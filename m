Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 014D436C8C6
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 17:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238774AbhD0PiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 11:38:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbhD0Ph4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 11:37:56 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8529C061574
        for <netdev@vger.kernel.org>; Tue, 27 Apr 2021 08:37:11 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id 65-20020a9d03470000b02902808b4aec6dso50882785otv.6
        for <netdev@vger.kernel.org>; Tue, 27 Apr 2021 08:37:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oYjzl9za2nuSYVWnVHvn5dVyj6nN6YvFpGUlTET4ykc=;
        b=TCnHaiMu98BHilZrU166rFh/pn2OqfDoMQAkAQ4cgD+COSg9mGnUbcj+HV9UBgM6bc
         MH2oLlwZr8iN09ze1JgMCWm6D1iJbxTtICpgS4StFy2jQOtAidrj78xyR7kRgykKs7p4
         5G981ZqkoFUhh6VogibvangBnv+Up6esoW+0aHI+ZoIvF/vcmTsOT+nRsydIPgOXVdcp
         HzMWLm76pIj7Qz/VdswRizoJUvkXLtN8Q2uTMfIGnkLwPm22aXITOQ8zEG/p5ZTDz79Z
         J/VbRfPwv+U3IuGHC8gDJctr3fd1oGLEwim8EKxot7g+Dj5+KML8wBgbeBm14Ca8/DA8
         Ct1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oYjzl9za2nuSYVWnVHvn5dVyj6nN6YvFpGUlTET4ykc=;
        b=CpvobarWagHeiexJjmfeiU7851QBaogWTBsjQBrZ3tw9AwyB28xY28504oK0JKU3f8
         MpaymEaSRL/5myXD6ATvG0ASUJwsboMWiC6zK1sgQKd6v6dpJ2UOwZsew5Z5ExK6VPBz
         hciyTKjWrLZXGNHhnxXFuPQsfvUbnvYGhfYJaGY1jSGXLMG6GSG8UYq3aTZDyC6DltZ7
         1OFdoszlzrnEZABJwToFie24RT0EIpWkcnJMG42XgZ6VCFYYE12BNxnkJPkPOsaQZeh0
         nlx0YKtIBBXW+5qdyePA5+OQlZKOIuu22Wu0gNIJmpKLrvqNB2oYPs/7sXB9ZL4Nl0Gz
         2CMw==
X-Gm-Message-State: AOAM532dhbjmVSBIJ8n1jm8Wuf66AmA2fgAw+AuZsvoSqEUIzoAH1O+w
        U2UPVHzM9LWDHuA3waFGDaO1YPxd58g=
X-Google-Smtp-Source: ABdhPJzPE4rSvmJYIfDWD3CgPcAjnNIZOAYouqxAZpZsdktKuLK+tPBZYMIzFSEvD87zluw+LBlIgg==
X-Received: by 2002:a9d:62cd:: with SMTP id z13mr20500905otk.228.1619537830953;
        Tue, 27 Apr 2021 08:37:10 -0700 (PDT)
Received: from aroeseler-ly545.hsd1.ut.comcast.net ([2601:681:8800:baf9:1ee4:d363:8fe6:b64f])
        by smtp.googlemail.com with ESMTPSA id d6sm739329oom.33.2021.04.27.08.37.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Apr 2021 08:37:10 -0700 (PDT)
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, stephen@networkplumber.org, andrew@lunn.ch,
        Andreas Roeseler <andreas.a.roeseler@gmail.com>
Subject: [PATCH RESEND net-next] icmp: standardize naming of RFC 8335 PROBE constants
Date:   Tue, 27 Apr 2021 10:36:35 -0500
Message-Id: <20210427153635.2591-1-andreas.a.roeseler@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current definitions of constants for PROBE, currently defined only
in the net-next kernel branch, are inconsistent, with
some beginning with ICMP and others with simply EXT. This patch
attempts to standardize the naming conventions of the constants for
PROBE before their release into a stable Kernel, and to update the
relevant definitions in net/ipv4/icmp.c.

Similarly, the definitions for the code field (previously
ICMP_EXT_MAL_QUERY, etc) use the same prefixes as the type field. This
patch adds _CODE_ to the prefix to clarify the distinction of these
constants.

Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com>
---
 include/uapi/linux/icmp.h | 28 ++++++++++++++--------------
 net/ipv4/icmp.c           | 16 ++++++++--------
 2 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/include/uapi/linux/icmp.h b/include/uapi/linux/icmp.h
index 222325d1d80e..c1da8244c5e1 100644
--- a/include/uapi/linux/icmp.h
+++ b/include/uapi/linux/icmp.h
@@ -70,22 +70,22 @@
 #define ICMP_EXC_FRAGTIME	1	/* Fragment Reass time exceeded	*/
 
 /* Codes for EXT_ECHO (PROBE) */
