Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5A3831C408
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 23:27:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbhBOW02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 17:26:28 -0500
Received: from mail-pl1-f179.google.com ([209.85.214.179]:41341 "EHLO
        mail-pl1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbhBOW0X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 17:26:23 -0500
Received: by mail-pl1-f179.google.com with SMTP id a9so2325103plh.8;
        Mon, 15 Feb 2021 14:26:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4x4wk/MBWrGeQ2PmR10uKthvK2Y8pOz+y6BP6rAOGKU=;
        b=kgjYel/WjPXF83sB7MIvfWOmDC5crV/gmNVO6tIBoVRZesJFEQcV2qe1NUyTIMX0ml
         Mo78XZ8tTBrK0Le5AAm0N3bvaPDfdzdsUdlYLxnMCnCtumzjGlMQpCL3uKhVJFZNHDsb
         1Np+MmTIrpK8Z+qj2DbuxJMpGplD7fJ/oQu9kR7jUv0AEy5Pfy/11bArUXtpswKWG/qC
         7skhAP0IgnOT3d94MJ9uH3AuijM1P1gVjudaqu4pnRyjFDmj3CXVpYKc2MggCLk+B5py
         9AYkpvbEtIel6/v/YNi+rcl0VsthDL5fp0Fn9kTf6Uug/1Xf+V2bX5KPs/LSHtepiecZ
         Gshg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4x4wk/MBWrGeQ2PmR10uKthvK2Y8pOz+y6BP6rAOGKU=;
        b=ZhRY58A4bLfR/2dkBSIbJZJDYhqxkfKxJKZgJMB1dCl6CuOeMMpakQjZ5qrS/Imfq9
         565NESg8oo5lIed0JxZzK3C2DbkcHLukeFQCZn00BWHwalypipTSuQ1fuydk6pw792zp
         NEY7LZriwwkEa4EHrQQMXJAjnbmS6c60iPr8aiP2TlRmJwvwaiiW6UgIJ52/9SjtWrma
         FsR8/xyktdGpdBuFnj/d/tC9uBGbIPrtC3I4gaV6SgHIravaMmvKP2UeX3OjYjkyXBKV
         qxpARPocm1kzaDGYZ87D1lynoAtGT25HII5wEs/zr7G6dQJnXECN4b7whkows8T3LRCK
         x95A==
X-Gm-Message-State: AOAM533NXJvXSsdZe/+PxM9Ke9TkNM13nP8K6fd5b0dEvoIGXi5iUmKz
        2oL/5Xb8rsajXM37spR1w6Nd85s8SF8R9sj7z5c=
X-Google-Smtp-Source: ABdhPJyiWJX/n25kE5t0xfm9mtAmN4FiBfJUFrhNPaF/uAFS06T2/wk9naBy/RM5r6RZfSbbdXpJB496WsMvvCzlWBA=
X-Received: by 2002:a17:902:c155:b029:e3:7396:ec41 with SMTP id
 21-20020a170902c155b02900e37396ec41mr478540plj.10.1613427882492; Mon, 15 Feb
 2021 14:24:42 -0800 (PST)
MIME-Version: 1.0
References: <20210213214421.226357-1-xiyou.wangcong@gmail.com>
 <20210213214421.226357-5-xiyou.wangcong@gmail.com> <602ac96f9e30f_3ed41208b6@john-XPS-13-9370.notmuch>
In-Reply-To: <602ac96f9e30f_3ed41208b6@john-XPS-13-9370.notmuch>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 15 Feb 2021 14:24:30 -0800
Message-ID: <CAM_iQpWufy-YnQnBf_kk_otLaTikK8YxkhgjHh_eiu8MA=0Raw@mail.gmail.com>
Subject: Re: [Patch bpf-next v3 4/5] skmsg: use skb ext instead of TCP_SKB_CB
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, duanxiongchun@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        jiang.wang@bytedance.com, Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 15, 2021 at 11:20 AM John Fastabend
<john.fastabend@gmail.com> wrote:
>
> Cong Wang wrote:
> > From: Cong Wang <cong.wang@bytedance.com>
> >
> > Currently TCP_SKB_CB() is hard-coded in skmsg code, it certainly
> > does not work for any other non-TCP protocols. We can move them to
> > skb ext instead of playing with skb cb, which is harder to make
> > correct.
> >
> > Cc: John Fastabend <john.fastabend@gmail.com>
> > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > Reviewed-by: Lorenz Bauer <lmb@cloudflare.com>
> > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > ---
>
> I'm not seeing the advantage of doing this at the moment. We can
> continue to use cb[] here, which is simpler IMO and use the ext
> if needed for the other use cases. This is adding a per packet
> alloc cost that we don't have at the moment as I understand it.

Hmm? How can we continue using TCP_SKB_CB() for UDP or
AF_UNIX?

I am not sure I get your "at the moment" correctly, do you mean
I should move this patch to a later patchset, maybe the UDP
patchset? At least this patch is needed, no matter by which patchset,
so it should not be dropped.


>
> [...]
>
> > diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
> > index e3bb712af257..d5c711ef6d4b 100644
> > --- a/include/linux/skmsg.h
> > +++ b/include/linux/skmsg.h
> > @@ -459,4 +459,44 @@ static inline bool sk_psock_strp_enabled(struct sk_psock *psock)
> >               return false;
> >       return !!psock->saved_data_ready;
> >  }
> > +
> > +struct skb_bpf_ext {
> > +     __u32 flags;
> > +     struct sock *sk_redir;
> > +};
> > +
> > +#if IS_ENABLED(CONFIG_NET_SOCK_MSG)
> > +static inline
> > +bool skb_bpf_ext_ingress(const struct sk_buff *skb)
> > +{
> > +     struct skb_bpf_ext *ext = skb_ext_find(skb, SKB_EXT_BPF);
> > +
> > +     return ext->flags & BPF_F_INGRESS;
> > +}
> > +
> > +static inline
> > +void skb_bpf_ext_set_ingress(const struct sk_buff *skb)
> > +{
> > +     struct skb_bpf_ext *ext = skb_ext_find(skb, SKB_EXT_BPF);
> > +
> > +     ext->flags |= BPF_F_INGRESS;
> > +}
> > +
> > +static inline
> > +struct sock *skb_bpf_ext_redirect_fetch(struct sk_buff *skb)
> > +{
> > +     struct skb_bpf_ext *ext = skb_ext_find(skb, SKB_EXT_BPF);
> > +
> > +     return ext->sk_redir;
> > +}
> > +
> > +static inline
> > +void skb_bpf_ext_redirect_clear(struct sk_buff *skb)
> > +{
> > +     struct skb_bpf_ext *ext = skb_ext_find(skb, SKB_EXT_BPF);
> > +
> > +     ext->flags = 0;
> > +     ext->sk_redir = NULL;
> > +}
> > +#endif /* CONFIG_NET_SOCK_MSG */
>
> So we will have some slight duplication for cb[] variant and ext
> variant above. I'm OK with that to avoid an allocation.

