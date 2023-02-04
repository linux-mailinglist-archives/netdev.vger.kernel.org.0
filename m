Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69D7B68AD73
	for <lists+netdev@lfdr.de>; Sun,  5 Feb 2023 00:30:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232569AbjBDXae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 18:30:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbjBDXab (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 18:30:31 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFA3B20D3F;
        Sat,  4 Feb 2023 15:30:29 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id k4so24897643eje.1;
        Sat, 04 Feb 2023 15:30:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z2OOn9fRXNRi/D1wH37mZYRXmM0quMrDez5IgGiosfE=;
        b=SEpEv7LYUi6fgDWjw58MnVru5yw3PR4Nv9F5hz9BybL1VI5ncXJWDCa0A+RMTUDTW9
         VS8x1Johk107INT5c6XKACchwDjsJ0wAKpkXTkITuGwAp5pzu2vO7jr7cKFksMJjXtcm
         zxSWaqoudv9upUL1uek3oEHUBglZUOozLKhCsV5nKOIoyGDfMO/UwmKMQTD3LSfYPtNj
         pt6rLNM19iVCnjUaRNrQQznFMYJAZ/IoIeHyUAbImG6dGVd9lvmPCZh9LAlwoyMqk0iN
         O4utBltvi7sqz6ohwpgxCXeHKzGKRzmcn4WWX6YlXNGKdGXM+bnL4jkzDBhW9LxcGsUn
         mcXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z2OOn9fRXNRi/D1wH37mZYRXmM0quMrDez5IgGiosfE=;
        b=sgMjfN1WG5x+ypSUh8sRoMbEB1MnJHaFPSUWAvvXwCmpFdNdgmuqeefrTLpgtcRYAd
         2WfY8jYcO7wHxVfWbjc3BEVLFS4W21b5w9OzIvQ0BpR/5mX9/WNcNwpMb+NBNWttfNXA
         nWNlPFXEidOI1fk0QRRqaVE7an8RM6pdGa78uJuUkLbTeKC8v5c0iq4qDBGfpdvgH6hf
         gNlymxyBfz3GHTvjQXcq27EKzsdNd3Ep9WcCnSb3k44qNSX1zSaOqTjFmazfhxwAlFbz
         YQ7ppu265Nb7xPMgwOqZ7C5ktle3hzl0cWFqcoBCt62+QD6Uyt7Y2jmMGb2fO9TtR5Am
         gl5Q==
X-Gm-Message-State: AO0yUKWkpZyKTdAdMrol7oOUk15ZCOeh1adnCgGjsOoanRcNeMMt964x
        LfKMspovPIsvfIdSuFBKk7j+8f8FQio=
X-Google-Smtp-Source: AK7set9RFpSCBsOLZmbEz9QMqDpnQ3kXDdCfwx9PGfRzdBnIj20vsnMnQFO91WSbWBcbTxeHRtcGFg==
X-Received: by 2002:a17:906:5658:b0:878:7b5c:3811 with SMTP id v24-20020a170906565800b008787b5c3811mr13627277ejr.42.1675553428265;
        Sat, 04 Feb 2023 15:30:28 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c22-7777-cc00-f22f-74ff-fe21-0725.c22.pool.telefonica.de. [2a01:c22:7777:cc00:f22f:74ff:fe21:725])
        by smtp.googlemail.com with ESMTPSA id v5-20020a1709061dc500b0084d4e9a13cbsm3386658ejh.221.2023.02.04.15.30.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Feb 2023 15:30:27 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     tony0620emma@gmail.com, kvalo@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>, pkshih@realtek.com,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v2 4/4] wifi: rtw88: mac: Use existing macros in rtw_pwr_seq_parser()
Date:   Sun,  5 Feb 2023 00:30:01 +0100
Message-Id: <20230204233001.1511643-5-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230204233001.1511643-1-martin.blumenstingl@googlemail.com>
References: <20230204233001.1511643-1-martin.blumenstingl@googlemail.com>
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

Replace the magic numbers for the intf_mask with their existing
RTW_PWR_INTF_PCI_MSK and RTW_PWR_INTF_USB_MSK macros to make the code
easier to understand.

Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---

Changes from v1 -> v2:
- reword subject and include the "wifi" prefix
- add Ping-Ke's Acked-by


 drivers/net/wireless/realtek/rtw88/mac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/mac.c b/drivers/net/wireless/realtek/rtw88/mac.c
index 98777f294945..4e5c194aac29 100644
--- a/drivers/net/wireless/realtek/rtw88/mac.c
+++ b/drivers/net/wireless/realtek/rtw88/mac.c
@@ -217,10 +217,10 @@ static int rtw_pwr_seq_parser(struct rtw_dev *rtwdev,
 	cut_mask = cut_version_to_mask(cut);
 	switch (rtw_hci_type(rtwdev)) {
 	case RTW_HCI_TYPE_PCIE:
-		intf_mask = BIT(2);
+		intf_mask = RTW_PWR_INTF_PCI_MSK;
 		break;
 	case RTW_HCI_TYPE_USB:
-		intf_mask = BIT(1);
+		intf_mask = RTW_PWR_INTF_USB_MSK;
 		break;
 	default:
 		return -EINVAL;
-- 
2.39.1

