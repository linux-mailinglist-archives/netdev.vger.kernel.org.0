Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A239B63D7A7
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 15:07:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbiK3OHm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 09:07:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbiK3OHX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 09:07:23 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EF188BD02
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 06:06:56 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id ha10so41655643ejb.3
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 06:06:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rt1ilKFDzEzlhdKfYbR+znkHTtNyBE/kTERl0l5cx8w=;
        b=XGgNGGxtOChAIQsnl1Rw6eAqP+KQCn5XAKjAhxawLhkHMNZRCws2UYSArJhydm3uAO
         KT5dcraiYYrJavkOmIw3396ajGj1HsM6sA3eM9u1GZXDiFZ9oYIvlyW9KYGTH6D1Nqdl
         fLAHntstcW3ONz0ZqIBI7ssM8K+Z+5peQEg1SvAEj0F+OWCoAsb8rTyPGA5wrZ5iZNpp
         cD9T5CEUwUfcVd0W612EAQPva43vpQOTnrATCiBrruJGtuVgQLgU5w5I+2Ci93qRq/1U
         rLuEM6lSG5SrBusRnRc4B1Wxmr9bRMTsc7WoFxpJ42SKM8mH2ta1VsZ42y6z4ZfMGn24
         M8Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rt1ilKFDzEzlhdKfYbR+znkHTtNyBE/kTERl0l5cx8w=;
        b=XRVOX7fWz84eKDsWU6ib1DzzM2pH7/kTwS8LbKINBW1jeDqtzblQqDl8WQ/3KlkhKx
         V7EZ+d/ETgMK00+JOzJHtl+OhnIRpvFEFFTXDL6641So8LxeaPxI6iqS1Fd+mg+6QFVT
         QhZT4vnFuysyccvlILEI8TJIZd0aUJCBmQyYNsUxd3MYXsNTi08pO7e0oK9/+4H0aXgA
         eg0QUyQWs5DkjOMZWKfewxPLfvMHnivvW2ct4CUILfV78IYv/JbC17fWB47u55Ec6BMq
         FN6bdju1cfUsdXqJWNd9Bya+yl6cWoeg03P8CFE26no0HHg42PKin/ys3p/zBS4oZ1U5
         UFJg==
X-Gm-Message-State: ANoB5pnzPopc3yJ+vk6n0xUWsQSLVsUyh61hmOORAZRlObbZsnIPYOPT
        a5SRwe84W9wGrWs5uehfPLSQ3Q==
X-Google-Smtp-Source: AA0mqf5rBUQp06bOPeb2P50vGhfAiW493UUbrMxL6CqiT7DSfI3HjTNhhwFvxgv3FyimqSG/D/nYcQ==
X-Received: by 2002:a17:906:79c4:b0:778:e3e2:8311 with SMTP id m4-20020a17090679c400b00778e3e28311mr38419262ejo.342.1669817214914;
        Wed, 30 Nov 2022 06:06:54 -0800 (PST)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id mh1-20020a170906eb8100b0073d83f80b05sm692454ejb.94.2022.11.30.06.06.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 06:06:54 -0800 (PST)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        mptcp@lists.linux.dev, netdev@vger.kernel.org
