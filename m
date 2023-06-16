Return-Path: <netdev+bounces-11289-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 810F97326BE
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 07:45:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AF1FC1C20F0C
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 05:45:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45389EC0;
	Fri, 16 Jun 2023 05:45:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3616C7C
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 05:45:21 +0000 (UTC)
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1BFC1715;
	Thu, 15 Jun 2023 22:45:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=public-files.de;
 s=s31663417; t=1686894282; x=1687499082; i=frank-w@public-files.de;
 bh=5eg7RXmJMtMZxqGRw8WILxedxtZ1RDfpgHRg3ABH2FY=;
 h=X-UI-Sender-Class:Date:From:To:CC:Subject:Reply-to:In-Reply-To:Referenc
 es;
 b=a4VetjATUhtGrviquK6iBUjQVmw+Q8WPcuBvm72jxETBCVAt8fKwmwn9Ia7JtaLXpGWeDOv
 gtCJurPNc0lY2OJUpPRBIzQ2FawN/2XZlczYqIjOOYUOptQBQISXNMAVw5seuH0ZfgUliPwFO
 xLgICPEHQyzyRH9+nE/2r1v+8vyQdakDYsIPnAJLETfWUZ21eF5f+MHTNL6QLqGrPOhSrROut
 69zB2n/dpCtO8GmHyGNPwwgXF0UhG49bRHJt2fU26gFMIy+AYDfARviTSv4PbO68kE/pv8vgd
 f20WQesbrPeActVgBYr//+Kpno4K2TbM+pfp04ngvTrtZX4HIvhQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [127.0.0.1] ([217.61.152.78]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1Mzyya-1px9iO1nL4-00x58L; Fri, 16
 Jun 2023 07:44:42 +0200
Date: Fri, 16 Jun 2023 07:44:32 +0200
From: Frank Wunderlich <frank-w@public-files.de>
To: arinc9.unal@gmail.com,
 =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
 Daniel Golle <daniel@makrotopia.org>, Landen Chao <Landen.Chao@mediatek.com>,
 DENG Qingfang <dqfext@gmail.com>, Sean Wang <sean.wang@mediatek.com>,
 Andrew Lunn <andrew@lunn.ch>, Florian Fainelli <f.fainelli@gmail.com>,
 Vladimir Oltean <olteanv@gmail.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Russell King <linux@armlinux.org.uk>
CC: Landen Chao <landen.chao@mediatek.com>,
 Bartel Eerdekens <bartel.eerdekens@constell8.be>, mithat.guner@xeront.com,
 erkin.bozoglu@xeront.com, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net v5 4/6] net: dsa: mt7530: fix handling of LLDP frames
User-Agent: K-9 Mail for Android
Reply-to: frank-w@public-files.de
In-Reply-To: <20230616025327.12652-5-arinc.unal@arinc9.com>
References: <20230616025327.12652-1-arinc.unal@arinc9.com> <20230616025327.12652-5-arinc.unal@arinc9.com>
Message-ID: <CFD0E43B-1D0F-4BC3-8DB8-8CFA09F8AA94@public-files.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:3lxl0MPex+u5xxfAzvrdcXVP4Drii4GQK9Qm1rbQCLkju9MzBb+
 bN5ner5fXtcDMmVpLVZB2/yGeNGdPyrMrJwqaNXL9CUN2tHfZPU/PqCn6p/hKkwYQBKakKX
 j3Ap68wuPAToJ6wEnzLUbeKt7xdcS8eB9DsZ92FGk8Is7Ic/JVbSsFweqa+7udI9t4qlQw4
 NST1bsMQSWjlAbbe4LR8Q==
