Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA0C60EE36
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 04:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233817AbiJ0C7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 22:59:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234075AbiJ0C7u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 22:59:50 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A06B14B487
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 19:59:48 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id g24so73661plq.3
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 19:59:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pTcwFlToppXQeEyLbS7R4VGKWUp+HRts3qdg5PARQ7g=;
        b=MtIJM5k9/FmMMDohDsnsbb8NdQGccLoooYi4pxQxZNS6gHPOM4pPy8NqFAlP6mWOqa
         PRXmRNwsBEBKXOIAedZGAd+VpMR0EBwQKggQ2+IquQeew7IGm0RjbrbFkFMFUtuG7F3C
         0EW8XnQDajieWLsALLx5/hVCAfK/aTIMLH+67bK2bKakvdYz4JfMlwDI7m7akmGDzbGJ
         5x3eSql0E/e+JmKkrR4NU+Nx8hltjdx+B78L3wYRQ6RSvqtDbBCry8B8dRanoX+q+c/M
         IB5iMQKXVs8qrjxtqJ0+OlBFVpUsKi+3z3t23NiYpHHWw0bD2BXjhCYBmvjipqs7S9Dt
         X0BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pTcwFlToppXQeEyLbS7R4VGKWUp+HRts3qdg5PARQ7g=;
        b=lHE4gCv8Brm8j+mPQf3iUR6GwEjM20H80Y3ItdmR2AWH+wd40C6amU9sYpr1311Mhf
         tAwkvCnxLyAUHoS1u3H9U1CemJxP+EXngHFyOjSeEG2dkaGPQ/xt9zdrsMAWYDbHTRKN
         qGpNfP9I+SFOygoQ2DHFsuz/8aZfEbSfkMw5BRqKHVXz8mmc9bJbGjQ1mJzNSqE5Qfpp
         poGr++u86cSZRcaFDnRIiXWN+Xu9zSWAPHjcfJQVJSTXxQ38kexBI07YLxduUbG6LpzW
         f6hIlviD30eMyvPp2pOCulIK7AtvOMNmBDY1ZVxDbGDx1nH6QDQssf1kfEkOXd+TsU1F
         +F5g==
X-Gm-Message-State: ACrzQf3Eg10H89fTDzTacwtDIEQirSUysE47BGg7b0znErYkMJCaDxsi
        c91FSNKS7zEH33oKrfoB2rgPDRDnyfCY4g==
X-Google-Smtp-Source: AMsMyM4pUJcgBONUeoNqD008IsFtXYcTaj7NNFwCvV0XCujcUf2UUEfLd2nSNQAowSbdDAegNpRdVw==
X-Received: by 2002:a17:902:d483:b0:182:cb98:26e8 with SMTP id c3-20020a170902d48300b00182cb9826e8mr47252435plg.73.1666839587888;
        Wed, 26 Oct 2022 19:59:47 -0700 (PDT)
Received: from localhost.localdomain ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id ix6-20020a170902f80600b0017f756563bcsm54488plb.47.2022.10.26.19.59.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 19:59:47 -0700 (PDT)
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
Subject: [PATCHv6 net-next 0/4] rtnetlink: Honour NLM_F_ECHO flag in rtnl_{new, del}link
Date:   Thu, 27 Oct 2022 10:57:22 +0800
Message-Id: <20221027025726.2138619-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.37.3
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
 net/core/dev.c                 | 36 ++++++++++++++++----------
 net/core/dev.h                 |  7 ++++++
 net/core/rtnetlink.c           | 46 +++++++++++++++++++---------------
 net/ipv4/ip_gre.c              |  2 +-
 net/openvswitch/vport-geneve.c |  2 +-
 net/openvswitch/vport-gre.c    |  2 +-
 net/openvswitch/vport-netdev.c |  2 +-
 net/openvswitch/vport-vxlan.c  |  2 +-
 17 files changed, 86 insertions(+), 52 deletions(-)

-- 
2.37.3

