Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B576E6EF8E1
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 19:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233652AbjDZRCg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 13:02:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231222AbjDZRCf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 13:02:35 -0400
Received: from out203-205-221-149.mail.qq.com (out203-205-221-149.mail.qq.com [203.205.221.149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54A566181;
        Wed, 26 Apr 2023 10:02:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1682528551;
        bh=0jtZ1tJWTi2inp5S8B+o1APzbV/sG+j39aLHY3E4ric=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=cXxzB61hg6oujYZnM6uf+lwJdE4topBp/2bWZCWPhT6kqhTcNOK222NsyHF7KUemH
         ggjFon6uxwc3pLujaQgRH9y/2pCanKv/p1BgrmZqS3rdLTnG3ZKA9Duf/ebZ/kUYRS
         yvvTfjTVOIGz9teErxobZKxlXl7jat4YG2q/w9XM=
Received: from localhost.localdomain ([220.243.191.11])
        by newxmesmtplogicsvrsza10-0.qq.com (NewEsmtp) with SMTP
        id 9828290; Thu, 27 Apr 2023 01:02:24 +0800
X-QQ-mid: xmsmtpt1682528547tel9oph6f
Message-ID: <tencent_D2EB102CC7435C0110154E62ECA6A7D67505@qq.com>
X-QQ-XMAILINFO: NkHKfw09D6j8LSj8UwFeu2OCk7A8oQLwa8gZrIgcoSEVCTIOSzx9v+Y5eP3oy7
         ivYq7fa0whH/f020W39Mawe33y6+oug8Qys190X7BXddYTI1PRBMLoZOAdXwTfbbhJEShW0vFEoM
         kk0KnZNR+AqTvRXDv5dFjwXWyZtxFJWW1+Z9I88G3oSqK/+WTOubCS3I6q0fqYAA/eS52YeOdNn2
         hZpmONjXpJi9G2jZCHIMhHUbVqCqkT3V0KuGCrhbHMeBlJ0KplM6MbbAAObUTPChGsAI1IOn9fsf
         HobtfAubBDLABTa93HsOt+q0PqDH2siBA6S7FI+a/Pt37W/lgx7e1eJd1Y1ykbbUbGc92lyuzIWq
         94YMLTby7My0FYv6Wxxe9qXdNwwq7LJrrYMugJ267S89G6bUyuWSeu1eS5r9r+GEzijkASH6fLNA
         o45TTGmFrSe9l40Cm8vNd8CczYBSyxk95Apo16KKBfYqpNGxubvxvYlIpF3MixeKFlrLSLVAxrxW
         Qg8Y/pAKHPK9ZcO/Q1LkiDkCIc6EPRvhxw8pU1zgYAWMM5Tl1QLH+5waVl4crHTWM2rfHVqCs8AH
         d6a2oTmrgYOgFOFBNRXippbM2mXvl9lAi7shQvNNTqPL9PRN4yv0rtUQPmwlQUG8TYKEdwC+eYwi
         p8iLgxmqRrAKzi9wo14LmcCb0KPrW0J/h7iq5Gl+Iba6eInqkoh3VQXidNY3cm/PGpu/nDBGGOF7
         zQy0RIjfRj49Z5LsWWUlRhQEtUbAKt0hXOM/bE0RGhXSpAPe8VEPmsSJkQMPtd8/WANJYztEjkQ2
         IvFRoPKKTl0AQ/vHxqgS979JYhcHrf6+FfaTJ/ekWdEuuKTF/dpHp7sS1Jwb/m1LBWqw21le0JOT
         +nc4vuEnk47N1cJHn0ZiHTwoWqi6m69iV+WV5Z7u9jKphBr2D/TtWEmH/v2nlby5cP3UqiPd57nM
         ZyJm/ft26ZKT4aEZryeOKTYbHVEpKdBbK5cu2x1ewT6/qz1jXg8U9m6gh0OAtXydswpaD8Cn8Yrw
         rXEpwdmPQA/gnDVPScE2acrWCzCgs=
From:   Zhang Shurong <zhang_shurong@foxmail.com>
To:     pkshih@realtek.com
Cc:     tony0620emma@gmail.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Zhang Shurong <zhang_shurong@foxmail.com>
Subject: [PATCH v3 1/2] wifi: rtw88: fix incorrect error codes in rtw_debugfs_copy_from_user
Date:   Thu, 27 Apr 2023 01:02:20 +0800
X-OQ-MSGID: <d4e504c99f23ae18ff831939f56846b0878acb23.1682526135.git.zhang_shurong@foxmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1682526135.git.zhang_shurong@foxmail.com>
References: <cover.1682526135.git.zhang_shurong@foxmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        HELO_DYNAMIC_IPADDR,RCVD_IN_DNSWL_NONE,RDNS_DYNAMIC,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If there is a failure during copy_from_user or user-provided data
buffer is invalid, rtw_debugfs_copy_from_user should return negative
error code instead of a positive value count.

Fix this bug by returning correct error code. Moreover, the check
of buffer against null is removed since it will be handled by
copy_from_user.

Signed-off-by: Zhang Shurong <zhang_shurong@foxmail.com>
---
 drivers/net/wireless/realtek/rtw88/debug.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/debug.c b/drivers/net/wireless/realtek/rtw88/debug.c
index fa3d73b333ba..3da477e1ebd3 100644
--- a/drivers/net/wireless/realtek/rtw88/debug.c
+++ b/drivers/net/wireless/realtek/rtw88/debug.c
@@ -183,8 +183,8 @@ static int rtw_debugfs_copy_from_user(char tmp[], int size,
 
 	tmp_len = (count > size - 1 ? size - 1 : count);
 
-	if (!buffer || copy_from_user(tmp, buffer, tmp_len))
-		return count;
+	if (copy_from_user(tmp, buffer, tmp_len))
+		return -EFAULT;
 
 	tmp[tmp_len] = '\0';
 
-- 
2.40.0

