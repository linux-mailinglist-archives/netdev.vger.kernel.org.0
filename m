Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC0462B6C25
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 18:48:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730088AbgKQRrh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 12:47:37 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:56159 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728960AbgKQRrf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 12:47:35 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 55B875D5;
        Tue, 17 Nov 2020 12:47:34 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 17 Nov 2020 12:47:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=GXHQpuqPxb6VlupQ/XfREziQH3EdYF/kaYzz+9yeqZ0=; b=DLdYQQwR
        d1I+QghspibC6nULls8r/0ZFqchaxZMoNBjO7+2YS+Wi41fPeYIBIEPKXIpOaPwY
        untQ37wB27VEvn0MLWebCf/F4nPSjwzqKxuemO9BD3bcKI+Udm35uxaPC5k6U0Op
        V59DB4NLOK6xn8HxOm+F7PbDg+iVHtSsam8L1E0eGZd77jqapRXqIpI6kOO0vnlA
        xP6vrRZOS+mFeFlWnjI4Ta+5JobHHQAXhpusHkDY6RPDpDrPXJEI09CkbbIg2PyH
        7lGS3OgFzuObCrz4Ky3+9eUgd56t6SqqTZgliVUAP0D3hAiuR+Rguq5KIZY/DjHF
        CyIodcS4TWcx2A==
X-ME-Sender: <xms:tQy0X4G7JIq9o_pGasmJnTv-YHeF5cIIYe_0B3c3CyLD2XNcIFeQzw>
    <xme:tQy0XxXY-9KOCMBroNbnCSJ1KOlvXH8LfiesFvFf1pHK-9RpwusNA3iPwvw3pYAVq
    4sS2yjQMSCGzDk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudeffedguddthecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheegrddu
    geejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:tQy0XyI3Gnrl3RpJPu_YThfIEgCHdUyhjEJbUIF6VSenLBBfBoqiqg>
    <xmx:tQy0X6Fx7R7ByBMQN-EIfrM5ApjStx0xLWtbeMKKKQXw7Ji5V-oZrw>
    <xmx:tQy0X-XL3xnnehpfTmXkG-3RlJHO6RsMhaNVwLgUm5haDiXibQDxyA>
    <xmx:tQy0X9T3wdRSFGE5EvOU3_ys3hswBTUG6UZdJMcHJ8aclo-d1aaAjw>
Received: from shredder.lan (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9103C328005D;
        Tue, 17 Nov 2020 12:47:32 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 2/9] mlxsw: spectrum_router: Set ifindex for IPv4 nexthops
Date:   Tue, 17 Nov 2020 19:46:57 +0200
Message-Id: <20201117174704.291990-3-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201117174704.291990-1-idosch@idosch.org>
References: <20201117174704.291990-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The ifindex of the nexthop device was never set for IPv4 nexthops,
unlike IPv6 nexthops. This went unnoticed since only IPv6 nexthops use
it.

Set the ifindex for IPv4 nexthops in order to be consistent with IPv6
and also because it will be used by a later patch.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 7dbf02f45913..1ea338786479 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -3971,6 +3971,7 @@ static int mlxsw_sp_nexthop4_init(struct mlxsw_sp *mlxsw_sp,
 
 	if (!dev)
 		return 0;
+	nh->ifindex = dev->ifindex;
 
 	rcu_read_lock();
 	in_dev = __in_dev_get_rcu(dev);
-- 
2.28.0

