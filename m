Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF1B1A5BEE
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 04:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbgDLCGy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 22:06:54 -0400
Received: from wnew4-smtp.messagingengine.com ([64.147.123.18]:48131 "EHLO
        wnew4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726884AbgDLCGx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Apr 2020 22:06:53 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.west.internal (Postfix) with ESMTP id E70C87B7;
        Sat, 11 Apr 2020 22:06:49 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sat, 11 Apr 2020 22:06:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alistair23.me;
         h=from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm3; bh=4NDaOwg5jepTh
        MDWgHjK7GYLbHX6IFibl+r4ExTotBU=; b=Ped5lv+ST74HxjOy1nkjPyQSqkkmC
        3GPJm5KmNJU5GaNlAg9z3DPzpzO2uQ0kl0eo51CdyF+ivgbEQvrFyXUmhYM0qIfV
        RohmPP5kl4T/2NWebs1raDsk+RzEOp8ShsDpNG6omeafbxQKuNaRdYckTUqiohle
        aPolSFXRr+zqXYZPXXwe7EtuK/tQNd76DeLF7vNblRqlUwt7VGiC5hOaV0aeyuEp
        hX7B0T2ckIf6diL5Qwo6eYl8bR5G4UD3D+Si7QriZ6X16RZDhsF6D0xzejKChQp5
        IpXIeojNhaudVMO01hl/b9sNeDe/bdrVZhalHdVJNp7+lYNmV+NYVAk8w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=4NDaOwg5jepThMDWgHjK7GYLbHX6IFibl+r4ExTotBU=; b=RRv0xfOM
        kZXoOwg05LTADsX7dlDPCpuwMHfK2u1P6ew5qY71JJb99ioCy/FbwnldpCtiJjft
        FNmFwTCSHbkUofGOx7InhVJ6QYlc2sLcUtpPIPBqWj10YErrh97SokPcAEeswMox
        F1WViSAYLV4WSxPSqLTdlTk5aNHDsQyAvT2F3aveVR2gX9fRRBi0JCCx3mr84Bpx
        IrnAoREhD0lHb9QNRglUSTMeOcZw1u1XquHyRXhcf0XkOl0Z57YC6KbUc/jZO10k
        yrwC9ZAwXK5HL/HOjsMvQt8InSPOW9SU4tc5FM8fRLzhArfBBK6X6UAP1W+uRXZP
        /Iejm3RU7kHoBQ==
X-ME-Sender: <xms:uXeSXn3KN5oQ6xqlGoKmAwc5rEepd6I5I_JRAubL0yvYt6BXwmEWzg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrvdehgdehvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpeetlhhishhtrghirhcuhfhrrghntghishcuoegrlhhishhtrghi
    rhesrghlihhsthgrihhrvdefrdhmvgeqnecukfhppeejfedrleefrdekgedrvddtkeenuc
    evlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrlhhishht
    rghirhesrghlihhsthgrihhrvdefrdhmvg
X-ME-Proxy: <xmx:uXeSXj7iVd-VsaScO_-izCbzAk2ZOOb4tE66bGCAX7H-4uXuo0zH2A>
    <xmx:uXeSXoyH37Zp33PjtNDIs0v3THPdHGTMDZgtuGtwSt2kemWNLRQa9g>
    <xmx:uXeSXnyF3GSWANtDhTI0LwzY6j4nVwmN75HOaKUAnLvbMQ5fj638lw>
    <xmx:uXeSXjJsYh82Y_fRx45IsX1zKNbYewzuRNF-cj-lt_I8v7VOgqLmA4tjDc0>
Received: from alistair-xps-14z.alistair23.me (c-73-93-84-208.hsd1.ca.comcast.net [73.93.84.208])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4575E3280060;
        Sat, 11 Apr 2020 22:06:48 -0400 (EDT)
From:   Alistair Francis <alistair@alistair23.me>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, johan.hedberg@gmail.com,
        linux-bluetooth@vger.kernel.org, mripard@kernel.org, wens@csie.org
Cc:     anarsoul@gmail.com, devicetree@vger.kernel.org,
        alistair23@gmail.com, linux-arm-kernel@lists.infradead.org,
        Alistair Francis <alistair@alistair23.me>
Subject: [PATCH v3 2/3] Bluetooth: hci_h5: Add support for binding RTL8723BS with device tree
Date:   Sat, 11 Apr 2020 19:06:43 -0700
Message-Id: <20200412020644.355142-2-alistair@alistair23.me>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200412020644.355142-1-alistair@alistair23.me>
References: <20200412020644.355142-1-alistair@alistair23.me>
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

