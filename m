Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC7E34FDC7C
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 13:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbiDLKbI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 06:31:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380525AbiDLKUq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 06:20:46 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5ED740A1E;
        Tue, 12 Apr 2022 02:24:59 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23C8pDOL001710;
        Tue, 12 Apr 2022 09:24:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=bZczMsPUVaZKDGozOlc39OaGJ85C1zfhyMzLxmGnZVw=;
 b=fFLAZOWavQv+ITL901IhChdKPDo3Fd8nasNZqLloVKIGQVFUuqFvxQZ7PDdlIEWJxKH9
 wyIl8xkFnlt60LEoDaEi27TbH1M7zJuBgUgI8mTIq3082NDiFLu0Dl0OUOjNUDrBygjH
 P24TiTMjahzwIOTGrzUH7g99MX5lwOLRbXFB7XmuZsjzL6rEHSQKjb7k0GrfKtJVzg9c
 DigkTemF84VmjJFD5bh/GC31GqOidNu2lf3UOtGGE1grB/lRxjry4xhcROXse19P6JrK
 Qj1NfedZmoVo9AhjItSJn9c7I20ZzzdNHzk0Mw22iDEwTqdpX6MXSrYPJcY7PpuEPGLt 1A== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb0x2e7fs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 09:24:39 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23C9FhHf018555;
        Tue, 12 Apr 2022 09:24:38 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fb0k2ppwg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 09:24:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LMjln9EpyUVM3NRtdZRzLzIU3iwIZH8unwsFyZamgSgVkiOXrLzOfVBZCtZVBJ7TNBoeGIT/uc3i2/xBTegN9If20Jkqn0NikweA9C1GuTUZ+C/+UWw9wX1cvxJ1fNTpu+SHrGHFOHTBzSD3Hxulc9Ui49dA0HprWQEvx41gDI0i//PaxpToZ8a+EJWoirXbNFgtyICR3bZXq36qmjqIadjxbK0DS4ly+VZd0gp2vSC1VUQ/vKEXyt/bseB6LG8UQ/1BrG/8kFzY6yKSB6vWrUSue25TOUqVorVbVLoCzxp4AUu0JNL2nuAiwM8CdNBrj9gAxFaIi8jLOxnqHctZ2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bZczMsPUVaZKDGozOlc39OaGJ85C1zfhyMzLxmGnZVw=;
 b=fcJgFnWMcIgq10fNSRlOi3I+ZWL8wQhXQykaD7/YE+xUe2C4ypcIUhmNkaF8iuBxD9sl5iaosqRmPrPM3z/rij9JnDPT7hJgq3IRydpEsyXowzP+kjts7qvV748J6kKiLfxrHd7m38qvhoLck4hNfPvKJecxKa0wdwanYYI0DorwhDDybziM5EX9O0qVvAIfAHcOWlcTpMNSPYdJ0FDAGcrqe8kjZtMKzoT8WAvsmdj4GaR3FBSWSZdC/77Nh1z4w5Sk+yEPiaqZ+4Ey4t1SYtrR54X38yt3DukPNMmt2h9rIPjgJEdaGUdFXpeEOmwvYfR6VY+RtA/f1i9wQUy5mA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bZczMsPUVaZKDGozOlc39OaGJ85C1zfhyMzLxmGnZVw=;
 b=rddhujK4+YPVui53gRNUvpFhS8tJyly1qae2Nsd4lHYhFl34JfZw8G1h95Pkumqgdwi1ssRKTw7504VSObeO1AzZqJKnva8BovmEEqr7efPDgOVa542kU6IZaWZowxZoUACp49sHgfXm3OCxOTJWOm0wCaT7Ipdivoo3zi9TbF4=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by DS7PR10MB5391.namprd10.prod.outlook.com
 (2603:10b6:5:3ac::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 09:24:35 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::b5d5:7b39:ca2d:1b87]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::b5d5:7b39:ca2d:1b87%5]) with mapi id 15.20.5144.022; Tue, 12 Apr 2022
 09:24:35 +0000
Date:   Tue, 12 Apr 2022 12:24:19 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] net: ethernet: mtk_eth_soc: use after free in
 __mtk_ppe_check_skb()
