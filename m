Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC096CFD3C
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 09:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbjC3Hqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 03:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbjC3Hqr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 03:46:47 -0400
Received: from outbound-ip23b.ess.barracuda.com (outbound-ip23b.ess.barracuda.com [209.222.82.220])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77F0A59C0
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 00:46:27 -0700 (PDT)
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2044.outbound.protection.outlook.com [104.47.51.44]) by mx-outbound20-128.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Thu, 30 Mar 2023 07:46:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BX+83JXmHBOOSiVvUt2Pa76WBiC2g3POtkL3EsvwgRroYOLwzpUmvKgbaA080mHhbxpu95ScnxXM+X8aUpP46NYz6s3DN/EhNys6KsiTIRkUXQGODsnPr4jCV4LikAje09mOVzIZto4ZWUWnMk2S/de0qbi4XIEd9fILB36B3uyG6/qCJwEk8ICDyVW2/sydr/PLAyYxYcykEQ1nPGXg1pIUgZPGHpa/8GaBnZdgItnzX8LEAKSaJwF7EQTj4pnHqSWWEmjvnm2AmGOGtuNumH6ZOZCcdSGM+/OS5GQ0Tr2IKrepeiWQgtTPJKwgSjDlEKUOsWG8aOiGatVVc5JtbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jFw0YtW8kS3qIpSoh4oiMDj+RB/lgcRLkNX9s+KzWp8=;
 b=YWAJO8dRmR5Yr/HQyS7+jWRKixu8ark5rYbaFqpergoODAJU48bpRsuoGZFxiT3yv/uWBtZLmahrx8ez6pJFkZ4x2C9qDmQom0vQmYmnsYmDra2F6PVXwXmtb8pDGg5pY6C3OutZE1cFjyawrvcCYKwQzcBdoQIjMFZGHVLpAptnFFJxK/qAE3LTujtdDrsY4b7SZz9KYCOJr/bNBxxbL7JlYfyCsv1FGRrAvik0LHEB6HS2kNwvIXABDLblghJt/XfZdSq+K1F6hIhrTiMOcBrhsQ1k57UQHiQg5vLMrxyLUYS/GDIt1rUR5Htrekds9Ch5wTnUrhFfczlSzGC73g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=digi.com; dmarc=pass action=none header.from=digi.com;
 dkim=pass header.d=digi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digi.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jFw0YtW8kS3qIpSoh4oiMDj+RB/lgcRLkNX9s+KzWp8=;
 b=Imgjzv4L8mV/OutgK9cUdmkAqG6IYlgzGJhXsHtR5IZM737W73kGxw+dsPc9W5L2BEjigAtz2EtfPSpJy52O6F3Rk2HZZjDvVcyIN77yzclp+zVg5Hoge6naIjtzEvLqG1orrSsDys8n9xlw+b/J9TjEZw5SlO0kAhsDEgknnUjb286h769itSOXDbF32XzzReJejLxcPzUuLL2LKDnJo0fzw2K/e88UneoKrJE4B4E903jZ0zCTS7Mz8R1oeQAsTWFn9GIbpQPb7mIkWHIv1ICrQ3jNroyY96cvc0RcFaEhB64l3xQ/Wc0EK4Cgo/dKl8Idrs/0nHskHyGc0PQWjg==
