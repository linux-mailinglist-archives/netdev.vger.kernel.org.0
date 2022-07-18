Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98E865785F5
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 17:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234794AbiGRPBY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 11:01:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234659AbiGRPBX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 11:01:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C62A522BF8
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 08:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658156479;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BHSes/WjwsThp6weFkYaeDkMyMfx1ODvuk7pSgKJJmg=;
        b=imZr2qs9I94ilr1c70sZGxZM5tpsejJbvYYZzf41FWMGotFkMqFy0sTa0ky5r1jUnO9HAj
        TKEPR+D5LiqYPtf6vccnuJxqYNVXdPGAFJ6g6ScpUpQr1eGuKeiCHbHgMgUduEjyJZzQ02
        XxWW3OH4dk9rIVYfjSQnrp2yD6QgHXA=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-575-RuPCvn3HMM28yVn8WQCmiw-1; Mon, 18 Jul 2022 11:01:18 -0400
X-MC-Unique: RuPCvn3HMM28yVn8WQCmiw-1
Received: by mail-qv1-f71.google.com with SMTP id eb3-20020ad44e43000000b00472e7d52ce6so5648304qvb.17
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 08:01:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=BHSes/WjwsThp6weFkYaeDkMyMfx1ODvuk7pSgKJJmg=;
        b=avLMoXW6xbfsnEQ4Jstf5hrlEzHfqEtdoCHjP5QzAxc2fnUOTSdR0fekGw5kJG5goz
         SaiR5XcmWIJo3ieN3IDpAmGd9ff5x2o5CEBd+9sk59MZTx3b+jJHtOTLqstXyLUN5PKe
         wA+6QUIerjRL/6YT0hPJM3qwLQpQIlgObt7/kl9Cl6k1mnArfgFotf7laTftqMDrD2Mg
         /G79H5ThjwZq6j7FDJbjznP9LNdsDg4ytxp+0q7qbll+8fPsRfp6wBA1xUvU/sP/y6MP
         nWe929XDvr+nBR83Ak4zx4OelEeoNwwCVyEn/goowM7YSbOToITp9pyNfgW6vOMi0GQz
         msjA==
X-Gm-Message-State: AJIora+z9Mds6F1DnvG1S04h+zFRfsCFuuVkSIMiraU7RxfMOSJ/y2pw
        moM8iNpLd9Qc+Q2qWDefEf73vh9lfCLjV7r3GoDq1e722adwVFR/tJMLiYDpOOanV8fF7/3KoKL
        gAEHoFAcz0Xcv0oxw
X-Received: by 2002:ae9:ddc2:0:b0:6b5:b33f:a2df with SMTP id r185-20020ae9ddc2000000b006b5b33fa2dfmr17296183qkf.746.1658156475901;
        Mon, 18 Jul 2022 08:01:15 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1umRLZVDb3ZR7Qr+fEk3G0gl72mYlrC9SQxx4k22xI0jiZYmZ85s99d6wy0jP2FwrCpbTH/Mg==
X-Received: by 2002:ae9:ddc2:0:b0:6b5:b33f:a2df with SMTP id r185-20020ae9ddc2000000b006b5b33fa2dfmr17296020qkf.746.1658156474064;
        Mon, 18 Jul 2022 08:01:14 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-97-238.dyn.eolo.it. [146.241.97.238])
        by smtp.gmail.com with ESMTPSA id bk34-20020a05620a1a2200b006af1f0af045sm11135611qkb.107.2022.07.18.08.01.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 08:01:13 -0700 (PDT)
Message-ID: <26265e62a3ed1d5fd8f588a043c2da5a09378021.camel@redhat.com>
Subject: Re: [mptcp]  d24141fe7b:
 WARNING:at_mm/page_counter.c:#page_counter_cancel
From:   Paolo Abeni <pabeni@redhat.com>
To:     kernel test robot <oliver.sang@intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        netdev@vger.kernel.org, mptcp@lists.linux.dev, lkp@lists.01.org,
        lkp@intel.com
