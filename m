Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8E16C046E
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 20:38:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbjCSTi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 15:38:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjCSTi0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 15:38:26 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E2016EAC
        for <netdev@vger.kernel.org>; Sun, 19 Mar 2023 12:38:24 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id j2so8532833wrh.9
        for <netdev@vger.kernel.org>; Sun, 19 Mar 2023 12:38:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679254702;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=R2HBlNxL593KK38JOiUJUQ5j71BteRRhdQuhNcIe5TA=;
        b=Yr/8u14d8h0Ab+5x3sUA5CURivNZfLX6mPamgTHWqMTLvbQFg+9ele24nOu5fRbNcB
         mmOoSiDrNkBEYJXoDV2Cu0kpJzMqxSIxq1o2v/NNYJCOOl6D3DFOMMIsJCiPQbThHzrN
         G0sOzIVwNLr6Ikv5S7jlSB8EQ/9k8S+Bf8C31RWpvUZiHx3QBPu2mbXgKdpgK/aV96OK
         ohhZ3LygsAwwhB6Q/tNWhLJlqmkS7vZvUIxeswVF99NlXdeWcy1en5Qw/2CEGv7FyRzM
         8lI91YBUSgNFETrOGH+gCWp2jlPcomqFWpP0I3iVeVuXOgCusmtYTK5sS+2KpUFlXNhV
         YC8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679254702;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R2HBlNxL593KK38JOiUJUQ5j71BteRRhdQuhNcIe5TA=;
        b=etRkz3Rar8+k+qsvGkkKMbdKAKs5zabjfiI6nv/XAXkwf36UGPQA1yySmnxqg+zimL
         Ame5Qwk9Jf6YL1WOBCZC/WxACAqI2efoB6DoUI9EfRPGipNHz+R1tcjaxIK8aga40kVa
         2nrkdTPPCzD4BgIslKPKFI9oT8dJ1mY0lBsb2KMS5My6KkzqGLtiC4jXaAU9MJ+PP7tf
         Dt+uT/4LeYeCR76+bl2tvkZH1PEQuilFRCKvVvCXRm8sJj49cNPObs5juJ4Ai7nhHsJG
         XnUgUCkk1Ngz4GMBlhtFAQwLq2rMCGmChB9t5++E6luStWfWyrKgEC1UQm2vm3wRfyOw
         XtUA==
X-Gm-Message-State: AO0yUKW+piaA1C+hoIQ+319OD1PvuSW4KzDDtLH8i8KF+Dq04lrxLFvT
        gQs7OHr/5oy2y3tDDWDhRK3JGecoBNs=
X-Google-Smtp-Source: AK7set8e6VpMvKDZT8yc3fvz+nVBxUW1fjK9bhmkoAvLY8pNX7IG6/Yg2WqQzL98r0+FwpWdJH71TA==
X-Received: by 2002:a5d:54c1:0:b0:2d3:fba4:e61d with SMTP id x1-20020a5d54c1000000b002d3fba4e61dmr6772133wrv.12.1679254702537;
        Sun, 19 Mar 2023 12:38:22 -0700 (PDT)
Received: from imac.redhat.com ([88.97.103.74])
        by smtp.gmail.com with ESMTPSA id d5-20020adfef85000000b002cfed482e9asm7204190wro.61.2023.03.19.12.38.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Mar 2023 12:38:21 -0700 (PDT)
From:   Donald Hunter <donald.hunter@gmail.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     donald.hunter@redhat.com, Donald Hunter <donald.hunter@gmail.com>
Subject: [PATCH net-next v2 0/6] ynl: add support for user headers and struct attrs
Date:   Sun, 19 Mar 2023 19:37:57 +0000
Message-Id: <20230319193803.97453-1-donald.hunter@gmail.com>
X-Mailer: git-send-email 2.39.0
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

Add support for user headers and struct attrs to YNL. This patchset adds
features to ynl and add a partial spec for openvswitch that demonstrates
use of the features.

Patch 1 fixes a trivial signedness mismatch with struct genlmsghdr
Patch 2-5 add features to ynl
Patch 6 adds partial openvswitch specs that demonstrate the new features

v1 - v2: all requested by Jakub Kicinski
 - Split ynl changes into separate patches
 - Rename user-header to fixed-header and improve description
 - Move fixed-header to operations section of spec
 - Introduce objects to represent struct config in nlspec
 - Use kebab-case throughout openvswitch specs

Donald Hunter (6):
  tools: ynl: Fix genlmsg header encoding formats
  tools: ynl: Add struct parsing to nlspec
  tools: ynl: Add array-nest attr decoding to ynl
  tools: ynl: Add struct attr decoding to ynl
  tools: ynl: Add fixed-header support to ynl
  netlink: specs: add partial specification for openvswitch

 Documentation/netlink/genetlink-legacy.yaml   |  17 +-
 Documentation/netlink/specs/ovs_datapath.yaml | 153 ++++++++++++++++++
 Documentation/netlink/specs/ovs_vport.yaml    | 139 ++++++++++++++++
 tools/net/ynl/lib/nlspec.py                   |  72 +++++++--
 tools/net/ynl/lib/ynl.py                      |  53 +++++-
 5 files changed, 413 insertions(+), 21 deletions(-)
 create mode 100644 Documentation/netlink/specs/ovs_datapath.yaml
 create mode 100644 Documentation/netlink/specs/ovs_vport.yaml

-- 
2.39.0

