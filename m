Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF4AAE556
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 10:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406799AbfIJIUP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 10 Sep 2019 04:20:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41230 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404918AbfIJIUL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Sep 2019 04:20:11 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B05A1309BF15;
        Tue, 10 Sep 2019 08:20:10 +0000 (UTC)
Received: from dhcp-12-139.nay.redhat.com (dhcp-12-139.nay.redhat.com [10.66.12.139])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id ECC2C5C22C;
        Tue, 10 Sep 2019 08:19:59 +0000 (UTC)
Date:   Tue, 10 Sep 2019 16:19:56 +0800
From:   Hangbin Liu <haliu@redhat.com>
To:     CKI Project <cki-project@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>,
        netdev@vger.kernel.org, Jan Stancek <jstancek@redhat.com>,
        Xiumei Mu <xmu@redhat.com>,
        David Howells <dhowells@redhat.com>,
        linux-afs@lists.infradead.org
Subject: Re: =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Stable queue: queue-5.2
Message-ID: <20190910081956.GG22496@dhcp-12-139.nay.redhat.com>
References: <cki.77A5953448.UY7ROQ6BKT@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <cki.77A5953448.UY7ROQ6BKT@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Tue, 10 Sep 2019 08:20:10 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 28, 2019 at 08:36:14AM -0400, CKI Project wrote:
> 
> Hello,
> 
> We ran automated tests on a patchset that was proposed for merging into this
> kernel tree. The patches were applied to:
> 
>        Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
>             Commit: f7d5b3dc4792 - Linux 5.2.10
> 
> The results of these automated tests are provided below.
> 
>     Overall result: FAILED (see details below)
>              Merge: OK
>            Compile: OK
>              Tests: FAILED
> 
> All kernel binaries, config files, and logs are available for download here:
> 
>   https://artifacts.cki-project.org/pipelines/128519
> 
> 
> 
> One or more kernel tests failed:
> 
>   x86_64:
>     ❌ Networking socket: fuzz

Sorry, maybe the info is a little late, I just found the call traces for this
failure.


