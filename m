Return-Path: <netdev+bounces-3088-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AF4F70568B
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 21:02:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AAC5A28129E
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 19:02:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DE9A290F3;
	Tue, 16 May 2023 19:01:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B1F9290EF
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 19:01:45 +0000 (UTC)
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04E1A1FE9;
	Tue, 16 May 2023 12:01:24 -0700 (PDT)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34GBgDik009807;
	Tue, 16 May 2023 19:01:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=2P7UaktNOmnKY5Qvg1rZVkVahBHU/sKtgm6MMlo5YiA=;
 b=Ml2h214H4upJCJTOXT3pxfclRheWnbs9qJ7bZsJNle/tnDus6HSQxP13MaR0hbtjd+Sp
 G3aDw7QOYTFoy6xHCEu2U/JPFIkWu+JAkxRbdq1pCmllFNMvvgQ7OrC/J5hpDlTwrwzD
 BcWw7llXS0ktgJE9HG6CeDelCazauO9B5KgJFBSg3fMaQBLx1N7jI3eVXOZdmZHm+Emt
 1h7wGgVkaacFgLYlvn71K9ze0sFxv/ZULvcXNNCm8DABvjGtfM+cIqLCh249oZiAZaow
 iF+TOTW0yGQukuHVPPuUkbdZq4kXb4IqTxUHl63KtbZplr1pkNF8j/3+9MupJCO6VQOK Bw== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3qhys037mm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 May 2023 19:01:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cCJZx+vikmPGLPJ5x5+Ya9HIIubLXcqnDs+Cbbp08Wyl3Mb1lSYTuZors7JrkMvS5HJA8GTBloDFq3G9CgFqYLPm4CsWOt43axn4lfsQMNdb6baeL9nuRdfzsQh8tSFDUKKdyQWfWA/Za3YG80HEbw4NIZfFskiX04KvScOUEeoAG0hyP39TWUNrYKeeZcKFnxcwNP+Yv+OkUbhyTRzcgLoNaDdNW/iM9ejiuR6er7t9Vy7cm3LJDQG9JFHJDRD3+SXDKJ65aW2M6D2Mmf3cCW8uo931jFG5y53wof+/189/W8+3oIpEj3axM2uUSqnuEBuSQENzv8eXIJVPTDYjBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2P7UaktNOmnKY5Qvg1rZVkVahBHU/sKtgm6MMlo5YiA=;
 b=EWAgBtWMmEx+C05jGHX80Ex5+7x0ikPjbE0ba4Wd5Fz2zVVQvsiIXSElyGpB/vOovdu+KbxGziJhn6KOIAn1R6d0BejX6p0rWrZDAZJC+lIZg0COmXrSa307oWn0BJHp5RdZet+wGgniCACX0B5+fyK/oRxJzBQTCt/KZaNW9tw25CPrezdwNnPKblzNoQCU1n8uXmW4VBf6T5YfLu1mYYblKss3mcXCF4kEta62kMW/b1E+EYtbK+j4feigEGaKeuACgXiHYtmhP3uHsr4RlzJIq8mudkee52RFIQsf+twopCKIiw/asl2VsWWLWMozZuxUHT/ZQyxGYq5fr2tD6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from PH0PR11MB4952.namprd11.prod.outlook.com (2603:10b6:510:40::15)
 by PH7PR11MB6953.namprd11.prod.outlook.com (2603:10b6:510:204::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.33; Tue, 16 May
 2023 19:01:05 +0000
Received: from PH0PR11MB4952.namprd11.prod.outlook.com
 ([fe80::5693:5120:1f58:9efa]) by PH0PR11MB4952.namprd11.prod.outlook.com
 ([fe80::5693:5120:1f58:9efa%3]) with mapi id 15.20.6387.033; Tue, 16 May 2023
 19:01:05 +0000
From: Dragos-Marian Panait <dragos.panait@windriver.com>
To: stable@vger.kernel.org
Cc: wenxu <wenxu@ucloud.cn>, Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, William Zhao <wizhao@redhat.com>,
        Xin Long <lucien.xin@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 5.10 1/3] net/sched: act_mirred: refactor the handle of xmit
Date: Tue, 16 May 2023 22:00:38 +0300
Message-Id: <20230516190040.636627-2-dragos.panait@windriver.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230516190040.636627-1-dragos.panait@windriver.com>
References: <20230516190040.636627-1-dragos.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0701CA0029.eurprd07.prod.outlook.com
 (2603:10a6:800:90::15) To PH0PR11MB4952.namprd11.prod.outlook.com
 (2603:10b6:510:40::15)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4952:EE_|PH7PR11MB6953:EE_
