Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF1956D5260
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 22:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233294AbjDCUZj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 16:25:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232429AbjDCUZ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 16:25:29 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7FD835A9;
        Mon,  3 Apr 2023 13:24:56 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id l37so17795488wms.2;
        Mon, 03 Apr 2023 13:24:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112; t=1680553494;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KQ+60A8XCWlvtT1qOzVKT5c/Do/fHJEKL+FyN+sj3M8=;
        b=Gnfk6ZQ+Q+abkUPd89x7HyrN6jBJzIZRdv8Eu6oHm/Zorr/Lr6FOeMnVsljB7PWZns
         D6mAm0w8bWVVbFRFZKlNuohBdVSTw6QWsy1FgGi+z6WZtC5/cCzinSN39ZYizmjomFfJ
         qevnIRbANhue1mx8AMpUn5s1fakEkNk9Ah+DtpTa9BaZBmAxED6svuklEtqPd6SN3HLD
         fQtrungFtWCXJ4Z1yKZjOIINMU4ueSYxvKv1WJVxBgXoYVhr63Hgy1VuCH8mQxAerBZv
         NbGUxCcM+hmdDUQVq8w2joEMrR/6f0Uy07z3DvBz/BbfyH/whq4kACMl0Vv3Mf45Vy5O
         Z/CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680553494;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KQ+60A8XCWlvtT1qOzVKT5c/Do/fHJEKL+FyN+sj3M8=;
        b=FD7g96Exmp3DAwLCoziqsVaz+XGOgnhQSJ9AzkVX3AeTWrlrMFEj2Pf0lbb+8YtUuG
         rox7+NU9w3ajSP5+NLFRCy37dpgUVtY4NcLxq9otz1oaOSMIZlBnyaRQhGfafhqPQrdG
         /UFm1QOEtx1ly66jguTmbvKLN1TMsBvjXw7NlXfN+hnw1+vWczZh+QSH+tBp3ITD47w/
         QfQsNb+oXH4uKYTWLUubfkz/HbdMHe/80DHaf1AIe1Ez3gxTFohw0b99qofyWB4mUkzk
         mqK/JrAGymL8YSzvgh85t5rVG9ichzKm5HCAAxfU0zKKJIWqGgpZrrQ4a8Y7H/k/SW6O
         eMIw==
X-Gm-Message-State: AAQBX9eqKyadxZ/eXgN0ni9f7SbO12o53rC+dd4Z+2fwc0CbRNZKkC7I
        73yhH5pB02uXQxShIj9Ib6VDwwOS6DY=
X-Google-Smtp-Source: AKy350aqt1k3SgCOQGOAslm7LKUhptEerjeUBV9lR2vcWgghufxaG7SZYleg3zlSve63X1ke4TD8+g==
X-Received: by 2002:a05:600c:214:b0:3eb:2e27:2d0c with SMTP id 20-20020a05600c021400b003eb2e272d0cmr231996wmi.1.1680553493976;
        Mon, 03 Apr 2023 13:24:53 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a01-0c22-7651-4500-0000-0000-0000-0e63.c22.pool.telefonica.de. [2a01:c22:7651:4500::e63])
        by smtp.googlemail.com with ESMTPSA id 24-20020a05600c021800b003ee1acdb036sm12845895wmi.17.2023.04.03.13.24.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 13:24:53 -0700 (PDT)
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
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v4 1/9] wifi: rtw88: Clear RTW_FLAG_POWERON early in rtw_mac_power_switch()
Date:   Mon,  3 Apr 2023 22:24:32 +0200
Message-Id: <20230403202440.276757-2-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403202440.276757-1-martin.blumenstingl@googlemail.com>
References: <20230403202440.276757-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
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

Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
Changes since v3:
- added Ping-Ke's reviewed-by (thank you!)

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

