Return-Path: <netdev+bounces-10638-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BE12172F831
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 10:47:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 78CD7281307
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 08:47:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6E301FCF;
	Wed, 14 Jun 2023 08:47:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5059369
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 08:47:23 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC1981BC6
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 01:47:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686732440;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zKa17mcJ3JZO5ohKJLfi/PuyyQC704/6NuVAqrSjVLw=;
	b=FwmACezJ80yQoojryPtWqNZ/pNc48Zudx9JF6hk4eDRRJViykV378IB+rPpreTmGrSXMRg
	caQbumgUw82roN2MBvc/7o8mPE6iq1VOyA+W4wD1KhayuiGeBotQwbl+W+NPVXr6wpo1Ao
	ctISFMLGKLlcsVNLxcz2BnMX22Sf14U=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-586-ctl6RBgrOIGsDZJK7FvzuA-1; Wed, 14 Jun 2023 04:47:19 -0400
X-MC-Unique: ctl6RBgrOIGsDZJK7FvzuA-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-3f7e7cfcae4so3569845e9.1
        for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 01:47:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686732438; x=1689324438;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zKa17mcJ3JZO5ohKJLfi/PuyyQC704/6NuVAqrSjVLw=;
        b=beK9357YD2bgLohEYP+pSiBE5ETnU7SPGzbMJ7Wxc+ttkImH51+189S+jYGYs0l9Tw
         1tpHvlJ7MTHUP9qz/HpwiETWsLbi74rIQVWXYvYQZpQg0MHF8rOooSzMvdGETzimtOWr
         PBtL0uefmXKCGtmcQ2GQ+hVMAr+03HFaE+FDGWa88c6GzQJzZTtCagjeTUVoVR6SyX8X
         vEiH5DP1nMS5nM2hBN7JwM6VXrAmtigHKhmg1ZS0l+VIY3OOClLjUd7a878SSJ3kI1Y1
         eW9Fp6flCXll8bLIeQOggaNRZfJHILpmzak+pTv30mhYWxnAW8F/ALJiwCVF8XcbxvO8
         QWSg==
X-Gm-Message-State: AC+VfDxUh0XbvmW/Xexbfg4hVkrsaAYxRkD+3kjx7YLz58N+qOEvGhSw
	/hsVmzzl7QQYBxzrt2yZgTqp9/x3PXM05HoZQMyo0/FMV4QuvA4ph7QMtuzUPWgYmBIiW68tXh+
	O4THHLIehBwgpzHli
X-Received: by 2002:a7b:c7c6:0:b0:3f7:dfdf:36ce with SMTP id z6-20020a7bc7c6000000b003f7dfdf36cemr11707245wmk.9.1686732438396;
        Wed, 14 Jun 2023 01:47:18 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6Z8YuuOGNs6Hj04dXo4iS3Q8t38rLYcTbaUG4CGkcr2jU5sVUgPGIIdof9BgkDzKPkajtuCg==
X-Received: by 2002:a7b:c7c6:0:b0:3f7:dfdf:36ce with SMTP id z6-20020a7bc7c6000000b003f7dfdf36cemr11707228wmk.9.1686732437995;
        Wed, 14 Jun 2023 01:47:17 -0700 (PDT)
Received: from debian (2a01cb058d652b0004dec95078ab8527.ipv6.abo.wanadoo.fr. [2a01:cb05:8d65:2b00:4de:c950:78ab:8527])
        by smtp.gmail.com with ESMTPSA id y10-20020a1c4b0a000000b003f5ffba9ae1sm16824117wma.24.2023.06.14.01.47.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 01:47:17 -0700 (PDT)
Date: Wed, 14 Jun 2023 10:47:15 +0200
From: Guillaume Nault <gnault@redhat.com>
To: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: POSSIBLE BUG: selftests/net/fcnal-test.sh: [FAIL][FIX TESTED] in
 vrf "bind - ns-B IPv6 LLA" test
