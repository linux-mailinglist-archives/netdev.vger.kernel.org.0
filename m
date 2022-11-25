Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7975F63915F
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 23:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbiKYWaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 17:30:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbiKYWaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 17:30:23 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D65FD2E9FD
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 14:30:20 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id x102so8110799ede.0
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 14:30:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/lfe7NcgAftfCbfY2/+Z4pAkfVrRZUU2cO+H0igoqlA=;
        b=7FzjGwCiJNJVId0pUks3IuSTjdAMDw/5uXCGz//3wbe+aLq/LZkraFTPq+18Iqy8f+
         CAVozAtbugIdxu88+z6SZt3bmZRfgpoeY2+CfsQsBW3uw1dbpoPZTSya72tcg61Zp4Yz
         MEPWXVkwFTLGVCxst/lDCPkehzZk5zczUMp7euaQlpBLGQDL0hDDDINkWnD6arSwHjDx
         KZe7Q3wXtmnB9mRA+gi5eoFCbv7gFJ7/xXP4mT3AP4LuiVTP7obGpqCSjYh9gGg31rRx
         bTOl5+gcVNvCOUQp/opbKTBlY2OFU51UNYpeOSUbTDLjfcpmey7BW0Vljjbs9AfGHspU
         SARQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/lfe7NcgAftfCbfY2/+Z4pAkfVrRZUU2cO+H0igoqlA=;
        b=yOihGlKmJUjraJ/qhQv+yB1Mh7j7pmDpNimLhq5lGVdXZ1SDr7IKNEt5P1KifiHgeH
         CNqpHQVkhnTqiJ4TsLw7wrUSL3SKJBf4O0SPnHWeeossoHTHFvsx5S5bo9apft/LMwhY
         xnLCbeAaH8i84NxYdbuZv1o6Epuc29p8OBCsqu6HM6hAzN+buIGkkQB5QISqqvAPpY+X
         rAfXrYSnNbRDRtrYfq6qd15LjCWXjCvaV4uO1MK8imU9ok6WfVUrCacXRDzw2Ebr4V8x
         Bx+6X4YS1v8bhoNBsDyluM1miOo3C8WPkVz39r0xVcwmGXycvawgNxdtBp4bDgeSg3WY
         yE1Q==
X-Gm-Message-State: ANoB5pn6phtqX+uE13E7w8trWsgavBXKxG+n0SqxvrB3b56bTdz+033E
        eM81U9+VI/TElLn0qJv5z8VFuQ==
X-Google-Smtp-Source: AA0mqf45lZIo5bLh7SlwVwao3zqUEgyAn3xE8WBlMhIlo1JGSbjME9QxdeWPkodlemi4FjWWeyrtJA==
X-Received: by 2002:a05:6402:5c7:b0:469:6e8f:74c1 with SMTP id n7-20020a05640205c700b004696e8f74c1mr19895454edx.334.1669415419190;
        Fri, 25 Nov 2022 14:30:19 -0800 (PST)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id q1-20020a056402248100b0046267f8150csm2254612eda.19.2022.11.25.14.30.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Nov 2022 14:30:18 -0800 (PST)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc:     Benjamin Hesmans <benjamin.hesmans@tessares.net>,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        mptcp@lists.linux.dev, netdev@vger.kernel.org
