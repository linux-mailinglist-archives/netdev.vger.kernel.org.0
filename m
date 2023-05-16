Return-Path: <netdev+bounces-3089-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 810BD705693
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 21:02:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7EBB41C20C18
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 19:02:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EBED290F1;
	Tue, 16 May 2023 19:01:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A692290EF
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 19:01:48 +0000 (UTC)
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 894636E8D;
	Tue, 16 May 2023 12:01:28 -0700 (PDT)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34GHUXDY010902;
	Tue, 16 May 2023 12:01:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=gJp0SxB0p/w4/bz+nxAnUKSOEIXR+3pmN8oHFHRAcKU=;
 b=P0pJfJ10TR76mevUHCIqCR/KxYURH09q0SnwfIsP0K+/00lTpzpC4Pn5fJ0A0qRkRZPO
 rGq9Yj3yVXYBOLlw+Y+r+nBE28hcVHoR7NPRL1x8P2bUBT3Xc4ohjmM9zeOdwVqhZWwy
 7oHQ1Vh5OjB6o5gmZm/lF3qBHAPWUemXIv9myq10haVIUZLW9wwxEweg8lN7uewU+JPU
 ECTxzG+AyGdtmDur4qNh35ZKMJ+rjzdQogIjgwNypISxBdWbovwrRJRbT2SUVCh5cz6v
 Ts5WTRq64hne9bNgc9fPZrT0yQ7Kc2tdfsqZg2C2OiC1tdBoBHegy8OVxFVlfcApVmtX Ug== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3qja2jaxr3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 May 2023 12:01:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qqw8kDhGQRHIYtvsl14PDZ6Z+3PJXwCbFif28ioQf3Ms91Z8L3ixmAh8eY2SemEaG8OBPPXrLnAoqm8nVEh0E9O1tWfqMslS5PXrvqbK+cfx3m6DToWjY8313cHUkN2mmS5f9TaFhrjnCvM8fg5LXl7SJ/DJTWAPyE5PsgKanrYcdxHvXDE7IPOMD2UpmN7dBchtHxHU+L58A6bQfMQqmKj8SOLkw5PEIQYTr94phgJOe8fcAVfOlKzY/u0WtQwBgOLSB8U4VowKKs4oMT42A8KCK8dXIZAAebNXB09p7uOzGnZ+yC2hGvmzTL1q2NmJmyrDaY8A19lGhMLPHivrVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gJp0SxB0p/w4/bz+nxAnUKSOEIXR+3pmN8oHFHRAcKU=;
 b=G5PJgdJPvBJgL4txpsgv59GZVBeiVPvJBRiTggg8Dr1NL5xUyOE9snLCYcQqAYBqmxHc7VIfXluy8QxT8jc5bWg5+d9aAhTSGytd1QXtMs5m+cHLO3sZOLMLXH/mZ7YENUInLEB63eWzT4AhrPIgGVN2DgP2ZEj8RjxrEsZiKEvL2J9vFh6k1O+aomRuFy93INZNqktJollrwT8ZatR1e7Hf15OSH1f2CfJLkVwzPtEFZt4sWtCShmgwjDskEe+eHxUs8Ck8+CDSE0KGseJwdK95CZnoyTuynNZlV3qtVQXT6T9PSsS6ANpYdDRuVeU2RmnVborrkalERJNakINLOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from PH0PR11MB4952.namprd11.prod.outlook.com (2603:10b6:510:40::15)
 by PH7PR11MB6953.namprd11.prod.outlook.com (2603:10b6:510:204::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.33; Tue, 16 May
 2023 19:01:10 +0000
Received: from PH0PR11MB4952.namprd11.prod.outlook.com
 ([fe80::5693:5120:1f58:9efa]) by PH0PR11MB4952.namprd11.prod.outlook.com
 ([fe80::5693:5120:1f58:9efa%3]) with mapi id 15.20.6387.033; Tue, 16 May 2023
 19:01:10 +0000
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
Subject: [PATCH 5.10 2/3] net/sched: act_mirred: better wording on protection against excessive stack growth
Date: Tue, 16 May 2023 22:00:39 +0300
Message-Id: <20230516190040.636627-3-dragos.panait@windriver.com>
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
X-MS-Office365-Filtering-Correlation-Id: d1246dc6-0df5-4d9c-e08a-08db563fe90c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	Seg8kyx4YY9zAv3lLHDJK0BQSroZWTIzYayFmpRgF3dOSsQ570uD7D+Qp+3jzIRcG4d6c3lEveQWhXuUqVEtPbJ4Ko5JQExLV8YRGvGx1C5FcHFaho7D25ve/7i1l//Pu0RbFzZn8W51cVadX8YVOzmtfhz1oHy4Yo0Oz9i2XnhBCXKTwMWPgm46jaYAVNqa+GA5hvUMfEWHIrFrMZoQzbkOnG+4Fk3DnwOq12TaKRGZcr86PCsKJtm2JaxAXV3HTU9LCUFrf0JVvhCWxGxivU5jHAJObW5DqAKuQNSzxjJQPOL0oSa9iKyYVoKjc6e0HJQ+GjR0hDRe7LyZ5E5EZBmjXvJX5bAK9/1fuTT+Hzok2IVHhJRJJQ1DiJENCiNKt8cDERf7ECv1L7o0rHujX0D5zIYrgXtxjlveden92OugdAirWlZE71LFKUsoIIvMPi6DczXBaeRh+ZQ7lYjN+tv+ddph43qopYEt11ZXdAZMcGJCGVKsfCn1Z61JM2cyiob6QVuQ1yugb+SxBkvynPGV0nozwdvBfV5sayfipx3xxPASQh/uTXUnOeoq4DYgfGqW+WDiIuNnOHVy++wOACdhAhu5pPUdlw4/HjB8SK1y8y4HO1+btd7fMJqZBIYO
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4952.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(376002)(396003)(39850400004)(136003)(451199021)(38100700002)(38350700002)(36756003)(86362001)(6916009)(6506007)(41300700001)(316002)(186003)(5660300002)(8936002)(8676002)(7416002)(54906003)(6512007)(26005)(1076003)(2616005)(2906002)(66556008)(66476007)(66946007)(6666004)(6486002)(478600001)(4326008)(83380400001)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?NFAO5YhJY0snr2EWOsVqviH3AEVhC5uhMzSlQD10P1WfdJWd5sRoLgBKkNAr?=
 =?us-ascii?Q?WcT3TgLRRnsjjUXKQh61DR4FoFISdvjdLkxENSe0v8GOdd8+8sozRUcQ22vA?=
 =?us-ascii?Q?lNZEJm9v7YqyrITD/Zh6984FFkISnmOtYAwNFMmcgzM9gVLfOtIeWJdD/mOe?=
 =?us-ascii?Q?iY9cekINAOxAIlhJLyHyEEPFfk5qpyW5nc31lyI+aRajBPXlYWq6mNkODbq+?=
 =?us-ascii?Q?Ewv/T+5xMZqX7hCdFZ/UcYoo6dqIH0KxFAHFqyu+pnuR8uHc1XjGq7+CJVji?=
 =?us-ascii?Q?QRBou9ZpNEeJX0QM9mNCxQ9ympdQ+GNCNPkY4DT/slck5UGt/DXtg58N2+cE?=
 =?us-ascii?Q?mhAr1eEDdv4DQW8uGmtG9Gax/aNulDrMPRQpvxXZhMK3Lptoxhn2tUwd6aOv?=
 =?us-ascii?Q?nmiIqpFZSqpiecrt/701nR7BMqKwVPa69pqZyYZQsFH0yP1FnamUeL5uCJKz?=
 =?us-ascii?Q?IfO6XfOJjDRHU8pGzfcfxkEdTVII1v/myP+B4kkzI+1aYb622/wSKTHVtAgi?=
 =?us-ascii?Q?4YQlTbpcmoqE1dFQsEfGxvypCh+sE+Xan8RuESYjz7+Yni8ha33u2p1OuDvI?=
 =?us-ascii?Q?U6MqlyOfL6xDcmwdfPCuJFTL/XONKlktEtjPuF0XQZgJ0UaydcfH1McDy439?=
 =?us-ascii?Q?0lQ0WvfSPtDjP5xxXjt6dYdsrLaKhGqVAobImGkyW8Xyr26SuVY5yTJkniF4?=
 =?us-ascii?Q?+eeijTHPC0pcMkI8lMTCL4LF6SNhjTLOf97yWP9ZDeLCqWHclTiU7Md/RZQ4?=
 =?us-ascii?Q?QMZi1TG7Mj9sIE2JqgTT/3uD8vgxi6ge28YRcG06p6A6ob0CRSrjdk9y6moh?=
 =?us-ascii?Q?sT3I+DgMbqmLxk3IYhPxFIThX6NB8VkeUW4GAnVLELxAlYgKTjK4Irv6BJ6H?=
 =?us-ascii?Q?oAxsXo+CTsMbRANpfKcp6GyhlCfgnEawB1EWMcknaQwhQHeD905JF8C0SlfE?=
 =?us-ascii?Q?YfBFSUditaB1+DeEUVhQGLlqGQM/RqzV8tANvfHDOJM38VqAqGcSyeus3+0b?=
 =?us-ascii?Q?IeP3hfX7/hBhBJXmDY5AsbmjXzZUsorwV4iHO4mrlfcR+aE+RwuwcU65URM5?=
 =?us-ascii?Q?VITiTJeoGWDgKJ2QsJqUCZz9Go4Tlta/0yPsm2bStINxYJQibEotrrHd6nJJ?=
 =?us-ascii?Q?wP3vifxgVJ7/HxOsUQjIYWVb5sSVsYMv9fS0IeETPr+NK7/If6EL9G+k6Ja1?=
 =?us-ascii?Q?ahZUDR51xJ7fWIM+oGzuoEuYKo6kScv+tR3WMsSvH9bQ6Zv/K/sj+H/IhgcP?=
 =?us-ascii?Q?j5KkmD6zhGqs/3yX2YjxFONCeE+fjAttbCKrXYRPWgAnqtAxBWjuna5bNAwn?=
 =?us-ascii?Q?ehxepOrAbUkHqMsq+n4Ykn0rHCmARDFU3pVl8MqpDseEGkLIHy87k4/vZDdc?=
 =?us-ascii?Q?lgWQLjvfLvKvt0jh0Ixo4pZtmwzabmQiXiL7VxrCRrvOfw0fBvgZ5cjTQgRD?=
 =?us-ascii?Q?cbuc5JKeieIJUkgnuXg0+RSOpykLL4C8QU4InhJi4bcbmccwdEccFbHWXNc1?=
 =?us-ascii?Q?oHnjT6Qbve/UdMvf72jIslDjU6GcbuVqRd49B8HCs3CRck9+TBAsBX3bIBn4?=
 =?us-ascii?Q?tJ0YxZ1E+U10aejx6ZzITr3AcdPWQur7dOIqLhRgrBZ68uNd2YpWEaozV37x?=
 =?us-ascii?Q?mg=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1246dc6-0df5-4d9c-e08a-08db563fe90c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4952.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2023 19:01:09.9880
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8VrR8LcuguEy6t9D/4btcJNrhi5ieuv6Z0UnBzQtHaq/HM1fC+2dWLdS9cwHUFT2EMOkplnghD2V/gABnknOWioE40slyot/UxB6OcK0doA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6953
X-Proofpoint-GUID: uIVurne7AS-o7VNHC3IhIXeXIkvIfMYs
X-Proofpoint-ORIG-GUID: uIVurne7AS-o7VNHC3IhIXeXIkvIfMYs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-16_11,2023-05-16_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 phishscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501
 suspectscore=0 impostorscore=0 adultscore=0 mlxscore=0 clxscore=1015
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305160160
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Davide Caratti <dcaratti@redhat.com>

[ Upstream commit 78dcdffe0418ac8f3f057f26fe71ccf4d8ed851f ]

with commit e2ca070f89ec ("net: sched: protect against stack overflow in
TC act_mirred"), act_mirred protected itself against excessive stack growth
using per_cpu counter of nested calls to tcf_mirred_act(), and capping it
to MIRRED_RECURSION_LIMIT. However, such protection does not detect
recursion/loops in case the packet is enqueued to the backlog (for example,
when the mirred target device has RPS or skb timestamping enabled). Change
the wording from "recursion" to "nesting" to make it more clear to readers.

CC: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: ca22da2fbd69 ("act_mirred: use the backlog for nested calls to mirred ingress")
Signed-off-by: Dragos-Marian Panait <dragos.panait@windriver.com>
---
 net/sched/act_mirred.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index 53594b0466eb..01a44c3e8d6d 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -28,8 +28,8 @@
 static LIST_HEAD(mirred_list);
 static DEFINE_SPINLOCK(mirred_list_lock);
 
-#define MIRRED_RECURSION_LIMIT    4
-static DEFINE_PER_CPU(unsigned int, mirred_rec_level);
+#define MIRRED_NEST_LIMIT    4
+static DEFINE_PER_CPU(unsigned int, mirred_nest_level);
 
 static bool tcf_mirred_is_act_redirect(int action)
 {
@@ -225,7 +225,7 @@ static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
 	struct sk_buff *skb2 = skb;
 	bool m_mac_header_xmit;
 	struct net_device *dev;
-	unsigned int rec_level;
+	unsigned int nest_level;
 	int retval, err = 0;
 	bool use_reinsert;
 	bool want_ingress;
@@ -236,11 +236,11 @@ static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
 	int mac_len;
 	bool at_nh;
 
-	rec_level = __this_cpu_inc_return(mirred_rec_level);
-	if (unlikely(rec_level > MIRRED_RECURSION_LIMIT)) {
+	nest_level = __this_cpu_inc_return(mirred_nest_level);
+	if (unlikely(nest_level > MIRRED_NEST_LIMIT)) {
 		net_warn_ratelimited("Packet exceeded mirred recursion limit on dev %s\n",
 				     netdev_name(skb->dev));
-		__this_cpu_dec(mirred_rec_level);
+		__this_cpu_dec(mirred_nest_level);
 		return TC_ACT_SHOT;
 	}
 
@@ -310,7 +310,7 @@ static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
 			err = tcf_mirred_forward(res->ingress, skb);
 			if (err)
 				tcf_action_inc_overlimit_qstats(&m->common);
-			__this_cpu_dec(mirred_rec_level);
+			__this_cpu_dec(mirred_nest_level);
 			return TC_ACT_CONSUMED;
 		}
 	}
@@ -322,7 +322,7 @@ static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
 		if (tcf_mirred_is_act_redirect(m_eaction))
 			retval = TC_ACT_SHOT;
 	}
-	__this_cpu_dec(mirred_rec_level);
+	__this_cpu_dec(mirred_nest_level);
 
 	return retval;
 }
-- 
2.40.1


