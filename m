Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E63BA6A3472
	for <lists+netdev@lfdr.de>; Sun, 26 Feb 2023 23:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbjBZWKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Feb 2023 17:10:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjBZWKs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Feb 2023 17:10:48 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 326E3166E8;
        Sun, 26 Feb 2023 14:10:39 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id ck15so18740062edb.0;
        Sun, 26 Feb 2023 14:10:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rtTWNey+IhA3so2SGQ580fEgKs+YQCQ1nD7d9f+iKpk=;
        b=g6OD0Sobyoh+3CtHzK26UIeZLP1E8fkjPqDgedG9ARvpEBu6XbRV6Fm4ivGDIZydDy
         5njuKLrdbTxir6xHDoZlhKdP3VZkymMJwmAEKeFLUUWH4lNtsrSYG70LUb4uLj6i89mK
         OiGK1egkaUa7Bk3aCPl9CEWavdGtaqTbUpp1yvYoCkcDuDE7n24HnGdCZgW3Q56N5kEf
         l+5uFTkZyteafs+qsOg7eah9M69NNJo47ABoXxfUD4Ws6oekHpXnl6BI8I9wBOfC+2KJ
         7IZhP4tjTYbZWUMONXzBS4dQoi68AP/ss598U5sNLRdsWN0b1zd6z+o6/tat4DYNJoMT
         cFsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rtTWNey+IhA3so2SGQ580fEgKs+YQCQ1nD7d9f+iKpk=;
        b=3VBvv7Eu6vt/4OH5+1jm9GBAvpXNJ0AW2/ZcvPYIyoOsVycD4XCHNGgMMWPUBm6McO
         gMN59+hXfzbSnlKiPXqLGI/vkwU4W1MLxfzMJKBS1ACv1zu5o/USgFWUsoyQc7HCuWuB
         Kln0+aAESi9/CZsywTSS7paIHH//zsTQEbL8taRpbWj0hHBQv5QsH4EPh0Z1jRZIFAWp
         JbQRvW1EFKiqxRru7D2+iCzdQKFq0f64pYykziLGlgw7NO0vW1Ot3Ab2bs5V+lZIYdLp
         NyystHLcxmu6Ap8z+hrnRJOOsDdFtqjViFeAZ+Dn7rVQiFXtxxAIoGPUyePbKSfTRsG/
         27Yw==
X-Gm-Message-State: AO0yUKVEY+u3LvIqYCgZ/uVRDeO2gjUvNYBzt6DB8X/AxLYUD5BSQWrA
        jmYxj2sSwCTTj+nVDV7Mdmp4fFga0oU=
X-Google-Smtp-Source: AK7set/O82VDpkK8rWQbyF0R+JEpLnIxDiUqyank23OH1p9CpYG/fOAb4TALHVHVbh29Q/NzcoEIow==
X-Received: by 2002:a05:6402:40ce:b0:4af:51b6:fe49 with SMTP id z14-20020a05640240ce00b004af51b6fe49mr7744081edb.13.1677449437284;
        Sun, 26 Feb 2023 14:10:37 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a02-3100-9483-fd00-0000-0000-0000-0e63.310.pool.telefonica.de. [2a02:3100:9483:fd00::e63])
        by smtp.googlemail.com with ESMTPSA id 26-20020a50875a000000b004a21c9facd5sm2390752edv.67.2023.02.26.14.10.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Feb 2023 14:10:36 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvalo@kernel.org, tony0620emma@gmail.com,
        Ping-Ke Shih <pkshih@realtek.com>, Neo Jou <neojou@gmail.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v1 wireless-next 2/2] wifi: rtw88: mac: Return the original error from rtw_mac_power_switch()
Date:   Sun, 26 Feb 2023 23:10:04 +0100
Message-Id: <20230226221004.138331-3-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230226221004.138331-1-martin.blumenstingl@googlemail.com>
References: <20230226221004.138331-1-martin.blumenstingl@googlemail.com>
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

rtw_mac_power_switch() calls rtw_pwr_seq_parser() which can return
-EINVAL, -EBUSY or 0. Propagate the original error code instead of
unconditionally returning -EINVAL in case of an error.

Fixes: e3037485c68e ("rtw88: new Realtek 802.11ac driver")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/wireless/realtek/rtw88/mac.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/mac.c b/drivers/net/wireless/realtek/rtw88/mac.c
index 4749d75fefee..f3a566cf979b 100644
--- a/drivers/net/wireless/realtek/rtw88/mac.c
+++ b/drivers/net/wireless/realtek/rtw88/mac.c
@@ -250,6 +250,7 @@ static int rtw_mac_power_switch(struct rtw_dev *rtwdev, bool pwr_on)
 	const struct rtw_pwr_seq_cmd **pwr_seq;
 	u8 rpwm;
 	bool cur_pwr;
+	int ret;
 
 	if (rtw_chip_wcpu_11ac(rtwdev)) {
 		rpwm = rtw_read8(rtwdev, rtwdev->hci.rpwm_addr);
@@ -273,8 +274,9 @@ static int rtw_mac_power_switch(struct rtw_dev *rtwdev, bool pwr_on)
 		return -EALREADY;
 
 	pwr_seq = pwr_on ? chip->pwr_on_seq : chip->pwr_off_seq;
-	if (rtw_pwr_seq_parser(rtwdev, pwr_seq))
-		return -EINVAL;
+	ret = rtw_pwr_seq_parser(rtwdev, pwr_seq);
+	if (ret)
+		return ret;
 
 	if (pwr_on)
 		set_bit(RTW_FLAG_POWERON, rtwdev->flags);
-- 
2.39.2

