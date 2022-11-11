Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B14E662637C
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 22:23:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234167AbiKKVXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 16:23:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233179AbiKKVXb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 16:23:31 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65FCE10B4
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 13:23:29 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id fn7-20020a05600c688700b003b4fb113b86so3891715wmb.0
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 13:23:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=e6Yy5Fgy/fFmhzxwj4kvbwK22iDhlH9BwFdgcuKAt24=;
        b=GgQ5yN9aR8bX0LQ2edh3M9RyxBVAN14ksPobL1d8ceSVeMzg9lk9b3JwD8Sr8JHvyJ
         Xr3atLcMIEgpZQks1apFIux82kUROpnfmDouKkSefqlyVxeOictcNzZtrVDy5T6whoVR
         6M2RHL/jW5U+GLOUrbWSm/Y8qskVBU7gneSh4dt7fE2cEII5rIUpg2aw7+6Tw9nx6vNP
         tgvyFGmsRp/b9NtTIPLUecSdzA/3hGUKuklMotY+toz+DhJIn6vtxZro0DsHuvyQTgxF
         lzCTCNA2So4ma/l0tj7PGdkzCqU3fJ6u7UYL0fBNwt+D9xpkc5sdLbcHG+j/VeViWlG/
         8Tyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e6Yy5Fgy/fFmhzxwj4kvbwK22iDhlH9BwFdgcuKAt24=;
        b=k3GTctvK3n31HRDnQv0YZbkRKFu9owBQf9FO2EEIlj5Q396EI4A8i2klGkWDieH9c+
         kLvzFx33/s8LdenE3F6clV7PIqELaWFrWVGKXOJw8roxzkVx9vAkN5oZiQvNf0uYihDV
         JcIuKrGyjXPTzIYpisrj0/BmlAxEYF6MI2siqkSYDXe0Ponr6LgyDKrga0RDYGsSdbK4
         JyGYdMxzdP3KEFaSN2xvaAFwiV2qcAlHoXa1qLdEVFawzM5vTF61kmEh8ILNbqKYd5Mk
         Ff+T78OlCww2+C9hkRX6rRNfWXX0Rtelnr0PEWAzkhz29uPwyXsLdDk+SDVKVtUtPkn3
         ApHQ==
X-Gm-Message-State: ANoB5pn63eQ0iLXwGlPR9RcJd4mDBeZbR9CCQc6p9fvJYdL+I81vuVD5
        jAmS+O5MIIJ/vjo+zOd4ZfUpRw==
X-Google-Smtp-Source: AA0mqf4u6VQV9Wt/vxFDck/AQs2RvFYT0qfgexN8yWfOheGg3mv+eFPv+/V8WFcrAh3xrxjjwDlG4Q==
X-Received: by 2002:a7b:c5d3:0:b0:3cf:4eeb:927b with SMTP id n19-20020a7bc5d3000000b003cf4eeb927bmr2472521wmk.74.1668201807910;
        Fri, 11 Nov 2022 13:23:27 -0800 (PST)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id n18-20020a7bcbd2000000b003cf9bf5208esm9423281wmi.19.2022.11.11.13.23.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Nov 2022 13:23:27 -0800 (PST)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     Dmitry Safonov <dima@arista.com>,
        Bob Gilligan <gilligan@arista.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org
Subject: [PATCH v3 0/3] net/tcp: Dynamically disable TCP-MD5 static key
Date:   Fri, 11 Nov 2022 21:23:17 +0000
Message-Id: <20221111212320.1386566-1-dima@arista.com>
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

Changes from v2:
- Prevent key->enabled from turning negative by overflow from
  static_key_slow_inc() or static_key_fast_inc()
  (addressing Peter Zijlstra's review)
- Added checks if static_branch_inc() and static_key_fast_int()
  were successful to TCP-MD5 code.

Changes from v1:
- Add static_key_fast_inc() helper rather than open-coded atomic_inc()
  (as suggested by Eric Dumazet)

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

Cc: Bob Gilligan <gilligan@arista.com>
Cc: David Ahern <dsahern@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Francesco Ruggeri <fruggeri@arista.com>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Salam Noureddine <noureddine@arista.com>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

[1]: https://lore.kernel.org/all/20221027204347.529913-1-dima@arista.com/T/#u

Thanks,
            Dmitry

Dmitry Safonov (3):
  jump_label: Prevent key->enabled int overflow
  net/tcp: Separate tcp_md5sig_info allocation into
    tcp_md5sig_info_add()
  net/tcp: Disable TCP-MD5 static key on tcp_md5sig_info destruction

 include/linux/jump_label.h | 21 ++++++++--
 include/net/tcp.h          | 10 +++--
 kernel/jump_label.c        | 54 +++++++++++++++++-------
 net/ipv4/tcp.c             |  5 +--
 net/ipv4/tcp_ipv4.c        | 86 +++++++++++++++++++++++++++++++-------
 net/ipv4/tcp_minisocks.c   | 12 ++++--
 net/ipv4/tcp_output.c      |  4 +-
 net/ipv6/tcp_ipv6.c        | 10 ++---
 8 files changed, 150 insertions(+), 52 deletions(-)


base-commit: 4bbf3422df78029f03161640dcb1e9d1ed64d1ea
-- 
2.38.1

