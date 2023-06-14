Return-Path: <netdev+bounces-10885-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 934D9730A04
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 23:51:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B5CBB1C20DB2
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 21:51:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 740CF134C7;
	Wed, 14 Jun 2023 21:51:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6678F134B8
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 21:51:43 +0000 (UTC)
Received: from sender3-op-o19.zoho.com (sender3-op-o19.zoho.com [136.143.184.19])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FC2F2690;
	Wed, 14 Jun 2023 14:51:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1686779460; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=at6IAKRHbWvf44wjAf2UrAefuJRh+bNdNE4HnYjllwClTP3VNHL6hmjfk+e2WAmK7MWPe/hsFnkWmM1iJf5wzf7i4/rGFM/BQWGeJ4azc27IkEzO7EV7+udFEYL2qx3hnnn3x4LBdpUzNxyH+9aJQURxEFfRutxBT5f09OKzXxQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1686779460; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
	bh=G8ptNQMHMGfwoSZLcBUexpcfjLofTU0hZ5NuVHfPk7I=; 
	b=P1eg5EnHUnjK0hK0/ZwYsXACXNpZRVevo+JEN+wsKKw0X+H3r674WNSG/VsySGVofa8beuL0/MlPjX4gkyUmCzWePFCdNIlRYP0qRy9umWyudQV3V3ctWDTlkG2em3SAS8lw+tq2S6aRSmwHWCE9dQhUmfFcB/dN8I3riyQisGY=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=arinc9.com;
	spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
	dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1686779460;
	s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
	h=Date:Date:From:From:To:To:CC:Subject:Subject:In-Reply-To:References:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To:Cc;
	bh=G8ptNQMHMGfwoSZLcBUexpcfjLofTU0hZ5NuVHfPk7I=;
	b=PY4/LrhZhUGbYfr8lZXXduW7nFR8QOhshgOp+bOizfTQtH5lB8Qbv8dLCJmtbwfe
	oz6KPkHlyuUfD6zWKoPIyv5ag8vrJW8z2EbcVLb2VqjkGWZ8smVCmFIM7hRBaLDXdxb
	v8FPU+xOeCKOfInTScdmadv0cQejpA0SL6OjeCUg=
Received: from [127.0.0.1] (62.74.57.178 [62.74.57.178]) by mx.zohomail.com
	with SMTPS id 1686779458249840.0790674400172; Wed, 14 Jun 2023 14:50:58 -0700 (PDT)
Date: Thu, 15 Jun 2023 00:50:49 +0300
From: =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
To: Vladimir Oltean <olteanv@gmail.com>
CC: "Russell King (Oracle)" <linux@armlinux.org.uk>,
 Daniel Golle <daniel@makrotopia.org>, Landen Chao <Landen.Chao@mediatek.com>,
 DENG Qingfang <dqfext@gmail.com>, Sean Wang <sean.wang@mediatek.com>,
 Andrew Lunn <andrew@lunn.ch>, Florian Fainelli <f.fainelli@gmail.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Frank Wunderlich <frank-w@public-files.de>,
 Bartel Eerdekens <bartel.eerdekens@constell8.be>, mithat.guner@xeront.com,
 erkin.bozoglu@xeront.com, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net v4 5/7] net: dsa: mt7530: fix handling of LLDP frames
User-Agent: K-9 Mail for Android
In-Reply-To: <20230614214313.oezqcs3jdpsll5k4@skbuf>
References: <20230612075945.16330-1-arinc.unal@arinc9.com> <20230612075945.16330-6-arinc.unal@arinc9.com> <ZInt8mmrZ6tCGy1N@shell.armlinux.org.uk> <3eaf5a2c-6ef2-e43a-1d0e-08ec4e1ee7e8@arinc9.com> <20230614214313.oezqcs3jdpsll5k4@skbuf>
Message-ID: <B91A794A-E822-4F27-8744-1D83C87D72FC@arinc9.com>
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

