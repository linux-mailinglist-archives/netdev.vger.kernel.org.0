Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4456062342E
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 21:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbiKIUGS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 15:06:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiKIUGO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 15:06:14 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on20700.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eae::700])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF7592F01A
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 12:06:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zr6EWj5rhwvNPOF8YurKxqMQGIUFpjJBhr3uB7T2Jb2/yYz5ZYag7lpdmqrakHGs8V1O8nlK6KpVu23HB8JzzZfI0Ciz2oW0VhicZlubIzs7ywYk8iOf2mLpMHaHdk9BnKxFtXA74akarWfzWkzDIYI2QDg16DVIPIrK75dCXyJHO095MnV4K+7sHf5skduVkHO8rvNvAUO8XDCiuqRUE57ou+PAnRkb2gJ0q052+KEDUuoAzIBq4pkllJ0+v53y4oL3DdCiO/+8H4qpL7HvYDQ30Mq5pE5gkSb4oRyv+NBd9YKKRLRp+mWV+GzYIYnkWZ8C6nvFOQ2DJgZ10ZTt3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=70aOoTzCIe7q44b00Ze99BRqrs+BZatjVrOJdibD0aM=;
 b=GxflxiAzH4eG4BcLXYz49eJnZ1dsyQFG85sgXR5mg1VevPen0/ZBVgTS03SZYWDYXmJYlkI98NimUqedeCA5fN+yJpefI7E86CmyRfLqTLVVcqc+/KYfmilJw7nnTCmvjH6oA2AMkLQYM8bqhXyPpiUzusrYveK4wUFq5/r9iNHqsxnNQZEo3GurO56ZUY+ZltJUhjpLbcme1TEhDcerLNQp0yefWzQCcuG1G4CRH6cxgmVlYxCq9OVCclakHK7AEDeFnUtBOyCOUNkcNYJzW21jpQO7+o3cwmpbbMZGBXS/TWVjDjSrq2B1wlSlNL+pb99gUbZyIcYK9O1HzXlu/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=70aOoTzCIe7q44b00Ze99BRqrs+BZatjVrOJdibD0aM=;
 b=d5oE1d33WRck0fI/whGybHIOm3BaTGWu5ttTwLMYU/40nazeNceFYlJmqWY7hSuYq6nzF/q732HT2Fju+e4Fj/R0o4S0B41zvGkgJu4ncGutybwSMMWH6RTnKBL4LKMhZdeJJUrmVbHXSitfHLCQxuIqgSILZD4uwlyDTpscIhc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5570.namprd13.prod.outlook.com (2603:10b6:a03:420::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25; Wed, 9 Nov
 2022 20:05:37 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30%8]) with mapi id 15.20.5791.027; Wed, 9 Nov 2022
 20:05:37 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next] nfp: take numa node into account when setting irq affinity
Date:   Wed,  9 Nov 2022 15:04:42 -0500
Message-Id: <20221109200442.143589-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR18CA0004.namprd18.prod.outlook.com
 (2603:10b6:208:23c::9) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5570:EE_
