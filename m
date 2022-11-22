Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C41A163440B
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 19:55:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234558AbiKVSzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 13:55:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230365AbiKVSzo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 13:55:44 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ACEC7EBD5
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 10:55:43 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id h126-20020a1c2184000000b003d03017c6efso184681wmh.4
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 10:55:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zTBORMVN8Ms/JVLz5RLeY+CtQ5QsJjxcwcBxY+FPoWs=;
        b=aVVvjmTfNNSKHAt9Gh1wtxRPrigAIiPMVVI1C0x+Cdm8rVZxq/jVw7PBENK0t28HdY
         OCI99YZuRU1N1l1o3wkcdIepfKqAdnTUTPrGR9T486NxtUEW2IUQIB0U8oNv1XvXJMjg
         Bld/9Cv3l0kPVtvuYFAYEOLOD53wR/O2ZdSOEUQYNzFwMGsEa0Q2XLw66DUD+bIUO2WL
         TREsecDqOVP28OMBaVgEzmZcbBM5f5c1NEY9qL1idxrvibDciHg/AZ96fmWmh5ggPkXV
         PFIH41L1u8V3+9Oi8KgftVHTSKX+JOmCHUHuTswHNCHHj/AUWnfd6n8uSvJVHYf42SLr
         psXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zTBORMVN8Ms/JVLz5RLeY+CtQ5QsJjxcwcBxY+FPoWs=;
        b=s/+S6eGhIzobIHZpAyr+zYsYqIf3jaFP66aHOrnNhHGDOtwVJgNFGdmFYpdaHe7Wh4
         hwX1SUO5T2H3IO49V8FIoeMMZsVuPiLHrP6AXn1XxRh//WsIwVhPpyJ02kyONfeov+ul
         HToo82ri21yqeXK8Xev3J85I20lc6YJDgGI8VbFR6cvnUdzKdpl8FOlER/g6MAZcSnuc
         c95mwVP1KG4n562CMYI7bAQrrZRwuOgAEKHhMODDZ7RuDzljRDcja8zS1Z9H0M9smVrH
         yPjcO3w62u7lShp/sLGe/FUpz7mgaz8qO5N600LhoM4o3ds18TSi+E0BkuZgz43Cp/bQ
         lpXQ==
X-Gm-Message-State: ANoB5pkBQvxrHsXuxlBKeZHUNb4Q0ZtCK00IoW2ehIm4NfCHJVyGj0XR
        VGO5ILEmoX60NPdsmcuNv8HbwQ==
X-Google-Smtp-Source: AA0mqf51tkhibKpHpotYNnqlP2n+AgRH6cj49wU13TjAHwh0RVf/WcC5W+8y6SIpSfkEUYedc95pQw==
X-Received: by 2002:a1c:4b0f:0:b0:3cf:735c:9d5a with SMTP id y15-20020a1c4b0f000000b003cf735c9d5amr10880872wma.113.1669143341798;
        Tue, 22 Nov 2022 10:55:41 -0800 (PST)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id c18-20020adffb12000000b002365730eae8sm14478044wrr.55.2022.11.22.10.55.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 10:55:41 -0800 (PST)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Dmitry Safonov <dima@arista.com>, Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Baron <jbaron@akamai.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        Steven Rostedt <rostedt@goodmis.org>, netdev@vger.kernel.org
Subject: [PATCH v5 0/5] net/tcp: Dynamically disable TCP-MD5 static key
Date:   Tue, 22 Nov 2022 18:55:29 +0000
Message-Id: <20221122185534.308643-1-dima@arista.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes from v4:
- Used rcu_dereference_protected() for tp->md5sig_info in
  tcp_md5_do_add() and tcp_md5_key_copy() fail paths to make sure
  there won't be false-positives from sparse (Jakub)
- Added Acked-by: Jakub Kicinski

