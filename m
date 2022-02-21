Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D9584BD5BA
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 07:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244412AbiBUFze (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 00:55:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241206AbiBUFzd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 00:55:33 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9251151333
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 21:55:11 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id 27so8168324pgk.10
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 21:55:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CSgV9Fmy9kyGfVJtwxftrAPCRwy8UA+63pWK8bJxB80=;
        b=WIxG+K3D7UGs22qBewhNA8de7o1RUDTjHaQ+k87l37F6CgIIGkrQOaL0BPhfB/UYBB
         5heA6hgGtnCEhR6U+w5Hk8+OJCMj6Cb8oRbJ1E3zS8lU4kJ59pkJFdwsBHB0vHvfTZ7m
         RiPXbhVz+62SaABilnVJ1x6wZiJ7ZPhwOkRxyaobjhI32SY7p9qctek20eGnpOCDqODZ
         y22LnVpOsW6xiv+51kQ3EFPlh2LDqRv/ReKw+jhzAjpwnD9MWSeT+0hC5XrrPLdg3nRp
         IQR8ebDFjspuaTQp7Rj4QdckyEgRiVZzGhMJAc7lbbpnKxY4Pw4qD3guJx1REi3/m90c
         wQYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CSgV9Fmy9kyGfVJtwxftrAPCRwy8UA+63pWK8bJxB80=;
        b=dLiSMmCni93tODehCs5ISmSsZftOKo+H/ZcghajljEObW+kQR38G4ZwQi4kQxh57qp
         CT/vKX0TOj4U0FS1TEDny20CBl4480c5aaho3GQdwQq2JZXNi/PM08YEHr9EPPTh1iyk
         kB35zx2BhBAt13TN6p9hFZ0ojeFej0DDC8c89gLXUQGjB7blw89gTEVy+4en/7xI/2gT
         bg0JcXWe7nn0naVDZ5XVZERfYGgVLJX4yKBhVGgDfQvyiQbzvHxX/r7SDmnmnBNt6Mzi
         +WuNug7db7zq9C46aROmdTRbDNLM08MOLuncfh6Wd89GSc/E+xXUgzmxJ45B3lMxNZQm
         RUhw==
X-Gm-Message-State: AOAM530PnjJkKFhn1KBh9cLgyJuAQqZVncLJie8a4SXTFuTwMWTjkTnf
        N2gqFCfg4+ElDko2anik090kwH0mAxI=
X-Google-Smtp-Source: ABdhPJy1pUAjasUF60JTgvWL77ffYBBVaYfnTibS8hA76tOKvv2uc1FSPiYu3kfyfT32OH1/72q7Tg==
X-Received: by 2002:a05:6a00:cd4:b0:4e1:bec9:efac with SMTP id b20-20020a056a000cd400b004e1bec9efacmr18404095pfv.63.1645422910854;
        Sun, 20 Feb 2022 21:55:10 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s15sm17359767pgn.30.2022.02.20.21.55.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Feb 2022 21:55:10 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv2 net-next 0/5] bonding: add IPv6 NS/NA monitor support
Date:   Mon, 21 Feb 2022 13:54:52 +0800
Message-Id: <20220221055458.18790-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
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

This patch add bond IPv6 NS/NA monitor support. A new option
ns_ip6_target is added, which is similar with arp_ip_target.
The IPv6 NS/NA monitor will take effect when there is a valid IPv6
address. Both ARP monitor and NS monitor will working at the same time.

A new extra storage field is added to struct bond_opt_value for IPv6 support.

Function bond_handle_vlan() is split from bond_arp_send() for both
IPv4/IPv6 usage.

To alloc NS message and send out. ndisc_ns_create() and ndisc_send_skb()
are exported.

v1 -> v2:
1. remove sysfs entry[1] and only keep netlink support.

RFC -> v1:
1. define BOND_MAX_ND_TARGETS as BOND_MAX_ARP_TARGETS
2. adjust for reverse xmas tree ordering of local variables
3. remove bond_do_ns_validate()
4. add extra field for bond_opt_value
5. set IS_ENABLED(CONFIG_IPV6) for IPv6 codes

[1] https://lore.kernel.org/netdev/8863.1645071997@famine

Hangbin Liu (5):
  ipv6: separate ndisc_ns_create() from ndisc_send_ns()
  Bonding: split bond_handle_vlan from bond_arp_send
  bonding: add extra field for bond_opt_value
  bonding: add new parameter ns_targets
  bonding: add new option ns_ip6_target

 Documentation/networking/bonding.rst |  11 +
 drivers/net/bonding/bond_main.c      | 295 +++++++++++++++++++++++----
 drivers/net/bonding/bond_netlink.c   |  59 ++++++
 drivers/net/bonding/bond_options.c   |  74 ++++++-
 include/net/bond_options.h           |  31 ++-
 include/net/bonding.h                |  26 ++-
 include/net/ndisc.h                  |   5 +
 include/uapi/linux/if_link.h         |   1 +
 net/ipv6/ndisc.c                     |  49 +++--
 tools/include/uapi/linux/if_link.h   |   1 +
 10 files changed, 481 insertions(+), 71 deletions(-)

-- 
2.31.1

