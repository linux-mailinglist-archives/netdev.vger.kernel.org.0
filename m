Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C973F69B864
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 07:54:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbjBRGyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Feb 2023 01:54:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjBRGyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Feb 2023 01:54:05 -0500
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01olkn2017.outbound.protection.outlook.com [40.92.99.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAC132595B;
        Fri, 17 Feb 2023 22:54:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YojDy5Vi6Nda4+mTX/wAnZyhUkaKI4teCZ8EJQc3DaxwGf1z6ImtSJ5dRLAlktltgkUsz6bjAqdZWMuFHI8JZY75NdZLxAUP6Wopiu44xx1jffIvnaTYTknICofPT6JxU1f5YkFUNs/ZgIMzpMBw1RVxT6njEj8VM4Frh1B7OC0aWb4Fb6SWo+cDhtK6kBJIEvkjFsVvrDHPE1R2nKGShX8vdEAbg4LpFRRw/1NQWqy7ZPMG+tzHJnSxGbnp9C+VEkYPQqLt/HSiVZvshl/YyU5y+qO8jEw2M0FQ60L/VhhleUqvu54D6hWofdBlHTn4tjnAaHzZrxL+LqAK79Y+8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qjCGJXd3+ouVUxyF2LRoijYo2GaRzTUwAm7PUzMjg48=;
 b=NeAnr1dstS3WsKfE+gzJEVc9QCVQCRgetzJsss9kDeYEwJPps8TJdU1wCMwEJ23LxbC5rL0ppDSo1Y7A2ex1OAgPYDuubwwnJ2fKUxLHCNWRD10J5o9tM43lSqBGB+M9k/bbwul41mq/lfG0Xu2pS8bYDsxRPSLobF9cwc6oypkRhH5+2igm07jVTZ6gUdAWFP6mcCe9kzRWNmvwVO24LDddZgkzJok8sm3YTAzoajej7PKPch9Xgadgek1o+rl+bZ/LSVrNaxHN+ssf04KkgpSGyN/9+uL+9C5GxvdmQznH0OAyq/SD1pQNXd2Q5OACuzaqcRNbP7YLtMBjAtek7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qjCGJXd3+ouVUxyF2LRoijYo2GaRzTUwAm7PUzMjg48=;
 b=Nt3QYYmRjIcTUJbCkD9fxDGYsVGX8c1z93aiV6V+T/bQzzVGjQXyKvi5cm2UTCwyguj2SMnxXTYrT3QkLayDUsgL8N1PuqRo+LhxmTAnU3d81dwJd0Qm+PMNu7hO0z9BG4YxNbPxRezasdvpsvpFg02TTP7t+R3BrdIaJbIyP1CtRWs6Kx+5fSaFfXv2/3mQ/75giKj/FhWQ+O9ZXzID26bwNJ69niK7GIVozWY+bpaP27FLbWUO88QncX5jnefBFWBJYR7wNDxg76zXg784WjmuwDIyov21ueNiIUg7VH3RnqWV1DQkN9M1bweK1Oo0aH0/kmfdpySisfhSi94iyA==
Received: from OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:19b::11)
 by OS3P286MB3209.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:20f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.18; Sat, 18 Feb
 2023 06:54:00 +0000
Received: from OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 ([fe80::9a1d:12f5:126c:9068]) by OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 ([fe80::9a1d:12f5:126c:9068%3]) with mapi id 15.20.6086.024; Sat, 18 Feb 2023
 06:54:00 +0000
