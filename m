Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0204FF0BC
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 09:41:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbiDMHn3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 03:43:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232447AbiDMHnY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 03:43:24 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CB0D2E69C
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 00:41:03 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23D5O7wK008778;
        Wed, 13 Apr 2022 00:41:02 -0700
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3fd6nfd7jw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Apr 2022 00:41:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ihiy5FaTiDxQQUOGyIMi7w3DaRJfa/P4x5SbrR7ppVw6QJOJYEmDW6MRGG4uNAAmZp3ZC26YYcq71kT86Rhv/oIKEMFeoOS8iISu7VfroSAOz5fDkZeN+mCovAO5/LwPjOAXEgJav8f8FRMJLWZgE/wIxqVE/ArJq4tFwxdkG6FlQv2strutSoFCGl9bk+Hxyj8SHisrFPJVfcL19YUU9Y280suCB8qvqeNFvvE+yu2AJOxRZbL/ORDEXP6FTTLBG6jgIJnMnBLnPjfjHS9sLk2C89cm2jUnJHAEXiWnEheuZbyDPQqxlbq4GYQxCGIVgHafk49K0EXAnqA9ShiY0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IVHV8lK9K9ElHjPV6xx7swD0sTtQSbX0FVEzSvkESPw=;
 b=BECzjwgEeYXYgfa+ULo5sWX5YMiMPTHV3oMEr5N+zvNdJ6LPJuKRmBf9wYGCqMAkvEe6h+5tdEuyJ/iuo6t74k1w0sxBphGhLVBC65jGz/0/nhmY9P7+/uheHQsUieSWe5Q/3HruSJRpTgHlEaC+qSnRUs+Srb/u6GZ4BP7eZKX/QrCLymFpdMKqVH2g37s9b4AN34403ccrQE94ZDDVN0SFqS5ovFaSeCfnQhpoxBFwOlwnKt92KInvPgcCCtl6ghEYCMpQTvXa5bfH9/0rwnyYsJKWWn49Cf51O4RvDbduhUtEh4wDrIjy2ySN9GWervPSK0hH1zagDfeyPVQUfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IVHV8lK9K9ElHjPV6xx7swD0sTtQSbX0FVEzSvkESPw=;
 b=TdPdwGL9h7XB7Y/IU/Hk698Qky3HQJnE39azgueEv66cYHrYQzAIfuVDFvDl4d1G3sYRqTTcG15bZ+zjtIA6frx69mxesXtSe7j1ksJ2u2L46GQ6S7McfNSHKQtjNUuKVWB9rWO82k2ntPTOm/XmidQ5/CKqbNM9VX+qGQWVY34=
