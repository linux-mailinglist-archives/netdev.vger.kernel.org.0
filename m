Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7FC41609AA
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 05:45:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727983AbgBQEpT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 16 Feb 2020 23:45:19 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:49196 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727685AbgBQEpT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 23:45:19 -0500
Received: by mail-il1-f199.google.com with SMTP id p7so13376252ilq.16
        for <netdev@vger.kernel.org>; Sun, 16 Feb 2020 20:45:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to:content-transfer-encoding;
        bh=dn4MciHwD/yeBu35qzDObLRKjTPI1in9zOkJBdWyPTs=;
        b=RfXHzEB+1VAH6SBvSsKj0qjBZxEK+xYuxv9JgzTzGpyJ+dy5CTTzMAyU55vpzUVg4H
         F4VK/94BeJC8o33SXnDsp8N2COCGiS+kN6Eh8MeB4D/WTz+S4P/JlhaD64jOOFANl/2u
         BOIIql7F7yNXVv1xNB2Kjy9bYiyZJtMSwW4XYL0T+928yxDBYEEU+eSvLN9OPPdbYFiK
         DP8UJ5j2Yy7o1UeGVY0BZLVvPDuvMRqqCfrFAD5IC8BHkUR+ZeZFJPZtw5DqyKHnBw+e
         wEWKi8S10aS5yKh1IMlFZWfCYA8iLNAwOlVJ7HeRGaVxc0EgUGEafDKmB3A+wK6n1bmQ
         QrNw==
X-Gm-Message-State: APjAAAW0FY/sltW6WuzzKhMtb4I+yj+tegBjuo1P6edBP5Lzp5hf0wkq
        0qg3Wiz6a9NAlQ+rgOROtohcqKSnkM4MWdBF5QsFSgzHTNcr
X-Google-Smtp-Source: APXvYqxasJauvlNpQMjzY3NXdpBWl92FzyCCOeKo04hF+cGOFmlhauXHsAbjCrDD0DicQTj8r59Nv16WbSQknubl11wfZ1Y0n5M1
MIME-Version: 1.0
X-Received: by 2002:a92:860a:: with SMTP id g10mr12746645ild.280.1581914716168;
 Sun, 16 Feb 2020 20:45:16 -0800 (PST)
Date:   Sun, 16 Feb 2020 20:45:16 -0800
In-Reply-To: <000000000000ed4120057e2df0c6@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b8e97f059ebe38cf@google.com>
Subject: Re: KASAN: stack-out-of-bounds Write in ax25_getname
From:   syzbot <syzbot+6a29097222b4d3b8617c@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jreuter@yaina.de, kuba@kernel.org,
        linux-hams@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, ralf@linux-mips.org,
        sisiyang@uniconcctv.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    11a48a5a Linux 5.6-rc2
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14e7f56ee00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b1248cc89e4dba4
dashboard link: https://syzkaller.appspot.com/bug?extid=6a29097222b4d3b8617c
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15517d6ee00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=133c3eb5e00000

Bisection is inconclusive: the first bad commit could be any of:

3d8e15dd KVM: new maintainer on the block
541d8f4d Merge tag 'for-linus' of git://git.kernel.org/pub/scm/virt/kvm/kvm
8d4a2ec1 assoc_array: don't call compare_object() on a node
952cca6a ASN.1: fix open failure check on headername
9cb5b787 Merge tag 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma
c4004b02 x86: remove the kernel code/data/bss resources from /proc/iomem
4a6cd3ba Merge tag 'kvm-arm-for-4.6-rc4' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm
7a98205d KVM: MMU: fix permission_fault()
fc5b7f3b kvm: x86: do not leak guest xcr0 into host interrupt handlers
316314ca KVM: x86: mask CPUID(0xD,0x1).EAX against host value
915e846d Merge tag 'imx-drm-next-2016-04-01' of git://git.pengutronix.de/git/pza/linux into drm-fixes
5003bc6c Merge tag 'spi-fix-v4.6-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi
4cf43e0e Merge branch 'for-upstream/hdlcd' of git://linux-arm.org/linux-ld into drm-fixes
30aab189 Merge branch 'linux-4.6' of git://github.com/skeggsb/linux into drm-fixes
1b5caa3e Merge tag 'pinctrl-v4.6-2' of git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl
62d2def9 Merge tag 'media/v4.6-3' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media
1e1e5ce7 Merge tag 'linux-kselftest-4.6-rc3' of git://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux-kselftest
fd8c61eb Merge branch 'drm-fixes-4.6' of git://people.freedesktop.org/~agd5f/linux into drm-fixes
c3b1feb0 Merge branch 'upstream' of git://git.linux-mips.org/pub/scm/ralf/upstream-linus
741f37b8 Merge branch 'drm-fixes' of git://people.freedesktop.org/~airlied/linux
d3436a1d Merge tag 'for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost
1c915b3a Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client
636c8a8d Merge tag 'usb-serial-4.6-rc3' of git://git.kernel.org/pub/scm/linux/kernel/git/johan/usb-serial into usb-linus
73659be7 Merge branches 'pm-core', 'powercap' and 'pm-tools'
93e2aeac Merge tag 'for-linus-4.6-rc2-tag' of git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip
fa81e66e Merge branches 'pm-cpufreq', 'pm-cpuidle' and 'acpi-cppc'
30d237a6 Merge tag 'mac80211-for-davem-2016-04-06' of git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211
93061f39 Merge tag 'ext4_for_linus_stable' of git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4
3c968887 Revert "ib_srpt: Convert to percpu_ida tag allocation"
592570c9 parisc: Handle R_PARISC_PCREL32 relocations in kernel modules
a61b37ea mailbox: xgene-slimpro: Fix wrong test for devm_kzalloc
e865f496 Merge branch 'for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs
17f5f28f mailbox: mailbox-test: Use more consistent format for calling copy_from_user()
e3893027 parisc: Avoid function pointers for kernel exception routines
d1c2f87c mailbox: mailbox-test: Prevent memory leak
ef72f311 parisc: Fix kernel crash with reversed copy_from_user()
0c44d789 mailbox: Stop using ENOSYS for anything other than unimplemented syscalls
2ef4dfd9 parisc: Unbreak handling exceptions from kernel modules
c7e82c64 Merge tag 'f2fs-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs
c44da62b ALSA: hda - Fix inconsistent monitor_present state until repoll
cb910c17 parisc: Update comment regarding relative extable support
023d8218 ALSA: hda - Fix regression of monitor_present flag in eld proc file
1a59c539 Merge tag 'iommu-fixes-v4.6-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu
e56f4981 orangefs: remove unused variable
1917a693 orangefs: Add KERN_<LEVEL> to gossip_<level> macros
adcdd0d5 ALSA: usb-audio: Skip volume controls triggers hangup on Dell USB Dock
0b74ecdf iommu/vt-d: Silence an uninitialized variable warning
166c5a6e gma500: remove annoying deprecation warning
2eacea74 orangefs: strncpy -> strscpy
9b8e3ec3 gpio: pca953x: Use correct u16 value for register word write
c00bbcf8 virtio: add VIRTIO_CONFIG_S_NEEDS_RESET device status bit
c636b95e ALSA: hda/realtek - Enable the ALC292 dock fixup on the Thinkpad T460s
0dee6c82 ARC: [plat-axs103] Enable loop block devices
159f3cd9 gpiolib: Defer gpio device setup until after gpiolib initialization
3430284f bridge, netem: mark mailing lists as moderated
4a2d057e Merge branch 'PAGE_CACHE_SIZE-removal'
dc5027a7 ALSA: sscape: Use correct format identifier for size_t
eeca9a67 MAINTAINERS: add entry for QEMU
f83140c1 orangefs: clean up truncate ctime and mtime setting
fbedd9b9 iommu/rockchip: Fix "is stall active" check
016adb72 tuntap: restore default qdisc
2fa37fd7 Orangefs: fix ifnullfree.cocci warnings
476e2fc5 gpiolib: Do not use devm functions when registering gpio chip
6dc97ee6 Revert "ARC: [plat-axs10x] add Ethernet PHY description in .dts"
a3901802 libnvdimm, pfn: fix nvdimm_namespace_add_poison() vs section alignment
b4203ff5 ALSA: usb-audio: Add a quirk for Plantronics BT300
cb39f732 Merge remote-tracking branches 'spi/fix/omap2' and 'spi/fix/rockchip' into spi-linus
d48d5691 USB: option: add "D-Link DWM-221 B1" device id
def7ac80 firmware: qemu_fw_cfg.c: hold ACPI global lock during device access
eebb8034 iommu: Don't overwrite domain pointer when there is no default_domain
05dbcb43 virtio: virtio 1.0 cs04 spec compliance for reset
07b48ac4 iommu/dma: Restore scatterlist offsets correctly
16669bef PM / wakeirq: fix wakeirq setting after wakup re-configuration from sysfs
2b657a58 Merge remote-tracking branch 'spi/fix/imx' into spi-linus
2fe78571 i40iw: avoid potential uninitialized variable use
47cd3060 hwrng: bcm63xx - fix device tree compilation
7b8ba82a m68k/defconfig: Update defconfigs for v4.6-rc2
94a57f1f mpls: find_outdev: check for err ptr in addition to NULL check
a9bb3ba8 Orangefs: optimize boilerplate code.
c4e5ffb6 gpio: pxa: fix legacy non pinctrl aware builds
cddc9434 USB: serial: cp210x: Adding GE Healthcare Device ID
e5670563 libnvdimm, pfn: fix uuid validation
e5e0a65c arc: Add our own implementation of fb_pgprotect()
f03b24a8 ALSA: usb-audio: Add a sample rate quirk for Phoenix Audio TMX320
0eb2c80c m68k: Wire up preadv2 and pwritev2
21129112 libnvdimm: fix smart data retrieval
2224d879 rbd: use GFP_NOIO consistently for request allocations
25487533 gpio / ACPI: ignore GpioInt() GPIOs when requesting GPIO_OUT_*
2d09a2ca Orangefs: xattr.c cleanup
3ba3458f ipv6: Count in extension headers in skb->network_header
732dc97b ARC: Don't source drivers/pci/pcie/Kconfig ourselves
8fd2910e PM / runtime: Document steps for device removal
9967c70a IB/mlx5: fix VFs callback function prototypes
b70bb984 iommu: provide of_xlate pointer unconditionally
bfa5fb14 ALSA: hda - Bind with i915 only when Intel graphics is present
c12d2da5 mm/gup: Remove the macro overload API migration helpers from the get_user*() APIs
d7124d69 Merge remote-tracking branch 'spi/fix/core' into spi-linus
e8aabc64 qemu_fw_cfg: don't leak kobj on init error
ea6db90e USB: serial: ftdi_sio: Add support for ICP DAS I-756xU devices
ef609c23 sunrpc: Fix skcipher/shash conversion
579ba855 RDS: fix congestion map corruption for PAGE_SIZE > 4k
9735a227 Linux 4.6-rc2
4c3b73c6 Merge branch 'perf-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
67592126 Merge tag 'for-linus-4.6-ofs1' of git://git.kernel.org/pub/scm/linux/kernel/git/hubcap/linux
e98499ac RDS: memory allocated must be align to 8
7b367f5d Merge branch 'core-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
839a3f76 Merge branch 'for-linus-4.6' of git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs
a0ca153f GRE: Disable segmentation offloads w/ CSUM and we are encapsulated via FOU
0a1a37b6 net: add the AF_KCM entries to family name tables
eff471b1 MAINTAINERS: intel-wired-lan list is moderated
9c94f6c8 lib/test_bpf: Add additional BPF_ADD tests
b64b50ea lib/test_bpf: Add test to check for result of 32-bit add that overflows
c7395d6b lib/test_bpf: Add tests for unsigned BPF_JGT
9f134c34 lib/test_bpf: Fix JMP_JSET tests
8ab18d71 VSOCK: Detach QP check should filter out non matching QPs.
17084b7e v4l2-mc: avoid warning about unused variable
52f95bbf stmmac: fix adjust link call in case of a switch is attached
30cebb6c Merge branch 'x86-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
6ae81ced af_packet: tone down the Tx-ring unsupported spew.
18fcf49f net_sched: fix a memory leak in tc action
138d6153 samples/bpf: Enable powerpc support
128d1514 samples/bpf: Use llc in PATH, rather than a hardcoded value
77e63534 samples/bpf: Fix build breakage with map_perf_test_user.c
32fa270c Revert "bridge: Fix incorrect variable assignment on error path in br_sysfs_addbr"
529927f9 cxgb4: Add pci device id for chelsio t520-cr adapter
b4201cc4 mac80211: fix "warning: ‘target_metric’ may be used uninitialized"
b6ee376c ip6_tunnel: set rtnl_link_ops before calling register_netdevice
f6d4671a mac80211: close the SP when we enqueue frames during the SP
4b559ec0 mac80211: Fix BW upgrade for TDLS peers
727ceaa4 Revert "netpoll: Fix extra refcount release in netpoll_cleanup()"
f7eeb8a8 Merge tag 'rproc-v4.6-rc1' of git://github.com/andersson/remoteproc
aa4f069e Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/net-queue
facde7f3 mac80211: don't send deferred frames outside the SP
a4605fef e1000: Double Tx descriptors needed check for 82544
c2d45923 mac80211: remove description of dropped member
847a1d67 e1000: Do not overestimate descriptor counts in Tx pre-check
84ea3a18 mac80211: add doc for RX_FLAG_DUP_VALIDATED flag
d6c24df0 Merge git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending
8e2cc0e6 i40e: fix errant PCIe bandwidth message
b6bf8c68 mac80211: ensure no limits on station rhashtable
62b14b24 mac80211: properly deal with station hashtable insert errors
eb8e9771 sctp: use list_* in sctp_list_dequeue
aa507a7b mac80211: recalc min_def chanctx even when chandef is identical
e43569e6 sctp: flush if we can't fit another DATA chunk
59021c67 mac80211: TDLS: change BW calculation for WIDER_BW peers
c862cc9b bridge: Fix incorrect variable assignment on error path in br_sysfs_addbr
be447f30 ipv6: l2tp: fix a potential issue in l2tp_ip6_recv
cb107161 Convert straggling drivers to new six-argument get_user_pages()
db8d9977 mac80211: TDLS: always downgrade invalid chandefs
264800b5 Merge tag 'configfs-for-linus-2' of git://git.infradead.org/users/hch/configfs
5745b823 ipv4: l2tp: fix a potential issue in l2tp_ip_recv
c3732a7b mac80211: fix AP buffered multicast frames with queue control and txq
05cf8077 Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
cf78031a Merge tag 'clk-fixes-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/clk/linux
1826907c Merge tag 'pm+acpi-4.6-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm
4e19fd93 Merge branch 'akpm' (patches from Andrew)
7c0ecda1 drm/amdgpu: total vram size also reduces pin size
9ef11ceb Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
91628231 drm/amd/powerplay: add uvd/vce dpm enabling flag default.
0168f78f drm/amd/powerplay: fix issue that resume back, dpm can't work on FIJI.
d23be4e3 drm/amdgpu: save and restore the firwmware cache part when suspend resume
394532e4 .mailmap: add Christophe Ricard
3f99dd81 drm/amdgpu: save and restore UVD context with suspend and resume
749b48fa drm/ttm: use phys_addr_t for ttm_bus_placement
f76be617 Make CONFIG_FHANDLE default y
5e916a3a drm/radeon: Only call drm_vblank_on/off between drm_vblank_init/cleanup
82d2a348 Merge branch 'for-linus-4.6' of git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs
ec3b6882 mm/page_isolation.c: fix the function comments
22fed397 Merge tag 'for-linus' of git://github.com/martinbrandenburg/linux
af8e15cc oom, oom_reaper: do not enqueue task if it is on the oom_reaper_list head
fc387a0b drm/amdgpu: fence wait old rcu slot
ab7e9c13 drm/amdgpu: fix leaking fence in the pageflip code
bbe3de25 mm/page_isolation: fix tracepoint to mirror check function behavior
1f8628c7 drm/amdgpu: print vram type rather than just DDR
858eaaa7 mm/rmap: batched invalidations should use existing api
18c98243 x86/mm: TLB_REMOTE_SEND_IPI should count pages
4fff5056 Merge tag 'arm64-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux
b634de4f drm/amdgpu/gmc: use proper register for vram type on Fiji
6f25a14a mm: fix invalid node in alloc_migrate_target()
d1518a1d drm/amdgpu/gmc: move vram type fetching into sw_init
354edd8e drm/amdgpu: Set vblank_disable_allowed = true
969e8d7e include/linux/huge_mm.h: return NULL instead of false for pmd_trans_huge_lock()
0b355eaa mm, kasan: fix compilation for CONFIG_SLAB
978ccad6 drm/radeon: Set vblank_disable_allowed = true
2708d17d Merge tag 'sound-4.6-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound
b39c3cf4 MAINTAINERS: orangefs mailing list is subscribers-only
e0c77163 drm/amd/powerplay: Need to change boot to performance state in resume.
6ddf37da Merge branch 'drm-fixes' of git://people.freedesktop.org/~airlied/linux
bbe6aa99 drm/amd/powerplay: add new Fiji function for not setting same ps.
5349ece7 drm/amdgpu: check dpm state before pm system fs initialized.
4cd05a74 drm/amd/powerplay: notify amdgpu whether dpm is enabled or not.
1587f6e4 drm/amdgpu: Not support disable dpm in powerplay.
4c90080b drm/amdgpu: add an cgs interface to notify amdgpu the dpm state.
f9e9c08e drm/amd/powerplay: fix segment fault issue in multi-display case.
52bef0cb Merge tag 'powerpc-4.6-2' of git://git.kernel.org/pub/scm/linux/kernel/git/powerpc/linux
72b9ff06 drm/udl: Use unlocked gem unreferencing
40bca9db Merge tag 'pm+acpi-4.6-rc3' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm
7779c5e2 drm/dp: move hw_mutex up the call stack
f9a67b11 md/bitmap: clear bitmap if bitmap_create failed
1fa64f19 mm: drop PAGE_CACHE_* and page_cache_{get,release} definition
5456248d Merge branch 'drm-rockchip-next-fixes-2016-03-28' of https://github.com/markyzq/kernel-drm-rockchip into drm-fixes
ed3b98c7 MD: add rdev reference for super write
466ad292 md: fix a trivial typo in comments
90516d89 Merge branch 'msm-fixes-4.6-rc1' of git://people.freedesktop.org/~robclark/linux into drm-fixes
ea1754a0 mm, fs: remove remaining PAGE_CACHE_* and page_cache_{get,release} usage
09cbfeaf mm, fs: get rid of PAGE_CACHE_* and page_cache_{get,release} macros
2f4fcb3e Merge branch 'drm-next-4.6' of git://people.freedesktop.org/~agd5f/linux into drm-fixes
816b0acf md:raid1: fix a dead loop when read from a WriteMostly disk
dc8a64ee Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux
c05c2ec9 Merge branch 'parisc-4.6-2' of git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux
63b106a8 Merge tag 'md/4.6-rc2-fix' of git://git.kernel.org/pub/scm/linux/kernel/git/shli/md
e9dcfaff Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs
39ec5cbe Merge tag 'fixes-for-v4.6-rc3' of git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb into usb-linus
ca457204 Merge tag 'gpio-v4.6-2' of git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio
fb41b4be Merge tag 'scsi-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi
0b24f7a8 Merge tag 'mvebu-fixes-4.6-1' of git://git.infradead.org/linux-mvebu into fixes
95272c29 compiler-gcc: disable -ftracer for __noclone functions
61abdbe0 kvm: x86: make lapic hrtimer pinned
c5bce408 Merge branch 'libnvdimm-for-next' of git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm
3d50a7fb MIPS: traps.c: Verify the ISA for microMIPS RDHWR emulation
452a31fd ARM: sa1100: remove references to the defunct handhelds.org
9c650d09 s390/mm/kvm: fix mis-merge in gmap handling
13ab2c80 Merge tag 'pxa-fixes-v4.6' of https://github.com/rjarzmik/linux into fixes
14f47605 kvm: set page dirty only if page has been writable
1e6d88cc Merge tag 'nios2-v4.6-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/lftan/nios2
353def94 MAINTAINERS: Update my email address
6870e707 MIPS: BMIPS: Fix gisb-arb compatible string for 7435
04211a57 MIPS: Bail on unsupported module relocs
14ebda33 KVM: x86: reduce default value of halt_poll_ns parameter
39e2e173 locking/lockdep: Print chain_key collision information
adf9a3ab usb: dwc3: keystone: drop dma_mask configuration
283d7573 uapi/linux/stddef.h: Provide __always_inline to userspace headers
2e1d18c6 Merge tag 'omap-for-v4.6/fixes-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap into fixes
62f444e0 Merge branch 'linus' of git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6
79171e9b usb: gadget: udc-core: remove manual dma configuration
a2b5c3c0 KVM: Hyper-V: do not do hypercall userspace exits if SynIC is disabled
f7f797cf MIPS: dts: qca: ar9132_tl_wr1043nd_v1.dts: use "ref" for reference clock name
07c0db77 Merge tag 'dlm-4.6-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/teigland/linux-dlm
1ffb4d5c usb: dwc3: pci: add ID for one more Intel Broxton platform
321c5658 KVM: x86: Inject pending interrupt even if pending nmi exist
a189c017 tools/lib/lockdep: Fix unsupported 'basename -s' in run_tests.sh
f4c87b7a MIPS: ath79: Fix the ar913x reference clock rate
4fccb076 usb: renesas_usbhs: fix to avoid using a disabled ep in usbhsg_queue_done()
5529578a locking/atomic, sched: Unexport fetch_or()
5a07975a USB: digi_acceleport: do sanity checking for the number of ports
c26e5f30 Merge tag 'kvm-arm-for-4.6-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
c338d59d MIPS: ath79: Fix the ar724x clock calculation
2b885ea6 dt-bindings: clock: qca,ath79-pll: fix copy-paste typos
8b8c877f Merge tag 'hwmon-for-linus-v4.6-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging
8f9e8f5f ocfs2: Fix Q_GETNEXTQUOTA for filesystem without quotas
c55aee1b USB: cypress_m8: add endpoint sanity check
ecd9a7ad usb: dwc2: do not override forced dr_mode in gadget setup
f009a7a7 timers/nohz: Convert tick dependency mask to atomic_t
17e8a893 quota: Handle Q_GETNEXTQUOTA when quota is disabled
3b143cca MIPS: traps: Correct the SIGTRAP debug ABI in `do_watch' and `do_trap_or_bp'
4e9a0b05 USB: mct_u232: add sanity checking in probe
4fc50ba5 usb: gadget: f_midi: unlock on error
53c43c5c Revert "Staging: olpc_dcon: Remove obsolete driver"
5acba71e locking/atomic: Introduce atomic_fetch_or()
e1641c9d Revert "Revert "pinctrl: lantiq: Implement gpio_chip.to_irq""
1993b176 Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/ide
59b9023c usb: fix regression in SuperSpeed endpoint descriptor parsing
6490865c usb: renesas_usbhs: disable TX IRQ before starting TX DMAC transfer
6d79b6c7 staging/rdma/hfi1: select CRC32
748ac56b FIRMWARE: Broadcom: Fix grammar of warning messages in bcm47xx_sprom.c.
a3125494 x86/mce: Avoid using object after free in genpool
a9b0b1fe pinctrl: qcom: ipq4019: fix register offsets
5a269ca9 Merge tag 'iio-fixes-for-4.6b' of git://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio into staging-linus
732d4ba6 MIPS: ci20: Enable NAND and UBIFS support in defconfig.
894f2fc4 usb: renesas_usbhs: avoid NULL pointer derefernce in usbhsf_pkt_handler()
b348d7dd USB: usbip: fix potential out-of-bounds write
c6e6e58c Merge tag 'staging-4.6-rc3' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging
cdbac734 pinctrl: qcom: ipq4019: fix the function enum for gpio mode
e51f17a0 drm/imx: Don't set a gamma table size
f87e0434 lguest, x86/entry/32: Fix handling of guest syscalls using interrupt gates
03d27ade usb: gadget: f_midi: Fixed a bug when buflen was smaller than wMaxPacketSize
2aac7ddf clk: qcom: ipq4019: add some fixed clocks for ddrppl and fepll
5303f782 pinctrl: qcom: ipq4019: set ngpios to correct value
6bcaf0c5 drm/imx: ipuv3-plane: Configure DMFC wait4eot bit after slots are determined
6d92bc9d x86/build: Build compressed x86 kernels as PIE
8ef34aa5 Merge tag 'fixes-for-v4.6-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb into usb-linus
92a76f6d MIPS: Fix misspellings in comments.
091bc3a4 MIPS: tlb-r4k: panic if the MMU doesn't support PAGE_SIZE
27630c20 gpu: ipu-v3: ipu-dmfc: Rename ipu_dmfc_init_channel to ipu_dmfc_config_wait4eot
591b1d8d x86/mm/pkeys: Add missing Documentation
6ee33455 pinctrl: nomadik: fix pull debug print inversion
6f40fed1 ARM: dts: am335x-baltos-ir5221: fix cpsw_emac0 link type
7e8ac87a usb: phy: qcom-8x16: fix regulator API abuse
bc95d4f0 clk: qcom: ipq4019: switch remaining defines to enums
d4dc3b24 Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc
2bbe32f7 gpu: ipu-v3: ipu-dmfc: Make function ipu_dmfc_init_channel() return void
34a4cceb x86/cpu: Add advanced power management bits
3de7beeb bus: uniphier-system-bus: fix condition of overlap check
405ddbfa [media] Revert "[media] media: au0828 change to use Managed Media Controller API"
44b03c10 MAINTAINERS: pinctrl: samsung: Add two new maintainers
6b472574 ARM: OMAP: Correct interrupt type for ARM TWD
743bc4b0 usb: ch9: Fix SSP Device Cap wFunctionalitySupport type
8961b28f MIPS: zboot: Remove copied source files on clean
add479ee clk: qcom: Make reset_control_ops const
06a71a24 arm64: KVM: unregister notifiers in hyp mode teardown path
08f8cabf usb: gadget: composite: Access SSP Dev Cap fields properly
101ecde5 MAINTAINERS: xen: Konrad to step down and Juergen to pick up
3137b716 ARM: uniphier: drop weird sizeof()
32c26a56 gpu: ipu-v3: ipu-dmfc: Protect function ipu_dmfc_init_channel() with mutex
5f870a3f x86/thread_info: Merge two !__ASSEMBLY__ sections
6b532c4a ARM: DRA722: Add ID detect for Silicon Rev 2.0
7ba256d2 clk: tegra: Make reset_control_ops const
a939bb57 pinctrl: intel: implement gpio_irq_enable
c50ec678 MIPS: zboot: Fix the build with XZ compression on older GCC versions
c89178f5 [media] Revert "[media] sound/usb: Use Media Controller API to share media resources"
caf28080 i2c: jz4780: really prevent potential division by zero
1cc9daea drm/imx: dw_hdmi: Don't call platform_set_drvdata()
309fdeb5 Merge tag 'meson8-dt-fix' of https://github.com/carlocaione/linux-meson into fixes
38e58986 usb: gadget: udc: atmel: don't disable enpdoints we don't own
4a6772f5 x86/cpufreq: Remove duplicated TDP MSR macro definitions
4ececb7d Revert "i2c: jz4780: prevent potential division by zero"
5e7bc9c6 clk: sunxi: Make reset_control_ops const
6141570c arm64: KVM: Warn when PARange is less than 40 bits
62d8e644 MIPS: Wire up preadv2 and pwrite2 syscalls.
bf380cfa pinctrl: intel: make the high level interrupt working
d41676dd ARM: dts: am43xx: fix edma memcpy channel allocation
e8e3039f [media] au0828: Fix dev_state handling
ec3c0737 Merge git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile
ff1e22e7 xen/events: Mask a moving irq
1c5631c7 KVM: arm/arm64: Handle forward time correction gracefully
34cf2acd i2c: jz4780: prevent potential division by zero
788c8ddb drm/imx: dw_hdmi: Call drm_encoder_cleanup() in error path
839559e1 target: add a new add_wwn_groups fabrics method
85d1a29d Xen on ARM and ARM64: update MAINTAINERS info
9a4f4245 pinctrl: freescale: imx: fix bogus check of of_iomap() return value
b1b69c5d clk: atlas7: Make reset_control_ops const
cfe1580a ARM: dts: AM43x-epos: Fix clk parent for synctimer
e901aa15 usb: dwc3: gadget: fix endpoint renaming
e95008a1 MIPS: cpu_name_string: Use raw_smp_processor_id().
ed940cd2 [media] au0828: fix au0828_v4l2_close() dev_state race condition
f7be8610 x86/Documentation: Start documenting x86 topology
208fae5c ARM: 8550/1: protect idiv patching against undefined gcc behavior
39b132b0 i2c: mux: demux-pinctrl: Update docs to new sysfs-attributes
3fb950fe clk: rockchip: Make reset_control_ops const
431597bb arm64: defconfig: updates for 4.6
456e8d53 ARM: OMAP2: Fix up interconnect barrier initialization for DRA7
5e7515ba pinctrl: sunxi: Fix A33 external interrupts not working
6ac217ee drm/imx: ipuv3-plane: fix planar YUV 4:2:0 support
71528d8b powerpc: Correct used_vsr comment
7d4bd1d2 arm64: KVM: Add braces to multi-line if statement in virtual PMU code
8196dab4 x86/cpu: Get rid of compute_unit_id
ad14d4e0 usb: dwc3: gadget: release spin lock during gadget resume
b2dde6fc f2fs: retrieve IO write stat from the right place
ccc7d5a1 sh: fix function signature of cpu_coregroup_mask to match pointer type
dc6416f1 xen/x86: Call cpu_startup_entry(CPUHP_AP_ONLINE_IDLE) from xen_play_dead()
e34b6fcf pcmcia: db1xxx_ss: fix last irq_to_gpio user
e6e202ed target: initialize the nacl base CIT begfore init_nodeacl
ffa8576a [media] media: au0828 fix to clear enable/disable/change source handlers
01d6b2a4 mmc: sdhci-pci: Add support and PCI IDs for more Broxton host controllers
01d7c2a2 powerpc/process: Fix altivec SPR not being saved
0fed3fce [media] v4l2-mc: cleanup a warning
11ca8735 documentation: Fix pinctrl documentation for Meson8 / Meson8b
1809de7e Merge tag 'for-v4.6-rc/omap-fixes-a' of git://git.kernel.org/pub/scm/linux/kernel/git/pjw/omap-pending into omap-for-v4.6/fixes
199831c7 ARM: mvebu: Correct unit address for linksys
32b62f44 perf/x86/amd: Cleanup Fam10h NB event constraints
505ce68c selftest/seccomp: Fix the seccomp(2) signature
5e00bbfb tty: Fix merge of "tty: Refactor tty_open()"
5f5560b1 arm64: KVM: Register CPU notifiers when the kernel runs at HYP
67ca6b60 drm/imx: ipuv3-plane: Add more thorough checks for plane parameter limitations
69c2565a drm: ARM HDLCD - fix an error code
8041dcc8 Merge tag 'v4.6-rc1' into for-linus-4.6
878dfd32 orangefs: minimum userspace version is 2.9.3
8d8ee18c gpio: xgene: Prevent NULL pointer dereference
8fbd4ade Merge branch 'acpi-processor'
b8cfadfc arm64: perf: Move PMU register related defines to asm/perf_event.h
c0c508a4 i2c: mux: demux-pinctrl: Clean up sysfs attributes
c90e09f7 f2fs crypto: fix corrupted symlink in encrypted case
ce7043fd target: remove ->fabric_cleanup_nodeacl
d7586849 MAINTAINERS: Add mailing list for remote processor subsystems
e6cc3be5 arm64: dts: vulcan: Update PCI ranges
e9adb336 pinctrl: pistachio: fix mfio84-89 function description and pinmux.
ef21b32a sh: fix smp-shx3 build regression from removal of arch localtimer
f2335a2a ARM: wire up preadv2 and pwritev2 syscalls
f59dcab1 usb: dwc3: core: improve reset sequence
fa8ff601 MIPS: Fix MSA ld unaligned failure cases
fd92f41d clk: mmp: Make reset_control_ops const
0129801b pinctrl: sh-pfc: only use dummy states for non-DT platforms
08a5bb29 powerpc/mm: Fixup preempt underflow with huge pages
0fc03d4c ARM: SMP enable of cache maintanence broadcast
16b02d71 Merge tag 'v4.6-rc1'
19fb5818 MIPS: Fix broken malta qemu
1dceb041 mmc: sdhci: Fix regression setting power on Trats2 board
2e208c64 [media] au0828: disable tuner links and cache tuner/decoder
3c2e2266 hwmon: (max1111) Return -ENODEV from max1111_read_channel if not instantiated
3ca4a238 ARM: OMAP2+: hwmod: Fix updating of sysconfig register
427b1d3f ARM: u8500_defconfig: turn on the Synaptics RMI4 driver
4b28038f remoteproc: st: fix check of syscon_regmap_lookup_by_phandle() return value
4c35430a ARM: pxa: fix the number of DMA requestor lines
572a1434 iser-target: Use ib_drain_qp
61a6dcd7 drm: ARM HDLCD - get rid of devm_clk_put()
641bb324 orangefs: don't put readdir slot twice
6c045d07 selftest/seccomp: Fix the flag name SECCOMP_FILTER_FLAG_TSYNC
6ea7e387 Merge branch 'fixes-base' into fixes
7500c38a fix the braino in "namei: massage lookup_slow() to be usable by lookup_one_len_unlocked()"
77644ad8 bus: mvebu-mbus: use %pa to print phys_addr_t
82c7d823 dlm: config: Fix ENOMEM failures in make_cluster()
8dcf3217 i2c: prevent endless uevent loop with CONFIG_I2C_DEBUG_CORE
8fe88927 nios2: Replace fdt_translate_address with of_flat_dt_translate_address
90195c36 gpu: ipu-cpmem: modify ipu_cpmem_set_yuv_planar_full for better control
9acdf4df usb: gadget: f_midi: added spinlock on transmit function
a34d5df8 Merge tag 'iio-fixes-for-4.6a' of git://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio into usb-linus
a6002ec5 arm64: opcodes.h: Add arm big-endian config options before including arm header
ad06fdee pwm: fsl-ftm: Use flat regmap cache
b60e1157 ARM: dts: amlogic: Split pinctrl device for Meson8 / Meson8b
cb678d60 arm64: kvm: 4.6-rc1: Fix VTCR_EL2 VS setting
da5a0fc6 tty: Fix UML console breakage
ee6825c8 x86/topology: Fix AMD core count
f39bb457 clk: mediatek: Make reset_control_ops const
fc0c2028 x86, pmem: use memcpy_mcsafe() for memcpy_from_pmem()
fd694733 f2fs: cover large section in sanity check of super
fd975a7b gpio: menz127: Drop lock field from struct men_z127_gpio
f55532a0 Linux 4.6-rc1
d5a38f6e Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client
ffb927d1 Merge tag 'usb-4.6-rc3' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb
183c948a Merge tag 'tty-4.6-rc3' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty
289b7bfd Merge tag 'gpio-v4.6-3' of git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio
239467e8 Merge branch 'libnvdimm-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm
698f415c Merge tag 'ofs-pull-tag-1' of git://git.kernel.org/pub/scm/linux/kernel/git/hubcap/linux
b4cec5f6 Merge tag 'ntb-4.6' of git://github.com/jonmason/ntb
5b5b7fd1 Merge branch 'parisc-4.6-3' of git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux
895a1067 Merge tag 'scsi-misc' of git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi
02fc59a0 f2fs/crypto: fix xts_tweak initialization
9f2394c9 Revert "ext4: allow readdir()'s of large empty directories to be interrupted"
606c61a0 Merge branch 'akpm' (patches from Andrew)
0fda2788 thp: fix typo in khugepaged_scan_pmd()
0ba1d91d MAINTAINERS: fill entries for KASAN
6a7c9243 Merge branch 'i2c/for-current' of git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux
e7080a43 mm/filemap: generic_file_read_iter(): check for zero reads unconditionally
9dcadd38 kasan: test fix: warn if the UAF could not be detected in kmalloc_uaf2
2f422f94 Merge tag 'mmc-v4.6-rc1' of git://git.linaro.org/people/ulf.hansson/mmc
cd11016e mm, kasan: stackdepot implementation. Enable stackdepot for SLAB
be7635e7 arch, ftrace: for KASAN put hard/soft IRQ entries into separate sections
505f5dcb mm, kasan: add GFP flags to KASAN API
7ed2f9e6 mm, kasan: SLAB support
08b15d13 Merge branch 'fixes' of git://ftp.arm.linux.org.uk/~rmk/linux-arm
e6e8379c kasan: modify kmalloc_large_oob_right(), add kmalloc_pagealloc_oob_right()
aaf4fb71 include/linux/oom.h: remove undefined oom_kills_count()/note_oom_kill()
bf162006 Linux 4.6-rc3
072623de dm: fix dm_target_io leak if clone_bio() returns an error
2763ee64 m68k/gpio: remove arch specific sysfs bus device
d7d75352 fscrypto: use dget_parent() in fscrypt_d_revalidate()
d9dddbf5 mm/page_alloc: prevent merging between isolated and other pageblocks
33b13951 f2fs: use dget_parent and file_dentry in f2fs_file_open
9567366f dm cache metadata: fix READ_LOCK macros and cleanup WRITE_LOCK macros
f419a08f drivers/memstick/host/r592.c: avoid gcc-6 warning
102c2595 ocfs2: extend enough credits for freeing one truncate record while replaying truncate records
b32e4482 fscrypto: don't let data integrity writebacks fail with ENOMEM
03a8bb0e ext4/fscrypto: avoid RCU lookup in d_revalidate
17215989 ocfs2: extend transaction for ocfs2_remove_rightmost_path() and ocfs2_update_edge_lengths() before to avoid inconsistency between inode and et
a56711fa Merge tag 'arc-4.6-rc4-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/vgupta/arc
e5054c9a ocfs2/dlm: move lock to the tail of grant queue while doing in-place convert
584dca34 ocfs2: solve a problem of crossing the boundary in updating backups
35ddf78e ocfs2: fix occurring deadlock by changing ocfs2_wq from global to local
6c6563a4 Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k
be12b299 ocfs2/dlm: fix BUG in dlm_move_lockres_to_recovery_list
1c74a7f8 Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid
ac7cf246 ocfs2/dlm: fix race between convert and recovery
28888681 ocfs2: fix a deadlock issue in ocfs2_dio_end_io_write()
ce170828 ocfs2: fix disk file size and memory file size mismatch
58976eef Merge tag 'keys-fixes-20160412' of git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs into for-linus
a86a72a4 ocfs2: take ip_alloc_sem in ocfs2_dio_get_block & ocfs2_dio_end_io_write
e63890f3 ocfs2: fix ip_unaligned_aio deadlock with dio work queue
f1f973ff ocfs2: code clean up for direct io
c15471f7 ocfs2: fix sparse file & data ordering issue in direct io
4506cfb6 ocfs2: record UNWRITTEN extents when populate write desc
2de6a3c7 ocfs2: return the physical address in ocfs2_write_cluster
46e62556 ocfs2: do not change i_size in write_end for direct io
5e1b59ab Merge tag 'for-linus' of git://git.kernel.org/pub/scm/virt/kvm/kvm
65c4db8c ocfs2: test target page before change it
b46637d5 ocfs2: use c_new to indicate newly allocated extents
c1ad1e3c ocfs2: add ocfs2_write_type_t type to identify the caller of write
9e13f1f9 ocfs2: o2hb: fix double free bug
b8b4ead1 drivers/input: eliminate INPUT_COMPAT_TEST macro
bb29902a oom, oom_reaper: protect oom_reaper_list using simpler way
e2679606 oom: make oom_reaper freezable
29c696e1 oom: make oom_reaper_list single linked
855b0183 oom, oom_reaper: disable oom_reaper for oom_kill_allocating_task
03049269 mm, oom_reaper: implement OOM victims queuing
15dbc136 Merge tag 'pm+acpi-4.6-rc1-3' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm
bc448e89 mm, oom_reaper: report success/failure
36324a99 oom: clear TIF_MEMDIE after oom_reaper managed to unmap the address space
dad44dec Merge tag 'please-pull-preadv2' of git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux
aac45363 mm, oom: introduce oom reaper
2d5ae5c2 [IA64] Enable preadv2 and pwritev2 syscalls for ia64
69b27baf sched: add schedule_timeout_idle()
c155c749 Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input
1701f680 Revert "ppdev: use new parport device model"
b475c59b iio: gyro: bmg160: fix buffer read values
3b3b3bd9 Merge tag 'firewire-update2' of git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394
95e7ff03 iio: gyro: bmg160: fix endianness when reading axes
2215f31d iio: accel: bmc150: fix endianness when reading axes
f98c2135 Merge branch 'drm-next' of git://people.freedesktop.org/~airlied/linux
11caf57f Merge tag 'asm-generic-4.6' of git://git.kernel.org/pub/scm/linux/kernel/git/arnd/asm-generic
9b090a98 iio: st_magn: always define ST_MAGN_TRIGGER_SET_STATE
1bef2c1d iio: fix config watermark initial value
3d66c6ba Merge tag 'pm+acpi-4.6-rc1-2' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm
8407ef46 Merge tag 'rtc-4.6-2' of git://git.kernel.org/pub/scm/linux/kernel/git/abelloni/linux
b74fccad iio: health: max30100: correct FIFO check condition
b4ae78ed Merge tag 'hwmon-for-linus-v4.6-2' of git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging
f7072198 iio: imu: Fix inv_mpu6050 dependencies
8a665d2f iio: adc: Fix build error of missing devm_ioremap_resource on UM
1d02369d Merge branch 'for-linus' of git://git.kernel.dk/linux-block
8f40842e Merge tag 'for-linus-20160324' of git://git.infradead.org/linux-mtd
e0127662 Merge tag 'armsoc-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc
88875667 Merge tag 'upstream-4.6-rc1' of git://git.infradead.org/linux-ubifs
5b523ff2 Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu
8b306a2e Merge tag 'nfsd-4.6-1' of git://linux-nfs.org/~bfields/linux
90de6800 Merge tag 'sh-fixes-4.6-rc1' of git://git.libc.org/linux-sh
4046d6e8 Revert "x86: remove the kernel code/data/bss resources from /proc/iomem"
34dbbcdb Make file credentials available to the seqfile interfaces
ab0fa82b pci-sysfs: use proper file capability helper function
51d7b120 /proc/iomem: only expose physical resource addresses to privileged users
4c0b1c67 Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security
5ee61e95 libceph: use KMEM_CACHE macro
70c5eb84 Merge branch 'misc' of git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild
99ec2697 ceph: use kmem_cache_zalloc
03d94406 rbd: use KMEM_CACHE macro
3a1ef0e0 Merge branch 'kconfig' of git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild
16382ed9 Merge branch 'linus' of git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6
200fd27c ceph: use lookup request to revalidate dentry
2162b80f Merge branch 'kbuild' of git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild
641235d8 ceph: kill ceph_get_dentry_parent_inode()
976fb3f7 Merge branch 'parisc-4.6-1' of git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux
315f2408 ceph: fix security xattr deadlock
29dccfa5 ceph: don't request vxattrs from MDS
132ca7e1 ceph: fix mounting same fs multiple times
45311267 ceph: remove unnecessary NULL check
dfe70581 Merge tag 'for-linus-4.6-rc4' of git://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs
a3d714c3 ceph: avoid updating directory inode's i_size accidentally
9d854607 Merge tag 'arm64-upstream' of git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux
af5e5eb5 ceph: fix race during filling readdir cache
89f08173 libceph: use sizeof_footer() more
34b759b4 ceph: kill ceph_empty_snapc
a7109a2c Merge branch 'mailbox-devel' of git://git.linaro.org/landing-teams/working/fujitsu/integration
ce435593 ceph: fix a wrong comparison
8bbd4714 ceph: replace CURRENT_TIME by current_fs_time()
5b64640c ceph: scattered page writeback
2c63f49a libceph: add helper that duplicates last extent operation
3f1af42a libceph: enable large, variable-sized OSD requests
8a20a04b Merge tag 'armsoc-dt2' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc
9e767adb libceph: osdc->req_mempool should be backed by a slab pool
ae458f5a libceph: make r_request msg_size calculation clearer
6fe35ab7 Merge tag 'at91-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/nferre/linux-at91 into next/dt2
7665d85b libceph: move r_reply_op_{len,result} into struct ceph_osd_req_op
c325a67c ext4: ignore quota mount options if the quota feature is enabled
4762cc3f ext4 crypto: fix some error handling
de2aa102 libceph: rename ceph_osd_req_op::payload_len to indata_len
3ce093d4 intel_idle: Add KBL support
8f0e8746 ext4: avoid calling dquot_get_next_id() if quota is not enabled
a587d71b ceph: remove useless BUG_ON
c8c52850 Merge tag 'sound-4.6-rc4' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound
133e9156 ceph: don't enable rbytes mount option by default
413b321b ARM: dts: uniphier: add pinmux node for I2C ch4
e84dfbe2 ext4: retry block allocation for failed DIO and DAX writes
f9e71657 intel_idle: Add SKX support
090f41f4 ARM: dts: uniphier: add @{address} to EEPROM node
0a3f5af1 Merge tag 'pwm/for-4.6-rc4' of git://git.kernel.org/pub/scm/linux/kernel/git/thierry.reding/linux-pwm
3e66a9ab intel_idle: Clean up all registered devices on exit.
d1eee0c0 ceph: encode ctime in cap message
daf647d2 ext4: add lockdep annotations for i_data_sem
08820546 intel_idle: Propagate hot plug errors.
1028b55b ext4: allow readdir()'s of large empty directories to be interrupted
4f8b8c60 ARM: dts: uniphier: add PH1-Pro4 Sanji board support
b5d91704 libceph: behave in mon_fault() if cur_mon < 0
ac503e4a nfsd: use short read as well as i_size to set eof
b69ef2c0 intel_idle: Don't overreact to a cpuidle registration failure.
bee3a37c libceph: reschedule tick in mon_fault()
d2522f97 ARM: dts: uniphier: add PH1-Pro4 Ace board support
de17e793 btrfs: fix crash/invalid memory access on fsync when using overlayfs
1752b50c libceph: introduce and switch to reopen_session()
2259a819 intel_idle: Setup the timer broadcast only on successful driver load.
3d43bcfe ext4 crypto: use dget_parent() in ext4_d_revalidate()
47557239 ARM: dts: uniphier: enable I2C channel 2 of ProXstream2 Gentil board
4b15da44 nfsd: better layoutupdate bounds-checking
63a1281b Merge tag 'dm-4.6-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm
691b1e2e arm64: mm: allow preemption in copy_to_user_page
10c4de10 nfsd: block and scsi layout drivers need to depend on CONFIG_BLOCK
168b9090 libceph: monc hunt rate is 3s with backoff up to 30s
3bdf9e42 ARM: dts: uniphier: add EEPROM node for ProXstream2 Gentil board
c0a37d48 ext4: use file_dentry()
c661cb1c arm64: consistently use p?d_set_huge
ca42489d intel_idle: Avoid a double free of the per-CPU data.
119a0a3c parisc: Wire up preadv2 and pwritev2 syscalls
58d81b12 libceph: monc ping rate is 10s
61f838c7 ARM: dts: uniphier: add reference clock nodes
9dd78d8c ext4: use dget_parent() in ext4_file_open()
a1f98317 Merge branch 'mm-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
b3185564 cpufreq: dt: Drop stale comment
d5e57437 arm64: kaslr: use callee saved register to preserve SCTLR across C call
e9df69cc intel_idle: Fix dangling registration on error path.
f99d4fbd nfsd: add SCSI layout support
0de79858 parisc: Use generic extable search and sort routines
0e04dc26 libceph: pick a different monitor when reconnecting
13ad7701 cpufreq: intel_pstate: Documenation for structures
14bae133 ARM: dts: uniphier: rework UniPhier System Bus nodes
35b90a29 tile: Fix misspellings in comments.
368248ee nfsd: move some blocklayout code
51319918 intel_idle: Fix deallocation order on the driver exit path.
be62a1a8 nfs: use file_dentry()
c27cb972 ubifs: Remove unused header
f09f1bac arm64: Split pr_notice("Virtual kernel memory layout...") into multiple pr_cont()
30a39153 cpufreq: intel_pstate: fix inconsistency in setting policy limits
4a3dfb3f intel_idle: Remove redundant initialization calls.
5c5154e4 ARM: dts: uniphier: factor out ranges property of support card
81c39329 nfsd: add a new config option for the block layout driver
82dcabad libceph: revamp subs code, switch to SUBSCRIBE2 protocol
8c34d8d9 MAINTAINERS: update web link for tile architecture
a7859936 MAINTAINERS: Update UBIFS entry
c95a23da parisc: Panic immediately when panic_on_oops
cc7c0cda arm64: drop unused __local_flush_icache_all()
d101a125 fs: add file_dentry()
0d7ef45c ide: palm_bk3710: test clock rate to avoid division by 0
0f9af169 libceph: decouple hunting and subs management
5469c827 intel_idle: Fix a helper function's return value.
58d303de mtd: ubi: Add logging functions ubi_msg, ubi_warn and ubi_err
65e43389 arm64: dts: uniphier: rename PH1-LD10 to PH1-LD20
6c31da34 parisc,metag: Implement CONFIG_DEBUG_STACK_USAGE option
9ef595d8 sparc: Convert naked unsigned uses to unsigned int
b02acd4e ARM: dts: at91: sama5d4 Xplained: don't disable hsmci regulator
b90b4a60 arm64: fix KASLR boot-time I-cache maintenance
b9a279f6 MAINTAINERS: update arch/tile maintainer email domain
c9af28fd ext4 crypto: don't let data integrity writebacks fail with ENOMEM
d9186c03 nfs/blocklayout: add SCSI layout support
febce40f intel_pstate: Avoid extra invocation of intel_pstate_sample()
02ac956c libceph: move debugfs initialization into __ceph_open_session()
08f80073 sparc: Fix misspellings in comments.
3e7f2c51 ubifs: Add logging functions for ubifs_msg, ubifs_err and ubifs_warn
40cf446b nfs4.h: add SCSI layout definitions
56649be9 parisc: Drop alloc_hugepages and free_hugepages syscalls
732b84ee Merge tag 'for-4.6' of git://git.osdn.jp/gitroot/uclinux-h8/linux
77ef8f51 tile kgdb: fix bug in copy to gdb regs, and optimize memset
968ce1b1 MAINTAINERS: Update mailing list and web page for hwmon subsystem
9e92f48c ext4: check if in-inode xattr is corrupted in ext4_expand_extra_isize_ea()
a2121167 ACPI / processor: Request native thermal interrupt handling via _OSC
aae31813 Merge tag 'imx-dt-4.6' of git://git.kernel.org/pub/scm/linux/kernel/git/shawnguo/linux into next/dt2
ae3fc8ea ARM: dts: at91: sama5d3 Xplained: don't disable hsmci regulator
b660950c arm64/kernel: fix incorrect EL0 check in inv_entry macro
bb6ab52f intel_pstate: Do not set utilization update hook too early
eccf432f ide: icside: remove incorrect initconst annotation
ed6069be xen/apic: Provide Xen-specific version of cpu_present_to_apicid APIC op
f7041549 intel_idle: remove useless return from void function.
806fdcce Merge branch 'x86-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14740853200000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+6a29097222b4d3b8617c@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: stack-out-of-bounds in memset include/linux/string.h:366 [inline]
BUG: KASAN: stack-out-of-bounds in ax25_getname+0x58/0x7a0 net/ax25/af_ax25.c:1405
Write of size 72 at addr ffffc90005bc7e00 by task syz-executor507/10059

