Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 677F74BD57B
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 06:45:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344559AbiBUFiY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 00:38:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233752AbiBUFiW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 00:38:22 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C4FE40A1E;
        Sun, 20 Feb 2022 21:37:59 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21L4oXCd024603;
        Mon, 21 Feb 2022 05:35:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=CBHyDs3SS2Drrr+S9+OVEQm1MZOBD8sNV5RCnFu9JrA=;
 b=fE8x8FqeGcaw7gXGrAFoRMdUnkT1DF7mnq405Um5xccYlfX9kyV8v87Bn73J4I8iwqtA
 89PF/kkIE9D05llGclJNaBLa90gWtuH8iK3IloYTYHxP+pJPyUiKbXJKP5FpKr5/j9D6
 c5zYlsq7rqbw+Ju7Ya/J/dywE92bb767H1jb9/6zUgmAqlOoJr2VdOsYrNnjrkALZKD2
 unE6nNRBp87b8o12DmYJBfc0QGWl6sod0B28s4dRWx+21tjcnLSjJsB802X7Gf2VKRqZ
 LMV+X/ve8HiljjWyKSkYNDMJfn8/xl/A4QOgBrgQ12lVaDhnZkfjuV2DLG71Vr0A9r9+ Bg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eaqb3b4jy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Feb 2022 05:35:15 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21L5WNA3077278;
        Mon, 21 Feb 2022 05:35:14 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2042.outbound.protection.outlook.com [104.47.51.42])
        by aserp3020.oracle.com with ESMTP id 3eb47y8ntk-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Feb 2022 05:35:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B5emhA4c2wjYkdD3VeNK71ZSdkqm44PStlvfkkavZbF7Xb/cf4WmCObaI0uyHXd4RpRHw0h+2yBxHWjgycfBCr9LTp/OJ5Y4dwaCH4zGfT0jJ2oGr4il8ooW27LrWO/FJyvgXojdCT/lug6m5uYp9GIslOzZ7P0VNgPaL2Q0RaLNa12NvUra+yuZ7q5lRrajZiWB53GVxMYpNwTBGNLnIcKGLE+AX0fGKYj7NHP5usbS2mb7zmnKBCoA76XYcJTZncThkJyLTnARKuss4mGFoSbC8P6p18LRANIdMfpiX+3CzOELSk9ljnBKSdSu/T7h6hoJQidp4PbeFDKCeI/MVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CBHyDs3SS2Drrr+S9+OVEQm1MZOBD8sNV5RCnFu9JrA=;
 b=GM5FddXkULF/zk180Rt1JQDbIz/m/56LQ8pAlQw9mBp43PB44D9+ttkDwpFW0awBTc8DIBIlvF0OSBUIRJtukgWnh6/bC+C3CnoWhdPpHhlRUchYZcByGDg8JsJcVYxkeZSpRFhGOp4wOLaZwzKIgXUtyFgMYVu4fQFOcKPhxdo11RDBOY6cUtUK7hmoW4vVe99WdsDERoZtY+ktf9M5UfhHV3z6grZiAOz7EA0d5qgRsDhS3bjF14oIBTGSOfIhGbicNvSsP+pUuSEGHDT2+7I8/4eX6G5RBNTP5rru4zv9cT2r66jFAz2auMqnW0c642dVs8JI6cy3Xn8nPhX1pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CBHyDs3SS2Drrr+S9+OVEQm1MZOBD8sNV5RCnFu9JrA=;
 b=diSGyDAJOU5mPVcw7sui0bAO2oncYa0HZpC/93dKTUxZ3eLsfrRkv+pn+gc75QflwEnjJcAA/NrXap8p8PL/hihDJtMIkMjFAnxql+i/uKKfLcCoCDz8yW56mVJDd5In3h+ch/XvtqXaQK+l4LDU8r6ZmuCbTL+JXlTIPN9cngg=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by MWHPR10MB1533.namprd10.prod.outlook.com (2603:10b6:300:26::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.17; Mon, 21 Feb
 2022 05:35:13 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47%4]) with mapi id 15.20.4995.027; Mon, 21 Feb 2022
 05:35:12 +0000
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, imagedong@tencent.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, dsahern@gmail.com,
        edumazet@google.com
