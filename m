Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A14A6665F3F
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 16:37:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234794AbjAKPhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 10:37:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235083AbjAKPhA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 10:37:00 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2075.outbound.protection.outlook.com [40.107.8.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B9AE11463
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 07:36:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WvwkpgPOc8Zurxf/LLgp4wjDtg5tDlTW4ZRbzNSWFdEdVkLpZv0XBggj4qc2T+Ji47ts6o7EgNya9cSMd1FR0SSg1okpVkfUS8FJOs11p080VByiO/bH/8sN/d71MXxBgmllmAz6b5cn916bNq0KoZaPcC3m2HE6ZscbWTsRj7v7RYrobwmdbLHl7npQHTNR08wIT3ojhMtjWBVtindL45GCbrlgJAyPtNVvUolod5SbwETHPs3WUAefW+Dtn4ypSh1/Z2JwzqcRWvB9nh3Zo+if8cpr4gkDd6LRBm+fTl4KFdgNEN/1GqiEOWw80t0R46YB3Q77pRSW4LktlM2KDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/qK0kvOzNksaTKGTEZtNsZsGkl+VNqInlxDN265Pl4c=;
 b=Qx5Q+hVyh9fjMulV7JKnFw7lT99wHcyuiIAWBaEw1vjG3yTuUdGSuDGd0Quq4JZmCL6KrPgNAfAaSfYh1sq//+XtbiOTK1CoO7RgUAZOLiAQQvcEOrO9h4cgB+QZL0i1TfNxJgoh0bnOQ1cypwuX3gE1aLHHTx2y/QqSODJrx+SJqCyfS5Yn2UTPK7hFoVu6p/WjmE07y9B21DsIAV5seV0RkUvH6Kag9JRvLSGexSH+7thjsYD81gHdpxKPmFs4+IngB0sQZOtnC3HXFBUYFHNVSpuCPZQz1FMFbQaiuM228hOi7ndZXw0bL5/ta+CIiRV6twASK6INZkhaJt8/Dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/qK0kvOzNksaTKGTEZtNsZsGkl+VNqInlxDN265Pl4c=;
 b=VI2w1h47OVlMfusrXxQXSxmmzs6++KTF9xyE2ifj9OIF9co7FW0rdd3vSfOiiSQko9EUaCdRkVVG1m6+V1s2M9BxRgsFJ12yl/kC1RhqJQ9WjhbR4vYLKA6V7dt1UweXgMNXub/n1RxZOs4X90DQLXI8gphP1lMKTeFNeigaOkU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB7219.eurprd04.prod.outlook.com (2603:10a6:20b:1d3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Wed, 11 Jan
 2023 15:36:55 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.5986.018; Wed, 11 Jan 2023
 15:36:55 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Michal Kubecek <mkubecek@suse.cz>,
        Jakub Kicinski <kuba@kernel.org>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>
Subject: [PATCH ethtool 3/5] netlink: pass the source of statistics for pause stats
Date:   Wed, 11 Jan 2023 17:36:36 +0200
Message-Id: <20230111153638.1454687-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230111153638.1454687-1-vladimir.oltean@nxp.com>
References: <20230111153638.1454687-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0090.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:78::14) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM8PR04MB7219:EE_
X-MS-Office365-Filtering-Correlation-Id: 1404db16-939d-4010-947b-08daf3e9ab82
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rsiHPtZJeoAZbtZsnbMYlPQZz89UE9sgHSx77x2kRmm/Oh/HVIgrC4GZrWQCKfdlNQGWMIf25jqwCPAzO7BJTI7AcCaUzh+W8jIaGRIF0BlE/fOOInok+zrMiB9nQZdhrybCbAugPKSaD+UX7ejmo1GChZcupi3lcrl5Rl3iIdeJrMEbd10orOhSr6v+3xzah2FqmhcW37lKti9eDP7J7Gb4i5aS+Cwg1apZduaLAGfmWoAEshnpg/tVjjOKFqk9GUwje3v90S1XNCB47SVys4qKZnhA9vxrzLA7l354KL7u4x2uU9P8kttEqLPPvs3Yrli9e6S1kKy7IY9oTZFVtscsOYKFVXJmsuUjL76haYTjWX1iBpZXaXGJwtbEFJp4/oSY5pI1ZN/FsiCy08caIagxIP7t1AtJDg3VyXo7W4xTbVaY9ssnlmrYJFu9pr7bxvpEMN2h1icCkvubyymSQJKfczUPeywIRpgkOgscjr4UhvIDJ0FltdeTm8+Xk0oPByLPXWlyY9hJlWQGK1Vl//02Yuu4Eqt/JH/aA7DcrnWnn/syxzWKXfI09ty6GMfZBmZ31SWKaohtK0q4d9tozu0PMIIahx7nTXt3yHhetv/IzShShuN+b0P/enKOMfNh69kQZeQsVgrcbrigM5tbLsEk7XDIpgWIr+Ery7Jt3dPxoGYGF7WmieWXDas1KmcnlXSXY1gLaQceIG8slkhZWQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(366004)(136003)(39860400002)(396003)(451199015)(8936002)(2906002)(5660300002)(41300700001)(44832011)(52116002)(4326008)(316002)(66556008)(8676002)(6916009)(66476007)(66946007)(54906003)(26005)(6512007)(1076003)(38100700002)(2616005)(86362001)(38350700002)(186003)(83380400001)(36756003)(6506007)(6666004)(478600001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cvfHAfZHJdNOiG7oY7zjUgsWYGyGQhRVnuqkBl+aH3gPQuSJw4kk5uFNbrji?=
 =?us-ascii?Q?WHNtUU/e6MNLKa1pDIMjOWpmy8DYQqCB7TyYUCAAiMBS5UJcewG2S8FrktD3?=
 =?us-ascii?Q?orEd76IhMGjR3oUrxblWSxxKhd88gY+r3m7ZwvCAzdNysemvbkB50lfH68wg?=
 =?us-ascii?Q?3UOQheOz37gUXzzEYYtDANxIqUS5l84sW9C5Xh8J6B6OsRcoZQpb4NpDVdRW?=
 =?us-ascii?Q?u13jLbt1oEfSuVrTGxqf6jvkH4rAA08IqGcx3d3Ov51X0hI0ASEcoLE0ApaW?=
 =?us-ascii?Q?+vGGYYn4ssPTs3cLo5HvrEQ9p8LyfVqSHJfo3P77WFMgdgqfGi/lD5DT4v1J?=
 =?us-ascii?Q?bUMJ2+aCc5hRJjGNiW4NYSQMQFDSFtGHx8TrSG5m/fFkswmUkxDOU0jbixIF?=
 =?us-ascii?Q?SF8Lj9HuTXCATnzN269V0JsisY0ZfJyGzhyycRLTDKhoeW/1JMpR9VyOqPX1?=
 =?us-ascii?Q?hlG76NlzEbf9QiaaBmqU+nnTSj5TeGKgsM+AuYgvFig5ZcNKbIbw1gsXl/RG?=
 =?us-ascii?Q?jYc2MA6+gs7Xj/PTo/CaDSsnke2UYxIGVOIPcGjtpWiDSfeWxtsXIUUDPlY+?=
 =?us-ascii?Q?2yckOW3ws3GTKMfmNwCoVj4m55/OmLlo+MgRHTMaBFXS8S6OcWFDdOBRky4C?=
 =?us-ascii?Q?83C2ltlm1R5oy9QxSfI1NSmIpV5jSj5hRbLGOm039yfwyz895MT9xi72hQy2?=
 =?us-ascii?Q?eosJhVXEDKvUQGjMKuSOLzNiZGwemt6q3k39A2MSQT4JBWpzpEBVckobje6s?=
 =?us-ascii?Q?I9x9rKLSEoBy9OTSHfIUV0EsxxkasJt9brIJR6SbPrnYMccwdHYvUGhHqiio?=
 =?us-ascii?Q?ApACePrfZTocivM8a2oixw00T1bPWb9OCYxlyRv8cJUg0OTagsB7zg/SQqAL?=
 =?us-ascii?Q?FgsfBFoWD5PmiPoFLcmT0xWQPM7EW+NCGT+rs6zBxcTHj+NqEmdbtOEuzm21?=
 =?us-ascii?Q?rei5f4/WEHXCjHknL/VBvkbyDt8nGu/9vcotCbQMy+cBetTuZz8YFXjf7fCj?=
 =?us-ascii?Q?7aGiqxvgj8Eda2dxNRv/SM3cEZDi9wMXo7hmOoOhaEoxMhA9B1AWJPLvepwc?=
 =?us-ascii?Q?zhjIcQ8i3t5X5HxOXSLRaCxalhIzasX37LGZka8a2nWJRZSFg900XgBuODzx?=
 =?us-ascii?Q?Lp+LqV3ICNHO6Q9OwWNoXJfiZ0OfDTk+48RGZlnxo4K/xgOYFlA8HdtTUfOV?=
 =?us-ascii?Q?iUcZaqIs0Ge97hVrc39iQTmsq5HaKV8u8CGlpQ/5aem0/e4bwfoQhrfaSanI?=
 =?us-ascii?Q?UBZvXOnOejM4VA45F8IWUa+jWGj1TU1cYMe2CNJj2n3OMVWReOAOuxt8ouJI?=
 =?us-ascii?Q?+3I9I2fUAp4/HsYrOLYuiW+aCl9LL1+Rs+QNfyg8UcXXFrTeieKZ+BW7MY8g?=
 =?us-ascii?Q?uPO51ffq0rFJArV1Z5cTyEEtWNtVbyS3qrdKr8hVHdFNGrO1lydUQztuFh9b?=
 =?us-ascii?Q?CcouHkoFIAu4pTIvOjTTgBLwlJjVtQImDxmRXkUbsy2X1ygIflT+jaMZYJf7?=
 =?us-ascii?Q?C3feBLxdYwIy4Cn+5VWUHhqrm9mvvg05jUJWySAJwiK4bCo56QFytmfdV5WG?=
 =?us-ascii?Q?IAKtxn879lpCab02snrpITADMYw3wR06nUKvZwMAF63F/gQQnUwWvNnwVmQM?=
 =?us-ascii?Q?RQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1404db16-939d-4010-947b-08daf3e9ab82
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2023 15:36:55.8143
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0tVdd0IYKEYEKjmVHMoogzTCSJqbqJCU2mKZoR7p1XwuLCdMSCFoTL+uBoqXkynx5IblncFY/JGlM/HQyrUShA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7219
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support adding and parsing the ETHTOOL_A_PAUSE_STATS_SRC attribute from
the request header.

$ ethtool -I --show-pause eno2 --src aggregate
Pause parameters for eno2:
Autonegotiate:  on
RX:             off
TX:             off
RX negotiated: on
TX negotiated: on
Statistics:
  tx_pause_frames: 0
  rx_pause_frames: 0
$ ethtool -I --show-pause eno0 --src pmac
$ ethtool -I --show-pause eno0 --src emac

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 netlink/pause.c | 33 ++++++++++++++++++++++++++++-----
 1 file changed, 28 insertions(+), 5 deletions(-)

diff --git a/netlink/pause.c b/netlink/pause.c
index 867d0da71f72..b5e735f25acb 100644
--- a/netlink/pause.c
+++ b/netlink/pause.c
@@ -216,6 +216,24 @@ err_close_dev:
 	return err_ret;
 }
 
