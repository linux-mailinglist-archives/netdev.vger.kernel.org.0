Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8E92F3B95
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 23:41:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727693AbfKGWlw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 17:41:52 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:25012 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725945AbfKGWlw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 17:41:52 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA7MemG1003007;
        Thu, 7 Nov 2019 14:41:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0818; bh=uM8DhSRpPnvIbie7NH6UYVxezmhSpQcpXwO1Y960SYM=;
 b=ObMlaZdsrJGEQtHkghmFlOJ0oTXxJ+qnpPJITdr13p7pJ+zrPdXk2KTKC0cYDOOfasVS
 PoYY7q/JUPDS69jVWGeeOuS7my2+NawLXjCfVm52Q5sUEkI3cGXTt1kzK526ZBNFT4l0
 g5J+Qy5NP88pTF03N3zjuZTybweRJ9/s/0ju7sfhDaQmv0VJ1D8SdMT4dzyH4gIoPZQ4
 44p22rbY61UsapU9zrGu+feD+9es+mCbc1y1LFliVnFkn8z564LrWrI97N1IIm/kF/SL
 kzo6sb74NDDBxPMYKib6oBCSWkDrNuJw2f6pxAZh9kEqR5KIP6YEw0jS7sux/tD0NyX3 4g== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2w41uwxren-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 07 Nov 2019 14:41:49 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 7 Nov
 2019 14:41:48 -0800
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (104.47.32.58) by
 SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Thu, 7 Nov 2019 14:41:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vg9CiCX7Y2BcyZPjzLb0uJHA1ZacjPOQV8jKw4z8F1SnQ9KMh5jLgDZKG4aZBCZfeP9xVUzodI1vnm5e4HbDR+5pLCxK/8HKeelFBtLO8b7ppLFaj6FP7vXoZZN2NjmkAZCsevfy8069ZZXkndCVjRys/Wb8ZNAPLRMkhNW3gDa+LRRUKSkMrw2FCa6mLgHdSkwM2WrRg6vZJ1Ey4C7eGm/H0WF5qeTYhAjNFh+luf+xpGncFQWFKxeHOdSy3fHvTaRoPR1qZu0vhQGSXIG7c8UUl/6b7f6U5j9bvntX1H4Z47KoZNnp1+b+IffCjSbowRes97gK2kzS4C/fBTR9lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uM8DhSRpPnvIbie7NH6UYVxezmhSpQcpXwO1Y960SYM=;
 b=HTnUu8Q5rJMhpv/Pn+Kw7qTymur2MLlHiHHTMWknJDqBo8DqNuNUxwxJ++XVcsHEpjYeSF2ybh1wCfZFBRwYyalkGHgY7MkNmOGWkAmsaICUllhQxHF6DrfuSCaiSNOUjwPXVX5tWsuWmiAfrrieq/4GBvQ9ZLvJMeFor5CWilx7s9J4A8qH4JzdDfooJcb62tCpR62elVvb86oaNEtlNlcajEXSrY2nbmRP3Qd96HZNIbDPWXt0lynjfy1FPnTFbfF8fto9FVmRP1nwKW5XYA7wcUSPXe8ATj9KJx2QY0IT1wrXmcaI+bfae1VhbXmo6iNTig3JAFSG2o4C+Xx6wQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uM8DhSRpPnvIbie7NH6UYVxezmhSpQcpXwO1Y960SYM=;
 b=D6z7o0zMgX6G4EDvEsbblUBpFakKSPInldDI6GzHh3t6pIw/c2cK/EEpnDzU8wxKLsNLBeYnjEs/B5E8F+JuvTydFw9t0QrpEyczFSQSmppEOph+/ff8eALaVDxpyZ2trwjcagOr3lZBvpHdyTmDm2+yP35E8lf/4MuaTmVp2ck=
Received: from DM5PR18MB1642.namprd18.prod.outlook.com (10.175.224.8) by
 DM5PR18MB2295.namprd18.prod.outlook.com (52.132.142.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.24; Thu, 7 Nov 2019 22:41:47 +0000
Received: from DM5PR18MB1642.namprd18.prod.outlook.com
 ([fe80::d89:706b:cda0:5c15]) by DM5PR18MB1642.namprd18.prod.outlook.com
 ([fe80::d89:706b:cda0:5c15%10]) with mapi id 15.20.2430.020; Thu, 7 Nov 2019
 22:41:47 +0000
From:   Igor Russkikh <irusskikh@marvell.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH v2 net-next 00/12] Aquantia Marvell atlantic driver updates
 11-2019
Thread-Topic: [PATCH v2 net-next 00/12] Aquantia Marvell atlantic driver
 updates 11-2019
Thread-Index: AQHVlbyJlO2HS4/AhkWWXcHmMrOnFw==
Date:   Thu, 7 Nov 2019 22:41:47 +0000
Message-ID: <cover.1573158381.git.irusskikh@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR2PR09CA0011.eurprd09.prod.outlook.com
 (2603:10a6:101:16::23) To DM5PR18MB1642.namprd18.prod.outlook.com
 (2603:10b6:3:14c::8)
