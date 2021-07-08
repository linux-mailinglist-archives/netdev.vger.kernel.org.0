Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE3103BF8B6
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 13:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231583AbhGHLOE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 07:14:04 -0400
Received: from mail-eopbgr140048.outbound.protection.outlook.com ([40.107.14.48]:9285
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231522AbhGHLOD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Jul 2021 07:14:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HK9q4RJQS/5cxUppCnzuTb5S4Gg1N5l04E0jaQCl3ZWtol+8vBafZ7JkMqzSGu5NQPciuboY0n0kiuUuM9YimS4v5qUVkrXDx/lorQZ7psx7HNZpwHE2RlmjXPkV/kElH2rzfJSOJr2o3gMwMr5sDTRpc+aZ7x1xCwy/P6AvvyI4BXh97s2kJdQ14x0Mm1mbyx1HRQLnjRW/Br+vmjpQsK4aVqq2G//9z2wGhCzpL6NT+JiI72f4X0ZlVOmq+cXDdsl3FMBvk/j3u5W5K56D859ytAQ/l2ivxi05fgo9i45SL5QbJQuNcwOeB+GiYycQGQHq9S3gf5t6h0yQxpbDCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2A+6Mkd8w2sSy4DMaljRbDmzretQk1G7+toxvBMl3yk=;
 b=g6H6Hk+6sOIwyVoPyHcYn4T9k1gyEai1/VyVR8zs/ZwdClnhdqfEQkw94OAzSvYA+W8ziLLwzoqn+hy01syIjDUC/bB7BauM+Dsghi5RwrTjJsjCHFc6qi0Y2fvrOq78SLxuQo/4EXj2mJ778l/HZGsMVUS4I6q8Mwb12ZUit63M0PpcdDwAHqpDvsBwAtSN+kldcrtOT2NW01MksB0kJ6hNJNPh5c0b9H6dcXTR8d/EmjH4wi0uqF8XoLmXkH1yMAwDd8eI+f3hiWDm9Nahs71lHfgiuQOgwDIwkNUohdDWWfA6V67UQDQnoCHO72OlfFZPSiWG/NumGLtj6c0sHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2A+6Mkd8w2sSy4DMaljRbDmzretQk1G7+toxvBMl3yk=;
 b=rKyfNj0GK4PWu75OvDRxbqNOKdQAsM86Z0JzA4W/wNHHiki9AbDzoB018xWDVO+3L/BMQAw8w00vq7Y2HlSnUsRf2UX+EgvlQoXbe6gDDbG4ki1Kuv7zgA7LkLYXTvrT+6ydbv+cXU939oOrm1ReuWY1XcdZOzbdmlTexoXeJwY=
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by AM8PR04MB7443.eurprd04.prod.outlook.com (2603:10a6:20b:1d6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.19; Thu, 8 Jul
 2021 11:11:18 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::8f3:e338:fc71:ae62]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::8f3:e338:fc71:ae62%5]) with mapi id 15.20.4308.022; Thu, 8 Jul 2021
 11:11:18 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Johannes Berg <johannes@sipsolutions.net>
CC:     Yajun Deng <yajun.deng@linux.dev>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "ryazanov.s.a@gmail.com" <ryazanov.s.a@gmail.com>,
        "avagin@gmail.com" <avagin@gmail.com>,
        "cong.wang@bytedance.com" <cong.wang@bytedance.com>,
        "roopa@cumulusnetworks.com" <roopa@cumulusnetworks.com>,
        "zhudi21@huawei.com" <zhudi21@huawei.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] net: rtnetlink: Fix rtnl_dereference may be return
 NULL
Thread-Topic: [PATCH v2] net: rtnetlink: Fix rtnl_dereference may be return
 NULL