UI-OutboundReport: notjunk:1;M01:P0:drprUYgIsko=;lfwGdT9vdEHSO876eZlvpXiTruf
 bPKCupHUQU481noFTmxoTV+MAdHAdySN+LsY41W07L1W/ZwuyTr3HaZ4mBC0lTQY0RWfWS7DF
 jdoeKrWf+/BZ2VSWYIhDwiWOkq1oohhlxs7h1xwOqQR0j4hb6qopX4BJtuERvbY7eBdxwjkvI
 mrB1ou0/C7+iyqmYbXnbHFXwfzF4eF0dKaWaQbDQPFBHo8ju2vPZFBhvi+N6+hAt+T+vbRxQ9
 EOcaevb8UJ1w12/CvOEGZydfzbXNoUzstE+V8j2zSt6utty885YOLA1XWbAFskZ4nXFNbU+az
 yte4HmG2lZlskrCHk4plSMvAdqQeVHb8mdfG/L7HuVc1InlTCSTcJRLoz9qXf021Z2G+2qmwy
 y8oE4HfyzV9r3Jp3qIcJzny9i+w5Jmr8K/T2bmAB3R8Gpzpup8/1lWKGd1U+YSp7sY527tfgN
 FEM/m50nG7SJdcXQZURQKWyRo2UIhcygFfgOqZ9/AlBuQdsMZwShq5agFY/kxJrit9M0uOv/K
 f4JF53TYE8viqipgN7mg80n2tdpSR902jRiw4ZBmxFGXqsoCTncYsjVyPCVEN7y7qmSdAw70U
 +EN1kf8Pjx3mm8DDIKrKP7WqAH2dtEpr0wG/DtDKoSdqr9w+0HCXJ4ep9d4+iQ/bfbscOgqgA
 4g0AYxdmQzXhNIJq0w0iYhQjwD9vKZX3IuImhfoo2ova1IgsWZAqR8fO8vWnxHoNeATjMSwYd
 GdLetfkFJ8zGshBpg0Mp0bpas6faP37TBZHKAcyE6HETF89/sJDSM/RSFL2tqshSSBt5//M8c
 /TgXyKZVY5oHgWjSeoFg8wjU2zfEceHkmuZAkJ4a2aMuWjVxRp4th50cPGNnSO2D2fe+rl8SO
 M2YkVLL/AcscZdnAipmVUI236Cy4IW3XMMSCXxrDZnNOS/ijV+qtTI+nwE/gGKwvhOBnK2bIZ
 zxOhs9A3On0k74n6U4jb8Bzd7X0=
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Am 16=2E Juni 2023 04:53:25 MESZ schrieb arinc9=2Eunal@gmail=2Ecom:
>From: Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc=2Eunal@arinc9=2Ecom>
>
>LLDP frames are link-local frames, therefore they must be trapped to the
>CPU port=2E Currently, the MT753X switches treat LLDP frames as regular
>multicast frames, therefore flooding them to user ports=2E To fix this, s=
et
>LLDP frames to be trapped to the CPU port(s)=2E
>
>Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 =
switch")
>Signed-off-by: Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc=2Eunal@arinc9=2Ecom>
>---
> drivers/net/dsa/mt7530=2Ec | 8 ++++++++
> drivers/net/dsa/mt7530=2Eh | 5 +++++
> 2 files changed, 13 insertions(+)
>
>diff --git a/drivers/net/dsa/mt7530=2Ec b/drivers/net/dsa/mt7530=2Ec
>index 7b72cf3a0e30=2E=2Ec85876fd9107 100644
>--- a/drivers/net/dsa/mt7530=2Ec
>+++ b/drivers/net/dsa/mt7530=2Ec
>@@ -2266,6 +2266,10 @@ mt7530_setup(struct dsa_switch *ds)
> 	mt7530_rmw(priv, MT753X_BPC, MT753X_BPDU_PORT_FW_MASK,
> 		   MT753X_BPDU_CPU_ONLY);
>=20
>+	/* Trap LLDP frames with :0E MAC DA to the CPU port */
>+	mt7530_rmw(priv, MT753X_RGAC2, MT753X_R0E_PORT_FW_MASK,
>+		   MT753X_R0E_PORT_FW(MT753X_BPDU_CPU_ONLY));
>+
> 	/* Enable and reset MIB counters */
> 	mt7530_mib_reset(ds);
>=20
>@@ -2369,6 +2373,10 @@ mt7531_setup_common(struct dsa_switch *ds)
> 	mt7530_rmw(priv, MT753X_BPC, MT753X_BPDU_PORT_FW_MASK,
> 		   MT753X_BPDU_CPU_ONLY);
>=20
>+	/* Trap LLDP frames with :0E MAC DA to the CPU port(s) */
>+	mt7530_rmw(priv, MT753X_RGAC2, MT753X_R0E_PORT_FW_MASK,
>+		   MT753X_R0E_PORT_FW(MT753X_BPDU_CPU_ONLY));
>+
> 	/* Enable and reset MIB counters */
> 	mt7530_mib_reset(ds);
>=20


I though these 2 hunks should go into some common function as these are re=
dundant or am i wrong?

Btw=2Ethx for your work on this driver :)

regards Frank

