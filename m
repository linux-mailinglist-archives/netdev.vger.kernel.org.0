Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90D576AAA62
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 15:24:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbjCDOYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Mar 2023 09:24:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCDOX7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Mar 2023 09:23:59 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4C5F1A4AE;
        Sat,  4 Mar 2023 06:23:58 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id u3-20020a17090a450300b00239db6d7d47so4911424pjg.4;
        Sat, 04 Mar 2023 06:23:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677939838;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=E40eLy+/e4WccoyCmK8MHA6xOEkEoM/JFQrkvVd5+lc=;
        b=C69qxzcM4ocpfcTdB9d7K2pPOg8tam57WmyhAaqc11l9Scmqe5K/uWhMvq/zsyLL6z
         1FwTReikWwE3+vM4MKtv2k7oQED872sixJOS2KXEwyjAAE2U1sKbOwJ06GtZxvhDMxrb
         AVRvG1CsldUctSwLaBnmBQkUl2ujo8CgS0hOrDDVOBShhi52dEwxtLRG4V3Wg0qa/IHh
         6UnMcKCgbAikEDE4eR25b0EUC3mMsTTC60FM1fHRbaaGbqbK3E/wBSKdtvHHndQS47r8
         LU78Jy5xMIwrLGXz6nk98SvE6a/Ao7NviGyQ+1HFL1y3QT3VeXrzPjjHRS6LdFh/IXDM
         nkCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677939838;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E40eLy+/e4WccoyCmK8MHA6xOEkEoM/JFQrkvVd5+lc=;
        b=ULIjqMFcUYAnaXbAeTYRQFgfXigvXwSX44vrPI6kP3EyRl5Wjqe4KnAtTusyjzPm54
         7wbcvPrhUhewMlP6tkac5be7LzY11swcfWVwB8RhA/TDM8ZjkouABlhFMahig/OD0OVS
         hSkKswoQryuXNnYuwdJ4IGoHEfMf/1sXhoAkjOoDBLy5OCNWCFWRczyYiKbKBwkBCFd5
         qqyJ+BZvcO62hbXjpkcyFY9Zslnbx/kyWW1GN4LcNfQUePQIYJDd1FjnoNQp8jc95+54
         nL5jnoHzQwIsmkv9WApA5AI+8NvTK8AaC2D2nQ+4Q6s2hcg7Litr0mFAHzTFd2B0m39o
         s9hw==
X-Gm-Message-State: AO0yUKWHz8VUg6ow+6E+4WkZ1nQs/MK+9N18xrpsD69FCeEYZ7cFCJ12
        aGsZs+0PBQXL91HRr3julao=
X-Google-Smtp-Source: AK7set8T/YxAc9SFEUfkXxNSRdG+eOe+UhcryHT3kFHCDvAilrsViarerJRhKev8BPE9PVSwkdRbXw==
X-Received: by 2002:a17:90b:190f:b0:230:a082:b085 with SMTP id mp15-20020a17090b190f00b00230a082b085mr4200433pjb.0.1677939838314;
        Sat, 04 Mar 2023 06:23:58 -0800 (PST)
Received: from ubuntu.localdomain ([112.10.230.37])
        by smtp.gmail.com with ESMTPSA id bt9-20020a17090af00900b00230dc295651sm3236502pjb.8.2023.03.04.06.23.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Mar 2023 06:23:57 -0800 (PST)
From:   Min Li <lm0963hack@gmail.com>
To:     luiz.dentz@gmail.com
Cc:     marcel@holtmann.org, johan.hedberg@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        jkosina@suse.cz, hdegoede@redhat.com, david.rheinsberg@gmail.com,
        wsa+renesas@sang-engineering.com, linux@weissschuh.net,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/1] Bluetooth: fix race condition in hidp_session_thread
Date:   Sat,  4 Mar 2023 22:23:30 +0800
Message-Id: <20230304142330.7367-1-lm0963hack@gmail.com>
X-Mailer: git-send-email 2.25.1
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

There is a potential race condition in hidp_session_thread that may
lead to use-after-free. For instance, the timer is active while
hidp_del_timer is called in hidp_session_thread(). After hidp_session_put,
then 'session' will be freed, causing kernel panic when hidp_idle_timeout
is running.

The solution is to use del_timer_sync instead of del_timer.

Here is the call trace:

? hidp_session_probe+0x780/0x780
call_timer_fn+0x2d/0x1e0
__run_timers.part.0+0x569/0x940
hidp_session_probe+0x780/0x780
call_timer_fn+0x1e0/0x1e0
ktime_get+0x5c/0xf0
lapic_next_deadline+0x2c/0x40
clockevents_program_event+0x205/0x320
run_timer_softirq+0xa9/0x1b0
__do_softirq+0x1b9/0x641
__irq_exit_rcu+0xdc/0x190
irq_exit_rcu+0xe/0x20
sysvec_apic_timer_interrupt+0xa1/0xc0

v2:
  - Fixed code style issues

Signed-off-by: Min Li <lm0963hack@gmail.com>
---
 net/bluetooth/hidp/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/hidp/core.c b/net/bluetooth/hidp/core.c
index bed1a7b9205c..707f229f896a 100644
--- a/net/bluetooth/hidp/core.c
+++ b/net/bluetooth/hidp/core.c
@@ -433,7 +433,7 @@ static void hidp_set_timer(struct hidp_session *session)
 static void hidp_del_timer(struct hidp_session *session)
 {
 	if (session->idle_to > 0)
-		del_timer(&session->timer);
+		del_timer_sync(&session->timer);
 }
 
 static void hidp_process_report(struct hidp_session *session, int type,
-- 
2.25.1

