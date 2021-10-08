Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93B4E426FA6
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 19:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbhJHRiB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 13:38:01 -0400
Received: from mail-vi1eur05on2136.outbound.protection.outlook.com ([40.107.21.136]:58709
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231234AbhJHRh7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 13:37:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WelYzfUrwbAKcgKimHwhRbJ88c6piRZn53gX5j+C6MdnQ6H5sAAP+bslEaFnjfpJWhBTDx1UBUzZeF7lDRx5jWu+25tnB0un9MC6T5hWsfDRs1akZHoew0yLcsvA/0FNw+mlymfCnbiyHXxY4k2UYrx05ojuvPHNnMopFW/2Fp0hUm83eMi8oAuQa1x8GbNQCwN/h27sI+6afTGEwF1/C0e9sh9zS1KedtJJv01MYAw5NhKjfpoXCmWc5X7BGiSY9WMn6+B0GTrE3pUFnuLmGK2BdyxVvjyVjoNjmI413knDOOjaQQuIfbbxdnJr2FQ8a0ZNO95eUa/0Q3I+/fKa1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=galv+I47unVH4pSp8/LAGBkYnGfmUN0jXOmAXO8Z5rU=;
 b=EigYJZmomc7A5QJ3LP/NS9CwdpXrNgF0fmhCs8O3dDtia0OZYNq/mJKR/l0eSHm8VzTV/KTTjGDEdpcI7QMiYyJZ6B/c1sSNmXPHp+m+LHPpCRaIeSfJGS2WlYfRu9dJwEbAZU+RX9m8XH6JQVta9PNoS5aqYOAspD4aOI51BPEZGbXF2YzAmo94JNH280lwa5wIFikXM8dBfCTLgaCAn7nEXO++LaJ8PNJLuYZ6UlkRpx4J0HlC5OHa0P3Qj5QzEOyjcKV0ieUYxi/Iw1gRVpUMsM4daRJBfINvJr00g4ZP/uRSP6jEgcV52iZY2YYj4y8tjoZilSZ+UL3HjULjeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=galv+I47unVH4pSp8/LAGBkYnGfmUN0jXOmAXO8Z5rU=;
 b=rKHNhGR8cD1B3/9o1wld61cCd8QEBlUn1B17QvdzDz3IAijvEHaNrE5XurxFNuKmAd3hDGbTrPBAdjTduesMW9pE6Qa0h4n5AudySAbAHQofyFMuHySFDVWzSS5feGvV0JlpxLqA8244is04xZL1CsNNMCd+2zu4umdWdbCeu60=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=plvision.eu;
Received: from AM0P190MB0721.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:1a0::24)
 by AM0P190MB0578.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:1a1::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Fri, 8 Oct
 2021 17:36:01 +0000
Received: from AM0P190MB0721.EURP190.PROD.OUTLOOK.COM
 ([fe80::e0ef:543e:4a22:7639]) by AM0P190MB0721.EURP190.PROD.OUTLOOK.COM
 ([fe80::e0ef:543e:4a22:7639%9]) with mapi id 15.20.4587.024; Fri, 8 Oct 2021
 17:36:01 +0000
From:   Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net] netfilter: fix conntrack flows stack issue on cleanup.
Date:   Fri,  8 Oct 2021 20:35:26 +0300
Message-Id: <1633714526-31678-1-git-send-email-volodymyr.mytnyk@plvision.eu>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: HE1PR05CA0338.eurprd05.prod.outlook.com
 (2603:10a6:7:92::33) To AM0P190MB0721.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:1a0::24)
