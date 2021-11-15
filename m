Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CBF0451642
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 22:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240093AbhKOVSJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 16:18:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350451AbhKOUXw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 15:23:52 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65F87C0432CA
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 12:18:10 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id w29so32973588wra.12
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 12:18:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:to:cc:content-language
         :subject:content-transfer-encoding;
        bh=VoxwCzYwQGbno9RbtsIIyYkVXvs51MPgjgV/WkLpkWs=;
        b=ks5P5bpGtRrua1CrctmHTWnL6jjzS07a/rzMiISmin2xVmV7AzUtmxFxyC4EDahsuI
         5CG7YKF9vvTmDqnh4uYk9uA602Dd6gmgd2UvYzjxj9bUAqPxus2xB/BVBAzpKdT4muVI
         oU7vS98rq8k17Mi1waRJW0e+9cf3ceRt1IyJPkiraDtW1wAaDrgKEhDRnfHA14Q94Xsx
         8Jo3jMv/fjvQ5fW+y+HI72jQm4N/ZSXLdVa1M7hX/8mrXjJX3bslb134XvpEtpbX2sL/
         PjX2RTt4U/fQxQ/fIMZYVIcinnttyn9z7DmkX1yCaR8gl+YL5UVOjGJ+2EyLrH4LppcM
         ThmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from:to
         :cc:content-language:subject:content-transfer-encoding;
        bh=VoxwCzYwQGbno9RbtsIIyYkVXvs51MPgjgV/WkLpkWs=;
        b=nDvrXom5poSp1dLdJXrXCyG8djoF3PYt8Of/kJziV2BPKCx4wEk4i43IVFA4ZH3CTE
         IAOyNbXirjOzSj3N7jZKF4KI2il+7gzFDurFlyf285DV4vEgO5ObodPifCWmdGXRC9kk
         h/qk6uaUwCKesogxcNFe/nBnI51ck/3YditacM43OEimA1qjcSS2riDLl67MykJ2kVTF
         b4ZFdlq66w58a1E1MLQL36WJHHhExQcPTYs65n0Dbj9CHPwmvhRS8Veo8VU2p3DX4qFt
         TfdXwq6aKzfie0qzRYy0pQ1DQLbmUV0tClOV4681RQ4Gf7vu1GRogdjLH0lEeJcms2nC
         sc2w==
X-Gm-Message-State: AOAM531L6vQzhdFowf7+iBa3gJZuDn+r7NbTM/RZshvkf6n/wGm00q4l
        OE+69r/Fjmta/JCzwyoRUulCBb7ygO4=
X-Google-Smtp-Source: ABdhPJwxr9O00XPbkDnKF1mLhfkevWXTQGbLR9BWhDf6b63uLv8EABqMiz2lJB4phaxtnFhLxQFezQ==
X-Received: by 2002:adf:f907:: with SMTP id b7mr2250734wrr.5.1637007488861;
        Mon, 15 Nov 2021 12:18:08 -0800 (PST)
Received: from ?IPV6:2003:ea:8f1a:f00:a554:6e71:73b4:f32d? (p200300ea8f1a0f00a5546e7173b4f32d.dip0.t-ipconnect.de. [2003:ea:8f1a:f00:a554:6e71:73b4:f32d])
        by smtp.googlemail.com with ESMTPSA id o3sm379211wms.10.2021.11.15.12.18.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Nov 2021 12:18:08 -0800 (PST)
Message-ID: <36feb8c4-a0b6-422a-899c-e61f2e869dfe@gmail.com>
Date:   Mon, 15 Nov 2021 21:17:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Language: en-US
Subject: [PATCH net-next] r8169: enable ASPM L1/L1.1 from RTL8168h
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With newer chip versions ASPM-related issues seem to occur only if
L1.2 is enabled. I have a test system with RTL8168h that gives a
number of rx_missed errors when running iperf and L1.2 is enabled.
With L1.2 disabled (and L1 + L1.1 active) everything is fine.
See also [0]. Can't test this, but L1 + L1.1 being active should be
sufficient to reach higher package power saving states.

[0] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1942830

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index bbe21db20..6e46397f0 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5271,12 +5271,6 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (rc)
 		return rc;
 
-	/* Disable ASPM L1 as that cause random device stop working
-	 * problems as well as full system hangs for some PCIe devices users.
-	 */
-	rc = pci_disable_link_state(pdev, PCIE_LINK_STATE_L1);
-	tp->aspm_manageable = !rc;
-
 	/* enable device (incl. PCI PM wakeup and hotplug setup) */
 	rc = pcim_enable_device(pdev);
 	if (rc < 0) {
@@ -5319,6 +5313,17 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	tp->mac_version = chipset;
 
+	/* Disable ASPM L1 as that cause random device stop working
+	 * problems as well as full system hangs for some PCIe devices users.
+	 * Chips from RTL8168h partially have issues with L1.2, but seem
+	 * to work fine with L1 and L1.1.
+	 */
+	if (tp->mac_version >= RTL_GIGA_MAC_VER_45)
+		rc = pci_disable_link_state(pdev, PCIE_LINK_STATE_L1_2);
+	else
+		rc = pci_disable_link_state(pdev, PCIE_LINK_STATE_L1);
+	tp->aspm_manageable = !rc;
+
 	tp->dash_type = rtl_check_dash(tp);
 
 	tp->cp_cmd = RTL_R16(tp, CPlusCmd) & CPCMD_MASK;
-- 
2.33.1