+static const struct lookup_entry_u32 stats_src_values[] = {
+	{ .arg = "aggregate",	.val = ETHTOOL_STATS_SRC_AGGREGATE },
+	{ .arg = "emac",	.val = ETHTOOL_STATS_SRC_EMAC },
+	{ .arg = "pmac",	.val = ETHTOOL_STATS_SRC_PMAC },
+	{}
+};
+
+static const struct param_parser gpause_params[] = {
+	{
+		.arg		= "--src",
+		.type		= ETHTOOL_A_PAUSE_STATS_SRC,
+		.handler	= nl_parse_lookup_u32,
+		.handler_data	= stats_src_values,
+		.min_argc	= 1,
+	},
+	{}
+};
+
 int nl_gpause(struct cmd_context *ctx)
 {
 	struct nl_context *nlctx = ctx->nlctx;
@@ -225,11 +243,6 @@ int nl_gpause(struct cmd_context *ctx)
 
 	if (netlink_cmd_check(ctx, ETHTOOL_MSG_PAUSE_GET, true))
 		return -EOPNOTSUPP;
-	if (ctx->argc > 0) {
-		fprintf(stderr, "ethtool: unexpected parameter '%s'\n",
-			*ctx->argp);
-		return 1;
-	}
 
 	flags = get_stats_flag(nlctx, ETHTOOL_MSG_PAUSE_GET,
 			       ETHTOOL_A_PAUSE_HEADER);
@@ -238,6 +251,16 @@ int nl_gpause(struct cmd_context *ctx)
 	if (ret < 0)
 		return ret;
 
+	nlctx->cmd = "-a";
+	nlctx->argp = ctx->argp;
+	nlctx->argc = ctx->argc;
+	nlctx->devname = ctx->devname;
+	nlsk = nlctx->ethnl_socket;
+
+	ret = nl_parser(nlctx, gpause_params, NULL, PARSER_GROUP_NONE, NULL);
+	if (ret < 0)
+		return 1;
+
 	new_json_obj(ctx->json);
 	ret = nlsock_send_get_request(nlsk, pause_reply_cb);
 	delete_json_obj();
-- 
2.34.1

