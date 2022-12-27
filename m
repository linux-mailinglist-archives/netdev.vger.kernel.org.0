Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0295657103
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 00:30:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232151AbiL0Xao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 18:30:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231771AbiL0Xal (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 18:30:41 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D661FB30;
        Tue, 27 Dec 2022 15:30:37 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id i9so20869954edj.4;
        Tue, 27 Dec 2022 15:30:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h1onIReQ5ODXVSyv0b1/9HLSWm0hUVA7Xk38y7M8c2U=;
        b=Df8qMwCuW8cm4WyFWmo2vn9IeBhUpQbbxzTpBts52ctPvyR66nbu95qWp0nuVkXbWT
         8DyaeshDFmzvg48x2tAxGuhtJVxRNkOUGXewKplLtkyIqlTYqhF5uGRCHpSIrhBvAQYc
         RRpwYhZWwGMfUK1yiyUq3/x6iPJaIk/OX3e9hdbsdhgTGwOTgoCBJPvEzJvg8VPhVcPt
         5AV6gzEeN4izFixPg2s6xkJFAkFrW0iEhFF6A9wHuADDb66qsSHKrCPuf38UX+u5ukH0
         7LA7Vp7KcN/07WaXqq9rJnVs9jcJ2nkq8i7OOSgREVy3JxxCP/I1QNbiI7Y8/0dHsUo8
         v+vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h1onIReQ5ODXVSyv0b1/9HLSWm0hUVA7Xk38y7M8c2U=;
        b=kSHgaspvNBV12/4toCVG0DQ3mgBqfhlGQAEXuyTD5OlgCf+evf7MiIer7SBNJE7ijJ
         4fEp7Uvb6pbzCSCrT8dkROtykvYF49capmceMXWGNx8sYezu26fUrrAeGBGmGmT4V042
         6rHnWlSE8MqjdT4C6OnBxW4PKk3AqzaIpKOY+qHUpgUnBRKF4LQKDctB7cle7IALqtiu
         4+xWSG2kMSfTmx35pNIgcCqFihAwq+htzyDcPU+UdxsTBP4IW/YT4/aOeVCzqADnRtTA
         tCb1u1V9eVNWw+9fSaDIudbt4vOkcvyIkZE79wd+Oam4KNiaNEue/eMzJ8NkKg3QwnHN
         b0yg==
X-Gm-Message-State: AFqh2kp2eoYCRpyfxL0Ip3d0y0PQ33ppwyAwgR3bTpN2MwkKDECNhRtz
        ObHug8L2k6/Yvsg/cYn/vsClevkl+1U=
X-Google-Smtp-Source: AMrXdXuC3Lrm0vqhcWSxgt9v2Dlw0EC+6jU6Yug/OR3FfYch83uV5zHH3+QRNBOfBNMFCGHdpUGU0g==
X-Received: by 2002:a05:6402:5145:b0:462:7b85:33aa with SMTP id n5-20020a056402514500b004627b8533aamr19561385edd.2.1672183835963;
        Tue, 27 Dec 2022 15:30:35 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c23-c4cf-d900-0000-0000-0000-0e63.c23.pool.telefonica.de. [2a01:c23:c4cf:d900::e63])
        by smtp.googlemail.com with ESMTPSA id r7-20020aa7c147000000b0046cbcc86bdesm6489978edp.7.2022.12.27.15.30.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Dec 2022 15:30:35 -0800 (PST)
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
Subject: [RFC PATCH v1 01/19] rtw88: mac: Use existing interface mask macros in rtw_pwr_seq_parser()
Date:   Wed, 28 Dec 2022 00:30:02 +0100
Message-Id: <20221227233020.284266-2-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221227233020.284266-1-martin.blumenstingl@googlemail.com>
References: <20221227233020.284266-1-martin.blumenstingl@googlemail.com>
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

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
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
2.39.0

