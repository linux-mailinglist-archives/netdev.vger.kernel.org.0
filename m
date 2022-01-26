Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55DBB49C45F
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 08:35:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237869AbiAZHfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 02:35:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbiAZHfd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 02:35:33 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01C0BC06161C
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 23:35:33 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id o64so22501190pjo.2
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 23:35:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aF5kcu0t39kU7a8AXsYZ8oRu5hf/ROtjmPzvTNsZtlU=;
        b=CKgCKEp09ZIsc4FKB4swlyApSX2KUJMcSteSs3AhqjkzDYt/MNIM82CejyhxTp1Wle
         xoScOvng4o9vBJErudvfXdKS45XcBbQiDT+Qo3Hv1z5MHSy/NWMyr24UJlB4zKIy8mo8
         tPx9KF7QoVdBGcj1S+8CpgWkYMkwVShWb53sfQC78FHC+xbv6iYQZ4B2iXQAJfi2FU8m
         /BGSjmLgcFMpbd5cM1EJ6Cp3H3ZKOZ7XnflMZP+TlqNiOJz9+cgfIBzY8azHsrdaR+kj
         3BcCIFxlgYbkh7pt/tvSjuWPAR+KdovMyaMaqEvN2FE0oEL4iqg4/89wtPv4tjmQEaMi
         /D2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aF5kcu0t39kU7a8AXsYZ8oRu5hf/ROtjmPzvTNsZtlU=;
        b=IbD1/tGlJ5g1Wo6EsuIjgpocwzCTZn9S2JGTsyDO2NOXY7u5wm4mivGVl4ZElfG3hf
         CAs5aGhfXvUm1J4BKbRlLrfLKxsTNVV8xG1vq9d7Apl5+hBZhzo9UICG85nB8sgCGiCS
         xBpsJxxLcxFkuU5f1FwMp5qzv8trxI7kJvX4z9endnidUeLvbELIAXq5ZJB/YpNvK/yo
         SXXOPMDYJBJA+KNKsNgXMUis3AKrzJD4B/jF/tCO1A73fafDT0aG1oUwRmYi8gXYMVr4
         U3zcqTuEMDPvqTtJOa/8sZFcp8fmx51RGb1UEEvgUF7t3NEJUjtRRKhuKpBJCOraaC5I
         8OeA==
X-Gm-Message-State: AOAM5324lX9MxDJ0QFHuWrGDP1k7niiik9Tm3aJz1rEZ3osL462af5f5
        fDDFmssRRs7Kk4mJoGe8gDyEZM9FC1s=
X-Google-Smtp-Source: ABdhPJyL47wJFm8IWnR82VIkXgy8O85YI6/ULFSkglETvJi79WtS4IJuIVO1lFFVhajQkRv2J5lMRg==
X-Received: by 2002:a17:902:e0c2:b0:14a:e796:26c2 with SMTP id e2-20020a170902e0c200b0014ae79626c2mr22273423pla.118.1643182532307;
        Tue, 25 Jan 2022 23:35:32 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p12sm2240819pjj.55.2022.01.25.23.35.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 23:35:31 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH RFC net-next 0/5] bonding: add IPv6 NS/NA monitor support
Date:   Wed, 26 Jan 2022 15:35:16 +0800
Message-Id: <20220126073521.1313870-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an RFC of adding IPv6 NS/NA monitor support for bonding. I
posted a draft patch before[1]. But that patch is too big and David
Ahern suggested to split it smaller. So I split the previous patch
to 5 small ones, maybe not very good :)

The iproute2 patch is here [2].

This patch add bond IPv6 NS/NA monitor support. A new option
ns_ip6_target is added, which is similar with arp_ip_target.
The IPv6 NS/NA monitor will take effect when there is a valid IPv6
address. And ARP monitor will stop working.

A new field struct in6_addr ip6_addr is added to struct bond_opt_value
for IPv6 support. Thus __bond_opt_init() is also updated to check
string, addr first.

Function bond_handle_vlan() is split from bond_arp_send() for both
IPv4/IPv6 usage.

To alloc NS message and send out. ndisc_ns_create() and ndisc_send_skb()
are exported.

[1] https://lore.kernel.org/netdev/20211124071854.1400032-1-liuhangbin@gmail.com
[2] https://lore.kernel.org/netdev/20211124071854.1400032-2-liuhangbin@gmail.com

Hangbin Liu (5):
  ipv6: separate ndisc_ns_create() from ndisc_send_ns()
  Bonding: split bond_handle_vlan from bond_arp_send
  bonding: add ip6_addr for bond_opt_value
  bonding: add new parameter ns_targets
  bonding: add new option ns_ip6_target

 Documentation/networking/bonding.rst |  11 ++
 drivers/net/bonding/bond_main.c      | 266 ++++++++++++++++++++++++---
 drivers/net/bonding/bond_netlink.c   |  55 ++++++
 drivers/net/bonding/bond_options.c   | 142 +++++++++++++-
 drivers/net/bonding/bond_sysfs.c     |  22 +++
 include/net/bond_options.h           |  14 +-
 include/net/bonding.h                |  36 ++++
 include/net/ndisc.h                  |   5 +
 include/uapi/linux/if_link.h         |   1 +
 net/ipv6/ndisc.c                     |  45 +++--
 tools/include/uapi/linux/if_link.h   |   1 +
 11 files changed, 549 insertions(+), 49 deletions(-)

-- 
2.31.1