Changes from v3:
- Used atomic_try_cmpxchg() as suggested by Peter Zijlstra
- Renamed static_key_fast_inc() => static_key_fast_inc_not_negative()
  (addressing Peter Zijlstra's review)
- Based on linux-tip/master
- tcp_md5_key_copy() now does net_warn_ratelimited()
  (addressing Peter Zijlstra's review)
  tcp_md5_do_add() does not as it returns -EUSERS from setsockopt()
  syscall back to the userspace
- Corrected WARN_ON_ONCE(!static_key_fast_inc(key))
  (Spotted by Jason Baron)
- Moved declaration of static_key_fast_inc_not_negative() and its
  EXPORT_SYMBOL_GPL() to the patch 3 that uses it,
  "net/tcp: Disable TCP-MD5 static key on tcp_md5sig_info destruction"
  (addressing Peter Zijlstra's review)
- Added patch 4 that destroys the newly created request socket
  if md5 info allocation or static_key increment was unsuccessful.
  Instead of proceeding to add a socket without TCP-MD5 keys.
- Added patch 5 that separates helper tcp_time_wait_init()
  and converts BUG_ON() to WARN_ON_ONCE().

Changes from v2:
- Prevent key->enabled from turning negative by overflow from
  static_key_slow_inc() or static_key_fast_inc()
  (addressing Peter Zijlstra's review)
- Added checks if static_branch_inc() and static_key_fast_int()
  were successful to TCP-MD5 code.

Changes from v1:
- Add static_key_fast_inc() helper rather than open-coded atomic_inc()
  (as suggested by Eric Dumazet)

Version 4:
https://lore.kernel.org/all/20221115211905.1685426-1-dima@arista.com/T/#u
Version 3:
https://lore.kernel.org/all/20221111212320.1386566-1-dima@arista.com/T/#u
Version 2: 
https://lore.kernel.org/all/20221103212524.865762-1-dima@arista.com/T/#u
Version 1: 
https://lore.kernel.org/all/20221102211350.625011-1-dima@arista.com/T/#u

The static key introduced by commit 6015c71e656b ("tcp: md5: add
tcp_md5_needed jump label") is a fast-path optimization aimed at
avoiding a cache line miss.
Once an MD5 key is introduced in the system the static key is enabled
and never disabled. Address this by disabling the static key when
the last tcp_md5sig_info in system is destroyed.

Previously it was submitted as a part of TCP-AO patches set [1].
Now in attempt to split 36 patches submission, I send this independently.

Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Bob Gilligan <gilligan@arista.com>
Cc: David Ahern <dsahern@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Francesco Ruggeri <fruggeri@arista.com>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Jason Baron <jbaron@akamai.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Salam Noureddine <noureddine@arista.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

[1]: https://lore.kernel.org/all/20221027204347.529913-1-dima@arista.com/T/#u

Thanks,
            Dmitry

Dmitry Safonov (5):
  jump_label: Prevent key->enabled int overflow
  net/tcp: Separate tcp_md5sig_info allocation into
    tcp_md5sig_info_add()
  net/tcp: Disable TCP-MD5 static key on tcp_md5sig_info destruction
  net/tcp: Do cleanup on tcp_md5_key_copy() failure
  net/tcp: Separate initialization of twsk

 include/linux/jump_label.h | 21 +++++++--
 include/net/tcp.h          | 10 ++--
 kernel/jump_label.c        | 55 +++++++++++++++++-----
 net/ipv4/tcp.c             |  5 +-
 net/ipv4/tcp_ipv4.c        | 96 +++++++++++++++++++++++++++++---------
 net/ipv4/tcp_minisocks.c   | 61 +++++++++++++++---------
 net/ipv4/tcp_output.c      |  4 +-
 net/ipv6/tcp_ipv6.c        | 21 ++++-----
 8 files changed, 193 insertions(+), 80 deletions(-)


base-commit: 771a207d1ee9f38da8c0cee1412228f18b900bac
-- 
2.38.1