CPU: 1 PID: 10059 Comm: syz-executor507 Not tainted 5.6.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x197/0x210 lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0x5/0x30b mm/kasan/report.c:374
 __kasan_report.cold+0x1b/0x32 mm/kasan/report.c:506
 kasan_report+0x12/0x20 mm/kasan/common.c:641
 check_memory_region_inline mm/kasan/generic.c:185 [inline]
 check_memory_region+0x134/0x1a0 mm/kasan/generic.c:192
 memset+0x24/0x40 mm/kasan/common.c:108
 memset include/linux/string.h:366 [inline]
 ax25_getname+0x58/0x7a0 net/ax25/af_ax25.c:1405
 get_raw_socket drivers/vhost/net.c:1433 [inline]
 get_socket drivers/vhost/net.c:1489 [inline]
 vhost_net_set_backend drivers/vhost/net.c:1524 [inline]
 vhost_net_ioctl+0x1213/0x1960 drivers/vhost/net.c:1715
 vfs_ioctl fs/ioctl.c:47 [inline]
 ksys_ioctl+0x123/0x180 fs/ioctl.c:763
 __do_sys_ioctl fs/ioctl.c:772 [inline]
 __se_sys_ioctl fs/ioctl.c:770 [inline]
 __x64_sys_ioctl+0x73/0xb0 fs/ioctl.c:770
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x440259
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffe1fa95c28 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440259
RDX: 0000000020f1dff8 RSI: 000000004008af30 RDI: 0000000000000003
RBP: 00000000006ca018 R08: 00000000004002c8 R09: 00000000004002c8
R10: 00000000004002c8 R11: 0000000000000246 R12: 0000000000401ae0
R13: 0000000000401b70 R14: 0000000000000000 R15: 0000000000000000


addr ffffc90005bc7e00 is located in stack of task syz-executor507/10059 at offset 128 in frame:
 vhost_net_ioctl+0x0/0x1960 drivers/vhost/net.c:386

this frame has 4 objects:
 [48, 52) 'r'
 [64, 72) 'features'
 [96, 104) 'backend'
 [128, 180) 'uaddr'

Memory state around the buggy address:
 ffffc90005bc7d00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffffc90005bc7d80: f1 f1 f1 f1 f1 f1 04 f2 00 f2 f2 f2 00 f2 f2 f2
>ffffc90005bc7e00: 00 00 00 00 00 00 04 f3 f3 f3 f3 f3 00 00 00 00
                                     ^
 ffffc90005bc7e80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffffc90005bc7f00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
==================================================================

