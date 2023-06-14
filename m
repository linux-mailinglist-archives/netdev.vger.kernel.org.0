Return-Path: <netdev+bounces-10733-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D5AE730056
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 15:46:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 848D71C20CC3
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 13:46:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46FE6BE59;
	Wed, 14 Jun 2023 13:46:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AEA77FC
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 13:46:28 +0000 (UTC)
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5545D2118;
	Wed, 14 Jun 2023 06:46:08 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id ca18e2360f4ac-777a78739ccso374236139f.3;
        Wed, 14 Jun 2023 06:46:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686750367; x=1689342367;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zQY5/Z9V92asgUBqQZpuZOlLV7pXFKrCuP0E34yfs0w=;
        b=V4ahN5BL99HDOMgXDQGo0/tyx6nm9sWOfshsWhVthyRTSNZrfjK4M658jtS2RiHGus
         pIZSdvbKF8hDIHAI2cKQYbUM/Fav7dOixRf6F65xHPWd9B/egU92Qve8NHblaGLxlgLN
         7RxtK3F9/R2+uvf66wGBHpfzUTTESC3mj0Yhm5stSPgYhoiMSxm0NTEwruyezQ56xjWV
         EThigOax2hhtA8OzSNU3F/oZ0kcj1n+7IbNsqo+yTz2zC3kxO3jHegCSSI6T1fVF9U4M
         5bwzbHJI+45CBp+cNesnSPfEjWwKoFuhIY1S2CMD3SF45btXTAkAgwPkH5rQcMDHRQd0
         Y4rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686750367; x=1689342367;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zQY5/Z9V92asgUBqQZpuZOlLV7pXFKrCuP0E34yfs0w=;
        b=hclyDKQE4yKXQH4SgOpZUMegqhY/r4WfKd+hCevgUfAulp3SwKAxSwW63rcCXdv3E2
         9GhpSgiRsjSwRtgujv+RUmLNEq0fzj6xNE20Z9xKDIO6EnMOk9LnvRGg8eC2ezzacAA+
         ks2PRFsIOfpjsGEEisFw97uzk6NKfVu8SdPJi8mc+8w6ZPqAf3pbQsoG3xoOmnNeAnup
         NXmZQ6bmsVQ4BbkzfFF5PJgvr4cdPLyWhM9dLAIRzmAX7tAJZiO1iW4YiGABeF8D5UDN
         Z3X4u1mqmKy/D3LuYc5mIH893jH6Ov6o84gs+Zm4Frnp61sgzvvtl4lpwMG0A0ZPkZWD
         kSYg==
X-Gm-Message-State: AC+VfDxsXJhZXutqtqeCEwIcnDh8MxhmYY1rtQaC5uNcGCe6Gm/x7nH6
	WsCPOA7KgLn8HPhMIfMbQf8=
X-Google-Smtp-Source: ACHHUZ6jTKwwclu9yoql3y/RRuy36VHdIgQDbVqS33PxEzmA14MKgVLgpgLm9ZC+sGbXkm4sxDv11w==
X-Received: by 2002:a05:6e02:108:b0:33f:a995:31ab with SMTP id t8-20020a056e02010800b0033fa99531abmr13648127ilm.11.1686750366930;
        Wed, 14 Jun 2023 06:46:06 -0700 (PDT)
Received: from azeems-kspp.c.googlers.com.com (54.70.188.35.bc.googleusercontent.com. [35.188.70.54])
        by smtp.gmail.com with ESMTPSA id cu13-20020a05663848cd00b0040bb600eb81sm5021586jab.149.2023.06.14.06.46.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 06:46:06 -0700 (PDT)
From: Azeem Shaikh <azeemshaikh38@gmail.com>
To: Kalle Valo <kvalo@kernel.org>
Cc: linux-hardening@vger.kernel.org,
	Azeem Shaikh <azeemshaikh38@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v2] wifi: cfg80211: replace strlcpy() with strlscpy()
Date: Wed, 14 Jun 2023 13:45:52 +0000
Message-ID: <20230614134552.2108471-1-azeemshaikh38@gmail.com>
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

Direct replacement is safe here since WIPHY_ASSIGN is only used by
TRACE macros and the return values are ignored.

[1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy
[2] https://github.com/KSPP/linux/issues/89

Signed-off-by: Azeem Shaikh <azeemshaikh38@gmail.com>
---
v1: https://lore.kernel.org/all/20230612232301.2572316-1-azeemshaikh38@gmail.com/

Changes from v1 - updated patch title.

 net/wireless/trace.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 716a1fa70069..a00da3ebfed5 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -22,7 +22,7 @@
 
 #define MAXNAME		32
 #define WIPHY_ENTRY	__array(char, wiphy_name, 32)
-#define WIPHY_ASSIGN	strlcpy(__entry->wiphy_name, wiphy_name(wiphy), MAXNAME)
+#define WIPHY_ASSIGN	strscpy(__entry->wiphy_name, wiphy_name(wiphy), MAXNAME)
 #define WIPHY_PR_FMT	"%s"
 #define WIPHY_PR_ARG	__entry->wiphy_name
 
-- 
2.41.0.162.gfafddb0af9-goog



