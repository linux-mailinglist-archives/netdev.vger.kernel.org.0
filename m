Return-Path: <netdev+bounces-11003-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 24BC27310BB
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 09:32:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 350F41C20E1B
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 07:32:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07B871C08;
	Thu, 15 Jun 2023 07:32:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E426F635
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 07:32:21 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2116.outbound.protection.outlook.com [40.107.92.116])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B15CB2706;
	Thu, 15 Jun 2023 00:32:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lQYQtCH/XZ9bY9JT26vdeq31L0rvnJYRoxJyvUL7DDgLgIzCAz0RO8q4lAsL3yGwB7tRch8y85yCW2gTRzLtVUkRa9Z/usJXwzzm7Y2yFlQDfTFIxfwE/nFk7y6Soz/kf2etclR/Odj/2cO8CrXP82+bbKw4RQW6Z5yWMwNl+4NUbZ1gGNvvpwIFk8pm7scKgrlHJ/2PJiOgyqjls2TiXhc7oRqIye2VJcGr/4NYjRnL0SurhPmtnEULPrE3Yqw62xxzRO427pM7WEluuMAXpDsEeBMXnAyKjahQkZJSes0rSy5EKTdQIQNpSBTum2QDuVE0xH8hsfhBFbdjRYc7gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2xwf8ORVXOYojqpgkrbH10jmYoaGn5pod6R6xW/Gqug=;
 b=Hlp3ttecA6A58AghcL2gm7Zj4VcS3wWK7B1Nf0rdm7IDwh7Tjx6CGtb07vaHiHZ3F1PC8w6PLhpOpWMh3amNcxJNNOtnjXhD73PQelIbpStjBPkbbMxRDENCPy4KChtpvxoDjbiyM8PkinzCdKsIdey17qIGnuAPOgVpPHMU48Az2dryAHeRSmfUJo+I0LVqubrdQeHQXgelnChG8wTfCcoUGX44ZnJEs6Vpc4nJyZUywFEx/2alW4qM67yg/DjO7XbtPg8jSht7+4TL2B5uDEmNy+nFqvkhWJQfBIYGLHQfM5+kf62Xcba8AQxTCoHQI6FaKH1c9ISXBdADqyGg5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2xwf8ORVXOYojqpgkrbH10jmYoaGn5pod6R6xW/Gqug=;
 b=CH4BuVW1Xdi/0QaMYRAiyz0S+vpoXVvRxMXb1GKyCKiEViEobsPLcQ5tPL1IGsTDJRA7vc60a+evHC0NA1qpcrzZpoLRRa3Zmyus3RXY6UQGn+NmokjIsZjiCPnTkNE7bJxOiseo3ytOgKtvXwKqfuyx5wzXXEbWUs6N12heQu4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from DM6PR13MB4249.namprd13.prod.outlook.com (2603:10b6:5:7b::25) by
 PH0PR13MB4889.namprd13.prod.outlook.com (2603:10b6:510:98::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6477.29; Thu, 15 Jun 2023 07:32:15 +0000
Received: from DM6PR13MB4249.namprd13.prod.outlook.com
 ([fe80::eb7b:880f:dc82:c8d1]) by DM6PR13MB4249.namprd13.prod.outlook.com
 ([fe80::eb7b:880f:dc82:c8d1%4]) with mapi id 15.20.6477.037; Thu, 15 Jun 2023
 07:32:15 +0000
From: Louis Peens <louis.peens@corigine.com>
To: David Miller <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <simon.horman@corigine.com>,
	Tianyu Yuan <tianyu.yuan@corigine.com>,
	netdev@vger.kernel.org,
	stable@vger.kernel.org,
	oss-drivers@corigine.com
Subject: [PATCH net v2] nfp: fix rcu_read_lock/unlock while rcu_derefrencing
Date: Thu, 15 Jun 2023 09:31:39 +0200
Message-Id: <20230615073139.8656-1-louis.peens@corigine.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: JN3P275CA0023.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:71::18)
 To DM6PR13MB4249.namprd13.prod.outlook.com (2603:10b6:5:7b::25)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR13MB4249:EE_|PH0PR13MB4889:EE_
