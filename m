Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 020E5255689
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 10:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728696AbgH1Ibm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 04:31:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:34408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726834AbgH1Ibe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Aug 2020 04:31:34 -0400
Received: from coco.lan (unknown [95.90.213.181])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E4422078A;
        Fri, 28 Aug 2020 08:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598603492;
        bh=cAq/sybSxcx13a+XYpOTjux0qvvE0KuRSS8BR2Ruuk0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=X6n5YBQLHawGomvQnxnbwlSc1+dZTN8444HonJ5Ac3m4H0Fyvynx/LbUzOQ/TOCay
         oe33m+yVp8mAJg7OMkbzgBpSFDylU2D+j35Ual2ZowKZZTburVjjyi4kF5mh1FNOb4
         CmCq1RD91Ea+0zY7GWQuOheST49fp1Wj6ynpAvTg=
Date:   Fri, 28 Aug 2020 10:31:25 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Steve deRosier <derosier@gmail.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>, linuxarm@huawei.com,
        mauro.chehab@huawei.com, John Stultz <john.stultz@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Maital Hahn <maitalm@ti.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Raz Bouganim <r-bouganim@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Johannes Berg <johannes.berg@intel.com>,
        Fuqian Huang <huangfq.daxian@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Revert "wlcore: Adding suppoprt for IGTK key in wlcore
 driver"
Message-ID: <20200828103125.5b766d27@coco.lan>
In-Reply-To: <CALLGbRLsQpdtrcV9ydz4KJ4A9uaj4P1EhbF0_yMxcdLvOmnY9Q@mail.gmail.com>
References: <f0a2cb7ea606f1a284d4c23cbf983da2954ce9b6.1598420968.git.mchehab+huawei@kernel.org>
        <CALLGbRL+duiHFd3w7hcD=u47k+JM5rLpOkMrRpW0aQm=oTfUnA@mail.gmail.com>
        <20200827194225.281eb7dc@coco.lan>
        <CALLGbRLsQpdtrcV9ydz4KJ4A9uaj4P1EhbF0_yMxcdLvOmnY9Q@mail.gmail.com>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Thu, 27 Aug 2020 13:36:28 -0700
Steve deRosier <derosier@gmail.com> escreveu:

