Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6031B696F01
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 22:15:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232429AbjBNVPF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 16:15:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232164AbjBNVPE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 16:15:04 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A24512E835;
        Tue, 14 Feb 2023 13:14:30 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id dr8so43232439ejc.12;
        Tue, 14 Feb 2023 13:14:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EdzJHZtvCjiajcTbwikaf9ObTwwLylq1F+vbECZVj10=;
        b=AC4Vb6aEo+exPXiScKa3vdrajE36oOuauqTOpoByqNWijGtJEBDuwgapSQTGe1Y1+M
         MYmWDKdZ9v+uQaTjFX7L9/EGWPx2/3zneIJ3hWNPVjUmSnesOj/385B2PHPLub27VFrS
         d6Y8OXec4xrjH8dxUxjCySI44BgTmi7myS4oss7P1nXyT5WqyQ9nAzK722+WBthAq8v+
         33MUw0ddtmeiGUQPWz+4PiS/ua0FKUquR35L8+FBNryVJ33vYwMVmnZXWHeLOVA+iWBC
         BT+97WPuUUNEzlIZZcaAWGGmnRE1tXseBRyAaZMdBGaK/Ga7az2TgeInMoNiN4OlD6Kf
         OcVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EdzJHZtvCjiajcTbwikaf9ObTwwLylq1F+vbECZVj10=;
        b=WcRYEErfjKKcPqyKzc/eZqnIjs4E8Rxmlcw2b1J98WCHAmc7qcanMei+REfbm7UXVW
         tC2B3Scc+KWzgGe8uMolkveA5poyIeC28rBE9r6VsQgPZx94f2PQpSBRFzIK/VIqfysK
         fEW/Ej5OiPUT8FMmBjYjjPznhi0T5wBU9/LkorK+uow3F06mAe9t6mve6aYFCZ7Ryt/k
         X6okkIW8gB6kxHIo4CjcWGozFv2iRSNp6nYgFJv1hpehSeHj524QFuZLAgZCgSsnaQKY
         pLV61d80ykoiyZhj37Lw6zuZiKz3o2N9a0e1u1WHJwepc3tB+FbuQk7PTjgOTjlDxRlK
         N9lA==
X-Gm-Message-State: AO0yUKUSDftkcoyCrRAzlHsCTylmOsqvGbVlV76kthuz1UsIuDH1dR3I
        bHZbCCyYB16mHRoVUF7ueZG7C1ipmoo=
X-Google-Smtp-Source: AK7set98aa4pYv0zLJBwJ4PbN1+IIXEpBDzlDgjQsDM27pPvfBHTOinOFp6lTCm59SBbcfzHaL3zHQ==
X-Received: by 2002:a17:906:e256:b0:8aa:1f89:122e with SMTP id gq22-20020a170906e25600b008aa1f89122emr4278783ejb.39.1676409264906;
        Tue, 14 Feb 2023 13:14:24 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c22-768e-b000-0000-0000-0000-0e63.c22.pool.telefonica.de. [2a01:c22:768e:b000::e63])
        by smtp.googlemail.com with ESMTPSA id uz2-20020a170907118200b008b134555e9fsm949806ejb.42.2023.02.14.13.14.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 13:14:24 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     tony0620emma@gmail.com, kvalo@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>, pkshih@realtek.com,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v1 1/5] wifi: rtw88: mac: Add support for the SDIO HCI in rtw_pwr_seq_parser()
Date:   Tue, 14 Feb 2023 22:14:17 +0100
Message-Id: <20230214211421.2290102-2-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230214211421.2290102-1-martin.blumenstingl@googlemail.com>
References: <20230214211421.2290102-1-martin.blumenstingl@googlemail.com>
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
index 4e5c194aac29..3ed88d38f1b4 100644
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
2.39.1