X-MS-Office365-Filtering-Correlation-Id: ffc2bcb6-d63a-44f0-4e4d-08db6d72a468
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	S9okJ3ufwwl56ujcPlEo00Ro0KiQZK5tHUQViyS5swXTtxBNU7glaFccMC06gryu4Jde6FRAIxYZGmYcf7aYTjCjQgGXmaXeeChjp5WxYhADQfIQzdZEFZeRhiOTDdrEjL93f48/KmcclwLEZyeeUAkCjQtC3s6we6l1pc724j63Wgz37oK7Newu85xjIF0grkxauJvfqKtL2TPfKrUzS+7Va+7ez1T5DlY6Zc8v5Dh1Au+yII3I+UecfIEahYbsD10AzZBc+O8fRBeMdjoC/b4nnFrFRGMxlL2dBAK5uUlMHXUhuoCMMeXFCm1qtvPRTu4EaOBnusivg8mBe6cEEeHBUwKZjX79BRL9hBoMaBrBOGbeSWQZZ0luHOkGNO5oK/ljneT94DFqQ4GtSMLsYkYkZjtgIA+XOu3M+E/bdc1h0aUzr0l0FJuHHeitZr4etC9IstfUVNf5cRMH7+mB4GdBZFuKaS4hvaCxLDnCte0WEWoK3YveY9K8AeHSR+3KSjof9TwE5lXMEaJq8XRId07X3ufCXXnrv+BAEK0dg0Vj9+Scq+zjn96/sRHD7Kg8x6knuohohrMXRnE6VOr7JgCq6F0XQha583IqDxO/2ILGMnGl2072h2aP2rRAtSkT
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB4249.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(396003)(39840400004)(376002)(366004)(451199021)(6666004)(52116002)(6486002)(478600001)(83380400001)(1076003)(6506007)(107886003)(26005)(6512007)(55236004)(36756003)(38350700002)(86362001)(38100700002)(2616005)(186003)(66556008)(66946007)(8676002)(66476007)(4326008)(316002)(8936002)(5660300002)(2906002)(41300700001)(110136005)(54906003)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Xc/iBmDKPGyLVTRu4Baat4k0DGvvgWmT7jkHOUH6v2ToLygLljBDlfk9d9N1?=
 =?us-ascii?Q?PT2ok9Rxo3jAKhosK9ySpHWj+MYotqNrvfYgd1A6HBl5PvVa8L2Goafi2uWP?=
 =?us-ascii?Q?6mod7ep62qzRlBz73oSvBjIVOlNk2Q/nkolzSJv86JqUn4t6fRjnWRcmyn9t?=
 =?us-ascii?Q?tnJM1kYbl9KSNFt2/CU37cSK0amtLhQmlVnTo9cHv/1S/SAzMHuxMjkg0C3/?=
 =?us-ascii?Q?vXJV8viVdq4VKQM1Y4waUXgMg7sGrgtVZGCYvunCrx+evVJgf61OkhtUD67T?=
 =?us-ascii?Q?+AA7VOEusp5SBbEwizNDoOKVpEl+C5Jz9EG9wkpgtmp2sxcd0Shsh8/mvDoM?=
 =?us-ascii?Q?9naqN4hfkyrWn9UQcq1g/52olSQsQJKsaPfJ1T1P7rweoy790a0+MHL6peI3?=
 =?us-ascii?Q?nEcLzBIaFlKGz7tf6K4COhQKGNluxtO8J1dqa2TC/nC9PaBQmA92Tjp3GeMJ?=
 =?us-ascii?Q?annFugfyG3gZBWtIIjwJfCbRp0Fo/UeEZ1LgyjXoZEBtGLQriQD8GsUPVXKi?=
 =?us-ascii?Q?7BoJFaawrjTLGuMACOTutac7BNQ4A/KLWLDtyOnYkbLAvsM8YFi2iSoby7TM?=
 =?us-ascii?Q?N+vLY2sqcVoBue/Q4seUFRlZY9pKC9pa/QG45KC1rdr8K0ACVxe/TF8j+EKK?=
 =?us-ascii?Q?RW2BQ/GJr5oyMkio5iOR0YocXAQNmW0RCRS5Id/OfGn8GPuq1Omsz9C9JulX?=
 =?us-ascii?Q?J0sFXVnl4y2xtkt6Z5MoaK1bHpU1auXBPZId4+SmEY0lIa84d2Tl1PeWzSiw?=
 =?us-ascii?Q?qE42Yn+vW5yIaMCUDU/HoeqUytbpUxnoRigQ7D4UZpu0GlDv9eknNc3E4pWt?=
 =?us-ascii?Q?AJhfpUekvHvZrczhqY9erSicC5enspAUyIBC5SoOgZGHEuNF62SgMWG6rqSu?=
 =?us-ascii?Q?D1qnGTaKNsDKA6vEvtkWxcfoF7AlHw6Wj5gZPYD7lQyiV0DD9x/TaY+vnmPk?=
 =?us-ascii?Q?zzSB1RiXBFIPEhISDULd8rMdbonJaK+7KgoC3K2v9aep+RhuJo4AKVJUCKUT?=
 =?us-ascii?Q?XJq7GpFZRFBTyOfBOWP+AeXfenbs5Ije9QWT2zRBfgclJNeIqT3oycQznohD?=
 =?us-ascii?Q?FvcRGy7BPLRHhcj8KL8Cb2EqClEka4urR7QTDZFdl+Xm3U+PkUhus3BzLgSf?=
 =?us-ascii?Q?Ku7WQW1enDcQzkgPkKNqzpMH9SOAEKcmxR0nLH1ZUhvySjvLxnkb0+9jFFM/?=
 =?us-ascii?Q?Vg8NxrZ0cGws9pe/F+i2TfbF5S+eAWcgF5xwSS5gY+GiKUTQO+TJRm0zXy0/?=
 =?us-ascii?Q?6YcLQpWzB4Bx5UwfSkJ/BndQJi2BoPIB1gXoRTkwklNYIWwcBu5ld3ersaxm?=
 =?us-ascii?Q?ufH8wyxcQFFweI9gILxAEQsCfI8tPPS3WhB8fJjTN+SQuetZyFTe6Js9P8bR?=
 =?us-ascii?Q?gjQyBQyDJwOzoR91oHPhIzoW5a7aDy1DKBsiL9ZY5fhaTsGmZdze2rJraDmx?=
 =?us-ascii?Q?vLhaIXXbZZV/td/m7HPH8PtHkFab8Gm/DFdVM8WfsjFMViJyyglR5GBsOXc8?=
 =?us-ascii?Q?KVGBXwCT4y/sTmYxqKMRMqbBIPHzNyfM6+TYKSJJr041G+b0EybFARu04Li5?=
 =?us-ascii?Q?0hzJddjPoWFRbilsDbSjhydtIjbaSnu1+IdkD1mFKeCOCCvJbTEYs99XM/0n?=
 =?us-ascii?Q?yw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffc2bcb6-d63a-44f0-4e4d-08db6d72a468
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB4249.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2023 07:32:15.6002
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pBiXbCYJkCIF297iJivdZVje6jBwJC4DhcKAo1SZdhlnWa23MPzpR+UJBiFNrKLkanHppGKwI5iPArHH5Y4UBDVvXG3g/s/Dx7mDD7R/i8I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4889
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Tianyu Yuan <tianyu.yuan@corigine.com>

