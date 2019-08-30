Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D48CA3F24
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 22:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728187AbfH3UvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 16:51:10 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:49858 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728145AbfH3UvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 16:51:10 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x7UKmnXe014023;
        Fri, 30 Aug 2019 13:50:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=facebook; bh=h86DtKNMjyOAVAS5ovVKihBFVomrUC3w7Mic+eStVtg=;
 b=EoGbuh1iYPrhppu4c8rgIYZCMYOoQfFTq7kFOQF56LIVkumocKVX4H7zjMbIRUitjkxX
 wihbmQ9IGcua5210nvFaJw44+6qWFC2zL92q7tApkLo0wSR+N2EYyLT1D9qn2r8U1KBb
 0ho26hNqxIJxrSEAFNCdpiSEEEQf4bJhia4= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2uq77799w3-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 30 Aug 2019 13:50:54 -0700
Received: from prn-mbx01.TheFacebook.com (2620:10d:c081:6::15) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 30 Aug 2019 13:50:53 -0700
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-mbx01.TheFacebook.com (2620:10d:c081:6::15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 30 Aug 2019 13:50:53 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 30 Aug 2019 13:50:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aNnfHlv2De2nm/gvtTswqTXSpP7FwMI/EKasX1L13U0CwJx2QKtL50coNiO+aBilYF5WtmSDeaKZ6f5gFF0nkaW0t3AO2qZb7UEbTp1sindT+K2HeDjNnk4ADmhDWa77Av7UYQzH77SU6ZD78TP1JHoBdphBNLzFRC14ZXzaNZHeXSL1ojHJ/zzPE0zWvleQeQFEbQwN7fMEhfoJlw1C5S5a1gTp6fW3eL3kcvIPl2WkyhGAklAApxFGxWGq170xiuQzC9pWHYGaU7NqQ4+5nM9L3uDNkee3wQJ9n72eyG5Zg4w2+zp5AhshsuKosI4Y+0kN3Nk5JAdE8EH+08EVQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h86DtKNMjyOAVAS5ovVKihBFVomrUC3w7Mic+eStVtg=;
 b=H5PhSE+cimAcnsMOAmrzc2XC2eSwXjAgTUHC+7XTyIvpsAFIbz6riudg8pw2958c4jLIm88qgAThFdqDrtDuUEpwiQFYJI47RPRXrWGGl8oBmCQhditpoA+uqbROuqp1p45yYRXXDkewzU2OLi+wTBntuKqIDL9SVTyGpk/ePuZxDhWP03A1T9v1nXnWq8mwtVLCi55GEa3YUz6a1708F+qa69q0XHwE1mKPmMF70f3hbnasg/bQquO3obr2p03WMeLGWAkptih05JLilg84f6jNOkibQbKAdPnlNiCWsxd91qiFDOd1PNH1xvbcyPbcWvyFwW8VF+Jykua1Py2yVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h86DtKNMjyOAVAS5ovVKihBFVomrUC3w7Mic+eStVtg=;
 b=ZayTOR8Ab72fVuAN+9DbnKJs01A1F7FGdTomgkI4Ls+trnizQIzffg2aPK9IjesUzJlLBem2tPez/P5/y3vqfZ9b3aOS3ZPDtq5vWPbqIrEqCH83jRg1YjC20bzkpZ5FxF4asRpEF4DsQUrmAUGCtiQpe60E6+Nzy0K5SXyA9ig=
Received: from CH2PR15MB3686.namprd15.prod.outlook.com (10.255.155.143) by
 CH2PR15MB3718.namprd15.prod.outlook.com (52.132.230.32) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Fri, 30 Aug 2019 20:50:52 +0000
Received: from CH2PR15MB3686.namprd15.prod.outlook.com
 ([fe80::9d88:b74a:48ea:cf6c]) by CH2PR15MB3686.namprd15.prod.outlook.com
 ([fe80::9d88:b74a:48ea:cf6c%5]) with mapi id 15.20.2199.021; Fri, 30 Aug 2019
 20:50:52 +0000
From:   Ben Wei <benwei@fb.com>
To:     David Miller <davem@davemloft.net>,
        "sam@mendozajonas.com" <sam@mendozajonas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>
CC:     Ben Wei <benwei@fb.com>
Subject: [PATCH v2 net-next] net/ncsi: add response handlers for PLDM over
 NC-SI
Thread-Topic: [PATCH v2 net-next] net/ncsi: add response handlers for PLDM
 over NC-SI
Thread-Index: AdVfdGexu+X/v31TQA2+RX8qVKJmqQ==
Date:   Fri, 30 Aug 2019 20:50:51 +0000
Message-ID: <CH2PR15MB3686A26D4BB64D8959B519B6A3BD0@CH2PR15MB3686.namprd15.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2620:10d:c090:200::2:6945]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 39d8bf09-63d3-4987-e566-08d72d8bbecf
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CH2PR15MB3718;
x-ms-traffictypediagnostic: CH2PR15MB3718:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR15MB3718AF98363BEF5F6821C2B2A3BD0@CH2PR15MB3718.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-forefront-prvs: 0145758B1D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(376002)(366004)(136003)(396003)(39860400002)(199004)(189003)(55016002)(6436002)(33656002)(25786009)(66946007)(5660300002)(478600001)(46003)(316002)(53936002)(110136005)(74316002)(305945005)(7736002)(9686003)(4326008)(6116002)(14454004)(2906002)(71200400001)(486006)(102836004)(186003)(86362001)(2501003)(52536014)(14444005)(71190400001)(81156014)(81166006)(76116006)(8936002)(66446008)(8676002)(476003)(66556008)(7696005)(64756008)(66476007)(2201001)(256004)(99286004)(6506007);DIR:OUT;SFP:1102;SCL:1;SRVR:CH2PR15MB3718;H:CH2PR15MB3686.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: HVdFoWiaG7OqEDPE+Cm3bOIDOy1w6DOPHA1gO8FY2hyAsLq1la3qmu+cQok8HN9INMsovai/Py004Rh2F6wSVOCYVUmXCeiAVhM1KtReUzbU5jamajuP3g8kBcIZ72ccjNwcSScb/YrkzjmyERC8eift9jLeDc/5w8KXhxvgSl6ZQ3WtDEFho2g3tkTWlDqvJFoh0eYdzOkz1SeeedewJZImf1+MGYBItqEJWx4w+x0aViF1Ez04Fj5j/VkzFVlWhX3puVgRVJfFgE3ryAeIDDLlH5iEZ90xkzMVcCqfw1lRr0aNEWAF7Cbc0P/z5oBnlztTXQ9m9x7rN8WdNLOrh7DTsRn3xavbCPXupoikaeQDQGyE3AVFNjOti8tK2k2hHSePzmZODd/Bwxeri1pLitrcVOILLkxETSXHmUE0DS4=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 39d8bf09-63d3-4987-e566-08d72d8bbecf
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2019 20:50:51.9885
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G5TDpv/JJkyFAc42ZoykT3phKs+4w8YJf8uwBwp1HMQt0kOq/cZpnmRzxRp5hlI5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR15MB3718
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-08-30_07:2019-08-29,2019-08-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 adultscore=0 priorityscore=1501 phishscore=0 mlxscore=0 mlxlogscore=782
 malwarescore=0 clxscore=1015 spamscore=0 impostorscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1908300199
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds handlers for PLDM over NC-SI command response.

