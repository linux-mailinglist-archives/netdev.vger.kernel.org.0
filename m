Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC51653BA69
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 16:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235524AbiFBOBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 10:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235643AbiFBOBb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 10:01:31 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9FD229FE6C
        for <netdev@vger.kernel.org>; Thu,  2 Jun 2022 07:01:30 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id q18so4574462pln.12
        for <netdev@vger.kernel.org>; Thu, 02 Jun 2022 07:01:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=FtMPw/UI3OSdRNifjfzs2Ej9FUMxxMPJrrkz4FjDg00=;
        b=avQM8YI86yCYQQdb2JYEaLMHRB6Yee1xmDZpBsEEOvWrAzMfzsVgZDu/roQq00GQ5E
         w6Zdheiuzbv8Yw9wOgEVHIO3OJLTT7NAqqJU4+avULV7MTOteHmZh7AhqAFdGQ97Cimo
         qBJ2kGS46HnxHoZkL+xyt/FjiTIWCBK05Fit6SNl2N45XrAvv4+1BzBea5M1B/NpMV8v
         5YECURU47AgeIvAiDgjQEKFySPW7qdPGEPGYme0tMRgvu3O+f7Z6MfQ9hayp4nPrq5zS
         eG9+SfiTzyP24BTf5JuhRU/MW1LDmYiTH2M0WEr0iTFL20eegsohxXh/zRIO6dyIOuen
         lqVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=FtMPw/UI3OSdRNifjfzs2Ej9FUMxxMPJrrkz4FjDg00=;
        b=zn5eWyZQol5PlyWRpoho/7vPeWiRNgHf1q/cAr2KFoqzmLqXk4W/ip6ZP+ppeS9Lst
         mKEv6L7v0VcsgHgSo5YNbDt7ap4+E1+0E1PVGEqA0V6PMSndN7zmSCSgDrwMlpczDlLl
         E00hEDD6rkhUoHRwUMfWsueVGybq8QtwHYmtkYZPPbLpWEat180iQhG4z7LWAqwVxw+z
         aNdsLHkZ4Wf1pNVZ+9AY61GttebtcbqpFj+vpzjEglEcvjo3E/XLRPXY/FGdpX0M52Me
         y9Ln0kmxoYaxZPnICBQJwGHcADODxm+3ZtDRw0+IZkBH2EBsLLqYUuR5Ee+kAbWmsltV
         wL2g==
X-Gm-Message-State: AOAM532GjmsTEk7BR0GgLysMKSJmXGAgDBho1fizRxz5ZQvAkK7PYoPi
        llQNYjCF7Q04kZKMm3LUSFI=
X-Google-Smtp-Source: ABdhPJypkvTO2ezvUtNwkqf88CG99qxsOJ9oQz/4ub1cfOucig4z706nEf9/nmqsXDtqwIC/ePSq2A==
X-Received: by 2002:a17:903:1d2:b0:165:fd6:6ab6 with SMTP id e18-20020a17090301d200b001650fd66ab6mr5073140plh.41.1654178490151;
        Thu, 02 Jun 2022 07:01:30 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id k13-20020aa7998d000000b0050dc76281ecsm108463pfh.198.2022.06.02.07.01.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jun 2022 07:01:29 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 3/3] amt: fix wrong type string definition
Date:   Thu,  2 Jun 2022 14:01:08 +0000
Message-Id: <20220602140108.18329-4-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220602140108.18329-1-ap420073@gmail.com>
References: <20220602140108.18329-1-ap420073@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

amt message type definition starts from 1, not 0.
But type_str[] starts from 0.
So, it prints wrong type information.

Fixes: cbc21dc1cfe9 ("amt: add data plane of amt interface")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/amt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index ef483bf51033..be2719a3ba70 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -51,6 +51,7 @@ static char *status_str[] = {
 };
 
 static char *type_str[] = {
+	"", /* Type 0 is not defined */
 	"AMT_MSG_DISCOVERY",
 	"AMT_MSG_ADVERTISEMENT",
 	"AMT_MSG_REQUEST",
-- 
2.17.1