Date:   Mon, 18 Jul 2022 17:01:09 +0200
In-Reply-To: <YtVhyGSsv1CWvPz4@xsang-OptiPlex-9020>
References: <YtVhyGSsv1CWvPz4@xsang-OptiPlex-9020>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-07-18 at 21:36 +0800, kernel test robot wrote:
> FYI, we noticed the following commit (built with gcc-11):
> 
> commit: d24141fe7b48d3572afb673ae350cf0e88caba6c ("mptcp: drop SK_RECLAIM_* macros")
> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master
> 
> in testcase: kernel-selftests
> version: kernel-selftests-x86_64-77b3a84e-1_20220711
> with following parameters:
> 
> 	group: mptcp
> 	ucode: 0xec
> 
> test-description: The kernel contains a set of "self tests" under the tools/testing/selftests/ directory. These are intended to be small unit tests to exercise individual code paths in the kernel.
> test-url: https://www.kernel.org/doc/Documentation/kselftest.txt
> 
> 
> on test machine: 8 threads Intel(R) Core(TM) i7-6700 CPU @ 3.40GHz with 16G memory
> 
> caused below changes (please refer to attached dmesg/kmsg for entire log/backtrace):
> 
> 
> If you fix the issue, kindly add following tag
> Reported-by: kernel test robot <oliver.sang@intel.com>
> 
> 
> [  240.473094][T14986] ------------[ cut here ]------------
> [  240.478507][T14986] page_counter underflow: -4294828518 nr_pages=4294967290
> [  240.485500][T14986] WARNING: CPU: 2 PID: 14986 at mm/page_counter.c:56 page_counter_cancel+0x96/0xc0
> [  240.494671][T14986] Modules linked in: mptcp_diag inet_diag nft_tproxy nf_tproxy_ipv6 nf_tproxy_ipv4 nft_socket nf_socket_ipv4 nf_socket_ipv6 nf_tabl
> es nfnetlink openvswitch nf_conncount nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 btrfs blake2b_generic xor raid6_pq zstd_compress libcrc32c sd_mo
> d t10_pi crc64_rocksoft_generic crc64_rocksoft crc64 i915 sg hp_wmi ipmi_devintf intel_rapl_msr intel_rapl_common ipmi_msghandler x86_pkg_temp_thermal i
> ntel_powerclamp coretemp crct10dif_pclmul crc32_pclmul intel_gtt sparse_keymap crc32c_intel platform_profile drm_buddy ghash_clmulni_intel mei_wdt rfkil
> l wmi_bmof drm_display_helper rapl ttm ahci drm_kms_helper libahci intel_cstate syscopyarea intel_uncore mei_me sysfillrect serio_raw libata i2c_i801 me
> i sysimgblt i2c_smbus fb_sys_fops intel_pch_thermal wmi video intel_pmc_core tpm_infineon acpi_pad fuse ip_tables
> [  240.570849][T14986] CPU: 2 PID: 14986 Comm: mptcp_connect Tainted: G S                5.19.0-rc4-00739-gd24141fe7b48 #1
> [  240.581637][T14986] Hardware name: HP HP Z240 SFF Workstation/802E, BIOS N51 Ver. 01.63 10/05/2017
> [  240.590600][T14986] RIP: 0010:page_counter_cancel+0x96/0xc0
> [  240.596179][T14986] Code: 00 00 00 45 31 c0 48 89 ef 5d 4c 89 c6 41 5c e9 40 fd ff ff 4c 89 e2 48 c7 c7 20 73 39 84 c6 05 d5 b1 52 04 01 e8 e7 95 f3
> 01 <0f> 0b eb a9 48 89 ef e8 1e 25 fc ff eb c3 66 66 2e 0f 1f 84 00 00
> [  240.615639][T14986] RSP: 0018:ffffc9000496f7c8 EFLAGS: 00010082
> [  240.621569][T14986] RAX: 0000000000000000 RBX: ffff88819c9c0120 RCX: 0000000000000000
> [  240.629404][T14986] RDX: 0000000000000027 RSI: 0000000000000004 RDI: fffff5200092deeb
> [  240.637239][T14986] RBP: ffff88819c9c0120 R08: 0000000000000001 R09: ffff888366527a2b
> [  240.645069][T14986] R10: ffffed106cca4f45 R11: 0000000000000001 R12: 00000000fffffffa
> [  240.652903][T14986] R13: ffff888366536118 R14: 00000000fffffffa R15: ffff88819c9c0000
> [  240.660738][T14986] FS:  00007f3786e72540(0000) GS:ffff888366500000(0000) knlGS:0000000000000000
> [  240.669529][T14986] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  240.675974][T14986] CR2: 00007f966b346000 CR3: 0000000168cea002 CR4: 00000000003706e0
> [  240.683807][T14986] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  240.691641][T14986] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  240.699468][T14986] Call Trace:
> [  240.702613][T14986]  <TASK>
> [  240.705413][T14986]  page_counter_uncharge+0x29/0x80
> [  240.710389][T14986]  drain_stock+0xd0/0x180
> [  240.714585][T14986]  refill_stock+0x278/0x580
> [  240.718951][T14986]  __sk_mem_reduce_allocated+0x222/0x5c0
> [  240.724443][T14986]  ? rwlock_bug+0xc0/0xc0
> [  240.729248][T14986]  __mptcp_update_rmem+0x235/0x2c0
> [  240.734228][T14986]  __mptcp_move_skbs+0x194/0x6c0
> [  240.739030][T14986]  ? mptcp_check_data_fin+0x380/0x380
> [  240.744869][T14986]  ? skb_release_data+0x482/0x640
> [  240.749764][T14986]  mptcp_recvmsg+0xdfa/0x1340
> [  240.754315][T14986]  ? __mptcp_move_skbs+0x6c0/0x6c0
> [  240.759296][T14986]  ? memset+0x20/0x40
> [  240.763153][T14986]  inet_recvmsg+0x37f/0x500
> [  240.767521][T14986]  ? generic_perform_write+0x310/0x4c0
> [  240.772846][T14986]  ? inet_sendpage+0x140/0x140
> [  240.777473][T14986]  ? find_held_lock+0x2c/0x140
> [  240.782109][T14986]  sock_read_iter+0x24a/0x380
> [  240.786655][T14986]  ? sock_recvmsg+0x140/0x140
> [  240.791198][T14986]  ? 0xffffffff81000000
> [  240.795228][T14986]  ? poll_select_set_timeout+0x82/0x100
> [  240.800633][T14986]  ? __lock_release+0x102/0x540
> [  240.805353][T14986]  new_sync_read+0x420/0x540
> [  240.809806][T14986]  ? lock_is_held_type+0x98/0x140
> [  240.814691][T14986]  ? __ia32_sys_llseek+0x340/0x340
> [  240.819668][T14986]  ? 0xffffffff81000000
> [  240.823693][T14986]  ? recalibrate_cpu_khz+0x40/0x40
> [  240.828667][T14986]  ? ktime_get_ts64+0xbc/0x240
> [  240.833306][T14986]  ? fsnotify_perm+0x13b/0x4c0
> [  240.838552][T14986]  vfs_read+0x37f/0x4c0
> [  240.842582][T14986]  ksys_read+0x170/0x200
> [  240.846688][T14986]  ? __ia32_sys_pwrite64+0x200/0x200
> [  240.851836][T14986]  ? lockdep_hardirqs_on_prepare+0x19a/0x380
> [  240.858284][T14986]  ? syscall_enter_from_user_mode+0x21/0x80
> [  240.864039][T14986]  do_syscall_64+0x5c/0x80
> [  240.868314][T14986]  ? do_syscall_64+0x69/0x80
> [  240.872770][T14986]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
> [  240.878526][T14986] RIP: 0033:0x7f3786d9ae8e
> [  240.882805][T14986] Code: c0 e9 b6 fe ff ff 50 48 8d 3d 6e 18 0a 00 e8 89 e8 01 00 66 0f 1f 84 00 00 00 00 00 64 8b 04 25 18 00 00 00 85 c0 75 14 0f 05 <48> 3d 00 f0 ff ff 77 5a c3 66 0f 1f 84 00 00 00 00 00 48 83 ec 28
> [  240.902259][T14986] RSP: 002b:00007fff7be81e08 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
> [  240.910533][T14986] RAX: ffffffffffffffda RBX: 0000000000002000 RCX: 00007f3786d9ae8e
> [  240.918368][T14986] RDX: 0000000000002000 RSI: 00007fff7be87ec0 RDI: 0000000000000005
> [  240.926206][T14986] RBP: 0000000000000005 R08: 00007f3786e6a230 R09: 00007f3786e6a240
> [  240.934046][T14986] R10: fffffffffffff288 R11: 0000000000000246 R12: 0000000000002000
> [  240.941884][T14986] R13: 00007fff7be87ec0 R14: 00007fff7be87ec0 R15: 0000000000002000
> [  240.949741][T14986]  </TASK>
> [  240.952632][T14986] irq event stamp: 27367
> [  240.956735][T14986] hardirqs last  enabled at (27366): [<ffffffff81ba50ea>] mem_cgroup_uncharge_skmem+0x6a/0x80
> [  240.966848][T14986] hardirqs last disabled at (27367): [<ffffffff81b8fd42>] refill_stock+0x282/0x580
> [  240.976017][T14986] softirqs last  enabled at (27360): [<ffffffff83a4d8ef>] mptcp_recvmsg+0xaf/0x1340
> [  240.985273][T14986] softirqs last disabled at (27364): [<ffffffff83a4d30c>] __mptcp_move_skbs+0x18c/0x6c0
> [  240.994872][T14986] ---[ end trace 0000000000000000 ]---

I think that the root cause is that subflows and main socket end-up in
different cgroups (likely, the subflows in no cgroup at all). It should
be quite unrelated from the mentioned commit (older issue).

I'll try to have a better look.

Thanks!

Paolo

