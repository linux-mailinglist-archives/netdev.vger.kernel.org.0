Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19E661B8788
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 17:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726230AbgDYPzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 11:55:44 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:37099 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726076AbgDYPzm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Apr 2020 11:55:42 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 39C485803BB;
        Sat, 25 Apr 2020 11:55:41 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sat, 25 Apr 2020 11:55:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alistair23.me;
         h=from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm3; bh=4NDaOwg5jepTh
        MDWgHjK7GYLbHX6IFibl+r4ExTotBU=; b=qjrasrrRtXMYrs6S+OE4vXcKll5qV
        6GNU2SNqK9tkbOwLgbrIzS+BCJpVXCvl7yYG8TqGBa6HE6z4P/tqPbAU0veD9fMN
        r3e3VistO+tUtmhY9iyG5UfiASAcUkWiQT/L46PpWVVVDKcsuiWok/IhwnRQrk8K
        OzJqUq9a895xA2bVvA2cc0Xqz84dGnvbxKRmtMMgLwF+UbPOG0MODJej/ip9Nf1x
        FgBKXgqthiiWYUQdj9NvF1Ym705mVFl4yNVCHmvARvle82eg4FzwQnllmhBQB9Nl
        /fAyOMOVNU3cM5TzbcxlHoaLy/BsUs6IeRTIyfEWvr3FIbpHteEitBoXw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=4NDaOwg5jepThMDWgHjK7GYLbHX6IFibl+r4ExTotBU=; b=bCfVWHG8
        LBSQMrCS0v3/C5HT46ThY53/r/E9V4cLosMlpERSPU8by3bZ798hbOvf+h+mpQah
        9ydx84tj7uwAhDyjnorAVJbQS9R4nRkRGnRJjCR44GgxOyJ7+FvXqHpSZA10Qo3p
        4/2MLlAXJ0McOkaSk5vWEBELiWiOE4ZPbMILD8ihKWFcKqYNWzoeduMPPWiyX6WK
        r67pQu2LAILHwDztoQ1Xo43q3IowrDxxjFolVkO1vbeThf+W85HsKVFk6t09Mgt4
        IYxps+dfaSAs2auNdclPDzdaI6PJwdm3EGHHxWRoByWkBcId5zrO3zYDaALw0PbU
        guJE4eAXVSqn2Q==
X-ME-Sender: <xms:eF2kXq86cUymBj8QOYZyEdgMiU2szVqg81_gTjSKw1DYzG2jFRTSuA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrheeggdejvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpeetlhhishhtrghirhcuhfhrrghntghishcuoegrlhhishhtrghi
    rhesrghlihhsthgrihhrvdefrdhmvgeqnecukfhppeejfedrleefrdekgedrvddtkeenuc
    evlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrlhhishht
    rghirhesrghlihhsthgrihhrvdefrdhmvg
X-ME-Proxy: <xmx:eF2kXqS-pC4-YEAay7uvJmtKdXJOqYaO14SVp18YrP8rC8CO7PB3kw>
    <xmx:eF2kXjz-5O5_2NoF2IAZMy_-QAx9M3gehxQ8c8vMlEC1WLoAZvHkwg>
    <xmx:eF2kXm5eW9jo3LrHUmzPfheAdlwwNzSyVVc0Ol3KlTqS_pjV7G_G6g>
    <xmx:fV2kXmWpZWwkjQV75R64eYAOMQujRkt-z7a_usZqW-Jo7C528rQ3jg>
Received: from alistair-xps-14z.alistair23.me (c-73-93-84-208.hsd1.ca.comcast.net [73.93.84.208])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4A9EB3280064;
        Sat, 25 Apr 2020 11:55:35 -0400 (EDT)
From:   Alistair Francis <alistair@alistair23.me>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, johan.hedberg@gmail.com,
        linux-bluetooth@vger.kernel.org, mripard@kernel.org, wens@csie.org
Cc:     anarsoul@gmail.com, devicetree@vger.kernel.org,
        alistair23@gmail.com, linux-arm-kernel@lists.infradead.org,
        Alistair Francis <alistair@alistair23.me>
Subject: [PATCH v4 2/3] Bluetooth: hci_h5: Add support for binding RTL8723BS with device tree
Date:   Sat, 25 Apr 2020 08:55:30 -0700
Message-Id: <20200425155531.2816584-2-alistair@alistair23.me>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200425155531.2816584-1-alistair@alistair23.me>
References: <20200425155531.2816584-1-alistair@alistair23.me>
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

