Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0962E3D5C2A
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 16:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234833AbhGZOMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 10:12:21 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:47788
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234726AbhGZOMK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 10:12:10 -0400
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPS id 84F873F35E
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 14:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1627311153;
        bh=VTZKLd4Cikiu9JLg7PgN5ojxKk/zgZVaneS8eoEANNg=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=B6u+9zyGLT/Le92wvXez8sQAUy7gXDE4KqMFoxLOcnq3Yeuvusl1OY62yRSUMnc4Q
         lDJpar7ysH5xL1jgvwiCJeF25/E6yeR0WRPJT39suqnCAYfPGfUB2DDEjQ+PTQsccV
         KfTOzlHZvVKaLQC2gIXxbuuuT27EhUsptzmjgHB3S+wN4LOco/lQooiynk/nBseBlZ
         VHQ750mSuqNJIMacfpsnNUAgY5fTWO4kCUk5+N8aEqmsEm2T1q58KirriCpIsB09mY
         zgaYhEbiMBJxJ0S0QScVICSvjGqL74xLYMXWCaJIvJrIUsp6j9Y+3yyN8wve46U3jE
         j/4mcepTLY2VA==
Received: by mail-ed1-f72.google.com with SMTP id eg50-20020a05640228b2b02903a2e0d2acb7so3675999edb.16
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 07:52:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VTZKLd4Cikiu9JLg7PgN5ojxKk/zgZVaneS8eoEANNg=;
        b=iE+83OHtcn63hFlQ6B+hG+tyZvGfAGTgxx9Ichxn6Y4jOpE5VqxiSDQnFwqsZywzq5
         KhyLw1JxsAobrvx+9/kOs/IvfVKjf2/MtwoXrEWjoChxmn0UHJHOTiv7m0Z74AMf7iIH
         oAzpGDT7dBgpJgTHd426YN+goC4KLk9dAVi1woCfkwJQOeBb4Zz6aEq14WL1ZuHFdJrZ
         ubKawpJ2+msH6TlaRUUh4diJwNtxOk5KVtNQx3SOnjpWnCoUNKD3VNngUdWNT8CRlrfV
         SK4boxs6FBG/oLUvW14gX2nIQ917QYoM8+vKe0Dc06l45BqI1gbLMqzTD2l3eV1aOdq5
         OEDA==
X-Gm-Message-State: AOAM531cOXZPL0p9hRyUp+K8rATQPgUgPSig3pqcA+vYP3wNypQiLqJl
        p4iH/k61SwWXJEtfoNGElhVECJWezUD6VGs7ZGSNc7HP1CiKatqi394vDeOcU3b6lmB71eOmO7i
        ljHbU3rrbzM8Tq1Htjo9gjsMOGPaSpa2Wcw==
X-Received: by 2002:a17:906:4310:: with SMTP id j16mr17891705ejm.182.1627311153279;
        Mon, 26 Jul 2021 07:52:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyaA1Fp5u7I5oRE9hR4xIbTXCOlHBKfNsVdDSv78ioftJh2cv7gNgVMhXGskXM+te4gAGIJDg==
X-Received: by 2002:a17:906:4310:: with SMTP id j16mr17891691ejm.182.1627311153166;
        Mon, 26 Jul 2021 07:52:33 -0700 (PDT)
Received: from localhost.localdomain ([86.32.47.9])
        by smtp.gmail.com with ESMTPSA id l16sm12750753eje.67.2021.07.26.07.52.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 07:52:32 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bongsu Jeon <bongsu.jeon@samsung.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] nfc: hci: annotate nfc_llc_init() as __init
Date:   Mon, 26 Jul 2021 16:52:19 +0200
Message-Id: <20210726145224.146006-3-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210726145224.146006-1-krzysztof.kozlowski@canonical.com>
References: <20210726145224.146006-1-krzysztof.kozlowski@canonical.com>
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

