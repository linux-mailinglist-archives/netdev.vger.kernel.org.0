Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68779657113
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 00:31:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232598AbiL0XbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 18:31:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232483AbiL0Xay (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 18:30:54 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CEB4DED5;
        Tue, 27 Dec 2022 15:30:45 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id b88so13595040edf.6;
        Tue, 27 Dec 2022 15:30:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YaL9++5/wfs1MVtqhD+aK5GRmljQ+ncXaK8G/SyoCYA=;
        b=V+1tmN6IeYc7cQVzpdQQEGr6cdYbtX1xkGlLY73RuW0o6HanAQyNubEMT6TEX03XIp
         wpll0fCMqyXAqhtoAQz4LqYvWPjGb25rlSRYWkXbnw8ZGeHNyvEXY5Ax3QH6JR9LQ4Fo
         iMynJ4OYJk6RjcP0D22XyQoX4riDWY6Zdaps8pB5GBhjsGR0DV8/tMqELR+PEYhjQJJZ
         AheI7mgNg2ttV2iSsYrVBqvZqkBuAUdiyPF9YuadS179fcYJZc2Yfvhahh+t/0Zh7Imw
         18cagXdQsTDyqDpOAUsflOxdPaNgkPm8egzCuaCdjC23V6gjFBmL20J7tWacuombl4M8
         1ypg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YaL9++5/wfs1MVtqhD+aK5GRmljQ+ncXaK8G/SyoCYA=;
        b=GVmvUQBjX0mFdlziMBUJECKXXTmrXUYyemdiPkRDU7kKtsZHb5HyDhAVGxK4rDM3Pt
         LfQFvMvJmf+Vn0NF/f2yoh0eqsN5KMpd4S55IAR+pBtLlEK8gc6TZ2DvMROsH3kWmpQI
         n4EY+KKBTS8+er4RzCUlr+DaYD6yJga+yDf3o/2852Y6s3tNrDqsEmaXivUwlykgStQk
         Smwo3aNrVdwk51sanOpByxKZv7FucbIxWQkAw7a20ct6e4GJmtgL78tmJi15mzMzTosi
         eBxt0IcDP7ZBAPW3sGqrpK378JGOw7f5fLqaoVLnK8bG6ezi/S3ezDlw0dO1VOXExXMq
         KsSg==
X-Gm-Message-State: AFqh2kpnbeW1LGtD/HReZIxKcvdTs6vagJxveHg5Rb9bvheF8j0vz3GT
        7BWmqENfMfFn7SUD8FMnLOlMtheU/i4=
X-Google-Smtp-Source: AMrXdXtsMVFApahSdC8eXR6eymLJm2FGMn6nsnE1CscohpsNBKfCufIUPgYGrzD/qHH0f/lTICtouQ==
X-Received: by 2002:aa7:c1c9:0:b0:468:fd17:aeb9 with SMTP id d9-20020aa7c1c9000000b00468fd17aeb9mr20546629edp.0.1672183844758;
        Tue, 27 Dec 2022 15:30:44 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c23-c4cf-d900-0000-0000-0000-0e63.c23.pool.telefonica.de. [2a01:c23:c4cf:d900::e63])
        by smtp.googlemail.com with ESMTPSA id r7-20020aa7c147000000b0046cbcc86bdesm6489978edp.7.2022.12.27.15.30.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Dec 2022 15:30:44 -0800 (PST)
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
Subject: [RFC PATCH v1 10/19] rtw88: mac: Add support for the SDIO HCI in rtw_pwr_seq_parser()
Date:   Wed, 28 Dec 2022 00:30:11 +0100
Message-Id: <20221227233020.284266-11-martin.blumenstingl@googlemail.com>
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

rtw_pwr_seq_parser() needs to know about the HCI bus interface mask for
the SDIO bus so it can parse the chip state change sequences.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/wireless/realtek/rtw88/mac.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/mac.c b/drivers/net/wireless/realtek/rtw88/mac.c
index bf1291902661..c04938691add 100644
--- a/drivers/net/wireless/realtek/rtw88/mac.c
+++ b/drivers/net/wireless/realtek/rtw88/mac.c
@@ -222,6 +222,9 @@ static int rtw_pwr_seq_parser(struct rtw_dev *rtwdev,
 	case RTW_HCI_TYPE_USB:
 		intf_mask = RTW_PWR_INTF_USB_MSK;
 		break;
+	case RTW_HCI_TYPE_SDIO:
+		intf_mask = RTW_PWR_INTF_SDIO_MSK;
+		break;
 	default:
 		return -EINVAL;
 	}
-- 
2.39.0