Message-ID: <20220412092419.GA3865@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0111.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:20::8) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b497568f-ae15-430b-92e0-08da1c664295
X-MS-TrafficTypeDiagnostic: DS7PR10MB5391:EE_
X-Microsoft-Antispam-PRVS: <DS7PR10MB5391F60879C578EAE46D29568EED9@DS7PR10MB5391.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5X/2L2ewtnilhnKz0WJ8QTr0uq3OtyVoPkL0ieVRLvqpO8YGdjxNQGMeMoaZ7/zQhn9qcZ1NMZjRL+aOQC4Gprs4riikwVq7eDlIZ0oU14OWfye7SzCe4S//bDkLxiLLh0bFLplX+IX4ZxOxOadam9it5mfDuitsX5igB9xVYLZKDSsEoCLERDJdn05zb7LedJeAWzQXEfcwOAFIKtOEXxH6rpnd2BkL72cAR5N8jiunLskdHv0G16oxwi9EVuMqmkdHC96ipCxOSxgsQeyBQ9zyVnwAGaEoISj0DkIdarIrj7J/cx7CxJixOT9XQZxjdWnDO6tz3G+g+zIilCnupBLpKEiYXhlUs3gB89t58nGOpfp0mR9UOGpmOW1pKXXZs6imHDH/sKPG/K9riuWHuaNWKHEooUEKBN8r23oSlssAGN3uy8WNnBPvmq+OYdOGL8eDljzrmIevNGItOuVw+oK6/4Chjquqp0EqKV8o2M7xyR6lo1Ub4qLtjIPjlVAvvo/Ed35FhhHEiNXKdECiI4P/VMu12jKXoqPbiJPrHqcNnbW2XTPoPxxP7SyMrLvxV+FK+kCGTqChWgx4DMdOS+aS3Gue5Fw7gC2cetSWkkQfAU/aBe5YfNSqIGiyLmO5Qybr/m8tRH8rIpM6PLHNx3qr0f5JowlN1SoVSGFVxMMtEHL2OShgZe/s0mPjXzu5b5qlJ4mpg99WxccxiZ50gw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(6486002)(508600001)(6666004)(66556008)(4326008)(66476007)(66946007)(26005)(186003)(6506007)(52116002)(33656002)(8676002)(83380400001)(6916009)(54906003)(316002)(1076003)(86362001)(33716001)(8936002)(9686003)(6512007)(44832011)(7416002)(38350700002)(38100700002)(2906002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nYKhyfXF6nqxezN6kIRFxl6a1/WDTEVzULGmUk+DbJGtsIJ0agRhgVAPrE1O?=
 =?us-ascii?Q?mYCc1BJjO3SQwGIALKVtWNGcCm5g7dNHl/wImRs7FSP0d8WbvXJMB4atsWPl?=
 =?us-ascii?Q?M8+q7xq+RtI62I/YFKzO0QC5TFfFdMMLj/Lwg9RrtZztIswE/tN+SQXbddw5?=
 =?us-ascii?Q?Q4sXamOz88TWuDTEz3HrpcBnPHxHPQ86OeJDMZKRdtPuhVKGTgExIBYqrvHH?=
 =?us-ascii?Q?iZF1NfH+7Ugi142mZDKyE6fGdy5Q0S8mEyhVsH9gcyWLs5DifwQ3rsX3uAGh?=
 =?us-ascii?Q?ZHY8AM//a6A5VSbSqMsU46LwtA+wQaJiF2BgA7ofVF9D6TzUC1uBNH4jqAPB?=
 =?us-ascii?Q?I8Bv8adnEh0Rjph2SNcSdwysTLvdjmXMRT5W0BllrWGWZV1SeSy3TzPRuvi1?=
 =?us-ascii?Q?B3saaq1yUFdRV/OyRt9FsZRMZYD+8tLJGT2bnUfUY+7ff8bBawDSeseoi7ks?=
 =?us-ascii?Q?eBEy1CfM+GWBtA932RNkn9PCv4wfgb5EOcmgM3PtPH0uKnatF/nFdBA7TbWO?=
 =?us-ascii?Q?o0rXViUlQ8gQRGyknn9NIGSAqtKUAKOt+6L86lcbwrXZxeXKU9+xpXiG3nDC?=
 =?us-ascii?Q?V1z9LCMiyVJapY+G3zKtz1WLEYQ4ZC/yN7PocCMiIY8V4uO9jsnDMVZMsP4t?=
 =?us-ascii?Q?PTymyiqqAADLyUP1Sig7qMe/14GngsYIe+PSNAYq55dbPJMFBKk+bErtOHrh?=
 =?us-ascii?Q?q73dg8iBIhsf7unkvQZat/9BkcQetKAPQ6YhcZJILpZzLmjue2mxFpi4/C4i?=
 =?us-ascii?Q?CQ3GCH5SE/7NblRmyN6/dT2wBhseIlp97xpxc5pUpjeNRmVssoZCZ3QB2qg2?=
 =?us-ascii?Q?xZFZmnSSqfKgFTq4JzGO311gsOXovua7TfbFocq1EQm06zcR9+Rm/GXRHlUT?=
 =?us-ascii?Q?VV2kFofwqonRzKHmJ0I0i4lmrUHAS541ZuR0ZdcIfDb4Zz0Cpl4cU41Qz9yU?=
 =?us-ascii?Q?0KrKyVt3B/CbYBSrLrPG/n0xju2rPdztT2Y+xbKsTuFvrk+0397pytj7JPQm?=
 =?us-ascii?Q?BlDVtx2DNdLTQeRrCfjTzErYA+k8QinPS1lNyQFcO9zgMFqitKP1R+Yh7Nj+?=
 =?us-ascii?Q?opALz6c3m+mPzlACMdBrY7K0uOMQgbKuay4AY0U0loGnLu5W7O07B+KjfPcZ?=
 =?us-ascii?Q?8E0qK0nadOOguGHZACs3CwXLPeRVPY/c+LCQXlfntqSsUkS4lPdAtayBzAOg?=
 =?us-ascii?Q?7Huzz1D+pJ1+n6aGx1vB8tvqaHo8gCQRIPUTGtEBy8+jaIy3bUFrCCG9HSRs?=
 =?us-ascii?Q?4r3AZjFNnSfzBhLX7nRM92tmdf5buFFJ+q84K8w41GLMlxWIsgmETggVwh1j?=
 =?us-ascii?Q?M/4QSIckcTKZf4RQ0B3o7Q8cyilfrZrXyzWOALQRhGsERfuoK77wjSw9olgj?=
 =?us-ascii?Q?1HKyil7cbQm2/r67WcPZk9BjgrYFCBSGB/FbXQn8UOHm/YK16RWV+85IW0qK?=
 =?us-ascii?Q?WW66onBRhrrs3J/2c6zt+XPS1xUAy+nJyeauEX2d+lk3UxqY65sOOUZV6dGP?=
 =?us-ascii?Q?MiV0gN7quesGFKoB4aReVOvVb4VetXo+oVK2n4AGl35shxK9AWAZXHcZI3o6?=
 =?us-ascii?Q?8YoiZQx91z1wQibU8WiXkPFNdZOHnhIHgR8NmRIwhFSO8T2oIzJQRNMX+eBj?=
 =?us-ascii?Q?N/PVSJKKJCrMlzyjSDgJv/ujz2phdKyU5VepP7VYvAf4+xESOTrXQ01rgjNq?=
 =?us-ascii?Q?kGmPISt4GSrwqo2bVvnXIdn/0gl9WGGCO7HYT9LKFnLJgO0+F+g/jrbPMmuf?=
 =?us-ascii?Q?ea2UDPNzdDO0BB7XkUVO+Dz8Y3iGxGM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b497568f-ae15-430b-92e0-08da1c664295
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 09:24:35.6780
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j4FanePZjIdd7bG8FfnET1Yb2+xKdx2+fZByBCcg9QQwAEdH3nGUI5fnAEzfo0fZlyMEI6wcu4AnL5LzDqydwjuGuvtlKsgXbW0fElHkJwk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5391
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.858
 definitions=2022-04-12_03:2022-04-11,2022-04-12 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 phishscore=0 suspectscore=0 spamscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204120043
