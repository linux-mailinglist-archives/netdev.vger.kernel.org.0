Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E18A2611574
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 17:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbiJ1PF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 11:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbiJ1PF1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 11:05:27 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1B566B15D;
        Fri, 28 Oct 2022 08:05:25 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29SEfF9D011139;
        Fri, 28 Oct 2022 15:05:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2022-7-12;
 bh=2pf5lQLoP4MNtIdn9oSZG3V5EVauPctjqSfthpmtjoA=;
 b=gdmQxlRkUB3obuaFVswYQ0kcDpjTJcxgw4gNSYPzl/KgGf/+oF/8Geg9esEqM3jKgj9A
 szBGdm8vjsQ0KJb2JA2jvmnkgtavv7gzIuUXNiTRN9TxP/V8R75RJM5PzeHsWL9Y3eve
 7chaKg16m1D8ocJLlxn/D9ZFOSvWQcL4ZtTCZ2LbKNmYJ7lPLGE/nExph7P2YnOMT2RG
 4isPgTd2Sr2lus3KYRPqWfioRaVefZtXzSS5Za3spn78juwauvm2wK0mQmVJCCInfoQ5
 LFiwZ/Tx0XjbSHSYFs5eefsiP4Oenvn0uIQfuLc+3D4eIWDTqzp86iCOEY7+IkBfjx5r vw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kfahedkdd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Oct 2022 15:05:13 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29SEF3Ra006899;
        Fri, 28 Oct 2022 15:05:09 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2040.outbound.protection.outlook.com [104.47.74.40])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kfagj514f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Oct 2022 15:05:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gAPGVDmyRXjZ4TDrnWSrUHHAix8xTWUm7aNrETw3GRTHrr6ih1jNUHRsQHLuendpwKvi6e1MV27/NegBTSlqZEyGPhUrXyqHyOdCHXMMe4PtSfQF0LWZWO/tCGO8Ytz+5FmVQ+OU8S2tl6dabn0R1iw1ye9T1XoQUHlVkUm7FRvycRm80qAv6MzYWEj7zvDkMs4NOZPUcS/+1Cb3OYyRUKlvlndRjgpUxQD7oxAg8V5nsdz5WoNiVhSGE4fJyoOYR8g3r3Ajf9QNeA4Hlxw8kznu164OAL4KTKE70Tj5DhWZrh/wZVf3SqS1q1tsldb6n7QT/JmwzxiXO0JhHawyMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2pf5lQLoP4MNtIdn9oSZG3V5EVauPctjqSfthpmtjoA=;
 b=kQ3ZT5WoPtaRGtsu8QxrJYIqnQn3NHSn5gTBptqEztPbD1AMiKJ+VVtjt6dFj0xMCx1MLeNhJxfS51QY9B89AodhhxkOKKmjeA8x3JLuPYhlKH1RcjqHuiprE+9O0L0s11H/nI9HsMJCs+r0a5faRuxYlKxXhZ6+wVyhPGNwUf6P6e+eYub5mh5d2ywbuYPq65vyHbGVOkF3DbdlCWsYLBracXvwaQfJeNEfFOQgfCS8qWgF5WkuWQ31rIRXy/4XV1o0/RhTyQqz4kj5KJZOgsprcPHEwmJpaI9P5VRgMOImIx2q+5WbsgkW/glLqqZiuckciEed37z2h96uIXQPOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2pf5lQLoP4MNtIdn9oSZG3V5EVauPctjqSfthpmtjoA=;
 b=udep5N+9HlRWhEmzFLQk1j9VtVryYDZC1lSDL6k8dEb/WnJM658ZnwalDFHyCZmvy0k09BN0z8rp0mazB1ZoXb+jDXUO0n13w0WCDng0gSRCmsr/rD+qYUd+iimC2HiNoTTpVjr2EBFXB2jjiCNK+Jio/lJTDATDDGWJntxe6Fw=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by DS7PR10MB5040.namprd10.prod.outlook.com
 (2603:10b6:5:3b0::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.14; Fri, 28 Oct
 2022 15:05:07 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::3809:e335:4589:331e]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::3809:e335:4589:331e%7]) with mapi id 15.20.5769.015; Fri, 28 Oct 2022
 15:05:07 +0000
