Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C10A8693DBA
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 06:08:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbjBMFIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 00:08:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjBMFIs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 00:08:48 -0500
Received: from BN6PR00CU002-vft-obe.outbound.protection.outlook.com (mail-eastus2azon11021022.outbound.protection.outlook.com [52.101.57.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C775DBE8;
        Sun, 12 Feb 2023 21:08:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z4+oUIXJOpXiCK9JwlMWK9EQkqcNe1+jLefQkWnCggmqs65mNGmdOX4fEM6OpBsu4TQUttQ+e1TYQDrvY87HCkQxF1vIatH9LHitJ5mSLgxSpZ684ByCqG3LFpV7yavOBpTga01OgDlWK3CQFakegT/7zL+21NS+13TjUoOiwRWZ5l48R8kg6N+hgrCswrevj2o3Y22PXjws+y+zw02t7YhhE+aNzA/cX1d+EuCkH/UpvA0RT/tjBSkVJb3tS7sAzgoYA2jj8oK4MHPyHTtbuA6vpEECcSh7X0cwjsKAgmH7x/wOd4GipX/koY/W9nRNVnn5LvbxtYLTu7sRxatxtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aXV23WKaTR5SPivWsX/fGaAxePQuax//CkkAs6WfjHo=;
 b=nRN0ZoAKBfBkwmHwlstSu5qN3ERThW2RhPqiphpsWXkUIaG09tMtH5q71CkePVOVDmVP3nKMEfW+AReOigwzVxku89R4yYq+6v5lVsXw7JJDZNB5swqeGTyCmgoQBWXV1qT1v+obz+G9CxgCaARfwDxi27T5UKXLErH0lOKt8vFLrs8XUpodOTVm34y1LoNBsfrnBH4Jty+ukAxe/ng5R4ZA1l5i57dYH48dMQWCo0fnlvHK5tkKCHDq4WW4NN9jTIUGvzZHuW2/Ohqcm9zfgcs/4oSEAIPzw49ReKceT+5MG10gMNC237AtKhnwum8UG02ChZKw4u4DuN5B5Az9BA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aXV23WKaTR5SPivWsX/fGaAxePQuax//CkkAs6WfjHo=;
 b=WTQ3o1gvyJyUU1AbZLAfkU6+jEkK2Q88gSN/XKpd6ZBEOve1GWQ6N3kFbBwXwbqRz/uHTSB6U9OQwgISNkCuf2MKt/MpNtRVxyuKYC8Yz17NFqYj+hlgdC1bjtQomLOgkzS4hTUp9keBgqxCLE9dn5QNQid/4pC6h4n3HRlwCC0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by BY5PR21MB1444.namprd21.prod.outlook.com (2603:10b6:a03:233::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.2; Mon, 13 Feb
 2023 05:08:42 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::caf1:81fb:4297:bf17]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::caf1:81fb:4297:bf17%4]) with mapi id 15.20.6134.002; Mon, 13 Feb 2023
 05:08:42 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     mikelley@microsoft.com
