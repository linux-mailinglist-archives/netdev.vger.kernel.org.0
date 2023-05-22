Return-Path: <netdev+bounces-4320-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E2DB70C0C4
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 16:15:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B6701280FC7
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 14:15:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C40C514276;
	Mon, 22 May 2023 14:15:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A626913AE3
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 14:15:14 +0000 (UTC)
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2094.outbound.protection.outlook.com [40.107.95.94])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE58E13E
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 07:15:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gtQwfvD5YSs/qPIJ84tD17hf7IQIUV2Zc3JDmVjKwPhPhSTY0/87bscoWW6GucNLGAZhl1sXmMtOhUr2QyO8n34vKTt0XCojVxDdfIo/Y/rGQ4MS4a4zlw7N2TkzV1yq8IxG3AHEFa/DLD/7S+s5q3gFK0IqeL1aI+lW0r4vtI+by+/su8Fzc7sFIiil9F6GSIyq4C0fa1rhEBqqiV6BzEsEw5iwMjrEMchkQDHj3nH7rvxCqjRm8ZqxOGP0Q8fJCXKXKf53YHo8GBMwGEnAA0g2ivpKuOkDQUcRPywRxAk2fWLDLNq5RlAN+nT1/CmS7ct5DKuwxADIyOMyl/IwCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H9CrsFhRyGacmppfy7VmuN/dJvx6MFAz1LQ6eN3GNUc=;
 b=fblbpHyI1g9EVxouuJqNHY9e/IKWmeZnx2pgEFriK/fmYJ3ym65e7o7yhtcuSSg99Cxq9kvMquoQfvjjrutLRmWvIxr63ScvrFO+7AQzueI9A1wcvV/ZNbML8YFugmhBCvMKIjDMVJ0IG6i7+gFs/Iye3WXQQ/NNIW92p4x/p7Jbb58eyj9bHACW+ZcxdyIadD9Pid/VpUIJFHva6URFzUfhgse6gWSZniQZWvWKhncu+2zde12OHWv4h5wg5K0KKBLGhSMlMtrfvDXk2lXMuCAa0U76e6nY/54GOoUWA7XA2girxGdmb3TWxTASJ388hWtI9sMZQ2YFlaSJLSUl4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H9CrsFhRyGacmppfy7VmuN/dJvx6MFAz1LQ6eN3GNUc=;
 b=bRbaCM4uKY2YcqQWuv3B3a1c57H1WrtICMQGBX/Oy6qiwK87mvDyNzxbfTiOSkC3W8NmG+hGJ4PsCVoCl7GT0VUFLpfctK+/1uHKOxMEEue38OOlAQFRf7ZeuazUkpvZsXvB4Fsawwx4mEuQrY7a9XkGTQimGW8WOlNejqxVsk4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from DM6PR13MB4249.namprd13.prod.outlook.com (2603:10b6:5:7b::25) by
 BLAPR13MB4579.namprd13.prod.outlook.com (2603:10b6:208:327::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.26; Mon, 22 May
 2023 14:15:09 +0000
Received: from DM6PR13MB4249.namprd13.prod.outlook.com
 ([fe80::47e:11b:a728:c09e]) by DM6PR13MB4249.namprd13.prod.outlook.com
 ([fe80::47e:11b:a728:c09e%7]) with mapi id 15.20.6411.027; Mon, 22 May 2023
 14:15:09 +0000
From: Louis Peens <louis.peens@corigine.com>
To: David Miller <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <simon.horman@corigine.com>,
	netdev@vger.kernel.org,
	oss-drivers@corigine.com
Subject: [PATCH net-next] nfp: add L4 RSS hashing on UDP traffic
Date: Mon, 22 May 2023 16:13:35 +0200
Message-Id: <20230522141335.22536-1-louis.peens@corigine.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR1P264CA0138.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:51::19) To DM6PR13MB4249.namprd13.prod.outlook.com
 (2603:10b6:5:7b::25)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR13MB4249:EE_|BLAPR13MB4579:EE_
