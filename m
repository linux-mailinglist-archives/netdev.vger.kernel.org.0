Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 630403AFD66
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 08:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231495AbhFVGyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 02:54:33 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:47241 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230092AbhFVGyY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 02:54:24 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 347935C00AA;
        Tue, 22 Jun 2021 02:52:08 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 22 Jun 2021 02:52:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=YIASq1/lFr7maTeBIAp2Lv3OG+VXgaE8WYS080/16Qo=; b=T73V6/xM
        xYV1kLQSSFnL1WOE1RvDTdoSMKoFgTsXjMkWSct8LcWAbECk2RkKOnwBGiuCy1LA
        h6icwxAiwTa+ofVt5x57p8G4MjJ+lDbVt59+MxwFbIe0e0eQpJhftZRoxO1Uk+cP
        tQkqNUwB1BYFiJ7bdGHzpMP2duq6+6vmkSv8hSSiC05e3374u/5w8hUgaxReEAnc
        1UjlPUISmDyFRJrhEzYVOdPcHP0ZTwJGc5pP5yt3/ViYsv5ocu5z7IcKYgb9A5ko
        MI2SQSkqPe783Zsgr/yjEhGgiJaN5Wukm3MsfwEKQPuloeDEumJwFccCF2+PAp9+
        49q3xIuvN+veDg==
X-ME-Sender: <xms:mIjRYLlPUoPeecYQGJEi7IpodY4Yq-CeqxAvGvydjhRzvZ9E0rYMfg>
    <xme:mIjRYO1DLhJCJv7ZSR1twaBjpJ4-X6ZWDy8Yub4BKxctsUMJ7Ae0Krwq7aQIaTq9P
    UEkTCnxZLq4bOg>
X-ME-Received: <xmr:mIjRYBoylmpsZ6EmFKsWkOToeweuvjtIRKV3qblrYdfiOG-me-dstsDsLiWyrwwc-THz6y5EOYwk9uvcE4mTSfYfwvvY40oo4ukZB3MaNX8FUg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeegtddguddufecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucevlhhushhtvghrufhiiigvpedunecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:mIjRYDkd0lNOYnmESDMWeS5hx_Wr-ZO_rytiV08kqE9dSZZwmquZuQ>
    <xmx:mIjRYJ1rhxHtQ6yO4dhU34l6hJVe9L3VRPsZTy1np3Wczu_jc0ZiHw>
    <xmx:mIjRYCt8-vy4zWaUeL6xnbpP39nRz7wF0Np6XzZVESewfWpjGb5Tig>
    <xmx:mIjRYDoVxyfkFIpclWLIRgLdj0EY5u2S1KXjj9xrxFnZ9dhJsuLeVw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 22 Jun 2021 02:52:06 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vladyslavt@nvidia.com, mkubecek@suse.cz, moshe@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 7/7] ethtool: Validate module EEPROM offset as part of policy
Date:   Tue, 22 Jun 2021 09:50:52 +0300
Message-Id: <20210622065052.2545107-8-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210622065052.2545107-1-idosch@idosch.org>
References: <20210622065052.2545107-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Validate the offset to read from module EEPROM as part of the netlink
policy and remove the corresponding check from the code.

This also makes it possible to query the offset range from user space:

 $ genl ctrl policy name ethtool
 ...
 ID: 0x14  policy[32]:attr[2]: type=U32 range:[0,255]
 ...

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/ethtool/eeprom.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/ethtool/eeprom.c b/net/ethtool/eeprom.c
index 1e75d9c1b154..7e6b37a54add 100644
--- a/net/ethtool/eeprom.c
+++ b/net/ethtool/eeprom.c
@@ -177,10 +177,6 @@ static int eeprom_parse_request(struct ethnl_req_info *req_info, struct nlattr *
 		NL_SET_ERR_MSG_ATTR(extack, tb[ETHTOOL_A_MODULE_EEPROM_LENGTH],
 				    "reading cross half page boundary is illegal");
 		return -EINVAL;
-	} else if (request->offset >= ETH_MODULE_EEPROM_PAGE_LEN * 2) {
-		NL_SET_ERR_MSG_ATTR(extack, tb[ETHTOOL_A_MODULE_EEPROM_OFFSET],
-				    "offset is out of bounds");
-		return -EINVAL;
 	} else if (request->offset + request->length > ETH_MODULE_EEPROM_PAGE_LEN * 2) {
 		NL_SET_ERR_MSG_ATTR(extack, tb[ETHTOOL_A_MODULE_EEPROM_LENGTH],
 				    "reading cross page boundary is illegal");
@@ -233,7 +229,8 @@ const struct ethnl_request_ops ethnl_module_eeprom_request_ops = {
 
 const struct nla_policy ethnl_module_eeprom_get_policy[] = {
 	[ETHTOOL_A_MODULE_EEPROM_HEADER]	= NLA_POLICY_NESTED(ethnl_header_policy),
-	[ETHTOOL_A_MODULE_EEPROM_OFFSET]	= { .type = NLA_U32 },
+	[ETHTOOL_A_MODULE_EEPROM_OFFSET]	=
+		NLA_POLICY_MAX(NLA_U32, ETH_MODULE_EEPROM_PAGE_LEN * 2 - 1),
 	[ETHTOOL_A_MODULE_EEPROM_LENGTH]	=
 		NLA_POLICY_RANGE(NLA_U32, 1, ETH_MODULE_EEPROM_PAGE_LEN),
 	[ETHTOOL_A_MODULE_EEPROM_PAGE]		= { .type = NLA_U8 },
-- 
2.31.1

