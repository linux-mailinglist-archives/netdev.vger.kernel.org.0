Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 576EC610C64
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 10:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbiJ1Ims (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 04:42:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiJ1Imq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 04:42:46 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EA361C4ED9
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 01:42:46 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id hh9so3053313qtb.13
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 01:42:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=USVj24Z5vKsvCTDLqIq5kYFnQJ74ys/ekD7klHTYerc=;
        b=puDjf2Mw/MyfUTdfh9Zy7nWVH8IHOGI04fqb4jHQjyfcrYLiML1hynZCGls/T+vu6g
         ERv1A5uycXsYZhkFWd2Bvi3bwzSeuYTxD86WgaQTsKj8lWX3kDlFE5WKimY6uvlkb9/T
         Ki3CD5eHaBbsQMJfPre6goiX+FT5GqI/jqx2LpYKryzQ/DLbQTeepPSt9t+xT463YBTw
         E2+h7ww2gHA23/UpSB633WQHUGLL7Kma5YF6wamipdkOrkn1ikDO3W1Fd4qN9oC+jhjw
         f2S0dVh49pjk5uB36kZBlG0F9geC9eUpsFTLZiTeG28XMllebrJdH8NZA2bQ6CUF82m8
         nU5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=USVj24Z5vKsvCTDLqIq5kYFnQJ74ys/ekD7klHTYerc=;
        b=duA+jPxjbrhTbUWhyGuNx9jgsa2cx8f4AQxT7gCy8pBZmkhluDL/25ir4p60J5pzWf
         ghaWac5rCATdV0kKcgGWdv1LkJDYj4KzmYe5lcnnWg8xzz2KsbyLn9p6mTXsoEq5yIxV
         XZXpdAGnh/0uME0afyCfEc33UTKz9nZ5CvQjZifhlqXp16BKna4IFVde2ZfeC/lft2Qc
         4+0C5e83WSRRM7v8u2JFz2cnOt54ReK7GRlyqFA8a22QClP7FTz0IJqmy2eqVer79t1X
         x82cDP/ExjS3/Zo5lRU4z7bFmemxNCOwNNjTunPlkhXrBHmsS/J+mWmiH4jQRukDZpuj
         KPuA==
X-Gm-Message-State: ACrzQf0WFSNUdsR8IzpksEeYyOa3Js56RuUkvtu2kf1QMNSL/yNXYDsw
        4cebAbqz6w6MpQQ2N/5EYIrncBjEqbgH0Q==
X-Google-Smtp-Source: AMsMyM7TVFSFe/E8M7uuEyOspV+grHL9aUwOetIxrxvBgQeoXeGaOWsT4KSGVEm18ExfkDJAH46MCw==
X-Received: by 2002:a05:622a:cb:b0:39c:deaa:9c0a with SMTP id p11-20020a05622a00cb00b0039cdeaa9c0amr45234854qtw.417.1666946565121;
        Fri, 28 Oct 2022 01:42:45 -0700 (PDT)
Received: from dell-per730-23.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id br40-20020a05620a462800b006ec9f5e3396sm2510706qkb.72.2022.10.28.01.42.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 01:42:44 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Guillaume Nault <gnault@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv7 net-next 0/4] rtnetlink: Honour NLM_F_ECHO flag in rtnl_{new, del}link
Date:   Fri, 28 Oct 2022 04:42:20 -0400
Message-Id: <20221028084224.3509611-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
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

Netlink messages are used for communicating between user and kernel space.
When user space configures the kernel with netlink messages, it can set the
NLM_F_ECHO flag to request the kernel to send the applied configuration back
to the caller. This allows user space to retrieve configuration information
that are filled by the kernel (either because these parameters can only be
set by the kernel or because user space let the kernel choose a default
value).

The kernel has support this feature in some places like RTM_{NEW, DEL}ADDR,
RTM_{NEW, DEL}ROUTE. This patch set handles NLM_F_ECHO flag and send link
info back after rtnl_{new, del}link.

v7:
1) Fix unregister_netdevice_many() prototype warnning in patch 02

v6:
1) Rename pid to portid, make all nlh const
2) Re-order the portid, nlh parameter for each function
3) Do not add rtnl_configure_link_notify() warpper as Guillaume suggested.
   Just modify rtnl_configure_link() directly in patch 01. Also remove
   the rtmsg_ifinfo_nlh() wrapper.
4) Un-export unregister_netdevice_many_notify() in patch 02

v5:
1) Make rtnl_configure_link_notify static, reported by kernel test robot

v4:
1) Add rtnl_configure_link_notify() helper so rtnl_newlink_create could
   use it instead of creating new notify function.
2) Add unregister_netdevice_many_notify() helper so rtnl_delete_link()
   could use it instead of creating new notify function
3) Split the previous patch to 4 small patches for easier reviewing.

v3:
1) Fix group parameter in rtnl_notify.
2) Use helper rtmsg_ifinfo_build_skb() instead re-write a new one.

v2:
1) Rename rtnl_echo_link_info() to rtnl_link_notify().
2) Remove IFLA_LINK_NETNSID and IFLA_EXT_MASK, which do not fit here.
3) Add NLM_F_ECHO in rtnl_dellink. But we can't re-use the rtnl_link_notify()
   helper as we need to get the link info before rtnl_delete_link().

Hangbin Liu (4):
  rtnetlink: pass netlink message header and portid to
    rtnl_configure_link()
  net: add new helper unregister_netdevice_many_notify
  rtnetlink: Honour NLM_F_ECHO flag in rtnl_newlink_create
  rtnetlink: Honour NLM_F_ECHO flag in rtnl_delete_link

 drivers/net/can/vxcan.c        |  2 +-
 drivers/net/geneve.c           |  2 +-
 drivers/net/veth.c             |  2 +-
 drivers/net/vxlan/vxlan_core.c |  4 +--
 drivers/net/wwan/wwan_core.c   |  2 +-
 include/linux/netdevice.h      |  2 --
 include/linux/rtnetlink.h      |  9 ++++---
 include/net/netlink.h          | 11 ++++++++
 include/net/rtnetlink.h        |  5 ++--
 net/core/dev.c                 | 48 ++++++++++++++++++++--------------
 net/core/dev.h                 |  7 +++++
 net/core/rtnetlink.c           | 46 ++++++++++++++++++--------------
 net/ipv4/ip_gre.c              |  2 +-
 net/openvswitch/vport-geneve.c |  2 +-
 net/openvswitch/vport-gre.c    |  2 +-
 net/openvswitch/vport-netdev.c |  2 +-
 net/openvswitch/vport-vxlan.c  |  2 +-
 17 files changed, 91 insertions(+), 59 deletions(-)

-- 
2.37.3