X-MS-Office365-Filtering-Correlation-Id: 9cdd6e09-5a1a-4fb6-b6bd-08db563fe5f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	2v4DKQwJ2Y0rikCObhpE9Lnd2QmVqhBEPG0INkM58/MuKXI/rFW2pzwXdihnGnLreiH4HgZ/fFvybOONpUAj4zqKAHoPvZVKRbhaWDKudFouqp1/JNsqemCl3S4ifDpCdnmvZc0+o4Hl42yYRYxDnsBhSjUWDZiOYNdNVvXQPYVERQRj1dWmOzco2yMAuoh/35DxxYZT6OZZ8Gw+crhjMygcIcBfGdA2bzb8M1hdXt0A4n+b573oM78dWAXbENuxUwunW4Zg7+RGjYF32e+VWTvjfbAe4g/BLXwBc1FnKFBoKZDHzG1xNn4ZQKZow8YUTSUu7yec6eOx4Z8QXpq4/CF3+DQzOqa8AWeKdT2r7GjG8Aj2VQ/KKk9xdMFpGx2xQ47ufStQaP4mnHUjsakM6pCKkiO8+kUbgHVnKv7gQmywvhA3oe32+vULOU93b7mm1JkllFKUkRbo8FRPgzPYoPowwT5bx/WRp4pzQ1rUdMET2tTLhfEIH8I0st2bLYeIOgHEmLMA/i/PXSW2LuQ+kEI5f7p/+ZN8jw6E2akGEO5p7CQSK34fvR6xWmmkw4GUWzOxbkF3bwafETCqsosYDa9ASjKQ1kDuXffQtyu/iJs=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4952.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(376002)(396003)(39850400004)(136003)(451199021)(38100700002)(38350700002)(36756003)(86362001)(6916009)(6506007)(41300700001)(316002)(186003)(5660300002)(8936002)(8676002)(7416002)(54906003)(6512007)(26005)(1076003)(2616005)(2906002)(66556008)(66476007)(66946007)(6666004)(6486002)(478600001)(4326008)(83380400001)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?zn6WQXE7c0rxRb3tDCTEKTcS96xxjBrdqByQm5jMCh2rROFFJR9022P3HSD8?=
 =?us-ascii?Q?rmD0LSjhaGtf3DfqtF+zAApK+y8MwpS7TK1K0b0FTOdXaYg6u2SDtQD2C0EY?=
 =?us-ascii?Q?oZ0ZQJUjMRvSllJKVx9pEYRuiSJMKe3HUX/9Cykwm/xKEUhLtlae+/gs0l4p?=
 =?us-ascii?Q?D6GxQzTSI8n5L6LjGgeEhYCJNacR/XtVwEQXP7dJMlxT4OcWXLhbSC8hA+9d?=
 =?us-ascii?Q?H5AC/EofSNGTgx++THyWHtHNF8ee/x7smhzKpwTxXq9oKtmtKiVq1bzChAy3?=
 =?us-ascii?Q?9phcAMU1S31ObaqwqNtpadSFnJVuVYDxP/lzW2iSUpuxkma1X1k5RSKj28Fr?=
 =?us-ascii?Q?U/d7GYtYs6E2GgjMRJwxNbFe/IJ8iW3atY+4JhlIIP2bY302QaDcayHw8iXm?=
 =?us-ascii?Q?s1BNrJI5TC78mGGCqzWxTkVmfzp4Laq+UQXBNgRnyMMcaIsueOfnJvn7i8mi?=
 =?us-ascii?Q?0DF7k701zg+ODm1JAktYmwsOGP+Rw+HjHjZU/DHYYhOF9Py0EH+H5WtKfk2b?=
 =?us-ascii?Q?pX2pxeat+Sc8PU2B42j8Styu2itBF1897J+pka4a0ll2fDE0MSFSDemw25fx?=
 =?us-ascii?Q?s8QeRYBjnJ/z4K6CBDs8uVKqAkyZKu9vU/riEOYl3gB+A7Jm51vZ8EXLOH2F?=
 =?us-ascii?Q?v5q4j/A6VhHmwr2AzqpI+WXZC3zET4fwh5mzqEhE5nkrAqjTcwea4y1MxUKS?=
 =?us-ascii?Q?NBNQR274JVuPwtGDsifTK+T7gDHD6+XMXarm4Oxob7hy9g+ObtPIvD3SBMz/?=
 =?us-ascii?Q?FniQUtAElP3H8tNLw4IcmO5v2Ry/p3HbftocUt3Y0xDVxVNLB4kFy12PToKv?=
 =?us-ascii?Q?0tyngzZJ1zhYx/L+PyaazovqQfBv5C8TL0WZ/GIeQMQQMlrzZywYADG6jZRe?=
 =?us-ascii?Q?eeCFlfz5wAPatmdBl6kquwN+egkbGu6xM2JlHAr33dIcKqqdqrpTIVc7fPCp?=
 =?us-ascii?Q?MNywdDqbjFJMjMcLwNm2/sfKbve0dIPIzhvQqSbYUkDM5nYKNjFLog7+Z6gN?=
 =?us-ascii?Q?ZaHkqsfPnLaae6GgKlCAcmc5IWTpM8u5heRObdFdR1EyWWes7DEx3PboRgyx?=
 =?us-ascii?Q?5jACazxE5Q/Z7zvb2w2/TyqJ1bAkjOuYoYiBIULVBpGmDIjkCgKOWzCp6ThU?=
 =?us-ascii?Q?aCK8XDn2HE7YwAUZxkLqMlKMnOrprXTq4Aj3NkGpUcG9zSl14Uk6U+WWh6iW?=
 =?us-ascii?Q?Y0ACsTU9R1tCLecCmSd2iRpKrItuWLWyEKRAxLPjcQC1dHjYoP2gTfpmm/JA?=
 =?us-ascii?Q?hDg8ErgPL6b0jAdua3JYElDJQ1S88RUfJrYh8mKDl/LXLG0waQAMoSvzyYXM?=
 =?us-ascii?Q?s3FR8z0qT6leT4fHjMlZ8sJnOX5DbyKkKl441AK1Q2DMhcudEJlKhDj8WIT6?=
 =?us-ascii?Q?wvH7y5HEb31M8jGfEW+Ro4+vnXkvaCptKtjD7G47AINvx38hswkZC4FMjVU3?=
 =?us-ascii?Q?QglxV4pd1HK1/MiaqSwcR4uyRnvcty3/2rPX7BZKZ+8E3IQAozcEmDwgYJgz?=
 =?us-ascii?Q?beMs0RuYxbpu7j4aCTJqWT1OYgxxHKiAlZ5PbGW08pvKrdgA8QHZuMAPn2Dz?=
 =?us-ascii?Q?HKrL5obNeIbN+gLiv75WvoCiLkQoEixFUo4DbXwVat5kAeG66U4l350Mi0UX?=
 =?us-ascii?Q?jw=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cdd6e09-5a1a-4fb6-b6bd-08db563fe5f0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4952.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2023 19:01:05.7291
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nIVo7J2NzQDVgoXJHs2ooNC/IitXG4rldc6DilGxGwGfnGDvzIxNR2VChyQ8VaVtTCiDo7PJERCtdJ0yabPyS/+6X2mncWb+7IayONS1T8g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6953
X-Proofpoint-ORIG-GUID: PTuf07kiYvMm7UkfZI6G5Te_7Rw23yRD
X-Proofpoint-GUID: PTuf07kiYvMm7UkfZI6G5Te_7Rw23yRD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-16_11,2023-05-16_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 suspectscore=0 mlxscore=0 impostorscore=0 clxscore=1015
 priorityscore=1501 phishscore=0 adultscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2304280000 definitions=main-2305160157
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: wenxu <wenxu@ucloud.cn>

