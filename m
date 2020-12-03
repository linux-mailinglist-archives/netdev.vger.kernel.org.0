Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF53D2CDA59
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 16:49:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387634AbgLCPsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 10:48:07 -0500
Received: from mail-db8eur05on2083.outbound.protection.outlook.com ([40.107.20.83]:37502
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726841AbgLCPsG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 10:48:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EkU6LOFcln0D/VyiCdqO9aU3edlycEy7gDfvjCAeaieJ1AFp5L2HDxTLQi3r+9myK0wwlbipZIgJ3B9rtfu6uUgQ4QmpuVHiI0bC7XrDx7evG625a5OQgj42LrIOI2rKz256vCn0pRcg1Ne9uOmgQeEtFM+igE4vUWzNjnKrraqb+WMOW584C3KzCiRn9UReyorYBRLr/sTYXsfuHnqBq1ye/crRSOAJLDI/0U3T50fUdUb+59bYYXpki58q9YM+SPGtvUb3UdZFCfuWLKXxqPorlReNQsk6U/WaDUJ+/L02LgFzUn4+MVd4zxH/MHR7r6jg4B0aGYyyiuQdg5rQhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C2Yxi/+8tLzNc0Bn70z3865IFdTnptgLYKuAmuNnGHM=;
 b=KPVLuxT91YjThHvuFeXbBAA8O1pzAKhecST7SCz1G9uMxLiro8PuatOqV2UGASv9VtsleoXSCPhgJC8vQ7EMPf+PGhKZ5SaTl/R+kp+KNYpCuZQ5aM9GSMFtBTkQBTpfTKFz/S129zCebGVyjRiCcO47iGfpl/5hEe05nQRRa9mQlH+kQjYCUfpMfwyBoMlf/1uzibGSc7TtisMbIvlExDbtgei3FPiCyM1hMzh94+F/WtLD6fUgH4YDR5e1C7gdy0D0o2L/Mo/XgIObuydgsC1tkp0iOSOgoapvLaJedFVntBqGMTQcm/nWUHSDJn7dA4pC5S/ronwCinAPh6g2HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C2Yxi/+8tLzNc0Bn70z3865IFdTnptgLYKuAmuNnGHM=;
 b=YiHvUxY8qanZIaTKW5MywKWGRqnGEZgi8sPBKzKoqwGJ3WYcLjSFpAWz/K6SjFV0MAR0YSf3r5N1ZGdbruXYs5tpuJX9T1pGBdnDbDdygED7ZN/7wj7//mxAh6QiR2gAgcgxUjOVP//OVjPek8K9Y8svn6Ynr8gWBt1U1+J6ecI=
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com (2603:10a6:209:3f::17)
 by AM6PR0402MB3559.eurprd04.prod.outlook.com (2603:10a6:209:12::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.25; Thu, 3 Dec
 2020 15:47:18 +0000
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::6c54:8278:771a:fc21]) by AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::6c54:8278:771a:fc21%4]) with mapi id 15.20.3611.032; Thu, 3 Dec 2020
 15:47:18 +0000
From:   Madalin Bucur <madalin.bucur@nxp.com>
To:     Patrick Havelange <patrick.havelange@essensium.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net 1/4] net: freescale/fman: Split the main resource
 region reservation
Thread-Topic: [PATCH net 1/4] net: freescale/fman: Split the main resource
 region reservation
Thread-Index: AQHWyXtSU15lz2QhZ0iXI1B/qYMSiKnlgUwA
Date:   Thu, 3 Dec 2020 15:47:18 +0000
Message-ID: <AM6PR04MB39764190C3CC885EAA84E8B3ECF20@AM6PR04MB3976.eurprd04.prod.outlook.com>
References: <20201203135039.31474-1-patrick.havelange@essensium.com>
 <20201203135039.31474-2-patrick.havelange@essensium.com>
In-Reply-To: <20201203135039.31474-2-patrick.havelange@essensium.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: essensium.com; dkim=none (message not signed)
 header.d=none;essensium.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [82.76.227.226]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0523c1e6-568e-42c0-1a32-08d897a2b72a
