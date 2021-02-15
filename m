Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3921B31C478
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 00:59:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbhBOX62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 18:58:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbhBOX60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 18:58:26 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83E4EC061574;
        Mon, 15 Feb 2021 15:57:46 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id s24so8453633iob.6;
        Mon, 15 Feb 2021 15:57:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=R/PQ2BiKH3vp4I8STUHQalZT+sxKBgOr2W58JFoF2W8=;
        b=nPx8HuFxwfKdOKwTOtUQtbQj4b2fy0HTkzO+15Dju217d4hVnCFeYvO/qLIKXL3Mu/
         dYQ4EJhy1QdNhPWovTUXs42g0JyQo9jkKX7NrjnNhedzxTNSC2r5KdWNyj6vxQp4W21Q
         Od10WuNzZ9VwaoBQZbtVFWe7p2Bz4MOxFuXsdWY7klBuxppI3JqVgvh6x3SbXceV806C
         4aMJA1h/HC4QLndDWJlkpIMsrh03ABw6mPTEM1cbZ/1vix23vApj8pdMv4eiKmxqoYXS
         FPqbJ9jvIgiq6UJqzEsu92JDxJVEYqNnXvEQiYaZqhsRhRhTXagdR7nqVGfMywyWJgnI
         wQRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=R/PQ2BiKH3vp4I8STUHQalZT+sxKBgOr2W58JFoF2W8=;
        b=dUds4G0g0h6m/D84hIwlYo5JaArjFw+8+YWvMQQvU8fXTuScnXW/G1dB2IIr1JYzu4
         WiZIyVrXxv21+33atw3RTVXQCfshOPNZ72gDaECmoIyOrPtxi79er2dRtTmywF1keLGZ
         ukhZDoHm3LNs2pwWpbJbOJ3XXrejKKbym3jxxJeM1DTlRs5qHhuD+LPmOL7SveunO1Gu
         Gkw8nCCVg3PiXXA2krspr8T0I9x+SVCyW0zapAHN7fGNWnNI67M1KLBWdBgo3rZ23gDH
         PYaYEEbZ0iS8FlMFt0Ck+HkJsxdVtpJm24Sdg+4wfAZWa6QgpELgj9L9J74SqEmFlFR0
         ml5A==
X-Gm-Message-State: AOAM5319i0MaqWD4oP6cVy5G/71CH6h6e90E4VdkZja5I6aAKI4EzFgv
        7iBVXGMjjlTlXrCABUz1Lto=
X-Google-Smtp-Source: ABdhPJwl7LXM4FjqWKKf+287uBRy6Jm1KcqjdmV+aSwZTgaRF50XCS7WCajE8i3Vx6Q9sD0fv6WjAA==
X-Received: by 2002:a02:394d:: with SMTP id w13mr17551858jae.46.1613433465555;
        Mon, 15 Feb 2021 15:57:45 -0800 (PST)
Received: from localhost ([172.243.146.206])
        by smtp.gmail.com with ESMTPSA id x12sm10130715ilg.83.2021.02.15.15.57.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Feb 2021 15:57:44 -0800 (PST)
Date:   Mon, 15 Feb 2021 15:57:36 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, duanxiongchun@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        jiang.wang@bytedance.com, Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Message-ID: <602b0a7046969_3ed41208dc@john-XPS-13-9370.notmuch>
In-Reply-To: <CAM_iQpWufy-YnQnBf_kk_otLaTikK8YxkhgjHh_eiu8MA=0Raw@mail.gmail.com>
References: <20210213214421.226357-1-xiyou.wangcong@gmail.com>
 <20210213214421.226357-5-xiyou.wangcong@gmail.com>
 <602ac96f9e30f_3ed41208b6@john-XPS-13-9370.notmuch>
 <CAM_iQpWufy-YnQnBf_kk_otLaTikK8YxkhgjHh_eiu8MA=0Raw@mail.gmail.com>
Subject: Re: [Patch bpf-next v3 4/5] skmsg: use skb ext instead of TCP_SKB_CB
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> On Mon, Feb 15, 2021 at 11:20 AM John Fastabend
> <john.fastabend@gmail.com> wrote:
> >
> > Cong Wang wrote:
> > > From: Cong Wang <cong.wang@bytedance.com>
> > >
> > > Currently TCP_SKB_CB() is hard-coded in skmsg code, it certainly
> > > does not work for any other non-TCP protocols. We can move them to
> > > skb ext instead of playing with skb cb, which is harder to make
> > > correct.
> > >
> > > Cc: John Fastabend <john.fastabend@gmail.com>
> > > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > > Reviewed-by: Lorenz Bauer <lmb@cloudflare.com>
> > > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > > ---
> >
> > I'm not seeing the advantage of doing this at the moment. We can
> > continue to use cb[] here, which is simpler IMO and use the ext
> > if needed for the other use cases. This is adding a per packet
> > alloc cost that we don't have at the moment as I understand it.
> 
> Hmm? How can we continue using TCP_SKB_CB() for UDP or
> AF_UNIX?
> 
> I am not sure I get your "at the moment" correctly, do you mean
> I should move this patch to a later patchset, maybe the UDP
> patchset? At least this patch is needed, no matter by which patchset,
> so it should not be dropped.

