Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8717514C8A
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 16:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376945AbiD2ORu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 10:17:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234397AbiD2ORs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 10:17:48 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCB5C1A836;
        Fri, 29 Apr 2022 07:14:29 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23TBx5ph010331;
        Fri, 29 Apr 2022 07:14:04 -0700
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3fr49gu0n2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Apr 2022 07:14:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g0+/Bc68584N8SionaeD6siQIdXTB9Hk7BnjrGzguwTHs8sgHgIqQYInfXpM6VQg5WyYslmFORCEFgIBx8BT2IxiXMQbWhLzSHouqwpZE/q9JDn6wdfwpIQv4SCvBlWnPLTEG+xeYoqZNiyXQ8V3+P2QgsQPxj3WkM5GJhzjo/mWEamGHbGgubonUn4guOgBUhlbbTwlVwluEfqP5gIb4+3T17nv3GJz9Z+802mcXt6tJEqJeDKMA+4mWq9aL238lowRnCG3mlhyI2m+fPfn7by8IvUQOXXqPTF+lpsdLKRmPBl4+U/twmaNGKxEzK5A6rBTTPlNrVDRGFHJQVVxrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=593jTfVrMmf5EeRUhsGHHEAcmW/BcYHmQ2QZqDPTAqs=;
 b=dL+fF2bsWv4xC/bpLxbafvCoBxL2QM6yKVX2+AhD6PmeUOwrtXtjAyFmSK9qrQrjqxf3/ioWUQHXA7AKjd/qIpY/EDWv0yDHQ87s7fe0HHRRyp/0MW6tsK1CAlSDb4BZAVGb7Nor09AwUNgM7fVBfwZ+7cv8XM3q7d5wixBofMUGAQes8p4QxKx5BhB8kRBlA6Msmcj5utltOC5/aFc8uoBynL5AF8FS7SIpfuYMeY0qkJ7+FILVvF18PoWgxdC1WBPzHvEcP8oLUDZp+blnJf7lMalGJOYorCPAFjU438f+0LCPtt0Xyga5E4Iq7gQR4HXsyHMM7jjnh/mV0vxfOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=593jTfVrMmf5EeRUhsGHHEAcmW/BcYHmQ2QZqDPTAqs=;
 b=J5xx4gdcyzGug/72ZvpMluhau5WGPxvi2vk3Hp1QmIAu8i9GVDIo0/vY1zymgYjBo6tuJcRfJXbkeWjKPzIVnufJgiGDxVbmDYB4udRvMxr4UuEEQ6gfVzIUHuvGX1nZJwDFOe/JVMLarxV5ZGpz8wd0HeEbN7PC8N7nHRU6H9w=
Received: from CH0PR18MB4193.namprd18.prod.outlook.com (2603:10b6:610:bc::23)
 by CH2PR18MB3320.namprd18.prod.outlook.com (2603:10b6:610:2b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.28; Fri, 29 Apr
 2022 14:14:00 +0000
Received: from CH0PR18MB4193.namprd18.prod.outlook.com
 ([fe80::ddfe:2d48:80b2:4251]) by CH0PR18MB4193.namprd18.prod.outlook.com
 ([fe80::ddfe:2d48:80b2:4251%4]) with mapi id 15.20.5206.014; Fri, 29 Apr 2022
 14:14:00 +0000
From:   Piyush Malgujar <pmalgujar@marvell.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chandrakala Chavva <cchavva@marvell.com>,
        Damian Eppel <deppel@marvell.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH] Marvell MDIO clock related changes.
