Return-Path: <netdev+bounces-1192-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 09DB36FC8F7
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 16:27:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AB5F92812F3
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 14:27:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 803AA19525;
	Tue,  9 May 2023 14:27:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E7A8182D9
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 14:27:42 +0000 (UTC)
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01olkn2037.outbound.protection.outlook.com [40.92.107.37])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B8922709;
	Tue,  9 May 2023 07:27:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j6bABV7ZKeUoP5uIcBPgIiJh1St4fzilOzOnnaYgwwOmyuvahUVLezzrlzLPD0Ly6SnW5zDxi3ZXRFB+KVuB1yU+iUpSj3poaSRJrmVFztE04MKqBMWSstjuIFOqDl+M7RPhIUZ2nqlaA5+Wr/kIlCmIDFVXhMeqQMu7Ba2eSh0dWo4gIwZF6VHqnzuMvMxgNhUfzyQd1bvG85GoLP6QFicyUyEe6ZiO+Qmj0VG6wi9eUnJlVt70JqKCKPnZk/nnWXaumXW4qUghCREkeP/ol7oikbTFRaUr1lX8sREcARj31DjlxF54pGEE9EILtA2r6OOEnUqaBimD3lZ4iLgqrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P2oEnxiLwbgB2bAr3Kvzct2z8lRg1fw7dDXJ8ENEM+c=;
 b=J580F/fb22kntsYR+02Xr3KHTdsJf8RftiHX/GUK54voNA3SoN38aLKnHau782TnPWfW0FO0q+lKvDVx1Vu6kyqGw6Jepc+t0kBNHejYU/Ch1PjnCW/EjA3ZNoVXXvzXHPOqeWDsllWNiNkbU/YLnX6piYYXAhKKFZl/83t0T0puxzIw6rm++Mi9wAeJeKuprzrcdprGIELN+ynLwM5+HTCbE/+38LWhBjsWcblpnbDquMAwNrvbqxGKnr/CscagdU22eE1k7MqB/SxuABRDWlOLjOtOlWJq11OoJlV1VZ4kIoDCSI3aknd/DR9g8Mz3Dc/C28Ca0zDJ+a7tf0IJkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P2oEnxiLwbgB2bAr3Kvzct2z8lRg1fw7dDXJ8ENEM+c=;
 b=hzTwr2HxsDKnXNiSdlq3M1c1sRAMaby7LxWdi+5lyGmlmIlo8oMb1XNJHJj9TjBe6ruWY7HcUMAvZUiuFfu5tT9eqV0FIFj6+ExkkE/3o/aI7qZEDyOfA9hr2MkwrPmznt023/CogiHo8JABqB3pPd/luzyjerbNnWWRDG++tFOlEFqZVMX3jAxzriOiBU1ElOYCHMoTllTMQQqw7jZND+yPSa7VZVP5fGx8t/FJEmpTIZZmR9Ktiw3JsWEkq8YFLIZm6Vv9fvcrXh2SsB9UsHfNgWdPS6FMRpWrUtr3McW4b2wlrB5ezCJemOzEypBP4mvFs1R8wYv7v1Y29GNwnQ==
Received: from KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 (2603:1096:820:9a::12) by SG2PR01MB3707.apcprd01.prod.exchangelabs.com
 (2603:1096:0:6::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Tue, 9 May
 2023 14:27:30 +0000
Received: from KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 ([fe80::1ff1:2f4e:bc0:1ba9]) by KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 ([fe80::1ff1:2f4e:bc0:1ba9%3]) with mapi id 15.20.6363.033; Tue, 9 May 2023
 14:27:29 +0000
Content-Type: text/plain;
	charset=us-ascii
Subject: Re: [PATCH v1] net: mdiobus: Add a function to deassert reset
From: Yan Wang <rk.code@outlook.com>
In-Reply-To: <96a1b95e-d05e-40f0-ada9-1956f43010e0@lunn.ch>
Date: Tue, 9 May 2023 22:27:23 +0800
Cc: hkallweit1@gmail.com,
 davem@davemloft.net,
 edumazet@google.com,
 kuba@kernel.org,
 pabeni@redhat.com,
 netdev@vger.kernel.org,
 open list <linux-kernel@vger.kernel.org>,
 linux@armlinux.org.uk
Content-Transfer-Encoding: quoted-printable
Message-ID:
 <KL1PR01MB5448457F0E0DE81BC01BC8CAE6769@KL1PR01MB5448.apcprd01.prod.exchangelabs.com>
References: <KL1PR01MB5448631F2D6F71021602117FE6769@KL1PR01MB5448.apcprd01.prod.exchangelabs.com>
 <96a1b95e-d05e-40f0-ada9-1956f43010e0@lunn.ch>
To: Andrew Lunn <andrew@lunn.ch>
X-Mailer: Apple Mail (2.3696.120.41.1.2)
X-TMN: [shHV7fi7nAOEswwcnmTy9m5hu/O7o1KT]
X-ClientProxiedBy: TYCP286CA0064.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:31a::11) To KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 (2603:1096:820:9a::12)
X-Microsoft-Original-Message-ID:
 <0562CD4B-0BA5-4223-8FB0-9A074E2AF2D1@outlook.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR01MB5448:EE_|SG2PR01MB3707:EE_
