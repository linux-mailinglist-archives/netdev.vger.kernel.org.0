Return-Path: <netdev+bounces-4146-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CCC3C70B5BC
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 09:02:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 88DA61C209B7
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 07:02:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A71133FE1;
	Mon, 22 May 2023 07:02:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9349023D2
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 07:02:11 +0000 (UTC)
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E65319BF
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 00:01:47 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-64d5b4c400fso1476684b3a.1
        for <netdev@vger.kernel.org>; Mon, 22 May 2023 00:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1684738903; x=1687330903;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QYNeVJrKOL7MnfIWnZtzWr+y0jbkK7//uDkqtArY+/I=;
        b=L2xb/K9Gl2wTLOgGLKgCeOOadn9mcb9mYkDZ/jTml6bfllu+Ci/lPKGRi96KKEECnJ
         c8wuCuHsqAqH2CQAT4R6RkQAdWOHueqieAR8/Lgo+w7V6MWOgGhJYQ0pc8Pc/jE02OOm
         +2yJ/pgSVnknd4HJ1Vro0U8u3RbL5udWQHTMaMpYP1gRFNTvLrVr/6GW4CfEGEEbz0ag
         gFWUACaDCpwkfJ7tSuFYTlc4yjGEY4uXy2AzAFE+S/aY/7E72qGXRSdV2tkVpOQWopgo
         VjkwL1ADzY9+yfE2kh/LdT/hvyeb/rbrWID+Xd6F8E9hLLUmok8UXKEqIARxKM1JZ7cf
         bH5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684738903; x=1687330903;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QYNeVJrKOL7MnfIWnZtzWr+y0jbkK7//uDkqtArY+/I=;
        b=V7hzL4QYjjH/MJo2dsKL2MjRjILhuXTGaCIUTvwUY/yPCrtLwxMqjSFspFoOk4eTkc
         nFG/hzEn2NkvbYncIAAihj7q4X2NFNWWR/IRPaFMzvh9gbvbIjO+4d1AE9j6DAy842rs
         BRUKj3pLivBQTLro/uHfduEX7KOI6mkvE6FmGJeXM3blrbm1gQlCYfjUX8DFcKnPfhaA
         jpUr9UwGO7PePU2fMT/okrmCN3ZOwQxzqmviRbS6g3c0C386T+xE3VxmvzWzZg+8P7ZU
         X1yR7KfxPIVqsLQw9CyPmQ/54/SIjmb2ns8wef+kBRsB/9YcmjpviXx1HV5ED9mkQJfS
         Lhhg==
X-Gm-Message-State: AC+VfDwCDbHAyI6jEEshsihG2+X/SDbnDaVAv9r1RXlcqwcZwd9Ylaiw
	8Ew9Uk8+/a9TsucTPZKtMdq6nA==
X-Google-Smtp-Source: ACHHUZ4I2WbOlKYOgzusUIffYUqfzhoqarV0DqN2Qs8ysF7zrJxV4MnqZfQF+rRfmw9+kt+ngQ4/Vw==
X-Received: by 2002:a05:6a20:c886:b0:106:5dff:5dc6 with SMTP id hb6-20020a056a20c88600b001065dff5dc6mr9467949pzb.16.1684738903209;
        Mon, 22 May 2023 00:01:43 -0700 (PDT)
Received: from localhost.localdomain ([139.177.225.251])
        by smtp.gmail.com with ESMTPSA id d27-20020a630e1b000000b0052cbd854927sm3687505pgl.18.2023.05.22.00.01.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 00:01:42 -0700 (PDT)
From: Abel Wu <wuyun.abel@bytedance.com>
To: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Glauber Costa <glommer@parallels.com>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Abel Wu <wuyun.abel@bytedance.com>
Subject: [PATCH v2 0/4] sock: Improve condition on sockmem pressure
Date: Mon, 22 May 2023 15:01:18 +0800
Message-Id: <20230522070122.6727-1-wuyun.abel@bytedance.com>
X-Mailer: git-send-email 2.37.3
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Currently the memcg's status is also accounted into the socket's
memory pressure to alleviate the memcg's memstall. But there are
still cases that can be improved. Please check the patches for
detailed info.

v2:
  - Splited into several patches and modified commit log for
    better readability.
  - Make memcg's pressure consideration function-wide in
    __sk_mem_raise_allocated().

v1: https://lore.kernel.org/netdev/20230506085903.96133-1-wuyun.abel@bytedance.com/

Abel Wu (4):
  sock: Always take memcg pressure into consideration
  sock: Fix misuse of sk_under_memory_pressure()
  sock: Consider memcg pressure when raising sockmem
  sock: Remove redundant cond of memcg pressure

 include/net/sock.h | 11 +++++++----
 net/core/sock.c    | 32 +++++++++++++++++++++++---------
 2 files changed, 30 insertions(+), 13 deletions(-)

-- 
2.37.3


