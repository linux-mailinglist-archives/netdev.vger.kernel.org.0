Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B9CEBB3F4
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 14:40:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437280AbfIWMkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 08:40:00 -0400
Received: from mail-eopbgr30048.outbound.protection.outlook.com ([40.107.3.48]:39034
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404312AbfIWMkA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Sep 2019 08:40:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ACa612EAjot5MVcQBqgfacC7bYWsOgt20R8qep3mxANsUQcOUX3eoPJZFqBh4D5sVRrYvO8cp2PGKFY6ROtEsS8dfqkCeiJd4brf5ZXZ1JejGcFNxMaCuaODTCi7U+EiCLUQdVvJNz0PsvPd5DwJgoQmiYHpcwAbHknu/Zkr1s8awkCnjDf/z4LvuagGdQbe49yvNlj9f/Inyii40Z2FuS9hc6uWhrgZBoJggc9syvANc8hfNZExZMtz+uJnPnLOrZw0x60x+pMFL6zk2dCk8OZsyXhf/gQXXLR9R6yYry9FgnobifivBkyC7dwwQOFAy/ShwSyPE3khJnBJiYC3Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SNorlOk01z5SjdrjEbsRcvridvWR2m10uOmq3ezLRtA=;
 b=lSzla7NKbTVtGMNSB8B6dtbeV1OUSQ2wR5nZZn6jRE3lkI46fbgjeR/lqEAHu0NWLvH1pVSvvO9SsLh8FrNNOC7kVRuxCf4xMxI2z6Ak/x06vGMfsKDnZngaGe0Rqirgn5gcqe9ePxFHL5x7B9EdfABQ/qqSmIjPbKt1vUzxj1hhLbEhgm0PN26/YkQaFeTf/b54Qk5niUfe30FTVUoj4xoJ/+W7nlvB/bj4/gHzTozRaCchoKD/hrRWVOVomR60VqirDDCtApL83B9InRpqnPLK/FaJ8kr5v248IDXGH1GDcxxrQu1I6upEtg8uTRAy8V9Bsvka0/Sx3qjzLx6mBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SNorlOk01z5SjdrjEbsRcvridvWR2m10uOmq3ezLRtA=;
 b=R5kR/pFo347pPzcVtQIm2B3MCZYP02gq94Keea4TyM97h5W3I0ujqC8Wvt5ibpSXCoXkrd11oI2vacCT6DHReI5T8GnUIZnu1M4PLjt4DgJwm35qWdiRshyzWDIK2vgtUo1DYxoY9eVw1jtO/sVE63dQWd2covK1TMlzUwMNo0k=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2339.eurprd05.prod.outlook.com (10.165.45.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.25; Mon, 23 Sep 2019 12:39:57 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::dd87:8e2c:f7ed:e29b]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::dd87:8e2c:f7ed:e29b%9]) with mapi id 15.20.2284.023; Mon, 23 Sep 2019
 12:39:57 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 4.19-stable 0/7] mlx5 checksum fixes for 4.19
Thread-Topic: [PATCH 4.19-stable 0/7] mlx5 checksum fixes for 4.19
Thread-Index: AQHVcgwB/2sgPTp/G0Cxcdv8yvTygQ==
Date:   Mon, 23 Sep 2019 12:39:57 +0000
Message-ID: <20190923123917.16817-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [89.138.141.98]
x-clientproxiedby: BYAPR03CA0036.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::49) To AM4PR0501MB2756.eurprd05.prod.outlook.com
 (2603:10a6:200:5c::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7a7914c6-bb85-4a2b-e669-08d7402323f0
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2339;
x-ms-traffictypediagnostic: AM4PR0501MB2339:|AM4PR0501MB2339:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB233913817DA54B200C39EF13BE850@AM4PR0501MB2339.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0169092318
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(136003)(39860400002)(396003)(366004)(189003)(199004)(6436002)(81156014)(81166006)(54906003)(71200400001)(2616005)(1076003)(476003)(6512007)(71190400001)(305945005)(66066001)(36756003)(486006)(316002)(478600001)(102836004)(7736002)(66946007)(52116002)(186003)(66476007)(8936002)(6916009)(107886003)(14454004)(26005)(50226002)(5660300002)(99286004)(256004)(64756008)(3846002)(6486002)(2906002)(66446008)(8676002)(86362001)(25786009)(6116002)(66556008)(4326008)(6506007)(386003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2339;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 9270HNXXMd5K0VaxLkffDCf+RAnS/ycljMyF8DshT6OjvY6EyQfzxdBghmHhWMJ1wOMcpAmKMKg/4IcCyCmG+yLw1cuhGSeVK7yD0SWFjskqCbW6TUQbh8LIgSopKyrPG+ays9Ceny+ac2zdUzJpVNYnXj8Kp0fc/2PoqH5cXIsiUOiu7gAbMnKwwNYJo9W9WMoxgrUEZTmUmRrHlId3SB/XlOpirod7M2QwUZ/EQiR7J0NMFxtdi2YQJ4BW4r1sb99K3S5y25WS3xWx7G3wjjPfwEYSCHavmfUgS2OIG5RHLjugcmiyIoK0mKEeRECcvv9EkKEgWL0vWGzMppcTSlaSKS8CSFkPRy1425KkA4BGD+fDjJmcGrYCtxj86TqLo74YHzFJEubEsTKxUQ0KquzDzcHXQDVjzSq5Gm/i09M=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a7914c6-bb85-4a2b-e669-08d7402323f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2019 12:39:57.1365
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J4C8jQyDmCX42HtAZ/qeXqymD6F8LEJlLc+hjSY+YGv+GAsgcbxocYqtRYD4/DgOVjajQLStLs3+3gG0TUXyBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2339
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Greg,

This series includes some upstream patches aimed to fix multiple checksum
issues with mlx5 driver in 4.19-stable kernels.

Since the patches didn't apply cleanly to 4.19 back when they were
submitted for the first time around 5.1 kernel release to the netdev
mailing list, i couldn't mark them for -stable 4.19, so now as the issue
is being reported on 4.19 LTS kernels, I had to do the backporting and
this submission myself.
=20
This series required some dependency patches and some manual touches
to apply some of them.

Please apply to 4.19-stable and let me know if there's any problem.
I tested and the patches apply cleanly and work on top of: v4.19.75

Thanks,
Saeed.=20

---

Alaa Hleihel (1):
  net/mlx5e: don't set CHECKSUM_COMPLETE on SCTP packets

Cong Wang (1):
  mlx5: fix get_ip_proto()

Natali Shechtman (1):
  net/mlx5e: Set ECN for received packets using CQE indication

Or Gerlitz (1):
  net/mlx5e: Allow reporting of checksum unnecessary

Saeed Mahameed (3):
  net/mlx5e: XDP, Avoid checksum complete when XDP prog is loaded
  net/mlx5e: Rx, Fixup skb checksum for packets with tail padding
  net/mlx5e: Rx, Check ip headers sanity

 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   3 +
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |  28 ++++
 .../net/ethernet/mellanox/mlx5/core/en_main.c |   8 ++
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 126 +++++++++++++++---
 .../ethernet/mellanox/mlx5/core/en_stats.c    |   9 ++
 .../ethernet/mellanox/mlx5/core/en_stats.h    |   6 +
 6 files changed, 165 insertions(+), 15 deletions(-)

--=20
2.21.0

