Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68A501075AB
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 17:21:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727455AbfKVQVM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 11:21:12 -0500
Received: from mail-eopbgr140051.outbound.protection.outlook.com ([40.107.14.51]:16870
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726666AbfKVQVL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 11:21:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WCAh2rv8TQDZI2YKUmXdZN2wrlqvtVOa3Ox3DoizUjt4Is19E0JBPM9/zNb6kpU347YPlyyypqOXHMMw7oiPwjnJgpIYrMchHxarwi9iwsLQM1+lPld9cioc3SfRNFeQcoHuq5QtGCJCyASVtPPGuLA7G2V3KM+dodRuuTjMrQmR0fav9aKNG/wpaJgqUvhn5SALswOx4chRpgXP1fBVBRWMoHxXUD3bNsnX8vwOOGhEnpdIRrN5vTRTgZFKVHSb4+enVg1mnortNqtZ9IPXqe/vZ91dorE0bZ36uKln2nZrzx+p2f5UxSFgY/524yitW2B4vjtbIqetpWqQGziOQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Pr3O5tmwJvfDdK5G4wwYUxD86FOH061U8Q+59s6ZPM=;
 b=PwWqmXbVRSpGawqYNivr+Xgrhp1hbRb2MKcWdx0l0SXI+DVVzCQDe5zsDneASqfDv+FX603m1bYwQU3TSzVYRQrBx0em2gOJgyPzcKfm0ND46x1sIIVzpdh05ryNxz3s0LQGnacBuQLEtDvElHKm2Pu94kbMO5P6CbpTqjIHvbuk41xMPCSniu8lVe87890tx/k+B+DnWLDJwjJiqGGZVa9gWLllWx/0WdfZO/9QFu6eOt+sLXrdKVmYkr80brmvJ0TETwWE7CJ7Rw9ruShCcgvZITbOC6i8F2S8XXfmM+FD2VHTX7hkLBzUVKUGtfwbeDbfTlem7eKeDF9KBhPiNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Pr3O5tmwJvfDdK5G4wwYUxD86FOH061U8Q+59s6ZPM=;
 b=sCM4pnh3phJyCbwiBe4VTPSQshe2xpj2TtWKIXQtBLhlN+89MfMxub2gRp+PLAL2SBqcbujbUA3znA5Jo/On6CsEvJaJ2W05AVFp+d3aYvSF++qNdh5EkuJilk1RpHsRQKym6WFE9o+je6wiqxfUO4UGZ8j210ODyJru4JklKkg=
Received: from AM4PR05MB3137.eurprd05.prod.outlook.com (10.171.188.155) by
 AM4PR05MB3313.eurprd05.prod.outlook.com (10.171.189.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.17; Fri, 22 Nov 2019 16:21:07 +0000
Received: from AM4PR05MB3137.eurprd05.prod.outlook.com
 ([fe80::70c3:1586:88a:1493]) by AM4PR05MB3137.eurprd05.prod.outlook.com
 ([fe80::70c3:1586:88a:1493%7]) with mapi id 15.20.2474.021; Fri, 22 Nov 2019
 16:21:07 +0000
From:   Leon Romanovsky <leonro@mellanox.com>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>
CC:     RDMA mailing list <linux-rdma@vger.kernel.org>,
        Danit Goldberg <danitg@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next 0/4] Get IB port and node GUIDs through
 rtnetlink
Thread-Topic: [PATCH rdma-next 0/4] Get IB port and node GUIDs through
 rtnetlink
Thread-Index: AQHVmu/Vfdk+oqiBkUy0e40m6XWwa6eXa8wA
Date:   Fri, 22 Nov 2019 16:21:07 +0000
Message-ID: <20191122162104.GE136476@unreal>
References: <20191114133126.238128-1-leon@kernel.org>
In-Reply-To: <20191114133126.238128-1-leon@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR01CA0126.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::31) To AM4PR05MB3137.eurprd05.prod.outlook.com
 (2603:10a6:205:8::27)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=leonro@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [5.29.147.182]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: cd9650a1-3a65-44b2-cea0-08d76f67fac1
