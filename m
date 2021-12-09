Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA7446E58B
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 10:28:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236163AbhLIJcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 04:32:06 -0500
Received: from mail-dm6nam10on2106.outbound.protection.outlook.com ([40.107.93.106]:50465
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236292AbhLIJcC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 04:32:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GxkgP5x1gC6FQapnO5t8xG0XEVOZ8oOASS6vv74ydJZ2BjUI24JtWzQqQoQCVlZSICjgqHg4c5zDhL6Eb5wzyD4+L3ouFyvzTpLFjsEFFkBB7L7eUrDkKljYQ0qq2N7jgC22lnJLW013Cbw9JLm0uu0N0dFK7P6VuScjrNtAnC13+c8E7dONxaaD8dFSbUAEZg1s4A9Kuoh6yqru3rCYNzaRtP1DnzzYmI5GDh3s8mt7z7qYl+Ou6PhM5cdIcMpQneMrWEQMaAfqRcop2eyQKRabRbgaUF///ZK9tTo/fACggHY4ZhvIvGqt57+ku9NhJdrhUKfr4hXS+tbEPKPeJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sRp1HCPVPqPJU3OHFquMchwhifHi9LhY7LZW7gk03f4=;
 b=TaoxnMEKmn5xpdBPLWGb6INb0FgMm0pJOzPVELN2yjT1v81EqRBN7s/QRgJGKLaRSyKwnxLzQRfask5SWAdntOTlR2sA9ZLyFGrZuV+cSRoywxGr0nnmeQ4CfNKQP97Rswh2kOxk0ERK/VoV2qnCgttmUmvOZ636i9lWze/2StkVAsn1L/stIJDFb297vbcrFlmoD95ljwE8Ci9XSaXnQhW/vWUFul/2mRmFLedlesIA2Wrh7WrBbQ6NsN8hjNtBJez6M5bbg4DB9Gq13MRi/DkKquarIQHt9pGmv0w8FGIhuZ93K17Hgkyd19c28hD5ionbGofo+aGzS/UVAgPgvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sRp1HCPVPqPJU3OHFquMchwhifHi9LhY7LZW7gk03f4=;
 b=tptWxbGx6Ok3CErA8f7qAC+Bjgz8pnDtb2WqMaBZYTnTRzp1QEI7HHGqPYyit2Kn3cgTlfzNIyGs3QDe2wcLDMnZ88zyPSy8vGRlKJ2hMOAGvWM/NmB3BAOj6rloKaO2mIUdzzDzatKiXi7IuYDVVeFKvnevEeZYk7iMHdETdEo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4796.namprd13.prod.outlook.com (2603:10b6:510:99::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.10; Thu, 9 Dec
 2021 09:28:28 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c%9]) with mapi id 15.20.4778.012; Thu, 9 Dec 2021
 09:28:28 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com, Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v6 net-next 01/12] flow_offload: fill flags to action structure
Date:   Thu,  9 Dec 2021 10:27:55 +0100
Message-Id: <20211209092806.12336-2-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211209092806.12336-1-simon.horman@corigine.com>
References: <20211209092806.12336-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR03CA0068.eurprd03.prod.outlook.com
 (2603:10a6:207:5::26) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 27590a60-0fcb-42e1-e77f-08d9baf641f8
