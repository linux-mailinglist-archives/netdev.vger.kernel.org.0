Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92F3C6C23CE
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 22:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231133AbjCTVgF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 17:36:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230452AbjCTVgD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 17:36:03 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4331B6A4E;
        Mon, 20 Mar 2023 14:35:25 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id h8so52326011ede.8;
        Mon, 20 Mar 2023 14:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112; t=1679348123;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iaA7NBVMrZmsPW6yrPvN7sDVRCh1/pGYAWSc+tho3oc=;
        b=JP6xNb6/aBRNMVW7z1+GlK+izHX4lvOr8FQRzh/hI0CWbCmCUVkvTPgpybGFYhOw2s
         WE8m4UsjMN4+3Y7UNtTX8laGbE88Lo5xXGJE0ZAA3mYnKT7HTafvw0gSyWL6GUEYscm7
         qyQY+45cHQsJBQ9pVEXjVWfbima9fkz8qnfBCBYRE5kJb2F11JXh7g1CJsPJFYIFy95O
         dlsiGtBGipO59fs1Iaep4NX27CPI3icbEsjuYiPLpaRIfD3wY/NDo+ULJph288FwUOQB
         Q/pSaeQTjJYsRpTxaMFnIYGIgMwOqQ/aPtNpjNQ3N4ipE6KO7sraJSQUg7i8uncG4NnJ
         hH/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679348123;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iaA7NBVMrZmsPW6yrPvN7sDVRCh1/pGYAWSc+tho3oc=;
        b=bDaUeRHfQiU+X3xzb3s2j9ZP6qkj8UmnOpxp4ctzNxQcxmzxXPW2SmPYip1534Rqkk
         n5odr8XY85PtBaoLNI4bBWk9RZHzC+9w7uMusHvZSJTyOG4zi4Nt2r0lt1kNz983MZEY
         fvcq4rXrvaa1ev4NsgtXNyRt7+CqLSB9dtDyx5RrZRaePrq3CSvcm03dCNTHwGrl1IQv
         +jsTnUZMD7atIlNBOuURVw4MwMdueYEdRJHRFjRV/1vepsW90RK7M5V2bEIw6YfTmVvz
         12spYnSJEJkNMjhyGfUVIrbOJmcvZP8KUsuGXYZSuCVs7yEManYvpxx2IgIH+IC2IQ5J
         IwTg==
X-Gm-Message-State: AO0yUKUFVIbHzNOax25bzFrUh/cdYr+SxH1Ov5B+LjX5bnEqk19qOCgH
        AStHja2N+9edoUH0da+YA9Dg+IJA5ls=
X-Google-Smtp-Source: AK7set91d0bsoDvXTT2gvnpK4a+8W6sDh86jOXRmRaTj8ONhwFSLkl28UlNXas3+qHr2gcY7/MBSiw==
X-Received: by 2002:a17:906:578d:b0:92c:138e:ff1f with SMTP id k13-20020a170906578d00b0092c138eff1fmr532251ejq.18.1679348123144;
        Mon, 20 Mar 2023 14:35:23 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a01-0c22-73dd-8200-0000-0000-0000-0e63.c22.pool.telefonica.de. [2a01:c22:73dd:8200::e63])
        by smtp.googlemail.com with ESMTPSA id z17-20020a5096d1000000b004aee4e2a56esm5413201eda.0.2023.03.20.14.35.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 14:35:22 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-mmc@vger.kernel.org, Chris Morgan <macroalpha82@gmail.com>,
        Nitin Gupta <nitin.gupta981@gmail.com>,
        Neo Jou <neojou@gmail.com>, Pkshih <pkshih@realtek.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v3 1/9] wifi: rtw88: Clear RTW_FLAG_POWERON early in rtw_mac_power_switch()
Date:   Mon, 20 Mar 2023 22:35:00 +0100
Message-Id: <20230320213508.2358213-2-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320213508.2358213-1-martin.blumenstingl@googlemail.com>
References: <20230320213508.2358213-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
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

The SDIO HCI implementation needs to know when the MAC is powered on.
This is needed because 32-bit register access has to be split into 4x
8-bit register access when the MAC is not fully powered on or while
powering off. When the MAC is powered on 32-bit register access can be
used to reduce the number of transfers but splitting into 4x 8-bit
register access still works in that case.

During the power on sequence is how RTW_FLAG_POWERON is only set when
the power on sequence has completed successfully. During power off
however RTW_FLAG_POWERON is set. This means that the upcoming SDIO HCI
implementation does not know that it has to use 4x 8-bit register
accessors. Clear the RTW_FLAG_POWERON flag early when powering off the
MAC so the whole power off sequence is processed with RTW_FLAG_POWERON
unset. This will make it possible to use the RTW_FLAG_POWERON flag in
the upcoming SDIO HCI implementation.

Note that a failure in rtw_pwr_seq_parser() while applying
chip->pwr_off_seq can theoretically result in the RTW_FLAG_POWERON
flag being cleared while the chip is still powered on. However,
depending on when the failure occurs in the power off sequence the
chip may be on or off. Even the original approach of clearing
RTW_FLAG_POWERON only when the power off sequence has been applied
successfully could end up in some corner case where the chip is
powered off but RTW_FLAG_POWERON was not cleared.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
Changes since v2:
- improve patch description about corner cases when clearing
  RTW_FLAG_POWERON

Changes since v1:
- This replaces a previous patch called "rtw88: hci: Add an optional
  power_switch() callback to rtw_hci_ops" which added a new callback
  to the HCI ops.


 drivers/net/wireless/realtek/rtw88/mac.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/mac.c b/drivers/net/wireless/realtek/rtw88/mac.c
index f3a566cf979b..cfdfc8a2c836 100644
--- a/drivers/net/wireless/realtek/rtw88/mac.c
+++ b/drivers/net/wireless/realtek/rtw88/mac.c
@@ -273,6 +273,9 @@ static int rtw_mac_power_switch(struct rtw_dev *rtwdev, bool pwr_on)
 	if (pwr_on == cur_pwr)
 		return -EALREADY;
 
+	if (!pwr_on)
+		clear_bit(RTW_FLAG_POWERON, rtwdev->flags);
+
 	pwr_seq = pwr_on ? chip->pwr_on_seq : chip->pwr_off_seq;
 	ret = rtw_pwr_seq_parser(rtwdev, pwr_seq);
 	if (ret)
@@ -280,8 +283,6 @@ static int rtw_mac_power_switch(struct rtw_dev *rtwdev, bool pwr_on)
 
 	if (pwr_on)
 		set_bit(RTW_FLAG_POWERON, rtwdev->flags);
-	else
-		clear_bit(RTW_FLAG_POWERON, rtwdev->flags);
 
 	return 0;
 }
-- 
2.40.0

