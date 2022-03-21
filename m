Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94D274E2112
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 08:17:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344781AbiCUHTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 03:19:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239866AbiCUHTL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 03:19:11 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F9D15A159;
        Mon, 21 Mar 2022 00:17:46 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id x8-20020a9d6288000000b005b22c373759so9942389otk.8;
        Mon, 21 Mar 2022 00:17:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=IgbuuFXubZcx35OeJk1Y5wvtoPcvSoG4HGrJKUO3pc0=;
        b=KJJTXME5Z5xM1pXAj0TMzUgsA2lC3vXDeOZiJ4C+Til/M3ggRHwJSfRElqBXKTIh2O
         CfqzduWAsy/EGKulVg0QqpDueXUA4c8Gf8dWa+2IWwptx1FaHzvI0n+gD2xaZplRNrX5
         FKLDsBgH7okSsoDSgXTNLVtWCWwFlYWg3TVOyWRUUaX57/5zIepNcJoX8aGuCLqIpDf+
         nk+xn9s74CkSs6TWqpVK1UIYRbNaTdfd4jXfrAfwYtONfomy48NJUjjz+GCoaYHoL9FE
         Su5L3GIa5GIOuHPDmXmuehuUt4Dsl1VFTbUIwGnaC7Nb1LM79bjOh3p/Ho/ipXPQajOV
         MmGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IgbuuFXubZcx35OeJk1Y5wvtoPcvSoG4HGrJKUO3pc0=;
        b=Jt+JRk8Ek+vtkYzYyFtR8zNZEPsjV27CKkLeG75VJUJOwo5ajNpDHnyrTHXpdYQCD2
         U+/Tk0WKFhGG4NGWMKkZ2prm9INWzAIQPrzAgQOi4bjkvOS///blS7wQRdBssrPpBizH
         lRMNu56TL5OsK1/sPdGGvGlazeQ4eU7u3GMvxmQs/A5Ytb16QvI5DKnJkR9LCVqs7OhY
         P5fFcCBfCpHxZjlhMFsQSpeqAOwsm+fWUpmwwDmDBXtBPncVqbZCrVmtQk7myyTNTB4a
         1wV0WtUbgkY2RXbM+T/swzuUnqcgDfW4xvFdYBegWKYgWTmYh4x6CRvtmFpy+PAaVDKR
         GFew==
X-Gm-Message-State: AOAM530UwFpjz/Pvd78ew6B8tqkY47j7IJYri6A6wwn6U/RSLLptPsSi
        dnNHblZ0uB3WlO5RMYIPVlQ=
X-Google-Smtp-Source: ABdhPJzTbCEqp56MxHzqCbVPlWQFLQWAzlQmMH0LWQcPyp/am/JfqrJy77x4BgQ5aTfVIOY+4K/Ezw==
X-Received: by 2002:a9d:6b0a:0:b0:5b2:3355:5ec8 with SMTP id g10-20020a9d6b0a000000b005b233555ec8mr7457277otp.51.1647847065879;
        Mon, 21 Mar 2022 00:17:45 -0700 (PDT)
Received: from tong-desktop.local ([2600:1700:3ec7:421f:a425:dbce:b9cb:7c6f])
        by smtp.googlemail.com with ESMTPSA id o18-20020a9d7652000000b005cbf6f5d7c5sm2459064otl.21.2022.03.21.00.17.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 00:17:45 -0700 (PDT)
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
Subject: [PATCH 1/4] ar5523: fix typo "to short" -> "too short"
Date:   Mon, 21 Mar 2022 00:17:28 -0700
Message-Id: <20220321071729.3476994-1-ztong0001@gmail.com>
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

"RX USB to short" -> "RX USB too short"

Signed-off-by: Tong Zhang <ztong0001@gmail.com>
---
 drivers/net/wireless/ath/ar5523/ar5523.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ar5523/ar5523.c b/drivers/net/wireless/ath/ar5523/ar5523.c
index 141c1b5a7b1f..9cabd342d156 100644
--- a/drivers/net/wireless/ath/ar5523/ar5523.c
+++ b/drivers/net/wireless/ath/ar5523/ar5523.c
@@ -104,7 +104,7 @@ static void ar5523_cmd_rx_cb(struct urb *urb)
 	}
 
 	if (urb->actual_length < sizeof(struct ar5523_cmd_hdr)) {
-		ar5523_err(ar, "RX USB to short.\n");
+		ar5523_err(ar, "RX USB too short.\n");
 		goto skip;
 	}
 
-- 
2.25.1

