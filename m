Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDE3D4BF7F8
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 13:17:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231337AbiBVMST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 07:18:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbiBVMSS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 07:18:18 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7300799EDB;
        Tue, 22 Feb 2022 04:17:52 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id k1so32836829wrd.8;
        Tue, 22 Feb 2022 04:17:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JgLdi2meuFLJpL8uNWtBC1zuJoXMBF6NsvXnD2doIeY=;
        b=kX+SGOoiqdzB+Xw5LMJ10rQhk4JeIqNTu3Cd18fdDI+IysPFISBqzPaNjEu9Vs1UYv
         GmvkRFOCuf+4X+k0LOQjHzatUpP/40pUHohvyrTIGEx/vvDXRExgCYOk+lahtJCtVMgS
         KEffB9PWFAFEs0ooD/J5gBS1kun6bR2pCdinOHAuaLhTBFquclzmDb/6ej6hCTsDGXac
         GuxN2S7qqBy7fsTI6ye7wLk3XOb6j9Sxq0H8k1uHioeLoEzWzVTonWPyMYPdikWR31oU
         er4Uaj8B7Y4Wwsv6Xny5fwbip1y1l+va5vGmYEoJPVeQA92Tvb3fLRMCMNStGFrgFLAt
         /hvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JgLdi2meuFLJpL8uNWtBC1zuJoXMBF6NsvXnD2doIeY=;
        b=Nqpp7sJeT4DHUZ2yvnCRppENujLcw3KcCeb/7Xxbjja1MHrzasbchPwYPZdY4k3WWN
         ZG28i+PX3d5I+UjNFxVGaK/Zfde0H5+UlY7uideNWjnb8yL+RNApImdfNOa7BtjxJrrG
         YFQHu5D4lnAZ/6TSHdR7Z2gwvssHND9s8NJz6+1VY2Sp1X4V36z+NYWWRvu90u4CwdgP
         tbWBbWBHr/jZXMrSUgyoQO3dMjriqTbswjdryviWdI/GWVFrUyKCLOH3i62WfEYJQPlg
         6A5FHQqvwXcpCBvSZFgLmvMzK+diJVGtLHQf6uwk7SM1QTEXzyGhiEjS8mSDtMTBugOA
         j9Pg==
X-Gm-Message-State: AOAM5320RIgxB1tchnV+IoqUF/68yZ6RRZMs1XCUKxV85B4PhgA/e/rV
        Xu4qPYS9cvvQEPbJ/2zXQLQ=
X-Google-Smtp-Source: ABdhPJwVQb9+cWnxQss89zNC1yfUKPK6lrRQb5gqdWK2hg3mVE/Ttlt8vJSgub9Vp7XN5MImK6G4Zw==
X-Received: by 2002:a5d:4007:0:b0:1e6:3359:d0f with SMTP id n7-20020a5d4007000000b001e633590d0fmr19200436wrp.662.1645532270891;
        Tue, 22 Feb 2022 04:17:50 -0800 (PST)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id z14sm1842806wrm.100.2022.02.22.04.17.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 04:17:50 -0800 (PST)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ath9k: make array voice_priority static const
Date:   Tue, 22 Feb 2022 12:17:49 +0000
Message-Id: <20220222121749.87513-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't populate the read-only array voice_priority on the stack but
instead make it static const. Also makes the object code a little
smaller.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/wireless/ath/ath9k/mci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/mci.c b/drivers/net/wireless/ath/ath9k/mci.c
index 39d46c203f6b..5e0ae7e6412f 100644
--- a/drivers/net/wireless/ath/ath9k/mci.c
+++ b/drivers/net/wireless/ath/ath9k/mci.c
@@ -43,7 +43,7 @@ static bool ath_mci_add_profile(struct ath_common *common,
 				struct ath_mci_profile_info *info)
 {
 	struct ath_mci_profile_info *entry;
-	u8 voice_priority[] = { 110, 110, 110, 112, 110, 110, 114, 116, 118 };
+	static const u8 voice_priority[] = { 110, 110, 110, 112, 110, 110, 114, 116, 118 };
 
 	if ((mci->num_sco == ATH_MCI_MAX_SCO_PROFILE) &&
 	    (info->type == MCI_GPM_COEX_PROFILE_VOICE))
-- 
2.34.1

