Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8DB069BAA9
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 16:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbjBRPaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Feb 2023 10:30:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjBRPaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Feb 2023 10:30:18 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBA8816AC7;
        Sat, 18 Feb 2023 07:30:17 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id z7so1207822edb.12;
        Sat, 18 Feb 2023 07:30:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ni0fK5BfMyJtYgVbYHoBsAm9oiht0nB3z1bCOO7slv4=;
        b=N8ggBGuqML1xN64UiQy3Wx5Inec69C0sv/QjAB3bzhi1ET+ddaU+h5baJ3p8zR0750
         J637LBnZS6vMICvdf7a16QclscJxfE5o8e+vixIfFhgvSdzXnAjvV3ch+yl5nla7W3n7
         SwXq+xXz45DubgBtXwkp477GFiamCSclJJvgQBEL03nup+N7ufm/d8cBdr8lGtY6AU2+
         LUuFZNlvZ1ewMwQMXLOgIyYebtXFYpTZD91W9veGG3984jyY/wCdPPjkYL5RWXigHnnH
         UUcHyts0BjIkgLLaQfcH17XZgVQNMdH+VT8fhUE0+dj6+Ss0xhVsmWV1cFy5XldFYRfz
         cqGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ni0fK5BfMyJtYgVbYHoBsAm9oiht0nB3z1bCOO7slv4=;
        b=IHItRh5LEdJSh22hBxoOBNe2aPzbBD1rlDoksrKMCf0SC98V7tqVkpkl5LDxUdtgqI
         +5utXOoBEzDZzqsQUNCcgFGbmqXZxpuRL33p9L8RIOTl79QY1IXilhJlHoSVQZZ4PhaW
         D9OXcNqZ7u2r2fLQuUcye+vxsmXoAymXUbMnHD09ckvtLsJOYSI6QM3dowXVagnsqMA5
         j2salkFYAseq+U4At1ayVPMhIRRvo+Bn1qMR32iJ1kA0Vec6FihMEBiNrruwER2tZmIT
         fSuLByZ+4aeXLz9Fkg4tz4X3AWMzFqILWqnoMUhcW1FgWG+SdvEE8JzxnX6Y/NbWAloP
         mS2A==
X-Gm-Message-State: AO0yUKWJUaLNsa28jx0cWQe0XB/l+n1/419ysrPhZ2qguXY62/q8Bpsk
        7r2Bus43+ZZFICnYbRI3x0+WYZ1hciM=
X-Google-Smtp-Source: AK7set8k6KJcWyyC8FuI6gCgwXuHPYBhPz/DMopMYVeI3LW9KzQU1VQ4rnzrXj0fWLs0o/Htpj/lXw==
X-Received: by 2002:a05:6402:34d5:b0:4ae:e548:1222 with SMTP id w21-20020a05640234d500b004aee5481222mr456057edc.15.1676734216067;
        Sat, 18 Feb 2023 07:30:16 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c23-b8cf-1500-0000-0000-0000-0e63.c23.pool.telefonica.de. [2a01:c23:b8cf:1500::e63])
        by smtp.googlemail.com with ESMTPSA id a65-20020a509ec7000000b004acc5077026sm3742554edf.79.2023.02.18.07.30.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Feb 2023 07:30:15 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     tony0620emma@gmail.com, kvalo@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>, pkshih@realtek.com,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v2 1/5] wifi: rtw88: mac: Add support for the SDIO HCI in rtw_pwr_seq_parser()
Date:   Sat, 18 Feb 2023 16:29:40 +0100
Message-Id: <20230218152944.48842-2-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230218152944.48842-1-martin.blumenstingl@googlemail.com>
References: <20230218152944.48842-1-martin.blumenstingl@googlemail.com>
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
2.39.2

