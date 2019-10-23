Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A178E0F4F
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 02:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731351AbfJWArM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 20:47:12 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:34016 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727403AbfJWArL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 20:47:11 -0400
Received: by mail-oi1-f196.google.com with SMTP id 83so15911829oii.1;
        Tue, 22 Oct 2019 17:47:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UodMGGQreKI/Daksnr6iCH8mqoXWy+dXHEHaIgh6+g8=;
        b=QSFeIgSmIlR5mXSH7G1xUu2l4YnRnwWmQnXyhf8qqf2Vz3r0sHRX+mP0MInhGSJtzR
         BgA6yLsVpqK2tk+GmBdDxjeiOTck+m4ZpIS6FsGVbKqTO8mS7PsKBxViyzBNicclwjba
         mxSf8q/BFne5/Ps6plessuvDt2Jy7UAv7JA1gjzCuR6SjEBZvNCNTz7aTVnlU9nD5gWn
         Kcfwcp5VGqga4zUWA5fFSojxgyZdS5s6Rd8JqXqs2T98ILtzSxKzvpEWaH+lxLJpCmuN
         7QHzEtr5013FpI+isyUJ2JxDgJ3hBEpW8Ra07fMaSARSWVV3gCCYaNf84nQ9T9bSVUmE
         8inA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UodMGGQreKI/Daksnr6iCH8mqoXWy+dXHEHaIgh6+g8=;
        b=XhrMpg0H5sDx02gvR9eazvjMPzwr+vUZHsmbuaN7Cg89cib1CCRUHRI1VcA1P6PIyo
         9x4m6iRm1jnzdE3uC91UhelL7Vrga7EphXtCRuRWGxjrS2HGg32KkH4C1d0zLsENel2z
         GFmNIZeX06z7xeLAv811tvSLJh3xVMLTc/sEVZY0fFrVpHRsqZ1/VqNsmTRT3WNbxKvy
         fBZHFvTSDI4DE7XsWzVuqcA4xSy3stRsoCnC+8d58JXQoXzSMJL2T3+ltKLwGlRs9Zbj
         7J5Jp26E1pB+upuh81inN8Pl4xfBEnW5BPYd+EBCgaVoyRvP6/AvSYItdBCAa9cgpVkl
         H2vw==
X-Gm-Message-State: APjAAAVbq5EmJT2jl+t92EFRHlrsB1GZlece/VS/9L32LxCWNkIQZY4e
        MGlw/rAQUNF1ruTXVembBsY=
X-Google-Smtp-Source: APXvYqwCcFA9Hg4v3KhshDhEGYGK3yOoFmAln5ZVzk92y1MjmmXnOWsgPGDMXC+/X0JX5jCjspu+1g==
X-Received: by 2002:aca:d508:: with SMTP id m8mr5161231oig.144.1571791629071;
        Tue, 22 Oct 2019 17:47:09 -0700 (PDT)
Received: from localhost.localdomain ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id j3sm5274476oih.52.2019.10.22.17.47.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2019 17:47:08 -0700 (PDT)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] rtlwifi: Remove unnecessary NULL check in rtl_regd_init
Date:   Tue, 22 Oct 2019 17:47:03 -0700
Message-Id: <20191023004703.39710-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When building with Clang + -Wtautological-pointer-compare:

drivers/net/wireless/realtek/rtlwifi/regd.c:389:33: warning: comparison
of address of 'rtlpriv->regd' equal to a null pointer is always false
[-Wtautological-pointer-compare]
        if (wiphy == NULL || &rtlpriv->regd == NULL)
                              ~~~~~~~~~^~~~    ~~~~
1 warning generated.

The address of an array member is never NULL unless it is the first
struct member so remove the unnecessary check. This was addressed in
the staging version of the driver in commit f986978b32b3 ("Staging:
rtlwifi: remove unnecessary NULL check").

While we are here, fix the following checkpatch warning:

CHECK: Comparison to NULL could be written "!wiphy"
35: FILE: drivers/net/wireless/realtek/rtlwifi/regd.c:389:
+       if (wiphy == NULL)

Fixes: 0c8173385e54 ("rtl8192ce: Add new driver")
Link:https://github.com/ClangBuiltLinux/linux/issues/750
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/net/wireless/realtek/rtlwifi/regd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/regd.c b/drivers/net/wireless/realtek/rtlwifi/regd.c
index c10432cd703e..8be31e0ad878 100644
--- a/drivers/net/wireless/realtek/rtlwifi/regd.c
+++ b/drivers/net/wireless/realtek/rtlwifi/regd.c
@@ -386,7 +386,7 @@ int rtl_regd_init(struct ieee80211_hw *hw,
 	struct wiphy *wiphy = hw->wiphy;
 	struct country_code_to_enum_rd *country = NULL;
 
-	if (wiphy == NULL || &rtlpriv->regd == NULL)
+	if (!wiphy)
 		return -EINVAL;
 
 	/* init country_code from efuse channel plan */
-- 
2.23.0

