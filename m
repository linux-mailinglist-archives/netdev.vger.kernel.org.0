Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7165B255588
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 09:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728503AbgH1HpA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 03:45:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:40490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726566AbgH1HpA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Aug 2020 03:45:00 -0400
Received: from coco.lan (unknown [95.90.213.181])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3AD620776;
        Fri, 28 Aug 2020 07:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598600699;
        bh=SkiS31dL5sO8aFc2BqHw/btZG51E399wbR9Mo2sTZLY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KrftNmW8b8/fNJvtgtULmSnzQLgd+F/V6EkjeI4kc5Ld1Qx8qt7Wbqjt/vq54EidE
         Ul+bpUIEM5Mr60sAh21KXKeIOMsow04UgPm6g6ouQr890Eaq2f5NPCfQ+2HpSA/Idf
         5nZzK5wtq+FGyCICa5ZE+RWwzI/Cr7qCITqHydHw=
Date:   Fri, 28 Aug 2020 09:44:52 +0200
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
Message-ID: <20200828094452.112dde27@coco.lan>
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

> > > And let's revisit the discussion of having a kernel splat because an
> > > unrelated piece of code fails yet the driver does exactly what it is
> > > supposed to do. We shouldn't be dumping registers and stack-trace when
> > > the code that crashed has nothing to do with the registers and
> > > stack-trace outputted. It is a false positive.  A simple printk WARN
> > > or ERROR should output notifying us that the chip firmware has crashed
> > > and why.  IMHO. 

Yeah, that WARN_ON() is disturbing.

Sometimes, it prints it here out of the blue at the first time it
tries to use WiFi:

[    4.502250] mmc_host mmc0: Bus speed (slot 0) = 400000Hz (slot req 400000Hz, actual 400000HZ div = 0)
[    4.542376] mmc_host mmc0: Bus speed (slot 0) = 25000000Hz (slot req 25000000Hz, actual 25000000HZ div = 0)
[    4.678228] mmc_host mmc0: Bus speed (slot 0) = 400000Hz (slot req 400000Hz, actual 400000HZ div = 0)
[    4.719082] mmc_host mmc0: Bus speed (slot 0) = 25000000Hz (slot req 25000000Hz, actual 25000000HZ div = 0)
[    4.830243] mmc_host mmc0: Bus speed (slot 0) = 400000Hz (slot req 400000Hz, actual 400000HZ div = 0)
[    4.870524] mmc_host mmc0: Bus speed (slot 0) = 25000000Hz (slot req 25000000Hz, actual 25000000HZ div = 0)
[    5.088650] wlcore: wl18xx HW: 183x or 180x, PG 2.2 (ROM 0x11)
[    5.095260] wlcore: WARNING Detected unconfigured mac address in nvs, derive from fuse instead.
[    5.104030] wlcore: WARNING This default nvs file can be removed from the file system
[    5.114699] wlcore: loaded
[    5.270777] mmc_host mmc0: Bus speed (slot 0) = 400000Hz (slot req 400000Hz, actual 400000HZ div = 0)
[    5.310835] mmc_host mmc0: Bus speed (slot 0) = 25000000Hz (slot req 25000000Hz, actual 25000000HZ div = 0)
[    5.414725] mmc_host mmc0: Bus speed (slot 0) = 400000Hz (slot req 400000Hz, actual 400000HZ div = 0)
[    5.454684] mmc_host mmc0: Bus speed (slot 0) = 25000000Hz (slot req 25000000Hz, actual 25000000HZ div = 0)
[    5.751078] wlcore: PHY firmware version: Rev 8.2.0.0.243
[    5.799065] wlcore: firmware booted (Rev 8.9.0.0.81)
[    5.804035] wlcore: ERROR Couldn't parse firmware version string

