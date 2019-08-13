Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEC488B284
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 10:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728160AbfHMIcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 04:32:13 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:44597 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727429AbfHMIcN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 04:32:13 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 2504220D89;
        Tue, 13 Aug 2019 04:32:12 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 13 Aug 2019 04:32:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=wfk+XngqiqUX8mjI3BiNTyF0bmlF0weAhefsYI0DX5Y=; b=DYCHXfxU
        xiy+EoEeNa555Dxr03J13BN2n7KCqhIaZ/B9obIMDYgE7c5IeiEjSWJ5ms91C9nl
        spr/LbJcRdYAJ7F8wBM4EAMXnB+DXIEkApaoufMM1NFhXobSHBkp4lyoILeNRewB
        0hUeqt2jUwas3YjsMclzxLgi38x2PNPU7TSEocAaQ+JKMmSK8gSmDB8AZBL+F0LR
        jnR4zQBd9fIjIdN8snUQTP5VwIH93hHTKi6BrLJ+nn+d3n3ZCHwFq3ve2uvrmZhq
        B6HNjvRPEgR3FtZLPdGFMnjA4B17zUYhg+RBEqFw6v3jivenP++5fw/UkQ2rntL8
        +BQ2ch75PB/AqQ==
X-ME-Sender: <xms:i3VSXYh11OVPA7JudU9zEHLDveTtg6bLOONUexc4XQLXTn1cJKK5EA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddviedgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:jHVSXYEAEybesaKRcp1XjGi9yYNvcegHCJas7v_FfK7QX_fTBtk92A>
    <xmx:jHVSXUXOrSwrfoJFYHelqn-hnbLs8Kf4mRnb2Q1sqkz7J01RVRYdRg>
    <xmx:jHVSXcCtc7vYUL1TjbTrLE93ikchtXPQuvgHmsqoxFFDFBHHhTFmTg>
    <xmx:jHVSXehDZi_atg22zNkB85TWclgAcgIymUNgQOYu1ToSNIYqocB3sw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id B26D18005B;
        Tue, 13 Aug 2019 04:32:09 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH iproute2-next v2 1/4] devlink: Increase number of supported options
Date:   Tue, 13 Aug 2019 11:31:40 +0300
Message-Id: <20190813083143.13509-2-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190813083143.13509-1-idosch@idosch.org>
References: <20190813083143.13509-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Currently, the number of supported options is capped at 32 which is a
problem given we are about to add a few more and go over the limit.

Increase the limit to 64 options.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 devlink/devlink.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 91c85dc1de73..4ed240e251f5 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -235,7 +235,7 @@ static void ifname_map_free(struct ifname_map *ifname_map)
 #define DL_OPT_HEALTH_REPORTER_AUTO_RECOVER	BIT(28)
 
 struct dl_opts {
-	uint32_t present; /* flags of present items */
+	uint64_t present; /* flags of present items */
 	char *bus_name;
 	char *dev_name;
 	uint32_t port_index;
@@ -735,7 +735,7 @@ static int dl_argv_handle_port(struct dl *dl, char **p_bus_name,
 
 static int dl_argv_handle_both(struct dl *dl, char **p_bus_name,
 			       char **p_dev_name, uint32_t *p_port_index,
-			       uint32_t *p_handle_bit)
+			       uint64_t *p_handle_bit)
 {
 	char *str = dl_argv_next(dl);
 	unsigned int slash_count;
@@ -1015,7 +1015,7 @@ static int param_cmode_get(const char *cmodestr,
 }
 
 struct dl_args_metadata {
-	uint32_t o_flag;
+	uint64_t o_flag;
 	char err_msg[DL_ARGS_REQUIRED_MAX_ERR_LEN];
 };
 
@@ -1042,10 +1042,10 @@ static const struct dl_args_metadata dl_args_required[] = {
 	{DL_OPT_HEALTH_REPORTER_NAME, "Reporter's name is expected."},
 };
 
-static int dl_args_finding_required_validate(uint32_t o_required,
-					     uint32_t o_found)
+static int dl_args_finding_required_validate(uint64_t o_required,
+					     uint64_t o_found)
 {
-	uint32_t o_flag;
+	uint64_t o_flag;
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(dl_args_required); i++) {
@@ -1058,16 +1058,16 @@ static int dl_args_finding_required_validate(uint32_t o_required,
 	return 0;
 }
 
-static int dl_argv_parse(struct dl *dl, uint32_t o_required,
-			 uint32_t o_optional)
+static int dl_argv_parse(struct dl *dl, uint64_t o_required,
+			 uint64_t o_optional)
 {
 	struct dl_opts *opts = &dl->opts;
-	uint32_t o_all = o_required | o_optional;
-	uint32_t o_found = 0;
+	uint64_t o_all = o_required | o_optional;
+	uint64_t o_found = 0;
 	int err;
 
 	if (o_required & DL_OPT_HANDLE && o_required & DL_OPT_HANDLEP) {
-		uint32_t handle_bit;
+		uint64_t handle_bit;
 
 		err = dl_argv_handle_both(dl, &opts->bus_name, &opts->dev_name,
 					  &opts->port_index, &handle_bit);
@@ -1446,7 +1446,7 @@ static void dl_opts_put(struct nlmsghdr *nlh, struct dl *dl)
 }
 
 static int dl_argv_parse_put(struct nlmsghdr *nlh, struct dl *dl,
-			     uint32_t o_required, uint32_t o_optional)
+			     uint64_t o_required, uint64_t o_optional)
 {
 	int err;
 
-- 
2.21.0

