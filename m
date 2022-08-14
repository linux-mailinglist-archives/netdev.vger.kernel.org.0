Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08A8D591E1E
	for <lists+netdev@lfdr.de>; Sun, 14 Aug 2022 06:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbiHNEjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Aug 2022 00:39:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiHNEjN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Aug 2022 00:39:13 -0400
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E996756B8A;
        Sat, 13 Aug 2022 21:39:11 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 823945C00E3;
        Sun, 14 Aug 2022 00:39:09 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Sun, 14 Aug 2022 00:39:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        cc:cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1660451949; x=1660538349; bh=KjuozbCmXt
        5vYINJ5+rGvb89Bc2k0Mt3LvWiZkPyuWk=; b=ddKrHE46+MAuMXSsvIb4MsBauQ
        2PjMq/NmCXbiYKqD6i6BL7KkhdueNqwmo0GSRE42mpxSzceGb6Ki0JNnrCw5R91V
        JwaGQE4mxx1zcsS3+t9LTx6qSmOZzjyI+ARsbLB3dtFRmbFvMV7nL2ntn1GWgy6y
        aFwdxF/wPGGrYcuhws+iJBNiYmUPUpJz8dpwMysHdbeyeOKLmloxRQPYH8Pceg2T
        ZAt3kuQyg69OM0t8OZ72Y/sF7g3gKQBa1XXvx5lR5tPAA5qGiETj2xk/ESzoulhz
        Kb4NY2bTp8bw4F+xkPtO4sVYDCfVWCErRxm98ibZtt4ZIWGxn/+Qpr+brGwg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1660451949; x=1660538349; bh=KjuozbCmXt5vYINJ5+rGvb89Bc2k
        0Mt3LvWiZkPyuWk=; b=Q9HQGSdYB7EY4JHH5PU7DCAy1rrkLQei2Hda+NlPh5lQ
        jRVKRtwRqgpECzxXmU32+OI7/k6V2FDp+/cVbQfH5izPHOMl1WNu/81WFFVzZc2k
        P1rCiSG5sQF0iDzDLQwhDLOGz3gHH72UgzOxD15RHofgq5Xe33SieXcVpy6kwxn+
        dAkc/vvjAufwEC/sgrJ53D/LjJ8av1C/DO3Hd6be/qMIEro9fL7fX3i99CXa+Ju8
        8PTy90DS4HVg2XI+Cu24fVAOCE0LcmEoSSCJ5z5hCPrTeqTe6SSvpiBHJzAYk33x
        2+5Sj5TWk2gJj5lFfil/2WhIemWFNq7ZxIGj1AxeXw==
X-ME-Sender: <xms:bHz4YvfxHhB7UlTwlGgRo9JFYrH_gl4xKaLwHaPyt8nRONCYLEgN2w>
    <xme:bHz4YlMMOzS_x-45vzaqqy371z8egbIX0_hFziXja8gu9KN3HO_vsFawr718-CNVM
    ysnEAIJf2Jik5Z_PQ>
X-ME-Received: <xmr:bHz4YogpG5ijIFDDkxCDoRz7WJe-TSjd6lGfMhTkmDeVgv7s8R1APLRT7V2egNjlSwFu7jc8xDvZpMh9qhQQddnd6OpbecF9QFXF9-sQCBpMLcuVVlP92fmO2XP2>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdegledgkeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomheptehnughr
    vghsucfhrhgvuhhnugcuoegrnhgurhgvshesrghnrghrrgiivghlrdguvgeqnecuggftrf
    grthhtvghrnhepvdfffeevhfetveffgeeiteefhfdtvdffjeevhfeuteegleduheetvedu
    ieettddunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    eprghnughrvghssegrnhgrrhgriigvlhdruggv
