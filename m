Return-Path: <netdev+bounces-9361-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2ECDE728970
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 22:29:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DCEDC2817C3
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 20:29:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D1ED34472;
	Thu,  8 Jun 2023 20:27:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 187C82D279
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 20:27:19 +0000 (UTC)
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B12E3582
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 13:27:02 -0700 (PDT)
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id A574F3F36F
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 20:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1686256018;
	bh=BjVOaOX+rOUwxqfCcfqaeBd3w4EjFD+d/9OSygYwXOc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version;
	b=wQK0hZhVfLcMxU4dlxzm2B9+jBCZKbCDPSbrR+s1fc8+Oh6xHJ+WqknKa0ztL23BR
	 q5ebjyq/74YcPh0accPMv8Xunc1HJXWTOyZNjY8Uy4ty+duhKgFzPwc57CzcOlFiA0
	 WiYNQu7a9PakROvBg4Qi7zKrXzfL2y19jzIvP9GgluqEwLncNCP+HewUs+kAxtdj59
	 zCejD0j3jvHi4S5ylfEvV31ipqIGiv5epun07nOaYFdH83q0hvwA47r2K7GW9E+SA1
	 HIMdyhzQZu0ct6XfutGI2vcnX6PuyZGnKjS0hnsFID/Hoznqfrd2x23BxX3yaV/t/A
	 bdMIo/QjUZaOQ==
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-974566553ccso116568866b.3
        for <netdev@vger.kernel.org>; Thu, 08 Jun 2023 13:26:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686256018; x=1688848018;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BjVOaOX+rOUwxqfCcfqaeBd3w4EjFD+d/9OSygYwXOc=;
        b=VyOMvPi0YFZEw7GLw6BFo1ZXvVdEIGI6pMVaDP/E+8EM9t/eIZW3UpCGu+QpuoKqzO
         +XkJdIaCSY3hf+yLbwLYe8OMPvwgsclwt/Ll3/IaEl4W+hF0TBOv/ipSAAvU0v1OsSv0
         FVyKZ2AnhmL3fxvz1X/Q+h+Qo1EhATUQ2/YcOboGRsTzIVzEDjTwow+iQuFNPfCScedl
         g8fzQpIK/7kxzu+3sXiHdqtgfVjYKs3nmAGlDlEGfhzbX3EfxcIRTShv6qOX9hQOHTjk
         NV7NPc81PN0M+2Emg3AbXDRkdcANS5kxNZdLclO8N8MMRqZMIxC3sHv43riMS0Lpzbb3
         sqgw==
X-Gm-Message-State: AC+VfDzgHuXIq0hV/4aR9fkzYUf5KL8OAlCprzyB7f6Utv/Ae0EMVXmG
	mx69+sSQTCBkjRrxMHSkWEHO3rcEFCzHdgj66rCQFTZaohum8imIT7GsSCTx3xP/cPjzwbmZClZ
	/jSj9afeLKQ6dKHAYnQiXVyexLwCt2If7SQ==
X-Received: by 2002:a17:907:7f23:b0:973:903c:35a4 with SMTP id qf35-20020a1709077f2300b00973903c35a4mr244238ejc.65.1686256018293;
        Thu, 08 Jun 2023 13:26:58 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ64l2skizqYkkoGjgKsgZOunpklCFslHyfrAGzKKNXGIZ19vqFFoZ4QRgjtjzYgI/m2J585WA==
X-Received: by 2002:a17:907:7f23:b0:973:903c:35a4 with SMTP id qf35-20020a1709077f2300b00973903c35a4mr244226ejc.65.1686256018075;
        Thu, 08 Jun 2023 13:26:58 -0700 (PDT)
Received: from amikhalitsyn.local (dslb-002-205-064-187.002.205.pools.vodafone-ip.de. [2.205.64.187])
        by smtp.gmail.com with ESMTPSA id b16-20020a170906491000b0095342bfb701sm315592ejq.16.2023.06.08.13.26.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 13:26:57 -0700 (PDT)
From: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To: davem@davemloft.net
Cc: linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Leon Romanovsky <leon@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Kees Cook <keescook@chromium.org>,
	Christian Brauner <brauner@kernel.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Lennart Poettering <mzxreary@0pointer.de>,
	Luca Boccassi <bluca@debian.org>,
	linux-arch@vger.kernel.org
Subject: [PATCH net-next v7 4/4] af_unix: Kconfig: make CONFIG_UNIX bool
Date: Thu,  8 Jun 2023 22:26:28 +0200
Message-Id: <20230608202628.837772-5-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230608202628.837772-1-aleksandr.mikhalitsyn@canonical.com>
References: <20230608202628.837772-1-aleksandr.mikhalitsyn@canonical.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Let's make CONFIG_UNIX a bool instead of a tristate.
We've decided to do that during discussion about SCM_PIDFD patchset [1].

[1] https://lore.kernel.org/lkml/20230524081933.44dc8bea@kernel.org/

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: David Ahern <dsahern@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Kees Cook <keescook@chromium.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: Lennart Poettering <mzxreary@0pointer.de>
Cc: Luca Boccassi <bluca@debian.org>
Cc: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-arch@vger.kernel.org
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
---
 net/unix/Kconfig | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/net/unix/Kconfig b/net/unix/Kconfig
index b7f811216820..28b232f281ab 100644
--- a/net/unix/Kconfig
+++ b/net/unix/Kconfig
@@ -4,7 +4,7 @@
 #
 
 config UNIX
-	tristate "Unix domain sockets"
+	bool "Unix domain sockets"
 	help
 	  If you say Y here, you will include support for Unix domain sockets;
 	  sockets are the standard Unix mechanism for establishing and
@@ -14,10 +14,6 @@ config UNIX
 	  an embedded system or something similar, you therefore definitely
 	  want to say Y here.
 
-	  To compile this driver as a module, choose M here: the module will be
-	  called unix.  Note that several important services won't work
-	  correctly if you say M here and then neglect to load the module.
-
 	  Say Y unless you know what you are doing.
 
 config UNIX_SCM
-- 
2.34.1


