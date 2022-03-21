Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4879E4E2120
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 08:18:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344814AbiCUHT7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 03:19:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344822AbiCUHTu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 03:19:50 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4AA817AAC;
        Mon, 21 Mar 2022 00:18:24 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id q129so13353503oif.4;
        Mon, 21 Mar 2022 00:18:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=1er9hXh4NM0xsL2Lew/SNJXsAYeQMvEWCUztMVmluyk=;
        b=XYAKx54NQ+daDqIfWnhcUav0VWfdZ+I2J8snROMkZXkOhO9TMqSItRPxvLMTwsSYra
         SAAlo7hM+naa1ZoMKhgjW+VQsYJuAXfBfHKPm9038/yPNccG55Oi24uAZmgu9DHXq9WV
         tmjHrXswJBdIV+I/guhkhoSJ+p+Y8ywN0ySEiFe4F+5Lx9yPM/uJjUQjDWofeo8J90h6
         /6egQBOmK0rK/mnm36s/izktSnMQhSk1/HDrSD6xvMsHgtW4iFWtMg4rScFh1X3gfriq
         DQ2ECDR75RgVhssFnpXku8VyLiG7cim+Lto+RumSfZyt97OAZPkTlWrESQdREF9nYCRK
         /vhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1er9hXh4NM0xsL2Lew/SNJXsAYeQMvEWCUztMVmluyk=;
        b=iDpVdv+9IhEE27XIe0HXNWruJEUu+9otSBVFy9EfEbI8YOmFmg2SdQi8rilWl9VRO+
         3dH2krNbldYZQrKPd4g9/RGWwVZHcXmK6qtSPvNE9ueNStHkQArw9nNtBSoAbgcDBr85
         FCs8DOF9IZmBaRup8NOEWMWIqY0KP5dQjHAC7/sflDA7OCJsnLVkScXVbXyQsQsziZ00
         EIcIGdHvI2WwphwfKxsyUpc9AYKo+kwgncySixCZfz/NprCTnQ9tJ8r6b1wqp6UwEhns
         w3is43st+NFQpwt2oaPp8L92W6ldgT5DYcW5SQDEU9W4Gkn0gCO/fwXdorWKT3lWjNDF
         ABxw==
X-Gm-Message-State: AOAM531K51sLpeKWAZzMpvk+Zv8IhPLwPjZtmJ0uOm+bmnF+LbFEg/Jw
        ssNuh7URHxr8P+h+xg3Ej4Y=
X-Google-Smtp-Source: ABdhPJxK9Kxfiyb/zcjUdeBgIeDMM8oM/8rMJ/d6+Gmg42H7x8nwE7dSl++JVvmDeKDgBX3SeVk0Bg==
X-Received: by 2002:a05:6808:3022:b0:2d5:bd2c:3154 with SMTP id ay34-20020a056808302200b002d5bd2c3154mr12984640oib.102.1647847104124;
        Mon, 21 Mar 2022 00:18:24 -0700 (PDT)
Received: from tong-desktop.local ([2600:1700:3ec7:421f:a425:dbce:b9cb:7c6f])
        by smtp.googlemail.com with ESMTPSA id r21-20020a05683002f500b005b249ffa43fsm7178537ote.22.2022.03.21.00.18.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 00:18:23 -0700 (PDT)
From:   Tong Zhang <ztong0001@gmail.com>
To:     Karsten Keil <isdn@linux-pingi.de>, Sam Creasey <sammy@sammy.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Pontus Fuchs <pontus.fuchs@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Tong Zhang <ztong0001@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH 4/4] mISDN: fix typo "frame to short" -> "frame too short"
Date:   Mon, 21 Mar 2022 00:18:18 -0700
Message-Id: <20220321071819.3477438-1-ztong0001@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220321071350.3476185-1-ztong0001@gmail.com>
References: <20220321071350.3476185-1-ztong0001@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"frame to short" -> "frame too short"

Signed-off-by: Tong Zhang <ztong0001@gmail.com>
---
 drivers/isdn/hardware/mISDN/mISDNipac.c | 2 +-
 drivers/isdn/hardware/mISDN/mISDNisar.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/mISDNipac.c b/drivers/isdn/hardware/mISDN/mISDNipac.c
index 39f841b42488..4f8d85bb3ce1 100644
--- a/drivers/isdn/hardware/mISDN/mISDNipac.c
+++ b/drivers/isdn/hardware/mISDN/mISDNipac.c
@@ -1062,7 +1062,7 @@ ipac_rme(struct hscx_hw *hx)
 	if (!hx->bch.rx_skb)
 		return;
 	if (hx->bch.rx_skb->len < 2) {
-		pr_debug("%s: B%1d frame to short %d\n",
+		pr_debug("%s: B%1d frame too short %d\n",
 			 hx->ip->name, hx->bch.nr, hx->bch.rx_skb->len);
 		skb_trim(hx->bch.rx_skb, 0);
 	} else {
diff --git a/drivers/isdn/hardware/mISDN/mISDNisar.c b/drivers/isdn/hardware/mISDN/mISDNisar.c
index 56943409b60d..48b3d43e2502 100644
--- a/drivers/isdn/hardware/mISDN/mISDNisar.c
+++ b/drivers/isdn/hardware/mISDN/mISDNisar.c
@@ -466,7 +466,7 @@ isar_rcv_frame(struct isar_ch *ch)
 		rcv_mbox(ch->is, ptr);
 		if (ch->is->cmsb & HDLC_FED) {
 			if (ch->bch.rx_skb->len < 3) { /* last 2 are the FCS */
-				pr_debug("%s: ISAR frame to short %d\n",
+				pr_debug("%s: ISAR frame too short %d\n",
 					 ch->is->name, ch->bch.rx_skb->len);
 				skb_trim(ch->bch.rx_skb, 0);
 				break;
@@ -542,7 +542,7 @@ isar_rcv_frame(struct isar_ch *ch)
 		rcv_mbox(ch->is, ptr);
 		if (ch->is->cmsb & HDLC_FED) {
 			if (ch->bch.rx_skb->len < 3) { /* last 2 are the FCS */
-				pr_info("%s: ISAR frame to short %d\n",
+				pr_info("%s: ISAR frame too short %d\n",
 					ch->is->name, ch->bch.rx_skb->len);
 				skb_trim(ch->bch.rx_skb, 0);
 				break;
-- 
2.25.1

