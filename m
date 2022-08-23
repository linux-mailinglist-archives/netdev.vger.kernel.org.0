Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2449F59DF02
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 14:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354019AbiHWKTj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 06:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353077AbiHWKRh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 06:17:37 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2101.outbound.protection.outlook.com [40.107.244.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F3368053E
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 02:01:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KI+x/hQkvT7avadhF+2MW+TiUb4FTyF9F3VKg/4oQzvsB1dBvf272Zxo/1rJy/71EMaGWBkVsm34/o9HWw5vfW3obt5KfnMKTLsO/GQ4Xr+mQl5S91qeJTHGP/1u8VwwUlU8bmf4pTYhDmgE1DbqSmlq4aeTYD5402AHFWpxnido8VPOWSKs90VONopvAjGwvBYXMqlNvPkXIWgfzT/LFh8KyBW24il7UQNZQQIpWl3X9u3HQ/54QJ5nMgU9kZvr2K6FigWacxCm19Iqyz+qvq0NE+ljUI/Y/NXlDKQAvYkf3NSRCIjlDkKNFr72BZZI/A7jF/oWJk8jR/6Q8frsiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aU9+YOSNeKiT/kQBuU4012InrinoPF6NgSI0uf8XvR8=;
 b=BUKjmki/PBtglj1xAvdVfWkoNJFQjku4FbTzyr01m1CIcVMxkxLx6XTW67i6wPkcS1NADUVJdqNAi265yoB0gBOj2/Swfk6KdJW3lUD1caIQJC+Axv4pFL3Pt617kEshXoyCSgQxwZpXdEWQEcOuYwsluSykGCy5NwtdxUfv00aN08gil2awBi1Rzs2t1EIhIxYOU1pb6EOM+Fs6Mjg/0FN047v8DvGvbUT2/JDD3djJon7KCdoluE2+xWUt4TkgZRIipjjz4mQGS/5UMDitnEQYUBPPV+TAewK7jlg8aPkgBfAovWSGOjsMMspScPiXHzcPX9dwLG/+x8mzCdDsxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aU9+YOSNeKiT/kQBuU4012InrinoPF6NgSI0uf8XvR8=;
 b=nVPoYERzBBVou77htW8LcCVsk7vHYnQuZdQrvqco5BYQ0ghWGqrrEKxwQuL6amirjp1QbKEBEqThLlTlZP6iH7V0DSBpQ6vNqXhiYOamljVwzUJi83A4RHoeEDKTtlRrChIXeuds1c1ooEH9iG+Jf3DaPZzuWrKtG517ot0KuBI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3320.namprd13.prod.outlook.com (2603:10b6:610:23::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.14; Tue, 23 Aug
 2022 09:01:37 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a1e6:3e37:b3f3:7576]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a1e6:3e37:b3f3:7576%8]) with mapi id 15.20.5566.014; Tue, 23 Aug 2022
 09:01:37 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Wenjuan Geng <wenjuan.geng@corigine.com>
