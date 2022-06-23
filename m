Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3F80557D1A
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 15:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231992AbiFWNd5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 09:33:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231979AbiFWNd4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 09:33:56 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45A45175AA;
        Thu, 23 Jun 2022 06:33:55 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25NAOwmO009481;
        Thu, 23 Jun 2022 13:32:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=fNFGBwtChnCdN12D147HXidXbMLXibaPoC3AhWErH+g=;
 b=eUmxyT42Nm+bUHPSbe/Jp65KW946CGKGCPtc0uFFEX9VKU65NwrCq9OG38ZrbYalGP/8
 qf6dm6Eq+w8C40Ucsjb/vxvmAc2n5yNf+Kn1crcCaBHHxs6Lf+BbSNgoYBEbjIWhOkId
 HwhSvyV9Q7byeTS+YUru5RA4k0z6+kR+EQeOTA9cO/HqRT5PCcD5w92zMZ6sLxGYYRw3
 5Vj+lrB7L8jJoDvZySjFFOVZ+p/XlQOaNfXNrQaHpVQ0hvkH+e1TlaGaamkMTPp6++pG
 N1/hM/EyEenCzhzeUktkeq5IO6NaKYkV1FzSILnkr9jEDr1rvDBIZlh2mlkbTJPfCI5H aQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gs5g238bp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jun 2022 13:32:46 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25NDUmoX033166;
        Thu, 23 Jun 2022 13:32:46 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gtg5wgs4d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jun 2022 13:32:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EtVg91B/ri3ZQdCUX9HUDuojdlJDoZhfvZBvgLiSpNXlzg3g/UZ8ThgXKRpTYAVgvflfjw9a2ek2X7ycArl5RMtR39yshcvVzHrQvGZxrYd70ROReXD3sXFpqy1cFFjsnt56qTiCYF56doTCCy280EW6IiKBzuOM3hwMMV1uiQBfXlPiNS74LtIHFQE2MK0TgnoPe8bv9uQ6RwdvGdT9GmoM2yEA1ZAPoqvvmN3vOqBx8msSsXQKGY+ayE0zk9P0Nh8CdTiVk2av98bShpLVdfN92hqRZi4L+tVFA+R8MOats24BtWG+OS5CsH8lRQf1e0qSb3+f5zSMV7m3RZ+1Rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fNFGBwtChnCdN12D147HXidXbMLXibaPoC3AhWErH+g=;
 b=XKoaUyuU5rKWWMhZc+xmefO+Mu7w0w4IoBDjG4qYkBGPStKrq8/gUq8jgMRVorpbhKqkDbgiQUt+izm3wcK8InRaXk59fsFnm5PbEO0VaNArQX6XYeqRaeW6ijWC86TB3oC1nRxR4eSRirp8iHcOQ9HmR5XdAy25xKGef9SHUy0aZrVovpsak8Dn2kGD3JHbxpqnCqdubkoFGYzuaTWSDGjekKY1e9oXyfvAn8TIQBrtZ1JnpnlXTUi4ky63qZSh22D9jwGMGzZXma9L5z+bPduhv7jNsaLU4WMKlgqMzlktuE7jodb+RJ6C4EjJPl1b02Z5qu3c+GlKllMwIJC0JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fNFGBwtChnCdN12D147HXidXbMLXibaPoC3AhWErH+g=;
 b=VkQXqd9m0Q5waXBd36zJsgMQF9PhkzATfEa3CuDu2qCDxeBfypiCj6p5OAK0DPmAi0lGtMxRzIoHTehPB46PucG9wU6iv/b0Jg43WwzQBmZVKasT3wnUB7YRKiZbe932Td3Kb3Z60tISNRuS+bLWwfDYCI/lpEQne0UMyQ++X60=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CY5PR10MB6010.namprd10.prod.outlook.com
 (2603:10b6:930:29::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14; Thu, 23 Jun
 2022 13:32:44 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b%6]) with mapi id 15.20.5373.015; Thu, 23 Jun 2022
 13:32:44 +0000
