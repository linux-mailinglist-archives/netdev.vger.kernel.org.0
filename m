Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A64FC2FACA6
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 22:30:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394692AbhARV2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 16:28:31 -0500
Received: from mail-eopbgr60043.outbound.protection.outlook.com ([40.107.6.43]:62630
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389635AbhARV2Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 16:28:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=moEaQl+Y1kcjjfKx9x4jASdod7EXyU6Bjmg90hPnJmWqhWmD9Cm/aJfRlNBaxvRNYS9M9sHZlhYwShwsO33ggqVl9V4poSzCd257FTJkTCf1qEo/8CpBeBzRrN/IFRpQHSpcvrrq0LKnPh6+Xrdga4bqsyvxd/iGmqde9BUr9ZtbkTxQrGxzNVxKCsv3h73/fzD3oHYNb6sB2lbqBLumhIzYK95J+Hp4UJvs0e7dIcyZpf+TjKAgzu0nUB/QSC+KMvRx2grxbXN6K6asRYAWxiHHfdLmc8jMVEr0FlG44fU0iRVzipcvaP8DHhbemGzFIKoaiX/K4CchB4z/S3M6JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=momAPEAeuzNBaNbFbzPT5l6PxnX+1Nj23GHXpiPAnqk=;
 b=BTYfHysJed5fu6EeRoz1KB9gUowVNGwnFZQ1qqQl6cQ4c9wdn4YTKOcmthPTdDDIFVbMBGJqJq1Sg41bQBmKYSlAwddXTps2EEfSB+4v3CLmkeVY7p1hyNg/t3HgpwQOhcEYxrRQPNNwEDeeK1CP8kYYCnSuz4txQRztHKa0+MsHjwC5Xg2ZmrKMyGrvkpsehJDhmQsbjN1iCNzOigdCPoTySpYrtCOKN0eoMhv1AZ/htAMWgnxJq98jG/44hAB5GDopy1ZSG0CxemHCUuUAjswzn/zLUB3JSs+UjyZJ7tSj69r3TP9rj86f8+CYTLNOC8WAn4crGy01uV2mMN2PpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=momAPEAeuzNBaNbFbzPT5l6PxnX+1Nj23GHXpiPAnqk=;
 b=bhkr+8SKAstd2FyFDndhiYuyAtccmA4p/9gT2FUto/irJsqbLXln8mBEYF6eWd5Ihfa3M0NqtuwxJ0y9RJqOKuSUrzrPFCELB/QCHZuOfLujlL9Bzw1300odvUoc9I8qg8DltDZ9XRLrJxhDdLiWeL6WFWco8sWGjfO5GpzlS7w=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5502.eurprd04.prod.outlook.com (2603:10a6:803:c9::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Mon, 18 Jan
 2021 21:27:36 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::2c43:e9c9:db64:fa57]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::2c43:e9c9:db64:fa57%5]) with mapi id 15.20.3763.013; Mon, 18 Jan 2021
 21:27:36 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
CC:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: mrp: use stp state as substitute for
 unimplemented mrp state
Thread-Topic: [PATCH net] net: mrp: use stp state as substitute for
 unimplemented mrp state
Thread-Index: AQHW7cWjvIuaHRmLXUOsoJYbcslYzqotu6kAgAAOCQCAAAmFAIAAEreA
Date:   Mon, 18 Jan 2021 21:27:36 +0000
Message-ID: <20210118212735.okoov5ndybszd6m5@skbuf>
References: <20210118181319.25419-1-rasmus.villemoes@prevas.dk>
 <20210118185618.75h45rjf6qqberic@soft-dev3.localdomain>
 <20210118194632.zn5yucjfibguemjq@skbuf>
 <20210118202036.wk2fuwa3hysg4dmj@soft-dev3.localdomain>