X-MS-Office365-Filtering-Correlation-Id: 54e6daf1-a7c9-441e-0afe-08db5acef347
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	lEmwInnM6KpynRlw253tsdlrI9z8CyEEnIzWgLEWM3g79wLA8EwAMJRsM30O6vUS4oujoLg2qcgoPNVjQmRN5UhpKRwIpqsunP1o7znJSRv6n3ZTpCJgNw4L415tFD06nn73vIqxw0PROquiscMFVQh4L4goebtuO5ZGjjMy64xXD3nhmeKES6CoFAqeizIcqYyfuoq5bVIMIImQTHlOKRq4LsD8IpWSP3Jzd2amn6d24rWk4V+lEsSr5mVMGWveC16BE7MDyQcTrFqgxgcpf4CVBJeppsBU3XzG9Z/2Eg9OwBeYgojogdLzqO5/64YxuL4+yz0NFVZywg/jeA50mfqh7/mMl55NhiCkox3tgVW5lKWO8bNw4JvqDNqjcepBPGrarBWja658DBn6xFV5IVICACPbknhhSR8fScWKNsRiX8GAra387kVdZjCy2IfrvP4A9ZnMhF/2ZBxPtCmBKs+jfb3R1JSFqk8hp6qcdIJm91oV+6W9okAhUGVJwEzxTbOkaO5gOqC/IrFzvYhlmZ3CKkkN/IlaxWfbkQJxN4CDwRqIPFG0hewfxtVLrfklnaLoKHLt3rl6ISWQUeeHhGSGl00iGh/cJWfEteO4kAE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB4249.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(39840400004)(376002)(396003)(366004)(346002)(451199021)(478600001)(8936002)(5660300002)(66946007)(66556008)(66476007)(4326008)(6666004)(8676002)(110136005)(52116002)(38100700002)(6486002)(6512007)(26005)(1076003)(6506007)(107886003)(44832011)(41300700001)(83380400001)(316002)(2616005)(38350700002)(36756003)(86362001)(186003)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hYHWFLw3927vqQk/EjRDSTX9Mcjdzz/aGCBvtyF12mMnEMt4OMMVb8xBIYib?=
 =?us-ascii?Q?m/8PyDQCrKuwzAc11DrczJP91IuOgbrgO2s9lwaqxGSEDEPqqSAZMe9EivbC?=
 =?us-ascii?Q?sIyJEaIUw+gZqzIc32ITZuBB2/9l3EVz9eNMCPGELEX+/l2UbkjefE+xAHvD?=
 =?us-ascii?Q?GHbtozf3m9YRJpMF7qKAaZP1OOxjn0TZOXcpXuYmkhdnuvvSyJELoAkfxrie?=
 =?us-ascii?Q?en/gRdDigvskkvEp9AVwNvxq9/O6VAnWjnOSBUaB1WGh9ZMm/KCAJanIpWS7?=
 =?us-ascii?Q?m0AtERWNEJnRYh39mVa9jwOekzaLRORgEcsO+9ZM8Dff7srkYvCALZmB5vjQ?=
 =?us-ascii?Q?Qa+0ASF2B7YnT/pn4tQ1bnbmZTHC6XvI6wVuuypcgw+3+KHjm+IrESL67YQG?=
 =?us-ascii?Q?wKnF1z1odHK0kFaBUrVB1AIxoOeJMBFZQqkiUkXWb+l46XJUC6C3yt2Kc+0X?=
 =?us-ascii?Q?WOQgPgpf/LAphhFvVXJLlRV0NNAYKbNUnPin5iI881kIAGrY4zPXs/DfzdHw?=
 =?us-ascii?Q?bz7/rfxHyUTLwU3ntvix2h0LYf/qARjP+Hk7Jnj7fVzds4J6qyxssS2XBiu5?=
 =?us-ascii?Q?rSOQLSp/fZghPJ99Az8eLh8/W1sVTDSgqIDqHbus46xDQnew/I8Xls/NSkAr?=
 =?us-ascii?Q?ie5V5RhM9rfoYu3daoBT+SWLZKNMwNrlwdxQLfPBwakTgcN6Z8y5MAvfXY5j?=
 =?us-ascii?Q?FnSRF/6at/0udKhWdlFoR4O4xHhQS6/MbtWDzQfh3Z3uUozrd3+zefFoxCUr?=
 =?us-ascii?Q?7BnPh9XCR8mcMlEug5lRIiU/ORnMbjyme7XTNYa2NuzhT7zKAmdsoZQY2+Rs?=
 =?us-ascii?Q?7TztK8XoJT4BYI36+WutyWBsB2CjlFj1PFSrciMh0hyFI+EUROtEcW5caF2U?=
 =?us-ascii?Q?1+VNjJLyThiwajzb+GpDfLbWS9yv+R12t/1OWqgihUGm43gcrxUSEdRueH/I?=
 =?us-ascii?Q?r1eZKnIKnDvu+/jTZzjOY2bw8AvU/nIMm8nLSsdWo8PK90/3exAEvYJYK/tE?=
 =?us-ascii?Q?0SD3dgognzYdjuQ2pJUqcnzdFfDakoEWaQGHmgeBnZcj8GGOOXL20q2jckwG?=
 =?us-ascii?Q?PNr21KDESc8l2zXik1sVXfT3g8GCJWMNPtGi/K9Vwvb6mBy5tU0qGHTmI0v+?=
 =?us-ascii?Q?ndG0HEHWniI31LM28Wh3mC+T17Gk7dMQ105DJozA66CgBQsKH+PyrbIii42U?=
 =?us-ascii?Q?ytAbSEfZUvoAyh2B7Vk+PIEhYx7LO0E6oW3grv9+PJGIagIQYG1GIX8qJzmx?=
 =?us-ascii?Q?+r1Gj03GkQPqaCCgSSqs8jeMPIzsPSPpuAUb6eAqExnhBjq0kW9YpDsZzggq?=
 =?us-ascii?Q?0NdeljSYmwcYFh9ym/rsIzftzMa9TUIb4Av4Q95SkEhYyCgjxHeLoeBBQ9GB?=
 =?us-ascii?Q?HU84fe0ciSC2gAHb0076YogQ//uthbd0ZOzwom4UkPeOOkE7+FBkha5XjTe4?=
 =?us-ascii?Q?GuxLEaUp49/XNCWZkSqnQ9WayqnzV6kuDQkdn8hUMRXLgcYzVSZyU9VrZQE8?=
 =?us-ascii?Q?QbIfdUzE8uxs1QqUJgmXRRBD6YN4Kfw2hDbauqkQLZVXC8fHaCUMCCDIVv8B?=
 =?us-ascii?Q?MwLJBU44djLFnBWEmRolSk0apvfC2CF2xBcFOnx9lSw5DXNP0HzLa4kIJGSF?=
 =?us-ascii?Q?5Q=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54e6daf1-a7c9-441e-0afe-08db5acef347
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB4249.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2023 14:15:09.7375
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H/0Vgfa0DRmvNbscLIUsLnWWoTCatcJwDGrPr+N3uWjZt2SzG+6UyKu+I+uzfpHwLKSWowQmL65CHF1Mdc9EVotNUxcEoJHunf/k0IAyEZo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR13MB4579
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Jaco Coetzee <jaco.coetzee@corigine.com>

