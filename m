Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61D2F6198D1
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 15:08:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231986AbiKDOIE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 10:08:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231992AbiKDOHi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 10:07:38 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC7BB2FFFD;
        Fri,  4 Nov 2022 07:07:25 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id o4so7225281wrq.6;
        Fri, 04 Nov 2022 07:07:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oilx5LbN9F6ZN5QDoq07iYnZhSaR7jPRZNG8HN9/3GQ=;
        b=NJ1HbMAcbW4gv51cWJsyBBdvCT+thQgJ8uXzv66/RR0G7fAOj9S8kj7rcknQIkgGqI
         J75VYaPtRV0TjwmOFCJUnYSnUfmUxgK9MJ1zIkw446alSJmg5oFyCZOkjNY59YCoF/I4
         1HXk6/5hQyzufOtAff7aswcWZ9JACbQ0SJOXpal7CX6IKjlJkSoliK1ZcqsQ7Ybp3kNy
         ux3/u5eudF38PGpNZJToFu7ghiblsQfFpCSCVCKm3MAAb2HNYN94iqSeXR4Hy/rEKnne
         oZq1oIRjkPupQCaznuGvlQHdmLCtjBMrncK+tqFhgPL6DIk2WMGyYBNRGGXrxZ7cGzRK
         UNqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oilx5LbN9F6ZN5QDoq07iYnZhSaR7jPRZNG8HN9/3GQ=;
        b=uRYKb8cX5BiSn8F3CFqfoNQHOB/keWhA98LNS/AOwBa/riwZA96uzRAN1n7sNx8bYQ
         jrkQNdtnWSg6vm4k7V49Lus3IezpT7XeZDuVgTMXi3GdtE1LgL25VVaGfSaBopeU/ePU
         9vAB5usLl8e+80uaKXg++84BLMRWyDgnc1f69Yui7SeWqCvyhcM67Tsg9CEOAcR+SG4b
         WUB2+ENW3tGYEOiXIArkU/NCD37ZYhqMCKPCBcDgvEeGOyu0JIY7RvtF+SwBdtqWdfbr
         VNa+b2jkz1P36RyMgr3t36k6oDHhcmrYEY+2kD9mTZ0QJ/lvMGUhni514N9R27qCt2Rz
         DwKQ==
X-Gm-Message-State: ACrzQf1vAbYjX3rGEufr8RxgQcQcBmO9G+bpNTMcA9D4/XdelSO9XLMz
        7jIGxwJbu/HOXa/jji+bR6E=
X-Google-Smtp-Source: AMsMyM5ciCoRQpI/3KaP6IzpM0ippXDMPbxCyv4isr3BROtsk0+O1xvzklPxpmWpNBG8dUHwYjYVTQ==
X-Received: by 2002:adf:f911:0:b0:21e:c0f6:fd26 with SMTP id b17-20020adff911000000b0021ec0f6fd26mr22400812wrr.361.1667570844286;
        Fri, 04 Nov 2022 07:07:24 -0700 (PDT)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id q11-20020a05600000cb00b0023677e1157fsm3449147wrx.56.2022.11.04.07.07.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 07:07:23 -0700 (PDT)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ath9k: Remove unused variable mismatch
Date:   Fri,  4 Nov 2022 14:07:23 +0000
Message-Id: <20221104140723.226857-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
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

Variable mismatch is just being incremented and it's never used anywhere
else. The variable and the increment are redundant so remove it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mci.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
index 9899661f9a60..8d7efd80d97a 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
@@ -585,7 +585,7 @@ static u32 ar9003_mci_wait_for_gpm(struct ath_hw *ah, u8 gpm_type,
 {
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath9k_hw_mci *mci = &ah->btcoex_hw.mci;
-	u32 *p_gpm = NULL, mismatch = 0, more_data;
+	u32 *p_gpm = NULL, more_data;
 	u32 offset;
 	u8 recv_type = 0, recv_opcode = 0;
 	bool b_is_bt_cal_done = (gpm_type == MCI_GPM_BT_CAL_DONE);
@@ -656,7 +656,6 @@ static u32 ar9003_mci_wait_for_gpm(struct ath_hw *ah, u8 gpm_type,
 		} else {
 			ath_dbg(common, MCI, "MCI GPM subtype not match 0x%x\n",
 				*(p_gpm + 1));
-			mismatch++;
 			ar9003_mci_process_gpm_extra(ah, recv_type,
 						     recv_opcode, p_gpm);
 		}
-- 
2.38.1