Message-ID: <ZIl+k8zJ7A0vFKpB@debian>
References: <ZHeN3bg28pGFFjJN@debian>
 <a379796a-5cd6-caa7-d11d-5ffa7419b90e@alu.unizg.hr>
 <ZH84zGEODT97TEXG@debian>
 <48cfd903-ad2f-7da7-e5a6-a22392dc8650@alu.unizg.hr>
 <ZH+BhFzvJkWyjBE0@debian>
 <a3b2891d-d355-dacd-24ec-af9f8aacac57@alu.unizg.hr>
 <ZIC1r6IHOM5nr9QD@debian>
 <884d9eb7-0e8e-3e59-cf6d-2c6931da35ee@alu.unizg.hr>
 <ZINPuawVp2KKoCjS@debian>
 <a74fbb54-2594-fd37-c5fe-3a027d9a5ea3@alu.unizg.hr>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a74fbb54-2594-fd37-c5fe-3a027d9a5ea3@alu.unizg.hr>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, Jun 10, 2023 at 08:04:02PM +0200, Mirsad Goran Todorovac wrote:
> This also works on the Lenovo IdeaPad 3 Ubuntu 22.10 laptop, but on the AlmaLinux 8.8
> Lenovo desktop I have a problem:
> 
> [root@pc-mtodorov net]# grep FAIL ../fcnal-test-4.log
> TEST: ping local, VRF bind - ns-A IP                                          [FAIL]
> TEST: ping local, VRF bind - VRF IP                                           [FAIL]
> TEST: ping local, device bind - ns-A IP                                       [FAIL]
> TEST: ping local, VRF bind - ns-A IP                                          [FAIL]
> TEST: ping local, VRF bind - VRF IP                                           [FAIL]
> TEST: ping local, device bind - ns-A IP                                       [FAIL]
> [root@pc-mtodorov net]#
> 
> Kernel is the recent one:
> 
> [root@pc-mtodorov net]# uname -rms
> Linux 6.4.0-rc5-testnet-00003-g5b23878f7ed9 x86_64
> [root@pc-mtodorov net]#

Maybe a problem with the ping version used by the distribution.
You can try "./fcnal-test.sh -t ipv4_ping -p -v" to view the commands
run and make the script stop when there's a test failure (so that you
can see the ping output and try your own commands in the testing
environment).

> > > However, I have a question:
> > > 
> > > In the ping + "With VRF" section, the tests with net.ipv4.raw_l3mdev_accept=1
> > > are repeated twice, while "No VRF" section has the versions:
> > > 
> > > SYSCTL: net.ipv4.raw_l3mdev_accept=0
> > > 
> > > and
> > > 
> > > SYSCTL: net.ipv4.raw_l3mdev_accept=1
> > > 
> > > The same happens with the IPv6 ping tests.
> > > 
> > > In that case, it could be that we have only 2 actual FAIL cases,
> > > because the error is reported twice.
> > > 
> > > Is this intentional?
> > 
> > I don't know why the non-VRF tests are run once with raw_l3mdev_accept=0
> > and once with raw_l3mdev_accept=1. Unless I'm missing something, this
> > option shouldn't affect non-VRF users. Maybe the objective is to make
> > sure that it really doesn't affect them. David certainly knows better.
> 
> The problem appears to be that non-VRF tests are being ran with
> raw_l3mdev_accept={0|1}, while VRF tests w raw_l3mdev_accept={1|1} ...

The reason the VRF tests run twice is to test both raw and ping sockets
(using the "net.ipv4.ping_group_range" sysctl). It doesn't seem anyone
ever intended to run the VRF tests with raw_l3mdev_accept=0.

Only the non-VRF tests were intended to be tested with
raw_l3mdev_accept=0 (see commit c032dd8cc7e2 ("selftests: Add ipv4 ping
tests to fcnal-test")). But I have no idea why.

> I will try to fix that, but I am not sure of the semantics either.
> 
> Regards,
> Mirsad
> 


