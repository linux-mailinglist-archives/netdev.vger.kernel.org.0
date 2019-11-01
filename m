Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3AC7EC296
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 13:17:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730605AbfKAMRk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 08:17:40 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:16398 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730584AbfKAMRj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 08:17:39 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA1CBLuc001707;
        Fri, 1 Nov 2019 05:17:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=mtBPs7eeJqZNm528OUn16Cs1CR6txqfhq9OPIa/qgv4=;
 b=hWdVYiu/j7SjPN9RProxV3McPsoeCiIk5/P7tpmClndQ3JiTjXLHQHqeTWcuq94UavwU
 C6nNSxeP+1FRU0YG05/NoMIpw1SMQGvJ7AR2rJX/tz0US8qLjIehWTo4DKbRCkzXe9a0
 SFYtsB+Cq9wZAswatDljc7vwXq3QPUn6dzughTwrhlSgZZuvLlfHTjHV7ubecJMFBtOj
 sUN6rnzwZwBvqAkRW1sPqmf+enzMQQMjcEVEhZ0l6ahCfQ6ZP5ZRdnujpElUC9D46nlm
 E24n/n/r8xlCCcu3BOpinBGxuWTg9uaA8F9TS4ULFtaxV/YHaNBxFOjajD4TVt5vIgCI aA== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 2vxwjmbtmb-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 01 Nov 2019 05:17:37 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Fri, 1 Nov
 2019 05:17:36 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (104.47.37.59) by
 SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Fri, 1 Nov 2019 05:17:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SYdIDs03qexUC0rgyzRGoXFFfNzUo7OKzINd60nk1tBWRZCzmK+QfLNnqf//TZFClJqxTHgBNR3ZoA18DLCk+Wle+3HdN18Bwfw9GSfqpNhl4lL/w95rmDbuRYHQnrPdV6QRLQtl3VdNRmA9cZ3M9/4vxTRjjwTlMjlh7gcYb0BFba7bH3U7nw2XL4pikI2bIM3hx4TrPg7iCo8cFJc1/knLP7kiFGQkxda2fhXxcZieEOm/QO3ioC8XActzmWwb/aJVxMzJ0RWp3Nff0rvoMryUP89WoA6NGYKxcS3TNKW/lRooAjDqpHNCQY22IDXDVoXXLAG2IiLSggScyG/MQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mtBPs7eeJqZNm528OUn16Cs1CR6txqfhq9OPIa/qgv4=;
 b=U4FQ6B1ileIzC6XYCAXfE0FYdsaAdEp2lU5Rt9I9l6RvNDU9DUBTKabjpiKy7WhrIeZrJlXRFBrszWcUag0mczUNaXQ/rUlF8y6egoVjNYxMwYlK4DYh/Urn92l4CPAn3Pn5kWudY1Uf3OnqakuyQijxpGJvXnqBTEj5nwg5h2lL+uyNkGvsOOAR20FpvN/6FiFmYcJ8KeC3HiUytDy4q0Om1af3e/VityS1g+YiySvUp5NYLWVma2CBf8NxGJKjZHX+t+TC9NpspNOnwtjaBeBkXiirfQr6C/CXLlnTRcltOMMxxGApLd4M1PL5Zxir6qAJBSrD7+QLXIJ3JkEc/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mtBPs7eeJqZNm528OUn16Cs1CR6txqfhq9OPIa/qgv4=;
 b=JiatKhbn7L0Z4h3TjQ7RIwyR/Cq2ClFLHp3q2wNALaQLOUeK1nSJVj17VidGIMK4HUFjVpHGMoE5aKZHFU2Vc45OcUMTGtJ8XchAf17o99U96GUPIeX3X32lc0VuJfBzDi3wv58tMkKGxaJiobtNi1jUxDqRWWIxGoU/hN+EshY=
Received: from BL0PR18MB2275.namprd18.prod.outlook.com (52.132.30.141) by
 BL0PR18MB2306.namprd18.prod.outlook.com (52.132.30.153) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.24; Fri, 1 Nov 2019 12:17:28 +0000
Received: from BL0PR18MB2275.namprd18.prod.outlook.com
 ([fe80::4152:b5a9:45c2:a981]) by BL0PR18MB2275.namprd18.prod.outlook.com
 ([fe80::4152:b5a9:45c2:a981%3]) with mapi id 15.20.2387.028; Fri, 1 Nov 2019
 12:17:28 +0000
From:   Igor Russkikh <irusskikh@marvell.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH net-next 12/12] net: atlantic: change email domains to Marvell
Thread-Topic: [PATCH net-next 12/12] net: atlantic: change email domains to
 Marvell
Thread-Index: AQHVkK5Tsis4VbAxXUm3LfFAnUA9dw==
Date:   Fri, 1 Nov 2019 12:17:28 +0000
Message-ID: <f08af560cd3e6f947f4fe663aa65e11c68652f83.1572610156.git.irusskikh@marvell.com>
References: <cover.1572610156.git.irusskikh@marvell.com>
In-Reply-To: <cover.1572610156.git.irusskikh@marvell.com>
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
x-ms-office365-filtering-correlation-id: b5c7f325-b0da-4201-ac37-08d75ec5762d
x-ms-traffictypediagnostic: BL0PR18MB2306:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR18MB2306AB6326260C1D397ADCDFB7620@BL0PR18MB2306.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 020877E0CB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(1496009)(4636009)(136003)(396003)(376002)(346002)(39860400002)(366004)(199004)(189003)(81156014)(186003)(25786009)(102836004)(52116002)(6916009)(256004)(76176011)(6506007)(66066001)(36756003)(386003)(66556008)(66476007)(2351001)(66446008)(486006)(26005)(64756008)(476003)(66946007)(2501003)(478600001)(99286004)(3846002)(11346002)(5660300002)(71200400001)(107886003)(71190400001)(50226002)(2906002)(8936002)(86362001)(118296001)(2616005)(81166006)(316002)(446003)(6486002)(54906003)(7736002)(6116002)(14454004)(305945005)(6512007)(8676002)(6306002)(6436002)(5640700003)(1730700003)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR18MB2306;H:BL0PR18MB2275.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PiBimmNDBjHt88DYMYF5DYwyygem9G+P72ZRMQH/aXN7ExMvpqdacQQy73FpDTsvN+7Jb6qFBGYtccWqPjwSo2XmhFavlKneqwUjufuwh4nev39kIv6b5ZyR8MZcw/Oe4gkKqz+zihXStq2gZG3niVl+x4ovO0Iew9hmzD9bgY7eoYK9YVm9WFdPXkb3u54OtKVQf5QzJiy5ilbHGzb7p0LB/Y4iB4dtyCBfmnttS8TaphlqoMS+erfRdIhkxD0FAj0abayN4ZwcEQyCYbmEaWOEpQxwjTufc01kHFXsVm6zWsEsdL5WrkUb4t+wbuk+Zza1hhkvI7FXv4gy4Rf/5ZK3XR64BoFDZ7w5OcVUoXUbysq3woqa/5iwrIolRs56eYTOVNrknqjpKFTCWDlB7lLaDarw5B9s27joOitLxYIvXjSaTfka83wzpPWu/iT+
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b5c7f325-b0da-4201-ac37-08d75ec5762d
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2019 12:17:28.2856
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +5tW6CzpgRAleTcYCUvaV3w+6km0r7yTqvQI53JPgqiJDsQ8TGsjO6b5znAYTqKXT389jF8ZdeAwp+siLRQ3nA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR18MB2306
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-11-01_04:2019-10-30,2019-11-01 signatures=0
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