x-ms-traffictypediagnostic: AM6PR0402MB3559:
x-microsoft-antispam-prvs: <AM6PR0402MB3559F019C0329AEBA68E2776ECF20@AM6PR0402MB3559.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2/voFYBq2d1DfcfAzGd3Q4SGajxqRPzqyWSidkTrkcP5fp37XUb0QfKx6JHtajp6Jh3aY15PGr5HRRu6jRjbvGIp+UBcQXftAUHuJGQyOnGhmWjMbk73Wv23PnpxYc3bchZr5hkE+FkseZIM3MFgo00W1O7+VYkgv5WhVP5aKUoiax0lhAwQoois1L5Tw5RhDid3/lxhKPr87W1OdYOZTAK9PMC18Wmf3VTEIuZLoU0XvFIrGs9QqRlQez/uBmZ0zOer1sXP8ixIh4HneBRbLdjixC2hGv5th2CWS1VeES2Wp3YfgUH4wchLq05W5a+i+a23BqgnWsk/JtKeiZSyvw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB3976.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(39860400002)(376002)(366004)(346002)(6506007)(9686003)(83380400001)(86362001)(66476007)(110136005)(8936002)(76116006)(8676002)(64756008)(478600001)(66946007)(66446008)(66556008)(33656002)(52536014)(71200400001)(316002)(7696005)(53546011)(55016002)(26005)(44832011)(2906002)(186003)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?OO8ti1tMSmEZGAB6eUgG/Xuvpi8sa+PoW40oY8bCP/jvzkv/LzJ7aNeJ04/K?=
 =?us-ascii?Q?Dw4q4HVaWpkJQ4XKoAaWDXo7pVip0xcLrrSKt6IbqegZQwv+MVAJE9RsWpfH?=
 =?us-ascii?Q?yx0sswP2lSLNSRHDWJ7MbQeXrLmrUDVM5eRQzLrjxP3L8WAUDV3SyI9L4CEa?=
 =?us-ascii?Q?7+Te5yIZXLJ7j3YAvScNfTd2i9GlXYiRKglvogmQXwnYwLVsP7ouOFSyz3yZ?=
 =?us-ascii?Q?lZu2UJVf1/n4zXKI2Y/y2ETq7dAOJq4gHYEErsMnz7FV9NPQm/o6CtHpJuD3?=
 =?us-ascii?Q?qea/YJyzqAWxKLOSpAfL8o08Xiw0Rm4nTyKMaJZqbMxfFmSTU9tEop2uXFV+?=
 =?us-ascii?Q?3NO5UEOFP4FW+88wf5fyRyfXHZGxxCUjjk0vv+/n0A8J2QmTfNm6JihaLf1P?=
 =?us-ascii?Q?zbkszTru6xt0X0YP//YHDsIfpAkNTubE4meMelGi7Z0m50HqB0IWycdh9haQ?=
 =?us-ascii?Q?hoW+DAekDtidjvfMdhNCZzC4opiR+2M5bYCeifiXmyBRQYeGTTQBOnW+yUS2?=
 =?us-ascii?Q?5pVVLO8lQvv/NVcQZoiqgUCmN79iPYsz3kstrPfqlfMc+kRtABLsbIadKHfM?=
 =?us-ascii?Q?adhCUIzlMosb77YwkG5eUewSIL89mXbB1f9IAXBy5uKxOrXd20R2OEGG3Dxy?=
 =?us-ascii?Q?UiWYvXeU/ihfaaxzz6XBaI8Jammbk+YmrGJVyxLMJCWCD/NB0/u1vIb1iB2P?=
 =?us-ascii?Q?EEOvxwR6KjlMFHUbQdApVDNWexSpVifIlLShjhe69sVr+ruTXAc7kabxh30a?=
 =?us-ascii?Q?ua5HXsli5rqK3iWHWGkkc0udHcWZFKxKu1YvyKTH0870Ypa3WXUc9KCQRtXf?=
 =?us-ascii?Q?X+qpEIWYNsgk6ITD8kseox5o0SZznQRO+jTKXXYAp7aowpBOlUY+kAvT7wIU?=
 =?us-ascii?Q?IViyPe7MB07CjF+YvsoMrtsfxkWU9/8rVP/KY0u/p34NPhSsnRjtVykJ2Uyu?=
 =?us-ascii?Q?gkdG9SPVUKiDTtXimwQeacsr775+2F06w8GbxzIR/hM=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB3976.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0523c1e6-568e-42c0-1a32-08d897a2b72a
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2020 15:47:18.5111
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pqlRK6FzAMhs/IFZF/rB1skdX5ZljOsgTmyC1BoVItGFGS42EgDvAiGbvm7YSHkasY3GjH9ZoPwqnyjKV/3rYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3559
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Patrick Havelange <patrick.havelange@essensium.com>
> Sent: 03 December 2020 15:51
> To: Madalin Bucur <madalin.bucur@nxp.com>; David S. Miller
> <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Cc: Patrick Havelange <patrick.havelange@essensium.com>
> Subject: [PATCH net 1/4] net: freescale/fman: Split the main resource
> region reservation
>=20
> The main fman driver is only using some parts of the fman memory
> region.
> Split the reservation of the main region in 2, so that the other
> regions that will be used by fman-port and fman-mac drivers can
> be reserved properly and not be in conflict with the main fman
> reservation.
>=20
> Signed-off-by: Patrick Havelange <patrick.havelange@essensium.com>

I think the problem you are trying to work on here is that the device
tree entry that describes the FMan IP allots to the parent FMan device the
whole memory-mapped registers area, as described in the device datasheet.
The smaller FMan building blocks (ports, MDIO controllers, etc.) are
each using a nested subset of this memory-mapped registers area.
While this hierarchical depiction of the hardware has not posed a problem
to date, it is possible to cause issues if both the FMan driver and any
of the sub-blocks drivers are trying to exclusively reserve the registers
area. I'm assuming this is the problem you are trying to address here,
besides the stack corruption issue. While for the latter I think we can
put together a quick fix, for the former I'd like to take a bit of time
to select the best fix, if one is really needed. So, please, let's split
the two problems and first address the incorrect stack memory use.

Regards,
Madalin
