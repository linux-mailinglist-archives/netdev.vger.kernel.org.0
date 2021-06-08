Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47D6739ED51
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 06:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230446AbhFHEFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 00:05:47 -0400
Received: from mail-lj1-f178.google.com ([209.85.208.178]:37467 "EHLO
        mail-lj1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbhFHEFq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 00:05:46 -0400
Received: by mail-lj1-f178.google.com with SMTP id e2so25129057ljk.4;
        Mon, 07 Jun 2021 21:03:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pPIdebRJBNO3bofmM1cHoD9YdsleLfcIV4SSBMyfI6g=;
        b=rg/D2oX5HGQDJEupPTB3i6Eoyd9mDK4JGLBxP4Z6oOUYj0HnOcD/eQQb+m0yJvor4Y
         FK+3nT5vcPqC7sYCpOa9IOv0sXQy8pAZ+qsMaKR9Oh6S5bzd5laWK0pfBQJFrHVXedF9
         KTT3ZIzsgrF1KXmg0p0L+98WQ3/gKh+xL6+4Ci4XjlyvX+efocMrtbJNZyD+ElhThpB7
         V7VZw+SfzqKsu/AOAQANYuzFU7bGedhrXZyr4qk9NaME6ymJQ0THGoShkNuhnmxEmG7n
         HDOb0ICRNNmiGlvC3dqZFMHhGWkGLiEa7f4FwoqKfRDVKVnLZED9NE6ovcls0Yt/SCCA
         fVfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pPIdebRJBNO3bofmM1cHoD9YdsleLfcIV4SSBMyfI6g=;
        b=JX7C0uvwvQ2yirb1Rhm/hTpJ9rg93WTyGUa57Px/2dd6rDOCAe2aLqhlZ6T5OPE7zc
         WpT5glWgGjm9DBqTFUZ7S7NrRHP0kqdYAgYo3ThCDZHlglgFXMWyVPk6z7zdud34Q60a
         cW3fZXC0z6JiVYdkCQtvXy3VrtgwprHjw//GQ34v9AKXhJK41tpSZx05omr8wMqrqF8O
         J4T3BcbXhJocDf+2l3lGoE2Rf/jf6xpSOM8/jhA1KU6XNSJ5bYv3/2RRtKR85kZjncmZ
         ddVlijbKMXUV0Q+X5TGYUiOLJeFC09eRJRcNrKyi+rxX90evRfJrlgz8SrOGgzOQ0aFC
         J11g==
X-Gm-Message-State: AOAM533jAE6+p8QSZQWCaCTQp193b//6zTRpQefwLRX7JdshBfQ6RAS3
        8uBi+eO0Lg5YoDp7wTiGrNw=
X-Google-Smtp-Source: ABdhPJxgXAaYKkR7I9XHwAi+zyAKhcNbXXSRMFzBworIkFYk/aAPJ0jL7PAZDHBHXsLqDjC2yq33ZA==
X-Received: by 2002:a2e:b4b0:: with SMTP id q16mr16790107ljm.434.1623124973054;
        Mon, 07 Jun 2021 21:02:53 -0700 (PDT)
Received: from rsa-laptop.internal.lan ([217.25.229.52])
        by smtp.gmail.com with ESMTPSA id l23sm1729096lfj.26.2021.06.07.21.02.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jun 2021 21:02:52 -0700 (PDT)
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
To:     Loic Poulain <loic.poulain@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH 04/10] net: wwan: core: init port type string array using enum values
Date:   Tue,  8 Jun 2021 07:02:35 +0300
Message-Id: <20210608040241.10658-5-ryazanov.s.a@gmail.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210608040241.10658-1-ryazanov.s.a@gmail.com>
References: <20210608040241.10658-1-ryazanov.s.a@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This array is indexed by port type. Make it self-descriptive by using
the port type enum values as indices in the array initializer.

Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
---
 drivers/net/wwan/wwan_core.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
index 632ff86398ac..97d77b06d222 100644
--- a/drivers/net/wwan/wwan_core.c
+++ b/drivers/net/wwan/wwan_core.c
@@ -184,13 +184,12 @@ static void wwan_remove_dev(struct wwan_device *wwandev)
 
 /* ------- WWAN port management ------- */
 
-/* Keep aligned with wwan_port_type enum */
-static const char * const wwan_port_type_str[] = {
-	"AT",
-	"MBIM",
-	"QMI",
-	"QCDM",
-	"FIREHOSE"
+static const char * const wwan_port_type_str[WWAN_PORT_MAX + 1] = {
+	[WWAN_PORT_AT] = "AT",
+	[WWAN_PORT_MBIM] = "MBIM",
+	[WWAN_PORT_QMI] = "QMI",
+	[WWAN_PORT_QCDM] = "QCDM",
+	[WWAN_PORT_FIREHOSE] = "FIREHOSE",
 };
 
 static ssize_t type_show(struct device *dev, struct device_attribute *attr,
-- 
2.26.3

