Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58D446EA529
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 09:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231352AbjDUHra (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 03:47:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231345AbjDUHr3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 03:47:29 -0400
Received: from mail-ed1-x564.google.com (mail-ed1-x564.google.com [IPv6:2a00:1450:4864:20::564])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98C522D57
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 00:47:24 -0700 (PDT)
Received: by mail-ed1-x564.google.com with SMTP id 4fb4d7f45d1cf-5067736607fso2277694a12.0
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 00:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google; t=1682063243; x=1684655243;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GptZ9S2v2iuA/K48gnra10lLb8nRLcNTkLUfYfYQWOM=;
        b=dsSsvjGTK3MbZkaHgdf0EpNe7c1qbLnurBz9luyhtyAJjnEk7/v0dLJyVvcqbp3VsF
         SzoSFYjtKopyhtaL5LtovQzoVXZMakGQWthqGWYdTSIdcxO7r/JRH9f36K6JwZeZ3ALa
         epBQZCtZLt/KajFAVnKc497dhr2vFpZbOzomAn8A0uYTCsvFzm2UItmKdnaGmtmy11aK
         BBVLf7rRILG87ybmx7qBAK3pR6tfFqkqrSXSHGZl1rVvIGARlNj8HHVuqv9wVG8il0uE
         dZI4/1Wy/7KZZjnEQSiRL4nQc7/dcRqysRdJ1N8aHoqHsCTCCLc06noQSW8e4Ocq+VX6
         aU6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682063243; x=1684655243;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GptZ9S2v2iuA/K48gnra10lLb8nRLcNTkLUfYfYQWOM=;
        b=B+iemTNY1r6/0DY/tIITGSf8mG2CWFpidEh+W+1NQWNPeSLTXXrGs5AfeqA1Fs5mUl
         rhx1IJrfgo14s+Sz8+HJ+JJI80Cpy+hwLZoguyOLZFC6MkBxU4xk6h6M42KMCxGbxmaM
         wPrgFzuDt3ufOWTxMCIRs4Z7IkysJVZBL0RiCimIf24dmkib14mt4ozp/hFf3ukDCfwI
         1CJidCtniAdQ06059EcjLdE6hVUEitgJfurxyry4R5CDma2+UCNC8OQnufnOY05zp06f
         RdFegZ53VkGSVDbTNgee2vHP7rxq8oJIdHwBuljhVVM2yqnJi4KKek77uWPqPyiTuPnt
         4FoA==
X-Gm-Message-State: AAQBX9cX0Bz6hzxRozKzsbrAsOeIn+8yHr9YBUGaYxzA4B9lbzIezj9d
        9keMU3xOwxaD7JufHyLKvzBUL1FcQpF5zDanPIi7e53uvTYiYw==
X-Google-Smtp-Source: AKy350YM+foqPNpJpjvQ9tDKUQjwztWvFHjBWY2e2l3T1Foy1R0eOFYH8jzpcQclO/yirpsb+LBIOEFpptq/
X-Received: by 2002:a17:906:1814:b0:957:1292:6726 with SMTP id v20-20020a170906181400b0095712926726mr1591229eje.55.1682063242893;
        Fri, 21 Apr 2023 00:47:22 -0700 (PDT)
Received: from smtpservice.6wind.com ([185.13.181.2])
        by smtp-relay.gmail.com with ESMTP id t22-20020a17090616d600b0095372072492sm614187ejd.287.2023.04.21.00.47.22;
        Fri, 21 Apr 2023 00:47:22 -0700 (PDT)
X-Relaying-Domain: 6wind.com
Received: from bretzel (bretzel.dev.6wind.com [10.17.1.57])
        by smtpservice.6wind.com (Postfix) with ESMTPS id 91EA6601C5;
        Fri, 21 Apr 2023 09:47:22 +0200 (CEST)
Received: from dichtel by bretzel with local (Exim 4.92)
        (envelope-from <dichtel@6wind.com>)
        id 1pplUI-00089d-FP; Fri, 21 Apr 2023 09:47:22 +0200
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        Simon Horman <simon.horman@corigine.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH iproute2 v3 1/2] iplink: use the same token NETNSNAME everywhere
Date:   Fri, 21 Apr 2023 09:47:19 +0200
Message-Id: <20230421074720.31004-2-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230421074720.31004-1-nicolas.dichtel@6wind.com>
References: <20230421074720.31004-1-nicolas.dichtel@6wind.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use NETNSNAME everywhere to ensure consistency between man pages and help
of the 'ip' command.

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 ip/iplink.c           | 4 ++--
 man/man8/ip-link.8.in | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/ip/iplink.c b/ip/iplink.c
index a8da52f9f7ca..8755fa076dab 100644
--- a/ip/iplink.c
+++ b/ip/iplink.c
@@ -63,7 +63,7 @@ void iplink_usage(void)
 			"		    [ mtu MTU ] [index IDX ]\n"
 			"		    [ numtxqueues QUEUE_COUNT ]\n"
 			"		    [ numrxqueues QUEUE_COUNT ]\n"
-			"		    [ netns { PID | NAME } ]\n"
+			"		    [ netns { PID | NETNSNAME } ]\n"
 			"		    type TYPE [ ARGS ]\n"
 			"\n"
 			"	ip link delete { DEVICE | dev DEVICE | group DEVGROUP } type TYPE [ ARGS ]\n"
@@ -88,7 +88,7 @@ void iplink_usage(void)
 		"		[ address LLADDR ]\n"
 		"		[ broadcast LLADDR ]\n"
 		"		[ mtu MTU ]\n"
-		"		[ netns { PID | NAME } ]\n"
+		"		[ netns { PID | NETNSNAME } ]\n"
 		"		[ link-netns NAME | link-netnsid ID ]\n"
 		"		[ alias NAME ]\n"
 		"		[ vf NUM [ mac LLADDR ]\n"
diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index c8c656579364..a4e0c4030363 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -465,7 +465,7 @@ specifies the desired index of the new virtual device. The link
 creation fails, if the index is busy.
 
 .TP
-.BI netns " { PID | NAME } "
+.BI netns " { PID | NETNSNAME } "
 specifies the desired network namespace to create interface in.
 
 .TP
-- 
2.39.2

