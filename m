Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01AA2458E0F
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 13:15:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239457AbhKVMS3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 07:18:29 -0500
Received: from mail.loongson.cn ([114.242.206.163]:55792 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236711AbhKVMS3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 07:18:29 -0500
Received: from localhost.localdomain.localdomain (unknown [10.2.5.46])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9Dx79PDiZthKyUAAA--.851S3;
        Mon, 22 Nov 2021 20:15:04 +0800 (CST)
From:   Yinbo Zhu <zhuyinbo@loongson.cn>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Nick Desaulniers <ndesaulniers@google.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Cc:     zhuyinbo@loongson.cn
Subject: [PATCH v1 2/2] net: mdio: fixup ethernet phy module auto-load function
Date:   Mon, 22 Nov 2021 20:14:58 +0800
Message-Id: <1637583298-20321-2-git-send-email-zhuyinbo@loongson.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1637583298-20321-1-git-send-email-zhuyinbo@loongson.cn>
References: <1637583298-20321-1-git-send-email-zhuyinbo@loongson.cn>
X-CM-TRANSID: AQAAf9Dx79PDiZthKyUAAA--.851S3
X-Coremail-Antispam: 1UD129KBjvJXoWxJr1DXFyxJF43WFyfWr1rZwb_yoW8GFyUpF
        sYyFyrtrWUXwsrWws5Cw4DGF1F93y0y3srGrW0939Y9rs8Jry0qFWfKFyjvF15GFWrZ3W7
        Xay0qF18XF97ArDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUPq14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr4l82xGYIkIc2
        x26xkF7I0E14v26r4j6ryUM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
        Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1l84
        ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AI
        xVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20x
        vE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xv
        r2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY04
        v7MxkIecxEwVCm-wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s02
        6c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw
        0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvE
        c7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14
        v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x
        0JU2_M3UUUUU=
X-CM-SenderInfo: 52kx5xhqerqz5rrqw2lrqou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

the phy_id is only phy identifier, that phy module auto-load function
should according the phy_id event rather than other information, this
patch is remove other unnecessary information and add phy_id event in
mdio_uevent function and ethernet phy module auto-load function will
work well.

Signed-off-by: Yinbo Zhu <zhuyinbo@loongson.cn>
---
 drivers/net/phy/mdio_bus.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 6865d93..999f0d4 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -962,12 +962,12 @@ static int mdio_bus_match(struct device *dev, struct device_driver *drv)
 
 static int mdio_uevent(struct device *dev, struct kobj_uevent_env *env)
 {
-	int rc;
+	struct phy_device *pdev;
 
-	/* Some devices have extra OF data and an OF-style MODALIAS */
-	rc = of_device_uevent_modalias(dev, env);
-	if (rc != -ENODEV)
-		return rc;
+	pdev = to_phy_device(dev);
+
+	if (add_uevent_var(env, "MODALIAS=mdio:p%08X", pdev->phy_id))
+		return -ENOMEM;
 
 	return 0;
 }
@@ -991,7 +991,7 @@ static int mdio_uevent(struct device *dev, struct kobj_uevent_env *env)
 };
 
 struct bus_type mdio_bus_type = {
-	.name		= "mdio_bus",
+	.name		= "mdio",
 	.dev_groups	= mdio_bus_dev_groups,
 	.match		= mdio_bus_match,
 	.uevent		= mdio_uevent,
-- 
1.8.3.1

