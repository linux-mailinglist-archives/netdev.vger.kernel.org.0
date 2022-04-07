Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37FEA4F77B9
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 09:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241936AbiDGHjz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 03:39:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241943AbiDGHjx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 03:39:53 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2054.outbound.protection.outlook.com [40.107.101.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FE3DC53
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 00:37:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VAX3INCodU2gHhSY/B1GfrCp7vadaX3Gc6Tzk29Ss27tnwtTlbIde0JEjqBvAp7imYtjwknVU4qEeOs5ssEUVUZ/E8SV3k/l9bLhmBKRX0+K81M6vg6UR4BshxhiblSAPO7Jfx1yFrREkXteD8ch7/xFg7ExLOYbCKHQgR7KP/vhlPtO7F/HKK6hNePT7yeW6IA0YFZtqLS6trM95hsDNljgueZdeS6F2K8Dt0N6kQKfyGimi6JTB3C39iBqIosPY8kFuYyy+s7G1fK1TXiHkud+vD/J0NSkE/HrFBehtptQ56bxePO2k7R+bjcGMtuYmDnh75RhEMVgKHp5SgHTxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QlNYJFvb6XBmB166Ih+QgfI8zyj7dS/CPcKWL/35OGI=;
 b=CVq8uWhOlXIB/yPWVhGFkKH6t8eshhKjFvyOu5U7rccWC0ziH/OlT77PtVtmPWkFRk8zbWWzCTPnKVtxICWf9uANqlPztGDUNNT4SGmIy0UDLL1rUFebvbLEkQmIjSDsL0+Vh8FR5zXU1janDqtwpdgRzOEteTHqm2h7bJX516U1FNehGoNVgudbsgkvrnFaP0yd7K7IQucBIb9lE6ykcCEm6EdZPmx0o3cCoTHY4+xQuG5IQpEqW967OFy7AMhXm9wVwaBCk6FtiOaCxQ0MyGwzkC6S0Ntxuw6XyuqiyCqztKbNnElJMOmbsyzECe3+0DpEh/Ns5VL+rdGnZeuADQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QlNYJFvb6XBmB166Ih+QgfI8zyj7dS/CPcKWL/35OGI=;
 b=DKxumlfN4KI68Dml6WqIEiTWQmmGWl3VIqlfLfP5sm/V92mrQr3q+9SRy1Ogob+dBnliHLVxP4GHJ+LY/RbFNkZE5XAsNmRhK6KSv0wUGpiEG4k0KcQmv5OSPBlRASAQTKSK0WhZ5uLLCxQlCevVmwq7i7islqbs2zSfDHUyy/vaReDQ4+Ucy5U/1iZAbE8yrWt96Td5gB0TywqG0cvMY8/0++4+7E4T3d+0iPECTPR+xIMQ2RUD4VTJJWaxQfHkj2XO0dj36DSpsc0FwUeN96eMBJOi4TtoBgUwwnNmtHb4fTJgffrxW6fKZ8pc48DbrfUzi5CWdnwILkKUiAWf8A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by BN9PR12MB5228.namprd12.prod.outlook.com (2603:10b6:408:101::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Thu, 7 Apr
 2022 07:37:44 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::4c9:9b43:f068:7ee2]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::4c9:9b43:f068:7ee2%2]) with mapi id 15.20.5144.022; Thu, 7 Apr 2022
 07:37:44 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        petrm@nvidia.com, jianbol@nvidia.com, roid@nvidia.com,
        vladbu@nvidia.com, olteanv@gmail.com, simon.horman@corigine.com,
        baowen.zheng@corigine.com, marcelo.leitner@gmail.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 01/14] net/sched: matchall: Take verbose flag into account when logging error messages
Date:   Thu,  7 Apr 2022 10:35:20 +0300
Message-Id: <20220407073533.2422896-2-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220407073533.2422896-1-idosch@nvidia.com>
References: <20220407073533.2422896-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0225.eurprd08.prod.outlook.com
 (2603:10a6:802:15::34) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 24449de2-c78e-4612-8b34-08da186980ce
