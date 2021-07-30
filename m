Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C69183DBADD
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 16:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239384AbhG3OmX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 10:42:23 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:44782
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239335AbhG3OmV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 10:42:21 -0400
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPS id 04A683F22C
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 14:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1627656136;
        bh=VTZKLd4Cikiu9JLg7PgN5ojxKk/zgZVaneS8eoEANNg=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=wG4q3F2QwIMWJeVKxe6/BaXgZlq4lh8fmwMXSqQ5qeo/j21FgAiWBC+m0AKZSa0RL
         Y5iS8JlzOzplGVG5GclJu01t5iyHzrqPXrMUKNQI8/ehW/iGCGUv6vOjiRk4K6NGML
         7Uoq3GD2e29/eVXf8jiPax6YHIC7o5caMPQ7u2A3Qgak2rXIM+2eJaYV0AjPurSvdg
         gh20AOwPUkDyeaTGvLBxtRYHFKT3nE8Z1a8tPJsRwYIZIiQ+tvQRKe2GIVXfn5HV7T
         dZoB34Txu5X47HMnQw3NFYdx1idP657Mzfo8U249FsXtOoc39l7ScFcqofqV4rkq7O
         As0PM8hqaxZ+Q==
Received: by mail-ed1-f72.google.com with SMTP id s8-20020a0564020148b02903948b71f25cso4713053edu.4
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 07:42:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VTZKLd4Cikiu9JLg7PgN5ojxKk/zgZVaneS8eoEANNg=;
        b=aez0X9QXMZv25rmlekhPkvOyzrNWE7Bu7SHBXXdplONAGV6XGUapA/vMPoPcknsp5Y
         St3Puz28r5RfiwqVT9YREn1yjTvseHUDTguINtid4HkFqeyPoo4v/iza3ig34Enu7eBr
         g+uDxumxYmvf+d9IkbCyy7AnCtTko53HodK3bBw6286dGRobECzu/n+/5oAqVWGZj40G
         CrcRpo6yydT/U7I11/ns+WLT2D1sgPZiSEhkyW/6hbz1S6OHu6kF2whZpV0w8gtwgUm7
         tFeIN8vnuJue4FINuJyh5SyDyhjHb+q+XA13uLeilbTpEUaEXc9NE5XsT8piallUNAc6
         Yx0w==
X-Gm-Message-State: AOAM530eigO6xButQ3i/cGVC81L1w8urG0eRcAQ80snfiahw0zgjyI8s
        sVmlhDDqKEn9rwnVcPDH63KNzbNxUpA5px0813c1eeUHU1vjHP1Sk8LQZu/cEpn2LHuX7lqxK56
        +Aiig+/3l3LCNvFFjELUQUhsXPciMTM8/8w==
X-Received: by 2002:a05:6402:d5a:: with SMTP id ec26mr3436354edb.4.1627656135813;
        Fri, 30 Jul 2021 07:42:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxTklZlpNPU1+0JaWvnxKZnRAAAubw23rxdRY2xTtGKFHycvUIP2Hj5u3KPcqBIf0isib80/w==
X-Received: by 2002:a05:6402:d5a:: with SMTP id ec26mr3436345edb.4.1627656135731;
        Fri, 30 Jul 2021 07:42:15 -0700 (PDT)
Received: from localhost.localdomain ([86.32.47.9])
        by smtp.gmail.com with ESMTPSA id z8sm626325ejd.94.2021.07.30.07.42.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 07:42:15 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/7] nfc: hci: annotate nfc_llc_init() as __init
Date:   Fri, 30 Jul 2021 16:41:58 +0200
Message-Id: <20210730144202.255890-4-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210730144202.255890-1-krzysztof.kozlowski@canonical.com>
References: <20210730144202.255890-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The nfc_llc_init() is used only in other __init annotated context.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 net/nfc/hci/llc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/nfc/hci/llc.c b/net/nfc/hci/llc.c
index fc6b63de3462..2140f6724644 100644
--- a/net/nfc/hci/llc.c
+++ b/net/nfc/hci/llc.c
@@ -11,7 +11,7 @@
 
 static LIST_HEAD(llc_engines);
 
-int nfc_llc_init(void)
+int __init nfc_llc_init(void)
 {
 	int r;
 
-- 
2.27.0

