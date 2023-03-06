Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD446ACFBD
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 22:04:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbjCFVD4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 16:03:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbjCFVDw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 16:03:52 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 569E047416;
        Mon,  6 Mar 2023 13:03:48 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id x7so4776524pff.7;
        Mon, 06 Mar 2023 13:03:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678136628;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MGmtZmnDs5ASNE58FlHEoRflz4j5hRXcFcWdJp13C10=;
        b=EzJCZDBXCZQBtCcs+i2Sd8VIIl3ZxMoIHVX47PVzHkX/80N6AnpWho3ip+JfnBNkcU
         DRhP9WEmyqgTb7amsutb8jjVfZKWRhNRIMWGGgmyyhv9j8c2hrsORGdruJ0fVdMJWBgb
         54pxkz2GPiUV5Nqz4U8SiiVXj4uu2mBEyUAnWR30Zr73qhKA+PGvs3PHaehLzCVwJojn
         K7uwJxuujTPDCN0YMmOI2hZ+jbdZibY7uHOme+hcHCxERz8ZbNdHj1XJisFrX+r9OfRl
         rC3DrdZJO9MyRn7lS6cz6LFV2u5iTdJLlqy2n3bEQThJca7tcLrCPHdznlHVWZJn1WsI
         9e6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678136628;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MGmtZmnDs5ASNE58FlHEoRflz4j5hRXcFcWdJp13C10=;
        b=4oVDBZZY4lIyNujx/5OjVFWIFn5uShYN6Uof1gp414DO3ZWEaSavajYljEozgzsO7O
         UfAFWwVEYFz0l26aY2kGPMw/u01HAWZuje8oK1YtBjgksD3EiXK8fjmoDIK2YYRJHaTk
         1A5wfwUHPcHhcoVBkVgkLLzIeW/haqS+OYqKyo7KByznnUrgyVFyE82pjCwzDQT6aqoM
         fQ8QK6ZJf5g5pc5n/bk2ftTQF1PlSJJpbsavrRFfL4o9WhvTvgw0Vhgiyg86y10A/kME
         +AHDr2h9TeZ5GDIx0tJxLEqQNl9UxipTMHSx+hFp8ezBHMu3Q5+GvHdqBrrInyhYX9TE
         2NAA==
X-Gm-Message-State: AO0yUKU4ziqQPU0Lti4ps5KbjTViLo7OLXiqo1QIKSSwRUzmswudHnFc
        ZnkKCqs/CU/jADO31UXyfJE=
X-Google-Smtp-Source: AK7set9SgjU99y7UTZCA7R51uGEBr/FGuhsJ2xk/AqVt+5KthhS3T7GPuQ5t/T6C74NazCaB8bgX8g==
X-Received: by 2002:a62:844c:0:b0:5db:db1c:37f9 with SMTP id k73-20020a62844c000000b005dbdb1c37f9mr13680453pfd.10.1678136627797;
        Mon, 06 Mar 2023 13:03:47 -0800 (PST)
Received: from vernon-pc.. ([49.67.2.142])
        by smtp.gmail.com with ESMTPSA id 3-20020aa79143000000b005810c4286d6sm6706760pfi.0.2023.03.06.13.03.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 13:03:47 -0800 (PST)
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
Date:   Tue,  7 Mar 2023 05:03:10 +0800
Message-Id: <20230306210312.2614988-3-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230306210312.2614988-1-vernon2gm@gmail.com>
References: <20230306210312.2614988-1-vernon2gm@gmail.com>
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

