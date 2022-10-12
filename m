Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2419D5FC7E8
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 17:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbiJLPCJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 11:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbiJLPCH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 11:02:07 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2749BC0692;
        Wed, 12 Oct 2022 08:02:06 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29CE3dpn020692;
        Wed, 12 Oct 2022 15:01:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2022-7-12;
 bh=RJ69usOC9HprcfFYxG0sO4ZC6LfMj6WKCi7IZ8xQtCI=;
 b=0BB7tVH4SYbXHbQ9fxldsG2Sg/9zashBBRzluZIz8I8Bcc1w+/plRBzHbDAWnuKSqMpZ
 6/RNM+ucF3qEMQiN3rFrxfrz7G4WpLI2BPo/NpbpPtW6LOxAEdlpwDl2u+pfaFnNQlkp
 6w/d0dZ2xEt8mWHeLcwI5xDHLI9lWwY9GaLABzNZqGFm2Sz9mZOIZ0HA2UZI2TtiKjdu
 D6lCsNH3vJ+/EgABoXGJFNGlR2+/gQVoq97odh/3P38CPmSN6JUqslS6tNs2wxtMhE4Q
 xQa6x5B/zrxFH1k0TNTvOJRlLJxu0jeEuJJn51X/H1gwYO3H2WUwKLeCU/okbp+0r1qb 3w== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k30tta7aa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Oct 2022 15:01:41 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29CE6QBd039815;
        Wed, 12 Oct 2022 15:01:41 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3k2ynbgrbv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Oct 2022 15:01:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L15p974X/+l3QhczZGctyW8Hwzz67aAssWEKQNF1U08J6zrZcQKvpocYr0Efn17DPejJwVLfQy7knpekHqfzW+LglT1qxShzgkCf/TbC+sY5X9hix2Vfy2uUxkBB05qnEHxmJAAyhEuKfHddK16/r0A/umf7AwjHLgeSAncUlHYwzve/vKMPeBKQVP3CF4VunjmRdTNQBzen9wfLKZERfVkKMD2YsptZ8OCIIXVn1x5Lu/uvdj7GgmtLaxk6pn59gj6yYTXzSqW/YKHImS7/S08h0HVA4jOk30WxB5ab1b+ZdqrUuyNOyG48k0fJSwNH/jW3Aty4SSSn1ncfXeUfKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RJ69usOC9HprcfFYxG0sO4ZC6LfMj6WKCi7IZ8xQtCI=;
 b=EWbIzvGQi2RDAsZYsNMHaL5qUVUYepj9JMNW3IsUsu3xI0hg84J04hjMJhTZJnnznKMkiRozkFHfji2w6A2GojNPWXOlrFX+CaTVb/vAgT5kin1QjQX2JLFBA1/lDa3Qxsr0frhtLIVaCPDLSZyfJGRefukGiZC+b6IpXYEuuk7LnUM0QpEBlYSYOydIvIWSK8MnQtHB3rvFNsBj1i5aA+qxu2LX7+7lNLzfX0LuWulaj9QOgGucu77wmHsDV2a3mMBk6Mm73EQgs4vWDz3GFI11ejFEk0aKdSo5SV03FsWz34jPpxVGNrUYbK5F8y1jrp5GMJZgUfWGp78GQjx/wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RJ69usOC9HprcfFYxG0sO4ZC6LfMj6WKCi7IZ8xQtCI=;
 b=CJ5Uqob03c+S6tib22Rgm3hCau3xyKvaf7RQZDDBcspaUIZze+Uziy9Q7v/7DtuxIp8z00mnbGY+bNeA09CaT8KVmC/7egvjC4CCNztenUgFHw44UWsDQMDufqHCRuazZuqBn0n7Jd95pOQsZQU6aZYuG3m0w7R6EbP4PnNRY1E=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CH0PR10MB4843.namprd10.prod.outlook.com
 (2603:10b6:610:cb::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.44; Wed, 12 Oct
 2022 15:01:39 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::1b8e:540e:10f0:9aec]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::1b8e:540e:10f0:9aec%4]) with mapi id 15.20.5676.031; Wed, 12 Oct 2022
 15:01:39 +0000
