Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5A5E59B6A1
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 00:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231782AbiHUW3Q convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 21 Aug 2022 18:29:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiHUW3P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Aug 2022 18:29:15 -0400
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7337213DE1
        for <netdev@vger.kernel.org>; Sun, 21 Aug 2022 15:29:13 -0700 (PDT)
Received: by mail-il1-f199.google.com with SMTP id d4-20020a056e02214400b002df95f624a4so7194076ilv.1
        for <netdev@vger.kernel.org>; Sun, 21 Aug 2022 15:29:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:from:subject:message-id:in-reply-to
         :date:mime-version:x-gm-message-state:from:to:cc;
        bh=nrmTigU9/l779kvm60OnMXf38LyDJVGnrRxSw2bcZg4=;
        b=Law7Fop+Is2sF6yzTL5V/+7knboPqgMIli6vLH18etZ5nl9bqoye8dQ8LS4F/CEfT4
         jhae2ngv3y2k1ytJrHPrmKzr/3C92RovX+/r3H/PQESZDcBqJJGzFtYR9/qHrnCLkuLy
         MyPnDZQvSjY2QIN4ZkDqTEG71YWHm2W9PErSAaFeVNDWQpcop0CRqCFSFSWIC3/A1ovY
         O4vyhxsN3Z8zIv7hbMYvovdiJdNyDH6Jy/kAuPy/v3pn+JLX6ovyyyA90nAxGb6zEp0N
         E0hUUUIMeuCNPJF7ZHXSTi3grBCbag+79cXtKo3n04rSnKVpsaXcORftblR/x9Kt73/+
         hcWw==
X-Gm-Message-State: ACgBeo1A8ylFO5Cd4IQkyxKpPCV2F4jrxKT4R+513cvtPZMFKQkHJMSZ
        MHC5HMX6Tq3MoU2YmcZD8mJ0chpWur6ynPckQ69PDJsF8pp3
X-Google-Smtp-Source: AA6agR78+YtCkedUDx4oAAZ9EAtyJ5r+BUUzsEg7gUnJGEB8gVbZ1Y+16FOoGdkAAp/xOvR5Ftbb1a8lUbUOG9uQXZ3W0Mr1zzLb
MIME-Version: 1.0
X-Received: by 2002:a02:3849:0:b0:349:c77c:a072 with SMTP id
 v9-20020a023849000000b00349c77ca072mr2815227jae.192.1661120952778; Sun, 21
 Aug 2022 15:29:12 -0700 (PDT)
Date:   Sun, 21 Aug 2022 15:29:12 -0700
In-Reply-To: <20220821191751.222357-1-khalid.masum.92@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000051c75b05e6c7dc73@google.com>
Subject: Re: [syzbot] WARNING: bad unlock balance in rxrpc_do_sendmsg
From:   syzbot <syzbot+7f0483225d0c94cb3441@syzkaller.appspotmail.com>
To:     18801353760@163.com, davem@davemloft.net, dhowells@redhat.com,
        edumazet@google.com, khalid.masum.92@gmail.com, kuba@kernel.org,
        linux-afs@lists.infradead.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, marc.dionne@auristor.com,
        netdev@vger.kernel.org, pabeni@redhat.com, paskripkin@gmail.com,
        skhan@linuxfoundation.org, syzkaller-bugs@googlegroups.com,
        yin31149@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot tried to test the proposed patch but the build/boot failed:

: BNEP filters: protocol multicast
[   11.858163][    T1] Bluetooth: BNEP socket layer initialized
[   11.864007][    T1] Bluetooth: CMTP (CAPI Emulation) ver 1.0
[   11.870006][    T1] Bluetooth: CMTP socket layer initialized
[   11.876108][    T1] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[   11.883027][    T1] Bluetooth: HIDP socket layer initialized
[   11.892802][    T1] NET: Registered PF_RXRPC protocol family
[   11.898816][    T1] Key type rxrpc registered
[   11.903368][    T1] Key type rxrpc_s registered
[   11.909035][    T1] NET: Registered PF_KCM protocol family
[   11.915665][    T1] lec:lane_module_init: lec.c: initialized
[   11.921574][    T1] mpoa:atm_mpoa_init: mpc.c: initialized
[   11.928018][    T1] l2tp_core: L2TP core driver, V2.0
[   11.933453][    T1] l2tp_ppp: PPPoL2TP kernel driver, V2.0
[   11.939099][    T1] l2tp_ip: L2TP IP encapsulation support (L2TPv3)
[   11.945982][    T1] l2tp_netlink: L2TP netlink interface
[   11.951559][    T1] l2tp_eth: L2TP ethernet pseudowire support (L2TPv3)
[   11.958477][    T1] l2tp_ip6: L2TP IP encapsulation support for IPv6 (L2TPv3)
[   11.966178][    T1] NET: Registered PF_PHONET protocol family
[   11.972631][    T1] 8021q: 802.1Q VLAN Support v1.8
[   11.987664][    T1] DCCP: Activated CCID 2 (TCP-like)
[   11.993261][    T1] DCCP: Activated CCID 3 (TCP-Friendly Rate Control)
[   12.000884][    T1] sctp: Hash tables configured (bind 32/56)
[   12.009112][    T1] NET: Registered PF_RDS protocol family
[   12.015798][    T1] Registered RDS/infiniband transport
[   12.022034][    T1] Registered RDS/tcp transport
[   12.027101][    T1] tipc: Activated (version 2.0.0)
[   12.032836][    T1] NET: Registered PF_TIPC protocol family
[   12.039346][    T1] tipc: Started in single node mode
[   12.045614][    T1] NET: Registered PF_SMC protocol family
[   12.052053][    T1] 9pnet: Installing 9P2000 support
[   12.058118][    T1] NET: Registered PF_CAIF protocol family
[   12.069167][    T1] NET: Registered PF_IEEE802154 protocol family
[   12.075802][    T1] Key type dns_resolver registered
[   12.080965][    T1] Key type ceph registered
[   12.085898][    T1] libceph: loaded (mon/osd proto 15/24)
[   12.092926][    T1] batman_adv: B.A.T.M.A.N. advanced 2022.2 (compatibility version 15) loaded
[   12.101941][    T1] openvswitch: Open vSwitch switching datapath
[   12.111525][    T1] NET: Registered PF_VSOCK protocol family
[   12.117955][    T1] mpls_gso: MPLS GSO support
[   12.134629][    T1] IPI shorthand broadcast: enabled
[   12.139859][    T1] AVX2 version of gcm_enc/dec engaged.
[   12.145876][    T1] AES CTR mode by8 optimization enabled
[   12.155779][    T1] sched_clock: Marking stable (12138076585, 17368961)->(12161137287, -5691741)
[   12.167112][    T1] registered taskstats version 1
[   12.234177][    T1] Loading compiled-in X.509 certificates
[   12.245779][    T1] Loaded X.509 cert 'Build time autogenerated kernel key: 16fa2afaa7210bc2438dbf8447100de29a0bc70d'
[   12.259289][    T1] zswap: loaded using pool lzo/zbud
[   12.266413][    T1] debug_vm_pgtable: [debug_vm_pgtable         ]: Validating architecture page table helpers
[   13.815072][    T1] Key type ._fscrypt registered
[   13.820356][    T1] Key type .fscrypt registered
[   13.825167][    T1] Key type fscrypt-provisioning registered
[   13.837059][    T1] kAFS: Red Hat AFS client v0.1 registering.
[   13.852391][    T1] Btrfs loaded, crc32c=crc32c-intel, assert=on, zoned=yes, fsverity=yes
[   13.861737][    T1] Key type big_key registered
[   13.870272][    T1] Key type encrypted registered
[   13.875671][    T1] ima: No TPM chip found, activating TPM-bypass!
[   13.882332][    T1] Loading compiled-in module X.509 certificates
[   13.891979][    T1] Loaded X.509 cert 'Build time autogenerated kernel key: 16fa2afaa7210bc2438dbf8447100de29a0bc70d'
[   13.904089][    T1] ima: Allocated hash algorithm: sha256
[   13.909975][    T1] ima: No architecture policies found
[   13.916111][    T1] evm: Initialising EVM extended attributes:
[   13.922235][    T1] evm: security.selinux
[   13.926735][    T1] evm: security.SMACK64 (disabled)
[   13.931859][    T1] evm: security.SMACK64EXEC (disabled)
[   13.937528][    T1] evm: security.SMACK64TRANSMUTE (disabled)
[   13.943548][    T1] evm: security.SMACK64MMAP (disabled)
[   13.949022][    T1] evm: security.apparmor (disabled)
[   13.954231][    T1] evm: security.ima
[   13.958042][    T1] evm: security.capability
[   13.962504][    T1] evm: HMAC attrs: 0x1
[   14.046064][    T1] PM:   Magic number: 2:748:401
[   14.051323][    T1] usb usb38-port7: hash matches
[   14.058853][    T1] printk: console [netcon0] enabled
[   14.064737][    T1] netconsole: network logging started
[   14.070553][    T1] gtp: GTP module loaded (pdp ctx size 104 bytes)
[   14.080150][    T1] rdma_rxe: loaded
[   14.084458][    T1] cfg80211: Loading compiled-in X.509 certificates for regulatory database
[   14.096699][    T1] cfg80211: Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
[   14.105001][    T1] ALSA device list:
[   14.106011][   T14] platform regulatory.0: Direct firmware load for regulatory.db failed with error -2
[   14.108906][    T1]   #0: Dummy 1
[   14.108920][    T1]   #1: Loopback 1
[   14.118716][   T14] platform regulatory.0: Falling back to sysfs fallback for: regulatory.db
[   14.124736][    T1]   #2: Virtual MIDI Card 1
[   14.142829][    T1] md: Waiting for all devices to be available before autodetect
[   14.150560][    T1] md: If you don't use raid, use raid=noautodetect
[   14.157094][    T1] md: Autodetecting RAID arrays.
[   14.162108][    T1] md: autorun ...
[   14.165854][    T1] md: ... autorun DONE.
[   14.276553][    T1] EXT4-fs (sda1): mounted filesystem with ordered data mode. Quota mode: none.
[   14.285966][    T1] VFS: Mounted root (ext4 filesystem) readonly on device 8:1.
[   14.323634][    T1] devtmpfs: mounted
[   14.339508][    T1] Freeing unused kernel image (initmem) memory: 2744K
[   14.352992][    T1] Write protecting the kernel read-only data: 176128k
[   14.364738][    T1] Freeing unused kernel image (text/rodata gap) memory: 2016K
[   14.372956][    T1] Freeing unused kernel image (rodata/data gap) memory: 392K
[   14.386193][    T1] Failed to set sysctl parameter 'max_rcu_stall_to_panic=1': parameter not found
[   14.396254][    T1] Run /sbin/init as init process
[   14.748233][    T1] SELinux:  Class mctp_socket not defined in policy.
[   14.755142][    T1] SELinux:  Class anon_inode not defined in policy.
[   14.761846][    T1] SELinux:  Class io_uring not defined in policy.
[   14.768317][    T1] SELinux: the above unknown classes and permissions will be denied
[   14.827412][    T1] SELinux:  policy capability network_peer_controls=1
[   14.834281][    T1] SELinux:  policy capability open_perms=1
[   14.840096][    T1] SELinux:  policy capability extended_socket_class=1
[   14.847142][    T1] SELinux:  policy capability always_check_network=0
[   14.853909][    T1] SELinux:  policy capability cgroup_seclabel=1
[   14.860245][    T1] SELinux:  policy capability nnp_nosuid_transition=1
[   14.867038][    T1] SELinux:  policy capability genfs_seclabel_symlinks=0
[   14.874017][    T1] SELinux:  policy capability ioctl_skip_cloexec=0
[   15.372859][   T27] audit: type=1403 audit(1661120546.300:2): auid=4294967295 ses=4294967295 lsm=selinux res=1
[   15.419548][ T2939] mount (2939) used greatest stack depth: 25104 bytes left
[   15.445064][ T2940] EXT4-fs (sda1): re-mounted. Quota mode: none.
mount: mounting smackfs on /sys/fs/smackfs failed: No such file or directory
mount: mounting mqueue on /dev/mqueue failed: No such file or directory
mount: mounting hugetlbfs on /dev/hugepages failed: No such file or directory
mount: mounting fuse.lxcfs on /var/lib/lxcfs fai[   15.591258][ T2942] mount (2942) used greatest stack depth: 24232 bytes left
led: No such file or directory
Starting syslogd: [   15.765727][   T27] audit: type=1400 audit(1661120546.690:3): avc:  denied  { read write } for  pid=2954 comm="syslogd" path="/dev/null" dev="devtmpfs" ino=5 scontext=system_u:system_r:syslogd_t tcontext=system_u:object_r:device_t tclass=chr_file permissive=1
OK
[   15.814376][   T27] audit: type=1400 audit(1661120546.740:4): avc:  denied  { read } for  pid=2954 comm="syslogd" name="log" dev="sda1" ino=1125 scontext=system_u:system_r:syslogd_t tcontext=system_u:object_r:var_t tclass=lnk_file permissive=1
Starting acpid: [   15.839700][   T27] audit: type=1400 audit(1661120546.760:5): avc:  denied  { search } for  pid=2954 comm="syslogd" name="/" dev="tmpfs" ino=1 scontext=system_u:system_r:syslogd_t tcontext=system_u:object_r:tmpfs_t tclass=dir permissive=1
[   15.861223][   T27] audit: type=1400 audit(1661120546.760:6): avc:  denied  { write } for  pid=2954 comm="syslogd" name="/" dev="tmpfs" ino=1 scontext=system_u:system_r:syslogd_t tcontext=system_u:object_r:tmpfs_t tclass=dir permissive=1
[   15.882689][   T27] audit: type=1400 audit(1661120546.760:7): avc:  denied  { add_name } for  pid=2954 comm="syslogd" name="messages" scontext=system_u:system_r:syslogd_t tcontext=system_u:object_r:tmpfs_t tclass=dir permissive=1
OK
[   15.923298][   T27] audit: type=1400 audit(1661120546.760:8): avc:  denied  { create } for  pid=2954 comm="syslogd" name="messages" scontext=system_u:system_r:syslogd_t tcontext=system_u:object_r:tmpfs_t tclass=file permissive=1
[   15.944279][   T27] audit: type=1400 audit(1661120546.760:9): avc:  denied  { append open } for  pid=2954 comm="syslogd" path="/tmp/messages" dev="tmpfs" ino=2 scontext=system_u:system_r:syslogd_t tcontext=system_u:object_r:tmpfs_t tclass=file permissive=1
Starting klogd: [   15.967402][   T27] audit: type=1400 audit(1661120546.760:10): avc:  denied  { getattr } for  pid=2954 comm="syslogd" path="/tmp/messages" dev="tmpfs" ino=2 scontext=system_u:system_r:syslogd_t tcontext=system_u:object_r:tmpfs_t tclass=file permissive=1
[   15.992369][   T27] audit: type=1400 audit(1661120546.800:11): avc:  denied  { use } for  pid=2956 comm="acpid" path="/dev/console" dev="rootfs" ino=1076 scontext=system_u:system_r:acpid_t tcontext=system_u:system_r:kernel_t tclass=fd permissive=1
OK
Running sysctl: OK
[   16.225258][ T2967] logger (2967) used greatest stack depth: 22976 bytes left
Populating /dev using udev: [   16.435978][ T2971] udevd[2971]: starting version 3.2.10
[   16.686715][ T2972] udevd[2972]: starting eudev-3.2.10
done
Starting system message bus: [   28.569901][   T27] kauditd_printk_skb: 14 callbacks suppressed
[   28.569911][   T27] audit: type=1400 audit(1661120559.490:26): avc:  denied  { use } for  pid=3171 comm="dbus-daemon" path="/dev/console" dev="rootfs" ino=1076 scontext=system_u:system_r:system_dbusd_t tcontext=system_u:system_r:kernel_t tclass=fd permissive=1
[   28.599571][   T27] audit: type=1400 audit(1661120559.490:27): avc:  denied  { read write } for  pid=3171 comm="dbus-daemon" path="/dev/console" dev="rootfs" ino=1076 scontext=system_u:system_r:system_dbusd_t tcontext=system_u:object_r:root_t tclass=chr_file permissive=1
[   28.642390][   T27] audit: type=1400 audit(1661120559.560:28): avc:  denied  { search } for  pid=3171 comm="dbus-daemon" name="/" dev="tmpfs" ino=1 scontext=system_u:system_r:system_dbusd_t tcontext=system_u:object_r:tmpfs_t tclass=dir permissive=1
[   28.665649][   T27] audit: type=1400 audit(1661120559.580:29): avc:  denied  { write } for  pid=3171 comm="dbus-daemon" name="dbus" dev="tmpfs" ino=1393 scontext=system_u:system_r:system_dbusd_t tcontext=system_u:object_r:tmpfs_t tclass=dir permissive=1
done
[   28.689039][   T27] audit: type=1400 audit(1661120559.580:30): avc:  denied  { add_name } for  pid=3171 comm="dbus-daemon" name="system_bus_socket" scontext=system_u:system_r:system_dbusd_t tcontext=system_u:object_r:tmpfs_t tclass=dir permissive=1
[   28.711654][   T27] audit: type=1400 audit(1661120559.580:31): avc:  denied  { create } for  pid=3171 comm="dbus-daemon" name="system_bus_socket" scontext=system_u:system_r:system_dbusd_t tcontext=system_u:object_r:tmpfs_t tclass=sock_file permissive=1
[   28.734633][   T27] audit: type=1400 audit(1661120559.580:32): avc:  denied  { setattr } for  pid=3171 comm="dbus-daemon" name="system_bus_socket" dev="tmpfs" ino=1394 scontext=system_u:system_r:system_dbusd_t tcontext=system_u:object_r:tmpfs_t tclass=sock_file permissive=1
[   28.759424][   T27] audit: type=1400 audit(1661120559.590:33): avc:  denied  { create } for  pid=3171 comm="dbus-daemon" name="messagebus.pid" scontext=system_u:system_r:system_dbusd_t tcontext=system_u:object_r:tmpfs_t tclass=file permissive=1
[   28.782144][   T27] audit: type=1400 audit(1661120559.590:34): avc:  denied  { write open } for  pid=3171 comm="dbus-daemon" path="/run/messagebus.pid" dev="tmpfs" ino=1395 scontext=system_u:system_r:system_dbusd_t tcontext=system_u:object_r:tmpfs_t tclass=file permissive=1
[   28.807197][   T27] audit: type=1400 audit(1661120559.590:35): avc:  denied  { getattr } for  pid=3171 comm="dbus-daemon" path="/run/messagebus.pid" dev="tmpfs" ino=1395 scontext=system_u:system_r:system_dbusd_t tcontext=system_u:object_r:tmpfs_t tclass=file permissive=1
Starting network: OK
Starting dhcpcd...
dhcpcd-9.4.0 starting
dev: loaded udev
DUID 00:04:18:1b:51:b6:f4:39:97:fb:3c:5d:6f:3f:70:18:1a:62
forked to background, child pid 3185
[   30.625552][ T3186] 8021q: adding VLAN 0 to HW filter on device bond0
[   30.638978][ T3186] eql: remember to turn off Van-Jacobson compression on your slave devices
Starting sshd: OK