Thread-Topic: [PATCH] Marvell MDIO clock related changes.
Thread-Index: Adhbzq0IscPzO/F8TYquG4fv15RHuQ==
Date:   Fri, 29 Apr 2022 14:14:00 +0000
Message-ID: <CH0PR18MB4193CF9786F80101D08A2431A3FC9@CH0PR18MB4193.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 77153768-554f-44cd-6c85-08da29ea821c
x-ms-traffictypediagnostic: CH2PR18MB3320:EE_
x-microsoft-antispam-prvs: <CH2PR18MB3320B71388220E083A7A276DA3FC9@CH2PR18MB3320.namprd18.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0QbaoD4RZztv3fl2aR68Be9fekVHBFNXtkeWAtlHDaG1558Vi3fdtyC794kzaj2823bSK3HBNnWBvYDGlKt07u9L+S5gFUQZOqNOFUZ5hApc7h4dXJjXh69OUjKSLencOF4CyuvGgK0mCR1uRUPMcxoX4E85c76FNZ7gAFkV8w67NnNFZeOn0/Uvf63aklPmS2NjNeqNyAmjNQn2s/i3+3Cti9386s8uCC1We7f8sZ34fhubhXP0N6PKBBW4sMCI1TCrtLoeqAbn1ikuaklR7+zd6qCH0uRBHKgw/h+GHdkqvX0sq1b5h25y59U6s87HMPY3Djyd2jdnqb6OdyUxusVDNqWs6p2s63PWhUoD570vsW5MHexgNqXSVV8IihLx/VgOj9ixc5dK2wNWjM9qpoykui02Oh321x0nXLnw4FMejmoE4b7qjW1FomaXgLD0/3pyofIvlebDWEsfbI1AndRmKO6/69wZCMkfFnus+wyRGnk9tHyc5ZODnYOu0Qvu/Efm45u9oWO7CF5hBZwTaw1e+p9loj87uShZ1jxUQMuubC+flYU2uKmOA4/13s/ElfXIyGYmZWyDM6d0k8AZmDxuTHJZMNFmJefxra+4vsLuR7b8AlYNUBW+LGwVNLAbXbUqX4//ekRoIKoljAsmZOw/W8qGs4SRVCkAbixMHQLXBd6unCB0fYZX/n3xLFg90dJzrHXvnmmkQ3xe1WJB5Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR18MB4193.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(86362001)(6506007)(7696005)(38070700005)(38100700002)(9686003)(122000001)(186003)(83380400001)(52536014)(33656002)(5660300002)(316002)(66476007)(66446008)(64756008)(66556008)(76116006)(66946007)(8676002)(4326008)(55016003)(2906002)(6916009)(8936002)(54906003)(508600001)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XPgqctmQcuBYh1MWbuK1Pm3YQi5qde1XF+WX9WTuZZb+0Mn+ICm6TDNIfmFp?=
 =?us-ascii?Q?bTwUvbZv09ASzH24EKq2ADsaIog/lgEau+4xRkPn6WR4wyrCw4uO0DkHLxeb?=
 =?us-ascii?Q?yIvnJr7aEUTq2yk6yfMxwIMuEn1sHJ2hJ+E6jFx3gn2K/tq0PnELe4qOTt4F?=
 =?us-ascii?Q?O/2DcfQNulPm373/zEmOQiCw5xgxZgag0mhfr90qJU6Y/kS7AzmnIXhM2WGQ?=
 =?us-ascii?Q?dhjuso2J9NsUZ3ZSZWk5ek8yZfTT7ObMggL4uFMMHPfB+zpAiSmG1kun9Os9?=
 =?us-ascii?Q?M1ZuCxQu+fYse1382HxfK/Sag5oQ4Gf+dXQpCYT9WWxzwGFCZk1uCasQot43?=
 =?us-ascii?Q?UU5mEFiWIjLGkZ88TTLOFNq5u1cek4q6sHgNCvfpwMpQLBjV/tto/yVXVEIu?=
 =?us-ascii?Q?S8Pcvip8dUbNbm2Nk18dm4zJBlSx3Q1wai+dNnm9ibFxbI+lXoM/p/6zqF3A?=
 =?us-ascii?Q?ZG3C3L8fwmEGPUK/RolfMcJr3x4/dQnFQ4B8JIGpkIFDdmnTb5wBDh9eFQFX?=
 =?us-ascii?Q?A3P/r09J08lcm9swm9xHF46cvAqn5VEYTdhBcQri45f2FMXAxVCQrH9T2pue?=
 =?us-ascii?Q?NJ3nwAuGUN3Qc4cN8YduOeoewx5ln8LVgoCESwqXoQPFFpBUbBuFcqBCRd8p?=
 =?us-ascii?Q?FY9VPBdYygTDDiqteVR0ym4jAxA2b7fcm5AQnVdmDeC/h7MoaSAE8OV9oQct?=
 =?us-ascii?Q?splCiujK2TTkOqMf5GQme4W6djZZwSyraMtQLlYdwFcKAU+YWuAStqpk2QFY?=
 =?us-ascii?Q?xV8WZGcr12TiPnD/PLwTCYRfW+gW0Ar3GHiWf089jSC4mphXVOQb6+lV81Re?=
 =?us-ascii?Q?zF8JhJT8CNDeCMjiL6ZytkwgPrqxNBGHmifITOW9hJY6TIumtF0sZI7JUHzO?=
 =?us-ascii?Q?o/v+gTGB4UD3sAsTSOBoakIgrSWPyePPI2w9QDfa00i/S2ho2N07ISzsyY6l?=
 =?us-ascii?Q?gIAdmrxcHFuuqN8A/5rsXxlS4qZJ+T1V3higJ94Np1R2zr0q9yOVD7J1w90e?=
 =?us-ascii?Q?HU8iOTRbdShSxEma8H3RG32KLGitWQhPRMRzClWdOwPhtvYheMSvqQXTVekl?=
 =?us-ascii?Q?LX2xPWrS/BMRwTeWCyevsJ6a4JUGXMkj+05Xlz3ub7NGEGph1T99FkMfYOIx?=
 =?us-ascii?Q?rQEsimlJiHmMubbSmva92KJ+PWjI+bLGLYZbf6C8NL5cjKHpOIP4grECxsDj?=
 =?us-ascii?Q?cg8p1vcG1n7mV9BPOOIbfMsxBTgVS+aKJxv4CJ5+xqFpFIk/Gv7fmhgRdk1O?=
 =?us-ascii?Q?NPsE4z9ujoUH1muhjEt72tHsEyQXTYOA09hiDMqywaSSAmXKcC14/9pjHuiI?=
 =?us-ascii?Q?hhBO2YfyOUmfG2oBpadIMPw7gtCDtD0R/yWuGNIGujVI8UZ031Ic4fLqm4tZ?=
 =?us-ascii?Q?8cFpBO3E+Rj2kcv0b09nIjiRGWllDMuudCXC95UQTSdpHH1zoAcJS6jAS6lL?=
 =?us-ascii?Q?PbmIxBqqe9xfkGszS90xN7sOqpyK7EZeevhVkygQ3EOLjz0jAp3GzUoOJDEh?=
 =?us-ascii?Q?Frzh5KqJE26vajOBiyUQrEifL4TZWMWsY8eAtOP4faD9ekBqVMqxDh3PQB2E?=
 =?us-ascii?Q?1jQWC0SCwH7mr7gDcexCG1wOCEYk5Wwm6giy/NVf26UQ4pSyQ10mbdiK7iqR?=
 =?us-ascii?Q?mscPowMDQZapL5Gddu2LCqKulPDbwbwbR5NM1N6ZBYclb/XmMpXggnGKUBcQ?=
 =?us-ascii?Q?DMHU9MI+iAVUdezd4VlzTMMF4qIPCqrDm+VvE/JIrm+Awz1TOI5wtLwvJg53?=
 =?us-ascii?Q?hkV8mFvPWQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR18MB4193.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77153768-554f-44cd-6c85-08da29ea821c
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2022 14:14:00.8177
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: biWlR3OtSTqWcr2YcJDy1BvIlj3MpukzVRArEqsuHkFBO9Fd7RRV0lbjZaG3uiOuy4VjbggDQQ/BZ9A+zVkauQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR18MB3320
X-Proofpoint-ORIG-GUID: FA2a3FIxTnA-ouAsX5KcFT7g640jlaYR
X-Proofpoint-GUID: FA2a3FIxTnA-ouAsX5KcFT7g640jlaYR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-29_07,2022-04-28_01,2022-02-23_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

