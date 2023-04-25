Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 772B06EE5AA
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 18:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234667AbjDYQY2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 12:24:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234620AbjDYQYZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 12:24:25 -0400
Received: from out203-205-221-153.mail.qq.com (out203-205-221-153.mail.qq.com [203.205.221.153])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD98F10CC;
        Tue, 25 Apr 2023 09:24:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1682439862;
        bh=sQKbtorZijfrBsSbG/R4wwtRRcylsXE+DoGloP7WmT8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=bDvSD8cPyDzClEriXp9+T7nNfOHOXvwcR7i8ANZ21rO9Ti0sGyn1tLqEEEJ7khEfR
         tiEfI70V+Fj0T80ebpxcYoKtdh7Fk9OX7CHgC4DayhRKG2No2ZvsWYQinFkaciK9pQ
         U2BSUwh6PVFZXU16vAHsXRHII/7kPAgStzCNdyd8=
Received: from localhost.localdomain ([116.132.239.134])
        by newxmesmtplogicsvrsza12-0.qq.com (NewEsmtp) with SMTP
        id 60F0C276; Wed, 26 Apr 2023 00:24:15 +0800
X-QQ-mid: xmsmtpt1682439858tapcj3suu
Message-ID: <tencent_8BA35E4B9CDF40D4AE6D8D831D7ACC28A00A@qq.com>
X-QQ-XMAILINFO: Ms5xyImz3IR/EQHELcyVQRQMm9Zy5ODFWYRoClZGAUWTl9fFI3AdYshw2WYnM4
         0XkfHsK59txHhl4DDcsr1capeI5a7YRxfoMJZHhtIfUu/HjqB6JRIQ9jZ9l+hgiRuW0kbyzlAgtM
         Bz4XjZtmQ2BXPJN/Hg+ygOGIkV9KtHcRNFg9JU6k69OTbjjfi8ZEFrVvitVNq6DN0evf7TSVz0+x
         P2ZkhB7BUz1jq+LOF5tkY+FGaMQgiDa/ACEp8OFqH1xFE2uDlbNDFFNFPlnqhNr8SvNPH01/fTht
         qJJY//R6omnQ6uMHa2kKgZf9naoKHfXMbW54xfkS3RhwebBLkwhDlwc28na6X7l6DIW9jv2PYiYP
         fh9EsXL2OLXFze9gECk2+FXmsAXPKw+UMnEtBtXUBLFf9/iI12DzbQKFWRsaIg0BpTC5LmI3pm+c
         9r1V1yJl3Mrslt0iiKvldy3Iq3uQBETmSyjJaFF8R91C+y0QA9pOAwvWQe23Wa/cTxKS8cqJvTUH
         j10TSvdaDyWsNBUUzSdhdW9LQjABSfQP5ZP/zBw6rSFw7RuAe2PSEdx2PgJszYjCVDbYoSPupvQG
         wDLY7g2WLsjXhdrYgaOQfnOTTgDXELiM8+18iDv7XYde0aETvP9g7TDBLhFCu9uWB9btLui5Mlot
         fc0Tuo8TYsDbcqZVa4kJPjtwgA99zPhBwDjxS00C3U0imfOx/Bvnr0fIVegu7C8rCki1qTOwzv5O
         04FXY2/ImZnxijfuhNkyPusVBnnXk3VPT/+ZECR+WgmI3bqinogOBUbefYDzfNl7mzht36MfALnJ
         6SpKu3EibdhMyiytMNwy9tDcrPs5yoxq/1K4jW1/2NP8PgyUYybjQXKcp4EAMg02CSdGfB+IEjls
         yujzTnWT0oSWBBGLiJwpldXphiwrCIvEZg/XL9fk9c2InknFdZryjY1v7VS1zEty2K9dDmoCq4ov
         0Xa3ruWfigsWAKmtdUSZM3EkayPMM9SqEZXO4D/K+vb7QE9+ulyoUQfw4jiLbnXhAv58jMY4n0+B
         J+NzaFXH3Vu+0NhKHz
From:   Zhang Shurong <zhang_shurong@foxmail.com>
To:     tony0620emma@gmail.com
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhang Shurong <zhang_shurong@foxmail.com>
Subject: [PATCH v2 1/2] wifi: rtw88: fix incorrect error codes in rtw_debugfs_copy_from_user
Date:   Wed, 26 Apr 2023 00:24:11 +0800
X-OQ-MSGID: <d4e504c99f23ae18ff831939f56846b0878acb23.1682438257.git.zhang_shurong@foxmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1682438257.git.zhang_shurong@foxmail.com>
References: <cover.1682438257.git.zhang_shurong@foxmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        HELO_DYNAMIC_IPADDR,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,RDNS_DYNAMIC,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If there is a failure during copy_from_user, rtw_debugfs_copy_from_user
should return negative error code instead of a positive value count.

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

