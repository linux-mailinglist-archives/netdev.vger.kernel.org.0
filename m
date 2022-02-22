Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0E64BF045
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 05:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234533AbiBVDuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 22:50:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbiBVDuK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 22:50:10 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A0F624BD7;
        Mon, 21 Feb 2022 19:49:45 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id bq11so12341569edb.2;
        Mon, 21 Feb 2022 19:49:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s2XSMVj1kILwt68WwMudYnmLz1ROeiH1LOdTavQMelo=;
        b=oOHR9c5Wf55GRsvLNqdswIBJpUBSrMPSg/Ou0HlmCVg3+8TmzRHE/UrAYQVyUZK4ia
         PeMeq+IddUMoWrYYqW1GFiJIZgOFcJSJJMwbWjxoPN8fMy1I/S/SVTyClbjCS0fkhPnv
         5H5NpizsrTuknRRRBNSbJOCf6CINwgYZ1QIUSM2ursPxRP8am7hs5E6Auv0iGbqDvA4F
         MOMkEDB8bLVO0QxqMPNixoLe/XA9AZiKakFXeZ+StN1UA5cJX5Ox6bnX8GFhTAc6aiIW
         quke8hAzfnMNzocvLbiDdJ0zgA4WRA2FYgQqPoj/jj13aXHbOV9FgbzXufxrUlxAV8UV
         k+lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s2XSMVj1kILwt68WwMudYnmLz1ROeiH1LOdTavQMelo=;
        b=IQyEqMNCBoTAJYr2ynr6SMzH1iC97sz+BgxnfPMyYyo2aQMmeAVUnk4YkSUBudc9T/
         28sZRRKnZpUdebLQ6aBL3xHmxQKsDy2OYCnVTaaauVPzCNLG3keZHe1Ca4FXpQbU6lJ3
         xiqUVZl5z5vW07kv/d7naSaeyhuJsCNIkmdoANfKiWB/xGjjMkOol8IIut+cQknxbzWR
         oFAFybGsT7WfgajD7Kur4kflJNsCOh9seR1gMz6tR7GYY5lYyM805Cp440mt6V18CIfd
         1odtFiMCV5P5EWa9JOH7FYO0hsYjnnEMxG+YXd9lTjVsbVxYheoJrnr1gXKMrbVAPrRU
         r04A==
X-Gm-Message-State: AOAM533o4x0yNH+US3WZlhvOfg3BQwvxfKvxPu/DT6c8QsuamQASRRKi
        0NoOHQwNGxeTnF1ApbNxXjPT47RlIUnk3jit0nE=
X-Google-Smtp-Source: ABdhPJxgnDvWvb2diDocMe2RJQoCH11Grw1/0dR5EAwDrSr/Bu+/DWHw7xgWPaYTAGyIegHH88P11WecFKe62GKOOTM=
X-Received: by 2002:a05:6402:17c8:b0:406:80a3:5cad with SMTP id
 s8-20020a05640217c800b0040680a35cadmr24039051edy.388.1645501783973; Mon, 21
 Feb 2022 19:49:43 -0800 (PST)
MIME-Version: 1.0
References: <20220220155705.194266-1-imagedong@tencent.com>
 <20220220155705.194266-2-imagedong@tencent.com> <3183c3c9-6644-b2de-885e-9e3699138102@kernel.org>
In-Reply-To: <3183c3c9-6644-b2de-885e-9e3699138102@kernel.org>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Tue, 22 Feb 2022 11:44:24 +0800
Message-ID: <CADxym3aMn_h_x0HYopDRu8y_sgRii+=myFtVr8iAYYxJuT2_JA@mail.gmail.com>
Subject: Re: [PATCH net-next 1/3] net: ip: add skb drop reasons for ip egress path
To:     David Ahern <dsahern@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
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

