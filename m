Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7194EF7CA
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 18:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241356AbiDAQYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 12:24:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353886AbiDAQYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 12:24:10 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EF2FE38B9
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 08:54:34 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id k23so3299504ejd.3
        for <netdev@vger.kernel.org>; Fri, 01 Apr 2022 08:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ULnBrcCgyAehY7pimTGYw+GfPShtBBZnozPp+loj+J4=;
        b=gXUTCagRYtGDqo0DmK3XqfQPQbENDaa25ZibMhqXJZ7jVzHL5rjcq3o3lJyCHQSUoI
         l5wSOmR4hYcWxVIC47Vj/uiNQMBnNbLIByz3gLMp66oGsHMV3cXpIT2CxPGXAdfdzwfk
         Migwhx99ULau7uTcJRxGmLRFg60pZjcyKfwsNnxLYXVEmD+MhHTvTmvWoiYu3VoVhZA+
         XKE4nxs45Tkox9fe9NxyfKgQgeZq/W9UGAFtvIZpX+7Hda2/MJ+e8RhwMaQTmYxPMBjk
         ComBtEGQk2qnDxuqyO6U7aWn6iRx/FxD8M0eTBZQSm8nebiNxImYVis8+vlcbDcGTAwC
         qUgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ULnBrcCgyAehY7pimTGYw+GfPShtBBZnozPp+loj+J4=;
        b=yap4kcJEPflHB+FPdpWmwX3phRM2/4gwSZz3Seau3/zNoN9g/2BwqknOYQUnNQfJCT
         QiwY/sUOHn6RBr6lKbZQe/lNxZt9E2VVnANk4BioXNLCm6Qa1KVTmQUMegpBjo/D1Nil
         qyRCgi2hoZbQ7oUR8t9gEXx7fiQOlTMgGBp4q57G9q8TbRlIPnM8GBVUmlqksVGRZfSK
         sYmk9ftPDl2KrhwEuHmUHmsmFn8vKQQTnOhciPMeICXbopOGs9DQx2SqRro43E4l8ZeF
         kgFaHnRUt3kXJJMuHZZNVXQwyUeRp8xZSSiQ49CYc0HtLH1GPi056lLmry+yQjaUcqSX
         Elvg==
X-Gm-Message-State: AOAM531JMexceV9r/h6T20OMNMM2f8qF6NIiBv9b0m5HLFE77zVsHbdP
        HDrIq2ff8fo5K7iXP1WgEkefhe9N8yTfoOB/
X-Google-Smtp-Source: ABdhPJxPn/JO136/uv/msxFXefrZ9dERtoD4mWLir8l292AwQyQNmRZf+LAvMSREPeXT3vzg7qhjRg==
X-Received: by 2002:a17:906:9c82:b0:6df:c5f0:d456 with SMTP id fj2-20020a1709069c8200b006dfc5f0d456mr375466ejc.287.1648828472789;
        Fri, 01 Apr 2022 08:54:32 -0700 (PDT)
Received: from debil.. (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id n13-20020a170906724d00b006cedd6d7e24sm1158308ejk.119.2022.04.01.08.54.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Apr 2022 08:54:31 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     dsahern@kernel.org, kuba@kernel.org, davem@davemloft.net,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH net] selftests: net: fix nexthop warning cleanup double ip typo
Date:   Fri,  1 Apr 2022 18:54:27 +0300
Message-Id: <20220401155427.3238004-1-razor@blackwall.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220401073343.277047-3-razor@blackwall.org>
References: <20220401073343.277047-3-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I made a stupid typo when adding the nexthop route warning selftest and
added both $IP and ip after it (double ip) on the cleanup path. The
error doesn't show up when running the test, but obviously it doesn't
cleanup properly after it.

Fixes: 392baa339c6a ("selftests: net: add delete nexthop route warning test")
Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
---
The test is accurate either way.

 tools/testing/selftests/net/fib_nexthops.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
index d8ede0c81ac1..b3bf5319bb0e 100755
--- a/tools/testing/selftests/net/fib_nexthops.sh
+++ b/tools/testing/selftests/net/fib_nexthops.sh
@@ -1220,8 +1220,8 @@ ipv4_fcnal()
 	[ $out1 -eq $out2 ]
 	rc=$?
 	log_test $rc 0 "Delete nexthop route warning"
-	run_cmd "$IP ip route delete 172.16.101.1/32 nhid 12"
-	run_cmd "$IP ip nexthop del id 12"
+	run_cmd "$IP route delete 172.16.101.1/32 nhid 12"
+	run_cmd "$IP nexthop del id 12"
 }
 
 ipv4_grp_fcnal()
-- 
2.35.1