MIME-Version: 1.0
Received: from vmytnykub.x.ow.s (217.20.186.93) by HE1PR05CA0338.eurprd05.prod.outlook.com (2603:10a6:7:92::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4566.16 via Frontend Transport; Fri, 8 Oct 2021 17:36:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 24436cee-304e-4422-ac32-08d98a8218b0
X-MS-TrafficTypeDiagnostic: AM0P190MB0578:
X-Microsoft-Antispam-PRVS: <AM0P190MB0578A81F7780C4BF7E19EB5D8FB29@AM0P190MB0578.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MsWdFpTagVr8cWzCR27zPdBOfQFXuRf3rGpdpgzvMfXhe8660w975M5h58MWBwf4okuJPfnfrB0pMFtziZ8R31A4Zy7BQLG/vUuhlFkm4dYJh5uqOpnnYgN5hr45pNGnJyghl4M1D+lAAHaTywdFRR0CoxdApQIc6bcWODdKa8lEifMDUf6ZWNJXTTwtGI7LvenYG6bsl9fBwjBUZGUAEfS/JWx60CYElUegXpPHoFjB6b6jj+ja/oPNKuRmkZdb+YR/zDyfeoc1OAOOEtqNCk1Kmu8t1KrlXDC5YWHQ/jonkT2lDyYiMPHolN9NeSbzM0MMOWBmNbOQfMzDbvz5H3h68dSF/vRVoWhgkAkmyhJ/KXM6ms4iVOna9amTDsAno600AgW3hmzrwU++v2Sk68dMpvg8SMG6UcAK3qVo86yQt1DltTK9JMDU6c7/0evJ1RABwBvG11Zl1Mj3oBpAupBURPjObLZKNOSuzzU7NGqnB+N/pUZsjx6Wyc9c0TipoYHaRwqC4Ivcuqm9bvMZEGda+jGWqZxmaArD4xxvVQWS1n3b6E8pfGXth5a+jokZoa5AG8k0QbZUu1IKL9ZOTijv8s0myDDz3Fs3HvHzcunbR8PKK7lcbhmLT189+hkLdCLkpTsNkEulYGVlcjBiTmCCzICOxt3/dzklyvs8Sp/+FJYCIFEd7bsMXtvN9sLL4/J+n4fOrkvnoCbBT+ci1g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0P190MB0721.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(376002)(39830400003)(136003)(6512007)(38350700002)(38100700002)(7416002)(6666004)(186003)(52116002)(44832011)(956004)(2616005)(6506007)(26005)(2906002)(508600001)(83380400001)(4326008)(6916009)(316002)(36756003)(8936002)(54906003)(86362001)(8676002)(6486002)(5660300002)(66556008)(66476007)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sQlNBgGnBwbkaUIbuGzCs1wh/utOcusON5N2sDPAEEMW6vjFKADkcUiP2tfw?=
 =?us-ascii?Q?FWeyZwrWHDwhbZXYtMzXygz74+3GUDgbGdxKbnp9sH9YSZi+CVlfMMrLIiRn?=
 =?us-ascii?Q?J1f8fQnodldyxVNolAqPsov6ZIs732mjwTQJcDJP7N7dnjRdl3n7Wv8uFA3d?=
 =?us-ascii?Q?/A7G1OVMz3CBY/bTXLPYOSPA7NOmMWTFjUJEr4uG/cBqYjonNfgUG2uWeElA?=
 =?us-ascii?Q?g8RhSFsHs8fu50tY24IsIR3ilejjwByqrmjDTJ+fIKWiDP//iET2nAmumb5m?=
 =?us-ascii?Q?WbUCOM7nqzaCpZ38wrE+e2iErYanoqnbSEkk79cX2StXcSBp/sF3m6qWJKMn?=
 =?us-ascii?Q?S22OhsgcXIxdDoi76hAkxJbohjTgMpp2CBP2/6q68moHwMHAhycyokSFXSrL?=
 =?us-ascii?Q?IEM/CPmzLZZ25p/GtTnxWNmE1WXo7vfu1NhLJYpWWymI/7iMpv+hKf/0R4GN?=
 =?us-ascii?Q?hmrmn6privUHI7eK2YUNZ9XhHtLlOVqjH76OuNs0sYAb+jyuogPI62pI0KjE?=
 =?us-ascii?Q?YrcxEjkaTl1KwcYNoXbGWIvKGKQEiDbu4ue6NH8Bi7R1jFWt9nBHxuOaxt1B?=
 =?us-ascii?Q?3p2CyPsVevOHpVKC1wyV9OV14UFrjaauzI3XGU5piLzDyUqah/Q/mLD03XBu?=
 =?us-ascii?Q?bW4TjZRXYAfz/rx+EKa9x1oinqT+c0FGEewjTbvOnrAz8HKTEwEI0vhNTAxH?=
 =?us-ascii?Q?1iNs7NpDnUQhe6fqabtzkTwKZOym2e3FZYO1wTsMHGHbBGKZZkaVWiHdCuNl?=
 =?us-ascii?Q?1+1uNiuGr8F05C2MF6x9NW07jBLMwkEJhLcRFLoCGwO37i6RV7wMjpbKpWGC?=
 =?us-ascii?Q?nfOQGQitvO5IOhGaN/qmrGcwJO6DuuZUMOjjm270Wt6ksu1FpkiCJQo2+eMi?=
 =?us-ascii?Q?89TMlNHToA+Sk9Zu30uF+BKtJbFC0inbYgns3PX7Kngso+NHBpI8QYlt0eSV?=
 =?us-ascii?Q?LLE6pOKDKWNW8DOJ9L09jsKx7Ucu2+8IoHFZEe+ZnWhhXmtH7EWFjCQpJIQL?=
 =?us-ascii?Q?PT4CbBUObJCwX02UuFukl96GJ5IzThVIfiUYCx2NOZNzV2zwvzYEXShYgV9X?=
 =?us-ascii?Q?4uXu7e2vzzgULnoihPcpev1HpsmlhDfLFz47RofMLLqLs3XdPueIBPKriMOS?=
 =?us-ascii?Q?3lx2ZDGebzgKaSV/gn6Srb+q1alzHzoRkHjxZlkZu6psEn4uUGTszOPNQT7O?=
 =?us-ascii?Q?7bEBr0sFpKJ3WHT8KfZomMpPpE/HawpyZN8ck8I5CAnv6t8FQXT60xikplpT?=
 =?us-ascii?Q?udXCGm4HbBIBrZNg3Em6Kr13/0ONO4yztpa66y0RU/oeMdsOrxJwCjJsJB1M?=
 =?us-ascii?Q?7LohRiqGjfrlfNbnyS9MwrkJ?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 24436cee-304e-4422-ac32-08d98a8218b0
X-MS-Exchange-CrossTenant-AuthSource: AM0P190MB0721.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2021 17:36:01.6290
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xRifkCAogefSyQDr1GT1jz7VZ9tRU4Vvj1w0YOTpWHq+TBuOzAA45/P3vbLb04j99NMWgUh7W1kErDm4lwc/YdMm9SBMtNUPyCT7J9/0l7U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0P190MB0578
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Volodymyr Mytnyk <vmytnyk@marvell.com>

On busy system with big number (few thousands) of HW offloaded flows, it
is possible to hit the situation, where some of the conntack flows are
stuck in conntrack table (as offloaded) and cannot be removed by user.

This behaviour happens if user has configured conntack using tc sub-system,
offloaded those flows for HW and then deleted tc configuration from Linux
system by deleting the tc qdiscs.

When qdiscs are removed, the nf_flow_table_free() is called to do the
cleanup of HW offloaded flows in conntrack table.

...
process_one_work
  tcf_ct_flow_table_cleanup_work()
    nf_flow_table_free()

The nf_flow_table_free() does the following things:

  1. cancels gc workqueue
  2. marks all flows as teardown
  3. executes nf_flow_offload_gc_step() once for each flow to
     trigger correct teardown flow procedure (e.g., allocate
     work to delete the HW flow and marks the flow as "dying").
  4. waits for all scheduled flow offload works to be finished.
  5. executes nf_flow_offload_gc_step() once for each flow to
     trigger the deleting of flows.

Root cause:

In step 3, nf_flow_offload_gc_step() expects to move flow to "dying"
state by using nf_flow_offload_del() and deletes the flow in next
nf_flow_offload_gc_step() iteration. But, if flow is in "pending" state
for some reason (e.g., reading HW stats), it will not be moved to
"dying" state as expected by nf_flow_offload_gc_step() and will not
be marked as "dead" for delition.

In step 5, nf_flow_offload_gc_step() assumes that all flows marked
as "dead" and will be deleted by this call, but this is not true since
the state was not set diring previous nf_flow_offload_gc_step()
call.

It issue causes some of the flows to get stuck in connection tracking
system or not release properly.

To fix this problem, add nf_flow_table_offload_flush() call between 2 & 3
step, to make sure no other flow offload works will be in "pending" state
during step 3.

Signed-off-by: Volodymyr Mytnyk <vmytnyk@marvell.com>
---
 net/netfilter/nf_flow_table_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 1e50908b1b7e..0de79835f628 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -638,6 +638,8 @@ void nf_flow_table_free(struct nf_flowtable *flow_table)
 
 	cancel_delayed_work_sync(&flow_table->gc_work);
 	nf_flow_table_iterate(flow_table, nf_flow_table_do_cleanup, NULL);
+	/* wait to finish */
+	nf_flow_table_offload_flush(flow_table);
 	nf_flow_table_iterate(flow_table, nf_flow_offload_gc_step, flow_table);
 	nf_flow_table_offload_flush(flow_table);
 	if (nf_flowtable_hw_offload(flow_table))
-- 
2.7.4

