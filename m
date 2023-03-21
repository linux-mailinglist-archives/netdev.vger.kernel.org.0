Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15B726C279D
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 02:50:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbjCUBu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 21:50:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbjCUBu2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 21:50:28 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 396051B2CE;
        Mon, 20 Mar 2023 18:50:27 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id b20so21121269edd.1;
        Mon, 20 Mar 2023 18:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679363425;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mFyddVK6wIUzaT3nDkTYwuRwcQJpRU74GgcNQU6SfT4=;
        b=Ea1Kcg1rWh1NkpTi3Uu3yLvD5hKcWEjGBFeF52JEAF61mOh1dZ01LdrX5fg1Oti+bh
         I9hJx1saairXronUFEwETrJdPRSaRSr5Yed6GgY0FdVqlYxyp2C+GDk23mv2rmlotZCN
         JKASgcBCApPxPat8xycbU1O5uGUuhu5hSchvCLtTm0CAMmLKLJeNO0NCIScVqzaYErlG
         JDBOxX7qPFCMLO1i9g5U8tSyGZbvDYh9kiqacSpu5igPA/lYkHb7EGLsljKAcy13crvE
         8h8nkuqhUJOXp9LjOc9XDQHZjAvdbsX02FbbtMWSs6/mPCBKGk4N5kvX7KrCkLyeM+yQ
         /4Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679363425;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mFyddVK6wIUzaT3nDkTYwuRwcQJpRU74GgcNQU6SfT4=;
        b=4BVqxUAnltIXw3xWNgXqzFu+wb400ADLKU4hMfxznEolJLqQCvral2P5qZb5IYT6Lb
         cV29bo1vFZ4Tz2dWPlPZiu38A9ABc1YhGolDHKvQoWdOqSvWMxsKkpAYwBTAWvBjeJNC
         aI8CN0lVOdSUUSUSFGgQmdX72rZwK4OeBdZhZMKUtOc7OLdWkw61vVLUzxAMXfcyqMjz
         CoDyo4O+ebaExZl+3iER8DaREs5IYxkXZoGWSgzppsdiVQsSkAXnHhzVvhWJnqduby0i
         pVkdgTYDhMLdcDQRV1h2qFhfiilTYzKi6VXdSAQZS9j2KO38aHYZIsFzIX//kk9Tvs4j
         yeIQ==
X-Gm-Message-State: AO0yUKUvaCtOdKOsA2U/OLzsObD7k3Q2m5/CjEg5TZdeZjk/5H1wNjO4
        7b4oD5MD6HSpF2UM9ifW0CPXk/+F8uCfPZkaL4Y=
X-Google-Smtp-Source: AK7set8VledEINbTim3mW2jpeDByRYMTGIU2yVBbD9U5mFLzTEBas4tDT/n0MtZh151NzJzLEhCM/VgUEp52tT3jJ30=
X-Received: by 2002:a17:907:2c46:b0:92f:cf96:e1f6 with SMTP id
 hf6-20020a1709072c4600b0092fcf96e1f6mr497578ejc.11.1679363425592; Mon, 20 Mar
 2023 18:50:25 -0700 (PDT)
MIME-Version: 1.0
References: <20230315092041.35482-1-kerneljasonxing@gmail.com>
 <20230315092041.35482-2-kerneljasonxing@gmail.com> <CAL+tcoCpgWUep+jAo--E2CGFp_AshZ+r89fGK_o7fOz9QqB8MA@mail.gmail.com>
 <20230320114026.021d9b3b@kernel.org>
In-Reply-To: <20230320114026.021d9b3b@kernel.org>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Tue, 21 Mar 2023 09:49:49 +0800
Message-ID: <CAL+tcoB=xH374+KeV3SvqRh+Xi=ZvbLkmGx_wsmNcV_m0e4wsw@mail.gmail.com>
Subject: Re: [PATCH v4 net-next 1/2] net-sysfs: display two backlog queue len separately
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     jbrouer@redhat.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com,
        stephen@networkplumber.org, simon.horman@corigine.com,
        sinquersw@gmail.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jason Xing <kernelxing@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 21, 2023 at 2:40=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> On Sun, 19 Mar 2023 11:05:57 +0800 Jason Xing wrote:
> > > Sometimes we need to know which one of backlog queue can be exactly
> > > long enough to cause some latency when debugging this part is needed.
> > > Thus, we can then separate the display of both.
> > >
> > > Signed-off-by: Jason Xing <kernelxing@tencent.com>
> > > Reviewed-by: Simon Horman <simon.horman@corigine.com>
> >
> > I just noticed that the state of this patch is "Changes Requested" in
> > the patchwork[1]. But I didn't see any feedback on this. Please let me
> > know if someone is available and provide more suggestions which are
> > appreciated.
> >
> > [1]: https://patchwork.kernel.org/project/netdevbpf/patch/2023031509204=
1.35482-2-kerneljasonxing@gmail.com/
>
> We work at a patch set granualrity, not at individual patches,
> so if there is feedback for any of the patches you need to repost.
> Even if it's just to drop the other patch from the series.

Well, I see. I'll drop the 2/2 patch and resend this one.

Thanks,
Jason