In-Reply-To: <20210118202036.wk2fuwa3hysg4dmj@soft-dev3.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [5.12.227.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 24795b9e-97f5-4428-6380-08d8bbf7e00f
x-ms-traffictypediagnostic: VI1PR04MB5502:
x-microsoft-antispam-prvs: <VI1PR04MB550215FCFA474E49228F48E4E0A40@VI1PR04MB5502.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: agPO8949VzubzGbXodOmpzJfylUUlQv9hhtRg2dCl5FunSVaaYMUZHCNw6S/x4KWQNmmlMoIlLTrqorr3CTVqACxbWAfPXdvBBg+TwXdfYFST7DHDpa9Kzm+i7aSyquHGt4I7YHkvER/tL4bx7oYRJWdukI3i5VIR8/0EL688lcwjo/atnUbks9/CVjOdHOTGFftcqPogMSoB+/P/PQxqkGCmcT+viKa+RfmCjjyCF3RM6JH/XOE76TIlSl0Sc0fQchpwLO6COpCAm3vZnyl2xAk/Ea4sysDwAqYEgXPEk6Vmwl4oeYNhly09qb1O3D19z9M/ZiqBR/B51U+HCjCOKB5LUlmgH8/+rNLGPGyhypThN3F2F2/iscZPqg8Fa0PWvnkfNTiXK4+rm8cZGoino9zEhRkjIgxd2+nCYLoZ+uMc4eCZn4xh3eclrv2XKbFjv/NxutDwCFQtSYmDx4MYOh0cPRwNgQQccr5ZUibaFUHqftICAH3/M4SEP8I0E1j78HfIApzp1L21rZjW0hefg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(39850400004)(396003)(366004)(346002)(136003)(376002)(6512007)(316002)(186003)(76116006)(71200400001)(86362001)(9686003)(64756008)(4326008)(478600001)(33716001)(66476007)(2906002)(26005)(6916009)(66446008)(66946007)(8936002)(8676002)(44832011)(6506007)(54906003)(7416002)(1076003)(6486002)(5660300002)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?4XNok1wN5ULP9q9uze6DIoGpcWu+j82LjDzi8O39SgcCqooDGIag7oF2F9jm?=
 =?us-ascii?Q?XCjR3weGPcD0CfU1bBFIJWwfhE9RAULzNAUmjZbzr6tAIiAzyplDsT7AycvX?=
 =?us-ascii?Q?YfljqHY/Z7yNeI30FFQYTk0BC7hmBha6P1VYKeNAsatkDsT+iB7ssrZpTA5U?=
 =?us-ascii?Q?B5KWMmphafxkH4Lxk8HHbGQA8QmabyR1/6YQzLYCet1UKu4gzfiFKZaor2lm?=
 =?us-ascii?Q?SHkLBeqJ8UHyr4dx7OLbW3CtKfc0xN6tErO0GzJOIduemockgYANd4jvNGSF?=
 =?us-ascii?Q?XXuSkkXV7jjjKucjjFORW+O10FrwE8h82RhrLDKffqdeQDOU0JSRFdUW0ch8?=
 =?us-ascii?Q?snC6z7Sn2dkSGDcTmY7TSPbIyUsOCaCeBeAyDKt5+mTlqKBWY3be7Z7Zm0iW?=
 =?us-ascii?Q?kkYbYprI5KhkhpjEno+bfoxNyfqcbaEosuhJgubL4C2kSWcxfqiPVXqSekNa?=
 =?us-ascii?Q?7IvWnoOJb3H3T56PHG5UmfxuzpAJHShkB6Ss/EwJy5WeEuEH3iSFqDhBUiTa?=
 =?us-ascii?Q?0GynQXBUO1RVh2dnRP572900809sSM65Ol4kbPppvna/FKhby2AFuCO5UfUq?=
 =?us-ascii?Q?aua2+ysR396knexFMQOn4RkjH5gU/8N21aA+JBhbwkSTq/FlbfQJcyYT3+rW?=
 =?us-ascii?Q?mWDQjoixZtqV5KKndT+SW9nD9oBNjE5QU3U9Z2z37+jX8A3T0eh7hn39DfHD?=
 =?us-ascii?Q?PHYGrP9zVzn3kKxhr/hkKPyo3X/11iYA3dCBmdVitVTQ3Z4HCDm3T8sv6a+y?=
 =?us-ascii?Q?W6IchgnXLnDI7fyaBJ5eOICqgl0eFpRpdf4nvswGgZy0wg7Rlqe2PY6/pX4A?=
 =?us-ascii?Q?i61gNloI4HqsaIqBKLo45lrY+5ZCNWhUL9KPXfk6Y8p1IlPXvtD3F1LriS20?=
 =?us-ascii?Q?hxDNsYmm+KCDSdt51ZyatiAtmgle9wlz4e0RqafrsxJTUyIZbnFW4+knm3mE?=
 =?us-ascii?Q?lveISXSvATYYKJdrsELeTnnhuqyTOSkq9pZ5EIiIsXs+ut+RdTkMqRGnlq0c?=
 =?us-ascii?Q?frtq?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2795B068D924114B9909A29669B28AC3@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24795b9e-97f5-4428-6380-08d8bbf7e00f
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2021 21:27:36.1787
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 59F5VbZyNjfjLub1tC9Kj5PqKrKnM4UDW1q8EKBbfHUXAl1iwiSMizDzmzpZCJIGUswdmbmgyzPhJ+R0mv6z+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5502
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 18, 2021 at 09:20:36PM +0100, Horatiu Vultur wrote:
> The 01/18/2021 19:46, Vladimir Oltean wrote:
> >
> > On Mon, Jan 18, 2021 at 07:56:18PM +0100, Horatiu Vultur wrote:
> > > The reason was to stay away from STP, because you can't run these two
> > > protocols at the same time. Even though in SW, we reuse port's state.
> > > In our driver(which is not upstreamed), we currently implement
> > > SWITCHDEV_ATTR_ID_MRP_PORT_STATE and just call the
> > > SWITCHDEV_ATTR_ID_PORT_STP_STATE.
> >
> > And isn't Rasmus's approach reasonable, in that it allows unmodified
> > switchdev drivers to offload MRP port states without creating
> > unnecessary code churn?
>
> I am sorry but I don't see this as the correct solution. In my opinion,
> I would prefer to have 3 extra lines in the driver and have a better
> view of what is happening. Than having 2 calls in the driver for
> different protocols.

I think the question boils down to: is a MRP-unaware driver expected to
work with the current bridge MRP code?

> If it is not a problem to have STP calls when you configure the MRP,
> then why not just remove SWITCHDEV_ATTR_ID_MRP_PORT_STATE?

Good question, why not?=
