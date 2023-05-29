Return-Path: <netdev+bounces-6103-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D5245714D1A
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 17:34:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 903E8280D16
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 15:34:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF5388F52;
	Mon, 29 May 2023 15:34:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A48DE8C11
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 15:34:18 +0000 (UTC)
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59D679C
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 08:34:17 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id 5614622812f47-38e3228d120so2105047b6e.3
        for <netdev@vger.kernel.org>; Mon, 29 May 2023 08:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1685374456; x=1687966456;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HD/rkgzAmI9vqe2ZDw1KeJgi3mG8W1bCV8beK0ezNiM=;
        b=mAmtWMxeJuAiAlVEoGMqh1eDWSK8ggmfTNw6gQSxxWDg41tNa8Q1Kts3bSXYJ6XO34
         cUQvchaR17jN5++usKNqoIww/6Tm6xMGZ8fhVkenKSB6hf4xMEEXOi88WGe2J/WNqnqO
         HBA5Wde6NBPNpN7Lc4ISuo1MyR64N+ABlZOLh1FcV7DJm1DVa8dXrU8p793gAwh2aBWW
         KAY1snFBRtgGfmN1XvQrrHdk7sAJyoBy64djc2ZVEUWhrRh8XItDymSQcEbnGLCGGnyQ
         J4ylq33CH1Vue2agFPBXrDgXXY/rC/JDcidjLM23YCk9OPUOINlQvB/3GIx9PdG32DK6
         IkfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685374456; x=1687966456;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HD/rkgzAmI9vqe2ZDw1KeJgi3mG8W1bCV8beK0ezNiM=;
        b=mCB+Umc49DwxycZzhjWE2K6lWdwnn87fgL41P5PJzBs+vBQjJsF79DtBjsTA7azxgv
         sbzfrfe6k3qIx3thn2BGroYP81UuWeRJC4VWfNnpazc/urYDKXExKfQm7BKQ85WKoT2K
         4Lfv+y+5YWTZQUhdDkfqaDEyEFWDft0aOqboB2TyoiesC5u/Uevk/aBW9g61Zhvp+xKh
         0FM3FAUYOnNmJxkUdL2b5m2doErtFATb0d/Sv0r7zI4zIHdElc2FWGFZX4B+IIdTivdq
         rwCJwO7PRcSNW1oS9f9Fy1VX3oWkY9qAUwzAHSivFMaYoPpzHi1pxvU9hlgk16eFU4pe
         LR/w==
X-Gm-Message-State: AC+VfDwtQ0D5L0qh7gppkkMUBXuhrCj3vIhO5dpk0KktfOGDL0PP/6a4
	2LxjK94kcEGTE4ZBiyxKShU3ssnPOiV5xw4v9q4=
X-Google-Smtp-Source: ACHHUZ6oXaMoN7baAfgG+ZMrtTHqtOCBLDtvlL+JNBU0K5aNnfFeevd3jbwKvktynvyU41bq/b5Rdg==
X-Received: by 2002:a05:6808:1813:b0:398:2a6b:8647 with SMTP id bh19-20020a056808181300b003982a6b8647mr6440336oib.35.1685374456302;
        Mon, 29 May 2023 08:34:16 -0700 (PDT)
Received: from rogue-one.tail33bf8.ts.net ([2804:14d:5c5e:44fb:e754:d14e:b665:58ef])
        by smtp.gmail.com with ESMTPSA id e187-20020a4a55c4000000b00555718c0c5dsm4671526oob.37.2023.05.29.08.34.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 08:34:15 -0700 (PDT)
From: Pedro Tammela <pctammela@mojatatu.com>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	kuniyu@amazon.com,
	dh.herrmann@gmail.com,
	jhs@mojatatu.com,
	Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next] net/netlink: fix NETLINK_LIST_MEMBERSHIPS length report
Date: Mon, 29 May 2023 12:33:35 -0300
Message-Id: <20230529153335.389815-1-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The current code for the length calculation wrongly truncates the reported
length of the groups array, causing an under report of the subscribed
groups. To fix this, use 'BITS_TO_BYTES()' which rounds up the
division by 8.

Fixes: b42be38b2778 ("netlink: add API to retrieve all group memberships")
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 net/netlink/af_netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index c87804112d0c..3a1e0fd5bf14 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1779,7 +1779,7 @@ static int netlink_getsockopt(struct socket *sock, int level, int optname,
 				break;
 			}
 		}
-		if (put_user(ALIGN(nlk->ngroups / 8, sizeof(u32)), optlen))
+		if (put_user(ALIGN(BITS_TO_BYTES(nlk->ngroups), sizeof(u32)), optlen))
 			err = -EFAULT;
 		netlink_unlock_table();
 		return err;
-- 
2.39.2