[    5.821800] wlcore: down
[    5.946770] mmc_host mmc0: Bus speed (slot 0) = 400000Hz (slot req 400000Hz, actual 400000HZ div = 0)
[    5.986777] mmc_host mmc0: Bus speed (slot 0) = 25000000Hz (slot req 25000000Hz, actual 25000000HZ div = 0)
[    6.878108] ------------[ cut here ]------------
[    6.882741] WARNING: CPU: 3 PID: 297 at drivers/net/wireless/ti/wlcore/sdio.c:78 wl12xx_sdio_raw_read+0x11c/0x1c0 [wlcore_sdio]
[    6.894220] Modules linked in: wl18xx wlcore mac80211 libarc4 cfg80211 rfkill snd_soc_hdmi_codec wlcore_sdio adv7511 cec kirin9xx_drm(C) crct10dif_ce kirin9xx_dw_drm_dsi(C) drm_kms_helper drm ip_tables x_tables ipv6 nf_defrag_ipv6
[    6.914682] CPU: 3 PID: 297 Comm: NetworkManager Tainted: G         C        5.8.0+ #197
[    6.922771] Hardware name: HiKey970 (DT)
[    6.926693] pstate: 60000005 (nZCv daif -PAN -UAO BTYPE=--)
[    6.932263] pc : wl12xx_sdio_raw_read+0x11c/0x1c0 [wlcore_sdio]
[    6.938181] lr : wl12xx_sdio_raw_read+0x8c/0x1c0 [wlcore_sdio]
[    6.944009] sp : ffff800012793140
[    6.947318] x29: ffff800012793140 x28: 0000000000000000 
[    6.952626] x27: ffff0001a79ba258 x26: ffff0001a79b9e80 
[    6.957935] x25: 0000000000000000 x24: ffff0001ac5db100 
[    6.963243] x23: 0000000000000004 x22: ffff0001b19b1810 
[    6.968552] x21: ffff0001b17a0000 x20: 0000000000013738 
[    6.973859] x19: ffff0001b6988800 x18: 00000002e3eebd18 
[    6.979168] x17: 0000000000000001 x16: 0000000000000001 
[    6.984476] x15: 0008291e1896a232 x14: 0008290c7b540ede 
[    6.989784] x13: 00000000000003c4 x12: 00000000fa83b2da 
[    6.995093] x11: 00000000000003c4 x10: 00000000000009c0 
[    7.000401] x9 : ffff800012792d20 x8 : ffff0001b17a0a20 
[    7.005708] x7 : 0000000000000001 x6 : 0000000001fb396f 
[    7.011017] x5 : 00ffffffffffffff x4 : 0000000000000000 
[    7.016325] x3 : ffff0001b760e104 x2 : 0000000000000000 
[    7.021633] x1 : ffff0001b17a0000 x0 : 00000000ffffff92 
[    7.026943] Call trace:
[    7.029386]  wl12xx_sdio_raw_read+0x11c/0x1c0 [wlcore_sdio]
[    7.034978]  wl18xx_boot+0x414/0x890 [wl18xx]
[    7.039373]  wl1271_op_add_interface+0x784/0xa60 [wlcore]
[    7.044843]  drv_add_interface+0x38/0x84 [mac80211]
[    7.049750]  ieee80211_do_open+0x59c/0x8cc [mac80211]
[    7.054829]  ieee80211_open+0x48/0x70 [mac80211]
[    7.059453]  __dev_open+0xe4/0x190
[    7.062852]  __dev_change_flags+0x180/0x1f0
[    7.067031]  dev_change_flags+0x24/0x64
[    7.070866]  do_setlink+0x20c/0xc40
[    7.074349]  __rtnl_newlink+0x500/0x820
[    7.078180]  rtnl_newlink+0x4c/0x80
[    7.081664]  rtnetlink_rcv_msg+0x11c/0x340
[    7.085759]  netlink_rcv_skb+0x58/0x11c
[    7.089591]  rtnetlink_rcv+0x18/0x2c
[    7.093163]  netlink_unicast+0x25c/0x320
[    7.097080]  netlink_sendmsg+0x190/0x3a0
[    7.101003]  ____sys_sendmsg+0x1d8/0x230
[    7.104921]  ___sys_sendmsg+0x80/0xd0
[    7.108579]  __sys_sendmsg+0x68/0xc4
[    7.112150]  __arm64_sys_sendmsg+0x28/0x3c
[    7.116247]  el0_svc_common.constprop.0+0x6c/0x170
[    7.121035]  do_el0_svc+0x24/0x90
[    7.124347]  el0_sync_handler+0x90/0x19c
[    7.128266]  el0_sync+0x158/0x180
[    7.131576] ---[ end trace 4dc4a75fcea462c4 ]---
[    7.136220] wl1271_sdio mmc0:0001:2: sdio read failed (-110)

It then continues:

[    7.262730] mmc_host mmc0: Bus speed (slot 0) = 400000Hz (slot req 400000Hz, actual 400000HZ div = 0)
[    7.302704] mmc_host mmc0: Bus speed (slot 0) = 25000000Hz (slot req 25000000Hz, actual 25000000HZ div = 0)
[    7.406723] mmc_host mmc0: Bus speed (slot 0) = 400000Hz (slot req 400000Hz, actual 400000HZ div = 0)
[    7.446674] mmc_host mmc0: Bus speed (slot 0) = 25000000Hz (slot req 25000000Hz, actual 25000000HZ div = 0)
[    7.738299] wlcore: PHY firmware version: Rev 8.2.0.0.243
[    7.787048] wlcore: firmware booted (Rev 8.9.0.0.81)
[    7.792020] wlcore: ERROR Couldn't parse firmware version string

[   16.536187] random: crng init done
[   16.539597] random: 7 urandom warning(s) missed due to ratelimiting
[   23.820340] wlcore: down
[   24.534944] wlan0: authenticate with de:ad:de:ad:de:ad
[   24.542583] wlan0: send auth to de:ad:de:ad:de:ad (try 1/3)
[   24.561316] wlan0: authenticated
[   24.568198] wlan0: associate with de:ad:de:ad:de:ad (try 1/3)
[   24.575998] wlan0: RX AssocResp from de:ad:de:ad:de:ad (capab=0x431 status=0 aid=3)
[   24.589510] wlan0: associated

And WiFi works properly.

Maybe it is not properly handling -EPROBE_DEFER somewhere.


Thanks,
Mauro
