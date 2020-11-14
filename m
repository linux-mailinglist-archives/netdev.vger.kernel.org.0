Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C736A2B2AFD
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 04:24:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbgKNDYO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 22:24:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726228AbgKNDYO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 22:24:14 -0500
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 316D9C0613D1
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 19:24:14 -0800 (PST)
Received: by mail-pj1-x1041.google.com with SMTP id ei22so1326162pjb.2
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 19:24:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6eXZN523wTS0YR6uyfw4Y6Si2ociubscC3FNxQrFs1k=;
        b=r6Z5sGvyc7KoBKD5APw1ucqUxXLqfgWLFpWJZCC+hvQyvhLlLaFea+secxkbXAkLBO
         1mdIV6IXJq73+q+HOACrBNaRHul8nChOXWwEKHtpQZTZK4Fm4oHkD3MY548cLEzqp5sH
         wyJlqt7nFGaCI3fRT3UmrkGwuUoGVvT0hUKAoxfnGKJiDBif8AlZvDvkb97oiYO//DSd
         ivlGoRgAE5sEuRzxmhhGlcPjCifCwiMVmmEDZiRmcq10V/M/3yBdhKe5f412Qnd4ZWfr
         9l3TyOkXrA/HxA56cYNOrJivvlh7Avniy4QEOv9AydaC2X5MMKXQw0RYFWazwbXU9Rf4
         LM6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6eXZN523wTS0YR6uyfw4Y6Si2ociubscC3FNxQrFs1k=;
        b=JZAfJodiDMEJ8GoTdWl0Ls+Yrxx5uoi0LrpkSvODtXdAFdB8uEa51esJBu7wqjnpkC
         8u9DBAZbZYUZxm2p5bhnOluHsI4HeJk9zgHe5EUd/3QybEKp/XOUhShHudOneuBZYG64
         vI60VUFXWPD1VwD/yv3Cmaq9WhImLDaJoxYS+ryLjMRWlyZLI4bB6eUgy8cnWWw8KjNd
         rJqk2I59aNO1yKcV+Jg1jgtxflMKN76tGZz/YAQc/xHjneAfxlDT2K8Yp1EKzhFpL7RU
         zRlwpCRSrvgiRRlllpOfQFrsfk7COa0iboqcIuEN1nDp28wGuw5SHNlhCYnozuWZkyIp
         RhBg==
X-Gm-Message-State: AOAM5308M3a4QQEK/1irZdy/+ef7wL5wjtT4Qvh27iLYlMF0uy6nV8Bi
        bN6jIjXGM96i0mNHKGbXq/k=
X-Google-Smtp-Source: ABdhPJyMGpj3kARMsTKABAJ9kKP9wk3sJSoogml5uyQ+pb+3aP8djAnH1Z5co8Yqk49RxrvZAcywpQ==
X-Received: by 2002:a17:90a:5c85:: with SMTP id r5mr6198462pji.199.1605324252497;
        Fri, 13 Nov 2020 19:24:12 -0800 (PST)
Received: from aroeseler-LY545.hsd1.ca.comcast.net ([2601:648:8400:9ef4:34d:9355:e74:4f1b])
        by smtp.googlemail.com with ESMTPSA id k9sm11192739pfp.68.2020.11.13.19.24.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 19:24:12 -0800 (PST)
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v2 net-next 2/3] icmp: define probe message types
Date:   Fri, 13 Nov 2020 19:24:11 -0800
Message-Id: <1ea3b0b7ff42054bfc1bb9ee19e487a3671f3a6a.1605323689.git.andreas.a.roeseler@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1605323689.git.andreas.a.roeseler@gmail.com>
References: <cover.1605323689.git.andreas.a.roeseler@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The types of ICMP Extended Echo Request and ICMP Extended Echo Reply are
defined in sections 2 and 3 of RFC8335.

Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com>
---
Changes since v1:
 - Switch to correct base tree
---
 include/linux/icmp.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/icmp.h b/include/linux/icmp.h
index 474f2a51cf0..acc9bcbc72b 100644
--- a/include/linux/icmp.h
+++ b/include/linux/icmp.h
@@ -64,6 +64,9 @@
 #define ICMP_EXC_TTL		0	/* TTL count exceeded		*/
 #define ICMP_EXC_FRAGTIME	1	/* Fragment Reass time exceeded	*/
 
+/* Codes for EXT_ECHO (Probe) */
+#define ICMP_EXT_ECHO		42
+#define ICMP_EXT_ECHOREPLY	43
 
 struct icmphdr {
   __u8		type;
-- 
2.29.2

