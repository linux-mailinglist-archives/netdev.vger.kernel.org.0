Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAF6431A293
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 17:24:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbhBLQYQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 11:24:16 -0500
Received: from mail-am6eur05on2062.outbound.protection.outlook.com ([40.107.22.62]:4800
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229451AbhBLQYI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 11:24:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hcWMIemqYvh6SFO7i+T9sFrRqMRjQ5wvR60qwyvK/jYmgad14YiUvbUdHnIByoMUgbkp5yZ+Z6pOoa5/YF9paFayJp6IJllaWIbCVtEGsbEb5mCkrxQTKQ2dvPNjwsJrkWkgJEb7136JYu7SVIkVdFj/gnEf9A627+pDknmjXutdjWOZYvfWV9kTJioeLtJEZfKzZeNy+TY9o2mbYz7XN7TL1wCwykkGxWp9ENVUXopFNSbij3PdHwNoGQH1Zz7URkq29Qqkcf+peQrbz+X1ADM4UpNPY/chsv5188poGzBzWAkoOH9iRla20UYTIbscWdouYRGEF4Y+3dsaQwTO0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZgZUd3+fUP/He7w7fiOykPdL22pPq87TevaIvh+B2cU=;
 b=cCFevALsjRDL0I0RZ8ESSuJdyK9kIu6/HyA3bXq9lxJSADYBgNaTX7cKg4OF9FcfEh6pwZSECjq173WmpdRHeqJFzrzQKsm3BFRM63MPnGLQ620aBGDCteTsdqkJK9xTxAQOU8Yn7SQaYTD1vJ6tyFqkSGT1qf/NLsjOnlDrFalHuCPBPFAHuWlYWGlrFACkgPqkuaHP9OahcR7A4PKMVpWKjDikOFe79W+Ju8czV/AvBKoClTJZhhO0N3tQnGaRlYNpgQZfibm2PofNdOmLop5KbHTsVEbQm2jYQBLgw/vKHhcEVAHH2l1V84pTEW9seEgJYiRBsy0sYh2i+WzfxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZgZUd3+fUP/He7w7fiOykPdL22pPq87TevaIvh+B2cU=;
 b=NU64yD87QmDs24MzOII/D3yF3fB95Mp9UCl+JrM66KlhUCbKY2ZXvjL+wGoOWibxX5MAOtUBB5o5MlypQEO3psAQCzhOGYH0K4nkQmf8tBD0wsY2QgHYK+m8egxM7r6Pw8v/mIY1SwRbRfhE4caJPBoA+8fDdfiyO8vcSjZa3s8=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7470.eurprd04.prod.outlook.com (2603:10a6:800:1a3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.26; Fri, 12 Feb
 2021 16:23:19 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7%7]) with mapi id 15.20.3846.029; Fri, 12 Feb 2021
 16:23:19 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Bjarni Jonasson <bjarni.jonasson@microchip.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steen Hegelund <steen.hegelund@microchip.com>