Received: from BN6PR18MB1476.namprd18.prod.outlook.com (2603:10b6:404:f3::17)
 by DM5PR18MB1100.namprd18.prod.outlook.com (2603:10b6:3:30::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.30; Wed, 13 Apr
 2022 07:40:59 +0000
Received: from BN6PR18MB1476.namprd18.prod.outlook.com
 ([fe80::601c:3a66:7626:b495]) by BN6PR18MB1476.namprd18.prod.outlook.com
 ([fe80::601c:3a66:7626:b495%10]) with mapi id 15.20.5164.018; Wed, 13 Apr
 2022 07:40:59 +0000
From:   Suman Ghosh <sumang@marvell.com>
To:     Suman Ghosh <sumang@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        Naveen Mamindlapalli <naveenm@marvell.com>,
        Rakesh Babu Saladi <rsaladi2@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     sa_ip-sw-jenkins <sa_ip-sw-jenkins@marvell.com>
Subject: RE: [PATCH] octeontx2-pf: Add support for adaptive interrupt
 coalescing
Thread-Topic: [PATCH] octeontx2-pf: Add support for adaptive interrupt
 coalescing
Thread-Index: AQHYTwcgscntY5bsok6jHkenjkv3c6ztdXCw
Date:   Wed, 13 Apr 2022 07:40:59 +0000
Message-ID: <BN6PR18MB1476A7D58F3B42ACC949E10FDBEC9@BN6PR18MB1476.namprd18.prod.outlook.com>
References: <20220413072124.119262-1-sumang@marvell.com>
In-Reply-To: <20220413072124.119262-1-sumang@marvell.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: af6d7c19-b843-4b7e-ee1c-08da1d20f3f2
x-ms-traffictypediagnostic: DM5PR18MB1100:EE_
x-microsoft-antispam-prvs: <DM5PR18MB11006C2E29CF0B39B23CB0E7DBEC9@DM5PR18MB1100.namprd18.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OCRBhSWRhKUbXvvtYAjxe5FJwh4vIw/YQ+yAwNZaMlM1lQq8GmwU6ZWAI9dUj2SgU6fIQtCvi9ZN7apIL06QOZF3gbL2sT7KyN57dZymQUiwfE4uKXwr7MlGadH1cxCwQCorm0AZHFbmse/Yj/9qDx2PBK+V/0xCHp2t8MyywW+Y/g6w6KLj5UXAgA72SxwU4k790Pv+ZS+vXdmBCReD+9rPXJG9RCn1QX73T3RxBtUXtGQDWQ3rdhdFaez4RubtwPEjsoAyINhg2XbPBQ/dTE84MbvMQZIxanTHljwq+g+tomdddnvq+2nTyJf26jxY+GlJd0SXt0LN4w8KAjfu6C+Hw2/FSugptg/oWqjgVaWsELyiTFVmiZvFSWNe8T56oLnALVyhikO6GPS2gST6qZgEflv0JnquBan8oKTzenGDtCnc5ytUXeKP/LoydDrrvtJYEzYwG8nm+bV3bEKPFO81Of5ViqGGPQBLnbm6CkCM50x7h0boVtr/TQ7Pczx63QHXd2M8bDV532AlHq+ZfCi+OXhQHOkrgk+DNOU3vA0DWDlpBAq82ChPVdM0J3EvfB/sZvPJ0ZjQkFmLaY+miKHgWlyRsroaUqqkUqUBHvFpnS5WSgqqSjbYG9+sox1RHuoqKVRUje+gEe9iHOsq6x5IWrkKsZFF1q3JjYdzSy9alEnz1lkH9kRubD5ts2weSHk5TczQR3CSqRHSDQyHMpmn2yshhDE/P9imlHQDQUOaS8ltwbxvwHHk4hAcelDZBowraLuj3Lvp8nOn7y5y3q4DnntwLbBDVivzk9n+9vE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR18MB1476.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66446008)(55016003)(66556008)(53546011)(86362001)(66476007)(64756008)(33656002)(4326008)(26005)(186003)(9686003)(8676002)(316002)(107886003)(38070700005)(508600001)(71200400001)(966005)(7696005)(83380400001)(6506007)(66946007)(30864003)(38100700002)(76116006)(110136005)(8936002)(5660300002)(122000001)(2906002)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2/i/lnInyLT3aNxzBqv9SsNxWrO8PyX46JAxRPH4tkXr08PDjLM8gmQmmM7D?=
 =?us-ascii?Q?rqtqjbsF44pABZHaa2viXpTkFyF3sV6m0WYf23+ytnMsRVzgPxdCpCwp9sHz?=
 =?us-ascii?Q?IkfyVojr/JS104gVrQ2ndOLv7HZB+PM/XBeVDJplGC/GiWPWOxFgJOBjEphV?=
 =?us-ascii?Q?do005g6W4Q0DrjVnA7qt/EHS2/1sXTI/pC/ciimrcEDfej5GhEsBtC1OM+VB?=
 =?us-ascii?Q?WKq/mDO/Q0HzWiGjoslAwFgxccIPtFHoLeT4jj0EQVS5c7sk8t7pNPukH3wK?=
 =?us-ascii?Q?uZhESgBbbS0n7TmRbqLyE4/GYDS0Qd9teAEQOsyhoMENwJ4WxnlgxO2L0S7q?=
 =?us-ascii?Q?7gpXVASKDMS/W9BQ2+/PUjTmJQChtG7TqNb1bT6moSKmaLLyq3a/DI3iFgj3?=
 =?us-ascii?Q?R2gHnm555YytkwkK/gi8O+RQBeWhQvlEuuRyuuHr45cTQofAP1q0Qs/dk0sp?=
 =?us-ascii?Q?zjX1IwaSRu9W3C6a2Rd7CEaNjRjjl4BmX9bR3i8/kYzIe4Vui/6mdmmzaVro?=
 =?us-ascii?Q?/hRKjt1uhMtvylPxmLElxPCnMuu/DtyuZ8CKCciUgiBPXeGx/XA8U9ngAydp?=
 =?us-ascii?Q?TF7bBYem5JYd4JH1n/Gvspst05wvqY2trYdv6kaUbnBbKd1tiEmAyeTLIfz8?=
 =?us-ascii?Q?oWUOf7pjpKvd5A8KywE7cWpW08LoF6H1wyooeqrZTUQGDhiV5Z2O9tV0G437?=
 =?us-ascii?Q?GG40KmIML/M2RzDAm90aF/ci3w7NmhEk8TKaLnXJYcinfjv5qDsPXt5YTZb4?=
 =?us-ascii?Q?4em7zET5yQ7g1nw+DAJPtgN9o/jETgkqr8nCW/spA4LEv1+8sYiYTYt/JNci?=
 =?us-ascii?Q?eQ3PeCP9hDfKx6HJZDsDdao8vaWYv7Qo6icGvn/2VV6IiRoOKpD4JzES3/IV?=
 =?us-ascii?Q?TwyqIA9KFMG2txhIffcFgXRGWxCCDYUjfwjaB4S9FIy0uC345ylVV17EuoML?=
 =?us-ascii?Q?2RPqjjjhiXxwJq71sgV4QguZtkgu+tuYS8oOapCNdlS91lSTCIdpE74zHVhc?=
 =?us-ascii?Q?U1i6QKZMS3Ns2X5xGbhqtTBViKQeThrN5MjHFkas5AAt7WZgcQUtKD5BXh8Y?=
 =?us-ascii?Q?Crrm0Ntocer747TTaV6ybZ5SERYujHm66qCfArC02TJwSupSg4HprkXuqE68?=
 =?us-ascii?Q?0YWjt4X6dt9OFlXPQtWhID4Xsf7AVx6y2ExaddqCjB7LvdmZnxxPLVsNU1l+?=
 =?us-ascii?Q?oGhgTSk/GaCqqoIlKl7I1isv7GTxzfsxr86VUhWaXQznRG4bgCOrVvaJ0RL9?=
 =?us-ascii?Q?0zGCHyxccs9BzvBrIPjk1CmAgJ/WYiPXzErAmoycjWWQYKwdaxYwU7VGkjIg?=
 =?us-ascii?Q?lVwbBSWNmUaieaw2FwtTEdCWYO9ejrSgLe81ac+yJvsS1ezz7GUu/iemKFw3?=
 =?us-ascii?Q?eWd2Hqx6lBcBRgLNA2gdayE/brcfQQoqf8NRhO1qP8K0dBwoqSC0P291tQ+0?=
 =?us-ascii?Q?KJBp+cGuT/qEVyPOR1O0OIuuUnGfhvKOWo5OeQwZ81HYBVpiMo/qtLv4G1Kh?=
 =?us-ascii?Q?5sTlIUdH296VG3U/W1M4AZYTeYA0VO6+JBokdlOAvspfaXm57ygkMZAt3gdz?=
 =?us-ascii?Q?/FLUUXc5s/ZKXZ9th/4hRwpDByfWQYpV7OJpeDXmn5PFoo464oE3c1eT1CJX?=
 =?us-ascii?Q?ahnJDEm9y3h5IePkvChFxxcBLfuPDz3Srj8nL1/tOLPHCh/QCWA1FYRl+ox6?=
 =?us-ascii?Q?wGuoQHYpestJ5QOaOIvNE8qa2i9NZd87OuoL3etPOdfZhy+phvwh+bBFVmVC?=
 =?us-ascii?Q?ZLqtj0X9eQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR18MB1476.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af6d7c19-b843-4b7e-ee1c-08da1d20f3f2
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2022 07:40:59.4039
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zCnCCthQwfRFC3+SPe01H673vPuj4PASH1DhiWFJCGCp1sRo/HCrKQfwt7B3v7XYVsxKZ7Nrm7tfkNs0Hg6HTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB1100
X-Proofpoint-GUID: Thni_P9VGmIw2qjaPa6X6UcV8_71pqlP
X-Proofpoint-ORIG-GUID: Thni_P9VGmIw2qjaPa6X6UcV8_71pqlP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-12_08,2022-04-12_02,2022-02-23_01
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please ignore this. I will resend.

