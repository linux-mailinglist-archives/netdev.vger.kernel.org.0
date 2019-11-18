Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4560E100942
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 17:33:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726813AbfKRQdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 11:33:31 -0500
Received: from mail-eopbgr790108.outbound.protection.outlook.com ([40.107.79.108]:48542
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726322AbfKRQdb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Nov 2019 11:33:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mzc+H+fzW3iMRt8NcUUz0/1UsAUf+BK4w3CCygQdvf5sQWEO9PtwhCcKnBsVwINTHsYKhQfH8hvaRVcr9MfWzxaf76xodoEAwOVVJiKMCB3yY7kwy9iaZkpo9ebn+rGf8Xk60J+BpLu0vuRXVc7+FqQz/msuhIXbpMaKcApwzsaW1xcHRN1/tBz1E80DhYS8S02t9i2EkmtJw4jBXiq5WP0b9EA68Qftl9dWmGky7ru6sM7tXKDpygIq7MDkE7n1deukGcZ9co7qR6f80f7y+xS5MufHMcUy/iPboWIC+d2+9IyQJtXJ3O8DnRfgYQlCBdvhwrHSf5/qYITE4A7kCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wYX+twZkjEJaM7LYiurxRVscCaFll+TmB6BHOd2FRcg=;
 b=NGEXRZU3wIKfomhaIvtAHewpTgppCBLaqNY3tU6iPRSLgUiNHlQ72Yk9G///eDTPb10sJ6tssjj2SHMn5SZPo5zBWS+hKu+9aXDDuPHbI1HsY7QuLesMna8VLhXp/cEWvwZJi+BYJphUSDYq4uOUjtLKGEfu76AyBeRu3LThsg0rw18jhDLfO0O5OTqfbnwYcfqyD7lx7alxItfrUOl/pRCMjo8OcdVZrNoSoDj37KlMlYmnr0xDylnnxuj3Eu3g20mMdxeV6bEXJzyGPw1AXocQxZf1ZP6ba4HiIteOhtvoY/9iPzQ/oag0CACO3QF5YSlfFOreLMZNdnGsg7aDZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wYX+twZkjEJaM7LYiurxRVscCaFll+TmB6BHOd2FRcg=;
 b=NjG8+n1OkA+dhHRUsDrnMfTWug53l643OPruHUJhtzfqAkDWqwl8IXcNcWBL5UZ2GEYMfgglgPp0+OzRfyRBe5x1vN99IYfIqiLa5mSbM241IpN6xeP2gE6YWwPlei3gNR4F5OyyaPJ+B5e48aX0/xt62i2WeJS9tm0yuCHIej8=
Received: from DM6PR21MB1242.namprd21.prod.outlook.com (20.179.50.86) by
 DM6PR21MB1147.namprd21.prod.outlook.com (20.179.50.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.0; Mon, 18 Nov 2019 16:33:28 +0000
Received: from DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::2c55:a47d:cd39:94d6]) by DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::2c55:a47d:cd39:94d6%9]) with mapi id 15.20.2474.015; Mon, 18 Nov 2019
 16:33:28 +0000
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (13.77.154.182) by CY4PR01CA0019.prod.exchangelabs.com (2603:10b6:903:1f::29) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Mon, 18 Nov 2019 16:33:27 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     "sashal@kernel.org" <sashal@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Haiyang Zhang <haiyangz@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH net, 0/2] Fix send indirection table offset
Thread-Topic: [PATCH net, 0/2] Fix send indirection table offset
Thread-Index: AQHVni3nXKSQXzj1fEmogVoKSCv0gQ==
Date:   Mon, 18 Nov 2019 16:33:27 +0000
Message-ID: <1574094751-98966-1-git-send-email-haiyangz@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CY4PR01CA0019.prod.exchangelabs.com (2603:10b6:903:1f::29)
 To DM6PR21MB1242.namprd21.prod.outlook.com (2603:10b6:5:169::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=lkmlhyz@microsoft.com; 
x-ms-exchange-messagesentrepresentingtype: 2
x-mailer: git-send-email 1.8.3.1
x-originating-ip: [13.77.154.182]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5aa61180-534f-4233-635d-08d76c450a48
x-ms-traffictypediagnostic: DM6PR21MB1147:|DM6PR21MB1147:|DM6PR21MB1147:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <DM6PR21MB1147151199AE64A965DF407AAC4D0@DM6PR21MB1147.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2399;
x-forefront-prvs: 0225B0D5BC
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(39860400002)(396003)(136003)(346002)(366004)(199004)(189003)(22452003)(2906002)(2201001)(6506007)(7736002)(6116002)(52116002)(3846002)(71200400001)(71190400001)(256004)(305945005)(66946007)(66446008)(22746008)(66476007)(4744005)(10090500001)(5660300002)(478600001)(10290500003)(4720700003)(25786009)(36756003)(66066001)(486006)(316002)(102836004)(64756008)(66556008)(7846003)(6436002)(6392003)(6486002)(110136005)(54906003)(2616005)(956004)(476003)(2501003)(16526019)(186003)(6512007)(81166006)(81156014)(8676002)(26005)(386003)(4326008)(50226002)(8936002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1147;H:DM6PR21MB1242.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +Fuo2y466eLXz8qX9B4IF5px7vGXd5QrQnAU891GdC5ZogT46DZUD7Z/jCEhVRWdUoorFtRTYKYpa+j+0vfmKhG7qiakJp3DNmtr1wOKK3tRFkenu+jUpWWOT/d5nk53i0ix/7uDoxYSZB+Sv8BBG2uhAGPdrFUBQeq7hlcaD7wCBR6BOIaG+8Xmzl+KTK1bm+YWROuAbkvMUR9s/MWc5MgXpLFdZouNKZJ6JIEUfxOZRyN9m3TJ+JfnLdqbS7MmgMceBtURillsIrSz2q5zJtPNwmP8nfPOdfE6k3Qr8HlcOHVqMeTrYMgyiF71zhFsAFAQAYD+ExU8XHV1KtZjLWdVT3ENkblz1WYBapirZMEYMgwL6sUXblf6tiyT1GOmnIMaALfWZGX+Kbw48xUS29B8qvIRktqx2py19sCbqBBpLZ+eydA6acPHhMbyjk4A
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5aa61180-534f-4233-635d-08d76c450a48
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2019 16:33:28.0022
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Z7oTEeFzC8S9GizIIq96ItxqkKvCovOtIcbUDfVQw6hs+8LzQ9HN43eF/feLHI8+OeypU1yDoP2LxIG53RYc/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1147
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix send indirection table offset issues related to guest and
host bugs.


Haiyang Zhang (2):
  hv_netvsc: Fix offset usage in netvsc_send_table()
  hv_netvsc: Fix send_table offset in case of a host bug

 drivers/net/hyperv/hyperv_net.h |  3 ++-
 drivers/net/hyperv/netvsc.c     | 35 +++++++++++++++++++++++++++--------
 2 files changed, 29 insertions(+), 9 deletions(-)

--=20
1.8.3.1