X-Proofpoint-ORIG-GUID: VZW6iJ5VZ1LKimDHPQ8jCM5IDJ5i68vd
X-Proofpoint-GUID: VZW6iJ5VZ1LKimDHPQ8jCM5IDJ5i68vd
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The __mtk_foe_entry_clear() function frees "entry" so we have to use
the _safe() version of hlist_for_each_entry() to prevent a use after
free.

Fixes: 33fc42de3327 ("net: ethernet: mtk_eth_soc: support creating mac address based offload entries")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/mediatek/mtk_ppe.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.c b/drivers/net/ethernet/mediatek/mtk_ppe.c
index 282a1f34a88a..683f89f8e3b2 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.c
@@ -600,6 +600,7 @@ void __mtk_ppe_check_skb(struct mtk_ppe *ppe, struct sk_buff *skb, u16 hash)
 	struct mtk_foe_entry *hwe = &ppe->foe_table[hash];
 	struct mtk_flow_entry *entry;
 	struct mtk_foe_bridge key = {};
+	struct hlist_node *n;
 	struct ethhdr *eh;
 	bool found = false;
 	u8 *tag;
@@ -609,7 +610,7 @@ void __mtk_ppe_check_skb(struct mtk_ppe *ppe, struct sk_buff *skb, u16 hash)
 	if (FIELD_GET(MTK_FOE_IB1_STATE, hwe->ib1) == MTK_FOE_STATE_BIND)
 		goto out;
 
-	hlist_for_each_entry(entry, head, list) {
+	hlist_for_each_entry_safe(entry, n, head, list) {
 		if (entry->type == MTK_FLOW_TYPE_L2_SUBFLOW) {
 			if (unlikely(FIELD_GET(MTK_FOE_IB1_STATE, hwe->ib1) ==
 				     MTK_FOE_STATE_BIND))
-- 
2.20.1

