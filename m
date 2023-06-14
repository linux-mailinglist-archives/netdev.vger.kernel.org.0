Return-Path: <netdev+bounces-10881-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A653B7309EA
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 23:41:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4B3B3280A05
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 21:41:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E374E134BB;
	Wed, 14 Jun 2023 21:41:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8202134B8
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 21:41:38 +0000 (UTC)
Received: from sender3-op-o19.zoho.com (sender3-op-o19.zoho.com [136.143.184.19])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EB03268C;
	Wed, 14 Jun 2023 14:41:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1686778856; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=Ul326G5zKHXONSFUS+UiamL2zNH0B5M+pCy2WNtDK0n5ysXLsGDDxcwi4wumb1/C2FX9y9DF0bJvqi8ezEhLEtknk1k1anFgqTMMCuuyPQpEzyDVm7/A+9cFpqIvEgm0XGQMNhfdDPG3VotkeACpSIZmsV06elkrBl7xdHzx3tc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1686778856; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
	bh=qJJkUdB/0J8dtVErmzAQ2BEHrFf9wberlx5qBQL3ZnI=; 
	b=WX0wi7xs/gkMuSYS46FuB4fhbMw3DOMzoyTGn6y/g9RX4gGcpvGbdQYD0yfYbwoC2e2sJTVVTV0Fro/a6oWsyl7z3X1ogFl2N4csugN+Ti+3SI2J9fKWnkJETsrQExi8EIR/E3EHsbE+P68YHUySOYhk2cZ6XDMDBWr8m2UHB74=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=arinc9.com;
	spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
	dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1686778856;
	s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
	h=Date:Date:From:From:To:To:CC:Subject:Subject:In-Reply-To:References:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To:Cc;
	bh=qJJkUdB/0J8dtVErmzAQ2BEHrFf9wberlx5qBQL3ZnI=;
	b=MNQUj18m8K8Tj5BGICpC2tlZDVDm7bjh2FIYrwsyDBd4Ze6UqjtcrsWCFabFD/uI
	wU5vvU/S4b/KjnYmUQMSVzCZUOZL1/Lboqxm4pSxKfdhmoAaCy5bcYSpF2ghvYsdff+
	cPLeFH+60vqgl8kTqbnaZMKNlELb/6JrFfP0FywY=
Received: from [127.0.0.1] (62.74.57.178 [62.74.57.178]) by mx.zohomail.com
	with SMTPS id 1686778855456977.8281613933586; Wed, 14 Jun 2023 14:40:55 -0700 (PDT)
Date: Thu, 15 Jun 2023 00:40:47 +0300
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
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_net_v4_1/7=5D_net=3A_dsa=3A_mt7530=3A_fix_tr?= =?US-ASCII?Q?apping_frames_with_multiple_CPU_ports_on_MT7531?=
User-Agent: K-9 Mail for Android
In-Reply-To: <20230614211352.sls7ao5swiqjgtjz@skbuf>
References: <20230612075945.16330-1-arinc.unal@arinc9.com> <20230612075945.16330-1-arinc.unal@arinc9.com> <20230612075945.16330-2-arinc.unal@arinc9.com> <20230612075945.16330-2-arinc.unal@arinc9.com> <20230614194330.qhhoxai7namrgczq@skbuf> <1e737fe9-6a2e-225b-9c0f-9a069e8fd4bc@arinc9.com> <20230614211352.sls7ao5swiqjgtjz@skbuf>
Message-ID: <F03D45C7-04E9-4534-AC28-2C6F76EAF3F4@arinc9.com>
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

On 15 June 2023 00:13:52 EEST, Vladimir Oltean <olteanv@gmail=2Ecom> wrote:
>On Wed, Jun 14, 2023 at 11:56:44PM +0300, Ar=C4=B1n=C3=A7 =C3=9CNAL wrote=
:
>> On 14=2E06=2E2023 22:43, Vladimir Oltean wrote:
>> > On Mon, Jun 12, 2023 at 10:59:39AM +0300, arinc9=2Eunal@gmail=2Ecom w=
rote:
>> > > From: Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc=2Eunal@arinc9=2Ecom>
>> > >=20
>> > > Every bit of the CPU port bitmap for MT7531 and the switch on the M=
T7988
>> > > SoC represents a CPU port to trap frames to=2E These switches trap =
frames
>> > > received from a user port to the CPU port that is affine to the use=
r port
>> > > from which the frames are received=2E
>> > >=20
>> > > Currently, only the bit that corresponds to the first found CPU por=
t is set
>> > > on the bitmap=2E When multiple CPU ports are being used, the trappe=
d frames
>> > > from the user ports not affine to the first CPU port will be droppe=
d as the
>> > > other CPU port is not set on the bitmap=2E The switch on the MT7988=
 SoC is
>> > > not affected as there's only one port to be used as a CPU port=2E
>> > >=20
>> > > To fix this, introduce the MT7531_CPU_PMAP macro to individually se=
t the
>> > > bits of the CPU port bitmap=2E Set the CPU port bitmap for MT7531 a=
nd the
>> > > switch on the MT7988 SoC on mt753x_cpu_port_enable() which runs on =
a loop
>> > > for each CPU port=2E
>> > >=20
>> > > Add a comment to explain frame trapping for these switches=2E
>> > >=20
>> > > According to the document MT7531 Reference Manual for Development B=
oard
>> > > v1=2E0, the MT7531_CPU_PMAP bits are unset after reset so no need t=
o clear it
>> > > beforehand=2E Since there's currently no public document for the sw=
itch on
>> > > the MT7988 SoC, I assume this is also the case for this switch=2E
>> > >=20
>> > > Fixes: c288575f7810 ("net: dsa: mt7530: Add the support of MT7531 s=
witch")
>> > > Signed-off-by: Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc=2Eunal@arinc9=2Ecom=
>
>> > > ---
>> >=20
>> > Would you agree that this is just preparatory work for change "net: d=
sa:
>> > introduce preferred_default_local_cpu_port and use on MT7530" and not=
 a
>> > fix to an existing problem in the code base?
>>=20
>> Makes sense=2E Pre-preferred_default_local_cpu_port patch, there isn't =
a case
>> where there's a user port affine to a CPU port that is not enabled on t=
he
>> CPU port bitmap=2E So yeah, this is just preparatory work for "net: dsa=
:
>> introduce preferred_default_local_cpu_port and use on MT7530"=2E
>>=20
>> So how do I change the patch to reflect this?
>>=20
>> Ar=C4=B1n=C3=A7
>
>net: dsa: mt7530: set all CPU ports in MT7531_CPU_PMAP
>
>MT7531_CPU_PMAP represents the destination port mask for trapped-to-CPU
>frames (further restricted by PCR_MATRIX)=2E
>
>Currently the driver sets the first CPU port as the single port in this
>bit mask, which works fine regardless of whether the device tree defines
>port 5, 6 or 5+6 as CPU ports=2E This is because the logic coincides with
>DSA's logic of picking the first CPU port as the CPU port that all user
>ports are affine to, by default=2E
>
>An upcoming change would like to influence DSA's selection of the
>default CPU port to no longer be the first one, and in that case, this
>logic needs adaptation=2E
>
>Since there is no observed leakage or duplication of frames if all CPU
>ports are defined in this bit mask, simply include them all=2E
>
>Note that there is no Fixes tag

Thanks a lot for making it easier for me=2E

Ar=C4=B1n=C3=A7

