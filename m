Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3333E1B35C3
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 05:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbgDVDxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 23:53:44 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:50913 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726423AbgDVDxn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 23:53:43 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id D85D65801C7;
        Tue, 21 Apr 2020 23:53:41 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 21 Apr 2020 23:53:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alistair23.me;
         h=from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm3; bh=4NDaOwg5jepTh
        MDWgHjK7GYLbHX6IFibl+r4ExTotBU=; b=BF75GViA/WfpZ42bIeuoEei73lYmG
        JM2i9BttJzOn6NbD8495IQc28VYtgrET6iOCWS/L6Qave6Djet0T08HzshXIrXuV
        kSrReF2ix4mz7TocckYkRVLI2OwGmbEQytFYPZEoeE1TLBpR6Pc46lQpPdYoiRqc
        TNTY1ojV5bMngpUddkEKqaTVoUVA0xJmvhDqQMCa2XQXkreoMkGltwcQuCLpkwWR
        HU/sKMfs0OV97Pp7bzx+3jsfzZJpad3ZlWhmZl2oVLAJA90iyOjYDdp5us7Gk2Xx
        WrciG23FeAiAmL26gMe/rS5kaaXt5xlhblY4WfZV1uXSL5nw/I9vun/PQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=4NDaOwg5jepThMDWgHjK7GYLbHX6IFibl+r4ExTotBU=; b=FJmTJX12
        PpAVU5FUBbc0HZbqFR/j6XPS2wA3Mi+hhFc0t8wCxMtujaEQPOvXiYU8laOB7ore
        vg/4OJhokVs24bB0kUFxQZ0lRr7LulpHg/L9Z1UIaDvd4gOKbeN6+tEsrzE9Rbz1
        Cqlf9WPftCg9CO7xGkxg3yrH5d8W3n8rWIyQOtG8UT75vU1iEk5GBLaRI/+Cs9CO
        MLY+q8XKa0QPwbVnoCyUO6efd5wxc485Q2SI5NXc8FsTVG+4QKdz2mZJyMC24J+z
        aSi3a9SCPsHu2MrSOmXMkC//79d6fk078mMNipmGaWTc1iiKk9JlSyl24D6C1oaD
        O7W7JdP42fhnpw==
X-ME-Sender: <xms:xb-fXgMZKZHGa2A8G8X9xwqCgTiuNQQuXM6xNFGQo1qQoTbN552kog>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrgeeigdejhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpeetlhhishhtrghirhcuhfhrrghntghishcuoegrlhhishhtrghi
    rhesrghlihhsthgrihhrvdefrdhmvgeqnecukfhppeejfedrleefrdekgedrvddtkeenuc
    evlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrlhhishht
    rghirhesrghlihhsthgrihhrvdefrdhmvg
X-ME-Proxy: <xmx:xb-fXizD7SBTgnp3IGahq3npEqipiXNCihgf0FwA9MHOGPUDO2ceSQ>
    <xmx:xb-fXirbdn-aFRWRdF60j4_Kq45RsPapFOF-afffxQyRinPckBlrhg>
    <xmx:xb-fXiNK6bc_vQZ7ddXaFVA8P2hEzS61JeJ9O0yuZYDMXwgXzZN63g>
    <xmx:xb-fXiQxFWskSBiWmt7QSJfHI_BjCU9EItf6Pcthi3j9pIHOhUftEA>
Received: from alistair-xps-14z.alistair23.me (c-73-93-84-208.hsd1.ca.comcast.net [73.93.84.208])
        by mail.messagingengine.com (Postfix) with ESMTPA id 79CC13280059;
        Tue, 21 Apr 2020 23:53:40 -0400 (EDT)
From:   Alistair Francis <alistair@alistair23.me>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, johan.hedberg@gmail.com,
        linux-bluetooth@vger.kernel.org, mripard@kernel.org, wens@csie.org
Cc:     anarsoul@gmail.com, devicetree@vger.kernel.org,
        alistair23@gmail.com, linux-arm-kernel@lists.infradead.org,
        Alistair Francis <alistair@alistair23.me>
Subject: [PATCH v4 2/3] Bluetooth: hci_h5: Add support for binding RTL8723BS with device tree
Date:   Tue, 21 Apr 2020 20:53:32 -0700
Message-Id: <20200422035333.1118351-2-alistair@alistair23.me>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200422035333.1118351-1-alistair@alistair23.me>
References: <20200422035333.1118351-1-alistair@alistair23.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasily Khoruzhick <anarsoul@gmail.com>

RTL8723BS is often used in ARM boards, so add ability to bind it
using device tree.

Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
Signed-off-by: Alistair Francis <alistair@alistair23.me>
---
 drivers/bluetooth/hci_h5.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/hci_h5.c b/drivers/bluetooth/hci_h5.c
index 106c110efe56..e60b2e0773db 100644
--- a/drivers/bluetooth/hci_h5.c
+++ b/drivers/bluetooth/hci_h5.c
@@ -1018,6 +1018,8 @@ static const struct of_device_id rtl_bluetooth_of_match[] = {
 #ifdef CONFIG_BT_HCIUART_RTL
 	{ .compatible = "realtek,rtl8822cs-bt",
 	  .data = (const void *)&rtl_vnd },
+	{ .compatible = "realtek,rtl8723bs-bt",
+	  .data = (const void *)&rtl_vnd },
 #endif
 	{ },
 };
-- 
2.26.0