When CONFIG_PROVE_LOCKING and CONFIG_PROVE_RCU are enabled, using OVS with
vf reprs on bridge will lead to following log in dmesg:

 .../nfp/flower/main.c:269 suspicious rcu_dereference_check() usage!

 other info that might help us debug this:

 rcu_scheduler_active = 2, debug_locks = 1
 no locks held by swapper/15/0.

 ......
 Call Trace:
  <IRQ>
  dump_stack_lvl+0x8c/0xa0
  lockdep_rcu_suspicious+0x118/0x1a0
  nfp_flower_dev_get+0xc1/0x240 [nfp]
  nfp_nfd3_rx+0x419/0xb90 [nfp]
  ? validate_chain+0x640/0x1880
  nfp_nfd3_poll+0x3e/0x180 [nfp]
  __napi_poll+0x28/0x1d0
  net_rx_action+0x2bd/0x3c0
  ? _raw_spin_unlock_irqrestore+0x42/0x70
  __do_softirq+0xc3/0x3c6
  irq_exit_rcu+0xeb/0x130
  common_interrupt+0xb9/0xd0
  </IRQ>
  <TASK>
  ......
  </TASK>

In previous patch rcu_read_lock()/unlock() are removed because rcu-lock may
affect xdp_prog. However this removal will make RCU lockdep report above
warning because of missing of rcu_read_lock()/unlock() pair around
rcu_deference().

