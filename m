Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21A63429669
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 20:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234218AbhJKSGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 14:06:45 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:51835 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234136AbhJKSGp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 14:06:45 -0400
Received: from localhost.localdomain (148.24-240-81.adsl-dyn.isp.belgacom.be [81.240.24.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPSA id 8830C200CD1D;
        Mon, 11 Oct 2021 20:04:42 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 8830C200CD1D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1633975482;
        bh=SnCefRQ+xHRzwR9SQUloscsDtfoIIpT4/AAYYZWWaj4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wBpYs8tsErudLl1rwo+2vKRD254HaOSwW9TKO/Xjw0G3di2xcYli9gdywO34dsmmY
         /3LPmJ6QW3xv3cSFb0hWnR3fOkxaXE3Aiz3rHukkLoxeyQ4eA7JPcq0s9/fOugbB+8
         qMH9pyV30h9Ca+OYLaV3FZNC7kTPu5RzTm5nlfo/zyzDRYw51PXHz3evkP6zfPITtL
         NWqbPhEk8exWGN5swEFWt4HyZNZItK7sRpzcVd424iXazHIvy7n40wrsMhQYH79p/v
         OczKD4CxYEpFDYaE8YaFDMsqfIAhxFrYkovzV2lyF3DnEmZFuiH8ezPXznXSQGMrGI
         eZAo2rPsgrP0Q==
From:   Justin Iurman <justin.iurman@uliege.be>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, justin.iurman@uliege.be
Subject: [PATCH net 1/2] ipv6: ioam: move the check for undefined bits
Date:   Mon, 11 Oct 2021 20:04:11 +0200
Message-Id: <20211011180412.22781-2-justin.iurman@uliege.be>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211011180412.22781-1-justin.iurman@uliege.be>
References: <20211011180412.22781-1-justin.iurman@uliege.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The check for undefined bits in the trace type is moved from the input side to
the output side, while the input side is relaxed and now inserts default empty
values when an undefined bit is set.

Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
---
 net/ipv6/ioam6.c          | 70 ++++++++++++++++++++++++++++++++++-----
 net/ipv6/ioam6_iptunnel.c |  6 +++-
 2 files changed, 67 insertions(+), 9 deletions(-)

diff --git a/net/ipv6/ioam6.c b/net/ipv6/ioam6.c
index 5e8961004832..d128172bb549 100644
--- a/net/ipv6/ioam6.c
+++ b/net/ipv6/ioam6.c
@@ -770,6 +770,66 @@ static void __ioam6_fill_trace_data(struct sk_buff *skb,
 		data += sizeof(__be32);
 	}
 
+	/* bit12 undefined: filled with empty value */
+	if (trace->type.bit12) {
+		*(__be32 *)data = cpu_to_be32(IOAM6_U32_UNAVAILABLE);
+		data += sizeof(__be32);
+	}
+
+	/* bit13 undefined: filled with empty value */
+	if (trace->type.bit13) {
+		*(__be32 *)data = cpu_to_be32(IOAM6_U32_UNAVAILABLE);
+		data += sizeof(__be32);
+	}
+
+	/* bit14 undefined: filled with empty value */
+	if (trace->type.bit14) {
+		*(__be32 *)data = cpu_to_be32(IOAM6_U32_UNAVAILABLE);
+		data += sizeof(__be32);
+	}
+
+	/* bit15 undefined: filled with empty value */
+	if (trace->type.bit15) {
+		*(__be32 *)data = cpu_to_be32(IOAM6_U32_UNAVAILABLE);
+		data += sizeof(__be32);
+	}
+
+	/* bit16 undefined: filled with empty value */
+	if (trace->type.bit16) {
+		*(__be32 *)data = cpu_to_be32(IOAM6_U32_UNAVAILABLE);
+		data += sizeof(__be32);
+	}
+
+	/* bit17 undefined: filled with empty value */
+	if (trace->type.bit17) {
+		*(__be32 *)data = cpu_to_be32(IOAM6_U32_UNAVAILABLE);
+		data += sizeof(__be32);
+	}
+
+	/* bit18 undefined: filled with empty value */
+	if (trace->type.bit18) {
+		*(__be32 *)data = cpu_to_be32(IOAM6_U32_UNAVAILABLE);
+		data += sizeof(__be32);
+	}
+
+	/* bit19 undefined: filled with empty value */
+	if (trace->type.bit19) {
+		*(__be32 *)data = cpu_to_be32(IOAM6_U32_UNAVAILABLE);
+		data += sizeof(__be32);
+	}
+
+	/* bit20 undefined: filled with empty value */
+	if (trace->type.bit20) {
+		*(__be32 *)data = cpu_to_be32(IOAM6_U32_UNAVAILABLE);
+		data += sizeof(__be32);
+	}
+
+	/* bit21 undefined: filled with empty value */
+	if (trace->type.bit21) {
+		*(__be32 *)data = cpu_to_be32(IOAM6_U32_UNAVAILABLE);
+		data += sizeof(__be32);
+	}
+
 	/* opaque state snapshot */
 	if (trace->type.bit22) {
 		if (!sc) {
@@ -791,16 +851,10 @@ void ioam6_fill_trace_data(struct sk_buff *skb,
 	struct ioam6_schema *sc;
 	u8 sclen = 0;
 
-	/* Skip if Overflow flag is set OR
-	 * if an unknown type (bit 12-21) is set
+	/* Skip if Overflow flag is set
 	 */
-	if (trace->overflow ||
-	    trace->type.bit12 | trace->type.bit13 | trace->type.bit14 |
-	    trace->type.bit15 | trace->type.bit16 | trace->type.bit17 |
-	    trace->type.bit18 | trace->type.bit19 | trace->type.bit20 |
-	    trace->type.bit21) {
+	if (trace->overflow)
 		return;
-	}
 
 	/* NodeLen does not include Opaque State Snapshot length. We need to
 	 * take it into account if the corresponding bit is set (bit 22) and
diff --git a/net/ipv6/ioam6_iptunnel.c b/net/ipv6/ioam6_iptunnel.c
index f9ee04541c17..9b7b726f8f45 100644
--- a/net/ipv6/ioam6_iptunnel.c
+++ b/net/ipv6/ioam6_iptunnel.c
@@ -75,7 +75,11 @@ static bool ioam6_validate_trace_hdr(struct ioam6_trace_hdr *trace)
 	u32 fields;
 
 	if (!trace->type_be32 || !trace->remlen ||
-	    trace->remlen > IOAM6_TRACE_DATA_SIZE_MAX / 4)
+	    trace->remlen > IOAM6_TRACE_DATA_SIZE_MAX / 4 ||
+	    trace->type.bit12 | trace->type.bit13 | trace->type.bit14 |
+	    trace->type.bit15 | trace->type.bit16 | trace->type.bit17 |
+	    trace->type.bit18 | trace->type.bit19 | trace->type.bit20 |
+	    trace->type.bit21)
 		return false;
 
 	trace->nodelen = 0;
-- 
2.25.1

