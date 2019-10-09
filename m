Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EEFFD1827
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 21:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732268AbfJITML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 15:12:11 -0400
Received: from mout.kundenserver.de ([217.72.192.74]:59681 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732061AbfJITLf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 15:11:35 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue109 [212.227.15.145]) with ESMTPA (Nemesis) id
 1M9Frd-1iCUhU1UAx-006S0r; Wed, 09 Oct 2019 21:09:11 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     linux-kernel@vger.kernel.org, y2038@lists.linaro.org,
        linux-fsdevel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v6 00/43] compat_ioctl: remove most of fs/compat_ioctl.c
Date:   Wed,  9 Oct 2019 21:08:52 +0200
Message-Id: <20191009190853.245077-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:soRfA8GEsLyL6KJg7pQMmF7Bo5SXBVsSv+VAvypPv38g8t9aDtn
 3y0GeYyEh9Ep2hbXg3Lgcef44HAU8BgCX5p0M8kyvLrlCTJan4SAkA/P7hpL88VyJP8xOqx
 WDz/UwhCf549lXsxlbiA1d0aA+bUwFqCIzBu3kWkC4G9ZxtTrn47udvoEX8UQyIcUxYqKra
 4x1+N9IJOh6o18fVm/DYg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:q9EmiQP5Hoc=:HeLrSdtqCXfrAstU0aO7OD
 884C2iPGS1h17y6cvncKVzY7Rh+WZvsveod21s3AMUX6zEPTX4OV2KmfDwGPPQf0hejWYCJbV
 OGiqdwt8W1012ByoFy9WMhEg1qB6V+/F6DVYrtAfM0b9pn7P8VTjMa3K0n5oKQA/RluYkP+Tv
 CTD4vr9OPALoSZkA9MXJ26tR5j4KoT6rdtZcb6D74ib/xLy+WdW6Uh96552Zb32nOXYPfQm/P
 urDGniIgVPa3PSjVOYcV4BzO8qqVeM8oeDPiSSFEbirsBH+/CPjGgIsR2UCmceeSQlqTRelnf
 Oci0xFbSJpZ7apksCk0/Fps4gl6B8+kL+c8kI9/8fDrmCUHEs7/gkchidTf4aL9t8fWVPnoKz
 NoabhvGvwUwR+LlmizruvBi0IXG1wQvMH5we7gOBbO6aqrrlFwl/XTDGYf1TN12JPvQZitMtz
 Jb3bhe6iE5io+NuBey6HpUCVQ7kKJn2kdIj9cvH57maGC5StNvBPRC/BNVgvMyci0CZaQJMUx
 iXcp7gh10qMZNlnOMhHMEO0wxiE0xib8XC5PRcPCTrZr8Gk8AzkgfiihJG0BE9LNTez9e4jWm
 Lyd8sFOPqqIYpMkMhcQpaTGpwgg05yjqT8TYD3rnCI8QBkDG5aCPiCw2hti6e7g76O7v2GIZv
 Lrh5y8x5j32XSdtk26K5V4B5y6+3xcrol+uyeYIY45s/bP6oRsgVHzeMtMhtWjQhn70QRH6VJ
 Mny9K9XEHt3dm7f3uu3k6U2Ip/kW3x5+7o5HK9+7HQFXccoMg8buR/iQh5PZMzcrBlYC30x4v
 d36CIWAEEHEUamoKgqnAzBSpP5dLcEPavVuKaJuEe7jT4VPam9B63/cWl12SAckf9GzCTYOgu
 Zxrg5El2sPCxv4k9iMhA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As part of the cleanup of some remaining y2038 issues, I came to
fs/compat_ioctl.c, which still has a couple of commands that need support
for time64_t.

In completely unrelated work, I spent time on cleaning up parts of this
file in the past, moving things out into drivers instead.

After Al Viro reviewed an earlier version of this series and did a lot
more of that cleanup, I decided to try to completely eliminate the rest
of it and move it all into drivers.

This series incorporates some of Al's work and many patches of my own,
but in the end stops short of actually removing the last part, which is
the scsi ioctl handlers. I have patches for those as well, but they need
more testing or possibly a rewrite.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---

Everything in here was posted one or more times already, sending
the whole series again for review, I hope to get some input on those
patches that have not already been reviewed.

