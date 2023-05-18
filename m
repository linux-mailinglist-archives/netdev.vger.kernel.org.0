Return-Path: <netdev+bounces-3513-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 63D07707A56
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 08:47:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2F9341C21040
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 06:47:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 292742A9C9;
	Thu, 18 May 2023 06:47:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CDD07E
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 06:47:40 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4F952D73
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 23:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684392457;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZN6Ju1FP4FeoecC0E5LNzhZjtVHQZME+r88V+E/OwK4=;
	b=eU4aFh27OYaUaNvb1xVbsKn1fRaOT16Ca0lJWLe+7Cuz7pJInlaeng/dUtNPQdCIB6BuRx
	x9KaCAKH34MBvj1bkQDQSMEHbyzjwVYUMoMK5Yb4kkAINVCkTsm8+s/8ssSzZN5HOUOHSd
	DH+Ek2HAu2WpZd8v/dxTbnYAlSNf7kk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-522-AKHkQhbnOd25pMHWaX509Q-1; Thu, 18 May 2023 02:47:35 -0400
X-MC-Unique: AKHkQhbnOd25pMHWaX509Q-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3f4b96aa44aso2743075e9.1
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 23:47:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684392454; x=1686984454;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZN6Ju1FP4FeoecC0E5LNzhZjtVHQZME+r88V+E/OwK4=;
        b=G4bFEV5kQvIqdW+irboG2xXWQu1LhOONP46bYvU4Ri8jhTb+e5MrXR6bR6VxqUgNWx
         ESdpPamE+AJEk7xvr18thbtrosTXWDs7lJ5k5BHaqsz6L6rtXrrzqZZT9RtRU7f8nCmP
         z6+kgrBpbQSmjmglO3BaAwMa2VVjFtMXVlQHP8NlHgxuRsW1ijE6wwPOG81/vb29wxIM
         V+YBMvECBX1EeAh4xg5Z/P/KzUHqmKwsQzedbV5XWhOdIQ0Q8GuIDh3kR8Vhsm3HcErx
         0qeizzbDGjTJv54oAoq4pNCB0mOg8V6GnFyZUbIiLmGfi0UfsRtt3w0OXcdBdjTi9vEO
         0fZA==
X-Gm-Message-State: AC+VfDwdjWGPKjLRAvc7djU3JKSjMzJ40bkKz4cYOfTfhtrNtuRlzZ36
	zNLYp4ejIlIRRVTUhZwcxwcXbcQ85hmqRzTJawbdfKK2dG2z4ZQTMHtkSLJAee8em/55yodCmI4
	Y0QyPJnkSZTIlRLa/ChjAHO1Z
X-Received: by 2002:adf:e984:0:b0:309:3a72:3cea with SMTP id h4-20020adfe984000000b003093a723ceamr3157297wrm.0.1684392454638;
        Wed, 17 May 2023 23:47:34 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7NAs5kv2mFpL8q2hjP8+Kb6Pg/BSYEPMO2lqh52LnPJx7S/ze/dGKFmh3+JCX6/3Rf/ZmhvQ==
X-Received: by 2002:adf:e984:0:b0:309:3a72:3cea with SMTP id h4-20020adfe984000000b003093a723ceamr3157285wrm.0.1684392454338;
        Wed, 17 May 2023 23:47:34 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-239-175.dyn.eolo.it. [146.241.239.175])
        by smtp.gmail.com with ESMTPSA id h12-20020a5d688c000000b003047f7a7ad1sm1050075wru.71.2023.05.17.23.47.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 23:47:33 -0700 (PDT)
Message-ID: <11ab22ff9ecf7e7a330ac45e9ac08bf04aa7f6df.camel@redhat.com>
Subject: Re: linux-next: build failure after merge of the net tree
From: Paolo Abeni <pabeni@redhat.com>
To: Jakub Kicinski <kuba@kernel.org>, Dario Binacchi
 <dario.binacchi@amarulasolutions.com>, Marc Kleine-Budde
 <mkl@pengutronix.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, David Miller
 <davem@davemloft.net>,  Networking <netdev@vger.kernel.org>, Linux Kernel
 Mailing List <linux-kernel@vger.kernel.org>, Linux Next Mailing List
 <linux-next@vger.kernel.org>
Date: Thu, 18 May 2023 08:47:32 +0200
In-Reply-To: <20230517214200.33398f82@kernel.org>
References: <20230518090634.6ec6b1e1@canb.auug.org.au>
	 <20230517214200.33398f82@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, 2023-05-17 at 21:42 -0700, Jakub Kicinski wrote:
> On Thu, 18 May 2023 09:06:34 +1000 Stephen Rothwell wrote:
> > Hi all,
> >=20
> > After merging the net tree, today's linux-next build (arm
> > multi_v7_defconfig) failed like this:
> >=20
> > Error: arch/arm/boot/dts/stm32f746.dtsi:265.20-21 syntax error
> > FATAL ERROR: Unable to parse input tree
> > make[2]: *** [scripts/Makefile.lib:419: arch/arm/boot/dts/stm32f746-dis=
co.dtb] Error 1
> > Error: arch/arm/boot/dts/stm32f746.dtsi:265.20-21 syntax error
> > FATAL ERROR: Unable to parse input tree
> > make[2]: *** [scripts/Makefile.lib:419: arch/arm/boot/dts/stm32f769-dis=
co.dtb] Error 1
> > Error: arch/arm/boot/dts/stm32f746.dtsi:265.20-21 syntax error
> > FATAL ERROR: Unable to parse input tree
> >=20
> > Caused by commit
> >=20
> >   0920ccdf41e3 ("ARM: dts: stm32: add CAN support on stm32f746")
> >=20
> > I have used the net tree from next-20230517 for today.
>=20
> Dario, Marc, can we get an immediate fix for this?

Dario, Marc: we are supposed to send the net PR to Linus today. Lacking
a fix, I'll be forced to revert the mentioned commit in a little time.

Thanks!

Paolo