Date:   Wed, 12 Oct 2022 18:01:32 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Sean Anderson <seanga2@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rolf Eike Beer <eike-kernel@sf-tec.de>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH net] sunhme: fix an IS_ERR() vs NULL check in probe
Message-ID: <Y0bWzJL8JknX8MUf@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-ClientProxiedBy: ZR2P278CA0043.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:47::17) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2365:EE_|CH0PR10MB4843:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b31e763-49df-446b-9762-08daac62aa44
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uanuInHAGKhB3VgIt6DnNl4Jp7x9ZPpGIVMOkdWI+t8KEAhyE20AUBlasGFseuhhe18/I/prKB6T/g+8EaEjDa5NaTn/Nz4UO0RkD46Wb5nB9SLG90fLPi+Dd8SUFCbNdGZpVB2PzdQfh00MosDjasCzKN+Yl4nM+NGp8I598AEcatysodTG6ttXHq4xDW3rLl4Om4B7/eaSMdQYjpMYQlMLMRw7xp+id0Zyk1ctzRSA3ZKwsl39AbN8rDj77/nky6V3b4Unhqv11d3tQUzXJZham3wtRLOGUyMFe5rJhSGdDghIlsU1xn87KHgxoCAd/KygjGA8XcxlklEvjqgKLL+8StgHylOfUfmkxZi892ppm4fmPasxZFZVppqTI6HFxi4r395IRWoPmP1YfVeZlrZQiphZSIsmPKCs+7eSyoE0IOQQcMr6fJrY1RnkfRE8G5PlxnWS/QLFENvp8/zwL5loDJVcoRM+bT0HvAiD0ar9WH4LxbWaBylVHc/6NSOgnsrCBRil9BUxdL8A2t+Nj0gfPYPgpc6Q1NMQxj6FeSPV2ikw9yr3NCcwSpm3ldc69Bpb4wbBMMMtm1iZhxcV/yedzoAeSCYtc3XpxklhTcp/rmsqAaiU6F7dbcrpcpYHWmt9RGa1FdRL8A2keKBrRgaybaXEj3ezzte/5hxWP8dT5PvLwArV+xbQpI8Tx9Ft1nHyORx1FhZvLnW+jRf33Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(346002)(366004)(39860400002)(136003)(396003)(376002)(451199015)(26005)(41300700001)(6486002)(6512007)(6506007)(66946007)(66556008)(66476007)(478600001)(8676002)(4326008)(9686003)(38100700002)(86362001)(186003)(44832011)(8936002)(5660300002)(33716001)(54906003)(83380400001)(4744005)(6916009)(2906002)(316002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SyDc/h7MBLTONhsCfMKMxTZYDasjUKljQK3zWvk7N3xqOvAV2FsJQB2vlGmE?=
 =?us-ascii?Q?8rjHit/ABloIBKts/LBIx5LrHj9S7nzfldocyLY3Ydn7tdIpAJrJj8KPHh8Y?=
 =?us-ascii?Q?HYhf2yt0nhFM8Gz0tmjtFtJ0VUlA31IP40VYbiI62Aw5VDMCSIOPyvYWQb83?=
 =?us-ascii?Q?znsD357Y95cyaQE33twtY1kH0zDx1gk/8wUBw9k/oX/C1jnFHXt3gZFa6qOs?=
 =?us-ascii?Q?M9zhDcNI8SepHyArXkzD6X4DaoA9K7yHaP/Ifm+zdK6KoF0juW0oOVNMdUtH?=
 =?us-ascii?Q?PXM7JSq+xcCL3WF+t4Jte1evWP6RsIpsWA87ZR2Ps71uTy3TTRax1tDDZcQZ?=
 =?us-ascii?Q?GlbgcwddmbPgfaxyy56l6VDWCQvb+kmAqWMHhJ5J+X/pIOfusDNpDY8tSetS?=
 =?us-ascii?Q?JPb1/6LlpC8teluJyT9XcVcm6aQGz5ujTchiG2/2tpgiwWKuIm0zQ61JhNLU?=
 =?us-ascii?Q?FllSyiZD4JFtEJF2cIuBBDh5MSen7iaesy31gi1YzPGvGqXnjQTRtvY4G+Nl?=
 =?us-ascii?Q?2ybjhpkM4LExVCfYRNNAWtC+ScfBNDWfF3tG5+ijSwnfgXy3zB4J1t5ZyeTl?=
 =?us-ascii?Q?kddJPQBwSFlyaWVl2J9zqHVRW0Et18Opsi47pISUySdIrWelrbVP+5LDMp+Z?=
 =?us-ascii?Q?/2iBp3qYXjwnnJRXcvreB6NkSLEy2Kmo2ZdMHXsVjyanwljHP7PmBdWzr2ks?=
 =?us-ascii?Q?t/qtMdnUwaX8TGCjXxCEGa4kgE1HCuQQksUnHl/vxG0dvKdPVHJrkov/WlIm?=
 =?us-ascii?Q?k+HFniwfti9nbD6joIuFYwaoswrRkC2AUZ53qZVG2FSf0N8dCzdP/db7n+4T?=
 =?us-ascii?Q?KyNlhNptxwh9owz1E41WzbmGGEpquZejeJU7D1L9fTjjBpmNxIKSy18sr2ja?=
 =?us-ascii?Q?q4UTd0zN2Dhm1N+XW8RgMZofvuX3ia4vypBhhr6iiEY/MTqA7Tw55ppoBf8d?=
 =?us-ascii?Q?wnzrQ2FC0tdGJOpIiACB5AytaFP/7+noiUAaEFKPFfBRciAr0ftkLxRlv5f4?=
 =?us-ascii?Q?kkReRteAHkrMHQqmhXPFzoF12JtM35jrsY0K/rzD6rMGm2k+Ttocn/c3Z7hb?=
 =?us-ascii?Q?1Q+A4UmyOKpu7Xakv2bSIgPus5WHGgF2JWXE5d2U9n6KSyB862jc2AYSFXwW?=
 =?us-ascii?Q?Hnw+TRAv4fI5g9gxKnQho3msLfkpWNkjPywb9EJRA1ulE6YLcmFQPZICTcc2?=
 =?us-ascii?Q?U0lQmvHku3z1zhaDieEo/69zcttd95Wvbn6Nk57sZj8V1y/s8X+2E/vS0yGM?=
 =?us-ascii?Q?D1L9TPCDM+/8EfYBFO7QVR/rbUArPKLE6wyLLlCw5q72rWDisGyb53eCUXpa?=
 =?us-ascii?Q?QU6GyTQdWlBw0geFvzuLrdhJoVBtPEi439nOQgHUwqI/uF8vARaPI+8SGdaB?=
 =?us-ascii?Q?KAi1doawvNimptUPbe4yGaNgOi4PbGmGSL/Lzagv4jMW6M2KKHaFgVPsgOxi?=
 =?us-ascii?Q?k7fUF5F6s56/qdl58WngqMLZpjVcYwpsJiKz3lV54H/GJrDFqyiwwIhx7Rdz?=
 =?us-ascii?Q?8A6pM+1CN1uosJHB0NcgV2rastf6NTsOFlIsmH+HAXMGN6EYGWso4Y8aeWT5?=
 =?us-ascii?Q?KS+IUXiitvzFD1pxQThF9MKtZcDdvd4jYfX8cHDFr0X2ypi3mR/17rW+YZkG?=
 =?us-ascii?Q?OA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b31e763-49df-446b-9762-08daac62aa44
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2022 15:01:39.0834
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MXkIwlc55yi2uIo+ZUPSD70174BELu483kku3rg3pSko7AAxNMR3gZOKcoIxGArfokT8uIHDB3czJSVFFlyMcE7XCUP8TF8xYS72z51vo9s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4843
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-12_07,2022-10-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 mlxscore=0 spamscore=0 bulkscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210120099
X-Proofpoint-GUID: zZOB0OBUilyoAFfKpXW_fB4WMuQqmf0X
X-Proofpoint-ORIG-GUID: zZOB0OBUilyoAFfKpXW_fB4WMuQqmf0X
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The devm_request_region() function does not return error pointers, it
returns NULL on error.

Fixes: 914d9b2711dd ("sunhme: switch to devres")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/sun/sunhme.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index 62deed210a95..91f10f746dff 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -2896,8 +2896,8 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 
 	hpreg_res = devm_request_region(&pdev->dev, pci_resource_start(pdev, 0),
 					pci_resource_len(pdev, 0), DRV_NAME);
-	if (IS_ERR(hpreg_res)) {
-		err = PTR_ERR(hpreg_res);
+	if (!hpreg_res) {
+		err = -EBUSY;
 		dev_err(&pdev->dev, "Cannot obtain PCI resources, aborting.\n");
 		goto err_out_clear_quattro;
 	}
-- 
2.35.1