Subject: Re: [PATCH net v1 1/3] net: phy: mscc: adding LCPLL reset to VSC8514
Thread-Topic: [PATCH net v1 1/3] net: phy: mscc: adding LCPLL reset to VSC8514
Thread-Index: AQHXAUhdAGZIwJCnokGEX7Rqm0aTdqpUtC0A
Date:   Fri, 12 Feb 2021 16:23:19 +0000
Message-ID: <20210212162318.zx6nx2suzdfocu55@skbuf>
References: <20210212140643.23436-1-bjarni.jonasson@microchip.com>
In-Reply-To: <20210212140643.23436-1-bjarni.jonasson@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [5.12.227.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0b16bdad-d705-4414-7a84-08d8cf72827a
x-ms-traffictypediagnostic: VE1PR04MB7470:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB747080DD6ADE6AC64E73ED33E08B9@VE1PR04MB7470.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zqXvREza4UyrK0OHCWBHzcpEDmUvLTiaKCoCY+pe2koy/9oBDm7hWDEZYxnT9/ZPuvQF3RS56QOijK9QojM6x3sh0M2SeBhlNDHHaX+bEHy1hh/ZZQaTJs/ybdPTFY/b8xjeoETaxU765kXcILRNip/YGaZqaJJQHDQJX9sSFA0oS2svxlnyz1ue3HrTxrT/wcYDuJp8WYKnlDLs2NXD1xVvGHKc7oxhEHXSVe1n9HUug7beZPGR9d0TP/glpuGtiBjqKMQEskFsNPvZafZvAE8Mhs9wtfJqUFzQ39nwpEV0LYwGYKuY0doSdVmWlXomIgJyX6fqYsELnKBjC70Ay+9BTUuBpmLz3G/PWo0mtxc/9oF7CCUDB2Huv4jx10FCahP2r70luDCHonpb0y0fL3nHu6yAlCgbHJG8Fjpu1N2t7E15HPU2z9H+HMwP3ZnAsG3wPXOG6m3wM47SeC2hsVaNwHEi+YrY3Q7sP7jTlfJYHzxIeTJgi6w/oc/KtmeXGSwFer2tDGv5QXgjZ9sAAg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(346002)(366004)(396003)(39860400002)(376002)(136003)(71200400001)(5660300002)(76116006)(6506007)(44832011)(66556008)(26005)(4326008)(316002)(9686003)(64756008)(66446008)(66476007)(91956017)(86362001)(66946007)(2906002)(186003)(6916009)(7416002)(33716001)(6512007)(6486002)(8676002)(54906003)(478600001)(1076003)(8936002)(83380400001)(4744005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?cEw/il/iwM69ROqk+YDO6d28GHmEJ5iACmcLXMRqOo97psV8kU5dl3CZMOOl?=
 =?us-ascii?Q?WJtWD2nZ8KqBCP72Le9jDwQgel7FysjNk4A2fursMEBIHRS+o1lQ7LbQ/A7n?=
 =?us-ascii?Q?iI/mMksdqZH3D6VQbVOhorPjwgHCIfkEIyXEsipj+RdOq1IRkfVnngA/cz1t?=
 =?us-ascii?Q?51ycIKcj3OPF9gTZ1bbbxaiGsIZQK//xt+2JO5Bhf5yEXxpoTo0/oPrzxswL?=
 =?us-ascii?Q?LxACVslUZTlCSHm0WphC5fTDG6Q0R3YdV/ZJijFDUji/32R4fNyce8iimkYN?=
 =?us-ascii?Q?NZi2JH8AjcEYGlaY8eWogRUFLlWPi2ie8aAcnFLCn2hUnX8KIjObnjcQeTPL?=
 =?us-ascii?Q?TzGEMQMsal0gUVdYRcf/NPQiEZtzgMCUM2wCVJAJMWS7T8R8xzVLSp+MZmzk?=
 =?us-ascii?Q?PM/If5AIgky49c69twboXgBqLFoc/oEkuHiHOzoAm0gjXsqgNvN/V4JmPclQ?=
 =?us-ascii?Q?Jqn7MMNbQVAZmxTJwtLBqw0ED19z5HOnD5rC9FAbL4+Ajg7uoAHwretVDFIM?=
 =?us-ascii?Q?VGqtVMz1AmnXzXbQoAK/8ldjdswgsyd9GLlFNoOGW/KmMLiarN5fpf2+kNGg?=
 =?us-ascii?Q?6Do9ukJ6zfU3dtsOpsSLrPCFxgYoZzZ39AlNM2lAabH1wpAVCXhF1vqE4/vy?=
 =?us-ascii?Q?ZIiaXIGQxUOYaMG4TEpvmjmv8rezQFmy1u44crxzrRwcuj09ZQGYHO6LizWU?=
 =?us-ascii?Q?4f+b3xCvZoAbV+PSwu6T7mdcWWKlRIHmU9ZO3OnuDZOL5uJh74LGCq/htZug?=
 =?us-ascii?Q?KS5AJCZQ9gl6o7g7WwkaPOOUCwPfT6zOukGwtzcKQ7qYV/RREXjQuESa5WkG?=
 =?us-ascii?Q?xN8+hTbQ3iiA2mx5bJubSGW03inh4QhNX6jQaUIH9SyXsl0WBUJ884YOwcK9?=
 =?us-ascii?Q?h+sqjBB7F6LNd4HeQ1EkJfF0Rw/RmHUfHsrpAThJ1QkAN9xHDaMQwLo6DKOz?=
 =?us-ascii?Q?YGx23CO7d/7ZnYGFbvQSC/SyAwBPbqvMCXKe03KAV4qRJHyfPoDp49rxDg4/?=
 =?us-ascii?Q?Qmg8QwcKQLUTSh0M9e34B73pWntVBMksfLhnEacDe8GAfFMMQqR/rYPDIwyr?=
 =?us-ascii?Q?9m0wvNQskTHzkwiRNBS+gqfwWH6haRPmk+LohDdOe8ZyrKZ4fcKh/nex44DV?=
 =?us-ascii?Q?z8syOGxdjS9G/bg8e5vSF7LRIJKqhnF7ftcvB6dXR4AtBny5eWzBQprmIg6b?=
 =?us-ascii?Q?VsvqeR7BJIjOdsR4aABp2zsyXrknQx1d2ZV4E5HifGpIEDk5/u0CJc/iJbbL?=
 =?us-ascii?Q?w84bFkYfurqfFZFND6tqCK5oN88FrywQ79StSgkKUtLTGK7+INPyLcWDu/vW?=
 =?us-ascii?Q?hS2ujkSrmqpNKbx9jMxBePbY?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <302086AB8D16B041826B95C65D806E39@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b16bdad-d705-4414-7a84-08d8cf72827a
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Feb 2021 16:23:19.4501
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: c+fR+8+bQ1HAjSl0Zx1DNHh8YCBEiAkZSlo28pOb3KOHVXID2jygC50jeekK1e5/ESpe4rNTqaX05mXzx/Pxxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7470
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 12, 2021 at 03:06:41PM +0100, Bjarni Jonasson wrote:
> At Power-On Reset, transients may cause the LCPLL to lock onto a
> clock that is momentarily unstable. This is normally seen in QSGMII
> setups where the higher speed 6G SerDes is being used.
> This patch adds an initial LCPLL Reset to the PHY (first instance)
> to avoid this issue.
>=20
> Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
> Signed-off-by: Bjarni Jonasson <bjarni.jonasson@microchip.com>
> Fixes: e4f9ba642f0b ("net: phy: mscc: add support for VSC8514 PHY.")
> ---

Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com> # for regressions=
