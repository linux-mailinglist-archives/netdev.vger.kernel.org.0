Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CEDC40DABA
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 15:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239902AbhIPNKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 09:10:34 -0400
Received: from mail-db8eur05on2053.outbound.protection.outlook.com ([40.107.20.53]:31361
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239898AbhIPNKd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 09:10:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=avgYX0EgtxQQ5buAgKHuUq6qwaKFsGGpYi77g4dMkzJgoSKf7b3D7c3q2CZBEOVjWVIo1bRLQhzC3Er1pXEFQj4SwEtyIXeK2SkLW4gHRG9XMZzGArhvv5UZtx2Qlat5r4ULgYwyiWcUO8c3kkXa0/ZUyhbnHo8AT0cMGoIeCnpPSTdCGVstiXfq5HBMDqrJfM6inRwNClmcY+XiHP6Z735V79egU60ccr3KV6SUcK3UlHT/HYyeP3iOzJEtECpZngtDwpxGLlOSpaU36HzgnSlFa+xOcg/4J2VjhlfZpLsP2+EhriKeqkYbzfxxSEq9Ckze0GwCbpC+lUKLxgD3/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Mz01xdFFBsgdhlXY8n2IA3OuyUc2Jd5JHcZ6+DrkvaM=;
 b=gSrX+1ZzUG3w3vdjALu1AanTvL4S7BWhmRW9GRzS2R3NSULaVjD/4r7FOLePMgniEBwKQBtEwUuBm6/+0LLwA8aTPYkRBowFVSVwKleKwmYSxW+l3MkKxRL+x/klVt8x4XlNoNJ253vEfadTKHDib6oiQc0itdvHdlx6iujTgLhRhXWtz9nMWT9DAId4aO41NixJ18pFal7PSqMmaev48yWnzmr4X95TGQtuQTVm7SK1jfbks+Q80qwGOkF7IRuVQq1115bTlvtwcv4wksuxnSK97g6OUI2NZkSizQGlyxGkq70meD6q98T1ZXRootPLuKD843ww9e/NCQOk95BPYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mz01xdFFBsgdhlXY8n2IA3OuyUc2Jd5JHcZ6+DrkvaM=;
 b=hH+ZqoRvh8AdJX49yjaXtCfAWJ3L+JjlZezKqK7eVpy8R2FrmrljUAKqfekMsTgnYYN/7vT1i+MKw2gifugDRl7LORknqfSh18GAFMf/A5UghY+bVFqQ4aFw0qePVRXeTDkm4set/lhjD/ybZjEQJbwOCDE9N6hlTfZaU3FbjK0=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5294.eurprd04.prod.outlook.com (2603:10a6:803:5a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.16; Thu, 16 Sep
 2021 13:09:09 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4500.019; Thu, 16 Sep 2021
 13:09:09 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        Michael Walle <michael@walle.cc>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "bcm-kernel-feedback-list@broadcom.com" 
        <bcm-kernel-feedback-list@broadcom.com>
Subject: Re: [RFC PATCH v2 net-next 0/5] Let phylink manage in-band AN for the
 PHY
Thread-Topic: [RFC PATCH v2 net-next 0/5] Let phylink manage in-band AN for
 the PHY
Thread-Index: AQHXnbcfxLtpmnYEMEO8mC1+XCvPQauMXriAgAABt4CAGlwzAA==
Date:   Thu, 16 Sep 2021 13:09:09 +0000
Message-ID: <20210916130908.zubzqs6i6i7kbbol@skbuf>
References: <20210830155250.4029923-1-vladimir.oltean@nxp.com>
 <20210830183015.GY22278@shell.armlinux.org.uk>
 <20210830183623.kxtbohzy4sfdbpsl@skbuf>
In-Reply-To: <20210830183623.kxtbohzy4sfdbpsl@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a16855c7-1ba2-41f5-9728-08d979132bed
x-ms-traffictypediagnostic: VI1PR04MB5294:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB5294258D9515BCA5F29B31E5E0DC9@VI1PR04MB5294.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /RSfjBPwSMpWF7tBDUtrhgnU3+RIz9BCRnL8FjYrmglJm6qAPFVBFp77kBd1/f130Tdu/zNH+LXqfTh6cuwBt8EyYYzegLYAoxFYG2cxRYD78FDTUBbSsIuSQmcqxKsblgN5hxRRKUHZrW7I9hsS85+z/TajEZvdbk9PKhCUyEMCQFpFNTfxnVrbx+ibTaw+ht/sv2SkWifg+3rwgK7BPd9QgdvZSctZMbtNtOS9zdNPfW3j6pQI7w6X0ClnA8RJRsW+RzMrYafhxHO7AGg+JnRacjTVm8R/pm9a8c29S0VPe2pW0YGF+XMiHFbjyDkk1gJ9x1rU4h6djnJ9NKcD++B8VwdJl6pIZmR6CKkGWHMLW+1tr9EADST6n8qBU8zpvWK4yDhqZpwKkTPIIeOiQV+sVVAG/wtBqqnnzj1iBn2O+AtnEZcaNiB9AYaP4UbpGiOTSlmD0YGRxhy5U2DF8YIwJ7wI4Z6k5KbhAHcsGH9YuiVtb7b7rIFkRCdVLCXeCnNH1Xe/Kd+aLKQ4lhLz1v2X87wbweNseN7osG3eEgY04Wi5ioqOqLpQ9vu9/CIHd6kWK/kYB4PuNqpKZr9I+z9uWCVcCdcVgemqwG6XAQCqufH5T21F1I44LYG5MHOwiXd5mcGMJjAxLK6UlxLSLnNum8mmkAn2aua1/H8AZ6XcmTEgc6F2o9H9iBya6BBo99l23SHQZ3WttLKAOXDXqg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(136003)(346002)(376002)(39860400002)(396003)(38070700005)(8676002)(6916009)(7416002)(316002)(38100700002)(71200400001)(44832011)(8936002)(6486002)(2906002)(6512007)(9686003)(33716001)(4326008)(54906003)(4744005)(5660300002)(186003)(26005)(6506007)(1076003)(478600001)(122000001)(91956017)(76116006)(66556008)(66446008)(66476007)(64756008)(66946007)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?BsoAYx2ETITA1svfKIiiLITHD6IGeu6Ja5qwZG+CgQU9mBFLJ8jEOSzqt7mY?=
 =?us-ascii?Q?qzJsWTz5AIX3dHS63JeQxA5rwaPW8D4ihuJkUI4gKGIn31Ti78Q9R8HlIz55?=
 =?us-ascii?Q?7/zUWn0sgX14L5dh7DByp9twPgvLvJH0Jt7k2cLhXkrJkhEaGGBS8T/HAP1O?=
 =?us-ascii?Q?uNyrj557ph2bwlSgwgvyICKR0Om1LfMIKo4wnG3eYS9sQFNyMi85ZJgT7IGz?=
 =?us-ascii?Q?y3brWdJhbcanCKpkVavdwHV9YEhG1S4hT8q0Zbhfq2uHibpzRfIueO12zXJY?=
 =?us-ascii?Q?4wMIecDWoeHNM/veLRf7QiMz71b++k93D1venBUEthTdVHiahKnVXIuKO4Y+?=
 =?us-ascii?Q?dlrJFNrKr1zyMm0OCMBBljQ9h99jyGtpeqtFfURFW2IVIEepvD2ehpbPipZ1?=
 =?us-ascii?Q?LxMP3DimJnU3IGHMjopS3wdb4/FFdjBfnPi0e2N4aB3ZBaE16/ECa2T05zbR?=
 =?us-ascii?Q?zqt9TCTAFxyPPRMVVrSi63F7srgPIoPN6V8VOJ91CK8Snh4jsddXEs2vv1uN?=
 =?us-ascii?Q?uRaX+gwF6P6Lvp1uiLYzdS3rd2LqwSNuYeuzB6GntpCTrH+VQ2FFyAOLkqNT?=
 =?us-ascii?Q?uExSI1sYTpmTjFcdX0mzYhA06gLbUfxHjSV+a4oB9jOaFh9BRGhSKTjsQptw?=
 =?us-ascii?Q?NhEO2lo3HdRl3c4cUUpVgWezxD1WRz9Ta5LaRoyocW6xbUSPkdkzKzzgdNrn?=
 =?us-ascii?Q?8vrpntWzQkBcD5GBd0QUlqnJWIk6iH/Gh/tgHuZ3a+aO+aJsbLsUw10V0B30?=
 =?us-ascii?Q?nHPmMPX6uXLebIpFnCxKOkFZ3v/aMJLDB8tkYm6fRd89EH2hKC9eb/DRgDAn?=
 =?us-ascii?Q?0GBzqymvx/o2JozDNEtZvwZUyLwwRKyMif6Hoq0V4FuGQEVBIItO2YnSA++S?=
 =?us-ascii?Q?mCUA2f1ZRecV4x1fYHOwVsrY3Qr3TNlZ89/Un/hG+dGPaeYR49V7aBhNcdi/?=
 =?us-ascii?Q?3CtEdAYTNCViVZDa5FeorVRKPokePoWqcqbYFVLIvzMs8NMht1c8zfgvwses?=
 =?us-ascii?Q?ErloVvsgdc+pp2x/8yZpiu56JH88rEhPlCpH0psaFg7DpPnP5uvHJStqUVHI?=
 =?us-ascii?Q?kSWoSjH8gjddFhSKvsngrxXauq2rSoEZsDge5fnoxKM6NWEH/YJtI0133jzi?=
 =?us-ascii?Q?ackfFjanGRh273J/pkkCr16T0YAAkFEqUsHWAhyJElmFyney0k/yGi5iWgpY?=
 =?us-ascii?Q?HdzKpMzO7xNaLrIO5RrspvR/Jer2On2HUMtjmW3fRPSpPBY17E378wh7odOe?=
 =?us-ascii?Q?JCuU5JWe19RhiW6P3NE7H/V4yJ42nuUInRa7pmruRIfMybsYp12E/wUGnduk?=
 =?us-ascii?Q?yDBuyV6RwHFsoaQsuV3aJChx?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <76AB15EE67AE804DA8A0B94FC7D543A2@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a16855c7-1ba2-41f5-9728-08d979132bed
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Sep 2021 13:09:09.6417
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bgNjOLZX+UqZY6ntSxk+647qRMclZ93W0hGkMry4jnXmTy/cJikI97MSXhlhClMX6ZA130swH785uoznzzj5LQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5294
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 30, 2021 at 09:36:23PM +0300, Vladimir Oltean wrote:
> On Mon, Aug 30, 2021 at 07:30:15PM +0100, Russell King (Oracle) wrote:
> > Can we postpone this after this merge window please, so I've got time
> > to properly review this. Thanks.
>=20
> Please review at your discretion, I've no intention to post a v3 right
> now, and to the best of my knowledge, RFC's are not even considered for
> direct inclusion in the git tree.

Hello Russell, can you please review these patches if possible? I would lik=
e to repost them soon.=