Date:   Thu, 23 Jun 2022 16:32:32 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net] net: fix IFF_TX_SKB_NO_LINEAR definition
Message-ID: <YrRrcGttfEVnf85Q@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-ClientProxiedBy: ZR0P278CA0036.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::23) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e18bc927-5b0d-4929-db98-08da551cdac7
X-MS-TrafficTypeDiagnostic: CY5PR10MB6010:EE_
X-Microsoft-Antispam-PRVS: <CY5PR10MB601060F4940614249C76628D8EB59@CY5PR10MB6010.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fGLxqkCQGLp3FgIMcIBW8VAkXYV9+BBFwn0Oc8ItbVLtr3o7y0bkci9mY50qdpWqXuN0N/gaDsLwDSXTbLdezjaPx+B/vRSft2kt9KCIEddIc4bzBoG9n7k8SwkQRIC+YGlhZxaOB8F0mReTNMR1XmCiTMbVMAinfYJFUV0a67lxwKissUxZiDkMSIA+TL7j7KpQF3PmQm/Io2iidn0NA+Vv09oHip25wb2SRrgHPlb4ka/Gb/OcKj7iOE7HJvS1UPy4c9DSR+e/aQfLHqrqQh8W1VleXvp0tkdSRQrFX1nqTee9H7+CVpPvKclShcsgPhk5NKmFZ+fng8Y+Eota+aW4/Ww2oVcQEcHVaOGp/AkP8ustMqZrqYpPZM2apCS6t7CvVhdJplWSNAKR1Wrk/GC5rACvYZ/ojsxbVtv3i3tvD9+pxUtB1Y2wkLM18JB9yfVYh9EDqqcWUYrN+JgRF6u3Volt9RD/BJFbpGX93wrV+6TWu8ZV0Eo05uHF3z3YcznGJxl34lN0ALJQjTGx0HCCL5OnR/oyjtEpMHLi1DI9zhfAtJ25iu+sRysIwmftxifRo8huOCwykzR7Omtpp4lTRc8utL3PcZhiC5P1+VfpcFC7TTkK/OJyI3lilmxD5Bm9/9ml1Ns9nHGib75C3uMSjN4aLUyqp97G1U0Bh5wnTTM5Fwagr/XsQOklKO4wjOwR97CrvYlOX/kYKeKU+QSvbxZeGCgQYi44E1AlQKYRG9nysp1BESJXuX+Qk5dwjaRzOBFVReKbRhOU7vXvzA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(396003)(366004)(39860400002)(136003)(346002)(376002)(8936002)(2906002)(86362001)(44832011)(66476007)(6512007)(26005)(6486002)(6506007)(478600001)(4744005)(9686003)(7416002)(52116002)(6666004)(5660300002)(8676002)(66946007)(83380400001)(33716001)(38350700002)(41300700001)(186003)(316002)(4326008)(66556008)(54906003)(38100700002)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+JfXY/W5a/vgvZz552yC4+i2P3OVbl2PhYB5ZY+UWfw+7n/ZCeNCh4ekb2H5?=
 =?us-ascii?Q?XvUtl1LH3jibbJu98Ai7MkqMHi2JmtWyZL/MjOl0cV4iLpbKC3Hlkr2aVd05?=
 =?us-ascii?Q?DEoZG+BbO9Igte8wnM4ioOcvtK0jPyeVptWCkFbjtFqVP4td7NnwKQ6sFiyb?=
 =?us-ascii?Q?Fvwka7m39oCMd3cgxgrChTfaHpyRyh5dZxFZ00611xIHKgssE6I9hU3HW590?=
 =?us-ascii?Q?SpkCB7jZiyhF56TLOiMleV6w6LOR6G5S8BXO/fk5CdR7zIfN7rCXLhiRRsvM?=
 =?us-ascii?Q?8GKbhmFUUgwJq3C9VncnDyW82BVKM1eszipphSbrzd7B8oosJALm64khLt64?=
 =?us-ascii?Q?WmwN7HnSzYsWfz0eKMNl7CrLz1giqYcC8tt78N05TPskKYn2V7571aI3a48B?=
 =?us-ascii?Q?bpWKPicnUmKryLA2DTX8l0ABHVCMXVD/HBeRUp9KMrhXFJqm0bpeAEGTPiIT?=
 =?us-ascii?Q?5v0Y/o5KlV+Y02nWjQxbE+tczoAcV/3VaKUdlrtx4vVtGa/E1ZaFadAKjjKc?=
 =?us-ascii?Q?ulcnxl9e8SDX1wWtn4qk7yGikIhs3+UmhikMYblcg8MxUOHnH/8Z9B764IHS?=
 =?us-ascii?Q?rCedPYIZAqGj/qQ5D8pnlA+MG9vvRDhMWreIFRLLnBrBhwLMmJjdgEUvdFgw?=
 =?us-ascii?Q?FE9QTfUpnY618DFHv7LVdDD7Hfq7WwTZR9Zws6Y067jxJlfgpHY0DGqe1daR?=
 =?us-ascii?Q?70jYYdGbWLJlkCy1GmVVJjHJUcZNQkX29aK7avz5vnlgSYefawGDuLTzfxyy?=
 =?us-ascii?Q?L65+ExZ0zBte8HHfLiMKkIiRGkc4/T9lFRm0c9P8O+OY6M8ZmluOnEeAIpJT?=
 =?us-ascii?Q?lbaKenTKzNV2PYWil0MJXhrKlwErjnxWkpDM/9TLNVq6zCKUu3PrbB9hi6YP?=
 =?us-ascii?Q?TKU83d9ASxWsVBBpl+6vjmJyv4wiONNHAQktk5BMDcuz6MvLxGfrudxyXU7z?=
 =?us-ascii?Q?UTDiKEi8HrrTAiVIN8PKFj8pxrojJ3ikEqkezuxZwgwGDrZobpGiVwL1Lsyz?=
 =?us-ascii?Q?rPVNaLaNlsgduKVJUtMnTqUzEFBUiR1pdfwgTM+jtG2A0jhM1VqAHw9SVVqb?=
 =?us-ascii?Q?CtB0nlol+YvUJHOzFRhfXGwf3pa8tZD/E9d7/UJonzN4+hYKe/FD0Pa4vACt?=
 =?us-ascii?Q?hKRKZBpRsJO/xBtU+F5UrM7tqS6tPR8Ct1oNBTGeWWePnMSdnafOmUdcSfRA?=
 =?us-ascii?Q?C6YeP9j19klrKIrgEoLBgsbyMFcb3JeYCnWFC8//XGGP/AF7bRpMT4iAM4CI?=
 =?us-ascii?Q?JsROmlzUPSafcSSbEztZ+cJ7hrLMsKqt8fcJlSC1PX3djWHWaioF/0dKBNET?=
 =?us-ascii?Q?4diC6y2aIitsxhhms10NdIoCwYVy6vJyT2hLr/Fvs1NYGsZlNoUD443GqR4v?=
 =?us-ascii?Q?G+z8lKOU4rQfRjoBt4pwHfSAVh56+5TqZwZ7Qi9/IRqudY9wqBYfStiPWnM5?=
 =?us-ascii?Q?10CSb0EFowDMPhI4U1DUtG4infUyS8YW9qT93GUVkX0oxR1piRwnol4B+K6I?=
 =?us-ascii?Q?R3Y5ZE7gCPn7iZ6VvSobOXCNIrz3DDnnGc3387SKGv94IsE++FxNDNYHg7iz?=
 =?us-ascii?Q?qGLog4173Sa9Qhg8lY31AgfAUq9+COCkt8JVExg79jtS915xdbiA+s5zPOdA?=
 =?us-ascii?Q?dQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e18bc927-5b0d-4929-db98-08da551cdac7
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2022 13:32:44.6041
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BihV9b+9OI1sJwmBuBRxLdWhtDlhFGyHafVhG7XLy8ONLTCtDgyot/CnojFWmg0l87Wg22/eUG1LFmT4qodTz+FzBS9woD43yB/oqud468M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6010
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-23_05:2022-06-23,2022-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206230055
X-Proofpoint-GUID: dc4qN1d9OObwQGvgkI2yqnRlXMy1pgoa
X-Proofpoint-ORIG-GUID: dc4qN1d9OObwQGvgkI2yqnRlXMy1pgoa
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "1<<31" shift has a sign extension bug so IFF_TX_SKB_NO_LINEAR is
0xffffffff80000000 instead of 0x0000000080000000.

Fixes: c2ff53d8049f ("net: Add priv_flags for allow tx skb without linear")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Before IFF_CHANGE_PROTO_DOWN was added then this issue was not so bad.

 include/linux/netdevice.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 89afa4f7747d..1a3cb93c3dcc 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1671,7 +1671,7 @@ enum netdev_priv_flags {
 	IFF_FAILOVER_SLAVE		= 1<<28,
 	IFF_L3MDEV_RX_HANDLER		= 1<<29,
 	IFF_LIVE_RENAME_OK		= 1<<30,
-	IFF_TX_SKB_NO_LINEAR		= 1<<31,
+	IFF_TX_SKB_NO_LINEAR		= BIT_ULL(31),
 	IFF_CHANGE_PROTO_DOWN		= BIT_ULL(32),
 };
 
-- 
2.35.1

