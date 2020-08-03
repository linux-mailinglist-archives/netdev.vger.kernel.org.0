Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B27DA23A06A
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 09:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725996AbgHCHgG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 03:36:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725806AbgHCHgG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 03:36:06 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26699C06174A;
        Mon,  3 Aug 2020 00:36:06 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id 184so14506492wmb.0;
        Mon, 03 Aug 2020 00:36:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9L/3IwWP9Xr9krQjFNzRXd8uVshnlKbKZCDqBpzNUZ8=;
        b=FV2iLImcom6TQ9xKVtQ1bZgOdXdP+a+sDQTlBMZr047jcV01QKAs4D5vRM4P2THBPn
         hYaaXmx3kwhPtGOJpxwC180DzePL2hAj/VI56HenocwKF7LRgHnDyWRQL1iRutL2M/vE
         4sUqM8wQuYVrZBN2q3I62L3PIy8g9u4AAag7/pPyCb6Ua78qwFW1DvpzWV/A812YFXVZ
         2uCIQwTZC0rcZgLO4iJ4qhmhtzPeWxb11u5YlR7b5ncTlvp1xQPzzGpbv2uywBsGBYeJ
         ZZxTRk/xzdq3QedoZfq4mH6qy4K3DQSJEL6OUVFqJBE1kEbKsGwWGBaRccx9XvnQ6j0t
         TzkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9L/3IwWP9Xr9krQjFNzRXd8uVshnlKbKZCDqBpzNUZ8=;
        b=QNDosCHeycl3n/2++3ohG4SZVXe5Aak6Ob+r+l8/N5qdPzyBBDH++PY/HRMtNZMkGp
         AFDJ+LyQzq4lXFWfLntwXveA9/IULQAMzwWCbsriNiNvYXJRiTamIJDXwdvndSJp/1iP
         MmhoQlhpVON+8GA0w3MOPPym5O2crnvC5zecsz+oED13cI4rUVVeo4a/EYMwY2fVnvwI
         KHOtDInz5W2elkC8f0vnZOb/QamqpvyWfvdKJZRmPz3IDuL3127VC/OgX3ZtBulW0sT1
         E94QnUl/oJk1YKdJ3bedwL+8g4JKeK5jsULbm8hHi2aZ0FC91aZm54b5M5o/KqN6zA6I
         VMmA==
X-Gm-Message-State: AOAM530swIIqVLznEYHlCs2gRjzwVOCiRolPwYEsKFkXLAgwfUGptEQx
        eDgr8YIlMjbzisCGxX/K1GE=
X-Google-Smtp-Source: ABdhPJwqhds6U3kbM3p2fgQQ4HyykeRah+uqcyDKETYTvnHGqCGVutZ00yH0qm4N9bTx+C1kuYS70Q==
X-Received: by 2002:a05:600c:25cc:: with SMTP id 12mr14350985wml.120.1596440164727;
        Mon, 03 Aug 2020 00:36:04 -0700 (PDT)
Received: from stancioi.c.googlers.com.com (88.140.78.34.bc.googleusercontent.com. [34.78.140.88])
        by smtp.gmail.com with ESMTPSA id o2sm22553796wrj.21.2020.08.03.00.36.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2020 00:36:03 -0700 (PDT)
From:   Ioana-Ruxandra Stancioi <ioanaruxandra.stancioi@gmail.com>
To:     david.lebrun@uclouvain.be, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     elver@google.com, glider@google.com,
        =?UTF-8?q?Ioana-Ruxandra=20St=C4=83ncioi?= <stancioi@google.com>
Subject: [PATCH v3] seg6_iptunnel: Refactor seg6_lwt_headroom out of uapi header
Date:   Mon,  3 Aug 2020 07:33:33 +0000
Message-Id: <20200803073333.1998786-1-ioanaruxandra.stancioi@gmail.com>
X-Mailer: git-send-email 2.28.0.163.g6104cc2f0b6-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana-Ruxandra Stăncioi <stancioi@google.com>

Refactor the function seg6_lwt_headroom out of the seg6_iptunnel.h uapi
header, because it is only used in seg6_iptunnel.c. Moreover, it is only
used in the kernel code, as indicated by the "#ifdef __KERNEL__".

Suggested-by: David Miller <davem@davemloft.net>
Signed-off-by: Ioana-Ruxandra Stăncioi <stancioi@google.com>
---
v3:
* Apply David's suggestion and remove the inline tag.
---
 include/uapi/linux/seg6_iptunnel.h | 21 ---------------------
 net/ipv6/seg6_iptunnel.c           | 17 +++++++++++++++++
 2 files changed, 17 insertions(+), 21 deletions(-)

diff --git a/include/uapi/linux/seg6_iptunnel.h b/include/uapi/linux/seg6_iptunnel.h
index 09fb608a35ec..eb815e0d0ac3 100644
--- a/include/uapi/linux/seg6_iptunnel.h
+++ b/include/uapi/linux/seg6_iptunnel.h
@@ -37,25 +37,4 @@ enum {
 	SEG6_IPTUN_MODE_L2ENCAP,
 };
 
-#ifdef __KERNEL__
-
-static inline size_t seg6_lwt_headroom(struct seg6_iptunnel_encap *tuninfo)
-{
-	int head = 0;
-
-	switch (tuninfo->mode) {
-	case SEG6_IPTUN_MODE_INLINE:
-		break;
-	case SEG6_IPTUN_MODE_ENCAP:
-		head = sizeof(struct ipv6hdr);
-		break;
-	case SEG6_IPTUN_MODE_L2ENCAP:
-		return 0;
-	}
-
-	return ((tuninfo->srh->hdrlen + 1) << 3) + head;
-}
-
-#endif
-
 #endif
diff --git a/net/ipv6/seg6_iptunnel.c b/net/ipv6/seg6_iptunnel.c
index e0e9f48ab14f..897fa59c47de 100644
--- a/net/ipv6/seg6_iptunnel.c
+++ b/net/ipv6/seg6_iptunnel.c
@@ -27,6 +27,23 @@
 #include <net/seg6_hmac.h>
 #endif
 
+static size_t seg6_lwt_headroom(struct seg6_iptunnel_encap *tuninfo)
+{
+	int head = 0;
+
+	switch (tuninfo->mode) {
+	case SEG6_IPTUN_MODE_INLINE:
+		break;
+	case SEG6_IPTUN_MODE_ENCAP:
+		head = sizeof(struct ipv6hdr);
+		break;
+	case SEG6_IPTUN_MODE_L2ENCAP:
+		return 0;
+	}
+
+	return ((tuninfo->srh->hdrlen + 1) << 3) + head;
+}
+
 struct seg6_lwt {
 	struct dst_cache cache;
 	struct seg6_iptunnel_encap tuninfo[];
-- 
2.28.0.163.g6104cc2f0b6-goog

