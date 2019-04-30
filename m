Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 376E6F0C0
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 08:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbfD3G4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 02:56:55 -0400
Received: from mail-eopbgr30067.outbound.protection.outlook.com ([40.107.3.67]:60550
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725554AbfD3G4y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 02:56:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nm+tlmTLqZKa7+e3MrJ3ndlH/Y/ArNw7rbAm79fECKw=;
 b=U+l77yR0VtdRR8QEpPtRYQRmNr3mi3jvuMFkXkU+RnCPeZ6Mx8gIBAZLHmVFdPVJNLhb+Z8gh9VpTdfo6s889djXIU1y6sA3MI4moV8xdaHhpHdB1Vmy/HDplQMFz5DZMBKG4fMe2LB5AEuFUvs87SJ4rUZcFVFRoFWXqVa5Pjc=
Received: from AM0PR05MB6497.eurprd05.prod.outlook.com (20.179.34.15) by
 AM0PR05MB5745.eurprd05.prod.outlook.com (20.178.112.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.14; Tue, 30 Apr 2019 06:56:52 +0000
Received: from AM0PR05MB6497.eurprd05.prod.outlook.com
 ([fe80::151:4fc5:f798:6ef1]) by AM0PR05MB6497.eurprd05.prod.outlook.com
 ([fe80::151:4fc5:f798:6ef1%5]) with mapi id 15.20.1835.018; Tue, 30 Apr 2019
 06:56:52 +0000
From:   Ido Schimmel <idosch@mellanox.com>
To:     David Ahern <dsahern@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH v3 net-next 2/3] ipv4: Pass fib_nh_common to
 rt_cache_route
Thread-Topic: [PATCH v3 net-next 2/3] ipv4: Pass fib_nh_common to
 rt_cache_route
Thread-Index: AQHU/qbCe9f1MD8ckEOE7QzJjPtlxKZURnaA
Date:   Tue, 30 Apr 2019 06:56:52 +0000
Message-ID: <20190430065649.GA20525@splinter>
References: <20190429161619.23671-1-dsahern@kernel.org>
 <20190429161619.23671-3-dsahern@kernel.org>
In-Reply-To: <20190429161619.23671-3-dsahern@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6PR08CA0027.eurprd08.prod.outlook.com
 (2603:10a6:20b:c0::15) To AM0PR05MB6497.eurprd05.prod.outlook.com
 (2603:10a6:208:13f::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=idosch@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b6898dfc-8ab7-45e5-1115-08d6cd390625
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB5745;
x-ms-traffictypediagnostic: AM0PR05MB5745:
x-microsoft-antispam-prvs: <AM0PR05MB5745F6E5BE22ECAC28DA037ABF3A0@AM0PR05MB5745.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2512;
x-forefront-prvs: 00235A1EEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(366004)(396003)(346002)(136003)(39860400002)(376002)(189003)(199004)(476003)(186003)(4744005)(486006)(71200400001)(76176011)(5660300002)(6246003)(33716001)(4326008)(102836004)(71190400001)(6506007)(11346002)(8676002)(25786009)(8936002)(81156014)(81166006)(26005)(2906002)(52116002)(446003)(97736004)(9686003)(6512007)(7736002)(1076003)(53936002)(305945005)(386003)(99286004)(478600001)(229853002)(3846002)(6486002)(66476007)(64756008)(66946007)(66066001)(66446008)(256004)(316002)(86362001)(54906003)(14454004)(6436002)(33656002)(6116002)(6916009)(73956011)(66556008)(68736007);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB5745;H:AM0PR05MB6497.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: BpFU5tt1dLhzXG9ckhpFEailBqfT+z/TgxhxppJbxmEzyHqDY79lOaTIKvj/ab3RJWh23w1xcn3kkCKgS5KPUnF329sFEKZHyxULJtAW/u/uUYqK+jTlTz0ZNoZRQBm5mp0dO5EMqXJ3KTcMtR/Py9OmheWkVyNbnc9EF/Wit3/gdUEqO9p6sStDSkvClHTZIdbOYiavp5N2GVJGEdydU4d5dqNmmDW/2+7+fTuyJIfA+G2io8+DnlL9wM9y3aQBhbFJirXNQ1bOn46sph2gVyUJInenu+21MHepaWF5+mVvH0Jtdhlcnr3bz/GufSeVnedknRSxm8YLHUC1xkCJBucx7p7AsO+n+Zrum2O7KCnrIc9jEV2QcwEBp+CZXv/BAKC3g9m8Oh/QZLgUB2oHknDBrn3bLAMO+6cVQeDpKdM=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D0007AF2AF66D24C8C61A5BBE6B9D2C1@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6898dfc-8ab7-45e5-1115-08d6cd390625
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2019 06:56:52.1924
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5745
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 29, 2019 at 09:16:18AM -0700, David Ahern wrote:
> From: David Ahern <dsahern@gmail.com>
>=20
> Now that the cached routes are in fib_nh_common, pass it to
> rt_cache_route and simplify its callers. For rt_set_nexthop,
> the tclassid becomes the last user of fib_nh so move the
> container of under the #ifdef CONFIG_IP_ROUTE_CLASSID.
>=20
> Signed-off-by: David Ahern <dsahern@gmail.com>

Reviewed-by: Ido Schimmel <idosch@mellanox.com>
