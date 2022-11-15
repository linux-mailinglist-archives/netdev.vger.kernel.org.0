Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A263629DC4
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 16:39:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230466AbiKOPj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 10:39:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237952AbiKOPj5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 10:39:57 -0500
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B8782935C;
        Tue, 15 Nov 2022 07:39:56 -0800 (PST)
Received: by mail-qv1-xf2c.google.com with SMTP id h10so10011587qvq.7;
        Tue, 15 Nov 2022 07:39:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MCjIA/eqXVicTJQ5RMAw6w0bmXnp4jF1cWjPhai0R80=;
        b=h77cd59Hu3xMyqWruO1ZGLlcF/I1eUZnHtPZPkVN/roUnelGYgFVP2hhf6+ag/1sCp
         a6yka66/CtvtJu/NZqQKwqlPBD86xakq3yEEiSB8aVSTviIOyW+8ICD4O16EjHk8I02a
         pcewn4nBX8ZA8xyoMrLGxOZBV+6GyRUIC7RNOJ3VffCZdCX/j+76ePw12vASrRhjX3He
         2IZJqC3tf4XPi9fYFDSn7rJLJbvQHwuSAPtSzH/T3aVvEueRXnTnrUTrQe4gR1HyNI7H
         TGnUqem/h7XgVLeokc7weEYP82wakEHqsxH/n0JTQTOZWj+Ori8I1RLXGuRIpKgwkjhU
         3G9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MCjIA/eqXVicTJQ5RMAw6w0bmXnp4jF1cWjPhai0R80=;
        b=hizEZJLPQU+3+lO7hIiYuX3B9Ly97eonjxb8D67hACc67shtdq14a7FjH0va90DaTE
         RHpOEuhTMYj0+fZXi02tgJhftgJmGKOEKdt22TW3xtZTcvp9lC7XgmsjtegYJoSdQB0u
         APrRA+Mn5MnUaBC1etH+FzAqpRpD0zlXWKHehpOPTs2+AJ4kyzsIVWjl/byIV9pfG+FN
         IPSq03g7UkjllsYlHEO/4rdV27/BXsSPTRaqXBdVk1PXMPmWx0VaX5J5fnt0K9NWEZYZ
         zTg2V267IG6zRmd4yCNiEtYoljPdleWkPdvc2lafLySbN87ehR4aqF00JD4pjmgveQaf
         xZ0g==
X-Gm-Message-State: ANoB5pmTSNlEEP4CNiZh2cFwh8qqeyBCOlJmzxBaLGLYbWWE5REENRa6
        JGmfRF+kn2BHPlIuHj9oNuR4JVBrXGg=
X-Google-Smtp-Source: AA0mqf7M1dMRjnbrUMestf/zGVRIPlhZqg4fQ2AP7QhCuvh+POwiNRCTEi2aZBDiJkhJju9t6c37ZQ==
X-Received: by 2002:ad4:51c2:0:b0:4bb:781e:6232 with SMTP id p2-20020ad451c2000000b004bb781e6232mr16786390qvq.15.1668526795376;
        Tue, 15 Nov 2022 07:39:55 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id az36-20020a05620a172400b006ec771d8f89sm8229991qkb.112.2022.11.15.07.39.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 07:39:55 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCH net-next] sctp: change to include linux/sctp.h in net/sctp/checksum.h
Date:   Tue, 15 Nov 2022 10:39:53 -0500
Message-Id: <ca7ea96d62a26732f0491153c3979dc1c0d8d34a.1668526793.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
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

Currently "net/sctp/checksum.h" including "net/sctp/sctp.h" is
included in quite some places in netfilter and openswitch and
net/sched. It's not necessary to include "net/sctp/sctp.h" if
a module does not have dependence on SCTP, "linux/sctp.h" is
the right one to include.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/checksum.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/sctp/checksum.h b/include/net/sctp/checksum.h
index 5a9bb09f32b6..f514a0aa849e 100644
--- a/include/net/sctp/checksum.h
+++ b/include/net/sctp/checksum.h
@@ -24,7 +24,7 @@
 #define __sctp_checksum_h__
 
 #include <linux/types.h>
-#include <net/sctp/sctp.h>
+#include <linux/sctp.h>
 #include <linux/crc32c.h>
 #include <linux/crc32.h>
 
-- 
2.31.1

