Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3080062A3DF
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 22:19:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbiKOVTt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 16:19:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbiKOVTr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 16:19:47 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A7621824
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 13:19:46 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id g12so26359984wrs.10
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 13:19:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vZD/7uHvS5J34N2GYYAfPmKEdHy2neeRIgKH7Q4ZaFo=;
        b=PJYCv+UxpU0P2K09mErm2HV6J0RWh+zwcSAdUZBcNry6+hpOlyCwSL2zk4qHh/3eCv
         nxZsax44TN0KfUiX1HNcq3t5UTdc/8FgpvCNsdx6ci9CNMQou1modM/PQ7hPxh3Tzlg3
         5ju/VdA6fWiZP0gycaJ5YysqrT+Hx2NvsdkJIK7DyJGlBi5LqZingJeYgsH3vCOaee0F
         mQ9k9DHwH4nbK9vrcA139ojzq3lWw3tV4FUFAiSDjb9UL9oYGdDtA+mJ7i+H28G1pwut
         iFAWZQzYdM7Yj55gGKystqyswarfz078yJAtgAskXJIrvt2cb9my1BJ25O3YgGKhp9e6
         r3ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vZD/7uHvS5J34N2GYYAfPmKEdHy2neeRIgKH7Q4ZaFo=;
        b=0KhBe3WEie6pG4nRN7I1oYiY6/c1SL6aauCW0uBSSIGQP7pAaQ16b7EokoyFmEqrb/
         8V4BeAe7qMcEY/5z/IWZsup45FPyGqdwPz13SBfFSbiOQB8J/qo2HjVkaKKQrtg+b5Q7
         LsbwdxOSOBGClWSD8goDM9Jthud9/wUOqWEwrBsczrzrBiGbHIZD4xsGANdCYmXHb+DN
         AIdyvXIXhBQt8GYLSF8MOpfkuECO7XpAX2TgnXWSRzXHHZO1jYr2FaDYE9Hp6uo8vpDC
         SBfaFaGZYG9RoAD438dMvfgwdM1zjdLU58IpNQ4QCZMgfbVywSZkZxncTLwabreIWZIz
         NNFg==
X-Gm-Message-State: ANoB5pkJPwuhThGMyACxtPp5f4iAEg1WZsgWgGz/A8A7NLx/pceqa4X8
        WZWoVnq2CstRYkWyEiZ24hY1Ug==
X-Google-Smtp-Source: AA0mqf4nNI8wfsKPCJV56BfDH8jzPKkB2fNgyBtM57A1yfkILgRjhBsC4hrC5cjNNfANg6YmuyIEHw==
X-Received: by 2002:a5d:4ec4:0:b0:241:6a95:6aa1 with SMTP id s4-20020a5d4ec4000000b002416a956aa1mr12044058wrv.458.1668547152711;
        Tue, 15 Nov 2022 13:19:12 -0800 (PST)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id n41-20020a05600c502900b003c65c9a36dfsm17201487wmr.48.2022.11.15.13.19.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 13:19:12 -0800 (PST)
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
Subject: [PATCH v4 0/5] net/tcp: Dynamically disable TCP-MD5 static key
Date:   Tue, 15 Nov 2022 21:19:00 +0000
Message-Id: <20221115211905.1685426-1-dima@arista.com>
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
 net/ipv4/tcp_ipv4.c        | 94 +++++++++++++++++++++++++++++---------
 net/ipv4/tcp_minisocks.c   | 61 ++++++++++++++++---------
 net/ipv4/tcp_output.c      |  4 +-
 net/ipv6/tcp_ipv6.c        | 21 ++++-----
 8 files changed, 191 insertions(+), 80 deletions(-)


base-commit: 094226ad94f471a9f19e8f8e7140a09c2625abaa
-- 
2.38.1

