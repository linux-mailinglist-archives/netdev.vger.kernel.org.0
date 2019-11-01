Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D797EC289
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 13:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728169AbfKAMRT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 08:17:19 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:21988 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727279AbfKAMRS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 08:17:18 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA1CA3Fa019176;
        Fri, 1 Nov 2019 05:17:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0818; bh=p2gBOsiz4PX2wlqy9NW3XiSqu44Q61IeFrKAnQSqwuY=;
 b=t1DdeiWKnNrMN/JV0p0QGRtg6ZYp24BWu0iRsyISY9US0J4NBHS3FtNgfIb+kKaGuQ5a
 m3b7W3j8Bsb8YvVYqxDcke3FYjLtma7XDjPcroaX/oLQbEkcm+ZCYFDK0RAjM8hFuFqf
 xh7Y4n4h0sS78PUCWxAUwnys2To4+Fn+NxvpVVwjVXd/G/zcV9yFnCPtO9seMhSd5Gg2
 xrtgOZ7zdYuAqMzyCVL23BCUl+esCDLAA4RXbgNxAUfbkkncHTxyezUiuypY2+K2NHsd
 m6HATRvVMbExvY90dqNfb+YevaUS5fxRmc0oXZOSjdtip7YwAePVpcodjcnrGWq8rK3A dA== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2vyxhy4qac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 01 Nov 2019 05:17:15 -0700
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Fri, 1 Nov
 2019 05:17:14 -0700
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (104.47.40.54) by
 SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Fri, 1 Nov 2019 05:17:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fNvBFPIFZYd0HE5PD7Kj0FWSWRMe6Rde3wtvU2QLhOFV6BKySgGp4hekbsbhQZ0SJV8IRpOtzBDBWYyA8YScmIXNsb6OIsG0USwGn/4bfQ/Ay4BG+jylcGcKmi6pb4TWdhxk2Zy5K2dtoaMhB/Wf177wM4cvezng1B7sGR3pvwZlAPDgUdocYCBZh261f9DLclQHROLzZSQ52AazbHB+T8SGyeVXlFpW1i3kW7J+VkW/5gUpVSCSyT6q9qXBOvmsYVvysIvrVE5imqjAymGvrsukS9y1yrMv20KmWBrfmH8GoM6EtYWGRPjOm6FAKMLDpbXXpK7IzVJzEm7gRme33w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p2gBOsiz4PX2wlqy9NW3XiSqu44Q61IeFrKAnQSqwuY=;
 b=Imajh3V1plVNpCdlRx3P2O/xAc0OWEAiTzal51dWsEyUqem2T2nzqYO08eD8IPYshss0wh0Ob506TCCXsYaQFC23QttbJJmWP8064X5Nfh3D9T60EnWdR54hHxKOMWrzA5MSWgknHA9Mvx+7N/IABfpsLh1ENC+SQEVVA22hrZYS4WdZ8V3qNAypA1jbF4GslM43yi9YoR8uAvgRXn52iLR4iGNxBgkYzVRzz0TGBv91TWo6KRExQ6+mq7zZ4iAStsV+bunBdYqHmpWPECS2TJTzxgzEJozi8hBBkQI0+HribgWT4/AkyQKDSZ75+7dmeb1FDc0KOc3X5MXaL855mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p2gBOsiz4PX2wlqy9NW3XiSqu44Q61IeFrKAnQSqwuY=;
 b=TmMZEE2uH6Hmw8KKHnmJjuW/WnVnAhYfDz6QWMg63FTfan46g6AJA+tjGJjPV7CMsc5PMdZhPizyK27ZZp/KH+hLBkLmVWdPA0MWrJo/4st83tgGeBGmYNRSI3fmBoxpAlZu/In3iT6II1g6gBHmoSLmqJne42fZf14kIAg/nT8=
Received: from BL0PR18MB2275.namprd18.prod.outlook.com (52.132.30.141) by
 BL0PR18MB2306.namprd18.prod.outlook.com (52.132.30.153) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.24; Fri, 1 Nov 2019 12:17:12 +0000
Received: from BL0PR18MB2275.namprd18.prod.outlook.com
 ([fe80::4152:b5a9:45c2:a981]) by BL0PR18MB2275.namprd18.prod.outlook.com
 ([fe80::4152:b5a9:45c2:a981%3]) with mapi id 15.20.2387.028; Fri, 1 Nov 2019
 12:17:12 +0000