syzkaller

syzkaller login: [   76.294776][   T14] cfg80211: failed to load regulatory.db


syzkaller build log:
go env (err=<nil>)
GO111MODULE="auto"
GOARCH="amd64"
GOBIN=""
GOCACHE="/syzkaller/.cache/go-build"
GOENV="/syzkaller/.config/go/env"
GOEXE=""
GOEXPERIMENT=""
GOFLAGS=""
GOHOSTARCH="amd64"
GOHOSTOS="linux"
GOINSECURE=""
GOMODCACHE="/syzkaller/jobs/linux/gopath/pkg/mod"
GONOPROXY=""
GONOSUMDB=""
GOOS="linux"
GOPATH="/syzkaller/jobs/linux/gopath"
GOPRIVATE=""
GOPROXY="https://proxy.golang.org,direct"
GOROOT="/usr/local/go"
GOSUMDB="sum.golang.org"
GOTMPDIR=""
GOTOOLDIR="/usr/local/go/pkg/tool/linux_amd64"
GOVCS=""
GOVERSION="go1.17"
GCCGO="gccgo"
AR="ar"
CC="gcc"
CXX="g++"
CGO_ENABLED="1"
GOMOD="/syzkaller/jobs/linux/gopath/src/github.com/google/syzkaller/go.mod"
CGO_CFLAGS="-g -O2"
CGO_CPPFLAGS=""
CGO_CXXFLAGS="-g -O2"
CGO_FFLAGS="-g -O2"
CGO_LDFLAGS="-g -O2"
PKG_CONFIG="pkg-config"
GOGCCFLAGS="-fPIC -m64 -pthread -fmessage-length=0 -fdebug-prefix-map=/tmp/go-build994994397=/tmp/go-build -gno-record-gcc-switches"

