Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E61C8C187
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 21:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726479AbfHMTa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 15:30:26 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:33465 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726313AbfHMTaZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 15:30:25 -0400
Received: by mail-ot1-f68.google.com with SMTP id q20so23848122otl.0;
        Tue, 13 Aug 2019 12:30:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=LkUkZZHHOpjUjyUqkx+tcRPy0nV/QGKvYnmWNcLuDl4=;
        b=f9ZIYlS5lQQ52mdpooEjRmTvYZAKY8ghh1EQk6/OQkmluIyHtKO3bRWmKNMq4SEmrk
         3S71XcA7F8B0+25/Aq9HBAcPzXB+1D1UPrN8Rp33Lx+thWM0T8Xn/sYjTVaEzn5dKBUW
         TDnZMHRInPOADY6TvSWFBIGlP2R+9Z3ShTXQdfJZPFRCmVVV0FQLOKPm2/XiMT7r+qZQ
         FUKBRle/vtx6o+R9X9l+CP1l61zyLm1QnlZIrhkDU0PSVvhIXruk5OWguyd0M38hyy2+
         WYTM645MfdAhX8l2xh7nXdRW87U4LdeifspoJDdnKIalB+NXzxwPP852htL1kEdMvFKG
         mWTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=LkUkZZHHOpjUjyUqkx+tcRPy0nV/QGKvYnmWNcLuDl4=;
        b=XqYybT/1nWtS7bS9ldutbhmNeYr3UnXvb6Ub6QJZJWUPI7lwuHc3IaaTfAMYXaV7B3
         8Kx3BHoMy7hJvgnouTMSEb1zDKHgLES9cPpGbZgex3QbMgDp5opOOaYq/dkdcW0cP5L8
         bz6YPFCabgnDfx0tjOg6XMT1X9YTEwNM8iroGEZKSf9SJkHaRp1BaJLghaC3CL9bcKtt
         mW2T63vieela2fiXZ15FIjOzU6r4+AoC5Gt4+Ie3wuIfkkefi+gpz1Zt1mTlbGFFzY5a
         cYLHWZSAOjaHpLRgMZgUfBftWlp+eebbzB/Oi3yTnDU0y3HqkNh0Ig1KvfH2dcnyeQEq
         HTBQ==
X-Gm-Message-State: APjAAAWxf2Y34WGX74EGPRs9m86ePpWLdBeSot6b07Sl4jY/pGcgE9LF
        XGKD1caTMrymPAhv5397AQs=
X-Google-Smtp-Source: APXvYqx1uZGEU/FWdg1qWuUCtfHp2p88R4pDcIZNEXpcKK8j+wiJV4izI9Z8HxKohjgmzX3tRSOAag==
X-Received: by 2002:a6b:fb10:: with SMTP id h16mr1126617iog.195.1565724624745;
        Tue, 13 Aug 2019 12:30:24 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id w17sm3247806ior.23.2019.08.13.12.30.22
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 13 Aug 2019 12:30:24 -0700 (PDT)
Date:   Tue, 13 Aug 2019 12:30:17 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Hillf Danton <hdanton@sina.com>,
        syzbot <syzbot+dcdc9deefaec44785f32@syzkaller.appspotmail.com>,
        aviadye@mellanox.com, borisp@mellanox.com, daniel@iogearbox.net,
        davejwatson@fb.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, syzkaller-bugs@googlegroups.com,
        willemb@google.com
Message-ID: <5d530fc91c07a_74d72b1d12a065b810@john-XPS-13-9370.notmuch>
In-Reply-To: <20190813115948.5f57b272@cakuba.netronome.com>
References: <000000000000f5d619058faea744@google.com>
 <20190810135900.2820-1-hdanton@sina.com>
 <5d52f09299e91_40c72adb748b25c0d3@john-XPS-13-9370.notmuch>
 <20190813102705.1f312b67@cakuba.netronome.com>
 <5d5301a82578_268d2b12c8efa5b470@john-XPS-13-9370.notmuch>
 <20190813115948.5f57b272@cakuba.netronome.com>
Subject: Re: general protection fault in tls_write_space
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski wrote:
> On Tue, 13 Aug 2019 11:30:00 -0700, John Fastabend wrote:
> > Jakub Kicinski wrote:
> > > On Tue, 13 Aug 2019 10:17:06 -0700, John Fastabend wrote:  
> > > > > Followup of commit 95fa145479fb
> > > > > ("bpf: sockmap/tls, close can race with map free")
> > > > > 
> > > > > --- a/net/tls/tls_main.c
> > > > > +++ b/net/tls/tls_main.c
> > > > > @@ -308,6 +308,9 @@ static void tls_sk_proto_close(struct so
> > > > >  	if (free_ctx)
> > > > >  		icsk->icsk_ulp_data = NULL;
> > > > >  	sk->sk_prot = ctx->sk_proto;
> > > > > +	/* tls will go; restore sock callback before enabling bh */
> > > > > +	if (sk->sk_write_space == tls_write_space)
> > > > > +		sk->sk_write_space = ctx->sk_write_space;
> > > > >  	write_unlock_bh(&sk->sk_callback_lock);
> > > > >  	release_sock(sk);
> > > > >  	if (ctx->tx_conf == TLS_SW)    
> > > > 
> > > > Hi Hillf,
> > > > 
> > > > We need this patch (although slightly updated for bpf tree) do
> > > > you want to send it? Otherwise I can. We should only set this if
> > > > TX path was enabled otherwise we null it. Checking against
> > > > tls_write_space seems best to me as well.
> > > > 
> > > > Against bpf this patch should fix it.
> > > > 
> > > > diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
> > > > index ce6ef56a65ef..43252a801c3f 100644
> > > > --- a/net/tls/tls_main.c
> > > > +++ b/net/tls/tls_main.c
> > > > @@ -308,7 +308,8 @@ static void tls_sk_proto_close(struct sock *sk, long timeout)
> > > >         if (free_ctx)
> > > >                 icsk->icsk_ulp_data = NULL;
> > > >         sk->sk_prot = ctx->sk_proto;
> > > > -       sk->sk_write_space = ctx->sk_write_space;
> > > > +       if (sk->sk_write_space == tls_write_space)
> > > > +               sk->sk_write_space = ctx->sk_write_space;
> > > >         write_unlock_bh(&sk->sk_callback_lock);
> > > >         release_sock(sk);
> > > >         if (ctx->tx_conf == TLS_SW)  
> > > 
> > > This is already in net since Friday:  
> > 
> > Don't we need to guard that with an
> > 
> >   if (sk->sk_write_space == tls_write_space)
> > 
> > or something similar? Where is ctx->sk_write_space set in the rx only
> > case? In do_tls_setsockop_conf() we have this block
> > 
> > 	if (tx) {
> > 		ctx->sk_write_space = sk->sk_write_space;
> > 		sk->sk_write_space = tls_write_space;
> > 	} else {
> > 		sk->sk_socket->ops = &tls_sw_proto_ops;
> > 	}
> > 
> > which makes me think ctx->sk_write_space may not be set correctly in
> > all cases.
> 
> Ah damn, you're right I remember looking at that but then I went down
> the rabbit hole of trying to repro and forgot :/
> 
> Do you want to send an incremental change?

Sure I'll send something out this afternoon.

