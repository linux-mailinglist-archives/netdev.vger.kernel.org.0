Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD4A65BA8
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 18:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728574AbfGKQkC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 12:40:02 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:43479 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728409AbfGKQkB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 12:40:01 -0400
Received: by mail-pl1-f194.google.com with SMTP id cl9so3294706plb.10;
        Thu, 11 Jul 2019 09:40:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=KOT/1So1IFYA/aJw1dMOvXq1f7H5g9e04BW/pi2Jh8E=;
        b=Fa5gSGGs1Osr80BVmBQ6ocvBjusK81e57cIaTdSEVg9FJo5WgSWo9uvCeWoMPT/ZHo
         A9Q7l3+5NsabASmh/dDjkd4I/sFmnb29d+XtfFN6hbWUcdkIQ2nydraebuev0q5Svhpq
         tzy3oSTS1F4510MERzDWrETYO7yUvfcFDWV/Y3NalUMbLAQHHFiLYvqfN3tfaJfEtXXS
         1ztHTqRHfe1gVgUtPVg4RuB+V7+0v54YajGk46yic8yzieUG6+SyESWnyQc8ITaTHG90
         Ea5YYbIYa+L6pOfpvvC3WmKyoBLkoAA4PE07bTmTvrIeijflXVA0Akdz/eJBGt+xL4af
         b3cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=KOT/1So1IFYA/aJw1dMOvXq1f7H5g9e04BW/pi2Jh8E=;
        b=Qkkm2fV9uqkTPPsIUEnU1apzfXwsXG804VN6ZZS5gP+VtsAP/9Z0LAPtXz4OVzWzds
         mQO8I3uCzzumHAqoXeyhVAuVd8uyIko0scxQaNn5A1xRSzx7Acd5Jd2Hse9y+qAlZpiC
         PrZsTJEFCg9axGMVeEdUua98VFffUs93HjXKA7PQQBEvI5bzDHMl+XilxuAZs5pM81+l
         TYVgRBW5GAHUteqI2V4SwF+nTt40zAVoMGyBZ+sQ/RufatGNY/2y5/tjkS1ItC1JjtaN
         z4JbTmR7h5yJOvoRmm7zFVyUDgV75zh1Q1J2fA+mwYmZELYxKYaQ25ZFjIryGI6e9AhS
         8Wmg==
X-Gm-Message-State: APjAAAUFpT46Y4QDZc8utjO018rmHpC3s5pfD1jvOYjsoEGDaMK8vQNf
        iit3h4XJJh+ltFFbRJ/4kAU=
X-Google-Smtp-Source: APXvYqyetvxk6G2ETT3z/iLwMx1IwdmMdlkREjAcHgkBqVMfF5yBVm3p9C3gUMcpCwsHDYPkXuuTkQ==
X-Received: by 2002:a17:902:f213:: with SMTP id gn19mr5867853plb.35.1562863201082;
        Thu, 11 Jul 2019 09:40:01 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id 137sm7995206pfz.112.2019.07.11.09.39.58
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 11 Jul 2019 09:40:00 -0700 (PDT)
Date:   Thu, 11 Jul 2019 09:39:53 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        edumazet@google.com, bpf@vger.kernel.org
Message-ID: <5d276659122cc_698f2aaeaaf925bc3e@john-XPS-13-9370.notmuch>
In-Reply-To: <20190710123543.04846e00@cakuba.netronome.com>
References: <156261310104.31108.4569969631798277807.stgit@ubuntu3-kvm1>
 <156261331866.31108.6405316261950259075.stgit@ubuntu3-kvm1>
 <20190709193846.62f0a2c7@cakuba.netronome.com>
 <5d255ca6e5b0d_1b7a2aec940d65b4f6@john-XPS-13-9370.notmuch>
 <20190710123543.04846e00@cakuba.netronome.com>
Subject: Re: [bpf PATCH v2 6/6] bpf: sockmap/tls, close can race with map free
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski wrote:
> On Tue, 09 Jul 2019 20:33:58 -0700, John Fastabend wrote:
> > Jakub Kicinski wrote:
> > > On Mon, 08 Jul 2019 19:15:18 +0000, John Fastabend wrote:  
> > > > @@ -352,15 +354,18 @@ static void tls_sk_proto_close(struct sock *sk, long timeout)
> > > >  	if (ctx->tx_conf == TLS_BASE && ctx->rx_conf == TLS_BASE)
> > > >  		goto skip_tx_cleanup;
> > > >  
> > > > -	sk->sk_prot = ctx->sk_proto;
> > > >  	tls_sk_proto_cleanup(sk, ctx, timeo);
> > > >  
> > > >  skip_tx_cleanup:
> > > > +	write_lock_bh(&sk->sk_callback_lock);
> > > > +	icsk->icsk_ulp_data = NULL;  
> > > 
> > > Is ulp_data pointer now supposed to be updated under the
> > > sk_callback_lock?  
> > 
> > Yes otherwise it can race with tls_update(). I didn't remove the
> > ulp pointer null set from tcp_ulp.c though. Could be done in this
> > patch or as a follow up.
> 
> Do we need to hold the lock in unhash, too, or is unhash called with
> sk_callback_lock held?
> 

We should hold the lock here. Also we should reset sk_prot similar to
other paths in case we get here without a close() call. syzbot hasn't
found that path yet but I'll add some tests for it.

	write_lock_bh(...)
	icsk_ulp_data = NULL
	sk->sk_prot = ctx->sk_proto;
	write_unlock_bh(...)

Thanks
