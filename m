Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9DBCAE0F
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 20:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388816AbfJCSTy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 14:19:54 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:37924 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388667AbfJCSTt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 14:19:49 -0400
Received: by mail-qk1-f195.google.com with SMTP id u186so3333480qkc.5
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 11:19:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DcE+UamZif/tZqIFXQiUhVwqdZa1A6gpoZRzqbUbJPs=;
        b=QIP6u/wLCunghfpa/RdV+aAudxpHIyHnJuxs22zSXr1Pt64XmszJ4U2Ab4gzUNc5C7
         JZ2e86QPs5rw9wG+1nKTHN5uUhLbgQneXuVttxl9FdQJwJc4sj/Kbwir0qaVvE+3iIaw
         0Oxjn45cRB2SFsCzwE3cTKeOzFPnojMqAyNZlX5Kh1Aus4G92f3EYsG5FQIqRKAFVmxH
         5mFO2bTLL7S3dzPGo/fk4aBpKlb/VElwOxfEuEpR6f0AVAZHZhf89FzppcKEyq4QOSkV
         zUiH/1MnOppBFDw6cTgKyIsoRABpZ/VgaAEsR9viPWegl7dvBj2JIIlTDSZTV57FJkN3
         wE2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DcE+UamZif/tZqIFXQiUhVwqdZa1A6gpoZRzqbUbJPs=;
        b=kjMNbyov6TnkQ41xVNOIcjFP7vC1LnoChPgJosdCp8/ou+locQ5owdNDEab2N68GNS
         c1ughNLJ3/dmpzfjrx+T0g6kxssrzp+tXYtibyUs0FRYdoG28tY1LUhfO7qoLdAYxiiA
         x6wXVrsUGEqlRmO3a5pTfmzaBZXrLxFksKhHeBOUTz/w0T0fa4W+NYeYplKRSqURSm8w
         WAZz6MeE91Ch5EkeFqRID4gGsWWy4ROCkirJJpWiZEoMQLCHdKzL5a11+4j5ea4Rgu+G
         /yyxXfEeDb7Up/gvMRQ3kRueli22Fv7D8AvNE+5uaXpTVFkCHlDoJyX1gJRXTyPyuii4
         x0sA==
X-Gm-Message-State: APjAAAXh1fyAXrBk60/kwEFoIPFmT2U35XLO4q4Edpg5diRSRpbbiXob
        g5Oib4T6261HJjwP1FVozMy43w==
X-Google-Smtp-Source: APXvYqwAiNKHEGtle/f8aLxiAbWrYSL4TL/JfC/eDhH9sOzz72Iv6RoM4ylHtJoe7VvgzZf1vIzLHw==
X-Received: by 2002:a37:a2c3:: with SMTP id l186mr5472693qke.461.1570126788643;
        Thu, 03 Oct 2019 11:19:48 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id m91sm1592984qte.8.2019.10.03.11.19.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Oct 2019 11:19:48 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        davejwatson@fb.com, borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        atul.gupta@chelsio.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Hurley <john.hurley@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net-next 6/6] net/tls: allow compiling TLS TOE out
Date:   Thu,  3 Oct 2019 11:18:59 -0700
Message-Id: <20191003181859.24958-7-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191003181859.24958-1-jakub.kicinski@netronome.com>
References: <20191003181859.24958-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TLS "record layer offload" requires TOE, and bypasses most of
the normal networking stack. It is also significantly less
maintained. Allow users to compile it out to avoid issues.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: John Hurley <john.hurley@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
---
 drivers/crypto/chelsio/Kconfig |  2 +-
 net/tls/Kconfig                | 10 ++++++++++
 net/tls/Makefile               |  3 ++-
 net/tls/tls_main.c             |  5 ++++-
 4 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/chelsio/Kconfig b/drivers/crypto/chelsio/Kconfig
index 250150560e68..91e424378217 100644
--- a/drivers/crypto/chelsio/Kconfig
+++ b/drivers/crypto/chelsio/Kconfig
@@ -35,7 +35,7 @@ config CHELSIO_IPSEC_INLINE
 config CRYPTO_DEV_CHELSIO_TLS
         tristate "Chelsio Crypto Inline TLS Driver"
         depends on CHELSIO_T4
-        depends on TLS
+        depends on TLS_TOE
         select CRYPTO_DEV_CHELSIO
         ---help---
           Support Chelsio Inline TLS with Chelsio crypto accelerator.
diff --git a/net/tls/Kconfig b/net/tls/Kconfig
index e4328b3b72eb..61ec78521a60 100644
--- a/net/tls/Kconfig
+++ b/net/tls/Kconfig
@@ -26,3 +26,13 @@ config TLS_DEVICE
 	Enable kernel support for HW offload of the TLS protocol.
 
 	If unsure, say N.
+
+config TLS_TOE
+	bool "Transport Layer Security TCP stack bypass"
+	depends on TLS
+	default n
+	help
+	Enable kernel support for legacy HW offload of the TLS protocol,
+	which is incompatible with the Linux networking stack semantics.
+
+	If unsure, say N.
diff --git a/net/tls/Makefile b/net/tls/Makefile
index 322250e912db..95d8c06a14b9 100644
--- a/net/tls/Makefile
+++ b/net/tls/Makefile
@@ -5,6 +5,7 @@
 
 obj-$(CONFIG_TLS) += tls.o
 
-tls-y := tls_main.o tls_sw.o tls_toe.o
+tls-y := tls_main.o tls_sw.o
 
+tls-$(CONFIG_TLS_TOE) += tls_toe.o
 tls-$(CONFIG_TLS_DEVICE) += tls_device.o tls_device_fallback.o
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 483dda6c3155..237e58e4928a 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -679,10 +679,11 @@ static void build_protos(struct proto prot[TLS_NUM_CONFIG][TLS_NUM_CONFIG],
 
 	prot[TLS_HW][TLS_HW] = prot[TLS_HW][TLS_SW];
 #endif
-
+#ifdef CONFIG_TLS_TOE
 	prot[TLS_HW_RECORD][TLS_HW_RECORD] = *base;
 	prot[TLS_HW_RECORD][TLS_HW_RECORD].hash		= tls_toe_hash;
 	prot[TLS_HW_RECORD][TLS_HW_RECORD].unhash	= tls_toe_unhash;
+#endif
 }
 
 static int tls_init(struct sock *sk)
@@ -692,8 +693,10 @@ static int tls_init(struct sock *sk)
 
 	tls_build_proto(sk);
 
+#ifdef CONFIG_TLS_TOE
 	if (tls_toe_bypass(sk))
 		return 0;
+#endif
 
 	/* The TLS ulp is currently supported only for TCP sockets
 	 * in ESTABLISHED state.
-- 
2.21.0

