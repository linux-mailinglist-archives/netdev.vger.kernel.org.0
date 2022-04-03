Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9364F4F0995
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 15:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358390AbiDCNKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 09:10:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235242AbiDCNKH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 09:10:07 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4405C26AF9
        for <netdev@vger.kernel.org>; Sun,  3 Apr 2022 06:08:11 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id u16so10665458wru.4
        for <netdev@vger.kernel.org>; Sun, 03 Apr 2022 06:08:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cAK1/MSWSGczGHHWEH3+cUcNGPK20afkIyYiOcdrh2w=;
        b=qd0KbAKjVCMuQfD2BTVsg5u7DXPWYQZk/gC34v4CVIaQpbYe5jsBkhQq5hRNn2/1MX
         JzNF6fQsE0l7PlNbGWB2P2jcUlh3i8epjCxrF7fVeClrBzLg3jmnelPhTRPdq/ZTfhBY
         AXgyq0N72tyt2LT1MQK9fgz/IRZ+k+BkWf7FoZuxgoQU3bugez5BTOBt7r1kvYhvmA2T
         nxyfamET9QdWfw0Lt6os81EQrtpV3FqaQUsk+sgcSYQ0E9u09figi+4B5tcD+cQeaN9c
         wYvVh4bfBhNq7j4L2L55gFSQjIAfi02SihJ4xK48fMcwj7NBmn7xwKDzAQv96bErZcpG
         /ooQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cAK1/MSWSGczGHHWEH3+cUcNGPK20afkIyYiOcdrh2w=;
        b=tMKKneXrs/OGu5aU3TLo99XbuBd+o7QLhXsy7PmtqQIT0Bprf617CEzi9MSUrR3NBL
         mTgu9nAd5QVw1fB05UJ3qqX1zP7B0dlDfnsqyJqBAh4QvfbO1r+9uZrm7aq2Zb/qsDEP
         XcHdtW9E+BFVRdjmJgzV3Fmu6ncR/oJprbWtnqw7PPT+/xSOrIRLtndxyGg6LsGqacvi
         7mvPiU9gZdQtgUM6qyvWC/bTQJIp2RZDIeT0mYjRek0qFOHNLv1CGIg0lvJkBYbOKbUw
         akqtUTn63NED8tyFZBvlmoczIYVXysYpdDXkRxoZHrlUQWOUD7QBknOIrs0a4O0P4L5p
         yEzA==
X-Gm-Message-State: AOAM533AwtolGC8ggGqlw6w/qvdIYpZ1zfIa8AvqW+fgRk4iEeElcdWF
        p1jwyEpy0uuWNwvCzJK0BGQjupHiq3w=
X-Google-Smtp-Source: ABdhPJzcETgdXmW2Kv+jM5cDRaJ0XHMXuODU2M4glhqCXtVhvoa8+ROOsh4nVARBnbHLV6F/k4HXPg==
X-Received: by 2002:adf:ebc7:0:b0:1ee:945a:ffb4 with SMTP id v7-20020adfebc7000000b001ee945affb4mr14133145wrn.641.1648991289555;
        Sun, 03 Apr 2022 06:08:09 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-233-133.dab.02.net. [82.132.233.133])
        by smtp.gmail.com with ESMTPSA id c12-20020a05600c0a4c00b00381141f4967sm7866995wmq.35.2022.04.03.06.08.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Apr 2022 06:08:09 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC net-next 00/27] net and/or udp optimisations
Date:   Sun,  3 Apr 2022 14:06:12 +0100
Message-Id: <cover.1648981570.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A mix of various net optimisations, which were mostly discovered during UDP
testing. Benchmarked with an io_uring test using 16B UDP/IPv6 over dummy netdev:
2090K vs 2229K tx/s, +6.6%, or in a 4-8% range if not averaging across reboots.

1-3 removes extra atomics and barriers from sock_wfree() mainly benefitting UDP.
4-7 cleans up some zerocopy helpers
8-16 do inlining of ipv6 and generic net pathes
17 is a small nice performance improvement for TCP zerocopy
18-27 refactors UDP to shed some more overhead

Pavel Begunkov (27):
  sock: deduplicate ->sk_wmem_alloc check
  sock: optimise sock_def_write_space send refcounting
  sock: optimise sock_def_write_space barriers
  skbuff: drop zero check from skb_zcopy_set
  skbuff: drop null check from skb_zcopy
  net: xen: set zc flags only when there is ubuf
  skbuff: introduce skb_is_zcopy()
  skbuff: optimise alloc_skb_with_frags()
  net: inline sock_alloc_send_skb
  net: inline part of skb_csum_hwoffload_help
  net: inline skb_zerocopy_iter_dgram
  ipv6: inline ip6_local_out()
  ipv6: help __ip6_finish_output() inlining
  ipv6: refactor ip6_finish_output2()
  net: inline dev_queue_xmit()
  ipv6: partially inline fl6_update_dst()
  tcp: optimise skb_zerocopy_iter_stream()
  net: optimise ipcm6 cookie init
  udp/ipv6: refactor udpv6_sendmsg udplite checks
  udp/ipv6: move pending section of udpv6_sendmsg
  udp/ipv6: prioritise the ip6 path over ip4 checks
  udp/ipv6: optimise udpv6_sendmsg() daddr checks
  udp/ipv6: optimise out daddr reassignment
  udp/ipv6: clean up udpv6_sendmsg's saddr init
  ipv6: refactor opts push in __ip6_make_skb()
  ipv6: improve opt-less __ip6_make_skb()
  ipv6: clean up ip6_setup_cork

 drivers/net/xen-netback/interface.c |   3 +-
 include/linux/netdevice.h           |  27 ++++-
 include/linux/skbuff.h              | 102 +++++++++++++-----
 include/net/ipv6.h                  |  37 ++++---
 include/net/sock.h                  |  10 +-
 net/core/datagram.c                 |   2 -
 net/core/datagram.h                 |  15 ---
 net/core/dev.c                      |  28 ++---
 net/core/skbuff.c                   |  59 ++++-------
 net/core/sock.c                     |  50 +++++++--
 net/ipv4/ip_output.c                |  10 +-
 net/ipv4/tcp.c                      |   5 +-
 net/ipv6/datagram.c                 |   4 +-
 net/ipv6/exthdrs.c                  |  15 ++-
 net/ipv6/ip6_output.c               |  88 ++++++++--------
 net/ipv6/output_core.c              |  12 ---
 net/ipv6/raw.c                      |   8 +-
 net/ipv6/udp.c                      | 158 +++++++++++++---------------
 net/l2tp/l2tp_ip6.c                 |   8 +-
 19 files changed, 339 insertions(+), 302 deletions(-)
 delete mode 100644 net/core/datagram.h

-- 
2.35.1

