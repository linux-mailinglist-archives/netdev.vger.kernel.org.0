Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0A954592D0
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 17:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239659AbhKVQRi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 11:17:38 -0500
Received: from mail-bn8nam12on2099.outbound.protection.outlook.com ([40.107.237.99]:20673
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239636AbhKVQRg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 11:17:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WDKx4+/uFH0BQPXpg4P0NXxw/h64QaSTIs3lv9fvosPIWzFIyDbFngt/vLystA3bRRRgId2HIyvf12lKctlu9pgZz2bk9HhJkmGBY6Yf977odfQ99USVxHmVZOkKB+VYW6pxIILrbW7m+Bvh6cQIiDoy+3T1pG6V2tSmGzNuTjnaH/Rjs4TJi8ZOtH07NUddEwCVFEriDg6Tq8UFQExkv9kLYc6l0jMCi0OTosEZdKxo8QfKyaowIruOK6dkC6nld5AF/PDcSmGMKCHLgyWuhXZX/iSpbRddOqXk1zk5ogHUwZUSYW/RvdJ0Tmvk9JnfqDp4G79lIOjsbMEtLnhNpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bSUDphBeQIDy5Wz7poK6DQUDLQ7FEWxq1UaHQTF9oL4=;
 b=IXClZ6ezROYKm/oPKww7cwBgIZ47IfQpC+JPQ+zFZY9wN1SIUjAZxAJ+HTk9G9N61Bpi8sDY5yWiRTXa0JzJ7ypsrPeDN2CYZyCueA+5TlMg+3YjksSQU75iT396+xXdUm++OGgzUVjqWF2jvEd+NoXtIimcDOaqVVLtwAbj4R051ed1I+XyBPiY37txyCMkRVT9G06qRXS/0KT4rRJW+7tdlZi52jQ1jfvHgwkrhikbbisgDcwA7eOlOAiIzl98AM9FJ9seD8Ow82bn32u2/TgPcNacYLhWlLrxBUE03zJOrxhIpeWkM2mAha7n/lJvw0nopBQ0HoD8sQL51a4duw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bSUDphBeQIDy5Wz7poK6DQUDLQ7FEWxq1UaHQTF9oL4=;
 b=kztPRx8DKRX6WVBH7XICAoBzWuVZz0cSkyTJIneljFId6PoIJO0Re0fGxeqdq3nkDHdCzbq4KddPUpfm0zPRHOoYZfZ5rCqE8jz1GzZ2N3vzx2+yQtKdpFur4hmk86EhPOpsZnGLyGcWm4yPVDqjZvNqMryaxX72jbVR8Yp68fw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO1PR10MB5521.namprd10.prod.outlook.com
 (2603:10b6:303:160::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.24; Mon, 22 Nov
 2021 16:14:27 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4713.025; Mon, 22 Nov 2021
 16:14:27 +0000
Date:   Mon, 22 Nov 2021 08:14:25 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH v1 net-next 5/6] net: mscc: ocelot: split register
 definitions to a separate file
Message-ID: <20211122161425.GA29931@DESKTOP-LAINLKC.localdomain>
References: <20211119224313.2803941-1-colin.foster@in-advantage.com>
 <20211119224313.2803941-6-colin.foster@in-advantage.com>
 <20211121170939.rwvqxsiruhc2edze@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211121170939.rwvqxsiruhc2edze@skbuf>
X-ClientProxiedBy: CO1PR15CA0088.namprd15.prod.outlook.com
 (2603:10b6:101:20::32) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from DESKTOP-LAINLKC.localdomain (96.93.101.165) by CO1PR15CA0088.namprd15.prod.outlook.com (2603:10b6:101:20::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Mon, 22 Nov 2021 16:14:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6fce970c-20df-4ff0-22f6-08d9add327ca
X-MS-TrafficTypeDiagnostic: CO1PR10MB5521:
X-Microsoft-Antispam-PRVS: <CO1PR10MB5521C175B98C2786C69B36F1A49F9@CO1PR10MB5521.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q0U9DELMwRBCbitHBYHAEtmMqUDxqhPVVuMxZxM3c+bQz8IexZLgXTkglbxXc8cKik7yWOKj/tecw6HsQ6SU8wRrne4057upQvSaqUKnYz1Egi+aTyKmkMJgdNWAlmrSIbilDW9fdrrIl2QcHIa6vEycv43f1x5xgPdIjP+IS30eQIwl0LZtz2a2VTaVwtecuR/BeYAxQ1GlgxRrcsRn48+hBuQA9iru0Iryxujl8r77vFEAQMw6oewG08UogBWtLdQ+QvrBr9pBM/OfLYvnQ6R6Q7eekqi7XfSphOgrh8Slbok29i+l9ek4RZ+LPoktfBHuldEIgMCrg+M0vFQYni5/+zBK2U2AbyGhtSaGt468niJsgm+IdUHHS8I5WZDk6l2J3Bi8FgzV9spM23WWDVKR+BNmoSaTnYRMHLiBsiMEqpsvtyRatCsWS9FBY21YwkeHGw/1fzXalOc34TxpZhuxl8REwwUiqrGvOZnv44lXHVBNm4FPoDNUBNLnAlN63OwI3EdGnylWxdtnytkdkO8P8ltdbpxgV1bbHueZb4KM77Vp/wB2NZ/Lop30L1xpb3Wjn3W8Vwb8Oj4yEPjJwR51cgXS+HD0HTQxI/2v/0+w4SmiMOlpaLGnrtbxPXWmZWJl/y/FOqEFu76RqAgm6H1rCU6WTwhVK2UCMmbhYZeFPe8Qb83c+8G9IIeU/LRKtb4NdKwvmR+sDn5dyXLMgg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39830400003)(346002)(376002)(396003)(366004)(136003)(7696005)(6506007)(9686003)(8676002)(54906003)(2906002)(7416002)(5660300002)(52116002)(55016002)(26005)(8936002)(4326008)(86362001)(44832011)(186003)(316002)(956004)(38100700002)(33656002)(38350700002)(508600001)(66556008)(66946007)(66476007)(1076003)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ly3RPv8kXCS73cAM87E6Z8praY2qOBUdeyPOJLirCgC5vYOZyUcnCT7k1YHl?=
 =?us-ascii?Q?jt6RezXuVbRsn9LVZY+S1ux8Itt/a2CAwucteG0Tb/+W38sksFwvMcum5HwJ?=
 =?us-ascii?Q?pyhElWobp+sRsHVjGXv453ZRdHq7ySi6j9YJ1LD80d8WHEbjeajhXNdzSnOb?=
 =?us-ascii?Q?7M4ITv7DcnJLs4Udak8ne1vtZcsg6vmSnaAPnOoTB2KTYsaocFr8ZU5bMSUu?=
 =?us-ascii?Q?GN603wmF5CeD+RrQrIFSf+8/xTflWRZEDm9DCy9Z9q6RQjSnQgXMD8vSycSR?=
 =?us-ascii?Q?7FE2C4uZprBBztbYPlI2gBKcaie/qeJ+jyAIjyoiYFYCdgnaOOl42atAz2aY?=
 =?us-ascii?Q?aHxZ/9seWuOeAWQf4WKRpAVYdCsO6eqfWw255xKdwnQohueiyYeTTpI6AgBq?=
 =?us-ascii?Q?1ceXpUlTQFFW144ghtRUrGhJHrKTNhDak6odM7VST25RDyDVjcwKY3DIDsJL?=
 =?us-ascii?Q?1EEhj69lxzqd7MINxkjWaEUlH3I2Gh6cIEJjBDXN0dyHmsmbl7Ts0yNOjDA7?=
 =?us-ascii?Q?ZQaKdMKeBRQ8kjhKZjQtSLyrN9jfgdlp59Gi6SPZy2zXnMMnSavUia8bsrFs?=
 =?us-ascii?Q?MOewyhnA6yJVbwjSc/fl3RuTBYnCeB/tKqANsio1YobqME88F2oThlQEOjxb?=
 =?us-ascii?Q?IVFzhPPHb5qy4VrAFvDw2acozy2DOXo7HQYajaBqlwVEsbc+xCGTxxgi7ge0?=
 =?us-ascii?Q?k4q8ebEEn4CfdgRVtOYzpMgm8GnGVtWM3daf3U+vhZeQ2WoKQ/fX4ciNSTOW?=
 =?us-ascii?Q?3qf/Hee2nNjNmPF1SXZXDLJJsJseWb8PXWdw2h/vSLTzzjh0cUH/979GAcui?=
 =?us-ascii?Q?KFN+QP4I9+XHb2/MFFvcUoKt66O9lI0dNKIbgYL5X8cp4AjmN+N7fHCA16/2?=
 =?us-ascii?Q?PVTMGSSxTgodxAVcw8TK45EknjWs6iPncUSTX0v51Q1HhwzJ+oynXyqoc78i?=
 =?us-ascii?Q?XovlXN8olclzKTQJ1vIxcRJlnr/d7Q6PFW7smFxYO3rnnbKtBcQfAbbp8AaY?=
 =?us-ascii?Q?5XEsw8ZZLHIt7WqW5+pyx5mHJAUtoa4fOR/sxQmnQY/w/kUwNM6jZJVvh3pR?=
 =?us-ascii?Q?HlPWGjzG40PoLvEFAS3XnBuo6UG9fZPeeIAiFiczhWXZjcX27oN7WoUciDEM?=
 =?us-ascii?Q?LovaRN+Vpn235R6V+SjzsEzTZqiVpsxRcpjZCQRSU/2ypUWsTOCsufp1byHq?=
 =?us-ascii?Q?y4Wqqm3Dyqfbeic6slEswYg17nB/jkAJUFwpPurY5qKYIH7tTSodsIje5E3+?=
 =?us-ascii?Q?zh4cAhZwF+MRAmyku5lWvW3A7vGuHuZ/9+8tSyZXJ9QfKjCFugQ1lx1dcg1c?=
 =?us-ascii?Q?6FoYsQbUhBncvz+gJ1Tz+LPPi71SbMkKMY90BBVaT8DTSK6ew/awRbRlyYUG?=
 =?us-ascii?Q?j4Pfmgw7Gda8oRf79t+nvDeYbQ70wMtw1jMrhHLlKf6RVRD6/wD4UdJfLWMv?=
 =?us-ascii?Q?fodZqTGWRWIT6WplUyX1M4fzopMCTM33PjE6mHeg1uYCbcHjbokzl511WuFX?=
 =?us-ascii?Q?Rh3qk3BAPMU/LJKb+qQT0FhxPgbT2j9YWMtxOBMnuZE84ZF4CTfhm8ynESYT?=
 =?us-ascii?Q?240hRmj5KENwKx5MSKib6G39hxjWqxIphRpeBWe33IDoWiWSfSivQj+w1+/V?=
 =?us-ascii?Q?vhdh7BDnST+JWYVJDnTZYRSM90LtrnjbLdfmtXytKM54gtFYGpI1FOru5RG2?=
 =?us-ascii?Q?qhh+iw=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fce970c-20df-4ff0-22f6-08d9add327ca
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2021 16:14:26.9767
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VF/0vwgr3BQjpi0P9L8bq7jb8+urDD7lOmvuFST17i70F3Lf/uJldhxHagnVhrLqLT1avzphhlgBGBNl5/GAbMplL2Azav8LfjB3w/rif+s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB5521
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 21, 2021 at 05:09:39PM +0000, Vladimir Oltean wrote:
> On Fri, Nov 19, 2021 at 02:43:12PM -0800, Colin Foster wrote:
> > Move these to a separate file will allow them to be shared to other
> > drivers.
> > 
> > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > ---
> ...
> > -static const u32 ocelot_ana_regmap[] = {
> ...
> > +const u32 vsc7514_ana_regmap[] = {
> ...
> > diff --git a/include/soc/mscc/vsc7514_regs.h b/include/soc/mscc/vsc7514_regs.h
> > new file mode 100644
> > index 000000000000..c39f64079a0f
> > --- /dev/null
> > +++ b/include/soc/mscc/vsc7514_regs.h
> > @@ -0,0 +1,27 @@
> > +/* SPDX-License-Identifier: (GPL-2.0 OR MIT) */
> > +/*
> > + * Microsemi Ocelot Switch driver
> > + *
> > + * Copyright (c) 2021 Innovative Advantage Inc.
> > + */
> > +
> > +#ifndef VSC7514_REGS_H
> > +#define VSC7514_REGS_H
> > +
> > +extern const u32 ocelot_ana_regmap[];
> > +extern const u32 ocelot_qs_regmap[];
> > +extern const u32 ocelot_qsys_regmap[];
> > +extern const u32 ocelot_rew_regmap[];
> > +extern const u32 ocelot_sys_regmap[];
> > +extern const u32 ocelot_vcap_regmap[];
> > +extern const u32 ocelot_ptp_regmap[];
> > +extern const u32 ocelot_dev_gmii_regmap[];
> 
> I have a vague impression that you forgot to rename these.

I think you're right. I'll include this in v2.

> 
> > +
> > +extern const struct vcap_field vsc7514_vcap_es0_keys[];
> > +extern const struct vcap_field vsc7514_vcap_es0_actions[];
> > +extern const struct vcap_field vsc7514_vcap_is1_keys[];
> > +extern const struct vcap_field vsc7514_vcap_is1_actions[];
> > +extern const struct vcap_field vsc7514_vcap_is2_keys[];
> > +extern const struct vcap_field vsc7514_vcap_is2_actions[];
> > +
> > +#endif
> > -- 
> > 2.25.1
> >
