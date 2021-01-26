Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFF383030CA
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 01:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731959AbhAZAFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 19:05:04 -0500
Received: from mail-eopbgr130051.outbound.protection.outlook.com ([40.107.13.51]:52573
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732483AbhAZADV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 19:03:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YVCQkp3lwd75QIXPBhfJusQkQ1L3QvbNojYFtOJL4gZyLb+DoRUQbglLvDJ0uoXUwG63Qhf2m27Gp2cXKiqCNad+CPWIod0uQ7TMSuKgtydD5MBoy8D6yunpTyLd8WAepdjuNbiFg1xcZOcui6CIgraXCOsW+2IWxiUNBfUO+283y1Clr2JzjayG039YukjRyu1SNOd595Szj8gxhxbWvhcgGBmiBW2DmPgG0/fUamI/kxk0QVXxO0FAaAREw/nkYaUZSikrTk9Tk8pKanK9QNs+9NLaXV2rzaBKvSAeMV5TTIRp3Bm+0ID2cRnNbda7idcmzGyZhl8OPRLujPrh6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FqA5PHtnveU17Sq2NPmAX4oJdzel3tNEDyfouxbGtkg=;
 b=Coo3c1C8EUVmIEww9//xVaES8F3sImIgODtunTjVh6ZtzE9wXdLrQG+gwCAkgDkYQ+aPxobZ72BtQT8AYiYWHrcBfNXkZvtDoXXZyKndDDNsCNtUoKn9Qic5hK/Mi/jU6ZVn3fm5PvtkAd23g2UJ8EnUwXn/uKb5RQJ4ITu7x/2Z1QCgElJ3IrKR/nGJwZufMijI7gQeK4ItK4eqOtGG4HvV0HQ8AM8Xb3hCFyawzMLemZBqy4n1VSFIi1dFrcmN8SkwYdWSHWqc3mfb1MtGu2cK/b/g2M9X/w53p9sIpdxcmm6gLw/iUcjQeDeMXVUQCKV5mo8fEROsllVTBYiM+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FqA5PHtnveU17Sq2NPmAX4oJdzel3tNEDyfouxbGtkg=;
 b=FuaCpEWwJMZmjg1xCz6P8dmYzsYyrGRJ7L3IBxPt2hKIc85lT9FctEV4cnEYqdMZzR2jyec9rGXghH3lNlstNJn0H8r58YFZQjkgaDyheeNSeScTTXb+c1b/9qTvY1s8Ihiyo1VITLeDwudZqb8/ulqrEcXrfG7ejRHAETmXZ/k=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6509.eurprd04.prod.outlook.com (2603:10a6:803:125::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.17; Tue, 26 Jan
 2021 00:02:29 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7%6]) with mapi id 15.20.3784.012; Tue, 26 Jan 2021
 00:02:29 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Jose.Abreu@synopsys.com" <Jose.Abreu@synopsys.com>,
        Po Liu <po.liu@nxp.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>
Subject: Re: [PATCH net-next v3 5/8] igc: Avoid TX Hangs because long cycles
Thread-Topic: [PATCH net-next v3 5/8] igc: Avoid TX Hangs because long cycles
Thread-Index: AQHW8RBH771cWx+OG06we+xwGrQpUKo5CvAA
Date:   Tue, 26 Jan 2021 00:02:29 +0000
Message-ID: <20210126000228.gpyh3rrp662wysit@skbuf>
References: <20210122224453.4161729-1-vinicius.gomes@intel.com>
 <20210122224453.4161729-6-vinicius.gomes@intel.com>
