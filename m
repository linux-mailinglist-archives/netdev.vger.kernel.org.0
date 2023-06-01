Return-Path: <netdev+bounces-7136-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 46A2471A3A0
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 18:04:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D81A61C21094
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 16:04:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BBC940774;
	Thu,  1 Jun 2023 16:04:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71DA5BA2F
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 16:04:49 +0000 (UTC)
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC1E713D
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 09:04:47 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-561ceb5b584so15395837b3.3
        for <netdev@vger.kernel.org>; Thu, 01 Jun 2023 09:04:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685635487; x=1688227487;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bT4nY22anymCNzDd/SdzIHb7+/MtsGxkuCcuSViEGdI=;
        b=D7TquxGE9NvGNghBvZhwhCNlgi1aKKPgtiG9OQZF3DA+DHAKx4GP1kqqFn3p+xQgrg
         tV6hM51PCGgWEO1hqu4TNIGjpKTFixr2zo5e1MgItt1BR1eKN9c0fcPyOXFh+Ib9q9uj
         b22q6UJC6BQ+S9kwYqvoJVWsuaEq4sSr83Ubi637BJn+SWZKmgdK4q9vJh6cp8vRJuRy
         8mfvsb7g2FawSJdkHtocfHLStEW1OXm3teYw9LO1AE+XoZ2T7vP7TU6hsYsBVzrPSsdg
         QnkI8xongkICxHdY4WTQtPFMO5J3MQopyR1CxAY+ZII2c49IaUGdMFuyqQHT0GuelXr9
         iTog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685635487; x=1688227487;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bT4nY22anymCNzDd/SdzIHb7+/MtsGxkuCcuSViEGdI=;
        b=TJ6riOhwTDuzwnN9vZv02b7oBq/8TjbqeXeu152WKtsYDMheTP4tfPFcXMEdcs1CKb
         qeu69O7b3dJUBJIVqfk2UcRyYPLar5GhowzA9scbT8Wt/rwz0Z8cO9YvZTzNaRWLFins
         KJMbNXSNmfa3/VDKtkUdED+FwVb7ZRauKjlq0+VU4ACii0q3EUK2mMEnuQu33b87Jt7D
         32K2I5U6cmwN/+z0yjmYoSauNO9VxIGDcjanZWOXbsQkBIrTSSbYln4DSXKF4Pp4x9e5
         W2r/bD1R1dSKr4Uudx7H6tLRxmgz3d8AhRz9u4shGBc7uifyDL0MZRK7VNxYgf359MrY
         plUA==
X-Gm-Message-State: AC+VfDwQ6u1hYwWXlDfq1rNPFt+VyI+Bil4mgojOJWTsd8K7KtU9LYZt
	hgHmxS5EAe/JTa1OrfP0g/Fq1Rhw1r2hbg==
X-Google-Smtp-Source: ACHHUZ6K5jU43PqBwWFj0XvOaY7IddM60Xg2HxyWMJizbjHgrW8cT9nZaWVW2h5qWoaRKyYrxFTeadEPlbVAWg==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:320c:0:b0:ba8:6422:7fc with SMTP id
 y12-20020a25320c000000b00ba8642207fcmr206579yby.7.1685635487030; Thu, 01 Jun
 2023 09:04:47 -0700 (PDT)
Date: Thu,  1 Jun 2023 16:04:43 +0000
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230601160445.1480257-1-edumazet@google.com>
Subject: [PATCH net 0/2] net/ipv6: skip_notify_on_dev_down fix
From: Eric Dumazet <edumazet@google.com>
To: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>, 
	Matthieu Baerts <matthieu.baerts@tessares.net>, eric.dumazet@gmail.com, 
	Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

While reviewing Matthieu Baerts recent patch [1], I found it copied/pasted
an existing bug around skip_notify_on_dev_down.

First patch is a stable candidate, and second one can simply land
in net tree.

https://lore.kernel.org/lkml/20230601-net-next-skip_print_link_becomes_ready-v1-1-c13e64c14095@tessares.net/

Eric Dumazet (2):
  net/ipv6: fix bool/int mismatch for skip_notify_on_dev_down
  net/ipv6: convert skip_notify_on_dev_down sysctl to u8

 include/net/netns/ipv6.h | 2 +-
 net/ipv6/route.c         | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

-- 
2.41.0.rc0.172.g3f132b7071-goog


