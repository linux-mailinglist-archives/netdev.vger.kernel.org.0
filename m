Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF6045AFC3
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 00:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233494AbhKWXJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 18:09:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231683AbhKWXJt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 18:09:49 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18B92C061574;
        Tue, 23 Nov 2021 15:06:41 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id gx15-20020a17090b124f00b001a695f3734aso736206pjb.0;
        Tue, 23 Nov 2021 15:06:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DJfk8BcmICotrkto9QK0fhNW+LePmR911sFhN5fSxj0=;
        b=SX2sKm1mQRcJMBZbVdhFqWjULJaNNJASVq+7B8dyl5socBw1O/ZZu8SRKVmTsFqX32
         +bbfKQSFUvGlTVzq8HoDuozhqu9Iw9Ishc0F/Iv4UcPWfvj9/1T4ALER20rj7cqgx032
         3WFBAm1REBDiP56AK4B1F42DWAiDvy5PKb8+3wjyzDA1e2JiklgcN5o8Hjca10YHiSd4
         lcV5+i0pt1axNiElu/R0ArmYZq24SwYzatw1JkmCYL2br66zs5wvdhd1ZDQauMql6sTV
         hlY2RRh+SdSu2FYRE1uorhU6CjU5vKglsbNQaPh8gZTme4iBWYIZESnIujM8KmY67jKU
         YsuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DJfk8BcmICotrkto9QK0fhNW+LePmR911sFhN5fSxj0=;
        b=eEX71d0NfaaggowTZaXvxpovmSfgUDnYOnzApRNlh/t9VGbhIlCYZfee3Kl2aFngeS
         Pdsru0k30gHoAM5M+z9htkWUsRDORsKdmzETCmx+BIoHHHxwsLQoDAhZ9KIe6b8k89Wv
         9CRJkY3xJJJ6mNcxS2F1zyS8Bf+hkOt8Hzz5gq275Buu6nfoiLX7tBLLRbj2Rr7jP0kE
         u0LlufwsZ2oAiCc5ZVE8LUAKgUIAhi29y/46TWTX2kQX8JwWzA0n7Ad6V+zzQO2FTHnq
         NyVRTO34iVbblX3/0sqFiafd83qTNeNqVqfCkeSoPkFDMf1pJJZUa3kCi6kbIo53Koi0
         c5Ew==
X-Gm-Message-State: AOAM530OhuIoGIB8SmTPFdusqjBbblgWtUvdrlbRhK0UT7R5VbaB8a0U
        VTeFu7EiPrXRXbf8nGXAtUg=
X-Google-Smtp-Source: ABdhPJybuomYRfd7QdEflkII9GI4dj/tolMPXuytg1Xezhm8N02yuw7m1SYTiWBebOB6nhnq9X2fEw==
X-Received: by 2002:a17:902:e74a:b0:142:114c:1f1e with SMTP id p10-20020a170902e74a00b00142114c1f1emr11878437plf.78.1637708800434;
        Tue, 23 Nov 2021 15:06:40 -0800 (PST)
Received: from athina.mtv.corp.google.com ([2620:15c:211:200:cd70:5ac2:9066:1bb8])
        by smtp.gmail.com with ESMTPSA id g11sm9646673pgn.41.2021.11.23.15.06.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 15:06:39 -0800 (PST)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        BPF Mailing List <bpf@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Lorenzo Colitti <lorenzo@google.com>
Subject: [PATCH bpf-next] net-bpf: bpf_skb_change_proto() - add support for ipv6 fragments
Date:   Tue, 23 Nov 2021 15:06:32 -0800
Message-Id: <20211123230632.1503854-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

IPv4 fragments (20 byte IPv4 header) need to be translated to/from
IPv6 fragments (40 byte IPv6 header with additional 8 byte IPv6
fragmentation header).

This allows this to be done by adding an extra flag BPF_F_IPV6_FRAGMENT
to bpf_skb_change_proto().

I think this is already technically achievable via the use of
bpf_skb_adjust_room() which was added in v4.12 commit 2be7e212d541,
but this is far easier to use and eliminates the need to call two
helper functions, so it's also faster.