Firstly, thanks for your time to review this patch.

> > This patch includes following support related to MDIO Clock:
>=20
> Please make you patch subject more specific. Marvell has lots of MDIO bus
> masters, those in the mvebu SoCs, there is at least one USB MDIO bus
> master, a couple in various SoHo switches, etc.
>=20
> git log --oneline mdio-thunder.c will give you an idea what to use.
>=20

This patch is for Marvell OcteonTX and CN10k hardware, this is
different from mvebu SoCs. I will add it in subject line for V2 version.

> > 1) clock gating:
> > The purpose of this change is to apply clock gating for MDIO clock when
> there is no transaction happening.
> > This will stop the MDC clock toggling in idle scenario.
> >
> > 2) Marvell MDIO clock frequency attribute change:
> > This MDIO change provides an option for user to have the bus speed set
> > to their needs which is otherwise set to default(3.125 MHz).
>=20
> Please read 802.3 Clause 22. The default should be 2.5MHz.
>=20

These changes are only specific to Marvell Octeon family.

> Also, you are clearly doing two different things here, so there should be=
 two
> patches.
>=20

Sure, I will create separate patches in V2 version.

> > In case someone needs to use this attribute, they have to add an extra
> > attribute clock-freq in the mdio entry in their DTS and this driver wil=
l
> support the rest.
> >
> > The changes are made in a way that the clock will set to the nearest
> > possible value based on the clock calculation
>=20
> Please keep line lengths to 80. I'm surprised checkpatch did not warn abo=
ut
> this.
>=20
>=20
> > and required frequency from DTS. Below are some possible values:
> > default:3.125 MHz
> > Max:16.67 MHz
> >
> > These changes has been verified internally with Marvell SoCs 9x and 10x
> series.
> >
> > Signed-off-by: Piyush Malgujar <pmalgujar@marvell.com>
> > Signed-off-by: Damian Eppel <deppel@marvell.com>
>=20
> These are in the wrong order. Since you are submitting it, your
> Signed-off-by: comes last.
>=20
> > ---
> >  drivers/net/mdio/mdio-cavium.h  |  1 +
> > drivers/net/mdio/mdio-thunder.c | 65
> +++++++++++++++++++++++++++++++++
> >  2 files changed, 66 insertions(+)
> >
> > diff --git a/drivers/net/mdio/mdio-cavium.h
> > b/drivers/net/mdio/mdio-cavium.h index
> >
> a2245d436f5dae4d6424b7c7bfca0aa969a3b3ad..ed4c48d8a38bd80e6a169f7
> a6d90
> > c1f2a0daccfc 100644
> > --- a/drivers/net/mdio/mdio-cavium.h
> > +++ b/drivers/net/mdio/mdio-cavium.h
> > @@ -92,6 +92,7 @@ struct cavium_mdiobus {
> >  	struct mii_bus *mii_bus;
> >  	void __iomem *register_base;
> >  	enum cavium_mdiobus_mode mode;
> > +	u32 clk_freq;
> >  };
> >
> >  #ifdef CONFIG_CAVIUM_OCTEON_SOC
> > diff --git a/drivers/net/mdio/mdio-thunder.c
> > b/drivers/net/mdio/mdio-thunder.c index
> >
> 822d2cdd2f3599025f3e79d4243337c18114c951..642d08aff3f7f849102992a89
> 179
> > 0e900b111d5c 100644
> > --- a/drivers/net/mdio/mdio-thunder.c
> > +++ b/drivers/net/mdio/mdio-thunder.c
> > @@ -19,6 +19,46 @@ struct thunder_mdiobus_nexus {
> >  	struct cavium_mdiobus *buses[4];
> >  };
> >
> > +#define _calc_clk_freq(_phase) (100000000U / (2 * (_phase))) #define
> > +_calc_sample(_phase) (2 * (_phase) - 3)
>=20
> Please avoid macros like this. Use a function.
>=20
> > +
> > +#define PHASE_MIN 3
> > +#define PHASE_DFLT 16
> > +#define DFLT_CLK_FREQ _calc_clk_freq(PHASE_DFLT) #define
> MAX_CLK_FREQ
> > +_calc_clk_freq(PHASE_MIN)
> > +
> > +static inline u32 _config_clk(u32 req_freq, u32 *phase, u32 *sample)
> > +{
> > +	unsigned int p;
> > +	u32 freq =3D 0, freq_prev;
> > +
> > +	for (p =3D PHASE_MIN; p < PHASE_DFLT; p++) {
> > +		freq_prev =3D freq;
> > +		freq =3D _calc_clk_freq(p);
> > +
> > +		if (req_freq >=3D freq)
> > +			break;
> > +	}
> > +
> > +	if (p =3D=3D PHASE_DFLT)
> > +		freq =3D DFLT_CLK_FREQ;
> > +
> > +	if (p =3D=3D PHASE_MIN || p =3D=3D PHASE_DFLT)
> > +		goto out;
> > +
> > +	/* Check which clock value from the identified range
> > +	 * is closer to the requested value
> > +	 */
> > +	if ((freq_prev - req_freq) < (req_freq - freq)) {
> > +		p =3D p - 1;
> > +		freq =3D freq_prev;
> > +	}
> > +out:
> > +	*phase =3D p;
> > +	*sample =3D _calc_sample(p);
> > +	return freq;
> > +}
> > +
> >  static int thunder_mdiobus_pci_probe(struct pci_dev *pdev,
> >  				     const struct pci_device_id *ent)  { @@ -
> 59,6 +99,8 @@ static
> > int thunder_mdiobus_pci_probe(struct pci_dev *pdev,
> >  		struct mii_bus *mii_bus;
> >  		struct cavium_mdiobus *bus;
> >  		union cvmx_smix_en smi_en;
> > +		union cvmx_smix_clk smi_clk;
> > +		u32 req_clk_freq;
> >
> >  		/* If it is not an OF node we cannot handle it yet, so
> >  		 * exit the loop.
> > @@ -87,6 +129,29 @@ static int thunder_mdiobus_pci_probe(struct
> pci_dev *pdev,
> >  		bus->register_base =3D nexus->bar0 +
> >  			r.start - pci_resource_start(pdev, 0);
> >
> > +		smi_clk.u64 =3D oct_mdio_readq(bus->register_base +
> SMI_CLK);
> > +		smi_clk.s.clk_idle =3D 1;
> > +
> > +		if (!of_property_read_u32(node, "clock-freq",
> &req_clk_freq)) {
>=20
> Documentation/devicetree/bindings/net/mdio.yaml
>=20
> says:
>=20
>   clock-frequency:
>     description:
>       Desired MDIO bus clock frequency in Hz. Values greater than IEEE 80=
2.3
>       defined 2.5MHz should only be used when all devices on the bus supp=
ort
>       the given clock speed.
>=20
> Please use this property name, and update the binding for your device to
> indicate it is valid.
>=20

Yes, the property name and binding will be updated in V2 version.

> > +			u32 phase, sample;
> > +
> > +			dev_info(&pdev->dev, "requested bus clock
> frequency=3D%d\n",
> > +				 req_clk_freq);
>=20
> dev_dbg()
>=20
> > +
> > +			 bus->clk_freq =3D _config_clk(req_clk_freq,
> > +						     &phase, &sample);
>=20
> There should be some sort of range checks here, and return -EINVAL, if as=
ked
> to do lower/higher than what the hardware can support.
>=20

In _config_clk() function, the clock will be set to the nearest identified =
value to=20
the requested value.

> > +
> > +			 smi_clk.s.phase =3D phase;
> > +			 smi_clk.s.sample_hi =3D (sample >> 4) & 0x1f;
> > +			 smi_clk.s.sample =3D sample & 0xf;
>=20
> You indentation is messed up here. checkpatch would definitely of found
> that! Please do use checkpatch.
>=20
> > +		} else {
> > +			bus->clk_freq =3D DFLT_CLK_FREQ;
> > +		}
> > +
> > +		oct_mdio_writeq(smi_clk.u64, bus->register_base +
> SMI_CLK);
> > +		dev_info(&pdev->dev, "bus clock frequency set to %d\n",
> > +			 bus->clk_freq);
>=20
> Only use dev_info() for really important messages. We don't spam the kern=
el
> log for trivial things.
>=20
>        Andrew

All the rest of the comments will be taken care in V2 version.

Thanks,
Piyush
