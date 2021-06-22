Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65B3F3AFD62
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 08:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbhFVGyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 02:54:19 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:39955 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230130AbhFVGyP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 02:54:15 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id B835C5C00D8;
        Tue, 22 Jun 2021 02:51:59 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 22 Jun 2021 02:51:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=lhUE0Q0hNAJZAVofoMYrwd8GAGbuGnNi4m6DI0mM4Fc=; b=XEVWEY3a
        oI0yVm7CKp+KLBuOwi4iwb2OgZY2z2lWueqKvOCMY3ThN2H1dnFTxPd7AGm/RhIm
        3V2PMZq4s8sqEAYdUyZDvQ3nWq+r4PxYhYphXSio9Ttoo1zoPbVhJpxPRufqdsI7
        jEl1YM6WiPp5socOUZ35uZm4KUSymKBrbbGzzwK+DZrUWJBOO0gDhgYV1v+VVxZn
        8p41v+I1Ar8TjfhMbD/FaXnRm3RUUUAuDUidgxIIuwHoni2oVCrfPS+b+QOc5Fyg
        KouscLPc03DgnDJzDzWJcSfSB6WfeHE6b0E0QWq/0+8YhrbO+AHaeEmWIsW+hgI6
        8+4YlFVfY68etw==
X-ME-Sender: <xms:j4jRYJE9-l4jZ3vmE1Wc6DGhJmAwZan0clpoxYRgXXwg2fnpXuBBBA>
    <xme:j4jRYOWYfgshVzmaTX3EBG-hrKZBiCnKYgSRMDUi5_UtCNNqm-gZlt9EqIkk31sFu
    mURG1aXfLWLAxY>
X-ME-Received: <xmr:j4jRYLIvwSKV6d0OR9M9gvwek_c3S4e0XNpf7As1ZrYEjwSjo_EDvIauXXZMpWm49l_EAuyeHdZqzly2oSeNCUEWtMk8tMDMq77BDz0iF6-O4Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeegtddguddufecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucevlhhushhtvghrufhiiigvpedtnecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:j4jRYPGmFvbQpTh526DmzV9XqjS9othsZGyPOURKnl9rNUQKy3JOTg>
    <xmx:j4jRYPVeEUL5OzTJKRb8m7WGpSmG1MGE_2HfBbursTW0Sx08K-y3zw>
    <xmx:j4jRYKMoeD3hIdmqUl9dwCpLlwLZR8bVjeRdk68fko57c5cmcdrJvg>
    <xmx:j4jRYBIpJgPsliWXK_eFC__sdD5gq4ZcssSegpctXDMfhT77EIyYDg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 22 Jun 2021 02:51:57 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vladyslavt@nvidia.com, mkubecek@suse.cz, moshe@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 3/7] ethtool: Decrease size of module EEPROM get policy array
Date:   Tue, 22 Jun 2021 09:50:48 +0300
Message-Id: <20210622065052.2545107-4-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210622065052.2545107-1-idosch@idosch.org>
References: <20210622065052.2545107-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The 'ETHTOOL_A_MODULE_EEPROM_DATA' attribute is not part of the get
request.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/ethtool/netlink.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 90b10966b16b..3e25a47fd482 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -380,7 +380,7 @@ extern const struct nla_policy ethnl_cable_test_tdr_act_policy[ETHTOOL_A_CABLE_T
 extern const struct nla_policy ethnl_tunnel_info_get_policy[ETHTOOL_A_TUNNEL_INFO_HEADER + 1];
 extern const struct nla_policy ethnl_fec_get_policy[ETHTOOL_A_FEC_HEADER + 1];
 extern const struct nla_policy ethnl_fec_set_policy[ETHTOOL_A_FEC_AUTO + 1];
-extern const struct nla_policy ethnl_module_eeprom_get_policy[ETHTOOL_A_MODULE_EEPROM_DATA + 1];
+extern const struct nla_policy ethnl_module_eeprom_get_policy[ETHTOOL_A_MODULE_EEPROM_I2C_ADDRESS + 1];
 extern const struct nla_policy ethnl_stats_get_policy[ETHTOOL_A_STATS_GROUPS + 1];
 
 int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info);
-- 
2.31.1

