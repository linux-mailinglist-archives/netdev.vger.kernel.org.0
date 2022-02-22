Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5664BF52E
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 10:54:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbiBVJyX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 04:54:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbiBVJyV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 04:54:21 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8836BD21C4
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 01:53:55 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id o24so32036977wro.3
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 01:53:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=V2f8WJVEfLmR7Yjrxn+JXUCE7Qf4fWvKIQu7kPzpdZ8=;
        b=TNfhaLXdD+1jWXqXV3evWP8kMWN3/YqHNZDVHLeYStGEoIR2WWXZ+oRkyNkHfT63uT
         mq1tNsePijEfawVtHdR4xm+aqmkFZrBOAFyuI1ndgsc5Aw0TnXETrO6+tKLOFhg8xhdz
         +eL+3fia/mdt+uNzk3CoxC/Dq+wIZ4IbaBmTK7AkgZyJ9qOdvih13GqHxB8FPTqvB/P6
         BieaCPPe2sVvh2etjWzVd2Y+vH32es5zs72TBAW7ZxYDbA2QkhkvETMlJ78gNm49S/UO
         BzCcxVx2fj1iqwrM+3cja94QBEk731lEMqFHVxHvo8jG1rj+MgN1YEr2QtiwqstaeZpX
         yuLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=V2f8WJVEfLmR7Yjrxn+JXUCE7Qf4fWvKIQu7kPzpdZ8=;
        b=2p1MpDyMObh9sqFi+drpOilUH5efkLxJMvqiIXIHwLKJSUISs043/+JEzgGWZRFfLS
         yxMBkorOdHatbSZhrneyJ4YyBkiENiW+QIUD2RXFNCCxq9tjc3SYGqS/kyP8g9CuoQBy
         OuTU7qFWk7LZnEIKvN9zoKOIq/fgbZFPC8CKC9omp3kwnnyaemjVhAEPVcqTbCy2o5hR
         6dWEQwX+vDkd8xy+uiPvQCdfkCsWIMhFWftwtAAJqtT6ay1ZSdAn/ghg89a6LbxPtnB7
         rUB6/u0Ee+Tj5hZgDHDLRD7qMFRyKHwiK+l81fyKg/hlvVXh25y16FifoL6w6l6WBIkL
         5T/g==
X-Gm-Message-State: AOAM532SMecMJVRXlOerjVb5cI2O32z2M5WvBdzo+vaL7ftOU532dOm6
        6TBp4usbI6byXFsaVwWPmtjvdD1CMiM=
X-Google-Smtp-Source: ABdhPJx02JNYGEs/kPFoCI+ySjb950iDH9apnTAoxEsGTe0sx7pc94DXsyrwgaRQKlT0zPU+6nGOKw==
X-Received: by 2002:a5d:55cd:0:b0:1e3:30ee:858 with SMTP id i13-20020a5d55cd000000b001e330ee0858mr18701945wrw.344.1645523634015;
        Tue, 22 Feb 2022 01:53:54 -0800 (PST)
Received: from morpheus.home.roving-it.com (3.e.2.0.0.0.0.0.0.0.0.0.0.0.0.0.1.8.6.2.1.1.b.f.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:fb11:2681::2e3])
        by smtp.googlemail.com with ESMTPSA id g6sm51372381wrq.97.2022.02.22.01.53.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 01:53:53 -0800 (PST)
From:   Peter Robinson <pbrobinson@gmail.com>
To:     Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org
Cc:     Peter Robinson <pbrobinson@gmail.com>,
        Javier Martinez Canillas <javierm@redhat.com>
Subject: [PATCH] net: bcmgenet: Return not supported if we don't have a WoL IRQ
Date:   Tue, 22 Feb 2022 09:53:48 +0000
Message-Id: <20220222095348.2926536-1-pbrobinson@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ethtool WoL enable function wasn't checking if the device
has the optional WoL IRQ and hence on platforms such as the
Raspberry Pi 4 which had working ethernet prior to the last
fix regressed with the last fix, so also check if we have a
WoL IRQ there and return ENOTSUPP if not.

Fixes: 9deb48b53e7f ("bcmgenet: add WOL IRQ check")
Fixes: 8562056f267d ("net: bcmgenet: request Wake-on-LAN interrupt")
Signed-off-by: Peter Robinson <pbrobinson@gmail.com>
Suggested-by: Javier Martinez Canillas <javierm@redhat.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c | 4 ++++
 1 file changed, 4 insertions(+)

We're seeing this crash on the Raspberry Pi 4 series of devices on
Fedora on 5.17-rc with the top Fixes patch and wired ethernet doesn't work.

