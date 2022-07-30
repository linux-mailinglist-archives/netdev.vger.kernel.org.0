Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6789A585B35
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 18:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234647AbiG3QDt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jul 2022 12:03:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbiG3QDs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jul 2022 12:03:48 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15D8AC32;
        Sat, 30 Jul 2022 09:03:44 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id v2so5581335qvs.12;
        Sat, 30 Jul 2022 09:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zgmGl0zOLMrX607mh9XkqEoaOPwjCXk2yDE13rCP8S4=;
        b=brWrA3BHLdXgaMLYNPn15nUSgJ+ICxG8mg77/mh6pbRg07FjjG6pva4xRLwxB0eghG
         Dfq+F+V+x1NOiHFkSbvx4tMx1QCHMIqqEBpB/oHd3QWHQqP92Z2xKTlHXFeP6Dx3NAZe
         sgtPmxYbpV0bnJUMme0La5BDx5Cp7c0CaFwYJczWmdWyvrpFLdPNJzk0Yv4J8rFViFe4
         ha3HU+A9U8BGTgtkjkQaBg7QnHTC3qfTulG7b6UZPbBImBZDyYVk72mOQ+V89AT2p5jo
         KppSykFsfouzX7UG9IQw2bdyE/Zmw5sx5Xah/jVB5rKs+S/K+2cvEFj2Dk/rj+VK9YS0
         4rog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zgmGl0zOLMrX607mh9XkqEoaOPwjCXk2yDE13rCP8S4=;
        b=0/9/N1hS95GLmR3fB4Jm5sosyv1b8vijso0Poj3TCQ2uMJFpRxZg4pzk9Ui8t3P9AV
         1dc0vbWu1A1wGfMcyZi87I9/isoj2svjfth1LlFLI8WoJFoInne2+kXAhHm79NhOlpn2
         kl+hcKxTg67sxjNySsWZO8D8xadOy+qhaCaIc2V3/9Bxuwqe76DQo+LtL/KdSqCiy/op
         l7SCPUezXzYH4oBSNkTXtqVCHYzRCS8ohFUrY9vbs6evoME8NrpcUOZWALSUSmCjEl5n
         m+61qiQO7mOHYoih1hsmEdZjKeLbY8Gw7TBzUPxrdxporiH4m09DUqZ23XV0IalFxQ5F
         ULUQ==
X-Gm-Message-State: ACgBeo1M58s+o/RF5OJCd3WpVHlRkUqINijDPxAAtXYgu5bA2F5sIhYs
        oXRGTCb7Gd9kFjkqn5jrHnhn5IW9K0Dr5g==
X-Google-Smtp-Source: AA6agR7TvxAutxwqOLc1mZR6yYJ9ibyJ7OtPept/S/5Xwy40UMUhzGvKys6n5v2Fi0v3+PXvSzM4nQ==
X-Received: by 2002:a05:6214:29c7:b0:473:7b25:f950 with SMTP id gh7-20020a05621429c700b004737b25f950mr7668120qvb.95.1659197023561;
        Sat, 30 Jul 2022 09:03:43 -0700 (PDT)
Received: from ada ([71.58.109.160])
        by smtp.gmail.com with ESMTPSA id 206-20020a3703d7000000b006b5840f3eefsm4447103qkd.130.2022.07.30.09.03.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Jul 2022 09:03:42 -0700 (PDT)
From:   Sevinj Aghayeva <sevinj.aghayeva@gmail.com>
To:     aroulin@nvidia.com
Cc:     sbrivio@redhat.com, roopa@nvidia.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org,
        Sevinj Aghayeva <sevinj.aghayeva@gmail.com>
Subject: [PATCH net-next 0/3] net: vlan: fix bridge binding behavior and add selftests
Date:   Sat, 30 Jul 2022 12:03:29 -0400
Message-Id: <cover.1659195179.git.sevinj.aghayeva@gmail.com>
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

When bridge binding is enabled for a vlan interface, it is expected
that the link state of the vlan interface will track the subset of the
ports that are also members of the corresponding vlan, rather than
that of all ports.

Currently, this feature works as expected when a vlan interface is
created with bridge binding enabled:

  ip link add link br name vlan10 type vlan id 10 protocol 802.1q \
        bridge_binding on

However, the feature does not work when a vlan interface is created
with bridge binding disabled, and then enabled later:

  ip link add link br name vlan10 type vlan id 10 protocol 802.1q \
        bridge_binding off
  ip link set vlan10 type vlan bridge_binding on

After these two commands, the link state of the vlan interface
continues to track that of all ports, which is inconsistent and
confusing to users. This series fixes this bug and introduces two
tests for the valid behavior.

Sevinj Aghayeva (3):
  net: bridge: export br_vlan_upper_change
  net: 8021q: fix bridge binding behavior for vlan interfaces
  selftests: net: tests for bridge binding behavior

 include/linux/if_bridge.h                     |   9 ++
 net/8021q/vlan.h                              |   2 +-
 net/8021q/vlan_dev.c                          |  21 ++-
 net/bridge/br_vlan.c                          |   7 +-
 tools/testing/selftests/net/Makefile          |   1 +
 .../selftests/net/bridge_vlan_binding_test.sh | 143 ++++++++++++++++++
 6 files changed, 176 insertions(+), 7 deletions(-)
 create mode 100755 tools/testing/selftests/net/bridge_vlan_binding_test.sh

-- 
2.25.1