From:   Eddy Tao <taoyuan_eddy@hotmail.com>
To:     netdev@vger.kernel.org
Cc:     Eddy Tao <taoyuan_eddy@hotmail.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, dev@openvswitch.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v1 1/1] net: openvswitch: ovs_packet_cmd_execute put sw_flow mainbody in stack
Date:   Sat, 18 Feb 2023 14:53:29 +0800
Message-ID: <OS3P286MB229509B8AD0264CC84F57845F5A69@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.27.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [m8K3aQrx7zPcq3XlYnxQD2T6DJThmlJI]
X-ClientProxiedBy: SG2PR01CA0128.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::32) To OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:604:19b::11)
X-Microsoft-Original-Message-ID: <20230218065330.229748-1-taoyuan_eddy@hotmail.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OS3P286MB2295:EE_|OS3P286MB3209:EE_
X-MS-Office365-Filtering-Correlation-Id: 220c73d9-53de-439f-067f-08db117cea00
X-MS-Exchange-SLBlob-MailProps: WE1/0xzO5cKe9cgmlwsG2XCcghGBxPuU2ZaPvCJZd98XbYc68p8YXz4vO0V4zxYc/AQNyx+geSp5/Nn+K6GG+m1ktmK7Q9VNYYsbqgB2uiWvbCqPs5KaDwTFWY76QsjL5jij2HGaPwAlyZW/de9G9KvOyB2tARr+x4Juut1S4fbMVN1MkbhaUUsmbmsxT9OJNc6YUBVxLyXujFqJf7nLhFMjgxORKmVEusnDOjTBgC1rkOLxPqz5kKAhRoXSXX61rLAosdvTB68oNFTonPja6/+tfQBl322ZXAWdUGCkWrPlWTxiCCYZGBDeWNAOqbEnbKZfmTW258G4Ke+tqejK/rO1fDCBYuGX4ttQHfGi3O0tojO4KupAqEkV114L82qmrUBGhQCjeYOll5au+Ob/A2y0YJdXVCxM37MSfdWlnTgQlpb+m7Q7cT/UHtlDuqvM9myCGHH0xMusma6UJf9jwMzgBNtgfN++HbprOwrW2IXCMnWXOBpCxOBukgshCFq1QwueSZGJi5zhWdIMibOt5ORMSaemfzj9HcJRlsVKw9PIJckcTdhfA3o5f6d0Gcf3qjdAEt5oIusqbLF7gGGRLE3cHDukwEohzR2cD0GONx/Jhzi/WlqNd9jK5+tyZxR1G86dMt3aVY6pTgi7dVq+3x0SLC0bJb94fKqmtRCmUMGQddmTKSsxxODHnmrbnOdyFUsZxGYVB276b9SVNzIVSitdlVTRjlN/DVkQr2Gf2fZEfW6BSfDLiw==
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 61Bfaqfa4sjOdpNbSRzGHIaUZq2NDDBtG6zhM8Rf2BqE7hS65ulTtuSowu2BUb7SkoS7npyibvewvEvyquviVvlqksIWlN6ewoJTCL5MaYgg0ctEjWp734T35rqBZVv8+tneVTOxj5sBBF85/Jp+RO4QSCaWQtN6qxtqnusPMxFl9Zlr8C9gC09ZKIc/7rZ5t0m0cY55EkMwgQuclEEsHszZT3c/3KzGbBd9omxAqJDGwktqhdF4Zx6y3juCWNNCem8lRhDH0WTBdPSOjXSoSkB2E0sZ8kSlUGXkVYNc9i9sZHfS3bNH/y/o9LX+kew3zHFoaLw15Y96fcQh3MjKPgSgqzrItKw6H6hMjbzQ+69aHyfBYSzVlIwL5XaDyVHuPaahYRBBVBHgzIHG7skmd/4Hfsz1QQHGKQkTZbv/g2Wem+OjEWeHpQRNvJjLq5JOkCsdR/UqUFURqG5iT2plFo6Cjv6VK9ShiX8VwYsIENiRHuQdTpJWos9gJoo5TBAX+cvBB6lJ9hNWOjSMdBGSKd6+uvYSe3aPbOQE7p1mcZkZGP1CflXYqgf3afqPinKSCUqvJWVnyFs9boFnZdosmBnd2ABrO9z2SiN2ysmNIlx2fIjyiKbMSP0ut56zzjeYIBKYbdXICClRtlQpl8ouyw==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yUiURsyHWjVfH1+fcSz294g+vJk6Jr2o46u2Gio16qWa/BeqyupF9XkegGnc?=
 =?us-ascii?Q?5NbP/QERLMxLrkLmdnc6kVpsQ/XTCc5zTCTWOFdZPOEW4g6EChzmiRibgXET?=
 =?us-ascii?Q?cHe6iY1aW848lbywf6pPAxN5jFf/9ACwOmAhQE0vqXy73JRNREXWypUfflNS?=
 =?us-ascii?Q?QiA2sgyZe2azk8koIzT3UJUNoF5Vkp3bnaKjyuPho02sC4QTboumq8rJbzSS?=
 =?us-ascii?Q?Xiu42hGZF2YHo0u7IoEE3MOHyquRl25tJvL/ehI77a0fK2Hcnm/SG5fS/cqD?=
 =?us-ascii?Q?+f7Sr1eZKeHF1tSVn/qW9L33a+Q+BPVIsoc4wTXWlmI/priHoUupFyR540Lm?=
 =?us-ascii?Q?qPPTyxjXNtvRdMKGVBMED0EYQtoCYRFfw9Za0WC7Qt/JRZvkcdk9X5hNGZ6E?=
 =?us-ascii?Q?PsNzgoBaifTPJZnj4fMjz8o1wMXJQFYjL1wGMt+I/HQqfthrBelsALboWtdx?=
 =?us-ascii?Q?QF+PrMbL9lpIKLpfpEqMW1IhbsklAywUj36Fhn+KlGea3jxE/YymBBBMpDae?=
 =?us-ascii?Q?43aI1h8xfFMGDFFlUi8YIKYXiQbCdngms7KsI6yBSUTs8IgtmEASqZlDYuUR?=
 =?us-ascii?Q?b4AOH8WiZ603fZAbopglRwT3a62yFhDVj9uQxTMwWdfahODMprrCfY4IkQ7M?=
 =?us-ascii?Q?zlBudu/t5V+9iVXfNNtaVwNRQyE8+1IZjXng8KTPb7oGh5L/ufJiJ9a6vv+d?=
 =?us-ascii?Q?msBfxsrfMeCRJY+XdmGSoPwC2+K52GxBTZ5+fucTrtSgwt7XMe5wj6zObcXi?=
 =?us-ascii?Q?RjONGVouBfbe0NLSvIuvkZRkAR724jzGwhzYqEH7A+TYprFldD3xWbvds3co?=
 =?us-ascii?Q?XrDbfeYNE+HKnnlqsikRUmXhHB3MxkSL2QMPLP7tYZ4MolkXAFtOSXwjAhDR?=
 =?us-ascii?Q?KfYeR6lVGFFxKhG2BRr93tRBnOTP2YOF88zZ1e13ajInEl+y6cHCETeCwnrR?=
 =?us-ascii?Q?aXZDJG7yz9VDv+XDPacerhvn9DicMORKQVxJmJJIpm+WCB/u2vVORf2VjS8M?=
 =?us-ascii?Q?q7sowRuIaCVBEuvhHpO6BdKPlFzk35uPYQyFA53TrTeBJ+iAddCLQRut1At0?=
 =?us-ascii?Q?bLy8T7vHsAEccKArEeK9wZpLrxPRCJi9Hm2BRc1/nfOhTFiIO+9dVxttS9/O?=
 =?us-ascii?Q?mw0nYCn0G1nUI8ziEr2wabZXC1jmLkI6Rk253+H2v4VHRA9xHgVapP11PvY7?=
 =?us-ascii?Q?G7q4q+C7pqYpMzwmjzr9TwqNHbROxoE0TM3gktQegIBqLTWaAmGajfkG45U/?=
 =?us-ascii?Q?/5/k8XU15O0e6T7RY84IESiqX8sHQDDg2ili48vrfA=3D=3D?=
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-05f45.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 220c73d9-53de-439f-067f-08db117cea00
X-MS-Exchange-CrossTenant-AuthSource: OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2023 06:54:00.6137
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3P286MB3209
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add 2 performance revisions for ovs_packet_cmd_execute

