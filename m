Return-Path: <netdev+bounces-8607-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AB413724BEF
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 20:57:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1A7AA1C20A98
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 18:57:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A63D22E40;
	Tue,  6 Jun 2023 18:57:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F321B125CC
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 18:57:15 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54E6595
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 11:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686077833;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=31JVF3l6gUDbROIl4YxBKRo91pCNMIATPATdnGp3EPo=;
	b=BDJVj1EqB6er3m8fNWPhD/XLFZ5GsBX2RWwFjx1efsXFYJzdeNyEpdJzCQdFBjftM01WDe
	dDChxGalTKuSVGZK4m9H8j5uOl3y4g4YHbYnOV0jbNSYdaQgIuRfFDEza+BRObnOexVbWV
	DWHKuZIV7KvUPjEf/xIV+4XA0D7Hs+I=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-489-YbEfcdVVMb6bEjzwEEu_Ow-1; Tue, 06 Jun 2023 14:57:12 -0400
X-MC-Unique: YbEfcdVVMb6bEjzwEEu_Ow-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3f7e7a6981cso9741105e9.1
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 11:57:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686077831; x=1688669831;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=31JVF3l6gUDbROIl4YxBKRo91pCNMIATPATdnGp3EPo=;
        b=XYZzEjpr9oaKJRp5dzpdBu2Ci5tyNpzpac/D9UZA9U0hA9CgxAhLG0/GHhQ/+VsA6s
         HQ1/PMj2RCD7grwNHzdMs1QgCkdaTfUE/LnJ9l5lVWoDMentpM5psBXZsmUbW14HVtoT
         lloLsFLydXeywU8HK6/fLhYyaccZlKUnMFU+Q/RYGvD3tFy+HDpTvJItniRI59bdCX/m
         X+p0W3iAxgl9zVtK74+BdBqGToe3hZKFT+UxxSY/WOMTQcUcSqme1V8ZekYLoAVESN19
         RR1iBCR5bjJ2Wr95fyziCm/K2ETim4+YsFl4ZMeSWgAf+ZAe/IxWQRnlObKSHNuBwaG7
         IX7Q==
X-Gm-Message-State: AC+VfDyzl6Byz6efEVDO/gQXsq9181A00wJ+oMrWYrN/5lf09F77K5OX
	TOOblI5vtd4JPE35gxdr+mnLhRndFz0cNhi3WgHdlIKZP1V9V4vxLBMvcnoNIQLEAC5Yy//Ed5D
	wbUJLqIxOkpAjC2iV
X-Received: by 2002:a7b:c858:0:b0:3f7:3991:e128 with SMTP id c24-20020a7bc858000000b003f73991e128mr2707040wml.2.1686077831251;
        Tue, 06 Jun 2023 11:57:11 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ61P0R8sqac5ijSKL835rH/AuF3V6x11y/N9t9GsB91bZ5m/eBP7wH0Dj0CykwQ9ZrpciOtVQ==
X-Received: by 2002:a7b:c858:0:b0:3f7:3991:e128 with SMTP id c24-20020a7bc858000000b003f73991e128mr2707034wml.2.1686077830994;
        Tue, 06 Jun 2023 11:57:10 -0700 (PDT)
Received: from debian (2a01cb058d652b00fa0f162c47a2f35b.ipv6.abo.wanadoo.fr. [2a01:cb05:8d65:2b00:fa0f:162c:47a2:f35b])
        by smtp.gmail.com with ESMTPSA id z19-20020a7bc7d3000000b003f7ead9be7fsm2685045wmk.38.2023.06.06.11.57.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 11:57:10 -0700 (PDT)
Date: Tue, 6 Jun 2023 20:57:08 +0200
From: Guillaume Nault <gnault@redhat.com>
To: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: POSSIBLE BUG: selftests/net/fcnal-test.sh: [FAIL][FIX TESTED] in
 vrf "bind - ns-B IPv6 LLA" test
Message-ID: <ZH+BhFzvJkWyjBE0@debian>
References: <b6191f90-ffca-dbca-7d06-88a9788def9c@alu.unizg.hr>
 <ZHeN3bg28pGFFjJN@debian>
 <a379796a-5cd6-caa7-d11d-5ffa7419b90e@alu.unizg.hr>
 <ZH84zGEODT97TEXG@debian>
 <48cfd903-ad2f-7da7-e5a6-a22392dc8650@alu.unizg.hr>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48cfd903-ad2f-7da7-e5a6-a22392dc8650@alu.unizg.hr>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 06, 2023 at 08:07:36PM +0200, Mirsad Goran Todorovac wrote:
> On 6/6/23 15:46, Guillaume Nault wrote:
> > diff --git a/net/ipv6/ping.c b/net/ipv6/ping.c
> > index c4835dbdfcff..f804c11e2146 100644
> > --- a/net/ipv6/ping.c
> > +++ b/net/ipv6/ping.c
> > @@ -114,7 +114,8 @@ static int ping_v6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
> >   	addr_type = ipv6_addr_type(daddr);
> >   	if ((__ipv6_addr_needs_scope_id(addr_type) && !oif) ||
> >   	    (addr_type & IPV6_ADDR_MAPPED) ||
> > -	    (oif && sk->sk_bound_dev_if && oif != sk->sk_bound_dev_if))
> > +	    (oif && sk->sk_bound_dev_if && oif != sk->sk_bound_dev_if &&
> > +	     l3mdev_master_ifindex_by_index(sock_net(sk), oif) != sk->sk_bound_dev_if))
> >   		return -EINVAL;
> >   	ipcm6_init_sk(&ipc6, np);
> 
> The problem appears to be fixed:
> 
> # ./fcnal-test.sh
> [...]
> TEST: ping out, vrf device+address bind - ns-B loopback IPv6                  [ OK ]
> TEST: ping out, vrf device+address bind - ns-B IPv6 LLA                       [ OK ]
> TEST: ping in - ns-A IPv6                                                     [ OK ]
> [...]
> Tests passed: 888
> Tests failed:   0
> #
> 
> The test passed in both environments that manifested the bug.
> 
> Tested-by: Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>

Thanks. I'll review and post this patch (probably tomorrow).

> However, test on my AMD Ubuntu 22.04 box with 6.4-rc5 commit a4d7d7011219
> has shown additional four failed tests:
> 
> root@host # grep -n FAIL ../fcnal-test-4.log
> 90:TEST: ping local, VRF bind - VRF IP                                           [FAIL]
> 92:TEST: ping local, device bind - ns-A IP                                       [FAIL]
> 116:TEST: ping local, VRF bind - VRF IP                                           [FAIL]
> 118:TEST: ping local, device bind - ns-A IP                                       [FAIL]
> root@host #
> 
> But you would probably want me to file a separate bug report?

Are these new failures? Do they also happen on the -net tree?

> Best regards,
> Mirsad
> 


