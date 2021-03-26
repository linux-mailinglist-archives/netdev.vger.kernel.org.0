Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DDCA349E49
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 01:58:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbhCZA6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 20:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbhCZA5c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 20:57:32 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD361C06174A;
        Thu, 25 Mar 2021 17:57:31 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id c17so3728299ilj.7;
        Thu, 25 Mar 2021 17:57:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=pZNtOJMqbtIMmId2/BNBtP0ZSDMbESecmLNGXdPCQ3E=;
        b=G+MCt2wpe57aauecOht2eHEWOBdbdQKIAh8aI5FbpxclHeJgvyyii2aaF3xXxFaimn
         F8N7/dfeoAYz0+ZBJIQ7NhI5M72KMUVYSkpMUqOji0mlYRaTIIrAaevDm1iHGSF3AKMI
         bDdVccKEXwsAEm3LzyqzJ//JBwlq8VbwlSnPMX2H8ePXN/YJlQIIJm2GEDJoi5BylUgh
         xpY4z79Faknfh37/uQ+d0ClEcyUF0qeyNrbtfkWac6vPXEVE5sG3GWuTmZHRw/qmwi+B
         Q3pTcUQF9WjOOigq9jHWAo03EVm5uwJxuTTBeu6/eXgQuxsMooN6IiH+5PQ0aRuE/Wg7
         /hXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=pZNtOJMqbtIMmId2/BNBtP0ZSDMbESecmLNGXdPCQ3E=;
        b=kphN82fKNLTmgsr8vF7p2eeDotdLtYh5C+vpnuw/lxNfAEJ2vJg95lg7RFHm9KrW6k
         akgqg7LgpgpU1qznsRKcm3x4I8C2RltGROYOWnzj8KsiSELJ04Pl/fokozoDKh37sF8g
         7DCfLHxnWM8X4g+f5a7Qom+unv3yICCt7VnI8ZI+Hzd4mVoQbXw+Qm8OWaP8uwVsWFcZ
         jpXwbBkuB4LtziSbRijQMbvWgj1lYtwpKbOtmzIV0r6Yox+/HhpSZD978en6F+KAgCuI
         qeSJVKtQFbrRioPb8BLs7l7pkzqszw2YzANarhIP4zyFGbo0Q+fQ6eZslNLC4tOhQvqm
         /CSg==
X-Gm-Message-State: AOAM532H9cbt6NDvIl3COe4q9h1o0K6DJJMtlC66oSj+oG2kc1GZ/Gv/
        m5ZawUMWjcKU7vg58bVzbQ4=
X-Google-Smtp-Source: ABdhPJwIpUHtzgCPceD75li33pskL4U1jdHtWKGH770vRbPMUuCOy1/D8UwUgE+DGHpno37zlfmxwQ==
X-Received: by 2002:a05:6e02:104f:: with SMTP id p15mr8662523ilj.20.1616720251327;
        Thu, 25 Mar 2021 17:57:31 -0700 (PDT)
Received: from localhost ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id v12sm774302ilm.42.2021.03.25.17.57.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 17:57:30 -0700 (PDT)
Date:   Thu, 25 Mar 2021 17:57:22 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@fb.com>, bpf <bpf@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Lorenz Bauer <lmb@cloudflare.com>
Message-ID: <605d3172bc50d_938e520870@john-XPS-13-9370.notmuch>
In-Reply-To: <CAM_iQpUdOkbs5MPcfTqNcPV3f0EXU7CQhuV9y2UDrOZ4SawvvA@mail.gmail.com>
References: <161661943080.28508.5809575518293376322.stgit@john-Precision-5820-Tower>
 <161661956953.28508.2297266338306692603.stgit@john-Precision-5820-Tower>
 <CAM_iQpUNUE8cmyNaALG1dZtCfJGah2pggDNk-eVbyxexnA4o_g@mail.gmail.com>
 <605bf553d16f_64fde2081@john-XPS-13-9370.notmuch>
 <CAM_iQpUdOkbs5MPcfTqNcPV3f0EXU7CQhuV9y2UDrOZ4SawvvA@mail.gmail.com>
Subject: Re: [bpf PATCH 1/2] bpf, sockmap: fix sk->prot unhash op reset
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> On Wed, Mar 24, 2021 at 7:28 PM John Fastabend <john.fastabend@gmail.com> wrote:
> >
> > Cong Wang wrote:
> > > On Wed, Mar 24, 2021 at 1:59 PM John Fastabend <john.fastabend@gmail.com> wrote:
> > > > diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
> > > > index 47b7c5334c34..ecb5634b4c4a 100644
> > > > --- a/net/tls/tls_main.c
> > > > +++ b/net/tls/tls_main.c
> > > > @@ -754,6 +754,12 @@ static void tls_update(struct sock *sk, struct proto *p,
> > > >
> > > >         ctx = tls_get_ctx(sk);
> > > >         if (likely(ctx)) {
> > > > +               /* TLS does not have an unhash proto in SW cases, but we need
> > > > +                * to ensure we stop using the sock_map unhash routine because
> > > > +                * the associated psock is being removed. So use the original
> > > > +                * unhash handler.
> > > > +                */
> > > > +               WRITE_ONCE(sk->sk_prot->unhash, p->unhash);
> > > >                 ctx->sk_write_space = write_space;
> > > >                 ctx->sk_proto = p;
> > >
> > > It looks awkward to update sk->sk_proto inside tls_update(),
> > > at least when ctx!=NULL.
> >
> > hmm. It doesn't strike me as paticularly awkward but OK.
> 
> I read tls_update() as "updating ctx when it is initialized", with your
> patch, we are updating sk->sk_prot->unhash too when updating ctx,
> pretty much like a piggyback, hence it reads odd to me.
> 
> Thanks.


OK convinced.
