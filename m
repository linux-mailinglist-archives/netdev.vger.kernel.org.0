Return-Path: <netdev+bounces-10271-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AB5C372D671
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 02:33:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E809A1C20BC8
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 00:33:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B217419D;
	Tue, 13 Jun 2023 00:33:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A297C196
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 00:33:32 +0000 (UTC)
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80CEE135;
	Mon, 12 Jun 2023 17:33:31 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id ca18e2360f4ac-77ae3db633cso244524539f.2;
        Mon, 12 Jun 2023 17:33:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686616411; x=1689208411;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=orvTaM05vfNG9foEK/hqh+cEN5/5QXQGjI4W0NarmSc=;
        b=sVN/hHFn2mCnqJsDV1/wf/tvkHMku434xIkskNn8dQRPf3VpS1giJRuSSObFQKRF2O
         aKDWo5ch1KU1X5vV/TyOBBLcP9hk/G93wzzs62//+uqGpF3xCc85dhxjZieUAQ0LWQ3D
         jV+SxYtFY2bx5J+yROGHgJIJ/FeB6IQ25n3frvdYIBaYvVrutJXT940ZAWrdq4/pO5T+
         alrIAI5BhJbLz9PRADEqjOYkIqpQZSF+kaE1YIb1ropgJw9zdCVEDn6x/mOgT/O5dyvc
         bAJuOfuYpPNDvUyijxlKxxTDX1b45Tconltk8AG/FSdQnulMIXMB5OJh0Yd9pNaEVmk4
         aX+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686616411; x=1689208411;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=orvTaM05vfNG9foEK/hqh+cEN5/5QXQGjI4W0NarmSc=;
        b=JU60LHGeciNyfJZn+4rkdNKC19l4vlcD8m7YCzZpQBW17VsNlf20MV/KTo4MPbpxgA
         OJAOKcrcVI3cuAQsWIp2hA9jyKRkWm5//LWMrujP1xx6HPf/eLXCwjrNwKLS+CxExukS
         iHot+1+/hGKmqcpWNZ4HFioB88V4N11P/5d6lm92pAvusTeqN6KmT7K5ccC++5x9/ax2
         2BG0CiDG4SCI0gVoeydGja3o/Ge0/ndNKs/vzlGmwRWTjfUBreYzptEqGkD+xXLnazSn
         Bq+uSS3i4pnJV6GgrMWKqsO9PCrJ2ecw/Jw+oW/2EcLhdyHJug1uPq+aQ4aXidRq1Hwu
         TMbg==
X-Gm-Message-State: AC+VfDyqcXTOq3JJ+yseBmp+IItCy5M9ao6eVGca/OxDNglwBHYqYxjq
	jfxnpA5SAnOgQVXE3Z4kB/w=
X-Google-Smtp-Source: ACHHUZ5qJiyzIl6fNy5Eta9rZ0A75u23IN2Wh+JvlLGlqiBYaTyZWLejZ20IYu4ylFcuIDX5ED7ofQ==
X-Received: by 2002:a5e:da0a:0:b0:775:8241:724a with SMTP id x10-20020a5eda0a000000b007758241724amr9316288ioj.16.1686616410765;
        Mon, 12 Jun 2023 17:33:30 -0700 (PDT)
Received: from azeems-kspp.c.googlers.com.com (54.70.188.35.bc.googleusercontent.com. [35.188.70.54])
        by smtp.gmail.com with ESMTPSA id g11-20020a02c54b000000b0041f4f8094ddsm3194983jaj.106.2023.06.12.17.33.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 17:33:30 -0700 (PDT)
From: Azeem Shaikh <azeemshaikh38@gmail.com>
To: Alexander Aring <alex.aring@gmail.com>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Cc: linux-hardening@vger.kernel.org,
	Azeem Shaikh <azeemshaikh38@gmail.com>,
	linux-wpan@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: [PATCH] ieee802154: Replace strlcpy with strscpy
Date: Tue, 13 Jun 2023 00:33:25 +0000
Message-ID: <20230613003326.3538391-1-azeemshaikh38@gmail.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

strlcpy() reads the entire source buffer first.
This read may exceed the destination size limit.
This is both inefficient and can lead to linear read
overflows if a source string is not NUL-terminated [1].
In an effort to remove strlcpy() completely [2], replace
strlcpy() here with strscpy().

Direct replacement is safe here since the return values
from the helper macros are ignored by the callers.

[1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy
[2] https://github.com/KSPP/linux/issues/89

Signed-off-by: Azeem Shaikh <azeemshaikh38@gmail.com>
---
 net/ieee802154/trace.h |    2 +-
 net/mac802154/trace.h  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ieee802154/trace.h b/net/ieee802154/trace.h
index e5d8439b9e45..c16db0b326fa 100644
--- a/net/ieee802154/trace.h
+++ b/net/ieee802154/trace.h
@@ -13,7 +13,7 @@
 
 #define MAXNAME		32
 #define WPAN_PHY_ENTRY	__array(char, wpan_phy_name, MAXNAME)
-#define WPAN_PHY_ASSIGN	strlcpy(__entry->wpan_phy_name,	 \
+#define WPAN_PHY_ASSIGN	strscpy(__entry->wpan_phy_name,	 \
 				wpan_phy_name(wpan_phy), \
 				MAXNAME)
 #define WPAN_PHY_PR_FMT	"%s"
diff --git a/net/mac802154/trace.h b/net/mac802154/trace.h
index 689396d6c76a..1574ecc48075 100644
--- a/net/mac802154/trace.h
+++ b/net/mac802154/trace.h
@@ -14,7 +14,7 @@
 
 #define MAXNAME		32
 #define LOCAL_ENTRY	__array(char, wpan_phy_name, MAXNAME)
-#define LOCAL_ASSIGN	strlcpy(__entry->wpan_phy_name, \
+#define LOCAL_ASSIGN	strscpy(__entry->wpan_phy_name, \
 				wpan_phy_name(local->hw.phy), MAXNAME)
 #define LOCAL_PR_FMT	"%s"
 #define LOCAL_PR_ARG	__entry->wpan_phy_name
-- 
2.41.0.162.gfafddb0af9-goog



