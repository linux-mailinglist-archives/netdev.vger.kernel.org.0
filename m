Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32BC32F957
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 11:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727314AbfE3JYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 05:24:50 -0400
Received: from mail-eopbgr70078.outbound.protection.outlook.com ([40.107.7.78]:30021
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726382AbfE3JYu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 May 2019 05:24:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/zMarMwZwutH5Z5IY8yQUbXXp4Q3LFBhimaYD4+otXM=;
 b=Jf/tiUAtcdsDB7F7TRHrvyiRGPZkN6vbSUaRyAQmiVibPfLVmJ02HApS5OqRR+TLSYoP0slv7hNn/FAzUaKb4FQI2sJQDkxMsPMQwdOjAPqKw+3BmYOX1Sv0+kFRsD8P+AJC4k3ugU+nOoMcyeJ1skMDRvRu6N3wuAF5kmqyrr8=
Received: from AM0PR04MB4994.eurprd04.prod.outlook.com (20.177.40.15) by
 AM0PR04MB4018.eurprd04.prod.outlook.com (52.134.90.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.18; Thu, 30 May 2019 09:24:46 +0000
Received: from AM0PR04MB4994.eurprd04.prod.outlook.com
 ([fe80::852c:1146:c756:66c4]) by AM0PR04MB4994.eurprd04.prod.outlook.com
 ([fe80::852c:1146:c756:66c4%5]) with mapi id 15.20.1922.021; Thu, 30 May 2019
 09:24:46 +0000
From:   Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: RE: [PATCH net-next 3/7] dpaa2-eth: Remove preempt_disable() from
 seed_pool()
Thread-Topic: [PATCH net-next 3/7] dpaa2-eth: Remove preempt_disable() from
 seed_pool()
Thread-Index: AQHVFmwJxRMR+P9nW0yrAVuF6NXqMaaDY4lw
Date:   Thu, 30 May 2019 09:24:46 +0000
Message-ID: <AM0PR04MB49941E78509985AF61D7AFD194180@AM0PR04MB4994.eurprd04.prod.outlook.com>
References: <20190529221523.22399-1-bigeasy@linutronix.de>
 <20190529221523.22399-4-bigeasy@linutronix.de>
In-Reply-To: <20190529221523.22399-4-bigeasy@linutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ruxandra.radulescu@nxp.com; 
x-originating-ip: [192.88.166.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a7fe54fe-d15f-4705-157c-08d6e4e0a86e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR04MB4018;
x-ms-traffictypediagnostic: AM0PR04MB4018:
x-microsoft-antispam-prvs: <AM0PR04MB40183D52434DEE45D52A07EA94180@AM0PR04MB4018.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:525;
x-forefront-prvs: 00531FAC2C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(39860400002)(136003)(366004)(376002)(396003)(189003)(199004)(13464003)(81156014)(8936002)(54906003)(68736007)(229853002)(33656002)(486006)(3846002)(110136005)(81166006)(6116002)(99286004)(316002)(25786009)(7696005)(256004)(478600001)(55016002)(6506007)(66066001)(53546011)(7736002)(71190400001)(305945005)(102836004)(76116006)(6436002)(186003)(74316002)(446003)(53936002)(26005)(2501003)(4326008)(73956011)(66946007)(6246003)(8676002)(14454004)(66446008)(9686003)(76176011)(476003)(5660300002)(11346002)(71200400001)(52536014)(86362001)(66476007)(2906002)(66556008)(64756008);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB4018;H:AM0PR04MB4994.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: e0H7t6TVtY3vMNmNBcUI/4cGYrPv3WA303TePjjhS23ES6uN+2RibBXDEcUBizg9OEpv9DztfMrgKf89Yc4H22hV4O5IXsoADiU1VjEzPRsNgm/ZvNXe3WF0p4z7GwuE545ln7kIIU9cPTVFR/yIjwbcAOaM6b12I/m+OFdUPaYveAl9hqZx4pDegnTV3DeTaJPJ173Z1rmcNYe7uAgaKyTupP+UYo30TAzJDKw/J4iSZvSw4pPAbJpQZkMNt1pARVAAu151g8U9pgNla17PUP5G/QfDSVeS4Pa+GpR4Dn5uoIynhmInYVKjoGwc4E1nl1R3R3ZDA8oaaq9tz9rnLGUg7zi0arASXBaTSiegpBglCTE7qgDi1Jl+pH8r3jQ6fiCP9ufJlqd7yxwelVQnbwh/8LJwdvUts8HVwsEiV00=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7fe54fe-d15f-4705-157c-08d6e4e0a86e
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2019 09:24:46.7838
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
> Subject: [PATCH net-next 3/7] dpaa2-eth: Remove preempt_disable() from
> seed_pool()
>=20
> According to the comment, the preempt_disable() statement is required
> due to synchronisation in napi_alloc_frag(). The awful truth is that
> local_bh_disable() is required because otherwise the NAPI poll callback
> can be invoked while the open function setup buffers. This isn't
> unlikely since the dpaa2 provides multiple devices.
>=20
> The usage of napi_alloc_frag() has been removed in commit
>=20
>  27c874867c4e9 ("dpaa2-eth: Use a single page per Rx buffer")
>=20
> which means that the comment is not accurate and the preempt_disable()
> statement is not required.
>=20
> Remove the outdated comment and the no longer required
> preempt_disable().
>=20
> Cc: Ioana Radulescu <ruxandra.radulescu@nxp.com>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Acked-by: Ioana Radulescu <ruxandra.radulescu@nxp.com>

Thanks,
Ioana