X-MS-Office365-Filtering-Correlation-Id: dc768578-0833-48e6-7f64-08dac28dc492
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Sd3L+A0AXL5DT1VmjFu2aBX2/MoKtCRnDMYljaeKAhi5IGYuIsBiz4F9gCju5L2tgbBAXyGoIdZp22n6Y+Au0W/Zk4GsBsUgIirmEn6PrP1sOCCtK+8DaGv7IOoEu0nu//dj8xhy9A4gjPteHKUKIsKUE5R194kV8Fa6ODX9fuW6ZERgWOMU+F2K1zXQsfDrC9rjkaJVVE2d5ljk4eM8f20vPnBruxkpCnc3aTYov/meW9I9Ew+9qmUKl9oSJayqkYwU0SegPXe3A7+7gxMnZ8y+alSprqX6ZzKPndpax7k4QODPqlpWBP+m0dPJAcvesgqdj6Xc3Gm2xlpd+vIr+0JrM3mT1Ni2TgAJNaWRi/OU49f+Z51AJfwVOWX9BuUEriXVKLE5F9XeC9f/7q/hDSAGJCWw4SyUunFqD6GcOPCPzwpjo+Xb/1ItNWS7MqsQPtl/4LcJFuSWUku5kRXpfY59NYYc+f0nTu+ssmPasEbreHW2VmfNrTf/a5epHC4T3Aiw7mVdcw7mVMS27mLMY8J8+k6vvQRoPjGh11KvmpdiVPFWOJfaX99Xs2Hif+4Qw2CxdOFT1uCFn8wKGShRFSg3inPmVTEfk2rVkbp9kNEuWcY6jIKyczlYgOBBYP94/iHlLrNTLHg7fbUnzH+lrdPZnpWrdF7i0mwkgtUQ2BC7Cyb4C29OK3vOKcEyTI/DP3XwrhipntP3a9FSSEwYYXdX4dwu8+grvDlA+91iVFdPC85HorMioZ/dNL2gL8vXnceVoHQaPTZKdPQ+80yFmg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(366004)(346002)(396003)(39840400004)(451199015)(478600001)(316002)(5660300002)(36756003)(2906002)(8936002)(6486002)(66946007)(66556008)(110136005)(44832011)(83380400001)(4326008)(66476007)(6666004)(38350700002)(6506007)(107886003)(86362001)(38100700002)(52116002)(1076003)(26005)(186003)(6512007)(54906003)(2616005)(41300700001)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RGc1ZFlIOU90K0ZKTjhieVNYa1lxWUdzSEtuZ05Ycmo3SGlaVEVZbjVPNmFa?=
 =?utf-8?B?aGs1WnNXY0NEQUhNYnJjV3ZmbGNPR3dua29SNk1QMVJ6ZGFVUWNOMVNNYVRK?=
 =?utf-8?B?aDgwQUVNTyt2MWkyWXpyTGwwWDNTaUJlR1UrM0dRVkI0dkhFaUNKTExINXQ5?=
 =?utf-8?B?QnNsZ2ZtWjdGaTdDRlEvaTVRajhBYlV2cWp0cmFqYUlBa1AxV0xUL3pZTEZG?=
 =?utf-8?B?RU1vMjYvMkEwYzBGY0FkY3craC9TeHpPekpQaUt4clZEM3orcGE2U0JaY0FW?=
 =?utf-8?B?VDJZT1d0Mk9RekVKUWV4Nk5DMk9lSC9GcnFQZUYzNjMrdU9KbU1mRXJmNDda?=
 =?utf-8?B?NGx5ZCtYemlmcmpHbjRkQXBQSm5lSDk3TGRQUjM1YWkxVzZIb0tXYm8rSk1H?=
 =?utf-8?B?TGdSNUVWWTlJRmVZT3hnaE1GdWtnN3dIeDNzbk1VSG0rNWRkeGR4cHQ1SElw?=
 =?utf-8?B?SU5sZEJmQk15eDdmMVBnV29pM3FMNkQ0NVBORmRlaUt6M3lKNXQyWGJQS0l0?=
 =?utf-8?B?VGo4SGhTdXBNWjQwUXlOZGs0bmpwTVRLc0MxUnB2VzJxUDVuTllTRDEycGdP?=
 =?utf-8?B?cFZOWkdib0ZycklVblBsOHFoclZ1cVdCQnNWSE5ReVFvRUcrQXpXOWdoQnY4?=
 =?utf-8?B?RXFUZ0tucEZlajV2WmJMNURtazNneHJ3Y1hIT3dvajNSSVFPWHk4VUF2SEM1?=
 =?utf-8?B?ZitHMmZISzdJY3hhRE1GWSs0NzRaQSsxK3d4WGtTWHBtTTQ4bHV4bGgySUt2?=
 =?utf-8?B?L2dTaUFJSHVPcUk0c2czUW01elptSTlyN3doK25FM0I2NVpnZUM2V1VKYzlD?=
 =?utf-8?B?SzZaeGJZZldXaW4zTVpXb252TlpoeTA0dzh1cE1wNzVDVTNCS2lWOTVyT0pl?=
 =?utf-8?B?Vnd5cVNMT3phaVBCODMwVk1BNUdCZVlhVUR2Q2s1Tm9GOTk0RkRjOElGTEVU?=
 =?utf-8?B?czZ4YlAvUGRwWG03NGpVak1ZT21NSSt2b1pLN0o5cmF2WXVIWHIvQS90ZzV1?=
 =?utf-8?B?Qm9MazcyZzI5T2cxSDhMd3dNTVRoMStPQjJmaWhVSE5lRHY0WUNvZVVwSEVa?=
 =?utf-8?B?dEJiNkEyUXZEUkxCMmRDcm5ITXA1M3lmQVkyVW02NUlxOTUrNGdsNHZEYy92?=
 =?utf-8?B?UW9ybGFaajhNZVNSRXh2THRVUGw4SkRDOU9TREJiY1NCZEtPNzh3cFl3Tkpk?=
 =?utf-8?B?OGNSZ25jc1NReVBpN0phTjFGOGJRM0tNTFJTRHk5N25ZNFJSdjZXYjlMQ1pv?=
 =?utf-8?B?QmppZXZNZitVZlBKK1ROMjVDcHg2UmdtR3dmQTNNNTdXM093bjRHdnd0WUNj?=
 =?utf-8?B?REFYU2RVeHBNekZUd0kvdlM2RndJa0JVZHh2N1FLVlZndzlQOUovOFRyR2FN?=
 =?utf-8?B?S2QyalpqSEoyakpWQm55ejZCeEpFcHQ2S0dadlpJMUxTR05MTzM3NlVVTkFP?=
 =?utf-8?B?aXp4YjVkclpveHJQYTkzOGM2UElSZ1hsQWdPZ2FiVDBWd1dqZy9iMTMzK3Y0?=
 =?utf-8?B?eVYzSE5YbE1mYThmRmx4c3ZRWGV3VlczRzJlY0ZlTzlaYUFjWk1MUEE1ZmRP?=
 =?utf-8?B?OTJnbHZ4YXEwY0V5UnlFSXFBbHkxYktsMFYyR2ZUYlI0bUpLakgxTXNzMERp?=
 =?utf-8?B?UnF0aTJtNWZZLzRKVEVOVnovUXNwdUNSOXUwYWZ6TEVQbjcyVDhLejh6dWd3?=
 =?utf-8?B?OWhNcDlaUkpVYUU2bzJHN21xRHNUemUxWGtWWC9Nc1VRZ1F2L1JZT2phazBr?=
 =?utf-8?B?d25kbmxYUk12ait5anRwOUhqRnNyMjd1U2ZBaWZuOW96UlFkcFd0U2dxcDMv?=
 =?utf-8?B?NkVCT0ZLT2VIT3hEcEpLZ0Npb09wWkVMU2Z3cnN6c0x5NW5CZmpDVm94OVVy?=
 =?utf-8?B?OGFMN3lmNlJYaEREVzQ4SGF6S3VCQnpNcHFnWG1oRXlHbEZhcVoybDczSU9I?=
 =?utf-8?B?Q3JBWXBQV3BiejRNT1Fxd3pycWJIc0MyanpkeFl6SU5jS3ZkcmZLeXhZTXZF?=
 =?utf-8?B?R1ZZMWpsYTlweFA5UGsxVGxLTTdzYm9GenlYYVJhNHU1OGhwSjd3RGM1alZq?=
 =?utf-8?B?OTF6VTVKQmJRM3BDdHpMeFZ1YVVaMGJ0czZaM1B0SG1xK3Z6L2JxeEpZdml5?=
 =?utf-8?B?dTREMEV1RjUreUNHUVAyZGQ2bTBIcUx0aEdWbktFQ0tFZlZGSlNuQWFuejZO?=
 =?utf-8?B?ZUE9PQ==?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc768578-0833-48e6-7f64-08dac28dc492
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2022 20:05:37.2490
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lbG2STsZ3QS8Pzv5EeWRegTu+l/gwbvW/a48rPIBIp37Zd7mxpm6/TwIBZp8MgogtSi97G6ZPbK35QAQE+FIKA3ZynPlF0CP983Y6Fb+ea8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5570
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yinjun Zhang <yinjun.zhang@corigine.com>

Set irq affinity to cpus that belong to the same numa node with
NIC device first.

Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Reviewed-by: Louis Peens <louis.peens@corigine.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 8c1a870bc0e5..184ffae2ac94 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -735,8 +735,9 @@ static unsigned int nfp_net_calc_fl_bufsz_xsk(struct nfp_net_dp *dp)
  */
 static void nfp_net_vecs_init(struct nfp_net *nn)
 {
+	int numa_node = dev_to_node(&nn->pdev->dev);
 	struct nfp_net_r_vector *r_vec;
-	int r;
+	unsigned int r;
 
 	nn->lsc_handler = nfp_net_irq_lsc;
 	nn->exn_handler = nfp_net_irq_exn;
@@ -762,7 +763,7 @@ static void nfp_net_vecs_init(struct nfp_net *nn)
 			tasklet_disable(&r_vec->tasklet);
 		}
 
-		cpumask_set_cpu(r, &r_vec->affinity_mask);
+		cpumask_set_cpu(cpumask_local_spread(r, numa_node), &r_vec->affinity_mask);
 	}
 }
 
-- 
2.30.2

