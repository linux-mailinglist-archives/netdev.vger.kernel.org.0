Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6DEA19EF3E
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 04:02:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbgDFCCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Apr 2020 22:02:00 -0400
Received: from mail-co1nam11on2094.outbound.protection.outlook.com ([40.107.220.94]:24769
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726373AbgDFCCA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Apr 2020 22:02:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mlPlmlwh+S6yQbGi2ckgyrB89OytZZKq+8BhrNC0hb4OA+t9m7ON0H0L4ZsbCehUatn/nS+EJ289n9y8inQ26NXpOO0T3bgEdu25OM7RRPRamr9XzF06YfVEBJx+MzfLXFTXB8YluTphwPzICu1JafzMwLd3bHYnyY4uZgPnQcBShAwWHWwDm+yn4gmqMqjXf72wJjbZO5892meIEChT+kv2jbH/VfbAlxZvHGuv2dZmnzRDeOkgWFWTcnRiSeSGu/s+hlHugf5PcrCAdWH5YoeX8pp2SXUh1otTXBgrVUGvHEMIElzwgq6SCU9zDjxCtExSOihnNsf+6EuJglrN9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l2YPG1NwyzFq65fcKxG2yfw4fGyg5WXCjYwqHl8bTJM=;
 b=Nf9dcAA3Fk0mvhA8Vc1MZ8IuYCuVtdv7zszmSIEpwmXi91XNcnPBjgxlGlKvHOsoCkJ4o9K7V3yX9mY6F64+Z2W0E+OVi2EuJ4qenDXSVr+IX1afHR71TQ2huNJ3rU+V6pRpd6wS0PJ4svfykG/EAy5V80pKLwuZOYU5/9xoeQ5iDmUnzKfNM0sn9DMpOn7USh50MZQ5YGdytvX+FwyInCzdNJ+thc4pfE8s6GQ0AzMkeumWx4I4uPy9hEfVeGrjAMCGbKlZ6SaGvbSkQfU9VA+9E1S9a4RyOuAXG2pIn+svt/PvqZwI8QV8BTfzGCptwYgJztkUFZog3JouW0pCCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l2YPG1NwyzFq65fcKxG2yfw4fGyg5WXCjYwqHl8bTJM=;
 b=N2PYd9S4hhXJ2e3FFu9modSbbENexCSnO3mS0mgahqaFq2CKE+U6OhkPaEk1DLT3MKdUyoKESQtGGoySFtBRaeoXGSdINV5+lJcYb4RSjolAABWKtq2YM5I7+yzfGWnievPpLb+rHc25KW71x4xVmEJIbaz/hbdlmt5ba+gdnAU=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
Received: from BN8PR21MB1139.namprd21.prod.outlook.com (2603:10b6:408:72::10)
 by BN8PR21MB1235.namprd21.prod.outlook.com (2603:10b6:408:77::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.3; Mon, 6 Apr
 2020 01:59:55 +0000
Received: from BN8PR21MB1139.namprd21.prod.outlook.com
 ([fe80::b5da:34dd:f205:560b]) by BN8PR21MB1139.namprd21.prod.outlook.com
 ([fe80::b5da:34dd:f205:560b%4]) with mapi id 15.20.2900.010; Mon, 6 Apr 2020
 01:59:55 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     willy@infradead.org, netdev@vger.kernel.org, davem@davemloft.net,
        willemb@google.com, kuba@kernel.org, simon.horman@netronome.com,
        sdf@google.com, edumazet@google.com, fw@strlen.de,
        jonathan.lemon@gmail.com, pablo@netfilter.org,
        rdunlap@infradead.org, decui@microsoft.com, jeremy@azazel.net,
        pabeni@redhat.com
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH v3 net] skbuff.h: Improve the checksum related comments
Date:   Sun,  5 Apr 2020 18:59:24 -0700
Message-Id: <1586138364-71127-1-git-send-email-decui@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Reply-To: decui@microsoft.com
Content-Type: text/plain
X-ClientProxiedBy: MWHPR10CA0008.namprd10.prod.outlook.com (2603:10b6:301::18)
 To BN8PR21MB1139.namprd21.prod.outlook.com (2603:10b6:408:72::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (13.77.154.182) by MWHPR10CA0008.namprd10.prod.outlook.com (2603:10b6:301::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.15 via Frontend Transport; Mon, 6 Apr 2020 01:59:53 +0000
X-Mailer: git-send-email 1.8.3.1
X-Originating-IP: [13.77.154.182]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c5af1b16-6825-4a24-edcd-08d7d9ce33c8
X-MS-TrafficTypeDiagnostic: BN8PR21MB1235:|BN8PR21MB1235:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN8PR21MB123534D2E6CA450706A1AB6EBFC20@BN8PR21MB1235.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0365C0E14B
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR21MB1139.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(396003)(39860400002)(346002)(136003)(366004)(376002)(4326008)(36756003)(6486002)(6506007)(66946007)(82950400001)(478600001)(3450700001)(6512007)(66556008)(66476007)(86362001)(82960400001)(5660300002)(2906002)(52116002)(8676002)(26005)(10290500003)(186003)(6666004)(16526019)(316002)(81166006)(81156014)(2616005)(8936002)(7416002)(956004)(921003)(1121003);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DW1ImMxgUsrevgWJ+3S62TUnC1enWifNB/wf8DeRP8lZdpfLrAeZZxGGOz/drqf+1f90sEC8MWz/Ye2P0FCns6qXfMzVzppIdl4fBM4zpIUDnhAtQW6RKwwOQILF3urFJCoNm8AEr3BUyQpFONsMQ+kcoxZV79sOgaAME1Sf55zorEv/MBEeOd9IpJ803ea5hFynT7ZHzgJqRNjsboAjdrCRcRNlXpxF5IE1KEzCjKBm9rE7DPvIqrQMhq5kY+tzSxmRRthTaYg0SHjT8UYxEXPO8lBjLN4cm96xa609hyDkXC0ZY80pOEE8Nzuce/Kx5XS4+oD6hu6QyqeoQtFuQ1vLIwnru3ahXH4sLg23w57wwjEpjHQoVeIZh2hcMlg5ziF12GmXYGy2C+fTEXfb/AOuz+dXOUdwG151P3hp2ssNmUWGOduonx9sS3A0GplvpEzB6zM3iau6K3GcXeNEuA8ibvS5fp7lo22OMQd0qDY2koZ6zGdBOSpLAnilW2iw
X-MS-Exchange-AntiSpam-MessageData: 7DNkGybTu1/8SOIMNEaOQ90LGsBp9GuzyB26zW2ci5XO7yt4ecGdyxBbm+l6aYLNK6x+VFOb8EAH/ZWAS0Bh7EU2e3hYBEsqLkXGHWufahzpEHohanGlUHGsqYGvPMlenYjCM8zvf6jOz34qqQVuWw==
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5af1b16-6825-4a24-edcd-08d7d9ce33c8
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2020 01:59:55.4239
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oagJUbJ6OX+Jd/0xlvfs4n8XBavuhfEQbUpMPzz0z5CEuyOY98OULY7l3UmskY/1jh03lc/tJKfwcHcGE2Jqsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR21MB1235
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixed the punctuation and some typos.
Improved some sentences with minor changes.

No change of semantics or code.

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
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

Changes in v3:
    "being offload" -> "being offloaded"   [Randy Dunlap]
    Added Randy's Reviewed-by.

 include/linux/skbuff.h | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 28b1a2b..3a2ac70 100644
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
+ * csum_offset are set to refer to the outermost checksum being offloaded
+ * (two offloaded checksums are possible with UDP encapsulation).
  */
 
 /* Don't change this without changing skb_csum_unnecessary! */
-- 
1.8.3.1

