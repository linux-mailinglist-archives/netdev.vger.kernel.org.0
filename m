Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5C6E333AFD
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 12:04:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232732AbhCJLEA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 06:04:00 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:42715 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232707AbhCJLDo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 06:03:44 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 832225C0129;
        Wed, 10 Mar 2021 06:03:43 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 10 Mar 2021 06:03:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=duknaemZiB+8lFzr9u9IoyEWv7rihDW4dANsEtpqQ1U=; b=l6MyLuh3
        /YmdCzS3DoS/S55xs5jG/5DH8B+iBv6jFXXXq22hj31kIu51eXRNimTkQ26IZqg6
        gU9rJJ5oAHCrNZS08zTW6uPjX6T4UJl3+nTgYwiiNwBtnbppJTeBwoOKCJolau7F
        RKtOslCHrnGOTAjZvvxqZsQYvIRNhQ3A/IDyn6d5B2A5k90179Bpc9me+aYMZuDQ
        u7E1UTPH12juZzzSh5Gkl0uDv2By5S9IGZ5UGjFNmoPycSe3+/7qmOrzCTJcQTpz
        JmDhit2IZ3/uvYitWBUCjzbLDzH5pik55Uy/mvW4Q9MufoaHOADn28kyyeIuxG3w
        CKNXA/oayUQoSg==
X-ME-Sender: <xms:j6dIYEbjB-KZc4bPnIUkzlA-LxCNE_4CgriHajyJz3fkq6WNSERxqQ>
    <xme:j6dIYK47Jy9Pzlko0Z2nWEgwaBqkgxWsRnpJvd0hggxZVNlVng0yPvE528Z211Rue
    Ntc_b5feanKgbY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddukedgvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:j6dIYFbnW8Eg2VZ75dWTmzXP2xbFgQyXhUMwaQoVbmXrwFSEWxSOmg>
    <xmx:j6dIYJiAVvJB24ZrvJbztP7g-oMU_NM41pCJP9rWdCpJC20s50EWPQ>
    <xmx:j6dIYG-qeUZZ5cezFY9BteoJ-KSDtcQNk0uqkj1QIoor6YxheKM-jQ>
    <xmx:j6dIYG_IbQT7WNfwVYB6JIH5RvcsRMzZy66c_R1ByR3e5cNsc3TcTw>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 842FA1080059;
        Wed, 10 Mar 2021 06:03:41 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        danieller@nvidia.com, amcohen@nvidia.com, petrm@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 5/6] mlxsw: core: Expose MFDE.log_ip to devlink health
Date:   Wed, 10 Mar 2021 13:02:19 +0200
Message-Id: <20210310110220.2534350-6-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210310110220.2534350-1-idosch@idosch.org>
References: <20210310110220.2534350-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

Add the MFDE.log_ip field to devlink health reporter in order to ease
firmware debug. This field encodes the instruction pointer that triggered
the CR space timeout.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 52fdc34251ba..c53461ac4e10 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1806,6 +1806,10 @@ static int mlxsw_core_health_fw_fatal_dump(struct devlink_health_reporter *repor
 		err = devlink_fmsg_u8_pair_put(fmsg, "log_irisc_id", val);
 		if (err)
 			return err;
+		val = mlxsw_reg_mfde_log_ip_get(mfde_pl);
+		err = devlink_fmsg_u64_pair_put(fmsg, "log_ip", val);
+		if (err)
+			return err;
 	} else if (event_id == MLXSW_REG_MFDE_EVENT_ID_KVD_IM_STOP) {
 		val = mlxsw_reg_mfde_pipes_mask_get(mfde_pl);
 		err = devlink_fmsg_u32_pair_put(fmsg, "pipes_mask", val);
-- 
2.29.2

