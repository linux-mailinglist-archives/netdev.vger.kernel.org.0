Return-Path: <netdev+bounces-11300-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3903473275B
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 08:23:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1D4461C20F11
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 06:23:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC36A4697;
	Fri, 16 Jun 2023 06:23:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD82C1100
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 06:23:08 +0000 (UTC)
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC9E63AB9;
	Thu, 15 Jun 2023 23:22:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1686896515; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=B4i8Vvarf4RaM2aoLWARyAJ1Ue3pO03wwUFEoM5DZqwYynAkJ9i9WK15koGBaEFhmgepTZ7iRsHT1dMcJDgyr+cTpo+DWxkzlDCzik24WZIBfB4tAuhDHdvMcQYHHZnYpLcW70fGVoRISKR5IeHbVG6REUChLUAPO9JFUHNgFG4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1686896515; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
	bh=JG1OOQAMtUxBQlamhzsDlI4XUK2tZtiqF6iq7b73yuw=; 
	b=A344pEiw8ZK+OxMIj94/fgSN9/Xtv3BqCf+aZqiYiv8guV34qLPKLo504DYYhOUn0Td7w8Jr5xuaf6Zti3kSNUM+iQDER7EXUbh8jfC5cIM5OPit39aPQ/Dj6XqONGLRRpK3BaG/b1tNXYiMgijk7XTTYP8ZKG5LPVqAeFJwaRw=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=arinc9.com;
	spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
	dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1686896515;
	s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
	h=Date:Date:From:From:To:To:CC:Subject:Subject:In-Reply-To:References:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To:Cc;
	bh=JG1OOQAMtUxBQlamhzsDlI4XUK2tZtiqF6iq7b73yuw=;
	b=F/K3dXqpJ7cvWJ0z0/X/6baNIJaJn9t6+sN7CH4w3gBsst9t6HDm6lTZaDR6grk+
	u1ElhmZQd+Y4/96OWqc+wv/DUcCrONLvu//z+VS3VJz/gvyiUwtWfPTGwlinhjTBX2z
	lhNizfRHIAvhbJdyzhz8vQd7TqxdgX40dNPy3oro=
Received: from [127.0.0.1] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
	with SMTPS id 1686896514281444.96802030067886; Thu, 15 Jun 2023 23:21:54 -0700 (PDT)
Date: Fri, 16 Jun 2023 09:21:40 +0300
From: =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
To: frank-w@public-files.de, Frank Wunderlich <frank-w@public-files.de>,
 arinc9.unal@gmail.com, Daniel Golle <daniel@makrotopia.org>,
 Landen Chao <Landen.Chao@mediatek.com>, DENG Qingfang <dqfext@gmail.com>,
 Sean Wang <sean.wang@mediatek.com>, Andrew Lunn <andrew@lunn.ch>,
 Florian Fainelli <f.fainelli@gmail.com>, Vladimir Oltean <olteanv@gmail.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Russell King <linux@armlinux.org.uk>
CC: Landen Chao <landen.chao@mediatek.com>,
 Bartel Eerdekens <bartel.eerdekens@constell8.be>, mithat.guner@xeront.com,
 erkin.bozoglu@xeront.com, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net v5 4/6] net: dsa: mt7530: fix handling of LLDP frames
User-Agent: K-9 Mail for Android
In-Reply-To: <CFD0E43B-1D0F-4BC3-8DB8-8CFA09F8AA94@public-files.de>
References: <20230616025327.12652-1-arinc.unal@arinc9.com> <20230616025327.12652-5-arinc.unal@arinc9.com> <CFD0E43B-1D0F-4BC3-8DB8-8CFA09F8AA94@public-files.de>
Message-ID: <44531D5A-9219-44CC-9197-DD59E9506453@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 16 June 2023 08:44:32 GMT+03:00, Frank Wunderlich <frank-w@public-files=
=2Ede> wrote:
>Am 16=2E Juni 2023 04:53:25 MESZ schrieb arinc9=2Eunal@gmail=2Ecom:
>>From: Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc=2Eunal@arinc9=2Ecom>
>>
>>LLDP frames are link-local frames, therefore they must be trapped to the
>>CPU port=2E Currently, the MT753X switches treat LLDP frames as regular
>>multicast frames, therefore flooding them to user ports=2E To fix this, =
set
>>LLDP frames to be trapped to the CPU port(s)=2E
>>
>>Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530=
 switch")
>>Signed-off-by: Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc=2Eunal@arinc9=2Ecom>
>>---
>> drivers/net/dsa/mt7530=2Ec | 8 ++++++++
>> drivers/net/dsa/mt7530=2Eh | 5 +++++
>> 2 files changed, 13 insertions(+)
>>
>>diff --git a/drivers/net/dsa/mt7530=2Ec b/drivers/net/dsa/mt7530=2Ec
>>index 7b72cf3a0e30=2E=2Ec85876fd9107 100644
>>--- a/drivers/net/dsa/mt7530=2Ec
>>+++ b/drivers/net/dsa/mt7530=2Ec
>>@@ -2266,6 +2266,10 @@ mt7530_setup(struct dsa_switch *ds)
>> 	mt7530_rmw(priv, MT753X_BPC, MT753X_BPDU_PORT_FW_MASK,
>> 		   MT753X_BPDU_CPU_ONLY);
>>=20
>>+	/* Trap LLDP frames with :0E MAC DA to the CPU port */
>>+	mt7530_rmw(priv, MT753X_RGAC2, MT753X_R0E_PORT_FW_MASK,
>>+		   MT753X_R0E_PORT_FW(MT753X_BPDU_CPU_ONLY));
>>+
>> 	/* Enable and reset MIB counters */
>> 	mt7530_mib_reset(ds);
>>=20
>>@@ -2369,6 +2373,10 @@ mt7531_setup_common(struct dsa_switch *ds)
>> 	mt7530_rmw(priv, MT753X_BPC, MT753X_BPDU_PORT_FW_MASK,
>> 		   MT753X_BPDU_CPU_ONLY);
>>=20
>>+	/* Trap LLDP frames with :0E MAC DA to the CPU port(s) */
>>+	mt7530_rmw(priv, MT753X_RGAC2, MT753X_R0E_PORT_FW_MASK,
>>+		   MT753X_R0E_PORT_FW(MT753X_BPDU_CPU_ONLY));
>>+
>> 	/* Enable and reset MIB counters */
>> 	mt7530_mib_reset(ds);
>>=20
>
>
>I though these 2 hunks should go into some common function

Like I said, I will do that on my net-next patch series=2E

Ar=C4=B1n=C3=A7

