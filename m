Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48754464954
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 09:13:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347838AbhLAIQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 03:16:51 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:33407 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347809AbhLAIQu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 03:16:50 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 6335B5C011A;
        Wed,  1 Dec 2021 03:13:29 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Wed, 01 Dec 2021 03:13:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=EpLEZddJKsYcc2hmQrqJWGrSBFGTTxQroiTaGXZaY5A=; b=YWSY6NKh
        6PS9tv0CAbKMXBPDC1usteXISMUj2sfTAGZtknpa6dz4oTYhahsBy08nmrb2YgXQ
        B+sE/BCcd88cBjYLcVTaCy6HiHslwrdm3AQGCRlvCUFGJSNFCUtmHqchTPRoXhEK
        gwu+cSy42aF/yr/zrlDeyGGVgCwQd6ugjNYPo6erOxBB9vUaCiWZg8c8nvmdVJ6X
        8SQN8eWE4Aojv6KF9kZI815wwat/uCj74jt5lvKsulHNxmG27fKcb2wQNIumeSpZ
        0/WYLKR0eCwzLYsUkLtUBM6Xdj8+cHY/tMPr/vJW7SjTlE5gWCWSkb0dDLeSMuvC
        OQ39uavW5MRCyA==
X-ME-Sender: <xms:qS6nYbyvlxAjTNhjAEo7HWioX7_Qq1YETrD8aB8adM6TGz8RUeu2DA>
    <xme:qS6nYTTXvqnWz4wOxrHNArO88Cw0CZrN95TAGVfydLFwrhZed_XvLyvm4OS5JTAaE
    trkawnHpzRJYRs>
X-ME-Received: <xmr:qS6nYVWx6i4Mup0JqteeatpUUhb8x-Rwh4I3vhdKEqKkYvpG_KXXKGTIbe34oZN2RAUM1WJT1ZZpm64YIgVWEnqF3WcVVLMzxY3c2Y5f3pxUQw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddriedvgdduudekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgepudenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:qS6nYVhLf0ov17ZCovh--4vg5IU-nH39t79oZYlgyIbNfRKATxnYrg>
    <xmx:qS6nYdDoRxePdKPEOYQ1HlPGIL87tH78BPCZrMgckLqGRWjdXDcj_w>
    <xmx:qS6nYeKcbwU3niA8godJzR1OFwptUlJDGcqaQdhjzvD03yoLcZpfAg>
    <xmx:qS6nYY9wm-XevjD3dRWMDm3zkAQ2UBSeds5qY-qCYMd8TOnd7ysEgg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 1 Dec 2021 03:13:27 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 05/10] mlxsw: reg: Increase 'port_num' field in PMTDB register
Date:   Wed,  1 Dec 2021 10:12:35 +0200
Message-Id: <20211201081240.3767366-6-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211201081240.3767366-1-idosch@idosch.org>
References: <20211201081240.3767366-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

'port_num' field is used to indicate the local port value which can be
assigned to a module.

Increase the field from 8 bits to 10 bits in order to support more than
255 ports.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 86146910b9c2..8d4395a2171f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -5828,7 +5828,7 @@ MLXSW_ITEM32(reg, pmtdb, status, 0x00, 0, 4);
  * the module.
  * Access: RO
  */
-MLXSW_ITEM16_INDEXED(reg, pmtdb, port_num, 0x04, 0, 8, 0x02, 0x00, false);
+MLXSW_ITEM16_INDEXED(reg, pmtdb, port_num, 0x04, 0, 10, 0x02, 0x00, false);
 
 static inline void mlxsw_reg_pmtdb_pack(char *payload, u8 slot_index, u8 module,
 					u8 ports_width, u8 num_ports)
-- 
2.31.1

