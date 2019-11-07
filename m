Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B68B7F3BA2
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 23:42:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbfKGWmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 17:42:16 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:55478 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727961AbfKGWmM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 17:42:12 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA7Mf9HN003108;
        Thu, 7 Nov 2019 14:42:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=mtBPs7eeJqZNm528OUn16Cs1CR6txqfhq9OPIa/qgv4=;
 b=rAK3hWfG+4bA7nKBoveWazLYD8o+hxeFkcA4tItZ1juuAQC1z0SQSnKZoA1LQnykvW5p
 0nIwgeoSamT5eo5d/TEX00SZhPlMRVQ41wh9NDIA5cCBdgy04rT/otdQCC63EzDpGiMn
 5JksuekmeXvJ7WedXqxN4ncUf/hbfw2klrmT4htNIGBZ1VPx/pLZ2WYX3ZYuQaoHw2JX
 FNvZlkrdIEsSgTCqkeaKQU1AK8E408AjDCOWicqzIeaJeFdE0NS6EGVzHhVoPsSrQalr
 SqqxuimfJrPLUOmJRQ9NDItmXQ16SBflAx6Or3eVxHQxSKGIRxNyjvWV9ItzBVQhpkZ9 SA== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2w41uwxrfp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 07 Nov 2019 14:42:11 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 7 Nov
 2019 14:42:10 -0800
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (104.47.33.53) by
 SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Thu, 7 Nov 2019 14:42:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CM/ISIC0mkEHgHmWReFbu7eCeyfNsQuWhG9H32csNF4vs0NcSXr0IYrYE4Lxhw8kMd2tW5eCETq62e4973hfvGYdS4U9ev2kXG6nrSRZY+VFOV4/KOM1Nff/LG1qtKmkmu6ot+XZICbg83ey6DL6n7tlAUpgGLwXw4E5tFHFru3/fSlyKmwyUeaL9RjLl+ZlFRnqdjoHiSDad4CMQNkvAkrk7zCuti5rrUiSxeUNS3MvLDQCeAchaWD18JGAvNM0ErqQk3hhTGLjFRSgWBqr60opaZr9dK98wIZbs/+n9PD/PvfcUOhAFZOt7xjXaNY/gjOo5xWtozBVyQZRFJZWrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mtBPs7eeJqZNm528OUn16Cs1CR6txqfhq9OPIa/qgv4=;
 b=P1UfGxraoDLPZYtv3o7k9cdDjanO/P1ktUVYRPebiGnC8XmM6QtoxYCCd6QmDpx/greaETCuEiWQKWNHk05hysyqZgHPd9/TEUo1NmxtWTGGph9GZ5D888+VjAeBt3k+JlgULWo8n11iTZo6sbVrbK7Vm4jUuBJKKibw1q83JOi2Aaqsbl9NBO6u7V4aALg5VxaMFUufbdMvgi+PDkc65XtY66bjH7apFNNkKs6pOpGPdDANba982kJQvLCScOYEY+ATwsyjIvJvzciXn5uov1n6Jl5xSwrudSF/Jwhn0pKgEwNF6bb19VZzLK11MUIAn7kSzkd8J+W5jvE6Z7lqCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mtBPs7eeJqZNm528OUn16Cs1CR6txqfhq9OPIa/qgv4=;
 b=PI5du7K5WUElA7dLEwd7lzODfCTjug2fhzldBH07fDa8kZyXbpC8kdDYQPtRnizGz+mR0ovxHXYtHMWFb09CHH3CaRdh6SRIHTrOAs8aSPrkbIJxUzA6F561fCCWMpPqpcECdA6pVi0n2Q1XN7N04AnXgxQKOZWtu0JG54Q3YPc=
Received: from DM5PR18MB1642.namprd18.prod.outlook.com (10.175.224.8) by
 DM5PR18MB2295.namprd18.prod.outlook.com (52.132.142.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.24; Thu, 7 Nov 2019 22:42:08 +0000
Received: from DM5PR18MB1642.namprd18.prod.outlook.com
 ([fe80::d89:706b:cda0:5c15]) by DM5PR18MB1642.namprd18.prod.outlook.com
 ([fe80::d89:706b:cda0:5c15%10]) with mapi id 15.20.2430.020; Thu, 7 Nov 2019
 22:42:08 +0000
From:   Igor Russkikh <irusskikh@marvell.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH v2 net-next 12/12] net: atlantic: change email domains to
 Marvell
Thread-Topic: [PATCH v2 net-next 12/12] net: atlantic: change email domains to
 Marvell