Regards,
Suman

-----Original Message-----
From: Suman Ghosh <sumang@marvell.com>=20
Sent: Wednesday, April 13, 2022 12:51 PM
To: davem@davemloft.net; Sunil Kovvuri Goutham <sgoutham@marvell.com>; Hari=
prasad Kelam <hkelam@marvell.com>; Subbaraya Sundeep Bhatta <sbhatta@marvel=
l.com>; Naveen Mamindlapalli <naveenm@marvell.com>; Rakesh Babu Saladi <rsa=
ladi2@marvell.com>; Geethasowjanya Akula <gakula@marvell.com>; netdev@vger.=
kernel.org
Cc: Suman Ghosh <sumang@marvell.com>; sa_ip-sw-jenkins <sa_ip-sw-jenkins@ma=
rvell.com>
Subject: [PATCH] octeontx2-pf: Add support for adaptive interrupt coalescin=
g

Added support for adaptive IRQ coalescing. It uses net_dim algorithm to fin=
d the suitable delay/IRQ count based on the current packet rate.

Signed-off-by: Suman Ghosh <sumang@marvell.com>
Reviewed-on: https://sj1git1.cavium.com/c/IP/SW/kernel/linux/+/73558
Tested-by: sa_ip-sw-jenkins <sa_ip-sw-jenkins@marvell.com>
Reviewed-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/Kconfig    |  1 +
 .../marvell/octeontx2/nic/otx2_common.c       |  5 ---
 .../marvell/octeontx2/nic/otx2_common.h       | 10 +++++
 .../marvell/octeontx2/nic/otx2_ethtool.c      | 43 ++++++++++++++++---
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  | 22 ++++++++++
 .../marvell/octeontx2/nic/otx2_txrx.c         | 28 ++++++++++++
 .../marvell/octeontx2/nic/otx2_txrx.h         |  1 +
 7 files changed, 99 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/Kconfig b/drivers/net/e=
