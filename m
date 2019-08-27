Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C38D9F685
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 01:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726111AbfH0XEO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 19:04:14 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:17758 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726034AbfH0XEO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 19:04:14 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7RN3gNZ025650;
        Tue, 27 Aug 2019 16:03:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=facebook; bh=sOQiakwD5O/8CTN/jDEGo+NOkL+GH/bdrseSZ+6qAyE=;
 b=rg97HA2m7qdTXvGPI+I2EZwFh2ahKUm1iGeNua1n83sbcjdggSYolgeMleWIFsxv9oGJ
 ywmfwLPJ8ac3RHusWjp9GaQDRzgy6a2ArFCtMa71G2VYmZwNKXi1ZWwC1xep1pFd+f4Q
 +GPQ9+BhshM/3/i1pVEhizOQQJw+aFOwSb4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2umk31q2um-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 27 Aug 2019 16:03:57 -0700
Received: from ash-exopmbx101.TheFacebook.com (2620:10d:c0a8:82::b) by
 ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 27 Aug 2019 16:03:55 -0700
Received: from ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) by
 ash-exopmbx101.TheFacebook.com (2620:10d:c0a8:82::b) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 27 Aug 2019 16:03:55 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 27 Aug 2019 16:03:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gi1GcL9oJiH7OvTqvM7AtAa7HxpZzHKbTgHHmUu32aXIhZjkkBw+hpaj3o6CAk+PMffHE+ohoS7Z9bbmWCFnxQgJow1UqKGtZ5b4+KPESBjBLqWI5LDhyr3o4i68E4h4iZ7YifllxNlxYDxhSunjbSG7z3iwGBJGnzXGWvK1oVhOyfnUazmpqfMlAv1jTyH3YosEZ+TrZ6HzkXno2mC1UCl3XJo+lE7zUnacZmy0VQWw8gOrerdL61IxeznsZmk+6W/s/5gH+HmJUZL+DqE5SB9Fgc2pzepDK/JUyqrnGq/DifD1k1DI11L+xYhVVtpYclv5nLu6o4zOgCB24HrecA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sOQiakwD5O/8CTN/jDEGo+NOkL+GH/bdrseSZ+6qAyE=;
 b=lHrSGxyQeE52oiE9Y9IpKMVrXHkAZR/8OTO0C2s58Mmh0WmYb6LJBWdt3bcbQO4kZBw22Lunys4zQ8MNCPYjgFuRACZhjWYYI1H9cBgSFFaITotZEHOPG+EmHU2uYQ67Ddv8boNnuj4uQLwE03y2fpzsz5JIca90wHoFmQL8OlkRqBnavqs6A0wTIynsgKwWmmaGjCuJEr+YsejpRU1ea+ZhEheP4q1KEO3O7cmraMnxC4UO2SEtHtYVw6R8IESEvd4zPcRpYJg50hsS20kBCy9SudEKECgyX+zYkBzyvm+gg1hC+xpBzXTIOVy3u+LnYUsVkpbAcfQ25nB1UWUxGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sOQiakwD5O/8CTN/jDEGo+NOkL+GH/bdrseSZ+6qAyE=;
 b=OYb7g0Vpbo/PiMB90XmO2HU8VY6tTR2m2nYdyKDFtVW17Q0IvEDH8e7oxv3aJW0O+0gsixzSz2o37SyqTp/i2LaUUfgBD+qIsoc4/hUebH2VbiugnJxh349kzbofI2fhO8oKcqCLSVIqKSdCSEuICkvxkA4u5eWbnDqn8KHDFC4=
