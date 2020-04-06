Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26F7419EF1A
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 03:26:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727968AbgDFB0c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Apr 2020 21:26:32 -0400
Received: from mail-bn7nam10on2109.outbound.protection.outlook.com ([40.107.92.109]:44264
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726408AbgDFB0b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Apr 2020 21:26:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BCuuCvmphKT9aqHC38gTGxShPrhuQ9y3Sa9jlkXc0kPTJQnJNyUMma/bR6Y2R0faGGzbjYTzYouRVKBd7VsxOP5MDtDPiS/sBeYZc6GP2jW7EC5GQGx40foq3UWQkG2AWxjm7Bu8ifw+MStZhTlrYJl2QzgD+GOZx/3ajZTxZ1O8ADApT8/w5DGkskx0aSNyQyqSqx38qmCTJ5ZAFUSxQDJlj66v21Fw5Y616Zf0d1XrlWWRhmfBtTSkvidY2LRPujdrn01xjVd+Bu8SlwB1vORgXGEzTyJe9PFSMflqH31zw08WxA+QGDC5OBmDYmX+qd1E++dqfABnHyJnROvGiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QLB13bA0uvCPI607oMAf7Q+lgm73dUZWM3dhhAJgCMc=;
 b=C0U5kWBhnFSdOa4jgwGxtW6GcTIhSo1OXCYtrmMr7+X96P1ofISIR1XoP3t2HF4cy1cxr8VqfOp4eAgNMt6+wcIH7LOzjKVSMJewy7sluijMHKwwvoSaW58JzIrIsPtUTlK4VbwUXLIiTEt8CZIAw5DlWzYJ4vkS7fsJs7HdjHqefg7c7YXgYJqCSyEx4GDhnaXNDVlpD9zrdpJwqiCMRxio8xdvj+b4ZpyslEupqWSIM5pOF2Q7OJD6QP/VvHnr+louNM318q+7eK5OWa76u3vtVwY9ci0izIJ8bsE2rXr6+3FAG7gKKrnC/qpPDZbV1Cju5h1XwoHtPTii7VSEYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QLB13bA0uvCPI607oMAf7Q+lgm73dUZWM3dhhAJgCMc=;
 b=cULW9odsO/ro1A0irhstGd/4fzmqiPDN45Ws5ZQP45g4cRUcpVtJ6tSYMJ/gKtsRWQg+BgX71exBtgKgawwzD6ROsqgST3BDUxQuGv7lvjd47BTf1lU81wiQL+tHWgp2YZ8ryAXXMb6wCfMhhlR5bXN8cHTaN+gN+OjPAfoO0/o=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
Received: from BN8PR21MB1139.namprd21.prod.outlook.com (2603:10b6:408:72::10)
 by BN8PR21MB1266.namprd21.prod.outlook.com (2603:10b6:408:a1::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.5; Mon, 6 Apr
 2020 01:26:25 +0000
Received: from BN8PR21MB1139.namprd21.prod.outlook.com
 ([fe80::b5da:34dd:f205:560b]) by BN8PR21MB1139.namprd21.prod.outlook.com
 ([fe80::b5da:34dd:f205:560b%4]) with mapi id 15.20.2900.010; Mon, 6 Apr 2020
 01:26:24 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     willy@infradead.org, netdev@vger.kernel.org, davem@davemloft.net,
        willemb@google.com, kuba@kernel.org, simon.horman@netronome.com,
        sdf@google.com, edumazet@google.com, fw@strlen.de,
        jonathan.lemon@gmail.com, pablo@netfilter.org,
        rdunlap@infradead.org, decui@microsoft.com, jeremy@azazel.net,
        pabeni@redhat.com
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH v2 net] skbuff.h: Improve the checksum related comments
Date:   Sun,  5 Apr 2020 18:26:09 -0700
Message-Id: <1586136369-67251-1-git-send-email-decui@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Reply-To: decui@microsoft.com
Content-Type: text/plain
X-ClientProxiedBy: MWHPR02CA0007.namprd02.prod.outlook.com
 (2603:10b6:300:4b::17) To BN8PR21MB1139.namprd21.prod.outlook.com
 (2603:10b6:408:72::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (13.77.154.182) by MWHPR02CA0007.namprd02.prod.outlook.com (2603:10b6:300:4b::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.15 via Frontend Transport; Mon, 6 Apr 2020 01:26:23 +0000
X-Mailer: git-send-email 1.8.3.1
X-Originating-IP: [13.77.154.182]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b289ad70-8367-4228-ec9d-08d7d9c9854b
X-MS-TrafficTypeDiagnostic: BN8PR21MB1266:|BN8PR21MB1266:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN8PR21MB1266E208C4E27849755C4D0FBFC20@BN8PR21MB1266.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0365C0E14B
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR21MB1139.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(346002)(136003)(366004)(376002)(396003)(39860400002)(186003)(16526019)(66946007)(66556008)(26005)(6486002)(66476007)(6512007)(81156014)(3450700001)(81166006)(36756003)(8676002)(6666004)(7416002)(5660300002)(52116002)(8936002)(478600001)(86362001)(82950400001)(82960400001)(2906002)(4326008)(10290500003)(2616005)(6506007)(956004)(316002)(921003)(1121003);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XYEr6m+sglTm4Kiqqf/an5tXfayaAFtkA8FBE1kidEmIqvn3g67z5YG+TvyBgatRqH7OdXAYbhWFT44+xqk+v2XYeCOmT6ywZ3xPZVUITu/tpBR1mb59PtOf5GEojlckmyjXJTsvP9akdALXvIxMldM0RiKUaT3KDntp0bT+WQXtpAXoCx9N3a4vlseaeb19zxfDFhJdyDbImGkE2TCzwwSco5rS3y+PWLtyhAWqrBTcIpfe8hILEq7eQG+qwqdRzU9aCGMuzK3R6SZHdyKxjPFsdFpODv4sLxvkQp1ZOe0MZkqonFam50muIbTuY3ZJwODSj5vgMRNQV+E0axkRuXb8bqvyDgRaAJ355AvJzulJCZL06Qtquz0LHtPQP7a1nCGzKt0r+YFDXOXFcOqJ3oYPKR9U495KdB1dkMNTUFmt6z+gbFPNVmKviCwSWWJAVCR3RXp6VnjS7DXJZ7kCWOr+wKKuZFK5Szt3gWEA9rVpdnfAyXoHnVZ6oBcm4pmB
X-MS-Exchange-AntiSpam-MessageData: AURUx0JOTd9I7DpPwR0+QEMnrPDwMEGSoGamy66dLTUDtW6jTv7+XUrD57GZSEsam9GiqYGE42Y+XA3xMce12XQXoHGPtP/gF2k5x+qPz0RYRXPuzEqzndln85lmm0RYKuPzpbk15Nk/HXctOSy02Q==
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b289ad70-8367-4228-ec9d-08d7d9c9854b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2020 01:26:24.7691
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gyk/o6cpv1Ewxw3+C3IkTUpqkfEFEmcR4crC3dO0ZNRqVhvh64Y/kBMAzohHmwA3HvINVDCjBSYdPTxl0bL1xg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR21MB1266
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixed the punctuation and some typos.
Improved some sentences with minor changes.

No change of semantics or code.

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Dexuan Cui <decui@microsoft.com>
---

Changes in v2:
1. Integrated comments from Matthew Wilcox, and added his Reviewed-by:

   Reverted back to "supplied" from "supplies".
   "fills out in" -> "fills in".
   Used "it should treat the packet as if CHECKSUM_NONE were set.".

2. Integrated a comment from Randy Dunlap:

   "... ip_summed is CHECKSUM_PARTIAL, csum_start and csum_offset
   are set to..." 

   ->

   "... ip_summed is CHECKSUM_PARTIAL, and both csum_start and
   csum_offset are set to refer to..." 


 include/linux/skbuff.h | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 28b1a2b..16eed3a 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -47,8 +47,8 @@
  * A. IP checksum related features
  *
  * Drivers advertise checksum offload capabilities in the features of a device.
- * From the stack's point of view these are capabilities offered by the driver,
- * a driver typically only advertises features that it is capable of offloading
+ * From the stack's point of view these are capabilities offered by the driver.
+ * A driver typically only advertises features that it is capable of offloading
  * to its device.
  *
  * The checksum related features are:
@@ -63,7 +63,7 @@
  *			  TCP or UDP packets over IPv4. These are specifically
  *			  unencapsulated packets of the form IPv4|TCP or
  *			  IPv4|UDP where the Protocol field in the IPv4 header
- *			  is TCP or UDP. The IPv4 header may contain IP options
+ *			  is TCP or UDP. The IPv4 header may contain IP options.
  *			  This feature cannot be set in features for a device
  *			  with NETIF_F_HW_CSUM also set. This feature is being
  *			  DEPRECATED (see below).
@@ -79,13 +79,13 @@
  *			  DEPRECATED (see below).
  *
  *	NETIF_F_RXCSUM - Driver (device) performs receive checksum offload.
- *			 This flag is used only used to disable the RX checksum
+ *			 This flag is only used to disable the RX checksum
  *			 feature for a device. The stack will accept receive
  *			 checksum indication in packets received on a device
  *			 regardless of whether NETIF_F_RXCSUM is set.
  *
  * B. Checksumming of received packets by device. Indication of checksum
- *    verification is in set skb->ip_summed. Possible values are:
+ *    verification is set in skb->ip_summed. Possible values are:
  *
  * CHECKSUM_NONE:
  *
@@ -115,16 +115,16 @@
  *   the packet minus one that have been verified as CHECKSUM_UNNECESSARY.
  *   For instance if a device receives an IPv6->UDP->GRE->IPv4->TCP packet
  *   and a device is able to verify the checksums for UDP (possibly zero),
- *   GRE (checksum flag is set), and TCP-- skb->csum_level would be set to
+ *   GRE (checksum flag is set) and TCP, skb->csum_level would be set to
  *   two. If the device were only able to verify the UDP checksum and not
- *   GRE, either because it doesn't support GRE checksum of because GRE
+ *   GRE, either because it doesn't support GRE checksum or because GRE
  *   checksum is bad, skb->csum_level would be set to zero (TCP checksum is
  *   not considered in this case).
  *
  * CHECKSUM_COMPLETE:
  *
  *   This is the most generic way. The device supplied checksum of the _whole_
- *   packet as seen by netif_rx() and fills out in skb->csum. Meaning, the
+ *   packet as seen by netif_rx() and fills in skb->csum. This means the
  *   hardware doesn't need to parse L3/L4 headers to implement this.
  *
  *   Notes:
@@ -153,8 +153,8 @@
  *   from skb->csum_start up to the end, and to record/write the checksum at
  *   offset skb->csum_start + skb->csum_offset. A driver may verify that the
  *   csum_start and csum_offset values are valid values given the length and
- *   offset of the packet, however they should not attempt to validate that the
- *   checksum refers to a legitimate transport layer checksum-- it is the
+ *   offset of the packet, but it should not attempt to validate that the
+ *   checksum refers to a legitimate transport layer checksum -- it is the
  *   purview of the stack to validate that csum_start and csum_offset are set
  *   correctly.
  *
@@ -178,18 +178,18 @@
  *
  * CHECKSUM_UNNECESSARY:
  *
- *   This has the same meaning on as CHECKSUM_NONE for checksum offload on
+ *   This has the same meaning as CHECKSUM_NONE for checksum offload on
  *   output.
  *
  * CHECKSUM_COMPLETE:
  *   Not used in checksum output. If a driver observes a packet with this value
- *   set in skbuff, if should treat as CHECKSUM_NONE being set.
+ *   set in skbuff, it should treat the packet as if CHECKSUM_NONE were set.
  *
  * D. Non-IP checksum (CRC) offloads
  *
  *   NETIF_F_SCTP_CRC - This feature indicates that a device is capable of
  *     offloading the SCTP CRC in a packet. To perform this offload the stack
- *     will set set csum_start and csum_offset accordingly, set ip_summed to
+ *     will set csum_start and csum_offset accordingly, set ip_summed to
  *     CHECKSUM_PARTIAL and set csum_not_inet to 1, to provide an indication in
  *     the skbuff that the CHECKSUM_PARTIAL refers to CRC32c.
  *     A driver that supports both IP checksum offload and SCTP CRC32c offload
@@ -200,10 +200,10 @@
  *   NETIF_F_FCOE_CRC - This feature indicates that a device is capable of
  *     offloading the FCOE CRC in a packet. To perform this offload the stack
  *     will set ip_summed to CHECKSUM_PARTIAL and set csum_start and csum_offset
- *     accordingly. Note the there is no indication in the skbuff that the
- *     CHECKSUM_PARTIAL refers to an FCOE checksum, a driver that supports
+ *     accordingly. Note that there is no indication in the skbuff that the
+ *     CHECKSUM_PARTIAL refers to an FCOE checksum, so a driver that supports
  *     both IP checksum offload and FCOE CRC offload must verify which offload
- *     is configured for a packet presumably by inspecting packet headers.
+ *     is configured for a packet, presumably by inspecting packet headers.
  *
  * E. Checksumming on output with GSO.
  *
@@ -211,9 +211,9 @@
  * is implied by the SKB_GSO_* flags in gso_type. Most obviously, if the
  * gso_type is SKB_GSO_TCPV4 or SKB_GSO_TCPV6, TCP checksum offload as
  * part of the GSO operation is implied. If a checksum is being offloaded
- * with GSO then ip_summed is CHECKSUM_PARTIAL, csum_start and csum_offset
- * are set to refer to the outermost checksum being offload (two offloaded
- * checksums are possible with UDP encapsulation).
+ * with GSO then ip_summed is CHECKSUM_PARTIAL, and both csum_start and
+ * csum_offset are set to refer to the outermost checksum being offload (two
+ * offloaded checksums are possible with UDP encapsulation).
  */
 
 /* Don't change this without changing skb_csum_unnecessary! */
-- 
1.8.3.1

