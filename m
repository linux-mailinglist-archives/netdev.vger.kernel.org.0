Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8FC2B27AE
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 23:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbgKMWD7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 17:03:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbgKMV7s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 16:59:48 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BB9DC0617A7
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 13:59:40 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id x15so7445612pfm.9
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 13:59:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/ZFxx9OoLBHZqTcdpKy7XMLLLSeC7kQQ9XyBjk1bmPg=;
        b=ZmB6ht7Qv9wo5O0/QcERlSAcS2yW+9fdzY6T7MPhXQxfzJxNbpan0tBgLMgnI0OLBj
         RsSLqCvNc/jSMX9+r3jXZOE12Vnw9gwly2SwK3nfDMblHOd/VVygqxv31DOt/o9P0PDC
         vzTCGUUMOyLklOjTxJ/Yv3ZBOUfe+dwzG3qs35XCN4KQAz1sirInmCfC8vNg5eVrAAav
         dcr0Kge/rNtWeyYkloaKMsBUALMIUUncMZAf6eoPeTQ4KcLb9h66fK0UY4AA6g0QCm6q
         kZeRRjjcm1Xsx/9ci0MJLvPeYvvOFh+K6pTlu+gBzROxBDhL+ArqF72D/Q3xsCI4Jhri
         LHhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/ZFxx9OoLBHZqTcdpKy7XMLLLSeC7kQQ9XyBjk1bmPg=;
        b=eKom4HHr/hfpnfWL3sVradNhk7ue6zOq3YJdFJFVBvAbw9icsYoQ/VXtaQe55SsHtQ
         SsoPOQAhYs4FHzqdAi/dw9SacLWYCZ7aRGjfx9Z1QhHFjegK+RsZp4uhVQRg55/xupBn
         bkIpPmOEReGETg1Wuj2comSQmxErI4L/LhUcEzqTMUGMATULkBIVmSBIirUixQ+DXsQf
         0wZbHzdCDaKkTjR+JuAWGQ88oJm4Ch1SuCAhs26AEqBZH8q4uHFz+rHtQurjacWFKJ10
         M1KiNqO0gPjXbfHaX6qy5zjEHBph4YZjYsvcGQ6XsdFAh64r18bw8Oj+sok9GbR1hYWH
         a7Xw==
X-Gm-Message-State: AOAM533W+0xm6NBo9FKTpAJpUxFnGWZ3GdZmYPhANnuxaHUJafAabvES
        K5T1we9ZhDiaWtqWw9KEPaA=
X-Google-Smtp-Source: ABdhPJzIKaN4RbJKtGLuGrD9w1tUEskCfivgHB5rfg5THXrJ4ICnfxYMZhWmuKckTpV1d4aSVTRVZw==
X-Received: by 2002:a63:4e24:: with SMTP id c36mr3490269pgb.171.1605304779907;
        Fri, 13 Nov 2020 13:59:39 -0800 (PST)
Received: from aroeseler-LY545.hsd1.ca.comcast.net ([2601:648:8400:9ef4:34d:9355:e74:4f1b])
        by smtp.googlemail.com with ESMTPSA id a28sm10784379pfk.50.2020.11.13.13.59.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 13:59:39 -0800 (PST)
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next 2/3] icmp: define probe message types
Date:   Fri, 13 Nov 2020 13:59:38 -0800
Message-Id: <751adc4ed06c46989542f1622f1ce9f05fd38a9d.1605303918.git.andreas.a.roeseler@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1605303918.git.andreas.a.roeseler@gmail.com>
References: <cover.1605303918.git.andreas.a.roeseler@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The types of ICMP Extended Echo Request and ICMP Extended Echo Reply are
defined in sections 2 and 3 of RFC8335.

Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com>
---
 include/uapi/linux/icmp.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/uapi/linux/icmp.h b/include/uapi/linux/icmp.h
index fb169a50895e..6cabb6acc156 100644
--- a/include/uapi/linux/icmp.h
+++ b/include/uapi/linux/icmp.h
@@ -66,6 +66,10 @@
 #define ICMP_EXC_TTL		0	/* TTL count exceeded		*/
 #define ICMP_EXC_FRAGTIME	1	/* Fragment Reass time exceeded	*/
 
+/* Codes for EXT_ECHO (Probe). */
+#define ICMP_EXT_ECHO		42
+#define ICMP_EXT_ECHOREPLY	43
+
 
 struct icmphdr {
   __u8		type;
-- 
2.29.2

