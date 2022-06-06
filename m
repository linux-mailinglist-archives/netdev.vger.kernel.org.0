Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE8C453DF70
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 03:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352007AbiFFBms (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jun 2022 21:42:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233230AbiFFBmr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jun 2022 21:42:47 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7259115A29;
        Sun,  5 Jun 2022 18:42:45 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id z17so11573059pff.7;
        Sun, 05 Jun 2022 18:42:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TPsp63SRNfrlmWUFAaYwuy4IKLsk/bOVD4a+ZunMsqU=;
        b=gjSrYOahe4ZLVzp+dfg7eA/1/f2LLxTxb5YR5WNC/aHtzoCApg7tia110SIVMLb/JB
         jF41Lgu8lVCgVsJ+jsa6Yg8tseg0rOULxnHmdoeD3UogqkGhTbGQU1zGQxpnlMZZASnY
         jnpGzw9EuOK8gFK/rw76R1Xa05nDFkOVM9hl18LfgQ3jWLLxYDoJHds83M1XhOVgPz3W
         tEecS/JBq7gIIUWllp9GrsUBfE5FJLda+imOMWjAiEdqvSB26ej9DFN+/vCfffNEb/Jb
         /DlzGHoGGK0BovrjLQ4l3Kov90IhXVQY87xgwR/Ja+oRLojuVtcCkJETwH5c+ZBGaiyb
         H3qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TPsp63SRNfrlmWUFAaYwuy4IKLsk/bOVD4a+ZunMsqU=;
        b=ms38wAE8PHQ0QdC4WbX5JR02dFbwojqzihAai09ggNHyDbSLRcozyfU8JDyal6ZZl0
         y5TIFUlLkZkMBvlp8IWcwN3k7utREda2QtgmVkXJ0U66LP2z9Gh+b9fKhmJqHvv9TeNP
         kZa98QGih/Kn4JJOg/I4nizUcUaayVpqzjrGrDwdTxd+iFBjCTPLwTUtE0lyYMZHDZ7X
         2qv25BDva6eum1J3rXbcHK8LFbgum34kZ2TV97CTz+VinL/tTr4D8EkGeTQt8mgFx2Fb
         DZbuTvNa+01aNWPbcHs94AMUJNKnSaakqDlIhKu4DbXp97Cm+5DEt30+zLFuMOjpkdkK
         klwA==
X-Gm-Message-State: AOAM53122wwJSGiz5QLh85YvKw2XyIzo3JhaYpGz7EWttHUPDc7YzD/w
        RXP8I0QSLFnH99DiiasMk0A=
X-Google-Smtp-Source: ABdhPJyDPELFrkCUWQ71OuoRmUSZwuyyBnGmeVqPqh4orOJwbE0n8P5LAnI03IY0dWYYdrRjjnTf5w==
X-Received: by 2002:a63:7d4:0:b0:3fc:7507:cb09 with SMTP id 203-20020a6307d4000000b003fc7507cb09mr19384751pgh.582.1654479765030;
        Sun, 05 Jun 2022 18:42:45 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id a6-20020a1709027e4600b0015e8d4eb24bsm9430487pln.149.2022.06.05.18.42.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jun 2022 18:42:44 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     jerome.pouiller@silabs.com
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] staging: wfx: Remove redundant NULL check before release_firmware() call
Date:   Mon,  6 Jun 2022 01:42:37 +0000
Message-Id: <20220606014237.290466-1-chi.minghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
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

From: Minghao Chi <chi.minghao@zte.com.cn>

release_firmware() checks for NULL pointers internally so checking
before calling it is redundant.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
---
 drivers/net/wireless/silabs/wfx/fwio.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/silabs/wfx/fwio.c b/drivers/net/wireless/silabs/wfx/fwio.c
index 3d1b8a135dc0..52c7f560b062 100644
--- a/drivers/net/wireless/silabs/wfx/fwio.c
+++ b/drivers/net/wireless/silabs/wfx/fwio.c
@@ -286,8 +286,7 @@ static int load_firmware_secure(struct wfx_dev *wdev)
 
 error:
 	kfree(buf);
-	if (fw)
-		release_firmware(fw);
+	release_firmware(fw);
 	if (ret)
 		print_boot_status(wdev);
 	return ret;
-- 
2.25.1


