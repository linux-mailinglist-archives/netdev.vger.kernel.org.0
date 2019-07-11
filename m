Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 869A165B9A
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 18:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728325AbfGKQfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 12:35:44 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:38667 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726213AbfGKQfo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 12:35:44 -0400
Received: by mail-pl1-f194.google.com with SMTP id az7so3306483plb.5;
        Thu, 11 Jul 2019 09:35:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=YBqG9gCkqUUFAchyuwWcht3NDQxJF/qNbfrZoS76VLA=;
        b=KQVPhldPMgmsPjvMN632xtT4H77DmgalQUcQWVxqhEICVRhKWdsxt0GiOFy5FePKAd
         E8GzJp6j/ek9yugGodI2iKgTlwhRKESwNuWzi0WibzaQuNXhH1c92+jk8hKewz54jFXP
         Wr7sf6g5ZaEG4qTGtP1uwDoulNBYpfn5uxEQKFNxdkPyqCmYidl/cVjef2GLBE2bL1Ny
         jetF6smCJm4tY7Cw85i4qvDv/sIvFp8cdQ2FeoAhR0pcqvb0ia57HFMPPq1E8VrlF9pP
         fYNI8FoP0ZZ3Fqa11DDEjAgTKDxMUEXLbdIaDheiExI3ET3NmVDEZ3g89VOZK0yF66kI
         pCmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=YBqG9gCkqUUFAchyuwWcht3NDQxJF/qNbfrZoS76VLA=;
        b=HEBh/utmSMixrTuQHcETeR6cgKsdEzC6GGQK1urUw8gzr9VG26Udr3D+Ibjw69lS66
         obK1LzCJa5SCldTjalw61XvmsFbX8SSe/Q4hia3wwb5P7FSVoN1GmAH5VzG2U3XzzkK2
         or4f3veay43PP3qa70OuEA0sPbX06KT6jviMBfttK6Eza+HWRdUvN9K2ZShIFbpktGMb
         00y9Svnwi53n2ppzipgf+Kbdc+zWYWSMvpb1hUc5Vmyoy4aangCUX88ncPJL92SpHcDG
         +bMX08Z8mlmLq3SOObPt3vRBwQCwAJpvzk14gXGSvhw/NWkY+jjqfGvQB0561fvN7K43
         8P/g==
X-Gm-Message-State: APjAAAW0BERyEPwHDiw83cEVQydTARwScx+uZN+04TbWngBvckybCjTh
        BhuMkgB4Fu2Thq8noM9ua3c=
X-Google-Smtp-Source: APXvYqwBiVITXHOJNkNEbl6yFGGnU+hsw+io8o+ksnQqUmRtQQPb629IdKDD6GIF2HrT+D+AdT2FHA==
X-Received: by 2002:a17:902:7088:: with SMTP id z8mr5732256plk.125.1562862943524;
        Thu, 11 Jul 2019 09:35:43 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id r15sm6998971pfh.121.2019.07.11.09.35.41
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 11 Jul 2019 09:35:42 -0700 (PDT)
Date:   Thu, 11 Jul 2019 09:35:36 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        edumazet@google.com, bpf@vger.kernel.org
Message-ID: <5d2765584f043_698f2aaeaaf925bcb0@john-XPS-13-9370.notmuch>
In-Reply-To: <20190710123417.2157a459@cakuba.netronome.com>
References: <156261310104.31108.4569969631798277807.stgit@ubuntu3-kvm1>
 <156261324561.31108.14410711674221391677.stgit@ubuntu3-kvm1>
 <20190709194525.0d4c15a6@cakuba.netronome.com>
 <5d255dececd33_1b7a2aec940d65b45@john-XPS-13-9370.notmuch>
 <20190710123417.2157a459@cakuba.netronome.com>
Subject: Re: [bpf PATCH v2 2/6] bpf: tls fix transition through disconnect
 with close
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski wrote:
> On Tue, 09 Jul 2019 20:39:24 -0700, John Fastabend wrote:
> > Jakub Kicinski wrote:
> > > On Mon, 08 Jul 2019 19:14:05 +0000, John Fastabend wrote:  
> > > > @@ -287,6 +313,27 @@ static void tls_sk_proto_cleanup(struct sock *sk,
> > > >  #endif
> > > >  }
> > > >  
> > > > +static void tls_sk_proto_unhash(struct sock *sk)
> > > > +{
> > > > +	struct inet_connection_sock *icsk = inet_csk(sk);
> > > > +	long timeo = sock_sndtimeo(sk, 0);
> > > > +	struct tls_context *ctx;
> > > > +
> > > > +	if (unlikely(!icsk->icsk_ulp_data)) {  
> > > 
> > > Is this for when sockmap is stacked on top of TLS and TLS got removed
> > > without letting sockmap know?  
> > 
> > Right its a pattern I used on the sockmap side and put here. But
> > I dropped the patch to let sockmap stack on top of TLS because
> > it was more than a fix IMO. We could probably drop this check on
> > the other hand its harmless.
> 
> I feel like this code is pretty complex I struggle to follow all the
> paths, so perhaps it'd be better to drop stuff that's not necessary 
> to have a clearer picture.
> 

Sure I can drop it and add it later when its necessary.

> > > > +		if (sk->sk_prot->unhash)
> > > > +			sk->sk_prot->unhash(sk);
> > > > +	}
> > > > +
> > > > +	ctx = tls_get_ctx(sk);
> > > > +	if (ctx->tx_conf == TLS_SW || ctx->rx_conf == TLS_SW)
> > > > +		tls_sk_proto_cleanup(sk, ctx, timeo);
> > > > +	icsk->icsk_ulp_data = NULL;  
> > > 
> > > I think close only starts checking if ctx is NULL in patch 6.
> > > Looks like some chunks of ctx checking/clearing got spread to
> > > patch 1 and some to patch 6.  
> > 
> > Yeah, I thought the patches were easier to read this way but
> > maybe not. Could add something in the commit log.
> 
> Ack! Let me try to get a full grip of patches 2 and 6 and come back 
> to this.
> 
> > > > +	tls_ctx_free_wq(ctx);
> > > > +
> > > > +	if (ctx->unhash)
> > > > +		ctx->unhash(sk);
> > > > +}
> > > > +
> > > >  static void tls_sk_proto_close(struct sock *sk, long timeout)
> > > >  {
> > > >  	struct tls_context *ctx = tls_get_ctx(sk);  