Subject: [PATCH net-next 00/11] mptcp: PM listener events + selftests cleanup
Date:   Wed, 30 Nov 2022 15:06:22 +0100
Message-Id: <20221130140637.409926-1-matthieu.baerts@tessares.net>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2590; i=matthieu.baerts@tessares.net;
 h=from:subject; bh=pl1o6f40D2/19YlccetSq1+bjdqP611/9GCIe0J7Hbs=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBjh2Nn+X5cqZr4yFarrOLufGxDeYDd/qEfd0Z/hsBE
 U9Ou3IKJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCY4djZwAKCRD2t4JPQmmgc/ZkEA
 CrhsRPYiY1HY18bBWROwXSiegcbNbajaWlgMHWIPeBX/HUhbweqo45mTB2AQJ0LfdDFCHZ/jLk5KaB
 bUTbXhGfBoV5BRJYtZHqnYnFSh3SoNFAlacDxG8AZQX3ZgqvHWY7eap9mK5cympe63LNxfRUNiVUsC
 pKMdP22IPNNlpa7ZZbWBcEtaExeJ2wZryNdMIHEjuyZ07oxoAquQs+yv3kWcL57UcNdzi58R6vbj9t
 O19eTfT6TA0KApwz9zsHIFuZPhwdS4Pj7KZxAYyACEncduMx+UcHjxLMJzDz0Cl3FUzwFpovdHsjl0
 hp5rqgmYCRUiPYmLwG6QggbHvK72/97znq3LvymB0tMZjFKN6t8D57j8RriSjaM/KTnnyXk5CS+W9x
 mjKV41zTlHmH7S8/OHu8OYzL8MJVS20dWJVe19MyDFKD1f8tY47nU8HdtE4RFpMns2V8OBaToVpcy4
 lr/L8fs0qEpGuOJy0zKXsbGXa4j8vGs1ViAHMD93OXj2Xe/lvpEh3uJdgQn+zwAxypWKWxQ5ZaEtwA
 /po4jh+7S1HNJyTMsfLouZLAF2dCNegSK/fJ47FhmQTh0mXVSYL68MoMnuRMTtcrYI3Yk+EX6LeTqd
 gT4tfSYxNB/7xdA+mfM/JNKcklq77kSM/MNV0k8UmpPuw4xvRGuZ0Qnzrc2w==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp; fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks to the patch 6/11, the MPTCP path manager now sends Netlink events when
MPTCP listening sockets are created and closed. The reason why it is needed is
explained in the linked ticket [1]:

  MPTCP for Linux, when not using the in-kernel PM, depends on the userspace PM
  to create extra listening sockets before announcing addresses and ports. Let's
  call these "PM listeners".

  With the existing MPTCP netlink events, a userspace PM can create PM listeners
  at startup time, or in response to an incoming connection. Creating sockets in
  response to connections is not optimal: ADD_ADDRs can't be sent until the
  sockets are created and listen()ed, and if all connections are closed then it
  may not be clear to the userspace PM daemon that PM listener sockets should be
  cleaned up.

  Hence this feature request: to add MPTCP netlink events for listening socket
  close & create, so PM listening sockets can be managed based on application
  activity.

  [1] https://github.com/multipath-tcp/mptcp_net-next/issues/313

Selftests for these new Netlink events have been added in patches 9,11/11.

The remaining patches introduce different cleanups and small improvements in
MPTCP selftests to ease the maintenance and the addition of new tests.


Geliang Tang (6):
  mptcp: add pm listener events
  selftests: mptcp: enhance userspace pm tests
  selftests: mptcp: make evts global in userspace_pm
  selftests: mptcp: listener test for userspace PM
  selftests: mptcp: make evts global in mptcp_join
  selftests: mptcp: listener test for in-kernel PM

Matthieu Baerts (5):
  selftests: mptcp: run mptcp_inq from a clean netns
  selftests: mptcp: removed defined but unused vars
  selftests: mptcp: uniform 'rndh' variable
  selftests: mptcp: clearly declare global ns vars
  selftests: mptcp: declare var as local

 include/uapi/linux/mptcp.h                    |   9 +
 net/mptcp/pm_netlink.c                        |  57 ++++
 net/mptcp/protocol.c                          |   3 +
 net/mptcp/protocol.h                          |   2 +
 tools/testing/selftests/net/mptcp/diag.sh     |   1 +
 .../selftests/net/mptcp/mptcp_connect.sh      |   6 +-
 .../testing/selftests/net/mptcp/mptcp_join.sh | 118 +++++--
 .../selftests/net/mptcp/mptcp_sockopt.sh      |  69 ++--
 .../selftests/net/mptcp/simult_flows.sh       |   4 +-
 .../selftests/net/mptcp/userspace_pm.sh       | 298 ++++++++++--------
 10 files changed, 375 insertions(+), 192 deletions(-)


base-commit: 91a7de85600d5dfa272cea3cef83052e067dc0ab
-- 
2.37.2

