Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1382A42C6D5
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 18:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233970AbhJMQzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 12:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbhJMQzo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 12:55:44 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28DC8C061570;
        Wed, 13 Oct 2021 09:53:41 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id h196so473286iof.2;
        Wed, 13 Oct 2021 09:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=t96vbX3huzx6jPidOA6aLXhrzDmeVKciuyCpLr8pu/E=;
        b=Fvlrz37VJKNwpkYFxCLDG42DjhXygi+0ns9+zCBhhiZ5vdAYHXCWYViU84ALnR+d6U
         5vyKsetH/el7fH0eVZzqjbj5rCnOkb8dQQQR1ku+fMnnj2+RfwYk5OWcuvhLjJKsoVF/
         k5HTecUnZ02vtERrKpzPHBpUNwUTwxnAp2N8GsRMnSjCHwFdTlQ53NlrYvq+A2NCL4tp
         xNImtyPpzo2UDZeeO2iQwHzb/5NolWY2RgSyM41NkLxvDAC4rdPISZtVwiQHBeuKzKhX
         7/Wgo1h31bKGxn/r1PFNckM2Mmqu2SDa2tgMUs5KuLYqm5VBRvswktNOituTjjYq6JYs
         Cvtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=t96vbX3huzx6jPidOA6aLXhrzDmeVKciuyCpLr8pu/E=;
        b=FMbRnQ8C7KwsM2Moh3egxZ2yeo6/phqpuPk5oKe5x4xVngUf11xiDmYBqdrcFbijD9
         pYzr/gk4AC2r1H8sjfZ6a2SiHD9fbbWJWGqLP/XaU8moNeQdt6Rt1kFKtJjzxOl3Jfvg
         F2oMTFO/C2E+Q2IWVwOuxSBzz2qGkdy6eayabIRmdxEC1vR7d4mP9OMEh82wDQc3G977
         ghVu2LHfpTvpzI3ZpZAESPhA04+9xTR7cdz6j1MLVkQpaOXSNCL+KY8XqGjeEjF4N86U
         QxVegSaL1MOsVyUrxXVi1RsXhvf43dJ3vGsIcXu4R89istzfirdSQR9mmiTE220A9P3a
         fVAA==
X-Gm-Message-State: AOAM533cASeBPqD5bR6sSeGt5t30/WCJo385PLFladQrdAa/9YshWinP
        rDL52ots6Xo4ZV9UnH7i8u0=
X-Google-Smtp-Source: ABdhPJxE9jORA5yiVvDplzxjRKj4wzu9TSBWNZkb1Uh1adZ1ENFWUmtDhcivTgjsbOHfvAIwH/i/pw==
X-Received: by 2002:a02:9a14:: with SMTP id b20mr333174jal.83.1634144020540;
        Wed, 13 Oct 2021 09:53:40 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id l12sm24803ilo.60.2021.10.13.09.53.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 09:53:40 -0700 (PDT)
Date:   Wed, 13 Oct 2021 09:53:32 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Message-ID: <61670f0cdb0dd_4d1c0208ee@john-XPS-13-9370.notmuch>
In-Reply-To: <CAM_iQpU11gHXS416D9KjTd5CoEGyhNT3kkejUMhymoOmnGUrcw@mail.gmail.com>
References: <20211007195147.28462-1-xiyou.wangcong@gmail.com>
 <6166e806d00ea_48c5d208be@john-XPS-13-9370.notmuch>
 <CAM_iQpU11gHXS416D9KjTd5CoEGyhNT3kkejUMhymoOmnGUrcw@mail.gmail.com>
Subject: Re: [Patch bpf v3] skmsg: check sk_rcvbuf limit before queuing to
 ingress_skb
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> On Wed, Oct 13, 2021 at 7:07 AM John Fastabend <john.fastabend@gmail.com> wrote:
> >
> > Cong Wang wrote:
> > > From: Cong Wang <cong.wang@bytedance.com>
> > >
> > > Jiang observed OOM frequently when testing our AF_UNIX/UDP
> > > proxy. This is due to the fact that we do not actually limit
> > > the socket memory before queueing skb to ingress_skb. We
> > > charge the skb memory later when handling the psock backlog,
> > > and it is not limited either.

[...]

> > > diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> > > index e8b48df73c85..8b243fcdbb8f 100644
> > > --- a/net/ipv4/tcp.c
> > > +++ b/net/ipv4/tcp.c
> > > @@ -1665,6 +1665,8 @@ int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
> > >                       if (used <= 0) {
> > >                               if (!copied)
> > >                                       copied = used;
> > > +                             if (used == -EAGAIN)
> > > +                                     continue;
> >
> > This is not a good idea, looping through read_sock because we have
> > hit a memory limit is not going to work. If something is holding the
> > memlimit pinned this could loop indefinately.
> >
> > Also this will run the verdict multiple times on the same bytes. For
> > apply/cork logic this will break plus just basic parsers will be
> > confused when they see duplicate bytes.
> 
> Good point! I run out of ideas for dealing with this TCP case,
> dropping is not okay, retrying is hard, reworking TCP ACKing
> is even harder. :-/

I think it can be done with a retry queue in skmsg side. I'll give
it a try today/tomorrow.

> 
> >
> > We need to do a workqueue and then retry later.
> >
> > Final missing piece is that strparser logic would still not handle
> > this correctly.
> >
> > I don't mind spending some time on this today. I'll apply your
> > patch and then add a few fixes for above.
> 
> Ideally, we should move TCP ACK after ->sk_data_ready()
> so that dropping in ->sk_data_ready() would be fine, but this is
> certainly not easy even if it is doable.

iirc the original hook did this but there was concern from TCP
maintainers. So we decided to put hooks on top of TCP vs inside
TCP. Its also helpful for TLS hooks.

> 
> Thanks.
