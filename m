Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21E19490FE7
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 18:50:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241921AbiAQRud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 12:50:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241665AbiAQRu2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 12:50:28 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 739DBC061574
        for <netdev@vger.kernel.org>; Mon, 17 Jan 2022 09:50:28 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id q75so3821488pgq.5
        for <netdev@vger.kernel.org>; Mon, 17 Jan 2022 09:50:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2CmMkcLMupEBjGGLQZwEV/RJ8zBm1D0fwzw031sSOqU=;
        b=Fthz7WL3hybo1kkw2Ta6oTHsIZzfCuqiT3ilS7JT7g/YqsJsaNa0IwnlYs2ejHymzt
         RkLfGSMkP7meM2Qvljyv0yaqMlN6PWsbGSC5W4Q4ppHMQbFYLbmH10sEFYNKe7E3t63u
         LvFiDAMegOeOS2YFLZdCCh2tfx3IGalmmJDciCJT2KtqcJyLb4uNZyqx1TdetKtxWIJG
         psJFkZF7tjbh5ndk+ffxO6dDPlD2j3dBe/Muxl1VLPKlk+oKVSnocZ+wZVBaG+ra28yu
         3qsC3D0Djv0nbf45kEuhhRMyt9hhm3hSxW9B1vL0N9IRwa5TSJjlMPHXdK0ObqaYvWwt
         w3vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2CmMkcLMupEBjGGLQZwEV/RJ8zBm1D0fwzw031sSOqU=;
        b=wk6uTMo+dSldDd5T7PqHuqcZT7ASl1+6iMFGwBXzz9nOJdXGcpwWjNiB21dSlMFq2O
         23ujR/eR3+YOwPu09knGPyjVLLFETS6Sg57twoPII7hHpgXE1CfShVQZx1YS3IGAF3nG
         DlLYUmG0vFe0fFtnQgJKtTPk/hnohLDHnWOuO+xpweQzH0ZpzdYYVOAS9AHYnLjHheCN
         J/FgBZs6A+MOzHcupuQP4NEIWB0TnIvIjDfexnN8jM7+JSxFZjWDmVcGt97+ISceYCd2
         NQuZ31V5raPZF6n2cqYn6qxf7TeMvXKFnBBXxw+rw6+t6c5Uoln03LTy+ZZHq5huceUv
         V8CQ==
X-Gm-Message-State: AOAM533EgcnBc/JNAzIt3t18Imd/ADUR+nlJJXarFK+EaYyh3GC2HjDK
        dYvtoepXvkBlGwPAl6y+Bzkjc7zz7TTuNA==
X-Google-Smtp-Source: ABdhPJwDG5OeakU4dq3LeqZh2fa61Go051YZFkjvyycrvipTGCdjWC4GSVepXWX8Z3vjfZPnlL+s5Q==
X-Received: by 2002:a63:154f:: with SMTP id 15mr19647545pgv.521.1642441827719;
        Mon, 17 Jan 2022 09:50:27 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id q19sm15819117pfk.131.2022.01.17.09.50.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jan 2022 09:50:27 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v3 iproute2-next 06/11] ipl2tp: fix clang warning
Date:   Mon, 17 Jan 2022 09:50:14 -0800
Message-Id: <20220117175019.13993-7-stephen@networkplumber.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220117175019.13993-1-stephen@networkplumber.org>
References: <20220117175019.13993-1-stephen@networkplumber.org>
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

