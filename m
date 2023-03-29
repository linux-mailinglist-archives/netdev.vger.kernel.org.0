Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92FF16CD049
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 04:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbjC2Cli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 22:41:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbjC2Clc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 22:41:32 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C80C210E4
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 19:41:15 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id h8so57555046ede.8
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 19:41:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680057673; x=1682649673;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n7z+jxD47MK5ugisO9r4norfloXQoxZKOItHy+2p45I=;
        b=iIPcaQrxGraZHE89geQkMarUZS8bOZ+oQatuWEEQJe81nEMVp+pug67gCiIL2YPvgO
         D7e+m6/wRmNX+EptBloY8NgbJT895s8pVGFaJM0oGuo3LGb00JfzABRucP1phEDWLRxW
         Bxxpn9kup0YCb+h3FnknerJl21k4brC39JNV2FgT21SC0NQJAwLE/VAAj1d5NXnwv8VX
         XXtYmYI+NsqijK9BhW0QVtQ75lzQnziiNKbykMqdZQOec9c6/IxBCrSnJsYvlLXWfcuF
         AnAx6tXUCvH/dHusIOPwByBzsm5YGXY3fY4GK/mqrDGdlO5KiIJPuSeZYMaSNkfKIyI/
         M+cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680057673; x=1682649673;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n7z+jxD47MK5ugisO9r4norfloXQoxZKOItHy+2p45I=;
        b=YQQkHMR9n8/Y5MDS9EzST7ZbE6e7+PoSK5ZMdZHICsn90lKNBuNcrg0nEDkYXlAuB1
         XuL4zlbqeSI2R6zC3hJqj/K0vlOFRt2oWBMlK5c/aCqQhGWUy6rg8jByXXo8vMRgYZ2Z
         Qrbjj3yH0HNUyTXOt2NJxxmxX0lsTghv8D8nrf2hAKKkZymM16ddkFQuLaKHA8cdtlaN
         Y6qFVpSbijA0ybUEYHt/Z2qiVKfNFTU881g0kHHUhWRfRsN/TD3mY8YMxUj3uGk2b593
         uOAyXF3Dh5Aj7qAssTbgtam6yom9sKxNLTgxNGQKQBdj0aoLD7cesfhdTYVOoWRjKFOj
         P6Ew==
X-Gm-Message-State: AAQBX9eVAWohF2AqGNadUaUXF9WYoiF1He3l/7Os4tLeEJlFulIDqQqz
        qP6DkjOaxh44QM2NYu6VmNefU0Ep7dZuRP1wPqA=
X-Google-Smtp-Source: AKy350ZdlOPJb4zrwE8JG5NtfjT/pYjI/1KizvqfeYZQtgtdZWcDFkiwP54MptGy65a1GWxiLzwu4MrWVTUKzuEobsQ=
X-Received: by 2002:a17:906:eda6:b0:8dd:70a:3a76 with SMTP id
 sa6-20020a170906eda600b008dd070a3a76mr9379325ejb.11.1680057673544; Tue, 28
 Mar 2023 19:41:13 -0700 (PDT)
MIME-Version: 1.0
References: <20230328235021.1048163-1-edumazet@google.com>
In-Reply-To: <20230328235021.1048163-1-edumazet@google.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Wed, 29 Mar 2023 10:40:37 +0800
Message-ID: <CAL+tcoDTQzCm0nh6oLB8w9+YPXeL2_Rk+bwBWECgUA_amMfwGw@mail.gmail.com>
Subject: Re: [PATCH net-next 0/4] net: rps/rfs improvements
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Xing <kernelxing@tencent.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 29, 2023 at 7:53=E2=80=AFAM Eric Dumazet <edumazet@google.com> =
wrote:
>
> Jason Xing attempted to optimize napi_schedule_rps() by avoiding
> unneeded NET_RX_SOFTIRQ raises: [1], [2]
>
> This is quite complex to implement properly. I chose to implement
> the idea, and added a similar optimization in ____napi_schedule()
>
[...]
> Overall, in an intensive RPC workload, with 32 TX/RX queues with RFS
> I was able to observe a ~10% reduction of NET_RX_SOFTIRQ
> invocations.
>
> While this had no impact on throughput or cpu costs on this synthetic
> benchmark, we know that firing NET_RX_SOFTIRQ from softirq handler
> can force __do_softirq() to wakeup ksoftirqd when need_resched() is true.
> This can have a latency impact on stressed hosts.

Eric, nice work ! You got these numbers.

Could you also put this whole important description above into the 3/4
patch? I believe it is very useful information if any
readers/developers try to track this part through git blame. After
all, I spent a lot of time discovering this point. Thanks.

Otherwise it looks good to me. Please add:
Reviewed-by: Jason Xing <kerneljasonxing@gmail.com>

And I've done tests on this patchset. Please also add:
Tested-by: Jason Xing <kerneljasonxing@gmail.com>

Thanks!

>
> [1] https://lore.kernel.org/lkml/20230325152417.5403-1-kerneljasonxing@gm=
ail.com/
> [2] https://lore.kernel.org/netdev/20230328142112.12493-1-kerneljasonxing=
@gmail.com/
>
>
> Eric Dumazet (4):
>   net: napi_schedule_rps() cleanup
>   net: add softnet_data.in_net_rx_action
>   net: optimize napi_schedule_rps()
>   net: optimize ____napi_schedule() to avoid extra NET_RX_SOFTIRQ
>
>  include/linux/netdevice.h |  1 +
>  net/core/dev.c            | 46 ++++++++++++++++++++++++++++++---------
>  2 files changed, 37 insertions(+), 10 deletions(-)
>
> --
> 2.40.0.348.gf938b09366-goog
>
