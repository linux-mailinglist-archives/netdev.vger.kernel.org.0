Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B81B049E6D
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 12:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729369AbfFRKm1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 06:42:27 -0400
Received: from mail-eopbgr50084.outbound.protection.outlook.com ([40.107.5.84]:29615
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729268AbfFRKm1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 06:42:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4OiHxy2V2xZZ3EvIadVD37aUv5krXobTWUWT6ikAJMo=;
 b=ieVbAy4DOIpYPMpJwOQxR1VxuNAo56sbKRToAaylNpW/4RhvIKrixByDRjWW5TWknvQN7unBkF9T9SqgXIen6FaDkk6Upu2QW7M4aHYh6tYRLrwb1qN1iPQoDEbfFEyHlXjyAltdRJvW+r3ALx2WFU50zlGdaQDjrSAjZA9FSb0=
Received: from AM4PR05MB3137.eurprd05.prod.outlook.com (10.171.186.14) by
 AM4PR05MB3123.eurprd05.prod.outlook.com (10.171.186.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.15; Tue, 18 Jun 2019 10:42:23 +0000
Received: from AM4PR05MB3137.eurprd05.prod.outlook.com
 ([fe80::bc5a:ba8b:1a69:91b6]) by AM4PR05MB3137.eurprd05.prod.outlook.com
 ([fe80::bc5a:ba8b:1a69:91b6%6]) with mapi id 15.20.1987.014; Tue, 18 Jun 2019
 10:42:23 +0000
From:   Leon Romanovsky <leonro@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Bodong Wang <bodong@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        Mark Bloch <markb@mellanox.com>
Subject: Re: [PATCH mlx5-next 14/15] {IB, net}/mlx5: E-Switch, Use index of
 rep for vport to IB port mapping
Thread-Topic: [PATCH mlx5-next 14/15] {IB, net}/mlx5: E-Switch, Use index of
 rep for vport to IB port mapping
Thread-Index: AQHVJUIqpjj0/zKL/kquOc3ZH7UhNaahOn4A
Date:   Tue, 18 Jun 2019 10:42:23 +0000
Message-ID: <20190618104220.GH4690@mtr-leonro.mtl.com>
References: <20190617192247.25107-1-saeedm@mellanox.com>
 <20190617192247.25107-15-saeedm@mellanox.com>
In-Reply-To: <20190617192247.25107-15-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM7PR04CA0030.eurprd04.prod.outlook.com
 (2603:10a6:20b:110::40) To AM4PR05MB3137.eurprd05.prod.outlook.com
 (2603:10a6:205:3::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=leonro@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ab71102f-179c-4d6f-e97f-08d6f3d9a589
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR05MB3123;
x-ms-traffictypediagnostic: AM4PR05MB3123:
x-microsoft-antispam-prvs: <AM4PR05MB3123CDCA8106E64C87FCBBCEB0EA0@AM4PR05MB3123.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 007271867D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(39860400002)(376002)(346002)(366004)(189003)(199004)(99286004)(6486002)(256004)(450100002)(53936002)(68736007)(26005)(6246003)(186003)(107886003)(54906003)(73956011)(4744005)(4326008)(66946007)(66556008)(64756008)(5660300002)(305945005)(1076003)(33656002)(229853002)(6862004)(478600001)(7736002)(66476007)(14454004)(9686003)(2906002)(6116002)(25786009)(81166006)(6512007)(81156014)(71200400001)(316002)(66066001)(8676002)(71190400001)(66446008)(386003)(486006)(52116002)(6436002)(76176011)(3846002)(102836004)(8936002)(6506007)(11346002)(6636002)(446003)(86362001)(476003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3123;H:AM4PR05MB3137.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Kd7PO73qRl+P/2kP+poPw7NY4r07+aqk8SZMxFpmsIGy1fEdvc4qxvqFxsJxHsVr9leI0GOCvpvvE+Odch7VFtnQZq8ak8KZT7puA41n87Rj8jk3eCYOwp+Vy99KkhhHVvCtvCGTiEa5FvqegnHtyjP41Ixv7LxR6L1qZSbUsaSE30O3AVUVu9eSsbxleB83EIhwuEc/b7MgcfrikB41AablhsRIt3vIdxXXTQNbT1tmQrBJQSwFp+QdhdaB302tgrN3UCloLDzFxZ4Yy2GI0SdbIO/FH9qAGMqlj9puP3aIL13t7z7XF1t+ns38h+5OnLmNWuBhMyYME0JT08HrDMrxENBy62VgaXcOPy2wSylXOAE1jzmjxtTmxZEjii911CBRT9yHKB7/XQpByvk4oU7K8ysfaxVvhKImXeCr44Q=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <438C83407DC05A4DA2CCFF67389D0F6F@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab71102f-179c-4d6f-e97f-08d6f3d9a589
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2019 10:42:23.2963
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: leonro@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3123
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 17, 2019 at 07:23:37PM +0000, Saeed Mahameed wrote:
> From: Bodong Wang <bodong@mellanox.com>
>
> In the single IB device mode, the mapping between vport number and
> rep relies on a counter. However for dynamic vport allocation, it is
> desired to keep consistent map of eswitch vport and IB port.
>
> Hence, simplify code to remove the free running counter and instead
> use the available vport index during load/unload sequence from the
> eswitch.
>
> Signed-off-by: Bodong Wang <bodong@mellanox.com>
> Suggested-by: Parav Pandit <parav@mellanox.com>
> Reviewed-by: Parav Pandit <parav@mellanox.com>

We are not adding multiple "*-by" for same user, please choose one.

Thanks
