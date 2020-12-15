Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5FBE2DA848
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 07:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbgLOGzI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 01:55:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbgLOGzA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 01:55:00 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3762C0617A6;
        Mon, 14 Dec 2020 22:54:34 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id j13so8358744pjz.3;
        Mon, 14 Dec 2020 22:54:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nIjZP5Lkybwz2c4aGlTZv0F588/auhsxru313pjOx5w=;
        b=KfjKWAEaC8+Nbkc22nUV0yrTvm9YpXoVUvMnHKcPuaBIY3UsVKMmTUw88yc+L9M8c4
         qbGMToASI5aZ0368VTsqwXqJgDOJrzBsbEuqw26ZpXKBevmsnkH3btXUG3GaLOrW9N+a
         /jHPiWwXmu3SMAf8BYJsfbtrcwEkB0WkwAYXHvErpcjH9PiDjTcz4tq/+wLsYcPlbtjC
         YWQzlP1pph8wYeecPGt+075F7rDPJwz7RokKlMIUyHzwduCZTZENXgwinIUVpBY6N+2T
         ljPJhnFfDGXVT64sWbECaKCDTODWPHj85ML9J3XytDWX5iaRO9b5vvEKU1UJSZIsaXtW
         iy0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=nIjZP5Lkybwz2c4aGlTZv0F588/auhsxru313pjOx5w=;
        b=sAYpATPtN12+cRTzszJPuuv8i+GZaaw7We89AyVhntMdn3NAl91qIkIDeHgBIKtfRV
         XfF+uZadtGOooAxP2aXq5x3vXZFwuL0IRUZ3yLslgYhl0D/XWOd1kdQ+v3T2USiPPbTv
         U7Ku2tfosh06+aXQmP3Ofts6FOA3mSSHnJxDgJIG7sQrnXRTJoU7R9cIrqyicYCxTXNc
         5Ck/hM6zJSmlc4IkR89OG+HaxCHxemft+Ya2LbW0TN9/0d4FItBcmoSOlb+R1qkRKm0y
         mRbQ/k7oj2hvkaoXGtZTWjIdhpwejAclxZM11IfeKwvOiDqD4/xIdFXcgB9L7sfHyOyA
         bNCw==
X-Gm-Message-State: AOAM5325Nqx54EOvL9xsOuk4HXQDenPsytujANvJr3KX/1x72jwa58tg
        p1NkVLnJqfOlkQ9LmVfHPp8=
X-Google-Smtp-Source: ABdhPJySuEAvZQpZgPTFQJ79CJff9QOdfof/7bZnikPspsKE3ZyoWZv6zT3Tj3k2p9g1CYqkh0gdGA==
X-Received: by 2002:a17:90b:697:: with SMTP id m23mr28565098pjz.35.1608015274584;
        Mon, 14 Dec 2020 22:54:34 -0800 (PST)
Received: from localhost.localdomain ([182.226.226.37])
        by smtp.googlemail.com with ESMTPSA id na6sm19124134pjb.12.2020.12.14.22.54.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 22:54:33 -0800 (PST)
From:   Bongsu Jeon <bongsu.jeon2@gmail.com>
X-Google-Original-From: Bongsu Jeon
To:     krzk@kernel.org
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: [PATCH v2 net-next 1/2] nfc: s3fwrn5: Remove the delay for NFC sleep
Date:   Tue, 15 Dec 2020 15:54:00 +0900
Message-Id: <20201215065401.3220-2-bongsu.jeon@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201215065401.3220-1-bongsu.jeon@samsung.com>
References: <20201215065401.3220-1-bongsu.jeon@samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bongsu Jeon <bongsu.jeon@samsung.com>

Remove the delay for NFC sleep because the delay is only needed to
guarantee that the NFC is awake.

Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
---
 drivers/nfc/s3fwrn5/phy_common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nfc/s3fwrn5/phy_common.c b/drivers/nfc/s3fwrn5/phy_common.c
index 497b02b30ae7..81318478d5fd 100644
--- a/drivers/nfc/s3fwrn5/phy_common.c
+++ b/drivers/nfc/s3fwrn5/phy_common.c
@@ -20,7 +20,8 @@ void s3fwrn5_phy_set_wake(void *phy_id, bool wake)
 
 	mutex_lock(&phy->mutex);
 	gpio_set_value(phy->gpio_fw_wake, wake);
-	msleep(S3FWRN5_EN_WAIT_TIME);
+	if (wake)
+		msleep(S3FWRN5_EN_WAIT_TIME);
 	mutex_unlock(&phy->mutex);
 }
 EXPORT_SYMBOL(s3fwrn5_phy_set_wake);
-- 
2.17.1