The entire series is also part of linux-next through
https://git.kernel.org/pub/scm/linux/kernel/git/arnd/playground.git/commit/?h=y2038


Al Viro (8):
  fix compat handling of FICLONERANGE, FIDEDUPERANGE and FS_IOC_FIEMAP
  FIGETBSZ: fix compat
  compat: itanic doesn't have one
  do_vfs_ioctl(): use saner types
  compat: move FS_IOC_RESVSP_32 handling to fs/ioctl.c
  compat_sys_ioctl(): make parallel to do_vfs_ioctl()
  compat_ioctl: unify copy-in of ppp filters
  compat_ioctl: move PPPIOCSCOMPRESS to ppp_generic

Arnd Bergmann (35):
  ceph: fix compat_ioctl for ceph_dir_operations
  compat_ioctl: drop FIOQSIZE table entry
  compat_ioctl: add compat_ptr_ioctl()
  compat_ioctl: move rtc handling into rtc-dev.c
  compat_ioctl: move drivers to compat_ptr_ioctl
  compat_ioctl: move more drivers to compat_ptr_ioctl
  compat_ioctl: use correct compat_ptr() translation in drivers
  compat_ioctl: move tape handling into drivers
  compat_ioctl: move ATYFB_CLK handling to atyfb driver
  compat_ioctl: move isdn/capi ioctl translation into driver
  compat_ioctl: move rfcomm handlers into driver
  compat_ioctl: move hci_sock handlers into driver
  compat_ioctl: remove HCIUART handling
  compat_ioctl: remove HIDIO translation
  compat_ioctl: remove translation for sound ioctls
  compat_ioctl: remove IGNORE_IOCTL()
  compat_ioctl: remove /dev/random commands
  compat_ioctl: remove joystick ioctl translation
  compat_ioctl: remove PCI ioctl translation
  compat_ioctl: remove /dev/raw ioctl translation
  compat_ioctl: remove last RAID handling code
  compat_ioctl: remove unused convert_in_user macro
  gfs2: add compat_ioctl support
  fs: compat_ioctl: move FITRIM emulation into file systems
  compat_ioctl: move WDIOC handling into wdt drivers
  compat_ioctl: reimplement SG_IO handling
  af_unix: add compat_ioctl support
  compat_ioctl: handle SIOCOUTQNSD
  compat_ioctl: move SIOCOUTQ out of compat_ioctl.c
  tty: handle compat PPP ioctls
  compat_ioctl: handle PPPIOCGIDLE for 64-bit time_t
  compat_ioctl: ppp: move simple commands into ppp_generic.c
  compat_ioctl: move SG_GET_REQUEST_TABLE handling
  pktcdvd: add compat_ioctl handler
  scsi: sd: enable compat ioctls for sed-opal

 Documentation/networking/ppp_generic.txt    |   2 +
 arch/powerpc/platforms/52xx/mpc52xx_gpt.c   |   1 +
 arch/um/drivers/harddog_kern.c              |   1 +
 arch/um/drivers/hostaudio_kern.c            |   1 +
 block/scsi_ioctl.c                          | 132 ++-
 drivers/android/binder.c                    |   2 +-
 drivers/block/pktcdvd.c                     |  25 +
 drivers/char/ipmi/ipmi_watchdog.c           |   1 +
 drivers/char/ppdev.c                        |  12 +-
 drivers/char/random.c                       |   1 +
 drivers/char/tpm/tpm_vtpm_proxy.c           |  12 +-
 drivers/crypto/qat/qat_common/adf_ctl_drv.c |   2 +-
 drivers/dma-buf/dma-buf.c                   |   4 +-
 drivers/dma-buf/sw_sync.c                   |   2 +-
 drivers/dma-buf/sync_file.c                 |   2 +-
 drivers/firewire/core-cdev.c                |  12 +-
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c    |   2 +-
 drivers/hid/hidraw.c                        |   4 +-
 drivers/hid/usbhid/hiddev.c                 |  11 +-
 drivers/hwmon/fschmd.c                      |   1 +
 drivers/hwtracing/stm/core.c                |  12 +-
 drivers/ide/ide-tape.c                      |  27 +-
 drivers/iio/industrialio-core.c             |   2 +-
 drivers/infiniband/core/uverbs_main.c       |   4 +-
 drivers/isdn/capi/capi.c                    |  31 +
 drivers/media/rc/lirc_dev.c                 |   4 +-
 drivers/misc/cxl/flash.c                    |   8 +-
 drivers/misc/genwqe/card_dev.c              |  23 +-
 drivers/misc/mei/main.c                     |  22 +-
 drivers/misc/vmw_vmci/vmci_host.c           |   2 +-
 drivers/mtd/ubi/cdev.c                      |  36 +-
 drivers/net/ppp/ppp_generic.c               | 245 ++++--
 drivers/net/tap.c                           |  12 +-
 drivers/nvdimm/bus.c                        |   4 +-
 drivers/nvme/host/core.c                    |   2 +-
 drivers/pci/switch/switchtec.c              |   2 +-
 drivers/platform/x86/wmi.c                  |   2 +-
 drivers/rpmsg/rpmsg_char.c                  |   4 +-
 drivers/rtc/dev.c                           |  13 +-
 drivers/rtc/rtc-ds1374.c                    |   1 +
 drivers/rtc/rtc-vr41xx.c                    |  10 +
 drivers/s390/char/tape_char.c               |  41 +-
 drivers/sbus/char/display7seg.c             |   2 +-
 drivers/sbus/char/envctrl.c                 |   4 +-
 drivers/scsi/3w-xxxx.c                      |   4 +-
 drivers/scsi/cxlflash/main.c                |   2 +-
 drivers/scsi/esas2r/esas2r_main.c           |   2 +-
 drivers/scsi/megaraid/megaraid_mm.c         |  28 +-
 drivers/scsi/pmcraid.c                      |   4 +-
 drivers/scsi/sd.c                           |  14 +-
 drivers/scsi/sg.c                           |  59 +-
 drivers/scsi/st.c                           |  28 +-
 drivers/staging/android/ion/ion.c           |   4 +-
 drivers/staging/pi433/pi433_if.c            |  12 +-
 drivers/staging/vme/devices/vme_user.c      |   2 +-
 drivers/tee/tee_core.c                      |   2 +-
 drivers/tty/tty_io.c                        |   5 +
 drivers/usb/class/cdc-wdm.c                 |   2 +-
 drivers/usb/class/usbtmc.c                  |   4 +-
 drivers/usb/core/devio.c                    |  16 +-
 drivers/usb/gadget/function/f_fs.c          |  12 +-
 drivers/vfio/vfio.c                         |  39 +-
 drivers/vhost/net.c                         |  12 +-
 drivers/vhost/scsi.c                        |  12 +-
 drivers/vhost/test.c                        |  12 +-
 drivers/vhost/vsock.c                       |  12 +-
 drivers/video/fbdev/aty/atyfb_base.c        |  12 +-
 drivers/virt/fsl_hypervisor.c               |   2 +-
 drivers/watchdog/acquirewdt.c               |   1 +
 drivers/watchdog/advantechwdt.c             |   1 +
 drivers/watchdog/alim1535_wdt.c             |   1 +
 drivers/watchdog/alim7101_wdt.c             |   1 +
 drivers/watchdog/ar7_wdt.c                  |   1 +
 drivers/watchdog/at91rm9200_wdt.c           |   1 +
 drivers/watchdog/ath79_wdt.c                |   1 +
 drivers/watchdog/bcm63xx_wdt.c              |   1 +
 drivers/watchdog/cpu5wdt.c                  |   1 +
 drivers/watchdog/eurotechwdt.c              |   1 +
 drivers/watchdog/f71808e_wdt.c              |   1 +
 drivers/watchdog/gef_wdt.c                  |   1 +
 drivers/watchdog/geodewdt.c                 |   1 +
 drivers/watchdog/ib700wdt.c                 |   1 +
 drivers/watchdog/ibmasr.c                   |   1 +
 drivers/watchdog/indydog.c                  |   1 +
 drivers/watchdog/intel_scu_watchdog.c       |   1 +
 drivers/watchdog/iop_wdt.c                  |   1 +
 drivers/watchdog/it8712f_wdt.c              |   1 +
 drivers/watchdog/ixp4xx_wdt.c               |   1 +
 drivers/watchdog/m54xx_wdt.c                |   1 +
 drivers/watchdog/machzwd.c                  |   1 +
 drivers/watchdog/mixcomwd.c                 |   1 +
 drivers/watchdog/mtx-1_wdt.c                |   1 +
 drivers/watchdog/mv64x60_wdt.c              |   1 +
 drivers/watchdog/nv_tco.c                   |   1 +
 drivers/watchdog/pc87413_wdt.c              |   1 +
 drivers/watchdog/pcwd.c                     |   1 +
 drivers/watchdog/pcwd_pci.c                 |   1 +
 drivers/watchdog/pcwd_usb.c                 |   1 +
 drivers/watchdog/pika_wdt.c                 |   1 +
 drivers/watchdog/pnx833x_wdt.c              |   1 +
 drivers/watchdog/rc32434_wdt.c              |   1 +
 drivers/watchdog/rdc321x_wdt.c              |   1 +
 drivers/watchdog/riowd.c                    |   1 +
 drivers/watchdog/sa1100_wdt.c               |   1 +
 drivers/watchdog/sb_wdog.c                  |   1 +
 drivers/watchdog/sbc60xxwdt.c               |   1 +
 drivers/watchdog/sbc7240_wdt.c              |   1 +
 drivers/watchdog/sbc_epx_c3.c               |   1 +
 drivers/watchdog/sbc_fitpc2_wdt.c           |   1 +
 drivers/watchdog/sc1200wdt.c                |   1 +
 drivers/watchdog/sc520_wdt.c                |   1 +
 drivers/watchdog/sch311x_wdt.c              |   1 +
 drivers/watchdog/scx200_wdt.c               |   1 +
 drivers/watchdog/smsc37b787_wdt.c           |   1 +
 drivers/watchdog/w83877f_wdt.c              |   1 +
 drivers/watchdog/w83977f_wdt.c              |   1 +
 drivers/watchdog/wafer5823wdt.c             |   1 +
 drivers/watchdog/watchdog_dev.c             |   1 +
 drivers/watchdog/wdrtas.c                   |   1 +
 drivers/watchdog/wdt.c                      |   1 +
 drivers/watchdog/wdt285.c                   |   1 +
 drivers/watchdog/wdt977.c                   |   1 +
 drivers/watchdog/wdt_pci.c                  |   1 +
 fs/btrfs/super.c                            |   2 +-
 fs/ceph/dir.c                               |   1 +
 fs/ceph/file.c                              |   2 +-
 fs/ceph/super.h                             |   1 +
 fs/compat_ioctl.c                           | 917 +-------------------
 fs/ecryptfs/file.c                          |   1 +
 fs/ext4/ioctl.c                             |   1 +
 fs/f2fs/file.c                              |   1 +
 fs/fat/file.c                               |  13 +-
 fs/fuse/dev.c                               |   2 +-
 fs/gfs2/file.c                              |  30 +
 fs/hpfs/dir.c                               |   1 +
 fs/hpfs/file.c                              |   1 +
 fs/ioctl.c                                  |  80 +-
 fs/nilfs2/ioctl.c                           |   1 +
 fs/notify/fanotify/fanotify_user.c          |   2 +-
 fs/ocfs2/ioctl.c                            |   1 +
 fs/userfaultfd.c                            |   2 +-
 include/linux/blkdev.h                      |   2 +
 include/linux/falloc.h                      |  20 +
 include/linux/fs.h                          |   7 +
 include/linux/mtio.h                        |  60 ++
 include/uapi/linux/ppp-ioctl.h              |   2 +
 include/uapi/linux/ppp_defs.h               |  14 +
 lib/iov_iter.c                              |   1 +
 net/bluetooth/hci_sock.c                    |  21 +-
 net/bluetooth/rfcomm/sock.c                 |  14 +-
 net/rfkill/core.c                           |   2 +-
 net/socket.c                                |   3 +
 net/unix/af_unix.c                          |  19 +
 sound/core/oss/pcm_oss.c                    |   4 +
 sound/oss/dmasound/dmasound_core.c          |   2 +
 155 files changed, 935 insertions(+), 1394 deletions(-)
 create mode 100644 include/linux/mtio.h

-- 
2.20.0

