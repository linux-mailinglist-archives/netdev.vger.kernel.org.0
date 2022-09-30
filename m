Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBB485F056E
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 09:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbiI3HAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 03:00:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230346AbiI3HA2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 03:00:28 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC2E9642C0
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 00:00:10 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id f23so3217673plr.6
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 00:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=JJxi3Y+/VA8x+wlRxXomkh/ESouc72lf+l299FCiNRA=;
        b=oCffqG/y0I2yiGLAzcFelFs5hhkcybcevC0n6u098/yoBpBsc3HRNotgJ99v3KdkHe
         Ro8F9cnjlyRG4JVNBVO0V37asBerA9ptpjh7VUKTMrWV+abWJDWhcZidGRsJiRvAJnCg
         nglJYOPpjxNfB9aUmG4eJHCeVix4Afp/a3L9jyZl/r4MJHRRzGtu8GXXcYhzjRTi7kMX
         RQUROUqtO2KkoDk4P2ogoTXuNrXa3se1IUvr3APC1+HjcpINy2BTD/xSCjEj1OdsN/vK
         RSu8+w6gvT9S+HrS4RmSZzuUPwUzcZ4jthQtQUP1mbQ58wWeF3v2SKrD91wI4Z8fu26O
         9ddQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=JJxi3Y+/VA8x+wlRxXomkh/ESouc72lf+l299FCiNRA=;
        b=OrpE8OZZaeVF1PgP08k792EeJsGgw6Tqv6dr9dZa+royl5nCtXFAn2QLmrSjg1GZs+
         cF4eWTSinwgVBUI7GAAcp0xKJExBdsp45gr8uYKXhrTSX5ktVwfhd8asF9cqrx75NwH6
         gaft9DDbMokCb2WR2FQJYlbp+e2ds+YdQKVNxNgPk6U++Dipw57RgLmS1oRpzG1j4BG6
         vcYJ4hirjAF3f3wfmDPlPYm9HKzDI3fgx6yqo4uz8au9cZ0jUgP/dixbNiv3I8ahh1sp
         qRpDyD1s7c4UYaq4YyCbMw/pxYrPuWYedgp01AyNvu5HwR06QbawOmofb1Zw9MCJIUWR
         /3hQ==
X-Gm-Message-State: ACrzQf1y1S5Zg2oRx6OSYV3I9dmj86e03C8xRlJmnJR49Y/pVSR1dTlA
        riYwIMCoMoT9APgScPRzT1aIQBzkiZweww==
X-Google-Smtp-Source: AMsMyM7ADdcM0SHwE2a38KeAEv8b9jZaY2Phz+NaqpGGKQ23ayK+M/QBhQejE2ut41aapGssfxK94A==
X-Received: by 2002:a17:902:cf12:b0:179:fafd:8a1c with SMTP id i18-20020a170902cf1200b00179fafd8a1cmr7649452plg.102.1664521209682;
        Fri, 30 Sep 2022 00:00:09 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id j13-20020a63594d000000b0041c0c9c0072sm998268pgm.64.2022.09.30.00.00.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 00:00:09 -0700 (PDT)
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
Subject: [PATCHv4 net-next 0/4] rtnetlink: Honour NLM_F_ECHO flag in rtnl_{new, del}link
Date:   Fri, 30 Sep 2022 14:59:53 +0800
Message-Id: <20220930065957.694263-1-liuhangbin@gmail.com>
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