This patch resolves this problem by replacing rcu_deference() with
rcu_dereference_check() to annotate that access is safe if
rcu_read_lock/rcu_read_lock_bh is held.

Fixes: d5789621b658 ("nfp: Remove rcu_read_lock() around XDP program invocation")
CC: stable@vger.kernel.org
Signed-off-by: Tianyu Yuan <tianyu.yuan@corigine.com>
Acked-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
---
v1 -> v2:
   Remove unnessary nfp_app_dev_get_locked() helper function
   Replace rcu_dereference() with rcu_dereference_check() in .get_dev()
   Improve commit message
---
 drivers/net/ethernet/netronome/nfp/abm/main.c    | 4 ++--
 drivers/net/ethernet/netronome/nfp/flower/main.c | 5 +++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/abm/main.c b/drivers/net/ethernet/netronome/nfp/abm/main.c
index 5d3df28c648f..10b73297a313 100644
--- a/drivers/net/ethernet/netronome/nfp/abm/main.c
+++ b/drivers/net/ethernet/netronome/nfp/abm/main.c
@@ -63,14 +63,14 @@ nfp_abm_repr_get(struct nfp_app *app, u32 port_id, bool *redir_egress)
 	rtype = FIELD_GET(NFP_ABM_PORTID_TYPE, port_id);
 	port = FIELD_GET(NFP_ABM_PORTID_ID, port_id);
 
-	reprs = rcu_dereference(app->reprs[rtype]);
+	reprs = rcu_dereference_check(app->reprs[rtype], rcu_read_lock_bh_held());
 	if (!reprs)
 		return NULL;
 
 	if (port >= reprs->num_reprs)
 		return NULL;
 
-	return rcu_dereference(reprs->reprs[port]);
+	return rcu_dereference_check(reprs->reprs[port], rcu_read_lock_bh_held());
 }
 
 static int
diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.c b/drivers/net/ethernet/netronome/nfp/flower/main.c
index 83eaa5ae3cd4..d33cc22c788d 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.c
@@ -257,14 +257,15 @@ nfp_flower_dev_get(struct nfp_app *app, u32 port_id, bool *redir_egress)
 	if (repr_type > NFP_REPR_TYPE_MAX)
 		return NULL;
 
-	reprs = rcu_dereference(app->reprs[repr_type]);
+	reprs = rcu_dereference_check(app->reprs[repr_type],
+				      rcu_read_lock_bh_held());
 	if (!reprs)
 		return NULL;
 
 	if (port >= reprs->num_reprs)
 		return NULL;
 
-	return rcu_dereference(reprs->reprs[port]);
+	return rcu_dereference_check(reprs->reprs[port], rcu_read_lock_bh_held());
 }
 
 static int
-- 
2.34.1


