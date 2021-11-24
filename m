Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06C6945D146
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 00:32:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235379AbhKXXfO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 18:35:14 -0500
Received: from mail-db8eur05on2042.outbound.protection.outlook.com ([40.107.20.42]:36896
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235005AbhKXXfO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 18:35:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tqvg248WuK+KyIL7SyF+Xu4KZirDME3gf+sDIy3daiWzc4Soz+Co/A/mytuTCDXQk6ydpaVneK006uBRfz63Ix0nwsNwC9+yXhQg0qPcu2H0Zw5zs81o7fCA/EzCxc6xKEO0ec5NPtzzRen/drFCA8Rd9zkus3TAmiadO+9dJMPFNO85CmMLMBFtp5WhrH9eSKyX+tIDMvMgoRyOfcyNRKsOXdpBi3TTE29kUY3mbSZn2kQV8LqRC6AEtFW80XxtSoEeOUv/zc3zWKbsggOxt5tG0IABe4vXoIY7LsLP7X7PoMCPmOCG3+IiHYG/ZjBXqmP8Wm/BjqKjWlUTC1p46A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tl2RF6U65LuYnPx1VTxYfsrTWedNCUHlTi7PAiuYOdE=;
 b=Uthcf4inFbzJ4pKmQ3OpQj1UE0eUXtvV8mqbocfilirZZotQDfJnzu4rI+nvnxBuGC7m/RbrCBKuPHLMABlDO1hsBamb0r1GGYpfDQOEQPPyBVuE7t4RNNcdnEhvOnNHBYNxYNymRk/lXPtNtv7GY3aWJSzsTGIYXVRCO1CGWsEVN5WyD7S7fHLGmsz+S216iFJmwP//4VsFtXhkeuHZ2WBdFEOhYhutUUi0bgEbjagbJoYQFr4ba+H8E5fVBBZVyQQgi5fGvWDCBycAsrDg3f3pNg5VFHwtiy4kRdqzcF4eLMgrlO51RfmSgovfD99YI+lMAsEwolRyiyLp4hYe5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tl2RF6U65LuYnPx1VTxYfsrTWedNCUHlTi7PAiuYOdE=;
 b=TJVyLPBxp3sZ30vmnZdsHC+RaZOFivJi6gOLHkqk/YSVsPMX+ce7jnny0t03h+GSiM4yzdgBAe7s4GHHE7eC5v7Iz22rwUzI+Bb7C8cq4CzmGvNRvhy+c2BtqEj2c4f+HAMuX4Ace1v7Cz2LBi3TXdLYo4wBwJdZVFgaeRb1Tjk=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4813.eurprd04.prod.outlook.com (2603:10a6:803:51::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.24; Wed, 24 Nov
 2021 23:32:01 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5%7]) with mapi id 15.20.4734.022; Wed, 24 Nov 2021
 23:32:01 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        George McCollister <george.mccollister@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH RFC net-next 11/12] net: dsa: sja1105: convert to
 phylink_generic_validate()
Thread-Topic: [PATCH RFC net-next 11/12] net: dsa: sja1105: convert to
 phylink_generic_validate()
Thread-Index: AQHX4VwvfzWd9Rz+dU6sjp1u+N+3rawTFzqAgAAU7YCAABgGAIAADSaAgAAC6QA=
Date:   Wed, 24 Nov 2021 23:32:00 +0000
Message-ID: <20211124233200.s77wp6r7cx4okqh4@skbuf>
References: <YZ56WapOaVpUbRuT@shell.armlinux.org.uk>
 <E1mpwSN-00D8Lz-GB@rmk-PC.armlinux.org.uk>
 <20211124195339.oa7u4zyintrwr4tx@skbuf>
 <YZ6p0V0ZOEJLhgEH@shell.armlinux.org.uk>
 <20211124223432.w3flpx55hyjxmkwn@skbuf>
 <YZ7I/6i42LMtr2hS@shell.armlinux.org.uk>