In-Reply-To: <20210122224453.4161729-6-vinicius.gomes@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [5.12.227.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3e4a4399-9c9b-4b69-05a7-08d8c18dac3d
x-ms-traffictypediagnostic: VE1PR04MB6509:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB6509D4D9201569DBEA4F5BE5E0BC0@VE1PR04MB6509.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ShSfsBW7/56lT9eW0MyoVH998owi+ygiO5AoBU2o27sRzbXApoXpVnKSAzDcMhFksfsu74JIzwZqJitilDn5GQZ8qeiGHEwWJlbXVhvHNv+b1guzxw6+nlh+avbk97DSzUxu+LfW/qYR5gh/NPYd2MF6wXTPffDswqa6qh6/uGZ2EbZwrAiqBEE/wvGrq+gEXnfW6pvhx3NZDPvQSLZ2oRRZe2wUyhEibvpjg2B2HSHaV5FeyjD+5ES1O1rLjT8tieahodhFtRVPBUq6IHGG9LykjdfkNTqpe4ZkVJZtXBmagul5Zc6abVjTZfM1M852s5S1OCPrhLK81nl1VFZS1VeF/sjQK9I1gGJQubHX1M1qKxbpVI62Du5uI+r1IiwyhenVJmXAHFsk1oFhKty6GzRmH0M6YaPA9c6YX9i8QYB4JHv1rluG41rWe/2jfdQ7nXMSQPY0JNN14xu28uX+qXXqZyjp00ZN+5fIAAtmYT6vdq38nRi4JDE9hz2tZSQjI0pSCwgqbWtmT7o117HUTQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(396003)(346002)(376002)(136003)(366004)(39860400002)(2906002)(6512007)(4744005)(83380400001)(1076003)(6486002)(54906003)(76116006)(64756008)(66556008)(8936002)(66446008)(316002)(44832011)(478600001)(91956017)(6506007)(86362001)(33716001)(4326008)(7416002)(6916009)(8676002)(66946007)(66476007)(186003)(5660300002)(9686003)(71200400001)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?DTpOBkC7BtFuxBWjKrPY1Abbc6gIizokc2XoyxIfPyj+IGm915USZ9CDao39?=
 =?us-ascii?Q?NOePCUWsCm/2ntw1KHd8emjQufRpngHbguv8rxKXC5kuXB34E5rJ+KflO9zd?=
 =?us-ascii?Q?9gxXz4wWB33aQaAtEd8jLYnDsbuaeqfnUqp8gz2kQAVhP98N6HsvknSnOVPg?=
 =?us-ascii?Q?/w6IO4kXc13nudlYhWcme0+xexpvb30HMmGOqyDLICU0oWQsOp1mgJWE9sTP?=
 =?us-ascii?Q?GqMvDZOkEYIJey6TLVG5tXlzv36YchKvBRbHsY2zc8EC1dcUN93dmiyNVFH3?=
 =?us-ascii?Q?ihusSVTbUgwMWMC04XWsfcpvd/xlJIe1uwR32qMB5LqLoQsI2h1ELhmVRTTL?=
 =?us-ascii?Q?o3rErZ5EozUSZ8mxbZ3DlHyTRF5Wcr0sz1BNPOaFKKLpVMyWIvmFRw7gZvEu?=
 =?us-ascii?Q?2dCkO1CEiD0H1/uBaf6p/4sj4CpXImZa6nAG1yvezwDj79P8nBCr7NTTqavs?=
 =?us-ascii?Q?z/9UR2yHSIUAIA+0ED3ryB//g0OiCiMWBezNSjLOWTXFEN8U+H2PnAODjFtH?=
 =?us-ascii?Q?8Hb8R5wzZQmq36zBJppoZjd9oUAG7MNCZXq562LkL6+nLoTkun/jaXaQH7ZM?=
 =?us-ascii?Q?p/rd2UyXwQyxowBZ87iPeem2cbSeICf0WJDrjp/hAAfEGbxK0FNTbNDMcgD9?=
 =?us-ascii?Q?NabyghKAyGwenDpdbENIAbkAsOY+1YcIC3tCzX5eRG2ekIyYHvFXkoCa06Lr?=
 =?us-ascii?Q?k7uXH0dIInMtViy1m3jB3tlQ8JN169i50adWXFJYRGUzF+vLMJK2g35ucGPl?=
 =?us-ascii?Q?WqRlfpEXMJjmB8qOy48d8IOvARcYHjljv3t/UNuEimLy8s7U7AlhxVlkV50h?=
 =?us-ascii?Q?XxdJybJxU8qWLi1b0fXAmGRXq3OImI8u54/uge2NBVw0JJDzfDoexq3eM55O?=
 =?us-ascii?Q?8DtNsscJU7nS6BdWojdxhdybw+AHaB0PfwaoXG79tsW6tUNEecgwGUzYtC5T?=
 =?us-ascii?Q?CkW5HCJZyYX51nkUHatthLElsg7cVubE8QgRnF6B3UFAjE5p/pW7VvGM1Hhs?=
 =?us-ascii?Q?MoOYwmAQBiJQbeCAMbl2GohV4rEJ2TkEuDFxIPHCGVcGyTLw3oN8sxokbwLx?=
 =?us-ascii?Q?MgMSwc9K?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9017B83999087042AA350220CFFD15A3@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e4a4399-9c9b-4b69-05a7-08d8c18dac3d
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jan 2021 00:02:29.5895
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h30/nxjMlzTkUzvdDz938IxNiqZ92DSly8NjiFnJtjnbLXvjrWKZQJt8zRbra8OKfDD0CeBNSXXZFO7AhuIKPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6509
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 22, 2021 at 02:44:50PM -0800, Vinicius Costa Gomes wrote:
> Avoid possible TX Hangs caused by using long Qbv cycles. In some
> cases, using long cycles (more than 1 second) can cause transmissions
> to be blocked for that time. As the TX Hang timeout is close to 1
> second, we may need to reduce the cycle time to something more
> reasonable: the value chosen is 1ms.
>=20
> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> ---

Don't you want this patch to go to 'net' and be backported?=