> Hi Mauro,
> 
> On Thu, Aug 27, 2020 at 10:42 AM Mauro Carvalho Chehab
> <mchehab+huawei@kernel.org> wrote:
> >
> > Em Thu, 27 Aug 2020 08:48:30 -0700
> > Steve deRosier <derosier@gmail.com> escreveu:
> >  
> > > On Tue, Aug 25, 2020 at 10:49 PM Mauro Carvalho Chehab
> > > <mchehab+huawei@kernel.org> wrote:  
> > > >
> > > > This patch causes a regression betwen Kernel 5.7 and 5.8 at wlcore:
> > > > with it applied, WiFi stops working, and the Kernel starts printing
> > > > this message every second:
> > > >
> > > >    wlcore: PHY firmware version: Rev 8.2.0.0.242
> > > >    wlcore: firmware booted (Rev 8.9.0.0.79)
> > > >    wlcore: ERROR command execute failure 14  
> > >
> > > Only if NO firmware for the device in question supports the `KEY_IGTK`
> > > value, then this revert is appropriate. Otherwise, it likely isn't.  
> >
> > Yeah, that's what I suspect too: some specific firmware is required
> > for KEY_IGTK to work.
> >  
> > >  My suspicion is that the feature that `KEY_IGTK` is enabling is
> > > specific to a newer firmware that Mauro hasn't upgraded to. What the
> > > OP should do is find the updated firmware and give it a try.  
> >
> > I didn't try checking if linux-firmware tree has a newer version on
> > it. I'm using Debian Bullseye on this device. So, I suspect that
> > it may have a relatively new firmware.
> >
> > Btw, that's also the version that came together with Fedora 32:
> >
> >         $ strings /lib/firmware/ti-connectivity/wl18xx-fw-4.bin |grep FRev
> >         FRev 8.9.0.0.79
> >         FRev 8.2.0.0.242
> >
> > Looking at:
> >         https://git.ti.com/cgit/wilink8-wlan/wl18xx_fw/
> >
> > It sounds that there's a newer version released this year:
> >
> >         2020-05-28      Updated to FW 8.9.0.0.81
> >         2018-07-29      Updated to FW 8.9.0.0.79
> >
> > However, it doesn't reached linux-firmware upstream yet:
> >
> >         $ git log --pretty=oneline ti-connectivity/wl18xx-fw-4.bin
> >         3a5103fc3c29 wl18xx: update firmware file 8.9.0.0.79
> >         65b1c68c63f9 wl18xx: update firmware file 8.9.0.0.76
> >         dbb85a5154a5 wl18xx: update firmware file
> >         69a250dd556b wl18xx: update firmware file
> >         dbe3f134bb69 wl18xx: update firmware file, remove conf file
> >         dab4b79b3fbc wl18xx: add version 4 of the wl18xx firmware
> >  
> > > AND - since there's some firmware the feature doesn't work with, the
> > > driver should be fixed to detect the running firmware version and not
> > > do things that the firmware doesn't support.  AND the firmware writer
> > > should also make it so the firmware doesn't barf on bad input and
> > > instead rejects it politely.  
> >
> > Agreed. The main issue here seems to be that the current patch
> > assumes that this feature is available. A proper approach would
> > be to check if this feature is available before trying to use it.
> >
> > Now, I dunno if version 8.9.0.0.81 has what's required for it to
> > work - or if KEY_IGTK require some custom firmware version.
> >
> > If it works with such version, one way would be to add a check
> > for this specific version, disabling KEY_IGTK otherwise.
> >
> > Also, someone from TI should be sending the newer version to
> > be added at linux-firmware.
> >
> > I'll try to do a test maybe tomorrow.
> >  
> 
> I think we're totally agreed on all of the above points.
> Fundamentally: the orig patch should've been coded defensively and
> tested properly since clearly it causes certain firmwares to break.
> Be nice if TI would both update the firmware and also update the
> driver to detect the relevant version for features.  I don't know
> about this one, but I do know the QCA firmwares (and others) have a
> set of feature flags that are detected by the drivers to determine
> what is supported.
> 
> I look forward to hearing the results of your test.  This whole thing
> has gotten me interested. I'd be tempted to pull out the relevant dev
> boards and play with them myself, but IIRC they got sent back to a
> previous employer and I don't have access to them anymore.

I upgraded to the newest firmware available at TI firmware site:

	https://git.ti.com/cgit/wilink8-wlan/wl18xx_fw/log/

No joy. It worked once, but I guess it just selected some different
cipher, as the access point it is logging in is set to WPA2-PSK
with auto cipher.

I even wrote a patch that checks the version, enabling AES-CMAC
algorithm only with newer firmware (see below).

Maybe this feature will only be available on some future firmware
or it requires some custom-made one. It may also require some
newer version of the chipset.

So, for now, I suggest to revert this patch, c/c stable.

A later patch can be re-enable it, once some additional logic
gets added in order to validate if this algorithm is
properly supported by the hardware/firmware.


Thanks,
Mauro

[PATCH] net: wireless: wlcore: fix support for IGTK key

Changeset 2b7aadd3b9e1 ("wlcore: Adding suppoprt for IGTK key in wlcore driver")
added support for AEC-CMAC cipher suite.

However, this only works with the very newest firmware version
(8.9.0.0.81). Such firmware weren't even pushed to linux-firmware
git tree yet:

	https://git.ti.com/cgit/wilink8-wlan/wl18xx_fw/log/