In-Reply-To: <YZ7I/6i42LMtr2hS@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7ba3c099-649d-43f9-2ad3-08d9afa29d7a
x-ms-traffictypediagnostic: VI1PR04MB4813:
x-microsoft-antispam-prvs: <VI1PR04MB48137B5CCDDC8146DC8DD865E0619@VI1PR04MB4813.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fpMPBi7SbmS78R8g+p11VcCpwOZ6lKCfRrIpE2d4PlogJNtA288JqL/D/AasGNs3bp3QcSMLz/7dtKIqo6glZ4la+OfpJhndBd6W/InHlzptkD1Eqnzl9F988sRYcAepCfO2pM6715qOwy9BpUS5EdX9yoLOL5KUL4y+NqJz+c0knq+UGgQgWM6eVaizfyStgm2ikXOGrfEo739DrUbCgY1TnQV2wl4fB12ohgViQVWBcxAETdsXfygtojz3mDJKRRwTF/v+d7XJs/I/ebnhd8nKGrCUgtMBrSP4W0myforiO2WgsLZCcAO0qG6DU8oyWz2r12Ipe+eW5vtxN06ZMN+ztohKaF+eEJCd/Cci/tPVshswvnF8i9yJ8Wu0jnZS+dLESXtu4g4zEtboXfm76iXC6NSCsI5X3yPt0Rt27J1lIST+IHWeAViu4i7sN3ybmlsbA4lMoSNkVwSI1SssG0oT8KoWkqB4vLNUrnnJyvdutbVdyzdR6GiaTUig3mT6l8bNWYajU/dj/2zWLvvZYCaZrlDkRxhj6+A/FLmTWs0apsuV3HiEC6eb6HJC1d7Ci4uc2XRyz3Wkte8y9S7qbkbnKcWYFg2QxtWqygn75VjZrcdMTDQ8mJrWN6/HZJ8TK1stldEKJryRcCbGFsDH7TTWxIQ/MO+t+CAh+VviPj3sD+8E6TyT6njHM4jjuZnUQuWeV+mPNUic0zw86pbUW3iFETIxhc6ENOl5zYX594I=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(8936002)(38100700002)(2906002)(71200400001)(4744005)(6506007)(1076003)(76116006)(5660300002)(38070700005)(508600001)(6512007)(6916009)(66946007)(66476007)(66556008)(64756008)(66446008)(7416002)(33716001)(83380400001)(91956017)(9686003)(4326008)(122000001)(6486002)(316002)(86362001)(26005)(186003)(8676002)(44832011)(54906003)(41533002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Ow6PrEMSi9gJ6L61ETBv4k/54Z6spU6gqzuJNtL3ahiLSXbns8mEtGAaXqpG?=
 =?us-ascii?Q?LW8sd2ORIG72l2EYZtfl4nTwzsLLIxcNTBAaTkS02uCnNr+atGe2sl3+0K1U?=
 =?us-ascii?Q?XwVIpiG7iciBa8/3S/JCgQrGDP4kbxeQcpxil1OTyiTVpsfgBiO1WXQIql7Y?=
 =?us-ascii?Q?geJmXvzPePYH5wpQt+2h2fEsrr6v5EUG7h3SxIxOG/jwCghyurHFMwUUCPeL?=
 =?us-ascii?Q?lO9qmiyHbLVoLXxZjT3u7DlWqhtIVb9jB0TGmq4J8QQiLuEGjimD3TvU3QZV?=
 =?us-ascii?Q?D4KXSOGL0yKgrk/ml+qrCsYitEVsKEpK6i2V8AYN2GJ5LxgtfS1qhfh+4cHf?=
 =?us-ascii?Q?a9Y27gxUKcl6TnmNSK37Z5jGtS7RaYvebC0BhK46PY46XfFq2vcxR+UnTKC9?=
 =?us-ascii?Q?Rrjw/EhTLLSN36R3IDtGcUi0gLPQ3AQiTDOkyVk2wS1A/WLP5uH6cGVjrgty?=
 =?us-ascii?Q?xROIawYj48eAATVutBo0Xq8hqmqwijNsxajcTyneUaznTBRYan0ZnKOjaBEG?=
 =?us-ascii?Q?hSTg9JFqmvy7epH1LZHx0IsTZhfXr6+X8T73yqgVx69v7TzETxWj40d4HzMC?=
 =?us-ascii?Q?oJjenS2keyyhS2GuNkIyl9Kcuctr+eP4KmJVE5Uwgxc6hRPMHFlDgB/oT+lo?=
 =?us-ascii?Q?GfMi71FtOXMrfb0FpQ8tbI2rk+rwHzuSLGOmzgbOwM/iu7hP8aiOWM+XcLsS?=
 =?us-ascii?Q?CHuICugDi6NljcU6ewtyfQGiE9cNxII7ZnldX4yWBY3rslyv9UOn3Z2Tegdi?=
 =?us-ascii?Q?5OPj/Gzpo5A9zLwQ490p4pi2i87TGYv7dYbDpSRkYyHSxGdx+GNHpMokqh6j?=
 =?us-ascii?Q?zGg85IY2RmBzrF/95/zD9EHdPIxntz3LjPhyLbxAEigKTyuKepZd7ZHRIHqf?=
 =?us-ascii?Q?rA2B3/oWyBZ1iVGgHlnaZDQ1QF/4QOjE9LxmDSIu5dI1qmVapyJ2/lZpZWd0?=
 =?us-ascii?Q?TGmSQ68Lp07qXxJ0Op0VZTS/s1gsh9kmK73vujda8TQpdl7TeEsImEJgngG3?=
 =?us-ascii?Q?Np3DPARTZ1n4ZzSH0MHngRWRWFNWRwrc+mNKqUq1iUouCf+DNgMtYKjRJgdZ?=
 =?us-ascii?Q?pE8FuLgdkwCqCPWodTAudYRdBucRyWuuGkxKGWga7+jmjogQcDBDF8Zqgv7t?=
 =?us-ascii?Q?fO6lRizaX976nyTjwvluZwP5izcADWU7UQRI4eWMvtZzWkySqY2cNAZUXnBb?=
 =?us-ascii?Q?5G2CuuaewtiR1bbTLcVUBnRFLQrgL9aOYMKS3xahvD3Jwpl9trFyQ4B5fYVo?=
 =?us-ascii?Q?MvAJRgH5F0IMKi1SA8+whTpubkc9m3xu7xNze6z1E3x+Fu2Ky2muPuSa5Iwe?=
 =?us-ascii?Q?fP/uB5mBeZZ2u6EXVsImq07hVlx6dZpZqVbPuPHZYFqaIaLeLpocPKlNoB0r?=
 =?us-ascii?Q?AkoM1eibJ1WyQyTuM/sw9obhcu+c2hxdD4jXaW3FJmAzYqvjnahxhSw1zn0+?=
 =?us-ascii?Q?Hjkq640c0cac+8J0O3z4MaF0OSDiBBn9CjwEHMHIgkSt0cX9VFyKWwUgcrQH?=
 =?us-ascii?Q?UCuCk83Ky070q6TCpc7T3EngqQSLYnNWG+NMnFzRgb5UIVaqkyYYKm1tTy3g?=
 =?us-ascii?Q?GeDBzS6xqUQGOg83LxRQtIomknl/PP8wGLDWgltIYhcdS2wSe+/eiBZXwrq8?=
 =?us-ascii?Q?J5iMsVQ/7Phgi8R2zDRWBVX9egLAPSnY/5FumVZo9h0i?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <53020FF816C56A4E87F87E6C3E2C5218@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ba3c099-649d-43f9-2ad3-08d9afa29d7a
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2021 23:32:00.9808
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lCW9rTEgagclPTf6D+vHMUSAH60eemnP2abNlgUTAd8yDA5/mYua8GEhdTve6+dogdnL1NKBOslwQz1wfiel9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4813
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 24, 2021 at 11:21:35PM +0000, Russell King (Oracle) wrote:
> Clearly, you have stopped listening to me. This can no longer be
> productive.

What is wrong with the second patch? You said I should split the change
that allows the SERDES protocol to be changed, and I did. You also said
I should make the change in behavior be the first patch, but that it's
up to me, and I decided not to make that change now at all.

As for why I prefer to send you a patch that I am testing, it is to make
the conversion process easier to you. For example you removed a comment
that said this MAC doesn't support flow control, and you declared flow
control in mac_capabilities anyway.

So no, I have not stopped listening to you, can you please tell me what
is not right?=
