Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5640D6E8D29
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 10:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234319AbjDTIvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 04:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234538AbjDTIuc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 04:50:32 -0400
Received: from mail-lj1-x261.google.com (mail-lj1-x261.google.com [IPv6:2a00:1450:4864:20::261])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A4934695
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 01:49:00 -0700 (PDT)
Received: by mail-lj1-x261.google.com with SMTP id 38308e7fff4ca-2a8a5f6771fso3536111fa.3
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 01:48:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google; t=1681980536; x=1684572536;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GptZ9S2v2iuA/K48gnra10lLb8nRLcNTkLUfYfYQWOM=;
        b=OeCgu81ukC74eXoJKGi6a0tSm/uJS9mU3HxvRyPak3bI/oRt+1SBU4RrINk/ZX3SbP
         toHO9NiaN+HMJ4oPQBd4rVP9erg2g66kKsYopNNeKTZicFE63yHAfDW1UyxLXPOZiH31
         5IBkLTUsVZUhw9OboIBkGqRPFMsTd6ml1KQBjyptccB0nqGENT5grY4aIUb8Y+TYDjlr
         0BWubYwMT5TUy6ckgivuzsfNh2j5bOzv353LyLVO1vhBMbrzN13GuTmu1QYxFfiW3274
         DMDDBKcVwErvFDJArINKjYgJhfs35OxPogc4vZwA02fdrxbCsZBdKoKqcCOopvPparAL
         +eWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681980536; x=1684572536;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GptZ9S2v2iuA/K48gnra10lLb8nRLcNTkLUfYfYQWOM=;
        b=dyu6ERw9sqKWVOFp3gBk7JlQdy3R46YZLPvVV75lSXX9UNr0IkxJkWocn24yz4YrLi
         pgQPdfA0YXN2DK3eCa+fQZhDIZuyqCcIjebGdnx1uSGOpQ+fmor6ErrY+JRWNLYqKyCK
         8EtRfma38cBrIjmSRpz172Z5+VQPzX11VVyiXmdazvKw+bRcS/JQ2gwT52dA4SgHGWTc
         5xWLoJrVRz4PI6Nxw7bUJ1ut7RA4yhJfd+LaBXpqO33w0TFAh9cBDPXyMroEbGkPTaDX
         2v6pFXvyIT+yC9eLfCW8VNtB0edjHLC3oOcqAfwItBLxhmB8j3Nr+97GpDBYHVclQdU6
         xwsw==
X-Gm-Message-State: AAQBX9fijpqQu/TmS2fHLzFmxqSv7UY5L/FNTIJpmlQDpVkDIcp+NO5Z
        xXNnFskb3zMHapgfdG60QogNlWDz6nThxiZA3ufRAUpemYur7g==
X-Google-Smtp-Source: AKy350ZDV9v7nYkfRvrxklfsEkH+GhXGhuDkTJUYcFDVIQY9sQM/sgraH4OHjGWCpgnbcatZjcq5ChI/Fz+Y
X-Received: by 2002:ac2:5e84:0:b0:4e8:43e2:a8 with SMTP id b4-20020ac25e84000000b004e843e200a8mr277833lfq.8.1681980535572;
        Thu, 20 Apr 2023 01:48:55 -0700 (PDT)
Received: from smtpservice.6wind.com ([185.13.181.2])
        by smtp-relay.gmail.com with ESMTP id w16-20020a05651204d000b004eb093a41f4sm162904lfq.104.2023.04.20.01.48.55;
        Thu, 20 Apr 2023 01:48:55 -0700 (PDT)
X-Relaying-Domain: 6wind.com
Received: from bretzel (bretzel.dev.6wind.com [10.17.1.57])
        by smtpservice.6wind.com (Postfix) with ESMTPS id 0F743601D3;
        Thu, 20 Apr 2023 10:48:55 +0200 (CEST)
Received: from dichtel by bretzel with local (Exim 4.92)
        (envelope-from <dichtel@6wind.com>)
        id 1ppPyI-0005bk-Uu; Thu, 20 Apr 2023 10:48:54 +0200
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        Simon Horman <simon.horman@corigine.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH iproute2 v2 1/2] iplink: use the same token NETNSNAME everywhere
Date:   Thu, 20 Apr 2023 10:48:48 +0200
Message-Id: <20230420084849.21506-2-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230420084849.21506-1-nicolas.dichtel@6wind.com>
References: <20230420084849.21506-1-nicolas.dichtel@6wind.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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