[ 9492.446228] BUG: kernel NULL pointer dereference, address: 0000000000000010 
[ 9492.447493] #PF: supervisor write access in kernel mode 
[ 9492.448489] #PF: error_code(0x0002) - not-present page 
[ 9492.449410] PGD 800000010902c067 P4D 800000010902c067 PUD 104202067 PMD 0  
[ 9492.450663] Oops: 0002 [#1] SMP PTI 
[ 9492.451348] CPU: 0 PID: 19353 Comm: socket Tainted: G        W         5.2.10-f7d5b3d.cki #1 
[ 9492.453040] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011 
[ 9492.454153] RIP: 0010:rxrpc_unuse_local+0xa/0x20 [rxrpc] 
[ 9492.455110] Code: ce e9 c4 fe ff ff 0f 0b e9 34 dd 00 00 e9 95 dd 00 00 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 0f 1f 44 00 00 b8 ff ff ff ff <3e> 0f c1 47 10 83 f8 01 74 05 e9 a7 f5 ff ff e9 e2 f7 ff ff 66 90 
[ 9492.458362] RSP: 0018:ffffa756008bbeb0 EFLAGS: 00010246 
[ 9492.459329] RAX: 00000000ffffffff RBX: ffff95fed42c0000 RCX: ffffc755ffc63b37 
[ 9492.460690] RDX: 0000000000000001 RSI: 0000000000000046 RDI: 0000000000000000 
[ 9492.461940] RBP: ffff95ff04fed000 R08: 0000000000000001 R09: ffffc755ffc63b60 
[ 9492.463220] R10: 0000000000000060 R11: 0000000000000000 R12: ffff95ff04fed0e4 
[ 9492.464508] R13: ffff95feaa84c780 R14: 0000000000000000 R15: 0000000000000000 
[ 9492.465781] FS:  00007f86bd101740(0000) GS:ffff95ffbba00000(0000) knlGS:0000000000000000 
[ 9492.467156] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 
[ 9492.468185] CR2: 0000000000000010 CR3: 000000002e34a004 CR4: 00000000007606f0 
[ 9492.469435] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000 
[ 9492.470754] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400 
[ 9492.472050] PKRU: 55555554 
[ 9492.472562] Call Trace: 
[ 9492.473025]  rxrpc_release+0x138/0x1e0 [rxrpc] 
[ 9492.473885]  __sock_release+0x89/0xa0 
[ 9492.474564]  __sys_socket+0xd4/0xf0 
[ 9492.475200]  __x64_sys_socket+0x16/0x20 
[ 9492.475903]  do_syscall_64+0x5f/0x1a0 
[ 9492.476551]  entry_SYSCALL_64_after_hwframe+0x44/0xa9 
[ 9492.477446] RIP: 0033:0x7f86bd20069b 
[ 9492.478094] Code: 73 01 c3 48 8b 0d ed 37 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 29 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d bd 37 0c 00 f7 d8 64 89 01 48 
[ 9492.481381] RSP: 002b:00007ffcbb797dc8 EFLAGS: 00000217 ORIG_RAX: 0000000000000029 
[ 9492.482744] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f86bd20069b 
[ 9492.483945] RDX: 000000000000000a RSI: 0000000000000002 RDI: 0000000000000021 
[ 9492.485220] RBP: 00007ffcbb797e10 R08: 00007f86bd2c41f4 R09: 00007f86bd2c4260 
[ 9492.486505] R10: 00000000ffffffff R11: 0000000000000217 R12: 00000000004012b0 
[ 9492.487769] R13: 00007ffcbb797ef0 R14: 0000000000000000 R15: 0000000000000000 
[ 9492.489048] Modules linked in: nfnetlink cmtp kernelcapi l2tp_ip6 l2tp_ip rfcomm pptp gre l2tp_ppp l2tp_netlink l2tp_core ip6_udp_tunnel udp_tunnel bnep can_bcm hidp can_raw kcm pppoe pppox ppp_generic slhc vmw_vsock_vmci_transport vsock vmw_vmci psnap ieee802154_socket ieee802154 rose bluetooth ecdh_generic ecc mpls_router ip_tunnel netrom ax25 smc ib_core af_key fcrypt pcbc rxrpc nfc rfkill atm can mlx4_en mlx4_core nls_utf8 isofs dummy minix binfmt_misc nfsv3 nfs_acl nfs lockd grace fscache sctp rds brd vfat fat btrfs xor zstd_compress raid6_pq zstd_decompress loop tun ip6table_nat ip6_tables xt_conntrack iptable_filter xt_MASQUERADE xt_comment iptable_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 veth bridge stp llc overlay fuse nfit libnvdimm sunrpc crct10dif_pclmul crc32_pclmul ghash_clmulni_intel virtio_net pcspkr net_failover joydev failover virtio_balloon i2c_piix4 ip_tables xfs libcrc32c qxl drm_kms_helper ttm drm crc32c_intel virtio_blk serio_raw ata_generic pata_acpi 
[ 9492.489083]  floppy qemu_fw_cfg [last unloaded: can] 
[ 9492.505349] CR2: 0000000000000010 
[ 9492.505948] ---[ end trace afa9902ac3c49830 ]--- 

Thanks
Hangbin
> 
> We hope that these logs can help you find the problem quickly. For the full
> detail on our testing procedures, please scroll to the bottom of this message.
> 
> Please reply to this email if you have any questions about the tests that we
> ran or if you have any suggestions on how to make future tests more effective.
> 
>         ,-.   ,-.
>        ( C ) ( K )  Continuous
>         `-',-.`-'   Kernel
>           ( I )     Integration
>            `-'
> ______________________________________________________________________________
> 
> Merge testing
> -------------
> 
> We cloned this repository and checked out the following commit:
> 
>   Repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
>   Commit: f7d5b3dc4792 - Linux 5.2.10
> 
> 
> We grabbed the 54831dad38d2 commit of the stable queue repository.
> 
> We then merged the patchset with `git am`:
> 
>   asoc-simple_card_utils.h-care-null-dai-at-asoc_simpl.patch
>   asoc-simple-card-fix-an-use-after-free-in-simple_dai.patch
>   asoc-simple-card-fix-an-use-after-free-in-simple_for.patch
>   asoc-audio-graph-card-fix-use-after-free-in-graph_da.patch
>   asoc-audio-graph-card-fix-an-use-after-free-in-graph.patch
>   asoc-audio-graph-card-add-missing-const-at-graph_get.patch
>   regulator-axp20x-fix-dcdca-and-dcdcd-for-axp806.patch
>   regulator-axp20x-fix-dcdc5-and-dcdc6-for-axp803.patch
>   asoc-samsung-odroid-fix-an-use-after-free-issue-for-.patch
>   asoc-samsung-odroid-fix-a-double-free-issue-for-cpu_.patch
>   asoc-intel-bytcht_es8316-add-quirk-for-irbis-nb41-ne.patch
>   hid-logitech-hidpp-add-usb-pid-for-a-few-more-suppor.patch
>   hid-add-044f-b320-thrustmaster-inc.-2-in-1-dt.patch
>   mips-kernel-only-use-i8253-clocksource-with-periodic.patch
>   mips-fix-cacheinfo.patch
>   libbpf-sanitize-var-to-conservative-1-byte-int.patch
>   netfilter-ebtables-fix-a-memory-leak-bug-in-compat.patch
>   asoc-dapm-fix-handling-of-custom_stop_condition-on-d.patch
>   asoc-sof-use-__u32-instead-of-uint32_t-in-uapi-heade.patch
>   spi-pxa2xx-balance-runtime-pm-enable-disable-on-erro.patch
>   bpf-sockmap-sock_map_delete-needs-to-use-xchg.patch
>   bpf-sockmap-synchronize_rcu-before-free-ing-map.patch
>   bpf-sockmap-only-create-entry-if-ulp-is-not-already-.patch
>   selftests-bpf-fix-sendmsg6_prog-on-s390.patch
>   asoc-dapm-fix-a-memory-leak-bug.patch
>   bonding-force-slave-speed-check-after-link-state-rec.patch
>   net-mvpp2-don-t-check-for-3-consecutive-idle-frames-.patch
>   selftests-forwarding-gre_multipath-enable-ipv4-forwa.patch
>   selftests-forwarding-gre_multipath-fix-flower-filter.patch
>   selftests-bpf-add-another-gso_segs-access.patch
>   libbpf-fix-using-uninitialized-ioctl-results.patch
>   can-dev-call-netif_carrier_off-in-register_candev.patch
>   can-mcp251x-add-error-check-when-wq-alloc-failed.patch
>   can-gw-fix-error-path-of-cgw_module_init.patch
>   asoc-fail-card-instantiation-if-dai-format-setup-fai.patch
>   staging-fbtft-fix-gpio-handling.patch
>   libbpf-silence-gcc8-warning-about-string-truncation.patch
>   st21nfca_connectivity_event_received-null-check-the-.patch
>   st_nci_hci_connectivity_event_received-null-check-th.patch
>   nl-mac-80211-fix-interface-combinations-on-crypto-co.patch
>   asoc-ti-davinci-mcasp-fix-clk-pdir-handling-for-i2s-.patch
>   asoc-rockchip-fix-mono-capture.patch
>   asoc-ti-davinci-mcasp-correct-slot_width-posed-const.patch
>   net-usb-qmi_wwan-add-the-broadmobi-bm818-card.patch
>   qed-rdma-fix-the-hw_ver-returned-in-device-attribute.patch
>   isdn-misdn-hfcsusb-fix-possible-null-pointer-derefer.patch
>   habanalabs-fix-f-w-download-in-be-architecture.patch
>   mac80211_hwsim-fix-possible-null-pointer-dereference.patch
>   net-stmmac-manage-errors-returned-by-of_get_mac_addr.patch
>   netfilter-ipset-actually-allow-destination-mac-addre.patch
>   netfilter-ipset-copy-the-right-mac-address-in-bitmap.patch
>   netfilter-ipset-fix-rename-concurrency-with-listing.patch
>   rxrpc-fix-potential-deadlock.patch
>   rxrpc-fix-the-lack-of-notification-when-sendmsg-fail.patch
>   nvmem-use-the-same-permissions-for-eeprom-as-for-nvm.patch
>   iwlwifi-mvm-avoid-races-in-rate-init-and-rate-perfor.patch
>   iwlwifi-dbg_ini-move-iwl_dbg_tlv_load_bin-out-of-deb.patch
>   iwlwifi-dbg_ini-move-iwl_dbg_tlv_free-outside-of-deb.patch
>   iwlwifi-fix-locking-in-delayed-gtk-setting.patch
>   iwlwifi-mvm-send-lq-command-always-async.patch
>   enetc-fix-build-error-without-phylib.patch
>   isdn-hfcsusb-fix-misdn-driver-crash-caused-by-transf.patch
>   net-phy-phy_led_triggers-fix-a-possible-null-pointer.patch
>   perf-bench-numa-fix-cpu0-binding.patch
>   spi-pxa2xx-add-support-for-intel-tiger-lake.patch
>   can-sja1000-force-the-string-buffer-null-terminated.patch
>   can-peak_usb-force-the-string-buffer-null-terminated.patch
>   asoc-amd-acp3x-use-dma_ops-of-parent-device-for-acp3.patch
>   net-ethernet-qlogic-qed-force-the-string-buffer-null.patch
>   enetc-select-phylib-while-config_fsl_enetc_vf-is-set.patch
>   nfsv4-fix-a-credential-refcount-leak-in-nfs41_check_.patch
>   nfsv4-when-recovering-state-fails-with-eagain-retry-.patch
>   nfsv4.1-fix-open-stateid-recovery.patch
>   nfsv4.1-only-reap-expired-delegations.patch
>   nfsv4-fix-a-potential-sleep-while-atomic-in-nfs4_do_.patch
>   nfs-fix-regression-whereby-fscache-errors-are-appear.patch
>   hid-quirks-set-the-increment_usage_on_duplicate-quir.patch
>   hid-input-fix-a4tech-horizontal-wheel-custom-usage.patch
>   drm-rockchip-suspend-dp-late.patch
>   smb3-fix-potential-memory-leak-when-processing-compo.patch
>   smb3-kernel-oops-mounting-a-encryptdata-share-with-c.patch
>   sched-deadline-fix-double-accounting-of-rq-running-b.patch
>   sched-psi-reduce-psimon-fifo-priority.patch
>   sched-psi-do-not-require-setsched-permission-from-th.patch
>   s390-protvirt-avoid-memory-sharing-for-diag-308-set-.patch
>   s390-mm-fix-dump_pagetables-top-level-page-table-wal.patch
>   s390-put-_stext-and-_etext-into-.text-section.patch
>   ata-rb532_cf-fix-unused-variable-warning-in-rb532_pa.patch
>   net-cxgb3_main-fix-a-resource-leak-in-a-error-path-i.patch
>   net-stmmac-fix-issues-when-number-of-queues-4.patch
>   net-stmmac-tc-do-not-return-a-fragment-entry.patch
>   drm-amdgpu-pin-the-csb-buffer-on-hw-init-for-gfx-v8.patch
>   net-hisilicon-make-hip04_tx_reclaim-non-reentrant.patch
>   net-hisilicon-fix-hip04-xmit-never-return-tx_busy.patch
>   net-hisilicon-fix-dma_map_single-failed-on-arm64.patch
>   nfsv4-ensure-state-recovery-handles-etimedout-correc.patch
>   libata-have-ata_scsi_rw_xlat-fail-invalid-passthroug.patch
>   libata-add-sg-safety-checks-in-sff-pio-transfers.patch
>   x86-lib-cpu-address-missing-prototypes-warning.patch
>   drm-vmwgfx-fix-memory-leak-when-too-many-retries-hav.patch
>   block-aoe-fix-kernel-crash-due-to-atomic-sleep-when-.patch
>   block-bfq-handle-null-return-value-by-bfq_init_rq.patch
>   perf-ftrace-fix-failure-to-set-cpumask-when-only-one.patch
>   perf-cpumap-fix-writing-to-illegal-memory-in-handlin.patch
>   perf-pmu-events-fix-missing-cpu_clk_unhalted.core-ev.patch
>   dt-bindings-riscv-fix-the-schema-compatible-string-f.patch
>   kvm-arm64-don-t-write-junk-to-sysregs-on-reset.patch
>   kvm-arm-don-t-write-junk-to-cp15-registers-on-reset.patch
>   selftests-kvm-adding-config-fragments.patch
>   iwlwifi-mvm-disable-tx-amsdu-on-older-nics.patch
>   hid-wacom-correct-misreported-ekr-ring-values.patch
>   hid-wacom-correct-distance-scale-for-2nd-gen-intuos-devices.patch
>   revert-kvm-x86-mmu-zap-only-the-relevant-pages-when-removing-a-memslot.patch
>   revert-dm-bufio-fix-deadlock-with-loop-device.patch
>   clk-socfpga-stratix10-fix-rate-caclulationg-for-cnt_clks.patch
>   ceph-clear-page-dirty-before-invalidate-page.patch
>   ceph-don-t-try-fill-file_lock-on-unsuccessful-getfilelock-reply.patch
>   libceph-fix-pg-split-vs-osd-re-connect-race.patch
>   drm-amdgpu-gfx9-update-pg_flags-after-determining-if-gfx-off-is-possible.patch
>   drm-nouveau-don-t-retry-infinitely-when-receiving-no-data-on-i2c-over-aux.patch
>   scsi-ufs-fix-null-pointer-dereference-in-ufshcd_config_vreg_hpm.patch
>   gpiolib-never-report-open-drain-source-lines-as-input-to-user-space.patch
>   drivers-hv-vmbus-fix-virt_to_hvpfn-for-x86_pae.patch
>   userfaultfd_release-always-remove-uffd-flags-and-clear-vm_userfaultfd_ctx.patch
>   x86-retpoline-don-t-clobber-rflags-during-call_nospec-on-i386.patch
>   x86-apic-handle-missing-global-clockevent-gracefully.patch
>   x86-cpu-amd-clear-rdrand-cpuid-bit-on-amd-family-15h-16h.patch
>   x86-boot-save-fields-explicitly-zero-out-everything-else.patch
>   x86-boot-fix-boot-regression-caused-by-bootparam-sanitizing.patch
>   ib-hfi1-unsafe-psn-checking-for-tid-rdma-read-resp-packet.patch
>   ib-hfi1-add-additional-checks-when-handling-tid-rdma-read-resp-packet.patch
>   ib-hfi1-add-additional-checks-when-handling-tid-rdma-write-data-packet.patch
>   ib-hfi1-drop-stale-tid-rdma-packets-that-cause-tiderr.patch
>   psi-get-poll_work-to-run-when-calling-poll-syscall-next-time.patch
>   dm-kcopyd-always-complete-failed-jobs.patch
>   dm-dust-use-dust-block-size-for-badblocklist-index.patch
>   dm-btree-fix-order-of-block-initialization-in-btree_split_beneath.patch
>   dm-integrity-fix-a-crash-due-to-bug_on-in-__journal_read_write.patch
>   dm-raid-add-missing-cleanup-in-raid_ctr.patch
>   dm-space-map-metadata-fix-missing-store-of-apply_bops-return-value.patch
>   dm-table-fix-invalid-memory-accesses-with-too-high-sector-number.patch
>   dm-zoned-improve-error-handling-in-reclaim.patch
>   dm-zoned-improve-error-handling-in-i-o-map-code.patch
>   dm-zoned-properly-handle-backing-device-failure.patch
>   genirq-properly-pair-kobject_del-with-kobject_add.patch
>   mm-z3fold.c-fix-race-between-migration-and-destruction.patch
>   mm-page_alloc-move_freepages-should-not-examine-struct-page-of-reserved-memory.patch
>   mm-memcontrol-flush-percpu-vmstats-before-releasing-memcg.patch
>   mm-memcontrol-flush-percpu-vmevents-before-releasing-memcg.patch
>   mm-page_owner-handle-thp-splits-correctly.patch
>   mm-zsmalloc.c-migration-can-leave-pages-in-zs_empty-indefinitely.patch
>   mm-zsmalloc.c-fix-race-condition-in-zs_destroy_pool.patch
>   mm-kasan-fix-false-positive-invalid-free-reports-with-config_kasan_sw_tags-y.patch
>   xfs-fix-missing-ilock-unlock-when-xfs_setattr_nonsize-fails-due-to-edquot.patch
>   ib-hfi1-drop-stale-tid-rdma-packets.patch
>   dm-zoned-fix-potential-null-dereference-in-dmz_do_re.patch
>   io_uring-fix-potential-hang-with-polled-io.patch
>   io_uring-don-t-enter-poll-loop-if-we-have-cqes-pendi.patch
>   io_uring-add-need_resched-check-in-inner-poll-loop.patch
>   powerpc-allow-flush_-inval_-dcache_range-to-work-across-ranges-4gb.patch
>   rxrpc-fix-local-endpoint-refcounting.patch
>   rxrpc-fix-read-after-free-in-rxrpc_queue_local.patch
>   rxrpc-fix-local-endpoint-replacement.patch
> 
> Compile testing
> ---------------
> 
> We compiled the kernel for 3 architectures:
> 
>     aarch64:
>       make options: -j30 INSTALL_MOD_STRIP=1 targz-pkg
> 
>     ppc64le:
>       make options: -j30 INSTALL_MOD_STRIP=1 targz-pkg
> 
>     x86_64:
>       make options: -j30 INSTALL_MOD_STRIP=1 targz-pkg
> 
> 
> Hardware testing
> ----------------
> We booted each kernel and ran the following tests:
> 
>   aarch64:
>       Host 1:
>          ✅ Boot test [0]
>          ✅ xfstests: xfs [1]
>          ✅ selinux-policy: serge-testsuite [2]
>          ✅ lvm thinp sanity [3]
>          ✅ storage: software RAID testing [4]
>          🚧 ✅ Storage blktests [5]
> 
>       Host 2:
> 
>          ⚡ Internal infrastructure issues prevented one or more tests (marked
>          with ⚡⚡⚡) from running on this architecture.
>          This is not the fault of the kernel that was tested.
> 
>          ⚡⚡⚡ Boot test [0]
>          ⚡⚡⚡ Podman system integration test (as root) [6]
>          ⚡⚡⚡ Podman system integration test (as user) [6]
>          ⚡⚡⚡ Loopdev Sanity [7]
>          ⚡⚡⚡ jvm test suite [8]
>          ⚡⚡⚡ AMTU (Abstract Machine Test Utility) [9]
>          ⚡⚡⚡ LTP: openposix test suite [10]
>          ⚡⚡⚡ Ethernet drivers sanity [11]
>          ⚡⚡⚡ Networking socket: fuzz [12]
>          ⚡⚡⚡ audit: audit testsuite test [13]
>          ⚡⚡⚡ httpd: mod_ssl smoke sanity [14]
>          ⚡⚡⚡ iotop: sanity [15]
>          ⚡⚡⚡ tuned: tune-processes-through-perf [16]
>          ⚡⚡⚡ Usex - version 1.9-29 [17]
>          ⚡⚡⚡ storage: SCSI VPD [18]
>          ⚡⚡⚡ stress: stress-ng [19]
>          🚧 ⚡⚡⚡ LTP lite [20]
> 
> 
>   ppc64le:
>       Host 1:
>          ✅ Boot test [0]
>          ✅ xfstests: xfs [1]
>          ✅ selinux-policy: serge-testsuite [2]
>          ✅ lvm thinp sanity [3]
>          ✅ storage: software RAID testing [4]
>          🚧 ✅ Storage blktests [5]
> 
>       Host 2:
>          ✅ Boot test [0]
>          ✅ Podman system integration test (as root) [6]
>          ✅ Podman system integration test (as user) [6]
>          ✅ Loopdev Sanity [7]
>          ✅ jvm test suite [8]
>          ✅ AMTU (Abstract Machine Test Utility) [9]
>          ✅ LTP: openposix test suite [10]
>          ✅ Ethernet drivers sanity [11]
>          ✅ Networking socket: fuzz [12]
>          ✅ audit: audit testsuite test [13]
>          ✅ httpd: mod_ssl smoke sanity [14]
>          ✅ iotop: sanity [15]
>          ✅ tuned: tune-processes-through-perf [16]
>          ✅ Usex - version 1.9-29 [17]
>          🚧 ✅ LTP lite [20]
> 
> 
>   x86_64:
>       Host 1:
>          ✅ Boot test [0]
>          ✅ Podman system integration test (as root) [6]
>          ✅ Podman system integration test (as user) [6]
>          ✅ Loopdev Sanity [7]
>          ✅ jvm test suite [8]
>          ✅ AMTU (Abstract Machine Test Utility) [9]
>          ✅ LTP: openposix test suite [10]
>          ✅ Ethernet drivers sanity [11]
>          ❌ Networking socket: fuzz [12]
>          ⚡⚡⚡ audit: audit testsuite test [13]
>          ⚡⚡⚡ httpd: mod_ssl smoke sanity [14]
>          ⚡⚡⚡ iotop: sanity [15]
>          ⚡⚡⚡ tuned: tune-processes-through-perf [16]
>          ⚡⚡⚡ pciutils: sanity smoke test [21]
>          ⚡⚡⚡ Usex - version 1.9-29 [17]
>          ⚡⚡⚡ storage: SCSI VPD [18]
>          ⚡⚡⚡ stress: stress-ng [19]
>          🚧 ❌ LTP lite [20]
> 
>       Host 2:
>          ✅ Boot test [0]
>          ✅ xfstests: xfs [1]
>          ✅ selinux-policy: serge-testsuite [2]
>          ✅ lvm thinp sanity [3]
>          ✅ storage: software RAID testing [4]
>          🚧 ✅ Storage blktests [5]
> 
> 
>   Test source:
>     💚 Pull requests are welcome for new tests or improvements to existing tests!
>     [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
>     [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/filesystems/xfs/xfstests
>     [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
>     [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/lvm/thinp/sanity
>     [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/swraid/trim
>     [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/blk
>     [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/container/podman
>     [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#filesystems/loopdev/sanity
>     [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/jvm
>     [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
>     [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/openposix_testsuite
>     [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/driver/sanity
>     [12]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/socket/fuzz
>     [13]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
>     [14]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
>     [15]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
>     [16]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
>     [17]: https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
>     [18]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/scsi/vpd
>     [19]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng
>     [20]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp-upstream/lite
>     [21]: https://github.com/CKI-project/tests-beaker/archive/master.zip#pciutils/sanity-smoke
> 
> Waived tests
> ------------
> If the test run included waived tests, they are marked with 🚧. Such tests are
> executed but their results are not taken into account. Tests are waived when
> their results are not reliable enough, e.g. when they're just introduced or are
> being fixed.