Subject: [PATCH net-next v3 1/1] hv_netvsc: Check status in SEND_RNDIS_PKT completion message
Date:   Sun, 12 Feb 2023 21:08:01 -0800
Message-Id: <1676264881-48928-1-git-send-email-mikelley@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0306.namprd03.prod.outlook.com
 (2603:10b6:303:dd::11) To DM6PR21MB1370.namprd21.prod.outlook.com
 (2603:10b6:5:16b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR21MB1370:EE_|BY5PR21MB1444:EE_
X-MS-Office365-Filtering-Correlation-Id: 38c56dd0-e665-4555-42a5-08db0d805fd0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j7kPwZ1fBOpwEbJUQWCh+5W8wzOy7E1bYmab2SZEEoUt+IyFRum6YX9dKBGn9CKTRoqUS+BPCA8HwEd4m1P4mmVnZKwAhwnIs/ihaPGaiPnuE7PuYlUjqzYKqB1FyLPrBHdAzCI1OVoK1Gn0aK0Rmoqlz1oMCA/hvS298zEXk7pl8erjZg4BfJf/cO+BsvOzHF8P08nXMMBN1LbjocEJe2+EFO8CVRXN1CHAJubrzcIuMNd7U29cWg+dTO79Zq3LlW4mP+UflG57YY7S8ePDDT0ui7Xg+FkwXtNDmhU9iU0cYvpnhZZZocSLDfZzn4FDLE61vMl+bp8GpcRnlQNTxY1Q25TRtao5lmifH30hoAK3OBznpCzMXzZKrRNFx9zKRuIP+gSNgnaSNwRcPrvXTe5mbZTddeEzwUrwi0vDyFlhv90451NIq5q7lxChMA3h89KXeHe4OLYB2ZZsEAKtNLKY8coxi2iHU/5Z4dRa8epBizFd4m/QQyKrI6nFeQFfxvyCWv5D1GeeEvqB2JETPt9x7BbSzAXWZO1gCm4D8+086vFcGIQNZsyBBnhSrE9g+0sog1lHiCaxazrZtPTfr1qEd8CgFIEPpfll5o2xp5fcHncdiaA5LIcdq3FiMtlS8OfrJ99W6w5i4orD8Cm9ZYOB4omB2UioogaQCb6UiIU4Y8+FROH5BgS9nCuQM8YqPUAGR9Op2uW4stbOCB6rjdjDDbVQ0M3AapP5qOAo4TdCypW7DUANnbs0oji10Zc8cf1r0icPxja36kg3PNIeew==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(366004)(39860400002)(376002)(396003)(346002)(451199018)(2616005)(86362001)(52116002)(83380400001)(2906002)(15650500001)(36756003)(6486002)(478600001)(107886003)(6506007)(6512007)(26005)(6666004)(186003)(10290500003)(38350700002)(921005)(82950400001)(38100700002)(82960400001)(41300700001)(66946007)(5660300002)(8936002)(8676002)(4326008)(66476007)(66556008)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hFmHVbqRcvDBwx2QRqKjWP6IyQD8+/84akvT3mWrm7f46AehO5UjJLF9gDXF?=
 =?us-ascii?Q?fSUnNwTaqHUaYMRJGGq1MdpoAfXMlrgnb8OBjopPZwVV36FYVp7BPE8M1PKX?=
 =?us-ascii?Q?TtzoHJVtZourlCAOT3AOwpz/mIomUkNF8oz93slvIhCSwPPac0tbxN272YXY?=
 =?us-ascii?Q?FRXuUtAmjJpokeOOWdcB7vP+GXFEfWFQVEhrcec5xL912DonqByhvUc+jRp7?=
 =?us-ascii?Q?lqyahLprOgWSNbLkJryWqkzsjf3l07iwt7gTGYNWEFi07ujAyMYQ5wzDSCEm?=
 =?us-ascii?Q?gKaxKMGDoRFOeLsuNFI2JccSe9EkxHsaneqTsRYBsENJKuUTnUMVVSpMML4/?=
 =?us-ascii?Q?fJnZRTs4DOWu7sVz5bRD7eSBgRjJXw0MPHQmRe3k/s9Yxuj7PMwSsSOl6mja?=
 =?us-ascii?Q?098fzP/rJnH7jJwHIaYAU9PSrOymSfRCKiGKSh5iyU6lkusAK1eeOGKzQNGs?=
 =?us-ascii?Q?XXzWcvZjSGc27vDrF5sXKq+HRPjuCvFrj3iZHD3fyaJsRR0z2xGaJicN6Bz9?=
 =?us-ascii?Q?GuimHBCmq4/H3dWSj0BJlQ+Dv8z6gLedT4mNAGHCjdeeTPK0xl5gbEVw2HGZ?=
 =?us-ascii?Q?kUPvRm+Naz8t3F61FvIoNQIjLT8B8F5VD7pjeMBkb1vvKvAmqm8ha5R218Aa?=
 =?us-ascii?Q?uRKD4gHDpjRTTXh/rNgt/HDN7r8Txpbut2d7617/9xGZRV5Q2MFP+CLfAQg3?=
 =?us-ascii?Q?GTYQmz5m6W07yZTnpoBrTNh+8VZHLfQXgLGjuevHTow3kjGbO0wWEFJaAEof?=
 =?us-ascii?Q?zs0oEaxm8p9SkQ8ANa1rgzcA5y1dBMtvIVGscQb/eOPK0PBgx1b68KwgDN1R?=
 =?us-ascii?Q?eYu66z+IvHnrtRorz+ZiJC5YkGZt16Enz1spYaCKG1HvrQsDjZ1C2tkv0adb?=
 =?us-ascii?Q?sBuHN0b8NNQUgcYtitp4iQQtIal5kzTUNFZh7HwLVt7+jqAaHEuxxdrieUfn?=
 =?us-ascii?Q?Axyj1LBC8Zf6k8ppby+/fSqbPoIOxlY3i0w7D7fHd/BkgYNhh8+okz44YBBV?=
 =?us-ascii?Q?JKSJQg6AG+XmZpNg4hMLeugpilhaI1gv+R15rREhabtdRW8J44Y8io1VyPsM?=
 =?us-ascii?Q?Nx5DzqjM32ULpyB8b0P0sIDKVCilRSYjdyIoqQ99tBtJPF+9BtegWi10CRQ+?=
 =?us-ascii?Q?Gt2TZdinrLhs6Kw1s+hfm1VMBcaU2t/07I+JPdUkUkemTnsFl0+FbMVohUGH?=
 =?us-ascii?Q?xBi9W98tJVBEGKVtiGp0coS7rcRtq5XJO8S+cOXpd7VCoHEbiPXi0mOegIYf?=
 =?us-ascii?Q?s7K6Te7FOdZRuXFE2jfg6MRzlIqzJkus0hHr9rm3/1Hel4xm7u5QS3iIFBX5?=
 =?us-ascii?Q?WIn0Msd+DSvkJuBAMGI5HchDGHeL3LhNHnbbjavSzyTfgHCXfl9k7Pn7psTI?=
 =?us-ascii?Q?/5vdZxjY8eatD2VzMgw2bbXA+XErqXG4od5enWEWbCwhsz7wcmrDvqXIpb0A?=
 =?us-ascii?Q?k7WBgxgHCd9EmmzkbkMoAbNqGCTgHwYx3wzwkUhtloPpClUFAi6pP8W5eCuF?=
 =?us-ascii?Q?N8LpAaZOPeiby4eCGNoaCq9OxK+UW/nZ7vMYPWQcstTOnhxK98iplIhiFsOM?=
 =?us-ascii?Q?YnzMuD6H52UC9+D8HHjvHSYziB9nSy4FCvGNdRkAf+4oWB7X2+lhi4Gs/A9n?=
 =?us-ascii?Q?bQ=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38c56dd0-e665-4555-42a5-08db0d805fd0
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 05:08:41.9078
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: szXQyjR1uKG5+Md6AocMSjww6EI2KeGLbJYLrXzqT2QNArKiV16QC3VzP7vI176YDoT5zcC2OjdXRBB2hj7xfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR21MB1444
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Completion responses to SEND_RNDIS_PKT messages are currently processed
regardless of the status in the response, so that resources associated
with the request are freed.  While this is appropriate, code bugs that
cause sending a malformed message, or errors on the Hyper-V host, go
undetected. Fix this by checking the status and outputting a rate-limited
message if there is an error.

Signed-off-by: Michael Kelley <mikelley@microsoft.com>
---

Changes in v3:
* Fix rate-limit logic when msglen is too small [Haiyang Zhang]

Changes in v2:
* Add rate-limiting to error messages [Haiyang Zhang]

 drivers/net/hyperv/netvsc.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index 661bbe6..f702807 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -813,6 +813,7 @@ static void netvsc_send_completion(struct net_device *ndev,
 	u32 msglen = hv_pkt_datalen(desc);
 	struct nvsp_message *pkt_rqst;
 	u64 cmd_rqst;
+	u32 status;
 
 	/* First check if this is a VMBUS completion without data payload */
 	if (!msglen) {
@@ -884,6 +885,23 @@ static void netvsc_send_completion(struct net_device *ndev,
 		break;
 
 	case NVSP_MSG1_TYPE_SEND_RNDIS_PKT_COMPLETE:
+		if (msglen < sizeof(struct nvsp_message_header) +
+		    sizeof(struct nvsp_1_message_send_rndis_packet_complete)) {
+			if (net_ratelimit())
+				netdev_err(ndev, "nvsp_rndis_pkt_complete length too small: %u\n",
+					   msglen);
+			return;
+		}
+
+		/* If status indicates an error, output a message so we know
+		 * there's a problem. But process the completion anyway so the
+		 * resources are released.
+		 */
+		status = nvsp_packet->msg.v1_msg.send_rndis_pkt_complete.status;
+		if (status != NVSP_STAT_SUCCESS && net_ratelimit())
+			netdev_err(ndev, "nvsp_rndis_pkt_complete error status: %x\n",
+				   status);
+
 		netvsc_send_tx_complete(ndev, net_device, incoming_channel,
 					desc, budget);
 		break;
-- 
1.8.3.1

