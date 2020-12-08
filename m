Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 162F62D277B
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 10:25:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728841AbgLHJZB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 04:25:01 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:57245 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728658AbgLHJZA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 04:25:00 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 4C3A55C01F0;
        Tue,  8 Dec 2020 04:23:54 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Tue, 08 Dec 2020 04:23:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=lCx9C0bR9DgECQFIfZT3RvSjgH4ere2Z5TE/zVpgecM=; b=CmMhy7Wv
        1ViEfXzRIXcDiFIsPDlPNINz04GutOrB3YKbpsHiaRG1wFnqLS9rZx+1qw7Qk/hW
        5ODs9EnEgQWAxNUsY6YLfab8ddx+wJUNF1Wt5z2cJoYi/qPzL4/PdXQ8LLG7G0/U
        AgMWfxU03z1YLX3GDILeo0sFEoyWPkLFHS7lV4yxIp7KxVG1jNoN8qvDKiMH+IJp
        q+C14khGyn1F0S4kmwJCF3yI+94Jylq+il7ER6rzPTnUQIpZnqrDU1E0G/yxARgR
        i2kijFTtLzoE+o6BrpA3brMy319d79vYIRAY5JGI1bhxaNWhNySZyLEjZ+JE8rqN
        uvpg6GvS7hoRpw==
X-ME-Sender: <xms:KkbPX-mb0P_-tj3Ug8tSkozTYfxYCGtXez-Ks_kuQEVJSgPl86V-OQ>
    <xme:KkbPX70vtPlyUGXm4b18JosZ3S0IZBdzzLyI9FY23u_mbtOfkuNCJ19FhHbn1ejN8
    tlxIA0GReaxbmc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudejiedgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrjeek
    necuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:KkbPX3eKmLDi4FH9IWza3urEk0ocGE9vMI_ieNnyBRaPKQvnUBbT_w>
    <xmx:KkbPX1bvf9fEyaTkK70qRQoku7yZHbGbEILNrdRnXJwYQDGddY6z5Q>
    <xmx:KkbPX8HtQnO-J5MIiqr4p6CKaqsMEncLvxqTg7DuqHdrFtFzDhtAqA>
    <xmx:KkbPXx0HxJ-wzRXY0f2KxAiSCCamUs--iIFOMx4GBX4J6MpGumc7SQ>
Received: from shredder.lan (igld-84-229-153-78.inter.net.il [84.229.153.78])
        by mail.messagingengine.com (Postfix) with ESMTPA id CAAC91080067;
        Tue,  8 Dec 2020 04:23:52 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 03/13] mlxsw: reg: Add support for tunnel port in SPVID register
Date:   Tue,  8 Dec 2020 11:22:43 +0200
Message-Id: <20201208092253.1996011-4-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201208092253.1996011-1-idosch@idosch.org>
References: <20201208092253.1996011-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Add spvid_tport field which indicates if the port is tunnel port.
When spvid_tport is true, local_port field supposed to be tunnel port
type.

It will be used to configure which Ethertype will be used when VLAN is
pushed at ingress for tunnel port.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index ad6798c2169d..2a89b3261f00 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -821,8 +821,16 @@ static inline void mlxsw_reg_spms_vid_pack(char *payload, u16 vid,
 
 MLXSW_REG_DEFINE(spvid, MLXSW_REG_SPVID_ID, MLXSW_REG_SPVID_LEN);
 
+/* reg_spvid_tport
+ * Port is tunnel port.
+ * Reserved when SwitchX/-2 or Spectrum-1.
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, spvid, tport, 0x00, 24, 1);
+
 /* reg_spvid_local_port
- * Local port number.
+ * When tport = 0: Local port number. Not supported for CPU port.
+ * When tport = 1: Tunnel port.
  * Access: Index
  */
 MLXSW_ITEM32(reg, spvid, local_port, 0x00, 16, 8);
-- 
2.28.0