Thread-Index: AQHVlbyWEtuqkwdtYE6Bo/srbNMr9A==
Date:   Thu, 7 Nov 2019 22:42:08 +0000
Message-ID: <34aeaf6826bdba7c5a47e27a6aee15cba661bda0.1573158382.git.irusskikh@marvell.com>
References: <cover.1573158381.git.irusskikh@marvell.com>
In-Reply-To: <cover.1573158381.git.irusskikh@marvell.com>
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
x-ms-office365-filtering-correlation-id: 9437e3f1-1645-4eb3-5041-08d763d3b87f
x-ms-traffictypediagnostic: DM5PR18MB2295:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR18MB22950136EA7BAEA8402558E6B7780@DM5PR18MB2295.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 0214EB3F68
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(1496009)(4636009)(346002)(366004)(39860400002)(136003)(396003)(376002)(189003)(199004)(64756008)(76176011)(7736002)(99286004)(316002)(66066001)(54906003)(2351001)(52116002)(5640700003)(2501003)(8676002)(25786009)(118296001)(8936002)(305945005)(81166006)(81156014)(1730700003)(6486002)(478600001)(71200400001)(71190400001)(6436002)(50226002)(6916009)(66476007)(6116002)(6306002)(6512007)(14454004)(2616005)(476003)(256004)(486006)(186003)(3846002)(102836004)(11346002)(107886003)(36756003)(66946007)(26005)(2906002)(66446008)(86362001)(66556008)(4326008)(386003)(6506007)(5660300002)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR18MB2295;H:DM5PR18MB1642.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JVmMm/nO6hnWVEpBPnbyIO5L2Rgqr8IQ/sJ+bXh4JFexxd7xE1WJ5zTOW8npQlRxUnqoCVTH9ZsGJdgguqWezLWs5LSuNSaiEaMp12sYrDU9TzTV+w5RbA/Y6H9fTX2JDcYs9Pd6IPSAARqysqoEBTp+Q9AmLS4wpeEU4ga3S800lKQPKx33APVBS6e0W5ooJ1t3/d9cJMRMr200BJHJfO722JnDVSjwXR/U4fhE1/+bMVhnRswQ905H9N9fQejOS3BIJbEEh2rG1AHb8bazmQOBu/rok+UCCJwLa2zHRtJV1urXh+aJfBYgBWKhkhmLW91K2WGzWQ68LYqfHhzIcSpAqFTbbT0DdeQG6Uz8g2kY0FjkNSqlhBKDFGE6N0/6vAh8jMYWxu93QaEBuZwUMqJY4bWbwi9bmn5UHgFrhiMFA3URBpVjs1jnX2NuVLdt
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 9437e3f1-1645-4eb3-5041-08d763d3b87f
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2019 22:42:08.3513
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /2AmKb51uyQPnhLfDhS6oIlTfOz4IeDAnEfP4+sS8RU5lM54vfiEFM5JEdrFHTCFyZTQCLU+eXqbEcTcroc9hQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB2295
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-07_07:2019-11-07,2019-11-07 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Aquantia is now part of Marvell, eventually we'll cease standalone
aquantia.com domain. Thus, change the maintainers file and some other
references to @marvell.com domain

Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../networking/device_drivers/aquantia/atlantic.txt        | 6 +++---
 MAINTAINERS                                                | 4 ++--
 drivers/net/ethernet/aquantia/atlantic/Makefile            | 7 -------
 3 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/Documentation/networking/device_drivers/aquantia/atlantic.txt =
b/Documentation/networking/device_drivers/aquantia/atlantic.txt
index d614250e37d5..47696389db1a 100644
--- a/Documentation/networking/device_drivers/aquantia/atlantic.txt
+++ b/Documentation/networking/device_drivers/aquantia/atlantic.txt
@@ -1,5 +1,5 @@
-aQuantia AQtion Driver for the aQuantia Multi-Gigabit PCI Express Family o=
f
-Ethernet Adapters
+Marvell(Aquantia) AQtion Driver for the aQuantia Multi-Gigabit PCI Express
+Family of Ethernet Adapters
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
=20
 Contents
@@ -466,7 +466,7 @@ Support
=20
 If an issue is identified with the released source code on the supported
 kernel with a supported adapter, email the specific information related
-to the issue to support@aquantia.com
+to the issue to aqn_support@marvell.com
=20
 License
 =3D=3D=3D=3D=3D=3D=3D
diff --git a/MAINTAINERS b/MAINTAINERS
index 7fc074632eac..d2e5286df044 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1182,10 +1182,10 @@ S:	Maintained
 F:	drivers/media/i2c/aptina-pll.*
=20
 AQUANTIA ETHERNET DRIVER (atlantic)
-M:	Igor Russkikh <igor.russkikh@aquantia.com>
+M:	Igor Russkikh <irusskikh@marvell.com>
 L:	netdev@vger.kernel.org
 S:	Supported
-W:	http://www.aquantia.com
+W:	https://www.marvell.com/
 Q:	http://patchwork.ozlabs.org/project/netdev/list/
 F:	drivers/net/ethernet/aquantia/atlantic/
 F:	Documentation/networking/device_drivers/aquantia/atlantic.txt
diff --git a/drivers/net/ethernet/aquantia/atlantic/Makefile b/drivers/net/=
ethernet/aquantia/atlantic/Makefile
index 0020726db204..6e0a6e234483 100644
--- a/drivers/net/ethernet/aquantia/atlantic/Makefile
+++ b/drivers/net/ethernet/aquantia/atlantic/Makefile
@@ -4,15 +4,8 @@
 # aQuantia Ethernet Controller AQtion Linux Driver
 # Copyright(c) 2014-2017 aQuantia Corporation.
 #
-# Contact Information: <rdc-drv@aquantia.com>
-# aQuantia Corporation, 105 E. Tasman Dr. San Jose, CA 95134, USA
-#
 ##########################################################################=
######
=20
-#
-# Makefile for the AQtion(tm) Ethernet driver
-#
-
 obj-$(CONFIG_AQTION) +=3D atlantic.o
=20
 atlantic-objs :=3D aq_main.o \
--=20
2.17.1