git status (err=<nil>)
HEAD detached at 1434eec0b
nothing to commit, working tree clean


go list -f '{{.Stale}}' ./sys/syz-sysgen | grep -q false || go install ./sys/syz-sysgen
make .descriptions
bin/syz-sysgen
touch .descriptions
GOOS=linux GOARCH=amd64 go build "-ldflags=-s -w -X github.com/google/syzkaller/prog.GitRevision=1434eec0b84075b7246560cfa89f20cdb3d8077f -X 'github.com/google/syzkaller/prog.gitRevisionDate=20220629-111539'" "-tags=syz_target syz_os_linux syz_arch_amd64 " -o ./bin/linux_amd64/syz-fuzzer github.com/google/syzkaller/syz-fuzzer
GOOS=linux GOARCH=amd64 go build "-ldflags=-s -w -X github.com/google/syzkaller/prog.GitRevision=1434eec0b84075b7246560cfa89f20cdb3d8077f -X 'github.com/google/syzkaller/prog.gitRevisionDate=20220629-111539'" "-tags=syz_target syz_os_linux syz_arch_amd64 " -o ./bin/linux_amd64/syz-execprog github.com/google/syzkaller/tools/syz-execprog
GOOS=linux GOARCH=amd64 go build "-ldflags=-s -w -X github.com/google/syzkaller/prog.GitRevision=1434eec0b84075b7246560cfa89f20cdb3d8077f -X 'github.com/google/syzkaller/prog.gitRevisionDate=20220629-111539'" "-tags=syz_target syz_os_linux syz_arch_amd64 " -o ./bin/linux_amd64/syz-stress github.com/google/syzkaller/tools/syz-stress
mkdir -p ./bin/linux_amd64
gcc -o ./bin/linux_amd64/syz-executor executor/executor.cc \
	-m64 -O2 -pthread -Wall -Werror -Wparentheses -Wunused-const-variable -Wframe-larger-than=16384 -Wno-stringop-overflow -Wno-array-bounds -Wno-format-overflow -static-pie -fpermissive -w -DGOOS_linux=1 -DGOARCH_amd64=1 \
	-DHOSTGOOS_linux=1 -DGIT_REVISION=\"1434eec0b84075b7246560cfa89f20cdb3d8077f\"


Error text is too large and was truncated, full error text is at:
https://syzkaller.appspot.com/x/error.txt?x=14b8bffd080000


Tested on:

commit:         568035b0 Linux 6.0-rc1
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
kernel config:  https://syzkaller.appspot.com/x/.config?x=930fc801ca92783a
dashboard link: https://syzkaller.appspot.com/bug?extid=7f0483225d0c94cb3441
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=17e2730d080000