X-MS-Office365-Filtering-Correlation-Id: 843ecea4-38a4-4f81-40a7-08db50998520
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	9v4vSFqfO1f/ZPNiYLKohgXo6XCrDduKKJx6R9k5vMlVTO0zdnsaCEXxWq+nDGeYeTPntfVU8g+7/3wObeuaiYQOBt0BOB8T0vp5PYK7K9Wp0HnkMQ+eP1Ycl27vZ6waW60gKSZMn4hP41iE2DSnRhX2krVi42YA4rpK5jh3wHvDlajdejak1V6vDMg7iMBtogkk+rbvmqGuaojoEkEQBFJeMa/OXo+vb8pm+vk9uDxT6uSESwa6QOTyrcqzoPl4fej4OZ6e+AFGPtOeTpEDIRrcLo9DMs8VDFN/7Vny/7XNqHbeSczFNKAI0B9bA/KI0QmISb6JKcio19eLKpPRgr/nskhp3MbR5sn/3sXOKk4es7Qfpj7xIBLOx9hotaSQa2z5uamY4FTlmo+sDZ4Jm2gK4/TqxVr+yWbO0gFXxCvDsji7lg7dPHBudooaEDhPvl2DnLQU+ffHiS5ar8fO+eQD5M4hkNvoUXJ0n/J0yCzOLWI6wXCRaUdWeD+3V5h8BFJrf+LJ/eCGVCX8KTZEYuhPLbey8WGwgBMOolYeQX+aTRL86ZCiY5m2lTpyyGU/M0TLb9NQjtqDgKsx+5mIN6QuAYqc+ha2QC7+Jc4E+EBqPACy339KbvFrIRT2+g15
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ya84Njsp8rWFEjT6sPou2fz9COYbitOqgpFJCZ1IVdTGL0A6yYzBPd5Y3clk?=
 =?us-ascii?Q?+1gjhX/Dnboes4lmnfvoI/0Lw6qRwF92SgwcqANds34BVW2WGACzPB+ZMtdf?=
 =?us-ascii?Q?HxbVfacXOToo0Ex1mKiwMiW8wgRVGCHOOl3ojuGxz1+X6cUiCCXbY7a/WZFd?=
 =?us-ascii?Q?JQqjNBEWOiTXJkPs8/9Anp4CBYoQDK5Vijm7R5riupw1U7+4XWp7PWf+QU3G?=
 =?us-ascii?Q?swC3EMvEEuCNWuVB4V+3FZVWVaFhOEdz0ZG9x992S5ljK7hQxSkIL1dHI8bR?=
 =?us-ascii?Q?em5xzmfuNOSlYwxdAFM+l9XPVdeB77+DHuzA0syu9PwL02Nd3RiqK7esIFeK?=
 =?us-ascii?Q?3kKI1x+DO6RH7AoiEdhFDIZLnasa883h3DzhG3J8VQ75QQb3pMkv5x4aS7BQ?=
 =?us-ascii?Q?5+65FF220V6bwby/Xp5E6YBodJ7ZfAcCiq3bUnuzEoaj9Kb4u8o0T6vpLVCO?=
 =?us-ascii?Q?5VHJfqjrgjthGjyjpyQRUZ/MK8njmNAxiGLRf2pajSRfdHzUqWL0peAbz0vk?=
 =?us-ascii?Q?GXlzsLWA8LQiloaxJuemKQQswqzsQkvI/KKSquqhowu7ef7U3SJNbwWQ+M7K?=
 =?us-ascii?Q?lbLE32IB6fwwczuWWGamSvPn2RKvuvrDuFVM5N7vchN9X/V7U7qK2RhmAn4F?=
 =?us-ascii?Q?V4C6+NhDII/lfTJzTDL3WUXvqYbvRyBJTNxitJVLaqNH504MdiZFDTIwjh8j?=
 =?us-ascii?Q?FgdrfJcIAT71eX+KUCAkYnfnF104oRhv/KEtoVRdM79uLnlaRuwc4uTc+RNc?=
 =?us-ascii?Q?40kkSKpTxkP4So/kmFqBUpxw2sg5hW0dqEqQJrEn5ya4SVOOBOE7gjAcHTTr?=
 =?us-ascii?Q?SK6bFnjeMhMft0apn9inJXLvY7PAvr1HusX4Ijzpmgh404VDHrXSAbPF+4gz?=
 =?us-ascii?Q?Zzkk3s/11aHBK6vofEIHXrl1WkYIpiaLgz5GMxeyphPwsf6Tg7ToaLMHW9Rt?=
 =?us-ascii?Q?jr015BLqyOf63YQMf8nWhPoHExJc4gaaXmtdeYi1d4+iB6V0pIu3lWjOuMdL?=
 =?us-ascii?Q?q4vRy9igWRHsCSEEh2G0jyzvoLl5tnU4LXQFFGq/uUcgQkx5TPz1YJbqC9hP?=
 =?us-ascii?Q?VNsHCfx0GwUsZI5qBtfHOIgOdPAIf9pOAFJ00UHH3pq1q+QhZbJQA/rH2kZI?=
 =?us-ascii?Q?iK4FoUhip01YhcNnKU8X9pwmIJwT+CnA05UaG5NFI8pyrjfkrbgJS3Q19Igc?=
 =?us-ascii?Q?8rEWcSp6aWHrqEcpdjAWOio+yiseK2UffaRDkg=3D=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 843ecea4-38a4-4f81-40a7-08db50998520
