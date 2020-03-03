Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE8AF176E5C
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 06:06:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726079AbgCCFFp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 00:05:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:37596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726083AbgCCFFo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 00:05:44 -0500
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 994C12465A;
        Tue,  3 Mar 2020 05:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583211943;
        bh=lHh4Ocf0j25mBc4t69P8IUwFi7BqiXsbqC/YkEo016E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YNsgZm5wdNYwmFdpWTzQ9O5GoNNZeeFg5DvBAZUW8gIIWWsKl9qPBSoobS7+x+cd4
         6PoPqpqWYFiX6rAZaULQ2k9EbVrDJK/cGAqZ4n1IZIaOP2MepFp6Angcbdnw5LpXKn
         PqLpndkS8WreSS25TWY2RO3lwJrT4wwLRMmBNAYs=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>, dev@openvswitch.org
Subject: [PATCH net 08/16] openvswitch: add missing attribute validation for hash
Date:   Mon,  2 Mar 2020 21:05:18 -0800
Message-Id: <20200303050526.4088735-9-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200303050526.4088735-1-kuba@kernel.org>
References: <20200303050526.4088735-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing attribute validation for OVS_PACKET_ATTR_HASH
to the netlink policy.

Fixes: bd1903b7c459 ("net: openvswitch: add hash info to upcall")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: Pravin B Shelar <pshelar@ovn.org>
CC: Tonghao Zhang <xiangxia.m.yue@gmail.com>
CC: dev@openvswitch.org
---
 net/openvswitch/datapath.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index c047afd12116..07a7dd185995 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -645,6 +645,7 @@ static const struct nla_policy packet_policy[OVS_PACKET_ATTR_MAX + 1] = {
 	[OVS_PACKET_ATTR_ACTIONS] = { .type = NLA_NESTED },
 	[OVS_PACKET_ATTR_PROBE] = { .type = NLA_FLAG },
 	[OVS_PACKET_ATTR_MRU] = { .type = NLA_U16 },
+	[OVS_PACKET_ATTR_HASH] = { .type = NLA_U64 },
 };
 
 static const struct genl_ops dp_packet_genl_ops[] = {
-- 
2.24.1

