Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2470D6BF6E0
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 01:23:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbjCRAXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 20:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjCRAXn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 20:23:43 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60FC319C54
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 17:23:42 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id y186-20020a62cec3000000b00627df3d6ec4so204275pfg.12
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 17:23:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679099022;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=POn92RWfNuQQQ9DSGkjDiwKFBxA3POONxTo0DfDdP8Y=;
        b=pRxFAC0sHVzeZ3vKazvfLS+l+8lNdcPmP61zW5x4j3LYQZYpUPrlUDemktMiybVmR2
         aZGEoMvMgwAWBT+IoBcwnjy+DDNaMYNNERoX3hzKpSqkcADKzk0uAxRzVXJpiyBDDhoD
         q7MO2vuv633R9UgrPoNiN7SMjw9yGESbY3og/AUA3LNZ5Ri5PBXHNICaucgoQSIUYPTM
         gh47o00EQm52IsSmDJE7FcHGej0X0tfFicYusw7svCHemUvNyNkZjDiCQoLDkISsku6n
         k3KMWCTbIz2f9rxHs02FSn30zAFp2w3OiGjVzOOxLoxUpcJlHfArTCCReFOpzHXFsfZa
         u9hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679099022;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=POn92RWfNuQQQ9DSGkjDiwKFBxA3POONxTo0DfDdP8Y=;
        b=S3tnQR4cxObVCmBfe/pSYwxE4FT9J+9UEzf5r0z9iLb0LoD4Iz1TpSR1Rfc/0bWQeT
         5sktZ3yBGCcL6yiGlQfyJEoJ+McLgLawaDP6SVhbsVX6oVfe0msIloNlvN28o8y1+PzT
         /49Rmwg/2S9xwfdz/flwjr34V40+0/+7sbtiOjF+bpn+ohdYysgvZ6KYdDFK5XXPOwza
         VyYR1lKMWIYsWpse1aCk1m0exsPO7yuWsWRPFfxomniaPBKix7N6V46SDcmrkJNCRONc
         kf5n3fCTltGaM4HnHIUDTTLdOkEq0h9LBBcHoDROeAuSstwGsasR1JZQOsoh+W7R2D3c
         rQjA==
X-Gm-Message-State: AO0yUKUI/UaepQu1cEih1IuiN8isoecYov9mck9Dr966FjajpVcE+pJe
        btuFk5U3nLR59Pzj0eKPO8lgL8Ny6C/F0iMZaq/SdgxH/RwUT1nsgm1jphIbz6i7K9IV501ZJ/n
        UvED7T1kDiLblFhT1QPjCSJGvYaJTR1vv0dXDp/gAXutMteMYzH2arw==
X-Google-Smtp-Source: AK7set+qpo44KtBzRAB3KfSFYB5cTNsY5+Q5RvJVxvUX6hNlwgwYO966FOFLjWmAYIKqep6ssMEU6oc=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:902:db09:b0:1a0:503a:2a42 with SMTP id
 m9-20020a170902db0900b001a0503a2a42mr3751054plx.12.1679099021783; Fri, 17 Mar
 2023 17:23:41 -0700 (PDT)
Date:   Fri, 17 Mar 2023 17:23:36 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230318002340.1306356-1-sdf@google.com>
Subject: [PATCH net-next 0/4] ynl: fill in some gaps of ethtool spec
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I was trying to fill in the spec while exploring ethtool API for some
related work. I don't think I'll have the patience to fill in the rest,
so decided to share whatever I currently have.

Patches 1-2 add the be16 + spec.
Patches 3-4 implement an ethtool-like python tool to test the spec.

Patches 3-4 are there because it felt more fun do the tool instead
of writing the actual tests; feel free to drop it; sharing mostly
to show that the spec is not a complete nonsense.

The spec is not 100% complete, see patch 2 for what's missing.
I was hoping to finish the stats-get message, but I'm too dump
to implement bitmask marshaling (multi-attr).

Stanislav Fomichev (4):
  ynl: support be16 in schemas
  ynl: populate most of the ethtool spec
  ynl: replace print with NlError
  ynl: ethtool testing tool

 Documentation/netlink/genetlink-c.yaml      |    2 +-
 Documentation/netlink/genetlink-legacy.yaml |    4 +-
 Documentation/netlink/genetlink.yaml        |    2 +-
 Documentation/netlink/specs/ethtool.yaml    | 1473 +++++++++++++++++--
 tools/net/ynl/ethtool                       |  424 ++++++
 tools/net/ynl/lib/nlspec.py                 |    9 +
 tools/net/ynl/lib/ynl.py                    |   31 +-
 7 files changed, 1827 insertions(+), 118 deletions(-)
 create mode 100755 tools/net/ynl/ethtool

-- 
2.40.0.rc1.284.g88254d51c5-goog