Thread-Index: AQHXc9vShl7ka6OGCUWvYjkG+ohJDqs406cAgAAYlAA=
Date:   Thu, 8 Jul 2021 11:11:18 +0000
Message-ID: <20210708111118.kti4jprkz7bus62g@skbuf>
References: <20210708092936.20044-1-yajun.deng@linux.dev>
 <3c160d187382677abe40606a6a88ddac0809c328.camel@sipsolutions.net>
In-Reply-To: <3c160d187382677abe40606a6a88ddac0809c328.camel@sipsolutions.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: sipsolutions.net; dkim=none (message not signed)
 header.d=none;sipsolutions.net; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1a0f184b-561b-46fa-fb27-08d942011c5c
x-ms-traffictypediagnostic: AM8PR04MB7443:
x-microsoft-antispam-prvs: <AM8PR04MB744380C0C9383949E0F036ACE0199@AM8PR04MB7443.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: R8EsanpxTmv9iB91rHcn2vrlCKUmeD17Zu8vDwf4cdINejzzHN+HR9rs9ZqPjUpyZiTr+Q9X8C8T6Ae5PXq+8xXs5/qYQXcasCCLVjZCKJQV3CGER8CRR7YdcW9XWGN2C4P3PDluELN5qshiBUFrX63RptX8kx3EW8UB0+BUSAiFAFj20QqgPcZD5z3i5oim2LmkQTwfI1k8GS1H4pxBsRu/6run/GBYw6NuQEAfQoGcd6z6hydfHyQfHKPWfUCzjStXbGQyRGOHK5QXP4d5ZlcughhI5AAXz/YiLV6CkMCA/sBJy/amid11lMh40vIdAkH3nYFjDqQNXcQsFQ9xuNpYBI8DGDyRgFxHYYbkl6/sczrt+SFivIQGcvhCBH5l1qxP+liM1F/B14hPA6a2BEko73lNjflqCjTqu8XSVuyK8Pratdp9ooGHaMPxY6a/FTiFlR8OMMk1h9QeIjp1WKlgvrvFbtDkcY/HwmelGlvXYf89ut0LZRG7GBv64YfsQAPVcurOPd9PX7V0N09L6dRYWRG3BJNLA3/rl5KfzpyYNSyyxTOa4BBUqmmA+u0JdHph/xFDM7T3PydSFVqJTTGUhAoQnbgFEdBX1E6PEtiwidqFrD+ZO+8mm9q00Vb7o8PJ/hh/8mb7mMY8zX2D1DWvij8U51u4/+UfJXm7mczSulaQ2JBSFuUZVY9FStTv
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(376002)(39860400002)(346002)(136003)(396003)(6506007)(2906002)(44832011)(6916009)(7416002)(66946007)(6512007)(26005)(66476007)(64756008)(122000001)(76116006)(66556008)(38100700002)(66446008)(5660300002)(6486002)(54906003)(316002)(33716001)(4326008)(1076003)(478600001)(186003)(8676002)(4744005)(71200400001)(9686003)(8936002)(86362001)(21314003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?esofZwcpJMlocQWgS5llPils8sNHA8bThZ5V5/TNimzuUVNHGEIRO8Aa9jXR?=
 =?us-ascii?Q?zOmZAeQrQMfszYwfz4haKPHNwv0LrCaCWKn+NdKGDcqBGsOb4llZ2jc/QVNj?=
 =?us-ascii?Q?Tkl/oGvHTlxoHGp2147+A8nSIfphCI53RlN1NxH3/fOfcZbIjDGJHmOT0yOA?=
 =?us-ascii?Q?jzxJMWM6I9g10vZOPbmEHE6sqWlKJMyWLZtJuQyEbaNuk14p8JWhi3AXRi1Z?=
 =?us-ascii?Q?8r1sYXXcWtUkxS56n2HQHr0sTqYF0hWZsyWPHPqjt+1htXHCdJkw1VANL3Xn?=
 =?us-ascii?Q?8MA9J7ib6EcylD6QYC9P5r+8dFa15XFa4gWSDsx9kJy3Jtatb0MwyDj1eTcW?=
 =?us-ascii?Q?CN4xUGG06UxWWH56tL51VXFhjZgyMFvGk6WClcIp2PZVLrALPTN0YAZPz1PL?=
 =?us-ascii?Q?4AIl3FqmkpqfVH94XIVd6mL/dEFSHTYEcIoEBhg8HS6xgvq5gG72F+36TzT9?=
 =?us-ascii?Q?o9jPJDgyTsiqRsJnBoRQiul9Xhz9Q8HdnB46w7fWFSL0CZOka0MW7Ai6uYDQ?=
 =?us-ascii?Q?5/le27ObWc41/ijVF52wipLhHaUqCBUuggsNpAXPKOrOQ7C+/uDBbMvWS0wO?=
 =?us-ascii?Q?/LtdUX7KfHeQrnQx1qBCqxD2qqjNC/z9hRvyuSxnuszvQ19DMexojnwUajA2?=
 =?us-ascii?Q?W9Urhgo1qcC8/Tt60ltRWmtx+fUhif6tDmFG3/9AhwAnVtHlHKiwmybjyx+V?=
 =?us-ascii?Q?m8lJBhITSIDdVciqcA1kmUWwJUV3pHFp9fARWM8ZlJVI2H2Z5cW9HeRtiqXf?=
 =?us-ascii?Q?TOJFx0rkMkVRJxjHsyYKUdAsyHJuAWtN3j+9BcS1DkVa5GC22na3lVr1CzhI?=
 =?us-ascii?Q?S4BlKMnsOtWqNWYNjRN+WuH6tInvkC05TzhOiUPk2Rogq4YLDXxG73iOA2ws?=
 =?us-ascii?Q?rKb2nbc9rOd0d4iRyL78K/aUc1A5luLr9/1KiEJvlJ7H+ycZ19oGx6hZgcQ3?=
 =?us-ascii?Q?qBvtakoV6n0ljs1MjTqAQGKSgXW8h5p+TH0MpaANfLRGfCaTNPzC2Aoxk0zf?=
 =?us-ascii?Q?+Y+pUqI5WQu6O8VQoEWS+oTXOXZt+MeljSCXEZUK9FKMXiG+MQqYa3jCxys5?=
 =?us-ascii?Q?cRRsLYZe+0AZ7031wA5O1VCiSxinO0fk/jpQnRhpebCbQ9ITdo/vmMzYseBm?=
 =?us-ascii?Q?FLf589LpF7ucvYC9AadZD7iaSia7iq8er47YOeBO2M34tD+Yf8Z1MJhkvKXC?=
 =?us-ascii?Q?lHJcpP8thBI95SwPN882vARwdT9gNH8JR0ntW8lwSAS19MZOKFYWCGkdbCkD?=
 =?us-ascii?Q?0ZNTZxV/GRoHgby5T9TejCPxUe7ceMOxfLtB8e+XpEU/0Jb+JM2TjtRqcwk6?=
 =?us-ascii?Q?fcnNijf22FC7ZLgSjUjkBKbI?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E25AB99A161B2648ACCB53D73C69A774@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a0f184b-561b-46fa-fb27-08d942011c5c
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2021 11:11:18.7032
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: T/EbCnYnO/1B0nIZILyF+F1mM3OVBL1KCfQWYf1QdswTN3i5E1qO74MLpeOrMWrAZF1/HMC14ph+KyETITeveQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7443
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 08, 2021 at 11:43:20AM +0200, Johannes Berg wrote:
> On Thu, 2021-07-08 at 17:29 +0800, Yajun Deng wrote:
> > The value 'link' may be NULL in rtnl_unregister(), this leads to
> > kfree_rcu(NULL, xxx), so add this case handling.
> >
>
> I don't see how. It would require the caller to unregister something
> they never registered. That would be a bug there, but I don't see that
> it's very useful to actually be defensive about bugs there.

Besides, isn't kfree_rcu(NULL) safe anyway?=
