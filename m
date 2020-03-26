Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDF7C19496A
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 21:46:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727549AbgCZUqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 16:46:34 -0400
Received: from mail-eopbgr60084.outbound.protection.outlook.com ([40.107.6.84]:37759
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726034AbgCZUqd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 16:46:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i/HQ5labq36ynIb+wdtDXhxHmwO8kDY1XvTSeNicdoK7bLUqG+g+Sc2HvgBejzniV5KSG7qyGE6JoAnED2biH5kXW2wUv7Vae1o304zH7VejQV5pArsVKM+InkRdu7uj+KeVnIJ2BH9WYIdsZXnpwtV+uQfJwxmcxr8RV/lpTA+x0JLhYPdbVqlE6zr8t7Xr6VTZl8Y2HGRKJdvBkQ+jvFKEkwOST+ne6XNZPir6dy8D4U1pQ4J8MUd2q9NXjgi4LBro1MBrRm/s/vQ2Jtiu7Y23tZYrwYHbPeeBZep7OFonSpUIcJnvpVww156wUF1IFFCGfLBICcMo7kha9EoYVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=idzH4qfUzNZqbA72vNJLX2Ci023acYLLJZH6FfZfV3k=;
 b=FhvqfKzuDszRRauuoD76p14ZRwLGGBhY8eJFVCOvH2z0wlsyTVJcyMXdw+z+iKJ5xHt1JjoY0JZMxY34ESBHtM85Ml8fKUeOmgvMdRZhA2Hs5ZQad/kVLeK2CD+/O3Yzgzf3os/KguknZY4DFSckip1+kvnvF6dEF8iNdGv7WhyK697uo7jcweeYOLQWkJtXChFrXlju1NzZdHI82cpyyz18stxkWWEFFIo6Oppu/IjkdilxPWs3ijWARGqsnJrYAlw/kLUpW484F7SpmIU2BfCtF3EQUgBAwIy97UoI1/a25zAYKlHFKj8+9dCVuoZGf/TvHHbGjnXQUgS4LXWWjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=idzH4qfUzNZqbA72vNJLX2Ci023acYLLJZH6FfZfV3k=;
 b=rAGBcCYHkiYrjTFDmw0J62Gj9XNEB1NiaL6znp+gho+TbqgkvNwjwcw4El+xFua0Y65GGzcKjx267e/o9IZKwJuxpqkDUrifnXUI1hf+sQ4NdWhmYf1YABHRiJYF89HP9/RPncWefELBMLeawCmn466dHpzzdG1j9O3SRu6wRkE=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (20.176.168.150) by
 HE1PR05MB3260.eurprd05.prod.outlook.com (10.170.243.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.22; Thu, 26 Mar 2020 20:46:29 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::e9a8:7b1c:f82a:865b]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::e9a8:7b1c:f82a:865b%6]) with mapi id 15.20.2835.023; Thu, 26 Mar 2020
 20:46:29 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>,
        Petr Machata <petrm@mellanox.com>, idosch@mellanox.com,
        jiri@mellanox.com, alexpe@mellanox.com