1.Stores mainbody of sw_flow(600+ bytes) in stack
  Benifit: avoid kmem cache alloc/free caused by ovs_flow_alloc/free

2.Define sw_flow_without_stats_init to initialize mainbody of
  struct sw_flow, which does not provides memory for sw_flow_stats.
  Reason: ovs_execute_actions does not touch sw_flow_stats.
  Benefit: less memzero, say each 'sw_flow_stats *' takes 4/8
  bytes, on systems with 20 to 128 logic cpus, this is a good deal.

Signed-off-by: Eddy Tao <taoyuan_eddy@hotmail.com>
---
 net/openvswitch/datapath.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index fcee6012293b..337947d34355 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -589,6 +589,12 @@ static int queue_userspace_packet(struct datapath *dp, struct sk_buff *skb,
 	return err;
 }
 
+static void sw_flow_without_stats_init(struct sw_flow *flow)
+{
+	memset(flow, 0, sizeof(*flow));
+	flow->stats_last_writer = -1;
+}
+
 static int ovs_packet_cmd_execute(struct sk_buff *skb, struct genl_info *info)
 {
 	struct ovs_header *ovs_header = info->userhdr;
@@ -596,7 +602,8 @@ static int ovs_packet_cmd_execute(struct sk_buff *skb, struct genl_info *info)
 	struct nlattr **a = info->attrs;
 	struct sw_flow_actions *acts;
 	struct sk_buff *packet;
-	struct sw_flow *flow;
+	struct sw_flow f;
+	struct sw_flow *flow = &f;
 	struct sw_flow_actions *sf_acts;
 	struct datapath *dp;
 	struct vport *input_vport;
@@ -636,20 +643,18 @@ static int ovs_packet_cmd_execute(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	/* Build an sw_flow for sending this packet. */
-	flow = ovs_flow_alloc();
-	err = PTR_ERR(flow);
-	if (IS_ERR(flow))
-		goto err_kfree_skb;
+	/* This flow has no sw_flow_stats */
+	sw_flow_without_stats_init(flow);
 
 	err = ovs_flow_key_extract_userspace(net, a[OVS_PACKET_ATTR_KEY],
 					     packet, &flow->key, log);
 	if (err)
-		goto err_flow_free;
+		goto err_kfree_skb;
 
 	err = ovs_nla_copy_actions(net, a[OVS_PACKET_ATTR_ACTIONS],
 				   &flow->key, &acts, log);
 	if (err)
-		goto err_flow_free;
+		goto err_kfree_skb;
 
 	rcu_assign_pointer(flow->sf_acts, acts);
 	packet->priority = flow->key.phy.priority;
@@ -677,13 +682,10 @@ static int ovs_packet_cmd_execute(struct sk_buff *skb, struct genl_info *info)
 	local_bh_enable();
 	rcu_read_unlock();
 
-	ovs_flow_free(flow, false);
 	return err;
 
 err_unlock:
 	rcu_read_unlock();
-err_flow_free:
-	ovs_flow_free(flow, false);
 err_kfree_skb:
 	kfree_skb(packet);
 err:
-- 
2.27.0

