Return-Path: <netdev+bounces-2225-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 59538700D0A
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 18:30:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DD173281AE3
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 16:30:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 212E6210F;
	Fri, 12 May 2023 16:30:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AFA91EA63
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 16:30:22 +0000 (UTC)
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01olkn20812.outbound.protection.outlook.com [IPv6:2a01:111:f400:feab::812])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D713C900E;
	Fri, 12 May 2023 09:30:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DMDfkDowk3NQllBwI3yfp8qmyp9gczgy9d7LP0smSfVtxfhCScKtHDCw97LFYT67FgutB2vBoMYi2dbZFkhpb2LANYJ9iTLwIKzP0RRM7efR3iSFvFvh641Sh28BZpL9gGqZXABI9Y8QMy5O9mALLNcLFvZM9U5Igi/KprVDEZbJgYCDbNXkKde/BOuYNTL5fFTIjA2/QdfbUorFZ5QZpAhMve4S32BrLmfYhxlizgApSzxhc0mxFn1i9FLOKIm9+ZQjQM/tuWHsoPDF9j81/mhNkAQrhWS47qEPdIJGUDjecaCdwLFZxXTEjtAt4eB2daBaFuiPPtzOjXmnlQSTcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BxZ+UIvvtKvwwW9MLQiOdIb96ph0o6/4WGeOVuVPTo8=;
 b=jpN3cM70EhSYH5DqK/3Ij92RB3zihW0tnfOsDKOs2QZYy54ZP0MHiVEmGUnYZQIo8v8QKtG+dxFQjbwg27iON4g5EVpl0bRdWA49IPax20BKOPM4wMjHa3snULz4cDfoM6JizuEnLVZQ2r3EXVOOf+0NQ+Vb5kWd41xe/ka9XzOzYeMtC0jEVXMay0sqbGXwGf8hvTRzGjHQ54ONe5R0WS2NFFz3KhdE3RlvqhlDKj+Qz7h9TdnJtApnv5rxHXdyNxzua4kDv34sClmmoV6x3bHPba30y2p6O5BBQ382zk6YaL6heGM4Il1unGo7u9a4VOfm5jzsRQPcLdM/I4QCwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BxZ+UIvvtKvwwW9MLQiOdIb96ph0o6/4WGeOVuVPTo8=;
 b=EqEQJ/erVayoOD9MEkiuJ8wim/1ktDts9ahfwLeuxWvaqbv0vUSlZVTyYxVaDa9aAqTQN7JZwbNMS+qjcqrKmYUoxkZw79MKfo/yN53mBkoS8RSKCMoMmDXyeCjN4IWO/D6nQVnh8DFpsxuUH6h1806ADqiZSx278nZEcO9HtD/s7k2VKENPyHi6te9q/+iQ77rQkiywDZHea+ynqnRgxeXHQY+rbfqVcVxci5Xy4ZNBAlIwbxNugtZJquBcOkebQZpwRxPzGzFcIzxZ7mkOSkTuTcQOseTfYb8eAbWyUfzYb3ViCICdVcsnMxln+Q97uiys3h61qRb35BmEwETiMA==
Received: from KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 (2603:1096:820:9a::12) by SI2PR01MB3899.apcprd01.prod.exchangelabs.com
 (2603:1096:4:109::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.21; Fri, 12 May
 2023 16:30:14 +0000
Received: from KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 ([fe80::93cb:1631:4c4c:1821]) by KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 ([fe80::93cb:1631:4c4c:1821%4]) with mapi id 15.20.6387.018; Fri, 12 May 2023
 16:30:14 +0000
Content-Type: text/plain;
	charset=utf-8
Subject: Re: [PATCH v5] net: mdiobus: Add a function to deassert reset
From: Yan Wang <rk.code@outlook.com>
In-Reply-To: <1828875.atdPhlSkOF@steina-w>
Date: Sat, 13 May 2023 00:30:09 +0800
Cc: "Russell King (Oracle)" <linux@armlinux.org.uk>,
 Andrew Lunn <andrew@lunn.ch>,
 hkallweit1@gmail.com,
 davem@davemloft.net,
 edumazet@google.com,
 kuba@kernel.org,
 pabeni@redhat.com,
 netdev@vger.kernel.org,
 open list <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-ID:
 <KL1PR01MB5448242DBD4EA7170341A418E6759@KL1PR01MB5448.apcprd01.prod.exchangelabs.com>
References: <KL1PR01MB54486A247214CC72CAB5A433E6759@KL1PR01MB5448.apcprd01.prod.exchangelabs.com>
 <KL1PR01MB54488021E5650ED8A203057FE6759@KL1PR01MB5448.apcprd01.prod.exchangelabs.com>
 <ZF4J1VqEqbnE6JG9@shell.armlinux.org.uk> <1828875.atdPhlSkOF@steina-w>
To: Alexander Stein <alexander.stein@ew.tq-group.com>
X-Mailer: Apple Mail (2.3696.120.41.1.2)
X-TMN: [8WJ+SISt6ablb+TglZSJmt/+fX51PQ767qlILcmympQ=]
X-ClientProxiedBy: SGBP274CA0018.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::30)
 To KL1PR01MB5448.apcprd01.prod.exchangelabs.com (2603:1096:820:9a::12)
