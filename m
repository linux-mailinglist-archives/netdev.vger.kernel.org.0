Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD1B83D5C2D
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 16:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234848AbhGZOMc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 10:12:32 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:47764
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234720AbhGZOMK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 10:12:10 -0400
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPS id 8BE453F35B
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 14:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1627311152;
        bh=TbQaBsPvgLCz2s8QzntY35xkR7Vmp0dFUIMeahF8LO0=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=gwCSPc6Z9vJ+WNAt+f//qQr7j9gdXobnIhsdpC6GA36qHjA17+P2Rl1PZvUJbV4Ai
         Xf/sNbs3BmmQ3JqD2Ykpqrc1bmcppOlnun9KfCWX+JEO/zuZ9OlUY+EoccZIZaweIy
         1Tit3OvDCYP43cBuRXmKQCSV9Zlsm/TjaaKbw4AK0yb1yzFz0emnwfqS8bki7PpDRC
         mMKV2iG9Gu0IP/WogLw166ntqhvtoRE/JvlmN5opDmozfgDLjZPpk1y5UnNI7erYM7
         LZCSE+JAnvSv8lrRAqdwsUSJX5v3iDuCCf6XlERLJeEvWuuicCuQamP2fRQhOZAkY9
         yUywFvX0j282Q==
Received: by mail-ed1-f69.google.com with SMTP id c1-20020aa7df010000b02903bb5c6f746eso2512814edy.10
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 07:52:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TbQaBsPvgLCz2s8QzntY35xkR7Vmp0dFUIMeahF8LO0=;
        b=h6OPby/7kh6SqlqQZkKYx/4ON9s8YrSG0D0bwxxk8Xj4aWVOtvyMZJj0YgNRejlCUl
         rZwKT+VMztIA6B2ZMcexiUcmELr23XGhVQu7GCnI7YcBIekILXYwcQ+xxJI171BCvr/H
         nxAnLNevrozP0N9FU4nXSPGoZM9ahxLQN0u+TW5lolW66TZUHgfU+p8Gy2bxF53moMmA
         qR5fI9jS7FnTMHdo2IWnVSaQXwPItmkAzzpBwqcif90VGWtkxzh0TI5ufKbiO1XbwnqG
         CljoRZ7urQllPHN2Y3ban37Tnpzy4l66keQwm+az85PfRbfxfDTVqpnKfXKgOf7TRqMh
         4hOg==
X-Gm-Message-State: AOAM533LGg8RklH1dtgwGrwGui9BSoy16P54tGFDB/NlQF/F+QVXbsNu
        mnFe90OIY9WzAfBcSMyTCs/eRZZBnS7xLVrAPSyYj/+caMWZU0ijoBr4KRmQwy9G8b1vHg86/q7
        c8+clGONIwdmkYT5QS20UVD6WoFNEfYqriA==
X-Received: by 2002:a17:906:fa12:: with SMTP id lo18mr6585889ejb.288.1627311152331;
        Mon, 26 Jul 2021 07:52:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzr3H22YX3zl6eg8kpAZmqM0lEeIfNO2slZxe8CmF468u3vG6E11UFP3U4RsaHrc9PMZ1yowA==
X-Received: by 2002:a17:906:fa12:: with SMTP id lo18mr6585879ejb.288.1627311152218;
        Mon, 26 Jul 2021 07:52:32 -0700 (PDT)
Received: from localhost.localdomain ([86.32.47.9])
        by smtp.gmail.com with ESMTPSA id l16sm12750753eje.67.2021.07.26.07.52.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 07:52:31 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bongsu Jeon <bongsu.jeon@samsung.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] nfc: annotate af_nfc_exit() as __exit
Date:   Mon, 26 Jul 2021 16:52:18 +0200
Message-Id: <20210726145224.146006-2-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210726145224.146006-1-krzysztof.kozlowski@canonical.com>
References: <20210726145224.146006-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The af_nfc_exit() is used only in other __exit annotated context
(nfc_exit()).

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 net/nfc/af_nfc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/nfc/af_nfc.c b/net/nfc/af_nfc.c
index 4a9e72073564..6024fad905ff 100644
--- a/net/nfc/af_nfc.c
+++ b/net/nfc/af_nfc.c
@@ -79,7 +79,7 @@ int __init af_nfc_init(void)
 	return sock_register(&nfc_sock_family_ops);
 }
 
-void af_nfc_exit(void)
+void __exit af_nfc_exit(void)
 {
 	sock_unregister(PF_NFC);
 }
-- 
2.27.0

