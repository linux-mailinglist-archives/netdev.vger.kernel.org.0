Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDC585F07E3
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 11:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbiI3Jpd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 05:45:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231445AbiI3Jp1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 05:45:27 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F578491CC
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 02:45:15 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id n7so3540008plp.1
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 02:45:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=4mAI4Ej0zOxef3nZFQdDr6305y7yPdxBfrhrgZcPAZs=;
        b=fLqSUElvRwwXzsLcEBYD585IPmUU1W3Sh9rNO9UdG/8LU0pdjoE4IcKCgqyrBO+N+J
         Mi6DsABOCKLie6geHYCNX3/y9hT32eQKHGlETPL+7DcOWe63WMOd/w3/ezbYbwEnqM6D
         9eqGNwWpt28IveSPaSUwRnGZ3BeTqBZo9nVAqsADItP1HZKqzdOv3j0ofLGzpXfzxsWF
         fvcG0PCcY6fmfoSL4dD2u9F+zCRLbLuXehd8ZP/ZfEInDTGZZXHjEhIjbefmWs4/Ncku
         OesxO1LaEYbjIqFM2sONodwWpKzdog+OvAVsSsdqawkeYXKseWmEOkuWfZsZktYEliV7
         gdmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=4mAI4Ej0zOxef3nZFQdDr6305y7yPdxBfrhrgZcPAZs=;
        b=0gkhDcqawzPD3YWambCt8PYe66WILExFlcOlDEcWNbZwI5eHaULL/rpo14v2RZHARU
         JzWDAZdH/NHvEs7RUYskEwA/b5pSdygaAIyY9JjDmhLOFTOxPWYjl+r+jn8xx002Yq2h
         iHkURsnHnZvDovCNI9rXEit1tVaqYMqtcnvkZyDWYkAYI627OJp+nrr/a+4fT/YPqVwo
         YlPSlOIT3i1/pK5BfMfw0TE+d+HgkV1ogTsc3zLUTcDFOWf4lFhmd/mD1RJO797npy8X
         SGc6GLDfDSb/dDmIzyGboxSNXDvWuWZJVRMf1rR1gs3yz0Y+6gqUWKqajKQm6KTTxcNJ
         GIJw==
X-Gm-Message-State: ACrzQf0m/l6WS+ekXDOFqwmL89NWt0nkQZnItEhzUDktVyZQs+mSHexD
        ksjRn/Aj1FkpyNMZT5w+EhlOb35Dx4R1QA==
X-Google-Smtp-Source: AMsMyM7a79+b9fgDu5kXqEn7u7YMrNz/Nlqg+ArXhc2NrLRKEfZdFeBvkbk/+6fcL2zcFViG8aP+og==
X-Received: by 2002:a17:90a:3f89:b0:205:a54e:2db8 with SMTP id m9-20020a17090a3f8900b00205a54e2db8mr8514488pjc.36.1664531114067;
        Fri, 30 Sep 2022 02:45:14 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id c28-20020aa7953c000000b0054d1a2ee8cfsm1305187pfp.103.2022.09.30.02.45.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 02:45:13 -0700 (PDT)
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
Subject: [PATCHv5 net-next 0/4] rtnetlink: Honour NLM_F_ECHO flag in rtnl_{new, del}link
Date:   Fri, 30 Sep 2022 17:45:02 +0800
Message-Id: <20220930094506.712538-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.37.2
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

v5:
1) make rtnl_configure_link_notify static, reported by kernel test robot

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
  rtnetlink: add new helper rtnl_configure_link_notify()
  net: add new helper unregister_netdevice_many_notify
  rtnetlink: Honour NLM_F_ECHO flag in rtnl_newlink_create
  rtnetlink: Honour NLM_F_ECHO flag in rtnl_delete_link

 include/linux/netdevice.h      |  4 ++-
 include/linux/rtnetlink.h      |  6 ++--
 include/net/rtnetlink.h        |  2 +-
 net/core/dev.c                 | 26 +++++++++++-----
 net/core/rtnetlink.c           | 56 ++++++++++++++++++++++------------
 net/openvswitch/vport-geneve.c |  2 +-
 net/openvswitch/vport-gre.c    |  2 +-
 net/openvswitch/vport-netdev.c |  2 +-
 net/openvswitch/vport-vxlan.c  |  2 +-
 9 files changed, 67 insertions(+), 35 deletions(-)

-- 
2.37.2