X-MS-TrafficTypeDiagnostic: BN9PR12MB5228:EE_
X-Microsoft-Antispam-PRVS: <BN9PR12MB5228E56FDCB13AA26E277643B2E69@BN9PR12MB5228.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LmrZfNUSTrnuaDnSOVoMTUS4wkIAsJc9WGuU7TkF1tZIatoO3AU4rp/r9cSajeMT9ED+fzAeyO9aW9vglr4XDAwpsQmTpYD3LvAODFdiYOED2OHpweuQOsuLejObzg9o+OWjPsGk8q/XIUkLl4itsu/rloMpsobqfItk9khB8+9Lxop3aepBthp79JFuwliftMnpocss7DkJNq5vXwj/35j2KIQDXDVoxeV1keIWqIEoHHBqaMPgstTACWyPqLdlvVlUP8asCmHJox8d1/WSHhjXBlTk9JdK23XoiTrL5yDpMIfy5X6jI9PlHYSSeirYIHAxoD7BSOQQNawhuUhhHUJSP53UcPO7d5BSX0rkOPuEyhs1uqA3h2oRIubErq7/Owvbo4JWCmQ/qvY/oMw/9V3QwhvPe/APj/b5zgYOwIrGcqy/zvJZaaty2QMZnfMpcj4h53YGZgRZQ4U+K2Fqnh3UQDtfJ5yz8aEtlmPWQXM0CCiDZJgio+jt6tLg2skjKNaNJwQ/bBEwanPoY327lUTbf4VM2jAzK9ko+K4JCzXYn0oHURu/rWrfYUIxatSdzFKDQI6qx7N0sqeG4wJBWgR9mk46HL18oOchugyA65Uug4bLrzn5oN0+87TptxYHu7pV5+abK29uCa2eDlHvBg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(7416002)(36756003)(6666004)(4326008)(8676002)(66476007)(66556008)(66946007)(6506007)(38100700002)(5660300002)(8936002)(316002)(2906002)(15650500001)(6916009)(1076003)(107886003)(26005)(186003)(83380400001)(2616005)(6512007)(508600001)(86362001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?07Qk6r1UOg7FRcD+UDx41yBap4fuP9Jp7ry/gl+QWpX4gTUBG25JVVCdhEDK?=
 =?us-ascii?Q?kh6/RtYmKGduemE5E3fHI5N9O6YSy9NFHeST2TIvXacoFz8pLlMSpFtixK/q?=
 =?us-ascii?Q?2R1u69NoCNx+fK7gKAp65H7xdgeKDwh87fUEeCXdY3VxxeGkJDY6kxkaJfxj?=
 =?us-ascii?Q?VB1Yb6E239FFVUIEhXZUb5HOiAJsyMv3emxJhjJIAo4Y61wDWfB0Vr4P9RAS?=
 =?us-ascii?Q?L9aZ2+F2AY6dSmGWbTQ5FqpiquZ1/dMaZjGufVmjgArdx5SFdQ7bHZl190yd?=
 =?us-ascii?Q?ZdZqfFFzPfWmq1plf8biJyH1+lRZfwonjeAl9ltjt/RXUejpSKOvkXBnKZOv?=
 =?us-ascii?Q?7Vtq1YEhm7CiN6B4pUT7UUvnNjMMTSXyS1I4L/NkWu7vLN3sprnrR40DYapd?=
 =?us-ascii?Q?x9jJSXJHd9pBthFO4fx40g6o66/1DXXdK3L6RzDjU5EYshDJoagkbUA7HBEK?=
 =?us-ascii?Q?5VisXCcf1nVLRLiY/7y3Iu3g9gEr/nYRkamJ2TViVwOZGB9JyK7JpHiWuS4I?=
 =?us-ascii?Q?jvQGFG7a+MJqDmAJ2VmcYzAJqUiVZINM7EmFLWxS25NhfsADQ3AzWi0GAc07?=
 =?us-ascii?Q?7HfeY75k3TF2jDoSQiJbEM2Lqzt4IraFIdUe5R72IoLcj6i8/OV63cENF1Sy?=
 =?us-ascii?Q?x/a17PxB7zWIwLuroUh3oSphWpzDT6OTfYtrb3Qi1sQfus+w6I0CR1a3whfX?=
 =?us-ascii?Q?n3YmoFiQjJoM3bldZ+kKdhlPvr2as3cee/uXx48JKn3gBEGfL8pZRk2O+Wf+?=
 =?us-ascii?Q?AhbQ8lA59Wg6/vfdIePdLJA7cX/CqdX17gTLxOakD5+HcLKVazG1sDylsji3?=
 =?us-ascii?Q?uwtenGR4pOWAv+AB8STxNBsGGn7l3zHMw44wLlCD+/3iS7aYEh2UBm/eemS4?=
 =?us-ascii?Q?htYFgnL3HXBvfqbhQRl5qReAkw1b0ahVqM0HubULMIeL5znn1btOV6CaN/eD?=
 =?us-ascii?Q?gqkVnF6Y1WfeszDkl553Iqb7cPbwGnQchHN2r/fgtAEMN2/gWl8KO89YUGkK?=
 =?us-ascii?Q?gMUz8d0RCWWsi0FrGNHIHZuSpWPMlsoZA9VCTDoshwtAzsauJYxWmabRR5tL?=
 =?us-ascii?Q?HZl2meupIQivlrPO3TnRujI8hHxSRdDahjmiWd5BH+A/dpFl8RPbcNV6wShj?=
 =?us-ascii?Q?ohOHQHOVahId520ppbJOPyd4nu5bD2XjjqR7KIWpWLFIzNw/eqQvqcsrcD3k?=
 =?us-ascii?Q?aCDI2kU3CaWlTewg7A7iWF0VDTEUEcIp9idDPgryMWsWdcfgm5sWuwg8LSZ+?=
 =?us-ascii?Q?Mzfqqj2nbnaB5al9kqrZpL8sAS8Jq9zalJCP9LYb3KMQI26/IhHweFTt3Wpw?=
 =?us-ascii?Q?ZGn+3dINeamBttN8jrn4yOcCsoO2verFCm9jDQtZ/V9iGkMX58TR4CpYV5QF?=
 =?us-ascii?Q?jHUcVurjLxMdelkqQyQlgDgjtUZwNY0QUPQvuX1/68p9FHXyagjpb7utzkWt?=
 =?us-ascii?Q?+Ju7EPvfpCCwhq4D6UYB0RLbiyBwTnyZDyhGHOwSzeydXT2iwhENJYr3bi0T?=
 =?us-ascii?Q?rRikICj9+D34QJmqhk34wcl3g5sNEb0/Z2ShzhQzHhTMpcIMospuo6bUQjlL?=
 =?us-ascii?Q?CIb6gW6np9FO1Tk/80WcHR334xaA15wIWNGGLF6SxnMq7gwdKfnnd0/+6IF+?=
 =?us-ascii?Q?WpbAMS1O9aJQTzVxiEqZeF6/lwnXQL9NQDBPK1t9dCHqQzWTRjqVguzhRXzj?=
 =?us-ascii?Q?0z+GBdi3lmwot2w9N2wHUEFvOmrticVcwkoaCNntIOehDbu4m2Um65sCtaZp?=
 =?us-ascii?Q?qw7lwSIEow=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24449de2-c78e-4612-8b34-08da186980ce
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 07:37:44.0029
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 599o0PydulJh+OEbKl7AFDBOoTVNKUTm+dzD+f/mS3HplM5/h69Mxvx+vKCTKRAvSnQ62ha+V3RvszrOUgjVVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5228
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The verbose flag was added in commit 81c7288b170a ("sched: cls: enable
verbose logging") to avoid suppressing logging of error messages that
occur "when the rule is not to be exclusively executed by the hardware".

However, such error messages are currently suppressed when setup of flow
action fails. Take the verbose flag into account to avoid suppressing
error messages. This is done by using the extack pointer initialized by
tc_cls_common_offload_init(), which performs the necessary checks.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 net/sched/cls_matchall.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/net/sched/cls_matchall.c b/net/sched/cls_matchall.c
index ca5670fd5228..37283b306924 100644
--- a/net/sched/cls_matchall.c
+++ b/net/sched/cls_matchall.c
@@ -101,12 +101,10 @@ static int mall_replace_hw_filter(struct tcf_proto *tp,
 	if (err) {
 		kfree(cls_mall.rule);
 		mall_destroy_hw_filter(tp, head, cookie, NULL);
-		if (skip_sw)
-			NL_SET_ERR_MSG_MOD(extack, "Failed to setup flow action");
-		else
-			err = 0;
+		NL_SET_ERR_MSG_MOD(cls_mall.common.extack,
+				   "Failed to setup flow action");
 
-		return err;
+		return skip_sw ? err : 0;
 	}
 
 	err = tc_setup_cb_add(block, tp, TC_SETUP_CLSMATCHALL, &cls_mall,
@@ -305,11 +303,10 @@ static int mall_reoffload(struct tcf_proto *tp, bool add, flow_setup_cb_t *cb,
 	err = tc_setup_offload_action(&cls_mall.rule->action, &head->exts);
 	if (err) {
 		kfree(cls_mall.rule);
-		if (add && tc_skip_sw(head->flags)) {
-			NL_SET_ERR_MSG_MOD(extack, "Failed to setup flow action");
-			return err;
-		}
-		return 0;
+		NL_SET_ERR_MSG_MOD(cls_mall.common.extack,
+				   "Failed to setup flow action");
+
+		return add && tc_skip_sw(head->flags) ? err : 0;
 	}
 
 	err = tc_setup_cb_reoffload(block, tp, add, cb, TC_SETUP_CLSMATCHALL,
-- 
2.33.1

