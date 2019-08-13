Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAEE38C093
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 20:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728562AbfHMSaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 14:30:08 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:36846 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728433AbfHMSaH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 14:30:07 -0400
Received: by mail-ot1-f65.google.com with SMTP id k18so44168191otr.3;
        Tue, 13 Aug 2019 11:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=xYr3qwvR0G9d1flmc14vpOBBlilcrrIu468KDrr2XHQ=;
        b=QI5bK8/eet4TBpDuU0lZi/msYy53LqfP7K1xLN3L6OP/ASss2EGtHLRDczEOyapwTL
         +tUkiFfPYjViS/NC4as9wVkxGJPMD6+NauR7ra5L9/G8wsNTjfBJEPOTlkaEU/A+VoXi
         1cg/RH/hM8x1G35aqSIq0VurvcriiDDnxDFUR2VZb9DswJnEobz2lPxcX2RNl3AqTv75
         z8LFP6CjFhtknWJ/XUjspx6Sn3xHZ7ulHMhaPaaiSfso3Uwk3qSOJzy5AmO6TSmN7wAb
         6DXAefjUa4k26yCMiSOTQ0xTxxWSpZgyG3On3ePJhYWK97Vy7WwYjxidzeRq6JonNQ1X
         L3ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=xYr3qwvR0G9d1flmc14vpOBBlilcrrIu468KDrr2XHQ=;
        b=tLlQ2JfmXKLRM1BMwHVe6yjocuOwO+q9qYWCsOk6FNGrjzUdEoDwdqAOWUkB43SVXR
         Lmim8D1hgnMnaB9h7KD9XhQdI8mqDw9gN4iJ9bzkQYS+D/RVRjPp63lNXNDxUrEpGbzo
         zeNRJQtn9kRwYuiWKx5Qdo+ziGkPOeW/9tGHmUXO2CkRTfWjCtuL+eTDWH0ac/ZrHi19
         R1l7v0ZbwLYZdWne4yaIPCL2u13+8tnsgj+t15bJdWBG6mfoNlIG5soafp5GHSY2b4/S
         w8xbCRlzsHQEg2U944KMRDv/ljsZnw46n5pzB+kFN8lC/MfoY0lF9SSy/YfOXKS3y3fA
         ubAw==
X-Gm-Message-State: APjAAAWvT4GY9xCYOalmDjDrBownaGYtajh8/5KXQKAz087tHIQwxSX6
        jogTlBIP2GfOFnZoY8WiMoU=
X-Google-Smtp-Source: APXvYqxP/aFWNNueAjq4+kTAeWaefJRH8kwpW9GRpVXfKHy9xCCn3AurjdyUEzt4Jl+MAqnYPwsSlw==
X-Received: by 2002:a6b:6516:: with SMTP id z22mr40554668iob.7.1565721006799;
        Tue, 13 Aug 2019 11:30:06 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id p12sm2849404ioh.72.2019.08.13.11.30.05
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 13 Aug 2019 11:30:06 -0700 (PDT)
Date:   Tue, 13 Aug 2019 11:30:00 -0700
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
Message-ID: <5d5301a82578_268d2b12c8efa5b470@john-XPS-13-9370.notmuch>
In-Reply-To: <20190813102705.1f312b67@cakuba.netronome.com>
References: <000000000000f5d619058faea744@google.com>
 <20190810135900.2820-1-hdanton@sina.com>
 <5d52f09299e91_40c72adb748b25c0d3@john-XPS-13-9370.notmuch>
 <20190813102705.1f312b67@cakuba.netronome.com>
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
> On Tue, 13 Aug 2019 10:17:06 -0700, John Fastabend wrote:
> > > Followup of commit 95fa145479fb
> > > ("bpf: sockmap/tls, close can race with map free")
> > > 
> > > --- a/net/tls/tls_main.c
> > > +++ b/net/tls/tls_main.c
> > > @@ -308,6 +308,9 @@ static void tls_sk_proto_close(struct so
> > >  	if (free_ctx)
> > >  		icsk->icsk_ulp_data = NULL;
> > >  	sk->sk_prot = ctx->sk_proto;
> > > +	/* tls will go; restore sock callback before enabling bh */
> > > +	if (sk->sk_write_space == tls_write_space)
> > > +		sk->sk_write_space = ctx->sk_write_space;
> > >  	write_unlock_bh(&sk->sk_callback_lock);
> > >  	release_sock(sk);
> > >  	if (ctx->tx_conf == TLS_SW)  
> > 
> > Hi Hillf,
> > 
> > We need this patch (although slightly updated for bpf tree) do
> > you want to send it? Otherwise I can. We should only set this if
> > TX path was enabled otherwise we null it. Checking against
> > tls_write_space seems best to me as well.
> > 
> > Against bpf this patch should fix it.
> > 
> > diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
> > index ce6ef56a65ef..43252a801c3f 100644
> > --- a/net/tls/tls_main.c
> > +++ b/net/tls/tls_main.c
> > @@ -308,7 +308,8 @@ static void tls_sk_proto_close(struct sock *sk, long timeout)
> >         if (free_ctx)
> >                 icsk->icsk_ulp_data = NULL;
> >         sk->sk_prot = ctx->sk_proto;
> > -       sk->sk_write_space = ctx->sk_write_space;
> > +       if (sk->sk_write_space == tls_write_space)
> > +               sk->sk_write_space = ctx->sk_write_space;
> >         write_unlock_bh(&sk->sk_callback_lock);
> >         release_sock(sk);
> >         if (ctx->tx_conf == TLS_SW)
> 
> This is already in net since Friday:

Don't we need to guard that with an

  if (sk->sk_write_space == tls_write_space)

or something similar? Where is ctx->sk_write_space set in the rx only
case? In do_tls_setsockop_conf() we have this block

	if (tx) {
		ctx->sk_write_space = sk->sk_write_space;
		sk->sk_write_space = tls_write_space;
	} else {
		sk->sk_socket->ops = &tls_sw_proto_ops;
	}

which makes me think ctx->sk_write_space may not be set correctly in
all cases.

Thanks.

> 
> commit 57c722e932cfb82e9820bbaae1b1f7222ea97b52
> Author: Jakub Kicinski <jakub.kicinski@netronome.com>
> Date:   Fri Aug 9 18:36:23 2019 -0700
> 
>     net/tls: swap sk_write_space on close
>     
>     Now that we swap the original proto and clear the ULP pointer
>     on close we have to make sure no callback will try to access
>     the freed state. sk_write_space is not part of sk_prot, remember
>     to swap it.
>     
>     Reported-by: syzbot+dcdc9deefaec44785f32@syzkaller.appspotmail.com
>     Fixes: 95fa145479fb ("bpf: sockmap/tls, close can race with map free")
>     Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
>     Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
> index 9cbbae606ced..ce6ef56a65ef 100644
> --- a/net/tls/tls_main.c
> +++ b/net/tls/tls_main.c
> @@ -308,6 +308,7 @@ static void tls_sk_proto_close(struct sock *sk, long timeout)
>         if (free_ctx)
>                 icsk->icsk_ulp_data = NULL;
>         sk->sk_prot = ctx->sk_proto;
> +       sk->sk_write_space = ctx->sk_write_space;
>         write_unlock_bh(&sk->sk_callback_lock);
>         release_sock(sk);
>         if (ctx->tx_conf == TLS_SW)

