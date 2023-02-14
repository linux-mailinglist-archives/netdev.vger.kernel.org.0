Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE741696F0B
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 22:15:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232544AbjBNVPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 16:15:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232113AbjBNVPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 16:15:05 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A72CB2FCCA;
        Tue, 14 Feb 2023 13:14:30 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id ml19so43483798ejb.0;
        Tue, 14 Feb 2023 13:14:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DeA/Fs5OrkYfLy7sfZ1TbPFwb47uZI+seq9bXI57mCE=;
        b=irA1GIZiRIghJL58pWmFEBIjmlCEJ+SHfBIK8jnYTxv1BpneXqdHz3q4SAp2Si8D5z
         fvW1+E1znO4hKRT9vV2SCgbQQkGPZCYhkuuNhTMThlVt6E2stQ+30jfejfUKniNdwBuV
         FzDmOwko4nZUPoPWBMgW45rLzeQ7fLU8UgkXLYlG6rCZSFJuPUSxlXY8yftQxM4wSbg4
         w4+T9LfEaF9HfwIpg/9vrV8h8JNPugvZ2hKY/jxblPEuSzysDa7cPPE6zmUgPalfRL7m
         E76QZBIcjH0OinQf6YwN6NtquXh1BWE7eqeck0jLy9FLegP87EYLSzEhEuNbJADVS5Ae
         xuPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DeA/Fs5OrkYfLy7sfZ1TbPFwb47uZI+seq9bXI57mCE=;
        b=n9tf322mvJM7pDQkEDyLz21AsS8BIc0Q/2xqVN/FHWYbjJC4XtoMZhXTjC0ZD0Bu+x
         kiXFPy8ZGLARnFgIZ+W6CuZdpyjZoF3P+REphrSm01fgTYswxDxNA8GUJ3sEQHYrYaC5
         EYqNA5K5K1p5T2QylcWT6l1UhYxPBylz7dYeQkDQIKV1DNSmRfJ9uU2El2igU5KxAGfT
         9oWxT4IwOrBAH0jMz0H6aZjr7hDyLNHpIAJcbkxhkUyWYKLJDKPQlJozi5dM5S00rwes
         An7+MV4wRi6FCysT786FHRZRCGMJL/FIREMPkNre741TP9rbjt/umTAL8puM/9p3Yagg
         Ck7Q==
X-Gm-Message-State: AO0yUKUMhBzAL5jhil7TaPr9gDS+AWT0stcwuszn0hBKWKSHVDSraBFB
        9TkZwxm2lGcTzqV6O7dOoa+65to6YPw=
X-Google-Smtp-Source: AK7set87KFOBYJ5H6LMVo4ORSWtMUXdB/iynMJTYLXZcpFaiQ4agdgzRbn8aS4TboIywPnmmkkgnyg==
X-Received: by 2002:a17:906:ccda:b0:8b1:2ebf:386c with SMTP id ot26-20020a170906ccda00b008b12ebf386cmr4000404ejb.11.1676409265803;
        Tue, 14 Feb 2023 13:14:25 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c22-768e-b000-0000-0000-0000-0e63.c22.pool.telefonica.de. [2a01:c22:768e:b000::e63])
        by smtp.googlemail.com with ESMTPSA id uz2-20020a170907118200b008b134555e9fsm949806ejb.42.2023.02.14.13.14.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 13:14:25 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     tony0620emma@gmail.com, kvalo@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>, pkshih@realtek.com,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v1 2/5] wifi: rtw88: mac: Add SDIO HCI support in the TX/page table setup
Date:   Tue, 14 Feb 2023 22:14:18 +0100
Message-Id: <20230214211421.2290102-3-martin.blumenstingl@googlemail.com>
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

txdma_queue_mapping() and priority_queue_cfg() can use the first entry
of each chip's rqpn_table and page_table. Add this mapping so data
transmission is possible on SDIO based chipsets.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/wireless/realtek/rtw88/mac.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/mac.c b/drivers/net/wireless/realtek/rtw88/mac.c
index 3ed88d38f1b4..6a234eec09ff 100644
--- a/drivers/net/wireless/realtek/rtw88/mac.c
+++ b/drivers/net/wireless/realtek/rtw88/mac.c
@@ -1033,6 +1033,9 @@ static int txdma_queue_mapping(struct rtw_dev *rtwdev)
 		else
 			return -EINVAL;
 		break;
+	case RTW_HCI_TYPE_SDIO:
+		rqpn = &chip->rqpn_table[0];
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -1195,6 +1198,9 @@ static int priority_queue_cfg(struct rtw_dev *rtwdev)
 		else
 			return -EINVAL;
 		break;
+	case RTW_HCI_TYPE_SDIO:
+		pg_tbl = &chip->page_table[0];
+		break;
 	default:
 		return -EINVAL;
 	}
-- 
2.39.1

