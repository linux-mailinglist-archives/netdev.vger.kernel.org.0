Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8CF3F774F
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 16:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241706AbhHYO0s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 10:26:48 -0400
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:60376
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241588AbhHYO0g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 10:26:36 -0400
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id B4EB14077A
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 14:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1629901546;
        bh=VhUvKPsyXjxe2LvjgGEBo9sT2cdcsgoMO30bCzrjHo0=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=PWAdNqYpo3tLbPxYjYrXtad4TidoTKW4mI1w6U9Cnz2acD81GBQhKSZI9gnQn8a1j
         /JsUMc54X2iF28VtKC4g0e7lDnZ74Z0U0GmiQ6Fvptf5a24fRceJiBc7VjNGi66/PG
         86sC2bTTxnBEcQ6e+JCfdFopz37LmpvrHxT7G89RnYM5pA2TisAkaKjoMGMDDVs8EP
         F2GVoUOZPQ3PxSPfStLZK/4VXKNhuIfmdq/W/mcfW6015apTVFD7L/KcvElP2jlIX6
         xpHqLw7nowb360L0yLgsPEicLw6qZTiOFVmEfKj56OcOTaCKWQ6C7o8uQI45fQx7o2
         pZS+Y51zh91bA==
Received: by mail-wm1-f70.google.com with SMTP id 201-20020a1c01d2000000b002e72ba822dcso2905916wmb.6
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 07:25:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VhUvKPsyXjxe2LvjgGEBo9sT2cdcsgoMO30bCzrjHo0=;
        b=o2Ompvs2VisZe4pOgsUisygAKMWCUeOZFdqVZQAmr3KJ8JhVDG3gZOe+WWsdiwzmRA
         cxISHvLUdP4d3vuHLoFEvSABvxkyBU/aDcLAWTo6mzg5L/bWOVpn8lBe84f76GyJLAa7
         0FRpFRInhviTtIioa+CPnMiejDJ6KMlYYXHfAQDBTvVAZigydoDE0nk0NpAptIEAmMzS
         SmGU0iZa4g4n59i1w7PaQJBOme7sOxC3MWzkNMRLvnVoacd3q/GjjzXSmFm6Tsd9kB/u
         HcNxRN/Inbgj2erjm7AA7c/QKBI/auLITnCdjl9rnnZRfIFl/fLU/ND0MPJjfFVVoI2y
         /3Mw==
X-Gm-Message-State: AOAM531qFlsbsnS+ApSk1TvaBVjUM/82tbucOv38a2GuUUwWxsKr512J
        6rshzFiK4iWvvj79eK1Ns4kAS1JC6vn7BA8ADIlOG/XPyK86GN+/xiTjefQFytQUhSnmc5Z8sn3
        bd8tvcOgO4K1xIQKeOeHvyV9VN3PIr8vsww==
X-Received: by 2002:a7b:c0cc:: with SMTP id s12mr9748920wmh.180.1629901546491;
        Wed, 25 Aug 2021 07:25:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyz2n7ykJoDbqtXZEZVoNFYeGdaA+OyKxpJHn4YsVvaC/ZZAHgNZphY3SDbEL7/FwzxUzHtkA==
X-Received: by 2002:a7b:c0cc:: with SMTP id s12mr9748908wmh.180.1629901546312;
        Wed, 25 Aug 2021 07:25:46 -0700 (PDT)
Received: from localhost.localdomain ([79.98.113.233])
        by smtp.gmail.com with ESMTPSA id i68sm60375wri.26.2021.08.25.07.25.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 07:25:45 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] nfc: st21nfca: remove unused header includes
Date:   Wed, 25 Aug 2021 16:24:58 +0200
Message-Id: <20210825142459.226168-5-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210825142459.226168-1-krzysztof.kozlowski@canonical.com>
References: <20210825142459.226168-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do not include unnecessary headers.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/nfc/st21nfca/core.c | 1 -
 drivers/nfc/st21nfca/i2c.c  | 2 --
 2 files changed, 3 deletions(-)

diff --git a/drivers/nfc/st21nfca/core.c b/drivers/nfc/st21nfca/core.c
index 5e6c99fcfd27..161caf2675cf 100644
--- a/drivers/nfc/st21nfca/core.c
+++ b/drivers/nfc/st21nfca/core.c
@@ -8,7 +8,6 @@
 #include <linux/module.h>
 #include <linux/nfc.h>
 #include <net/nfc/hci.h>
-#include <net/nfc/llc.h>
 
 #include "st21nfca.h"
 
diff --git a/drivers/nfc/st21nfca/i2c.c b/drivers/nfc/st21nfca/i2c.c
index 1b44a37a71aa..279d88128b2e 100644
--- a/drivers/nfc/st21nfca/i2c.c
+++ b/drivers/nfc/st21nfca/i2c.c
@@ -18,8 +18,6 @@
 #include <linux/nfc.h>
 #include <linux/firmware.h>
 
-#include <asm/unaligned.h>
-
 #include <net/nfc/hci.h>
 #include <net/nfc/llc.h>
 #include <net/nfc/nfc.h>
-- 
2.30.2