X-ME-Proxy: <xmx:bHz4Yg9LJKn9TYXW-r2WSaVoxBtv5fMJubQ3PqX9W-PLPZji9QW71w>
    <xmx:bHz4Yrsz-w_UfSOYJ2nkUIMnbmhQY8kwd_5pDoAztu-TecT3NJzALA>
    <xmx:bHz4YvGkudn6DuK1zplqmhqExinpZvFFO10lmCKpQ91CQOQloXVpcw>
    <xmx:bXz4YhqqVJ6xoUFQwQ8ZxdCZXS7NsL_cYFAd3wVej8vWSIiLZshhmA>
Feedback-ID: id4a34324:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 14 Aug 2022 00:39:07 -0400 (EDT)
Date:   Sat, 13 Aug 2022 21:39:06 -0700
From:   Andres Freund <andres@anarazel.de>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        alvaro.karsz@solid-run.com, colin.i.king@gmail.com,
        colin.king@intel.com, dan.carpenter@oracle.com, david@redhat.com,
        elic@nvidia.com, eperezma@redhat.com, gautam.dawar@xilinx.com,
        gshan@redhat.com, hdegoede@redhat.com, hulkci@huawei.com,
        jasowang@redhat.com, jiaming@nfschina.com,
        kangjie.xu@linux.alibaba.com, lingshan.zhu@intel.com,
        liubo03@inspur.com, michael.christie@oracle.com,
        pankaj.gupta@amd.com, peng.fan@nxp.com, quic_mingxue@quicinc.com,
        robin.murphy@arm.com, sgarzare@redhat.com, suwan.kim027@gmail.com,
        syoshida@redhat.com, xieyongji@bytedance.com, xuqiang36@huawei.com,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [GIT PULL] virtio: fatures, fixes
Message-ID: <20220814043906.xkmhmnp23bqjzz4s@awork3.anarazel.de>
References: <20220812114250-mutt-send-email-mst@kernel.org>
 <20220814004522.33ecrwkmol3uz7aq@awork3.anarazel.de>
 <1660441835.6907768-1-xuanzhuo@linux.alibaba.com>
 <20220814035239.m7rtepyum5xvtu2c@awork3.anarazel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220814035239.m7rtepyum5xvtu2c@awork3.anarazel.de>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 2022-08-13 20:52:39 -0700, Andres Freund wrote:
> Is there specific information you'd like from the VM? I just recreated the
> problem and can extract.

Actually, after reproducing I seem to now hit a likely different issue. I
guess I should have checked exactly the revision I had a problem with earlier,
rather than doing a git pull (up to aea23e7c464b)

