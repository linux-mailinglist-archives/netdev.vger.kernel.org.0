Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20B9C4BBFF4
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 19:51:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234440AbiBRSwD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 13:52:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235131AbiBRSvz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 13:51:55 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2BB151336
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 10:51:37 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id v73so8937573ybe.12
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 10:51:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=64Hr5c+MUPH0UtYd4UTCS7fr7Nh+2ZrmXtm/tvR5t7Y=;
        b=PBtssgXv9m1BoS65xAlWeNHBZBxDv+bK53eCIYGouTr1l3kQbom7SwKhhDFvH4pq5M
         8rUGREP//MFBKFPb9TpLs3c8kvXdIVLDBjwUcrpZa4G8SQIBQwEpUegD+ej0iee2ftXY
         +5B0VVMRJ9hpmxejHtdFY/pFS8tnvQ+Rohd+aEFIH5YGkhP8LLE2eucvdTzqngquHkpW
         BTv69+eHoULBF3/uqiubsv1m42CZ84jEnzKISvZwJo6rbKuO7N1hVtWm4r7m1qK5L/UO
         Gq3lZG74M22EXNeEXMXMiFut5E4DlIRqURUUO0Yh8Fi0woXvGY6U7QdKupMUA0T/1SOs
         Aq+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=64Hr5c+MUPH0UtYd4UTCS7fr7Nh+2ZrmXtm/tvR5t7Y=;
        b=2J4HOHd3Z4d60cy3ht0ZbNZaRWdFJ7N1Sifcgq5/5xeKG7mOkb4/KQ6HVplXjKHYcR
         69DEbbO0gI6Q1YepQ5Wn9Y9cbVq4drp1icQxSG/kBqMAKCufkYV/dzXLI7zdwdGU4c9C
         LXpj5SMMlH+ChSQca/1BMSdUcheThfDBdIsuHgkW6tdY/cRR3iAzB/LC0R45lz46FRTy
         TJEx7bakZUxUHCAa1KhSdm7vQ1RabCvYMaIgXvXKPRG2Gcbq62Rnb2cCEYF+072G16+v
         VaTki7uEJxHL4hGVxQXpfFg0P5dVzpe/xPQBeJt0dhS/17noNi8Vv+84qFWmOrNqHVHE
         OMqw==
X-Gm-Message-State: AOAM531IrE7dJNjuipbhP63gi2a2SrJHQvfMkhBPfmGPIzQc72W5f9Z8
        Vk/xB62F7n0b9Jq+OlI+JY5sRvEgE96yzhOkUaVh7Q==
X-Google-Smtp-Source: ABdhPJzzv2So3wlSjld8rmD+iS8rbF8mOgwhZ0HfP4AcBs+107yRpT3mG6sh4adNx0Hk62hcCjqjHXmTqyqbgP7tInc=
X-Received: by 2002:a25:3b17:0:b0:619:4463:a400 with SMTP id
 i23-20020a253b17000000b006194463a400mr8730690yba.36.1645210296676; Fri, 18
 Feb 2022 10:51:36 -0800 (PST)
MIME-Version: 1.0
References: <20220218083133.18031-1-imagedong@tencent.com>
In-Reply-To: <20220218083133.18031-1-imagedong@tencent.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 18 Feb 2022 10:51:25 -0800
Message-ID: <CANn89i+ZPrA=ZQKR+y921_WxoqH91_LwRKnw7C2u-SgoAnhcxw@mail.gmail.com>
Subject: Re: [PATCH net-next v2 0/9] net: add skb drop reasons to TCP packet receive
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Menglong Dong <imagedong@tencent.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kees Cook <keescook@chromium.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Antoine Tenart <atenart@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Yajun Deng <yajun.deng@linux.dev>,
        Roopa Prabhu <roopa@nvidia.com>,
        Willem de Bruijn <willemb@google.com>,
        Vasily Averin <vvs@virtuozzo.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        flyingpeng@tencent.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 18, 2022 at 12:32 AM <menglong8.dong@gmail.com> wrote:
>
> From: Menglong Dong <imagedong@tencent.com>
>
> In the commit c504e5c2f964 ("net: skb: introduce kfree_skb_reason()"),
> we added the support of reporting the reasons of skb drops to kfree_skb
> tracepoint. And in this series patches, reasons for skb drops are added
> to TCP layer (both TCPv4 and TCPv6 are considered).
> Following functions are processed:
>

>
> /* SKB_DROP_REASON_TCP_MD5* corresponding to LINUX_MIB_TCPMD5* */
> SKB_DROP_REASON_TCP_MD5NOTFOUND
> SKB_DROP_REASON_TCP_MD5UNEXPECTED
> SKB_DROP_REASON_TCP_MD5FAILURE
> SKB_DROP_REASON_SOCKET_BACKLOG
> SKB_DROP_REASON_TCP_FLAGS
> SKB_DROP_REASON_TCP_ZEROWINDOW
> SKB_DROP_REASON_TCP_OLD_DATA
> SKB_DROP_REASON_TCP_OVERWINDOW
> /* corresponding to LINUX_MIB_TCPOFOMERGE */
> SKB_DROP_REASON_TCP_OFOMERGE
>

For the whole series:

Reviewed-by: Eric Dumazet <edumazet@google.com>

Thanks !
