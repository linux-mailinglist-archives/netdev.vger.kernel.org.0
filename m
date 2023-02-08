Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACEB768E68E
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 04:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbjBHDVY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 22:21:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbjBHDVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 22:21:23 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F5F4C02
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 19:21:20 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id a5so9188308pfv.10
        for <netdev@vger.kernel.org>; Tue, 07 Feb 2023 19:21:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nln0p+/pxQmjacA2p5dBzK6VCMWzMygwZUeFqT3/anE=;
        b=DqOfkHoA0J5z0g1S1qaoTjtTut11MKkbAFmdMqahDZMV1ov7RykuP6O4DtvcLqmknH
         hCRSjx2ZvJg4g6kKTuZGQPteXumXYPooudt1Mf9atgvKkpwCk4OPen0iVnQhfFnUKaS+
         /ESszEVIBdK02gMw+RSULn1XbjauRyLfPp3TUGjZ3ErMoRco9m13XGFcOXLc0oOiYTsp
         OmIWEdbAI4ac15Y/AslbIdMVDs1+JMOPZYPb94665cB8NkoptfclDfm1HZMNg3YiJBrO
         ONI69xrQVJualkb3xT+OVpqq9a3/nNO813QGQSfW1en0AoPJoQUWWxkwHXEmBCgr+hlk
         5TLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nln0p+/pxQmjacA2p5dBzK6VCMWzMygwZUeFqT3/anE=;
        b=pqF/f8ex0K8Erf53+Oi6kY3o4FNIvKZa28f8XuSrdzQkjBa4haT2nfGFNTvx7m4t8H
         vI6wwunR/qT2e9qiy5scPJgxVG57k7Oe1kuYuHf4lIVFiUFHr2xO0KMlLuGPCSocw/8e
         wkTPOHShxPHERAQMr2xzMdjfFBlNTOyOZ8PZinyDo7JZLWXyiyoHvSOJTkOC9Zc+lBzu
         xuDbbg5vZDxbvAwl9bGTjv2YkHefsYmf3ieW/FUS4EMj0+H/k08gfeFM5migYVvjI3kq
         6eQEHSxviMBgfkiNjyzlR8gqfH4AAZmgEO+LhnE9rWqVQHZvkyJkw0tKMKHx8AKBZlIG
         d+aA==
X-Gm-Message-State: AO0yUKV0iRUZb53OdhjOLhDJan8ugZVcM8MfDm2hO03cbphNQeuCuN/X
        42mFVDOMageGDEbVUeSRRsmlIrdEdlnHHg==
X-Google-Smtp-Source: AK7set8mdM7XoWEOUoO/vezpNKKw0F+7MX7J1b+8p89MxyzPMOldGso09KBbARwo1dGHXNKbIRG6ZQ==
X-Received: by 2002:a62:6488:0:b0:578:ac9f:79a9 with SMTP id y130-20020a626488000000b00578ac9f79a9mr4397343pfb.15.1675826479796;
        Tue, 07 Feb 2023 19:21:19 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a9-20020a056a001d0900b00575caf80d08sm9901342pfx.31.2023.02.07.19.21.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 19:21:19 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Petr Machata <petrm@mellanox.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net] selftests: forwarding: lib: quote the sysctl values
Date:   Wed,  8 Feb 2023 11:21:10 +0800
Message-Id: <20230208032110.879205-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When set/restore sysctl value, we should quote the value as some keys
may have multi values, e.g. net.ipv4.ping_group_range

Fixes: f5ae57784ba8 ("selftests: forwarding: lib: Add sysctl_set(), sysctl_restore()")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tools/testing/selftests/net/forwarding/lib.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index 1c4f866de7d7..3d8e4ebda1b6 100755
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -914,14 +914,14 @@ sysctl_set()
 	local value=$1; shift
 
 	SYSCTL_ORIG[$key]=$(sysctl -n $key)
-	sysctl -qw $key=$value
+	sysctl -qw $key="$value"
 }
 
 sysctl_restore()
 {
 	local key=$1; shift
 
-	sysctl -qw $key=${SYSCTL_ORIG["$key"]}
+	sysctl -qw $key="${SYSCTL_ORIG[$key]}"
 }
 
 forwarding_enable()
-- 
2.38.1