Date:   Fri, 28 Oct 2022 18:05:00 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH net] net: sched: Fix use after free in red_enqueue()
Message-ID: <Y1vvnBnSVl976Pt3@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-ClientProxiedBy: ZR2P278CA0030.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:46::20) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2365:EE_|DS7PR10MB5040:EE_
X-MS-Office365-Filtering-Correlation-Id: 1bdfd3c3-e113-4756-0162-08dab8f5ccaf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jAp1o5Pd3wZh3ESVvN0roOa4JbbI4lclFA/xAVWcReoQzXyWRTJ0C1z3Mr0X6q+TAu1XkCvSDOcxhHZSjIc2FBRhUo5u7ts+oF8kOmA23JIpJLdh086wvpvJyA1RizQCUbWyIIPDGT1+M9u8zpCQ5CjMo3ZYQDAC3AnTNWrrMU2ZxEmv6GL1wqLnKPJA4WHCLOAAJdzQ6zf80pQ3aBtVztIQGrz5k0CuWm9yo4mD/24yZZGcrh9To/KGJAQQvg0lHKqttyVHFIGhNBkmahzAWur1en6SbJfiloyD3vdV7IReTzOten1Zf8um4XhAewFketoClNDNNMkx2oFsC35Or2roULC1aTV8fcsH9mqoxLvEB85idCAQEpgVOFzTn7pYqnkc6dU5jWS/fGYZjdEWVpgQVm+5OUPEkMBcMYvCl7KMAYbDDefqNxeQOYXzQkotPSROdYvGy8peNQn8uVwIuRByH0fXFGAZO5eHP7Bs7lUDtnxqlV/BYk8cw57xoif345SrsaLnwyy9ed+OkB7UBk4rdyAXd6BdA2FSfc9UhAex7lc8D0ANbAc+oaYwBr3WIMF3kRq4MzmS4As+wTjglJaqhLWRAvMzYI2p1JL/RZubkQahIp/tLdvZhoFcu5SWJCJeQY5gh7m818eRyW5DlFsZzfxsK1a8PFfwMwzYioDb2TyAqFimHoblzVppcfw/gEmx2VNo1hwFXbREId5+CA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(39860400002)(136003)(366004)(376002)(346002)(396003)(451199015)(107886003)(6666004)(478600001)(6486002)(38100700002)(33716001)(6506007)(54906003)(316002)(44832011)(26005)(6512007)(9686003)(186003)(83380400001)(110136005)(86362001)(2906002)(8936002)(66476007)(66946007)(41300700001)(4326008)(5660300002)(7416002)(8676002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PxDItzQlhBj2ZS4OcTv4ayQa01AMjUOOH4Zf+D8nIchjwcupbOwGmSAfCk1N?=
 =?us-ascii?Q?F14lOc/Ssl/Bh6yJULvQT0+F8yRCadJS7lpah9gKhbReOsUOBfaW0Y3HCXiF?=
 =?us-ascii?Q?w15l0awJitM0Qex6jtLkWusEZIUWQJybaTdozj0IqSchoU+ss2tN6EUmJP7i?=
 =?us-ascii?Q?PUXp1BZN6n9Kvnf9TScfavQOFY2fZYIRTsAjE3T69USnbeHYIGdDDA8aefPv?=
 =?us-ascii?Q?z3ROFuPEUyj0XI46dvjSj8Otpa4oj6w2HJPvfGREB7kxeqxFBWyK/bw47lrd?=
 =?us-ascii?Q?JMDX3IdC0TFlXRHOOwybDUEw2lQ3zm1dFnb71qZDpaM0MO6I8A9eoH3R76Dy?=
 =?us-ascii?Q?QSF/eILifsCa6OJ/hBBnqoNebVtRrwVS+0f8qvKnBCrtrTeQxP/b7AJzHVnz?=
 =?us-ascii?Q?E7rGlSLNRo0bV/tiwEhBfDoGE3zm7+eaRtzb+3sUTfg1+5yeS0xYqpxKRvxb?=
 =?us-ascii?Q?KYgEpadDHlYyX4pRrctHwUloNERqx1eEDLwVOT2BTz4rndi3GnAgihg1XLMc?=
 =?us-ascii?Q?ytSgTKVMLrtM457HayMvu4sP6Nzb8OOVGWZZYgOdfvwlq8FhZRYwC0zXz+ms?=
 =?us-ascii?Q?N4agsXwH2ZRM0emkn+ScyV2j6epNCyGULfZFjmnnUql1358CvEnk1yHFXwes?=
 =?us-ascii?Q?iqNconlRqBc6JElgel1x2aNkMcaIV3M3s3iZ6JkhFvH2bqYUkdWVMTqky7hI?=
 =?us-ascii?Q?3wvpTfk4zZzX08ZE8i7OhzIv4A2/NRAh9vl4uG0WBJZTiyzw5UnUyzxkasEj?=
 =?us-ascii?Q?j0+TbSMbP4dY/pa1TN+v3q3koTnHxUSdQJsUeTHSZtKSyIFAsn/9WJQlzcoY?=
 =?us-ascii?Q?0e9Tqmb6KPjfIblYb3xsTFDnan4kWumbkmBwsz1jb+sovIJUrVPjkC+kaOfh?=
 =?us-ascii?Q?qaRHkbFAuWfudKvJRfzCG/AGJDOlIbqDxRA797fgY7AJQxo1DscbLPQF0Q8v?=
 =?us-ascii?Q?1fRyhuujOvtnDiKOs2mJZkgbpN0YXez7OIVThhIWR2DQXNf9UVNoV09kgpum?=
 =?us-ascii?Q?PZf4+xZ33gpBPnsbaqV/4SzLONfOAymKJZDa8vAmRwM9RPHUdF7vX71u+H3u?=
 =?us-ascii?Q?2fDg9cbaL0D7zqZnKRNLb9/8uYM97fYLURjFEopuqlp+yQGsjVb2hbS2mYJh?=
 =?us-ascii?Q?FIUXLBirLopisTVWv6tJebhRdV83iAXB0htdb7kxpWkvpqJYJZy/KexcX4w1?=
 =?us-ascii?Q?8dxsPaask1tHEGkniUp6PXgRQAt7YakY9AweJ+sCV31vDbLfwIIWoEgOR5X/?=
 =?us-ascii?Q?IRxFthbVu7Hkr+yqEfUybruy4ii0fCykvQ2v8UgVJkcTLJFS44NlKNfxX0uM?=
 =?us-ascii?Q?NQEbMVRuP99MmdYrwklTvahY+ZFwB9ZWZOfMArrXqkIfrztsF7ibBpvSM866?=
 =?us-ascii?Q?bXWp4e0MK32ZDbBOZS28zrVQ2++NVVobDeRB9ZQslBwwpZBWFsVEokBhRW8D?=
 =?us-ascii?Q?zIMIeCCMP+MgtmlKkU4+xe0/DvvihrbcmL8pJbIeojkBkv6e8YN16mcVZJN8?=
 =?us-ascii?Q?4MDY17Mpva04UblmpzYVhVjT4M+cY8ljrkEfZNvQFuJuGpqAJwZ7wEgTmMt3?=
 =?us-ascii?Q?fz9eLdHlNXIR12h8A57OasjwTdgg0pNV3dszIJ49cDvHRAGo90WFhUZIeji9?=
 =?us-ascii?Q?yA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bdfd3c3-e113-4756-0162-08dab8f5ccaf
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2022 15:05:06.9990
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ycQTRwuMRNhdT3vhj6xxnE60QCRtZ7sY7HhPR0pPiSeJ6BMNw5PRFQG5y10BcXOaUhWdtaulVyofujLBvWjmrVmpIQmgxb2mCQEdugOzClE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5040
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-28_07,2022-10-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=0 phishscore=0 adultscore=0 mlxscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2210280094
X-Proofpoint-GUID: 76eKyHz6yj0ZhB4FAoMply1whUeMFOT9
X-Proofpoint-ORIG-GUID: 76eKyHz6yj0ZhB4FAoMply1whUeMFOT9
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can't use "skb" again after passing it to qdisc_enqueue().  This is
basically identical to commit 2f09707d0c97 ("sch_sfb: Also store skb
len before calling child enqueue").

Fixes: d7f4f332f082 ("sch_red: update backlog as well")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Applies to net.

 net/sched/sch_red.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_red.c b/net/sched/sch_red.c
index a5a401f93c1a..98129324e157 100644
--- a/net/sched/sch_red.c
+++ b/net/sched/sch_red.c
@@ -72,6 +72,7 @@ static int red_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 {
 	struct red_sched_data *q = qdisc_priv(sch);
 	struct Qdisc *child = q->qdisc;
+	unsigned int len;
 	int ret;
 
 	q->vars.qavg = red_calc_qavg(&q->parms,
@@ -126,9 +127,10 @@ static int red_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		break;
 	}
 
+	len = qdisc_pkt_len(skb);
 	ret = qdisc_enqueue(skb, child, to_free);
 	if (likely(ret == NET_XMIT_SUCCESS)) {
-		qdisc_qstats_backlog_inc(sch, skb);
+		sch->qstats.backlog += len;
 		sch->q.qlen++;
 	} else if (net_xmit_drop_count(ret)) {
 		q->stats.pdrop++;
-- 
2.35.1

