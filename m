Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF7194F1348
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 12:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358145AbiDDKuk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 06:50:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231848AbiDDKug (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 06:50:36 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EA04635D
        for <netdev@vger.kernel.org>; Mon,  4 Apr 2022 03:48:38 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id s13so12290482ljd.5
        for <netdev@vger.kernel.org>; Mon, 04 Apr 2022 03:48:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=a5aKvrhwfQ/HI/ZlpDr68OhVoSyfibhM/59IeOTWRXE=;
        b=TxRIoVNLWo1q0iNsmTb/4PXNCmXidNdCZXqBCvBGKoTz0zsXfQa+/Q9To9YtEsKGtt
         qxLhfvVt1TNCQU5ONXUx1KqAyz4jzILVotu+7pYweHmSw6f1mFLg36vhqjRN6YP4wLqp
         gKQP4IFoSH1+lhLNDmdHu5wh5JEFUkNnpdIfx32YaGTRiKN3YCnyiYzqgFYnWbYsiPh2
         St2XQUG1fDx2tg4G7h8sw6w3v1kan0FvBCEiG9qaNTWTQgVSvr5RGOON0otwo70VxjuV
         HfoPdXxOw/waKa3ZzGIgmdV6plshcR+lllv0qX6j8Bc851dUYKXdjQapnkBzukXqRfr8
         KGUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=a5aKvrhwfQ/HI/ZlpDr68OhVoSyfibhM/59IeOTWRXE=;
        b=0ZMOtnxhqbpLz6bL8ttRbNCWZMCIxJsj+/ylgMeGc0NUCHt0pYAMGUJPtv3kwlk5mY
         EyA++OxoA1FrowwloDrgqjEa5ZRuntleyVwqG8+yitfRq2XgboJJLnK9ZG3Wo2KVGxox
         +TjgpAV7B1M6kWApyAImos86pV491NZqG473kiv2tftgXXTaVAw3rO1hXVlXhgI+JEKN
         vQiakUxqydnvCT8BMbvN0idY6xGoNncv9WfISpJWPkA3/jAa37LkxOwCcKTn7d/2L9yW
         pJFodBtKkLxBIu5Ujx5VdgnOV2ZCgSseEYhoH6qYqz2LLBlU4IduLU8H0fuuQ/SqmpSv
         5J2w==
X-Gm-Message-State: AOAM5308/7FAxPlD6BntJR09iHTD+qpbQWINBhcz7LdHH6IbxKKYZN2j
        0naC4OBLVyM7dSAJxkJmZyGGCDzhmFxbOw==
X-Google-Smtp-Source: ABdhPJzp2F+XSysmR5aRg9Tl/AW0Jxi9Ioz75tdKDSk7jyAWrZNgytNiXTDOfdWoR0816s+GcV1wJw==
X-Received: by 2002:a2e:9b05:0:b0:24b:e8:8c7e with SMTP id u5-20020a2e9b05000000b0024b00e88c7emr9767687lji.70.1649069315800;
        Mon, 04 Apr 2022 03:48:35 -0700 (PDT)
Received: from wse-c0089.raspi.local (h-98-128-237-157.A259.priv.bahnhof.se. [98.128.237.157])
        by smtp.gmail.com with ESMTPSA id b26-20020a056512061a00b0044a57b38530sm1098116lfe.164.2022.04.04.03.48.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 03:48:34 -0700 (PDT)
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Mattias Forsblad <mattias.forsblad@gmail.com>
Subject: [PATCH v3 net-next 0/2] net: tc: dsa: Implement offload of matchall for bridged DSA ports
Date:   Mon,  4 Apr 2022 12:48:24 +0200
Message-Id: <20220404104826.1902292-1-mattias.forsblad@gmail.com>
X-Mailer: git-send-email 2.25.1
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

Greetings,

This series implements offloading of tc matchall filter to HW
for bridged DSA ports.

Background
When using a non-VLAN filtering bridge we want to be able to drop
traffic directed to the CPU port so that the CPU doesn't get unnecessary loaded.
This is specially important when we have disabled learning on user ports.

A sample configuration could be something like this:

       br0
      /   \
   swp0   swp1

ip link add dev br0 type bridge stp_state 0 vlan_filtering 0
ip link set swp0 master br0
ip link set swp1 master br0
ip link set swp0 type bridge_slave learning off
ip link set swp1 type bridge_slave learning off
ip link set swp0 up
ip link set swp1 up
ip link set br0 up

After discussions here: https://lore.kernel.org/netdev/YjMo9xyoycXgSWXS@shredder/
it was advised to use tc to set an ingress filter that could then
be offloaded to HW, like so:

tc qdisc add dev br0 clsact
tc filter add dev br0 ingress pref 1 proto all matchall action drop

Limitations
If there is tc rules on a bridge and all the ports leave the bridge
and then joins the bridge again, the indirect framwork doesn't seem
to reoffload them at join. The tc rules need to be torn down and
re-added.

The first part of this serie uses the flow indirect framework to
setup monitoring of tc qdisc and filters added to a bridge.
The second part offloads the matchall filter to HW for Marvell
switches.

RFC -> v1: Monitor bridge join/leave and re-evaluate offloading (Vladimir Oltean)
v2: Fix code standard compliance (Jakub Kicinski)
v3: Fix warning from kernel test robot (<lkp@intel.com>)

Mattias Forsblad (2):
  net: tc: dsa: Add the matchall filter with drop action for bridged DSA
    ports.
  net: dsa: Implement tc offloading for drop target.

 drivers/net/dsa/mv88e6xxx/chip.c |  23 +++-
 include/net/dsa.h                |  14 ++
 net/dsa/dsa2.c                   |   5 +
 net/dsa/dsa_priv.h               |   3 +
 net/dsa/port.c                   |   2 +
 net/dsa/slave.c                  | 224 ++++++++++++++++++++++++++++++-
 6 files changed, 266 insertions(+), 5 deletions(-)

-- 
2.25.1

