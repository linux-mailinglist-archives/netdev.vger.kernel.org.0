Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A00086D429A
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 12:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231749AbjDCKxl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 06:53:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231995AbjDCKxY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 06:53:24 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2079.outbound.protection.outlook.com [40.107.22.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 588D6619C
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 03:53:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GNXjDSo13pR4LXfjdXoavf+nFHNogac4TQvhMHErRKGGgynq+SFHzhftPQ3IX+tJjklP6VF6v90oRahmqB6mXhosvOGKYPYBS8NFeKWzV7vxlgx7Lq+8APLFAp7rjXqnrDiS0HokibL9ou4ssyxUu8kH/e2j4e/3XmHJVhnD71SVrAGl6LzfGcghZC5W9YlxXNXAHceeVU/UrM3csowno3ZWs27MxZgCTHF5qEMhewkD2pmB4GLl1CBaf4hCK+FfLrCiOh+tqH9eJKhXPcBWWMcae1CyLxIMlDhwUKBYvqkMPVMwi+A+htqfUboxmJj/hPRfpEfc2Durpi+ySeK6qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hpIW2lHarDb6sg0pqNvBFVdZVD1VCq1fzEzW1lgFgAU=;
 b=DFSEyOF6AXpev70Jjfd2VnJNTnACKlQn/qCvLZKQT0jCY57dZbG05pPVHH2/2UJsInNHP4vAtemtKT8+L09gO0Tcdxl7mbvI5UuI/7gixNrFtvWDBpQDoRs0y55yL53AYL9bBSqFfso2hSxBuwqAUrlVXhuX8EW2cyQhLBRBWQhlh3czFz+X8fBBqKb1hAoIl+USHSsfcMHLCOh4ACCuSCbjws/Z3lKV7cVzD2coQ6T+OmDYXwWV5Px3j2ourJk6k76EEo5OmC6LYEWrfNAxWcsuT29r0dDKFjqnSFOVqg0svgN78bs5hMQW1frVoIuBr5IRRVEU7EGt3L8YIeW6jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hpIW2lHarDb6sg0pqNvBFVdZVD1VCq1fzEzW1lgFgAU=;
 b=awAkuYQVffN5ex3N1H1YMmbb1IkGCpA7jA965IoetZOtVondgs/zCLdP7CCQb0fmukn15JYnom1OmJ3ZjxrVOO0RypEcBzW+bEyyM/h44LospyMRwIYiDjhY67vUwricCbgeLn55O4tt7VGsxD94DqvEEylCrmA1f9m3u48frYY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by DB9PR04MB8479.eurprd04.prod.outlook.com (2603:10a6:10:2c5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Mon, 3 Apr
 2023 10:53:05 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5%3]) with mapi id 15.20.6254.026; Mon, 3 Apr 2023
 10:53:05 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2-next 4/9] tc/taprio: add a size table to the examples from the man page
Date:   Mon,  3 Apr 2023 13:52:40 +0300
Message-Id: <20230403105245.2902376-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230403105245.2902376-1-vladimir.oltean@nxp.com>
References: <20230403105245.2902376-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FRYP281CA0006.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::16)
 To AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|DB9PR04MB8479:EE_
