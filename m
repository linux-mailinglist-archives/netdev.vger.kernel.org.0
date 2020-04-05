Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69D9819E9B8
	for <lists+netdev@lfdr.de>; Sun,  5 Apr 2020 09:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbgDEHSG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Apr 2020 03:18:06 -0400
Received: from mail-mw2nam12on2131.outbound.protection.outlook.com ([40.107.244.131]:20388
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726236AbgDEHSG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Apr 2020 03:18:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fDoppGWAHIxoh/h5NJdSBhM8B5jHlSnw9S0wG/BCQGNsi0fjmWTUionL+P2pmRHOUMZ6eB+3AQ/6Ds1khr0E9KIrd4hof+ckpHl6gR2zJ5kUyJxPEJ8xWRNg0YLvAGeuJL7iFAcYazAIc1K6DxlNx1Y/zHMS1+2zsOKipdjPvGZgLPZl8a7IuYMsoOc2o/513Uk5b+dl6qZd09R7n4BVFhWwslEhyipJHrqrpRtwXGlE99A/MCYXAlxeJvjK4MMiTL7EbdPB8gpvIixemkHCRpLgVfGKa53Fc5zvp/QVheCzFuMeY6r1TDP2GI7EBR/wiTReO6gMPt9C0bCB+/IACg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KcZzUCRdpqB8/oWHLqssecScX3PkScfqPeJguW/zIQU=;
 b=YAwNkiVRdTihWRyyHwSPUB4jIxNSjj+pL1YrGMBhZr0+Ew089E+/fleHzb74Nig7Q/6E0TvEO9/dZhr/EVztRUMTHwS/q3XDly4uTfjpHcRepLdvYfaqqhh2HN5Mx/sXulKowZdFin0A6FS90V9GuVM0q9wm2u5BE8+IuOo44cZPr+OjFVKHF+G4Aiqyxbj9V9IjeEhjxNn14eDO8GPncx6I9yRzUAtcaxqFZcctjBZsJu0DngbRZeaXrh4cdV/Yv+OyDO4p3Rr46T6XVYvwRdtgaAJS59NUUPwP5p89lxLe2hctU25H7ISdgaxqW/FWU1v/apufQDk8+7CA1G5B9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KcZzUCRdpqB8/oWHLqssecScX3PkScfqPeJguW/zIQU=;
 b=DVoeoZf7NsjenW/RB/2uQwoF/KEve7rtL+4gzu6oZnLhQXvvvxC4SFzBbQfgWTVIpvPVQv56gd82o0gTm7rjDy4d2psH/Skej4XSXk3nClwc10OGPJ7auhEY4YkPsNjxCK504F97haxVSGyOnc40tWXf6fBoT32SoPYLsUwOuT4=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
Received: from BN8PR21MB1139.namprd21.prod.outlook.com (2603:10b6:408:72::10)
 by BN8PR21MB1204.namprd21.prod.outlook.com (2603:10b6:408:76::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.4; Sun, 5 Apr
 2020 07:17:58 +0000
Received: from BN8PR21MB1139.namprd21.prod.outlook.com
 ([fe80::b5da:34dd:f205:560b]) by BN8PR21MB1139.namprd21.prod.outlook.com
 ([fe80::b5da:34dd:f205:560b%4]) with mapi id 15.20.2900.010; Sun, 5 Apr 2020
 07:17:58 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, willemb@google.com,
        kuba@kernel.org, willy@infradead.org, simon.horman@netronome.com,
        sdf@google.com, john.hurley@netronome.com, edumazet@google.com,
        fw@strlen.de, jonathan.lemon@gmail.com, pablo@netfilter.org,
        rdunlap@infradead.org, decui@microsoft.com, jeremy@azazel.net,
        pabeni@redhat.com
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH net] skbuff.h: Improve the checksum related comments
Date:   Sun,  5 Apr 2020 00:17:43 -0700
Message-Id: <1586071063-51656-1-git-send-email-decui@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Reply-To: decui@microsoft.com
Content-Type: text/plain
X-ClientProxiedBy: MWHPR22CA0032.namprd22.prod.outlook.com
 (2603:10b6:300:69::18) To BN8PR21MB1139.namprd21.prod.outlook.com
 (2603:10b6:408:72::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (13.77.154.182) by MWHPR22CA0032.namprd22.prod.outlook.com (2603:10b6:300:69::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.15 via Frontend Transport; Sun, 5 Apr 2020 07:17:57 +0000
X-Mailer: git-send-email 1.8.3.1
X-Originating-IP: [13.77.154.182]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7b79e438-5b0f-49ca-b056-08d7d93177de
X-MS-TrafficTypeDiagnostic: BN8PR21MB1204:|BN8PR21MB1204:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN8PR21MB120457BC277997CD6B73D44FBFC50@BN8PR21MB1204.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 03648EFF89
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR21MB1139.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(346002)(376002)(39860400002)(396003)(136003)(366004)(6666004)(478600001)(7416002)(82960400001)(10290500003)(36756003)(316002)(3450700001)(2906002)(4326008)(8676002)(82950400001)(66946007)(66556008)(66476007)(5660300002)(26005)(956004)(81156014)(81166006)(6486002)(86362001)(16526019)(52116002)(2616005)(186003)(6512007)(6506007)(8936002)(921003)(1121003);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6WalM9VL0AX1qtdlyyYHFOF+a6vt3ngsEWIfK49oGQ2pa9NNnVGhB7AfR7XrK4xjWCAkVZbDyJSGITRidNm7ZOJNjSVWktthvxGNXCwW2Hs6YtUHoEctNgbo5eIccky0uGKcT5tHnCHVsMGUdPMWhuNjoIcqPK3LpTvtP/5YHKG+yydOpvVwsUv6YTyz/RoWBNdJfzcmfW5IRMjTdLjeMHSJKqXTNlkFchMwS+nsnf5pHcAmoUdpVppW1HyZ2efS82xH0t56Y1qSmAc+cjEkZvZYll8C6SMsNyfI5fDVK7t6M5HV4Ax3KATQVZHlKJ9NwkF9Ad1caJ4SWH1LHAZoGDu2DDm20CJsoZkIc7NxURJbN+MmhnrW8z3lllgpvjBGNDGXJV0unfa8xVCMMGWqkM8lUlRBqKjJpHS83S6yt1fgV6q04tPxwWfNtj0btFi5HvLgavOk5Eu/1S2/y4JVLvKxVzSKDn2lBDKj7e8D3Ty30bauZ/zuzWdBP6YcNJ7n
X-MS-Exchange-AntiSpam-MessageData: NovHUzHUtP9iUZuXyuKNV2lmHg2Ukc7e2Hx0qttUs+0Ve9xIc/i/NpUF1Jxo+xfEiNsbn5/e4iXFiC3Du8WUZWRHidvVlqYNohIZcC2JPF2tv7RNlwjJXocgX8z3PLB9+nkK25UwOlzOYWBdHeWiXQ==
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b79e438-5b0f-49ca-b056-08d7d93177de
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2020 07:17:58.7080
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TSvzxDMyC66O+a8jVSe2a+QQzS0MuP7Rlka68vrqlA57jnfw+STvGmNny/I/kvi5qIe7vY4a/weEEdGcNZZbHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR21MB1204
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixed the punctuation and some typos.
Improved a few sentences with minor changes.

No change to the semantics or the code.

Signed-off-by: Dexuan Cui <decui@microsoft.com>
---

English is not my mother tongue, so I may not be making the best changes
here. I'm happy to post a v2 if necessary. Looking forward to your comments!

 include/linux/skbuff.h | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 28b1a2b..746049c 100644
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
- *   This is the most generic way. The device supplied checksum of the _whole_
- *   packet as seen by netif_rx() and fills out in skb->csum. Meaning, the
+ *   This is the most generic way. The device supplies checksum of the _whole_
+ *   packet as seen by netif_rx() and fills out in skb->csum. This means the
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
+ *   set in skbuff, the driver should treat it as CHECKSUM_NONE being set.
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
@@ -211,7 +211,7 @@
  * is implied by the SKB_GSO_* flags in gso_type. Most obviously, if the
  * gso_type is SKB_GSO_TCPV4 or SKB_GSO_TCPV6, TCP checksum offload as
  * part of the GSO operation is implied. If a checksum is being offloaded
- * with GSO then ip_summed is CHECKSUM_PARTIAL, csum_start and csum_offset
+ * with GSO then ip_summed is CHECKSUM_PARTIAL AND csum_start and csum_offset
  * are set to refer to the outermost checksum being offload (two offloaded
  * checksums are possible with UDP encapsulation).
  */
-- 
1.8.3.1

