Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3F232B6BD2
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 18:35:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728941AbgKQReq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 12:34:46 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:58887 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726397AbgKQRep (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 12:34:45 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 99AEEF63;
        Tue, 17 Nov 2020 12:34:44 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 17 Nov 2020 12:34:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=p04NgclNTO3OOmrSL
        uyO8E4wJMLONnTaSiFtSprlR2I=; b=luAtMl9AzM8SPiDddDTtwkCm+Qzk/45Ac
        XQH+eulhOwUUq2Nz6tOx+DpiV1HOtWAJe33bh3c61eVDcNLA2U3oV8NHoc0jh8Fb
        gdoUrrcFQ6RItPlc2KQ8POy3KrAZDplRxf6TPeOa7FyngMRRF5ZJkeWxlKwn+w+k
        QYa66Mku8GS46srCZcRqozG4o38jumuLhwUjiiFgoykBSlMN22c+cihl0S9VJrtm
        KQhuO+ZtvFBswKczNvv9uB93UZFcT4+TbwswYEsB8Ls9d/yPqRSBsyGh7hBSss6l
        HQejoivG1qp1BjI8mXQRjSGBeCblLBLNl9KkOkyC6LbjYutm+6F9g==
X-ME-Sender: <xms:swm0X_mfVOy19zTleh2YWlRKNzjSKG_1SHRzhBz-sxOpnQ27fiCidQ>
    <xme:swm0Xy3vQ1dbZYk7wTtsFxajjVdSowpcvRFOrycqJW8wKFjHYbfFtiAwAFRQiy-qC
    NHquMTl0V0H_sE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudeffedguddtvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeetveeghfevgffgffekueffuedvhfeuhe
    ehteffieekgeehveefvdegledvffduhfenucfkphepkeegrddvvdelrdduheegrddugeej
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:swm0X1qcq6v0SP9iuW-KfnxXO1du9j-KYoxQJuvo6GSefwf2e1ifPg>
    <xmx:swm0X3naZbqCfbMEYEvO5rYnWXHow1rKvGBIymm7LW3zgF1pSGk2cQ>
    <xmx:swm0X91_dnHP72kg5ZssM6klIOv5E-5v7t7gnN9p_yFyCwU6irDBvw>
    <xmx:tAm0X7DLbLQAmwxFfxCxP7QBdh2I3Y66jzT9LF0nASLelaofZ6M-aA>
Received: from shredder.lan (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id F401A3064AA7;
        Tue, 17 Nov 2020 12:34:41 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net 0/2] mlxsw: Couple of fixes
Date:   Tue, 17 Nov 2020 19:33:50 +0200
Message-Id: <20201117173352.288491-1-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

This patch set contains two fixes for mlxsw.

Patch #1 fixes firmware flashing when CONFIG_MLXSW_CORE=y and
CONFIG_MLXFW=m.

Patch #2 prevents EMAD transactions from needlessly failing when the
system is under heavy load by using exponential backoff.

Please consider patch #2 for stable.

Ido Schimmel (2):
  mlxsw: Fix firmware flashing
  mlxsw: core: Use variable timeout for EMAD retries

 drivers/net/ethernet/mellanox/mlxsw/Kconfig | 2 +-
 drivers/net/ethernet/mellanox/mlxsw/core.c  | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

-- 
2.28.0

