Return-Path: <netdev+bounces-3090-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C1E6705694
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 21:02:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C1F9E28125D
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 19:02:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 360FA290FB;
	Tue, 16 May 2023 19:01:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D1B1156D0
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 19:01:48 +0000 (UTC)
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4BD693D3;
	Tue, 16 May 2023 12:01:25 -0700 (PDT)
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34GGwhdf002484;
	Tue, 16 May 2023 19:01:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=WZL/ou/LOAXUUccfJHPYzKi7eWaL4kn0J4xC9jfD3G4=;
 b=FFvjlMfVMYceoXB/8/OyMJMajqDmueUxgHXSB4AtjeZlRtFi8rJnqsHQi+HyMRQgc6pJ
 /TEAhbDXIUfyRP23sa2VCLHJBU0UpZCJEBnqQYK/FWLtajWB/Miqvkp+j8plmPrKtmag
 gnrM3AFntdq0IXCZYRjTYgJmjPqYFWsSRQuAYxFs/M9FBA3ehY1/v8ONnqwPUJSRd6md
 4sk4oXLRphY9dZriw/WNahF1w7EnPkAP+jeW+1BxGFPdSnGQ+UJLXW5nmHPdcd5IS/eh
 woqdv22BvQ/rFXokgIGvPa1be0NC6KejnpSFz9BDd7zCb9zH52njqpRK5ieBJqcGKKrW qQ== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3qj1h8u5kn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 May 2023 19:01:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TDZxWtnj+lsV01ljaUCiVPDIaJ+klYKPt5jQ2MybSWHRz9/swQwLfbr/C2qS01TC58m+RF06GwUPXiMbst5AZHizVTFsIs2c2q/rZPrYzomftCrxFO+Ua0vjb+ofbde5tKz2eQRBK9XS8XSBWDoYB3YtBiFGRPO7QyQm2hSI1Bd8e4PEs2+EUdv4aHpN2tnttqAlNLOBus8Sy7JnO5SBlH9mZeYVhN78u+/1YGSH8wMTcB2mmFez4OLf1shVl64SSw7Hb/FBGWUET8OlqjEdurqworkjXJAf5YjkZclFBL3rmkTqAX1XpOtPpSsadB7Q57omLmlTlZcqJ9v/xrneuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WZL/ou/LOAXUUccfJHPYzKi7eWaL4kn0J4xC9jfD3G4=;
 b=hGuyjncH2kZttHEMzPKzpdDIucZ0hmDt9wj1K89U6SgQ8sRLE+f5b9r/+LPiv2/H6raxmuCAhODPTNkaZYaOIBuNXNfX9zi7/tF3+zO/xWqhDEImdkH/07xL4b1Y7bslaxg9qZsvYhpXMD1+5CL8TjI8P2yh8JpS0BFTjsCBqeMfPlcwMPc2uP+oVS9pCNB+9OjoybRX3qcPWmmU+mZEFHBboN9nU9SXmcJENpD5Xivg4gaDXbyd2IP7VgrkZz9DQkS4ctD24hsyx7euc63Gvz4CFB9lCeIjk7W5vHOXGQEh40CbtA/oHqA5lHEQtjVh2N1I54pgKbnp9e3q/TeN/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from PH0PR11MB4952.namprd11.prod.outlook.com (2603:10b6:510:40::15)
 by PH7PR11MB6953.namprd11.prod.outlook.com (2603:10b6:510:204::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.33; Tue, 16 May
 2023 19:01:14 +0000
Received: from PH0PR11MB4952.namprd11.prod.outlook.com
 ([fe80::5693:5120:1f58:9efa]) by PH0PR11MB4952.namprd11.prod.outlook.com
 ([fe80::5693:5120:1f58:9efa%3]) with mapi id 15.20.6387.033; Tue, 16 May 2023
 19:01:14 +0000
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
Subject: [PATCH 5.10 3/3] act_mirred: use the backlog for nested calls to mirred ingress
Date: Tue, 16 May 2023 22:00:40 +0300
Message-Id: <20230516190040.636627-4-dragos.panait@windriver.com>
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
X-MS-Office365-Filtering-Correlation-Id: 3e9dfe0e-0999-4317-1944-08db563feb8e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	IH6WJnYIHX358QEM5uE2KZ5MwKXm/VmtSpYSk9q5IzZDRJUeP6JShtwPuKN2WbjqQ9R/L2WnFUVZETQqnkDA3Mtgvf55HDkdO7O019/BuJ3oL90HVIxjGAyiEo/MrefKItUsxdJV420fep9eL0/LzrQoa/dFGUnl/fdYZYLDS8KAsyGvc4TNBCJeNejIoM0gbEKKRU77FpzC42MieNgqcU33Pi0f3R/hkbETle0yD1P/CjAS1r5TB26zFarM+M2jANseOZPQB9VNzlax11zznkW0khwq+h3szyKt9ao5ZjXY2tH/KSu8DLInx6R4grhKHFYPIhogzHTAihjzfXmbMoNeSgdofydg8S0Lnd5Uyf28oLpSth+lRQcAcnpVkoWPCWzPwLaagre9CMc1nnR35bxVAHpF1UhWPUQK3FNunNOLHOhLDGgnUwMuKbXpbjPB6i/weN2I9Y4vLxODPYD6HvR9ufwB+SapJgqqDF5o6jLb/wV7wNW2FzTH4cMoZbB/lnReIuaMd3R4Q/41kLkFXukjy9J1SjvH6Y5jPiax99aJ9Tkl6OoiVt9If2jBizXmGIv2MabFmT5wm6JJRmOEVVEm6+xPVwqUXuz65XUY7G3+kAV7qFNwtoEH4dKObVHgN1WkYukE9yjeEggvYmaMn+QqKqavZ+x45+GSC+xTedA=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4952.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(376002)(396003)(39850400004)(136003)(451199021)(38100700002)(38350700002)(36756003)(86362001)(6916009)(6506007)(41300700001)(316002)(186003)(5660300002)(8936002)(8676002)(7416002)(54906003)(6512007)(26005)(1076003)(2616005)(2906002)(66556008)(66476007)(66946007)(966005)(6666004)(6486002)(478600001)(4326008)(83380400001)(52116002)(473944003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?h9l1RjfzR4POESig/whop90aH3pM04+0WmQIXutYmwBuVf94Kf+HXTzhIm/t?=
 =?us-ascii?Q?YW8X11xHWF2u8flmpDVzPus5sva8RkWVOHdYncksAv+lkf0VOhNl874fj367?=
 =?us-ascii?Q?PL9lhwzQxFYX4lsyjtK0UesT51/KTZCe13QBh0VVARLUOPZUxq/5Gmbq7jh9?=
 =?us-ascii?Q?sMUZ16KEsc2w+loSWBgB6PwLfxWGVOD8AAdbPpVnxJIGG876MXdnNkRsCTJz?=
 =?us-ascii?Q?daUDeleGU6b24eKCLePPHYYxZe1QMqCOL8mtOcPUaFhsrL82cydRZBYvFJue?=
 =?us-ascii?Q?lKQYVo9k0/vCtrBHkl9qab/8ZtwQXPTwqeFVe+k8goBMjIZUwioErO4mGgw1?=
 =?us-ascii?Q?D8mCpRm70SDyIJkqKu1a8MLe4R0+jC8RdUbkzkHgO0QtHi350bsrKqnIf7yJ?=
 =?us-ascii?Q?qlTcVw3MqsI8Dsq1XFQPbnCSmPR2m2ulF66CHaASrY9v8336tBqtSpR4BYK9?=
 =?us-ascii?Q?oH0mR6ggu9q9i5a93syrcYmKTb7mdP0c5IcfURQMu2Bc1+QXYO63yRKLpIFO?=
 =?us-ascii?Q?vB7T/F62mKeh/D2DmL4WO/L8y2D7443zgsVT7afOyaorMgWTa/1bwq3blVhl?=
 =?us-ascii?Q?jPSJbRmuWau6C/NJ3WapF/fMmYDLUE7K9LZS38UNLiG9XfqmXJqGqIspjGXk?=
 =?us-ascii?Q?wnQ283W57WeNJJAnWV8/FiQvysNv8avJk0yfLze0msJKrgb7yhKwmk2lsK5S?=
 =?us-ascii?Q?LKOO+F+GOGO6xYgOL2nCKR4/gkRxtrSm2YoFou6FfVy3ruPTXRmAiovbLEDE?=
 =?us-ascii?Q?8j/JqIINIt+4nYQWkKfSygU34LqoDuTtWwYJ5w+0Zy3TqoO12aa9osi1+zMX?=
 =?us-ascii?Q?qBumCLmU/kwXJool/krL1uQEWXsFmN6ifP2yaeY2LGM3QzKa4IlhdKzAKlxy?=
 =?us-ascii?Q?tKEIXzAHvoqRGrTqSf8G4nrmVyhlxvwZUwYYANYdnvRMzeJ6B2QVcU18lmdu?=
 =?us-ascii?Q?YsvA/VwCJN+18KnlLUsTPmq+Me6mLiS+m9IQxtHqtse//t8yOOC15GiF6NwG?=
 =?us-ascii?Q?isZYBU2cVRfCObQcdG7ECnbJk7Mo7ARS0sOqw5qiw/3BVBqLPgIcT203zFla?=
 =?us-ascii?Q?tANDNhwNFf68cRaxVCgm9O6NlxjeGLwoH+4AZO9YZ43o8+GcDT9gt8JaKixZ?=
 =?us-ascii?Q?ojhWH3e6zkuMW3nDExMzCeSyFi053WGPXG4SnUeBOHg2D+cdQhG6Vnp7PLN1?=
 =?us-ascii?Q?KcgQKKXmeIBexBEEAgolwdxIlJUXi/qutOd6bM2/wETCh581PAgd9i3DOiKK?=
 =?us-ascii?Q?oGaOeoKFJNGB29v/0Q8jr9GaBdU8r0BrKN/flOUbg7b2w1ujNcBAj45/aMYR?=
 =?us-ascii?Q?M1D2wXGAwaVKDFeWt2SeJZzoZ5Gf8u0e+4YJpL5pa4thdLWggbhnnRAGe4/U?=
 =?us-ascii?Q?ZHB6XvtlBnMaM6JrD0A8rY/hpVP47wfonM/CGW8SPqqMfWMqQ+lUybnVFuF9?=
 =?us-ascii?Q?9+2GeqzkPkZw7RKhNsxygzpAcl4rSJOji7wMWN7qknS4jgoukFehwzO4YNLJ?=
 =?us-ascii?Q?J95VAakVQ1KfmTgwGnWbNs6eVfJM/WSWT9fXUwGniJYAS2tn7NLRvDXWw2WH?=
 =?us-ascii?Q?8e/NFqPpMgYhWD99afyF+3gzaGC95hlJShgFiknxntvYxetREn6/YFXpjNBH?=
 =?us-ascii?Q?/w=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e9dfe0e-0999-4317-1944-08db563feb8e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4952.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2023 19:01:14.0112
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vx/dW//EU6FxjSt+51fIX3awAtju5A9Y9RlFxFhHRjavQSAbQ5IvG2jsOAh60RcNw1cuNyOS35oSvL4lZBaSsvFSXSPjQxnvdHfSl17Oy5E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6953
X-Proofpoint-GUID: nOqUMIGnfpv4hKEiiNuZkmkhnWdHx1oz
X-Proofpoint-ORIG-GUID: nOqUMIGnfpv4hKEiiNuZkmkhnWdHx1oz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-16_10,2023-05-16_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 mlxscore=0 adultscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0
 spamscore=0 priorityscore=1501 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305160159
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Davide Caratti <dcaratti@redhat.com>

[ Upstream commit ca22da2fbd693b54dc8e3b7b54ccc9f7e9ba3640 ]

William reports kernel soft-lockups on some OVS topologies when TC mirred
egress->ingress action is hit by local TCP traffic [1].
The same can also be reproduced with SCTP (thanks Xin for verifying), when
client and server reach themselves through mirred egress to ingress, and
one of the two peers sends a "heartbeat" packet (from within a timer).

Enqueueing to backlog proved to fix this soft lockup; however, as Cong
noticed [2], we should preserve - when possible - the current mirred
behavior that counts as "overlimits" any eventual packet drop subsequent to
the mirred forwarding action [3]. A compromise solution might use the
backlog only when tcf_mirred_act() has a nest level greater than one:
change tcf_mirred_forward() accordingly.

Also, add a kselftest that can reproduce the lockup and verifies TC mirred
ability to account for further packet drops after TC mirred egress->ingress
(when the nest level is 1).

 [1] https://lore.kernel.org/netdev/33dc43f587ec1388ba456b4915c75f02a8aae226.1663945716.git.dcaratti@redhat.com/
 [2] https://lore.kernel.org/netdev/Y0w%2FWWY60gqrtGLp@pop-os.localdomain/
 [3] such behavior is not guaranteed: for example, if RPS or skb RX
     timestamping is enabled on the mirred target device, the kernel
     can defer receiving the skb and return NET_RX_SUCCESS inside
     tcf_mirred_forward().

Reported-by: William Zhao <wizhao@redhat.com>
CC: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[DP: adjusted context for linux-5.10.y]
Signed-off-by: Dragos-Marian Panait <dragos.panait@windriver.com>
---
 net/sched/act_mirred.c                        |  7 +++
 .../selftests/net/forwarding/tc_actions.sh    | 48 ++++++++++++++++++-
 2 files changed, 54 insertions(+), 1 deletion(-)

diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index 01a44c3e8d6d..296af520817d 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -206,12 +206,19 @@ static int tcf_mirred_init(struct net *net, struct nlattr *nla,
 	return err;
 }
 
+static bool is_mirred_nested(void)
+{
+	return unlikely(__this_cpu_read(mirred_nest_level) > 1);
+}
+
 static int tcf_mirred_forward(bool want_ingress, struct sk_buff *skb)
 {
 	int err;
 
 	if (!want_ingress)
 		err = dev_queue_xmit(skb);
+	else if (is_mirred_nested())
+		err = netif_rx(skb);
 	else
 		err = netif_receive_skb(skb);
 
diff --git a/tools/testing/selftests/net/forwarding/tc_actions.sh b/tools/testing/selftests/net/forwarding/tc_actions.sh
index d9eca227136b..1e27031288c8 100755
--- a/tools/testing/selftests/net/forwarding/tc_actions.sh
+++ b/tools/testing/selftests/net/forwarding/tc_actions.sh
@@ -3,7 +3,7 @@
 
 ALL_TESTS="gact_drop_and_ok_test mirred_egress_redirect_test \
 	mirred_egress_mirror_test matchall_mirred_egress_mirror_test \
-	gact_trap_test"
+	gact_trap_test mirred_egress_to_ingress_tcp_test"
 NUM_NETIFS=4
 source tc_common.sh
 source lib.sh
@@ -153,6 +153,52 @@ gact_trap_test()
 	log_test "trap ($tcflags)"
 }
 
+mirred_egress_to_ingress_tcp_test()
+{
+	local tmpfile=$(mktemp) tmpfile1=$(mktemp)
+
+	RET=0
+	dd conv=sparse status=none if=/dev/zero bs=1M count=2 of=$tmpfile
+	tc filter add dev $h1 protocol ip pref 100 handle 100 egress flower \
+		$tcflags ip_proto tcp src_ip 192.0.2.1 dst_ip 192.0.2.2 \
+			action ct commit nat src addr 192.0.2.2 pipe \
+			action ct clear pipe \
+			action ct commit nat dst addr 192.0.2.1 pipe \
+			action ct clear pipe \
+			action skbedit ptype host pipe \
+			action mirred ingress redirect dev $h1
+	tc filter add dev $h1 protocol ip pref 101 handle 101 egress flower \
+		$tcflags ip_proto icmp \
+			action mirred ingress redirect dev $h1
+	tc filter add dev $h1 protocol ip pref 102 handle 102 ingress flower \
+		ip_proto icmp \
+			action drop
+
+	ip vrf exec v$h1 nc --recv-only -w10 -l -p 12345 -o $tmpfile1  &
+	local rpid=$!
+	ip vrf exec v$h1 nc -w1 --send-only 192.0.2.2 12345 <$tmpfile
+	wait -n $rpid
+	cmp -s $tmpfile $tmpfile1
+	check_err $? "server output check failed"
+
+	$MZ $h1 -c 10 -p 64 -a $h1mac -b $h1mac -A 192.0.2.1 -B 192.0.2.1 \
+		-t icmp "ping,id=42,seq=5" -q
+	tc_check_packets "dev $h1 egress" 101 10
+	check_err $? "didn't mirred redirect ICMP"
+	tc_check_packets "dev $h1 ingress" 102 10
+	check_err $? "didn't drop mirred ICMP"
+	local overlimits=$(tc_rule_stats_get ${h1} 101 egress .overlimits)
+	test ${overlimits} = 10
+	check_err $? "wrong overlimits, expected 10 got ${overlimits}"
+
+	tc filter del dev $h1 egress protocol ip pref 100 handle 100 flower
+	tc filter del dev $h1 egress protocol ip pref 101 handle 101 flower
+	tc filter del dev $h1 ingress protocol ip pref 102 handle 102 flower
+
+	rm -f $tmpfile $tmpfile1
+	log_test "mirred_egress_to_ingress_tcp ($tcflags)"
+}
+
 setup_prepare()
 {
 	h1=${NETIFS[p1]}
-- 
2.40.1


