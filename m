Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 568CD6C88A2
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 23:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231460AbjCXW5B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 18:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbjCXW5A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 18:57:00 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB6D1B2D0
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 15:56:59 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id p12-20020a25420c000000b00b6eb3c67574so3124178yba.11
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 15:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679698618;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=kZAkkHzGMoIJFtWhBkYIh171hAK+DBsv6YkBiRK6dsE=;
        b=eDMKJkjlr+4hgtHYzbNZi9njmdb5i4gBycnGpFVbfEv79PHA3ZixRDLH8dEakkDkkv
         b0eVx4O7bO84IA5OaopmO0p9k3LkMRXSqSbleTih0jZCS1WvDbE4zF4V4p7lHjbj2cOM
         ILPWTEG1JqefL+khHyIE+gX0IHS4aDFYyke54zRtignPaojYvGW9k+w/QSrwXRSt/Wpf
         7O1Vb+oPV6SIhikz/TX7VUcuI1tNK6x7VMLFe68IzjkVk8zJP/Fbcw0CgqK/BSpGOKbi
         zgEd7c0Fd6I0cHX3Rdf2zG34pARu9g28LXPbM+vUVhBKFcTY4kjDKNzNxFvHFdnwkzHC
         z9dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679698618;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kZAkkHzGMoIJFtWhBkYIh171hAK+DBsv6YkBiRK6dsE=;
        b=oWCGe7OffoO7RNKcCzIxq4sF5Ac2BG6AArvZtPKhmJQ6SfT6EL5wh5EEhih75vys6Y
         91KoblQ6CukG6i568qf9Cy0bDvjwphezxDCqj886I9e33ISUi+F3CbeuROd5/PTub9hz
         9NuLttcxAkCkEi32wKv9xy+pjYD6/bC/+qEe4SpsLWfKcSDo5i6ELEFk2cefTOb+WBLV
         DkV51z2GUsZiS5LupWY/5vmR3osZObcOdFegFTWFpKBKZHt5eNlfgwdE2rZ+h/iCZPZs
         Vb+209gk6FMt9xQ5PvOeRyE1WieNvN4nhVdf4SLr09tEat+ROmlQALFuByS3xLVGuuNj
         fm6A==
X-Gm-Message-State: AAQBX9e0so/TGvXSMoTXzPh7pObMDbqBEpoOvDfzb5Vdr+FNqLpCZNu/
        ExYI8qfiRFlBh6YjQeq3MTwCnY1LNJ8NGf9RLw+8NfpAs3hoblZ9Q110B9TO66LLb6bR+itvokD
        hUmPL9+q8cUVFH0YjGq+tv/IIqGXb4t3flK93RFu2+0j1j4SNMQmD/A==
X-Google-Smtp-Source: AKy350aiO/mULwt+SCmux9OLubD8vzOTssUVYRnw2aOhV+wBMMIhf5bx/BBLXv0+pYHqgl/S37sF8DY=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a05:6902:168d:b0:98e:6280:90e7 with SMTP id
 bx13-20020a056902168d00b0098e628090e7mr2362726ybb.13.1679698618375; Fri, 24
 Mar 2023 15:56:58 -0700 (PDT)
Date:   Fri, 24 Mar 2023 15:56:52 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230324225656.3999785-1-sdf@google.com>
Subject: [PATCH net-next v2 0/4] tools: ynl: fill in some gaps of ethtool spec
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
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

Note, this is on top of net-next plus the following patch:
[PATCH net-next v4] tools: ynl: Add missing types to encode/decode

v2:
- be16 -> byte-order
- remove header in ethtool, not the lib
- NlError two spaces after
- s/_/-/ in ethtool spec
- add missing - for s32-array
- remove "value: 13" hard-code for features-ntf (empty reply instead)
- updated output of the sample run in the last patch (I was actually
  using real ethtool, lol)

Stanislav Fomichev (4):
  tools: ynl: support byte-order in cli
  tools: ynl: populate most of the ethtool spec
  tools: ynl: replace print with NlError
  tools: ynl: ethtool testing tool

 Documentation/netlink/specs/ethtool.yaml | 1476 ++++++++++++++++++++--
 tools/net/ynl/ethtool                    |  424 +++++++
 tools/net/ynl/lib/nlspec.py              |    9 +
 tools/net/ynl/lib/ynl.py                 |   70 +-
 4 files changed, 1847 insertions(+), 132 deletions(-)
 create mode 100755 tools/net/ynl/ethtool

-- 
2.40.0.348.gf938b09366-goog