X-MS-Exchange-CrossTenant-AuthSource: KL1PR01MB5448.apcprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2023 14:27:29.8509
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2PR01MB3707
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> On May 9, 2023, at 20:22, Andrew Lunn <andrew@lunn.ch> wrote:
>=20
> On Tue, May 09, 2023 at 06:44:02PM +0800, Yan Wang wrote:
>> Every PHY chip has a reset pin.
>=20
> Hi Yan
>=20
> Experience has shown that very few PHYs have controllable resets. So i
> would not say every.
>=20

> the state isn't
>> sure of the PHY before scanning.
>>=20
>> It is resetting, Scanning phy ID will fail, so
>> deassert reset for the chip ,normal operation.
>=20
> Please look at your white space in both the commit message and the
> patch. No space before , but after. Spaces between words etc. More
> blank lines are common in code to break up logical sections etc.
>=20
> "While in resetting, scanning of the PHY ID will fail. So deassert the
> reset for the chip to ensure normal operation."
>=20
> What you are missing is a delay afterwards. Look at the DT binding, it
> lists optional properties to control the delay. And if there is no
> delay specified, the code which will later take the GPIO inserts a
> delay.
>=20
Incorrect description caused your misunderstanding.

On my customized board, multiple phy devices are mounted on the mido bus,=20
and there are multiple pins on the hardware that control these phy devices.=
=20
These pins default to low level, so these phy devices are in a reset state,=
=20
so they cannot scan IDs.Therefore, I need to raise these control reset pins
to make the phy device work properly.

Can I resend a v2 patch?

Think you.
>>=20
>> Release the reset pin, because it needs to be
>> registered to the created phy device.
>>=20
>> Signed-off-by: Yan Wang <rk.code@outlook.com>
>>=20
>> diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_md=
io.c
>> index 1183ef5e203e..8fdf1293f447 100644
>> --- a/drivers/net/mdio/fwnode_mdio.c
>> +++ b/drivers/net/mdio/fwnode_mdio.c
>> @@ -11,6 +11,7 @@
>> #include <linux/of.h>
>> #include <linux/phy.h>
>> #include <linux/pse-pd/pse.h>
>> +#include <linux/of_gpio.h>
>=20
> These includes appear to be sorted.
OK, I will modify it.
>=20
>>=20
>> MODULE_AUTHOR("Calvin Johnson <calvin.johnson@oss.nxp.com>");
>> MODULE_LICENSE("GPL");
>> @@ -57,6 +58,32 @@ fwnode_find_mii_timestamper(struct fwnode_handle *fwn=
ode)
>> 	return register_mii_timestamper(arg.np, arg.args[0]);
>> }
>>=20
>> +static void fwnode_mdiobus_deassert_reset_phy(struct fwnode_handle *fwn=
ode)
>> +{
>> +	struct device_node *np;
>> +	int reset;
>> +	int rc;
>> +
>> +	np =3D to_of_node(fwnode);
>> +	if (!np)
>> +		return;
>> +	reset =3D of_get_named_gpio(np, "reset-gpios", 0);
>> +	if (gpio_is_valid(reset)) {
>> +		rc =3D gpio_request(reset, NULL);
>> +		if (rc < 0) {
>> +			pr_err("The currunt state of the reset pin is %s ",
>> +				rc =3D=3D -EBUSY ? "busy" : "error");
>=20
> Please correctly handle -EPROBE_DEFFER. The GPIO driver might not of
> probed yet. The gpio maintainers are also trying to remove the gpio_
> API and replace it with gpiod_.
Ok,I will modify it.
>=20
>> +		} else {
>> +			gpio_direction_output(reset, 0);
>> +			usleep_range(1000, 2000);
>> +			gpio_direction_output(reset, 1);
>=20
> This is actually putting it into reset first, and then taking it out
> of reset. We want to avoid that. it forces a new auto-neg cycles which
> takes a little over 1 second. Phylib will try to avoid forcing an
> auto-neg so you get link faster. If the PHY does not need to be
> reconfigured it won't be and the result of the auto neg can be used.
Is the delay too long?=20

The phy reset pin is got  and pulled up in mdiobus_register_device().
Auto-neg is meaningless! Phy does not have a matching driver.

> 	Andrew