x-mailer: git-send-email 2.17.1
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bc5a2f4f-9b88-4cd6-60a6-08d763d3ac1b
x-ms-traffictypediagnostic: DM5PR18MB2295:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR18MB22956D6A3D20FCACBFC27850B7780@DM5PR18MB2295.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:421;
x-forefront-prvs: 0214EB3F68
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(39860400002)(136003)(396003)(376002)(189003)(199004)(64756008)(7736002)(99286004)(316002)(66066001)(54906003)(2351001)(52116002)(5640700003)(2501003)(8676002)(25786009)(8936002)(305945005)(81166006)(81156014)(1730700003)(6486002)(478600001)(71200400001)(71190400001)(6436002)(50226002)(6916009)(66476007)(6116002)(6512007)(14454004)(15650500001)(2616005)(476003)(256004)(486006)(186003)(3846002)(102836004)(107886003)(36756003)(66946007)(26005)(2906002)(66446008)(86362001)(66556008)(4326008)(386003)(6506007)(5660300002)(14444005);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR18MB2295;H:DM5PR18MB1642.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1zLlOB7D7H7F1kPZT3UrYGTvWZ0ZnJBATZMY4Nbcabz3fA/TZCw1MelkALg4CgISysMXnRlC7AKMQps05GUHbIzSob/U5bfo0vzTt31c53xEbN7yIwTv8Dg2xRXzPXoKxe1hOcv2sAzS/lLNP7eYd5F2s8pBHnFc3+UXTuqW+/uyHZW7Un9frPOxpor05cZE4ybhopSh2WL5thYfG8ZnOOTLnc7OYkUlhBFBfPpmyq7XvIbKiqFGuHPZrViGL+jXxQNOByaK7+1AZ2GYVgqTi5uO/0SdcZS3Cv9HX5hE8QKUKh6rXsxDT8Nav9kwiQD/xPQjagFde0bVC93hpN0Zdt1Pta/A32EllBBva7wgLxUM0q5aufETjTKxAEMeS1Oh88+EsmQxbgWSlldMEcPi0h3vE7olu/WbaA4IE4rhEL+mofZhOU6LUDcPPg00ZMqm
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: bc5a2f4f-9b88-4cd6-60a6-08d763d3ac1b
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2019 22:41:47.5937
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dvM35ylL00/qO6a90cvel7nv5QZY0V/vMlQrWmnZeXsD6XkTNWstA+YWrYuDO2vubeF9Og9J3Pe5KNLSUI8Mog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB2295
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-07_07:2019-11-07,2019-11-07 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

Here is a bunch of atlantic driver new features and updates.

Shortlist:
- Me adding ethtool private flags for various loopback test modes,
- Nikita is doing some work here on power management, implementing new PM A=
PI,
  He also did some checkpatch style cleanup of older driver parts.
- I'm also adding a new UDP GSO offload support and flags for loopback acti=
vation
- We are now Marvell, so I am changing email addresses on maintainers list.

v2: styling, ip6 correct handling in udpgso

Igor Russkikh (4):
  net: atlantic: loopback tests via private flags
  net: atlantic: stylistic renames
  net: atlantic: implement UDP GSO offload
  net: atlantic: change email domains to Marvell

Nikita Danilov (8):
  net: atlantic: update firmware interface
  net: atlantic: implement wake_phy feature
  net: atlantic: refactoring pm logic
  net: atlantic: add msglevel configuration
  net: atlantic: adding ethtool physical identification
  net: atlantic: add fw configuration memory area
  net: atlantic: code style cleanup
  net: atlantic: update flow control logic

 .../device_drivers/aquantia/atlantic.txt      |  46 +++-
 MAINTAINERS                                   |   4 +-
 .../net/ethernet/aquantia/atlantic/Makefile   |   7 -
 .../net/ethernet/aquantia/atlantic/aq_cfg.h   |   9 +-
 .../ethernet/aquantia/atlantic/aq_ethtool.c   | 235 ++++++++++++----
 .../ethernet/aquantia/atlantic/aq_ethtool.h   |   1 +
 .../net/ethernet/aquantia/atlantic/aq_hw.h    |  24 ++
 .../ethernet/aquantia/atlantic/aq_hw_utils.c  |   1 +
 .../net/ethernet/aquantia/atlantic/aq_main.c  |  15 +-
 .../net/ethernet/aquantia/atlantic/aq_nic.c   | 232 +++++++++-------
 .../net/ethernet/aquantia/atlantic/aq_nic.h   |  28 +-
 .../ethernet/aquantia/atlantic/aq_pci_func.c  |  95 ++++++-
 .../net/ethernet/aquantia/atlantic/aq_ptp.c   |   6 +-
 .../net/ethernet/aquantia/atlantic/aq_ring.c  |   6 +-
 .../net/ethernet/aquantia/atlantic/aq_ring.h  |   7 +-
 .../net/ethernet/aquantia/atlantic/aq_vec.c   |   8 +-
 .../aquantia/atlantic/hw_atl/hw_atl_a0.c      |  43 +--
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      | 112 +++++---
 .../aquantia/atlantic/hw_atl/hw_atl_llh.c     |  26 ++
 .../aquantia/atlantic/hw_atl/hw_atl_llh.h     |  11 +
 .../atlantic/hw_atl/hw_atl_llh_internal.h     |  54 ++++
 .../aquantia/atlantic/hw_atl/hw_atl_utils.c   | 207 +++++++++-----
 .../aquantia/atlantic/hw_atl/hw_atl_utils.h   | 228 ++++++++--------
 .../atlantic/hw_atl/hw_atl_utils_fw2x.c       | 253 ++++++++++--------
 24 files changed, 1112 insertions(+), 546 deletions(-)

--=20
2.17.1