[    0.727199] scsi host0: Virtio SCSI HBA
[    0.732257] scsi 0:0:1:0: Direct-Access     Google   PersistentDisk   1    PQ: 0 ANSI: 6
[    0.736259] Freeing initrd memory: 7236K
[    0.741743] sd 0:0:1:0: Attached scsi generic sg0 type 0
[    0.742569] sd 0:0:1:0: [sda] 52428800 512-byte logical blocks: (26.8 GB/25.0 GiB)
[    0.742628] tun: Universal TUN/TAP device driver, 1.6
[    0.743730] sd 0:0:1:0: [sda] 4096-byte physical blocks
[    0.748026] sd 0:0:1:0: [sda] Write Protect is off
[    0.750684] sd 0:0:1:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    0.795519] BUG: unable to handle page fault for address: ffffa3107bd80008
[    0.795753] sky2: driver version 1.30
[    0.796500] #PF: supervisor read access in kernel mode
[    0.797252] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.796500] #PF: error_code(0x0000) - not-present page
[    0.796500] PGD 100001067 P4D 100001067 PUD 0
[    0.796500] Oops: 0000 [#1] PREEMPT SMP PTI
[    0.796500] CPU: 3 PID: 0 Comm: swapper/3 Not tainted 5.19.0-origin-14013-gaea23e7c464b #2
[    0.798728] ehci-pci: EHCI PCI platform driver
[    0.796500] Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/29/2022
[    0.800112] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.796500] RIP: 0010:kmem_cache_free+0x155/0x3e0
[    0.801875] ohci-pci: OHCI PCI platform driver
[    0.796500] Code: 02 00 00 65 48 ff 08 e8 e9 cd e6 ff 66 90 8b 45 28 48 c7 04 03 00 00 00 00 48 85 db 74 38 48 8b 45 00 65 48 03 05 fb 13 34 6d <48> 8b 50 08 4c 39 60 10 0f 85 da 01 00 00 8b 4d 28 48 8b 00 48 89
[    0.803798] uhci_hcd: USB Universal Host Controller Interface driver
[    0.796500] RSP: 0000:ffffa29cc0134e80 EFLAGS: 00010286
[    0.805319] RAX: ffffa3107bd80000 RBX: ffff998840b253c0 RCX: ffff029c00000000
[    0.805319] RDX: 0000000000000000 RSI: ffffc8f280000000 RDI: ffff998840ab2300
[    0.805319] RBP: ffff998840ab2300 R08: fffffffffff0bddf R09: 0000000000000008
[    0.805319] R10: ffffffff93e060c0 R11: ffffa29cc0134ff8 R12: ffffc8f28402c940
[    0.805319] R13: ffffffff92f17edd R14: 0000000000001000 R15: 0000000000001000
[    0.805319] FS:  0000000000000000(0000) GS:ffff99887bd80000(0000) knlGS:0000000000000000
[    0.805319] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.805319] CR2: ffffa3107bd80008 CR3: 000000002720c001 CR4: 00000000003706e0
[    0.805319] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    0.805319] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[    0.805319] Call Trace:
[    0.805319]  <IRQ>
[    0.805319]  blk_update_request+0xfd/0x3d0
[    0.805319]  ? detach_buf_split+0x6a/0x150
[    0.805319]  scsi_end_request+0x22/0x1b0
[    0.805319]  scsi_io_completion+0x3c/0x750
[    0.805319]  blk_complete_reqs+0x38/0x50
[    0.805319]  __do_softirq+0xe1/0x2ed
[    0.805319]  ? handle_edge_irq+0x9a/0x230
[    0.805319]  __irq_exit_rcu+0xa6/0x100
[    0.805319]  common_interrupt+0xa5/0xc0
[    0.805319]  </IRQ>
[    0.805319]  <TASK>
[    0.805319]  asm_common_interrupt+0x22/0x40
[    0.805319] RIP: 0010:acpi_idle_do_entry+0x46/0x60
[    0.805319] Code: 75 08 48 8b 15 2f 1a 19 01 ed c3 cc cc cc cc 65 48 8b 04 25 00 ad 01 00 48 8b 00 a8 08 75 eb 66 90 0f 00 2d 9c 0d 5b 00 fb f4 <fa> c3 cc cc cc cc e9 2f fd ff ff 66 66 2e 0f 1f 84 00 00 00 00 00
[    0.805319] RSP: 0000:ffffa29cc00a7e68 EFLAGS: 00000246
[    0.805319] RAX: 0000000000004000 RBX: 0000000000000001 RCX: 000000000000098d
[    0.805319] RDX: ffff99887bd80000 RSI: ffff998840b2c000 RDI: ffff998840b2c064
[    0.805319] RBP: ffff998841a2a400 R08: fffffffffff0be0e R09: 0000000157c1aaba
[    0.805319] R10: 0000000000000018 R11: 0000000000000c27 R12: ffffffff93fc46a0
[    0.805319] R13: ffff998840b2c064 R14: 0000000000000001 R15: 0000000000000000
[    0.805319]  acpi_idle_enter+0x9f/0x100
[    0.805319]  cpuidle_enter_state+0x84/0x400
[    0.805319]  cpuidle_enter+0x24/0x40
[    0.805319]  do_idle+0x1df/0x260
[    0.805319]  cpu_startup_entry+0x14/0x20
[    0.805319]  start_secondary+0xe8/0xf0
[    0.805319]  secondary_startup_64_no_verify+0xe0/0xeb
[    0.805319]  </TASK>
[    0.805319] Modules linked in:
[    0.805319] CR2: ffffa3107bd80008
[    0.805319] ---[ end trace 0000000000000000 ]---

Regards,

Andres
