Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0987A48B4A9
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 18:54:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344903AbiAKRyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 12:54:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344893AbiAKRys (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 12:54:48 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45816C061756
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 09:54:48 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id 59-20020a17090a09c100b001b34a13745eso6653673pjo.5
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 09:54:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2CmMkcLMupEBjGGLQZwEV/RJ8zBm1D0fwzw031sSOqU=;
        b=WRBg2ZXGKa7DXYywQUYT3lQxRWcELX8oSpi8YeIwyL52CMvhoOxhoKcZOba0cf3vyl
         fVM1AXm/OtrYo5SjMpV/RU6ik3MZrU59fHMEVihjZEOJq9UavoXlWXC/8VGN8g413zbO
         TvTyvgXtb/0WLSQMXAnpwF/AdjYZGb1OME/ySzIuBLJPzP7eZAi++D7DItEG75tzfIDO
         X/XG8y4M1wTWcvOtguc7oY1hUTechwM/FxvmkzAN447tpsDT9ZIZ1J2tPEXplO5WYOz3
         TLSceFrBzwS/EKPkzGdz1XMC/Ob147XiDJKY9HW1W6v+iEpq//JCbG1e11uo5qaHqURO
         R8pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2CmMkcLMupEBjGGLQZwEV/RJ8zBm1D0fwzw031sSOqU=;
        b=ltnCpALmWfi6KpA3Bhb6KctNa/BvHawLgFWa2xSq9dFxnkaq2Cwl0mZAj3GHxiHsla
         fCv7lRtGMRjO/j9xt7Ty1IpYd+2lCsFxfdOcOvIhHq7ZdIvaLJ+hqAMm7A/7eT7cZcXH
         YTHo+CudDKQ0T4186xkFEYY2f69jeTJusQ1WMJuLgia6glV5eXgaHXmJ8p13cN2UqQIS
         P7897psYghgDEVsnaaAEOn1iALMF7CYC13XVI/2uiaZLEPfMTEernQHAH6xRNTZL+OGS
         A+pTOxsrjIpF1ydWoGHsrh40K4046TfGensPCvD4J+0HUmCFS9Ly03qwjqXYsA4Tycm+
         p7wA==
X-Gm-Message-State: AOAM533ZiBdZpiQqGZiEIHi84OZmYOeSFWtFd+fnZDZQnCrUuXqZ4OxQ
        epbdJI9RMioPYAjVr9uS0ooeshvoptZc1g==
X-Google-Smtp-Source: ABdhPJz4opmvdc2UJJ8QyPv3MSvcJTCaZjVSGpYsYgnkYw/fgpMHp0BcMScqTIQzC/DST6sJ+MpqIA==
X-Received: by 2002:a17:90a:7786:: with SMTP id v6mr4397378pjk.11.1641923687440;
        Tue, 11 Jan 2022 09:54:47 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id f8sm23925pga.69.2022.01.11.09.54.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 09:54:46 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
X-Google-Original-From: Stephen Hemminger <sthemmin@microsoft.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <sthemmin@microsoft.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v2 iproute2-next 06/11] ipl2tp: fix clang warning
Date:   Tue, 11 Jan 2022 09:54:33 -0800
Message-Id: <20220111175438.21901-7-sthemmin@microsoft.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220111175438.21901-1-sthemmin@microsoft.com>
References: <20220111175438.21901-1-sthemmin@microsoft.com>
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

