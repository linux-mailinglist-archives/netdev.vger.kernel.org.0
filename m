Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91954F4C0A
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 13:46:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbfKHMp7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 07:45:59 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:43546 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726281AbfKHMp6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 07:45:58 -0500
Received: by mail-qk1-f194.google.com with SMTP id z23so5071107qkj.10
        for <netdev@vger.kernel.org>; Fri, 08 Nov 2019 04:45:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6KmRD4WIoTcLTetzw0jgx7nTMM1Utjqe0wu6KMN35+g=;
        b=STuepb8cQwW7tX/gWfpOjfcWeqKScu8OQ3RmLj/ornQy8T0G2pOAnQlnSzNKmvA7Vt
         mcaKZQlkb9ug+FqayH8OR4YAckXKtprhiQYQ9tOVuWMVD25QEKn4KPeBAqJt3L3klhra
         VieY4NWAdzsj7iDXXxq++XAhqme6SUFqHe/lCmRjmzr4K/IzcYeP+reU8FBkd/51h7EC
         Onf2wQyinppVQb4UZ6itvA1Ugq3wb1RX8LSjTSoYx8yFecuU7tQGo+OZFCgY0g1iWDZY
         /CgJIincW+sBuvADXWzpZZ3rtTlbVsU1R8+CHZDkZcVDZq9RONZAxxEbJPOztQ4pJkyz
         00DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6KmRD4WIoTcLTetzw0jgx7nTMM1Utjqe0wu6KMN35+g=;
        b=bfTD3mmlOYFDHBWlSbnYzie8wJDFT6KGDC1BA6ZD6zhCzbD2axlKwva4HEuVda+whe
         S+K8BXYauljGMGAqtUSDiyeo2Y51/OenFL++xH+r+8qiNpJJirdgqS0xKDH1wosphYgn
         kNPjgTdW2S0UrEy4SL2/4bM9Ojkcob2ojskXbsIoP3qZS1uvJWY8DVKvvV/x7R2bek6E
         AEmywZKPg+FO4Dqsl7QUvI7yEy4s14xROTN8qgKlbASRo/v1z/cfiAX29xNTFMFm34Si
         Uvyj6FQ3PU8okJn0ZaTIMxSa1IexdE/SvalVGy6b03CXbqp0Xlky7D/htQKgXjEWkujl
         VT9g==
X-Gm-Message-State: APjAAAVbltupjCWGS5xSMz3PuMOM0xHko+hSFO3pRObU+5k7vnw+mUL5
        0WdWZJQe/OV2ze2vCWVPSIjeUszvS2eZJOaGa934tw==
X-Google-Smtp-Source: APXvYqwgkLQcxtVyYk/tgF9kpii0eF3HiRjdfwMM2Dkqmzmlhrj3TjdnjAm/4IE37wQR8V6xA9rYaK/jAox/T6nMLCY=
X-Received: by 2002:a37:a94b:: with SMTP id s72mr8551271qke.256.1573217156913;
 Fri, 08 Nov 2019 04:45:56 -0800 (PST)
MIME-Version: 1.0
References: <0000000000007246fb058eabb9fb@google.com>
In-Reply-To: <0000000000007246fb058eabb9fb@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Fri, 8 Nov 2019 13:45:45 +0100
Message-ID: <CACT4Y+bpAd+b-N9Zf4T7aOFON=nK2ADBXw234yzLEJwfy9TzGA@mail.gmail.com>
Subject: Re: bpf boot error: WARNING: workqueue cpumask: online intersect >
 possible intersect (2)
To:     syzbot <syzbot+40f581848b1c5452b5ed@syzkaller.appspotmail.com>,
        Tejun Heo <tj@kernel.org>,
        Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 27, 2019 at 5:58 PM syzbot