[ Upstream commit fa6d639930ee5cd3f932cc314f3407f07a06582d ]

This one is prepare for the next patch.

Signed-off-by: wenxu <wenxu@ucloud.cn>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[DP: adjusted context for linux-5.10.y]
Signed-off-by: Dragos-Marian Panait <dragos.panait@windriver.com>
---
 include/net/sch_generic.h |  5 -----
 net/sched/act_mirred.c    | 21 +++++++++++++++------
 2 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 61cd19ee51f4..a62677be7452 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -1320,11 +1320,6 @@ void mini_qdisc_pair_init(struct mini_Qdisc_pair *miniqp, struct Qdisc *qdisc,
 void mini_qdisc_pair_block_init(struct mini_Qdisc_pair *miniqp,
 				struct tcf_block *block);
 
-static inline int skb_tc_reinsert(struct sk_buff *skb, struct tcf_result *res)
-{
-	return res->ingress ? netif_receive_skb(skb) : dev_queue_xmit(skb);
-}
-
 /* Make sure qdisc is no longer in SCHED state. */
 static inline void qdisc_synchronize(const struct Qdisc *q)
 {
diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index 24d561d8d9c9..53594b0466eb 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -206,6 +206,18 @@ static int tcf_mirred_init(struct net *net, struct nlattr *nla,
 	return err;
 }
 
+static int tcf_mirred_forward(bool want_ingress, struct sk_buff *skb)
+{
+	int err;
+
+	if (!want_ingress)
+		err = dev_queue_xmit(skb);
+	else
+		err = netif_receive_skb(skb);
+
+	return err;
+}
+
 static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
 			  struct tcf_result *res)
 {
@@ -295,18 +307,15 @@ static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
 		/* let's the caller reinsert the packet, if possible */
 		if (use_reinsert) {
 			res->ingress = want_ingress;
-			if (skb_tc_reinsert(skb, res))
+			err = tcf_mirred_forward(res->ingress, skb);
+			if (err)
 				tcf_action_inc_overlimit_qstats(&m->common);
 			__this_cpu_dec(mirred_rec_level);
 			return TC_ACT_CONSUMED;
 		}
 	}
 
-	if (!want_ingress)
-		err = dev_queue_xmit(skb2);
-	else
-		err = netif_receive_skb(skb2);
-
+	err = tcf_mirred_forward(want_ingress, skb2);
 	if (err) {
 out:
 		tcf_action_inc_overlimit_qstats(&m->common);
-- 
2.40.1