X-Microsoft-Original-Message-ID:
 <9AE749AC-1734-4A63-8421-7EA487887B7E@outlook.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR01MB5448:EE_|SI2PR01MB3899:EE_
X-MS-Office365-Filtering-Correlation-Id: 0dc8561b-df9e-4105-ce37-08db530629c9
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	hljr2TlVm9zMi5owLUpRuaLzksu/Un2nMETJ9tDV3L4HfElgd5RqV3ieRmLGaqaKvg2bPx+Sb6s6yR0BajhjcKS7dufIJam1mn4XXhOXVetLK8Y/RmNeo+F4wxSvSwAo7uomvhTIUCPwGSECGfh/ZwIask86LySudRct6h14mPYKMLFXlterVSzadgKLC9OUDcJ8Asxgcju3gYNWARtRlIob3FnV90dJWy2ZuPIVHPFO6nAaZyogB5tFNuNSunU1SFjkk4o8k+ej9EbWFdWFb4H6IyqNmhXhyenBUQwMBriItElXr2NAwjOIQq1XvNp+dStlR4q/PbdX9gcHHmN/Lldtk/y5u8qrmnv+u51TUeQJATwfVDzGYHrae4C4WzEchmPwQMcWe/MPbyAYLm4Oto6YJsKidzUNLwodQ+6sOkp71iJypVqT1Xi/hk1nCtyM3ozcxlZYSiHuxrBM0IkdRNhD6jwWExuE14VnqBsplF1LPCzHyGPP2r1bxihlN7m2tjdszKofTNTKxhgNxwWAXqNnLc/RBfZxZQXeYxOJ/sTpJt6EG1w8oUmpkiy7SqTAVa8RK/fU4E+i2EClbALKd+OmV1aJnxBOidYphZjghrs=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NldBVTg1TUtkRDFMTUd2SWVpRzYvVk1nUG9lQ0VsTVNYeDVRbk5aSUFCUzFv?=
 =?utf-8?B?OElsaEllWnJkMmN2b3VEcElnY3lSZFg5L3k4SWprSmszSkVveEhmRkNGSEhn?=
 =?utf-8?B?WmpmSXlxOEJweWJsb2k2ZDA2UUhCdFhLYTVGWkRxenlTNzlINW5MY0VGVnRu?=
 =?utf-8?B?R1M3emxEaWRMbVRZbDR4cURGdFlaTWpPQ3FBVU5mRkFmcjQ3RlVwdHJXbEp5?=
 =?utf-8?B?TXRtSmxQRTB3NElvQzFNQXpaTk5vR01SZUZWaWRlb2xSVHpxblY1WTZOUE4x?=
 =?utf-8?B?elExeHI3WnhYUXZIZHAza2lXUVdCSzI3R3NlSTZrdzNJalJKUnZTYzBxNDVB?=
 =?utf-8?B?ZEdSWDdZR1BOdG9KK3h2QWZiSDl0NGZFODZyYisxc0gxWHBud0J2KzExTE1a?=
 =?utf-8?B?MUhoNUxlYmUxT0Uzek5Bd0NyYnZFUVFuV1BZRElaaTNJUW9oNFdRa1N1TEl5?=
 =?utf-8?B?bEIveFFnVVYzQmVqNk1nQ0VIWEluOFZEa2oyQStwOTVub21DNm1pUzZGYmVu?=
 =?utf-8?B?bTYrV3JUeERrbzVHeDA3d2tNRlk4K0VELy9wWW85UEl1NFRIUmtYZ2NJRjJ4?=
 =?utf-8?B?dG1sZGpaRlpROXRkbUV5eGlTSnBnVmMvb3pkenprODl2ZnNyMWU2MXZuNTVo?=
 =?utf-8?B?aHUvMXMzUm9KMGlINmJoTkpPZHJmMUxTT1pqUHlwUTVSeVlMT3VsaXlucFg1?=
 =?utf-8?B?WEU4QVhKVmx4d2J1RHBBRGpCSnhPWVFSUEZBcE4vZDZtOFBXYXdCN1BrTHJ4?=
 =?utf-8?B?c0ZQWjMzeDZyeFUzQjdlYlZ0SmU4aHVFQlBuekNDUXZFbU80aVdlWmZOTmxL?=
 =?utf-8?B?UWpmWmsyRnRkZUtWZTFjbDZkcGJFbExKK3ExaEwxMHhtYW0rM1BMVVJ1T002?=
 =?utf-8?B?U3JvNVlPeFFRbDNCYlVUL0ltNHJhV3hSREFTUFY5UDM5ekNUZjEwSFpjQVFt?=
 =?utf-8?B?djEvSVBLYjVpT1Vha0NESlU0b2Y1VW9oclNVWmhaeVo4Wk5jZXdHVXErc0pM?=
 =?utf-8?B?VURwL0pSV0hSZHdOZGpMSjhwWU5ObE9OSmw2TXFCOG5SWjE2cGd2Z0VGbHNo?=
 =?utf-8?B?T3UwLzlTUmVzQVJFMGJDUS9HV1YrUVl5S05vS1E2NmZXOGM4YWlydzNQanE2?=
 =?utf-8?B?eDgxL2dXczhHK1lkQnMwMm9EbjI3eEJMU3BxT2pxOGF6ZFhSUFR0ZjU4aFRM?=
 =?utf-8?B?SXZOWStmbEtaWGVuODN2WFEveUN1aE1JVzNSaTJMNUNzM2RQVWZRSTVCVktl?=
 =?utf-8?B?ZWFDT0dCK3hENmNNTG1MWXI0eEYrNWtydGtYeGtON2c2dkkxV1hKYURYN2J5?=
 =?utf-8?B?WEFXTDIxVU03eFlpWVE1N201RUs0c0J0Vmh4NWFtcCtSM1ZiOVdXWEYzNkR5?=
 =?utf-8?B?Rkhxam8waFpqSXpweUNmNGE3SXFxMzZ6TnVxRU5ZWFdwUVRSU2kzeXhoYTd6?=
 =?utf-8?B?aVJ6M1RLZkxtSDBLaE9ZN2M2am5KY1NHQlNWWUdGcVM1ZW5lQ1FwZ2Q0RE1m?=
 =?utf-8?B?czRGQ05Ib3ZqWVNFdGZnYWM2WXJ4ZzRxNzJJZXZnRHNnOHNRL1c4dG1Gd2pS?=
 =?utf-8?B?LzBGMUJWRmJwOExaMzhBcVNXRTQ2cjdTV0FuOUFiQXRCd2wrVEpyc1dmejlo?=
 =?utf-8?B?OENWUFkvVEk1NmovQ2E2UTRuellodmc9PQ==?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0dc8561b-df9e-4105-ce37-08db530629c9
