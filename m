Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F7374955D5
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 22:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377778AbiATVME (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 16:12:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377776AbiATVMD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 16:12:03 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 656DAC06161C
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 13:12:03 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id 187so6158882pga.10
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 13:12:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2CmMkcLMupEBjGGLQZwEV/RJ8zBm1D0fwzw031sSOqU=;
        b=LYxdQNpL2ygSOeu29bkG1tv44wtxVNXfbose65mHFd1TUYM2w7cSihgBHE0LuBGppe
         ha5ZxmZtpES2G6EoFsCHCJKI8H7/ARNpINWRJhca/8j+b3QHY3QcIpirvXxl1e1zgGR/
         zU+JNTA11lO6GO0Pi8FVJUEjKyqmXYtBhMVdVjRgS5dkKvD6F7nvepgvJgWASAMdDpxv
         6rdGddMlHek+YdMZca9vaof5sfHU0oI/cJrYMaWQaGsIVh+ZjJo3rQc1VZxHAJh0TkSV
         z35bV6/rCS3dqqGerOASZnP51TiggZZkYawWTSWUfN5EtFH7cNt8J5CKdC6KfKLPG9YT
         n4BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2CmMkcLMupEBjGGLQZwEV/RJ8zBm1D0fwzw031sSOqU=;
        b=q2WWXR1Q7Qqj8cBZ3QypuLyoxc236csve78ag3Epkqgv8JL1kWlb84dRX4ICiTN2xb
         RBbjkhA0xYZcSbnv+Q5WjbPAltTSc73w6A9Z2QXv8SP6TH9dxgdQYPI0KUY+ftgiRTrQ
         8pnsZCeUSFgOIJGdw0FAyeMMwxz8HLHh+mBZoRSL0i9qVR8wuu1N9UGscD+nui8qERGq
         QCEtunjEtm21pz7gOkh3eunNCqoUCSMYWNJv6Y610KgPzciIaGov8kaQJQY3jcuTyq8j
         ywMfSxGzoAcopwbCc98jg8If6QGUeEWd1l7pBFd9wHVx6wSqYR2ySLx1p6HKvvP5d6bQ
         ++1Q==
X-Gm-Message-State: AOAM5333kY7v+M8qnxmfcYd5oxrmJgjx2Ww+LJl7i0wPJnZN4LB/ZFKd
        AsRP52yUMkZMJBo5mrCvl4ChWv8mpXAsQg==
X-Google-Smtp-Source: ABdhPJyjTvE6UIcB9mk/oghTfN27ZpM1rSz33re9SoNVHZjOYFORho4DUfmlYJNjrrI+Eco4D6rEcA==
X-Received: by 2002:a63:710e:: with SMTP id m14mr476056pgc.277.1642713122657;
        Thu, 20 Jan 2022 13:12:02 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id rj9sm3357187pjb.49.2022.01.20.13.12.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jan 2022 13:12:02 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v4 iproute2-next 06/11] ipl2tp: fix clang warning
Date:   Thu, 20 Jan 2022 13:11:48 -0800
Message-Id: <20220120211153.189476-7-stephen@networkplumber.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220120211153.189476-1-stephen@networkplumber.org>
References: <20220120211153.189476-1-stephen@networkplumber.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clang complains about passing non-format string.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 ip/ipl2tp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/ip/ipl2tp.c b/ip/ipl2tp.c
index 77bc3249c7ec..569723581ec2 100644
--- a/ip/ipl2tp.c
+++ b/ip/ipl2tp.c
@@ -191,8 +191,9 @@ static int delete_session(struct l2tp_parm *p)
 	return 0;
 }
 
-static void print_cookie(const char *name, const char *fmt,
-			 const uint8_t *cookie, int len)
+static void __attribute__((format(printf, 2, 0)))
+print_cookie(const char *name, const char *fmt,
+	     const uint8_t *cookie, int len)
 {
 	char abuf[32];
 	size_t n;
-- 
2.30.2

