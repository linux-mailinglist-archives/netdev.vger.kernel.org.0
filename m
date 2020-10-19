Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D57E293085
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 23:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733099AbgJSVct (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 17:32:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:41494 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733061AbgJSVcs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 17:32:48 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2995CAC2F;
        Mon, 19 Oct 2020 21:32:47 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id E572560563; Mon, 19 Oct 2020 23:32:46 +0200 (CEST)
Message-Id: <95db276533bc46dca9337a7aa37a85b7f846741f.1603142897.git.mkubecek@suse.cz>
In-Reply-To: <cover.1603142897.git.mkubecek@suse.cz>
References: <cover.1603142897.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool 3/4] netlink: add descriptions for genetlink policy
 dumps
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>
Date:   Mon, 19 Oct 2020 23:32:46 +0200 (CEST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add GENL_ID_CTRL message descriptions for messages and attributes used
for policy dumps.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 netlink/desc-genlctrl.c | 57 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/netlink/desc-genlctrl.c b/netlink/desc-genlctrl.c
index 9840179b0a1a..43b41ab395b8 100644
--- a/netlink/desc-genlctrl.c
+++ b/netlink/desc-genlctrl.c
@@ -29,6 +29,59 @@ static const struct pretty_nla_desc __mcgrps_desc[] = {
 	NLATTR_DESC_NESTED(0, mcgrp),
 };
 
+static const char *__policy_attr_type_names[] = {
+	[NL_ATTR_TYPE_INVALID]		= "NL_ATTR_TYPE_INVALID",
+	[NL_ATTR_TYPE_FLAG]		= "NL_ATTR_TYPE_FLAG",
+	[NL_ATTR_TYPE_U8]		= "NL_ATTR_TYPE_U8",
+	[NL_ATTR_TYPE_U16]		= "NL_ATTR_TYPE_U16",
+	[NL_ATTR_TYPE_U32]		= "NL_ATTR_TYPE_U32",
+	[NL_ATTR_TYPE_U64]		= "NL_ATTR_TYPE_U64",
+	[NL_ATTR_TYPE_S8]		= "NL_ATTR_TYPE_S8",
+	[NL_ATTR_TYPE_S16]		= "NL_ATTR_TYPE_S16",
+	[NL_ATTR_TYPE_S32]		= "NL_ATTR_TYPE_S32",
+	[NL_ATTR_TYPE_S64]		= "NL_ATTR_TYPE_S64",
+	[NL_ATTR_TYPE_BINARY]		= "NL_ATTR_TYPE_BINARY",
+	[NL_ATTR_TYPE_STRING]		= "NL_ATTR_TYPE_STRING",
+	[NL_ATTR_TYPE_NUL_STRING]	= "NL_ATTR_TYPE_NUL_STRING",
+	[NL_ATTR_TYPE_NESTED]		= "NL_ATTR_TYPE_NESTED",
+	[NL_ATTR_TYPE_NESTED_ARRAY]	= "NL_ATTR_TYPE_NESTED_ARRAY",
+	[NL_ATTR_TYPE_BITFIELD32]	= "NL_ATTR_TYPE_BITFIELD32",
+};
+
+static const struct pretty_nla_desc __policy_attr_desc[] = {
+	NLATTR_DESC_INVALID(NL_POLICY_TYPE_ATTR_UNSPEC),
+	NLATTR_DESC_U32_ENUM(NL_POLICY_TYPE_ATTR_TYPE, policy_attr_type),
+	NLATTR_DESC_S64(NL_POLICY_TYPE_ATTR_MIN_VALUE_S),
+	NLATTR_DESC_S64(NL_POLICY_TYPE_ATTR_MAX_VALUE_S),
+	NLATTR_DESC_U64(NL_POLICY_TYPE_ATTR_MIN_VALUE_U),
+	NLATTR_DESC_U64(NL_POLICY_TYPE_ATTR_MAX_VALUE_U),
+	NLATTR_DESC_U32(NL_POLICY_TYPE_ATTR_MIN_LENGTH),
+	NLATTR_DESC_U32(NL_POLICY_TYPE_ATTR_MAX_LENGTH),
+	NLATTR_DESC_U32(NL_POLICY_TYPE_ATTR_POLICY_IDX),
+	NLATTR_DESC_U32(NL_POLICY_TYPE_ATTR_POLICY_MAXTYPE),
+	NLATTR_DESC_X32(NL_POLICY_TYPE_ATTR_BITFIELD32_MASK),
+	NLATTR_DESC_X64(NL_POLICY_TYPE_ATTR_PAD),
+	NLATTR_DESC_BINARY(NL_POLICY_TYPE_ATTR_MASK),
+};
+
+static const struct pretty_nla_desc __policy_attrs_desc[] = {
+	NLATTR_DESC_NESTED(0, policy_attr),
+};
+
+static const struct pretty_nla_desc __policies_desc[] = {
+	NLATTR_DESC_ARRAY(0, policy_attrs),
+};
+
+static const struct pretty_nla_desc __op_policy_desc[] = {
+	NLATTR_DESC_INVALID(CTRL_ATTR_POLICY_UNSPEC),
+	NLATTR_DESC_U32(CTRL_ATTR_POLICY_DO),
+	NLATTR_DESC_U32(CTRL_ATTR_POLICY_DUMP),
+};
+
+static const struct pretty_nla_desc __op_policies_desc[] = {
+	NLATTR_DESC_NESTED(0, op_policy),
+};
+
 static const struct pretty_nla_desc __attr_desc[] = {
 	NLATTR_DESC_INVALID(CTRL_ATTR_UNSPEC),
 	NLATTR_DESC_U16(CTRL_ATTR_FAMILY_ID),
@@ -38,6 +91,9 @@ static const struct pretty_nla_desc __attr_desc[] = {
 	NLATTR_DESC_U32(CTRL_ATTR_MAXATTR),
 	NLATTR_DESC_ARRAY(CTRL_ATTR_OPS, attrops),
 	NLATTR_DESC_ARRAY(CTRL_ATTR_MCAST_GROUPS, mcgrps),
+	NLATTR_DESC_ARRAY(CTRL_ATTR_POLICY, policies),
+	NLATTR_DESC_ARRAY(CTRL_ATTR_OP_POLICY, op_policies),
+	NLATTR_DESC_U32(CTRL_ATTR_OP),
 };
 
 const struct pretty_nlmsg_desc genlctrl_msg_desc[] = {
@@ -51,6 +107,7 @@ const struct pretty_nlmsg_desc genlctrl_msg_desc[] = {
 	NLMSG_DESC(CTRL_CMD_NEWMCAST_GRP, attr),
 	NLMSG_DESC(CTRL_CMD_DELMCAST_GRP, attr),
 	NLMSG_DESC(CTRL_CMD_GETMCAST_GRP, attr),
+	NLMSG_DESC(CTRL_CMD_GETPOLICY, attr),
 };
 
 const unsigned int genlctrl_msg_n_desc = ARRAY_SIZE(genlctrl_msg_desc);
-- 
2.28.0

