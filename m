Return-Path: <netdev+bounces-7098-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CF22A719E6D
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 15:42:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8397628172A
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 13:42:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95EA421CC0;
	Thu,  1 Jun 2023 13:42:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89F5C23423
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 13:42:14 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5AC1139
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 06:42:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685626931;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZPN2zqjRcvTx5BAbVRSKyrNwIPYaR9V6mursf4H+kkE=;
	b=UBxwOJdaRm2luaDY7t8k9446iy8VUnJuINRWGyS4m9RgSZFNolHiufuYbVqb/ImBpcadF6
	yH/Zt8NwO4JyJTHa7PcvExjNIz0rOaWDrJaUeh83DF1UCFAGdp2Vxdg+4IYUO0KrkeuMli
	VkmtxDd1jqQawifUBtAmC35N39D2dP4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-354-Odq0QhyGOlaCeyIPE1kdVw-1; Thu, 01 Jun 2023 09:42:10 -0400
X-MC-Unique: Odq0QhyGOlaCeyIPE1kdVw-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-30ac043a7eeso46895f8f.0
        for <netdev@vger.kernel.org>; Thu, 01 Jun 2023 06:42:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685626928; x=1688218928;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZPN2zqjRcvTx5BAbVRSKyrNwIPYaR9V6mursf4H+kkE=;
        b=OQnPJxt5K7UCo8is2th3rCylhdVKtMglMEW8cZET6cliHzZOy3B4LifFrxevT7GG7L
         FHWRisPsis9pnWfbBbeUu/zwRhgAyjWYQDqI2ZXd4ZeLlVAA4coLrjGePQERymbPb410
         o7r1TXL0VE4mB2YGjiCWX2d3nGgWdkuko9kdWsicQEt2ahIkIU1g4sbN9MuhxtaWdBTy
         rp6vLSw68gcGX49lyrGh6HMLDmY0QKMvudIIAuD5p1FchB6kyT88C9FL8k33Kr/Bn1Sz
         Eat3lNj7oVdVwFBxIF+VBaSTy8Jkalil7aPVEr+cGoC7V+/4e/Jg9B+cbMXc4vxBDF06
         lgPw==
X-Gm-Message-State: AC+VfDzKujw0frAlE9Zopz7y6yIATy/jrUozdwg2RErpWFMqLPZlFCpr
	lrNyo8KtTcEZ1q4P5QMuJVHFLzcMJK7k92nh6GxGL3dmjVQJR6PlY7t0q3huk86QyMQuhyZPOZ2
	pumXo40Ek0563uiTu
X-Received: by 2002:a5d:5490:0:b0:2e4:c9ac:c492 with SMTP id h16-20020a5d5490000000b002e4c9acc492mr5994559wrv.1.1685626928450;
        Thu, 01 Jun 2023 06:42:08 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ52njr8Il+cOTczR39DnsK5Iu/OapPG+wYgoaSYubVjP1CrjzkBWo6brNrPUA6MLAqHiTSnPA==
X-Received: by 2002:a5d:5490:0:b0:2e4:c9ac:c492 with SMTP id h16-20020a5d5490000000b002e4c9acc492mr5994541wrv.1.1685626928087;
        Thu, 01 Jun 2023 06:42:08 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-242-89.dyn.eolo.it. [146.241.242.89])
        by smtp.gmail.com with ESMTPSA id z2-20020a5d6542000000b0030c2e3c7fb3sm2963398wrv.101.2023.06.01.06.42.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jun 2023 06:42:07 -0700 (PDT)
Message-ID: <1a14013cc3e205265e4564094d4faf971b651810.camel@redhat.com>
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: Increase wait after reset
 deactivation
From: Paolo Abeni <pabeni@redhat.com>
To: Andrew Lunn <andrew@lunn.ch>, Andreas Svensson
 <andreas.svensson@axis.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>, Vladimir Oltean
 <olteanv@gmail.com>,  "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,  kernel@axis.com,
 Baruch Siach <baruch@tkos.co.il>, netdev@vger.kernel.org, 
 linux-kernel@vger.kernel.org
Date: Thu, 01 Jun 2023 15:42:06 +0200
In-Reply-To: <133860f9-e745-44ce-9b74-c5d990cf92db@lunn.ch>
References: <20230530145223.1223993-1-andreas.svensson@axis.com>
	 <be44dfe3-b4cb-4fd5-b4bd-23eec4bd401c@lunn.ch>
	 <f89e203a-af77-9661-1003-0e9370ff6fab@axis.com>
	 <133860f9-e745-44ce-9b74-c5d990cf92db@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, 2023-06-01 at 14:01 +0200, Andrew Lunn wrote:
>  On Thu, Jun 01, 2023 at 11:10:58AM +0200, Andreas Svensson wrote:
> > On 5/30/23 19:28, Andrew Lunn wrote:
> > > On Tue, May 30, 2023 at 04:52:23PM +0200, Andreas Svensson wrote:
> > > > A switch held in reset by default needs to wait longer until we can
> > > > reliably detect it.
> > > >=20
> > > > An issue was observed when testing on the Marvell 88E6393X (Link St=
reet).
> > > > The driver failed to detect the switch on some upstarts. Increasing=
 the
> > > > wait time after reset deactivation solves this issue.
> > > >=20
> > > > The updated wait time is now also the same as the wait time in the
> > > > mv88e6xxx_hardware_reset function.
> > >=20
> > > Do you have an EEPROM attached and content in it?
> >=20
> > There's no EEPROM attached to the switch in our design.
> >=20
> > >=20
> > > It is not necessarily the reset itself which is the problem, but how
> > > long it takes after the reset to read the contents of the
> > > EEPROM. While it is doing that, is does not respond on the MDIO
> > > bus. Which is why mv88e6xxx_hardware_reset() polls for that to
> > > complete.
> >=20
> > Ok, yes that makes sense. I could add the mv88e6xxx_g1_wait_eeprom_done
> > function after the reset deactivation.
>=20
> I don't think that works, because how to talk to the switch is not
> determined until after the switch has been detected.
>=20
> > The datasheet for 88E6393X also states that it needs at least 10ms
> > before it's ready. But I suppose this varies from switch to switch.
>=20
> O.K, let go with this change and see if anybody really complains. We
> can always add a DT property later.
>=20
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
>=20
> You probably need to repost with my Reviewed-by added, now that Paolo
> has changed the status of the patch.

Not needed. I can restore the patch in PW.

Thanks,

Paolo


