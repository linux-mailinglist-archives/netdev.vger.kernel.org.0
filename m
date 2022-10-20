Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E02960624E
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 15:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbiJTN5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 09:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbiJTN5N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 09:57:13 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C3FD199899;
        Thu, 20 Oct 2022 06:57:11 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id bu30so34620536wrb.8;
        Thu, 20 Oct 2022 06:57:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ngGq9Gbtxzl0gmyIAkOWNorog708VikOB0/w/Kr3k+M=;
        b=GvZOhSM4dyj0Ur+6JcRLUu7kAl/nazFe9/kEDysRlOLpRoV34NDReQ5nX8oKe/ZuwB
         z2tsPC+jPAHOoTVno7frIBHRPVIudDakN2pOyYURUJUoUVr0jAQaTlvRmkirq8zpwGJw
         8g+vYjpe3KwG6YXavJlCKCYHSIWArEl9n4tL5AjGACDGZ7WSPL6hr7GWz1wF6RX5QvQJ
         KtMFj893scPfwqyLNW7w9VTVpYRIXZIWusu6icbXfxDuZKp5cr8RRmFPxTfbeP6k9tQZ
         SUmBcfUPDzUGVA5OEn3/3Xdq3wSjGYJ2jWZaDIiwAj8WDUXjpV/1k3f01lSGXJvhNGGi
         6aJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ngGq9Gbtxzl0gmyIAkOWNorog708VikOB0/w/Kr3k+M=;
        b=1UEfpKDfH3j5O6yke1En/nw2u+6QFjql3UinARBgG+vEeSVU68eRWAiNJWhU9F1jXU
         5uuw/kQWDmP9Jt3X5ysooreVJ1NkqI7lxXSPe+wpYk5o4QTTS6ZBOC76uvEeMGX0yEWJ
         5C/E1blZE6mv/SzwInH2Yh/muk407fQBJI3r9wwUtKkC3+4Hav2W+t18Aq5VSqrnXZ6B
         Dv118cSLjG5IFksb3NnnTW+ukFacqP2PxX5wFXc35dPxSvoxoWahqWK2w8v88M97Uq6O
         bTlS0SokaAn+n994RpybHLDBg/vOnbFoBpH8TccjeZnIxRrS2H2eezWKk7H/syt91VT3
         CuqA==
X-Gm-Message-State: ACrzQf2MQlg0N2R61C08r9xtba9F3PdiY9J/nl6gptPOqQFJx2eoXKFU
        h6ae6FZntdE5frsmwIyCaaQ=
X-Google-Smtp-Source: AMsMyM4IAwcg6WE4zL5H1BMmTbtTZ4v+KdVe4eFEF2c6NK3H128evLdH86rC8yer9I50a+yYE3Jdcw==
X-Received: by 2002:adf:e10f:0:b0:22a:43e8:969f with SMTP id t15-20020adfe10f000000b0022a43e8969fmr9310147wrz.292.1666274230099;
        Thu, 20 Oct 2022 06:57:10 -0700 (PDT)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id i9-20020a05600c354900b003c6f3e5ba42sm2986018wmq.46.2022.10.20.06.57.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 06:57:09 -0700 (PDT)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Jes Sorensen <Jes.Sorensen@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bitterblue Smith <rtl8821cerfe2@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] wifi: rtl8xxxu: Fix reads of uninitialized variables hw_ctrl_s1, sw_ctrl_s1
Date:   Thu, 20 Oct 2022 14:57:09 +0100
Message-Id: <20221020135709.1549086-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Variables hw_ctrl_s1 and sw_ctrl_s1 are not being initialized and
potentially can contain any garbage value. Currently there is an if
statement that sets one or the other of these variables, followed
by an if statement that checks if any of these variables have been
set to a non-zero value. In the case where they may contain
uninitialized non-zero values, the latter if statement may be
taken as true when it was not expected to.

Fix this by ensuring hw_ctrl_s1 and sw_ctrl_s1 are initialized.

Cleans up clang warning:
drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8188f.c:432:7: warning:
variable 'hw_ctrl_s1' is used uninitialized whenever 'if' condition is
false [-Wsometimes-uninitialized]
                if (hw_ctrl) {
                    ^~~~~~~
drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8188f.c:440:7: note: uninitialized
use occurs here
                if (hw_ctrl_s1 || sw_ctrl_s1) {
                    ^~~~~~~~~~
drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8188f.c:432:3: note: remove the 'if'
if its condition is always true
                if (hw_ctrl) {
                ^~~~~~~~~~~~~

Fixes: c888183b21f3 ("wifi: rtl8xxxu: Support new chip RTL8188FU")
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8188f.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8188f.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8188f.c
index 99610bb2afd5..0025bb32538d 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8188f.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8188f.c
@@ -412,7 +412,7 @@ static void rtl8188f_spur_calibration(struct rtl8xxxu_priv *priv, u8 channel)
 	};
 
 	const u8 threshold = 0x16;
-	bool do_notch, hw_ctrl, sw_ctrl, hw_ctrl_s1, sw_ctrl_s1;
+	bool do_notch, hw_ctrl, sw_ctrl, hw_ctrl_s1 = 0, sw_ctrl_s1 = 0;
 	u32 val32, initial_gain, reg948;
 
 	val32 = rtl8xxxu_read32(priv, REG_OFDM0_RX_D_SYNC_PATH);
-- 
2.37.3

