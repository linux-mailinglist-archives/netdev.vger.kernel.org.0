Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0D62F961
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 11:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727351AbfE3JZc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 05:25:32 -0400
Received: from mail-eopbgr70074.outbound.protection.outlook.com ([40.107.7.74]:7630
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726382AbfE3JZb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 May 2019 05:25:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jaxrNtUMwg6WO62L5oQhhRddZBec+ThTMDsqj3TvdZs=;
 b=mhks8K1h0NUAlyyF2BEUJDpUkHj44OhIUiQfwCW3Ru2B30j6Ub6n7lpA+S3HJl0zCc9+1piisaVlwrBb+d5C8U89Z9V1DoWPkrn3jwDb3RsWg1XMrHPHy9jLd3RR9xaQWKfwnbGSnhx2g3UutP6KkxQIIQryuEw25Hi2+cLMxaY=
Received: from AM0PR04MB4994.eurprd04.prod.outlook.com (20.177.40.15) by
 AM0PR04MB4018.eurprd04.prod.outlook.com (52.134.90.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.18; Thu, 30 May 2019 09:25:28 +0000
Received: from AM0PR04MB4994.eurprd04.prod.outlook.com
 ([fe80::852c:1146:c756:66c4]) by AM0PR04MB4994.eurprd04.prod.outlook.com
 ([fe80::852c:1146:c756:66c4%5]) with mapi id 15.20.1922.021; Thu, 30 May 2019
 09:25:28 +0000
From:   Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: RE: [PATCH net-next 4/7] dpaa2-eth: Use napi_alloc_frag()
Thread-Topic: [PATCH net-next 4/7] dpaa2-eth: Use napi_alloc_frag()
Thread-Index: AQHVFmwJwRRk+px8rEuM7jbC1D5sEaaDZkNg
Date:   Thu, 30 May 2019 09:25:28 +0000
Message-ID: <AM0PR04MB499422D37A49B440E8ED16D394180@AM0PR04MB4994.eurprd04.prod.outlook.com>
References: <20190529221523.22399-1-bigeasy@linutronix.de>
 <20190529221523.22399-5-bigeasy@linutronix.de>
In-Reply-To: <20190529221523.22399-5-bigeasy@linutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ruxandra.radulescu@nxp.com; 
x-originating-ip: [192.88.166.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6e6c0e92-430e-4eea-d010-08d6e4e0c145
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR04MB4018;
x-ms-traffictypediagnostic: AM0PR04MB4018:
x-microsoft-antispam-prvs: <AM0PR04MB4018F4AA64812093DC23089994180@AM0PR04MB4018.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-forefront-prvs: 00531FAC2C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(39860400002)(136003)(366004)(376002)(396003)(189003)(199004)(13464003)(81156014)(8936002)(54906003)(68736007)(229853002)(33656002)(486006)(14444005)(3846002)(110136005)(81166006)(6116002)(99286004)(316002)(25786009)(7696005)(256004)(478600001)(55016002)(6506007)(66066001)(53546011)(7736002)(71190400001)(305945005)(102836004)(76116006)(6436002)(186003)(74316002)(446003)(53936002)(26005)(2501003)(4326008)(4744005)(73956011)(66946007)(6246003)(8676002)(14454004)(66446008)(9686003)(76176011)(476003)(5660300002)(11346002)(71200400001)(52536014)(86362001)(66476007)(2906002)(66556008)(64756008);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB4018;H:AM0PR04MB4994.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: JlM/+Bz5Mn6gP3BhqE3qAsXXm3xEw5bgUNER+HbhycPJsQ5H+JCBGerFCCXqU57wKu4OEhC97LhlB70bpcznz+4DR8QHwQiAQ/LBw3IJ0NCcDrtoAL49bT+Hj9N/NT/YX75RlGcCtCpNXRajodOt0ujBpMiPn7EGbZ8yzcdjx7SfDvB6qFtccbgdbuo9Gox0muGyuQRya3LhrrDi15yz+7EQyijC3U3o0gwzsueLBXIjve5Cf1sT+6GF8Q1y3J2+s1hks6H785SCdoVDt4qfbhkhNZfpZp5k2+sqJBNaHSCM1q6UipsYOWC+E/VgIgokQjhBzxDOHqQPRjJ0U90vWyJDuV2/BqA5VmJWVNgivSvfGzgWyRlE6G6hFG3LPwciLKQ4EelhQs4p9SdaCFaGxz51iett8NSHduNDALI+kDQ=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e6c0e92-430e-4eea-d010-08d6e4e0c145
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2019 09:25:28.4279
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ruxandra.radulescu@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4018
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Sent: Thursday, May 30, 2019 1:15 AM
> To: netdev@vger.kernel.org
> Cc: tglx@linutronix.de; David S. Miller <davem@davemloft.net>; Sebastian
> Andrzej Siewior <bigeasy@linutronix.de>; Ioana Ciocoi Radulescu
> <ruxandra.radulescu@nxp.com>
> Subject: [PATCH net-next 4/7] dpaa2-eth: Use napi_alloc_frag()
>=20
> The driver is using netdev_alloc_frag() for allocation in the
> ->ndo_start_xmit() path. That one is always invoked in a BH disabled
> region so we could also use napi_alloc_frag().
>=20
> Use napi_alloc_frag() for skb allocation.
>=20
> Cc: Ioana Radulescu <ruxandra.radulescu@nxp.com>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Acked-by: Ioana Radulescu <ruxandra.radulescu@nxp.com>

Thanks,
Ioana
