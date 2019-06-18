Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84EA849E89
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 12:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729547AbfFRKrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 06:47:47 -0400
Received: from mail-eopbgr10074.outbound.protection.outlook.com ([40.107.1.74]:7173
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729369AbfFRKrq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 06:47:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mbx46S6jbSy+lVmay/qD/glcj7tr5dLVJK/TGA7qVpc=;
 b=bOK1MwZkcYK3datyhVA6Fc9IcX25HtfVEClqmCc560Tib5qDojvomDILUi5dJmdGFYOH5WsmvjTUiFAM2NtCjVekc/LffHMjYBj6KXMC+PmpvJgPuK0fPC/lmwronhz3UMGKzhBHzQ2DBGUWbHA3ZZ4DWPi636bLlz5qK5RI8U8=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB6817.eurprd05.prod.outlook.com (10.186.172.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Tue, 18 Jun 2019 10:47:43 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::217d:2cd7:c8da:9279]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::217d:2cd7:c8da:9279%5]) with mapi id 15.20.1987.014; Tue, 18 Jun 2019
 10:47:43 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Leon Romanovsky <leonro@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Bodong Wang <bodong@mellanox.com>,
        Mark Bloch <markb@mellanox.com>
Subject: RE: [PATCH mlx5-next 14/15] {IB, net}/mlx5: E-Switch, Use index of
 rep for vport to IB port mapping
Thread-Topic: [PATCH mlx5-next 14/15] {IB, net}/mlx5: E-Switch, Use index of
 rep for vport to IB port mapping
Thread-Index: AQHVJUIqAgWKfMPcakyB0HLLwlGVt6ahOoGAgAABFdA=
Date:   Tue, 18 Jun 2019 10:47:42 +0000
Message-ID: <AM0PR05MB4866DF63BB7D80483630F0A9D1EA0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190617192247.25107-1-saeedm@mellanox.com>
 <20190617192247.25107-15-saeedm@mellanox.com>
 <20190618104220.GH4690@mtr-leonro.mtl.com>
In-Reply-To: <20190618104220.GH4690@mtr-leonro.mtl.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.22.216]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 507d1bfa-5fd8-4ffa-ae5d-08d6f3da644e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB6817;
x-ms-traffictypediagnostic: AM0PR05MB6817:
x-microsoft-antispam-prvs: <AM0PR05MB6817BD67D1FD966C8B59DA58D1EA0@AM0PR05MB6817.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 007271867D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(396003)(366004)(39860400002)(376002)(346002)(13464003)(189003)(199004)(7736002)(486006)(305945005)(99286004)(26005)(9456002)(229853002)(78486014)(53546011)(7696005)(55236004)(68736007)(446003)(6506007)(3846002)(478600001)(107886003)(53936002)(6246003)(6116002)(76176011)(8936002)(256004)(9686003)(450100002)(25786009)(4326008)(6636002)(14454004)(71190400001)(73956011)(11346002)(74316002)(5660300002)(66946007)(81156014)(71200400001)(102836004)(186003)(55016002)(52536014)(66066001)(64756008)(110136005)(66446008)(316002)(6436002)(8676002)(33656002)(54906003)(66556008)(76116006)(81166006)(2906002)(66476007)(86362001)(476003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB6817;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: JLLRfU0W2oXgFyo1P9hio/B99cwPoAz5oZJ4jUrSkt+61d806tHGoY3aw6rXO2DkVMxUg8NCacxOrEQbq+GUMlfXNnQ7Lslm1fGPRh4CkVnU1gAonL046MUOrC0OkuQXE/NEDcXkWhK33mdlACP/3APiv6xDFSMmNzpdrorrGhjwWX7ftA1wyYJBaw7sSsl5lOXTNA60OU0KWQiLe6/RVBr/7musbIIbCUva6Kk8GOo4EM9QitbgNyHvh1+IUUc1Rqu3pmPsMzk20rH2rqkiAfLX2ETQf2DtdCLYnVBjxg0vY0Dkb99mYtzctYwI37UdooYHItWW5w5m65UslmLn4XfINQdgLpN8a2HpkI6LBjUCGacU43f+BHMpap9MUlAVMwyiWPDKAu/gjgdDdDPDb3XxiAeKq35mSSU30rj6m4c=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 507d1bfa-5fd8-4ffa-ae5d-08d6f3da644e
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2019 10:47:42.9662
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: parav@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6817
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Leon,

> -----Original Message-----
> From: Leon Romanovsky
> Sent: Tuesday, June 18, 2019 4:12 PM
> To: Saeed Mahameed <saeedm@mellanox.com>
> Cc: netdev@vger.kernel.org; linux-rdma@vger.kernel.org; Bodong Wang
> <bodong@mellanox.com>; Parav Pandit <parav@mellanox.com>; Mark Bloch
> <markb@mellanox.com>
> Subject: Re: [PATCH mlx5-next 14/15] {IB, net}/mlx5: E-Switch, Use index =
of rep
> for vport to IB port mapping
>=20
> On Mon, Jun 17, 2019 at 07:23:37PM +0000, Saeed Mahameed wrote:
> > From: Bodong Wang <bodong@mellanox.com>
> >
> > In the single IB device mode, the mapping between vport number and rep
> > relies on a counter. However for dynamic vport allocation, it is
> > desired to keep consistent map of eswitch vport and IB port.
> >
> > Hence, simplify code to remove the free running counter and instead
> > use the available vport index during load/unload sequence from the
> > eswitch.
> >
> > Signed-off-by: Bodong Wang <bodong@mellanox.com>
> > Suggested-by: Parav Pandit <parav@mellanox.com>
> > Reviewed-by: Parav Pandit <parav@mellanox.com>
>=20
> We are not adding multiple "*-by" for same user, please choose one.
>=20
Suggested-by was added by Bodong during our discussion. Later on when I did=
 gerrit +1, RB tag got added.

> Thanks
