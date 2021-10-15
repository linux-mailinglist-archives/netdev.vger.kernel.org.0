Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAFC742FE5C
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 00:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243397AbhJOWwr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 18:52:47 -0400
Received: from mail-eopbgr30060.outbound.protection.outlook.com ([40.107.3.60]:47881
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238725AbhJOWwq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 18:52:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HIgZ1DkTJ849Wks2SSfTTt/gU/jjtyqStBAfgo25Bkwf+LoMr66Sbcp5fU/W1zHiW3QHjIzOJApVYSBc0F0anPuRPi6xiSCpKoVBXf/+5OdEiSV3wyQ/ib2zamvOX2PLyjLMG+nlWCabD3OWKjA4HJ+1T74NUpjj0rlEhuVLiBkZSTTPU9jn/RZsCulmOdXT8Si8YI9HWiUQ+kDcNPkitUINrJ+BOZbnAXO1wZ9uPO1i6HJS16pOYZVxP6TgU7fC3c6WlX+4ljZ8JgdqiqvNnwu6cpTmj5LhS3RFjp1GR0GGTQKRUowLVLWpMYvEK+KzshE2oPESzHadDD5SNac0rA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vvVcBHGCDyXDAczSLtMQ7CO+bW7DyPFNJnWQN8Df/p4=;
 b=fYWM80mjGj4WOxUxReWXIl4peAsbKrz24uP+Ihxv5oucvAiB2dY0Zq2F6o3iji+Wxme/0MS24I0vvXJMe7xbfS/B+MhorctgbCEHlYDgejlCKX1OoXhBaeElmSokFtsewNuFK0Uj/dFaXCceuWMQBKfu9KTnjKJmCXNsfVQGqPKY1hFgLMSNlb9yL0VW5z1VnyoO0QPR/TAoC3t3SXQdnBSkYKBVzSONNKPXN8uEBckw3Gc7aMUvLfDC+AXCNmbs8M/Ta3t9M/iP6OlwoQrQv1JqrL9dsaHPnMqdldMHO48dkPk8Ok68W15GhMsThLRHHy9qqat9p25fvRgD4RnoRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vvVcBHGCDyXDAczSLtMQ7CO+bW7DyPFNJnWQN8Df/p4=;
 b=UIlHN5SJKDQoXbsKZgvd/vy1aXOwOzhnw6zUkF2DySnzlTWZGRXk2yHRuq/0SdQQghW9LxudvgtPYsbm91rag/LZmy+fND2M/5uM36VsJt9xtZ2Hq8/mXLDDb8TRb88n0NLNZbsaurqakKyXIageDiBZ4thXCCC844J3wro1nro=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4431.eurprd04.prod.outlook.com (2603:10a6:803:6f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Fri, 15 Oct
 2021 22:50:36 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4587.031; Fri, 15 Oct 2021
 22:50:36 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Shannon Nelson <snelson@pensando.io>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "idosch@idosch.org" <idosch@idosch.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "jiri@nvidia.com" <jiri@nvidia.com>,
        "idosch@nvidia.com" <idosch@nvidia.com>,
        "lars.povlsen@microchip.com" <lars.povlsen@microchip.com>,
        "Steen.Hegelund@microchip.com" <Steen.Hegelund@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "bjarni.jonasson@microchip.com" <bjarni.jonasson@microchip.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        "vkochan@marvell.com" <vkochan@marvell.com>,
        "tchornyi@marvell.com" <tchornyi@marvell.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>
Subject: Re: [RFC net-next 1/6] ethernet: add a helper for assigning port
 addresses
Thread-Topic: [RFC net-next 1/6] ethernet: add a helper for assigning port
 addresses
Thread-Index: AQHXwfxNPzszp+f7p0iBY3tsvjHx+KvUlVIAgAAPVYCAAAWAAA==
Date:   Fri, 15 Oct 2021 22:50:35 +0000
Message-ID: <20211015225034.vlxyhur77epyq4ji@skbuf>
References: <20211015193848.779420-1-kuba@kernel.org>
 <20211015193848.779420-2-kuba@kernel.org>
 <47ac074a-bf85-a514-00a5-3749e3582099@pensando.io>
 <20211015153053.781b6e57@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211015153053.781b6e57@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1908e52c-2335-4bc5-73f1-08d9902e33bf
x-ms-traffictypediagnostic: VI1PR04MB4431:
x-microsoft-antispam-prvs: <VI1PR04MB44319ADE5257CE9AD747E537E0B99@VI1PR04MB4431.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2399;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iPFjUH4KXYpFmu0i6YQzaXljwHlvV2OaGevrMTpyemhX+V6hxgltC1Vw16l1BEGXO1Mp+NCwEES2EUPMJCOOadD9588UMU+Sv+MTMyTizMaBqbfHu/b/oO/5tVhheu4H/HyvPpmI/JXIsyvVyktKZA9JoPb9sIZCC5spnPZKOFpTMiF5WE2mQd4Ciza/Bz5jolCRsK+vob8y7RTu6AVYST/p0RY86hRJe+TzBFR+pIwlwYMC7X6YNnHCnLx/Y2F2B+0LsNvcnjuNPZsuYW7DVYiglgqAtIZ66o7LgVjaFcEUzUSbN2U/OamowxGCm6RWA80dpN+ph7/wawiuKmEhgnESFNVQGqGLBOZGKZNk2GiGDj2C9K4eLhiyi3UFUNF7HcT0n7cYONTalBCBgLX6LcKcUSMXWqG5BMRlogpE7jA6SaycYSTisdmQj+HzzN07mzYsLZ6W4e/IFWZI2cRLEB5CTX13j1PjTMi7FQ11wkuY+O/oEiB3P9WItixrG4QRdk2e59U3sKkbJmZN+VcnmRgXgaC1yRJRxhxD1jMy/dzbkjweJSMJfIIRtOJbXcKACNni2e9dckD/+lr+4D0+QObpL8avXhHw8/fUW0NA0JCcTD4iIjW1/gRdqeKolF3hTfJItRYxAoBPe8PHhKD7rembJWqLmbEBmAbGCHUbYIoSAadtLlxcrwojLyKG2TuyYije4istCyaSR+DruRQsxg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(76116006)(86362001)(91956017)(186003)(26005)(66556008)(64756008)(8936002)(8676002)(9686003)(122000001)(558084003)(6506007)(66946007)(66446008)(38070700005)(6512007)(2906002)(54906003)(71200400001)(66476007)(316002)(1076003)(5660300002)(38100700002)(7416002)(508600001)(6916009)(4326008)(44832011)(33716001)(6486002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ZwcFMEQlvNAmdjbvBOndupnO+CFsbD0UVGlIMpQ70D1K5B3I7wKSibM0lJJ1?=
 =?us-ascii?Q?YMHZjaA8akwG1PfcMdGNzK5jKUl2/UW+w3+VumJANoQYAbCc4rW2+5hkfZaG?=
 =?us-ascii?Q?KloX2I/qZVVN/SwviWYoAfN312EnQWa+oiT70fKJLbq9ZAFl3Eh54Krv03di?=
 =?us-ascii?Q?+nVhjTdyEG9tYILZ3e7ELu+PkUZHAKMJWfDI2y3ID4OU661x9sc57EKIxxyw?=
 =?us-ascii?Q?uLKI4+UDBT73TTyIbjU2niQhcsfHBwElim9cej72UQzdLA2kCwn/3msVLKe5?=
 =?us-ascii?Q?mfQLtbno8cORskFl1tS59ae3q1SsgzyFUpJRcdFXFlAAQawWug3kyHhCZBAN?=
 =?us-ascii?Q?XuY0q0YB59rnB0/3HSNl5OWxgDFx0sV66BXhtKe6oNQkXHyABFvFOIyiDLiG?=
 =?us-ascii?Q?k6o8WCq0C80xwo1ZrTKRwPDVHcx5DE4woCgBXzABwieYJjJw9P4UGK+kS2De?=
 =?us-ascii?Q?kVlpmvwD58joA1l8vwxZMiDtzR8aAR211nZHP9ZS3/D9J+fmOXdYxBFmdVzK?=
 =?us-ascii?Q?FBV9FVaRkJTwtLNOnmL2jeBCv1lAyTJKy2mJXtPjvQnMIrF7J8TTL+tPC89p?=
 =?us-ascii?Q?T/33jT/P301i0MKcL2o9AwZvPJjUzKZyJK1m3wl9TKCEId8JUJiFKagyIMaD?=
 =?us-ascii?Q?NG2SQBGR8CfDqUwaLV+cRhOY19dEMazN4eiKhlSucOYTEqH9l985PY/HUQ40?=
 =?us-ascii?Q?8fyCWBeuKe01FgcL7WUiU/0QFtnL5jVv6RFPPCdiOZIUWcvehqNGJWlBpENC?=
 =?us-ascii?Q?ogEvg2bz6jHRIJl1u3aUCDZ98mC0xdc6OGw2KiXqCPrlstTvQh0uH2htprSO?=
 =?us-ascii?Q?bteG1fzPbqIOSlIzeZTF+y3Ti70gxYnTE9DBVmCkaeLEXqX1iC76ZDgSsMoJ?=
 =?us-ascii?Q?HhS01mqrYBbIJ0KhaPj8RWiJlwVx/nCu5/hocLXkc6j5aINl2mKDUtkVnQJg?=
 =?us-ascii?Q?RHzAxnb+LTMJbcu+DM+TBmKrbuGIakHTnMXrEjjYwUuUB1BQxBOvLne49RVG?=
 =?us-ascii?Q?AmgJd5otwI431Q+SV5O5+B29dkK8rmvCdGhfeg1nLwvTMLRWNG7TvgQPRIGr?=
 =?us-ascii?Q?PX8uhPD+m7rBC6OqFrfiOVah1Y7XuwLQ2pGLTh1wd5/1ClX4iNUeWHoIfPUo?=
 =?us-ascii?Q?6R4J7zmaAU8/vZXstz9m9UD1PQ1IGaRm2dFEgy3M/w/b+FM3YeVcnliFb6Pv?=
 =?us-ascii?Q?hbNmsT//Q4iGop5dFBRNesrVDQVlj7ig98i2O5eqAQM2aTuJgFrGCI4RNyvw?=
 =?us-ascii?Q?Cy9MLPcah2K7LsLuxxCG+bp4X/4KrjkAjuLIAFnCxofgrq4Ky05cNhvIL8/p?=
 =?us-ascii?Q?FGX3knfEIZcGrGxBFAuzSMX/wL7SQqS+/76aIXqBqwhbUw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2ABBCE675177384BA207EA89190A9A36@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1908e52c-2335-4bc5-73f1-08d9902e33bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2021 22:50:35.8687
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9pabRWjY5mhsvX4PIsYkOieGi5XBcIJScwIDUSIi3Lpaws2GhQYmtIY8iinGPRsYQaNf/E/Gzn/OgnvmZhZN1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4431
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 15, 2021 at 03:30:53PM -0700, Jakub Kicinski wrote:
> Thinking again maybe eth_hw_addr_gen()? We "generate" a port address
> based on base address and port ID.

I like eth_hw_addr_gen() better.=