On 15 June 2023 00:43:13 EEST, Vladimir Oltean <olteanv@gmail=2Ecom> wrote:
>On Wed, Jun 14, 2023 at 11:52:24PM +0300, Ar=C4=B1n=C3=A7 =C3=9CNAL wrote=
:
>> On 14=2E06=2E2023 19:42, Russell King (Oracle) wrote:
>> > On Mon, Jun 12, 2023 at 10:59:43AM +0300, arinc9=2Eunal@gmail=2Ecom w=
rote:
>> > > From: Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc=2Eunal@arinc9=2Ecom>
>> > >=20
>> > > LLDP frames are link-local frames, therefore they must be trapped t=
o the
>> > > CPU port=2E Currently, the MT753X switches treat LLDP frames as reg=
ular
>> > > multicast frames, therefore flooding them to user ports=2E To fix t=
his, set
>> > > LLDP frames to be trapped to the CPU port(s)=2E
>
>so far so good
>
>> > >=20
>> > > The mt753x_bpdu_port_fw enum is universally used for trapping frame=
s,
>> > > therefore rename it and the values in it to mt753x_port_fw=2E
>
>yeah, this part of the patch is not useful at all [ here ]
>
>> > >=20
>> > > For MT7530, LLDP frames received from a user port will be trapped t=
o the
>> > > numerically smallest CPU port which is affine to the DSA conduit in=
terface
>> > > that is up=2E
>> > >=20
>> > > For MT7531 and the switch on the MT7988 SoC, LLDP frames received f=
rom a
>> > > user port will be trapped to the CPU port that is affine to the use=
r port
>> > > from which the frames are received=2E
>
>redundant and useless information here - what's important here is that
>they're trapped, not where

Ok, will remove=2E

>
>> > > The bit for R0E_MANG_FR is 27=2E When set, the switch regards the f=
rames with
>> > > :0E MAC DA as management (LLDP) frames=2E This bit is set to 1 afte=
r reset on
>> > > MT7530 and MT7531 according to the documents MT7620 Programming Gui=
de v1=2E0
>> > > and MT7531 Reference Manual for Development Board v1=2E0, so there'=
s no need
>> > > to deal with this bit=2E Since there's currently no public document=
 for the
>> > > switch on the MT7988 SoC, I assume this is also the case for this s=
witch=2E
>
>I guess that the reader who isn't familiar with the hardware will never
>get to ask himself "is the unrelated R0E_MANG_FR bit set ok?", and the
>familiar reader can just look that up in the programming guides that are
>available, and see the default value and that the driver doesn't change i=
t=2E
>
>So I just don't see how this bit of information is relevant in this
>patch=2E Sure, by all means, provide all context that helps the reader to
>understand the change, but at the same time: less is more=2E

Will remove=2E

>
>> > >=20
>> > > Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek M=
T7530 switch")
>> >=20
>> > Patch 4 claims to be a fix for this commit, and introduces one of the=
se
>> > modifications to MT753X_BPC, which this patch then changes=2E
>> >=20
>> > On the face of it, it seems this patch is actually a fix to patch 4 a=
s
>> > well as the original patch, so does that mean that patch 4 only half
>> > fixes a problem?
>>=20
>> I should do the enum renaming on my net-next series instead, as it's no=
t
>> useful to what this patch fixes at all=2E
>
>please do so (assuming that the enum really has to be changed)=2E
>
>also, if you're not really sure that this behavior has impacted any user
>(including yourself), I suppose there's also the option of fixing this in
>net-next as one of the earliest patches, independent from any other rewor=
k,
>so that in case there's a request to backport it to stable, it's possible=
=2E
>I remember having suggested this once already=2E

This impacts the devices of the company I work with and Bartel's, so I wou=
ld like this on the stable kernels immediately=2E

Ar=C4=B1n=C3=A7

