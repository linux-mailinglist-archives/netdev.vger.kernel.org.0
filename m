Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBEE551D0DC
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 07:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389260AbiEFFrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 01:47:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389259AbiEFFrK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 01:47:10 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A3844552C
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 22:43:28 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 245KIqxx025577;
        Thu, 5 May 2022 22:43:23 -0700
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3fvngfhhka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 May 2022 22:43:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UQyqOwqr/TFJvGKb221lcmlbTEEvPFn/mouK1Y2h2N5138MDxFJMDkJcnRdLu8GKQlMhpBbbSXJtoN34ZDGlVI1DvT3CO9qjFWpp2mjC2XoYcTQKTcEo1Hc8wQPrZipKChisizm5sonkWuHUyZFo+Lv2VURg02OW6vXS5RXn5gWnfr5S6OYvOYtToU004XbJ25NYx4YTGcGcnOPfYpZdXJqpITj3NnX/PRF7czKjBE+YJEjqjDZOoblOBPcOHc6zQQt4+ekUic3sQmEmzOP5k0Yzj/nhe/B2m9vEBqWimT32iaL2EI5fh7S8VfsTMwvQs6KYkKTwAdBshI010Z50oQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I317mO30hWRvN5jexSYGNXNz6qqC2ud5ADG0d54ud0s=;
 b=jBGIeXnWBjfoURqHuhSTmH/rHEXdPYWxRAyJz3hfjOCq9TJSQBGj1BSgwP7cOYEHBhvjHEZ3AhiZNcQjL6vcaqRj00s7fY9tjroYo1+vv8jSt2zJYcgjmhDW881awxWmlfcQpUAvCk9KiDvLC/P0bAkG2K49dZLmNLlSfHcUfr45fnWifDpaWoVUn7lR0Vj90r2O9S5b2P6vgB2ErZRUjD/DMGIZAk+S22owSgRA8RPGmD0cN9P6r8BWfq03iQx2B0JmaI7oWHoso6lx4WR1iMnOqDvO+V7dU3C5LUg9ZOysD8eC9cxq+b8dBgEDSlZ04YfdVkYeLGFUe+n64RFpZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I317mO30hWRvN5jexSYGNXNz6qqC2ud5ADG0d54ud0s=;
 b=NKqH0pdPJxabYAGUgQ2tiuNgrzIELWxKpdYvstoVOfaqeizwoVfnpf0UoMNSrpJnulvmbIA7K278jQlZEKKoLGTbx39GIjWyGVCnbNpD+O8biRFH6Ay8s8a5smVuJaRG0w3/uKj7BYB4qE83hYi4eD6tF7o6ibqyOlN8uYV2s5s=