Due to that, it causes a regression betwen Kernel 5.7 and 5.8:
with such patch applied, WiFi stops working, and the Kernel starts
printing this message every second:

   wlcore: PHY firmware version: Rev 8.2.0.0.242
   wlcore: firmware booted (Rev 8.9.0.0.79)
   wlcore: ERROR command execute failure 14
   ------------[ cut here ]------------
   WARNING: CPU: 0 PID: 133 at drivers/net/wireless/ti/wlcore/main.c:795 wl12xx_queue_recovery_work.part.0+0x6c/0x74 [wlcore]
   Modules linked in: wl18xx wlcore mac80211 libarc4 cfg80211 rfkill snd_soc_hdmi_codec crct10dif_ce wlcore_sdio adv7511 cec kirin9xx_drm(C) kirin9xx_dw_drm_dsi(C) drm_kms_helper drm ip_tables x_tables ipv6 nf_defrag_ipv6
   CPU: 0 PID: 133 Comm: kworker/0:1 Tainted: G        WC        5.8.0+ #186
   Hardware name: HiKey970 (DT)
   Workqueue: events_freezable ieee80211_restart_work [mac80211]
   pstate: 60000005 (nZCv daif -PAN -UAO BTYPE=--)
   pc : wl12xx_queue_recovery_work.part.0+0x6c/0x74 [wlcore]
   lr : wl12xx_queue_recovery_work+0x24/0x30 [wlcore]
   sp : ffff8000126c3a60
   x29: ffff8000126c3a60 x28: 00000000000025de
   x27: 0000000000000010 x26: 0000000000000005
   x25: ffff0001a5d49e80 x24: ffff8000092cf580
   x23: ffff0001b7c12623 x22: ffff0001b6fcf2e8
   x21: ffff0001b7e46200 x20: 00000000fffffffb
   x19: ffff0001a78e6400 x18: 0000000000000030
   x17: 0000000000000001 x16: 0000000000000001
   x15: ffff0001b7e46670 x14: ffffffffffffffff
   x13: ffff8000926c37d7 x12: ffff8000126c37e0
   x11: ffff800011e01000 x10: ffff8000120526d0
   x9 : 0000000000000000 x8 : 3431206572756c69
   x7 : 6166206574756365 x6 : 0000000000000c2c
   x5 : 0000000000000000 x4 : ffff0001bf1361e8
   x3 : ffff0001bf1790b0 x2 : 0000000000000000
   x1 : ffff0001a5d49e80 x0 : 0000000000000001
   Call trace:
    wl12xx_queue_recovery_work.part.0+0x6c/0x74 [wlcore]
    wl12xx_queue_recovery_work+0x24/0x30 [wlcore]
    wl1271_cmd_set_sta_key+0x258/0x25c [wlcore]
    wl1271_set_key+0x7c/0x2dc [wlcore]
    wlcore_set_key+0xe4/0x360 [wlcore]
    wl18xx_set_key+0x48/0x1d0 [wl18xx]
    wlcore_op_set_key+0xa4/0x180 [wlcore]
    ieee80211_key_enable_hw_accel+0xb0/0x2d0 [mac80211]
    ieee80211_reenable_keys+0x70/0x110 [mac80211]
    ieee80211_reconfig+0xa00/0xca0 [mac80211]
    ieee80211_restart_work+0xc4/0xfc [mac80211]
    process_one_work+0x1cc/0x350
    worker_thread+0x13c/0x470
    kthread+0x154/0x160
    ret_from_fork+0x10/0x30
   ---[ end trace b1f722abf9af5919 ]---
   wlcore: WARNING could not set keys
   wlcore: ERROR Could not add or replace key
   wlan0: failed to set key (4, ff:ff:ff:ff:ff:ff) to hardware (-5)
   wlcore: Hardware recovery in progress. FW ver: Rev 8.9.0.0.79
   wlcore: pc: 0x0, hint_sts: 0x00000040 count: 39
   wlcore: down
   wlcore: down
   ieee80211 phy0: Hardware restart was requested
   mmc_host mmc0: Bus speed (slot 0) = 400000Hz (slot req 400000Hz, actual 400000HZ div = 0)
   mmc_host mmc0: Bus speed (slot 0) = 25000000Hz (slot req 25000000Hz, actual 25000000HZ div = 0)
   wlcore: PHY firmware version: Rev 8.2.0.0.242
   wlcore: firmware booted (Rev 8.9.0.0.79)
   wlcore: ERROR command execute failure 14
   ------------[ cut here ]------------