Received: from DS7PR10MB4926.namprd10.prod.outlook.com (2603:10b6:5:3ac::20)
 by BN0PR10MB5063.namprd10.prod.outlook.com (2603:10b6:408:126::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.35; Thu, 30 Mar
 2023 07:46:14 +0000
Received: from DS7PR10MB4926.namprd10.prod.outlook.com
 ([fe80::9ee4:1e8a:76b6:959b]) by DS7PR10MB4926.namprd10.prod.outlook.com
 ([fe80::9ee4:1e8a:76b6:959b%2]) with mapi id 15.20.6254.022; Thu, 30 Mar 2023
 07:46:13 +0000
From:   "Buzarra, Arturo" <Arturo.Buzarra@digi.com>
To:     Russell King <linux@armlinux.org.uk>, Andrew Lunn <andrew@lunn.ch>
CC:     Heiner Kallweit <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: RE: [PATCH] net: phy: return EPROBE_DEFER if PHY is not accessible
Thread-Topic: [PATCH] net: phy: return EPROBE_DEFER if PHY is not accessible
Thread-Index: AQHZWP1FSdAaHxazwkKnE2fAhKZFWq8DUXYQgABD0YCAAEfQAIAEldqAgAAEhICACodbAA==
Date:   Thu, 30 Mar 2023 07:46:13 +0000
Message-ID: <DS7PR10MB4926A59970F3DEAE76542FFFFA8E9@DS7PR10MB4926.namprd10.prod.outlook.com>
References: <20230317121646.19616-1-arturo.buzarra@digi.com>
 <3e904a01-7ea8-705c-bf7a-05059729cebf@gmail.com>
 <DS7PR10MB4926EBB7DAA389E69A4E2FC1FA809@DS7PR10MB4926.namprd10.prod.outlook.com>
 <74cef958-9513-40d7-8da4-7a566ba47291@lunn.ch>
 <DS7PR10MB49260FFA60F0B3A5AB7AD69EFA879@DS7PR10MB4926.namprd10.prod.outlook.com>
 <156b7aee-b61a-40b9-ac51-59bcaef0c129@lunn.ch>
 <ZBxjs4arSTq4cDgf@shell.armlinux.org.uk>
In-Reply-To: <ZBxjs4arSTq4cDgf@shell.armlinux.org.uk>
Accept-Language: es-ES, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=digi.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS7PR10MB4926:EE_|BN0PR10MB5063:EE_
x-ms-office365-filtering-correlation-id: 62ec3570-0bf2-4b1a-5b31-08db30f2d62a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VhX+m2FbcqK7t5H3atsM0u0+A/o8pix6hcOksiEXyy0U+hB7Vnc199yECi4fTRQ5mKhUJu5UalUMRejii31fCW4d/T4af9wPScX6XtdjuM6S4Z4FxjOu7JDvkopl6BwzbOUDjj9ZZLgc+939WouxjUijqUcqMEdPTypHk0LpTUvPphdEsRVxNHPDZ9d4g1iy18+UFDAaktB20KdkJJbcDH7cAnfj8Fj0RrBYT7VHbq7mLEgySayebsh/riFXHMOrhF4k2hdclWHlqFtF/Nb0Mvhv7DTGjh5MpxayBg9PeGblUWe5PslShI15zRiCzJGGGB/vfhR+aoEzE5Y0B+E7sicxG5C2GZm6eayIIl/cmI3PuihDUS9ZYibMZA6ohfXn8bj4gMkDoVRagk6Cjh/V4hP7v58cMzEh15Dq9SDX9RL53SaEZ8R7KNkf5mC19Z1S6pTmNgI0uvtECCkST7cNyVaJccAT6qu66VuUdlzqtzI5tLuWZfiCpUD343eVGfBV9/Imjhxyc0XVMcUE9JiAeQI8rfCVZudQcNFbbo0NWOk5f3fpTesqQ1r4bET4E84YbNbJ9fsDQym3gO1VyBhcZGyWvnr1D4AXa00x+1+7QXo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB4926.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(376002)(346002)(366004)(39850400004)(451199021)(66556008)(122000001)(53546011)(26005)(186003)(38100700002)(966005)(5660300002)(8936002)(33656002)(2906002)(76116006)(66946007)(54906003)(478600001)(110136005)(316002)(7696005)(71200400001)(55016003)(86362001)(64756008)(41300700001)(4326008)(52536014)(9686003)(6506007)(8676002)(66476007)(66446008)(38070700005)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?f3DSF5/jzAQY3vBMKujlM9DgNkUiOFh9zluILpzyRnRY64en52MOtifjG/tz?=
 =?us-ascii?Q?VMy7OBoHBZrG3SWKbM+fU1Xq88mgNwlzEvspyWffQRLedwhL7ppvk7buEO4R?=
 =?us-ascii?Q?yyijdcX+pzQm8k3WxM95zh42oNJGCZI3Zg5S9MoIxKq3+x3ifqoc08OwazUe?=
 =?us-ascii?Q?EgDyi3iO5raLGbMFdnDDMt33JF8jNCO//sdb2+BKvyKDRNlZwI0K2q9sscva?=
 =?us-ascii?Q?h2LfEfRX8gQm57XTl0h28idX8GIQHPk9stp5+qZzQc/afCJInvlL8c2yIYr6?=
 =?us-ascii?Q?1p/UBkPZo1eJRq0Ilcn0SaUSUgABePnZAxER+0x1ocVaS2JvCbPFxXKip+g4?=
 =?us-ascii?Q?/c3cEJ78/v7Uu4WUNbovKfrwkwFrVpfcHfZY4DF7sD89GTtoX5AwwvdiTSIS?=
 =?us-ascii?Q?TD5dqxzPemrc0MTSZx/MVeuha550UUF7SwmfpfJ5CPlrfxett82FzIMEJSjM?=
 =?us-ascii?Q?ILGBeIxczXv9JuP5OkG5cMRve5CKSGtUWSFfoVtCyp6zd+IiatcPYwVXyP/Q?=
 =?us-ascii?Q?Me/JfSG5Ly+RWyWgypdpea6Yj7OjQsAV4uUVCMgDPQOjRMJ/dIhCSdn/8MXB?=
 =?us-ascii?Q?7kCzw4W5js33YIlnq6aMg+vIXCVSHHqQJiPA+A1MJ2YI75T7oBN6yln6qo68?=
 =?us-ascii?Q?MGcKF4lWDyTJu7hapvnaxOWYPDQzGG0uBN2H5+51bxZvAEt5eMuGX/IvZic3?=
 =?us-ascii?Q?7kBaI+p9zMKaq9/yA2AjPQycedkowIpR3c4Ole0HWATDP52Iix+IvhCmi0u7?=
 =?us-ascii?Q?wFcWbVfiLGpO0boizpugwzw0TkePlZmy3kUjmeTEkTqgLdug3WPIrEz6/qXn?=
 =?us-ascii?Q?tMhiRgJVDuI4wbkxMJEXrftuj1EP0hEpU5vxDF/5583iYdQIf99w6TGGDfeC?=
 =?us-ascii?Q?Q5LBNExR9aMWGrTqtx9GOcW+MUwvCzj4Ar1LLefPBtwYyZPAKr7351VFl3O2?=
 =?us-ascii?Q?QId6DPHwCsRniRPgLBPVs5+WlLCVBKlcD3Wt9S9kib0dKaisjqT0M9IdVnFn?=
 =?us-ascii?Q?BRzrdPh2MYjBQfLXb5bEPu96TPOoqmnoUCvQPGwnfpOPl3nnkRg+gV+cdl4Y?=
 =?us-ascii?Q?DjD+l0U8gj8b86GwRt6ZWVEMYayxfJ+o/dNMpWO8QJpEQw4vwcDjBjMjOMQV?=
 =?us-ascii?Q?0XmPF/pc8U7oX/ZQ9iuneb1J4hlG2OKkvhDg8onRCY15qU7XSFhn/HCFEbsh?=
 =?us-ascii?Q?rSrN3WSom9mbhn9aP/U3HpwDwpvhfk82cfq0N6s4o+ouMnbgugBEj0O+bO2b?=
 =?us-ascii?Q?oE+U+jqM6egytFb1gY9MfiasNgUFu+P6yV17dsRvzoFaYlxGHuWzEOmeq8jO?=
 =?us-ascii?Q?pCnZ852X3TAyuRKEB/k50XafPs0BVbZygXIk9RXdxUJgRh4khAJELu5t9p7T?=
 =?us-ascii?Q?oWOQhONqlMk0mZW/8GJA21RZvKjeb4NspSJzM8WYRWB29tBGj1RednoCd5lF?=
 =?us-ascii?Q?w7FsJyzpJ+JRWo0l9CrA18fQ+jHmAXa6Rq15PIg1uzwe88Gp2WLPKegMjduR?=
 =?us-ascii?Q?zVw5KM1SJijYZ/8CV8uHQDsNT6SnCzK19xRa/rgVBL6xZvhToAA7DmtYchUb?=
 =?us-ascii?Q?gmbQeJ6v33+l8BjmRyfsjyR69dDQhHUSoF1HnvFB?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: digi.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB4926.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62ec3570-0bf2-4b1a-5b31-08db30f2d62a
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2023 07:46:13.5826
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: abb4cdb7-1b7e-483e-a143-7ebfd1184b9e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8/85RRZJPCfkmEtwvvreZiqnN82aNkDJ4m/elmyog8VxuYWdxRckNKv5UwUrzGIn9khyTH5U0LPiEsg1NH3nrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5063
X-BESS-ID: 1680162378-105248-5457-51819-1
X-BESS-VER: 2019.1_20230317.2229
X-BESS-Apparent-Source-IP: 104.47.51.44
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVkamFkZAVgZQMNHMKNXMwNgyNT
        XJ3MzIzDjVwDTJ0MI42cDc1DzZ0NJAqTYWAPXsuTdBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.247140 [from 
        cloudscan22-191.us-east-2b.ess.aws.cudaops.com]
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------
        0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS112744 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status: 1
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

" Which clock is it exactly? Both for the MAC and the PHY?"
Yes, you can clock both from a crystal or like in this case from the SoC.

" Is eth-ck being fed to both the MAC and the PHY? Is this the missing cloc=
k?"
Yes, It is the clock that only is available when the second Ethernet MAC (R=
MII) is initialized

" What exactly is this clock?"
This clock cames from the SoC, it is initialized in stm32mp1_set_mode() wit=
h the register value " val |=3D dwmac->ops->pmcsetr.eth2_ref_clk_sel;"

" Maybe meson8b_dwmac_register_clk() is a useful example?"
After reviewing your suggestion, I saw that the MAC driver "dwmac-stm32.c" =
doesn't have devm_clk_register(), so I'm assuming it doesn't register it as=
 a clock provider.=20

I will try to work on that way to create a clock dependency between MAC and=
 PHY.

Regardless, what do you think reading 0x0000 or 0xFFFF should be considered=
 as a PHY error?

Thanks,

Arturo.

-----Original Message-----
From: Russell King <linux@armlinux.org.uk>=20
Sent: jueves, 23 de marzo de 2023 15:36
To: Andrew Lunn <andrew@lunn.ch>
Cc: Buzarra, Arturo <Arturo.Buzarra@digi.com>; Heiner Kallweit <hkallweit1@=
gmail.com>; netdev@vger.kernel.org; Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH] net: phy: return EPROBE_DEFER if PHY is not accessible

[EXTERNAL E-MAIL] Warning! This email originated outside of the organizatio=
n! Do not click links or open attachments unless you recognize the sender a=
nd know the content is safe.



On Thu, Mar 23, 2023 at 03:19:21PM +0100, Andrew Lunn wrote:
> > Gigabit PHY has its own Crystal, however the 10/100 PHY uses a clock=20
> > from the CPU and it is the root cause of the issue because when=20
> > Linux asks the PHY capabilities the clock is not ready yet.
>
> O.K, now we are getting closer.
>
> Which clock is it exactly? Both for the MAC and the PHY?

Just a passing observation but... considering stmmac needs the clock from t=
he PHY in order to do even basic things, it doesn't surprise me that there'=
s a PHY out there that doesn't work without a clock provided from the "othe=
r side" to also do the most basic things such as read the IDs!

Hardware folk always find wonderful ways to break stuff and then need softw=
are to fix it... :/

That all said, if the clock that's being discussed is the MDC signal (MDIO =
interface clock) then /really/ (and obviously) that's a matter for the MDIO=
 driver to ensure that clock is available to run before registering itself.

--
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