This enables NC-SI driver recognizes the packet type so the responses
don't get dropped as unknown packet type.

PLDM over NC-SI are not handled in kernel driver for now, but can be
passed back to user space via Netlink for further handling.

Signed-off-by: Ben Wei <benwei@fb.com>
---
Changes in v2=20
  - fix function definition spacing

 net/ncsi/ncsi-pkt.h |  5 +++++
 net/ncsi/ncsi-rsp.c | 11 +++++++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/net/ncsi/ncsi-pkt.h b/net/ncsi/ncsi-pkt.h
index a8e9def593f2..80938b338fee 100644
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
diff --git a/net/ncsi/ncsi-rsp.c b/net/ncsi/ncsi-rsp.c
index 5254004f2b42..524974af0db6 100644
--- a/net/ncsi/ncsi-rsp.c
+++ b/net/ncsi/ncsi-rsp.c
@@ -1035,6 +1035,11 @@ static int ncsi_rsp_handler_gpuuid(struct ncsi_reque=
st *nr)
 	return 0;
 }
=20
+static int ncsi_rsp_handler_pldm(struct ncsi_request *nr)
+{
+	return 0;
+}
+
 static int ncsi_rsp_handler_netlink(struct ncsi_request *nr)
 {
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
--=20
2.17.1