X-MS-TrafficTypeDiagnostic: PH0PR13MB4796:EE_
X-Microsoft-Antispam-PRVS: <PH0PR13MB479660A5DC0F7A0D56EB9169E8709@PH0PR13MB4796.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:179;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cWni6bv/46YZaDqTK+z4FJm4tcGd1EOu4eMVBr+d6oyccdwYs88g1KJmXj0c2uA3caUH5dYOrfZZAYQo1zE/jeCaMp7JyyM5orC+Bkynl2xcXtINgUA49DxVMMw5Xkc2PH0QmxFTCrIEPmjLKOLp2ynt2GAgzRlDYwMxZ3o+UjZgzzPePPL7LDjw443UVSC7s6F66Bqy5xHn3bcrZkXPF5DKL1UWFdu2jDaXkzSey2NTHYafGiuyHvYgu1AJ0il+3z1q/aOa6Ndq+nzHry2/OKm0Wlko9g5ZGByZ9qnDra7DxRqVh00AezVFaNAmloj55N0WGvlbZFMV7cJc+HXZcdcwmlJ8RGMnO4mydyI6anEMsqDVm7bboxQ0LOXvBi1s0ztvKfgq0VNxPOU/adzoPsfooWsEr3tA9YFZO6bqe45k+v6oMTXqC8SSUKZ87DHpQuu+ZNkx/NGPkdxsTnjjbIbpUp5n8Z4wfxZqlyT5HgaCMGWRLjxyCxs3BkBTXrqUnecjx9b4BYQwHgSVvQZhFq4b1MvhGU/StIi3Jw/Uwwg+Imu5xcy/a/NeMUa9yea+lyoEz3Tp1ZFRTubLY0chs8mwjEGVERhAs9myQfYh9JSJh81+CpBWTMNecZz0IIaIDjEphnpmt0E30Y+7aZCi5uFDuGr38LOx6YHftz1ieV2Fv3wNS0H3qOodOIfmQi95
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(376002)(136003)(396003)(39830400003)(83380400001)(52116002)(8676002)(2906002)(316002)(4326008)(86362001)(5660300002)(54906003)(186003)(508600001)(6506007)(8936002)(44832011)(6486002)(2616005)(6512007)(6916009)(66946007)(36756003)(107886003)(66476007)(66556008)(38100700002)(1076003)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YY7AbYlIMazxtApg0GxzF/TTR+7i/765Cmx7pOOfg+/Pn9I6rC43QocFGBBQ?=
 =?us-ascii?Q?Dh8wloE42BNmhe5ZjNku//tKjmyZ1BXMRVtmhiyXi+fcmfE4m8NoojOPzBNT?=
 =?us-ascii?Q?30ipZoxpxgQgcGlmN8iBD0eITEzSmXff4XylKLTSj3Z26xenl/+3o/f9slqv?=
 =?us-ascii?Q?aDWvHHwRflDevQMPbdSxzPdcLkgoQmWn8FfJhrQkS34Alu3RCDYK6BySlUdf?=
 =?us-ascii?Q?bDOu6FAKZ2Vmn85hqu+k5vSaRm10439O7dx4drZBdt5XYQe6GLOUrLi7GFkO?=
 =?us-ascii?Q?2DvzVijZreN2NB4xoW/sIwkCr89dgMAGXvL5AB0bmPhlbZr+5bvHBcUuVxJo?=
 =?us-ascii?Q?g+orecO8aRFZWbsFShUrNBU9zz/5vzoFc/o80W1Fd3zOGqYYOKFiP594Ij8v?=
 =?us-ascii?Q?AU4y7eJ0H3A1X6VGAUPQT2sN//VKiZZDC/duSU4krVoSMilaE2LP1FqYXz/K?=
 =?us-ascii?Q?R/KEfPK5RrabIOqPdsoyZIGlliR+/0E4p7Ca3qeGUw4/ShPWZTjCFg6l/ozw?=
 =?us-ascii?Q?hfzUeSZpwhh0EwbT/dlXkhG0jAQEPpstAeqcyvAoWPOJD8TE4NsvlQJexuLY?=
 =?us-ascii?Q?TNvsx6yZAcevpdIhaNHC2lTQG2IRm4dAkwv0cImRR32Wy3MKQqfYDg5JbSHG?=
 =?us-ascii?Q?THfElRrLQfyiG8lY1+GilQv2rENex9LX1kUle8fROkAk/YBmLy1Ul15QtIlk?=
 =?us-ascii?Q?fNfXNdgD9KvQSBlCYCfAlE6u6pa74c+Gjzqv3KyFEAu+NyTzJPdSoCQSQiT4?=
 =?us-ascii?Q?oblAJjluQ9sOLxCuRTlqY8KwDwfTIoxgedaPehCKJd/4+8+yDislMTKFTM6e?=
 =?us-ascii?Q?l1mIFMejQoHDitqdg6i0gkgD0OaRIha7oFfDU8JeZ+TW/PUNYc7KFB2qB/hp?=
 =?us-ascii?Q?002ybxCVjU6KAVmcStGEVq2hB9+gMP75Nb7bVRSpqjijQaP8rx0wd90/iUoG?=
 =?us-ascii?Q?wuSYLHPlqgYXFY+JfBLZNSEPjYiwJ5infStVaj/DJAD3wUbkXZzUprH/STDz?=
 =?us-ascii?Q?sltgYjm93HfXTes+Z43Vk8HwxyHWuxqlGMolvWxTyhcMYIbkUpD/qqRMGveM?=
 =?us-ascii?Q?13aOAUL+59xkDaZe2nCnfC9YA/5MEo0J2RlvYTxa96D69+H/cBNmt5ZZNrbE?=
 =?us-ascii?Q?hyr+5VzhF5r231ogSiExmTuY9r0og88YqaKnItEtEF1+atf94/ConHegdBre?=
 =?us-ascii?Q?ODsCAr3LKkRMeY9veyzneWTGUyoMiYGJ6nTvzvzk97Vj4ni2QIRLfI/J3ECK?=
 =?us-ascii?Q?+bcxlhWJX8/IGwXZVuftifm0MeFYqGfgIZf4pQ0O6enU/+nvKMcAGRIo4pp4?=
 =?us-ascii?Q?gJL86LXCoP+vVFZlCxpxsy5fQ+g2nZm9ZpvDlSLuvtfVQPb4hKvkSdUpb2YB?=
 =?us-ascii?Q?K9TgSUPURlXqLIEPx6AHo6lh1vKrg/YCUwmwwsE0iake9oKnopPEK7pE/ULh?=
 =?us-ascii?Q?eTHkQhdzsu2cRbIeQlo0ysegAO2hxz9UBaLRUKSg2GkXzrMDlI8Q9kH47/kZ?=
 =?us-ascii?Q?k0rro5npVLv0UPvtRUDBC1GB0RPeMJmYrI0Ygu7ysQd3mCLzOptdkoEtM92S?=
 =?us-ascii?Q?jRIoFybLbB3pwYTL0Zv7rfeMDBTfX5dOZW2lmxtS88KoYB19JpyJtgJ6AX8a?=
 =?us-ascii?Q?elycJOQTEZGgIKUYoRAgnmoS070z4mRZjFP2VkRievB4pSqKYNlYgrd0szes?=
 =?us-ascii?Q?gDOfrSQwUzg8D574oCk5Y5Rs4Moh4cfoO60BSyFMWFop+bXtGsmE5qdjzsao?=
 =?us-ascii?Q?HTgpzVPCA4wPYM7wKuDWvrTvpflL4Nc=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27590a60-0fcb-42e1-e77f-08d9baf641f8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 09:28:28.3826
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t7uKaLKQXcWe4MfpNkeMgwkI3IDdzDUK7UAKjm+u4hsW5/WeDu1SFjSC3GpAtBMEx6j3fFNxOidyXKSgmAcf+KK2FaYgeZ3t6z9C1rvv0Jo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4796
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