-#define ICMP_EXT_ECHO		42
-#define ICMP_EXT_ECHOREPLY	43
-#define ICMP_EXT_MAL_QUERY	1	/* Malformed Query */
-#define ICMP_EXT_NO_IF		2	/* No such Interface */
-#define ICMP_EXT_NO_TABLE_ENT	3	/* No such Table Entry */
-#define ICMP_EXT_MULT_IFS	4	/* Multiple Interfaces Satisfy Query */
+#define ICMP_EXT_ECHO			42
+#define ICMP_EXT_ECHOREPLY		43
+#define ICMP_EXT_CODE_MAL_QUERY		1	/* Malformed Query */
+#define ICMP_EXT_CODE_NO_IF		2	/* No such Interface */
+#define ICMP_EXT_CODE_NO_TABLE_ENT	3	/* No such Table Entry */
+#define ICMP_EXT_CODE_MULT_IFS		4	/* Multiple Interfaces Satisfy Query */
 
 /* Constants for EXT_ECHO (PROBE) */
-#define EXT_ECHOREPLY_ACTIVE	(1 << 2)/* active bit in reply message */
-#define EXT_ECHOREPLY_IPV4	(1 << 1)/* ipv4 bit in reply message */
-#define EXT_ECHOREPLY_IPV6	1	/* ipv6 bit in reply message */
-#define EXT_ECHO_CTYPE_NAME	1
-#define EXT_ECHO_CTYPE_INDEX	2
-#define EXT_ECHO_CTYPE_ADDR	3
-#define ICMP_AFI_IP		1	/* Address Family Identifier for ipv4 */
-#define ICMP_AFI_IP6		2	/* Address Family Identifier for ipv6 */
+#define ICMP_EXT_ECHOREPLY_ACTIVE	(1 << 2)/* active bit in reply message */
+#define ICMP_EXT_ECHOREPLY_IPV4		(1 << 1)/* ipv4 bit in reply message */
+#define ICMP_EXT_ECHOREPLY_IPV6		1	/* ipv6 bit in reply message */
+#define ICMP_EXT_ECHO_CTYPE_NAME	1
+#define ICMP_EXT_ECHO_CTYPE_INDEX	2
+#define ICMP_EXT_ECHO_CTYPE_ADDR	3
+#define ICMP_AFI_IP			1	/* Address Family Identifier for ipv4 */
+#define ICMP_AFI_IP6			2	/* Address Family Identifier for ipv6 */
 
 struct icmphdr {
   __u8		type;
diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 8bd988fbcb31..7b6931a4d775 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -1033,7 +1033,7 @@ static bool icmp_echo(struct sk_buff *skb)
 	status = 0;
 	dev = NULL;
 	switch (iio->extobj_hdr.class_type) {
-	case EXT_ECHO_CTYPE_NAME:
+	case ICMP_EXT_ECHO_CTYPE_NAME:
 		iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(_iio), &_iio);
 		if (ident_len >= IFNAMSIZ)
 			goto send_mal_query;
@@ -1041,14 +1041,14 @@ static bool icmp_echo(struct sk_buff *skb)
 		memcpy(buff, &iio->ident.name, ident_len);
 		dev = dev_get_by_name(net, buff);
 		break;
-	case EXT_ECHO_CTYPE_INDEX:
+	case ICMP_EXT_ECHO_CTYPE_INDEX:
 		iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(iio->extobj_hdr) +
 					 sizeof(iio->ident.ifindex), &_iio);
 		if (ident_len != sizeof(iio->ident.ifindex))
 			goto send_mal_query;
 		dev = dev_get_by_index(net, ntohl(iio->ident.ifindex));
 		break;
-	case EXT_ECHO_CTYPE_ADDR:
+	case ICMP_EXT_ECHO_CTYPE_ADDR:
 		if (ident_len != sizeof(iio->ident.addr.ctype3_hdr) +
 				 iio->ident.addr.ctype3_hdr.addrlen)
 			goto send_mal_query;
@@ -1080,23 +1080,23 @@ static bool icmp_echo(struct sk_buff *skb)
 		goto send_mal_query;
 	}
 	if (!dev) {
-		icmp_param.data.icmph.code = ICMP_EXT_NO_IF;
+		icmp_param.data.icmph.code = ICMP_EXT_CODE_NO_IF;
 		goto send_reply;
 	}
 	/* Fill bits in reply message */
 	if (dev->flags & IFF_UP)
-		status |= EXT_ECHOREPLY_ACTIVE;
+		status |= ICMP_EXT_ECHOREPLY_ACTIVE;
 	if (__in_dev_get_rcu(dev) && __in_dev_get_rcu(dev)->ifa_list)
-		status |= EXT_ECHOREPLY_IPV4;
+		status |= ICMP_EXT_ECHOREPLY_IPV4;
 	if (!list_empty(&rcu_dereference(dev->ip6_ptr)->addr_list))
-		status |= EXT_ECHOREPLY_IPV6;
+		status |= ICMP_EXT_ECHOREPLY_IPV6;
 	dev_put(dev);
 	icmp_param.data.icmph.un.echo.sequence |= htons(status);
 send_reply:
 	icmp_reply(&icmp_param, skb);
 		return true;
 send_mal_query:
-	icmp_param.data.icmph.code = ICMP_EXT_MAL_QUERY;
+	icmp_param.data.icmph.code = ICMP_EXT_CODE_MAL_QUERY;
 	goto send_reply;
 }
 
-- 
2.31.1