<syzbot+40f581848b1c5452b5ed@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    5d01ab7b libbpf: fix erroneous multi-closing of BTF FD
> git tree:       bpf
> console output: https://syzkaller.appspot.com/x/log.txt?x=110318b4600000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=6efd5962fd8c1d39
> dashboard link: https://syzkaller.appspot.com/bug?extid=40f581848b1c5452b5ed
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>
> Unfortunately, I don't have any reproducer for this crash yet.
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+40f581848b1c5452b5ed@syzkaller.appspotmail.com

+workqueue maintainers

syzkaller will now ignore this warning as it happens on every boot and
masks all other boot problems:
https://github.com/google/syzkaller/commit/31b7aac4626757ae0862971db78aaa1338541227

#syz invalid

> smpboot: CPU0: Intel(R) Xeon(R) CPU @ 2.30GHz (family: 0x6, model: 0x3f,
> stepping: 0x0)
> Performance Events: unsupported p6 CPU model 63 no PMU driver, software
> events only.
> rcu: Hierarchical SRCU implementation.
> NMI watchdog: Perf NMI watchdog permanently disabled
> smp: Bringing up secondary CPUs ...
> x86: Booting SMP configuration:
> .... node  #0, CPUs:      #1
> MDS CPU bug present and SMT on, data leak possible. See
> https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/mds.html for
> more details.
> smp: Brought up 2 nodes, 2 CPUs
> smpboot: Max logical packages: 1
> smpboot: Total of 2 processors activated (9200.00 BogoMIPS)
> devtmpfs: initialized
> clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns:
> 19112604462750000 ns
> futex hash table entries: 512 (order: 4, 65536 bytes, vmalloc)
> xor: automatically using best checksumming function   avx
> PM: RTC time: 01:04:45, date: 2019-07-27
> NET: Registered protocol family 16
> audit: initializing netlink subsys (disabled)
> cpuidle: using governor menu
> ACPI: bus type PCI registered
> dca service started, version 1.12.1
> PCI: Using configuration type 1 for base access
> WARNING: workqueue cpumask: online intersect > possible intersect
> HugeTLB registered 1.00 GiB page size, pre-allocated 0 pages
> HugeTLB registered 2.00 MiB page size, pre-allocated 0 pages
> cryptd: max_cpu_qlen set to 1000
> raid6: avx2x4   gen() 11248 MB/s
> raid6: avx2x4   xor()  6695 MB/s
> raid6: avx2x2   gen()  6687 MB/s
> raid6: avx2x2   xor()  3654 MB/s
> raid6: avx2x1   gen()  3443 MB/s
> raid6: avx2x1   xor()  2027 MB/s
> raid6: sse2x4   gen()  5758 MB/s
> raid6: sse2x4   xor()  3294 MB/s
> raid6: sse2x2   gen()  3924 MB/s
> raid6: sse2x2   xor()  1858 MB/s
> raid6: sse2x1   gen()  1745 MB/s
> raid6: sse2x1   xor()  1019 MB/s
> raid6: using algorithm avx2x4 gen() 11248 MB/s
> raid6: .... xor() 6695 MB/s, rmw enabled
> raid6: using avx2x2 recovery algorithm
> ACPI: Added _OSI(Module Device)
> ACPI: Added _OSI(Processor Device)
> ACPI: Added _OSI(3.0 _SCP Extensions)
> ACPI: Added _OSI(Processor Aggregator Device)
> ACPI: Added _OSI(Linux-Dell-Video)
> ACPI: Added _OSI(Linux-Lenovo-NV-HDMI-Audio)
> ACPI: Added _OSI(Linux-HPI-Hybrid-Graphics)
> ACPI: 2 ACPI AML tables successfully acquired and loaded
> ACPI: Interpreter enabled
> ACPI: (supports S0 S3 S4 S5)
> ACPI: Using IOAPIC for interrupt routing
> PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and
> report a bug
> ACPI: Enabled 16 GPEs in block 00 to 0F
> ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
> acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments MSI HPX-Type3]
> acpi PNP0A03:00: fail to add MMCONFIG information, can't access extended
> PCI configuration space under this bridge.
> PCI host bridge to bus 0000:00
> pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window]
> pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
> pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]
> pci_bus 0000:00: root bus resource [mem 0xc0000000-0xfebfffff window]
> pci_bus 0000:00: root bus resource [bus 00-ff]
> pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
> pci 0000:00:01.0: [8086:7110] type 00 class 0x060100
> pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
> pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
> pci 0000:00:03.0: [1af4:1004] type 00 class 0x000000
> pci 0000:00:03.0: reg 0x10: [io  0xc000-0xc03f]
> pci 0000:00:03.0: reg 0x14: [mem 0xfebfe000-0xfebfe07f]
> pci 0000:00:04.0: [1af4:1000] type 00 class 0x020000
> pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
> pci 0000:00:04.0: reg 0x14: [mem 0xfebff000-0xfebff07f]
> ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
> ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
> ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
> ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
> ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
> vgaarb: loaded
> SCSI subsystem initialized
> ACPI: bus type USB registered
> usbcore: registered new interface driver usbfs
> usbcore: registered new interface driver hub
> usbcore: registered new device driver usb
> mc: Linux media interface: v0.10
> videodev: Linux video capture interface: v2.00
> pps_core: LinuxPPS API ver. 1 registered
> pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti
> <giometti@linux.it>
> PTP clock support registered
> EDAC MC: Ver: 3.0.0
> Advanced Linux Sound Architecture Driver Initialized.
> PCI: Using ACPI for IRQ routing
> Bluetooth: Core ver 2.22
> NET: Registered protocol family 31
> Bluetooth: HCI device and connection manager initialized
> Bluetooth: HCI socket layer initialized
> Bluetooth: L2CAP socket layer initialized
> Bluetooth: SCO socket layer initialized
> NET: Registered protocol family 8
> NET: Registered protocol family 20
> NetLabel: Initializing
> NetLabel:  domain hash size = 128
> NetLabel:  protocols = UNLABELED CIPSOv4 CALIPSO
> NetLabel:  unlabeled traffic allowed by default
> nfc: nfc_init: NFC Core ver 0.1
> NET: Registered protocol family 39
> clocksource: Switched to clocksource kvm-clock
> VFS: Disk quotas dquot_6.6.0
> VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> FS-Cache: Loaded
> *** VALIDATE hugetlbfs ***
> CacheFiles: Loaded
> TOMOYO: 2.6.0
> Mandatory Access Control activated.
> AppArmor: AppArmor Filesystem Enabled
> pnp: PnP ACPI init
> pnp: PnP ACPI: found 7 devices
> thermal_sys: Registered thermal governor 'step_wise'
> thermal_sys: Registered thermal governor 'user_space'
> clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns:
> 2085701024 ns
> pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
> pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
> pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff window]
> pci_bus 0000:00: resource 7 [mem 0xc0000000-0xfebfffff window]
> NET: Registered protocol family 2
> tcp_listen_portaddr_hash hash table entries: 4096 (order: 6, 294912 bytes,
> vmalloc)
> TCP established hash table entries: 65536 (order: 7, 524288 bytes, vmalloc)
> TCP bind hash table entries: 65536 (order: 10, 4194304 bytes, vmalloc)
> TCP: Hash tables configured (established 65536 bind 65536)
> UDP hash table entries: 4096 (order: 7, 655360 bytes, vmalloc)
> UDP-Lite hash table entries: 4096 (order: 7, 655360 bytes, vmalloc)
> NET: Registered protocol family 1
> RPC: Registered named UNIX socket transport module.
> RPC: Registered udp transport module.
> RPC: Registered tcp transport module.
> RPC: Registered tcp NFSv4.1 backchannel transport module.
> NET: Registered protocol family 44
> pci 0000:00:00.0: Limiting direct PCI/PCI transfers
> PCI: CLS 0 bytes, default 64
> PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
> software IO TLB: mapped [mem 0xaa800000-0xae800000] (64MB)
> RAPL PMU: API unit is 2^-32 Joules, 0 fixed counters, 10737418240 ms ovfl
> timer
> kvm: already loaded the other module
> clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x212735223b2,
> max_idle_ns: 440795277976 ns
> clocksource: Switched to clocksource tsc
> mce: Machine check injector initialized
> check: Scanning for low memory corruption every 60 seconds
> Initialise system trusted keyrings
> workingset: timestamp_bits=40 max_order=21 bucket_order=0
> zbud: loaded
> DLM installed
> squashfs: version 4.0 (2009/01/31) Phillip Lougher
> FS-Cache: Netfs 'nfs' registered for caching
> NFS: Registering the id_resolver key type
> Key type id_resolver registered
> Key type id_legacy registered
> nfs4filelayout_init: NFSv4 File Layout Driver Registering...
> Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
> ntfs: driver 2.1.32 [Flags: R/W].
> fuse: init (API version 7.31)
> JFS: nTxBlock = 8192, nTxLock = 65536
> SGI XFS with ACLs, security attributes, realtime, no debug enabled
> 9p: Installing v9fs 9p2000 file system support
> FS-Cache: Netfs '9p' registered for caching
> gfs2: GFS2 installed
> FS-Cache: Netfs 'ceph' registered for caching
> ceph: loaded (mds proto 32)
> NET: Registered protocol family 38
> async_tx: api initialized (async)
> Key type asymmetric registered
> Asymmetric key parser 'x509' registered
> Asymmetric key parser 'pkcs8' registered
> Key type pkcs7_test registered
> Asymmetric key parser 'tpm_parser' registered
> Block layer SCSI generic (bsg) driver version 0.4 loaded (major 246)
> io scheduler mq-deadline registered
> io scheduler kyber registered
> io scheduler bfq registered
> input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
> ACPI: Power Button [PWRF]
> input: Sleep Button as /devices/LNXSYSTM:00/LNXSLPBN:00/input/input1
> ACPI: Sleep Button [SLPF]
> ioatdma: Intel(R) QuickData Technology Driver 5.00
> PCI Interrupt Link [LNKC] enabled at IRQ 11
> virtio-pci 0000:00:03.0: virtio_pci: leaving for legacy driver
> PCI Interrupt Link [LNKD] enabled at IRQ 10
> virtio-pci 0000:00:04.0: virtio_pci: leaving for legacy driver
> HDLC line discipline maxframe=4096
> N_HDLC line discipline registered.
> Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> 00:03: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
> 00:04: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a 16550A
> 00:05: ttyS2 at I/O 0x3e8 (irq = 6, base_baud = 115200) is a 16550A
> 00:06: ttyS3 at I/O 0x2e8 (irq = 7, base_baud = 115200) is a 16550A
> Non-volatile memory driver v1.3
> Linux agpgart interface v0.103
> [drm] Initialized vgem 1.0.0 20120112 for vgem on minor 0
> [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
> [drm] Driver supports precise vblank timestamp query.
> [drm] Initialized vkms 1.0.0 20180514 for vkms on minor 1
> usbcore: registered new interface driver udl
> brd: module loaded
> loop: module loaded
> zram: Added device: zram0
> null: module loaded
> nfcsim 0.2 initialized
> Loading iSCSI transport class v2.0-870.
> scsi host0: Virtio SCSI HBA
> st: Version 20160209, fixed bufsize 32768, s/g segs 256
> kobject: 'sd' (0000000040ee4d1b): kobject_add_internal: parent: 'drivers',
> set: 'drivers'
> kobject: 'sd' (0000000040ee4d1b): kobject_uevent_env
> kobject: 'sd' (0000000040ee4d1b): fill_kobj_path: path
> = '/bus/scsi/drivers/sd'
> kobject: 'sr' (00000000e7d12427): kobject_add_internal: parent: 'drivers',
> set: 'drivers'
> kobject: 'sr' (00000000e7d12427): kobject_uevent_env
> kobject: 'sr' (00000000e7d12427): fill_kobj_path: path
> = '/bus/scsi/drivers/sr'
> kobject: 'scsi_generic' (000000000443366b): kobject_add_internal:
> parent: 'class', set: 'class'
> kobject: 'scsi_generic' (000000000443366b): kobject_uevent_env
> kobject: 'scsi_generic' (000000000443366b): fill_kobj_path: path
> = '/class/scsi_generic'
> kobject: 'nvme-wq' (0000000010fea8b9): kobject_add_internal:
> parent: 'workqueue', set: 'devices'
> kobject: 'nvme-wq' (0000000010fea8b9): kobject_uevent_env
> kobject: 'nvme-wq' (0000000010fea8b9): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'nvme-wq' (0000000010fea8b9): kobject_uevent_env
> kobject: 'nvme-wq' (0000000010fea8b9): fill_kobj_path: path
> = '/devices/virtual/workqueue/nvme-wq'
> kobject: 'nvme-reset-wq' (00000000a7f5b0c8): kobject_add_internal:
> parent: 'workqueue', set: 'devices'
> kobject: 'nvme-reset-wq' (00000000a7f5b0c8): kobject_uevent_env
> kobject: 'nvme-reset-wq' (00000000a7f5b0c8): kobject_uevent_env:
> uevent_suppress caused the event to drop!
> kobject: 'nvme-reset-wq' (00000000a7f5b0c8): kobject_uevent_env
> kobject: 'nvme-reset-wq' (00000000a7f5b0c8): fill_kobj_path: path
> = '/devices/virtual/workqueue/nvme-reset-wq'
> kobject: 'nvme-delete-wq' (00000000dc28d66f): kobject_add_internal:
> parent: 'workqueue', set: 'devices'
> kobject: 'nvme-delete-wq' (00000000dc28d66f): kobject_uevent_env
> kobject: 'nvme-delete-wq' (00000000dc28d66f): kobject_uevent_env:
> uevent_suppress caused the event to drop!
> kobject: 'nvme-delete-wq' (00000000dc28d66f): kobject_uevent_env
> kobject: 'nvme-delete-wq' (00000000dc28d66f): fill_kobj_path: path
> = '/devices/virtual/workqueue/nvme-delete-wq'
> kobject: 'nvme' (00000000d7d8a11c): kobject_add_internal: parent: 'class',
> set: 'class'
> kobject: 'nvme' (00000000d7d8a11c): kobject_uevent_env
> kobject: 'nvme' (00000000d7d8a11c): fill_kobj_path: path = '/class/nvme'
> kobject: 'nvme-subsystem' (00000000f9b59088): kobject_add_internal:
> parent: 'class', set: 'class'
> kobject: 'nvme-subsystem' (00000000f9b59088): kobject_uevent_env
> kobject: 'nvme-subsystem' (00000000f9b59088): fill_kobj_path: path
> = '/class/nvme-subsystem'
> kobject: 'nvme' (000000005b8830cb): kobject_add_internal:
> parent: 'drivers', set: 'drivers'
> kobject: 'drivers' (00000000f79b6140): kobject_add_internal:
> parent: 'nvme', set: '<NULL>'
> kobject: 'nvme' (000000005b8830cb): kobject_uevent_env
> kobject: 'nvme' (000000005b8830cb): fill_kobj_path: path
> = '/bus/pci/drivers/nvme'
> kobject: 'ahci' (000000005bbce619): kobject_add_internal:
> parent: 'drivers', set: 'drivers'
> kobject: 'drivers' (000000000440468e): kobject_add_internal:
> parent: 'ahci', set: '<NULL>'
> kobject: 'ahci' (000000005bbce619): kobject_uevent_env
> kobject: 'ahci' (000000005bbce619): fill_kobj_path: path
> = '/bus/pci/drivers/ahci'
> kobject: 'ata_piix' (00000000b703d945): kobject_add_internal:
> parent: 'drivers', set: 'drivers'
> kobject: 'drivers' (000000008d5db480): kobject_add_internal:
> parent: 'ata_piix', set: '<NULL>'
> kobject: 'ata_piix' (00000000b703d945): kobject_uevent_env
>
>
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/0000000000007246fb058eabb9fb%40google.com.
