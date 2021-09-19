Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0904410B5C
	for <lists+netdev@lfdr.de>; Sun, 19 Sep 2021 13:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231463AbhISL6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 07:58:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230393AbhISL6y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Sep 2021 07:58:54 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2413DC061574
        for <netdev@vger.kernel.org>; Sun, 19 Sep 2021 04:57:29 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id d6so23418015wrc.11
        for <netdev@vger.kernel.org>; Sun, 19 Sep 2021 04:57:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8VCgDTfJ2SXMRPRIHoiGe2iWvCLro2JaYo28xKNRVY4=;
        b=OrK5+lue9hK8Eyrpn7zg9DvITX6VSW8X5bVP19Z7FVNzAdiNnyrX9cSzP2Kbz+PsAN
         u/SmZtfOuDgijrVal5s8UWgyQ9STeVFQgJrPLB+JE789JerkgTqwFWE0ApewF0EO/DqI
         pAxAL0QCqDizPMAFN8g3hrrDQVRCfTUp3eUhdNdAIvGZanouMrItwp8+zk6jy7qU5qkM
         FuDAJFUx94RRvmGDkAKJWqah1EAouUUUpYF/D5FvQIJntlyA88mq2l7neB6sntkr0tux
         mR6fIutS7yKM5YflD+obg3Fl7Y9puE/IWy4fmoZUbLEJ5/8+pMbpoNgmOVDt0KKeavT3
         623w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8VCgDTfJ2SXMRPRIHoiGe2iWvCLro2JaYo28xKNRVY4=;
        b=YCzDbmZS3drmkdhSgSdzRNrh1WbKeguX40sHH5OFk/SnOF003CKuh4timn2r/4Ug5a
         hk/SiY/zIxpzmTtgQO6H6Fdrm0bh6TkRrwiFec74ZOSt6NrmqXBbe56+rBHIeb/iEhWR
         nlJi8VRYjvOuYzlF1FLIbyYh0knFE46XBtc/t4NU61lXVNgVo0jrkXYxwR1QDnvotGAw
         ipEmysbklQINTSrvNPai3B20KEZT70M4k0R+0avB024zqfaiydLN+w+wjbsUlTnTOEZ4
         PkgpaGzgTvQHpS1/us04O0lXQRmJ0VTKRSAAzSXSZKsE/Z8ADBTUd5S2dJcRyT3v/T8y
         Dsgw==
X-Gm-Message-State: AOAM533AOAHlD3d4ttIktTrQ2S4AA5aDFAtl3Ey/q0YrH/oos6pMFCiO
        oeL6KO3+ydCbYUU9zGfF9RaMiZlkAuM=
X-Google-Smtp-Source: ABdhPJzTsxhL9crQEWI7arG2wl0yt8wzTusFcmI7xO8LpS5qvHTpkEiN3KRG9k44UirGZ1PprIe9bA==
X-Received: by 2002:adf:80eb:: with SMTP id 98mr22614147wrl.348.1632052647687;
        Sun, 19 Sep 2021 04:57:27 -0700 (PDT)
Received: from debian64.daheim (p200300d5ff2d4b00d63d7efffebde96e.dip0.t-ipconnect.de. [2003:d5:ff2d:4b00:d63d:7eff:febd:e96e])
        by smtp.gmail.com with ESMTPSA id g13sm11309449wmh.20.2021.09.19.04.57.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Sep 2021 04:57:27 -0700 (PDT)
Received: from chuck by debian64.daheim with local (Exim 4.95-RC2)
        (envelope-from <chunkeey@gmail.com>)
        id 1mRvRl-0007Z2-Dv;
        Sun, 19 Sep 2021 13:57:25 +0200
From:   Christian Lamparter <chunkeey@gmail.com>
To:     netdev@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com
Cc:     Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net v2] net: bgmac-bcma: handle deferred probe error due to mac-address
Date:   Sun, 19 Sep 2021 13:57:25 +0200
Message-Id: <20210919115725.29064-1-chunkeey@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Due to the inclusion of nvmem handling into the mac-address getter
function of_get_mac_address() by
commit d01f449c008a ("of_net: add NVMEM support to of_get_mac_address")
it is now possible to get a -EPROBE_DEFER return code. Which did cause
bgmac to assign a random ethernet address.

This exact issue happened on my Meraki MR32. The nvmem provider is
an EEPROM (at24c64) which gets instantiated once the module
driver is loaded... This happens once the filesystem becomes available.

With this patch, bgmac_probe() will propagate the -EPROBE_DEFER error.
Then the driver subsystem will reschedule the probe at a later time.

Cc: Petr Štetiar <ynezz@true.cz>
Cc: Michael Walle <michael@walle.cc>
Fixes: d01f449c008a ("of_net: add NVMEM support to of_get_mac_address")
Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
---
changes:
	v1 -> v2:
		rewrote commit message
		based on net (commit 02319bf15ac) [Andrew Lunn]
		"net" tag [Andrew Lunn]
		added "CCs" of the previous authors in that area
---
 drivers/net/ethernet/broadcom/bgmac-bcma.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bgmac-bcma.c b/drivers/net/ethernet/broadcom/bgmac-bcma.c
index 85fa0ab7201c..9513cfb5ba58 100644
--- a/drivers/net/ethernet/broadcom/bgmac-bcma.c
+++ b/drivers/net/ethernet/broadcom/bgmac-bcma.c
@@ -129,6 +129,8 @@ static int bgmac_probe(struct bcma_device *core)
 	bcma_set_drvdata(core, bgmac);
 
 	err = of_get_mac_address(bgmac->dev->of_node, bgmac->net_dev->dev_addr);
+	if (err == -EPROBE_DEFER)
+		return err;
 
 	/* If no MAC address assigned via device tree, check SPROM */
 	if (err) {
-- 
2.33.0

