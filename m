Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB516A41A2
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 13:21:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbjB0MVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 07:21:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjB0MVc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 07:21:32 -0500
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2124.outbound.protection.outlook.com [40.107.241.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3331A136FA
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 04:21:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ea35kZ+QikI67QNepCp3XmLJR4/dEDfRDrIPIOlq6Ja6DHDdqDjYnahhlPrXiygAm3N0hRgAD1YHaoLr9zAPywZW3Nj4rOpo+U9CH4wEXWI1ukPk6YRvBMwlWCJLT+6Y0YJQo/b/K6XlqvMIOe8zyFH+MwPokldQjp8WUp3reT64S6DYpDcSATWy2PLkSbUtOmNNxwuGr/be1m6QbJ45AS/0Zo2X/rwJNr8SeaDFx45oKWijkxht7Ts877xfy9Z156Q3Wh3z4cxKYsgg/lpysMODlZEqYx3qnOFN3fJMxqTxOy27j47VygEtIi6jxzTCzwe/Cxhhz3jKnM5MlyPBtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=psKsTDho90CdTRmSuiWaT0JFMTvuu1eVtlIG/eU1iH4=;
 b=bLhfQqiDMBmrzEbF2j2rHZR/3rinWGfzm9NHdL6sWPFdY1rbPmJZcjkmfZrDlMRWVpPzo0z7Fjb2u77saxJSUSjOssgegU0qWoQ55HOLnSpX5HVWGwXz8BA2bXD+en6/v2IfdWSc0oSF6vVlfp8KJiFI+S0EG+G5svy4U9XX4+BHo7kcxregyxY1UFWv3JlKJoeBJ/j1x3vmPkpLMgva+dd3SrKbrOBZl4wOwYstNxdwkh56cwbwUwJEGgjcEX7DbX/g5eI8JWGDknMDUvMEXygITW7pOda+yQwKLRmOECIkgCS2RE0P2ejIlwNJDBlcfWXwkbpojr7Rhh0EJwsyQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=psKsTDho90CdTRmSuiWaT0JFMTvuu1eVtlIG/eU1iH4=;
 b=hETT46qEfvEqBuhheUc5OtMaxFOOAY29Zlzju6DCztXMUcsR8W6o04QPGPWbzBhVxa1V00qHDcv5z6I0YrrjoDA2cNI2MXXRNLY0rE14cBvraYFuIAD0HtKa6Va1NNy5xCcdNB6vtas1atv+fafRZ5kA3JYgYYrNcgjJxET8R3zaErm9NNEFtPjK5sMKm/zIuM17WamnNcSokK1/dHhg2nGDhsJVnxVrEabQDf6W1lDNgPNjr4I/x15J23jXIgl1vsGvQ0vqhlLdW4p69fOAufjhVNWua98pZqmqTVud6cwLyOKvM11F2vWhVk3dCuUl/ijWOHvCduoY6lnkwuS6AQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from VE1PR08MB4765.eurprd08.prod.outlook.com (2603:10a6:802:a5::16)
 by PA4PR08MB6208.eurprd08.prod.outlook.com (2603:10a6:102:e5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.27; Mon, 27 Feb
 2023 12:21:28 +0000
Received: from VE1PR08MB4765.eurprd08.prod.outlook.com
 ([fe80::de4d:b213:8e1:9343]) by VE1PR08MB4765.eurprd08.prod.outlook.com
 ([fe80::de4d:b213:8e1:9343%7]) with mapi id 15.20.6134.029; Mon, 27 Feb 2023
 12:21:28 +0000
Message-ID: <901abd29-9813-e4fe-c1db-f5273b1c55e3@virtuozzo.com>
Date:   Mon, 27 Feb 2023 14:21:26 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.0
Subject: [PATCH] netfilter: nf_tables: always synchronize with readers before
 releasing tables
References: <20230227121720.3775652-1-alexander.atanasov@virtuozzo.com>
To:     netdev@vger.kernel.org
From:   Alexander Atanasov <alexander.atanasov@virtuozzo.com>
In-Reply-To: <20230227121720.3775652-1-alexander.atanasov@virtuozzo.com>
X-Forwarded-Message-Id: <20230227121720.3775652-1-alexander.atanasov@virtuozzo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: VI1PR09CA0094.eurprd09.prod.outlook.com
 (2603:10a6:803:78::17) To VE1PR08MB4765.eurprd08.prod.outlook.com
 (2603:10a6:802:a5::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VE1PR08MB4765:EE_|PA4PR08MB6208:EE_
X-MS-Office365-Filtering-Correlation-Id: 022f6a7f-5d71-437a-723f-08db18bd26a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wBnz/T/ihre1hxH89ljvRUsyn7iLKpH1oTFYPOrtrN2Uc0SbNt7Th1YHO3AhlDq0PAwaFZHY/kTKBjQE+Sg7AZc8vddkPErkBh6t0Q3gftOAX7n7GQYqhI1OG7u9rN6QYmxHJkQ51Ah8ZXIX/3phoj31GeqvX0DqXbLyDbJDYgetM8f5s3OMluAltD/4IEwXcLDMgjMK0PIER4kIhexsfdgpQiE84tYVIaFvRhlHB0a4Kjx1YHOxq/jNqKtfytKCL43JIlIBXzlG+N0XuEXwmU2sugUpeNEcrhsnfxKVV2rXskzCQ+DMnJfSSSpvIRk/MCBsp/tg3qHtGE08fVpAA3J5WlwrFh5zmGt7nCvCVdx0tCk51Kp2W06c/TcocmbuB3ij/RQ3WrhYasLl0MD+nwsnDUKt0odntSv97heGokOuBVlLBDZ/27N0XY5SC/eeJbMjMOlmrMwubzhmllwc1KRr1e7lGB9W9gfbJ1EVya3xPartjGgiJxbuNYS8GjBulNQVAkRyPmCKxmwLRtu73uNFPY+s99/0W3rHOBlomo24vaIkVGaH+4EyOwBRGDK1jNtGONYJMN0/L9ORKuBz6OM+gPTFvkF/3PSqE9avHn0WIQ+Eu7NxoUXOEZVdbkG+z8zg0Q0wTvzSj9v4mDym+m3ybGAY7VVPvvgqf+//UQlDCPR9zKFHNYjszFq6xWJ+Gky2/SKMcKA9JK3gpD6mmoxa4e1hFxWmcW+n+ACXl7E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR08MB4765.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(396003)(366004)(346002)(39850400004)(451199018)(8936002)(316002)(36756003)(8676002)(6512007)(186003)(26005)(478600001)(86362001)(44832011)(31696002)(2906002)(6486002)(6506007)(2616005)(38100700002)(5660300002)(83380400001)(6916009)(66556008)(66946007)(66476007)(31686004)(41300700001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N3FlQUo0ZWkyUGo1L3Q2Ujk1T0lXSjE1TVNKVllWcTc0b242OHcxdEJzUSs5?=
 =?utf-8?B?U3VXbDUyeldSN2ZXUlh6NDdSckxHSVBQMFJDRUJqYTlFZktDRVN3em82NlUz?=
 =?utf-8?B?MUl1WVBpeFN3Kyt0NlRpby8ydTVUZGRNRnBUYm4xTlYzb1Y3WjRnQWplL2M4?=
 =?utf-8?B?UUNQTkYvMy9ISm5UK3JrQ25GUk91bHU2QkJQMGJrZm1KaEwxaEVsRzlIdkpB?=
 =?utf-8?B?V1JnUDV1Y3BFeWxQbjBpUG42ejdpREVKYkpuNDdlM1p2VVRqNDRRQUU3UFUy?=
 =?utf-8?B?MGdFNFZ1TDA1Q1pWbUJ1ZDA1UEpnMG5sQTZvZXViYUc0L25SRmJHWjVWQXg5?=
 =?utf-8?B?ektvQ0hqUTFlZitjaGF2TlBoY1hYSlJVVFQxZXlhdjFXSDNZM0V5ZC85QkE1?=
 =?utf-8?B?L2xlenNKK2JkakI0bnA0cldmNXR0dGR1cEJHQ1VqSTBqUXlnWUdOakJhb0VK?=
 =?utf-8?B?aFI5dGFuN0gvb3dZR2lWdkQ3MFlQb20zV21mV1F4UWppWFc4OTY2b1REZFFK?=
 =?utf-8?B?NCtHdHNCM0V6aTVmbjhpRTN5ZEtSSUlOa2kwZk90dkhtWXdIRkdQdmoyK0Vi?=
 =?utf-8?B?azJQZThwNWlPb0xpUzVEVHdRUWxlRVRlRVhNRitJNnU2V3lhVHhvbmVySnRR?=
 =?utf-8?B?TitnS0docjdNMUZNMjl5U0h3d3R0WjFSN0hKb0l5YVBpSlRsWFhZTXZ4ckN4?=
 =?utf-8?B?N0hsMnFLVjZLdVNxT3kyRUVpRkhSYjF1bFQ0YVZGWW1YSFlYeW01SjF5bnFS?=
 =?utf-8?B?dlhjMFlxa1pTZVErdCt2WkgvaVpuS01mT09QTXBQTUY1eHEzMWg2NWVxZHRR?=
 =?utf-8?B?TlJFNmVJV2NNZDUyVTFlai9Ldm9ydmtwNFV1VWxnR0MxNFdNSGdSQmV4Qmps?=
 =?utf-8?B?S3U3UWN1bDEwdG1IMjFwdEhmclh6S0s2ZUVNU1FjRWpPYURROElVdDNnaDBE?=
 =?utf-8?B?M3VUdkduZlRYT2o5TjYwM3ZDRWVzM1Q5RURUSlM3VDUvM00xMFFGcWp4Z0pT?=
 =?utf-8?B?MVNNMkp3TUg1Z1JOakZmSjJuTXZJV1kyeXZzODhJTm1DM2ZpU21HUkpSL3NI?=
 =?utf-8?B?ZDBYNUpWa25odUZBU3J5TGYvUkpvTnFyRWpOMVJZdXM2ZFNzQWpLT0ZoQW0w?=
 =?utf-8?B?SVdTa3lwZC9SeWVSQnErV3RwTnczcWlVY2NOZmxQa0Z5UGtEaUo3aG1hREZH?=
 =?utf-8?B?cHVNcHc5T3R0WTd1T0NVbUJLMzVKOWo0ejhCUjUxQVJZaHlJVUJIRGpDMElX?=
 =?utf-8?B?LzFBN0NZRnQrU29wODFGSUZSdktYQWFWY3Z3ZGxQdDJ6bHErSklIajNRTEll?=
 =?utf-8?B?WVRTNWNCTlYyZmxhcFlDRzBBcHhLRkI1QVZYb0FtSU1aY3BvMWRwTU1US0Jq?=
 =?utf-8?B?b1NRUHM5UkhReWJlc1VSb2tnb3NIUDgxeVZ6eUJnWitIVEpXdkpxTzZCajRx?=
 =?utf-8?B?a0VLVFljYlVPd2FPMGRMbVNOaStNVWE2RmJoZXJ6QUgvYkE3c3M5RUk4MzJq?=
 =?utf-8?B?V3dQMkRFdndoUjhuMlFIZXZoYllSVExHejczK1JGWkJwWHBGWjE0bkMxcDdC?=
 =?utf-8?B?RCtzQlQxSklWS2d1YXlGaDRWeSsybDlyTmZwWWErR01qQkN6U25YbnF4bGts?=
 =?utf-8?B?M1E5UW4yRU1yTUcwbitPWStGelQwb2pjamdIWlNxWFlCSWtsTkd1MGNQbDBY?=
 =?utf-8?B?R1gyd0FmRSsyZVNNZ2VFblFBclg3T1RQcGhKOW5COHFIeWJqdnozMGRvcHJT?=
 =?utf-8?B?KzlEQmpRS2JkRm9yZTRldlpvNlorMDNORlhEUTIrcFJYd291c1gwOGdicHhU?=
 =?utf-8?B?dk16NWdGSkhVUTFkajhXMDBPSjBnL2x5TmhJbE9ValdhamVRSHFVZElTUms1?=
 =?utf-8?B?NVNMMEsrNE5Tak1Cc05jdGVJTzQ4dzJ3M0Mra2s1NE5LQ2tSWmZjbkdYSzVh?=
 =?utf-8?B?dzFQV3phZzV1ZVA3Qk1qNWtWWW1JaTM5aU1LN2djNGZ6b3oxVmQzK0duM3ox?=
 =?utf-8?B?aWZQMmJFellVenZaTFBqZ052K3NHaEcvcWxTYmVPUU1wVWY1SWVFVk1DSmhy?=
 =?utf-8?B?S2FRbzBXSDc2dTg0T1Z6RE5wM2NXbzdGYW9IbE9MRks4Z1R3NE0vU0EwVjY4?=
 =?utf-8?B?d3d3eG1XOWNnWUVKdGFIYnRWZEt3VGprRmFUQnh2ZTNuSDFCaHJ4UWNHNmlX?=
 =?utf-8?Q?iyWwUfKNrSvMOMPC185sYW0=3D?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 022f6a7f-5d71-437a-723f-08db18bd26a7
X-MS-Exchange-CrossTenant-AuthSource: VE1PR08MB4765.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2023 12:21:28.0856
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cqgoc5CBey8RaQpc7OZ9rC/VIR5sQSY7++HdBCCfJZq7HHgeE0O0flEpGWu8/q2dho2KShgQYslN9mUoA1N85GTCBI85C91u4L8ppBfPcLe1trjk3F7SydUGgnw3naJJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB6208
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

general protection fault, probably for non-canonical
address 0xdead000000000115: 0000 [#1] PREEMPT SMP NOPTI
RIP: 0010:__nf_tables_dump_rules+0x10d/0x170 [nf_tables]

__nf_tables_dump_rules runs under rcu_read_lock while __nft_release_table
is called from nf_tables_exit_net. commit_mutex is held inside
nf_tables_exit_net but this is not enough to guard against
lockless readers. When __nft_release_table does list_del(&rule->list)
next ptr is poisoned and it crashes while walking the list.

Before calling __nft_release_tables all lockless readers must be done -
to ensure this a call to synchronize_rcu() is required.

nf_tables_exit_net does this in case there is something to abort
inside __nf_tables_abort but it does not do so otherwise.
Fix this by add the missing synchronize_rcu() call before calling
__nft_release_table in the nothing to abort case.

Fixes: 6001a930ce03 ("netfilter: nftables: introduce table ownership")
Signed-off-by: Alexander Atanasov <alexander.atanasov@virtuozzo.com>
---
  net/netfilter/nf_tables_api.c | 6 ++++++
  1 file changed, 6 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index d73edbd4eec4..849523ece109 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -10333,9 +10333,15 @@ static void __net_exit 
nf_tables_exit_net(struct net *net)
  	struct nftables_pernet *nft_net = nft_pernet(net);
   	mutex_lock(&nft_net->commit_mutex);
+	/* Need to call synchronize_rcu() to let any active rcu lockless
+	 * readers to finish. __nf_tables_abort does this internaly so
+	 * only call it here if there is nothing to abort.
+	 */
  	if (!list_empty(&nft_net->commit_list) ||
  	    !list_empty(&nft_net->module_list))
  		__nf_tables_abort(net, NFNL_ABORT_NONE);
+	else
+		synchronize_rcu();
  	__nft_release_tables(net);
  	mutex_unlock(&nft_net->commit_mutex);
  	WARN_ON_ONCE(!list_empty(&nft_net->tables));
-- 
2.31.1

