Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38CC54C46ED
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 14:54:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238658AbiBYNym (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 08:54:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238218AbiBYNyl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 08:54:41 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BD211D037C;
        Fri, 25 Feb 2022 05:54:09 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id p15so11016814ejc.7;
        Fri, 25 Feb 2022 05:54:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GnXiIUAMXWm01/l5EP1pdOFtRZ05tzZEPsUmh/hqPXY=;
        b=FXVEFaNBvLk+xO+tyPV/s1XlQ1Qi7cy/SXDWGg3LIEUgY0lV+xhDGZf6Dy99qr6zKO
         HR5ta4urj2SFhPi5B6wITXevgHb09uBnfdZbj/BgooTK7u9IXm/zkahhUn5UUB371Mr0
         fd71J1Ljj2jQe2iIcWhUKpQhbc8GTMikxkYeu0FlD89iOnRvPeNHpG4GXC6Z/InslSjt
         /kfQBbmEIBVQBpfKfeKYLPhA0y7qWy2TMgLOpuPDrua9T2KMjYKlGdrABh/XRUd4ZABo
         1aW5RdgcQGkL4vgAQRIqTvyac6a03zej203XQ6e2p2ePG6uK0UM7fonjp2Dv43dzFZjk
         mDVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GnXiIUAMXWm01/l5EP1pdOFtRZ05tzZEPsUmh/hqPXY=;
        b=M5QH/jID2uBuZsFqy4rp4U45YESDMe+T04A/jCP3kklfP5thYG9HOrVkYK5H4ehx7J
         6dLzQDZStp6DMzzYN4MDvOpbVyNG0rEL0Gw8YSeChqLyr3KcGUMXK+PxLnIBw/xRFp8Q
         RaqyXtzZEFYe1tB0DJ/yCZ7RMj0RejYlazHe/0EYrggNUu7H/54ij1/ALclfjVQzeDwe
         fHvKa7ugyZeTV3oBd/Pppoyk6hT9/0Pp0RYcPU7lsSc4lt/P4bH3EZaQNftIHNlyr2s2
         ufMNrC5269vF58Vkmzwa6MNEEIy6ut3aiBNjg4PtEl20b9LQ8wZCYQju4ZIfF9FgAun6
         Ij1Q==
X-Gm-Message-State: AOAM530uqnVq2s29d/sbKxhfrYvrepB1mEPNgS72veDKxTLUf7EIkOkd
        LqccSVhzoJ4rN2Ktfyty8zTy7zX4xIOLpyhaTjA=
X-Google-Smtp-Source: ABdhPJw+pjMyZZoTFs/p94a8eVH88apkn2kGxaUVjR04mbLLxrDHRuJZzPRjiEg+WUVkQRpWJEJAmMn0mMNo1q3GMBs=
X-Received: by 2002:a17:906:d49:b0:6b6:1f07:fb76 with SMTP id
 r9-20020a1709060d4900b006b61f07fb76mr6052873ejh.704.1645797248112; Fri, 25
 Feb 2022 05:54:08 -0800 (PST)
MIME-Version: 1.0
References: <20220220155705.194266-1-imagedong@tencent.com>
 <20220220155705.194266-2-imagedong@tencent.com> <3183c3c9-6644-b2de-885e-9e3699138102@kernel.org>
 <CADxym3apww2XEeTX=kU7gW5mbQ9STwVyQypK4Xbsmgid9s+2og@mail.gmail.com> <85v8x3xdvb.fsf@mojatatu.com>
In-Reply-To: <85v8x3xdvb.fsf@mojatatu.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Fri, 25 Feb 2022 21:53:56 +0800
Message-ID: <CADxym3Yuanr+ZKyAMu2yYD_Ld-=7GncatuhKFYpmc-Eq_QOB8g@mail.gmail.com>
Subject: Re: [PATCH net-next 1/3] net: ip: add skb drop reasons for ip egress path
To:     Roman Mashak <mrv@mojatatu.com>
Cc:     David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Menglong Dong <imagedong@tencent.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Cong Wang <cong.wang@bytedance.com>, paulb@nvidia.com,
        Talal Ahmad <talalahmad@google.com>,
        Kees Cook <keescook@chromium.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        flyingpeng@tencent.com, Mengen Sun <mengensun@tencent.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yajun Deng <yajun.deng@linux.dev>,
        Roopa Prabhu <roopa@nvidia.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 25, 2022 at 9:41 PM Roman Mashak <mrv@mojatatu.com> wrote:
>
> Menglong Dong <menglong8.dong@gmail.com> writes:
>
> > On Tue, Feb 22, 2022 at 11:13 AM David Ahern <dsahern@kernel.org> wrote:
> >>
> >> On 2/20/22 8:57 AM, menglong8.dong@gmail.com wrote:
> >> > From: Menglong Dong <imagedong@tencent.com>
> >> >
> >> > Replace kfree_skb() with kfree_skb_reason() in the packet egress path of
> >> > IP layer (both IPv4 and IPv6 are considered).
> >> >
> >> > Following functions are involved:
> >> >
> >> > __ip_queue_xmit()
> >> > ip_finish_output()
> >> > ip_mc_finish_output()
> >> > ip6_output()
> >> > ip6_finish_output()
> >> > ip6_finish_output2()
> >> >
> >> > Following new drop reasons are introduced:
> >> >
> >> > SKB_DROP_REASON_IP_OUTNOROUTES
> >> > SKB_DROP_REASON_BPF_CGROUP_EGRESS
> >> > SKB_DROP_REASON_IPV6DSIABLED
>
> Is this a typo and should be SKB_DROP_REASON_IPV6DISABLED ?

In fact......yeah, this is a typo :)
I'll fix it. Thanks!

>
> [...]
>