[173353.733114] bcmgenet fd580000.ethernet eth0: Link is Up - 1Gbps/Full - flow control rx/tx
[173353.741855] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
dm[173356.452622] ------------[ cut here ]------------
[173356.457442] NETDEV WATCHDOG: eth0 (bcmgenet): transmit queue 4 timed out
[173356.464418] WARNING: CPU: 3 PID: 0 at net/sched/sch_generic.c:529 dev_watchdog+0x234/0x240
[173356.472915] Modules linked in: tls nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip_set nf_tables nfnetlink rtl8xxxu rtl8192cu rtl_usb rtl8192c_common rtlwifi btsdio mac80211 bluetooth cpufreq_dt libarc4 ecdh_generic brcmfmac brcmutil cfg80211 raspberrypi_cpufreq rfkill broadcom snd_soc_hdmi_codec bcm_phy_lib bcm2711_thermal genet iproc_rng200 mdio_bcm_unimac leds_gpio nvmem_rmem vfat fat fuse zram mmc_block vc4 snd_soc_core crct10dif_ce snd_compress gpio_raspberrypi_exp raspberrypi_hwmon dwc2 clk_bcm2711_dvp ac97_bus snd_pcm_dmaengine bcm2835_wdt snd_pcm udc_core snd_timer bcm2835_dma sdhci_iproc snd sdhci_pltfm pcie_brcmstb sdhci phy_generic soundcore drm_cma_helper i2c_dev aes_neon_bs
[173356.546454] CPU: 3 PID: 0 Comm: swapper/3 Not tainted 5.17.0-0.rc4.96.pbr1.fc36.aarch64 #1
[173356.554931] Hardware name: Unknown Unknown Product/Unknown Product, BIOS 2022.04-rc1 04/01/2022
[173356.563843] pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[173356.570997] pc : dev_watchdog+0x234/0x240
[173356.575157] lr : dev_watchdog+0x234/0x240
[173356.579314] sp : ffff8000080b3a40
[173356.582758] x29: ffff8000080b3a40 x28: ffffc6e8711b7000 x27: ffff8000080b3b20
[173356.590096] x26: ffffc6e870c30000 x25: 0000000000000000 x24: ffffc6e8711bec08
[173356.597432] x23: 0000000000000100 x22: ffffc6e8711b7000 x21: ffff38a4c2250000
[173356.604767] x20: 0000000000000004 x19: ffff38a4c22504c8 x18: ffffffffffffffff
[173356.612102] x17: ffff71bd0ab21000 x16: ffff80000801c000 x15: 0000000000000006
[173356.619436] x14: 0000000000000000 x13: 205d323434373534 x12: ffffc6e8712ad5f0
[173356.626769] x11: 712074696d736e61 x10: ffffc6e8712ad5f0 x9 : ffffc6e86edfc78c
[173356.634104] x8 : 00000000ffffdfff x7 : 000000000000003f x6 : 0000000000000000
[173356.641438] x5 : 0000000000000000 x4 : 0000000000000000 x3 : 0000000000001000
[173356.648773] x2 : 0000000000001000 x1 : 0000000000000005 x0 : 000000000000003c
[173356.656107] Call trace:
[173356.658685]  dev_watchdog+0x234/0x240
[173356.662493]  call_timer_fn+0x3c/0x15c
[173356.666304]  __run_timers.part.0+0x288/0x310
[173356.670728]  run_timer_softirq+0x48/0x80
[173356.674799]  __do_softirq+0x128/0x360
e[173356.678601]  __irq_exit_rcu+0x138/0x140
[173356.682661]  irq_exit_rcu+0x1c/0x30
[173356.686291]  el1_interrupt+0x38/0x54
[173356.690007]  el1h_64_irq_handler+0x18/0x24
[173356.694251]  el1h_64_irq+0x7c/0x80
[173356.697787]  arch_cpu_idle+0x18/0x2c
[173356.701502]  default_idle_call+0x4c/0x140
[173356.705657]  cpuidle_idle_call+0x14c/0x1a0
[173356.709905]  do_idle+0xb0/0x100
[173356.713182]  cpu_startup_entry+0x34/0x8c
[173356.717252]  secondary_start_kernel+0xe4/0x110
[173356.721852]  __secondary_switched+0x94/0x98
[173356.726188] ---[ end trace 0000000000000000 ]--- 

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
index e31a5a397f11..325f01b916c8 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
@@ -60,6 +60,10 @@ int bcmgenet_set_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
 	if (!device_can_wakeup(kdev))
 		return -ENOTSUPP;
 
+	/* We need a WoL IRQ to enable support, not all HW has one setup */
+	if (priv->wol_irq <= 0)
+		return -ENOTSUPP;
+
 	if (wol->wolopts & ~(WAKE_MAGIC | WAKE_MAGICSECURE | WAKE_FILTER))
 		return -EINVAL;
 
-- 
2.35.1

