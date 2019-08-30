Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15FC7A365C
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 14:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727836AbfH3MIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 08:08:31 -0400
Received: from mail-eopbgr770053.outbound.protection.outlook.com ([40.107.77.53]:10067
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727521AbfH3MIb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Aug 2019 08:08:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EjNFEi05mnVPItiZ5rLpnDHKPT670oScjswogzhH0FasjoFv5jC3ufAcJRizWveJyjMtIXeGi1qz8rkZPoZxQne442qv3mPqFn7KhF5o8pRz7xV6RIB/QviNFKfpwT648+rrDd/SWbsbuq+G2ht0tFNnuDOnhkGgVSCDFgvqO/FbOhnCGgzDVTrTP4L8vgLqCb/v72Gym4aVMMiwB22951acMMiX2psvnVDCMhyfudh3KhACADuPGm+2815RpG0jXsRHADOgPwOXZY2lbDvnOTSX5+k6TtXf9SKW7JWQrxfp5SPSd8CXB9v9MbW+iuHoJTVNDTIAfkO7X0444olxOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oJxgBOJDpL/e/Z9xt3WGuDzwDE6z9HQECN5D86psxmA=;
 b=Q7ZJijlIohjF99Y2hnu0763bVQ7GNjnkXvOvN8mXykZR2nokcpRuND0VP2qvqH46k2sJUxRPtX3PXewVGZKe/p+UDyLFMohBSmKIOcgg01UHnXXC0LiCaaiEDwbBrY2IllkTHwwzdB4vYAs85zN9SKIEaQ6OnIf5zBc8DsPdghkvZIwZzKtO5EZHrcKE6YnNnqBhW20BFqL2oqGu6Otu6ckWXo3XZje5EL42RUWY5VuYjgz1dS5KkWxtuqB8Ymlj6a0Y/hPFi6hAcHYVLcJbx37YkBntI3qzHu/TTLYk37YDp8wY3nsLijfWajP2tQAhHazgFR5x2AveYDhPV1FLCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oJxgBOJDpL/e/Z9xt3WGuDzwDE6z9HQECN5D86psxmA=;
 b=Py0G/29dnchWtXAptFH9GKAc9RCF044od4Yd06KI0DPq1W9ATeywxDwqXosjK46LaURtyqIUxrtWXtFolpM95E9e90KwEpMPXlf6Wmp1T0Q3/ncpQbORGyBpuQqMh3jgqSGqqXBpw4VGCpAkUE8HkfnLBm6J3TAqMj4r25DnndI=
Received: from BN6PR11MB4081.namprd11.prod.outlook.com (10.255.128.166) by
 BN6PR11MB1684.namprd11.prod.outlook.com (10.173.28.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.16; Fri, 30 Aug 2019 12:08:28 +0000
Received: from BN6PR11MB4081.namprd11.prod.outlook.com
 ([fe80::95ec:a465:3f5f:e3e5]) by BN6PR11MB4081.namprd11.prod.outlook.com
 ([fe80::95ec:a465:3f5f:e3e5%3]) with mapi id 15.20.2220.013; Fri, 30 Aug 2019
 12:08:28 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "David S . Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>
Subject: [PATCH net 0/5] net: aquantia: fixes on vlan filters and other
 conditions
Thread-Topic: [PATCH net 0/5] net: aquantia: fixes on vlan filters and other
 conditions
Thread-Index: AQHVXyui7AATDwHFhkStapckJw4rMg==
Date:   Fri, 30 Aug 2019 12:08:28 +0000
Message-ID: <cover.1567163402.git.igor.russkikh@aquantia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1P195CA0012.EURP195.PROD.OUTLOOK.COM (2603:10a6:3:fd::22)
 To BN6PR11MB4081.namprd11.prod.outlook.com (2603:10b6:405:78::38)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 523f16a7-c247-47fc-ceb3-08d72d42c46e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN6PR11MB1684;
x-ms-traffictypediagnostic: BN6PR11MB1684:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR11MB168497D02F0655FB0CDCA9FD98BD0@BN6PR11MB1684.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2399;
x-forefront-prvs: 0145758B1D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(136003)(376002)(39840400004)(366004)(396003)(199004)(189003)(2906002)(476003)(6916009)(4744005)(4326008)(50226002)(99286004)(6436002)(305945005)(186003)(26005)(36756003)(478600001)(316002)(6486002)(6506007)(54906003)(25786009)(8936002)(107886003)(44832011)(52116002)(2616005)(3846002)(14454004)(102836004)(386003)(86362001)(53936002)(81156014)(6116002)(5660300002)(8676002)(81166006)(7736002)(6512007)(64756008)(66446008)(14444005)(256004)(66556008)(66476007)(66946007)(71190400001)(71200400001)(66066001)(486006)(79990200002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN6PR11MB1684;H:BN6PR11MB4081.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: dB9dqCe+tWi+9Jw0z+Qj3etUR1sZwyr3HUHTF/KzITuvGINRgzBaLi1WJAnak4/qbEqY2bdgRImT5fw0SV8YASjJPnw0Q/5tYS82HEgXFbRmozsKwYAXQiGB+1UQKuILifzEw6sQTj2tf58uKAZgKB4jNW7i3cb1Yz2v58RT9mlWBBmkZQoZcKh7+5G9AqTTk8yS08CvRsC0ixPvRgYoKJ73iNQ/OEzOO4aYOeXuSyIKdVO/RCAR+3aD7PFT1uhddVdJAs5jUV3nPfUnLlD6Z99jqXu4iKnIsvy8IPXvl7LHycMP7oamGVcFqc+Dv1OeNDGiRetCsSJAcM0mro3CgGZ3WTPdytENtT3krjrPLlZZIr+kfH2gH0BaLp/n6bKaJu0OXZkzxXJWoxWZMwXooATGlb4P/b0y+UJ+tI1Pu7VOwQQE1GNMPcsj/iWDSTCQx3lZ3o1strgAJuJJqvf4Dg==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 523f16a7-c247-47fc-ceb3-08d72d42c46e
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2019 12:08:28.6709
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: a1O70Zd2g0q/5q6KtrK4c3Zrfiw5+1TmvnuGbUjwyo7uVWw9DO07CxxfkZkv7aQHPKgrNR8tFNHqwi32/ZyB4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1684
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here is a set of various bug fixes related to vlan filter offload and
two other rare cases.

Dmitry Bogdanov (4):
  net: aquantia: fix removal of vlan 0
  net: aquantia: fix limit of vlan filters
  net: aquantia: reapply vlan filters on up
  net: aquantia: fix out of memory condition on rx side

Igor Russkikh (1):
  net: aquantia: linkstate irq should be oneshot

 drivers/net/ethernet/aquantia/atlantic/aq_filters.c | 5 +++--
 drivers/net/ethernet/aquantia/atlantic/aq_main.c    | 4 ++++
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c     | 2 +-
 drivers/net/ethernet/aquantia/atlantic/aq_vec.c     | 3 ++-
 4 files changed, 10 insertions(+), 4 deletions(-)

--=20
2.17.1