Subject: [PATCH net-next] nfp: flower: support case of match on ct_state(0/0x3f)
Date:   Tue, 23 Aug 2022 11:01:22 +0200
Message-Id: <20220823090122.403631-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P190CA0036.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d1::7) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 986216fd-1e5d-4a48-7b94-08da84e61634
X-MS-TrafficTypeDiagnostic: CH2PR13MB3320:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FpQyS6AfWJgMLaInMt6A8K3pSGWYYlHcmZzc9EYSaCiFU5wDcR7SLXbCk4gxoJqvTbXO412t2/MsbHW+MH2O+rWyyyMCU0s4JLdssRQEGgHAMqpZ+ZcPmk03vQxecS90oGmxr9GfSdM2xC0QLg8c57HHWOPlTIivfv4tOKC1rG/jWDksPUvyZiki6lB/Yw3ZgGU6z8Rx00ew5iX07YImj2XEZWvoDOlxTJcNSju2j/nMLRp93GZXQan/8vY0FpVE6zDhXKv1KiFoW4N2QINZb2GZvQjL08+NeMh7XmYXXcbDbOJBhFy0UaLAIx7V/nRxIXpSjaoQSKQy9NKp1HPt51JvL+LrczpZoFBFkxN/LfllU/CYMFf0k/OsJjjpFDQ2ra9Upl1ymI8ewHf0msyyv7ybfaDbyd8jRW46Jrz+mt4j4oglwbeLlIy1eyKvNksJhn1t6q62VJvMPNt6/R1NYV7dpthK21/niWvHdBxn0JYh174IYfRdxj4XrI41ZD41ibqtGXnkPPn3n8yCLqzyYEAY8r5FJ5LwYIWnObi8LSQqNQWr8yxX3x1bI78KncscbVoHJA45a5aQlrEan0znztKbZbBRSN9WAy4aEsnGU1yeSVr51YstLnKJWP/PrAll8+pHGXRPu6Sie4imAz4KXDEVgSfqnDkF8uW5j7GTSqx0Zl5xYO0RR3VK8DILj5pwPVvHHTVBi7Br7G1fv9pBnA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(366004)(136003)(39830400003)(396003)(376002)(83380400001)(86362001)(38100700002)(66946007)(4326008)(6486002)(66556008)(66476007)(478600001)(8676002)(8936002)(5660300002)(316002)(110136005)(186003)(107886003)(1076003)(52116002)(6506007)(6666004)(6512007)(44832011)(41300700001)(2616005)(2906002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?b4wSWMCy/IfQZfvJFHJ06jfGx4SR2DRogyFPizzeW4z29d5udQseAbTab+YE?=
 =?us-ascii?Q?CJsP1ly2Y+tbcfTwYMV49Ljfzp63DJ8l+XJb+k1R6W7ZNVhKyyq+cXmK1Xfe?=
 =?us-ascii?Q?uD5m3d+kHR/0OeazjesI3ogUo/+ZWOHk8wTNKgzkQnOCxRUOMFrMRi5v22x4?=
 =?us-ascii?Q?0Ptm4iq57JfM8qCOn5gZb/v90tZFZSid/H/d3VvhIQcsH3V+JQQFO9P4vTvf?=
 =?us-ascii?Q?GLpfIK6cBkQ3YJ6RD6F0ZxhuCFalJOXbsK1wnfzBMJJbihnhvttKVNPuXSrg?=
 =?us-ascii?Q?ZgetT31q6DC970th+27JfAu5Z2vPRnpZku6mS4LKjW21vGQM74W56eOw9bNz?=
 =?us-ascii?Q?S9fYmzGyGic0Jn3kazjx+vzjqv51zY0r9qA96NRQ5KWHFNC4Pj9hATlvi9q4?=
 =?us-ascii?Q?xGYn4bx8Y9YjUk/z3wysv/bkEgFsddPMcS45lYkkHecLdAep+WZFnyJh45Go?=
 =?us-ascii?Q?vMHa6CqhIoKad4sZwAORe3zh+N99HEolhcDvgg9OjaHj8oIh68PN4bXlaSwW?=
 =?us-ascii?Q?dAb+pJMG8PksBXTkdB72rYQlfO71c5DxqTICf3qOD6caeT393q349VV2rWQz?=
 =?us-ascii?Q?/I45XJx7OQXoQN4NKTnaI4QSa/rGTSFWHF47K8RFs7locqbNwUHR3RaW18nx?=
 =?us-ascii?Q?U88SPoILXVvt1Bn/40wtf+kFzPzc2iCpHkglginPgdiUvP/4bF5+l2PnUa/5?=
 =?us-ascii?Q?oRIY0JLQ1TM0s0jgAmZDfIfMtzncFS1wBsIHThfEWXI/5FIhQ8mTMqo8389r?=
 =?us-ascii?Q?sda6+1DcmSHirpuVaEXXmFh+n4ReRjCvmKA/p+IwLBTFoMKW5v9dyjlWMg9n?=
 =?us-ascii?Q?ykr2ma/Nw4BDLLv3jYBqsUePo+UuhMx2hqVw9XiaSC9R3/902zD3SpoBUJ1y?=
 =?us-ascii?Q?j9nDLC0BPSj7Kqvd+Jw36veqWAU7mg6VZJ+b4viN5cHWEgGrEp5qT04w9jjN?=
 =?us-ascii?Q?UdpSSvWXHN9IiE8KeG3g//QuyL7qiLud8jH58/z/my57RVauBFeHSjNILETD?=
 =?us-ascii?Q?E/SpP7/W109XzFupsk/rvP81WdBe0pL1wD4ETzFrQv/vPQNzrr0q/NzWWLBQ?=
 =?us-ascii?Q?AQHiQWlW629AHm40LHigFHJxp2iiYSqfrmc72anSNwAiqyJe+sDEhIblDVFL?=
 =?us-ascii?Q?l8LVfkhntMBSBcIz2ldwItJ2bX3FeQmUbdgA7OSF4DdH4ySckakG7YemggOp?=
 =?us-ascii?Q?HglLCSAbvKHd4XC3noH5/x8qL3MiBWweyKlAyt/NK0xk9S+KW7TrLHxmIHaV?=
 =?us-ascii?Q?sat5dNTEvok7ozAoCW6age6Od2gag26y1ra4REyN/8c8JAYrYI61BpEzolfm?=
 =?us-ascii?Q?Hqtl67o7Ubv7rl1FZRlqcqBSg25oKvH3woT+MQXkjafg6g3r8MdmrRLCtf8E?=
 =?us-ascii?Q?mB7dP2+8TI2jrwywKWB8dMZg4uxrNPQDY0WMMFqzmU+xeBswKn9whvddFd6+?=
 =?us-ascii?Q?ru4zLnpQvX3iKt5TOO/KNiTd8neYgsFub/fgFSdxw42Wm8w21wFzDSMD8jgs?=
 =?us-ascii?Q?Py3sVR88e0RItptoTG3zxoxy2dMeuMQwncMWRkkvQnCZjcfvzyymN+ac09Qr?=
 =?us-ascii?Q?pm5CyB4AmWB/9piQBeEWHHwWQ2SzYlJy3FG1h7zza+uqtXNGj8L7j+5XD/+H?=
 =?us-ascii?Q?+gvsHPjWPUk+0XgVOZUVomzuPWiZYcwH5L0uka5/7GXxZSQSjwk33/vxTHg7?=
 =?us-ascii?Q?GAbSKg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 986216fd-1e5d-4a48-7b94-08da84e61634
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2022 09:01:37.7614
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FxHZgCA1SaVd0EYczRNapvcKjrTzftFWrP9Ii2bOfWRKuXfbTc3k6TdzTZDXpGzoR+P+S6hRF1aHpimEEOhbHlq+wciDA2qQXbYM8OCxXl0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3320
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wenjuan Geng <wenjuan.geng@corigine.com>

is_post_ct_flow() function will process only ct_state ESTABLISHED,
then offload_pre_check() function will check FLOW_DISSECTOR_KEY_CT flag.
When config tc filter match ct_state(0/0x3f), dissector->used_keys
with FLOW_DISSECTOR_KEY_CT bit, function offload_pre_check() will
return false, so not offload. This is a special case that can be handled
safely.

Therefore, modify to let initial packet which won't go through conntrack
can be offloaded, as long as the cared ct fields are all zero.

Signed-off-by: Wenjuan Geng <wenjuan.geng@corigine.com>
Reviewed-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/flower/offload.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index 83c97154c0c7..3ab3e4536b99 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -1301,9 +1301,14 @@ static bool offload_pre_check(struct flow_cls_offload *flow)
 {
 	struct flow_rule *rule = flow_cls_offload_flow_rule(flow);
 	struct flow_dissector *dissector = rule->match.dissector;
+	struct flow_match_ct ct;
 
-	if (dissector->used_keys & BIT(FLOW_DISSECTOR_KEY_CT))
-		return false;
+	if (dissector->used_keys & BIT(FLOW_DISSECTOR_KEY_CT)) {
+		flow_rule_match_ct(rule, &ct);
+		/* Allow special case where CT match is all 0 */
+		if (memchr_inv(ct.key, 0, sizeof(*ct.key)))
+			return false;
+	}
 
 	if (flow->common.chain_index)
 		return false;
-- 
2.30.2

