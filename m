Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A635915978D
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 19:01:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729662AbgBKSBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 13:01:33 -0500
Received: from gateway22.websitewelcome.com ([192.185.47.65]:12216 "EHLO
        gateway22.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728712AbgBKSBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 13:01:33 -0500
X-Greylist: delayed 1351 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Feb 2020 13:01:29 EST
Received: from cm16.websitewelcome.com (cm16.websitewelcome.com [100.42.49.19])
        by gateway22.websitewelcome.com (Postfix) with ESMTP id 7906D1286D
        for <netdev@vger.kernel.org>; Tue, 11 Feb 2020 11:38:57 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 1ZUvjR54P8vkB1ZUvjPH8u; Tue, 11 Feb 2020 11:38:57 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=xyY60RZTaVHgqxJMDcNw6jWbj1d9s89FHkL3ALR3HwU=; b=WRs8hTNYLNIxJgjoi7w8ZWLhAb
        rT14QyRBqVpYtuc5fvmnRU+0hQnjeTYOgpBdV5gKbcPorF6tvq+88V6wm2udaZ9S5u0kby86/P4tM
        rPlnQFBp6OQ1q+8yjjsS3IpuyvjdNw1GGy2lLMj3DhvahFnduyug88kRoHb6Trll5cOiGVwFc60nr
        n+nI/31X21VvPfDlYrVkYIpxH7MeTUugbZmpsiw59Mra5No+MveQQMKT0EPouLZdr1yIjr79c0dtP
        5klQnnGZL9U79sq0j5f0C49DOKABYirOooDQFi9+eFE8cD2kW2woXdbeRSiMbfbFpGIn/0HaKsoEX
        RGEhHsqg==;
Received: from [200.68.141.48] (port=29949 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j1ZUp-000EC5-VV; Tue, 11 Feb 2020 11:38:55 -0600
Date:   Tue, 11 Feb 2020 11:41:26 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     linux-kernel@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] treewide: Replace zero-length arrays with flexible-array
 member
Message-ID: <20200211174126.GA29960@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 200.68.141.48
X-Source-L: No
X-Exim-ID: 1j1ZUp-000EC5-VV
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [200.68.141.48]:29949
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 6
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current codebase makes use of the zero-length array language
extension to the C90 standard, but the preferred mechanism to declare
variable-length types such as these ones is a flexible array member[1][2],
introduced in C99:

struct foo {
        int stuff;
        struct boo array[];
};

By making use of the mechanism above, we will get a compiler warning
in case the flexible array does not occur last in the structure, which
will help us prevent some kind of undefined behavior bugs from being
unadvertenly introduced[3] to the codebase from now on.

All these instances of code were found with the help of the following
Coccinelle script:

@@
identifier S, member, array;
type T1, T2;
@@

struct S {
  ...
  T1 member;
  T2 array[
- 0
  ];
};

[1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
[2] https://github.com/KSPP/linux/issues/21
[3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")

NOTE: I'll carry this in my -next tree for the v5.6 merge window.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 arch/m68k/amiga/config.c                           |  2 +-
 arch/m68k/tools/amiga/dmesg.c                      |  2 +-
 arch/mips/kernel/signal.c                          |  2 +-
 arch/powerpc/mm/hugetlbpage.c                      |  2 +-
 arch/powerpc/platforms/powermac/nvram.c            |  2 +-
 arch/s390/appldata/appldata_os.c                   |  2 +-
 arch/sparc/kernel/cpumap.c                         |  2 +-
 arch/sparc/kernel/ds.c                             |  8 ++++----
 arch/x86/events/intel/bts.c                        |  2 +-
 drivers/amba/tegra-ahb.c                           |  2 +-
 drivers/auxdisplay/charlcd.c                       |  2 +-
 drivers/block/rsxx/dma.c                           |  2 +-
 drivers/bluetooth/btintel.c                        |  4 ++--
 drivers/bluetooth/hci_ag6xx.c                      |  2 +-
 drivers/bluetooth/hci_intel.c                      |  2 +-
 drivers/char/mspec.c                               |  2 +-
 drivers/char/virtio_console.c                      |  2 +-
 drivers/crypto/caam/caamalg.c                      |  2 +-
 drivers/crypto/caam/caamalg_qi.c                   |  4 ++--
 drivers/crypto/caam/caamhash.c                     |  2 +-
 drivers/crypto/cavium/nitrox/nitrox_main.c         |  2 +-
 drivers/crypto/img-hash.c                          |  2 +-
 drivers/crypto/mediatek/mtk-sha.c                  |  2 +-
 drivers/crypto/omap-sham.c                         |  4 ++--
 drivers/crypto/s5p-sss.c                           |  2 +-
 drivers/dma/at_xdmac.c                             |  2 +-
 drivers/dma/bcm-sba-raid.c                         |  2 +-
 drivers/dma/ioat/dca.c                             |  2 +-
 drivers/dma/moxart-dma.c                           |  2 +-
 drivers/dma/qcom/bam_dma.c                         |  2 +-
 drivers/dma/sa11x0-dma.c                           |  2 +-
 drivers/dma/sprd-dma.c                             |  2 +-
 drivers/dma/tegra20-apb-dma.c                      |  2 +-
 drivers/dma/tegra210-adma.c                        |  2 +-
 drivers/dma/ti/edma.c                              |  2 +-
 drivers/dma/ti/omap-dma.c                          |  2 +-
 drivers/dma/timb_dma.c                             |  2 +-
 drivers/dma/uniphier-mdmac.c                       |  2 +-
 drivers/firewire/core-cdev.c                       |  2 +-
 drivers/firewire/core-transaction.c                |  2 +-
 drivers/firewire/nosy.c                            |  2 +-
 drivers/firewire/ohci.c                            |  2 +-
 drivers/firmware/arm_scmi/driver.c                 |  2 +-
 drivers/firmware/arm_scmi/perf.c                   |  2 +-
 drivers/firmware/arm_scpi.c                        |  4 ++--
 drivers/firmware/dmi-sysfs.c                       |  2 +-
 drivers/firmware/efi/apple-properties.c            |  4 ++--
 drivers/firmware/google/memconsole-coreboot.c      |  2 +-
 drivers/firmware/google/vpd.c                      |  2 +-
 drivers/gpio/gpio-uniphier.c                       |  2 +-
 drivers/gpu/drm/i915/gt/intel_lrc.c                |  2 +-
 drivers/gpu/drm/qxl/qxl_cmd.c                      |  2 +-
 drivers/hwmon/ibmaem.c                             |  2 +-
 drivers/hwtracing/stm/policy.c                     |  2 +-
 drivers/i3c/master/dw-i3c-master.c                 |  2 +-
 drivers/i3c/master/i3c-master-cdns.c               |  2 +-
 drivers/infiniband/core/cache.c                    |  2 +-
 drivers/infiniband/core/cm.c                       |  4 ++--
 drivers/infiniband/core/multicast.c                |  2 +-
 drivers/infiniband/core/sa_query.c                 |  2 +-
 drivers/infiniband/hw/hfi1/mad.c                   |  4 ++--
 drivers/infiniband/hw/hfi1/sdma.c                  |  2 +-
 drivers/infiniband/hw/mthca/mthca_memfree.c        |  2 +-
 drivers/input/keyboard/applespi.c                  |  2 +-
 drivers/input/keyboard/goldfish_events.c           |  2 +-
 drivers/input/keyboard/gpio_keys.c                 |  2 +-
 drivers/input/keyboard/gpio_keys_polled.c          |  2 +-
 drivers/input/keyboard/tca6416-keypad.c            |  4 ++--
 drivers/input/mouse/cyapa_gen5.c                   |  8 ++++----
 drivers/iommu/qcom_iommu.c                         |  2 +-
 drivers/irqchip/irq-bcm7038-l1.c                   |  2 +-
 drivers/irqchip/qcom-irq-combiner.c                |  2 +-
 drivers/leds/leds-is31fl32xx.c                     |  2 +-
 drivers/leds/leds-pwm.c                            |  2 +-
 drivers/md/dm-crypt.c                              |  2 +-
 drivers/md/dm-integrity.c                          |  2 +-
 drivers/md/dm-log-writes.c                         |  2 +-
 drivers/md/dm-raid.c                               |  2 +-
 drivers/md/dm-raid1.c                              |  2 +-
 drivers/md/dm-stats.c                              |  2 +-
 drivers/md/dm-stripe.c                             |  2 +-
 drivers/md/dm-switch.c                             |  2 +-
 drivers/media/i2c/s5k5baf.c                        |  2 +-
 drivers/media/rc/iguanair.c                        |  2 +-
 drivers/mfd/omap-usb-tll.c                         |  2 +-
 drivers/mfd/qcom-pm8xxx.c                          |  2 +-
 drivers/misc/mei/bus-fixup.c                       |  4 ++--
 drivers/misc/vexpress-syscfg.c                     |  2 +-
 drivers/mmc/host/sdhci-acpi.c                      |  2 +-
 drivers/mmc/host/sdhci-cadence.c                   |  2 +-
 drivers/mmc/host/vub300.c                          |  2 +-
 drivers/mtd/maps/sa1100-flash.c                    |  2 +-
 drivers/mtd/nand/raw/marvell_nand.c                |  2 +-
 drivers/mtd/nand/raw/meson_nand.c                  |  2 +-
 drivers/mtd/nand/raw/mtk_nand.c                    |  2 +-
 drivers/mtd/nand/raw/nand_hynix.c                  |  2 +-
 drivers/mtd/nand/raw/sunxi_nand.c                  |  2 +-
 drivers/mtd/spi-nor/aspeed-smc.c                   |  2 +-
 drivers/net/can/peak_canfd/peak_pciefd_main.c      |  4 ++--
 drivers/net/ethernet/amd/atarilance.c              |  2 +-
 .../net/ethernet/cavium/liquidio/octeon_console.c  |  2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c |  2 +-
 drivers/net/ethernet/chelsio/cxgb4/l2t.c           |  2 +-
 .../net/ethernet/mellanox/mlx5/core/fpga/ipsec.c   |  2 +-
 .../net/ethernet/mellanox/mlx5/core/fs_counters.c  |  2 +-
 drivers/net/ethernet/mellanox/mlxfw/mlxfw_mfa2.c   |  2 +-
 drivers/net/ethernet/mellanox/mlxsw/core.c         |  2 +-
 .../ethernet/mellanox/mlxsw/core_acl_flex_keys.c   |  2 +-
 .../net/ethernet/mellanox/mlxsw/spectrum1_kvdl.c   |  2 +-
 .../net/ethernet/mellanox/mlxsw/spectrum2_kvdl.c   |  2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c |  4 ++--
 .../mellanox/mlxsw/spectrum_acl_bloom_filter.c     |  2 +-
 .../ethernet/mellanox/mlxsw/spectrum_acl_tcam.c    |  4 ++--
 .../net/ethernet/mellanox/mlxsw/spectrum_kvdl.c    |  2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c  |  2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c |  2 +-
 .../net/ethernet/netronome/nfp/nfp_net_debugdump.c |  8 ++++----
 drivers/net/ethernet/toshiba/tc35815.c             |  2 +-
 drivers/net/usb/cdc-phonet.c                       |  2 +-
 drivers/net/wan/wanxl.c                            |  2 +-
 drivers/net/wireless/ath/ath6kl/debug.c            |  2 +-
 drivers/net/wireless/ath/wil6210/wmi.c             |  2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/fweh.c    |  2 +-
 drivers/net/wireless/intel/ipw2x00/ipw2200.c       |  2 +-
 drivers/net/wireless/intel/iwlwifi/fw/debugfs.c    |  2 +-
 drivers/net/wireless/intersil/orinoco/fw.c         |  2 +-
 drivers/net/wireless/intersil/orinoco/hermes_dld.c |  6 +++---
 .../net/wireless/intersil/orinoco/orinoco_usb.c    |  2 +-
 drivers/net/wireless/marvell/libertas/if_sdio.c    |  2 +-
 drivers/net/wireless/marvell/libertas/if_spi.c     |  2 +-
 drivers/net/wireless/marvell/mwl8k.c               |  6 +++---
 drivers/net/wireless/rndis_wlan.c                  |  8 ++++----
 drivers/nfc/fdp/fdp.c                              |  2 +-
 drivers/nfc/st21nfca/dep.c                         |  4 ++--
 drivers/nvme/host/lightnvm.c                       |  2 +-
 drivers/pci/controller/pci-hyperv.c                |  6 +++---
 drivers/pci/pci.c                                  |  2 +-
 drivers/pinctrl/sirf/pinctrl-atlas7.c              |  2 +-
 drivers/pinctrl/uniphier/pinctrl-uniphier-core.c   |  2 +-
 drivers/platform/chrome/cros_ec_chardev.c          |  2 +-
 drivers/platform/chrome/wilco_ec/event.c           |  4 ++--
 drivers/platform/x86/i2c-multi-instantiate.c       |  2 +-
 drivers/powercap/idle_inject.c                     |  2 +-
 drivers/rapidio/rio-scan.c                         |  2 +-
 drivers/regulator/da9062-regulator.c               |  2 +-
 drivers/regulator/da9063-regulator.c               |  2 +-
 drivers/rpmsg/virtio_rpmsg_bus.c                   |  2 +-
 drivers/s390/block/dasd_diag.c                     |  2 +-
 drivers/s390/char/sclp_pci.c                       |  2 +-
 drivers/s390/cio/idset.c                           |  2 +-
 drivers/s390/crypto/zcrypt_msgtype6.c              |  2 +-
 drivers/scsi/advansys.c                            |  2 +-
 drivers/scsi/aic94xx/aic94xx_sds.c                 | 14 +++++++-------
 drivers/scsi/mpt3sas/mpt3sas_scsih.c               |  2 +-
 drivers/scsi/stex.c                                |  2 +-
 drivers/scsi/ufs/ufshcd.c                          |  2 +-
 drivers/spi/spi-fsl-lpspi.c                        |  2 +-
 drivers/spi/spi-s3c24xx.c                          |  2 +-
 drivers/staging/greybus/raw.c                      |  2 +-
 drivers/staging/media/allegro-dvt/allegro-core.c   |  2 +-
 drivers/staging/unisys/visorinput/visorinput.c     |  2 +-
 drivers/thunderbolt/eeprom.c                       |  2 +-
 drivers/thunderbolt/icm.c                          |  2 +-
 drivers/tty/n_gsm.c                                |  2 +-
 drivers/tty/serial/8250/8250_exar.c                |  2 +-
 drivers/tty/serial/8250/8250_pci.c                 |  2 +-
 drivers/tty/serial/sc16is7xx.c                     |  2 +-
 drivers/usb/atm/ueagle-atm.c                       |  2 +-
 drivers/usb/gadget/function/f_phonet.c             |  2 +-
 drivers/usb/host/ehci-tegra.c                      |  2 +-
 drivers/usb/musb/musb_host.c                       |  2 +-
 drivers/usb/serial/ti_usb_3410_5052.c              |  4 ++--
 drivers/video/fbdev/ssd1307fb.c                    |  2 +-
 drivers/zorro/zorro.c                              |  2 +-
 fs/aio.c                                           |  2 +-
 fs/binfmt_elf.c                                    |  2 +-
 fs/btrfs/scrub.c                                   |  2 +-
 fs/ceph/cache.c                                    |  2 +-
 fs/dlm/user.c                                      |  2 +-
 fs/ext4/dir.c                                      |  2 +-
 fs/ext4/namei.c                                    |  4 ++--
 fs/jfs/jfs_dtree.c                                 |  2 +-
 fs/nfs/dir.c                                       |  2 +-
 fs/nfs/nfs4proc.c                                  |  2 +-
 fs/ocfs2/journal.c                                 |  2 +-
 fs/pstore/ram_core.c                               |  2 +-
 fs/select.c                                        |  4 ++--
 kernel/bpf/hashtab.c                               |  2 +-
 kernel/bpf/lpm_trie.c                              |  2 +-
 kernel/bpf/queue_stack_maps.c                      |  2 +-
 kernel/events/callchain.c                          |  2 +-
 kernel/gcov/fs.c                                   |  2 +-
 kernel/gcov/gcc_3_4.c                              |  6 +++---
 kernel/gcov/gcc_4_7.c                              |  2 +-
 kernel/locking/lockdep.c                           |  2 +-
 kernel/module.c                                    |  4 ++--
 kernel/params.c                                    |  2 +-
 kernel/sched/fair.c                                |  2 +-
 kernel/tracepoint.c                                |  2 +-
 lib/bch.c                                          |  2 +-
 lib/objagg.c                                       |  4 ++--
 lib/ts_bm.c                                        |  2 +-
 lib/ts_fsm.c                                       |  2 +-
 lib/ts_kmp.c                                       |  2 +-
 net/batman-adv/distributed-arp-table.c             |  2 +-
 net/bridge/netfilter/ebtables.c                    |  2 +-
 net/core/bpf_sk_storage.c                          |  2 +-
 net/core/devlink.c                                 |  2 +-
 net/core/drop_monitor.c                            |  2 +-
 net/core/sock_map.c                                |  2 +-
 net/ipv4/netfilter/arp_tables.c                    |  4 ++--
 net/ipv4/netfilter/ip_tables.c                     |  4 ++--
 net/ipv6/ah6.c                                     |  2 +-
 net/ipv6/netfilter/ip6_tables.c                    |  4 ++--
 net/ipv6/seg6_iptunnel.c                           |  2 +-
 net/netfilter/ipset/ip_set_bitmap_ip.c             |  2 +-
 net/netfilter/ipset/ip_set_bitmap_ipmac.c          |  2 +-
 net/netfilter/ipset/ip_set_bitmap_port.c           |  2 +-
 net/netfilter/nfnetlink_acct.c                     |  2 +-
 net/netfilter/xt_hashlimit.c                       |  2 +-
 net/netfilter/xt_recent.c                          |  4 ++--
 net/netlink/af_netlink.c                           |  2 +-
 net/nfc/digital_dep.c                              |  4 ++--
 net/sched/em_ipt.c                                 |  2 +-
 net/sched/em_nbyte.c                               |  2 +-
 net/sched/sch_atm.c                                |  2 +-
 net/sched/sch_netem.c                              |  2 +-
 net/sunrpc/xprtrdma/svc_rdma_rw.c                  |  2 +-
 net/switchdev/switchdev.c                          |  2 +-
 samples/mei/mei-amt-version.c                      |  2 +-
 scripts/basic/fixdep.c                             |  2 +-
 scripts/mod/modpost.c                              |  2 +-
 security/apparmor/apparmorfs.c                     |  2 +-
 sound/core/oss/rate.c                              |  2 +-
 sound/pci/hda/hda_codec.c                          |  2 +-
 sound/pci/hda/patch_ca0132.c                       |  2 +-
 sound/soc/codecs/wm0010.c                          |  2 +-
 sound/usb/midi.c                                   |  2 +-
 tools/lib/bpf/libbpf.c                             |  2 +-
 tools/perf/bench/sched-messaging.c                 |  2 +-
 tools/perf/builtin-inject.c                        |  2 +-
 tools/perf/builtin-script.c                        |  2 +-
 tools/perf/builtin-timechart.c                     |  2 +-
 tools/perf/util/jitdump.c                          |  2 +-
 tools/perf/util/pstack.c                           |  2 +-
 tools/perf/util/unwind-libunwind-local.c           |  2 +-
 tools/testing/selftests/nsfs/pidns.c               |  2 +-
 247 files changed, 297 insertions(+), 297 deletions(-)

diff --git a/arch/m68k/amiga/config.c b/arch/m68k/amiga/config.c
index c32ab8041cf6..06c15374200e 100644
--- a/arch/m68k/amiga/config.c
+++ b/arch/m68k/amiga/config.c
@@ -628,7 +628,7 @@ struct savekmsg {
 	unsigned long magic2;		/* SAVEKMSG_MAGIC2 */
 	unsigned long magicptr;		/* address of magic1 */
 	unsigned long size;
-	char data[0];
+	char data[];
 };
 
 static struct savekmsg *savekmsg;
diff --git a/arch/m68k/tools/amiga/dmesg.c b/arch/m68k/tools/amiga/dmesg.c
index 7340f5b6cf6d..5c466b07ea90 100644
--- a/arch/m68k/tools/amiga/dmesg.c
+++ b/arch/m68k/tools/amiga/dmesg.c
@@ -34,7 +34,7 @@ struct savekmsg {
     u_long magic2;	/* SAVEKMSG_MAGIC2 */
     u_long magicptr;	/* address of magic1 */
     u_long size;
-    char data[0];
+	char data[];
 };
 
 
diff --git a/arch/mips/kernel/signal.c b/arch/mips/kernel/signal.c
index f6efabcb4e92..4ee626049d92 100644
--- a/arch/mips/kernel/signal.c
+++ b/arch/mips/kernel/signal.c
@@ -52,7 +52,7 @@ struct sigframe {
 	/* Matches struct ucontext from its uc_mcontext field onwards */
 	struct sigcontext sf_sc;
 	sigset_t sf_mask;
-	unsigned long long sf_extcontext[0];
+	unsigned long long sf_extcontext[];
 };
 
 struct rt_sigframe {
diff --git a/arch/powerpc/mm/hugetlbpage.c b/arch/powerpc/mm/hugetlbpage.c
index 73d4873fc7f8..08eb7e046c6c 100644
--- a/arch/powerpc/mm/hugetlbpage.c
+++ b/arch/powerpc/mm/hugetlbpage.c
@@ -246,7 +246,7 @@ int __init alloc_bootmem_huge_page(struct hstate *h)
 struct hugepd_freelist {
 	struct rcu_head	rcu;
 	unsigned int index;
-	void *ptes[0];
+	void *ptes[];
 };
 
 static DEFINE_PER_CPU(struct hugepd_freelist *, hugepd_freelist_cur);
diff --git a/arch/powerpc/platforms/powermac/nvram.c b/arch/powerpc/platforms/powermac/nvram.c
index dc7a5bae8f1c..2b00e1621043 100644
--- a/arch/powerpc/platforms/powermac/nvram.c
+++ b/arch/powerpc/platforms/powermac/nvram.c
@@ -55,7 +55,7 @@ struct chrp_header {
   u8		cksum;
   u16		len;
   char          name[12];
-  u8		data[0];
+	u8		data[];
 };
 
 struct core99_header {
diff --git a/arch/s390/appldata/appldata_os.c b/arch/s390/appldata/appldata_os.c
index 54f375627532..8bf46d705957 100644
--- a/arch/s390/appldata/appldata_os.c
+++ b/arch/s390/appldata/appldata_os.c
@@ -75,7 +75,7 @@ struct appldata_os_data {
 				   (waiting for I/O)               */
 
 	/* per cpu data */
-	struct appldata_os_per_cpu os_cpu[0];
+	struct appldata_os_per_cpu os_cpu[];
 } __attribute__((packed));
 
 static struct appldata_os_data *appldata_os_data;
diff --git a/arch/sparc/kernel/cpumap.c b/arch/sparc/kernel/cpumap.c
index 1cb62bfeaa1f..f07ea88a83af 100644
--- a/arch/sparc/kernel/cpumap.c
+++ b/arch/sparc/kernel/cpumap.c
@@ -50,7 +50,7 @@ struct cpuinfo_tree {
 
 	/* Offsets into nodes[] for each level of the tree */
 	struct cpuinfo_level level[CPUINFO_LVL_MAX];
-	struct cpuinfo_node  nodes[0];
+	struct cpuinfo_node  nodes[];
 };
 
 
diff --git a/arch/sparc/kernel/ds.c b/arch/sparc/kernel/ds.c
index bbf59b3b4af8..9e70b51cb075 100644
--- a/arch/sparc/kernel/ds.c
+++ b/arch/sparc/kernel/ds.c
@@ -87,7 +87,7 @@ struct ds_reg_req {
 	__u64			handle;
 	__u16			major;
 	__u16			minor;
-	char			svc_id[0];
+	char			svc_id[];
 };
 
 struct ds_reg_ack {
@@ -701,12 +701,12 @@ struct ds_var_hdr {
 
 struct ds_var_set_msg {
 	struct ds_var_hdr		hdr;
-	char				name_and_value[0];
+	char				name_and_value[];
 };
 
 struct ds_var_delete_msg {
 	struct ds_var_hdr		hdr;
-	char				name[0];
+	char				name[];
 };
 
 struct ds_var_resp {
@@ -989,7 +989,7 @@ struct ds_queue_entry {
 	struct ds_info			*dp;
 	int				req_len;
 	int				__pad;
-	u64				req[0];
+	u64				req[];
 };
 
 static void process_ds_work(void)
diff --git a/arch/x86/events/intel/bts.c b/arch/x86/events/intel/bts.c
index 6a3b599ee0fe..731dd8d0dbb1 100644
--- a/arch/x86/events/intel/bts.c
+++ b/arch/x86/events/intel/bts.c
@@ -58,7 +58,7 @@ struct bts_buffer {
 	local_t		head;
 	unsigned long	end;
 	void		**data_pages;
-	struct bts_phys	buf[0];
+	struct bts_phys	buf[];
 };
 
 static struct pmu bts_pmu;
diff --git a/drivers/amba/tegra-ahb.c b/drivers/amba/tegra-ahb.c
index 57d3b2e2d007..0b2c20fddb7c 100644
--- a/drivers/amba/tegra-ahb.c
+++ b/drivers/amba/tegra-ahb.c
@@ -120,7 +120,7 @@ static const u32 tegra_ahb_gizmo[] = {
 struct tegra_ahb {
 	void __iomem	*regs;
 	struct device	*dev;
-	u32		ctx[0];
+	u32		ctx[];
 };
 
 static inline u32 gizmo_readl(struct tegra_ahb *ahb, u32 offset)
diff --git a/drivers/auxdisplay/charlcd.c b/drivers/auxdisplay/charlcd.c
index 874c259a8829..c0da3820454b 100644
--- a/drivers/auxdisplay/charlcd.c
+++ b/drivers/auxdisplay/charlcd.c
@@ -88,7 +88,7 @@ struct charlcd_priv {
 		int len;
 	} esc_seq;
 
-	unsigned long long drvdata[0];
+	unsigned long long drvdata[];
 };
 
 #define charlcd_to_priv(p)	container_of(p, struct charlcd_priv, lcd)
diff --git a/drivers/block/rsxx/dma.c b/drivers/block/rsxx/dma.c
index 111eb659e66d..1914f5488b22 100644
--- a/drivers/block/rsxx/dma.c
+++ b/drivers/block/rsxx/dma.c
@@ -80,7 +80,7 @@ struct dma_tracker {
 struct dma_tracker_list {
 	spinlock_t		lock;
 	int			head;
-	struct dma_tracker	list[0];
+	struct dma_tracker	list[];
 };
 
 
diff --git a/drivers/bluetooth/btintel.c b/drivers/bluetooth/btintel.c
index 62e781a18bf0..6a0e2c5a8beb 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -376,13 +376,13 @@ struct ibt_cp_reg_access {
 	__le32  addr;
 	__u8    mode;
 	__u8    len;
-	__u8    data[0];
+	__u8    data[];
 } __packed;
 
 struct ibt_rp_reg_access {
 	__u8    status;
 	__le32  addr;
-	__u8    data[0];
+	__u8    data[];
 } __packed;
 
 static int regmap_ibt_read(void *context, const void *addr, size_t reg_size,
diff --git a/drivers/bluetooth/hci_ag6xx.c b/drivers/bluetooth/hci_ag6xx.c
index 8bafa650b5b0..1f55df93e4ce 100644
--- a/drivers/bluetooth/hci_ag6xx.c
+++ b/drivers/bluetooth/hci_ag6xx.c
@@ -27,7 +27,7 @@ struct ag6xx_data {
 struct pbn_entry {
 	__le32 addr;
 	__le32 plen;
-	__u8 data[0];
+	__u8 data[];
 } __packed;
 
 static int ag6xx_open(struct hci_uart *hu)
diff --git a/drivers/bluetooth/hci_intel.c b/drivers/bluetooth/hci_intel.c
index 31f25153087d..f1299da6eed8 100644
--- a/drivers/bluetooth/hci_intel.c
+++ b/drivers/bluetooth/hci_intel.c
@@ -49,7 +49,7 @@
 struct hci_lpm_pkt {
 	__u8 opcode;
 	__u8 dlen;
-	__u8 data[0];
+	__u8 data[];
 } __packed;
 
 struct intel_device {
diff --git a/drivers/char/mspec.c b/drivers/char/mspec.c
index a9d9f074fbd6..7d583222e8fa 100644
--- a/drivers/char/mspec.c
+++ b/drivers/char/mspec.c
@@ -75,7 +75,7 @@ struct vma_data {
 	enum mspec_page_type type; /* Type of pages allocated. */
 	unsigned long vm_start;	/* Original (unsplit) base. */
 	unsigned long vm_end;	/* Original (unsplit) end. */
-	unsigned long maddr[0];	/* Array of MSPEC addresses. */
+	unsigned long maddr[];	/* Array of MSPEC addresses. */
 };
 
 /*
diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index 4df9b40d6342..3cbaec925606 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -112,7 +112,7 @@ struct port_buffer {
 	unsigned int sgpages;
 
 	/* sg is used if spages > 0. sg must be the last in is struct */
-	struct scatterlist sg[0];
+	struct scatterlist sg[];
 };
 
 /*
diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index ef1a65f4fc92..2c3f917c10aa 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -895,7 +895,7 @@ struct skcipher_edesc {
 	int sec4_sg_bytes;
 	dma_addr_t sec4_sg_dma;
 	struct sec4_sg_entry *sec4_sg;
-	u32 hw_desc[0];
+	u32 hw_desc[];
 };
 
 static void caam_unmap(struct device *dev, struct scatterlist *src,
diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index 4a29e0ef9d63..27e36bdf6163 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -783,7 +783,7 @@ struct aead_edesc {
 	unsigned int assoclen;
 	dma_addr_t assoclen_dma;
 	struct caam_drv_req drv_req;
-	struct qm_sg_entry sgt[0];
+	struct qm_sg_entry sgt[];
 };
 
 /*
@@ -803,7 +803,7 @@ struct skcipher_edesc {
 	int qm_sg_bytes;
 	dma_addr_t qm_sg_dma;
 	struct caam_drv_req drv_req;
-	struct qm_sg_entry sgt[0];
+	struct qm_sg_entry sgt[];
 };
 
 static struct caam_drv_ctx *get_drv_ctx(struct caam_ctx *ctx,
diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 8d9143407fc5..b352dc5c62c1 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -529,7 +529,7 @@ struct ahash_edesc {
 	int src_nents;
 	int sec4_sg_bytes;
 	u32 hw_desc[DESC_JOB_IO_LEN_MAX / sizeof(u32)] ____cacheline_aligned;
-	struct sec4_sg_entry sec4_sg[0];
+	struct sec4_sg_entry sec4_sg[];
 };
 
 static inline void ahash_unmap(struct device *dev,
diff --git a/drivers/crypto/cavium/nitrox/nitrox_main.c b/drivers/crypto/cavium/nitrox/nitrox_main.c
index c4632d84c9a1..e91be9b8b083 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_main.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_main.c
@@ -71,7 +71,7 @@ struct ucode {
 	char version[VERSION_LEN - 1];
 	__be32 code_size;
 	u8 raz[12];
-	u64 code[0];
+	u64 code[];
 };
 
 /**
diff --git a/drivers/crypto/img-hash.c b/drivers/crypto/img-hash.c
index 25d5227f74a1..0e25fc3087f3 100644
--- a/drivers/crypto/img-hash.c
+++ b/drivers/crypto/img-hash.c
@@ -103,7 +103,7 @@ struct img_hash_request_ctx {
 	struct ahash_request	fallback_req;
 
 	/* Zero length buffer must remain last member of struct */
-	u8 buffer[0] __aligned(sizeof(u32));
+	u8 buffer[] __aligned(sizeof(u32));
 };
 
 struct img_hash_ctx {
diff --git a/drivers/crypto/mediatek/mtk-sha.c b/drivers/crypto/mediatek/mtk-sha.c
index 9e9f48bb7f85..bd6309e57ab8 100644
--- a/drivers/crypto/mediatek/mtk-sha.c
+++ b/drivers/crypto/mediatek/mtk-sha.c
@@ -107,7 +107,7 @@ struct mtk_sha_ctx {
 	u8 id;
 	u8 buf[SHA_BUF_SIZE] __aligned(sizeof(u32));
 
-	struct mtk_sha_hmac_ctx	base[0];
+	struct mtk_sha_hmac_ctx	base[];
 };
 
 struct mtk_sha_drv {
diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 4f915a4ef5b0..e4072cd38585 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -159,7 +159,7 @@ struct omap_sham_reqctx {
 	int			sg_len;
 	unsigned int		total;	/* total request */
 
-	u8			buffer[0] OMAP_ALIGNED;
+	u8			buffer[] OMAP_ALIGNED;
 };
 
 struct omap_sham_hmac_ctx {
@@ -176,7 +176,7 @@ struct omap_sham_ctx {
 	/* fallback stuff */
 	struct crypto_shash	*fallback;
 
-	struct omap_sham_hmac_ctx base[0];
+	struct omap_sham_hmac_ctx base[];
 };
 
 #define OMAP_SHAM_QUEUE_LENGTH	10
diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index d66e20a2f54c..2a16800d2579 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -369,7 +369,7 @@ struct s5p_hash_reqctx {
 	bool			error;
 
 	u32			bufcnt;
-	u8			buffer[0];
+	u8			buffer[];
 };
 
 /**
diff --git a/drivers/dma/at_xdmac.c b/drivers/dma/at_xdmac.c
index f71c9f77d405..1e9971a3d06d 100644
--- a/drivers/dma/at_xdmac.c
+++ b/drivers/dma/at_xdmac.c
@@ -212,7 +212,7 @@ struct at_xdmac {
 	struct clk		*clk;
 	u32			save_gim;
 	struct dma_pool		*at_xdmac_desc_pool;
-	struct at_xdmac_chan	chan[0];
+	struct at_xdmac_chan	chan[];
 };
 
 
diff --git a/drivers/dma/bcm-sba-raid.c b/drivers/dma/bcm-sba-raid.c
index 275e90fa829d..64239da02e74 100644
--- a/drivers/dma/bcm-sba-raid.c
+++ b/drivers/dma/bcm-sba-raid.c
@@ -120,7 +120,7 @@ struct sba_request {
 	struct brcm_message msg;
 	struct dma_async_tx_descriptor tx;
 	/* SBA commands */
-	struct brcm_sba_command cmds[0];
+	struct brcm_sba_command cmds[];
 };
 
 enum sba_version {
diff --git a/drivers/dma/ioat/dca.c b/drivers/dma/ioat/dca.c
index be61c32a876f..0be385587c4c 100644
--- a/drivers/dma/ioat/dca.c
+++ b/drivers/dma/ioat/dca.c
@@ -102,7 +102,7 @@ struct ioat_dca_priv {
 	int			 max_requesters;
 	int			 requester_count;
 	u8			 tag_map[IOAT_TAG_MAP_LEN];
-	struct ioat_dca_slot 	 req_slots[0];
+	struct ioat_dca_slot	 req_slots[];
 };
 
 static int ioat_dca_dev_managed(struct dca_provider *dca,
diff --git a/drivers/dma/moxart-dma.c b/drivers/dma/moxart-dma.c
index e04499c1f27f..2a77fa319d78 100644
--- a/drivers/dma/moxart-dma.c
+++ b/drivers/dma/moxart-dma.c
@@ -127,7 +127,7 @@ struct moxart_desc {
 	unsigned int			dma_cycles;
 	struct virt_dma_desc		vd;
 	uint8_t				es;
-	struct moxart_sg		sg[0];
+	struct moxart_sg		sg[];
 };
 
 struct moxart_chan {
diff --git a/drivers/dma/qcom/bam_dma.c b/drivers/dma/qcom/bam_dma.c
index ef73f65224b1..5a08dd0d3388 100644
--- a/drivers/dma/qcom/bam_dma.c
+++ b/drivers/dma/qcom/bam_dma.c
@@ -74,7 +74,7 @@ struct bam_async_desc {
 	struct list_head desc_node;
 	enum dma_transfer_direction dir;
 	size_t length;
-	struct bam_desc_hw desc[0];
+	struct bam_desc_hw desc[];
 };
 
 enum bam_reg {
diff --git a/drivers/dma/sa11x0-dma.c b/drivers/dma/sa11x0-dma.c
index afb68055ed1b..0fa7f14a65a1 100644
--- a/drivers/dma/sa11x0-dma.c
+++ b/drivers/dma/sa11x0-dma.c
@@ -78,7 +78,7 @@ struct sa11x0_dma_desc {
 	bool			cyclic;
 
 	unsigned		sglen;
-	struct sa11x0_dma_sg	sg[0];
+	struct sa11x0_dma_sg	sg[];
 };
 
 struct sa11x0_dma_phy;
diff --git a/drivers/dma/sprd-dma.c b/drivers/dma/sprd-dma.c
index 9a31a315dbef..954eff32cc05 100644
--- a/drivers/dma/sprd-dma.c
+++ b/drivers/dma/sprd-dma.c
@@ -212,7 +212,7 @@ struct sprd_dma_dev {
 	struct clk		*ashb_clk;
 	int			irq;
 	u32			total_chns;
-	struct sprd_dma_chn	channels[0];
+	struct sprd_dma_chn	channels[];
 };
 
 static void sprd_dma_free_desc(struct virt_dma_desc *vd);
diff --git a/drivers/dma/tegra20-apb-dma.c b/drivers/dma/tegra20-apb-dma.c
index 3a45079d11ec..cbb9f636ff2d 100644
--- a/drivers/dma/tegra20-apb-dma.c
+++ b/drivers/dma/tegra20-apb-dma.c
@@ -226,7 +226,7 @@ struct tegra_dma {
 	u32				reg_gen;
 
 	/* Last member of the structure */
-	struct tegra_dma_channel channels[0];
+	struct tegra_dma_channel channels[];
 };
 
 static inline void tdma_write(struct tegra_dma *tdma, u32 reg, u32 val)
diff --git a/drivers/dma/tegra210-adma.c b/drivers/dma/tegra210-adma.c
index 6e1268552f74..c4ce5dfb149b 100644
--- a/drivers/dma/tegra210-adma.c
+++ b/drivers/dma/tegra210-adma.c
@@ -164,7 +164,7 @@ struct tegra_adma {
 	const struct tegra_adma_chip_data *cdata;
 
 	/* Last member of the structure */
-	struct tegra_adma_chan		channels[0];
+	struct tegra_adma_chan		channels[];
 };
 
 static inline void tdma_write(struct tegra_adma *tdma, u32 reg, u32 val)
diff --git a/drivers/dma/ti/edma.c b/drivers/dma/ti/edma.c
index 03a7f647f7b2..5689f3a19fc5 100644
--- a/drivers/dma/ti/edma.c
+++ b/drivers/dma/ti/edma.c
@@ -211,7 +211,7 @@ struct edma_desc {
 	u32				residue;
 	u32				residue_stat;
 
-	struct edma_pset		pset[0];
+	struct edma_pset		pset[];
 };
 
 struct edma_cc;
diff --git a/drivers/dma/ti/omap-dma.c b/drivers/dma/ti/omap-dma.c
index a014ab96e673..918301e17552 100644
--- a/drivers/dma/ti/omap-dma.c
+++ b/drivers/dma/ti/omap-dma.c
@@ -124,7 +124,7 @@ struct omap_desc {
 	uint32_t csdp;		/* CSDP value */
 
 	unsigned sglen;
-	struct omap_sg sg[0];
+	struct omap_sg sg[];
 };
 
 enum {
diff --git a/drivers/dma/timb_dma.c b/drivers/dma/timb_dma.c
index 39382694fdfc..68e48bf54d78 100644
--- a/drivers/dma/timb_dma.c
+++ b/drivers/dma/timb_dma.c
@@ -88,7 +88,7 @@ struct timb_dma {
 	struct dma_device	dma;
 	void __iomem		*membase;
 	struct tasklet_struct	tasklet;
-	struct timb_dma_chan	channels[0];
+	struct timb_dma_chan	channels[];
 };
 
 static struct device *chan2dev(struct dma_chan *chan)
diff --git a/drivers/dma/uniphier-mdmac.c b/drivers/dma/uniphier-mdmac.c
index 21b8f1131d55..618839df0748 100644
--- a/drivers/dma/uniphier-mdmac.c
+++ b/drivers/dma/uniphier-mdmac.c
@@ -68,7 +68,7 @@ struct uniphier_mdmac_device {
 	struct dma_device ddev;
 	struct clk *clk;
 	void __iomem *reg_base;
-	struct uniphier_mdmac_chan channels[0];
+	struct uniphier_mdmac_chan channels[];
 };
 
 static struct uniphier_mdmac_chan *
diff --git a/drivers/firewire/core-cdev.c b/drivers/firewire/core-cdev.c
index 6e291d8f3a27..e6fc20dff687 100644
--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -117,7 +117,7 @@ struct inbound_transaction_resource {
 struct descriptor_resource {
 	struct client_resource resource;
 	struct fw_descriptor descriptor;
-	u32 data[0];
+	u32 data[];
 };
 
 struct iso_resource {
diff --git a/drivers/firewire/core-transaction.c b/drivers/firewire/core-transaction.c
index 404a035f104d..439d918bbaaf 100644
--- a/drivers/firewire/core-transaction.c
+++ b/drivers/firewire/core-transaction.c
@@ -620,7 +620,7 @@ struct fw_request {
 	u32 request_header[4];
 	int ack;
 	u32 length;
-	u32 data[0];
+	u32 data[];
 };
 
 static void free_response_callback(struct fw_packet *packet,
diff --git a/drivers/firewire/nosy.c b/drivers/firewire/nosy.c
index 6ca2f5ab6c57..5fd6a60b6741 100644
--- a/drivers/firewire/nosy.c
+++ b/drivers/firewire/nosy.c
@@ -52,7 +52,7 @@ struct pcl {
 
 struct packet {
 	unsigned int length;
-	char data[0];
+	char data[];
 };
 
 struct packet_buffer {
diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index 33269316f111..54fdc39cd0bc 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -111,7 +111,7 @@ struct descriptor_buffer {
 	dma_addr_t buffer_bus;
 	size_t buffer_size;
 	size_t used;
-	struct descriptor buffer[0];
+	struct descriptor buffer[];
 };
 
 struct context {
diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index 2c96f6b5a7d8..c5469d10434e 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -161,7 +161,7 @@ struct scmi_shared_mem {
 #define SCMI_SHMEM_FLAG_INTR_ENABLED	BIT(0)
 	__le32 length;
 	__le32 msg_header;
-	u8 msg_payload[0];
+	u8 msg_payload[];
 };
 
 static const int scmi_linux_errmap[] = {
diff --git a/drivers/firmware/arm_scmi/perf.c b/drivers/firmware/arm_scmi/perf.c
index ec81e6f7e7a4..34f3a917dd8d 100644
--- a/drivers/firmware/arm_scmi/perf.c
+++ b/drivers/firmware/arm_scmi/perf.c
@@ -89,7 +89,7 @@ struct scmi_msg_resp_perf_describe_levels {
 		__le32 power;
 		__le16 transition_latency_us;
 		__le16 reserved;
-	} opp[0];
+	} opp[];
 };
 
 struct scmi_perf_get_fc_info {
diff --git a/drivers/firmware/arm_scpi.c b/drivers/firmware/arm_scpi.c
index a80c331c3a6e..d0dee37ad522 100644
--- a/drivers/firmware/arm_scpi.c
+++ b/drivers/firmware/arm_scpi.c
@@ -262,12 +262,12 @@ struct scpi_drvinfo {
 struct scpi_shared_mem {
 	__le32 command;
 	__le32 status;
-	u8 payload[0];
+	u8 payload[];
 } __packed;
 
 struct legacy_scpi_shared_mem {
 	__le32 status;
-	u8 payload[0];
+	u8 payload[];
 } __packed;
 
 struct scp_capabilities {
diff --git a/drivers/firmware/dmi-sysfs.c b/drivers/firmware/dmi-sysfs.c
index b6180023eba7..8b8127fa8955 100644
--- a/drivers/firmware/dmi-sysfs.c
+++ b/drivers/firmware/dmi-sysfs.c
@@ -262,7 +262,7 @@ struct dmi_system_event_log {
 	u8	header_format;
 	u8	type_descriptors_supported_count;
 	u8	per_log_type_descriptor_length;
-	u8	supported_log_type_descriptos[0];
+	u8	supported_log_type_descriptos[];
 } __packed;
 
 #define DMI_SYSFS_SEL_FIELD(_field) \
diff --git a/drivers/firmware/efi/apple-properties.c b/drivers/firmware/efi/apple-properties.c
index 5ccf39986a14..084942846f4d 100644
--- a/drivers/firmware/efi/apple-properties.c
+++ b/drivers/firmware/efi/apple-properties.c
@@ -31,7 +31,7 @@ __setup("dump_apple_properties", dump_properties_enable);
 struct dev_header {
 	u32 len;
 	u32 prop_count;
-	struct efi_dev_path path[0];
+	struct efi_dev_path path[];
 	/*
 	 * followed by key/value pairs, each key and value preceded by u32 len,
 	 * len includes itself, value may be empty (in which case its len is 4)
@@ -42,7 +42,7 @@ struct properties_header {
 	u32 len;
 	u32 version;
 	u32 dev_count;
-	struct dev_header dev_header[0];
+	struct dev_header dev_header[];
 };
 
 static void __init unmarshal_key_value_pairs(struct dev_header *dev_header,
diff --git a/drivers/firmware/google/memconsole-coreboot.c b/drivers/firmware/google/memconsole-coreboot.c
index fd7f0fbec07e..d17e4d6ac9bc 100644
--- a/drivers/firmware/google/memconsole-coreboot.c
+++ b/drivers/firmware/google/memconsole-coreboot.c
@@ -21,7 +21,7 @@
 struct cbmem_cons {
 	u32 size_dont_access_after_boot;
 	u32 cursor;
-	u8  body[0];
+	u8  body[];
 } __packed;
 
 #define CURSOR_MASK ((1 << 28) - 1)
diff --git a/drivers/firmware/google/vpd.c b/drivers/firmware/google/vpd.c
index db0812263d46..d23c5c69ab52 100644
--- a/drivers/firmware/google/vpd.c
+++ b/drivers/firmware/google/vpd.c
@@ -32,7 +32,7 @@ struct vpd_cbmem {
 	u32 version;
 	u32 ro_size;
 	u32 rw_size;
-	u8  blob[0];
+	u8  blob[];
 };
 
 struct vpd_section {
diff --git a/drivers/gpio/gpio-uniphier.c b/drivers/gpio/gpio-uniphier.c
index 7ec97499b7f7..f99f3c10bed0 100644
--- a/drivers/gpio/gpio-uniphier.c
+++ b/drivers/gpio/gpio-uniphier.c
@@ -30,7 +30,7 @@ struct uniphier_gpio_priv {
 	struct irq_domain *domain;
 	void __iomem *regs;
 	spinlock_t lock;
-	u32 saved_vals[0];
+	u32 saved_vals[];
 };
 
 static unsigned int uniphier_gpio_bank_to_reg(unsigned int bank)
diff --git a/drivers/gpu/drm/i915/gt/intel_lrc.c b/drivers/gpu/drm/i915/gt/intel_lrc.c
index 0cf0f6fae675..cf03dac2c3b3 100644
--- a/drivers/gpu/drm/i915/gt/intel_lrc.c
+++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
@@ -218,7 +218,7 @@ struct virtual_engine {
 
 	/* And finally, which physical engines this virtual engine maps onto. */
 	unsigned int num_siblings;
-	struct intel_engine_cs *siblings[0];
+	struct intel_engine_cs *siblings[];
 };
 
 static struct virtual_engine *to_virtual_engine(struct intel_engine_cs *engine)
diff --git a/drivers/gpu/drm/qxl/qxl_cmd.c b/drivers/gpu/drm/qxl/qxl_cmd.c
index ef09dc6bc635..d1086b2a6892 100644
--- a/drivers/gpu/drm/qxl/qxl_cmd.c
+++ b/drivers/gpu/drm/qxl/qxl_cmd.c
@@ -36,7 +36,7 @@ static int qxl_reap_surface_id(struct qxl_device *qdev, int max_to_reap);
 
 struct ring {
 	struct qxl_ring_header      header;
-	uint8_t                     elements[0];
+	uint8_t                     elements[];
 };
 
 struct qxl_ring {
diff --git a/drivers/hwmon/ibmaem.c b/drivers/hwmon/ibmaem.c
index d05ab713566d..a4ec85207782 100644
--- a/drivers/hwmon/ibmaem.c
+++ b/drivers/hwmon/ibmaem.c
@@ -219,7 +219,7 @@ struct aem_read_sensor_req {
 
 struct aem_read_sensor_resp {
 	struct aem_iana_id	id;
-	u8			bytes[0];
+	u8			bytes[];
 } __packed;
 
 /* Data structures to talk to the IPMI layer */
diff --git a/drivers/hwtracing/stm/policy.c b/drivers/hwtracing/stm/policy.c
index 4f932a419752..603b4a9969d3 100644
--- a/drivers/hwtracing/stm/policy.c
+++ b/drivers/hwtracing/stm/policy.c
@@ -34,7 +34,7 @@ struct stp_policy_node {
 	unsigned int		first_channel;
 	unsigned int		last_channel;
 	/* this is the one that's exposed to the attributes */
-	unsigned char		priv[0];
+	unsigned char		priv[];
 };
 
 void *stp_policy_node_priv(struct stp_policy_node *pn)
diff --git a/drivers/i3c/master/dw-i3c-master.c b/drivers/i3c/master/dw-i3c-master.c
index bd26c3b9634e..5c5306cd50ec 100644
--- a/drivers/i3c/master/dw-i3c-master.c
+++ b/drivers/i3c/master/dw-i3c-master.c
@@ -221,7 +221,7 @@ struct dw_i3c_xfer {
 	struct completion comp;
 	int ret;
 	unsigned int ncmds;
-	struct dw_i3c_cmd cmds[0];
+	struct dw_i3c_cmd cmds[];
 };
 
 struct dw_i3c_master {
diff --git a/drivers/i3c/master/i3c-master-cdns.c b/drivers/i3c/master/i3c-master-cdns.c
index 54712793709e..3fee8bd7fe20 100644
--- a/drivers/i3c/master/i3c-master-cdns.c
+++ b/drivers/i3c/master/i3c-master-cdns.c
@@ -388,7 +388,7 @@ struct cdns_i3c_xfer {
 	struct completion comp;
 	int ret;
 	unsigned int ncmds;
-	struct cdns_i3c_cmd cmds[0];
+	struct cdns_i3c_cmd cmds[];
 };
 
 struct cdns_i3c_data {
diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index 17bfedd24cc3..dedfbe27916f 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -46,7 +46,7 @@
 
 struct ib_pkey_cache {
 	int             table_len;
-	u16             table[0];
+	u16             table[];
 };
 
 struct ib_update_work {
diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 68cc1b2d6824..8424abe83607 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -197,7 +197,7 @@ struct cm_device {
 	struct ib_device *ib_device;
 	u8 ack_delay;
 	int going_down;
-	struct cm_port *port[0];
+	struct cm_port *port[];
 };
 
 struct cm_av {
@@ -216,7 +216,7 @@ struct cm_work {
 	__be32 local_id;			/* Established / timewait */
 	__be32 remote_id;
 	struct ib_cm_event cm_event;
-	struct sa_path_rec path[0];
+	struct sa_path_rec path[];
 };
 
 struct cm_timewait_info {
diff --git a/drivers/infiniband/core/multicast.c b/drivers/infiniband/core/multicast.c
index cd338ddc4a39..9c2d8b7f1af9 100644
--- a/drivers/infiniband/core/multicast.c
+++ b/drivers/infiniband/core/multicast.c
@@ -71,7 +71,7 @@ struct mcast_device {
 	struct ib_event_handler	event_handler;
 	int			start_port;
 	int			end_port;
-	struct mcast_port	port[0];
+	struct mcast_port	port[];
 };
 
 enum mcast_state {
diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index 30d4c126a2db..74e0058fcf9e 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -101,7 +101,7 @@ struct ib_sa_port {
 struct ib_sa_device {
 	int                     start_port, end_port;
 	struct ib_event_handler event_handler;
-	struct ib_sa_port port[0];
+	struct ib_sa_port port[];
 };
 
 struct ib_sa_query {
diff --git a/drivers/infiniband/hw/hfi1/mad.c b/drivers/infiniband/hw/hfi1/mad.c
index a51bcd2b4391..7073f237a949 100644
--- a/drivers/infiniband/hw/hfi1/mad.c
+++ b/drivers/infiniband/hw/hfi1/mad.c
@@ -2381,7 +2381,7 @@ struct opa_port_status_rsp {
 		__be64 port_vl_rcv_bubble;
 		__be64 port_vl_mark_fecn;
 		__be64 port_vl_xmit_discards;
-	} vls[0]; /* real array size defined by # bits set in vl_select_mask */
+	} vls[]; /* real array size defined by # bits set in vl_select_mask */
 };
 
 enum counter_selects {
@@ -2423,7 +2423,7 @@ struct opa_aggregate {
 	__be16 attr_id;
 	__be16 err_reqlength;	/* 1 bit, 8 res, 7 bit */
 	__be32 attr_mod;
-	u8 data[0];
+	u8 data[];
 };
 
 #define MSK_LLI 0x000000f0
diff --git a/drivers/infiniband/hw/hfi1/sdma.c b/drivers/infiniband/hw/hfi1/sdma.c
index a51525647ac8..c93ea021cf49 100644
--- a/drivers/infiniband/hw/hfi1/sdma.c
+++ b/drivers/infiniband/hw/hfi1/sdma.c
@@ -833,7 +833,7 @@ struct sdma_engine *sdma_select_engine_sc(
 struct sdma_rht_map_elem {
 	u32 mask;
 	u8 ctr;
-	struct sdma_engine *sde[0];
+	struct sdma_engine *sde[];
 };
 
 struct sdma_rht_node {
diff --git a/drivers/infiniband/hw/mthca/mthca_memfree.c b/drivers/infiniband/hw/mthca/mthca_memfree.c
index 78a48aea3faf..dc10376f09cb 100644
--- a/drivers/infiniband/hw/mthca/mthca_memfree.c
+++ b/drivers/infiniband/hw/mthca/mthca_memfree.c
@@ -58,7 +58,7 @@ struct mthca_user_db_table {
 		u64                uvirt;
 		struct scatterlist mem;
 		int                refcount;
-	}                page[0];
+	}                page[];
 };
 
 static void mthca_free_icm_pages(struct mthca_dev *dev, struct mthca_icm_chunk *chunk)
diff --git a/drivers/input/keyboard/applespi.c b/drivers/input/keyboard/applespi.c
index d38398526965..14362ebab9a9 100644
--- a/drivers/input/keyboard/applespi.c
+++ b/drivers/input/keyboard/applespi.c
@@ -186,7 +186,7 @@ struct touchpad_protocol {
 	u8			number_of_fingers;
 	u8			clicked2;
 	u8			unknown3[16];
-	struct tp_finger	fingers[0];
+	struct tp_finger	fingers[];
 };
 
 /**
diff --git a/drivers/input/keyboard/goldfish_events.c b/drivers/input/keyboard/goldfish_events.c
index bc8c85a52a10..57d435fc5c73 100644
--- a/drivers/input/keyboard/goldfish_events.c
+++ b/drivers/input/keyboard/goldfish_events.c
@@ -30,7 +30,7 @@ struct event_dev {
 	struct input_dev *input;
 	int irq;
 	void __iomem *addr;
-	char name[0];
+	char name[];
 };
 
 static irqreturn_t events_interrupt(int irq, void *dev_id)
diff --git a/drivers/input/keyboard/gpio_keys.c b/drivers/input/keyboard/gpio_keys.c
index 1f56d53454b2..53c9ff338dea 100644
--- a/drivers/input/keyboard/gpio_keys.c
+++ b/drivers/input/keyboard/gpio_keys.c
@@ -55,7 +55,7 @@ struct gpio_keys_drvdata {
 	struct input_dev *input;
 	struct mutex disable_lock;
 	unsigned short *keymap;
-	struct gpio_button_data data[0];
+	struct gpio_button_data data[];
 };
 
 /*
diff --git a/drivers/input/keyboard/gpio_keys_polled.c b/drivers/input/keyboard/gpio_keys_polled.c
index 6eb0a2f3f9de..c3937d2fc744 100644
--- a/drivers/input/keyboard/gpio_keys_polled.c
+++ b/drivers/input/keyboard/gpio_keys_polled.c
@@ -38,7 +38,7 @@ struct gpio_keys_polled_dev {
 	const struct gpio_keys_platform_data *pdata;
 	unsigned long rel_axis_seen[BITS_TO_LONGS(REL_CNT)];
 	unsigned long abs_axis_seen[BITS_TO_LONGS(ABS_CNT)];
-	struct gpio_keys_button_data data[0];
+	struct gpio_keys_button_data data[];
 };
 
 static void gpio_keys_button_event(struct input_dev *input,
diff --git a/drivers/input/keyboard/tca6416-keypad.c b/drivers/input/keyboard/tca6416-keypad.c
index 2a14769de637..21758767ccf0 100644
--- a/drivers/input/keyboard/tca6416-keypad.c
+++ b/drivers/input/keyboard/tca6416-keypad.c
@@ -33,7 +33,7 @@ MODULE_DEVICE_TABLE(i2c, tca6416_id);
 
 struct tca6416_drv_data {
 	struct input_dev *input;
-	struct tca6416_button data[0];
+	struct tca6416_button data[];
 };
 
 struct tca6416_keypad_chip {
@@ -48,7 +48,7 @@ struct tca6416_keypad_chip {
 	int irqnum;
 	u16 pinmask;
 	bool use_polling;
-	struct tca6416_button buttons[0];
+	struct tca6416_button buttons[];
 };
 
 static int tca6416_write_reg(struct tca6416_keypad_chip *chip, int reg, u16 val)
diff --git a/drivers/input/mouse/cyapa_gen5.c b/drivers/input/mouse/cyapa_gen5.c
index 14239fbd72cf..7f012bfa2658 100644
--- a/drivers/input/mouse/cyapa_gen5.c
+++ b/drivers/input/mouse/cyapa_gen5.c
@@ -250,7 +250,7 @@ struct cyapa_tsg_bin_image_data_record {
 
 struct cyapa_tsg_bin_image {
 	struct cyapa_tsg_bin_image_head image_head;
-	struct cyapa_tsg_bin_image_data_record records[0];
+	struct cyapa_tsg_bin_image_data_record records[];
 } __packed;
 
 struct pip_bl_packet_start {
@@ -271,7 +271,7 @@ struct pip_bl_cmd_head {
 	u8 report_id;  /* Bootloader output report id, must be 40h */
 	u8 rsvd;  /* Reserved, must be 0 */
 	struct pip_bl_packet_start packet_start;
-	u8 data[0];  /* Command data variable based on commands */
+	u8 data[];  /* Command data variable based on commands */
 } __packed;
 
 /* Initiate bootload command data structure. */
@@ -300,7 +300,7 @@ struct tsg_bl_metadata_row_params {
 struct tsg_bl_flash_row_head {
 	u8 flash_array_id;
 	__le16 flash_row_id;
-	u8 flash_data[0];
+	u8 flash_data[];
 } __packed;
 
 struct pip_app_cmd_head {
@@ -314,7 +314,7 @@ struct pip_app_cmd_head {
 	 * Bit 6-0: command code.
 	 */
 	u8 cmd_code;
-	u8 parameter_data[0];  /* Parameter data variable based on cmd_code */
+	u8 parameter_data[];  /* Parameter data variable based on cmd_code */
 } __packed;
 
 /* Application get/set parameter command data structure */
diff --git a/drivers/iommu/qcom_iommu.c b/drivers/iommu/qcom_iommu.c
index 39759db4f003..f1e175ca5e4a 100644
--- a/drivers/iommu/qcom_iommu.c
+++ b/drivers/iommu/qcom_iommu.c
@@ -48,7 +48,7 @@ struct qcom_iommu_dev {
 	void __iomem		*local_base;
 	u32			 sec_id;
 	u8			 num_ctxs;
-	struct qcom_iommu_ctx	*ctxs[0];   /* indexed by asid-1 */
+	struct qcom_iommu_ctx	*ctxs[];   /* indexed by asid-1 */
 };
 
 struct qcom_iommu_ctx {
diff --git a/drivers/irqchip/irq-bcm7038-l1.c b/drivers/irqchip/irq-bcm7038-l1.c
index cbf01afcd2a6..eb9bce93cd05 100644
--- a/drivers/irqchip/irq-bcm7038-l1.c
+++ b/drivers/irqchip/irq-bcm7038-l1.c
@@ -50,7 +50,7 @@ struct bcm7038_l1_chip {
 
 struct bcm7038_l1_cpu {
 	void __iomem		*map_base;
-	u32			mask_cache[0];
+	u32			mask_cache[];
 };
 
 /*
diff --git a/drivers/irqchip/qcom-irq-combiner.c b/drivers/irqchip/qcom-irq-combiner.c
index abfe59284ff2..aa54bfcb0433 100644
--- a/drivers/irqchip/qcom-irq-combiner.c
+++ b/drivers/irqchip/qcom-irq-combiner.c
@@ -33,7 +33,7 @@ struct combiner {
 	int                 parent_irq;
 	u32                 nirqs;
 	u32                 nregs;
-	struct combiner_reg regs[0];
+	struct combiner_reg regs[];
 };
 
 static inline int irq_nr(u32 reg, u32 bit)
diff --git a/drivers/leds/leds-is31fl32xx.c b/drivers/leds/leds-is31fl32xx.c
index 6f29b8943913..cd768f991da1 100644
--- a/drivers/leds/leds-is31fl32xx.c
+++ b/drivers/leds/leds-is31fl32xx.c
@@ -44,7 +44,7 @@ struct is31fl32xx_priv {
 	const struct is31fl32xx_chipdef *cdef;
 	struct i2c_client *client;
 	unsigned int num_leds;
-	struct is31fl32xx_led_data leds[0];
+	struct is31fl32xx_led_data leds[];
 };
 
 /**
diff --git a/drivers/leds/leds-pwm.c b/drivers/leds/leds-pwm.c
index 8b6965a563e9..9eded0956da1 100644
--- a/drivers/leds/leds-pwm.c
+++ b/drivers/leds/leds-pwm.c
@@ -29,7 +29,7 @@ struct led_pwm_data {
 
 struct led_pwm_priv {
 	int num_leds;
-	struct led_pwm_data leds[0];
+	struct led_pwm_data leds[];
 };
 
 static void __led_pwm_set(struct led_pwm_data *led_dat)
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index c6a529873d0f..dd2cda498314 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -212,7 +212,7 @@ struct crypt_config {
 	struct mutex bio_alloc_lock;
 
 	u8 *authenc_key; /* space for keys in authenc() format (if used) */
-	u8 key[0];
+	u8 key[];
 };
 
 #define MIN_IOS		64
diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index b225b3e445fa..e22e6d65862a 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -89,7 +89,7 @@ struct journal_entry {
 		} s;
 		__u64 sector;
 	} u;
-	commit_id_t last_bytes[0];
+	commit_id_t last_bytes[];
 	/* __u8 tag[0]; */
 };
 
diff --git a/drivers/md/dm-log-writes.c b/drivers/md/dm-log-writes.c
index 99721c76225d..9e21df5bb998 100644
--- a/drivers/md/dm-log-writes.c
+++ b/drivers/md/dm-log-writes.c
@@ -127,7 +127,7 @@ struct pending_block {
 	char *data;
 	u32 datalen;
 	struct list_head list;
-	struct bio_vec vecs[0];
+	struct bio_vec vecs[];
 };
 
 struct per_bio_data {
diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 9a18bef0a5ff..10e8b2fe787b 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -254,7 +254,7 @@ struct raid_set {
 		int mode;
 	} journal_dev;
 
-	struct raid_dev dev[0];
+	struct raid_dev dev[];
 };
 
 static void rs_config_backup(struct raid_set *rs, struct rs_layout *l)
diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index 089aed57e083..2f655d9f4200 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -83,7 +83,7 @@ struct mirror_set {
 	struct work_struct trigger_event;
 
 	unsigned nr_mirrors;
-	struct mirror mirror[0];
+	struct mirror mirror[];
 };
 
 DECLARE_DM_KCOPYD_THROTTLE_WITH_MODULE_PARM(raid1_resync_throttle,
diff --git a/drivers/md/dm-stats.c b/drivers/md/dm-stats.c
index 71417048256a..35d368c418d0 100644
--- a/drivers/md/dm-stats.c
+++ b/drivers/md/dm-stats.c
@@ -56,7 +56,7 @@ struct dm_stat {
 	size_t percpu_alloc_size;
 	size_t histogram_alloc_size;
 	struct dm_stat_percpu *stat_percpu[NR_CPUS];
-	struct dm_stat_shared stat_shared[0];
+	struct dm_stat_shared stat_shared[];
 };
 
 #define STAT_PRECISE_TIMESTAMPS		1
diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index 63bbcc20f49a..51fbfcf8efa1 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -41,7 +41,7 @@ struct stripe_c {
 	/* Work struct used for triggering events*/
 	struct work_struct trigger_event;
 
-	struct stripe stripe[0];
+	struct stripe stripe[];
 };
 
 /*
diff --git a/drivers/md/dm-switch.c b/drivers/md/dm-switch.c
index 8a0f057b8122..bff4c7fa1cd2 100644
--- a/drivers/md/dm-switch.c
+++ b/drivers/md/dm-switch.c
@@ -53,7 +53,7 @@ struct switch_ctx {
 	/*
 	 * Array of dm devices to switch between.
 	 */
-	struct switch_path path_list[0];
+	struct switch_path path_list[];
 };
 
 static struct switch_ctx *alloc_switch_ctx(struct dm_target *ti, unsigned nr_paths,
diff --git a/drivers/media/i2c/s5k5baf.c b/drivers/media/i2c/s5k5baf.c
index cdfe008ba39f..42584a088273 100644
--- a/drivers/media/i2c/s5k5baf.c
+++ b/drivers/media/i2c/s5k5baf.c
@@ -281,7 +281,7 @@ struct s5k5baf_fw {
 		u16 id;
 		u16 offset;
 	} seq[0];
-	u16 data[0];
+	u16 data[];
 };
 
 struct s5k5baf {
diff --git a/drivers/media/rc/iguanair.c b/drivers/media/rc/iguanair.c
index a7deca1fefb7..3c8bd13d029a 100644
--- a/drivers/media/rc/iguanair.c
+++ b/drivers/media/rc/iguanair.c
@@ -76,7 +76,7 @@ struct send_packet {
 	uint8_t channels;
 	uint8_t busy7;
 	uint8_t busy4;
-	uint8_t payload[0];
+	uint8_t payload[];
 };
 
 static void process_ir_data(struct iguanair *ir, unsigned len)
diff --git a/drivers/mfd/omap-usb-tll.c b/drivers/mfd/omap-usb-tll.c
index 265f5e350e1c..1cf259a48966 100644
--- a/drivers/mfd/omap-usb-tll.c
+++ b/drivers/mfd/omap-usb-tll.c
@@ -99,7 +99,7 @@
 struct usbtll_omap {
 	void __iomem	*base;
 	int		nch;		/* num. of channels */
-	struct clk	*ch_clk[0];	/* must be the last member */
+	struct clk	*ch_clk[];	/* must be the last member */
 };
 
 /*-------------------------------------------------------------------------*/
diff --git a/drivers/mfd/qcom-pm8xxx.c b/drivers/mfd/qcom-pm8xxx.c
index 29133326c6fd..acd172ddcbd6 100644
--- a/drivers/mfd/qcom-pm8xxx.c
+++ b/drivers/mfd/qcom-pm8xxx.c
@@ -76,7 +76,7 @@ struct pm_irq_chip {
 	unsigned int		num_masters;
 	const struct pm_irq_data *pm_irq_data;
 	/* MUST BE AT THE END OF THIS STRUCT */
-	u8			config[0];
+	u8			config[];
 };
 
 static int pm8xxx_read_block_irq(struct pm_irq_chip *chip, unsigned int bp,
diff --git a/drivers/misc/mei/bus-fixup.c b/drivers/misc/mei/bus-fixup.c
index 9ad9c01ddf41..910f059b3384 100644
--- a/drivers/misc/mei/bus-fixup.c
+++ b/drivers/misc/mei/bus-fixup.c
@@ -91,7 +91,7 @@ struct mkhi_rule_id {
 struct mkhi_fwcaps {
 	struct mkhi_rule_id id;
 	u8 len;
-	u8 data[0];
+	u8 data[];
 } __packed;
 
 struct mkhi_fw_ver_block {
@@ -119,7 +119,7 @@ struct mkhi_msg_hdr {
 
 struct mkhi_msg {
 	struct mkhi_msg_hdr hdr;
-	u8 data[0];
+	u8 data[];
 } __packed;
 
 #define MKHI_OSVER_BUF_LEN (sizeof(struct mkhi_msg_hdr) + \
diff --git a/drivers/misc/vexpress-syscfg.c b/drivers/misc/vexpress-syscfg.c
index 058fcd7f9f01..a431787c0898 100644
--- a/drivers/misc/vexpress-syscfg.c
+++ b/drivers/misc/vexpress-syscfg.c
@@ -42,7 +42,7 @@ struct vexpress_syscfg_func {
 	struct vexpress_syscfg *syscfg;
 	struct regmap *regmap;
 	int num_templates;
-	u32 template[0]; /* Keep it last! */
+	u32 template[]; /* Keep it last! */
 };
 
 
diff --git a/drivers/mmc/host/sdhci-acpi.c b/drivers/mmc/host/sdhci-acpi.c
index 9651dca6863e..ea0e4fda3a9e 100644
--- a/drivers/mmc/host/sdhci-acpi.c
+++ b/drivers/mmc/host/sdhci-acpi.c
@@ -72,7 +72,7 @@ struct sdhci_acpi_host {
 	const struct sdhci_acpi_slot	*slot;
 	struct platform_device		*pdev;
 	bool				use_runtime_pm;
-	unsigned long			private[0] ____cacheline_aligned;
+	unsigned long			private[] ____cacheline_aligned;
 };
 
 static inline void *sdhci_acpi_priv(struct sdhci_acpi_host *c)
diff --git a/drivers/mmc/host/sdhci-cadence.c b/drivers/mmc/host/sdhci-cadence.c
index 5827d3751b81..9af3fe48d62f 100644
--- a/drivers/mmc/host/sdhci-cadence.c
+++ b/drivers/mmc/host/sdhci-cadence.c
@@ -67,7 +67,7 @@ struct sdhci_cdns_priv {
 	void __iomem *hrs_addr;
 	bool enhanced_strobe;
 	unsigned int nr_phy_params;
-	struct sdhci_cdns_phy_param phy_params[0];
+	struct sdhci_cdns_phy_param phy_params[];
 };
 
 struct sdhci_cdns_phy_cfg {
diff --git a/drivers/mmc/host/vub300.c b/drivers/mmc/host/vub300.c
index 6ced1b7f642f..a5a90d133f1f 100644
--- a/drivers/mmc/host/vub300.c
+++ b/drivers/mmc/host/vub300.c
@@ -95,7 +95,7 @@ struct sd_response_header {
 	u8 port_number;
 	u8 command_type;
 	u8 command_index;
-	u8 command_response[0];
+	u8 command_response[];
 } __packed;
 
 struct sd_status_header {
diff --git a/drivers/mtd/maps/sa1100-flash.c b/drivers/mtd/maps/sa1100-flash.c
index 47602af4ee34..bb1ef650ffd2 100644
--- a/drivers/mtd/maps/sa1100-flash.c
+++ b/drivers/mtd/maps/sa1100-flash.c
@@ -34,7 +34,7 @@ struct sa_subdev_info {
 struct sa_info {
 	struct mtd_info		*mtd;
 	int			num_subdev;
-	struct sa_subdev_info	subdev[0];
+	struct sa_subdev_info	subdev[];
 };
 
 static DEFINE_SPINLOCK(sa1100_vpp_lock);
diff --git a/drivers/mtd/nand/raw/marvell_nand.c b/drivers/mtd/nand/raw/marvell_nand.c
index fb5abdcfb007..7082bef1c8a7 100644
--- a/drivers/mtd/nand/raw/marvell_nand.c
+++ b/drivers/mtd/nand/raw/marvell_nand.c
@@ -334,7 +334,7 @@ struct marvell_nand_chip {
 	int addr_cyc;
 	int selected_die;
 	unsigned int nsels;
-	struct marvell_nand_chip_sel sels[0];
+	struct marvell_nand_chip_sel sels[];
 };
 
 static inline struct marvell_nand_chip *to_marvell_nand(struct nand_chip *chip)
diff --git a/drivers/mtd/nand/raw/meson_nand.c b/drivers/mtd/nand/raw/meson_nand.c
index 9f17b5b8efbf..f6fb5c0e6255 100644
--- a/drivers/mtd/nand/raw/meson_nand.c
+++ b/drivers/mtd/nand/raw/meson_nand.c
@@ -118,7 +118,7 @@ struct meson_nfc_nand_chip {
 	u8 *data_buf;
 	__le64 *info_buf;
 	u32 nsels;
-	u8 sels[0];
+	u8 sels[];
 };
 
 struct meson_nand_ecc {
diff --git a/drivers/mtd/nand/raw/mtk_nand.c b/drivers/mtd/nand/raw/mtk_nand.c
index b8305e39ab51..ef149e8b26d0 100644
--- a/drivers/mtd/nand/raw/mtk_nand.c
+++ b/drivers/mtd/nand/raw/mtk_nand.c
@@ -131,7 +131,7 @@ struct mtk_nfc_nand_chip {
 	u32 spare_per_sector;
 
 	int nsels;
-	u8 sels[0];
+	u8 sels[];
 	/* nothing after this field */
 };
 
diff --git a/drivers/mtd/nand/raw/nand_hynix.c b/drivers/mtd/nand/raw/nand_hynix.c
index 194e4227aefe..7caedaa5b9e5 100644
--- a/drivers/mtd/nand/raw/nand_hynix.c
+++ b/drivers/mtd/nand/raw/nand_hynix.c
@@ -26,7 +26,7 @@
 struct hynix_read_retry {
 	int nregs;
 	const u8 *regs;
-	u8 values[0];
+	u8 values[];
 };
 
 /**
diff --git a/drivers/mtd/nand/raw/sunxi_nand.c b/drivers/mtd/nand/raw/sunxi_nand.c
index 37a4ac0dd85b..6ede3934a5f4 100644
--- a/drivers/mtd/nand/raw/sunxi_nand.c
+++ b/drivers/mtd/nand/raw/sunxi_nand.c
@@ -195,7 +195,7 @@ struct sunxi_nand_chip {
 	u32 timing_cfg;
 	u32 timing_ctl;
 	int nsels;
-	struct sunxi_nand_chip_sel sels[0];
+	struct sunxi_nand_chip_sel sels[];
 };
 
 static inline struct sunxi_nand_chip *to_sunxi_nand(struct nand_chip *nand)
diff --git a/drivers/mtd/spi-nor/aspeed-smc.c b/drivers/mtd/spi-nor/aspeed-smc.c
index 395127349aa8..e26a1897db0e 100644
--- a/drivers/mtd/spi-nor/aspeed-smc.c
+++ b/drivers/mtd/spi-nor/aspeed-smc.c
@@ -109,7 +109,7 @@ struct aspeed_smc_controller {
 	void __iomem *ahb_base;			/* per-chip windows resource */
 	u32 ahb_window_size;			/* full mapping window size */
 
-	struct aspeed_smc_chip *chips[0];	/* pointers to attached chips */
+	struct aspeed_smc_chip *chips[];	/* pointers to attached chips */
 };
 
 /*
diff --git a/drivers/net/can/peak_canfd/peak_pciefd_main.c b/drivers/net/can/peak_canfd/peak_pciefd_main.c
index d08a3d559114..6ad83a881039 100644
--- a/drivers/net/can/peak_canfd/peak_pciefd_main.c
+++ b/drivers/net/can/peak_canfd/peak_pciefd_main.c
@@ -146,7 +146,7 @@ struct pciefd_rx_dma {
 	__le32 irq_status;
 	__le32 sys_time_low;
 	__le32 sys_time_high;
-	struct pucan_rx_msg msg[0];
+	struct pucan_rx_msg msg[];
 } __packed __aligned(4);
 
 /* Tx Link record */
@@ -194,7 +194,7 @@ struct pciefd_board {
 	struct pci_dev *pci_dev;
 	int can_count;
 	spinlock_t cmd_lock;		/* 64-bits cmds must be atomic */
-	struct pciefd_can *can[0];	/* array of network devices */
+	struct pciefd_can *can[];	/* array of network devices */
 };
 
 /* supported device ids. */
diff --git a/drivers/net/ethernet/amd/atarilance.c b/drivers/net/ethernet/amd/atarilance.c
index 4e36122609a3..03bb658d25d4 100644
--- a/drivers/net/ethernet/amd/atarilance.c
+++ b/drivers/net/ethernet/amd/atarilance.c
@@ -156,7 +156,7 @@ struct lance_memory {
 	struct lance_init_block	init;
 	struct lance_tx_head	tx_head[TX_RING_SIZE];
 	struct lance_rx_head	rx_head[RX_RING_SIZE];
-	char					packet_area[0];	/* packet data follow after the
+	char			packet_area[];	/* packet data follow after the
 											 * init block and the ring
 											 * descriptors and are located
 											 * at runtime */
diff --git a/drivers/net/ethernet/cavium/liquidio/octeon_console.c b/drivers/net/ethernet/cavium/liquidio/octeon_console.c
index dfc77507b159..d0d581e98734 100644
--- a/drivers/net/ethernet/cavium/liquidio/octeon_console.c
+++ b/drivers/net/ethernet/cavium/liquidio/octeon_console.c
@@ -127,7 +127,7 @@ struct octeon_pci_console_desc {
 	u32 pad;
 	/* must be 64 bit aligned here... */
 	/* Array of addresses of octeon_pci_console structures */
-	u64 console_addr_array[0];
+	u64 console_addr_array[];
 	/* Implicit storage for console_addr_array */
 };
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
index de30d61af065..fe883cb1a7af 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
@@ -984,7 +984,7 @@ static const char * const devlog_facility_strings[] = {
 struct devlog_info {
 	unsigned int nentries;		/* number of entries in log[] */
 	unsigned int first;		/* first [temporal] entry in log[] */
-	struct fw_devlog_e log[0];	/* Firmware Device Log */
+	struct fw_devlog_e log[];	/* Firmware Device Log */
 };
 
 /* Dump a Firmaware Device Log entry.
diff --git a/drivers/net/ethernet/chelsio/cxgb4/l2t.c b/drivers/net/ethernet/chelsio/cxgb4/l2t.c
index 1a16449e9deb..12c3354172cd 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/l2t.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/l2t.c
@@ -59,7 +59,7 @@ struct l2t_data {
 	rwlock_t lock;
 	atomic_t nfree;             /* number of free entries */
 	struct l2t_entry *rover;    /* starting point for next allocation */
-	struct l2t_entry l2tab[0];  /* MUST BE LAST */
+	struct l2t_entry l2tab[];  /* MUST BE LAST */
 };
 
 static inline unsigned int vlan_prio(const struct l2t_entry *e)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c
index 4c61d25d2e88..b794888fa3ba 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c
@@ -57,7 +57,7 @@ struct mlx5_fpga_ipsec_cmd_context {
 	struct completion complete;
 	struct mlx5_fpga_device *dev;
 	struct list_head list; /* Item in pending_cmds */
-	u8 command[0];
+	u8 command[];
 };
 
 struct mlx5_fpga_esp_xfrm;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
index ab69effb056d..f43caefd07a1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
@@ -470,7 +470,7 @@ struct mlx5_fc_bulk {
 	u32 base_id;
 	int bulk_len;
 	unsigned long *bitmask;
-	struct mlx5_fc fcs[0];
+	struct mlx5_fc fcs[];
 };
 
 static void mlx5_fc_init(struct mlx5_fc *counter, struct mlx5_fc_bulk *bulk,
diff --git a/drivers/net/ethernet/mellanox/mlxfw/mlxfw_mfa2.c b/drivers/net/ethernet/mellanox/mlxfw/mlxfw_mfa2.c
index 79057af4fe99..5d9ddf36fb4e 100644
--- a/drivers/net/ethernet/mellanox/mlxfw/mlxfw_mfa2.c
+++ b/drivers/net/ethernet/mellanox/mlxfw/mlxfw_mfa2.c
@@ -496,7 +496,7 @@ mlxfw_mfa2_file_component_tlv_get(const struct mlxfw_mfa2_file *mfa2_file,
 
 struct mlxfw_mfa2_comp_data {
 	struct mlxfw_mfa2_component comp;
-	u8 buff[0];
+	u8 buff[];
 };
 
 static const struct mlxfw_mfa2_tlv_component_descriptor *
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index e9f791c43f20..0d630096a28c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -82,7 +82,7 @@ struct mlxsw_core {
 	struct mlxsw_core_port *ports;
 	unsigned int max_ports;
 	bool fw_flash_in_progress;
-	unsigned long driver_priv[0];
+	unsigned long driver_priv[];
 	/* driver_priv has to be always the last item */
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.c b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.c
index feb4672a5ac0..bd2207f60722 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.c
@@ -72,7 +72,7 @@ struct mlxsw_afk_key_info {
 						      * is index inside "blocks"
 						      */
 	struct mlxsw_afk_element_usage elusage;
-	const struct mlxsw_afk_block *blocks[0];
+	const struct mlxsw_afk_block *blocks[];
 };
 
 static bool
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum1_kvdl.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum1_kvdl.c
index 09ee0a807747..a9fff8adc75e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum1_kvdl.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum1_kvdl.c
@@ -60,7 +60,7 @@ static const struct mlxsw_sp1_kvdl_part_info mlxsw_sp1_kvdl_parts_info[] = {
 
 struct mlxsw_sp1_kvdl_part {
 	struct mlxsw_sp1_kvdl_part_info info;
-	unsigned long usage[0];	/* Entries */
+	unsigned long usage[];	/* Entries */
 };
 
 struct mlxsw_sp1_kvdl {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum2_kvdl.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum2_kvdl.c
index 8d14770766b4..3a73d654017f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum2_kvdl.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum2_kvdl.c
@@ -45,7 +45,7 @@ struct mlxsw_sp2_kvdl_part {
 	unsigned int usage_bit_count;
 	unsigned int indexes_per_usage_bit;
 	unsigned int last_allocated_bit;
-	unsigned long usage[0];	/* Usage bits */
+	unsigned long usage[];	/* Usage bits */
 };
 
 struct mlxsw_sp2_kvdl {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
index 3d3cca596116..9368b93dab38 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
@@ -58,7 +58,7 @@ struct mlxsw_sp_acl_ruleset {
 	struct mlxsw_sp_acl_ruleset_ht_key ht_key;
 	struct rhashtable rule_ht;
 	unsigned int ref_count;
-	unsigned long priv[0];
+	unsigned long priv[];
 	/* priv has to be always the last item */
 };
 
@@ -71,7 +71,7 @@ struct mlxsw_sp_acl_rule {
 	u64 last_used;
 	u64 last_packets;
 	u64 last_bytes;
-	unsigned long priv[0];
+	unsigned long priv[];
 	/* priv has to be always the last item */
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_bloom_filter.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_bloom_filter.c
index 3a2de13fcb68..dbd3bebf11ec 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_bloom_filter.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_bloom_filter.c
@@ -13,7 +13,7 @@
 struct mlxsw_sp_acl_bf {
 	struct mutex lock; /* Protects Bloom Filter updates. */
 	unsigned int bank_size;
-	refcount_t refcnt[0];
+	refcount_t refcnt[];
 };
 
 /* Bloom filter uses a crc-16 hash over chunks of data which contain 4 key
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
index e993159e8e4c..430da69003d8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
@@ -224,7 +224,7 @@ struct mlxsw_sp_acl_tcam_vchunk;
 struct mlxsw_sp_acl_tcam_chunk {
 	struct mlxsw_sp_acl_tcam_vchunk *vchunk;
 	struct mlxsw_sp_acl_tcam_region *region;
-	unsigned long priv[0];
+	unsigned long priv[];
 	/* priv has to be always the last item */
 };
 
@@ -243,7 +243,7 @@ struct mlxsw_sp_acl_tcam_vchunk {
 struct mlxsw_sp_acl_tcam_entry {
 	struct mlxsw_sp_acl_tcam_ventry *ventry;
 	struct mlxsw_sp_acl_tcam_chunk *chunk;
-	unsigned long priv[0];
+	unsigned long priv[];
 	/* priv has to be always the last item */
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_kvdl.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_kvdl.c
index 1e4cdee7bcd7..715ec8ecacba 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_kvdl.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_kvdl.c
@@ -8,7 +8,7 @@
 
 struct mlxsw_sp_kvdl {
 	const struct mlxsw_sp_kvdl_ops *kvdl_ops;
-	unsigned long priv[0];
+	unsigned long priv[];
 	/* priv has to be always the last item */
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c
index 54275624718b..423eedebcd22 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c
@@ -68,7 +68,7 @@ struct mlxsw_sp_mr_table {
 	struct list_head route_list;
 	struct rhashtable route_ht;
 	const struct mlxsw_sp_mr_table_ops *ops;
-	char catchall_route_priv[0];
+	char catchall_route_priv[];
 	/* catchall_route_priv has to be always the last item */
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c
index 2153bcc4b585..16a130c2f21c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c
@@ -67,7 +67,7 @@ struct mlxsw_sp_nve_mc_record {
 	struct mlxsw_sp_nve_mc_list *mc_list;
 	const struct mlxsw_sp_nve_mc_record_ops *ops;
 	u32 kvdl_index;
-	struct mlxsw_sp_nve_mc_entry entries[0];
+	struct mlxsw_sp_nve_mc_entry entries[];
 };
 
 struct mlxsw_sp_nve_mc_list {
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_debugdump.c b/drivers/net/ethernet/netronome/nfp/nfp_net_debugdump.c
index 769ceef09756..a614df095b08 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_debugdump.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_debugdump.c
@@ -36,7 +36,7 @@ enum nfp_dumpspec_type {
 struct nfp_dump_tl {
 	__be32 type;
 	__be32 length;	/* chunk length to follow, aligned to 8 bytes */
-	char data[0];
+	char data[];
 };
 
 /* NFP CPP parameters */
@@ -62,7 +62,7 @@ struct nfp_dumpspec_csr {
 
 struct nfp_dumpspec_rtsym {
 	struct nfp_dump_tl tl;
-	char rtsym[0];
+	char rtsym[];
 };
 
 /* header for register dumpable */
@@ -79,7 +79,7 @@ struct nfp_dump_rtsym {
 	struct nfp_dump_common_cpp cpp;
 	__be32 error;		/* error code encountered while reading */
 	u8 padded_name_length;	/* pad so data starts at 8 byte boundary */
-	char rtsym[0];
+	char rtsym[];
 	/* after padded_name_length, there is dump_length data */
 };
 
@@ -92,7 +92,7 @@ struct nfp_dump_error {
 	struct nfp_dump_tl tl;
 	__be32 error;
 	char padding[4];
-	char spec[0];
+	char spec[];
 };
 
 /* to track state through debug size calculation TLV traversal */
diff --git a/drivers/net/ethernet/toshiba/tc35815.c b/drivers/net/ethernet/toshiba/tc35815.c
index 3fd43d30b20d..b50c3ec3495b 100644
--- a/drivers/net/ethernet/toshiba/tc35815.c
+++ b/drivers/net/ethernet/toshiba/tc35815.c
@@ -367,7 +367,7 @@ struct TxFD {
 
 struct RxFD {
 	struct FDesc fd;
-	struct BDesc bd[0];	/* variable length */
+	struct BDesc bd[];	/* variable length */
 };
 
 struct FrFD {
diff --git a/drivers/net/usb/cdc-phonet.c b/drivers/net/usb/cdc-phonet.c
index bcabd39d136a..9bdbd7b472a0 100644
--- a/drivers/net/usb/cdc-phonet.c
+++ b/drivers/net/usb/cdc-phonet.c
@@ -36,7 +36,7 @@ struct usbpn_dev {
 
 	spinlock_t		rx_lock;
 	struct sk_buff		*rx_skb;
-	struct urb		*urbs[0];
+	struct urb		*urbs[];
 };
 
 static void tx_complete(struct urb *req);
diff --git a/drivers/net/wan/wanxl.c b/drivers/net/wan/wanxl.c
index 23f93f1c815d..499f7cd19a4a 100644
--- a/drivers/net/wan/wanxl.c
+++ b/drivers/net/wan/wanxl.c
@@ -78,7 +78,7 @@ struct card {
 	struct sk_buff *rx_skbs[RX_QUEUE_LENGTH];
 	struct card_status *status;	/* shared between host and card */
 	dma_addr_t status_address;
-	struct port ports[0];	/* 1 - 4 port structures follow */
+	struct port ports[];	/* 1 - 4 port structures follow */
 };
 
 
diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index 54337d60f288..7506cea46f58 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -30,7 +30,7 @@ struct ath6kl_fwlog_slot {
 	__le32 length;
 
 	/* max ATH6KL_FWLOG_PAYLOAD_SIZE bytes */
-	u8 payload[0];
+	u8 payload[];
 };
 
 #define ATH6KL_FWLOG_MAX_ENTRIES 20
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 23e1ed6a9d6d..c7136ce567ee 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -222,7 +222,7 @@ struct auth_no_hdr {
 	__le16 auth_transaction;
 	__le16 status_code;
 	/* possibly followed by Challenge text */
-	u8 variable[0];
+	u8 variable[];
 } __packed;
 
 u8 led_polarity = LED_POLARITY_LOW_ACTIVE;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
index 79c8a858b6d6..a5cced2c89ac 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
@@ -32,7 +32,7 @@ struct brcmf_fweh_queue_item {
 	u8 ifaddr[ETH_ALEN];
 	struct brcmf_event_msg_be emsg;
 	u32 datalen;
-	u8 data[0];
+	u8 data[];
 };
 
 /**
diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2200.c b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
index 5ef6f87a48ac..f7c7b2cb73b8 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
@@ -3386,7 +3386,7 @@ struct ipw_fw {
 	__le32 boot_size;
 	__le32 ucode_size;
 	__le32 fw_size;
-	u8 data[0];
+	u8 data[];
 };
 
 static int ipw_get_fw(struct ipw_priv *priv,
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c b/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c
index 89f74116569d..cc1d93606d9b 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c
@@ -261,7 +261,7 @@ struct hcmd_write_data {
 	__be32 cmd_id;
 	__be32 flags;
 	__be16 length;
-	u8 data[0];
+	u8 data[];
 } __packed;
 
 static ssize_t iwl_dbgfs_send_hcmd_write(struct iwl_fw_runtime *fwrt, char *buf,
diff --git a/drivers/net/wireless/intersil/orinoco/fw.c b/drivers/net/wireless/intersil/orinoco/fw.c
index 400a35217644..015af782881b 100644
--- a/drivers/net/wireless/intersil/orinoco/fw.c
+++ b/drivers/net/wireless/intersil/orinoco/fw.c
@@ -49,7 +49,7 @@ struct orinoco_fw_header {
 	__le32 pdr_offset;      /* Offset to PDR data from eof header */
 	__le32 pri_offset;      /* Offset to primary plug data */
 	__le32 compat_offset;   /* Offset to compatibility data*/
-	char signature[0];      /* FW signature length headersize-20 */
+	char signature[];      /* FW signature length headersize-20 */
 } __packed;
 
 /* Check the range of various header entries. Return a pointer to a
diff --git a/drivers/net/wireless/intersil/orinoco/hermes_dld.c b/drivers/net/wireless/intersil/orinoco/hermes_dld.c
index 4a10b7aca043..dbeadfcfefe2 100644
--- a/drivers/net/wireless/intersil/orinoco/hermes_dld.c
+++ b/drivers/net/wireless/intersil/orinoco/hermes_dld.c
@@ -64,7 +64,7 @@
 struct dblock {
 	__le32 addr;		/* adapter address where to write the block */
 	__le16 len;		/* length of the data only, in bytes */
-	char data[0];		/* data to be written */
+	char data[];		/* data to be written */
 } __packed;
 
 /*
@@ -76,7 +76,7 @@ struct pdr {
 	__le32 id;		/* record ID */
 	__le32 addr;		/* adapter address where to write the data */
 	__le32 len;		/* expected length of the data, in bytes */
-	char next[0];		/* next PDR starts here */
+	char next[];		/* next PDR starts here */
 } __packed;
 
 /*
@@ -87,7 +87,7 @@ struct pdr {
 struct pdi {
 	__le16 len;		/* length of ID and data, in words */
 	__le16 id;		/* record ID */
-	char data[0];		/* plug data */
+	char data[];		/* plug data */
 } __packed;
 
 /*** FW data block access functions ***/
diff --git a/drivers/net/wireless/intersil/orinoco/orinoco_usb.c b/drivers/net/wireless/intersil/orinoco/orinoco_usb.c
index e753f43e0162..a77bbcd544d6 100644
--- a/drivers/net/wireless/intersil/orinoco/orinoco_usb.c
+++ b/drivers/net/wireless/intersil/orinoco/orinoco_usb.c
@@ -202,7 +202,7 @@ struct ezusb_packet {
 	__le16 crc;		/* CRC up to here */
 	__le16 hermes_len;
 	__le16 hermes_rid;
-	u8 data[0];
+	u8 data[];
 } __packed;
 
 /* Table of devices that work or may work with this driver */
diff --git a/drivers/net/wireless/marvell/libertas/if_sdio.c b/drivers/net/wireless/marvell/libertas/if_sdio.c
index 30f1025ecb9b..acf61b93b782 100644
--- a/drivers/net/wireless/marvell/libertas/if_sdio.c
+++ b/drivers/net/wireless/marvell/libertas/if_sdio.c
@@ -103,7 +103,7 @@ MODULE_FIRMWARE("sd8688.bin");
 struct if_sdio_packet {
 	struct if_sdio_packet	*next;
 	u16			nb;
-	u8			buffer[0] __attribute__((aligned(4)));
+	u8			buffer[] __aligned(4);
 };
 
 struct if_sdio_card {
diff --git a/drivers/net/wireless/marvell/libertas/if_spi.c b/drivers/net/wireless/marvell/libertas/if_spi.c
index d07fe82c557e..3625baa66d3e 100644
--- a/drivers/net/wireless/marvell/libertas/if_spi.c
+++ b/drivers/net/wireless/marvell/libertas/if_spi.c
@@ -35,7 +35,7 @@
 struct if_spi_packet {
 	struct list_head		list;
 	u16				blen;
-	u8				buffer[0] __attribute__((aligned(4)));
+	u8				buffer[] __aligned(4);
 };
 
 struct if_spi_card {
diff --git a/drivers/net/wireless/marvell/mwl8k.c b/drivers/net/wireless/marvell/mwl8k.c
index d55f229abeea..47fb4b3ea004 100644
--- a/drivers/net/wireless/marvell/mwl8k.c
+++ b/drivers/net/wireless/marvell/mwl8k.c
@@ -592,7 +592,7 @@ struct mwl8k_cmd_pkt {
 	__u8	seq_num;
 	__u8	macid;
 	__le16	result;
-	char	payload[0];
+	char	payload[];
 } __packed;
 
 /*
@@ -806,7 +806,7 @@ static int mwl8k_load_firmware(struct ieee80211_hw *hw)
 struct mwl8k_dma_data {
 	__le16 fwlen;
 	struct ieee80211_hdr wh;
-	char data[0];
+	char data[];
 } __packed;
 
 /* Routines to add/remove DMA header from skb.  */
@@ -2955,7 +2955,7 @@ mwl8k_cmd_rf_antenna(struct ieee80211_hw *hw, int antenna, int mask)
 struct mwl8k_cmd_set_beacon {
 	struct mwl8k_cmd_pkt header;
 	__le16 beacon_len;
-	__u8 beacon[0];
+	__u8 beacon[];
 };
 
 static int mwl8k_cmd_set_beacon(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index c8f8fe5497a8..52375f3e430a 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -201,7 +201,7 @@ struct ndis_80211_pmkid_candidate {
 struct ndis_80211_pmkid_cand_list {
 	__le32 version;
 	__le32 num_candidates;
-	struct ndis_80211_pmkid_candidate candidate_list[0];
+	struct ndis_80211_pmkid_candidate candidate_list[];
 } __packed;
 
 struct ndis_80211_status_indication {
@@ -246,12 +246,12 @@ struct ndis_80211_bssid_ex {
 	__le32 net_infra;
 	u8 rates[NDIS_802_11_LENGTH_RATES_EX];
 	__le32 ie_length;
-	u8 ies[0];
+	u8 ies[];
 } __packed;
 
 struct ndis_80211_bssid_list_ex {
 	__le32 num_items;
-	struct ndis_80211_bssid_ex bssid[0];
+	struct ndis_80211_bssid_ex bssid[];
 } __packed;
 
 struct ndis_80211_fixed_ies {
@@ -333,7 +333,7 @@ struct ndis_80211_bssid_info {
 struct ndis_80211_pmkid {
 	__le32 length;
 	__le32 bssid_info_count;
-	struct ndis_80211_bssid_info bssid_info[0];
+	struct ndis_80211_bssid_info bssid_info[];
 } __packed;
 
 /*
diff --git a/drivers/nfc/fdp/fdp.c b/drivers/nfc/fdp/fdp.c
index 0cc9ac856fe2..7c0b1e6b80ff 100644
--- a/drivers/nfc/fdp/fdp.c
+++ b/drivers/nfc/fdp/fdp.c
@@ -76,7 +76,7 @@ static u8 nci_core_get_config_otp_ram_version[5] = {
 struct nci_core_get_config_rsp {
 	u8 status;
 	u8 count;
-	u8 data[0];
+	u8 data[];
 };
 
 static int fdp_nci_create_conn(struct nci_dev *ndev)
diff --git a/drivers/nfc/st21nfca/dep.c b/drivers/nfc/st21nfca/dep.c
index 60acdfd1cb8c..a1d69f9b2d4a 100644
--- a/drivers/nfc/st21nfca/dep.c
+++ b/drivers/nfc/st21nfca/dep.c
@@ -66,7 +66,7 @@ struct st21nfca_atr_req {
 	u8 bsi;
 	u8 bri;
 	u8 ppi;
-	u8 gbi[0];
+	u8 gbi[];
 } __packed;
 
 struct st21nfca_atr_res {
@@ -79,7 +79,7 @@ struct st21nfca_atr_res {
 	u8 bri;
 	u8 to;
 	u8 ppi;
-	u8 gbi[0];
+	u8 gbi[];
 } __packed;
 
 struct st21nfca_psl_req {
diff --git a/drivers/nvme/host/lightnvm.c b/drivers/nvme/host/lightnvm.c
index ec46693f6b64..3002bf972c6b 100644
--- a/drivers/nvme/host/lightnvm.c
+++ b/drivers/nvme/host/lightnvm.c
@@ -171,7 +171,7 @@ struct nvme_nvm_bb_tbl {
 	__le32	tdresv;
 	__le32	thresv;
 	__le32	rsvd2[8];
-	__u8	blk[0];
+	__u8	blk[];
 };
 
 struct nvme_nvm_id20_addrf {
diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller/pci-hyperv.c
index 9977abff92fc..be957268f9d6 100644
--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -260,7 +260,7 @@ struct pci_packet {
 				int resp_packet_size);
 	void *compl_ctxt;
 
-	struct pci_message message[0];
+	struct pci_message message[];
 };
 
 /*
@@ -296,7 +296,7 @@ struct pci_bus_d0_entry {
 struct pci_bus_relations {
 	struct pci_incoming_message incoming;
 	u32 device_count;
-	struct pci_function_description func[0];
+	struct pci_function_description func[];
 } __packed;
 
 struct pci_q_res_req_response {
@@ -508,7 +508,7 @@ struct hv_dr_work {
 struct hv_dr_state {
 	struct list_head list_entry;
 	u32 device_count;
-	struct pci_function_description func[0];
+	struct pci_function_description func[];
 };
 
 enum hv_pcichild_state {
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index d828ca835a98..3217b8cdb1e0 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1521,7 +1521,7 @@ EXPORT_SYMBOL(pci_restore_state);
 
 struct pci_saved_state {
 	u32 config_space[16];
-	struct pci_cap_saved_data cap[0];
+	struct pci_cap_saved_data cap[];
 };
 
 /**
diff --git a/drivers/pinctrl/sirf/pinctrl-atlas7.c b/drivers/pinctrl/sirf/pinctrl-atlas7.c
index b1a9611f46b3..50df9e084414 100644
--- a/drivers/pinctrl/sirf/pinctrl-atlas7.c
+++ b/drivers/pinctrl/sirf/pinctrl-atlas7.c
@@ -352,7 +352,7 @@ struct atlas7_gpio_chip {
 	int nbank;
 	raw_spinlock_t lock;
 	struct gpio_chip chip;
-	struct atlas7_gpio_bank banks[0];
+	struct atlas7_gpio_bank banks[];
 };
 
 /**
diff --git a/drivers/pinctrl/uniphier/pinctrl-uniphier-core.c b/drivers/pinctrl/uniphier/pinctrl-uniphier-core.c
index 57babf31e320..ade348b49b31 100644
--- a/drivers/pinctrl/uniphier/pinctrl-uniphier-core.c
+++ b/drivers/pinctrl/uniphier/pinctrl-uniphier-core.c
@@ -29,7 +29,7 @@ struct uniphier_pinctrl_reg_region {
 	struct list_head node;
 	unsigned int base;
 	unsigned int nregs;
-	u32 vals[0];
+	u32 vals[];
 };
 
 struct uniphier_pinctrl_priv {
diff --git a/drivers/platform/chrome/cros_ec_chardev.c b/drivers/platform/chrome/cros_ec_chardev.c
index c65e70bc168d..fd33de546aee 100644
--- a/drivers/platform/chrome/cros_ec_chardev.c
+++ b/drivers/platform/chrome/cros_ec_chardev.c
@@ -48,7 +48,7 @@ struct ec_event {
 	struct list_head node;
 	size_t size;
 	u8 event_type;
-	u8 data[0];
+	u8 data[];
 };
 
 static int ec_get_version(struct cros_ec_dev *ec, char *str, int maxlen)
diff --git a/drivers/platform/chrome/wilco_ec/event.c b/drivers/platform/chrome/wilco_ec/event.c
index dba3d445623f..814518509739 100644
--- a/drivers/platform/chrome/wilco_ec/event.c
+++ b/drivers/platform/chrome/wilco_ec/event.c
@@ -79,7 +79,7 @@ static DEFINE_IDA(event_ida);
 struct ec_event {
 	u16 size;
 	u16 type;
-	u16 event[0];
+	u16 event[];
 } __packed;
 
 #define ec_event_num_words(ev) (ev->size - 1)
@@ -96,7 +96,7 @@ struct ec_event_queue {
 	int capacity;
 	int head;
 	int tail;
-	struct ec_event *entries[0];
+	struct ec_event *entries[];
 };
 
 /* Maximum number of events to store in ec_event_queue */
diff --git a/drivers/platform/x86/i2c-multi-instantiate.c b/drivers/platform/x86/i2c-multi-instantiate.c
index ffb8d5d1eb5f..6acc8457866e 100644
--- a/drivers/platform/x86/i2c-multi-instantiate.c
+++ b/drivers/platform/x86/i2c-multi-instantiate.c
@@ -28,7 +28,7 @@ struct i2c_inst_data {
 
 struct i2c_multi_inst_data {
 	int num_clients;
-	struct i2c_client *clients[0];
+	struct i2c_client *clients[];
 };
 
 static int i2c_multi_inst_count(struct acpi_resource *ares, void *data)
diff --git a/drivers/powercap/idle_inject.c b/drivers/powercap/idle_inject.c
index cd1270614cc6..e9bbd3c42eef 100644
--- a/drivers/powercap/idle_inject.c
+++ b/drivers/powercap/idle_inject.c
@@ -67,7 +67,7 @@ struct idle_inject_device {
 	struct hrtimer timer;
 	unsigned int idle_duration_us;
 	unsigned int run_duration_us;
-	unsigned long int cpumask[0];
+	unsigned long cpumask[];
 };
 
 static DEFINE_PER_CPU(struct idle_inject_thread, idle_inject_thread);
diff --git a/drivers/rapidio/rio-scan.c b/drivers/rapidio/rio-scan.c
index 0e90c5d4bb2b..eb8ed28533f8 100644
--- a/drivers/rapidio/rio-scan.c
+++ b/drivers/rapidio/rio-scan.c
@@ -39,7 +39,7 @@ struct rio_id_table {
 	u16 start;	/* logical minimal id */
 	u32 max;	/* max number of IDs in table */
 	spinlock_t lock;
-	unsigned long table[0];
+	unsigned long table[];
 };
 
 static int next_destid = 0;
diff --git a/drivers/regulator/da9062-regulator.c b/drivers/regulator/da9062-regulator.c
index d3ce0278bfbe..d8112f56e94e 100644
--- a/drivers/regulator/da9062-regulator.c
+++ b/drivers/regulator/da9062-regulator.c
@@ -73,7 +73,7 @@ struct da9062_regulators {
 	int					irq_ldo_lim;
 	unsigned				n_regulators;
 	/* Array size to be defined during init. Keep at end. */
-	struct da9062_regulator			regulator[0];
+	struct da9062_regulator			regulator[];
 };
 
 /* Regulator operations */
diff --git a/drivers/regulator/da9063-regulator.c b/drivers/regulator/da9063-regulator.c
index 2aceb3b7afc2..26f2903caff3 100644
--- a/drivers/regulator/da9063-regulator.c
+++ b/drivers/regulator/da9063-regulator.c
@@ -152,7 +152,7 @@ struct da9063_regulator {
 struct da9063_regulators {
 	unsigned				n_regulators;
 	/* Array size to be defined during init. Keep at end. */
-	struct da9063_regulator			regulator[0];
+	struct da9063_regulator			regulator[];
 };
 
 /* BUCK modes for DA9063 */
diff --git a/drivers/rpmsg/virtio_rpmsg_bus.c b/drivers/rpmsg/virtio_rpmsg_bus.c
index 376ebbf880d6..07d4f3374098 100644
--- a/drivers/rpmsg/virtio_rpmsg_bus.c
+++ b/drivers/rpmsg/virtio_rpmsg_bus.c
@@ -89,7 +89,7 @@ struct rpmsg_hdr {
 	u32 reserved;
 	u16 len;
 	u16 flags;
-	u8 data[0];
+	u8 data[];
 } __packed;
 
 /**
diff --git a/drivers/s390/block/dasd_diag.c b/drivers/s390/block/dasd_diag.c
index 8d4971645cf1..facb588d09e4 100644
--- a/drivers/s390/block/dasd_diag.c
+++ b/drivers/s390/block/dasd_diag.c
@@ -58,7 +58,7 @@ struct dasd_diag_private {
 
 struct dasd_diag_req {
 	unsigned int block_count;
-	struct dasd_diag_bio bio[0];
+	struct dasd_diag_bio bio[];
 };
 
 static const u8 DASD_DIAG_CMS1[] = { 0xc3, 0xd4, 0xe2, 0xf1 };/* EBCDIC CMS1 */
diff --git a/drivers/s390/char/sclp_pci.c b/drivers/s390/char/sclp_pci.c
index 995e9196852e..a3e5a5fb0c1e 100644
--- a/drivers/s390/char/sclp_pci.c
+++ b/drivers/s390/char/sclp_pci.c
@@ -39,7 +39,7 @@ struct err_notify_evbuf {
 	u8 atype;
 	u32 fh;
 	u32 fid;
-	u8 data[0];
+	u8 data[];
 } __packed;
 
 struct err_notify_sccb {
diff --git a/drivers/s390/cio/idset.c b/drivers/s390/cio/idset.c
index 835de44dbbcc..77d0ea7b381b 100644
--- a/drivers/s390/cio/idset.c
+++ b/drivers/s390/cio/idset.c
@@ -13,7 +13,7 @@
 struct idset {
 	int num_ssid;
 	int num_id;
-	unsigned long bitmap[0];
+	unsigned long bitmap[];
 };
 
 static inline unsigned long bitmap_size(int num_ssid, int num_id)
diff --git a/drivers/s390/crypto/zcrypt_msgtype6.c b/drivers/s390/crypto/zcrypt_msgtype6.c
index a36251d138fb..eadd3a438a4b 100644
--- a/drivers/s390/crypto/zcrypt_msgtype6.c
+++ b/drivers/s390/crypto/zcrypt_msgtype6.c
@@ -590,7 +590,7 @@ struct type86x_reply {
 	struct CPRBX cprbx;
 	unsigned char pad[4];	/* 4 byte function code/rules block ? */
 	unsigned short length;
-	char text[0];
+	char text[];
 } __packed;
 
 struct type86_ep11_reply {
diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index a242a62caaa1..c2c7850ff7b4 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -316,7 +316,7 @@ typedef struct asc_sg_head {
 	ushort queue_cnt;
 	ushort entry_to_copy;
 	ushort res;
-	ASC_SG_LIST sg_list[0];
+	ASC_SG_LIST sg_list[];
 } ASC_SG_HEAD;
 
 typedef struct asc_scsi_q {
diff --git a/drivers/scsi/aic94xx/aic94xx_sds.c b/drivers/scsi/aic94xx/aic94xx_sds.c
index 3ddc8852bc32..105adba559a1 100644
--- a/drivers/scsi/aic94xx/aic94xx_sds.c
+++ b/drivers/scsi/aic94xx/aic94xx_sds.c
@@ -406,7 +406,7 @@ struct asd_manuf_sec {
 	u8    sas_addr[SAS_ADDR_SIZE];
 	u8    pcba_sn[ASD_PCBA_SN_SIZE];
 	/* Here start the other segments */
-	u8    linked_list[0];
+	u8    linked_list[];
 } __attribute__ ((packed));
 
 struct asd_manuf_phy_desc {
@@ -449,7 +449,7 @@ struct asd_ms_sb_desc {
 	u8    type;
 	u8    node_desc_index;
 	u8    conn_desc_index;
-	u8    _recvd[0];
+	u8    _recvd[];
 } __attribute__ ((packed));
 
 #if 0
@@ -478,12 +478,12 @@ struct asd_ms_conn_desc {
 	u8    size_sideband_desc;
 	u32   _resvd;
 	u8    name[16];
-	struct asd_ms_sb_desc sb_desc[0];
+	struct asd_ms_sb_desc sb_desc[];
 } __attribute__ ((packed));
 
 struct asd_nd_phy_desc {
 	u8    vp_attch_type;
-	u8    attch_specific[0];
+	u8    attch_specific[];
 } __attribute__ ((packed));
 
 #if 0
@@ -503,7 +503,7 @@ struct asd_ms_node_desc {
 	u8    size_phy_desc;
 	u8    _resvd;
 	u8    name[16];
-	struct asd_nd_phy_desc phy_desc[0];
+	struct asd_nd_phy_desc phy_desc[];
 } __attribute__ ((packed));
 
 struct asd_ms_conn_map {
@@ -518,7 +518,7 @@ struct asd_ms_conn_map {
 	u8    usage_model_id;
 	u32   _resvd;
 	struct asd_ms_conn_desc conn_desc[0];
-	struct asd_ms_node_desc node_desc[0];
+	struct asd_ms_node_desc node_desc[];
 } __attribute__ ((packed));
 
 struct asd_ctrla_phy_entry {
@@ -542,7 +542,7 @@ struct asd_ll_el {
 	u8   id0;
 	u8   id1;
 	__le16  next;
-	u8   something_here[0];
+	u8   something_here[];
 } __attribute__ ((packed));
 
 static int asd_poll_flash(struct asd_ha_struct *asd_ha)
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index c597d544eb39..778d5e6ce385 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -207,7 +207,7 @@ struct fw_event_work {
 	u8			ignore;
 	u16			event;
 	struct kref		refcount;
-	char			event_data[0] __aligned(4);
+	char			event_data[] __aligned(4);
 };
 
 static void fw_event_work_free(struct kref *r)
diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 33287b6bdf0e..d4f10c0d813c 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -236,7 +236,7 @@ struct req_msg {
 	u8 data_dir;
 	u8 payload_sz;		/* payload size in 4-byte, not used */
 	u8 cdb[STEX_CDB_LENGTH];
-	u32 variable[0];
+	u32 variable[];
 };
 
 struct status_msg {
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index abd0e6b05f79..fbcb22d4d36d 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3156,7 +3156,7 @@ static inline int ufshcd_read_desc(struct ufs_hba *hba,
 struct uc_string_id {
 	u8 len;
 	u8 type;
-	wchar_t uc[0];
+	wchar_t uc[];
 } __packed;
 
 /* replace non-printable or non-ASCII characters with spaces */
diff --git a/drivers/spi/spi-fsl-lpspi.c b/drivers/spi/spi-fsl-lpspi.c
index d0b8cc741a24..746251e4db72 100644
--- a/drivers/spi/spi-fsl-lpspi.c
+++ b/drivers/spi/spi-fsl-lpspi.c
@@ -125,7 +125,7 @@ struct fsl_lpspi_data {
 	struct completion dma_rx_completion;
 	struct completion dma_tx_completion;
 
-	int chipselect[0];
+	int chipselect[];
 };
 
 static const struct of_device_id fsl_lpspi_dt_ids[] = {
diff --git a/drivers/spi/spi-s3c24xx.c b/drivers/spi/spi-s3c24xx.c
index 2d6e37f25e2d..2cb3b611c294 100644
--- a/drivers/spi/spi-s3c24xx.c
+++ b/drivers/spi/spi-s3c24xx.c
@@ -227,7 +227,7 @@ static inline unsigned int hw_txbyte(struct s3c24xx_spi *hw, int count)
 struct spi_fiq_code {
 	u32	length;
 	u32	ack_offset;
-	u8	data[0];
+	u8	data[];
 };
 
 extern struct spi_fiq_code s3c24xx_spi_fiq_txrx;
diff --git a/drivers/staging/greybus/raw.c b/drivers/staging/greybus/raw.c
index 64a17dfe3b6e..2a375f407d38 100644
--- a/drivers/staging/greybus/raw.c
+++ b/drivers/staging/greybus/raw.c
@@ -29,7 +29,7 @@ struct gb_raw {
 struct raw_data {
 	struct list_head entry;
 	u32 len;
-	u8 data[0];
+	u8 data[];
 };
 
 static struct class *raw_class;
diff --git a/drivers/staging/media/allegro-dvt/allegro-core.c b/drivers/staging/media/allegro-dvt/allegro-core.c
index 3be41698df4c..0a09b3622e78 100644
--- a/drivers/staging/media/allegro-dvt/allegro-core.c
+++ b/drivers/staging/media/allegro-dvt/allegro-core.c
@@ -434,7 +434,7 @@ struct mcu_msg_push_buffers_internal_buffer {
 struct mcu_msg_push_buffers_internal {
 	struct mcu_msg_header header;
 	u32 channel_id;
-	struct mcu_msg_push_buffers_internal_buffer buffer[0];
+	struct mcu_msg_push_buffers_internal_buffer buffer[];
 } __attribute__ ((__packed__));
 
 struct mcu_msg_put_stream_buffer {
diff --git a/drivers/staging/unisys/visorinput/visorinput.c b/drivers/staging/unisys/visorinput/visorinput.c
index 9693fb559052..6d202cba8575 100644
--- a/drivers/staging/unisys/visorinput/visorinput.c
+++ b/drivers/staging/unisys/visorinput/visorinput.c
@@ -111,7 +111,7 @@ struct visorinput_devdata {
 	/* size of following array */
 	unsigned int keycode_table_bytes;
 	/* for keyboard devices: visorkbd_keycode[] + visorkbd_ext_keycode[] */
-	unsigned char keycode_table[0];
+	unsigned char keycode_table[];
 };
 
 static const guid_t visor_keyboard_channel_guid = VISOR_KEYBOARD_CHANNEL_GUID;
diff --git a/drivers/thunderbolt/eeprom.c b/drivers/thunderbolt/eeprom.c
index 921d164b3f35..b451a5aa90b5 100644
--- a/drivers/thunderbolt/eeprom.c
+++ b/drivers/thunderbolt/eeprom.c
@@ -247,7 +247,7 @@ struct tb_drom_entry_header {
 
 struct tb_drom_entry_generic {
 	struct tb_drom_entry_header header;
-	u8 data[0];
+	u8 data[];
 } __packed;
 
 struct tb_drom_entry_port {
diff --git a/drivers/thunderbolt/icm.c b/drivers/thunderbolt/icm.c
index 13e88109742e..fbbe32ca1e69 100644
--- a/drivers/thunderbolt/icm.c
+++ b/drivers/thunderbolt/icm.c
@@ -114,7 +114,7 @@ struct icm_notification {
 struct ep_name_entry {
 	u8 len;
 	u8 type;
-	u8 data[0];
+	u8 data[];
 };
 
 #define EP_NAME_INTEL_VSS	0x10
diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index f1c90fa2978e..5f8c30f0538e 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -97,7 +97,7 @@ struct gsm_msg {
 	u8 ctrl;		/* Control byte + flags */
 	unsigned int len;	/* Length of data block (can be zero) */
 	unsigned char *data;	/* Points into buffer but not at the start */
-	unsigned char buffer[0];
+	unsigned char buffer[];
 };
 
 /*
diff --git a/drivers/tty/serial/8250/8250_exar.c b/drivers/tty/serial/8250/8250_exar.c
index 91e9b070d36d..65898ef90801 100644
--- a/drivers/tty/serial/8250/8250_exar.c
+++ b/drivers/tty/serial/8250/8250_exar.c
@@ -127,7 +127,7 @@ struct exar8250 {
 	unsigned int		nr;
 	struct exar8250_board	*board;
 	void __iomem		*virt;
-	int			line[0];
+	int			line[];
 };
 
 static void exar_pm(struct uart_port *port, unsigned int state, unsigned int old)
diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
index 939685fed396..0804469ff052 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -53,7 +53,7 @@ struct serial_private {
 	unsigned int		nr;
 	struct pci_serial_quirk	*quirk;
 	const struct pciserial_board *board;
-	int			line[0];
+	int			line[];
 };
 
 static const struct pci_device_id pci_use_msi[] = {
diff --git a/drivers/tty/serial/sc16is7xx.c b/drivers/tty/serial/sc16is7xx.c
index 7d3ae31cc720..06e8071d5601 100644
--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -329,7 +329,7 @@ struct sc16is7xx_port {
 	struct task_struct		*kworker_task;
 	struct kthread_work		irq_work;
 	struct mutex			efr_lock;
-	struct sc16is7xx_one		p[0];
+	struct sc16is7xx_one		p[];
 };
 
 static unsigned long sc16is7xx_lines;
diff --git a/drivers/usb/atm/ueagle-atm.c b/drivers/usb/atm/ueagle-atm.c
index 635cf0466b59..e9fed9a88737 100644
--- a/drivers/usb/atm/ueagle-atm.c
+++ b/drivers/usb/atm/ueagle-atm.c
@@ -350,7 +350,7 @@ struct l1_code {
 	u8 string_header[E4_L1_STRING_HEADER];
 	u8 page_number_to_block_index[E4_MAX_PAGE_NUMBER];
 	struct block_index page_header[E4_NO_SWAPPAGE_HEADERS];
-	u8 code[0];
+	u8 code[];
 } __packed;
 
 /* structures describing a block within a DSP page */
diff --git a/drivers/usb/gadget/function/f_phonet.c b/drivers/usb/gadget/function/f_phonet.c
index 8b72b192c747..d7f6cc51b7ec 100644
--- a/drivers/usb/gadget/function/f_phonet.c
+++ b/drivers/usb/gadget/function/f_phonet.c
@@ -48,7 +48,7 @@ struct f_phonet {
 	struct usb_ep			*in_ep, *out_ep;
 
 	struct usb_request		*in_req;
-	struct usb_request		*out_reqv[0];
+	struct usb_request		*out_reqv[];
 };
 
 static int phonet_rxq_size = 17;
diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
index d6433f206c17..10d51daa6a1b 100644
--- a/drivers/usb/host/ehci-tegra.c
+++ b/drivers/usb/host/ehci-tegra.c
@@ -282,7 +282,7 @@ static int tegra_ehci_hub_control(
 struct dma_aligned_buffer {
 	void *kmalloc_ptr;
 	void *old_xfer_buffer;
-	u8 data[0];
+	u8 data[];
 };
 
 static void free_dma_aligned_buffer(struct urb *urb)
diff --git a/drivers/usb/musb/musb_host.c b/drivers/usb/musb/musb_host.c
index 886c9b602f8c..1c813c37462a 100644
--- a/drivers/usb/musb/musb_host.c
+++ b/drivers/usb/musb/musb_host.c
@@ -2550,7 +2550,7 @@ static int musb_bus_resume(struct usb_hcd *hcd)
 struct musb_temp_buffer {
 	void *kmalloc_ptr;
 	void *old_xfer_buffer;
-	u8 data[0];
+	u8 data[];
 };
 
 static void musb_free_temp_buffer(struct urb *urb)
diff --git a/drivers/usb/serial/ti_usb_3410_5052.c b/drivers/usb/serial/ti_usb_3410_5052.c
index ef23acc9b9ce..73075b9351c5 100644
--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -219,7 +219,7 @@ struct ti_write_data_bytes {
 	u8	bDataCounter;
 	__be16	wBaseAddrHi;
 	__be16	wBaseAddrLo;
-	u8	bData[0];
+	u8	bData[];
 } __packed;
 
 struct ti_read_data_request {
@@ -234,7 +234,7 @@ struct ti_read_data_bytes {
 	__u8	bCmdCode;
 	__u8	bModuleId;
 	__u8	bErrorCode;
-	__u8	bData[0];
+	__u8	bData[];
 } __packed;
 
 /* Interrupt struct */
diff --git a/drivers/video/fbdev/ssd1307fb.c b/drivers/video/fbdev/ssd1307fb.c
index 142535267fec..fb2640fe575a 100644
--- a/drivers/video/fbdev/ssd1307fb.c
+++ b/drivers/video/fbdev/ssd1307fb.c
@@ -89,7 +89,7 @@ struct ssd1307fb_par {
 
 struct ssd1307fb_array {
 	u8	type;
-	u8	data[0];
+	u8	data[];
 };
 
 static const struct fb_fix_screeninfo ssd1307fb_fix = {
diff --git a/drivers/zorro/zorro.c b/drivers/zorro/zorro.c
index 8eeb84c239db..47c733817903 100644
--- a/drivers/zorro/zorro.c
+++ b/drivers/zorro/zorro.c
@@ -41,7 +41,7 @@ struct zorro_dev *zorro_autocon;
 
 struct zorro_bus {
 	struct device dev;
-	struct zorro_dev devices[0];
+	struct zorro_dev devices[];
 };
 
 
diff --git a/fs/aio.c b/fs/aio.c
index 5f3d3d814928..caa0df0238b1 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -68,7 +68,7 @@ struct aio_ring {
 	unsigned	header_length;	/* size of aio_ring */
 
 
-	struct io_event		io_events[0];
+	struct io_event		io_events[];
 }; /* 128 bytes + ring size */
 
 /*
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index f4713ea76e82..38f706341853 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1664,7 +1664,7 @@ struct elf_thread_core_info {
 	struct elf_thread_core_info *next;
 	struct task_struct *task;
 	struct elf_prstatus prstatus;
-	struct memelfnote notes[0];
+	struct memelfnote notes[];
 };
 
 struct elf_note_info {
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 61b37c56a7fb..8d1f02934d5b 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -149,7 +149,7 @@ struct scrub_parity {
 	 */
 	unsigned long		*ebitmap;
 
-	unsigned long		bitmap[0];
+	unsigned long		bitmap[];
 };
 
 struct scrub_ctx {
diff --git a/fs/ceph/cache.c b/fs/ceph/cache.c
index 270b769607a2..2f5cb6bc78e1 100644
--- a/fs/ceph/cache.c
+++ b/fs/ceph/cache.c
@@ -32,7 +32,7 @@ struct ceph_fscache_entry {
 	size_t uniq_len;
 	/* The following members must be last */
 	struct ceph_fsid fsid;
-	char uniquifier[0];
+	char uniquifier[];
 };
 
 static const struct fscache_cookie_def ceph_fscache_fsid_object_def = {
diff --git a/fs/dlm/user.c b/fs/dlm/user.c
index 5264bac75115..e5cefa90b1ce 100644
--- a/fs/dlm/user.c
+++ b/fs/dlm/user.c
@@ -46,7 +46,7 @@ struct dlm_lock_params32 {
 	__u32 bastaddr;
 	__u32 lksb;
 	char lvb[DLM_USER_LVB_LEN];
-	char name[0];
+	char name[];
 };
 
 struct dlm_write_request32 {
diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index 1f340743c9a8..711da1783860 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -390,7 +390,7 @@ struct fname {
 	__u32		inode;
 	__u8		name_len;
 	__u8		file_type;
-	char		name[0];
+	char		name[];
 };
 
 /*
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 129d2ebae00d..77c327d904bf 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -233,13 +233,13 @@ struct dx_root
 		u8 unused_flags;
 	}
 	info;
-	struct dx_entry	entries[0];
+	struct dx_entry	entries[];
 };
 
 struct dx_node
 {
 	struct fake_dirent fake;
-	struct dx_entry	entries[0];
+	struct dx_entry	entries[];
 };
 
 
diff --git a/fs/jfs/jfs_dtree.c b/fs/jfs/jfs_dtree.c
index 3acc954f7c04..837d42f61464 100644
--- a/fs/jfs/jfs_dtree.c
+++ b/fs/jfs/jfs_dtree.c
@@ -2964,7 +2964,7 @@ struct jfs_dirent {
 	loff_t position;
 	int ino;
 	u16 name_len;
-	char name[0];
+	char name[];
 };
 
 /*
diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 1320288ff9ec..bbc498e546ae 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -141,7 +141,7 @@ struct nfs_cache_array {
 	int size;
 	int eof_index;
 	u64 last_cookie;
-	struct nfs_cache_array_entry array[0];
+	struct nfs_cache_array_entry array[];
 };
 
 typedef int (*decode_dirent_t)(struct xdr_stream *, struct nfs_entry *, bool);
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 95d07a3dc5d1..0563052dca5b 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -5536,7 +5536,7 @@ static int buf_to_pages_noslab(const void *buf, size_t buflen,
 struct nfs4_cached_acl {
 	int cached;
 	size_t len;
-	char data[0];
+	char data[];
 };
 
 static void nfs4_set_cached_acl(struct inode *inode, struct nfs4_cached_acl *acl)
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 68ba354cf361..b425f0b01dce 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -91,7 +91,7 @@ enum ocfs2_replay_state {
 struct ocfs2_replay_map {
 	unsigned int rm_slots;
 	enum ocfs2_replay_state rm_state;
-	unsigned char rm_replay_slots[0];
+	unsigned char rm_replay_slots[];
 };
 
 static void ocfs2_replay_map_set_state(struct ocfs2_super *osb, int state)
diff --git a/fs/pstore/ram_core.c b/fs/pstore/ram_core.c
index 1f4d8c06f9be..c917c191e78c 100644
--- a/fs/pstore/ram_core.c
+++ b/fs/pstore/ram_core.c
@@ -34,7 +34,7 @@ struct persistent_ram_buffer {
 	uint32_t    sig;
 	atomic_t    start;
 	atomic_t    size;
-	uint8_t     data[0];
+	uint8_t     data[];
 };
 
 #define PERSISTENT_RAM_SIG (0x43474244) /* DBGC */
diff --git a/fs/select.c b/fs/select.c
index 11d0285d46b7..f38a8a7480f7 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -97,7 +97,7 @@ u64 select_estimate_accuracy(struct timespec64 *tv)
 struct poll_table_page {
 	struct poll_table_page * next;
 	struct poll_table_entry * entry;
-	struct poll_table_entry entries[0];
+	struct poll_table_entry entries[];
 };
 
 #define POLL_TABLE_FULL(table) \
@@ -826,7 +826,7 @@ SYSCALL_DEFINE1(old_select, struct sel_arg_struct __user *, arg)
 struct poll_list {
 	struct poll_list *next;
 	int len;
-	struct pollfd entries[0];
+	struct pollfd entries[];
 };
 
 #define POLLFD_PER_PAGE  ((PAGE_SIZE-sizeof(struct poll_list)) / sizeof(struct pollfd))
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 2d182c4ee9d9..f44bf6df56cc 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -64,7 +64,7 @@ struct htab_elem {
 		struct bpf_lru_node lru_node;
 	};
 	u32 hash;
-	char key[0] __aligned(8);
+	char key[] __aligned(8);
 };
 
 static bool htab_lru_map_delete_node(void *arg, struct bpf_lru_node *node);
diff --git a/kernel/bpf/lpm_trie.c b/kernel/bpf/lpm_trie.c
index 56e6c75d354d..67e9eebdf56b 100644
--- a/kernel/bpf/lpm_trie.c
+++ b/kernel/bpf/lpm_trie.c
@@ -25,7 +25,7 @@ struct lpm_trie_node {
 	struct lpm_trie_node __rcu	*child[2];
 	u32				prefixlen;
 	u32				flags;
-	u8				data[0];
+	u8				data[];
 };
 
 struct lpm_trie {
diff --git a/kernel/bpf/queue_stack_maps.c b/kernel/bpf/queue_stack_maps.c
index f697647ceb54..30e1373fd437 100644
--- a/kernel/bpf/queue_stack_maps.c
+++ b/kernel/bpf/queue_stack_maps.c
@@ -19,7 +19,7 @@ struct bpf_queue_stack {
 	u32 head, tail;
 	u32 size; /* max_entries + 1 */
 
-	char elements[0] __aligned(8);
+	char elements[] __aligned(8);
 };
 
 static struct bpf_queue_stack *bpf_queue_stack(struct bpf_map *map)
diff --git a/kernel/events/callchain.c b/kernel/events/callchain.c
index c2b41a263166..b1991043b7d8 100644
--- a/kernel/events/callchain.c
+++ b/kernel/events/callchain.c
@@ -16,7 +16,7 @@
 
 struct callchain_cpus_entries {
 	struct rcu_head			rcu_head;
-	struct perf_callchain_entry	*cpu_entries[0];
+	struct perf_callchain_entry	*cpu_entries[];
 };
 
 int sysctl_perf_event_max_stack __read_mostly = PERF_MAX_STACK_DEPTH;
diff --git a/kernel/gcov/fs.c b/kernel/gcov/fs.c
index e5eb5ea7ea59..5e891c3c2d93 100644
--- a/kernel/gcov/fs.c
+++ b/kernel/gcov/fs.c
@@ -58,7 +58,7 @@ struct gcov_node {
 	struct dentry *dentry;
 	struct dentry **links;
 	int num_loaded;
-	char name[0];
+	char name[];
 };
 
 static const char objtree[] = OBJTREE;
diff --git a/kernel/gcov/gcc_3_4.c b/kernel/gcov/gcc_3_4.c
index 801ee4b0b969..acb83558e5df 100644
--- a/kernel/gcov/gcc_3_4.c
+++ b/kernel/gcov/gcc_3_4.c
@@ -38,7 +38,7 @@ static struct gcov_info *gcov_info_head;
 struct gcov_fn_info {
 	unsigned int ident;
 	unsigned int checksum;
-	unsigned int n_ctrs[0];
+	unsigned int n_ctrs[];
 };
 
 /**
@@ -78,7 +78,7 @@ struct gcov_info {
 	unsigned int			n_functions;
 	const struct gcov_fn_info	*functions;
 	unsigned int			ctr_mask;
-	struct gcov_ctr_info		counts[0];
+	struct gcov_ctr_info		counts[];
 };
 
 /**
@@ -352,7 +352,7 @@ struct gcov_iterator {
 	unsigned int count;
 
 	int num_types;
-	struct type_info type_info[0];
+	struct type_info type_info[];
 };
 
 static struct gcov_fn_info *get_func(struct gcov_iterator *iter)
diff --git a/kernel/gcov/gcc_4_7.c b/kernel/gcov/gcc_4_7.c
index ec37563674d6..908fdf5098c3 100644
--- a/kernel/gcov/gcc_4_7.c
+++ b/kernel/gcov/gcc_4_7.c
@@ -68,7 +68,7 @@ struct gcov_fn_info {
 	unsigned int ident;
 	unsigned int lineno_checksum;
 	unsigned int cfg_checksum;
-	struct gcov_ctr_info ctrs[0];
+	struct gcov_ctr_info ctrs[];
 };
 
 /**
diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index 32406ef0d6a2..0ec2e82ffa7b 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -460,7 +460,7 @@ struct lock_trace {
 	struct hlist_node	hash_entry;
 	u32			hash;
 	u32			nr_entries;
-	unsigned long		entries[0] __aligned(sizeof(unsigned long));
+	unsigned long		entries[] __aligned(sizeof(unsigned long));
 };
 #define LOCK_TRACE_SIZE_IN_LONGS				\
 	(sizeof(struct lock_trace) / sizeof(unsigned long))
diff --git a/kernel/module.c b/kernel/module.c
index 33569a01d6e1..b88ec9cd2a7f 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1515,7 +1515,7 @@ struct module_sect_attr {
 struct module_sect_attrs {
 	struct attribute_group grp;
 	unsigned int nsections;
-	struct module_sect_attr attrs[0];
+	struct module_sect_attr attrs[];
 };
 
 static ssize_t module_sect_show(struct module_attribute *mattr,
@@ -1608,7 +1608,7 @@ static void remove_sect_attrs(struct module *mod)
 struct module_notes_attrs {
 	struct kobject *dir;
 	unsigned int notes;
-	struct bin_attribute attrs[0];
+	struct bin_attribute attrs[];
 };
 
 static ssize_t module_notes_read(struct file *filp, struct kobject *kobj,
diff --git a/kernel/params.c b/kernel/params.c
index 8e56f8b12d8f..55c07e3b9903 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -529,7 +529,7 @@ struct module_param_attrs
 {
 	unsigned int num;
 	struct attribute_group grp;
-	struct param_attribute attrs[0];
+	struct param_attribute attrs[];
 };
 
 #ifdef CONFIG_SYSFS
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index fe4e0d775375..2a4d85fcf41c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1081,7 +1081,7 @@ struct numa_group {
 	 * more by CPU use than by memory faults.
 	 */
 	unsigned long *faults_cpu;
-	unsigned long faults[0];
+	unsigned long faults[];
 };
 
 /*
diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 73956eaff8a9..3ee46cda2692 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -50,7 +50,7 @@ static bool ok_to_free_tracepoints;
  */
 struct tp_probes {
 	struct rcu_head rcu;
-	struct tracepoint_func probes[0];
+	struct tracepoint_func probes[];
 };
 
 static inline void *allocate_probes(int count)
diff --git a/lib/bch.c b/lib/bch.c
index 5db6d3a4c8a6..052d3fb753a0 100644
--- a/lib/bch.c
+++ b/lib/bch.c
@@ -102,7 +102,7 @@
  */
 struct gf_poly {
 	unsigned int deg;    /* polynomial degree */
-	unsigned int c[0];   /* polynomial terms */
+	unsigned int c[];   /* polynomial terms */
 };
 
 /* given its degree, compute a polynomial size in bytes */
diff --git a/lib/objagg.c b/lib/objagg.c
index 55621fb82e0a..5e1676ccdadd 100644
--- a/lib/objagg.c
+++ b/lib/objagg.c
@@ -28,7 +28,7 @@ struct objagg_hints_node {
 	struct objagg_hints_node *parent;
 	unsigned int root_id;
 	struct objagg_obj_stats_info stats_info;
-	unsigned long obj[0];
+	unsigned long obj[];
 };
 
 static struct objagg_hints_node *
@@ -66,7 +66,7 @@ struct objagg_obj {
 				* including nested objects
 				*/
 	struct objagg_obj_stats stats;
-	unsigned long obj[0];
+	unsigned long obj[];
 };
 
 static unsigned int objagg_obj_ref_inc(struct objagg_obj *objagg_obj)
diff --git a/lib/ts_bm.c b/lib/ts_bm.c
index b352903c50e3..277cb4417ac2 100644
--- a/lib/ts_bm.c
+++ b/lib/ts_bm.c
@@ -52,7 +52,7 @@ struct ts_bm
 	u8 *		pattern;
 	unsigned int	patlen;
 	unsigned int 	bad_shift[ASIZE];
-	unsigned int	good_shift[0];
+	unsigned int	good_shift[];
 };
 
 static unsigned int bm_find(struct ts_config *conf, struct ts_state *state)
diff --git a/lib/ts_fsm.c b/lib/ts_fsm.c
index 9c873cadab7c..ab749ec10ab5 100644
--- a/lib/ts_fsm.c
+++ b/lib/ts_fsm.c
@@ -32,7 +32,7 @@
 struct ts_fsm
 {
 	unsigned int		ntokens;
-	struct ts_fsm_token	tokens[0];
+	struct ts_fsm_token	tokens[];
 };
 
 /* other values derived from ctype.h */
diff --git a/lib/ts_kmp.c b/lib/ts_kmp.c
index 94617e014b3a..c77a3d537f24 100644
--- a/lib/ts_kmp.c
+++ b/lib/ts_kmp.c
@@ -36,7 +36,7 @@ struct ts_kmp
 {
 	u8 *		pattern;
 	unsigned int	pattern_len;
-	unsigned int 	prefix_tbl[0];
+	unsigned int	prefix_tbl[];
 };
 
 static unsigned int kmp_find(struct ts_config *conf, struct ts_state *state)
diff --git a/net/batman-adv/distributed-arp-table.c b/net/batman-adv/distributed-arp-table.c
index 3d21dd83f8cc..b85da4b7a77b 100644
--- a/net/batman-adv/distributed-arp-table.c
+++ b/net/batman-adv/distributed-arp-table.c
@@ -88,7 +88,7 @@ struct batadv_dhcp_packet {
 	__u8 sname[64];
 	__u8 file[128];
 	__be32 magic;
-	__u8 options[0];
+	__u8 options[];
 };
 
 #define BATADV_DHCP_YIADDR_LEN sizeof(((struct batadv_dhcp_packet *)0)->yiaddr)
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index e1256e03a9a8..78db58c7aec2 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1561,7 +1561,7 @@ struct compat_ebt_entry_mwt {
 		compat_uptr_t ptr;
 	} u;
 	compat_uint_t match_size;
-	compat_uint_t data[0] __attribute__ ((aligned (__alignof__(struct compat_ebt_replace))));
+	compat_uint_t data[] __aligned(__alignof__(struct compat_ebt_replace));
 };
 
 /* account for possible padding between match_size and ->data */
diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
index 3ab23f698221..427cfbc0d50d 100644
--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -60,7 +60,7 @@ struct bpf_sk_storage_data {
 	 * the number of cachelines access during the cache hit case.
 	 */
 	struct bpf_sk_storage_map __rcu *smap;
-	u8 data[0] __aligned(8);
+	u8 data[] __aligned(8);
 };
 
 /* Linked to bpf_sk_storage and bpf_sk_storage_map */
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 549ee56b7a21..a8c1f46319da 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4232,7 +4232,7 @@ struct devlink_fmsg_item {
 	int attrtype;
 	u8 nla_type;
 	u16 len;
-	int value[0];
+	int value[];
 };
 
 struct devlink_fmsg {
diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 31700e0c3928..43467c1af673 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -67,7 +67,7 @@ struct net_dm_hw_entry {
 
 struct net_dm_hw_entries {
 	u32 num_entries;
-	struct net_dm_hw_entry entries[0];
+	struct net_dm_hw_entry entries[];
 };
 
 struct per_cpu_dm_data {
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 085cef5857bb..3a7a96ab088a 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -518,7 +518,7 @@ struct bpf_htab_elem {
 	u32 hash;
 	struct sock *sk;
 	struct hlist_node node;
-	u8 key[0];
+	u8 key[];
 };
 
 struct bpf_htab_bucket {
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index f1f78a742b36..b167f4a5b684 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -1057,7 +1057,7 @@ struct compat_arpt_replace {
 	u32				underflow[NF_ARP_NUMHOOKS];
 	u32				num_counters;
 	compat_uptr_t			counters;
-	struct compat_arpt_entry	entries[0];
+	struct compat_arpt_entry	entries[];
 };
 
 static inline void compat_release_entry(struct compat_arpt_entry *e)
@@ -1383,7 +1383,7 @@ static int compat_copy_entries_to_user(unsigned int total_size,
 struct compat_arpt_get_entries {
 	char name[XT_TABLE_MAXNAMELEN];
 	compat_uint_t size;
-	struct compat_arpt_entry entrytable[0];
+	struct compat_arpt_entry entrytable[];
 };
 
 static int compat_get_entries(struct net *net,
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 10b91ebdf213..c2670eaa74e6 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1211,7 +1211,7 @@ struct compat_ipt_replace {
 	u32			underflow[NF_INET_NUMHOOKS];
 	u32			num_counters;
 	compat_uptr_t		counters;	/* struct xt_counters * */
-	struct compat_ipt_entry	entries[0];
+	struct compat_ipt_entry	entries[];
 };
 
 static int
@@ -1562,7 +1562,7 @@ compat_do_ipt_set_ctl(struct sock *sk,	int cmd, void __user *user,
 struct compat_ipt_get_entries {
 	char name[XT_TABLE_MAXNAMELEN];
 	compat_uint_t size;
-	struct compat_ipt_entry entrytable[0];
+	struct compat_ipt_entry entrytable[];
 };
 
 static int
diff --git a/net/ipv6/ah6.c b/net/ipv6/ah6.c
index 95835e8d99aa..871d6e52ec67 100644
--- a/net/ipv6/ah6.c
+++ b/net/ipv6/ah6.c
@@ -36,7 +36,7 @@ struct tmp_ext {
 		struct in6_addr saddr;
 #endif
 		struct in6_addr daddr;
-		char hdrs[0];
+		char hdrs[];
 };
 
 struct ah_skb_cb {
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index c973ace208c5..e27393498ecb 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1227,7 +1227,7 @@ struct compat_ip6t_replace {
 	u32			underflow[NF_INET_NUMHOOKS];
 	u32			num_counters;
 	compat_uptr_t		counters;	/* struct xt_counters * */
-	struct compat_ip6t_entry entries[0];
+	struct compat_ip6t_entry entries[];
 };
 
 static int
@@ -1571,7 +1571,7 @@ compat_do_ip6t_set_ctl(struct sock *sk, int cmd, void __user *user,
 struct compat_ip6t_get_entries {
 	char name[XT_TABLE_MAXNAMELEN];
 	compat_uint_t size;
-	struct compat_ip6t_entry entrytable[0];
+	struct compat_ip6t_entry entrytable[];
 };
 
 static int
diff --git a/net/ipv6/seg6_iptunnel.c b/net/ipv6/seg6_iptunnel.c
index ab7f124ff5d7..d8afe7290de8 100644
--- a/net/ipv6/seg6_iptunnel.c
+++ b/net/ipv6/seg6_iptunnel.c
@@ -29,7 +29,7 @@
 
 struct seg6_lwt {
 	struct dst_cache cache;
-	struct seg6_iptunnel_encap tuninfo[0];
+	struct seg6_iptunnel_encap tuninfo[];
 };
 
 static inline struct seg6_lwt *seg6_lwt_lwtunnel(struct lwtunnel_state *lwt)
diff --git a/net/netfilter/ipset/ip_set_bitmap_ip.c b/net/netfilter/ipset/ip_set_bitmap_ip.c
index 0a2196f59106..486959f70cf3 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ip.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ip.c
@@ -46,7 +46,7 @@ struct bitmap_ip {
 	u8 netmask;		/* subnet netmask */
 	struct timer_list gc;	/* garbage collection */
 	struct ip_set *set;	/* attached to this ip_set */
-	unsigned char extensions[0]	/* data extensions */
+	unsigned char extensions[]	/* data extensions */
 		__aligned(__alignof__(u64));
 };
 
diff --git a/net/netfilter/ipset/ip_set_bitmap_ipmac.c b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
index 739e343efaf6..2310a316e0af 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ipmac.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
@@ -49,7 +49,7 @@ struct bitmap_ipmac {
 	size_t memsize;		/* members size */
 	struct timer_list gc;	/* garbage collector */
 	struct ip_set *set;	/* attached to this ip_set */
-	unsigned char extensions[0]	/* MAC + data extensions */
+	unsigned char extensions[]	/* MAC + data extensions */
 		__aligned(__alignof__(u64));
 };
 
diff --git a/net/netfilter/ipset/ip_set_bitmap_port.c b/net/netfilter/ipset/ip_set_bitmap_port.c
index b49978dd810d..e56ced66f202 100644
--- a/net/netfilter/ipset/ip_set_bitmap_port.c
+++ b/net/netfilter/ipset/ip_set_bitmap_port.c
@@ -37,7 +37,7 @@ struct bitmap_port {
 	size_t memsize;		/* members size */
 	struct timer_list gc;	/* garbage collection */
 	struct ip_set *set;	/* attached to this ip_set */
-	unsigned char extensions[0]	/* data extensions */
+	unsigned char extensions[]	/* data extensions */
 		__aligned(__alignof__(u64));
 };
 
diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
index 2481470dec36..5827117f2635 100644
--- a/net/netfilter/nfnetlink_acct.c
+++ b/net/netfilter/nfnetlink_acct.c
@@ -33,7 +33,7 @@ struct nf_acct {
 	refcount_t		refcnt;
 	char			name[NFACCT_NAME_MAX];
 	struct rcu_head		rcu_head;
-	char			data[0];
+	char			data[];
 };
 
 struct nfacct_filter {
diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index bccd47cd7190..1b6d8b76aa67 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -131,7 +131,7 @@ struct xt_hashlimit_htable {
 	const char *name;
 	struct net *net;
 
-	struct hlist_head hash[0];	/* hashtable itself */
+	struct hlist_head hash[];	/* hashtable itself */
 };
 
 static int
diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index 0a9708004e20..6e6bc5b91199 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -71,7 +71,7 @@ struct recent_entry {
 	u_int8_t		ttl;
 	u_int8_t		index;
 	u_int16_t		nstamps;
-	unsigned long		stamps[0];
+	unsigned long		stamps[];
 };
 
 struct recent_table {
@@ -82,7 +82,7 @@ struct recent_table {
 	unsigned int		entries;
 	u8			nstamps_max_mask;
 	struct list_head	lru_list;
-	struct list_head	iphash[0];
+	struct list_head	iphash[];
 };
 
 struct recent_net {
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 4e31721e7293..bced11032681 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -71,7 +71,7 @@
 
 struct listeners {
 	struct rcu_head		rcu;
-	unsigned long		masks[0];
+	unsigned long		masks[];
 };
 
 /* state bits */
diff --git a/net/nfc/digital_dep.c b/net/nfc/digital_dep.c
index 65aaa9d7c813..304b1a9bb18a 100644
--- a/net/nfc/digital_dep.c
+++ b/net/nfc/digital_dep.c
@@ -71,7 +71,7 @@ struct digital_atr_req {
 	u8 bs;
 	u8 br;
 	u8 pp;
-	u8 gb[0];
+	u8 gb[];
 } __packed;
 
 struct digital_atr_res {
@@ -83,7 +83,7 @@ struct digital_atr_res {
 	u8 br;
 	u8 to;
 	u8 pp;
-	u8 gb[0];
+	u8 gb[];
 } __packed;
 
 struct digital_psl_req {
diff --git a/net/sched/em_ipt.c b/net/sched/em_ipt.c
index 9fff6480acc6..eecfe072c508 100644
--- a/net/sched/em_ipt.c
+++ b/net/sched/em_ipt.c
@@ -22,7 +22,7 @@ struct em_ipt_match {
 	const struct xt_match *match;
 	u32 hook;
 	u8 nfproto;
-	u8 match_data[0] __aligned(8);
+	u8 match_data[] __aligned(8);
 };
 
 struct em_ipt_xt_match {
diff --git a/net/sched/em_nbyte.c b/net/sched/em_nbyte.c
index 88c7ce42df7e..2c1192a2ee5e 100644
--- a/net/sched/em_nbyte.c
+++ b/net/sched/em_nbyte.c
@@ -16,7 +16,7 @@
 
 struct nbyte_data {
 	struct tcf_em_nbyte	hdr;
-	char			pattern[0];
+	char			pattern[];
 };
 
 static int em_nbyte_change(struct net *net, void *data, int data_len,
diff --git a/net/sched/sch_atm.c b/net/sched/sch_atm.c
index f4f9b8cdbffb..ee12ca9f55b4 100644
--- a/net/sched/sch_atm.c
+++ b/net/sched/sch_atm.c
@@ -58,7 +58,7 @@ struct atm_flow_data {
 	struct atm_flow_data	*excess;	/* flow for excess traffic;
 						   NULL to set CLP instead */
 	int			hdr_len;
-	unsigned char		hdr[0];		/* header data; MUST BE LAST */
+	unsigned char		hdr[];		/* header data; MUST BE LAST */
 };
 
 struct atm_qdisc_data {
diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index 42e557d48e4e..84f82771cdf5 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -66,7 +66,7 @@
 
 struct disttable {
 	u32  size;
-	s16 table[0];
+	s16 table[];
 };
 
 struct netem_sched_data {
diff --git a/net/sunrpc/xprtrdma/svc_rdma_rw.c b/net/sunrpc/xprtrdma/svc_rdma_rw.c
index 48fe3b16b0d9..003610ce00bc 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_rw.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_rw.c
@@ -41,7 +41,7 @@ struct svc_rdma_rw_ctxt {
 	struct rdma_rw_ctx	rw_ctx;
 	int			rw_nents;
 	struct sg_table		rw_sg_table;
-	struct scatterlist	rw_first_sgl[0];
+	struct scatterlist	rw_first_sgl[];
 };
 
 static inline struct svc_rdma_rw_ctxt *
diff --git a/net/switchdev/switchdev.c b/net/switchdev/switchdev.c
index 3a1d428c1336..60630762a748 100644
--- a/net/switchdev/switchdev.c
+++ b/net/switchdev/switchdev.c
@@ -29,7 +29,7 @@ struct switchdev_deferred_item {
 	struct list_head list;
 	struct net_device *dev;
 	switchdev_deferred_func_t *func;
-	unsigned long data[0];
+	unsigned long data[];
 };
 
 static struct switchdev_deferred_item *switchdev_deferred_dequeue(void)
diff --git a/samples/mei/mei-amt-version.c b/samples/mei/mei-amt-version.c
index 32234481ad7d..ad3e56042f96 100644
--- a/samples/mei/mei-amt-version.c
+++ b/samples/mei/mei-amt-version.c
@@ -267,7 +267,7 @@ struct amt_host_if_msg_header {
 struct amt_host_if_resp_header {
 	struct amt_host_if_msg_header header;
 	uint32_t status;
-	unsigned char data[0];
+	unsigned char data[];
 } __attribute__((packed));
 
 const uuid_le MEI_IAMTHIF = UUID_LE(0x12f80028, 0xb4b7, 0x4b2d,  \
diff --git a/scripts/basic/fixdep.c b/scripts/basic/fixdep.c
index 9ba47b0a47b9..693195e42e32 100644
--- a/scripts/basic/fixdep.c
+++ b/scripts/basic/fixdep.c
@@ -165,7 +165,7 @@ struct item {
 	struct item	*next;
 	unsigned int	len;
 	unsigned int	hash;
-	char		name[0];
+	char		name[];
 };
 
 #define HASHSZ 256
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 7edfdb2f4497..3b6f13934c41 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -172,7 +172,7 @@ struct symbol {
 				    *  (only for external modules) **/
 	unsigned int is_static:1;  /* 1 if symbol is not global */
 	enum export  export;       /* Type of export */
-	char name[0];
+	char name[];
 };
 
 static struct symbol *symbolhash[SYMBOL_HASH_SIZE];
diff --git a/security/apparmor/apparmorfs.c b/security/apparmor/apparmorfs.c
index 280741fc0f5f..299994ff9168 100644
--- a/security/apparmor/apparmorfs.c
+++ b/security/apparmor/apparmorfs.c
@@ -839,7 +839,7 @@ static ssize_t query_label(char *buf, size_t buf_len,
 struct multi_transaction {
 	struct kref count;
 	ssize_t size;
-	char data[0];
+	char data[];
 };
 
 #define MULTI_TRANSACTION_LIMIT (PAGE_SIZE - sizeof(struct multi_transaction))
diff --git a/sound/core/oss/rate.c b/sound/core/oss/rate.c
index 7cd09cef6961..d381f4c967c9 100644
--- a/sound/core/oss/rate.c
+++ b/sound/core/oss/rate.c
@@ -47,7 +47,7 @@ struct rate_priv {
 	unsigned int pos;
 	rate_f func;
 	snd_pcm_sframes_t old_src_frames, old_dst_frames;
-	struct rate_channel channels[0];
+	struct rate_channel channels[];
 };
 
 static void rate_init(struct snd_pcm_plugin *plugin)
diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index 5dc42f932739..97a03685dd8b 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -88,7 +88,7 @@ struct hda_conn_list {
 	struct list_head list;
 	int len;
 	hda_nid_t nid;
-	hda_nid_t conns[0];
+	hda_nid_t conns[];
 };
 
 /* look up the cached results */
diff --git a/sound/pci/hda/patch_ca0132.c b/sound/pci/hda/patch_ca0132.c
index ded8bc07d755..a4a39f7d9ae1 100644
--- a/sound/pci/hda/patch_ca0132.c
+++ b/sound/pci/hda/patch_ca0132.c
@@ -2698,7 +2698,7 @@ struct dsp_image_seg {
 	u32 magic;
 	u32 chip_addr;
 	u32 count;
-	u32 data[0];
+	u32 data[];
 };
 
 static const u32 g_magic_value = 0x4c46584d;
diff --git a/sound/soc/codecs/wm0010.c b/sound/soc/codecs/wm0010.c
index 727d6703c905..fbcee21736e8 100644
--- a/sound/soc/codecs/wm0010.c
+++ b/sound/soc/codecs/wm0010.c
@@ -43,7 +43,7 @@ struct dfw_binrec {
 	u8 command;
 	u32 length:24;
 	u32 address;
-	uint8_t data[0];
+	uint8_t data[];
 } __packed;
 
 struct dfw_inforec {
diff --git a/sound/usb/midi.c b/sound/usb/midi.c
index 392e5fda680c..be5c597ed40c 100644
--- a/sound/usb/midi.c
+++ b/sound/usb/midi.c
@@ -91,7 +91,7 @@ struct usb_ms_endpoint_descriptor {
 	__u8  bDescriptorType;
 	__u8  bDescriptorSubtype;
 	__u8  bNumEmbMIDIJack;
-	__u8  baAssocJackID[0];
+	__u8  baAssocJackID[];
 } __attribute__ ((packed));
 
 struct snd_usb_midi_in_endpoint;
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 514b1a524abb..2bcba0f290cc 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -7810,7 +7810,7 @@ static struct perf_buffer *__perf_buffer__new(int map_fd, size_t page_cnt,
 struct perf_sample_raw {
 	struct perf_event_header header;
 	uint32_t size;
-	char data[0];
+	char data[];
 };
 
 struct perf_sample_lost {
diff --git a/tools/perf/bench/sched-messaging.c b/tools/perf/bench/sched-messaging.c
index 97e4a4fb3362..71d830d7b923 100644
--- a/tools/perf/bench/sched-messaging.c
+++ b/tools/perf/bench/sched-messaging.c
@@ -40,7 +40,7 @@ struct sender_context {
 	unsigned int num_fds;
 	int ready_out;
 	int wakefd;
-	int out_fds[0];
+	int out_fds[];
 };
 
 struct receiver_context {
diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 7e124a7b8bfd..8f983877c42d 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -51,7 +51,7 @@ struct perf_inject {
 struct event_entry {
 	struct list_head node;
 	u32		 tid;
-	union perf_event event[0];
+	union perf_event event[];
 };
 
 static int output_bytes(struct perf_inject *inject, void *buf, size_t sz)
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index e2406b291c1c..4576b0b226fb 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -2568,7 +2568,7 @@ static int __cmd_script(struct perf_script *script)
 struct script_spec {
 	struct list_head	node;
 	struct scripting_ops	*ops;
-	char			spec[0];
+	char			spec[];
 };
 
 static LIST_HEAD(script_specs);
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 9e84fae9b096..0ba568efa939 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -128,7 +128,7 @@ struct sample_wrapper {
 	struct sample_wrapper *next;
 
 	u64		timestamp;
-	unsigned char	data[0];
+	unsigned char	data[];
 };
 
 #define TYPE_NONE	0
diff --git a/tools/perf/util/jitdump.c b/tools/perf/util/jitdump.c
index e3ccb0ce1938..32bb05e03fb2 100644
--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -57,7 +57,7 @@ struct debug_line_info {
 	unsigned long vma;
 	unsigned int lineno;
 	/* The filename format is unspecified, absolute path, relative etc. */
-	char const filename[0];
+	char const filename[];
 };
 
 struct jit_tool {
diff --git a/tools/perf/util/pstack.c b/tools/perf/util/pstack.c
index 80ff41fc45be..a1d1e4ef6257 100644
--- a/tools/perf/util/pstack.c
+++ b/tools/perf/util/pstack.c
@@ -15,7 +15,7 @@
 struct pstack {
 	unsigned short	top;
 	unsigned short	max_nr_entries;
-	void		*entries[0];
+	void		*entries[];
 };
 
 struct pstack *pstack__new(unsigned short max_nr_entries)
diff --git a/tools/perf/util/unwind-libunwind-local.c b/tools/perf/util/unwind-libunwind-local.c
index b4649f5a0c2f..9aededc0bc06 100644
--- a/tools/perf/util/unwind-libunwind-local.c
+++ b/tools/perf/util/unwind-libunwind-local.c
@@ -243,7 +243,7 @@ struct eh_frame_hdr {
 	 *    encoded_t fde_addr;
 	 * } binary_search_table[fde_count];
 	 */
-	char data[0];
+	char data[];
 } __packed;
 
 static int unwind_spec_ehframe(struct dso *dso, struct machine *machine,
diff --git a/tools/testing/selftests/nsfs/pidns.c b/tools/testing/selftests/nsfs/pidns.c
index e0d86e1668c0..e3c772c6a7c7 100644
--- a/tools/testing/selftests/nsfs/pidns.c
+++ b/tools/testing/selftests/nsfs/pidns.c
@@ -27,7 +27,7 @@
 #define __stack_aligned__	__attribute__((aligned(16)))
 struct cr_clone_arg {
 	char stack[128] __stack_aligned__;
-	char stack_ptr[0];
+	char stack_ptr[];
 };
 
 static int child(void *args)
-- 
2.25.0