Subject: [PATCH net-next v3 1/4] skbuff: introduce kfree_skb_list_reason()
Date:   Sun, 20 Feb 2022 21:34:37 -0800
Message-Id: <20220221053440.7320-2-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220221053440.7320-1-dongli.zhang@oracle.com>
References: <20220221053440.7320-1-dongli.zhang@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SA1P222CA0020.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:22c::21) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 582e49bd-d6a6-49b2-287c-08d9f4fbeea4
X-MS-TrafficTypeDiagnostic: MWHPR10MB1533:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB15334311209A8DAFAB5C17F6F03A9@MWHPR10MB1533.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dtqLkAYQ93cGnW2/Z8ZsMZG4Q3Ttq3pbDmFB4fjwxCgHXzxIVq4euY3D99crYcCDVZzQ2hhr7mmlJH/mWYFRC6QT0sfWO69vjnh5WNp+4cgtJsZ0Mxoj04QS70/eh9o5lDhX6r4UXAyMvF4GR8HinaYdW/2qdsnkQvUtwJFnG2dSOfJtEzHw3or7WCdWqYN7g6NDFW+eiTZZvLl8OQSjkBoQpmXB1AXGnpXF7EZStqTTuGL6PitRYHElnkiqi2Ad6ldP2m4LNP6SqC39lVJsa3tC4ByPn8VmJgHMiIH/XsyNA405VJr2iC8W7i2XIMAk839vrrLc8scUZuzIacH7bmC0naxApuczLpb8oDTDYWd6h+0rcsAGmHdBmf0LEnv5oOgVnd6kQ0tl0Ss8t8ftPNj6kS7P7qQvAn4hIz7EO0F8i+6JCuIxKkbZp16lJ2abTqwN6VDmuzqDgzSdDT5vDi2Ln1usiwAPAuRMUSv3mymacdt3F0lrfQENPts7oK9nvNI2H8zPYMhuy+DtBEkQ82egqzH1LlxCXCLQtWjZ/WfdvFW8ljzPXnkJ9ilraj+uqOkZjjYPm7Qd7cLU211WU0QeM96y1dnZO0Um1NJbefTCklD3fnyJxqPTeoObTja2gSDr9t9G2qZu2Ddmk02zHM5l6o53j7RscJAsEuFUY2gQUsQ814YBa4+sKqmYQQaue8q20fpiC27jT3itDgRm+A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(38100700002)(38350700002)(83380400001)(36756003)(7416002)(44832011)(5660300002)(2906002)(8936002)(2616005)(8676002)(6486002)(6506007)(26005)(52116002)(186003)(66946007)(66556008)(6512007)(1076003)(66476007)(6666004)(508600001)(316002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8KLX3vpcIBAE0ys5Ggr68GdLjrBN1LR5mXP+1lbTQ21FREvV8XCumwc/t2B7?=
 =?us-ascii?Q?2QDJvuTfhSZ9BCwXeT1JlDJkDJChieGmXuwF3FzI3a7lVJ6JaL0XMa2noyHs?=
 =?us-ascii?Q?LL/sCVARu4IOPNbGPTjn1YVznqpE6TmWqsCKyKrxT9/AFCaaOXHrCO5lArKI?=
 =?us-ascii?Q?8u/74h0gQjU5IqdbH99O1oZn7fKveIZitu0N46oX57zKjHzsnM5PE2X3A9cu?=
 =?us-ascii?Q?/kkIOuwnGXb72OMtXmzKMSW+8HKSMerlYe6NVjgrCkaR8Li0+HxfOkgsYOzE?=
 =?us-ascii?Q?qYjiPWYQ9/9k6C6Ue+vKittk6Y+FQoUbrcbCWuLoKDNtqFlT7GtIRZyDR1xf?=
 =?us-ascii?Q?L7re556kaSgrGx662GiR80CQ0cz4NQe0BodrxTLOW/ZeZGh9+ynm1/72HF8U?=
 =?us-ascii?Q?ZCh/lmCqolghVLCXzOy+nxsNg/suLkDFpLk0wV84GYoesmBIWF7O3uSN36Mi?=
 =?us-ascii?Q?tzKMBOXwHr9U3NW0kWqpn4Hh+9PSxXhLmgYyjdf8/CBwvrvdABIj2esVWGca?=
 =?us-ascii?Q?IqdOZYVGGsh+KoBAF0lG2+2NPJ42YGDeB6E7TLqQ9cC+lo2SMWzVbVduI2EX?=
 =?us-ascii?Q?KRucdIxG9ixWCckrNa7JhAEKaJ8CQQhmA+uZfb9maF1yIODU5pcIC/4lnZcn?=
 =?us-ascii?Q?p0d1Dto3+POWH8LOtPLNNOjXj9S6YnOJ4xTSpo5FZYFjJ5MfrI/UE475AnvX?=
 =?us-ascii?Q?5NhTDB3ENPGghfyeRsNMzxyflUqlGRsdHpr5eIx1pWsGJN+jES92adBQlrlc?=
 =?us-ascii?Q?I8yAWYXGz8LrYOX/c4tolpG8RrmVRrWs0lSlnixbS9dW+a8Gt9IuPDUoaSQx?=
 =?us-ascii?Q?qjIlJiJ+SU9vDfX9InIQECcFRPJL6fuCiMcluZROi5xaYN/uwT+qZBtNr3Nr?=
 =?us-ascii?Q?MGne6faYNhCOa891KQVktVSVb+e3bR7pAV29+lamCtE8qzmuv1Hpookl8Hk3?=
 =?us-ascii?Q?7Kbd5Vsya4rFGWncoGd/Y0isFnkapcxwUV3Bk5iR2R8jgwz6MuhFOUPVsC0Y?=
 =?us-ascii?Q?ZYOlFW/XVRCIAQI3Oqzuc3fc6J0GCUjjtyjpDsdJhe7eVndIyjlNR4l8LRs8?=
 =?us-ascii?Q?94XbO+rETp8wKvL18oPN5ds2zwfbC6IMtr0fRyhC7jrgiTybRaLwfXy8FQNA?=
 =?us-ascii?Q?zmWTB1aapDSZpwGzKNZa+6/Fs3HmEW106cTqVS9GS8QrzeZgnXC0xii0ghYx?=
 =?us-ascii?Q?/F/Ebdkfr/zIekuatLiD+CnClQPJcvq9kOOVTA1qT/KjVvFFHOWT1NsOLw4T?=
 =?us-ascii?Q?ut3JC+12x4HWdhiH+fl+46KW0l8j900fzto2AIN6+fBZMB8+ZpeWYE6D4MGL?=
 =?us-ascii?Q?mRhwW+luf1vH/Ovw/U5LBeRUfEyAI1R18cJTA5GeRkb8O9I352huI0dWfbUI?=
 =?us-ascii?Q?tUD09e8SA6HFilrVRyoJyiU0zVU5FmDQqg9RG/i4v9yz5jdac0jLfp4dGi0Y?=
 =?us-ascii?Q?Lfr08+JzLo/PrC+PkCNW8yJnJDmID38sjI06joLhBAF7UmMJINKnvMWpJig4?=
 =?us-ascii?Q?suPlcfVB3//W5NUa8u2GYQcHNAPoDo2ZI1yAtxBSialOGwOOs8yef1UHiGao?=
 =?us-ascii?Q?kyRaEcHqjF5P9m3x+6bDkNjTGdfKtj2phKyLbWrLXli7DadUJgGxZ83uJoD1?=
 =?us-ascii?Q?rKvpVwASG3CCPMfqopZc0Zc=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 582e49bd-d6a6-49b2-287c-08d9f4fbeea4
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 05:35:12.9058
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kGAUHMp0NMuAES2KogcT7/DIpglo87IVHved4f+DwBCttbfarFauF1Td6kBRdVgBlKhV68bz9+Ii/OfX7YZ1qA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1533
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10264 signatures=677614
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202210034
X-Proofpoint-ORIG-GUID: jhvBI8MgqPoZR5iJkRNeG5hbW_xJp4aO
X-Proofpoint-GUID: jhvBI8MgqPoZR5iJkRNeG5hbW_xJp4aO
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is to introduce kfree_skb_list_reason() to drop a list of sk_buff with
a specific reason.

Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Joe Jin <joe.jin@oracle.com>
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
 include/linux/skbuff.h |  2 ++
 net/core/skbuff.c      | 11 +++++++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index a3e90ef..87ebe2f 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1176,6 +1176,8 @@ static inline void kfree_skb(struct sk_buff *skb)
 }
 
 void skb_release_head_state(struct sk_buff *skb);
