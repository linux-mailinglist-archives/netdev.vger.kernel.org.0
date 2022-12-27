Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5463657124
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 00:32:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232678AbiL0Xbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 18:31:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232572AbiL0XbB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 18:31:01 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8756BDF21;
        Tue, 27 Dec 2022 15:30:46 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id s5so20853172edc.12;
        Tue, 27 Dec 2022 15:30:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=69RnArZw8pH7v6gYxnQGzkJOThGnroKfpqTaxkmeVcY=;
        b=VAG6baKX/Mbr2DiVvAd65r0OFECQlNI7HMyeV5xK5EFM/UA2S2OKtOulpjvKMcBtfl
         5HrY4slBX+ZTCC8atGBqBz4TNbgCVtEYt256Ba86Qr5xa3cZBnBY7ewZZq0wPNzLx5+/
         EdzV9LQ964qkyv3XzxNFudAa37qfu9eW2JlrrmSqIrqJI1SNB8szOKArWKknQcT2EfqK
         tjWtVUw5C3i6F3Y02mKz1ynaR+cATwqAkwAG8FIHrTQKyuCK3MvWReYEkidjBwHxieRY
         rt4+TzAwkZY2EnxqlHAkctd8d6QH6cWJZRCnPp1cXsZQZbv/e7Fi254KasR44zT4Hsxh
         kXBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=69RnArZw8pH7v6gYxnQGzkJOThGnroKfpqTaxkmeVcY=;
        b=jsZ67VLsCP1dNPvGLQ5VZlc4KhD3jBZmZ99BbHccDPwFDicerqKqgTYrWeUeZNvwZw
         uvyqMLVp3DL7d0ngjf35M6rjx+Vren0YiWVA+WxX8CNaBmvSImT3eib3sHLxrJp1RmFj
         dcaRMHc3zgqvV4nR0MsRqHlbe9N6P+hytnVM33mGjdp3z3UVMw/+Epi2vS42Ojzn/tlF
         ltdT8281OsleaPKkk1fXHsci8K5lpwZ3oKTSc2J0QH2p+LDbkGU18SHVCT7PIjR+veSL
         kfmQ7JYtqcYJlnO/p3S7SypEbDZmulZ9hxRCLhzo+o2qPCb7WbzUc9WDxOMP6c4lwk9b
         iQwA==
X-Gm-Message-State: AFqh2kob/Wb1picBH8fwdi/jHG82un/MEMM8swhCTwsRUB0uycpFonMa
        zZCuhEw/NAIp4o5CMuz+SUveORk5t/k=
X-Google-Smtp-Source: AMrXdXuFjWYhuXY54NqEai5crXRnZmHWyZmaV0No9HAtAyd8YZaEWgoMr1yvq0OCoKF2/JAOZP3PgA==
X-Received: by 2002:a05:6402:1055:b0:467:c3cb:49aa with SMTP id e21-20020a056402105500b00467c3cb49aamr19724907edu.4.1672183845760;
        Tue, 27 Dec 2022 15:30:45 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c23-c4cf-d900-0000-0000-0000-0e63.c23.pool.telefonica.de. [2a01:c23:c4cf:d900::e63])
        by smtp.googlemail.com with ESMTPSA id r7-20020aa7c147000000b0046cbcc86bdesm6489978edp.7.2022.12.27.15.30.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Dec 2022 15:30:45 -0800 (PST)
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
Subject: [RFC PATCH v1 11/19] rtw88: mac: Add support for the SDIO HCI in the TX/page table setup
Date:   Wed, 28 Dec 2022 00:30:12 +0100
Message-Id: <20221227233020.284266-12-martin.blumenstingl@googlemail.com>
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

txdma_queue_mapping() and priority_queue_cfg() can use the first entry
of each chip's rqpn_table and page_table. Add this mapping so data
transmission is possible on SDIO based chipsets.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/wireless/realtek/rtw88/mac.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/mac.c b/drivers/net/wireless/realtek/rtw88/mac.c
index c04938691add..8e1fa824b32b 100644
--- a/drivers/net/wireless/realtek/rtw88/mac.c
+++ b/drivers/net/wireless/realtek/rtw88/mac.c
@@ -1041,6 +1041,9 @@ static int txdma_queue_mapping(struct rtw_dev *rtwdev)
 		else
 			return -EINVAL;
 		break;
+	case RTW_HCI_TYPE_SDIO:
+		rqpn = &chip->rqpn_table[0];
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -1203,6 +1206,9 @@ static int priority_queue_cfg(struct rtw_dev *rtwdev)
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
2.39.0

