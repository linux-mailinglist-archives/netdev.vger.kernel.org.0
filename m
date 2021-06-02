Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82603397F98
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 05:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbhFBDlb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 23:41:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbhFBDla (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 23:41:30 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F675C061574;
        Tue,  1 Jun 2021 20:39:47 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id r4so1036370iol.6;
        Tue, 01 Jun 2021 20:39:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=Ky3B8DwaaLwtu1BzJ+lvGvXYskHVLpWoa3hnGNfCdz8=;
        b=mqJnerbBbS5zYuCpt7hm5StZv2aP4UDbaIDln33KCTZHq4rmjwbAlrjy9iEoIrLtl9
         PIywHllYRWEbLJsifhgegsliS2HxRjBE+Ak74F+CqkHdCaoUkvCCw+bX/1Q7sh2yWh/4
         lHQWs/VF1RuqugXjtNvkq61HIMqLiN6hpBJGsEO1yBoCe01s6LuQLWVsvxBxAAS45Rpv
         huNhIjnHvchFoSSsE/t1k8gCD8yznNBERooNz7vCzrISvX1clRCyod7rFcfPhp0l0hrc
         NQEUPV/cTkcSI7aMEJxARqVL9se2HOZeLKuGlBSc7BPJiULdGNB5hxE5VZtZmtKklpbU
         J2VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=Ky3B8DwaaLwtu1BzJ+lvGvXYskHVLpWoa3hnGNfCdz8=;
        b=et7KPhPDlD2J9+2b7d2nI+5AeXe2kX54fCgU7bnv+4fXBoeqLx5GFL+Rnf+bR4e01A
         UQ9S/H7W9uTkE6hQBYZufzSH/f++dFDsiiwPIdtnDQPoPn2XFKm0jnCzAHKCcwZiUxQh
         jOLRKhDDcDXbBZ0UYroFIe6MaJoiDfMN2FmN5nEo0geThHnyV/j2n0d0Z3ak9aC2/SsJ
         1wsFuDdP5yIuSt9IBpd//o4lceu6nIvV2EvmOTFvPyPBB8nWiVBZOWh0l3p7QVsoZsSr
         fdsinJ1dRxEtFtzDSUsS1Hr30y8hQB9tIWCe+uZjaUGQBRHUa6ErQlHaCrLP9KyIRhQY
         pZGA==
X-Gm-Message-State: AOAM530i6FSgydbYXNGbGiKE77GCxD4YZxRQyD2+fW3baDS8XFuyptpw
        t/nAg3QFrthS/ZhrTm3lOZE=
X-Google-Smtp-Source: ABdhPJz+22nUAqsxhZJGmxfNqr5zUERUccK1LxJBCUbyzdOnDvDUTx8sMi7dsoWllVbU3oJBO1NM2A==
X-Received: by 2002:a02:c04c:: with SMTP id u12mr28210762jam.129.1622605186571;
        Tue, 01 Jun 2021 20:39:46 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id p18sm4391987ilg.32.2021.06.01.20.39.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 20:39:45 -0700 (PDT)
Date:   Tue, 01 Jun 2021 20:39:38 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Message-ID: <60b6fd7ace348_38d6d208eb@john-XPS-13-9370.notmuch>
In-Reply-To: <CAM_iQpU0evVG6_M33ZAgirRsTAJzZcMMN-cYfxqHepbC0UN0iQ@mail.gmail.com>
References: <20210527011155.10097-1-xiyou.wangcong@gmail.com>
 <20210527011155.10097-9-xiyou.wangcong@gmail.com>
 <60b07f49377b6_1cf82088d@john-XPS-13-9370.notmuch>
 <CAM_iQpU0evVG6_M33ZAgirRsTAJzZcMMN-cYfxqHepbC0UN0iQ@mail.gmail.com>
Subject: Re: [Patch bpf v3 8/8] skmsg: increase sk->sk_drops when dropping
 packets
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> On Thu, May 27, 2021 at 10:27 PM John Fastabend
> <john.fastabend@gmail.com> wrote:
> >
> > Cong Wang wrote:
> > > From: Cong Wang <cong.wang@bytedance.com>
> > >
> > > It is hard to observe packet drops without increasing relevant
> > > drop counters, here we should increase sk->sk_drops which is
> > > a protocol-independent counter. Fortunately psock is always
> > > associated with a struct sock, we can just use psock->sk.
> > >
> > > Suggested-by: John Fastabend <john.fastabend@gmail.com>
> > > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > > Cc: Lorenz Bauer <lmb@cloudflare.com>
> > > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > > ---
> > >  net/core/skmsg.c | 22 ++++++++++++++--------
> > >  1 file changed, 14 insertions(+), 8 deletions(-)
> > >
> >
> > [...]
> >
> > > @@ -942,7 +948,7 @@ static int sk_psock_verdict_apply(struct sk_psock *psock, struct sk_buff *skb,
> > >       case __SK_DROP:
> > >       default:
> > >  out_free:
> > > -             kfree_skb(skb);
> > > +             sock_drop(psock->sk, skb);
> >
> > I must have missed this on first review.
> >
> > Why should we mark a packet we intentionally drop as sk_drops? I think
> > we should leave it as just kfree_skb() this way sk_drops is just
> > the error cases and if users want this counter they can always add
> > it to the bpf prog itself.
> 
> This is actually a mixed case of error and non-error drops,
> because bpf_sk_redirect_map() could return SK_DROP
> in error cases. And of course users could want to drop packets
> in whatever cases.
> 
> But if you look at packet filter cases, for example UDP one,
> it increases drop counters too when user-defined rules drop
> them:
> 
> 2182         if (sk_filter_trim_cap(sk, skb, sizeof(struct udphdr)))
> 2183                 goto drop;
> 2184
> ...
> 2192 drop:
> 2193         __UDP_INC_STATS(sock_net(sk), UDP_MIB_INERRORS, is_udplite);
> 2194         atomic_inc(&sk->sk_drops);
> 2195         kfree_skb(skb);
> 2196         return -1;
> 
> 
> Thanks.

OK same for TCP side for sk_filter_trim_cap() case. Works for me.
