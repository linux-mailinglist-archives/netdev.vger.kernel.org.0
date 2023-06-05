Return-Path: <netdev+bounces-7885-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 86833721F7F
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 09:27:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4BDE82811EC
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 07:27:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8564EAD3C;
	Mon,  5 Jun 2023 07:27:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A3068BEA
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 07:27:50 +0000 (UTC)
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84B3098;
	Mon,  5 Jun 2023 00:27:48 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id 38308e7fff4ca-2b1a46ad09fso51084121fa.2;
        Mon, 05 Jun 2023 00:27:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685950067; x=1688542067;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TsP0n5juNyauxV4ZzGiEHcjUixvHobJ7dhZs4yRrqJI=;
        b=h/7XCXusn51Z8gchWhBGbEfoI1f8wXzjmCmwyAV+YdrxWmws2wUFCK+9WUMNXmxLM3
         A5lDIMH5vr7hiosRq4hrPBbLukoEG1FWYPzLBBG41IPfIvt/ESeOWkL6QliA+x7rrhI/
         Vn7oGdOSfbgaP4hcSAxiwAtoHGA1PGC5mvOuMbH9oAcXDlJwSwUtGYSX6AcqbNrNMiNi
         E4V7csdznjg3FFvDMQv8UuATgEC07xMSCkb56wkAVhyDXbecGj+5y3LcPvfCwIGUQTWL
         fq+QB8K2iI5d2AFTy1avYEcBAX6OzrdeZDiB2FhvUcPbI0HEGOy36kLuRYehMhzZvA5w
         ZG1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685950067; x=1688542067;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TsP0n5juNyauxV4ZzGiEHcjUixvHobJ7dhZs4yRrqJI=;
        b=doeI1FvRhi2PJT59GBt5LLKl4c5B5E7nnnUx/yi6Z0OlBvCHpO+g2gwHTBe+OIsVmd
         qwT7K1jM+uVAcMYK46xD2+FpR/0709TC9/e0bFbU6muqlFOXZC+iDuIaY//1fQcmSeQh
         eQNisn0jyt2zGrNnxsNlTGSoJXe7/6nJv7eiV8DP7tmoKrR+OCAULoLVkjmVh7pIKsFL
         QPt9OkDrgUk0wEQDWsPR8fYYc4TFpVqtYIKMEf0I844DnphKIWThu+sRQTsidCsaSaiI
         /GYGKom/tcQahqcr9l/4TmIU5kqq41ULac1Aktj91QC1ipTiZ6pbPNoQvxn8yVfHMTh+
         evdQ==
X-Gm-Message-State: AC+VfDz+nB3szubGDdjtgZIcfhT7zepN0O8Jaq4emQe6+w+j2QJgTR7F
	QGRdbprw2pEXC3uwlCbOvw0=
X-Google-Smtp-Source: ACHHUZ4Wz4q+jZu5kAv6QOPm74HoKeM8yyFcMAonyqnL8xCKX2S2QjaBAoS+jo+0EcG7yzxfafXP/Q==
X-Received: by 2002:a2e:9d18:0:b0:2b0:3343:1c0a with SMTP id t24-20020a2e9d18000000b002b033431c0amr3192634lji.31.1685950066428;
        Mon, 05 Jun 2023 00:27:46 -0700 (PDT)
Received: from felia.fritz.box ([2a02:810d:7e40:14b0:91ce:1f9c:f9d4:7837])
        by smtp.gmail.com with ESMTPSA id kj24-20020a170907765800b00965f5d778e3sm3911553ejc.120.2023.06.05.00.27.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 00:27:45 -0700 (PDT)
From: Lukas Bulwahn <lukas.bulwahn@gmail.com>
To: Jaco Kroon <jaco@uls.co.za>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH] net/pppoe: fix a typo for the PPPOE_HASH_BITS_1 definition
Date: Mon,  5 Jun 2023 09:27:43 +0200
Message-Id: <20230605072743.11247-1-lukas.bulwahn@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>

Instead of its intention to define PPPOE_HASH_BITS_1, commit 96ba44c637b0
("net/pppoe: make number of hash bits configurable") actually defined
config PPPOE_HASH_BITS_2 twice in the ppp's Kconfig file due to a quick
typo with the numbers.

Fix the typo and define PPPOE_HASH_BITS_1.

Fixes: 96ba44c637b0 ("net/pppoe: make number of hash bits configurable")
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---
 drivers/net/ppp/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ppp/Kconfig b/drivers/net/ppp/Kconfig
index 2fbcae31fc02..8c9ed1889d1a 100644
--- a/drivers/net/ppp/Kconfig
+++ b/drivers/net/ppp/Kconfig
@@ -141,7 +141,7 @@ choice
 
 		This hash table is on a per outer ethernet interface.
 
-config PPPOE_HASH_BITS_2
+config PPPOE_HASH_BITS_1
 	bool "1 bit (2 buckets)"
 
 config PPPOE_HASH_BITS_2
-- 
2.17.1


