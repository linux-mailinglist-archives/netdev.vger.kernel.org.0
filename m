Return-Path: <netdev+bounces-10328-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FC8572DEC5
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 12:10:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2390F1C20C29
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 10:10:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18F222910D;
	Tue, 13 Jun 2023 10:10:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C33C27738
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 10:10:22 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C7DC186
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 03:10:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686651020;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EQ8qG3I5WaG3P52JxI3Wd7lusGu6FrfknhfgsuNOgLo=;
	b=ByreEKN5TAIoLLSlsgd9a5BDKYIq+cGD1QJ7pqeUIWHouR2AmNferdWWLUFAUXwoDr/J7+
	pmLkTOQFJydtoOMqvofUwjHWhLMxRUY4SxDNxTktT8/PI9tBK8+7bRgrSSUmDh/Yg23Xy1
	FH4FfdqBj/Eqf93QfFGpWwD6BVxJJhk=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-616-C7RhIc6LMdW_BNfWjSJY8Q-1; Tue, 13 Jun 2023 06:10:19 -0400
X-MC-Unique: C7RhIc6LMdW_BNfWjSJY8Q-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-5187a7016edso164155a12.0
        for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 03:10:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686651018; x=1689243018;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EQ8qG3I5WaG3P52JxI3Wd7lusGu6FrfknhfgsuNOgLo=;
        b=ScNUlZHmDoJS4TKskjgkJXNQ2IrG/QUjPOhq3epq2kKMxt2+H6V+X5twaiePrJUTRN
         rKGfuImWn+jBFXk3TtOLtxVPXA/PFmbVC8WIp1MpxOJ9SNVkXVRltRdNHbXyJKBbbLVM
         nHzlmObYjtVb8r4RZYM+uARzzuiLD1C7P9bttFrw7v56YSy9RJ06hrAmK4BnR8t+a4rq
         61sLUYsLbIIFau3pXfwcMdWVM4NunpCojmlJxbUiKjvcbuyX39zFsXEK5LUaM0P7NNYX
         HK0utX75p0nRgOs2eUtQx+CTnOI1VmC3KApQfXvHybT/HLaHVF96lQdQ9W8pQbx54ms1
         eXwQ==
X-Gm-Message-State: AC+VfDxLVNedDjGaM+e0IRiepUvmL24rvkx5EbEz8JSon5tSQa6xCEK7
	tqJmiMDRWTis2YBgtFk6JglN30cLYw66aHQ/zyB59QnPvuinDJbbw4jC852mz2kswjwZcjL/012
	rv1h9TWnw8u9ym/hM
X-Received: by 2002:a17:907:9306:b0:974:1e85:6a69 with SMTP id bu6-20020a170907930600b009741e856a69mr12573586ejc.16.1686651018070;
        Tue, 13 Jun 2023 03:10:18 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4x+CLF7oh9OSNrlseseUZsRMaCbeVralIJHlINtpA+bhMhcdCKdtmrONK76OG4HPKF+L9oAg==
X-Received: by 2002:a17:907:9306:b0:974:1e85:6a69 with SMTP id bu6-20020a170907930600b009741e856a69mr12573565ejc.16.1686651017718;
        Tue, 13 Jun 2023 03:10:17 -0700 (PDT)
Received: from localhost (net-130-25-106-149.cust.vodafonedsl.it. [130.25.106.149])
        by smtp.gmail.com with ESMTPSA id y21-20020a170906471500b00974564fa7easm6492031ejq.5.2023.06.13.03.10.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jun 2023 03:10:17 -0700 (PDT)
Date: Tue, 13 Jun 2023 12:10:15 +0200
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Daniel Golle <daniel@makrotopia.org>, netdev@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Mark Lee <Mark-MC.Lee@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>, John Crispin <john@phrozen.org>,
	Felix Fietkau <nbd@nbd.name>, Conor Dooley <conor+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Rob Herring <robh+dt@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sam Shih <Sam.Shih@mediatek.com>
Subject: Re: [PATCH net-next 6/8] net: ethernet: mtk_eth_soc: convert caps in
 mtk_soc_data struct to u64
Message-ID: <ZIhAh2mzrYHOq2v1@lore-desk>
References: <ZIUX1AkjbSHdiMUc@makrotopia.org>
 <ZIcBQCqeMc424mv6@shell.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="cszZz60J0MnGgC6u"
Content-Disposition: inline
In-Reply-To: <ZIcBQCqeMc424mv6@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--cszZz60J0MnGgC6u
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Sun, Jun 11, 2023 at 01:39:48AM +0100, Daniel Golle wrote:
> > From: Lorenzo Bianconi <lorenzo@kernel.org>
> >=20
> > This is a preliminary patch to introduce support for MT7988 SoC.
> >=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > Signed-off-by: Daniel Golle <daniel@makrotopia.org>
>=20
> At some point, I'd really like to unpick this and see whether there's a
> better structure to it - so that mac_config() doesn't have to save the
> syscfg0 value, and restore it in mac_finish(). Given that syscfg0 is a
> shared register, are we sure the code that updates this register is safe
> from races caused by two MACs going through the config progress in two
> separate CPUs at the same time?

Agree, this seems a bit racy. However it does not seem related to this patc=
h.
I would say we can address it with a follow-up patch.

Regards,
Lorenzo

>=20
> Is there anything which prevents two or more MACs wanting to mess with
> the contents of the SYSCFG0_SGMII_MASK bits? It's difficult to tell with
> the current code.
>=20
> Thanks.
>=20
> --=20
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!
>=20

--cszZz60J0MnGgC6u
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCZIhAhwAKCRA6cBh0uS2t
rKWRAQD8bHaqtDus4I0VAesGyVWRDufLK3pPr+pM1DFTIDlkHQEA/9/+RWG7ZPoC
FpXYqhMD3z7v/+rNvWTD2rV8IbnfLg8=
=Cfik
-----END PGP SIGNATURE-----

--cszZz60J0MnGgC6u--


