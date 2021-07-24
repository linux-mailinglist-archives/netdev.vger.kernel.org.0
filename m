Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61DCB3D4A45
	for <lists+netdev@lfdr.de>; Sat, 24 Jul 2021 23:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbhGXVJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Jul 2021 17:09:08 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:58604
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229964AbhGXVJH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Jul 2021 17:09:07 -0400
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPS id 812323F352
        for <netdev@vger.kernel.org>; Sat, 24 Jul 2021 21:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1627163378;
        bh=lqncaONSiNw90ZsWSl9AH9IIEf03wH8Ti3Z9kPsi5zE=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=HRA3Gnoa+RlPT5s4iYQ0//vnLXwsCMTAgsCwe0RJAtpRR3Kbeu32owHXgc+aEZfAA
         WWHBL8dUverPoyPV/3Ru/Ym0PIwH2byzNfSJYPEXdH2IcS16JmKflArQhYSWIEbjU9
         tRSYyvirb03zhiAGBruCJHi9ioPjnOKEUumEy67XuZhtEQRB1iBl8TPNLhM9TSpmq8
         li7tABDEEPPtSUBnGlVmO8SAc0P/WXLcbygnvZsXBSwDJWUurOSx9ofJBE0aGCswv9
         F0A2x8CMU0R/oD0vbc27/fsaxf0AAMVHYa1RXR6XGpUbsdm2tRGUOjeff9gNLg0hJD
         YnDePwXSSJNIQ==
Received: by mail-ed1-f72.google.com with SMTP id z15-20020a50f14f0000b02903aa750a46efso2819464edl.8
        for <netdev@vger.kernel.org>; Sat, 24 Jul 2021 14:49:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lqncaONSiNw90ZsWSl9AH9IIEf03wH8Ti3Z9kPsi5zE=;
        b=ZQfHdZY1cbbS3WCXdxvXM3PEGUz3ZEajT2INBqJkC2WjfDpCUSOSiOpDwn++sb4NDR
         kRaUJwk2VGHciUSOgq/fDLUGqVaLRlgvBJtpGH36kidqkhdLg3BF1ITRkV2LZrfweLxh
         B61eKL4tgPX9nLxsMnuXlUeZGfg1U+z0Ci2dltIA07P9r0+/Fs6ZOUqFIMikez741m3J
         nauVsGLsP4Oi0g99kh7CK6CEgd+Rf7H6i80DdkIKdjMcIy5DELnJm1Oa3CTrmkagOJJQ
         e71uNlmVdtm8TcP1auuiaZK4ZVJlDNn6SQ2h3eoaizFh5vu4utT17zTd0VwbJwmaNJMf
         XG/g==
X-Gm-Message-State: AOAM5313VDJkEaWgn87bDyRrHiGXJ2v3eP+MXP5FtbW1Em3KT1LRkVIm
        nBiteuCnvSo4DPqFJjlbrbDZ4aNWT+7VGt6S7QUAtNeFeQfxoAo1LCcL0OJMmQoyrhVl7M7S1eW
        yUG95g4V1wAslenBsa0hSv0hnXAfhYvqZHQ==
X-Received: by 2002:a50:ce45:: with SMTP id k5mr12994090edj.168.1627163378121;
        Sat, 24 Jul 2021 14:49:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzs2MCWxVY/iIgBmUT84/VHcn/wv31k1R7oXnENH/7sKHYpMW13rHzV1X6lKvVGgvVFlM+aqQ==
X-Received: by 2002:a50:ce45:: with SMTP id k5mr12994078edj.168.1627163378020;
        Sat, 24 Jul 2021 14:49:38 -0700 (PDT)
Received: from localhost.localdomain ([86.32.47.9])
        by smtp.gmail.com with ESMTPSA id s10sm12821908ejc.39.2021.07.24.14.49.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Jul 2021 14:49:37 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Charles Gorand <charles.gorand@effinnov.com>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        Mark Greer <mgreer@animalcreek.com>,
        Bongsu Jeon <bongsu.jeon@samsung.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH 06/12] nfc: st21nfca: constify file-scope arrays
Date:   Sat, 24 Jul 2021 23:49:22 +0200
Message-Id: <20210724214928.122096-1-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210724214743.121884-1-krzysztof.kozlowski@canonical.com>
References: <20210724214743.121884-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Driver only reads len_seq and wait_tab variables.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/nfc/st21nfca/i2c.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nfc/st21nfca/i2c.c b/drivers/nfc/st21nfca/i2c.c
index 9dc9693a7356..1b44a37a71aa 100644
--- a/drivers/nfc/st21nfca/i2c.c
+++ b/drivers/nfc/st21nfca/i2c.c
@@ -76,8 +76,8 @@ struct st21nfca_i2c_phy {
 	struct mutex phy_lock;
 };
 
-static u8 len_seq[] = { 16, 24, 12, 29 };
-static u16 wait_tab[] = { 2, 3, 5, 15, 20, 40};
+static const u8 len_seq[] = { 16, 24, 12, 29 };
+static const u16 wait_tab[] = { 2, 3, 5, 15, 20, 40};
 
 #define I2C_DUMP_SKB(info, skb)					\
 do {								\
-- 
2.27.0