X-MS-Exchange-CrossTenant-AuthSource: KL1PR01MB5448.apcprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2023 16:30:14.1827
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2PR01MB3899
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> On May 12, 2023, at 21:37, Alexander Stein <alexander.stein@ew.tq-group.c=
om> wrote:
>=20
> Hi Russel,
>=20
> Am Freitag, 12. Mai 2023, 11:41:41 CEST schrieb Russell King (Oracle):
>> On Fri, May 12, 2023 at 05:28:47PM +0800, Yan Wang wrote:
>>> On 5/12/2023 5:02 PM, Russell King (Oracle) wrote:
>>>> On Fri, May 12, 2023 at 03:08:53PM +0800, Yan Wang wrote:
>>>>> +	gpiod_set_value_cansleep(reset, gpiod_is_active_low(reset));
>>>>> +	fsleep(reset_assert_delay);
>>>>> +	gpiod_set_value_cansleep(reset, !gpiod_is_active_low(reset));
>>>>=20
>>>> Andrew, one of the phylib maintainers and thus is responsible for code
>>>> in the area you are touching. Andrew has complained about the above
>>>> which asserts and then deasserts reset on two occasions now, explained
>>>> why it is wrong, but still the code persists in doing this.
>>>>=20
>>>> I am going to add my voice as another phylib maintainer to this and sa=
y
>>>> NO to this code, for the exact same reasons that Andrew has given.
>>>>=20
>>>> You now have two people responsible for the code in question telling
>>>> you that this is the wrong approach.
>>>>=20
>>>> Until this is addressed in some way, it is pointless you posting
>>>> another version of this patch.
>>>>=20
>>>> Thanks.
>>>=20
>>> I'm very sorry, I didn't have their previous intention.
>>> The meaning of the two assertions is reset and reset release.
>>> If you believe this is the wrong method, please ignore it.
>>=20
>> As Andrew has told you twice:
>>=20
>> We do not want to be resetting the PHY while we are probing the bus,
>> and he has given one reason for it.
>>=20
>> The reason Andrew gave is that hardware resetting a PHY that was not
>> already in reset means that any link is immediately terminated, and
>> the PHY has to renegotiate with its link partner when your code
>> subsequently releases the reset signal. This is *not* the behaviour
>> that phylib maintainers want to see.
>>=20
>> The second problem that Andrew didn't mention is that always hardware
>> resetting the PHY will clear out any firmware setup that has happened
>> before the kernel has been booted. Again, that's a no-no.
>=20
> I am a bit confused by your statement regarding always resetting a PHY is=
 a=20
