Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 244323EF16B
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 20:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233255AbhHQSJX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 14:09:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232807AbhHQSJV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 14:09:21 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D731C0613C1
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 11:08:48 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id j9-20020a2581490000b02905897d81c63fso21146391ybm.8
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 11:08:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=kSH45SZMveG0CaWqBoMxwQKpfpniEhXxIOVkDYEW2gs=;
        b=etBTrfpzbs3cCZzDaZKPfBXIEycjxSXscCauYc6AWlisF9NEhS8ywPiPwTY/Wtj71Z
         mlPHKTapnrEoFTaKGh1QJEXGlBuHZchvm/cDjtVpnGJlY4UPdFgBGeMIXvnyvEiB3hRL
         b+keVDqVAz4Li0cYWHnFXicwcp13C8RMgw9c7Tcbe4/22AeafI/xWgVcoT+x81IAqy13
         uwk6adK35YZVmXB7bbz+Wa2Vvk6+kFDIi1yFhCC3IuXeY0LOvtUlZL85J9SKxs8+juNa
         I/u7zRb3xSzn3J5LZUMJM8ZLRh6Bdl3tMCdepXJQ2NBrkquYBrm2rCvMJr/3nxAW6QMi
         AyiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=kSH45SZMveG0CaWqBoMxwQKpfpniEhXxIOVkDYEW2gs=;
        b=UOWBT4/gQWcqm76tDWGeKB5hiBDr9BUjtX8E/Cj5LnJEP4qU5WXqsvGHokfcxuZtgL
         PfabIx7s+vZkDDbrjfYhRI54LVS6Uskv1hj828qbRNMQd5ulyDGs4VJ2C8WKie35jS0U
         jgskjPlXzt6syuT/PahANfB5zSOR+NkG+58HmTu5Wv7MR6RNJOt+Mbfuv8LqsXYnd69L
         EPFBT3kz5hl8TfP11kE/nH73reIwfPGvQeYiCK0/XFml/ZGWEtZsKQnGic250xZRfVyB
         4RTe+fha9Es9RDE9MIhZ8w8sT1/qjJDOKYDyVrn+8FJr2NuifkMagrD75dz7Fk4ltZpN
         KLXA==
X-Gm-Message-State: AOAM531Et+8LGgcQ1/C55rZW4xR4GPbBFVJomxzsvseMMPsHgcorMaB+
        XuBwg1BF6pks4ebQCLYa2L30/cXyRDXcHRs=
X-Google-Smtp-Source: ABdhPJx7kwc2yf1NBmOlwG/p8RdAt1gPoF/4QEpryZEEDFOG4+07JBD9gcC3N93m0NSyNthhw2Af3wW+rR1Ihgg=
X-Received: from saravanak.san.corp.google.com ([2620:15c:2d:3:7750:a56d:5272:72cb])
 (user=saravanak job=sendgmr) by 2002:a25:b948:: with SMTP id
 s8mr5947207ybm.281.1629223727760; Tue, 17 Aug 2021 11:08:47 -0700 (PDT)
Date:   Tue, 17 Aug 2021 11:08:39 -0700
In-Reply-To: <20210817180841.3210484-1-saravanak@google.com>
Message-Id: <20210817180841.3210484-2-saravanak@google.com>
Mime-Version: 1.0
References: <20210817180841.3210484-1-saravanak@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH net v2 1/3] net: mdio-mux: Delete unnecessary devm_kfree
From:   Saravana Kannan <saravanak@google.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Saravana Kannan <saravanak@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>, kernel-team@android.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The whole point of devm_* APIs is that you don't have to undo them if you
are returning an error that's going to get propagated out of a probe()
function. So delete unnecessary devm_kfree() call in the error return path.

Signed-off-by: Saravana Kannan <saravanak@google.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Acked-by: Marc Zyngier <maz@kernel.org>
Tested-by: Marc Zyngier <maz@kernel.org>
Acked-by: Kevin Hilman <khilman@baylibre.com>
Tested-by: Kevin Hilman <khilman@baylibre.com>
---
 drivers/net/mdio/mdio-mux.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/mdio/mdio-mux.c b/drivers/net/mdio/mdio-mux.c
index 110e4ee85785..5b37284f54d6 100644
--- a/drivers/net/mdio/mdio-mux.c
+++ b/drivers/net/mdio/mdio-mux.c
@@ -181,7 +181,6 @@ int mdio_mux_init(struct device *dev,
 	}
 
 	dev_err(dev, "Error: No acceptable child buses found\n");
-	devm_kfree(dev, pb);
 err_pb_kz:
 	put_device(&parent_bus->dev);
 err_parent_bus:
-- 
2.33.0.rc1.237.g0d66db33f3-goog