+void kfree_skb_list_reason(struct sk_buff *segs,
+			   enum skb_drop_reason reason);
 void kfree_skb_list(struct sk_buff *segs);
 void skb_dump(const char *level, const struct sk_buff *skb, bool full_pkt);
 void skb_tx_error(struct sk_buff *skb);
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 9d0388be..dfdd71e 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -777,15 +777,22 @@ void kfree_skb_reason(struct sk_buff *skb, enum skb_drop_reason reason)
 }
 EXPORT_SYMBOL(kfree_skb_reason);
 
-void kfree_skb_list(struct sk_buff *segs)
+void kfree_skb_list_reason(struct sk_buff *segs,
+			   enum skb_drop_reason reason)
 {
 	while (segs) {
 		struct sk_buff *next = segs->next;
 
-		kfree_skb(segs);
+		kfree_skb_reason(segs, reason);
 		segs = next;
 	}
 }
+EXPORT_SYMBOL(kfree_skb_list_reason);
+
+void kfree_skb_list(struct sk_buff *segs)
+{
+	kfree_skb_list_reason(segs, SKB_DROP_REASON_NOT_SPECIFIED);
+}
 EXPORT_SYMBOL(kfree_skb_list);
 
 /* Dump skb information and contents.
-- 
1.8.3.1