Not sure what you mean by "duplication", these are removed from
TCP_SKB_CB(), so there is clearly no duplication.

>
> [...]
>
> > @@ -1003,11 +1008,17 @@ static int sk_psock_verdict_recv(read_descriptor_t *desc, struct sk_buff *skb,
> >               goto out;
> >       }
> >       skb_set_owner_r(skb, sk);
> > +     if (!skb_ext_add(skb, SKB_EXT_BPF)) {
> > +             len = 0;
> > +             kfree_skb(skb);
> > +             goto out;
> > +     }
> > +
>
> per packet cost here. Perhaps you can argue small alloc will usually not be
> noticable in such a large stack, but once we convert over it will be very
> hard to go back. And I'm looking at optimizing this path now.

This is a price we need to pay to avoid CB, and skb_ext_add() has been
used on other fast paths too, for example, tcf_classify_ingress() and
mptcp_incoming_options(). So, it is definitely acceptable.

>
> >       prog = READ_ONCE(psock->progs.skb_verdict);
> >       if (likely(prog)) {
> > -             tcp_skb_bpf_redirect_clear(skb);
> > +             skb_bpf_ext_redirect_clear(skb);
> >               ret = sk_psock_bpf_run(psock, prog, skb);
> > -             ret = sk_psock_map_verd(ret, tcp_skb_bpf_redirect_fetch(skb));
> > +             ret = sk_psock_map_verd(ret, skb_bpf_ext_redirect_fetch(skb));
> >       }
> >       sk_psock_verdict_apply(psock, skb, ret);
>
> Thanks for the series Cong. Drop this patch and resubmit carry ACKs forward
> and then lets revisit this later.

I still believe it is best to stay in this patchset, as it does not change
any functionality and is a preparation too. And the next patchset will be
UDP/AF_UNIX changes as you suggested, it is very awkward to put this
patch into either UDP or AF_UNIX changes.

So, let's keep it in this patchset, and I am happy to address any concerns
and open to other ideas than using skb ext.

Thanks.
