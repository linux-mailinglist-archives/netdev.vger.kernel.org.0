Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5929B4F67B5
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 19:40:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238632AbiDFR0J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 13:26:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238706AbiDFRZy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 13:25:54 -0400
Received: from stuerz.xyz (stuerz.xyz [IPv6:2001:19f0:5:15da:5400:3ff:fecc:7379])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E0E91B74DF;
        Wed,  6 Apr 2022 08:24:47 -0700 (PDT)
Received: by stuerz.xyz (Postfix, from userid 114)
        id 92E25FC6DA; Wed,  6 Apr 2022 15:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=stuerz.xyz; s=mail;
        t=1649258686; bh=8zU/pVQzaSSeUmGTy07qPAWn19XTwb6FrCl7lhD+040=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F5IdetPChtUOVoLwPCuNzWJTZlFgz80ooqJFZHeyM0yfuYBTfEV7iLDNNhTBN3iDW
         mizZ/yFT/lGcojJnxJ/lzwcKiKKjCw/nMEoDbSxYM119WVUfyubnTza7gvR23kl6+X
         j+UR4aSPwZDBSUH/cOxrgDP+Nr8ZJh5MvjaY+zTqczapQaAQ+3MiWh15QvxJ8ggSDA
         m0NPRY+PEwrIqGVaNuB83AiooaX6CgGWdhdcsUpkawf0z0WauHBe1p0eHkuRqw84oK
         e2l48xtAw/bg1c+lCP7cDAwHQmbdbqrTwCZolVX5K0LF7M1njGnmTJKbyWNUHmy7m3
         K8/PRModzQ86Q==
Received: from benni-fedora.. (unknown [IPv6:2a02:8109:a100:1a48::1e62])
        by stuerz.xyz (Postfix) with ESMTPSA id 89C2FFBC43;
        Wed,  6 Apr 2022 15:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=stuerz.xyz; s=mail;
        t=1649258684; bh=8zU/pVQzaSSeUmGTy07qPAWn19XTwb6FrCl7lhD+040=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lvTG7c4oIxOJNe9NBCuq3P85DZ+etjpwfuEQ0UG4LHQMa8mJrGZDng9KQXZlvNyb+
         Cr/JL8ucvS7AZ3T7mWIBJ+g8h/0zAJkIWeZC3eCmttxx2vao5wtF6y1B14lsYsIu8L
         444KoU4jtb4OVGYjgEfB2mj2yFg+xJUqMBYnIcO/zr/bFLH+HvJbOkQ9we6N/eFKPJ
         wncKVnC6Qtz3Yv+YYb2FZ5hPfuYDvHXiNNFA8Q+sHti22dOxmA9B+wnr/tVP912LqJ
         Ysh0gq0Rl08sF4nPnnpdHLam21IMWbHKOBJTaHT6p51WI+CJS85N5mUAJB18OaF9ZS
         sNQfOxwir4VyA==
From:   =?UTF-8?q?Benjamin=20St=C3=BCrz?= <benni@stuerz.xyz>
To:     kvalo@kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Benjamin=20St=C3=BCrz?= <benni@stuerz.xyz>
Subject: [PATCH v4 2/2] ray_cs: Make card_status[] const
Date:   Wed,  6 Apr 2022 17:22:47 +0200
Message-Id: <20220406152247.386267-3-benni@stuerz.xyz>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220406152247.386267-1-benni@stuerz.xyz>
References: <20220406152247.386267-1-benni@stuerz.xyz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        PDS_OTHER_BAD_TLD,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make the const because it shouldn't be modified.

Signed-off-by: Benjamin Stürz <benni@stuerz.xyz>
---
 drivers/net/wireless/ray_cs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ray_cs.c b/drivers/net/wireless/ray_cs.c
index 3df795dc3d9f..07f36aaefbde 100644
--- a/drivers/net/wireless/ray_cs.c
+++ b/drivers/net/wireless/ray_cs.c
@@ -2528,7 +2528,7 @@ static void clear_interrupt(ray_dev_t *local)
 #ifdef CONFIG_PROC_FS
 #define MAXDATA (PAGE_SIZE - 80)
 
-static const char *card_status[] = {
+static const char * const card_status[] = {
 	[CARD_INSERTED]		= "Card inserted - uninitialized",
 	[CARD_AWAITING_PARAM]	= "Card not downloaded",
 	[CARD_DL_PARAM]		= "Waiting for download parameters",
-- 
2.35.1