thernet/marvell/octeontx2/Kconfig
index 8560f7e463d3..a544733152d8 100644
--- a/drivers/net/ethernet/marvell/octeontx2/Kconfig
+++ b/drivers/net/ethernet/marvell/octeontx2/Kconfig
@@ -30,6 +30,7 @@ config OCTEONTX2_PF
 	tristate "Marvell OcteonTX2 NIC Physical Function driver"
 	select OCTEONTX2_MBOX
 	select NET_DEVLINK
+	select DIMLIB
 	depends on PCI
 	help
 	  This driver supports Marvell's OcteonTX2 Resource Virtualization diff -=
-git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/n=
et/ethernet/marvell/octeontx2/nic/otx2_common.c
index 033fd79d35b0..c28850d815c2 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -103,11 +103,6 @@ void otx2_get_dev_stats(struct otx2_nic *pfvf)  {
 	struct otx2_dev_stats *dev_stats =3D &pfvf->hw.dev_stats;
=20
-#define OTX2_GET_RX_STATS(reg) \
-	 otx2_read64(pfvf, NIX_LF_RX_STATX(reg))
-#define OTX2_GET_TX_STATS(reg) \
-	 otx2_read64(pfvf, NIX_LF_TX_STATX(reg))
-
 	dev_stats->rx_bytes =3D OTX2_GET_RX_STATS(RX_OCTS);
 	dev_stats->rx_drops =3D OTX2_GET_RX_STATS(RX_DROP);
 	dev_stats->rx_bcast_frames =3D OTX2_GET_RX_STATS(RX_BCAST); diff --git a/=
drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethe=
rnet/marvell/octeontx2/nic/otx2_common.h
index d9f4b085b2a4..6abf5c28921f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -16,6 +16,7 @@
 #include <net/pkt_cls.h>
 #include <net/devlink.h>
 #include <linux/time64.h>
+#include <linux/dim.h>
=20
 #include <mbox.h>
 #include <npc.h>
@@ -54,6 +55,11 @@ enum arua_mapped_qtypes {
 /* Send skid of 2000 packets required for CQ size of 4K CQEs. */
 #define SEND_CQ_SKID	2000
=20
+#define OTX2_GET_RX_STATS(reg) \
+	 otx2_read64(pfvf, NIX_LF_RX_STATX(reg)) #define=20
+OTX2_GET_TX_STATS(reg) \
+	 otx2_read64(pfvf, NIX_LF_TX_STATX(reg))
+
 struct otx2_lmt_info {
 	u64 lmt_addr;
 	u16 lmt_id;
@@ -363,6 +369,7 @@ struct otx2_nic {
 #define OTX2_FLAG_TC_MATCHALL_INGRESS_ENABLED	BIT_ULL(13)
 #define OTX2_FLAG_DMACFLTR_SUPPORT		BIT_ULL(14)
 #define OTX2_FLAG_PTP_ONESTEP_SYNC		BIT_ULL(15)
+#define OTX2_FLAG_ADPTV_INT_COAL_ENABLED	BIT_ULL(16)
 	u64			flags;
 	u64			*cq_op_addr;
=20
@@ -442,6 +449,9 @@ struct otx2_nic {
 #endif
 	/* qos */
 	struct otx2_qos		qos;
+
+	/* napi event count. It is needed for adaptive irq coalescing */
+	u32 napi_events;
 };
=20
 static inline bool is_otx2_lbkvf(struct pci_dev *pdev) diff --git a/driver=
s/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/=
marvell/octeontx2/nic/otx2_ethtool.c
index 72d0b02da3cc..8ed282991f05 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -477,6 +477,14 @@ static int otx2_get_coalesce(struct net_device *netdev=
,
 	cmd->rx_max_coalesced_frames =3D hw->cq_ecount_wait;
 	cmd->tx_coalesce_usecs =3D hw->cq_time_wait;
 	cmd->tx_max_coalesced_frames =3D hw->cq_ecount_wait;
+	if ((pfvf->flags & OTX2_FLAG_ADPTV_INT_COAL_ENABLED) =3D=3D
+		OTX2_FLAG_ADPTV_INT_COAL_ENABLED) {
+		cmd->use_adaptive_rx_coalesce =3D 1;
+		cmd->use_adaptive_tx_coalesce =3D 1;
+	} else {
+		cmd->use_adaptive_rx_coalesce =3D 0;
+		cmd->use_adaptive_tx_coalesce =3D 0;
+	}
=20
 	return 0;
 }
@@ -486,10 +494,10 @@ static int otx2_set_coalesce(struct net_device *netde=
v,  {
 	struct otx2_nic *pfvf =3D netdev_priv(netdev);
 	struct otx2_hw *hw =3D &pfvf->hw;
+	u8 priv_coalesce_status;
 	int qidx;
=20
-	if (ec->use_adaptive_rx_coalesce || ec->use_adaptive_tx_coalesce ||
-	    ec->rx_coalesce_usecs_irq || ec->rx_max_coalesced_frames_irq ||
+	if (ec->rx_coalesce_usecs_irq || ec->rx_max_coalesced_frames_irq ||
 	    ec->tx_coalesce_usecs_irq || ec->tx_max_coalesced_frames_irq ||
 	    ec->stats_block_coalesce_usecs || ec->pkt_rate_low ||
 	    ec->rx_coalesce_usecs_low || ec->rx_max_coalesced_frames_low || @@ -5=
02,6 +510,18 @@ static int otx2_set_coalesce(struct net_device *netdev,
 	if (!ec->rx_max_coalesced_frames || !ec->tx_max_coalesced_frames)
 		return 0;
=20
+	/* Check and update coalesce status */
+	if ((pfvf->flags & OTX2_FLAG_ADPTV_INT_COAL_ENABLED) =3D=3D
+	    OTX2_FLAG_ADPTV_INT_COAL_ENABLED) {
+		priv_coalesce_status =3D 1;
+		if (!ec->use_adaptive_rx_coalesce || !ec->use_adaptive_tx_coalesce)
+			pfvf->flags &=3D ~OTX2_FLAG_ADPTV_INT_COAL_ENABLED;
+	} else {
+		priv_coalesce_status =3D 0;
+		if (ec->use_adaptive_rx_coalesce || ec->use_adaptive_tx_coalesce)
+			pfvf->flags |=3D OTX2_FLAG_ADPTV_INT_COAL_ENABLED;
+	}
+
 	/* 'cq_time_wait' is 8bit and is in multiple of 100ns,
 	 * so clamp the user given value to the range of 1 to 25usec.
 	 */
@@ -521,13 +541,13 @@ static int otx2_set_coalesce(struct net_device *netde=
v,
 		hw->cq_time_wait =3D min_t(u8, ec->rx_coalesce_usecs,
 					 ec->tx_coalesce_usecs);
=20
-	/* Max ecount_wait supported is 16bit,
-	 * so clamp the user given value to the range of 1 to 64k.
+	/* Max packet budget per napi is 64,
+	 * so clamp the user given value to the range of 1 to 64.
 	 */
 	ec->rx_max_coalesced_frames =3D clamp_t(u32, ec->rx_max_coalesced_frames,
-					      1, U16_MAX);
+					      1, NAPI_POLL_WEIGHT);
 	ec->tx_max_coalesced_frames =3D clamp_t(u32, ec->tx_max_coalesced_frames,
-					      1, U16_MAX);
+					      1, NAPI_POLL_WEIGHT);
=20
 	/* Rx and Tx are mapped to same CQ, check which one
 	 * is changed, if both then choose the min.
@@ -540,6 +560,17 @@ static int otx2_set_coalesce(struct net_device *netdev=
,
 		hw->cq_ecount_wait =3D min_t(u16, ec->rx_max_coalesced_frames,
 					   ec->tx_max_coalesced_frames);
=20
+	/* Reset 'cq_time_wait' and 'cq_ecount_wait' to
+	 * default values if coalesce status changed from
+	 * 'on' to 'off'.
+	 */
+	if (priv_coalesce_status &&
+	    ((pfvf->flags & OTX2_FLAG_ADPTV_INT_COAL_ENABLED) !=3D
+	    OTX2_FLAG_ADPTV_INT_COAL_ENABLED)) {
+		hw->cq_time_wait =3D CQ_TIMER_THRESH_DEFAULT;
+		hw->cq_ecount_wait =3D CQ_CQE_THRESH_DEFAULT;
+	}
+
 	if (netif_running(netdev)) {
 		for (qidx =3D 0; qidx < pfvf->hw.cint_cnt; qidx++)
 			otx2_config_irq_coalescing(pfvf, qidx); diff --git a/drivers/net/ethern=
et/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2=
/nic/otx2_pf.c
index f18c9a9a50d0..94aaafbeb365 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1279,6 +1279,7 @@ static irqreturn_t otx2_cq_intr_handler(int irq, void=
 *cq_irq)
 	otx2_write64(pf, NIX_LF_CINTX_ENA_W1C(qidx), BIT_ULL(0));
=20
 	/* Schedule NAPI */
+	pf->napi_events++;
 	napi_schedule_irqoff(&cq_poll->napi);
=20
 	return IRQ_HANDLED;
@@ -1292,6 +1293,7 @@ static void otx2_disable_napi(struct otx2_nic *pf)
=20
 	for (qidx =3D 0; qidx < pf->hw.cint_cnt; qidx++) {
 		cq_poll =3D &qset->napi[qidx];
+		cancel_work_sync(&cq_poll->dim.work);
 		napi_disable(&cq_poll->napi);
 		netif_napi_del(&cq_poll->napi);
 	}
@@ -1538,6 +1540,24 @@ static void otx2_free_hw_resources(struct otx2_nic *=
pf)
 	mutex_unlock(&mbox->lock);
 }
=20
+static void otx2_dim_work(struct work_struct *w) {
+	struct dim_cq_moder cur_moder;
+	struct otx2_cq_poll *cq_poll;
+	struct otx2_nic *pfvf;
+	struct dim *dim;
+
+	dim =3D container_of(w, struct dim, work);
+	cur_moder =3D net_dim_get_rx_moderation(dim->mode, dim->profile_ix);
+	cq_poll =3D container_of(dim, struct otx2_cq_poll, dim);
+	pfvf =3D (struct otx2_nic *)cq_poll->dev;
+	pfvf->hw.cq_time_wait =3D (cur_moder.usec > CQ_TIMER_THRESH_MAX) ?
+				CQ_TIMER_THRESH_MAX : cur_moder.usec;
+	pfvf->hw.cq_ecount_wait =3D (cur_moder.pkts > NAPI_POLL_WEIGHT) ?
+				NAPI_POLL_WEIGHT : cur_moder.pkts;
+	dim->state =3D DIM_START_MEASURE;
+}
+
 int otx2_open(struct net_device *netdev)  {
 	struct otx2_nic *pf =3D netdev_priv(netdev); @@ -1611,6 +1631,8 @@ int ot=
x2_open(struct net_device *netdev)
 					  CINT_INVALID_CQ;
=20
 		cq_poll->dev =3D (void *)pf;
+		cq_poll->dim.mode =3D DIM_CQ_PERIOD_MODE_START_FROM_CQE;
+		INIT_WORK(&cq_poll->dim.work, otx2_dim_work);
 		netif_napi_add(netdev, &cq_poll->napi,
 			       otx2_napi_handler, NAPI_POLL_WEIGHT);
 		napi_enable(&cq_poll->napi);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drive=
rs/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
index 459b94b99ddb..927dd12b4f4e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -512,6 +512,22 @@ static int otx2_tx_napi_handler(struct otx2_nic *pfvf,
 	return 0;
 }
=20
+static void otx2_adjust_adaptive_coalese(struct otx2_nic *pfvf, struct=20
+otx2_cq_poll *cq_poll) {
+	struct dim_sample dim_sample;
+	u64 rx_frames, rx_bytes;
+
+	rx_frames =3D OTX2_GET_RX_STATS(RX_BCAST) + OTX2_GET_RX_STATS(RX_MCAST) +
+			OTX2_GET_RX_STATS(RX_UCAST);
+	rx_bytes =3D OTX2_GET_RX_STATS(RX_OCTS);
+	dim_update_sample(pfvf->napi_events,
+			  rx_frames,
+			  rx_bytes,
+			  &dim_sample);
+
+	net_dim(&cq_poll->dim, dim_sample);
+}
+
 int otx2_napi_handler(struct napi_struct *napi, int budget)  {
 	struct otx2_cq_queue *rx_cq =3D NULL;
@@ -549,6 +565,18 @@ int otx2_napi_handler(struct napi_struct *napi, int bu=
dget)
 		if (pfvf->flags & OTX2_FLAG_INTF_DOWN)
 			return workdone;
=20
+		/* Check for adaptive interrupt coalesce */
+		if (workdone !=3D 0 &&
+		    ((pfvf->flags & OTX2_FLAG_ADPTV_INT_COAL_ENABLED) =3D=3D
+		    OTX2_FLAG_ADPTV_INT_COAL_ENABLED)) {
+			/* Adjust irq coalese using net_dim */
+			otx2_adjust_adaptive_coalese(pfvf, cq_poll);
+
+			/* Update irq coalescing */
+			for (i =3D 0; i < pfvf->hw.cint_cnt; i++)
+				otx2_config_irq_coalescing(pfvf, i);
+		}
+
 		/* Re-enable interrupts */
 		otx2_write64(pfvf, NIX_LF_CINTX_ENA_W1S(cq_poll->cint_idx),
 			     BIT_ULL(0));
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h b/drive=
rs/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
index a2ac2b3bdbf5..ed41a68d3ec6 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
@@ -107,6 +107,7 @@ struct otx2_cq_poll {
 #define CINT_INVALID_CQ		255
 	u8			cint_idx;
 	u8			cq_ids[CQS_PER_CINT];
+	struct dim		dim;
 	struct napi_struct	napi;
 };
=20
--
2.25.1