Fill flags to action structure to allow user control if
the action should be offloaded to hardware or not.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 net/sched/act_bpf.c      | 2 +-
 net/sched/act_connmark.c | 2 +-
 net/sched/act_ctinfo.c   | 2 +-
 net/sched/act_gate.c     | 2 +-
 net/sched/act_ife.c      | 2 +-
 net/sched/act_ipt.c      | 2 +-
 net/sched/act_mpls.c     | 2 +-
 net/sched/act_nat.c      | 2 +-
 net/sched/act_pedit.c    | 2 +-
 net/sched/act_police.c   | 2 +-
 net/sched/act_sample.c   | 2 +-
 net/sched/act_simple.c   | 2 +-
 net/sched/act_skbedit.c  | 2 +-
 net/sched/act_skbmod.c   | 2 +-
 14 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/net/sched/act_bpf.c b/net/sched/act_bpf.c
index f2bf896331a5..a77d8908e737 100644
--- a/net/sched/act_bpf.c
+++ b/net/sched/act_bpf.c
@@ -305,7 +305,7 @@ static int tcf_bpf_init(struct net *net, struct nlattr *nla,
 	ret = tcf_idr_check_alloc(tn, &index, act, bind);
 	if (!ret) {
 		ret = tcf_idr_create(tn, index, est, act,
-				     &act_bpf_ops, bind, true, 0);
+				     &act_bpf_ops, bind, true, flags);
 		if (ret < 0) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_connmark.c b/net/sched/act_connmark.c
index 94e78ac7a748..09e2aafc8943 100644
--- a/net/sched/act_connmark.c
+++ b/net/sched/act_connmark.c
@@ -124,7 +124,7 @@ static int tcf_connmark_init(struct net *net, struct nlattr *nla,
 	ret = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (!ret) {
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_connmark_ops, bind, false, 0);
+				     &act_connmark_ops, bind, false, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_ctinfo.c b/net/sched/act_ctinfo.c
index 549374a2d008..0281e45987a4 100644
--- a/net/sched/act_ctinfo.c
+++ b/net/sched/act_ctinfo.c
@@ -212,7 +212,7 @@ static int tcf_ctinfo_init(struct net *net, struct nlattr *nla,
 	err = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (!err) {
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_ctinfo_ops, bind, false, 0);
+				     &act_ctinfo_ops, bind, false, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_gate.c b/net/sched/act_gate.c
index 7df72a4197a3..ac985c53ebaf 100644
--- a/net/sched/act_gate.c
+++ b/net/sched/act_gate.c
@@ -357,7 +357,7 @@ static int tcf_gate_init(struct net *net, struct nlattr *nla,
 
 	if (!err) {
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_gate_ops, bind, false, 0);
+				     &act_gate_ops, bind, false, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_ife.c b/net/sched/act_ife.c
index b757f90a2d58..41ba55e60b1b 100644
--- a/net/sched/act_ife.c
+++ b/net/sched/act_ife.c
@@ -553,7 +553,7 @@ static int tcf_ife_init(struct net *net, struct nlattr *nla,
 
 	if (!exists) {
 		ret = tcf_idr_create(tn, index, est, a, &act_ife_ops,
-				     bind, true, 0);
+				     bind, true, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			kfree(p);
diff --git a/net/sched/act_ipt.c b/net/sched/act_ipt.c
index 265b1443e252..2f3d507c24a1 100644
--- a/net/sched/act_ipt.c
+++ b/net/sched/act_ipt.c
@@ -145,7 +145,7 @@ static int __tcf_ipt_init(struct net *net, unsigned int id, struct nlattr *nla,
 
 	if (!exists) {
 		ret = tcf_idr_create(tn, index, est, a, ops, bind,
-				     false, 0);
+				     false, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_mpls.c b/net/sched/act_mpls.c
index 8faa4c58305e..2b30dc562743 100644
--- a/net/sched/act_mpls.c
+++ b/net/sched/act_mpls.c
@@ -248,7 +248,7 @@ static int tcf_mpls_init(struct net *net, struct nlattr *nla,
 
 	if (!exists) {
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_mpls_ops, bind, true, 0);
+				     &act_mpls_ops, bind, true, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_nat.c b/net/sched/act_nat.c
index 7dd6b586ba7f..2a39b3729e84 100644
--- a/net/sched/act_nat.c
+++ b/net/sched/act_nat.c
@@ -61,7 +61,7 @@ static int tcf_nat_init(struct net *net, struct nlattr *nla, struct nlattr *est,
 	err = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (!err) {
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_nat_ops, bind, false, 0);
+				     &act_nat_ops, bind, false, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index c6c862c459cc..cd3b8aad3192 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -189,7 +189,7 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
 	err = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (!err) {
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_pedit_ops, bind, false, 0);
+				     &act_pedit_ops, bind, false, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			goto out_free;
diff --git a/net/sched/act_police.c b/net/sched/act_police.c
index 9e77ba8401e5..c13a6245dfba 100644
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -90,7 +90,7 @@ static int tcf_police_init(struct net *net, struct nlattr *nla,
 
 	if (!exists) {
 		ret = tcf_idr_create(tn, index, NULL, a,
-				     &act_police_ops, bind, true, 0);
+				     &act_police_ops, bind, true, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_sample.c b/net/sched/act_sample.c
index ce859b0e0deb..91a7a93d5f6a 100644
--- a/net/sched/act_sample.c
+++ b/net/sched/act_sample.c
@@ -70,7 +70,7 @@ static int tcf_sample_init(struct net *net, struct nlattr *nla,
 
 	if (!exists) {
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_sample_ops, bind, true, 0);
+				     &act_sample_ops, bind, true, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_simple.c b/net/sched/act_simple.c
index e617ab4505ca..8c1d60bde93e 100644
--- a/net/sched/act_simple.c
+++ b/net/sched/act_simple.c
@@ -129,7 +129,7 @@ static int tcf_simp_init(struct net *net, struct nlattr *nla,
 
 	if (!exists) {
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_simp_ops, bind, false, 0);
+				     &act_simp_ops, bind, false, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
index d30ecbfc8f84..cb2d10d3dcc0 100644
--- a/net/sched/act_skbedit.c
+++ b/net/sched/act_skbedit.c
@@ -176,7 +176,7 @@ static int tcf_skbedit_init(struct net *net, struct nlattr *nla,
 
 	if (!exists) {
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_skbedit_ops, bind, true, 0);
+				     &act_skbedit_ops, bind, true, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_skbmod.c b/net/sched/act_skbmod.c
index 9b6b52c5e24e..2083612d8780 100644
--- a/net/sched/act_skbmod.c
+++ b/net/sched/act_skbmod.c
@@ -168,7 +168,7 @@ static int tcf_skbmod_init(struct net *net, struct nlattr *nla,
 
 	if (!exists) {
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_skbmod_ops, bind, true, 0);
+				     &act_skbmod_ops, bind, true, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
-- 
2.20.1

