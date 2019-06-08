Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4FB839E96
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 13:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728865AbfFHLsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 07:48:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:37134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729583AbfFHLsX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Jun 2019 07:48:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5EBFB216FD;
        Sat,  8 Jun 2019 11:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559994503;
        bh=8F5r7ZgB2gD6Rrc7gkB+b3iBZdok2ASmpbLtrCpoJ8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=btoMh/IrvlxxYOx69cHiWuHWvUHRdekn11dOWkF1Pr300PoIY/2g1dZsxe4x/rkUY
         WM+oVQlSCwxr6u8Qkkp8UL0muQzc7e8H2oAoWeP02pwyFFF+vuorhhOBI9b4w10K5B
         tdOqSHT1MWmBrMM7jzWbQsQ1t3J2E2as9xQTk5OM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-parisc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 08/20] net: tulip: de4x5: Drop redundant MODULE_DEVICE_TABLE()
Date:   Sat,  8 Jun 2019 07:47:44 -0400
Message-Id: <20190608114756.9742-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190608114756.9742-1-sashal@kernel.org>
References: <20190608114756.9742-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 3e66b7cc50ef921121babc91487e1fb98af1ba6e ]

Building with Clang reports the redundant use of MODULE_DEVICE_TABLE():

drivers/net/ethernet/dec/tulip/de4x5.c:2110:1: error: redefinition of '__mod_eisa__de4x5_eisa_ids_device_table'
MODULE_DEVICE_TABLE(eisa, de4x5_eisa_ids);
^
./include/linux/module.h:229:21: note: expanded from macro 'MODULE_DEVICE_TABLE'
extern typeof(name) __mod_##type##__##name##_device_table               \
                    ^
<scratch space>:90:1: note: expanded from here
__mod_eisa__de4x5_eisa_ids_device_table
^
drivers/net/ethernet/dec/tulip/de4x5.c:2100:1: note: previous definition is here
MODULE_DEVICE_TABLE(eisa, de4x5_eisa_ids);
^
./include/linux/module.h:229:21: note: expanded from macro 'MODULE_DEVICE_TABLE'
extern typeof(name) __mod_##type##__##name##_device_table               \
                    ^
<scratch space>:85:1: note: expanded from here
__mod_eisa__de4x5_eisa_ids_device_table
^

This drops the one further from the table definition to match the common
use of MODULE_DEVICE_TABLE().

Fixes: 07563c711fbc ("EISA bus MODALIAS attributes support")
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/dec/tulip/de4x5.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/dec/tulip/de4x5.c b/drivers/net/ethernet/dec/tulip/de4x5.c
index 6620fc861c47..005c79b5b3f0 100644
--- a/drivers/net/ethernet/dec/tulip/de4x5.c
+++ b/drivers/net/ethernet/dec/tulip/de4x5.c
@@ -2109,7 +2109,6 @@ static struct eisa_driver de4x5_eisa_driver = {
 		.remove  = de4x5_eisa_remove,
         }
 };
-MODULE_DEVICE_TABLE(eisa, de4x5_eisa_ids);
 #endif
 
 #ifdef CONFIG_PCI
-- 
2.20.1

