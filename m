Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A533C6ACF71
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 21:48:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbjCFUsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 15:48:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbjCFUsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 15:48:10 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31A0672B3B;
        Mon,  6 Mar 2023 12:47:57 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id u5so11848138plq.7;
        Mon, 06 Mar 2023 12:47:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678135676;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MGmtZmnDs5ASNE58FlHEoRflz4j5hRXcFcWdJp13C10=;
        b=qYRs34Gk9hUvTs5ooXKPKoymdDDp1qyJBx1E+sIY2JvW1s22DJk2X7y1vFmfMeNrya
         jjiZs95ll3Deo94LJL0MIxxSzm3AWRXtvMwqww3eAIRMZv1we4kFFe5CoNGogyjud4lu
         pXxem8c/aN7PvEOkXxjWSMGHwMbKX563gMIWEEC8S196B2+ltQLn/Qz0WDJ+GiwYyu4/
         v7TN1sQjBcS/3bHO/fl8LNr5VGX4MBH5kONmDgLJUmrWf5YzB0akr/Oq91jAVYUCyxPi
         Lo/fnlVTqlRZPMUY2RyW7pa2rGqTEbKBIuL4RiQYRZ9a6C+RYptbZSpYXQaxMI9QmYTH
         ru9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678135676;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MGmtZmnDs5ASNE58FlHEoRflz4j5hRXcFcWdJp13C10=;
        b=7v+DGIXDLuUQ7NhQBJWM8rUyQ1nX+4MHDPgHAieFzgqidJAZwGf9qnJCOVGVVDUAzN
         Ds54AIO13UjO6cTD2dAO3A+u95F5tSw5byIa2EbGYLXvroOqtF3yHb3fYttafvo3dmwO
         qA9caNdbPPrOK/Jr7UtHWpYYhky/voUTDBfebr7pnwtjAgiH1C28nIfJ3KOLfUGrgXAw
         RSHK7ZuH6ncw0GH/aYEFc5naSFuSrEHQWE2rUYFr6X2DzcygHhCoElU6MJNVompGlpoZ
         5tiriI/vCSJ5Yw6HDCod9Q0nzpXf5nIPBa0mVtyvT+b/v6xKDLATZVcMpk0PTLOOfGea
         OVBA==
X-Gm-Message-State: AO0yUKWIYDY7j4iR3NjmlBMsRPOlXkpQBqP1JbaDSppSvSI7u21E3mNi
        vkHnCcUNjuimckN0JMZtpB0=
X-Google-Smtp-Source: AK7set/FIMLWtnvm1jz8Ak/Nanv3uUTjVLkFSHhdcorkKHDqQ6eoh1Z+NIyFSpqTUVyNVTkxCTNMkA==
X-Received: by 2002:a05:6a20:1e61:b0:cb:a0e3:4598 with SMTP id cy33-20020a056a201e6100b000cba0e34598mr11460370pzb.43.1678135676488;
        Mon, 06 Mar 2023 12:47:56 -0800 (PST)
Received: from vernon-pc.. ([49.67.2.142])
        by smtp.gmail.com with ESMTPSA id e23-20020aa78c57000000b005a75d85c0c7sm6699772pfd.51.2023.03.06.12.47.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 12:47:56 -0800 (PST)
From:   Vernon Yang <vernon2gm@gmail.com>
To:     torvalds@linux-foundation.org, tytso@mit.edu, Jason@zx2c4.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
        yury.norov@gmail.com, andriy.shevchenko@linux.intel.com,
        linux@rasmusvillemoes.dk, james.smart@broadcom.com,
        dick.kennedy@broadcom.com
Cc:     linux-kernel@vger.kernel.org, wireguard@lists.zx2c4.com,
        netdev@vger.kernel.org, linux-scsi@vger.kernel.org,
        Vernon Yang <vernon2gm@gmail.com>
Subject: [PATCH v2 2/4] wireguard: fix wg_cpumask_choose_online() if no further cpus set
Date:   Tue,  7 Mar 2023 04:47:21 +0800
Message-Id: <20230306204723.2584724-3-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230306204723.2584724-1-vernon2gm@gmail.com>
References: <20230306204723.2584724-1-vernon2gm@gmail.com>
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

When cpumask_next() the return value is greater than or equal to
nr_cpu_ids, it indicates invalid.

Before commit 596ff4a09b89 ("cpumask: re-introduce constant-sized cpumask
optimizations"), when cpumask_next() returned an invalid cpu, the driver
used the judgment equal to nr_cpu_ids to indicate the invalid cpu, so it
happened to work normally, but this is the wrong approach.

After commit 596ff4a09b89 ("cpumask: re-introduce constant-sized cpumask
optimizations"), these incorrect practices actively buggy, so fix it to
correctly.

Signed-off-by: Vernon Yang <vernon2gm@gmail.com>
---
 drivers/net/wireguard/queueing.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireguard/queueing.h b/drivers/net/wireguard/queueing.h
index 583adb37ee1e..125284b346a7 100644
--- a/drivers/net/wireguard/queueing.h
+++ b/drivers/net/wireguard/queueing.h
@@ -106,7 +106,7 @@ static inline int wg_cpumask_choose_online(int *stored_cpu, unsigned int id)
 {
 	unsigned int cpu = *stored_cpu, cpu_index, i;
 
-	if (unlikely(cpu == nr_cpumask_bits ||
+	if (unlikely(cpu >= nr_cpu_ids ||
 		     !cpumask_test_cpu(cpu, cpu_online_mask))) {
 		cpu_index = id % cpumask_weight(cpu_online_mask);
 		cpu = cpumask_first(cpu_online_mask);
-- 
2.34.1

