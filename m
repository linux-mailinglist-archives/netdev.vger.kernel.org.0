Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE2414FDEFA
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 14:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347002AbiDLMFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 08:05:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351243AbiDLMCg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 08:02:36 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D20C76595;
        Tue, 12 Apr 2022 03:58:53 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id bg10so36566167ejb.4;
        Tue, 12 Apr 2022 03:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+eJGktqK5V7HDq2U3VQXwapNjHNoENEgBXt1QNATELQ=;
        b=ZoFzb3tloXo+McRmkV6Gjg4GWW6lT27yGVpQhLtkyv6VtKJAkz3EOXC4aqUvcXQxTA
         fZk3vQyLWDrVKZghgFc8vooDWaYuBRlPXfhKU+uU/xhrw6hd7uU4BFjbWhlzkFjAmGPZ
         AIZAfM2nYSXw9Ziw9eywORZ+2hSZYIx9hW/8V3WAYu6elqDnzP3N5e2LzkpnKJ43TMAg
         iLr3BrXHMV+92mMcEL6FrJKEr+fP3v1xYy4dAD5BLkMFLvOjt24AkA2BpkvT1SFiy4I5
         OnZ9KtzFh9kv4tfn0kHZtUOosQl6A6yWQT8ZQdfvLARlvhWkUPNuOfcm+A8pYz1USsFA
         K9dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+eJGktqK5V7HDq2U3VQXwapNjHNoENEgBXt1QNATELQ=;
        b=HMopq+KcYuG1ZW1IisA9oALTsc3/VcHlfzlq+0hZeFOCYfuO379WjlwsUemsE63Cos
         MTYUNOVx6byXWjOz/Tge4TvBuY95G8b0191x5eTq5lylheH/JT9OS73rRVc6O2I03JBQ
         e1tFfmHi/XW8qkRgRTw+9y0Y8bi5rqRX+61MslrPmK9NuescZjISUKDQZP/s59vBtHAi
         EjpOS2Dx8yUAhVoEV5CHWBVUmucAgHNiqXBFV7x8ewCfTmdDWi54Ymm6FYRp74aoQAQU
         W0Jb+Sipvorb7hzQx8ZKOravOUBmx6s5/WLYbd+kzJhZMe27TS+eD/CFCZkQCwFtvM9d
         B7WQ==
X-Gm-Message-State: AOAM530T+L/eNdT5RVPQjLsa+io+2t9EbIi9HZIln5YyLnfZJe81tHbj
        ykjOm9UwoJoZv0q1n25i72HOd05fRggIlQ==
X-Google-Smtp-Source: ABdhPJxep0FXI5E4VuHszT83H2dajpT8we3g05o3csYxYlKrvvyOU9hf7TeqHG/soEwhIlAY6GoNJQ==
X-Received: by 2002:a17:906:1603:b0:6ce:362:c938 with SMTP id m3-20020a170906160300b006ce0362c938mr34467412ejd.253.1649761131410;
        Tue, 12 Apr 2022 03:58:51 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id f1-20020a056402194100b00416b174987asm16986370edz.35.2022.04.12.03.58.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 03:58:50 -0700 (PDT)
From:   Jakob Koschel <jakobkoschel@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com, Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Casper Andersson <casper.casan@gmail.com>,
        Jakob Koschel <jakobkoschel@gmail.com>,
        Colin Ian King <colin.king@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Michael Walle <michael@walle.cc>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Eric Dumazet <edumazet@google.com>,
        Xu Wang <vulab@iscas.ac.cn>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, bpf@vger.kernel.org,
        Mike Rapoport <rppt@kernel.org>,
        "Brian Johannesmeyer" <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>
Subject: [PATCH net-next v2 00/18] Remove use of list iterator after loop body
Date:   Tue, 12 Apr 2022 12:58:12 +0200
Message-Id: <20220412105830.3495846-1-jakobkoschel@gmail.com>
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

When the list iterator loop does not exit early the list iterator variable
contains a type-confused pointer to a 'bogus' list element computed based
on the head [1].

Often a 'found' variable is used to ensure the list iterator
variable is only accessed after the loop body if the loop did exit early
(using a break or goto).

In other cases that list iterator variable is used in
combination to access the list member which reverses the invocation of
container_of() and brings back a "safe" pointer to the head of the list.

Since, due to this code patten, there were quite a few bugs discovered [2],
Linus concluded that the rule should be to never use the list iterator
after the loop and introduce a dedicated pointer for that [3].

