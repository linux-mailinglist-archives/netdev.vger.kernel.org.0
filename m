Return-Path: <netdev+bounces-5365-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C1B6710EE2
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 16:59:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E0A901C208D1
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 14:59:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1F07156F7;
	Thu, 25 May 2023 14:58:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D7BFC1B
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 14:58:43 +0000 (UTC)
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ECCB10C4
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 07:58:19 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id af79cd13be357-75b050b4fa0so106319085a.0
        for <netdev@vger.kernel.org>; Thu, 25 May 2023 07:58:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685026659; x=1687618659;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dD38hC+cCrWMU0ih2g0kMm8EHlyKDDOEX4V/VlJWyJU=;
        b=DNip7uOIqCjXQvtglWKZSo4fsnusEJMp/AZ5cdeHeSRpnChwbaLvHm8q/I9Qxxv17n
         9AkKXnhmt45dlAb0zkN9ZCCR9Ll9bSdoSJ4IUpG4S2nEraVqFJNsIlbOIR2KReIVln1G
         dpfHhEA5w9GqNsjjMgMezpImh5UxK/5l+z6ag7gmiV/0F5ZDXFtm24qxvDF3FqML8nRY
         hENBT4zVB+YNjllC5OkaXKeSPJLLDqeZff/+eoICKVeNwsdtviKAOD9s+3JcPfHq2/a8
         emlCYH4IQ4cyFX8DYI2BszwU7rCuEx1nZfwOiGE75/rHOB61PKkmMpgKRrLIzjOU94zm
         qb/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685026659; x=1687618659;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dD38hC+cCrWMU0ih2g0kMm8EHlyKDDOEX4V/VlJWyJU=;
        b=IlGaHzXBkNvZAWuKg6zar56TNX8zD0UfyaTeY12E9uecuvCkDssG/ud7Zx+iG31XIA
         fSgyel0xwQocsaBVa0GOzbWcsAD6+R3YOIkavf0pYdo3zR1/GhBLnQ8FVET84pXWmTCO
         HLw9Ni1nKKzdCySr7vnFiivXC6xSMnlU4+qSWUiaj95G6izj01k5+W8cBCjU6KGDziaO
         7AaBe5Jm5wZUCD23cYC0jfPAT+rmWeoPhtwKXoOZ+2wzrCHb+NknJCdiDVhu5ePY31Xm
         7YRO3zImH6VD5wh1EX9AYqp8it0jLKj2AKqln3bqbTKJwAx1MJkzYD9yzN285MUbIGEy
         6zvQ==
X-Gm-Message-State: AC+VfDw9FxruXHgMLt1fqbJqgz9/aN4SpYmvzyBAdeZTSemnjjytcj6f
	0ZzFvNm4iG7Hg/D9ODwIhnI=
X-Google-Smtp-Source: ACHHUZ66PeBAo6OK452FYpc1EpSSJ2vNHqFVSBI7O1Kwm01PlJk2P2FIBfudbTMa6GGZyutEbS9j+A==
X-Received: by 2002:a05:6214:212b:b0:625:75dd:236d with SMTP id r11-20020a056214212b00b0062575dd236dmr1670154qvc.23.1685026659429;
        Thu, 25 May 2023 07:57:39 -0700 (PDT)
Received: from soy.nyc.corp.google.com ([2620:0:1003:32a:3224:68f5:46ec:cb29])
        by smtp.gmail.com with ESMTPSA id jh18-20020a0562141fd200b0062382e1e228sm460741qvb.49.2023.05.25.07.57.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 07:57:38 -0700 (PDT)
From: Neal Cardwell <ncardwell.sw@gmail.com>
To: David Miller <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>
Cc: netdev@vger.kernel.org,
	Neal Cardwell <ncardwell@google.com>
Subject: [PATCH net-next] tcp: remove unused TCP_SYNQ_INTERVAL definition
Date: Thu, 25 May 2023 10:57:36 -0400
Message-ID: <20230525145736.2151925-1-ncardwell.sw@gmail.com>
X-Mailer: git-send-email 2.40.1.698.g37aff9b760-goog
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Neal Cardwell <ncardwell@google.com>

Currently TCP_SYNQ_INTERVAL is defined but never used.

According to "git log -S TCP_SYNQ_INTERVAL net-next/main" it seems
the last references to TCP_SYNQ_INTERVAL were removed by 2015
commit fa76ce7328b2 ("inet: get rid of central tcp/dccp listener timer")

Signed-off-by: Neal Cardwell <ncardwell@google.com>
---
 include/net/tcp.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 02a6cff1827e..8123de1e0db9 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -161,8 +161,6 @@ void tcp_time_wait(struct sock *sk, int state, int timeo);
 #define MAX_TCP_KEEPCNT		127
 #define MAX_TCP_SYNCNT		127
 
-#define TCP_SYNQ_INTERVAL	(HZ/5)	/* Period of SYNACK timer */
-
 #define TCP_PAWS_24DAYS	(60 * 60 * 24 * 24)
 #define TCP_PAWS_MSL	60		/* Per-host timestamps are invalidated
 					 * after this time. It should be equal
-- 
2.40.1.698.g37aff9b760-goog