x-ms-traffictypediagnostic: AM4PR05MB3313:|AM4PR05MB3313:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR05MB3313CEE4ECEEBD61E758BB4CB0490@AM4PR05MB3313.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 02296943FF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(4636009)(376002)(39860400002)(136003)(396003)(366004)(346002)(199004)(189003)(66556008)(6116002)(8676002)(186003)(8936002)(110136005)(316002)(256004)(26005)(99286004)(66946007)(6506007)(71200400001)(76176011)(102836004)(14454004)(386003)(64756008)(478600001)(81156014)(66446008)(5660300002)(66476007)(52116002)(11346002)(1076003)(81166006)(446003)(54906003)(25786009)(2906002)(86362001)(3846002)(7736002)(9686003)(6512007)(6246003)(4326008)(71190400001)(6486002)(6436002)(229853002)(33656002)(305945005)(66066001)(33716001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3313;H:AM4PR05MB3137.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nNovESItCFuLFais6KzUytwNgZR+OIqAwcrR95gKK8yqrcD0aGx3YhLRu5hvNgf4mfOTy5IB3sb502f/Bqy4u7Bvk3A9SebjEdIjNVBG6A9Gi04R+yWoXxw4pO0W2iyB9vf+a7++PrURdmaS9VB5GjZTJSkFZow7SYqjAU/CiBSkPDOatPMLb0U/Yee/ysyQO9uO5itDj/xyG0LHqYlAwEUJxhyCZtSWR8qpbbTui0lIINYe9M/pwPqAmKV3jUYxgHHZfJ06xzhp+OmGoHFOwJFpA9Dt7TsEpdD6LSIdll0D4DGPiZjyjjuJW5RST9Xn+1n+sqs5h6PHpS/ubuXB06GhFDlpfES+0K56sRBj47WMz52uEWLax+J8UFElAl3spzQHV0RFEVJ7uBbfOaIGy1Y/jr29cT04sAbXKtWO/vVZHSoXVOeyEcOraWqqfz+1
Content-Type: text/plain; charset="us-ascii"
Content-ID: <12BC2570BB9B814D82F352439080E489@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd9650a1-3a65-44b2-cea0-08d76f67fac1
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2019 16:21:07.7233
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JI+9U/k1EgOmi+jQIEfdC6gDtEn/4F04JYdiNoOX8Tigge+M4MEVKa5rdCFdMCaRGsLtchkxn2NXNAHS2JMAOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3313
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 14, 2019 at 03:31:21PM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
>
> Hi,
>
> This series from Danit extends RTNETLINK to provide IB port and node
> GUIDs, which were configured for Infiniband VFs.
>
> The functionality to set VF GUIDs already existed for a long time, and he=
re
> we are adding the missing "get" so that netlink will be symmetric
> and various cloud orchestration tools will be able to manage such
> VFs more naturally.
>
> The iproute2 was extended too to present those GUIDs.
>
> - ip link show <device>
>
> For example:
> - ip link set ib4 vf 0 node_guid 22:44:33:00:33:11:00:33
> - ip link set ib4 vf 0 port_guid 10:21:33:12:00:11:22:10
> - ip link show ib4
>     ib4: <BROADCAST,MULTICAST> mtu 4092 qdisc noop state DOWN mode DEFAUL=
T group default qlen 256
>     link/infiniband 00:00:0a:2d:fe:80:00:00:00:00:00:00:ec:0d:9a:03:00:44=
:36:8d brd 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
>     vf 0     link/infiniband 00:00:0a:2d:fe:80:00:00:00:00:00:00:ec:0d:9a=
:03:00:44:36:8d brd 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:f=
f:ff,
>     spoof checking off, NODE_GUID 22:44:33:00:33:11:00:33, PORT_GUID 10:2=
1:33:12:00:11:22:10, link-state disable, trust off, query_rss off
>
> Due to the fact that this series touches both net and RDMA, we assume
> that it needs to be applied to our shared branch (mlx5-next) and pulled
> later by Dave and Doug/Jason.
>
> Thanks
>
> Danit Goldberg (4):
>   net/core: Add support for getting VF GUIDs
>   IB/core: Add interfaces to get VF node and port GUIDs
>   IB/ipoib: Add ndo operation for getting VFs GUID attributes
>   IB/mlx5: Implement callbacks for getting VFs GUID attributes

Applied to mlx5-next,
Doug, Jason please pull.

9c0015ef0928 IB/mlx5: Implement callbacks for getting VFs GUID attributes
2446887ed226 IB/ipoib: Add ndo operation for getting VFs GUID attributes
bfcb3c5d1485 IB/core: Add interfaces to get VF node and port GUIDs
30aad41721e0 net/core: Add support for getting VF GUIDs

Thanks
