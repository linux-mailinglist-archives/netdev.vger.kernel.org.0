Return-Path: <netdev+bounces-10883-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 595A17309F3
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 23:43:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3FF031C20D87
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 21:43:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E551134A7;
	Wed, 14 Jun 2023 21:43:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3223C134BD
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 21:43:56 +0000 (UTC)
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41C75268C;
	Wed, 14 Jun 2023 14:43:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1686779003; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=TNCcwRcj3htE9mbhAI9EIOhTRe+lZK6g5z1rJmA7ALaBYPybWunBwZ8pzxQGE/zUWdZK01A5phD9VP/iaOq7C6O0F+0ZFppaI9kKC2Vl3tpeQG5wcBMKbH6eyZRQp+FMIt4SXgNJKy1d0Xc/1PpA9xl9V3ejpoO3rkero4XbYB4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1686779003; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
	bh=hrueTWQ6ZYtBZeyZn5VhqPvTaefOuM0zQTPIl5FyBKY=; 
	b=fOKKM6A93PSFPGRaCswtEwsZ1Vt85reLsuh5hn+U9aIZ1k4S0ljtmQG9euxwPcw2W89LmZlzTKDT3ZxtHHo0VniiPJE9rla/w15r2oWfo0Ol6RPr4n+HESk1KjCd3x2/ueWJNjWyXh/usKGs1IAukOjYCSy2NBuavR/l7Q7A2kQ=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=arinc9.com;
	spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
	dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1686779003;
	s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
	h=Date:Date:From:From:To:To:CC:Subject:Subject:In-Reply-To:References:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To:Cc;
	bh=hrueTWQ6ZYtBZeyZn5VhqPvTaefOuM0zQTPIl5FyBKY=;
	b=ejloB5I2rzXHaSHqg9UZzF9pyFNVN2bfXe460H4oC2vrG8yr+vqvSVS/qRhIrb3z
	LpHGxMTLvVreZSW1rMIWxFyCz3rXx5fdoZ6GvKsBWvAG1Q7hBGvp92r8dSCKCyOImow
	5hftDgmnW41GcbgCfKk6gIOSasJxXV3wHttAeUas=
Received: from [127.0.0.1] (62.74.57.178 [62.74.57.178]) by mx.zohomail.com
	with SMTPS id 1686779002505844.3102518414573; Wed, 14 Jun 2023 14:43:22 -0700 (PDT)
Date: Thu, 15 Jun 2023 00:43:14 +0300
From: =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
To: Vladimir Oltean <olteanv@gmail.com>
CC: Daniel Golle <daniel@makrotopia.org>, Landen Chao <Landen.Chao@mediatek.com>,
 DENG Qingfang <dqfext@gmail.com>, Sean Wang <sean.wang@mediatek.com>,
 Andrew Lunn <andrew@lunn.ch>, Florian Fainelli <f.fainelli@gmail.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Russell King <linux@armlinux.org.uk>,
 Frank Wunderlich <frank-w@public-files.de>,
 Bartel Eerdekens <bartel.eerdekens@constell8.be>, mithat.guner@xeront.com,
 erkin.bozoglu@xeront.com, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_net_v4_4/7=5D_net=3A_dsa=3A_mt7530?= =?US-ASCII?Q?=3A_fix_handling_of_BPDUs_on_MT7530_switch?=
User-Agent: K-9 Mail for Android
In-Reply-To: <20230614211657.2c3ljwnlng7vxamz@skbuf>
References: <20230612075945.16330-1-arinc.unal@arinc9.com> <20230612075945.16330-5-arinc.unal@arinc9.com> <20230614205008.czro45ogsc4c6sb5@skbuf> <e8a0f46b-f133-c155-f0de-9046a53e6069@arinc9.com> <20230614211657.2c3ljwnlng7vxamz@skbuf>
Message-ID: <BEF93653-4380-423E-8B41-B4B18FB1F213@arinc9.com>
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

On 15 June 2023 00:16:57 EEST, Vladimir Oltean <olteanv@gmail=2Ecom> wrote:
>On Thu, Jun 15, 2023 at 12:05:44AM +0300, Ar=C4=B1n=C3=A7 =C3=9CNAL wrote=
:
>> On 14=2E06=2E2023 23:50, Vladimir Oltean wrote:
>> > Where have you seen the BPC register in the memory map of MT7530 or M=
T7621?
>>=20
>> I did not somehow dump the memory map of the switch hardware and confir=
m the
>> BPC register is there, if that's what you're asking=2E
>
>I mean to say that I looked at
>
>MT7530 Giga Switch programming guide=2Epdf
>MT7621 Giga Switch Programming Guide=2Epdf
>MT7621_ProgrammingGuide_GSW_v01=2Epdf
>
>and I did not find this register=2E
>
>> However, I can confirm the register is there and identical across all M=
T7530
>> variants=2E I have tested the function of the register on the MCM MT753=
0 on
>> the MT7621 SoC and the standalone MT7530=2E The register is also descri=
bed on
>> the document MT7620 Programming Guide v1=2E0, page 262=2E
>
>Interesting=2E I did not have that one=2E Hard to keep up=2E

I know the pain=2E The MT7530 registers are scattered throughout these fou=
r documents=2E TRGMII stuff is on MT7530 Giga Switch programming guide=2Epd=
f, etc=2E Good thing MT7531 Reference Manual for Development Board v1=2E0 h=
as it all for MT7531=2E

Ar=C4=B1n=C3=A7

