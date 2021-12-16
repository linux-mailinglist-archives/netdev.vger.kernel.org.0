Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C81F6477D2A
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 21:15:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241251AbhLPUOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 15:14:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241245AbhLPUOb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 15:14:31 -0500
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D614C061574
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 12:14:30 -0800 (PST)
Received: by mail-qk1-x735.google.com with SMTP id t6so118543qkg.1
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 12:14:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eeDZMZzzCvStXE/DrJdNcGT+efRMXCq58T1ud4iM/V8=;
        b=fbTcFElYBRmLEh19fd0qYWSn954xk5c/UwLnDDAwplg9VilPXhtQJgSExyDhEl/tjt
         9rIpyGKFM2B+fGk/lckYbe1tgxLua6OcHtXFcnFxtZMj+EY50rhrUeVMK3UxPzHgE3v5
         VxoF8+O8eHwRnB7JTb4rYuKMKj3COizXvAQFhFr0OITK1kxvzI6l0npwIVTeSpQdqY3d
         ezeudw3rpuQIYEzzNCimqXvH0hc8tN484dtq2hz+LDey95hz9UXcKdNU8HppzYrVyfW8
         n7fw5RMX9oj0gJ1t8qy9+wuXMIbTyGRJ1vrxjHMkka0AADfJWw+aUX5iqbEVRkM0N+5c
         r+JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eeDZMZzzCvStXE/DrJdNcGT+efRMXCq58T1ud4iM/V8=;
        b=iG/YucrZEfNiof8ykVZoGtkZEoG/bR+oRLZhIXh3hNc3IYmAJDkNoYWOg8PMwr+DwT
         bc5u8IO38HF68rJMhP1n3QGz5umx/hQ3eQfpnU6iW029o752HXcyGOjN8Tv1DHLG2Xek
         P5kTTya+/4rdHhslcFc/2IjBoS80WWFbp2o88TVsLIA5l/FnCbtF5khGcIb4zuCRdfZj
         eYIcCICLnMKGq/baEVwkp1bRg9vtNYU3wP8wLwgR3azpqn3asXW+sq0DqZjT9bDttTF+
         YwQujvePpuEnSLpD/kcScszTCR0KepWzt3niPTDPb8ogOt2z//e5Jyvj9DPLL8S40Hdg
         I6cg==
X-Gm-Message-State: AOAM5330pLZ5OpACLKs1zKzCYuvR+DmiI4433BwuKJ4FZVEJAcr05Xad
        xKNO5zHIoD9heywhlBQ+DmC4jf+5II07qA==
X-Google-Smtp-Source: ABdhPJyZs0Ay7ZIn7a/xB3tY2YQMXIrMFUNYncygHB0uHLcTz92piax+Gz/u3uSJEcSLbEr55Llntw==
X-Received: by 2002:a05:620a:318d:: with SMTP id bi13mr13282306qkb.279.1639685669013;
        Thu, 16 Dec 2021 12:14:29 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br (187-049-235-234.floripa.net.br. [187.49.235.234])
        by smtp.gmail.com with ESMTPSA id a15sm5110266qtb.5.2021.12.16.12.14.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 12:14:28 -0800 (PST)
From:   luizluca@gmail.com
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next 06/13] net: dsa: rtl8365mb: move rtl8365mb.c to rtl8367c.c
Date:   Thu, 16 Dec 2021 17:13:35 -0300
Message-Id: <20211216201342.25587-7-luizluca@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211216201342.25587-1-luizluca@gmail.com>
References: <20211216201342.25587-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luiz Angelo Daros de Luca <luizluca@gmail.com>

Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
---
 drivers/net/dsa/realtek/Makefile                    | 2 +-
 drivers/net/dsa/realtek/{rtl8365mb.c => rtl8367c.c} | 0
 2 files changed, 1 insertion(+), 1 deletion(-)
 rename drivers/net/dsa/realtek/{rtl8365mb.c => rtl8367c.c} (100%)

diff --git a/drivers/net/dsa/realtek/Makefile b/drivers/net/dsa/realtek/Makefile
index 8b5a4abcedd3..efb9568077f5 100644
--- a/drivers/net/dsa/realtek/Makefile
+++ b/drivers/net/dsa/realtek/Makefile
@@ -2,4 +2,4 @@
 obj-$(CONFIG_NET_DSA_REALTEK_SMI) 	+= realtek-smi.o
 obj-$(CONFIG_NET_DSA_REALTEK_RTL8366RB) += rtl8366.o
 rtl8366-objs 				:= rtl8366-core.o rtl8366rb.o
-obj-$(CONFIG_NET_DSA_REALTEK_RTL8365MB) += rtl8365mb.o
+obj-$(CONFIG_NET_DSA_REALTEK_RTL8365MB) += rtl8367c.o
diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8367c.c
similarity index 100%
rename from drivers/net/dsa/realtek/rtl8365mb.c
rename to drivers/net/dsa/realtek/rtl8367c.c
-- 
2.34.0