With the new gnu11 standard, it will now be possible to limit the scope
of the list iterator variable to the traversal loop itself by defining
the variable within the for loop.
This, however, requires to remove all uses of the list iterator after
the loop.

Based on input from Paolo Abeni [4], Vinicius Costa Gomes [5], and
Jakub Kicinski [6], I've splitted all the net-next related changes into
two patch sets, where this is part 1.

v1->v2:
- Fixed commit message for PATCH 14/18 and used dedicated variable
  pointing to the position (Edward Cree)
- Removed redundant check in mv88e6xxx_port_vlan() (Vladimir Oltean)
- Refactor mv88e6xxx_port_vlan() using separate list iterator functions
  (Vladimir Oltean)
- Refactor sja1105_insert_gate_entry() to use separate list iterator
  functions (Vladimir Oltean)
- Allow early return in sja1105_insert_gate_entry() if
  sja1105_first_entry_longer_than() didn't find any element
  (Vladimir Oltean)
- Use list_add_tail() instead of list_add() in sja1105_insert_gate_entry()
  (Jakub Kicinski)
- net: netcp: also use separate 'pos' variable instead of duplicating list_add()

Link: https://lwn.net/Articles/887097/ [1]
Link: https://lore.kernel.org/linux-kernel/20220217184829.1991035-4-jakobkoschel@gmail.com/ [2]
Link: https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/ [3]
Link: https://lore.kernel.org/linux-kernel/7393b673c626fd75f2b4f8509faa5459254fb87c.camel@redhat.com/ [4]
Link: https://lore.kernel.org/linux-kernel/877d8a3sww.fsf@intel.com/ [5]
Link: https://lore.kernel.org/linux-kernel/20220403205502.1b34415d@kernel.org/ [6]

Jakob Koschel (18):
  connector: Replace usage of found with dedicated list iterator
    variable
  net: dsa: sja1105: remove use of iterator after list_for_each_entry()
    loop
  net: dsa: sja1105: reorder sja1105_first_entry_longer_than with memory
    allocation
  net: dsa: sja1105: use list_add_tail(pos) instead of
    list_add(pos->prev)
  net: dsa: mv88e6xxx: remove redundant check in mv88e6xxx_port_vlan()
  net: dsa: mv88e6xxx: refactor mv88e6xxx_port_vlan()
  net: dsa: Replace usage of found with dedicated list iterator variable
  net: sparx5: Replace usage of found with dedicated list iterator
    variable
  qed: Use dedicated list iterator variable
  qed: Replace usage of found with dedicated list iterator variable
  qed: Remove usage of list iterator variable after the loop
  net: qede: Replace usage of found with dedicated list iterator
    variable
  net: qede: Remove check of list iterator against head past the loop
    body
  sfc: Remove usage of list iterator for list_add() after the loop body
  net: netcp: Remove usage of list iterator for list_add() after loop
    body
  ps3_gelic: Replace usage of found with dedicated list iterator
    variable
  ipvlan: Remove usage of list iterator variable for the loop body
  team: Remove use of list iterator variable for
    list_for_each_entry_from()

 drivers/connector/cn_queue.c                  | 13 ++---
 drivers/net/dsa/mv88e6xxx/chip.c              | 57 ++++++++++---------
 drivers/net/dsa/sja1105/sja1105_vl.c          | 51 +++++++++--------
 .../microchip/sparx5/sparx5_mactable.c        | 25 ++++----
 drivers/net/ethernet/qlogic/qed/qed_dev.c     | 11 ++--
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c   | 26 ++++-----
 drivers/net/ethernet/qlogic/qed/qed_spq.c     |  6 +-
 .../net/ethernet/qlogic/qede/qede_filter.c    | 11 ++--
 drivers/net/ethernet/qlogic/qede/qede_rdma.c  | 11 ++--
 drivers/net/ethernet/sfc/rx_common.c          |  8 ++-
 drivers/net/ethernet/ti/netcp_core.c          | 14 +++--
 .../net/ethernet/toshiba/ps3_gelic_wireless.c | 30 +++++-----
 drivers/net/ipvlan/ipvlan_main.c              |  7 ++-
 drivers/net/team/team.c                       | 20 ++++---
 net/dsa/dsa.c                                 | 11 ++--
 15 files changed, 163 insertions(+), 138 deletions(-)


base-commit: 3e732ebf7316ac83e8562db7e64cc68aec390a18
--
2.25.1