From:   Igor Russkikh <irusskikh@marvell.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH net-next 00/12] Aquantia Marvell atlantic driver updates
Thread-Topic: [PATCH net-next 00/12] Aquantia Marvell atlantic driver updates
Thread-Index: AQHVkK5KlGQ7BTo3w0u8ZATwk9674g==
Date:   Fri, 1 Nov 2019 12:17:12 +0000
Message-ID: <cover.1572610156.git.irusskikh@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0035.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1::23) To BL0PR18MB2275.namprd18.prod.outlook.com
 (2603:10b6:207:44::13)
x-mailer: git-send-email 2.17.1
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 239999b8-0c3e-4f11-51bb-08d75ec56cc4
x-ms-traffictypediagnostic: BL0PR18MB2306:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR18MB2306F4459DAA495DBFCDE7D7B7620@BL0PR18MB2306.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:421;
x-forefront-prvs: 020877E0CB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(376002)(346002)(39860400002)(366004)(199004)(189003)(81156014)(186003)(25786009)(102836004)(14444005)(52116002)(6916009)(256004)(6506007)(66066001)(36756003)(386003)(66556008)(66476007)(2351001)(66446008)(486006)(26005)(64756008)(476003)(66946007)(2501003)(478600001)(99286004)(3846002)(5660300002)(71200400001)(107886003)(71190400001)(50226002)(2906002)(8936002)(86362001)(2616005)(81166006)(316002)(6486002)(54906003)(7736002)(6116002)(14454004)(305945005)(15650500001)(6512007)(8676002)(6436002)(5640700003)(1730700003)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR18MB2306;H:BL0PR18MB2275.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: H1p7HeIHJEjoWEoSKSBNrxMGCOVAcft/V5bYS6DlIsP5sC+BVrEXdLkpHKRnr1hM+KJTUwGpBwv0SO8TKrbkgt93sppW4hi/PSVPdlHJPDU3KCNoJ9M6k/WXZ1TJQt/TJZco0YS7V5Zs24dsu1mQ7tG4R2XYQGXoEFy+EFss3gFTlicrf5/5eQkVF/nErGAIa/v7h5mwbm+/OCu8nXYNSNGkHiv1IDTFkeajNpNIA5uSpefjjWQFxvIfEU9smFf/MSkLtHG7Apaqg3F/IZXKCHvHqJrlTn2c0hpWkNPTefU7IwqpD4ut4hTCWWyeRclQ3nZ6HwWgfAizBnRD0ED520862jrVgIk9G2reDMgIojBjOrqPAtYLZ57dxt/+Q1ez/GR0kDpkJZG1I1qqoa7AlTt7iVvI9Z+rZVuISE+BY0ki781ENG6zJLYseRr38Y5m
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 239999b8-0c3e-4f11-51bb-08d75ec56cc4
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2019 12:17:12.4946
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CtEuJNBWFq+aKo79iy3C5TeJ9wi6mWUOn88KaugOi026lWnpebFXX9skbQC38GI0jJaVONcfs5tbqe/AevTOEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR18MB2306
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-11-01_04:2019-10-30,2019-11-01 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

Here is another bunch of atlantic driver new features and updates.

Shortlist:
- Me adding ethtool private flags for various loopback test modes,
- Nikita is doing some work here on power management, implementing new PM A=
PI,
  He also did some checkpatch style cleanup of older driver parts.
- I'm also adding a new UDP GSO offload support and flags for loopback acti=
vation
- We are now Marvell, so I am changing email addresses on maintainers list.

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
 .../net/ethernet/aquantia/atlantic/aq_nic.c   | 196 ++++++++------
 .../net/ethernet/aquantia/atlantic/aq_nic.h   |  24 +-
 .../ethernet/aquantia/atlantic/aq_pci_func.c  |  94 ++++++-
 .../net/ethernet/aquantia/atlantic/aq_ptp.c   |   6 +-
 .../net/ethernet/aquantia/atlantic/aq_ring.c  |   6 +-
 .../net/ethernet/aquantia/atlantic/aq_ring.h  |   7 +-
 .../net/ethernet/aquantia/atlantic/aq_vec.c   |   8 +-
 .../aquantia/atlantic/hw_atl/hw_atl_a0.c      |  43 +--
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      |  87 ++++--
 .../aquantia/atlantic/hw_atl/hw_atl_llh.c     |  26 ++
 .../aquantia/atlantic/hw_atl/hw_atl_llh.h     |  11 +
 .../atlantic/hw_atl/hw_atl_llh_internal.h     |  54 ++++
 .../aquantia/atlantic/hw_atl/hw_atl_utils.c   | 207 +++++++++-----
 .../aquantia/atlantic/hw_atl/hw_atl_utils.h   | 228 ++++++++--------
 .../atlantic/hw_atl/hw_atl_utils_fw2x.c       | 253 ++++++++++--------
 24 files changed, 1080 insertions(+), 512 deletions(-)

--=20
2.17.1