Agree, the skb_bpf_ext{} pieces are needed for UDP and AF_UNIX. Its
not required for TCP side though. What I'm suggesting is leave the
TCP side as-is, using the cb[] fields. Then use the skb_bpf_ext fields
from UDP and AF_UNIX.

> 
> 
> >
> > [...]
> >
> > > diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
> > > index e3bb712af257..d5c711ef6d4b 100644
> > > --- a/include/linux/skmsg.h
> > > +++ b/include/linux/skmsg.h
> > > @@ -459,4 +459,44 @@ static inline bool sk_psock_strp_enabled(struct sk_psock *psock)
> > >               return false;
> > >       return !!psock->saved_data_ready;
> > >  }
> > > +
> > > +struct skb_bpf_ext {
> > > +     __u32 flags;
> > > +     struct sock *sk_redir;
> > > +};
> > > +
> > > +#if IS_ENABLED(CONFIG_NET_SOCK_MSG)
> > > +static inline
> > > +bool skb_bpf_ext_ingress(const struct sk_buff *skb)
> > > +{
> > > +     struct skb_bpf_ext *ext = skb_ext_find(skb, SKB_EXT_BPF);
> > > +
> > > +     return ext->flags & BPF_F_INGRESS;
> > > +}
> > > +
> > > +static inline
> > > +void skb_bpf_ext_set_ingress(const struct sk_buff *skb)
> > > +{
> > > +     struct skb_bpf_ext *ext = skb_ext_find(skb, SKB_EXT_BPF);
> > > +
> > > +     ext->flags |= BPF_F_INGRESS;
> > > +}
> > > +
> > > +static inline
> > > +struct sock *skb_bpf_ext_redirect_fetch(struct sk_buff *skb)
> > > +{
> > > +     struct skb_bpf_ext *ext = skb_ext_find(skb, SKB_EXT_BPF);
> > > +
> > > +     return ext->sk_redir;
> > > +}
> > > +
> > > +static inline
> > > +void skb_bpf_ext_redirect_clear(struct sk_buff *skb)
> > > +{
> > > +     struct skb_bpf_ext *ext = skb_ext_find(skb, SKB_EXT_BPF);
> > > +
 > > +     ext->flags = 0;
> > > +     ext->sk_redir = NULL;
> > > +}
> > > +#endif /* CONFIG_NET_SOCK_MSG */
> >
> > So we will have some slight duplication for cb[] variant and ext
> > variant above. I'm OK with that to avoid an allocation.
> 
> Not sure what you mean by "duplication", these are removed from
> TCP_SKB_CB(), so there is clearly no duplication.

In this patch yes, no duplication.  But, I want to leave TCP alone
and have it continue to use cb[] to avoid alloc per packet.

> 
> >
> > [...]
> >
> > > @@ -1003,11 +1008,17 @@ static int sk_psock_verdict_recv(read_descriptor_t *desc, struct sk_buff *skb,
> > >               goto out;
> > >       }
> > >       skb_set_owner_r(skb, sk);
> > > +     if (!skb_ext_add(skb, SKB_EXT_BPF)) {
> > > +             len = 0;
> > > +             kfree_skb(skb);
> > > +             goto out;
> > > +     }
> > > +
> >
> > per packet cost here. Perhaps you can argue small alloc will usually not be
> > noticable in such a large stack, but once we convert over it will be very
> > hard to go back. And I'm looking at optimizing this path now.
> 
> This is a price we need to pay to avoid CB, and skb_ext_add() has been
> used on other fast paths too, for example, tcf_classify_ingress() and
> mptcp_incoming_options(). So, it is definitely acceptable.

For TCP case we can continue to use CB and not pay the price. For UDP
and AF_UNIX we can do the extra alloc.

The use in tcf_classify_ingress is a miss case so not the common path. If
it is/was in the common path I would suggest we rip it out.

> 
> >
> > >       prog = READ_ONCE(psock->progs.skb_verdict);
> > >       if (likely(prog)) {
> > > -             tcp_skb_bpf_redirect_clear(skb);
> > > +             skb_bpf_ext_redirect_clear(skb);
> > >               ret = sk_psock_bpf_run(psock, prog, skb);
> > > -             ret = sk_psock_map_verd(ret, tcp_skb_bpf_redirect_fetch(skb));
> > > +             ret = sk_psock_map_verd(ret, skb_bpf_ext_redirect_fetch(skb));
> > >       }
> > >       sk_psock_verdict_apply(psock, skb, ret);
> >
> > Thanks for the series Cong. Drop this patch and resubmit carry ACKs forward
> > and then lets revisit this later.
> 
> I still believe it is best to stay in this patchset, as it does not change
> any functionality and is a preparation too. And the next patchset will be
> UDP/AF_UNIX changes as you suggested, it is very awkward to put this
> patch into either UDP or AF_UNIX changes.

Disagree. It adds extra code to the TCP side that I think is not needed. Any
reason the TCP implementation can't continue to use cb[]?

> 
> So, let's keep it in this patchset, and I am happy to address any concerns
> and open to other ideas than using skb ext.

The idea here is to just use cb[] in TCP case per above. I only scanned your
other patches, but presumably this can be patch 1 with just the functions

 skb_bpf_ext_ingress()
 skb_bpf_ext_set_ingress()
 skb_bpf_ext_redirect_fetch()
 skb_bpf_ext_redirect_clear()

And none of the removals from TCP side.

.John