Add layer 4 RSS hashing on UDP traffic to allow for the
utilization of multiple queues for multiple connections on
the same IP address.

Previously, since the introduction of the driver, RSS hashing
was only performed on the source and destination IP addresses
of UDP packets thereby limiting UDP traffic to a single queue
for multiple connections on the same IP address. The transport
layer is now included in RSS hashing for UDP traffic, which
was not previously the case. The reason behind the previous
limitation is unclear - either a historic limitation of the
NFP device, or an oversight.

Signed-off-by: Jaco Coetzee <jaco.coetzee@corigine.com>
Acked-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 62f0bf91d1e1..b7cce746b5c0 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -2418,6 +2418,8 @@ static void nfp_net_rss_init(struct nfp_net *nn)
 	/* Enable IPv4/IPv6 TCP by default */
 	nn->rss_cfg = NFP_NET_CFG_RSS_IPV4_TCP |
 		      NFP_NET_CFG_RSS_IPV6_TCP |
+		      NFP_NET_CFG_RSS_IPV4_UDP |
+		      NFP_NET_CFG_RSS_IPV6_UDP |
 		      FIELD_PREP(NFP_NET_CFG_RSS_HFUNC, nn->rss_hfunc) |
 		      NFP_NET_CFG_RSS_MASK;
 }
-- 
2.34.1


