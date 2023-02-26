Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 399106A3470
	for <lists+netdev@lfdr.de>; Sun, 26 Feb 2023 23:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbjBZWKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Feb 2023 17:10:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbjBZWKs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Feb 2023 17:10:48 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53A2412F28;
        Sun, 26 Feb 2023 14:10:38 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id o12so18431104edb.9;
        Sun, 26 Feb 2023 14:10:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WNtzPJy13uvz5eTqnpV/5PmEiW1tVMUFwhuU1sV8ZoQ=;
        b=p8wgKg5mwE+HMznl2mIJKa7yw2wzed4HtTigWMBY1mqJqv6WfqjcvF/RQF+ug/ifue
         9tBYSk7tSTXfUndgI6p2rcOZlu8TDsqfB5VYMMp7iCrFRfzruM1wCsjAsE4h+NGyWOZ5
         i4VP7suTyHlK6051Y20JpMft06yBWePNXJhs0ZuDUAh5hjcIbKbGL7N9hjBu/0Wwia5p
         Hr8A/uxH/Wt1dZmLrHBS0blGawF/PxWZRYWl/S5MDl7Hh/eDB00lyymuJzAd++JjK2GN
         E9aabCJUoilCSSz8Y91WtxFHuswfTxsFJ4/a5S6S4fKhX1x6dBIyu0ZLCKz8kGqy561i
         jBjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WNtzPJy13uvz5eTqnpV/5PmEiW1tVMUFwhuU1sV8ZoQ=;
        b=XPWwaEsKaNGRAcq7JbF6/btiAq5VrRwMA1y8nTNfstZIQc6EJoXrm8nPU46xjXBuOe
         C/1EuGFfZeE1tqf8t1tM9m5+m6CTv4czmVoW8lk6GBW8+0QwgznouPfgEOuIbE7Pkayi
         At1EtDYegqonh86809t5/rMzelgWTuAchwzXFQZbNCUxP/R9j2rRvRoglrjWaLy7s6u9
         9+guXmo1/60YiczWlFBtkLlrq2VHgexkS186CXmZxN/JAmT833XX3xdkEIA2n3p2OE8E
         SQItGX22sNShz/HhI9B4XJ7HkdSrkfkFYk2C8Evg7eZGYhF4N/xDw6qGFsr/v9Sz9SX8
         CUhg==
X-Gm-Message-State: AO0yUKWRkHsUhEIJioRenI2s6raO4fbLmWJgcFn/O/X4Fq/zn/RSVwHF
        tiLRvHxScoINhK24zFEXF+fUpEIP1W0=
X-Google-Smtp-Source: AK7set8fJ82hXVVDr/S7LQi89YBuAl0MFAEjLGYSIEnrhIAMUy1FIj+ixiXxIORI1iO6x69DuN1tWA==
X-Received: by 2002:a17:907:6e10:b0:8ec:4334:fe with SMTP id sd16-20020a1709076e1000b008ec433400femr21334487ejc.26.1677449436517;
        Sun, 26 Feb 2023 14:10:36 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a02-3100-9483-fd00-0000-0000-0000-0e63.310.pool.telefonica.de. [2a02:3100:9483:fd00::e63])
        by smtp.googlemail.com with ESMTPSA id 26-20020a50875a000000b004a21c9facd5sm2390752edv.67.2023.02.26.14.10.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Feb 2023 14:10:36 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvalo@kernel.org, tony0620emma@gmail.com,
        Ping-Ke Shih <pkshih@realtek.com>, Neo Jou <neojou@gmail.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v1 wireless-next 1/2] wifi: rtw88: mac: Return the original error from rtw_pwr_seq_parser()
Date:   Sun, 26 Feb 2023 23:10:03 +0100
Message-Id: <20230226221004.138331-2-martin.blumenstingl@googlemail.com>
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

rtw_pwr_seq_parser() calls rtw_sub_pwr_seq_parser() which can either
return -EBUSY, -EINVAL or 0. Propagate the original error code instead
of unconditionally returning -EBUSY in case of an error.

Fixes: e3037485c68e ("rtw88: new Realtek 802.11ac driver")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/wireless/realtek/rtw88/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/mac.c b/drivers/net/wireless/realtek/rtw88/mac.c
index 1c9530a0eb69..4749d75fefee 100644
--- a/drivers/net/wireless/realtek/rtw88/mac.c
+++ b/drivers/net/wireless/realtek/rtw88/mac.c
@@ -236,7 +236,7 @@ static int rtw_pwr_seq_parser(struct rtw_dev *rtwdev,
 
 		ret = rtw_sub_pwr_seq_parser(rtwdev, intf_mask, cut_mask, cmd);
 		if (ret)
-			return -EBUSY;
+			return ret;
 
 		idx++;
 	} while (1);
-- 
2.39.2