X-MS-Office365-Filtering-Correlation-Id: a7e618d2-f626-4883-1f21-08db34319a62
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rJj85wYxFaRwpsL9/sDV5sOCnwvkmNc3Ac84lNVIRUEwA3svyTGrdeHgfKwFqfLaVuZqNWQeEaeKxh+0alrgrKFglZSGFDX3vIlVd2yxESfh+c5UVpmguo+fYwpEuLImtjrkAY2S9Wd1Acph4MDEnqLI/m9KwsQ8n3/hRw5dqx4zxtIF3xwLxz8J1Irh7MPtgxW3FjxFkpCynhIamfAHp/FbGa4zW0gTIiP8j4k8Tn32u+RN3Jy8NcAiRFvJvH/7FYSz/lTE5RcUUblC1uQ/lNQovfbT8sVQlxqK1ZNRv29tMXy7Hzw58C3k6SYdOZFlqwsF5i1nqkZ+69e9M73kQulZ0SD43pVm6hnNcvlIrwu3R4ye6Z1gfBWE0tbyWehJDw5oroU8BKevoxt/ueOkdspOA0rzeErXJ4m2ETrNaeCV5+BsZw7OiAVP03urKN/0LQXyctXApII1hrf4OuvfYAgtMA10Z74jgy8yTUvsdBhKy2YBkvARLdlQXEuaWTgZ/R0OdY03wdzBX9p7ugNHfqtWhAkgDs5qg14qAj912Efq4yN8wlpeAOXRYdnpgHpLoLOfsDOKkCD1uSGzkcdvpH5LOQ4FLsHXHiPoVdGfWXj5Q3czjSwUkoPbU6y3lLnr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(39860400002)(376002)(346002)(366004)(451199021)(8676002)(6916009)(66556008)(66476007)(66946007)(54906003)(316002)(478600001)(8936002)(44832011)(41300700001)(5660300002)(38100700002)(38350700002)(4326008)(186003)(83380400001)(2616005)(52116002)(6486002)(6666004)(1076003)(26005)(6506007)(6512007)(86362001)(36756003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vY74K1ymgVqf7PHT5hhIjCrF+YuiMoPq19ecLCeHOxnpXWOyJ0C1W84Lwptl?=
 =?us-ascii?Q?aFPvLX8eqK28sXiRcwJv01+brYLjKhjYhmWwFq3OhNJjQZ73ovcOcdjf+oGb?=
 =?us-ascii?Q?Ufziq24FoRsREpZFBYCKSj9zCZ1epIhxUP5/YG/ZfnE1USqCdmrznYGHekG4?=
 =?us-ascii?Q?NiSTd46F+xDbiaoEQpkbMDpi6NZrf4flUSsUKPfc++ySnKx1A7jL/w3dV/jg?=
 =?us-ascii?Q?4rRIDJXsRhdqizEzqVFibSpPNk1rzy2n9MhPBNl7sx2/OW6SONYOZu6gIvSk?=
 =?us-ascii?Q?00voluc1DEk4ciXQh78GuM3m99/Gc8cICEdIzjTm523FqoPDhk36QDB1DYPl?=
 =?us-ascii?Q?et26PAbVXIiQMxIMKEaylganV/Tj7vG+j/0lAKwNNN2wgiQh5OK1G8dAJJEB?=
 =?us-ascii?Q?qgGaSCnX2ixbqFy1/mJ23+2KlnobAc2gSi8v5HiipulpiBmEBYTSXFq2U7fI?=
 =?us-ascii?Q?TPbrEv155C9/3I/I6pHRHU6Wa0NLP8P2SC6474pqmUjdZlVOgweqmoP0D0v8?=
 =?us-ascii?Q?icHxsSz/lQrNU46DUb1CyaQEhQ5AeVaRo/64wcjbJICAgQXPz1hrjWcg3rot?=
 =?us-ascii?Q?5o/AjhuNoNQU7mwbbhQXnVyTV3NgAfJ7wVeDlRx1PSL/sLmbYhI36zDNs0ud?=
 =?us-ascii?Q?xGlS2JuhkWMQsQXhBC9g8e5IWCu5BBbwG9QeSMWQ4vIkTYR8VoypyaqcofGV?=
 =?us-ascii?Q?a5j1TEMdOgoSO0lPmDNsAjCIyTuZTpVOy8aIBe31lNIWkhRT9SSOmrOGpjS+?=
 =?us-ascii?Q?VqDf7Jk48B5bBaroV/RwCKPT7UkLNsKMX/9rKfqI9xVHlfhQUafJ72KuwmPM?=
 =?us-ascii?Q?SU17ulqCibiQLu84oCxhBHiaLwLz0XaIoS0nJ90YCk/xsvtbrshRSP5CdE2K?=
 =?us-ascii?Q?SpWJGn6yGwZ0yIqNvwH/6dll2zparBEq0DbOny65HsOspyhQQ7PIrYPSaK07?=
 =?us-ascii?Q?p9BWhoD6xfARwbE9kkuMLe2tVCv+eSKqmAEolwcvpcGaTwe6w9E1A16QPVDV?=
 =?us-ascii?Q?HgdaV6njVH0YeXUMiUyAF2Yl0EdPe1DdYGY68I/sC8wBv8DZfhASlpTo138e?=
 =?us-ascii?Q?e0N1P9THGLJ+527IjPwze7InGgp/3p047Sfo9ZFMfVdQKjFbdsh/EbfzJBsy?=
 =?us-ascii?Q?Kv7dOymtGf5D1Uqjn1Y8G2IUvVwp+PWwl8KLGiXLCbbOhaFRSma8kcJHQTUy?=
 =?us-ascii?Q?BvXdoJyuhNaPx+OLVRulJ9zF9tyitnZ1FtFJ4fNQu6YyV71vZYPSqV1kH1J2?=
 =?us-ascii?Q?kkziUVwypat2QvDUU0xZ6eMerV1VMgRHUFftryA4NGAuXOI8EkrQKA/Fbfe9?=
 =?us-ascii?Q?pdq8+QdK14O5LpgnLQ1ZA96RA6vYJM2wLbFgrCd3RDivA911PI0/Cg+8fC8A?=
 =?us-ascii?Q?8A81kBY4pcGsGHjd6JQPMEBNdOvffKafE1sG5+Oweyh1ckbWF4UITtq9i4sZ?=
 =?us-ascii?Q?alqbZ0kkOl37jvt8p65gYbdNeB1GMVS8Ngd7mL+IcYA7YXXZIF/HieDHSgKX?=
 =?us-ascii?Q?IijZ96AlVW9kxFWixqUvcfRAgE+8Uy5i8Ls5ibmBFmD2ognbDoRgKqzxZw47?=
 =?us-ascii?Q?4xHnEQD7OaNVjYVV5PozZGtwVVHkTKXrM0j30FlRSrP/UYiV4S2xC5/qF5Di?=
 =?us-ascii?Q?OA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7e618d2-f626-4883-1f21-08db34319a62
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 10:53:05.2871
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6vzDl7oKZf8tWH0df6O7lv2RMZdSd1dTz2/aSizdVYRHZFbocCxx6Ao5eYjWv+R7nZbJvQoqqtYy0T70zet7PA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8479
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since kernel commit a3d91b2c6f6b ("net/sched: taprio: warn about missing
size table"), the kernel emits a warning netlink extack if the user
doesn't specify a stab. We want the user be aware of the fact that the
L1 overhead is determined by taprio exactly based on the overhead of the
stab, so we want to encourage users to add a size table to the Qdisc.
Teach them how.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 man/man8/tc-taprio.8 | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/man/man8/tc-taprio.8 b/man/man8/tc-taprio.8
index 9adee7fd8dde..c3ccefea9c8a 100644
--- a/man/man8/tc-taprio.8
+++ b/man/man8/tc-taprio.8
@@ -177,7 +177,7 @@ reference CLOCK_TAI. The schedule is composed of three entries each of
 300us duration.
 
 .EX
-# tc qdisc replace dev eth0 parent root handle 100 taprio \\
+# tc qdisc replace dev eth0 parent root handle 100 stab overhead 24 taprio \\
               num_tc 3 \\
               map 2 2 1 0 2 2 2 2 2 2 2 2 2 2 2 2 \\
               queues 1@0 1@1 2@2 \\
@@ -193,7 +193,7 @@ Following is an example to enable the txtime offload mode in taprio. See
 for more information about configuring the ETF qdisc.
 
 .EX
-# tc qdisc replace dev eth0 parent root handle 100 taprio \\
+# tc qdisc replace dev eth0 parent root handle 100 stab overhead 24 taprio \\
               num_tc 3 \\
               map 2 2 1 0 2 2 2 2 2 2 2 2 2 2 2 2 \\
               queues 1@0 1@0 1@0 \\
@@ -222,10 +222,11 @@ NIC's current PTP time. In addition, the MTU for traffic class 5 is limited to
 200 octets, so that the interference this creates upon traffic class 7 during
 the time window when their gates are both open is bounded. The interference is
 determined by the transmit time of the max SDU, plus the L2 header length, plus
-the L1 overhead.
+the L1 overhead (determined from the size table specified using
+.BR tc-stab(8)).
 
 .EX
-# tc qdisc add dev eth0 parent root taprio \\
+# tc qdisc add dev eth0 parent root stab overhead 24 taprio \\
               num_tc 8 \\
               map 0 1 2 3 4 5 6 7 \\
               queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 \\
@@ -237,5 +238,8 @@ the L1 overhead.
               flags 0x2
 .EE
 
+.SH SEE ALSO
+.BR tc-stab(8)
+
 .SH AUTHORS
 Vinicius Costa Gomes <vinicius.gomes@intel.com>
-- 
2.34.1