Received: from SJ0PR18MB5216.namprd18.prod.outlook.com (2603:10b6:a03:41a::12)
 by PH0PR18MB4766.namprd18.prod.outlook.com (2603:10b6:510:ce::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.20; Fri, 6 May
 2022 05:43:20 +0000
Received: from SJ0PR18MB5216.namprd18.prod.outlook.com
 ([fe80::3491:955:3e91:e5f1]) by SJ0PR18MB5216.namprd18.prod.outlook.com
 ([fe80::3491:955:3e91:e5f1%3]) with mapi id 15.20.5206.014; Fri, 6 May 2022
 05:43:20 +0000
From:   Suman Ghosh <sumang@marvell.com>
To:     "pabeni@redhat.com" <pabeni@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: 
Thread-Index: AQHYYQv4H+ydl+/CkkiJs7IAZ5bt3q0RVjQQ
Date:   Fri, 6 May 2022 05:43:19 +0000
Message-ID: <SJ0PR18MB52169FEA6D16CB8B3D6E601FDBC59@SJ0PR18MB5216.namprd18.prod.outlook.com>
References: <20220506054135.323079-1-sumang@marvell.com>
In-Reply-To: <20220506054135.323079-1-sumang@marvell.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: df7d42a3-0655-4087-6041-08da2f23539b
x-ms-traffictypediagnostic: PH0PR18MB4766:EE_
x-microsoft-antispam-prvs: <PH0PR18MB4766AC269D87F571429AC3ECDBC59@PH0PR18MB4766.namprd18.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WS99Q5zV4gCZLtC+yVvPTf3H+IS/O5JiL+ymwTjjF8x1fhMG7k+rV6SRks7/PJXoT+4KZunETjQ2i9IrW7nJg5rR/EoqVnNWOMkNmfogbE3jVXb4vjvEt3zu3Lcr92QiTidwjv693SHRNhLDk9Wse3NdflIeeOcPcmuLRFYquyT2bXAGjQZOBD4I2/1JCDYz1cb8NAqPlFygrvkP2iyfOyulW1HgID/RDLChIhxeZER/mBFX4eQENKQqVt7yqqrlj3vcAYsSWJborx9sKhlUGC1H/xyYnPvHcMocAM7kVozxt8bu0oSKNc8QNQXykVTABMKLjn7KJ2stYqbL/24fj04hJP+gpoeUFgRV8TZR/X/ROS0u26GrwgjHBcsCMSz7GhYiZP8P1Y08snemeYOyINbsdDrUD+5wkmNAKawQHrWzTj1cI0Pv7EMWezj+DoS6W/c+3WYTYRP4mfv5GSfIhuicIGLzdxTepKxnVDe7a9qAgvtevJCNKZYejOmmkuf0QAbiiSCrLjTy7z6/0htbSXZekhjb7GfUKxG+is5wFFGxWqeMm7DVM4lE7TxZiFUaBKKyt7KMSIrAWB22l3jUVss2frG+kQzRAH56LtPR0tPQpcXNq3rM6E8p8mvhyTlHqBiMHiN6ScNd1QWAG1DTZe7MMk36m8UH6HkWMFVwqAamJt1o/ie675weeyl/WP1FYl+od7sx8hFI3p5GvK70faYaddYfUa/C0wLGX59F0PE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR18MB5216.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(55016003)(110136005)(9686003)(2906002)(316002)(508600001)(26005)(8936002)(5660300002)(64756008)(66476007)(66946007)(4743002)(66556008)(52536014)(33656002)(76116006)(66446008)(83380400001)(38100700002)(8676002)(55236004)(6506007)(38070700005)(7116003)(71200400001)(30864003)(86362001)(3480700007)(122000001)(186003)(7696005)(231573002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2FsF9+Bo/PVYwwLXvbcB7aVjInYe9b/UlCAJHmMA8Wx6xVMtQs3+nicKWufL?=
 =?us-ascii?Q?MQp4qG0Xgfp2Ocy+PuUfAnzJ/zQtDCVv3A76kAj2wwhoAC7/WabzC9eR+ZCl?=
 =?us-ascii?Q?vY2hXlXZ2p9rorWQexnMXpjvmh2ClKrHf2XM+R9X4RQIP8rrkp2956Sky6t8?=
 =?us-ascii?Q?kaCKfLw9CtjB7uET0BT5RbEERrvxWQroadVw0S/fld2jOYOL60mdZ9R0upAJ?=
 =?us-ascii?Q?CXlYMKt3gId7Q2Uq/1a1wKf59lwi9gP7uPVt/4nKFQRLavPSTb31bs9DJDCT?=
 =?us-ascii?Q?LAlUm+lvG2I/iM7ktcIhBDWSHYHNOQpZzWMtkxWEZrJyjHTFYwceHIkr47aF?=
 =?us-ascii?Q?tfPAEiqA3tQMaZMJXG4Tso6JPEZ2Kn5N9y404OX1O1ZRgB4kmzeR+RMCRJRY?=
 =?us-ascii?Q?k+sg1OObXrmDaNc9fzk5PWX66L1o6UHGBoJY3WPim/VMUbUG10a4d+HwuCJs?=
 =?us-ascii?Q?BuZ0BBl6+lrA4YL9xWNJ/qmXaFNpWqKBxzuph5l5Ta7ZdVS7a/9ckDSHfWVy?=
 =?us-ascii?Q?m+spl8MhdrQl7O8Zp5/8v880RbiVSmyybUFWIXsKJZjmUjAeCZTUK1YpNfeJ?=
 =?us-ascii?Q?XDjGXFFo+4kS3mr6Bm48ojyC7IFfUaI+AH4BLayZ8LGMPNQEVRZaFN0NZ8xp?=
 =?us-ascii?Q?FhN7bgOzBrVjwPn7Ggf1mxpWHZluxdr5PJwQT4uMVnXB1NkDT1/irKAYP3db?=
 =?us-ascii?Q?jwo+cMraEcgJW3Z2FHHvH1vopWBsqhqS5MmDJCLA3uHKOFo94H3BcsI+mzhY?=
 =?us-ascii?Q?i4fcZ/iDASwcWwo276ax0x2CRGmJ9EYulVQ24l6ILzXmc4vwD7BOsHh1jxaQ?=
 =?us-ascii?Q?lcA6+wsOp6C/SPFIgtONkhaSKLVMUXRhzmw7LX2s8UsOY1AsVJGVtWnZSEVL?=
 =?us-ascii?Q?fH5/CxSNuF7Od/mnXk2HY/gOC5jG2mVEZ3ofpb1MrLvAkRWYnakOJdTY2z7+?=
 =?us-ascii?Q?Mu4kvxVD+7l0ryZ5/rNuX9mHNhj99CVTemzNsRVTtQsxeuGrKYTod4AuAkcB?=
 =?us-ascii?Q?tyEHpGoXxFGWqFuM0R2hlugdIBr35zaFJHMQaWpNSUQe9AZ2uMvB9QQUazg5?=
 =?us-ascii?Q?n5Yn4sxaa9ARaIYnQletogdPh/Rd+/NuZU5ee8gVzGRG8f3D9vMJdgXgIOPd?=
 =?us-ascii?Q?pn6aYpJOQygh46Ll+9a9+XNBvQCZ0v08ijbEJcQYB2xPobQjR94M7Vbxa7a0?=
 =?us-ascii?Q?cek+T8FgAueB5t132tUZYJYriKbDAkdWRAaPpfpfvOKEtHftbZ0ZvvRnzIoS?=
 =?us-ascii?Q?UMoj35mRnuLruDc51X4oVIoFM+13pjVVQv0aTL0YRL0DxUb25BllDUWE8/fM?=
 =?us-ascii?Q?nI2ynkwy+wI71Jl5blcDcTXPiMoipYqVo06S1t+CSVbMbmpuuEWM9YMMxE8O?=
 =?us-ascii?Q?Qs3p4MrCy/oFmeBCxStQuqNJdfhDUAg6Rh868iKvWoTbj6k1lhPcHd1MYIIW?=
 =?us-ascii?Q?M1W3NUzz8fRBFWvWNpLJETNKuqyjpiFaI2HwJkQBudYsIDT9+Un31jtrtsT+?=
 =?us-ascii?Q?z4hnCvT/+VDjGbEfpwj7RCRwpU5r/pOp3ts7Rub9h/A7G6LuGs/rEbyy8Zf9?=
 =?us-ascii?Q?jBsQfpIxAgAKbNtMg8FTmiB6YvDcBPg02eNxAge/ukOsYhSOjpEbHX8fyj/a?=
 =?us-ascii?Q?oQ3oJvba7b0WxNp+rWXzaBsOJDHKvybp+xawEJATeiXzmCVLoaShv99Qsilu?=
 =?us-ascii?Q?IPidVJK+XPfWnWhXgRq1TdpeCX3VynnenKIWnlnXT6PERKV5R1SO++HwWWC9?=
 =?us-ascii?Q?aRCZYc6iXw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR18MB5216.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df7d42a3-0655-4087-6041-08da2f23539b
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 May 2022 05:43:19.8916
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BEf8PylOluWYU7GE8Qj8uflp6dflfGW25ZF9F9lrxr4RcBemEXR+iXQyJ1yT6hUeiLoqTTlM4PaEoT5joB2Org==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR18MB4766
X-Proofpoint-ORIG-GUID: SeUhhuHx_VkM5EXNpogoGY_6-lRxDaqU
X-Proofpoint-GUID: SeUhhuHx_VkM5EXNpogoGY_6-lRxDaqU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-06_01,2022-05-05_01,2022-02-23_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please ignore this.

Regards,
Suman

>-----Original Message-----
>From: Suman Ghosh <sumang@marvell.com>
>Sent: Friday, May 6, 2022 11:12 AM
>To: pabeni@redhat.com; davem@davemloft.net; kuba@kernel.org; Sunil
>Kovvuri Goutham <sgoutham@marvell.com>; netdev@vger.kernel.org
>Cc: Suman Ghosh <sumang@marvell.com>
>Subject:
>
>Date: Tue, 22 Mar 2022 11:54:47 +0530
>Subject: [PATCH V3] octeontx2-pf: Add support for adaptive interrupt
>coalescing
>
>Added support for adaptive IRQ coalescing. It uses net_dim algorithm to
>find the suitable delay/IRQ count based on the current packet rate.
>
>Signed-off-by: Suman Ghosh <sumang@marvell.com>
>Reviewed-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
>---
>Changes since V2
>- No change, resubmitting because V1 did not get picked up in patchworks
>  for some reason.
>
> .../net/ethernet/marvell/octeontx2/Kconfig    |  1 +
> .../marvell/octeontx2/nic/otx2_common.c       |  5 ---
> .../marvell/octeontx2/nic/otx2_common.h       | 10 +++++
> .../marvell/octeontx2/nic/otx2_ethtool.c      | 43 ++++++++++++++++---
> .../ethernet/marvell/octeontx2/nic/otx2_pf.c  | 22 ++++++++++
> .../marvell/octeontx2/nic/otx2_txrx.c         | 28 ++++++++++++
> .../marvell/octeontx2/nic/otx2_txrx.h         |  1 +
> 7 files changed, 99 insertions(+), 11 deletions(-)
>
>diff --git a/drivers/net/ethernet/marvell/octeontx2/Kconfig
>b/drivers/net/ethernet/marvell/octeontx2/Kconfig
>index 8560f7e463d3..a544733152d8 100644
>--- a/drivers/net/ethernet/marvell/octeontx2/Kconfig
>+++ b/drivers/net/ethernet/marvell/octeontx2/Kconfig
>@@ -30,6 +30,7 @@ config OCTEONTX2_PF
> 	tristate "Marvell OcteonTX2 NIC Physical Function driver"
> 	select OCTEONTX2_MBOX
> 	select NET_DEVLINK
>+	select DIMLIB
> 	depends on PCI
> 	help
> 	  This driver supports Marvell's OcteonTX2 Resource Virtualization
>diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
>b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
>index 033fd79d35b0..c28850d815c2 100644
>--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
>+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
>@@ -103,11 +103,6 @@ void otx2_get_dev_stats(struct otx2_nic *pfvf)  {
> 	struct otx2_dev_stats *dev_stats =3D &pfvf->hw.dev_stats;
>
>-#define OTX2_GET_RX_STATS(reg) \
>-	 otx2_read64(pfvf, NIX_LF_RX_STATX(reg))
>-#define OTX2_GET_TX_STATS(reg) \
>-	 otx2_read64(pfvf, NIX_LF_TX_STATX(reg))
>-
> 	dev_stats->rx_bytes =3D OTX2_GET_RX_STATS(RX_OCTS);
> 	dev_stats->rx_drops =3D OTX2_GET_RX_STATS(RX_DROP);
> 	dev_stats->rx_bcast_frames =3D OTX2_GET_RX_STATS(RX_BCAST); diff --
>git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
>b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
>index d9f4b085b2a4..6abf5c28921f 100644
>--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
>+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
>@@ -16,6 +16,7 @@
> #include <net/pkt_cls.h>
> #include <net/devlink.h>
> #include <linux/time64.h>
>+#include <linux/dim.h>
>
> #include <mbox.h>
> #include <npc.h>
>@@ -54,6 +55,11 @@ enum arua_mapped_qtypes {
> /* Send skid of 2000 packets required for CQ size of 4K CQEs. */
> #define SEND_CQ_SKID	2000
>
>+#define OTX2_GET_RX_STATS(reg) \
>+	 otx2_read64(pfvf, NIX_LF_RX_STATX(reg)) #define
>+OTX2_GET_TX_STATS(reg) \
>+	 otx2_read64(pfvf, NIX_LF_TX_STATX(reg))
>+
> struct otx2_lmt_info {
> 	u64 lmt_addr;
> 	u16 lmt_id;
>@@ -363,6 +369,7 @@ struct otx2_nic {
> #define OTX2_FLAG_TC_MATCHALL_INGRESS_ENABLED	BIT_ULL(13)
> #define OTX2_FLAG_DMACFLTR_SUPPORT		BIT_ULL(14)
> #define OTX2_FLAG_PTP_ONESTEP_SYNC		BIT_ULL(15)
>+#define OTX2_FLAG_ADPTV_INT_COAL_ENABLED	BIT_ULL(16)
> 	u64			flags;
> 	u64			*cq_op_addr;
>
>@@ -442,6 +449,9 @@ struct otx2_nic {
> #endif
> 	/* qos */
> 	struct otx2_qos		qos;
>+
>+	/* napi event count. It is needed for adaptive irq coalescing */
>+	u32 napi_events;
> };
>
> static inline bool is_otx2_lbkvf(struct pci_dev *pdev) diff --git
>a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
>b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
>index 72d0b02da3cc..8ed282991f05 100644
>--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
>+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
>@@ -477,6 +477,14 @@ static int otx2_get_coalesce(struct net_device
>*netdev,
> 	cmd->rx_max_coalesced_frames =3D hw->cq_ecount_wait;
> 	cmd->tx_coalesce_usecs =3D hw->cq_time_wait;
> 	cmd->tx_max_coalesced_frames =3D hw->cq_ecount_wait;
>+	if ((pfvf->flags & OTX2_FLAG_ADPTV_INT_COAL_ENABLED) =3D=3D
>+		OTX2_FLAG_ADPTV_INT_COAL_ENABLED) {
>+		cmd->use_adaptive_rx_coalesce =3D 1;
>+		cmd->use_adaptive_tx_coalesce =3D 1;
>+	} else {
>+		cmd->use_adaptive_rx_coalesce =3D 0;
>+		cmd->use_adaptive_tx_coalesce =3D 0;
>+	}
>
> 	return 0;
> }
>@@ -486,10 +494,10 @@ static int otx2_set_coalesce(struct net_device
>*netdev,  {
> 	struct otx2_nic *pfvf =3D netdev_priv(netdev);
> 	struct otx2_hw *hw =3D &pfvf->hw;
>+	u8 priv_coalesce_status;
> 	int qidx;
>
>-	if (ec->use_adaptive_rx_coalesce || ec->use_adaptive_tx_coalesce ||
>-	    ec->rx_coalesce_usecs_irq || ec->rx_max_coalesced_frames_irq ||
>+	if (ec->rx_coalesce_usecs_irq || ec->rx_max_coalesced_frames_irq ||
> 	    ec->tx_coalesce_usecs_irq || ec->tx_max_coalesced_frames_irq ||
> 	    ec->stats_block_coalesce_usecs || ec->pkt_rate_low ||
> 	    ec->rx_coalesce_usecs_low || ec->rx_max_coalesced_frames_low ||
>@@ -502,6 +510,18 @@ static int otx2_set_coalesce(struct net_device
>*netdev,
> 	if (!ec->rx_max_coalesced_frames || !ec->tx_max_coalesced_frames)
> 		return 0;
>
>+	/* Check and update coalesce status */
>+	if ((pfvf->flags & OTX2_FLAG_ADPTV_INT_COAL_ENABLED) =3D=3D
>+	    OTX2_FLAG_ADPTV_INT_COAL_ENABLED) {
>+		priv_coalesce_status =3D 1;
>+		if (!ec->use_adaptive_rx_coalesce || !ec-
>>use_adaptive_tx_coalesce)
>+			pfvf->flags &=3D ~OTX2_FLAG_ADPTV_INT_COAL_ENABLED;
>+	} else {
>+		priv_coalesce_status =3D 0;
>+		if (ec->use_adaptive_rx_coalesce || ec-
>>use_adaptive_tx_coalesce)
>+			pfvf->flags |=3D OTX2_FLAG_ADPTV_INT_COAL_ENABLED;
>+	}
>+
> 	/* 'cq_time_wait' is 8bit and is in multiple of 100ns,
> 	 * so clamp the user given value to the range of 1 to 25usec.
> 	 */
>@@ -521,13 +541,13 @@ static int otx2_set_coalesce(struct net_device
>*netdev,
> 		hw->cq_time_wait =3D min_t(u8, ec->rx_coalesce_usecs,
> 					 ec->tx_coalesce_usecs);
>
>-	/* Max ecount_wait supported is 16bit,
>-	 * so clamp the user given value to the range of 1 to 64k.
>+	/* Max packet budget per napi is 64,
>+	 * so clamp the user given value to the range of 1 to 64.
> 	 */
> 	ec->rx_max_coalesced_frames =3D clamp_t(u32, ec-
>>rx_max_coalesced_frames,
>-					      1, U16_MAX);
>+					      1, NAPI_POLL_WEIGHT);
> 	ec->tx_max_coalesced_frames =3D clamp_t(u32, ec-
>>tx_max_coalesced_frames,
>-					      1, U16_MAX);
>+					      1, NAPI_POLL_WEIGHT);
>
> 	/* Rx and Tx are mapped to same CQ, check which one
> 	 * is changed, if both then choose the min.
>@@ -540,6 +560,17 @@ static int otx2_set_coalesce(struct net_device
>*netdev,
> 		hw->cq_ecount_wait =3D min_t(u16, ec->rx_max_coalesced_frames,
> 					   ec->tx_max_coalesced_frames);
>
>+	/* Reset 'cq_time_wait' and 'cq_ecount_wait' to
>+	 * default values if coalesce status changed from
>+	 * 'on' to 'off'.
>+	 */
>+	if (priv_coalesce_status &&
>+	    ((pfvf->flags & OTX2_FLAG_ADPTV_INT_COAL_ENABLED) !=3D
>+	    OTX2_FLAG_ADPTV_INT_COAL_ENABLED)) {
>+		hw->cq_time_wait =3D CQ_TIMER_THRESH_DEFAULT;
>+		hw->cq_ecount_wait =3D CQ_CQE_THRESH_DEFAULT;
>+	}
>+
> 	if (netif_running(netdev)) {
> 		for (qidx =3D 0; qidx < pfvf->hw.cint_cnt; qidx++)
> 			otx2_config_irq_coalescing(pfvf, qidx); diff --git
>a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
>b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
>index f18c9a9a50d0..94aaafbeb365 100644
>--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
>+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
>@@ -1279,6 +1279,7 @@ static irqreturn_t otx2_cq_intr_handler(int irq,
>void *cq_irq)
> 	otx2_write64(pf, NIX_LF_CINTX_ENA_W1C(qidx), BIT_ULL(0));
>
> 	/* Schedule NAPI */
>+	pf->napi_events++;
> 	napi_schedule_irqoff(&cq_poll->napi);
>
> 	return IRQ_HANDLED;
>@@ -1292,6 +1293,7 @@ static void otx2_disable_napi(struct otx2_nic *pf)
>
> 	for (qidx =3D 0; qidx < pf->hw.cint_cnt; qidx++) {
> 		cq_poll =3D &qset->napi[qidx];
>+		cancel_work_sync(&cq_poll->dim.work);
> 		napi_disable(&cq_poll->napi);
> 		netif_napi_del(&cq_poll->napi);
> 	}
>@@ -1538,6 +1540,24 @@ static void otx2_free_hw_resources(struct
>otx2_nic *pf)
> 	mutex_unlock(&mbox->lock);
> }
>
>+static void otx2_dim_work(struct work_struct *w) {
>+	struct dim_cq_moder cur_moder;
>+	struct otx2_cq_poll *cq_poll;
>+	struct otx2_nic *pfvf;
>+	struct dim *dim;
>+
>+	dim =3D container_of(w, struct dim, work);
>+	cur_moder =3D net_dim_get_rx_moderation(dim->mode, dim->profile_ix);
>+	cq_poll =3D container_of(dim, struct otx2_cq_poll, dim);
>+	pfvf =3D (struct otx2_nic *)cq_poll->dev;
>+	pfvf->hw.cq_time_wait =3D (cur_moder.usec > CQ_TIMER_THRESH_MAX) ?
>+				CQ_TIMER_THRESH_MAX : cur_moder.usec;
>+	pfvf->hw.cq_ecount_wait =3D (cur_moder.pkts > NAPI_POLL_WEIGHT) ?
>+				NAPI_POLL_WEIGHT : cur_moder.pkts;
>+	dim->state =3D DIM_START_MEASURE;
>+}
>+
> int otx2_open(struct net_device *netdev)  {
> 	struct otx2_nic *pf =3D netdev_priv(netdev); @@ -1611,6 +1631,8 @@
>int otx2_open(struct net_device *netdev)
> 					  CINT_INVALID_CQ;
>
> 		cq_poll->dev =3D (void *)pf;
>+		cq_poll->dim.mode =3D DIM_CQ_PERIOD_MODE_START_FROM_CQE;
>+		INIT_WORK(&cq_poll->dim.work, otx2_dim_work);
> 		netif_napi_add(netdev, &cq_poll->napi,
> 			       otx2_napi_handler, NAPI_POLL_WEIGHT);
> 		napi_enable(&cq_poll->napi);
>diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
>b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
>index 459b94b99ddb..927dd12b4f4e 100644
>--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
>+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
>@@ -512,6 +512,22 @@ static int otx2_tx_napi_handler(struct otx2_nic
>*pfvf,
> 	return 0;
> }
>
>+static void otx2_adjust_adaptive_coalese(struct otx2_nic *pfvf, struct
>+otx2_cq_poll *cq_poll) {
>+	struct dim_sample dim_sample;
>+	u64 rx_frames, rx_bytes;
>+
>+	rx_frames =3D OTX2_GET_RX_STATS(RX_BCAST) +
>OTX2_GET_RX_STATS(RX_MCAST) +
>+			OTX2_GET_RX_STATS(RX_UCAST);
>+	rx_bytes =3D OTX2_GET_RX_STATS(RX_OCTS);
>+	dim_update_sample(pfvf->napi_events,
>+			  rx_frames,
>+			  rx_bytes,
>+			  &dim_sample);
>+
>+	net_dim(&cq_poll->dim, dim_sample);
>+}
>+
> int otx2_napi_handler(struct napi_struct *napi, int budget)  {
> 	struct otx2_cq_queue *rx_cq =3D NULL;
>@@ -549,6 +565,18 @@ int otx2_napi_handler(struct napi_struct *napi, int
>budget)
> 		if (pfvf->flags & OTX2_FLAG_INTF_DOWN)
> 			return workdone;
>
>+		/* Check for adaptive interrupt coalesce */
>+		if (workdone !=3D 0 &&
>+		    ((pfvf->flags & OTX2_FLAG_ADPTV_INT_COAL_ENABLED) =3D=3D
>+		    OTX2_FLAG_ADPTV_INT_COAL_ENABLED)) {
>+			/* Adjust irq coalese using net_dim */
>+			otx2_adjust_adaptive_coalese(pfvf, cq_poll);
>+
>+			/* Update irq coalescing */
>+			for (i =3D 0; i < pfvf->hw.cint_cnt; i++)
>+				otx2_config_irq_coalescing(pfvf, i);
>+		}
>+
> 		/* Re-enable interrupts */
> 		otx2_write64(pfvf, NIX_LF_CINTX_ENA_W1S(cq_poll->cint_idx),
> 			     BIT_ULL(0));
>diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
>b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
>index a2ac2b3bdbf5..ed41a68d3ec6 100644
>--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
>+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
>@@ -107,6 +107,7 @@ struct otx2_cq_poll {
> #define CINT_INVALID_CQ		255
> 	u8			cint_idx;
> 	u8			cq_ids[CQS_PER_CINT];
>+	struct dim		dim;
> 	struct napi_struct	napi;
> };
>
>--
>2.25.1