Received: from CH2PR15MB3686.namprd15.prod.outlook.com (10.255.155.143) by
 CH2PR15MB3638.namprd15.prod.outlook.com (52.132.229.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Tue, 27 Aug 2019 23:03:53 +0000
Received: from CH2PR15MB3686.namprd15.prod.outlook.com
 ([fe80::9d88:b74a:48ea:cf6c]) by CH2PR15MB3686.namprd15.prod.outlook.com
 ([fe80::9d88:b74a:48ea:cf6c%5]) with mapi id 15.20.2199.021; Tue, 27 Aug 2019
 23:03:53 +0000
From:   Ben Wei <benwei@fb.com>
To:     David Miller <davem@davemloft.net>,
        "sam@mendozajonas.com" <sam@mendozajonas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>
CC:     Ben Wei <benwei@fb.com>
Subject: [PATCH net-next] net/ncsi: add response handlers for PLDM over NC-SI
Thread-Topic: [PATCH net-next] net/ncsi: add response handlers for PLDM over
 NC-SI
Thread-Index: AdVdK7Dkb5gbkg6XQAi/YA23MivgTg==
Date:   Tue, 27 Aug 2019 23:03:53 +0000
Message-ID: <CH2PR15MB3686302D8210855E5AB643B1A3A00@CH2PR15MB3686.namprd15.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2620:10d:c090:200::2:d0d3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 96f89eb8-052d-45e2-03b1-08d72b42d4bd
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CH2PR15MB3638;
x-ms-traffictypediagnostic: CH2PR15MB3638:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR15MB36383B6707B8F3F609EA6D01A3A00@CH2PR15MB3638.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-forefront-prvs: 0142F22657
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(396003)(366004)(39860400002)(376002)(136003)(199004)(189003)(7696005)(186003)(305945005)(2501003)(74316002)(476003)(46003)(14444005)(110136005)(256004)(81166006)(2906002)(81156014)(99286004)(25786009)(8676002)(8936002)(9686003)(102836004)(6506007)(33656002)(55016002)(4326008)(7736002)(53936002)(6436002)(486006)(52536014)(478600001)(71190400001)(71200400001)(6116002)(86362001)(66476007)(66446008)(64756008)(66556008)(76116006)(66946007)(316002)(14454004)(2201001)(5660300002);DIR:OUT;SFP:1102;SCL:1;SRVR:CH2PR15MB3638;H:CH2PR15MB3686.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: n/dJPv0EKSJPbTJlaalUnxDJOrNwro/273DwE+EBrZS9Vlt5U1oKPLpPXUYS+tws9sKY5QVUpbS1AK7M7dbMCC3ni1JI137XTUHnPtcf8Nlrwnk922+zh5GWZu2uLJI+bBx/+W6x6rk+XJPdsKPPywmkciLRv2TTiC5qhJpXhx3SBp4tKImkNWPiLyvrwjm7+6ePP0DPzsjES9U/pgcOLXOGFklfrjYWXpVxoU4T4Z2SbHjrANgO8tFRLql5O7No9HX3Inp8QqQQF8WTdVJZcMEo4JkqELTAOUOgWrBoriym2hJigKAWdQZppm3Cqq5UA8pPgTwrGNsHW6txbizMz2LuocVr1WO93gczTZ7AOsah2sfUPJXydgGr5zU6VnxSugFkqzOYn0yq594/Bb7yuSZO1U7p74koUQ744g2ZhNE=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 96f89eb8-052d-45e2-03b1-08d72b42d4bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2019 23:03:53.1488
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tpQPPlwmv+TjSQ8wZVGWE+2AbkzltPTQ29bkpXKXsUuySmlIyQIhmkth3RnSewHg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR15MB3638
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-08-27_04:2019-08-27,2019-08-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 mlxscore=0 lowpriorityscore=0 spamscore=0 impostorscore=0 bulkscore=0
 clxscore=1015 phishscore=0 adultscore=0 mlxlogscore=759 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1908270219
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds handlers for PLDM over NC-SI command response.

This enables NC-SI driver recognizes the packet type so the responses don't=
 get dropped as unknown packet type.

PLDM over NC-SI are not handled in kernel driver for now, but can be passed=
 back to user space via Netlink for further handling.

Signed-off-by: Ben Wei <benwei@fb.com>
---
 net/ncsi/ncsi-pkt.h |  5 +++++
 net/ncsi/ncsi-rsp.c | 11 +++++++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/net/ncsi/ncsi-pkt.h b/net/ncsi/ncsi-pkt.h index a8e9def593f2..=
80938b338fee 100644
--- a/net/ncsi/ncsi-pkt.h
+++ b/net/ncsi/ncsi-pkt.h
@@ -387,6 +387,9 @@ struct ncsi_aen_hncdsc_pkt {
 #define NCSI_PKT_CMD_OEM	0x50 /* OEM                              */
 #define NCSI_PKT_CMD_PLDM	0x51 /* PLDM request over NCSI over RBT  */
 #define NCSI_PKT_CMD_GPUUID	0x52 /* Get package UUID                 */
+#define NCSI_PKT_CMD_QPNPR	0x56 /* Query Pending NC PLDM request */
+#define NCSI_PKT_CMD_SNPR	0x57 /* Send NC PLDM Reply  */
+
=20
 /* NCSI packet responses */
 #define NCSI_PKT_RSP_CIS	(NCSI_PKT_CMD_CIS    + 0x80)
@@ -419,6 +422,8 @@ struct ncsi_aen_hncdsc_pkt {
 #define NCSI_PKT_RSP_OEM	(NCSI_PKT_CMD_OEM    + 0x80)
 #define NCSI_PKT_RSP_PLDM	(NCSI_PKT_CMD_PLDM   + 0x80)
 #define NCSI_PKT_RSP_GPUUID	(NCSI_PKT_CMD_GPUUID + 0x80)
+#define NCSI_PKT_RSP_QPNPR	(NCSI_PKT_CMD_QPNPR   + 0x80)
+#define NCSI_PKT_RSP_SNPR	(NCSI_PKT_CMD_SNPR   + 0x80)
=20
 /* NCSI response code/reason */
 #define NCSI_PKT_RSP_C_COMPLETED	0x0000 /* Command Completed        */
diff --git a/net/ncsi/ncsi-rsp.c b/net/ncsi/ncsi-rsp.c index 5254004f2b42..=
524974af0db6 100644
--- a/net/ncsi/ncsi-rsp.c
+++ b/net/ncsi/ncsi-rsp.c
@@ -1035,6 +1035,11 @@ static int ncsi_rsp_handler_gpuuid(struct ncsi_reque=
st *nr)
 	return 0;
 }
=20
+static int ncsi_rsp_handler_pldm(struct ncsi_request *nr) {
+	return 0;
+}
+
 static int ncsi_rsp_handler_netlink(struct ncsi_request *nr)  {
 	struct ncsi_dev_priv *ndp =3D nr->ndp;
@@ -1088,8 +1093,10 @@ static struct ncsi_rsp_handler {
 	{ NCSI_PKT_RSP_GNPTS,  48, ncsi_rsp_handler_gnpts   },
 	{ NCSI_PKT_RSP_GPS,     8, ncsi_rsp_handler_gps     },
 	{ NCSI_PKT_RSP_OEM,    -1, ncsi_rsp_handler_oem     },
-	{ NCSI_PKT_RSP_PLDM,    0, NULL                     },
-	{ NCSI_PKT_RSP_GPUUID, 20, ncsi_rsp_handler_gpuuid  }
+	{ NCSI_PKT_RSP_PLDM,   -1, ncsi_rsp_handler_pldm    },
+	{ NCSI_PKT_RSP_GPUUID, 20, ncsi_rsp_handler_gpuuid  },
+	{ NCSI_PKT_RSP_QPNPR,  -1, ncsi_rsp_handler_pldm    },
+	{ NCSI_PKT_RSP_SNPR,   -1, ncsi_rsp_handler_pldm    }
 };
=20
 int ncsi_rcv_rsp(struct sk_buff *skb, struct net_device *dev,
--
2.17.1

