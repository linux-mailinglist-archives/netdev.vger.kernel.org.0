Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E39B017ADA9
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 18:56:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726317AbgCERz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 12:55:56 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37622 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726079AbgCERzz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 12:55:55 -0500
Received: by mail-wm1-f68.google.com with SMTP id a141so6704880wme.2;
        Thu, 05 Mar 2020 09:55:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YAZG2/hO05sl03MiRnCZ1W9e0grW3DaoEjXC3GXhXj4=;
        b=S/5oNryUBD4ZFftRBagJ7C+oDjo0WCg8XDU5xuoPlrH272+nkWx960ZFh90qYe1u3F
         62tTv1vb73nyqeAJlVZmebsYQrf+EX2t0Zg/Sg6YqJFQYznJd6atvD241dOnS7K1VKRN
         3Yi0i7qW54H4mKgaQlrGJuLzvX4NDsHuWtfmEuKpvonTL19s1MCG5HR6k7Pgrm8t4VMh
         O3whRaUUjhYjmDCcZ/ByjDWVwmJzwgS8WyWKlj+yupu48ARi56ER0RsS58Ja9ZiShSE6
         VdQJCI0xkzIp8CMTOYikFzfVV8nsmogv0F1NMI0X96kXfPcREIErUfyqrGn1uu92KRFU
         B4yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YAZG2/hO05sl03MiRnCZ1W9e0grW3DaoEjXC3GXhXj4=;
        b=kKR18+fhkj8dDgj70IulEuGAZ4AuxjI89mLpHXsJ4GrxKweIUjqtBPnyPLvI6Tyxgj
         AkYduw37pR5Fl+6K4SBHxJDIemVr1W4+AGrXL2lCZEbiKs1ec6ygJhhGG7J+ECIZfVrU
         VoiPU9LJW2VD4l6FyhyAIrEkntq49h9KRh30LWXBxfD3dgqEniotbTJH52KzgDIlrMSH
         4p4s9YBmxui+if/nJ7NhUidVuLzrW5KPXB8XSrXeuGVnnD0EK3BXyCvsY5BHVG3TZcbu
         dM+SoARTtdLDBqAXBYrrR9SFn1Qe+v9cSX5YwdMZVbR6h724PGtNBu1RleLV4zsKS/HQ
         9FjA==
X-Gm-Message-State: ANhLgQ3Iis/FT3xCSJm6C9zSlm7ByLMXjyjH4zugSQRlnq7cIpviswVK
        vUyiUVJzdbItFyHUOa7B/QquGzp6nW5d6A==
X-Google-Smtp-Source: ADFU+vvfowrsZBhN4NuEGgRdvMRwAFkOslobhFI/xeIzfgz/EiMksoHc2N6XdWo8RU0Q5uqqSlsakw==
X-Received: by 2002:a05:600c:280b:: with SMTP id m11mr10900679wmb.93.1583430953992;
        Thu, 05 Mar 2020 09:55:53 -0800 (PST)
Received: from localhost (hosting85.skyberate.net. [185.87.248.81])
        by smtp.gmail.com with ESMTPSA id i1sm25493010wrs.18.2020.03.05.09.55.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2020 09:55:53 -0800 (PST)
From:   Era Mayflower <mayflowerera@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Era Mayflower <mayflowerera@gmail.com>
Subject: [PATCH 1/2] macsec: Backward compatibility bugfix of consts values
Date:   Fri,  6 Mar 2020 02:55:22 +0000
Message-Id: <20200306025523.63457-1-mayflowerera@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixed a compatibility bug, the value of the following consts changes:
    * IFLA_MACSEC_PAD (include/uapi/linux/if_link.h)
    * MACSEC_SECY_ATTR_PAD (include/uapi/linux/if_macsec.h)
    * MACSEC_RXSC_ATTR_PAD (include/uapi/linux/if_macsec.h)

Depends on: macsec: Netlink support of XPN cipher suites (IEEE 802.1AEbw)

Signed-off-by: Era Mayflower <mayflowerera@gmail.com>
---
 include/uapi/linux/if_link.h   | 2 +-
 include/uapi/linux/if_macsec.h | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index ee424d915..383316421 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -462,9 +462,9 @@ enum {
 	IFLA_MACSEC_SCB,
 	IFLA_MACSEC_REPLAY_PROTECT,
 	IFLA_MACSEC_VALIDATION,
+	IFLA_MACSEC_PAD,
 	IFLA_MACSEC_SSCI,
 	IFLA_MACSEC_SALT,
-	IFLA_MACSEC_PAD,
 	__IFLA_MACSEC_MAX,
 };
 
diff --git a/include/uapi/linux/if_macsec.h b/include/uapi/linux/if_macsec.h
index c8fab9673..a1132107d 100644
--- a/include/uapi/linux/if_macsec.h
+++ b/include/uapi/linux/if_macsec.h
@@ -68,9 +68,9 @@ enum macsec_secy_attrs {
 	MACSEC_SECY_ATTR_INC_SCI,
 	MACSEC_SECY_ATTR_ES,
 	MACSEC_SECY_ATTR_SCB,
+	MACSEC_SECY_ATTR_PAD,
 	MACSEC_SECY_ATTR_SSCI,
 	MACSEC_SECY_ATTR_SALT,
-	MACSEC_SECY_ATTR_PAD,
 	__MACSEC_SECY_ATTR_END,
 	NUM_MACSEC_SECY_ATTR = __MACSEC_SECY_ATTR_END,
 	MACSEC_SECY_ATTR_MAX = __MACSEC_SECY_ATTR_END - 1,
@@ -82,8 +82,8 @@ enum macsec_rxsc_attrs {
 	MACSEC_RXSC_ATTR_ACTIVE,  /* config/dump, u8 0..1 */
 	MACSEC_RXSC_ATTR_SA_LIST, /* dump, nested */
 	MACSEC_RXSC_ATTR_STATS,   /* dump, nested, macsec_rxsc_stats_attr */
-	MACSEC_RXSC_ATTR_SSCI,    /* config/dump, u32 */
 	MACSEC_RXSC_ATTR_PAD,
+	MACSEC_RXSC_ATTR_SSCI,    /* config/dump, u32 */
 	__MACSEC_RXSC_ATTR_END,
 	NUM_MACSEC_RXSC_ATTR = __MACSEC_RXSC_ATTR_END,
 	MACSEC_RXSC_ATTR_MAX = __MACSEC_RXSC_ATTR_END - 1,
-- 
2.20.1