> no-no. Isn't mdiobus_register_device() exactly doing this for PHYs? Using=
=20
> either a GPIO or reset-controller.
> Thats's also what I see on our boards. During startup while device probin=
g=20
> there is a PHY reset, including the link reset.
> And yes, that clears settings done by the firmware, e.g. setting PHY's LE=
D=20
> configuration.
>=20



What he expressed is that the phy has been linked before the kernel has bee=
n booted,=20
and at this point, resetting the phy hardware will lose its original config=
uration.=20
The main focus is on fast links, resetting phy, and renegotiate

I am not sure if my statement is correct

the mdiobus_ register_ Device (), I didn't understand it either In the foll=
owing example,=20
I submitted a patch and did the same thing.

int phy_device_register(struct phy_device *phydev)
{
	int err;

	*err =3D mdiobus_register_device(&phydev->mdio);*
	if (err)
		return err;

	/* Deassert the reset signal */
	*phy_device_reset(phydev, 0);*

	/* Run all of the fixups for this PHY */
	err =3D phy_scan_fixups(phydev);
	if (err) {
		phydev_err(phydev, "failed to initialize\n");
		goto out;
	}

	err =3D device_add(&phydev->mdio.dev);
	if (err) {
		phydev_err(phydev, "failed to add\n");
		goto out;
	}

	return 0;

 out:
	/* Assert the reset signal */
	phy_device_reset(phydev, 1);

	mdiobus_unregister_device(&phydev->mdio);
	return err;
}

Firstly, I think this operation is too late.

Secondly, it was in the boot program that I did not reset my phy and was un=
able to detect it,=20
so I submitted a patch, which caused trouble for maintenance personnel.


> Best
> Alexander
>=20
>> The final issue I have is that your patch is described as "add a
>> function do *DEASSERT* reset" not "add a function to *ALWAYS* *RESET*"
>> which is what you are actually doing here. So the commit message and
>> the code disagree with what's going on - the summary line is at best
>> misleading.
>>=20
>> If your hardware case is that the PHY is already in reset, then of
>> course you don't see any of the above as a problem, but that is not
>> universally true - and that is exactly why Andrew is bringing this
>> up. There are platforms out there where the reset is described in
>> the firmware hardware description, *but* when the kernel boots, the
>> reset signal is already deasserted. Raising it during kernel boot as
>> you are doing will terminate the PHY's link with the remote end,
>> and then deasserting it will cause it to renegotiate.
>>=20
>> Thanks.
>=20
>=20
> --=20
> TQ-Systems GmbH | M=C3=BChlstra=C3=9Fe 2, Gut Delling | 82229 Seefeld, Ge=
rmany
> Amtsgericht M=C3=BCnchen, HRB 105018
> Gesch=C3=A4ftsf=C3=BChrer: Detlef Schneider, R=C3=BCdiger Stahl, Stefan S=
chneider
> http://www.tq-group.com/


