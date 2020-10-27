Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A10AF29B396
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 15:56:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1780060AbgJ0Oxn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 10:53:43 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:45929 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1774148AbgJ0OwC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 10:52:02 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id A1A40177E;
        Tue, 27 Oct 2020 10:52:01 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 27 Oct 2020 10:52:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=glr1dXXy1jKXTu4jt+ehlrOdCqohnKeGhVTZndL7yHc=; b=mfThyfPU
        /GWs+OwyyXDiFH44weGjCILxp/F8Axj+Xky7wb/BsFTyklzTvzoU2xuMaQzR+1eW
        qo6O7FIxzoACTWGpqkgZCONtgytequpJ8WxsvcP1yAFY26LDSBsDXseJjrJ6DUeu
        1Mo/YhRNkz1MGsS71A4f0ugl727xp3Sz7UgVxTDxBI5pAnS5VHWkLluu90uiREcL
        SegqRd6+YOsrUvHtCs133fLIQelIBfVp3UUd5r/EOe9NLDvOzXRcbzDvwms7Rbxq
        cvDv5jX9KS9JE40OqUeWLDL8iTlUaunvDVfIrRh/e2xsf9IpNIZucddX2pJOc/Ts
        42C0hXuDKD21UA==
X-ME-Sender: <xms:ETSYX3GVHObPcSFXrjOGPjsYw8R03lDzCtSTJCRcosQbH4WBvy_Ppg>
    <xme:ETSYX0VDkbKjcHbLTmR_Nq6bTMaq7zIEHIRc4Zf67piAaBGnmdg9IS0MUGyMEGHtc
    dLJLuSIeffkDxE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrkeelgdeilecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheefrdelnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:ETSYX5L6RVuS2cFoZs-ENHkpCzMT8gMd9wI5wsGmGqw22GHsm6hCIQ>
    <xmx:ETSYX1FIZptCyxP2Gc9odXZn74PbJGuX4LCuUY1Rw-9l6btDPbbzoA>
    <xmx:ETSYX9VUdTTSxlvfyNbjKyDQ1Z8QH_vvFRiY0bT-pPBue886SOvE8Q>
    <xmx:ETSYX7cYpVzexsYRGZaDXLx4FfV3OmqTtc3HxPsUP3GCBDAlFt4ELQ>
Received: from shredder.mtl.com (igld-84-229-153-9.inter.net.il [84.229.153.9])
        by mail.messagingengine.com (Postfix) with ESMTPA id 07D9A3280064;
        Tue, 27 Oct 2020 10:51:58 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, mkubecek@suse.cz,
        f.fainelli@gmail.com, andrew@lunn.ch, David.Laight@aculab.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH ethtool 2/2] netlink: Set 'ETHTOOL_FLAG_LEGACY' for compatibility with legacy ioctl interface
Date:   Tue, 27 Oct 2020 16:51:47 +0200
Message-Id: <20201027145147.227053-3-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201027145147.227053-1-idosch@idosch.org>
References: <20201027145147.227053-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Set the above mentioned flag in the ethtool netlink request header of
the various commands mapped to 'ethtool set' (e.g.,
'ETHTOOL_MSG_LINKMODES_SET').

The purpose of the flag is to indicate to the kernel to be compatible
with legacy ioctl interface. The current use case is to ensure that the
kernel will advertise all the supported link modes when autoneg is
enabled, but without specifying other parameters.

To prevent the kernel from complaining about unknown flags, the flag is
only set in the request header in case the kernel supports it. This is
achieved by using the recently introduced per-operation policy dump
infrastructure.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 netlink/netlink.c | 13 +++++++++++++
 netlink/netlink.h |  2 ++
 netlink/parser.c  |  5 ++++-
 3 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/netlink/netlink.c b/netlink/netlink.c
index f655f6ea25b7..11c5a639f381 100644
--- a/netlink/netlink.c
+++ b/netlink/netlink.c
@@ -289,6 +289,19 @@ u32 get_stats_flag(struct nl_context *nlctx, unsigned int nlcmd,
 	return nlctx->ops_info[nlcmd].hdr_flags & ETHTOOL_FLAG_STATS;
 }
 
+u32 get_legacy_flag(struct nl_context *nlctx, unsigned int nlcmd,
+		    unsigned int hdrattr)
+{
+	if (nlcmd > ETHTOOL_MSG_USER_MAX ||
+	    !(nlctx->ops_info[nlcmd].op_flags & GENL_CMD_CAP_HASPOL))
+		return 0;
+
+	if (read_flags_policy(nlctx, nlctx->ethnl_socket, nlcmd, hdrattr) < 0)
+		return 0;
+
+	return nlctx->ops_info[nlcmd].hdr_flags & ETHTOOL_FLAG_LEGACY;
+}
+
 /* initialization */
 
 static int genl_read_ops(struct nl_context *nlctx,
diff --git a/netlink/netlink.h b/netlink/netlink.h
index c02558540218..97a1e72ff930 100644
--- a/netlink/netlink.h
+++ b/netlink/netlink.h
@@ -74,6 +74,8 @@ const char *get_dev_name(const struct nlattr *nest);
 int get_dev_info(const struct nlattr *nest, int *ifindex, char *ifname);
 u32 get_stats_flag(struct nl_context *nlctx, unsigned int nlcmd,
 		   unsigned int hdrattr);
+u32 get_legacy_flag(struct nl_context *nlctx, unsigned int nlcmd,
+		    unsigned int hdrattr);
 
 int linkmodes_reply_cb(const struct nlmsghdr *nlhdr, void *data);
 int linkinfo_reply_cb(const struct nlmsghdr *nlhdr, void *data);
diff --git a/netlink/parser.c b/netlink/parser.c
index 3b25f5d5a88e..7d4d51235628 100644
--- a/netlink/parser.c
+++ b/netlink/parser.c
@@ -996,6 +996,7 @@ int nl_parser(struct nl_context *nlctx, const struct param_parser *params,
 	for (parser = params; parser->arg; parser++) {
 		struct nl_msg_buff *msgbuff;
 		struct nlattr *nest;
+		u32 flags;
 
 		n_params++;
 		if (group_style == PARSER_GROUP_NONE || !parser->group)
@@ -1018,9 +1019,11 @@ int nl_parser(struct nl_context *nlctx, const struct param_parser *params,
 				goto out_free_buffs;
 			break;
 		case PARSER_GROUP_MSG:
+			flags = get_legacy_flag(nlctx, parser->group,
+						ETHTOOL_A_LINKINFO_HEADER);
 			if (ethnla_fill_header(msgbuff,
 					       ETHTOOL_A_LINKINFO_HEADER,
-					       nlctx->devname, 0))
+					       nlctx->devname, flags))
 				goto out_free_buffs;
 			break;
 		default:
-- 
2.26.2

