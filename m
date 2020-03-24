Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8682F19032E
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 02:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbgCXBKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 21:10:30 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:45506 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727046AbgCXBKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 21:10:30 -0400
Received: by mail-pl1-f194.google.com with SMTP id b9so6682328pls.12
        for <netdev@vger.kernel.org>; Mon, 23 Mar 2020 18:10:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iSfF7yjVFHlwSTuYQLymEImstVpSq5rsUabdeKm/s9g=;
        b=ScAJyWynIoOWiUG7H/Uj7m6jDLVFRa8MJMPQWTnG3M5YQ/XEeP/Y8++eY/ZUnIPkBc
         LnKZHoI5rFuCP24v9fYQozYZl3t4OBSdhE5t3t8Hw7S7XMdLKpIXZsBWB5SlYtajp6mf
         JxNchP2DVzV9vXd3e4zitSHam/WHsAzNpJodgtE7fHg8VbsWwbBgmpWd8yVCgQbdSPlk
         1sWQOibdwK3nmNHD6RfBFQWb5jY9tyUYPOsKMKMzhLM2PXm62Lt9FiAh2v7zI5tKFciY
         msiE03oQP2dkVddeLwSwI2lu7kGXG3+pJTkznyyfpD6WQ/wLLRMTlKG/uPTsJpUrkgE0
         bMHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iSfF7yjVFHlwSTuYQLymEImstVpSq5rsUabdeKm/s9g=;
        b=pfAufh4BR0rsHYVIlGPohLSScI/31K+Ua9fnSPCRa82YveCNVUt4YxGgSyxKCxcp1/
         YDPMOw1cZKL9T8SIQ+oeeW8YZTK7uIfsRzM1TiCQuEbfCf9C0Hj2WuHn0d/ZfEVG+vK/
         vXDzdzBcKnLzahp7xcXAIAZX+E45xZDBAgy/ZZaSa4GYbfC+kdGbUE5wkvrwk6MzKlBe
         62jDulmU+o2rtV8sewFBbGGTgffJ/G1/QHrdB4nrBLatt2b3HvI6m+KfpKVvjJTY8m7l
         qHs8wzFmLTjjOLxWB1SOBQV1h19Nlf65Z1Krb+I/Bbo3KqKSH9eXLy5rqRQeGsJRvRSM
         HNSg==
X-Gm-Message-State: ANhLgQ0yuk/cJo7BU5Un7LvV6Wz25dNz973nbooDDpL9wa83jiL9cMf4
        yxX4oFUr4jxPJkUMl3+cJE4=
X-Google-Smtp-Source: ADFU+vvNClLTn7VFSEo82a2JAPEWC02dcXkjnujPX7sIJVKLS6/nKLH3Ipqb4GePOh0wNnG20TZp/g==
X-Received: by 2002:a17:90a:8a17:: with SMTP id w23mr2199622pjn.94.1585012228880;
        Mon, 23 Mar 2020 18:10:28 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id 66sm14822778pfb.150.2020.03.23.18.10.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 18:10:28 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Erik Kline <ek@google.com>, Jen Linkova <furry@google.com>,
        Lorenzo Colitti <lorenzo@google.com>,
        Michael Haro <mharo@google.com>
Subject: [PATCH] net-ipv6-ndisc: add support for 'PREF64' dns64 prefix identifier
Date:   Mon, 23 Mar 2020 18:10:19 -0700
Message-Id: <20200324011019.248392-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.25.1.696.g5e7596f4ac-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

This is trivial since we already have support for the entirely
identical (from the kernel's point of view) RDNSS, DNSSL, etc. that
also contain opaque data that needs to be passed down to userspace
for further processing.

As specified in draft-ietf-6man-ra-pref64-09 (while it is still a draft,
it is purely waiting on the RFC Editor for cleanups and publishing):
  PREF64 option contains lifetime and a (up to) 96-bit IPv6 prefix.

The 8-bit identifier of the option type as assigned by the IANA is 38.

Since we lack DNS64/NAT64/CLAT support in kernel at the moment,
thus this option should also be passed on to userland.

See:
  https://tools.ietf.org/html/draft-ietf-6man-ra-pref64-09
  https://www.iana.org/assignments/icmpv6-parameters/icmpv6-parameters.xhtml#icmpv6-parameters-5

Cc: Erik Kline <ek@google.com>
Cc: Jen Linkova <furry@google.com>
Cc: Lorenzo Colitti <lorenzo@google.com>
Cc: Michael Haro <mharo@google.com>
Signed-off-by: Maciej Żenczykowski <maze@google.com>
---
 include/net/ndisc.h | 1 +
 net/ipv6/ndisc.c    | 1 +
 2 files changed, 2 insertions(+)

diff --git a/include/net/ndisc.h b/include/net/ndisc.h
index 1c61aeb3a1c0..7d107113f988 100644
--- a/include/net/ndisc.h
+++ b/include/net/ndisc.h
@@ -41,6 +41,7 @@ enum {
 	ND_OPT_DNSSL = 31,		/* RFC6106 */
 	ND_OPT_6CO = 34,		/* RFC6775 */
 	ND_OPT_CAPTIVE_PORTAL = 37,	/* RFC7710 */
+	ND_OPT_PREF64 = 38,		/* RFC-ietf-6man-ra-pref64-09 */
 	__ND_OPT_MAX
 };
 
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index 4a3feccd5b10..6ffa153e5166 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -197,6 +197,7 @@ static inline int ndisc_is_useropt(const struct net_device *dev,
 	return opt->nd_opt_type == ND_OPT_RDNSS ||
 		opt->nd_opt_type == ND_OPT_DNSSL ||
 		opt->nd_opt_type == ND_OPT_CAPTIVE_PORTAL ||
+		opt->nd_opt_type == ND_OPT_PREF64 ||
 		ndisc_ops_is_useropt(dev, opt->nd_opt_type);
 }
 
-- 
2.25.1.696.g5e7596f4ac-goog

