Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B30AC6B51D5
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 21:29:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbjCJU3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 15:29:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231510AbjCJU3r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 15:29:47 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C27F5E4C51;
        Fri, 10 Mar 2023 12:29:45 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id cy23so25316398edb.12;
        Fri, 10 Mar 2023 12:29:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112; t=1678480184;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GIn1AgV2sGuDsJHCIDtNHKXft4I0Zm5REzo0371LmhQ=;
        b=AEykxNa6BcHgbOMyB3tP/sG9MFk1PgPLuIXmuPWppHLW/zgRPmvHuYhRQVafg3xhTa
         JWw1aVxDCCKl/LCQvzMF9tICmiFwHV2eMXHw3NK65xAaN3a7xU8G5vqPpUfMHrLwn0A+
         do7JTQD/IMt8+rh/lfhx6V5LoFzC1gTiEQSptOGkYbxfG5Omac55DqoDl7Cp3B8743NU
         PtfEBhHQXDbJuJHhody0qxXXRameZLfslEqt8em0IkWGcvyLruGSiahpcsVxcGKyF2ZQ
         bdZ269Vd6Q9Or0osLyJ+JJBjLHPLHE3ohhpukNgifayqcVkmCmUP+im7ZVyudBHEMgRX
         fRlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678480184;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GIn1AgV2sGuDsJHCIDtNHKXft4I0Zm5REzo0371LmhQ=;
        b=UBcquoJlqLQ93u8D+tEFixgcrMmItQjeHeoViObVuX7/DERbDdjC44YysYAHNCgM2N
         4NhDtFt3ka3yfoFuTivuxhaMVrNpL0/Cb8dIQ2lghNUO7a2NX6AfSpm6wbU4P7gUwugj
         kO/2Tol91xax9L5wQ4UnRj1dM+l4aAk1S2rMqPuNzDnCenLNP+XrVpwFQRMGc2CH+sWW
         v13hKIK0xXYeGOwVdwSN9+k/FcwnBYBd/UYsJKOzB9TgOC7AUn8FPACQaD9rTL7/5ggB
         Ppbn1+U8XhO/jbxLdsWimyiQZeBeR7LpB7X1iVN5Z7S1G/SOMlC3BFmB8B+xH55I/6h2
         uQmg==
X-Gm-Message-State: AO0yUKV0g0FyLPxporJYQFkqOvpGMnTKbCsP3BYAFh+8s+LSnt8cyT3L
        H1HVl0tull3hrFXUrjL5d2ofcWzkI+g=
X-Google-Smtp-Source: AK7set/T0wyIVEnhrHRWXWwPaUFN+atvVDmEoibzsRbtl07Hy1CPKWo5GLEA7OMFoW12ik8AYZdpjg==
X-Received: by 2002:a17:907:9494:b0:8ec:4371:19c2 with SMTP id dm20-20020a170907949400b008ec437119c2mr34790397ejc.73.1678480184037;
        Fri, 10 Mar 2023 12:29:44 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c23-b84f-c400-0000-0000-0000-079c.c23.pool.telefonica.de. [2a01:c23:b84f:c400::79c])
        by smtp.googlemail.com with ESMTPSA id md10-20020a170906ae8a00b008e34bcd7940sm259047ejb.132.2023.03.10.12.29.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 12:29:43 -0800 (PST)
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
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v2 RFC 1/9] wifi: rtw88: Clear RTW_FLAG_POWERON early in rtw_mac_power_switch()
Date:   Fri, 10 Mar 2023 21:29:14 +0100
Message-Id: <20230310202922.2459680-2-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310202922.2459680-1-martin.blumenstingl@googlemail.com>
References: <20230310202922.2459680-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
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

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
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
2.39.2

