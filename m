Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58BD31AF81E
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 09:02:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726048AbgDSHB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 03:01:59 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:51869 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725446AbgDSHB6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 03:01:58 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 71D235C00BF;
        Sun, 19 Apr 2020 03:01:57 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 19 Apr 2020 03:01:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=gfl9GPk9cxLkgbHBRPo3oCqUgDUsbHGB4qv6/PyTnV8=; b=nUeLZECh
        7gWywrxnxZ6V3aasTgUBlZ28v4joqXCfe+/zKdmSolU4/mq0XpUidiKJUc4ihl1k
        KPqfyqtpurYd8UvP+vC3R6FJNDKStFoPn1D5yUn+DZGP5riWDJtqO6sNflFOa81J
        ol29evplReeJxReghmsUMXM+nX+lBgDpuVGspNzPM/+GdIeeB+8o8ONFbAGNNMn7
        Iss4jfYo/3scvJ3z7LLq82/nlsFo2PXmQW4ub0Fx82U1Eygf4Gm+URwg9Twa5+Sy
        uoW7Vt3qPYoHFjR6uzdn9LYkvn9hMFMgLeZsETH3ZHXXf1wywmij6TNKyaa8Xx33
        u8JtY/ITDjMjGw==
X-ME-Sender: <xms:ZfebXspKg7Sni4wtkYCoNrhKyqS0J1psNkeJ_lXqze3NWem4xKr7wg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrgedtgdduudduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudektddrheegrdduudeinecuvehluhhsthgvrh
    fuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgt
    hhdrohhrgh
X-ME-Proxy: <xmx:ZfebXmgOTvt-P6wu7PvbdcJZoMtsoj-WTTaH1ge2Eq10Z4U1JgaQ1w>
    <xmx:ZfebXu6s4us1QQkwYRZc5frfF3OwjP9sTdy6xAiixHlUIYUVM3lbqw>
    <xmx:ZfebXs7fXrONDCDiyw2PHBHJmIbtCdGkNciTIH7UPWndbBK88GjX8A>
    <xmx:ZfebXhRYMq_aMm_01pXPky2D5HrMxJnIRh11hemA5A6IV3Q5er6ZbQ>
Received: from localhost.localdomain (bzq-79-180-54-116.red.bezeqint.net [79.180.54.116])
        by mail.messagingengine.com (Postfix) with ESMTPA id 491A33280059;
        Sun, 19 Apr 2020 03:01:56 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 2/2] mlxsw: reg: Increase register field length to 13 bits
Date:   Sun, 19 Apr 2020 10:01:06 +0300
Message-Id: <20200419070106.3471528-3-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200419070106.3471528-1-idosch@idosch.org>
References: <20200419070106.3471528-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The Infrastructure Entry Delete Register (IEDR) is used to delete
entries stored in the KVD linear database. Currently, it is only
possible to delete entries of size up to 2048. Future firmware versions
will support deletion of entries of size up to 4096.

Increase the size of the field so that the driver will be able to
perform such deletions in the future, when required.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 9b39b8e70519..3c3db1c874b6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -3203,7 +3203,7 @@ MLXSW_ITEM32_INDEXED(reg, iedr, rec_type, MLXSW_REG_IEDR_BASE_LEN, 24, 8,
  * Size of entries do be deleted. The unit is 1 entry, regardless of entry type.
  * Access: OP
  */
-MLXSW_ITEM32_INDEXED(reg, iedr, rec_size, MLXSW_REG_IEDR_BASE_LEN, 0, 11,
+MLXSW_ITEM32_INDEXED(reg, iedr, rec_size, MLXSW_REG_IEDR_BASE_LEN, 0, 13,
 		     MLXSW_REG_IEDR_REC_LEN, 0x00, false);
 
 /* reg_iedr_rec_index_start
-- 
2.24.1