Fix it by adding some code that will check if the firmware version
is at least version 8.9.0.0.81.

Fixes: 2b7aadd3b9e1 ("wlcore: Adding suppoprt for IGTK key in wlcore driver")
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index de6c8a7589ca..db9e410c5d0b 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -14,6 +14,7 @@
 #include <linux/irq.h>
 #include <linux/pm_runtime.h>
 #include <linux/pm_wakeirq.h>
+#include <linux/ctype.h>
 
 #include "wlcore.h"
 #include "debug.h"
@@ -1082,6 +1083,45 @@ static int wl12xx_chip_wakeup(struct wl1271 *wl, bool plt)
 	return ret;
 }
 
+bool wl1271_check_aes_cmac_cypher(struct wl1271 *wl)
+{
+	int ver[5] = { };
+	int ret;
+	const char *p = wl->chip.fw_ver_str;
+
+
+	/* The string starts with "Rev ". Ignore it */
+	while (*p && !isdigit(*p))
+		p++;
+
+	ret = sscanf(p, "%d.%d.%d.%d.%d",
+		     &ver[0], &ver[1], &ver[2], &ver[3], &ver[4]);
+
+	if (ret != ARRAY_SIZE(ver)) {
+		wl1271_info("Parsed version: %d.%d.%d.%d.%d\n",
+			    ver[0], ver[1], ver[2], ver[3], ver[4]);
+		wl1271_error("Couldn't parse firmware version string: %d\n", ret);
+		return false;
+	}
+
+	/*
+	 * Only versions equal (and probably above) 8.9.0.0.81
+	 * supports such feature.
+	 */
+	if (ver[0] < 8)
+		return false;
+	if (ver[1] < 9)
+		return false;
+	if (ver[2] > 0)
+		return true;
+	if (ver[3] > 0)
+		return true;
+	if (ver[4] >= 81)
+		return true;
+
+	return false;
+}
+
 int wl1271_plt_start(struct wl1271 *wl, const enum plt_mode plt_mode)
 {
 	int retries = WL1271_BOOT_RETRIES;
@@ -1133,6 +1173,8 @@ int wl1271_plt_start(struct wl1271 *wl, const enum plt_mode plt_mode)
 		strncpy(wiphy->fw_version, wl->chip.fw_ver_str,
 			sizeof(wiphy->fw_version));
 
+		wl->has_aes_cmac_cipher = wl1271_check_aes_cmac_cypher(wl);
+
 		goto out;
 
 power_off:
@@ -2358,6 +2400,8 @@ static int wl12xx_init_fw(struct wl1271 *wl)
 	strncpy(wiphy->fw_version, wl->chip.fw_ver_str,
 		sizeof(wiphy->fw_version));
 
+	wl->has_aes_cmac_cipher = wl1271_check_aes_cmac_cypher(wl);
+
 	/*
 	 * Now we know if 11a is supported (info from the NVS), so disable
 	 * 11a channels if not supported
@@ -3551,6 +3595,10 @@ int wlcore_set_key(struct wl1271 *wl, enum set_key_cmd cmd,
 		key_type = KEY_GEM;
 		break;
 	case WLAN_CIPHER_SUITE_AES_CMAC:
+		if (!wl->has_aes_cmac_cipher) {
+			wl1271_error("AEC CMAC cipher not available on this firmware version\n");
+			return -EOPNOTSUPP;
+		}
 		key_type = KEY_IGTK;
 		break;
 	default:
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index b7821311ac75..26a2bd9b2df1 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -213,6 +213,8 @@ struct wl1271 {
 	void *nvs;
 	size_t nvs_len;
 
+	u32 has_aes_cmac_cipher:1;
+
 	s8 hw_pg_ver;
 
 	/* address read from the fuse ROM */


