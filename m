Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EBFB36C38
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 08:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbfFFGZt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 02:25:49 -0400
Received: from mail-eopbgr10082.outbound.protection.outlook.com ([40.107.1.82]:29710
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725267AbfFFGZs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 02:25:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6okJqbguMhu/7UCQQ6z6/dC9QmzsFlb27VntAyD0iBs=;
 b=GfyU+014Lzqd0xYpnBhUmhBrmiVcyPOEbRaKfy0EzSpeMTUeXz2tClZLD0RHylzBCw/EfHWh3p+ortmNmVvdmgicaGQVdtOBx1kDqMjH58mvp6Hf5/OgtcYsqo/nUYHrEJWTnLeAk6iKvflEaKqDV3a8mw6JpXxiuLBU0qS6XB0=
Received: from AM0PR04MB4994.eurprd04.prod.outlook.com (20.177.40.15) by
 AM0PR04MB5955.eurprd04.prod.outlook.com (20.178.112.75) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.12; Thu, 6 Jun 2019 06:25:45 +0000
Received: from AM0PR04MB4994.eurprd04.prod.outlook.com
 ([fe80::5cc8:5731:41ba:1709]) by AM0PR04MB4994.eurprd04.prod.outlook.com
 ([fe80::5cc8:5731:41ba:1709%7]) with mapi id 15.20.1943.018; Thu, 6 Jun 2019
 06:25:45 +0000
From:   Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>
To:     David Miller <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: RE: [PATCH net-next 2/3] dpaa2-eth: Support multiple traffic classes
 on Tx
Thread-Topic: [PATCH net-next 2/3] dpaa2-eth: Support multiple traffic classes
 on Tx
Thread-Index: AQHVG4UWlYcUlbQxy0GdgO2+gYYloKaN3DwAgABNy3A=
Date:   Thu, 6 Jun 2019 06:25:45 +0000
Message-ID: <AM0PR04MB4994D6FBBAE9783800B9B1A594170@AM0PR04MB4994.eurprd04.prod.outlook.com>
References: <1559728646-4332-1-git-send-email-ruxandra.radulescu@nxp.com>
        <1559728646-4332-3-git-send-email-ruxandra.radulescu@nxp.com>
 <20190605.184620.1429935652147545143.davem@davemloft.net>
In-Reply-To: <20190605.184620.1429935652147545143.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ruxandra.radulescu@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 40d3272f-ebe7-4587-64fb-08d6ea47cec6
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR04MB5955;
x-ms-traffictypediagnostic: AM0PR04MB5955:
x-microsoft-antispam-prvs: <AM0PR04MB595541EF9AE25448DCCB17E194170@AM0PR04MB5955.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2150;
x-forefront-prvs: 00603B7EEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(366004)(346002)(39860400002)(396003)(136003)(189003)(13464003)(22813001)(199004)(8936002)(14454004)(6916009)(74316002)(25786009)(6436002)(6246003)(81166006)(256004)(5660300002)(7736002)(86362001)(68736007)(478600001)(446003)(476003)(486006)(11346002)(4326008)(4744005)(7696005)(76116006)(99286004)(305945005)(8676002)(81156014)(229853002)(3846002)(66556008)(66476007)(2906002)(66946007)(6116002)(66446008)(64756008)(55016002)(73956011)(9686003)(26005)(71200400001)(71190400001)(54906003)(186003)(53936002)(102836004)(53546011)(76176011)(316002)(6506007)(66066001)(52536014)(33656002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB5955;H:AM0PR04MB4994.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: TEcJObFpLL5OG85jjDRwfIXrKCYrWPvH8rMXc9RkYyyoij2YxCFbFKddRDIVDV/DtA29hWh6FC+lF8ennujU0VY6/qaK9bpjEXwHx+V1pKOAG4t72sblNpavP9oKw2XKM5lS1YhS0TTgWQ9Ukgj5TahAQ9qtptMQi5GhStDswGXb9pjyUtNHtzISDNgwzt/Rd9Mk80PKjCsrncE5JdlKN+BViNubOCjqPK8kXhvxW6fKGvggZ+cr7VwzxXtSzrfLD3JHSxqmeeiFXo2ZVPn/8puKXFnsCPaWFQ+0FdRknAdO23Jhal+FV2YOr0nHhT6wX7Qc607JLBWa4CFuj0R7nvYzFaFhVAz73woEpJKL9EGQ/bw+AuAcVl1hlnRUA8rdQTHhQ75Ok1uui/fIkDUts9Qr1OZQ64ga0aIKDl/dmRo=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40d3272f-ebe7-4587-64fb-08d6ea47cec6
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2019 06:25:45.1050
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ruxandra.radulescu@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5955
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: David Miller <davem@davemloft.net>
> Sent: Thursday, June 6, 2019 4:46 AM
> To: Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>
> Cc: netdev@vger.kernel.org; Ioana Ciornei <ioana.ciornei@nxp.com>
> Subject: Re: [PATCH net-next 2/3] dpaa2-eth: Support multiple traffic cla=
sses
> on Tx
>=20
> From: Ioana Radulescu <ruxandra.radulescu@nxp.com>
> Date: Wed,  5 Jun 2019 12:57:25 +0300
>=20
> > +	queue_mapping %=3D dpaa2_eth_queue_count(priv);
>=20
> You are now performing a very expensive modulus operation every single TX
> packet, regardless of whether TC is in use or not.
>=20
> The whole reason we store the queue mapping pre-cooked in the SKB is so
> that you don't have to do this.

Good point, thanks. Will refactor and send a v2.

Ioana
