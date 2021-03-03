Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED96132C3FA
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:52:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354655AbhCDAJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:09:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1582445AbhCCKV5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 05:21:57 -0500
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFF0BC034621
        for <netdev@vger.kernel.org>; Wed,  3 Mar 2021 01:35:25 -0800 (PST)
Received: by mail-lj1-x229.google.com with SMTP id y12so14843572ljj.12
        for <netdev@vger.kernel.org>; Wed, 03 Mar 2021 01:35:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GEKsNPFt5uW+bAYL4neLUuqC5v5C91j6xhAwFtQ4lRc=;
        b=nPo5CmePDn0/ArVEDW37gxprx1SCAOIA8Dx8yHaCH7RtGD4/Wr26bY40lcNAvwrXdI
         +IUMJmVCJLVMndm6zz+XB+5aDe2hLGinJdM6DIhsFovKhunXSeAcDcHOqYcoFb4vtNTV
         vg/dAA47KCWS0r0GsKYk/53AUsAfqyuFt3KDE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GEKsNPFt5uW+bAYL4neLUuqC5v5C91j6xhAwFtQ4lRc=;
        b=uXQFPAODz/Rg3j1iJlvJAOMmcAq60AbRVWT4Hs0Vzo5Yw9V/rh1YsWkgjGn0ARaUwI
         XhhzKcHB1abTxcxCOaatd21PwTYRR1Varg40EaZrnxCOxXLQoEMSbQfMYxakGwhhAToq
         odUw4n36pFNoCjmI7S2T6j7S0L4XrKAp1mr4MHWilqNnMz45eUVRUFTNrpKUFPzkBPap
         gOdD48vGW9geP4kFTv28hwCdFgM9j/jK3q+ijICn6sJa2/oQ0fHHYA59cCqXMBpZHsWG
         ZwNm3fpw+6ShYCzScn+AK6pKTG4OanenDZHwxUT9hQlTK2wedyWYi563KKvLLyPR3A+U
         u2wQ==
X-Gm-Message-State: AOAM5325ZtBbFwQ/6Y5+uWdwmN/jE2del+kqp+jm4gm3YSmC2OQ6hMLl
        Qdsy+QlDr0SeHEYIAexFWO2wuNCkVUwkXTMpnAvQGKHQD1XOkQ==
X-Google-Smtp-Source: ABdhPJxX12DLFCNDWK1D3NDg/M9FChhkM1DPxBb4Jw2IveYs4lKzABCN01gR1vUX17clmbSsyqbaWnKIkZiyyN4h9po=
X-Received: by 2002:a2e:8114:: with SMTP id d20mr11874975ljg.83.1614764124333;
 Wed, 03 Mar 2021 01:35:24 -0800 (PST)
MIME-Version: 1.0
References: <20210302023743.24123-1-xiyou.wangcong@gmail.com>
 <20210302023743.24123-3-xiyou.wangcong@gmail.com> <CACAyw9-SjsNn4_J1KDXuFh1nd9Hr-Mo+=7S-kVtooJwdi1fodQ@mail.gmail.com>
 <CAM_iQpXqE9qJ=+zKA6H1Rq=KKgm8LZ=p=ZtvrrH+hfSrTg+zxw@mail.gmail.com>
In-Reply-To: <CAM_iQpXqE9qJ=+zKA6H1Rq=KKgm8LZ=p=ZtvrrH+hfSrTg+zxw@mail.gmail.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Wed, 3 Mar 2021 09:35:13 +0000
Message-ID: <CACAyw99BweMk-82f270=Vb=jDuec0q0N-6E8Rr8enaOGuZEDNQ@mail.gmail.com>
Subject: Re: [Patch bpf-next v2 2/9] sock: introduce sk_prot->update_proto()
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        duanxiongchun@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2 Mar 2021 at 18:23, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> > if the function returned a struct proto * like it does at the moment.
> > That way we keep sk->sk_prot manipulation confined to the sockmap code
> > and don't have to copy paste it into every proto.
>
> Well, TCP seems too special to do this, as it could call tcp_update_ulp()
> to update the proto.

I had a quick look, tcp_bpf_update_proto is the only caller of tcp_update_ulp,
which in turn is the only caller of icsk_ulp_ops->update, which in turn is only
implemented as tls_update in tls_main.c. Turns out that tls_update
has another one of these calls:

} else {
    /* Pairs with lockless read in sk_clone_lock(). */
    WRITE_ONCE(sk->sk_prot, p);
    sk->sk_write_space = write_space;
}

Maybe it looks familiar? :o) I think it would be a worthwhile change.

>
> >
> > > diff --git a/net/core/sock_map.c b/net/core/sock_map.c
> > > index 3bddd9dd2da2..13d2af5bb81c 100644
> > > --- a/net/core/sock_map.c
> > > +++ b/net/core/sock_map.c
> > > @@ -184,26 +184,10 @@ static void sock_map_unref(struct sock *sk, void *link_raw)
> > >
> > >  static int sock_map_init_proto(struct sock *sk, struct sk_psock *psock)
> > >  {
> > > -       struct proto *prot;
> > > -
> > > -       switch (sk->sk_type) {
> > > -       case SOCK_STREAM:
> > > -               prot = tcp_bpf_get_proto(sk, psock);
> > > -               break;
> > > -
> > > -       case SOCK_DGRAM:
> > > -               prot = udp_bpf_get_proto(sk, psock);
> > > -               break;
> > > -
> > > -       default:
> > > +       if (!sk->sk_prot->update_proto)
> > >                 return -EINVAL;
> > > -       }
> > > -
> > > -       if (IS_ERR(prot))
> > > -               return PTR_ERR(prot);
> > > -
> > > -       sk_psock_update_proto(sk, psock, prot);
> > > -       return 0;
> > > +       psock->saved_update_proto = sk->sk_prot->update_proto;
> > > +       return sk->sk_prot->update_proto(sk, false);
> >
> > I think reads / writes from sk_prot need READ_ONCE / WRITE_ONCE. We've
> > not been diligent about this so far, but I think it makes sense to be
> > careful in new code.
>
> Hmm, there are many places not using READ_ONCE/WRITE_ONCE,
> for a quick example:

I know! I'll defer to John and Jakub.

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
