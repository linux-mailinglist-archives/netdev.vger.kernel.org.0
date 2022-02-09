Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94F504AFCF6
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 20:11:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbiBITLb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 9 Feb 2022 14:11:31 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:54792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230202AbiBITL2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 14:11:28 -0500
X-Greylist: delayed 1637 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 09 Feb 2022 11:11:20 PST
Received: from good-out-06.clustermail.de (good-out-06.clustermail.de [IPv6:2a02:708:0:2c::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CB45C02B5CC
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 11:11:20 -0800 (PST)
Received: from [10.0.0.1] (helo=frontend.clustermail.de)
        by smtpout-02.clustermail.de with esmtp (Exim 4.94.2)
        (envelope-from <Rafael.Richter@gin.de>)
        id 1nHrwQ-0007Yf-O7; Wed, 09 Feb 2022 19:43:52 +0100
Received: from [217.6.33.237] (helo=Win2012-02.gin-domain.local)
        by frontend.clustermail.de with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384
        (Exim 4.94.2)
        (envelope-from <Rafael.Richter@gin.de>)
        id 1nHrwQ-000400-LO; Wed, 09 Feb 2022 19:43:46 +0100
Received: from Win2012-02.gin-domain.local (10.160.128.12) by
 Win2012-02.gin-domain.local (10.160.128.12) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Wed, 9 Feb 2022 19:43:45 +0100
Received: from Win2012-02.gin-domain.local ([fe80::b531:214c:87e0:8d4a]) by
 Win2012-02.gin-domain.local ([fe80::b531:214c:87e0:8d4a%18]) with mapi id
 15.00.1497.026; Wed, 9 Feb 2022 19:43:45 +0100
From:   "Richter, Rafael" <Rafael.Richter@gin.de>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "Klauer, Daniel" <Daniel.Klauer@gin.de>,
        Robert-Ionut Alexa <robert-ionut.alexa@nxp.com>
Subject: AW: [PATCH net] dpaa2-eth: unregister the netdev before disconnecting
 from the PHY
Thread-Topic: [PATCH net] dpaa2-eth: unregister the netdev before
 disconnecting from the PHY
Thread-Index: AQHYHc3irxHwc5wFI0WE9O9tcl0aJqyLi9Ty
Date:   Wed, 9 Feb 2022 18:43:45 +0000
Message-ID: <1644432224486.73494@gin.de>
References: <20220209155743.3167775-1-ioana.ciornei@nxp.com>
In-Reply-To: <20220209155743.3167775-1-ioana.ciornei@nxp.com>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.176.8.30]
x-esetresult: clean, is OK
x-esetid: 37303A29342AAB53617060
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ioana!

I've been testing this patch. However, I'm still facing the same kernel panic during shutdown if a SGMII interface was activated before.

Here is the stack trace:

[   96.923647] systemd-shutdown[1]: Rebooting.
[   97.461827] fsl-mc dpbp.9: Removing from iommu group 7
[   97.838899] fsl-mc dpbp.8: Removing from iommu group 7
[   98.206385] fsl-mc dpbp.7: Removing from iommu group 7
[   98.554855] fsl-mc dpbp.6: Removing from iommu group 7
[   98.815498] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
[   98.816624] Mem abort info:
[   98.816981]   ESR = 0x86000004
[   98.817371]   EC = 0x21: IABT (current EL), IL = 32 bits
[   98.818046]   SET = 0, FnV = 0
[   98.818436]   EA = 0, S1PTW = 0
[   98.818837]   FSC = 0x04: level 0 translation fault
[   98.819456] user pgtable: 4k pages, 48-bit VAs, pgdp=00000020835d7000
[   98.820273] [0000000000000000] pgd=0000000000000000, p4d=0000000000000000
[   98.821140] Internal error: Oops: 86000004 [#1] PREEMPT SMP
[   98.821848] Modules linked in:
[   98.822241] CPU: 15 PID: 0 Comm: swapper/15 Not tainted 5.17.0-rc2-00212-g3bed06e36994-dirty #1
[   98.823345] Hardware name: mpxlx2160a-gl6 (DT)
[   98.823909] pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[   98.824794] pc : 0x0
[   98.825077] lr : call_timer_fn.constprop.0+0x20/0x80
[   98.825717] sp : ffff80000943ba40
[   98.826139] x29: ffff80000943ba40 x28: 0000000000000000 x27: ffff80000943bad0
[   98.827052] x26: ffff0020002ff140 x25: ffff800008ee6980 x24: ffff00267c19fd28
[   98.827963] x23: ffff80000943bad0 x22: 0000000000000000 x21: 0000000000000101
[   98.828873] x20: ffff0020002ff140 x19: 0000000000000000 x18: fffffc0080035a48
[   98.829783] x17: ffff8026733ae000 x16: ffff80000807c000 x15: 0000000000004000
[   98.830693] x14: 00000000000003d0 x13: 0000000000000000 x12: 00000000000001e2
[   98.831602] x11: 00000000000003a6 x10: ffff8026733ae000 x9 : ffff00267c19fd70
[   98.832511] x8 : 0000000000000001 x7 : ffffffffffffffff x6 : 0000000000000000
[   98.833420] x5 : 0000000000000000 x4 : 0000000000000000 x3 : 0000000000000200
[   98.834329] x2 : 0000000000000200 x1 : 0000000000000000 x0 : ffff0020030872b0
[   98.835239] Call trace:
[   98.835552]  0x0
[   98.835790]  __run_timers.part.0+0x1e8/0x220
[   98.836338]  run_timer_softirq+0x38/0x70
[   98.836840]  _stext+0x124/0x29c
[   98.837244]  __irq_exit_rcu+0xdc/0xfc
[   98.837716]  irq_exit_rcu+0xc/0x14
[   98.838153]  el1_interrupt+0x34/0x80
[   98.838617]  el1h_64_irq_handler+0x14/0x1c
[   98.839140]  el1h_64_irq+0x78/0x7c
[   98.839575]  cpuidle_enter_state+0x12c/0x314
[   98.840121]  cpuidle_enter+0x34/0x4c
[   98.840577]  do_idle+0x1f0/0x254
[   98.840994]  cpu_startup_entry+0x20/0x70
[   98.841497]  secondary_start_kernel+0x13c/0x160
[   98.842076]  __secondary_switched+0x54/0x58
[   98.842618] Code: bad PC value
[   98.843010] ---[ end trace 0000000000000000 ]---
[   98.843597] Kernel panic - not syncing: Oops: Fatal exception in interrupt
[   98.844479] Kernel Offset: disabled
[   98.844922] CPU features: 0x10,00000042,40000842
[   98.845510] Memory Limit: none
[   98.845901] ---[ end Kernel panic - not syncing: Oops: Fatal exception in interrupt ]---

BR,

Rafael Richter
________________________________________
Von: Ioana Ciornei <ioana.ciornei@nxp.com>
Gesendet: Mittwoch, 9. Februar 2022 16:57
An: davem@davemloft.net; kuba@kernel.org; netdev@vger.kernel.org
Cc: Richter, Rafael; Klauer, Daniel; Robert-Ionut Alexa; Ioana Ciornei
Betreff: [PATCH net] dpaa2-eth: unregister the netdev before disconnecting from the PHY

From: Robert-Ionut Alexa <robert-ionut.alexa@nxp.com>

The netdev should be unregistered before we are disconnecting from the
MAC/PHY so that the dev_close callback is called and the PHY and the
phylink workqueues are actually stopped before we are disconnecting and
destroying the phylink instance.

Fixes: 719479230893 ("dpaa2-eth: add MAC/PHY support through phylink")
Signed-off-by: Robert-Ionut Alexa <robert-ionut.alexa@nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index e985ae008a97..dd9385d15f6b 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -4523,12 +4523,12 @@ static int dpaa2_eth_remove(struct fsl_mc_device *ls_dev)
 #ifdef CONFIG_DEBUG_FS
        dpaa2_dbg_remove(priv);
 #endif
+
+       unregister_netdev(net_dev);
        rtnl_lock();
        dpaa2_eth_disconnect_mac(priv);
        rtnl_unlock();

-       unregister_netdev(net_dev);
-
        dpaa2_eth_dl_port_del(priv);
        dpaa2_eth_dl_traps_unregister(priv);
        dpaa2_eth_dl_free(priv);
--
2.33.1



