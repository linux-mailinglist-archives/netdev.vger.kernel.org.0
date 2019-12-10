Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1B7F118934
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 14:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727607AbfLJNIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 08:08:10 -0500
Received: from mx2.suse.de ([195.135.220.15]:49186 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727529AbfLJNIF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 08:08:05 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B08CCAC6F;
        Tue, 10 Dec 2019 13:08:03 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 5FFD5E00E0; Tue, 10 Dec 2019 14:08:03 +0100 (CET)
Message-Id: <45f719213b88920276cd825925db34a89b546b45.1575982069.git.mkubecek@suse.cz>
In-Reply-To: <cover.1575982069.git.mkubecek@suse.cz>
References: <cover.1575982069.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v2 3/5] ethtool: move to its own directory
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Date:   Tue, 10 Dec 2019 14:08:03 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ethtool netlink interface is going to be split into multiple files so
that it will be more convenient to put all of them in a separate directory
net/ethtool. Start by moving current ethtool.c with ioctl interface into
this directory and renaming it to ioctl.c.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 net/Makefile                            | 2 +-
 net/core/Makefile                       | 2 +-
 net/ethtool/Makefile                    | 3 +++
 net/{core/ethtool.c => ethtool/ioctl.c} | 0
 4 files changed, 5 insertions(+), 2 deletions(-)
 create mode 100644 net/ethtool/Makefile
 rename net/{core/ethtool.c => ethtool/ioctl.c} (100%)

diff --git a/net/Makefile b/net/Makefile
index 449fc0b221f8..848303d98d3d 100644
--- a/net/Makefile
+++ b/net/Makefile
@@ -13,7 +13,7 @@ obj-$(CONFIG_NET)		+= $(tmp-y)
 
 # LLC has to be linked before the files in net/802/
 obj-$(CONFIG_LLC)		+= llc/
-obj-$(CONFIG_NET)		+= ethernet/ 802/ sched/ netlink/ bpf/
+obj-$(CONFIG_NET)		+= ethernet/ 802/ sched/ netlink/ bpf/ ethtool/
 obj-$(CONFIG_NETFILTER)		+= netfilter/
 obj-$(CONFIG_INET)		+= ipv4/
 obj-$(CONFIG_TLS)		+= tls/
diff --git a/net/core/Makefile b/net/core/Makefile
index a104dc8faafc..3e2c378e5f31 100644
--- a/net/core/Makefile
+++ b/net/core/Makefile
@@ -8,7 +8,7 @@ obj-y := sock.o request_sock.o skbuff.o datagram.o stream.o scm.o \
 
 obj-$(CONFIG_SYSCTL) += sysctl_net_core.o
 
-obj-y		     += dev.o ethtool.o dev_addr_lists.o dst.o netevent.o \
+obj-y		     += dev.o dev_addr_lists.o dst.o netevent.o \
 			neighbour.o rtnetlink.o utils.o link_watch.o filter.o \
 			sock_diag.o dev_ioctl.o tso.o sock_reuseport.o \
 			fib_notifier.o xdp.o flow_offload.o
diff --git a/net/ethtool/Makefile b/net/ethtool/Makefile
new file mode 100644
index 000000000000..3ebfab2bca66
--- /dev/null
+++ b/net/ethtool/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0
+
+obj-y		+= ioctl.o
diff --git a/net/core/ethtool.c b/net/ethtool/ioctl.c
similarity index 100%
rename from net/core/ethtool.c
rename to net/ethtool/ioctl.c
-- 
2.24.0