On Tue, Feb 22, 2022 at 11:13 AM David Ahern <dsahern@kernel.org> wrote:
>
> On 2/20/22 8:57 AM, menglong8.dong@gmail.com wrote:
> > From: Menglong Dong <imagedong@tencent.com>
> >
> > Replace kfree_skb() with kfree_skb_reason() in the packet egress path of
> > IP layer (both IPv4 and IPv6 are considered).
> >
> > Following functions are involved:
> >
> > __ip_queue_xmit()
> > ip_finish_output()
> > ip_mc_finish_output()
> > ip6_output()
> > ip6_finish_output()
> > ip6_finish_output2()
> >
> > Following new drop reasons are introduced:
> >
> > SKB_DROP_REASON_IP_OUTNOROUTES
> > SKB_DROP_REASON_BPF_CGROUP_EGRESS
> > SKB_DROP_REASON_IPV6DSIABLED
> >
> > Reviewed-by: Mengen Sun <mengensun@tencent.com>
> > Reviewed-by: Hao Peng <flyingpeng@tencent.com>
> > Signed-off-by: Menglong Dong <imagedong@tencent.com>
> > ---
> >  include/linux/skbuff.h     | 13 +++++++++++++
> >  include/trace/events/skb.h |  4 ++++
> >  net/ipv4/ip_output.c       |  6 +++---
> >  net/ipv6/ip6_output.c      |  6 +++---
> >  4 files changed, 23 insertions(+), 6 deletions(-)
> >
> > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > index a3e90efe6586..c310a4a8fc86 100644
> > --- a/include/linux/skbuff.h
> > +++ b/include/linux/skbuff.h
> > @@ -380,6 +380,19 @@ enum skb_drop_reason {
> >                                        * the ofo queue, corresponding to
> >                                        * LINUX_MIB_TCPOFOMERGE
> >                                        */
> > +     SKB_DROP_REASON_IP_OUTNOROUTES, /* route lookup failed during
> > +                                      * packet outputting
> > +                                      */
>
> This should be good enough since the name contains OUT.
>
> /* route lookup failed */
>
> > +     SKB_DROP_REASON_BPF_CGROUP_EGRESS,      /* dropped by eBPF program
> > +                                              * with type of BPF_PROG_TYPE_CGROUP_SKB
> > +                                              * and attach type of
> > +                                              * BPF_CGROUP_INET_EGRESS
> > +                                              * during packet sending
> > +                                              */
>
> /* dropped by BPF_CGROUP_INET_EGRESS eBPF program */
>
> > +     SKB_DROP_REASON_IPV6DSIABLED,   /* IPv6 is disabled on the device,
> > +                                      * see the doc for disable_ipv6
> > +                                      * in ip-sysctl.rst for detail
> > +                                      */
>
> Just /* IPv6 is disabled on the device */
>
>
> >       SKB_DROP_REASON_MAX,
> >  };
> >
>
> > diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
> > index 0c0574eb5f5b..df549b7415fb 100644
> > --- a/net/ipv4/ip_output.c
> > +++ b/net/ipv4/ip_output.c
>
> This file has other relevant drops. e.g., ip_finish_output2 when a neigh
> entry can not be created and after skb_gso_segment. The other set for
> tun/tap devices has SKB_DROP_REASON_SKB_GSO_SEG which can be used for
> the latter. That set also adds kfree_skb_list_reason for the frag drops.
>

I tried to add a drop reason for neigh creating fail, but I found it's hard
to find the root reason, as __neigh_create() can fail in many cases.
And I'm not sure if there is any help when we get a
'SKB_DROP_REASON_NEIGH_CREATEFAIL' message.

Seems it's hard to make every drop reason accurate, is it ok if we
use the name 'SKB_DROP_REASON_NEIGH_CREATEFAIL' for
this path?

>
> > diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
> > index 0c6c971ce0a5..4cd9e5fd25e4 100644
> > --- a/net/ipv6/ip6_output.c
> > +++ b/net/ipv6/ip6_output.c
>
> Similarly here. The other set should land in the next few days, so you
> cna put this set on top of it.

Yeah, I can make use of it.

>