Cc: Lorenzo Colitti <lorenzo@google.com>
Signed-off-by: Maciej Żenczykowski <maze@google.com>
---
 include/uapi/linux/bpf.h | 24 ++++++++++++++++++++++--
 net/core/filter.c        | 19 ++++++++++---------
 2 files changed, 32 insertions(+), 11 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index ba5af15e25f5..0187c2f0a4bc 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2188,8 +2188,10 @@ union bpf_attr {
  * 		checked and segments are recalculated by the GSO/GRO engine.
  * 		The size for GSO target is adapted as well.
  *
- * 		All values for *flags* are reserved for future usage, and must
- * 		be left at zero.
+ * 		*flags* may be set to **BPF_F_IPV6_FRAGMENT** to treat ipv6 as
+ * 		a 48 byte header instead of the normal 40 (this leaves 8 bytes
+ * 		of space for the IPv6 Fragmentation Header). All other bits in
+ * 		*flags* are reserved for future usage, and must be left at zero.
  *
  * 		A call to this helper is susceptible to change the underlying
  * 		packet buffer. Therefore, at load time, all checks on pointers
@@ -5164,6 +5166,24 @@ enum {
 	BPF_F_TUNINFO_IPV6		= (1ULL << 0),
 };
 
+/* BPF_FUNC_skb_change_proto flags. */
+enum {
+	/* Bits 0-15 are reserved for possible future expansion into
+	 * a potential signed 8 bit field, which allows for corrections
+	 * to account for ipv4 options and/or additional ipv6 expansion headers,
+	 * but for now we support *only* the 8 byte ipv6 frag header.
+	 *
+	 * This is most useful, because ipv4 without options supports fragments,
+	 * while ipv6 does not, so the 20 byte ipv4-frag <-> 48 byte ipv6
+	 * conversion is not a terribly rare case (UDP DNS queries for example).
+	 *
+	 * Only use bits <16 for other purposes if we run out of >15 bits first.
+	 *
+	 * 1ULL << 3 is equal to +8 and is the ipv6 frag header size.
+	 */
+	BPF_F_IPV6_FRAGMENT		= (1ULL << 3),
+};
+
 /* flags for both BPF_FUNC_get_stackid and BPF_FUNC_get_stack. */
 enum {
 	BPF_F_SKIP_FIELD_MASK		= 0xffULL,
diff --git a/net/core/filter.c b/net/core/filter.c
index 6102f093d59a..13020368fb4a 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3219,9 +3219,8 @@ static int bpf_skb_net_hdr_pop(struct sk_buff *skb, u32 off, u32 len)
 	return ret;
 }
 
-static int bpf_skb_proto_4_to_6(struct sk_buff *skb)
+static int bpf_skb_proto_4_to_6(struct sk_buff *skb, u32 len_diff)
 {
-	const u32 len_diff = sizeof(struct ipv6hdr) - sizeof(struct iphdr);
 	u32 off = skb_mac_header_len(skb);
 	int ret;
 
@@ -3249,9 +3248,8 @@ static int bpf_skb_proto_4_to_6(struct sk_buff *skb)
 	return 0;
 }
 
-static int bpf_skb_proto_6_to_4(struct sk_buff *skb)
+static int bpf_skb_proto_6_to_4(struct sk_buff *skb, u32 len_diff)
 {
-	const u32 len_diff = sizeof(struct ipv6hdr) - sizeof(struct iphdr);
 	u32 off = skb_mac_header_len(skb);
 	int ret;
 
@@ -3279,17 +3277,17 @@ static int bpf_skb_proto_6_to_4(struct sk_buff *skb)
 	return 0;
 }
 
-static int bpf_skb_proto_xlat(struct sk_buff *skb, __be16 to_proto)
+static int bpf_skb_proto_xlat(struct sk_buff *skb, __be16 to_proto, u32 len_diff)
 {
 	__be16 from_proto = skb->protocol;
 
 	if (from_proto == htons(ETH_P_IP) &&
 	      to_proto == htons(ETH_P_IPV6))
-		return bpf_skb_proto_4_to_6(skb);
+		return bpf_skb_proto_4_to_6(skb, len_diff);
 
 	if (from_proto == htons(ETH_P_IPV6) &&
 	      to_proto == htons(ETH_P_IP))
-		return bpf_skb_proto_6_to_4(skb);
+		return bpf_skb_proto_6_to_4(skb, len_diff);
 
 	return -ENOTSUPP;
 }
@@ -3297,9 +3295,10 @@ static int bpf_skb_proto_xlat(struct sk_buff *skb, __be16 to_proto)
 BPF_CALL_3(bpf_skb_change_proto, struct sk_buff *, skb, __be16, proto,
 	   u64, flags)
 {
+	u32 len_diff;
 	int ret;
 
-	if (unlikely(flags))
+	if (unlikely(flags & ~(BPF_F_IPV6_FRAGMENT)))
 		return -EINVAL;
 
 	/* General idea is that this helper does the basic groundwork
@@ -3319,7 +3318,9 @@ BPF_CALL_3(bpf_skb_change_proto, struct sk_buff *, skb, __be16, proto,
 	 * that. For offloads, we mark packet as dodgy, so that headers
 	 * need to be verified first.
 	 */
-	ret = bpf_skb_proto_xlat(skb, proto);
+	len_diff = sizeof(struct ipv6hdr) - sizeof(struct iphdr)
+		   + ((flags & BPF_F_IPV6_FRAGMENT) ? sizeof(struct frag_hdr) : 0);
+	ret = bpf_skb_proto_xlat(skb, proto, len_diff);
 	bpf_compute_data_pointers(skb);
 	return ret;
 }
-- 
2.34.0.rc2.393.gf8c9666880-goog