Subject: [PATCH net-next 0/8] mptcp: MSG_FASTOPEN and TFO listener side support
Date:   Fri, 25 Nov 2022 23:29:46 +0100
Message-Id: <20221125222958.958636-1-matthieu.baerts@tessares.net>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2144; i=matthieu.baerts@tessares.net;
 h=from:subject; bh=/zzbai6dUt499JGTzQ7EvmldP8hH2rMm7tWR7FtcNHY=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBjgUHP3odjVCF44gMniUSK742ym4dsZtaly1a5iwCc
 FH/sZh6JAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCY4FBzwAKCRD2t4JPQmmgc4AgD/
 9DDOGjkr+5Wmxj4SWdYT43p//sr3oSXjQ2BycD/2oU/9vaHX0oS66ZS1zlrHRX5eTvWTvrx52OsQUn
 dPITVA4VCiU8KuNrys1OOjMJ1Lhmc5GrhEXujArJiqlMzCinR/g4YvTClJnCdHtx43gsrC7n7Ipp6Q
 yuocyEcoNVPLVIvpDqDbkIGjC0iYuMbBE/X4HF1r8/EnMNHC3TWbtoYGjqDpRKvs8hOAHeXdvZMmxe
 Graz1JQuoSCj3rsZBy726G8sGveOYkwcKstbTayfW5X/B8hIG4h0sF6N5pRwDR1L+WnpytQ/IRPBLJ
 gC7c06L5RN+DkzrQ2o+WF2LPBVDm9ZlbbGIQz04c/EwDR8bXfNMG5RBVwTuCds4RDuXf7n/KrMQIMR
 vF/0Zm4qJO9rs6PzJ6d3PcW/hP8AmmPrmuSyVmltFVmWSvcV+nT4JryyqgK3MbXRy1OmE+7oZtzkwg
 WZaAYLQUI0wqZ9FB2ewIdGcvULVhwjo+N9lOx0vny3H+7dJxoid3QgpGZnzLjYKsXP5Ktj/cKCqepr
 wO0rMej6wXKqtMLaER8mVT5Rjm8wzaJNiaVH2D8Sq7nF8BGjb+BlSFD+mZy7vvf3T0lJSupd5lz1S9
 bkuc/p9WoY5PocljH1c4FM5mPGPwaAI3SAGFPAt7FicEtbh284ft0Gs/R+HA==
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

Before this series, only the initiator of a connection was able to combine both
TCP FastOpen and MPTCP when using TCP_FASTOPEN_CONNECT socket option.

These new patches here add (in theory) the full support of TFO with MPTCP, which
means:

 - MSG_FASTOPEN sendmsg flag support (patch 1/8)
 - TFO support for the listener side (patches 2-5/8)
 - TCP_FASTOPEN socket option (patch 6/8)
 - TCP_FASTOPEN_KEY socket option (patch 7/8)

To support TFO for the server side, a few preparation patches are needed
(patches 2 to 5/8). Some of them were inspired by a previous work from Benjamin
Hesmans.

Note that TFO support with MPTCP has been validated with selftests (patch 8/8)
but also with Packetdrill tests running with a modified but still very WIP
version supporting MPTCP. Both the modified tool and the tests are available
online:

  https://github.com/multipath-tcp/packetdrill/


Dmytro Shytyi (5):
  mptcp: add MSG_FASTOPEN sendmsg flag support
  mptcp: implement delayed seq generation for passive fastopen
  mptcp: add subflow_v(4,6)_send_synack()
  mptcp: add TCP_FASTOPEN sock option
  selftests: mptcp: mptfo Initiator/Listener

Matthieu Baerts (1):
  mptcp: add support for TCP_FASTOPEN_KEY sockopt

Paolo Abeni (2):
  mptcp: track accurately the incoming MPC suboption type
  mptcp: consolidate initial ack seq generation

 net/mptcp/Makefile                            |   2 +-
 net/mptcp/fastopen.c                          |  73 ++++++++
 net/mptcp/options.c                           |  25 ++-
 net/mptcp/protocol.c                          |  39 +---
 net/mptcp/protocol.h                          |  28 ++-
 net/mptcp/sockopt.c                           |   9 +-
 net/mptcp/subflow.c                           | 105 ++++++++---
 .../selftests/net/mptcp/mptcp_connect.c       | 171 +++++++++++++-----
 .../selftests/net/mptcp/mptcp_connect.sh      |  21 +++
 9 files changed, 358 insertions(+), 115 deletions(-)
 create mode 100644 net/mptcp/fastopen.c


Cc: Benjamin Hesmans <benjamin.hesmans@tessares.net>
base-commit: a6e3d86ece0b42a571a11055ace5c3148cb7ce76
-- 
2.37.2

