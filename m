Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9CC66612E4
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 02:31:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231906AbjAHBa6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 20:30:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231533AbjAHBaz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 20:30:55 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9CF035923
        for <netdev@vger.kernel.org>; Sat,  7 Jan 2023 17:30:54 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id d10so3631789pgm.13
        for <netdev@vger.kernel.org>; Sat, 07 Jan 2023 17:30:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=schmorgal.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vSiLXb9WJcajlY3pp2A6uRr9twRUEMwHYlZPISHDuv0=;
        b=Fe/zwNAMNgjbbOPzhmtFZNyLrxouNqQy0oXAMZ7cwS5nexp9omCvH8z+/YeBSW4sqd
         8BqLE46ad32EU9xrFTP6nwTEMxfZLgWVDoR9KKxKgOlrZWc20SlgMHRBh2xlOenR/95c
         TREYtyflWCBHqAPIfS71u7CHqSTVkhs1PUM60=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vSiLXb9WJcajlY3pp2A6uRr9twRUEMwHYlZPISHDuv0=;
        b=qtpNe4Pao7m4q6ieWmPQyfLPOZPLU6H26koy+g1AEz6nQwR9q2NoMMYB++S8wLD5lq
         a7gukGI19Rtns1OTHb6XI7eL45Hms6lBxkwi1gSsR8CKLj7d1a8yVaBx6Xax4xWUvFlI
         YGWbyL9NFppmGCjdZ9QS2x+ubt4bkL6TQUX/hgDm+FEqTlP+jDuh647/H7zZEE59w6s2
         mbaGUtUmKeXNuvNbdojsDqOUgHHmMPvK7VZMUd8TYAcKTJGo8o4D6g6VlW6URXzTtLfA
         6XnIiOrK8UpUWo9/jNuNiPQehcOBNGFbP9a8mKZbCwLRn1vO3kn59jrtoHw8QLubabYJ
         MVsQ==
X-Gm-Message-State: AFqh2koDusngu++VrkJkJrd1RilSHVIC5oloKGKKZSA5HnjmYoprPVqK
        Rv3LFl+Vel112enFwaNr5ywOoQ==
X-Google-Smtp-Source: AMrXdXvpcdk77TT8XagZXpCHsOGivfKhMtZKjvxVygLPtMDMC+KtL3QUm6JlsOicE/Yc7+8TgSPZhw==
X-Received: by 2002:a62:ea01:0:b0:582:bbc7:c61e with SMTP id t1-20020a62ea01000000b00582bbc7c61emr15686779pfh.11.1673141454073;
        Sat, 07 Jan 2023 17:30:54 -0800 (PST)
Received: from doug-ryzen-5700G.. ([192.183.212.197])
        by smtp.gmail.com with ESMTPSA id x14-20020aa79a4e000000b005811c421e6csm3323714pfj.162.2023.01.07.17.30.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Jan 2023 17:30:53 -0800 (PST)
From:   Doug Brown <doug@schmorgal.com>
To:     Dan Williams <dcbw@redhat.com>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Doug Brown <doug@schmorgal.com>
Subject: [PATCH v2 1/4] wifi: libertas: fix capitalization in mrvl_ie_data struct
Date:   Sat,  7 Jan 2023 17:30:13 -0800
Message-Id: <20230108013016.222494-2-doug@schmorgal.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230108013016.222494-1-doug@schmorgal.com>
References: <20230108013016.222494-1-doug@schmorgal.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This struct is currently unused, but it will be used in future patches.
Fix the code style to not use camel case.

Signed-off-by: Doug Brown <doug@schmorgal.com>
---
 drivers/net/wireless/marvell/libertas/types.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/libertas/types.h b/drivers/net/wireless/marvell/libertas/types.h
index cd4ceb6f885d..398e3272e85f 100644
--- a/drivers/net/wireless/marvell/libertas/types.h
+++ b/drivers/net/wireless/marvell/libertas/types.h
@@ -105,7 +105,7 @@ struct mrvl_ie_header {
 
 struct mrvl_ie_data {
 	struct mrvl_ie_header header;
-	u8 Data[1];
+	u8 data[1];
 } __packed;
 
 struct mrvl_ie_rates_param_set {
-- 
2.34.1

