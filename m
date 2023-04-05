Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 868B96D87BA
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 22:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233800AbjDEUHq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 16:07:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233280AbjDEUHn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 16:07:43 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 512A03C38;
        Wed,  5 Apr 2023 13:07:39 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id y4so144054872edo.2;
        Wed, 05 Apr 2023 13:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112; t=1680725257;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WO38kEmYBLiR9apBDiKwyBSAdNe1y1sU2/3Yb1rUmYo=;
        b=jsrVBzby5D4BDCQbj3GR5B6c6T32GV99fkjthoYWR2b1cVxDM21r5HvI9R8Us9NVKJ
         CP2hxhw6lcnzqTwF8wROcO5xe0ve++moT1prhGs4+LLRIsdM8qj14izeg/H3+E9nRwFS
         1vvrIV1nBmTIIuVKeXp9PIURKub2QR6DJ1F1Uc2nFv2LQXdzF0vywUrASg7t8zkERb14
         BpCivtxpd0ZcRaBG0HlhYI8KFVKQXQqxjv9X3kToXvsV+5QuDn49Hr/iEcZCoX1lz0gk
         LsfLuvwyrODCVnBNEugwmh3a8aLZnDwJ45KOb7utvoJ1THTEcB/jM85F1Ju4csjHiijx
         5MVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680725257;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WO38kEmYBLiR9apBDiKwyBSAdNe1y1sU2/3Yb1rUmYo=;
        b=7gQ0egpQ5WTejuigI17jvN+pbIX1H6p+vEsqGUaUpKCdKEGPTfmo+kcrwrMrnt7WC6
         6sivTcuimzObPOhrcrjDYAWfHzwQI091RBQLGK0rr239EU0MSpuHaF6iPkTYBHCSLyZT
         6WCd0GZMbaqFU7PpHDp9sS2pYzc1SedbzjU7LGbXvBHuCmj9BVouFG4bfnSMKo08yEhN
         oJ2NdwapX4DrOOQVEbzH2ySJFUVCIN5Nxgx2Fk5SypsYS/K7xhO05dI2xCjIkj+0SBOG
         hwegCBGWsmBzXga/hdFcfJpdUyUECfsOy4e2ugg1DyrT7pWgtW1kE2gRRhUWRYlNRBC1
         UYwA==
X-Gm-Message-State: AAQBX9eUUq3VvGBP/sPyvWxuLDVrBLnl9dM9zCD8FxNPVS2imYoNf2Ko
        fLS1VIljX7g8YQ+SzvIzGt/qz0Up9ZEdvA==
X-Google-Smtp-Source: AKy350ZyXvCoZGazUJThTS6AbtPbulJXy/HPU+72wR4lh+x/3oybHn8hN5z4AB68Bd9JlQd8+ZSDCA==
X-Received: by 2002:a17:906:3c13:b0:947:895a:bd82 with SMTP id h19-20020a1709063c1300b00947895abd82mr4113693ejg.56.1680725257434;
        Wed, 05 Apr 2023 13:07:37 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a01-0c22-7a4e-3100-0000-0000-0000-0e63.c22.pool.telefonica.de. [2a01:c22:7a4e:3100::e63])
        by smtp.googlemail.com with ESMTPSA id a23-20020a170906369700b0092a59ee224csm7724873ejc.185.2023.04.05.13.07.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 13:07:37 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-mmc@vger.kernel.org, Chris Morgan <macromorgan@hotmail.com>,
        Nitin Gupta <nitin.gupta981@gmail.com>,
        Neo Jou <neojou@gmail.com>, Pkshih <pkshih@realtek.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Simon Horman <simon.horman@corigine.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v5 1/9] wifi: rtw88: Clear RTW_FLAG_POWERON early in rtw_mac_power_switch()
Date:   Wed,  5 Apr 2023 22:07:21 +0200
Message-Id: <20230405200729.632435-2-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230405200729.632435-1-martin.blumenstingl@googlemail.com>
References: <20230405200729.632435-1-martin.blumenstingl@googlemail.com>
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
Changes since v4:
- none

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