Subject: [PATCH net-next 3/3] selftests: skbedit_priority: Test counters at the skbedit rule
Date:   Thu, 26 Mar 2020 22:45:57 +0200
Message-Id: <504a9e0a34dff3fc43296db70e593968cbc5a4de.1585255467.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1585255467.git.petrm@mellanox.com>
References: <cover.1585255467.git.petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR0P264CA0043.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1::31) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by PR0P264CA0043.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.19 via Frontend Transport; Thu, 26 Mar 2020 20:46:28 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 82e66071-21b5-4cf6-c8a8-08d7d1c6c29e
X-MS-TrafficTypeDiagnostic: HE1PR05MB3260:|HE1PR05MB3260:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB3260206B1D8749EC265A5404DBCF0@HE1PR05MB3260.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0354B4BED2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(396003)(346002)(136003)(376002)(39860400002)(366004)(2616005)(478600001)(36756003)(956004)(6506007)(16526019)(52116002)(4326008)(107886003)(26005)(186003)(8936002)(6486002)(2906002)(66476007)(8676002)(316002)(86362001)(6666004)(81166006)(81156014)(6916009)(54906003)(5660300002)(6512007)(66946007)(66556008);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ETLaMjKXsqj29IdP4nAVDldTcwsONAWr369kR1y02DTldtsKTRjc6VyM3PZX/i0rzcw4E50DvWzRtMBM+syohu1EBfeHJ38r+ITr4RGNkngSNsJmCZ3lcgwjNSsmJ3nCLbKWfWHIKq6HOJbYL8xohRlLY2Z4ipuEaHjwx7XJUpcVPs1ExwCPjYTvaRxuCRgw3e0xAy1mRt5qWK7LkAWObKUn2IA0C5CfHC4Y4WS67ABi1pQ7bAqN5DTlj0p4XT9tKM9E+lwuf3Q7PgMTrBLBmkEbbXJOLLX3efrchinI1DVm2CTlVJRqK1y6fTkUZSa+Ed7fWSOKRHtn+jQ37no+fyh/qTpar7w+lGsYPfha6sJ7q9eyjVeQpKvfH3CWwk2ZCYBLfivYiJcVF7zFqX0G1S4CWe2fbSFf2SJqM6OsEXd+TMLWx23E1A1bY2DZZCn2
X-MS-Exchange-AntiSpam-MessageData: RJYu1MapQc+Au1ulXTD8PirGQ6DtiGIY/LS6WU1n8bd2IQSzsXv/L12/4IWp7/sLJ4C9sOQeXpe5V3ctK7v7zGAakRZhjVjYaBOyUip66qNCI6fDi7JGYop7CCeLlR8mZeWjqBrpfyLajSatt3uHGA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82e66071-21b5-4cf6-c8a8-08d7d1c6c29e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2020 20:46:29.8228
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GuAqnB7R2kZRsmtL4aC2RVF7HygqROd6zzCmUnBP3brYKvRi7wUECrkAmpsNJZEfHe39C9XE7bBoF67NA2/kvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3260
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the test checks the observable effect of skbedit priority:
queueing of packets at the correct qdisc band. It therefore misses the fact
that the counters for offloaded rules are not updated. Add an extra check
for the counter.

Signed-off-by: Petr Machata <petrm@mellanox.com>
---
 .../testing/selftests/net/forwarding/skbedit_priority.sh | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/skbedit_priority.sh b/tools/testing/selftests/net/forwarding/skbedit_priority.sh
index 0e7693297765..e3bd8a6bb8b4 100755
--- a/tools/testing/selftests/net/forwarding/skbedit_priority.sh
+++ b/tools/testing/selftests/net/forwarding/skbedit_priority.sh
@@ -120,14 +120,19 @@ test_skbedit_priority_one()
 	   flower action skbedit priority $prio
 
 	local pkt0=$(qdisc_parent_stats_get $swp2 $classid .packets)
+	local pkt2=$(tc_rule_handle_stats_get "$locus" 101)
 	$MZ $h1 -t udp "sp=54321,dp=12345" -c 10 -d 20msec -p 100 \
 	    -a own -b $h2mac -A 192.0.2.1 -B 192.0.2.2 -q
+
 	local pkt1
 	pkt1=$(busywait "$HIT_TIMEOUT" until_counter_is ">= $((pkt0 + 10))" \
 			qdisc_parent_stats_get $swp2 $classid .packets)
+	check_err $? "Expected to get 10 packets on class $classid, but got $((pkt1 - pkt0))."
+
+	local pkt3=$(tc_rule_handle_stats_get "$locus" 101)
+	((pkt3 >= pkt2 + 10))
+	check_err $? "Expected to get 10 packets on skbedit rule but got $((pkt3 - pkt2))."
 
-	check_err $? "Expected to get 10 packets on class $classid, but got
-$((pkt1 - pkt0))."
 	log_test "$locus skbedit priority $prio -> classid $classid"
 
 	tc filter del $locus pref 1
-- 
2.20.1

