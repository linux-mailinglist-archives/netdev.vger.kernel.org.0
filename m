Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C95556B5799
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 02:47:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbjCKBr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 20:47:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjCKBrZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 20:47:25 -0500
Received: from mail-ua1-x92e.google.com (mail-ua1-x92e.google.com [IPv6:2607:f8b0:4864:20::92e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54443112DD7;
        Fri, 10 Mar 2023 17:47:20 -0800 (PST)
Received: by mail-ua1-x92e.google.com with SMTP id s23so4772710uae.5;
        Fri, 10 Mar 2023 17:47:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678499239;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Uuh51nXvkLQUiEjaDRM9lQJll7+KcksMVuX3jpgsd3Y=;
        b=YcCtjzYPMVn2hlrCEbFXb0Xb5xv+fvwb4PobNWnhneC8+ho+FcbaDdwFzn0GdA47TD
         q952bC1f49YL/ryZ5pKixZPDkPopK2SThoLByRZlsFB5j9huE44JfGS/W2mL87JUEICu
         KdDGXfefTliWyBW8G67sZGZCEt0iHrxEllIJVhrp3r/h/z/2i8MM3FCFEcBD5QFwqX93
         pIertyv1sz7T2zPMCPLfPACRIUbssJ0ghsT+73oqeCVLD5x11yovVLNDoYp7dV4jeoXE
         qsxeO1STFZwlxpEcttcv1wHFFlFGi5fXXyhvhrdCsHIg+b8ZtwJ7AsH6GVuYpJUu1u9X
         ZXpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678499239;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Uuh51nXvkLQUiEjaDRM9lQJll7+KcksMVuX3jpgsd3Y=;
        b=DG9x1uqzEuPZg5nl0IwCZs5h0PRQacwy75OCBn+G2Ovv7AQ0a0iT2/SGc4c4pOZoX4
         VawLUsqhYty9NUiV6jKRmM6ktKIAOM75xyRS19ZmLLd1nhKbAKhNvH7wCJCJ9KMjSamo
         HlOWa4kdxVdeN3o2lJVc2ewfoDUaYqEolGdASci5PHzeLpITjG2tFm1e52DSdxccYh6M
         e1kmI1pY/cQDzyBoku6/cp+f062B2vVcf+rSGwF6RlDqTVUQtbzkLatALmoUGiMzlyZn
         FsX2pIGAiBYVCJwAT4OzR8Zji/z6ydq2crYsmud9ONq7Sc0FzS6FhOhzirvUWgDZXTac
         5D9A==
X-Gm-Message-State: AO0yUKWwIURPMlxz4Nixse+YLcffCKtErEKRQCOYkvtHlYABK/NXOXtL
        M2kY6lfc3+cAXuzM2xghBoFC9OaBfKdWRfnDqHw=
X-Google-Smtp-Source: AK7set+xY47Akl7ACZ8EaZbtzamD4H/ig9T5cSSzfWrcZ6ayBNaLDEyK3M1yXzZ2XTcTwyKyfJl7teyF4wf3d2dvAac=
X-Received: by 2002:a1f:ecc5:0:b0:406:1ef2:7bc7 with SMTP id
 k188-20020a1fecc5000000b004061ef27bc7mr16395891vkh.2.1678499238714; Fri, 10
 Mar 2023 17:47:18 -0800 (PST)
MIME-Version: 1.0
References: <CACsaVZL6ykbsVvEaV2Cv3r6m_jKt04MEUOw5=mSnR5AYTyE7qg@mail.gmail.com>
 <a752422c-4630-e53d-c9cd-cc9ed866f853@intel.com> <CACsaVZJXqkWGOQhe-GzRKJSfYn-3+dZTyHNZC97npCxzqr+R9g@mail.gmail.com>
 <CACsaVZLh0WFu1p7TUxE=RwucoTcZwsfQ5+ivorcbwCiRneeVFg@mail.gmail.com>
 <70eea40e-808c-e9ee-9aab-617ebe67d67c@intel.com> <CACsaVZ+icDmY15bqHuSR=KUBx0tbpDVXasuuYPjWg6aVAyy2hg@mail.gmail.com>
 <CACsaVZKr=B6xNrxM_J60+pg48onQf1jQJYNRDLwgESje_fN13Q@mail.gmail.com>
 <BYAPR11MB2727764EB94F647479731DAB96F39@BYAPR11MB2727.namprd11.prod.outlook.com>
 <CACsaVZJnKMcAtKdfgNKSzH8VNW-Lw5JN=+C+CDHcotpZJQCaeQ@mail.gmail.com>
 <BYAPR11MB2727B1CA9A658119793B2F7896F39@BYAPR11MB2727.namprd11.prod.outlook.com>
 <CACsaVZJTZon4VZ5X35o1avkKrskkcU_Qfru7FMTYHJ+cPeXpnw@mail.gmail.com>
 <CACsaVZ+1QhryQU+=pPHHrWLqfwO+17oP8zZu6Csizgqutj5a=A@mail.gmail.com>
 <43ea7fbf-9a2f-07a0-9633-b42271815a71@intel.com> <CACsaVZ+OXhp1+4t4YOm8+9fJcQOVVNckwVppzikkGBHUi-PFcw@mail.gmail.com>
 <f68c8c55-8fa1-fd34-5d3f-550bbd454ca1@intel.com> <CACsaVZ+B+d+oLizddMyv==4id+5ArNf7Dq5QSKLfoHEDdM5NOA@mail.gmail.com>
In-Reply-To: <CACsaVZ+B+d+oLizddMyv==4id+5ArNf7Dq5QSKLfoHEDdM5NOA@mail.gmail.com>
From:   Kyle Sanderson <kyle.leet@gmail.com>
Date:   Fri, 10 Mar 2023 17:47:07 -0800
Message-ID: <CACsaVZ+Z5h+FO4NQiPwVdOFXFJXyhWjvX4TmOiN-OVozNj_agg@mail.gmail.com>
Subject: Re: igc: 5.15.98 Kernel PANIC on igc_down
To:     "Neftin, Sasha" <sasha.neftin@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Cc:     "Avivi, Amir" <amir.avivi@intel.com>,
        Linux-Kernel <linux-kernel@vger.kernel.org>,
        "Torvalds, Linus" <torvalds@linux-foundation.org>,
        "Ruinskiy, Dima" <dima.ruinskiy@intel.com>,
        "Lifshits, Vitaly" <vitaly.lifshits@intel.com>,
        "naamax.meir" <naamax.meir@linux.intel.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Gunasekaran, Aravindhan" <aravindhan.gunasekaran@intel.com>,
        "MP, Sureshkumar" <sureshkumar.mp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Intel IGC Maintainers,

I see there was a patch that was backported to stable (
9b275176270efd18f2f4e328b32be1bad34c4c0d ) in early February of 2023
implementing ndo_tx_timeout. I'm still seeing the full register dump
and a panic on a simple cable removal while traffic is flowing on
5.15.98.

Here's the output from my console line with full symbols again. They
do look different now with this patch applied. I know this was
reported in December 2022, please let me know if there's anything else
I can do to help.

[   62.061814] igc 0000:01:00.0 eth0: NIC Link is Down
[   62.069169] br-lan: port 1(eth0) entered disabled state
[   62.077689] igc 0000:01:00.0 eth0: Register Dump
[   62.084172] igc 0000:01:00.0 eth0: Register Name   Value
[   62.091376] igc 0000:01:00.0 eth0: CTRL            081c0641
[   62.098865] igc 0000:01:00.0 eth0: STATUS          00380681
[   62.106357] igc 0000:01:00.0 eth0: CTRL_EXT        100000c0
[   62.113828] igc 0000:01:00.0 eth0: MDIC            18017949
[   62.121255] igc 0000:01:00.0 eth0: ICR             00000001
[   62.128698] igc 0000:01:00.0 eth0: RCTL            0440803a
[   62.136137] igc 0000:01:00.0 eth0: RDLEN[0-3]      00001000
00001000 00001000 00001000
[   62.146136] igc 0000:01:00.0 eth0: RDH[0-3]        000000b0
000000f7 00000081 0000007d
[   62.156111] igc 0000:01:00.0 eth0: RDT[0-3]        000000af
000000f6 00000080 0000007c
[   62.166075] igc 0000:01:00.0 eth0: RXDCTL[0-3]     02040808
02040808 02040808 02040808
[   62.176039] igc 0000:01:00.0 eth0: RDBAL[0-3]      04313000
042f6000 04303000 04306000
[   62.185986] igc 0000:01:00.0 eth0: RDBAH[0-3]      00000001
00000001 00000001 00000001
[   62.195922] igc 0000:01:00.0 eth0: TCTL            a503f0fa
[   62.203336] igc 0000:01:00.0 eth0: TDBAL[0-3]      0431b000
04320000 042ea000 04312000
[   62.213307] igc 0000:01:00.0 eth0: TDBAH[0-3]      00000001
00000001 00000001 00000001
[   62.223268] igc 0000:01:00.0 eth0: TDLEN[0-3]      00001000
00001000 00001000 00001000
[   62.233263] igc 0000:01:00.0 eth0: TDH[0-3]        000000fd
00000075 00000028 00000085
[   62.243280] igc 0000:01:00.0 eth0: TDT[0-3]        000000fd
00000077 00000083 00000085
[   62.253246] igc 0000:01:00.0 eth0: TXDCTL[0-3]     02100108
02100108 02100108 02100108
[   62.263219] igc 0000:01:00.0 eth0: Reset adapter
[   65.695646] i915 0000:00:02.0: [drm] Failed to load DMC firmware
i915/icl_dmc_ver1_09.bin. Disabling runtime power management.
[   65.709497] i915 0000:00:02.0: [drm] DMC firmware homepage:
https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git=
/tree/i915
[   69.360523] igc 0000:01:00.0 eth0: NIC Link is Up 1000 Mbps Full
Duplex, Flow Control: RX
[   69.371069] br-lan: port 1(eth0) entered blocking state
[   69.378124] br-lan: port 1(eth0) entered forwarding state
[   74.310776] igc 0000:01:00.0 eth0: NIC Link is Down
[   74.317778] br-lan: port 1(eth0) entered disabled state
[   77.080765] igc 0000:01:00.0 eth0: NIC Link is Up 1000 Mbps Full
Duplex, Flow Control: RX
[   77.091325] br-lan: port 1(eth0) entered blocking state
[   77.098446] br-lan: port 1(eth0) entered forwarding state
[   80.737639] igc 0000:01:00.0 eth0: NIC Link is Down
[   80.744715] br-lan: port 1(eth0) entered disabled state
[   84.076683] igc 0000:01:00.0 eth0: NIC Link is Up 1000 Mbps Full
Duplex, Flow Control: RX
[   84.087252] br-lan: port 1(eth0) entered blocking state
[   84.094354] br-lan: port 1(eth0) entered forwarding state
[   92.888365] ------------[ cut here ]------------
[   92.894997] Kernel BUG at dql_completed+0x175/0x180 [verbose debug
info unavailable]
[   92.904872] invalid opcode: 0000 [#1] SMP NOPTI
[   92.911276] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.15.98 #0
[   92.919245] Hardware name: Default string Default string/Default
string, BIOS 5.19 09/23/2022
[   92.929928] RIP: 0010:dql_completed+0x175/0x180
[   92.936300] Code: 95 c2 45 84 d4 75 08 44 89 c2 e9 17 ff ff ff 45
85 db 79 f3 01 d2 45 89 c2 41 29 d2 ba 00 00 00 00 44 0f 48 d2 e9 7b
ff ff ff <0f> 0b cc cc cc cc cc cc cc cc cc 55 49 89 f2 48 89 f8 4d 8d
5a 01
[   92.958191] RSP: 0018:ffffc9000012ce10 EFLAGS: 00010297
[   92.965381] RAX: ffff8881030f8340 RBX: ffffc90000755cb0 RCX: 00000000000=
00042
[   92.974609] RDX: ffff888101e00000 RSI: 00000000000023be RDI: 00000000000=
43b73
[   92.983873] RBP: ffffc9000012cee8 R08: 0000000000000000 R09: 8bf25443d96=
e9830
[   92.993161] R10: 0000000000043b31 R11: 0000000000000000 R12: ffff8881031=
0cb80
[   93.002478] R13: 00000000ffffff3a R14: ffff8881030f8280 R15: 00000000000=
00000
[   93.011747] FS:  0000000000000000(0000) GS:ffff88903fe80000(0000)
knlGS:0000000000000000
[   93.022078] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   93.029770] CR2: 00007fd6f70df02c CR3: 000000000340a000 CR4: 00000000003=
50ee0
[   93.039015] Call Trace:
[   93.043211]  <IRQ>
[   93.046912]  ? igc_down+0xb05/0x2df0 [igc]
[   93.052873]  ? load_balance+0x139/0xa90
[   93.058537]  __napi_poll+0x43/0x130
[   93.063818]  net_rx_action+0x224/0x290
[   93.069413]  __do_softirq+0xc2/0x1ff
[   93.074805]  irq_exit_rcu+0x5e/0x90
[   93.080115]  common_interrupt+0x8e/0xa0
[   93.086023]  </IRQ>
[   93.089989]  <TASK>
[   93.093768]  asm_common_interrupt+0x27/0x40
[   93.099780] RIP: 0010:cpuidle_enter_state+0xbb/0x2d0
[   93.106643] Code: 9f 89 ff 65 8b 3d fd 44 7c 7e e8 70 9e 89 ff 31
ff 49 89 c6 e8 56 ab 89 ff 80 7d d7 00 0f 85 ab 01 00 00 fb 66 0f 1f
44 00 00 <45> 85 ff 0f 88 dc 00 00 00 49 63 cf 4c 8b 55 c8 48 8d 04 49
48 8d
[   93.128483] RSP: 0018:ffffc900000e7e70 EFLAGS: 00000246
[   93.135678] RAX: ffff88903fea1b00 RBX: ffff88903feab000 RCX: 00000000000=
0001f
[   93.144907] RDX: 00000015a093d6fc RSI: 0000000046ec0743 RDI: 00000000000=
00000
[   93.154146] RBP: ffffc900000e7ea8 R08: 0000000000000000 R09: 00000000000=
00006
[   93.163362] R10: 00000015a091e22a R11: 0000000000000000 R12: 00000000000=
00001
[   93.172596] R13: ffffffff824cd680 R14: 00000015a093d6fc R15: 00000000000=
00001
[   93.181832]  cpuidle_enter+0x2f/0x50
[   93.187193]  call_cpuidle+0x1e/0x40
[   93.192447]  do_idle+0x15c/0x180
[   93.197435]  cpu_startup_entry+0x18/0x20
[   93.203161]  start_secondary+0xf9/0x110
[   93.208810]  secondary_startup_64_no_verify+0xb0/0xbb
[   93.215695]  </TASK>
[   93.219552] Modules linked in: pppoe ppp_async nft_fib_inet
nf_flow_table_ipv6 nf_flow_table_ipv4 nf_flow_table_inet pppox
ppp_generic nft_reject_ipv6 nft_reject_ipv4 nft_reject_inet nft_reject
nft_redir nft_quota nft_objref nft_numgen nft_nat nft_masq nft_log
nft_limit nft_hash nft_flow_offload nft_fib_ipv6 nft_fib_ipv4 nft_fib
nft_ct nft_counter nft_chain_nat nf_tables nf_nat nf_flow_table
nf_conntrack lzo slhc r8169 nfnetlink nf_reject_ipv6 nf_reject_ipv4
nf_log_syslog nf_defrag_ipv6 nf_defrag_ipv4 lzo_rle lzo_decompress
lzo_compress libcrc32c igc forcedeth e1000e crc_ccitt bnx2 i2c_dev
ixgbe e1000 amd_xgbe mdio nls_utf8 ena crypto_acompress nls_iso8859_1
nls_cp437 igb vfat fat button_hotplug tg3 ptp realtek pps_core mii
[   93.293844] ---[ end trace cf6cfea187f192b8 ]---
[   93.300503] RIP: 0010:dql_completed+0x175/0x180
[   93.307072] Code: 95 c2 45 84 d4 75 08 44 89 c2 e9 17 ff ff ff 45
85 db 79 f3 01 d2 45 89 c2 41 29 d2 ba 00 00 00 00 44 0f 48 d2 e9 7b
ff ff ff <0f> 0b cc cc cc cc cc cc cc cc cc 55 49 89 f2 48 89 f8 4d 8d
5a 01
[   93.329070] RSP: 0018:ffffc9000012ce10 EFLAGS: 00010297
[   93.336418] RAX: ffff8881030f8340 RBX: ffffc90000755cb0 RCX: 00000000000=
00042
[   93.345821] RDX: ffff888101e00000 RSI: 00000000000023be RDI: 00000000000=
43b73
[   93.355266] RBP: ffffc9000012cee8 R08: 0000000000000000 R09: 8bf25443d96=
e9830
[   93.364715] R10: 0000000000043b31 R11: 0000000000000000 R12: ffff8881031=
0cb80
[   93.374131] R13: 00000000ffffff3a R14: ffff8881030f8280 R15: 00000000000=
00000
[   93.383579] FS:  0000000000000000(0000) GS:ffff88903fe80000(0000)
knlGS:0000000000000000
[   93.394055] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   93.402072] CR2: 00007fd6f70df02c CR3: 000000000340a000 CR4: 00000000003=
50ee0
[   93.411583] Kernel panic - not syncing: Fatal exception in interrupt
[   93.420283] Kernel Offset: disabled
[   93.425950] Rebooting in 3 seconds..




[   39.107467] igc 0000:01:00.0 eth0: NIC Link is Down
[   39.117619] br-lan: port 1(eth0) entered disabled state
[   44.607761] igc 0000:01:00.0 eth0: NIC Link is Up 1000 Mbps Full
Duplex, Flow Control: RX
[   44.618409] br-lan: port 1(eth0) entered blocking state
[   44.625541] br-lan: port 1(eth0) entered forwarding state
[   54.752628] igc 0000:01:00.0 eth0: NIC Link is Down
[   54.761354] br-lan: port 1(eth0) entered disabled state
[   54.768615] igc 0000:01:00.0 eth0: Register Dump
[   54.775079] igc 0000:01:00.0 eth0: Register Name   Value
[   54.782251] igc 0000:01:00.0 eth0: CTRL            081c0641
[   54.789741] igc 0000:01:00.0 eth0: STATUS          00380681
[   54.797215] igc 0000:01:00.0 eth0: CTRL_EXT        100000c0
[   54.804672] igc 0000:01:00.0 eth0: MDIC            18017949
[   54.812112] igc 0000:01:00.0 eth0: ICR             00000001
[   54.819562] igc 0000:01:00.0 eth0: RCTL            0440803a
[   54.827014] igc 0000:01:00.0 eth0: RDLEN[0-3]      00001000
00001000 00001000 00001000
[   54.836977] igc 0000:01:00.0 eth0: RDH[0-3]        00000004
00000031 000000bc 00000044
[   54.846960] igc 0000:01:00.0 eth0: RDT[0-3]        00000003
00000030 000000bb 00000043
[   54.856970] igc 0000:01:00.0 eth0: RXDCTL[0-3]     02040808
02040808 02040808 02040808
[   54.866941] igc 0000:01:00.0 eth0: RDBAL[0-3]      045c1000
04485000 04424000 04484000
[   54.876917] igc 0000:01:00.0 eth0: RDBAH[0-3]      00000001
00000001 00000001 00000001
[   54.886889] igc 0000:01:00.0 eth0: TCTL            a503f0fa
[   54.894327] igc 0000:01:00.0 eth0: TDBAL[0-3]      04245000
045a8000 045eb000 0444e000
[   54.904304] igc 0000:01:00.0 eth0: TDBAH[0-3]      00000001
00000001 00000001 00000001
[   54.914243] igc 0000:01:00.0 eth0: TDLEN[0-3]      00001000
00001000 00001000 00001000
[   54.924199] igc 0000:01:00.0 eth0: TDH[0-3]        0000000e
000000cd 000000ed 00000058
[   54.934175] igc 0000:01:00.0 eth0: TDT[0-3]        0000000e
000000da 000000ed 000000a5
[   54.944100] igc 0000:01:00.0 eth0: TXDCTL[0-3]     02100108
02100108 02100108 02100108
[   54.954025] igc 0000:01:00.0 eth0: Reset adapter
[   59.629489] igc 0000:01:00.0 eth0: NIC Link is Up 1000 Mbps Full
Duplex, Flow Control: RX
[   59.639966] br-lan: port 1(eth0) entered blocking state
[   59.647007] br-lan: port 1(eth0) entered forwarding state
[   65.894810] i915 0000:00:02.0: [drm] Failed to load DMC firmware
i915/icl_dmc_ver1_09.bin. Disabling runtime power management.
[   65.908594] i915 0000:00:02.0: [drm] DMC firmware homepage:
https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git=
/tree/i915
[   66.867303] ------------[ cut here ]------------
[   66.876821] refcount_t: underflow; use-after-free.
[   66.885000] WARNING: CPU: 2 PID: 0 at refcount_warn_saturate+0xc2/0x110
[   66.893622] Modules linked in: pppoe ppp_async nft_fib_inet
nf_flow_table_ipv6 nf_flow_table_ipv4 nf_flow_table_inet pppox
ppp_generic nft_reject_ipv6 nft_reject_ipv4 nft_reject_inet nft_reject
nft_redir nft_quota nft_objref nft_numgen nft_nat nft_masq nft_log
nft_limit nft_hash nft_flow_offload nft_fib_ipv6 nft_fib_ipv4 nft_fib
nft_ct nft_counter nft_chain_nat nf_tables nf_nat nf_flow_table
nf_conntrack lzo slhc r8169 nfnetlink nf_reject_ipv6 nf_reject_ipv4
nf_log_syslog nf_defrag_ipv6 nf_defrag_ipv4 lzo_rle lzo_decompress
lzo_compress libcrc32c igc forcedeth e1000e crc_ccitt bnx2 i2c_dev
ixgbe e1000 amd_xgbe mdio nls_utf8 ena crypto_acompress nls_iso8859_1
nls_cp437 igb vfat fat button_hotplug tg3 ptp realtek pps_core mii
[   66.967573] CPU: 2 PID: 0 Comm: swapper/2 Not tainted 5.15.98 #0
[   66.975705] Hardware name: Default string Default string/Default
string, BIOS 5.19 09/23/2022
[   66.986562] RIP: 0010:refcount_warn_saturate+0xc2/0x110
[   66.993851] Code: 01 e8 39 a2 69 00 0f 0b 5d c3 cc cc cc cc 80 3d
e9 92 13 01 00 75 81 48 c7 c7 10 45 28 82 c6 05 d9 92 13 01 01 e8 15
a2 69 00 <0f> 0b 5d c3 cc cc cc cc 80 3d c3 92 13 01 00 0f 85 59 ff ff
ff 48
[   67.015855] RSP: 0018:ffffc90000158de8 EFLAGS: 00010292
[   67.023179] RAX: 0000000000000026 RBX: ffff888105008b00 RCX: 00000000000=
00000
[   67.032612] RDX: ffff88903ff1df20 RSI: ffff88903ff1c580 RDI: ffff88903ff=
1c580
[   67.042021] RBP: ffffc90000158de8 R08: 0000000000000000 R09: ffffc900001=
58bf0
[   67.051440] R10: ffffc90000158be8 R11: ffffffff824ae428 R12: ffff888101f=
efb80
[   67.060871] R13: 00000000ffffff81 R14: ffff88810444e810 R15: ffff8881044=
4e830
[   67.070300] FS:  0000000000000000(0000) GS:ffff88903ff00000(0000)
knlGS:0000000000000000
[   67.080762] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   67.088708] CR2: 00007f93a6e1bd9d CR3: 000000000340a000 CR4: 00000000003=
50ee0
[   67.098129] Call Trace:
[   67.102475]  <IRQ>
[   67.106859]  napi_consume_skb+0xdd/0x100
[   67.113246]  igc_down+0xf2c/0x2df0 [igc]
[   67.119508]  ? load_balance+0x139/0xa90
[   67.125506]  __napi_poll+0x43/0x130
[   67.131100]  net_rx_action+0x224/0x290
[   67.136910]  __do_softirq+0xc2/0x1ff
[   67.142471]  irq_exit_rcu+0x5e/0x90
[   67.147882]  common_interrupt+0x8e/0xa0
[   67.153671]  </IRQ>
[   67.157581]  <TASK>
[   67.161459]  asm_common_interrupt+0x27/0x40
[   67.167654] RIP: 0010:cpuidle_enter_state+0xbb/0x2d0
[   67.174773] Code: 9f 89 ff 65 8b 3d fd 44 7c 7e e8 70 9e 89 ff 31
ff 49 89 c6 e8 56 ab 89 ff 80 7d d7 00 0f 85 ab 01 00 00 fb 66 0f 1f
44 00 00 <45> 85 ff 0f 88 dc 00 00 00 49 63 cf 4c 8b 55 c8 48 8d 04 49
48 8d
[   67.196712] RSP: 0018:ffffc900000efe70 EFLAGS: 00000246
[   67.204081] RAX: ffff88903ff21b00 RBX: ffff88903ff2b000 RCX: 00000000000=
0001f
[   67.213493] RDX: 0000000f9199ee36 RSI: 0000000046ec0743 RDI: 00000000000=
00000
[   67.222855] RBP: ffffc900000efea8 R08: 0000000000000000 R09: 00000000000=
00009
[   67.232270] R10: 0000000f91889923 R11: 0000000000000000 R12: 00000000000=
00002
[   67.241618] R13: ffffffff824cd680 R14: 0000000f9199ee36 R15: 00000000000=
00002
[   67.250989]  cpuidle_enter+0x2f/0x50
[   67.256506]  call_cpuidle+0x1e/0x40
[   67.261906]  do_idle+0x15c/0x180
[   67.267050]  cpu_startup_entry+0x18/0x20
[   67.272924]  start_secondary+0xf9/0x110
[   67.278690]  secondary_startup_64_no_verify+0xb0/0xbb
[   67.285814]  </TASK>
[   67.289779] ---[ end trace c9ee4679924ad6e2 ]---
[   73.307596] ------------[ cut here ]------------
[   73.317713] Kernel BUG at dql_completed+0x175/0x180 [verbose debug
info unavailable]
[   73.328905] invalid opcode: 0000 [#1] SMP NOPTI
[   73.335488] CPU: 2 PID: 0 Comm: swapper/2 Tainted: G        W
  5.15.98 #0
[   73.345150] Hardware name: Default string Default string/Default
string, BIOS 5.19 09/23/2022
[   73.356034] RIP: 0010:dql_completed+0x175/0x180
[   73.362604] Code: 95 c2 45 84 d4 75 08 44 89 c2 e9 17 ff ff ff 45
85 db 79 f3 01 d2 45 89 c2 41 29 d2 ba 00 00 00 00 44 0f 48 d2 e9 7b
ff ff ff <0f> 0b cc cc cc cc cc cc cc cc cc 55 49 89 f2 48 89 f8 4d 8d
5a 01
[   73.384660] RSP: 0018:ffffc90000158e10 EFLAGS: 00010283
[   73.392238] RAX: ffff888102d48c80 RBX: ffffc90000753370 RCX: 00000000000=
00a2a
[   73.401708] RDX: ffff888102d50000 RSI: 0000000000001014 RDI: 00000000001=
5e0a8
[   73.411167] RBP: ffffc90000158ee8 R08: 0000000000000000 R09: 00000000000=
00100
[   73.420606] R10: 000000000015d67e R11: 0000000000000000 R12: ffff888101f=
efb80
[   73.430026] R13: 00000000ffffffa2 R14: ffff888102d48bc0 R15: 00000000000=
00000
[   73.439434] FS:  0000000000000000(0000) GS:ffff88903ff00000(0000)
knlGS:0000000000000000
[   73.450024] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   73.457972] CR2: 00007f66eaeed000 CR3: 000000000340a000 CR4: 00000000003=
50ee0
[   73.467426] Call Trace:
[   73.471837]  <IRQ>
[   73.475749]  ? igc_down+0xb05/0x2df0 [igc]
[   73.481925]  __napi_poll+0x43/0x130
[   73.487442]  net_rx_action+0x224/0x290
[   73.493226]  __do_softirq+0xc2/0x1ff
[   73.498812]  irq_exit_rcu+0x5e/0x90
[   73.504305]  common_interrupt+0x8e/0xa0
[   73.510203]  </IRQ>
[   73.514193]  <TASK>
[   73.518166]  asm_common_interrupt+0x27/0x40
[   73.524381] RIP: 0010:cpuidle_enter_state+0xbb/0x2d0
[   73.531502] Code: 9f 89 ff 65 8b 3d fd 44 7c 7e e8 70 9e 89 ff 31
ff 49 89 c6 e8 56 ab 89 ff 80 7d d7 00 0f 85 ab 01 00 00 fb 66 0f 1f
44 00 00 <45> 85 ff 0f 88 dc 00 00 00 49 63 cf 4c 8b 55 c8 48 8d 04 49
48 8d
[   73.553573] RSP: 0018:ffffc900000efe70 EFLAGS: 00000246
[   73.561040] RAX: ffff88903ff21b00 RBX: ffff88903ff2b000 RCX: 00000000000=
0001f
[   73.570568] RDX: 0000001111777ffd RSI: 0000000046ec0743 RDI: 00000000000=
00000
[   73.580133] RBP: ffffc900000efea8 R08: 0000000000000000 R09: ffff888100c=
13200
[   73.589705] R10: 0000001111741bf8 R11: 0000000000000008 R12: 00000000000=
00003
[   73.599200] R13: ffffffff824cd680 R14: 0000001111777ffd R15: 00000000000=
00003
[   73.608723]  cpuidle_enter+0x2f/0x50
[   73.614394]  call_cpuidle+0x1e/0x40
[   73.619994]  do_idle+0x15c/0x180
[   73.625265]  cpu_startup_entry+0x18/0x20
[   73.631425]  start_secondary+0xf9/0x110
[   73.637320]  secondary_startup_64_no_verify+0xb0/0xbb
[   73.644584]  </TASK>
[   73.648664] Modules linked in: pppoe ppp_async nft_fib_inet
nf_flow_table_ipv6 nf_flow_table_ipv4 nf_flow_table_inet pppox
ppp_generic nft_reject_ipv6 nft_reject_ipv4 nft_reject_inet nft_reject
nft_redir nft_quota nft_objref nft_numgen nft_nat nft_masq nft_log
nft_limit nft_hash nft_flow_offload nft_fib_ipv6 nft_fib_ipv4 nft_fib
nft_ct nft_counter nft_chain_nat nf_tables nf_nat nf_flow_table
nf_conntrack lzo slhc r8169 nfnetlink nf_reject_ipv6 nf_reject_ipv4
nf_log_syslog nf_defrag_ipv6 nf_defrag_ipv4 lzo_rle lzo_decompress
lzo_compress libcrc32c igc forcedeth e1000e crc_ccitt bnx2 i2c_dev
ixgbe e1000 amd_xgbe mdio nls_utf8 ena crypto_acompress nls_iso8859_1
nls_cp437 igb vfat fat button_hotplug tg3 ptp realtek pps_core mii
[   73.723618] ---[ end trace c9ee4679924ad6e3 ]---
[   73.730427] RIP: 0010:dql_completed+0x175/0x180
[   73.737086] Code: 95 c2 45 84 d4 75 08 44 89 c2 e9 17 ff ff ff 45
85 db 79 f3 01 d2 45 89 c2 41 29 d2 ba 00 00 00 00 44 0f 48 d2 e9 7b
ff ff ff <0f> 0b cc cc cc cc cc cc cc cc cc 55 49 89 f2 48 89 f8 4d 8d
5a 01
[   73.759178] RSP: 0018:ffffc90000158e10 EFLAGS: 00010283
[   73.766611] RAX: ffff888102d48c80 RBX: ffffc90000753370 RCX: 00000000000=
00a2a
[   73.776135] RDX: ffff888102d50000 RSI: 0000000000001014 RDI: 00000000001=
5e0a8
[   73.785548] RBP: ffffc90000158ee8 R08: 0000000000000000 R09: 00000000000=
00100
[   73.794970] R10: 000000000015d67e R11: 0000000000000000 R12: ffff888101f=
efb80
[   73.804368] R13: 00000000ffffffa2 R14: ffff888102d48bc0 R15: 00000000000=
00000
[   73.813801] FS:  0000000000000000(0000) GS:ffff88903ff00000(0000)
knlGS:0000000000000000
[   73.824227] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   73.832137] CR2: 00007f66eaeed000 CR3: 000000000340a000 CR4: 00000000003=
50ee0
[   73.841581] Kernel panic - not syncing: Fatal exception in interrupt
[   73.850251] Kernel Offset: disabled
[   73.855836] Rebooting in 3 seconds..


On Mon, Feb 6, 2023 at 11:23=E2=80=AFPM Kyle Sanderson <kyle.leet@gmail.com=
> wrote:
>
> hi Intel IGC Maintainers,
>
> Is there any update on this? Can I help test a patch?
>
> Kyle.
>
> On Sun, Jan 15, 2023 at 1:13 AM Ruinskiy, Dima <dima.ruinskiy@intel.com> =
wrote:
> >
> > On 13/01/2023 22:33, Kyle Sanderson wrote:
> > >> On Wednesday, January 11, 2023, Ruinskiy, Dima <dima.ruinskiy@intel.=
com> wrote:
> > >> We are going to try to get a reliable reproduction internally, based=
 on the instructions provided, to simplify triage and debug.
> > >
> > > Understood, thank you Dima.
> > >
> > >> Could you share the exact model of the retail appliance you are usin=
g, just in case I can locate someone here with a similar device?
> > >
> > > https://www.servethehome.com/intel-celeron-j6413-powered-6x-i226-2-5g=
be-fanless-firewall-review/
> > >
> > > These boxes (like the protectli) boxes all ship with BSD. I know the
> > > IPS cases are private - were you able to connect with the group
> > > working on that? (Sureshkumar cc'd was in the to: field.)
> > >
> > > Kyle.
> >
> > We are indeed working with Sureshkumar.
> >
> > Thank you for sharing the box details. I hope we can achieve quality
> > debug with the existing platforms we have in house, but it is always
> > good to know what else is out there. :)
> >
> > --Dima
> >
> > >
> > > On Wednesday, January 11, 2023, Ruinskiy, Dima <dima.ruinskiy@intel.c=
om> wrote:
> > >> Hey Kyle,
> > >>
> > >> We are going to try to get a reliable reproduction internally, based=
 on the instructions provided, to simplify triage and debug.
> > >>
> > >> Could you share the exact model of the retail appliance you are usin=
g, just in case I can locate someone here with a similar device?
> > >>
> > >> Thanks,
> > >> Dima.
> > >>
> > >> On 04/01/2023 7:23, Kyle Sanderson wrote:
> > >>>
> > >>> hi Intel IGC Maintainers,
> > >>>
> > >>> I know a very kind gentleman from a large networking vendor reached
> > >>> out last week to a group on here saying they're seeing something
> > >>> eerily similar to this failure (and that they have an IPS case open=
).
> > >>>
> > >>> Is there any additional information that you're looking for that I =
can
> > >>> help with? One of my colleagues just had his UFS install corrupt
> > >>> itself, so having non-panic'ing Linux support is still very much-so
> > >>> desired.
> > >>>
> > >>> Kyle.
> > >>>
> > >>> On Thu, Dec 29, 2022 at 4:49 PM Kyle Sanderson <kyle.leet@gmail.com=
> wrote:
> > >>>>
> > >>>> On Thu, Dec 29, 2022 at 1:21 AM MP, Sureshkumar
> > >>>> <sureshkumar.mp@intel.com> wrote:
> > >>>>>
> > >>>>> 1. Can you share the HW and SW BKC used to do this experiment?
> > >>>>
> > >>>> This is a retail appliance. They ship with FBSD out of the box
> > >>>> (OPNsense / pfSense), or a Windows OS. I'm hoping we can fix Linux
> > >>>> support for these.
> > >>>> The NICs are embedded on the board, as to the bus they're using it=
's
> > >>>> beyond me as an end consumer (basically an stb with a console port=
).
> > >>>>
> > >>>>> 2. How about this test results with i225 AIC on these kernels?
> > >>>>
> > >>>> I don't have this controller, but now that we know the steps to
> > >>>> reproduce (enable IP Forwarding and send traffic until buffering
> > >>>> happens) it should be reproducible by anyone.
> > >>>>
> > >>>>> 3. Did you test this with kernel.org igc driver code on these ker=
nels? If yes, share the results.
> > >>>>
> > >>>> Yes. Kernel panic'd (from the BUG_ON) on 5.10, 5.15, and 6.0.
> > >>>>
> > >>>>> 4. How did you connect 6x i226 AICs in the EHL board?
> > >>>>
> > >>>> Port 1 and Port 6. Using the ports independently doesn't seem to
> > >>>> reproduce the issue, and is only when traffic is forwarded between
> > >>>> them.
> > >>>>
> > >>>>> 5. Did you test with 1x i226 AIC on these kernels in EHL board?
> > >>>>
> > >>>> Yes, the problem does not persist. 2 NICs need to be used (on igc)=
,
> > >>>> with traffic passing between them.
> > >>>>
> > >>>> K.
> > >>>>
> > >>>> On Thu, Dec 29, 2022 at 1:21 AM MP, Sureshkumar
> > >>>> <sureshkumar.mp@intel.com> wrote:
> > >>>>>
> > >>>>> Ok K.
> > >>>>>
> > >>>>> 1. Can you share the HW and SW BKC used to do this experiment?
> > >>>>> 2. How about this test results with i225 AIC on these kernels?
> > >>>>> 3. Did you test this with kernel.org igc driver code on these ker=
nels? If yes, share the results.
> > >>>>> 4. How did you connect 6x i226 AICs in the EHL board?
> > >>>>> 5. Did you test with 1x i226 AIC on these kernels in EHL board?
> > >>>>>
> > >>>>> Best Regards,
> > >>>>> Sureshkumar
> > >>>>>
> > >>>>> -----Original Message-----
> > >>>>> From: Kyle Sanderson <kyle.leet@gmail.com>
> > >>>>> Sent: Thursday, December 29, 2022 9:58 AM
> > >>>>> To: MP, Sureshkumar <sureshkumar.mp@intel.com>
> > >>>>> Cc: Neftin, Sasha <sasha.neftin@intel.com>; intel-wired-lan@lists=
.osuosl.org; Ruinskiy, Dima <dima.ruinskiy@intel.com>; Avivi, Amir <amir.av=
ivi@intel.com>; Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Ant=
hony L <anthony.l.nguyen@intel.com>; Linux-Kernel <linux-kernel@vger.kernel=
.org>; Torvalds, Linus <torvalds@linux-foundation.org>; netdev@vger.kernel.=
org; Lifshits, Vitaly <vitaly.lifshits@intel.com>; naamax.meir <naamax.meir=
@linux.intel.com>; Greg KH <gregkh@linuxfoundation.org>
> > >>>>> Subject: Re: [Intel-wired-lan] igc: 5.10.146 Kernel BUG at 0xffff=
ffff813ce19f
> > >>>>>
> > >>>>> On Wed, Dec 28, 2022 at 8:12 PM MP, Sureshkumar <sureshkumar.mp@i=
ntel.com> wrote:
> > >>>>>>
> > >>>>>> Not getting the exact issue here. Can someone explain what is th=
e issue with i226 in EHL platform?
> > >>>>>>
> > >>>>>> Best Regards,
> > >>>>>> Sureshkumar
> > >>>>>
> > >>>>> hi Sureshkumar,
> > >>>>>
> > >>>>> If you forward traffic on an igc kmod NIC the kernel will panic w=
ith the call traces provided from the three different kernel versions.
> > >>>>> This happens when there's traffic passing through the nic, and th=
e cable is removed. When the cable is returned to the device, the panic occ=
urs. Each controller (as far as I'm aware) is exposed as a standalone devic=
e.
> > >>>>>
> > >>>>> This has never worked on 5.10, 5.15, or 6.0 kernels. There is no =
device support on 5.4, so I can't test that far back unfortunately. We also=
 don't know if it's exclusive to this phy, or if it's impacting other devic=
es using the kmod.
> > >>>>>
> > >>>>> K.
> > >>>>>
> > >>>>> On Wed, Dec 28, 2022 at 8:12 PM MP, Sureshkumar <sureshkumar.mp@i=
ntel.com> wrote:
> > >>>>>>
> > >>>>>> Not getting the exact issue here. Can someone explain what is th=
e issue with i226 in EHL platform?
> > >>>>>>
> > >>>>>> Best Regards,
> > >>>>>> Sureshkumar
> > >>>>>>
> > >>>>>> -----Original Message-----
> > >>>>>> From: Kyle Sanderson <kyle.leet@gmail.com>
> > >>>>>> Sent: Thursday, December 29, 2022 8:18 AM
> > >>>>>> To: Neftin, Sasha <sasha.neftin@intel.com>;
> > >>>>>> intel-wired-lan@lists.osuosl.org; Ruinskiy, Dima
> > >>>>>> <dima.ruinskiy@intel.com>; Avivi, Amir <amir.avivi@intel.com>
> > >>>>>> Cc: Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anth=
ony L
> > >>>>>> <anthony.l.nguyen@intel.com>; MP, Sureshkumar
> > >>>>>> <sureshkumar.mp@intel.com>; Linux-Kernel
> > >>>>>> <linux-kernel@vger.kernel.org>; Torvalds, Linus
> > >>>>>> <torvalds@linux-foundation.org>; netdev@vger.kernel.org; Lifshit=
s,
> > >>>>>> Vitaly <vitaly.lifshits@intel.com>; naamax.meir
> > >>>>>> <naamax.meir@linux.intel.com>; Greg KH <gregkh@linuxfoundation.o=
rg>;
> > >>>>>> therbert@google.com
> > >>>>>> Subject: Re: [Intel-wired-lan] igc: 5.10.146 Kernel BUG at
> > >>>>>> 0xffffffff813ce19f
> > >>>>>>
> > >>>>>> On Wed, Dec 28, 2022 at 2:34 PM Kyle Sanderson <kyle.leet@gmail.=
com> wrote:
> > >>>>>>>
> > >>>>>>> On Tue, Dec 27, 2022 at 11:07 PM Neftin, Sasha <sasha.neftin@in=
tel.com> wrote:
> > >>>>>>>>
> > >>>>>>>> 1. Does the problem reproduce on the latest upstream kernel?(w=
orth
> > >>>>>>>> to check)
> > >>>>>>>
> > >>>>>>> The box is a bit problematic to try things on (it's all done th=
rough
> > >>>>>>> the COM port).
> > >>>>>>> Will try spinning an image for retail and seeing if it continue=
s (I
> > >>>>>>> did go back and look at the commits, post 5.15 the diffs looked=
 like
> > >>>>>>> cleanups).
> > >>>>>>
> > >>>>>> Yes, this is reproducible on 6.0.7. What I noticed though is, wh=
en the device is operating in client mode (Fedora), I cannot reproduce the =
panic.
> > >>>>>>
> > >>>>>> The only way I was able to reproduce the panic was forwarding tr=
affic from another device, which was confirmed by turning on IP forwarding =
and passing traffic from another asset (using the same fast.com test, this =
time on Fedora). Which means (I believe), this should be reproducible on Du=
al / Quad port NICs using igc as long as they're routing traffic through th=
e same card.
> > >>>>>>
> > >>>>>> Based on the relatively recent availability of the phy, and most
> > >>>>>> (noted) consumers using this single port onboard from a OEM it w=
ould be more difficult to encounter in the wild.
> > >>>>>>
> > >>>>>> Thank you very much for your help so far.
> > >>>>>>
> > >>>>>> K.
> > >>>>>>
> > >>>>>> On Wed, Dec 28, 2022 at 2:34 PM Kyle Sanderson <kyle.leet@gmail.=
com> wrote:
> > >>>>>>>
> > >>>>>>> On Tue, Dec 27, 2022 at 11:07 PM Neftin, Sasha <sasha.neftin@in=
tel.com> wrote:
> > >>>>>>>>
> > >>>>>>>> I do not know if it is an SW problem.
> > >>>>>>>
> > >>>>>>> I'm not experiencing the same failure on FBSD, so it's quite li=
kely
> > >>>>>>> software (somewhere :-)).
> > >>>>>>>
> > >>>>>>>> 1. Does the problem reproduce on the latest upstream kernel?(w=
orth
> > >>>>>>>> to check)
> > >>>>>>>
> > >>>>>>> The box is a bit problematic to try things on (it's all done th=
rough
> > >>>>>>> the COM port).
> > >>>>>>> Will try spinning an image for retail and seeing if it continue=
s (I
> > >>>>>>> did go back and look at the commits, post 5.15 the diffs looked=
 like
> > >>>>>>> cleanups).
> > >>>>>>>
> > >>>>>>>> 2. I do not see this crash in our labs. I haven't a platform w=
ith
> > >>>>>>>> six
> > >>>>>>>> i226 parts.(Trying find folks who work with this platform.)
> > >>>>>>>
> > >>>>>>> I'm not sure this (port count) is related. How I'm reproducing =
the
> > >>>>>>> issue now is simply going to fast.com on a client with aggressi=
ve
> > >>>>>>> settings (20cons minimum, 90s test duration), waiting until it
> > >>>>>>> starts to buffer (latency increases, so packets are being defer=
red /
> > >>>>>>> scheduled) then removing the ethernet cable from the laptop. Th=
e
> > >>>>>>> device seems to operate indefinitely in this mode, and only whe=
n the
> > >>>>>>> link comes back up, and traffic is sent again, do these kernels=
 panic.
> > >>>>>>> It doesn't seem to matter how long the cable is disconnected fo=
r
> > >>>>>>> (another trace below where I did it for 30s). If the resets are=
 fast
> > >>>>>>> enough, the failure seemed less likely to occur.
> > >>>>>>>
> > >>>>>>>> 3. I am working on a patch to address .ndo_tx_timeout support.
> > >>>>>>>> (pass the reset task to netdev while the link disconnected dur=
ing
> > >>>>>>>> traffic, under testing). It could be related and worth checkin=
g -
> > >>>>>>>> please, let me know if you want to apply on your platform (aga=
inst upstream).
> > >>>>>>>> Reach us (Dima, Amir, and me) directly off the list.
> > >>>>>>>
> > >>>>>>> Will try pending outcome on #1, If you can target the latest st=
able
> > >>>>>>> RC that you're aware of that would be appreciated.
> > >>>>>>>
> > >>>>>>> [   62.209563] igc 0000:01:00.0 eth0: Reset adapter
> > >>>>>>> [   89.560331] kernel BUG at lib/dynamic_queue_limits.c:27!
> > >>>>>>> [   89.567779] invalid opcode: 0000 [#1] SMP NOPTI
> > >>>>>>> [   89.573229] CPU: 3 PID: 0 Comm: swapper/3 Not tainted 5.15.8=
5-amd64-vyos #1
> > >>>>>>> [   89.579989] ------------[ cut here ]------------
> > >>>>>>> [   89.581328] Hardware name: Default string Default string/Def=
ault
> > >>>>>>> string, BIOS 5.19 09/23/2022
> > >>>>>>> [   89.581329] RIP: 0010:dql_completed+0x12f/0x140
> > >>>>>>> [   89.586873] kernel BUG at lib/dynamic_queue_limits.c:27!
> > >>>>>>> [   89.596627] Code: cf c9 00 48 89 57 58 e9 54 ff ff ff 85 ed =
40 0f
> > >>>>>>> 95 c5 41 39 d8 41 0f 95 c0 44 84 c5 74 04 85 d2 78 0a 44 89 d8 =
e9 36
> > >>>>>>> ff ff ff <0f> 0b 01 f6 44 89 da 29 f2 0f 48 d0 eb 8d cc cc cc 4=
1 56
> > >>>>>>> 49
> > >>>>>>> 89 f3
> > >>>>>>> [   89.596630] RSP: 0018:ffffb3324018ce20 EFLAGS: 00010283
> > >>>>>>> [   89.636568] RAX: 0000000000000003 RBX: ffff97640754eb40 RCX:=
 0000000000000036
> > >>>>>>> [   89.644842] RDX: ffff976407704000 RSI: 0000000000000620 RDI:=
 ffff976407708c80
> > >>>>>>> [   89.653108] RBP: 0000000000000000 R08: 000000000000a1f0 R09:=
 da49cae6d4ba44ce
> > >>>>>>> [   89.661379] R10: 000000000000a226 R11: ffffffffa05fee80 R12:=
 0000000000000620
> > >>>>>>> [   89.669657] R13: ffff97640754eb40 R14: ffffb33240cf9540 R15:=
 00000000ffffff18
> > >>>>>>> [   89.677942] FS:  0000000000000000(0000) GS:ffff97733ff80000(=
0000)
> > >>>>>>> knlGS:0000000000000000
> > >>>>>>> [   89.687275] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003=
3
> > >>>>>>> [   89.694065] CR2: 00007f6c7c9e9b40 CR3: 000000064f610000 CR4:=
 0000000000350ee0
> > >>>>>>> [   89.702353] Call Trace:
> > >>>>>>> [   89.705549]  <IRQ>
> > >>>>>>> [   89.708269]  igc_poll+0x19d/0x14b0 [igc]
> > >>>>>>> [   89.713073]  ? __ip_finish_output+0xc0/0x1a0
> > >>>>>>> [   89.718255]  ? __netif_receive_skb_one_core+0x86/0xa0
> > >>>>>>> [   89.724269]  __napi_poll+0x22/0x110
> > >>>>>>> [   89.728597]  net_rx_action+0xe9/0x250
> > >>>>>>> [   89.733093]  ? igc_msix_ring+0x51/0x60 [igc]
> > >>>>>>> [   89.738230]  __do_softirq+0xb8/0x1e9
> > >>>>>>> [   89.742616]  irq_exit_rcu+0x84/0xb0
> > >>>>>>> [   89.746915]  common_interrupt+0x78/0x90
> > >>>>>>> [   89.751566]  </IRQ>
> > >>>>>>> [   89.754323]  <TASK>
> > >>>>>>> [   89.757070]  asm_common_interrupt+0x22/0x40
> > >>>>>>> [   89.762066] RIP: 0010:cpuidle_enter_state+0xb5/0x2a0
> > >>>>>>> [   89.767931] Code: c1 48 b2 ff 65 8b 3d b2 58 a9 60 e8 65 47 =
b2 ff
> > >>>>>>> 31 ff 49 89 c5 e8 6b 52 b2 ff 45 84 f6 0f 85 85 01 00 00 fb 66 =
0f 1f
> > >>>>>>> 44 00 00 <45> 85 ff 0f 88 bb 00 00 00 49 63 c7 4c 2b 2c 24 48 8=
d 14
> > >>>>>>> 40
> > >>>>>>> 48 8d
> > >>>>>>> [   89.789731] RSP: 0018:ffffb332400ffea8 EFLAGS: 00000246
> > >>>>>>> [   89.795904] RAX: ffff97733ffa3440 RBX: 0000000000000003 RCX:=
 000000000000001f
> > >>>>>>> [   89.804138] RDX: 0000000000000000 RSI: 0000000046ec0743 RDI:=
 0000000000000000
> > >>>>>>> [   89.812376] RBP: ffff97733ffac910 R08: 00000014da35607b R09:=
 00000014bbdae179
> > >>>>>>> [   89.820594] R10: 00000000000000e2 R11: 000000000000357c R12:=
 ffffffffa00ccb40
> > >>>>>>> [   89.828795] R13: 00000014da35607b R14: 0000000000000000 R15:=
 0000000000000003
> > >>>>>>> [   89.837026]  ? cpuidle_enter_state+0xa5/0x2a0
> > >>>>>>> [   89.842226]  cpuidle_enter+0x24/0x40
> > >>>>>>> [   89.846558]  do_idle+0x1e4/0x280
> > >>>>>>> [   89.850516]  cpu_startup_entry+0x14/0x20
> > >>>>>>> [   89.855223]  secondary_startup_64_no_verify+0xb0/0xbb
> > >>>>>>> [   89.861153]  </TASK>
> > >>>>>>> [   89.863953] Modules linked in: wireguard curve25519_x86_64
> > >>>>>>> libcurve25519_generic libchacha20poly1305 chacha_x86_64
> > >>>>>>> poly1305_x86_64 ip6_udp_tunnel udp_tunnel libchacha vrf nft_mas=
q
> > >>>>>>> nf_nat_tftp nf_conntrack_tftp nf_nat_sip nf_conntrack_sip
> > >>>>>>> nf_nat_pptp nf_conntrack_pptp nf_nat_h323 nf_conntrack_h323
> > >>>>>>> nf_nat_ftp nf_conntrack_ftp nft_objref nft_counter nft_ct
> > >>>>>>> nft_chain_nat nf_nat nf_tables nfnetlink_cthelper nf_conntrack
> > >>>>>>> nf_defrag_ipv6
> > >>>>>>> nf_defrag_ipv4 libcrc32c nfnetlink af_packet x86_pkg_temp_therm=
al
> > >>>>>>> intel_powerclamp coretemp crct10dif_pclmul crc32_pclmul
> > >>>>>>> ghash_clmulni_intel aesni_intel crypto_simd cryptd intel_cstate
> > >>>>>>> iTCO_wdt evdev mei_me pcspkr efi_pstore iTCO_vendor_support mei=
 sg
> > >>>>>>> tpm_crb tpm_tis tpm_tis_core tpm rng_core button acpi_pad
> > >>>>>>> mpls_iptunnel mpls_router ip_tunnel br_netfilter bridge stp llc=
 fuse
> > >>>>>>> configfs efivarfs ip_tables x_tables autofs4 usb_storage ohci_h=
cd
> > >>>>>>> uhci_hcd ehci_hcd squashfs zstd_decompress lz4_decompress loop
> > >>>>>>> overlay
> > >>>>>>> ext4 crc32c_generic crc16 mbcache jbd2 nls_cp437
> > >>>>>>> [   89.864000]  vfat fat efivars nls_ascii hid_generic usbhid h=
id
> > >>>>>>> sd_mod t10_pi xhci_pci ahci libahci libata crc32c_intel i2c_i80=
1
> > >>>>>>> i2c_smbus scsi_mod igc xhci_hcd scsi_common thermal fan
> > >>>>>>> [   89.982932] invalid opcode: 0000 [#2] SMP NOPTI
> > >>>>>>> [   89.982934] ---[ end trace b0c0da59c18b279b ]---
> > >>>>>>> [   89.988461] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G      D
> > >>>>>>>     5.15.85-amd64-vyos #1
> > >>>>>>> [   90.031995] Hardware name: Default string Default string/Def=
ault
> > >>>>>>> string, BIOS 5.19 09/23/2022
> > >>>>>>> [   90.079903] RIP: 0010:dql_completed+0x12f/0x140
> > >>>>>>> [   90.099780] RIP: 0010:dql_completed+0x12f/0x140
> > >>>>>>> [   90.101151] Code: cf c9 00 48 89 57 58 e9 54 ff ff ff 85 ed =
40 0f
> > >>>>>>> 95 c5 41 39 d8 41 0f 95 c0 44 84 c5 74 04 85 d2 78 0a 44 89 d8 =
e9 36
> > >>>>>>> ff ff ff <0f> 0b 01 f6 44 89 da 29 f2 0f 48 d0 eb 8d cc cc cc 4=
1 56
> > >>>>>>> 49
> > >>>>>>> 89 f3
> > >>>>>>> [   90.106717] Code: cf c9 00 48 89 57 58 e9 54 ff ff ff 85 ed =
40 0f
> > >>>>>>> 95 c5 41 39 d8 41 0f 95 c0 44 84 c5 74 04 85 d2 78 0a 44 89 d8 =
e9 36
> > >>>>>>> ff ff ff <0f> 0b 01 f6 44 89 da 29 f2 0f 48 d0 eb 8d cc cc cc 4=
1 56
> > >>>>>>> 49
> > >>>>>>> 89 f3
> > >>>>>>> [   90.129020] RSP: 0018:ffffb33240003e20 EFLAGS: 00010293
> > >>>>>>> [   90.151344] RSP: 0018:ffffb3324018ce20 EFLAGS: 00010283
> > >>>>>>> [   90.157686] RAX: 0000000000000000 RBX: ffff97640754bb40 RCX:=
 0000000000000bd4
> > >>>>>>> [   90.157686]
> > >>>>>>> [   90.157687] RDX: ffff976407704000 RSI: 0000000000002966 RDI:=
 ffff9764077088c0
> > >>>>>>> [   90.164026] RAX: 0000000000000003 RBX: ffff97640754eb40 RCX:=
 0000000000000036
> > >>>>>>> [   90.172433] RBP: 0000000000000000 R08: 000000000002bdba R09:=
 0000000000000000
> > >>>>>>> [   90.174719] RDX: ffff976407704000 RSI: 0000000000000620 RDI:=
 ffff976407708c80
> > >>>>>>> [   90.183146] R10: 000000000002c98e R11: ffffffffa05fee80 R12:=
 0000000000002966
> > >>>>>>> [   90.191560] RBP: 0000000000000000 R08: 000000000000a1f0 R09:=
 da49cae6d4ba44ce
> > >>>>>>> [   90.199977] R13: ffff97640754bb40 R14: ffffb3324087d4c0 R15:=
 00000000ffffffa8
> > >>>>>>> [   90.208382] R10: 000000000000a226 R11: ffffffffa05fee80 R12:=
 0000000000000620
> > >>>>>>> [   90.216792] FS:  0000000000000000(0000) GS:ffff97733fe00000(=
0000)
> > >>>>>>> knlGS:0000000000000000
> > >>>>>>> [   90.225213] R13: ffff97640754eb40 R14: ffffb33240cf9540 R15:=
 00000000ffffff18
> > >>>>>>> [   90.233641] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003=
3
> > >>>>>>> [   90.242058] FS:  0000000000000000(0000) GS:ffff97733ff80000(=
0000)
> > >>>>>>> knlGS:0000000000000000
> > >>>>>>> [   90.251492] CR2: 00007f6097a90010 CR3: 0000000101468000 CR4:=
 0000000000350ef0
> > >>>>>>> [   90.259887] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003=
3
> > >>>>>>> [   90.266776] Call Trace:
> > >>>>>>> [   90.276193] CR2: 00007f6c7c9e9b40 CR3: 0000000104378000 CR4:=
 0000000000350ee0
> > >>>>>>> [   90.284596]  <IRQ>
> > >>>>>>> [   90.284597]  igc_poll+0x19d/0x14b0 [igc]
> > >>>>>>> [   90.291475] Kernel panic - not syncing: Fatal exception in i=
nterrupt
> > >>>>>>> [   90.294754]  __napi_poll+0x22/0x110
> > >>>>>>> [   90.322584]  net_rx_action+0xe9/0x250
> > >>>>>>> [   90.327118]  ? igc_msix_ring+0x51/0x60 [igc]
> > >>>>>>> [   90.332311]  __do_softirq+0xb8/0x1e9
> > >>>>>>> [   90.336716]  irq_exit_rcu+0x84/0xb0
> > >>>>>>> [   90.341031]  common_interrupt+0x78/0x90
> > >>>>>>> [   90.345725]  </IRQ>
> > >>>>>>> [   90.348534]  <TASK>
> > >>>>>>> [   90.351325]  asm_common_interrupt+0x22/0x40
> > >>>>>>> [   90.356365] RIP: 0010:cpuidle_enter_state+0xb5/0x2a0
> > >>>>>>> [   90.362239] Code: c1 48 b2 ff 65 8b 3d b2 58 a9 60 e8 65 47 =
b2 ff
> > >>>>>>> 31 ff 49 89 c5 e8 6b 52 b2 ff 45 84 f6 0f 85 85 01 00 00 fb 66 =
0f 1f
> > >>>>>>> 44 00 00 <45> 85 ff 0f 88 bb 00 00 00 49 63 c7 4c 2b 2c 24 48 8=
d 14
> > >>>>>>> 40
> > >>>>>>> 48 8d
> > >>>>>>> [   90.384058] RSP: 0018:ffffffffa0003e60 EFLAGS: 00000246
> > >>>>>>> [   90.390221] RAX: ffff97733fe23440 RBX: 0000000000000001 RCX:=
 000000000000001f
> > >>>>>>> [   90.398453] RDX: 0000000000000000 RSI: 0000000046ec0743 RDI:=
 0000000000000000
> > >>>>>>> [   90.406695] RBP: ffff97733fe2c910 R08: 00000014db620c58 R09:=
 0000000000000018
> > >>>>>>> [   90.414928] R10: 0000000000000259 R11: 00000000000000da R12:=
 ffffffffa00ccb40
> > >>>>>>> [   90.423151] R13: 00000014db620c58 R14: 0000000000000000 R15:=
 0000000000000001
> > >>>>>>> [   90.431387]  cpuidle_enter+0x24/0x40
> > >>>>>>> [   90.435751]  do_idle+0x1e4/0x280
> > >>>>>>> [   90.439733]  cpu_startup_entry+0x14/0x20
> > >>>>>>> [   90.444462]  start_kernel+0x627/0x650
> > >>>>>>> [   90.448909]  secondary_startup_64_no_verify+0xb0/0xbb
> > >>>>>>> [   90.454863]  </TASK>
> > >>>>>>> [   90.457714] Modules linked in: wireguard curve25519_x86_64
> > >>>>>>> libcurve25519_generic libchacha20poly1305 chacha_x86_64
> > >>>>>>> poly1305_x86_64 ip6_udp_tunnel udp_tunnel libchacha vrf nft_mas=
q
> > >>>>>>> nf_nat_tftp nf_conntrack_tftp nf_nat_sip nf_conntrack_sip
> > >>>>>>> nf_nat_pptp nf_conntrack_pptp nf_nat_h323 nf_conntrack_h323
> > >>>>>>> nf_nat_ftp nf_conntrack_ftp nft_objref nft_counter nft_ct
> > >>>>>>> nft_chain_nat nf_nat nf_tables nfnetlink_cthelper nf_conntrack
> > >>>>>>> nf_defrag_ipv6
> > >>>>>>> nf_defrag_ipv4 libcrc32c nfnetlink af_packet x86_pkg_temp_therm=
al
> > >>>>>>> intel_powerclamp coretemp crct10dif_pclmul crc32_pclmul
> > >>>>>>> ghash_clmulni_intel aesni_intel crypto_simd cryptd intel_cstate
> > >>>>>>> iTCO_wdt evdev mei_me pcspkr efi_pstore iTCO_vendor_support mei=
 sg
> > >>>>>>> tpm_crb tpm_tis tpm_tis_core tpm rng_core button acpi_pad
> > >>>>>>> mpls_iptunnel mpls_router ip_tunnel br_netfilter bridge stp llc=
 fuse
> > >>>>>>> configfs efivarfs ip_tables x_tables autofs4 usb_storage ohci_h=
cd
> > >>>>>>> uhci_hcd ehci_hcd squashfs zstd_decompress lz4_decompress loop
> > >>>>>>> overlay
> > >>>>>>> ext4 crc32c_generic crc16 mbcache jbd2 nls_cp437
> > >>>>>>> [   90.457755]  vfat fat efivars nls_ascii hid_generic usbhid h=
id
> > >>>>>>> sd_mod t10_pi xhci_pci ahci libahci libata crc32c_intel i2c_i80=
1
> > >>>>>>> i2c_smbus scsi_mod igc xhci_hcd scsi_common thermal fan
> > >>>>>>> [   90.576795] Kernel Offset: 0x1e000000 from 0xffffffff8100000=
0
> > >>>>>>> (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
> > >>>>>>> [   90.704454] ---[ end Kernel panic - not syncing: Fatal excep=
tion in
> > >>>>>>> interrupt ]---
> > >>>>>>>
> > >>>>>>> K.
> > >>>>>>>
> > >>>>>>> On Tue, Dec 27, 2022 at 11:07 PM Neftin, Sasha <sasha.neftin@in=
tel.com> wrote:
> > >>>>>>>>
> > >>>>>>>> On 12/28/2022 06:45, Kyle Sanderson wrote:
> > >>>>>>>>>
> > >>>>>>>>> hi Intel IGC Maintainers,
> > >>>>>>>>>
> > >>>>>>>>> I've managed to reproduce this issue on 5.15.85 (same steps t=
o
> > >>>>>>>>> reproduce), and have symbols and line numbers in the below pa=
nic.
> > >>>>>>>>> There's no device support in 5.4 for this hardware, so I was
> > >>>>>>>>> unable to reproduce the issue there in igc.
> > >>>>>>>>>
> > >>>>>>>>>    From the Kernel BUG_ON, it's being asked to read beyond th=
e
> > >>>>>>>>> array size. The min call looks very suspicious (igb, and othe=
r
> > >>>>>>>>> drives don't appear to do that), but I don't know if that's w=
here the issue is.
> > >>>>>>>>>
> > >>>>>>>>> Please let me know if there's anything more I can do to help.
> > >>>>>>>>
> > >>>>>>>> I do not know if it is an SW problem.
> > >>>>>>>> 1. Does the problem reproduce on the latest upstream kernel?(w=
orth
> > >>>>>>>> to check) 2. I do not see this crash in our labs. I haven't a
> > >>>>>>>> platform with six
> > >>>>>>>> i226 parts.(Trying find folks who work with this platform.) 3.=
 I
> > >>>>>>>> am working on a patch to address .ndo_tx_timeout support. (pas=
s
> > >>>>>>>> the reset task to netdev while the link disconnected during
> > >>>>>>>> traffic, under testing). It could be related and worth checkin=
g -
> > >>>>>>>> please, let me know if you want to apply on your platform (aga=
inst upstream).
> > >>>>>>>> Reach us (Dima, Amir, and me) directly off the list.
> > >>>>>>>>>
> > >>>>>>>>> [  223.725003] igc 0000:01:00.0 eth0: Reset adapter [
> > >>>>>>>>> 233.139441] kernel BUG at lib/dynamic_queue_limits.c:27!
> > >>>>>>>>> [  233.146814] invalid opcode: 0000 [#1] SMP NOPTI [
> > >>>>>>>>> 233.146816]
> > >>>>>>>>> refcount_t: saturated; leaking memory.
> > >>>>>>>>> [  233.146833] WARNING: CPU: 0 PID: 0 at lib/refcount.c:19
> > >>>>>>>>> refcount_warn_saturate+0x97/0x110
> > >>>>>>>>> [  233.153243] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G      =
  W
> > >>>>>>>>>      5.15.85-amd64-vyos #1
> > >>>>>>>>> [  233.159216] Modules linked in:
> > >>>>>>>>> [  233.168451] Hardware name: Default string Default
> > >>>>>>>>> string/Default string, BIOS 5.19 09/23/2022 [  233.177895]
> > >>>>>>>>> wireguard [  233.181645] RIP: 0010:dql_completed+0x12f/0x140 =
[
> > >>>>>>>>> 233.191360]  curve25519_x86_64 [  233.194406] Code: cf c9 00 =
48
> > >>>>>>>>> 89
> > >>>>>>>>> 57 58 e9 54 ff ff ff 85 ed 40 0f
> > >>>>>>>>> 95 c5 41 39 d8 41 0f 95 c0 44 84 c5 74 04 85 d2 78 0a 44 89 d=
8
> > >>>>>>>>> e9
> > >>>>>>>>> 36 ff ff ff <0f> 0b 01 f6 44 89 da 29 f2 0f 48 d0 eb 8d cc cc=
 cc
> > >>>>>>>>> 41 56 49
> > >>>>>>>>> 89 f3
> > >>>>>>>>> [  233.199767]  libcurve25519_generic [  233.203540] RSP:
> > >>>>>>>>> 0018:ffffa85dc0134e20 EFLAGS: 00010283 [  233.225248]
> > >>>>>>>>> libchacha20poly1305 [  233.229417] [  233.229417] RAX:
> > >>>>>>>>> 0000000000000001 RBX: ffff934002104b40 RCX: 00000000000005ea =
[
> > >>>>>>>>> 233.235539]  chacha_x86_64 [  233.239508] RDX: ffff9340021100=
00
> > >>>>>>>>> RSI: 0000000000001d92 RDI: ffff93400211a200 [  233.241606]
> > >>>>>>>>> poly1305_x86_64 [  233.249796] RBP: 0000000000000000 R08:
> > >>>>>>>>> 000000000004ad4e R09: 0000000000000000 [  233.253226]
> > >>>>>>>>> ip6_udp_tunnel [  233.261445] R10: 000000000004b338 R11:
> > >>>>>>>>> ffffffffbabfee80 R12: 0000000000001d92 [  233.261446] R13:
> > >>>>>>>>> ffff934002104b40 R14: ffffa85dc09d1450 R15: 00000000ffffffa6 =
[
> > >>>>>>>>> 233.265054]  udp_tunnel [  233.273314] FS:
> > >>>>>>>>> 0000000000000000(0000)
> > >>>>>>>>> GS:ffff934f3fe80000(0000)
> > >>>>>>>>> knlGS:0000000000000000
> > >>>>>>>>> [  233.276826]  libchacha
> > >>>>>>>>> [  233.285023] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050=
033
> > >>>>>>>>> [ 233.285025] CR2: 00007f294393fe84 CR3: 0000000605e10000 CR4=
:
> > >>>>>>>>> 0000000000350ee0 [  233.285026] Call Trace:
> > >>>>>>>>> [  233.285026]  <IRQ>
> > >>>>>>>>> [  233.285027]  igc_poll+0x19d/0x14b0 [igc] [  233.293242]  v=
rf
> > >>>>>>>>> [ 233.296396]  __napi_poll+0x22/0x110 [  233.305688]  nft_mas=
q [
> > >>>>>>>>> 233.308763]  net_rx_action+0xe9/0x250 [  233.315455]
> > >>>>>>>>> nf_nat_tftp [  233.323756]  ? igc_msix_ring+0x51/0x60 [igc] [
> > >>>>>>>>> 233.326946] nf_conntrack_tftp [  233.329661]
> > >>>>>>>>> __do_softirq+0xb8/0x1e9 [ 233.334471]  nf_nat_sip [  233.3369=
91]
> > >>>>>>>>> irq_exit_rcu+0x84/0xb0 [ 233.341290]  nf_conntrack_sip [
> > >>>>>>>>> 233.344284]
> > >>>>>>>>> common_interrupt+0x78/0x90 [  233.348778]  nf_nat_pptp [
> > >>>>>>>>> 233.352104]  </IRQ> [  233.357240]  nf_conntrack_pptp [
> > >>>>>>>>> 233.361052]  <TASK> [  233.365360]  nf_nat_h323 [  233.368484=
]
> > >>>>>>>>> asm_common_interrupt+0x22/0x40 [  233.372723]  nf_conntrack_h=
323
> > >>>>>>>>> [ 233.376363] RIP: 0010:cpuidle_enter_state+0xb5/0x2a0
> > >>>>>>>>> [  233.380952]  nf_nat_ftp
> > >>>>>>>>> [  233.384155] Code: c1 48 b2 ff 65 8b 3d b2 58 49 46 e8 65 4=
7
> > >>>>>>>>> b2 ff
> > >>>>>>>>> 31 ff 49 89 c5 e8 6b 52 b2 ff 45 84 f6 0f 85 85 01 00 00 fb 6=
6
> > >>>>>>>>> 0f 1f
> > >>>>>>>>> 44 00 00 <45> 85 ff 0f 88 bb 00 00 00 49 63 c7 4c 2b 2c 24 48=
 8d
> > >>>>>>>>> 14 40
> > >>>>>>>>> 48 8d
> > >>>>>>>>> [  233.386840]  nf_conntrack_ftp [  233.390553] RSP:
> > >>>>>>>>> 0018:ffffa85dc00efea8 EFLAGS: 00000246 [ 233.393224]  nft_obj=
ref
> > >>>>>>>>> [  233.396340] [  233.396340] RAX:
> > >>>>>>>>> ffff934f3fea3440 RBX: 0000000000000003 RCX: 000000000000001f =
[
> > >>>>>>>>> 233.401256]  nft_counter [  233.404981] RDX: 0000000000000000=
 RSI:
> > >>>>>>>>> 0000000046ec0743 RDI: 0000000000000000 [  233.410769]  nft_ct=
 [
> > >>>>>>>>> 233.413816] RBP: ffff934f3feac910 R08: 00000036481c5d1b R09:
> > >>>>>>>>> 0000003605db0041 [  233.435320]  nft_chain_nat [  233.438947]=
 R10:
> > >>>>>>>>> 0000000000000072 R11: 0000000000000164 R12: ffffffffba6ccb40 =
[
> > >>>>>>>>> 233.445014]  nf_nat [  233.448065] R13: 00000036481c5d1b R14:
> > >>>>>>>>> 0000000000000000 R15: 0000000000000003 [  233.450073]  nf_tab=
les
> > >>>>>>>>> [ 233.458210]  ? cpuidle_enter_state+0xa5/0x2a0 [  233.461335=
]
> > >>>>>>>>> nfnetlink_cthelper [  233.469449]  cpuidle_enter+0x24/0x40 [
> > >>>>>>>>> 233.472106]  nf_conntrack [  233.480247]  do_idle+0x1e4/0x280=
 [
> > >>>>>>>>> 233.483580]  nf_defrag_ipv6 [  233.491703]
> > >>>>>>>>> cpu_startup_entry+0x14/0x20 [  233.494399]  nf_defrag_ipv4 [
> > >>>>>>>>> 233.502517]  secondary_startup_64_no_verify+0xb0/0xbb
> > >>>>>>>>> [  233.505503]  libcrc32c
> > >>>>>>>>> [  233.510641]  </TASK>
> > >>>>>>>>> [  233.514474]  nfnetlink
> > >>>>>>>>> [  233.518787] Modules linked in: wireguard [  233.522065]
> > >>>>>>>>> af_packet [  233.525975]  curve25519_x86_64 [  233.529441]
> > >>>>>>>>> x86_pkg_temp_thermal [  233.534136]  libcurve25519_generic [
> > >>>>>>>>> 233.537612]  intel_powerclamp [  233.543511]
> > >>>>>>>>> libchacha20poly1305 [  233.546508]  coretemp [  233.549313]
> > >>>>>>>>> chacha_x86_64
> > >>>>>>>>> poly1305_x86_64 [  233.552304]  crct10dif_pclmul [  233.55698=
1]
> > >>>>>>>>> ip6_udp_tunnel udp_tunnel libchacha vrf nft_masq nf_nat_tftp
> > >>>>>>>>> nf_conntrack_tftp nf_nat_sip nf_conntrack_sip nf_nat_pptp
> > >>>>>>>>> nf_conntrack_pptp nf_nat_h323 nf_conntrack_h323 nf_nat_ftp
> > >>>>>>>>> nf_conntrack_ftp [  233.559990]  crc32_pclmul [  233.563754]
> > >>>>>>>>> nft_objref nft_counter [  233.567791]  ghash_clmulni_intel [
> > >>>>>>>>> 233.571912]  nft_ct [  233.575569]  aesni_intel [  233.579500=
]
> > >>>>>>>>> nft_chain_nat [  233.582390]  crypto_simd [  233.587225]  nf_=
nat
> > >>>>>>>>> [ 233.590841]  cryptd [  233.612012]  nf_tables [  233.615288=
]
> > >>>>>>>>> intel_cstate [  233.619486]  nfnetlink_cthelper [  233.623388=
]
> > >>>>>>>>> iTCO_wdt [  233.626063]  nf_conntrack [  233.629196]  efi_pst=
ore
> > >>>>>>>>> [ 233.632499]  nf_defrag_ipv6 [  233.635597]  pcspkr [
> > >>>>>>>>> 233.638218]
> > >>>>>>>>> nf_defrag_ipv4 [  233.640825]  evdev [  233.643700]  libcrc32=
c [
> > >>>>>>>>> 233.646869]  iTCO_vendor_support [  233.650591]  nfnetlink [
> > >>>>>>>>> 233.653355]  sg [  233.656497]  af_packet [  233.659446]
> > >>>>>>>>> tpm_crb [  233.662775]  x86_pkg_temp_thermal [  233.665337]
> > >>>>>>>>> tpm_tis [ 233.668670]  intel_powerclamp [  233.671144]
> > >>>>>>>>> tpm_tis_core [ 233.673993]  coretemp [  233.677768]  tpm [
> > >>>>>>>>> 233.680591] crct10dif_pclmul [  233.682782]  rng_core [
> > >>>>>>>>> 233.685624] crc32_pclmul [  233.688271]  mei_me [  233.692161=
]
> > >>>>>>>>> ghash_clmulni_intel [  233.694799]  mei [  233.698290]
> > >>>>>>>>> aesni_intel [  233.701384]  button [  233.704125]  crypto_sim=
d [
> > >>>>>>>>> 233.706379]  acpi_pad [  233.709861]  cryptd [  233.712587]
> > >>>>>>>>> mpls_iptunnel [  233.715682]  intel_cstate [  233.718177]
> > >>>>>>>>> mpls_router [  233.721872]  iTCO_wdt [  233.724077]  ip_tunne=
l [
> > >>>>>>>>> 233.727034]  efi_pstore [  233.729533]  br_netfilter [
> > >>>>>>>>> 233.732471]  pcspkr [  233.735139]  bridge [  233.737627]  ev=
dev
> > >>>>>>>>> [ 233.740768]  stp [  233.743827]  iTCO_vendor_support [
> > >>>>>>>>> 233.746789]  llc [  233.749457]  sg [  233.752222]  fuse [
> > >>>>>>>>> 233.755071]  tpm_crb [  233.758113]  configfs [  233.760589]
> > >>>>>>>>> tpm_tis [  233.763065]  efivarfs [  233.765437]  tpm_tis_core=
 [
> > >>>>>>>>> 233.767622]  ip_tables [  233.771314]  tpm [  233.773511]
> > >>>>>>>>> x_tables [  233.775607]  rng_core [  233.777893]  autofs4 [
> > >>>>>>>>> 233.780456]  mei_me [  233.783120]  usb_storage [  233.785686=
]
> > >>>>>>>>> mei [  233.788319]  ohci_hcd [  233.791358]  button [
> > >>>>>>>>> 233.794104] uhci_hcd [  233.796287]  acpi_pad [  233.798948]
> > >>>>>>>>> ehci_hcd [ 233.801608]  mpls_iptunnel [  233.804146]  squashf=
s [
> > >>>>>>>>> 233.806598] mpls_router [  233.809530]  zstd_decompress [
> > >>>>>>>>> 233.811719] ip_tunnel [  233.814378]  lz4_decompress [
> > >>>>>>>>> 233.816841] br_netfilter [  233.819492]  loop [  233.822152]
> > >>>>>>>>> bridge [ 233.824802]  overlay [  233.827927]  stp [  233.8305=
64]
> > >>>>>>>>> ext4 [ 233.833498]  llc [  233.836805]  crc32c_generic [
> > >>>>>>>>> 233.839557] fuse [  233.842787]  crc16 [  233.845815]  config=
fs
> > >>>>>>>>> [  233.848084] mbcache [  233.850564]  efivarfs [  233.853117=
]
> > >>>>>>>>> jbd2 [ 233.855296]  ip_tables [  233.857561]  nls_cp437 [
> > >>>>>>>>> 233.859722] x_tables autofs4 [  233.862950]  vfat [  233.8652=
16]
> > >>>>>>>>> usb_storage [  233.867585]  fat [  233.870239]  ohci_hcd
> > >>>>>>>>> uhci_hcd [ 233.872779]  efivars [  233.875414]  ehci_hcd [
> > >>>>>>>>> 233.877693] nls_ascii [  233.880433]  squashfs zstd_decompres=
s [
> > >>>>>>>>> 233.883172] hid_generic [  233.886580]  lz4_decompress [
> > >>>>>>>>> 233.888861]  usbhid [  233.891803]  loop [  233.893980]  hid =
[
> > >>>>>>>>> 233.897493]  overlay [ 233.900050]  sd_mod [  233.902702]  ex=
t4
> > >>>>>>>>> [  233.905446]  t10_pi [ 233.909612]  crc32c_generic [
> > >>>>>>>>> 233.912548]  ahci [  233.915776]
> > >>>>>>>>> crc16 [  233.918244]  libahci [  233.920540]  mbcache [
> > >>>>>>>>> 233.922740]  crc32c_intel [  233.925303]  jbd2 [  233.927777]
> > >>>>>>>>> libata [  233.930058]  nls_cp437 [  233.932530]  i2c_i801 [
> > >>>>>>>>> 233.935740]  vfat fat [  233.938022]  i2c_smbus [  233.940397=
]
> > >>>>>>>>> efivars [  233.942945]  xhci_pci [  233.945504]  nls_ascii
> > >>>>>>>>> hid_generic [  233.948535]  xhci_hcd [  233.950814]  usbhid [
> > >>>>>>>>> 233.953282]  scsi_mod [  233.956022]  hid [  233.958671]
> > >>>>>>>>> scsi_common [  233.961327]  sd_mod t10_pi [  233.964066]  igc=
 [
> > >>>>>>>>> 233.966618]  ahci [  233.969274]  thermal [  233.973168]
> > >>>>>>>>> libahci [  233.975830]  fan [  233.978310]  crc32c_intel [
> > >>>>>>>>> 233.980975] [ 233.983158]  libata
> > >>>>>>>>> [  233.986113] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G      =
  W
> > >>>>>>>>>      5.15.85-amd64-vyos #1
> > >>>>>>>>> [  233.989257]  i2c_i801
> > >>>>>>>>> [  233.991441] Hardware name: Default string Default
> > >>>>>>>>> string/Default string, BIOS 5.19 09/23/2022 [  233.993730]
> > >>>>>>>>> i2c_smbus [  233.996286] RIP:
> > >>>>>>>>> 0010:refcount_warn_saturate+0x97/0x110
> > >>>>>>>>> [  233.998850]  xhci_pci
> > >>>>>>>>> [  234.001055] Code: 00 01 e8 cb 40 42 00 0f 0b c3 cc cc cc c=
c
> > >>>>>>>>> 80 3d
> > >>>>>>>>> 39 f4 da 00 00 75 a8 48 c7 c7 d8 13 43 ba c6 05 29 f4 da 00 0=
1
> > >>>>>>>>> e8
> > >>>>>>>>> a8
> > >>>>>>>>> 40 42 00 <0f> 0b c3 cc cc cc cc 80 3d 13 f4 da 00 00 75 85 48=
 c7
> > >>>>>>>>> c7 30
> > >>>>>>>>> 14 43
> > >>>>>>>>> [  234.004069]  xhci_hcd scsi_mod [  234.005878] RSP:
> > >>>>>>>>> 0018:ffffa85dc0003ae0 EFLAGS: 00010282 [ 234.008348]
> > >>>>>>>>> scsi_common igc [  234.017611] [  234.020297] thermal fan [
> > >>>>>>>>> 234.029764] RAX: 0000000000000000 RBX:
> > >>>>>>>>> 0000000000005837 RCX: 0000000000000000 [  234.032559] [
> > >>>>>>>>> 234.032585] ---[ end trace 8acd09a29bf2e660 ]--- [  234.03845=
8]
> > >>>>>>>>> RDX: ffff934f3fe1f3e0 RSI: ffff934f3fe1c490 RDI:
> > >>>>>>>>> 0000000000000300 [  234.141617] RIP:
> > >>>>>>>>> 0010:dql_completed+0x12f/0x140 [  234.146459]
> > >>>>>>>>> RBP: ffff9340074b28c0 R08: 0000000000000000 R09:
> > >>>>>>>>> ffffa85dc0003908 [  234.150075] Code: cf c9 00 48 89 57 58 e9=
 54
> > >>>>>>>>> ff ff ff 85 ed 40 0f
> > >>>>>>>>> 95 c5 41 39 d8 41 0f 95 c0 44 84 c5 74 04 85 d2 78 0a 44 89 d=
8
> > >>>>>>>>> e9
> > >>>>>>>>> 36 ff ff ff <0f> 0b 01 f6 44 89 da 29 f2 0f 48 d0 eb 8d cc cc=
 cc
> > >>>>>>>>> 41 56 49
> > >>>>>>>>> 89 f3
> > >>>>>>>>> [  234.156048] R10: ffffa85dc0003900 R11: ffffffffba6b0ce8 R1=
2:
> > >>>>>>>>> ffff9340074b2908 [  234.159502] RSP: 0018:ffffa85dc0134e20 EF=
LAGS:
> > >>>>>>>>> 00010283 [  234.161442] R13: ffffffffba28eb60 R14:
> > >>>>>>>>> fffffffffffffff0 R15: ffffa85dc0003b40 [  234.164506] [
> > >>>>>>>>> 234.172573] FS:  0000000000000000(0000)
> > >>>>>>>>> GS:ffff934f3fe00000(0000)
> > >>>>>>>>> knlGS:0000000000000000
> > >>>>>>>>> [  234.174545] RAX: 0000000000000001 RBX: ffff934002104b40 RC=
X:
> > >>>>>>>>> 00000000000005ea [  234.179914] CS:  0010 DS: 0000 ES: 0000 C=
R0:
> > >>>>>>>>> 0000000080050033 [  234.188023] RDX: ffff934002110000 RSI:
> > >>>>>>>>> 0000000000001d92 RDI: ffff93400211a200 [  234.193301] CR2:
> > >>>>>>>>> 000055e26436ee10 CR3: 0000000605e10000 CR4: 0000000000350ef0 =
[
> > >>>>>>>>> 234.201457] RBP: 0000000000000000 R08: 000000000004ad4e R09: =
0000000000000000 [  234.223063] Call Trace:
> > >>>>>>>>> [  234.231267] R10: 000000000004b338 R11: ffffffffbabfee80 R1=
2:
> > >>>>>>>>> 0000000000001d92 [  234.237398]  <IRQ> [  234.245613] R13:
> > >>>>>>>>> ffff934002104b40 R14: ffffa85dc09d1450 R15: 00000000ffffffa6 =
[
> > >>>>>>>>> 234.247734]  __nf_conntrack_find_get+0x331/0x340 [nf_conntrac=
k]
> > >>>>>>>>> [ 234.256997] FS:  0000000000000000(0000)
> > >>>>>>>>> GS:ffff934f3fe80000(0000)
> > >>>>>>>>> knlGS:0000000000000000
> > >>>>>>>>> [  234.265245]  nf_conntrack_in+0x1e1/0x760 [nf_conntrack] [
> > >>>>>>>>> 234.271954] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033=
 [
> > >>>>>>>>> 234.280252]  nf_hook_slow+0x37/0xb0 [  234.288537] CR2:
> > >>>>>>>>> 00007f294393fe84 CR3: 000000011da48000 CR4: 0000000000350ee0 =
[
> > >>>>>>>>> 234.296788]  nf_hook_slow_list+0x8c/0x130 [  234.300002] Kern=
el
> > >>>>>>>>> panic - not syncing: Fatal exception in interrupt [  234.3083=
39]
> > >>>>>>>>> ip_sublist_rcv+0x1fa/0x220 [  234.319422] Kernel Offset:
> > >>>>>>>>> 0x38600000 from 0xffffffff81000000 (relocation range:
> > >>>>>>>>> 0xffffffff80000000-0xffffffffbfffffff)
> > >>>>>>>>> [  234.494681] ---[ end Kernel panic - not syncing: Fatal
> > >>>>>>>>> exception in interrupt ]---
> > >>>>>>>>>
> > >>>>>>>>> Kyle.
> > >>>>>>>>>
> > >>>>>>>>> On Tue, Dec 20, 2022 at 10:29 AM Kyle Sanderson <kyle.leet@gm=
ail.com> wrote:
> > >>>>>>>>>>
> > >>>>>>>>>> re-sending as plain text - my apologies.
> > >>>>>>>>>>
> > >>>>>>>>>>> On Sun, 18 Dec 2022, 23:31 Neftin, Sasha wrote:
> > >>>>>>>>>>> What is a board in use (LAN on board or NIC)?
> > >>>>>>>>>>> What is lspci, lspci -t and lspci -s 0000:[lan bus:device.f=
unction] -vvv output?
> > >>>>>>>>>>
> > >>>>>>>>>> It's embedded on the board, could very well be on a bridge
> > >>>>>>>>>> though as a card. The box has 6 ports, 2 were in-use while t=
esting.
> > >>>>>>>>>>
> > >>>>>>>>>> 00:00.0 Host bridge: Intel Corporation Device 4522 (rev 01)
> > >>>>>>>>>> 00:02.0 VGA compatible controller: Intel Corporation Elkhart
> > >>>>>>>>>> Lake [UHD Graphics Gen11 16EU] (rev 01)
> > >>>>>>>>>> 00:08.0 System peripheral: Intel Corporation Device 4511 (re=
v
> > >>>>>>>>>> 01)
> > >>>>>>>>>> 00:14.0 USB controller: Intel Corporation Device 4b7d (rev 1=
1)
> > >>>>>>>>>> 00:14.2 RAM memory: Intel Corporation Device 4b7f (rev 11)
> > >>>>>>>>>> 00:16.0 Communication controller: Intel Corporation Device 4=
b70
> > >>>>>>>>>> (rev 11)
> > >>>>>>>>>> 00:17.0 SATA controller: Intel Corporation Device 4b63 (rev =
11)
> > >>>>>>>>>> 00:1c.0 PCI bridge: Intel Corporation Device 4b38 (rev 11)
> > >>>>>>>>>> 00:1c.1 PCI bridge: Intel Corporation Device 4b39 (rev 11)
> > >>>>>>>>>> 00:1c.2 PCI bridge: Intel Corporation Device 4b3a (rev 11)
> > >>>>>>>>>> 00:1c.3 PCI bridge: Intel Corporation Device 4b3b (rev 11)
> > >>>>>>>>>> 00:1c.4 PCI bridge: Intel Corporation Device 4b3c (rev 11)
> > >>>>>>>>>> 00:1c.6 PCI bridge: Intel Corporation Device 4b3e (rev 11)
> > >>>>>>>>>> 00:1f.0 ISA bridge: Intel Corporation Device 4b00 (rev 11)
> > >>>>>>>>>> 00:1f.3 Audio device: Intel Corporation Device 4b58 (rev 11)
> > >>>>>>>>>> 00:1f.4 SMBus: Intel Corporation Device 4b23 (rev 11)
> > >>>>>>>>>> 00:1f.5 Serial bus controller: Intel Corporation Device 4b24
> > >>>>>>>>>> (rev
> > >>>>>>>>>> 11)
> > >>>>>>>>>> 01:00.0 Ethernet controller: Intel Corporation Device 125c (=
rev
> > >>>>>>>>>> 04)
> > >>>>>>>>>> 02:00.0 Ethernet controller: Intel Corporation Device 125c (=
rev
> > >>>>>>>>>> 04)
> > >>>>>>>>>> 03:00.0 Ethernet controller: Intel Corporation Device 125c (=
rev
> > >>>>>>>>>> 04)
> > >>>>>>>>>> 04:00.0 Ethernet controller: Intel Corporation Device 125c (=
rev
> > >>>>>>>>>> 04)
> > >>>>>>>>>> 05:00.0 Ethernet controller: Intel Corporation Device 125c (=
rev
> > >>>>>>>>>> 04)
> > >>>>>>>>>> 06:00.0 Ethernet controller: Intel Corporation Device 125c (=
rev
> > >>>>>>>>>> 04)
> > >>>>>>>>>>
> > >>>>>>>>>> -[0000:00]-+-00.0
> > >>>>>>>>>>               +-02.0
> > >>>>>>>>>>               +-08.0
> > >>>>>>>>>>               +-14.0
> > >>>>>>>>>>               +-14.2
> > >>>>>>>>>>               +-16.0
> > >>>>>>>>>>               +-17.0
> > >>>>>>>>>>               +-1c.0-[01]----00.0
> > >>>>>>>>>>               +-1c.1-[02]----00.0
> > >>>>>>>>>>               +-1c.2-[03]----00.0
> > >>>>>>>>>>               +-1c.3-[04]----00.0
> > >>>>>>>>>>               +-1c.4-[05]----00.0
> > >>>>>>>>>>               +-1c.6-[06]----00.0
> > >>>>>>>>>>               +-1f.0
> > >>>>>>>>>>               +-1f.3
> > >>>>>>>>>>               +-1f.4
> > >>>>>>>>>>               \-1f.5
> > >>>>>>>>>>
> > >>>>>>>>>>
> > >>>>>>>>>> 01:00.0 Ethernet controller: Intel Corporation Device 125c (=
rev 04)
> > >>>>>>>>>>     Subsystem: Intel Corporation Device 0000
> > >>>>>>>>>>     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASno=
op-
> > >>>>>>>>>> ParErr-
> > >>>>>>>>>> Stepping- SERR- FastB2B- DisINTx+
> > >>>>>>>>>>     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast
> > >>>>>>>>>>>
> > >>>>>>>>>>> TAbort-
> > >>>>>>>>>>
> > >>>>>>>>>> <TAbort- <MAbort- >SERR- <PERR- INTx-
> > >>>>>>>>>>     Latency: 0
> > >>>>>>>>>>     Interrupt: pin A routed to IRQ 16
> > >>>>>>>>>>     Region 0: Memory at 80600000 (32-bit, non-prefetchable) =
[size=3D1M]
> > >>>>>>>>>>     Region 3: Memory at 80700000 (32-bit, non-prefetchable) =
[size=3D16K]
> > >>>>>>>>>>     Capabilities: [40] Power Management version 3
> > >>>>>>>>>>      Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA PME(D0+,D1=
-,D2-,D3hot+,D3cold+)
> > >>>>>>>>>>      Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D1 P=
ME-
> > >>>>>>>>>>     Capabilities: [50] MSI: Enable- Count=3D1/1 Maskable+ 64=
bit+
> > >>>>>>>>>>      Address: 0000000000000000 Data: 0000
> > >>>>>>>>>>      Masking: 00000000 Pending: 00000000
> > >>>>>>>>>>     Capabilities: [70] MSI-X: Enable+ Count=3D5 Masked-
> > >>>>>>>>>>      Vector table: BAR=3D3 offset=3D00000000
> > >>>>>>>>>>      PBA: BAR=3D3 offset=3D00002000
> > >>>>>>>>>>     Capabilities: [a0] Express (v2) Endpoint, MSI 00
> > >>>>>>>>>>      DevCap: MaxPayload 512 bytes, PhantFunc 0, Latency L0s =
<512ns, L1 <64us
> > >>>>>>>>>>       ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+ SlotPo=
werLimit 0W
> > >>>>>>>>>>      DevCtl: CorrErr+ NonFatalErr+ FatalErr+ UnsupReq+
> > >>>>>>>>>>       RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLReset-
> > >>>>>>>>>>       MaxPayload 128 bytes, MaxReadReq 512 bytes
> > >>>>>>>>>>      DevSta: CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPw=
r+ TransPend-
> > >>>>>>>>>>      LnkCap: Port #0, Speed 5GT/s, Width x1, ASPM L1, Exit L=
atency L1 <4us
> > >>>>>>>>>>       ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp+
> > >>>>>>>>>>      LnkCtl: ASPM Disabled; RCB 64 bytes, Disabled- CommClk+
> > >>>>>>>>>>       ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
> > >>>>>>>>>>      LnkSta: Speed 5GT/s, Width x1
> > >>>>>>>>>>       TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
> > >>>>>>>>>>      DevCap2: Completion Timeout: Range ABCD, TimeoutDis+ NR=
OPrPrP- LTR+
> > >>>>>>>>>>        10BitTagComp- 10BitTagReq- OBFF Not Supported, ExtFmt=
- EETLPPrefix-
> > >>>>>>>>>>        EmergencyPowerReduction Not Supported, EmergencyPower=
ReductionInit-
> > >>>>>>>>>>        FRS- TPHComp- ExtTPHComp-
> > >>>>>>>>>>        AtomicOpsCap: 32bit- 64bit- 128bitCAS-
> > >>>>>>>>>>      DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- =
LTR+
> > >>>>>>>>>> 10BitTagReq- OBFF Disabled,
> > >>>>>>>>>>        AtomicOpsCtl: ReqEn-
> > >>>>>>>>>>      LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- Spe=
edDis-
> > >>>>>>>>>>        Transmit Margin: Normal Operating Range,
> > >>>>>>>>>> EnterModifiedCompliance-
> > >>>>>>>>>> ComplianceSOS-
> > >>>>>>>>>>        Compliance Preset/De-emphasis: -6dB de-emphasis, 0dB =
preshoot
> > >>>>>>>>>>      LnkSta2: Current De-emphasis Level: -6dB,
> > >>>>>>>>>> EqualizationComplete-
> > >>>>>>>>>> EqualizationPhase1-
> > >>>>>>>>>>        EqualizationPhase2- EqualizationPhase3- LinkEqualizat=
ionRequest-
> > >>>>>>>>>>        Retimer- 2Retimers- CrosslinkRes: unsupported
> > >>>>>>>>>>     Capabilities: [100 v2] Advanced Error Reporting
> > >>>>>>>>>>      UESta: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmpl=
t-
> > >>>>>>>>>> RxOF-
> > >>>>>>>>>> MalfTLP- ECRC- UnsupReq- ACSViol-
> > >>>>>>>>>>      UEMsk: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmpl=
t-
> > >>>>>>>>>> RxOF-
> > >>>>>>>>>> MalfTLP- ECRC- UnsupReq- ACSViol-
> > >>>>>>>>>>      UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmp=
lt-
> > >>>>>>>>>> RxOF+
> > >>>>>>>>>> MalfTLP+ ECRC- UnsupReq- ACSViol-
> > >>>>>>>>>>      CESta: RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNo=
nFatalErr-
> > >>>>>>>>>>      CEMsk: RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNo=
nFatalErr+
> > >>>>>>>>>>      AERCap: First Error Pointer: 00, ECRCGenCap+ ECRCGenEn-=
 ECRCChkCap+ ECRCChkEn-
> > >>>>>>>>>>       MultHdrRecCap- MultHdrRecEn- TLPPfxPres- HdrLogCap-
> > >>>>>>>>>>      HeaderLog: 00000000 00000000 00000000 00000000
> > >>>>>>>>>>     Capabilities: [140 v1] Device Serial Number e4-3a-6e-ff-=
ff-5d-bb-54
> > >>>>>>>>>>     Capabilities: [1c0 v1] Latency Tolerance Reporting
> > >>>>>>>>>>      Max snoop latency: 3145728ns
> > >>>>>>>>>>      Max no snoop latency: 3145728ns
> > >>>>>>>>>>     Capabilities: [1f0 v1] Precision Time Measurement
> > >>>>>>>>>>      PTMCap: Requester:+ Responder:- Root:-
> > >>>>>>>>>>      PTMClockGranularity: 4ns
> > >>>>>>>>>>      PTMControl: Enabled:- RootSelected:-
> > >>>>>>>>>>      PTMEffectiveGranularity: Unknown
> > >>>>>>>>>>     Capabilities: [1e0 v1] L1 PM Substates
> > >>>>>>>>>>      L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+ ASPM_L1.=
1+ L1_PM_Substates+
> > >>>>>>>>>>         PortCommonModeRestoreTime=3D55us PortTPowerOnTime=3D=
70us
> > >>>>>>>>>>      L1SubCtl1: PCI-PM_L1.2- PCI-PM_L1.1- ASPM_L1.2- ASPM_L1=
.1-
> > >>>>>>>>>>          T_CommonMode=3D0us LTR1.2_Threshold=3D81920ns
> > >>>>>>>>>>      L1SubCtl2: T_PwrOn=3D50us
> > >>>>>>>>>>     Kernel driver in use: igc
> > >>>>>>>>>>     Kernel modules: igc
> > >>>>>>>>>>
> > >>>>>>>>>> On Sun, Dec 18, 2022 at 10:31 PM Neftin, Sasha <sasha.neftin=
@intel.com> wrote:
> > >>>>>>>>>>>
> > >>>>>>>>>>> On 12/16/2022 00:28, Kyle Sanderson wrote:
> > >>>>>>>>>>>>
> > >>>>>>>>>>>> (Un)fortunately I can reproduce this bug by simply removin=
g
> > >>>>>>>>>>>> the ethernet cable from the box while there is traffic flo=
wing.
> > >>>>>>>>>>>> kprint below from a console line. Please CC / to me for an=
y
> > >>>>>>>>>>>> additional information I can provide for this panic.
> > >>>>>>>>>>>
> > >>>>>>>>>>> What is a board in use (LAN on board or NIC)? What is lspci=
,
> > >>>>>>>>>>> lspci -t and lspci -s 0000:[lan bus:device.function] -vvv o=
utput?
> > >>>>>>>>>>>>
> > >>>>>>>>>>>> [  156.707054] igc 0000:01:00.0 eth0: NIC Link is Down [
> > >>>>>>>>>>>> 156.712981] br-lan: port 1(eth0) entered disabled state [
> > >>>>>>>>>>>> 156.719246] igc 0000:01:00.0 eth0: Register Dump
> > >>>>>>>>>>>> [  156.724784] igc 0000:01:00.0 eth0: Register Name   Valu=
e
> > >>>>>>>>>>>> [  156.731067] igc 0000:01:00.0 eth0: CTRL            181c=
0641
> > >>>>>>>>>>>> [  156.737607] igc 0000:01:00.0 eth0: STATUS          0038=
0681
> > >>>>>>>>>>>> [  156.744133] igc 0000:01:00.0 eth0: CTRL_EXT        1000=
00c0
> > >>>>>>>>>>>> [  156.750759] igc 0000:01:00.0 eth0: MDIC            1801=
7949
> > >>>>>>>>>>>> [  156.757258] igc 0000:01:00.0 eth0: ICR             0000=
0001
> > >>>>>>>>>>>> [  156.763785] igc 0000:01:00.0 eth0: RCTL            0440=
803a
> > >>>>>>>>>>>> [  156.770324] igc 0000:01:00.0 eth0: RDLEN[0-3]      0000=
1000
> > >>>>>>>>>>>> 00001000 00001000 00001000
> > >>>>>>>>>>>> [  156.779457] igc 0000:01:00.0 eth0: RDH[0-3]        0000=
00ef
> > >>>>>>>>>>>> 000000a1 00000092 000000ba
> > >>>>>>>>>>>> [  156.788500] igc 0000:01:00.0 eth0: RDT[0-3]        0000=
00ee
> > >>>>>>>>>>>> 000000a0 00000091 000000b9
> > >>>>>>>>>>>> [  156.797650] igc 0000:01:00.0 eth0: RXDCTL[0-3]     0204=
0808
> > >>>>>>>>>>>> 02040808 02040808 02040808
> > >>>>>>>>>>>> [  156.806688] igc 0000:01:00.0 eth0: RDBAL[0-3]      02f4=
3000
> > >>>>>>>>>>>> 02180000 02e7f000 02278000
> > >>>>>>>>>>>> [  156.815781] igc 0000:01:00.0 eth0: RDBAH[0-3]      0000=
0001
> > >>>>>>>>>>>> 00000001 00000001 00000001
> > >>>>>>>>>>>> [  156.824928] igc 0000:01:00.0 eth0: TCTL            a503=
f0fa
> > >>>>>>>>>>>> [  156.831587] igc 0000:01:00.0 eth0: TDBAL[0-3]      02f4=
3000
> > >>>>>>>>>>>> 02180000 02e7f000 02278000
> > >>>>>>>>>>>> [  156.840637] igc 0000:01:00.0 eth0: TDBAH[0-3]      0000=
0001
> > >>>>>>>>>>>> 00000001 00000001 00000001
> > >>>>>>>>>>>> [  156.849753] igc 0000:01:00.0 eth0: TDLEN[0-3]      0000=
1000
> > >>>>>>>>>>>> 00001000 00001000 00001000
> > >>>>>>>>>>>> [  156.858760] igc 0000:01:00.0 eth0: TDH[0-3]        0000=
00d4
> > >>>>>>>>>>>> 0000003d 000000af 0000002a
> > >>>>>>>>>>>> [  156.867771] igc 0000:01:00.0 eth0: TDT[0-3]        0000=
00e4
> > >>>>>>>>>>>> 0000005a 000000c8 0000002a
> > >>>>>>>>>>>> [  156.876864] igc 0000:01:00.0 eth0: TXDCTL[0-3]     0210=
0108
> > >>>>>>>>>>>> 02100108 02100108 02100108
> > >>>>>>>>>>>> [  156.885905] igc 0000:01:00.0 eth0: Reset adapter [
> > >>>>>>>>>>>> 160.307195] igc 0000:01:00.0 eth0: NIC Link is Up 1000 Mbp=
s
> > >>>>>>>>>>>> Full Duplex, Flow Control: RX/TX [  160.317974] br-lan: po=
rt
> > >>>>>>>>>>>> 1(eth0) entered blocking state [  160.324532] br-lan: port
> > >>>>>>>>>>>> 1(eth0) entered forwarding state [  161.197263] ----------=
--[
> > >>>>>>>>>>>> cut here ]------------ [  161.202669] Kernel BUG at
> > >>>>>>>>>>>> 0xffffffff813ce19f [verbose debug info unavailable] [
> > >>>>>>>>>>>> 161.210769] invalid opcode: 0000 [#1] SMP NOPTI [
> > >>>>>>>>>>>> 161.216022]
> > >>>>>>>>>>>> CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.10.146 #0 [
> > >>>>>>>>>>>> 161.222980] Hardware name: Default string Default
> > >>>>>>>>>>>> string/Default string, BIOS 5.19 09/23/2022 [  161.232546]=
 RIP:
> > >>>>>>>>>>>> 0010:0xffffffff813ce19f [  161.237167] Code: 03 01 4c 89 4=
8
> > >>>>>>>>>>>> 58
> > >>>>>>>>>>>> e9 2f ff ff ff 85 db 41 0f 95
> > >>>>>>>>>>>> c2 45 39 d9 41 0f 95 c1 45 84 ca 74 05 45 85 e4 78 0a 44 8=
9
> > >>>>>>>>>>>> c2
> > >>>>>>>>>>>> e9 10 ff ff ff <0f> 0b 01 d2 45 89 c1 41 29 d1 ba 00 00 00=
 00
> > >>>>>>>>>>>> 44 0f 48 ca eb
> > >>>>>>>>>>>> 80 cc
> > >>>>>>>>>>>> [  161.258651] RSP: 0018:ffffc90000118e88 EFLAGS: 00010283=
 [
> > >>>>>>>>>>>> 161.264736] RAX: ffff888101f8f200 RBX: ffffc900006f9bd0 RC=
X:
> > >>>>>>>>>>>> 000000000000050e [  161.272837] RDX: ffff888101fec000 RSI:
> > >>>>>>>>>>>> 0000000000000a1c RDI: 0000000000061a10 [  161.280942] RBP:
> > >>>>>>>>>>>> ffffc90000118ef8 R08: 0000000000000000 R09: 00000000000615=
02
> > >>>>>>>>>>>> [ 161.289089] R10: 0000000000000000 R11: 0000000000000000 =
R12:
> > >>>>>>>>>>>> 00000000ffffff3f [  161.297229] R13: ffff888101f8f140 R14:
> > >>>>>>>>>>>> 0000000000000000 R15: ffff888100ad9b00 [  161.305345] FS:
> > >>>>>>>>>>>> 0000000000000000(0000) GS:ffff88903fe80000(0000)
> > >>>>>>>>>>>> knlGS:00000 00000000000
> > >>>>>>>>>>>> [  161.314492] CS:  0010 DS: 0000 ES: 0000 CR0:
> > >>>>>>>>>>>> 0000000080050033 [  161.321139] CR2: 00007f941ad43a9b CR3:
> > >>>>>>>>>>>> 000000000340a000 CR4: 0000000000350ee0 [  161.329284] Call=
 Trace:
> > >>>>>>>>>>>> [  161.332373]  <IRQ>
> > >>>>>>>>>>>> [  161.334981]  ? 0xffffffffa0185f78
> > >>>>>>>>>>>> [igc@00000000f400031b+0x13000] [  161.341949]
> > >>>>>>>>>>>> 0xffffffff8185b047 [  161.345797]  0xffffffff8185b2ca [
> > >>>>>>>>>>>> 161.349637]  0xffffffff81e000bb [  161.353465]
> > >>>>>>>>>>>> 0xffffffff81c0109f [  161.357304]  </IRQ> [  161.359988]
> > >>>>>>>>>>>> 0xffffffff8102cdac [  161.363783]  0xffffffff810bfdaf [
> > >>>>>>>>>>>> 161.367584]  0xffffffff81a2e616 [  161.371374]
> > >>>>>>>>>>>> 0xffffffff81c00c9e [  161.375192] RIP:
> > >>>>>>>>>>>> 0010:0xffffffff817e331b [  161.379840] Code: 21 90 ff 65 8=
b
> > >>>>>>>>>>>> 3d 45 23 83 7e e8 80 20 90 ff 31 ff 49 89 c6 e8 26 2d 90 f=
f
> > >>>>>>>>>>>> 80 7d d7 00 0f 85 9e 01 00 00 fb 66 0f 1f
> > >>>>>>>>>>>> 44 00 00 <45> 85 ff 0f 88 cf 00 00 00 49 63 cf 48 8d 04 49=
 48
> > >>>>>>>>>>>> 8d 14 81
> > >>>>>>>>>>>> 48 c1
> > >>>>>>>>>>>> [  161.401397] RSP: 0018:ffffc900000d3e80 EFLAGS: 00000246=
 [
> > >>>>>>>>>>>> 161.407493] RAX: ffff88903fea5180 RBX: ffff88903feadf00 RC=
X:
> > >>>>>>>>>>>> 000000000000001f [  161.415648] RDX: 0000000000000000 RSI:
> > >>>>>>>>>>>> 0000000046ec0743 RDI: 0000000000000000 [  161.423811] RBP:
> > >>>>>>>>>>>> ffffc900000d3eb8 R08: 00000025881a3b81 R09: ffff8881003173=
40
> > >>>>>>>>>>>> [ 161.432003] R10: 0000000000000001 R11: 0000000000000000 =
R12:
> > >>>>>>>>>>>> 0000000000000003 [  161.440154] R13: ffffffff824c7bc0 R14:
> > >>>>>>>>>>>> 00000025881a3b81 R15: 0000000000000003 [  161.448285]
> > >>>>>>>>>>>> 0xffffffff817e357f [  161.452123]  0xffffffff810e6258 [
> > >>>>>>>>>>>> 161.455938]  0xffffffff810e63fb [  161.459746]
> > >>>>>>>>>>>> 0xffffffff8104bec0 [  161.463526]  0xffffffff810000f5 [
> > >>>>>>>>>>>> 161.467290] Modules linked in: pppoe ppp_async nft_fib_ine=
t
> > >>>>>>>>>>>> nf_flow_table_ipv 6 nf_flow_table_ipv4 nf_flow_table_inet
> > >>>>>>>>>>>> wireguard pppox ppp_generic nft_reject_i pv6 nft_reject_ip=
v4
> > >>>>>>>>>>>> nft_reject_inet nft_reject nft_redir nft_quota nft_objref =
nf
> > >>>>>>>>>>>> t_numgen nft_nat nft_masq nft_log nft_limit nft_hash
> > >>>>>>>>>>>> nft_flow_offload nft_fib_ip v6 nft_fib_ipv4 nft_fib nft_ct
> > >>>>>>>>>>>> nft_counter nft_chain_nat nf_tables nf_nat nf_flo w_table
> > >>>>>>>>>>>> nf_conntrack libchacha20poly1305 curve25519_x86_64
> > >>>>>>>>>>>> chacha_x86_64 slhc r8 169 poly1305_x86_64 nfnetlink
> > >>>>>>>>>>>> nf_reject_ipv6
> > >>>>>>>>>>>> nf_reject_ipv4 nf_log_ipv6 nf_log_i pv4 nf_log_common
> > >>>>>>>>>>>> nf_defrag_ipv6
> > >>>>>>>>>>>> nf_defrag_ipv4 libcurve25519_generic libcrc32c libchacha i=
gc
> > >>>>>>>>>>>> forcedeth e1000e crc_ccitt bnx2 i2c_dev ixgbe e1000 amd_xg=
be
> > >>>>>>>>>>>> ip6_u dp_tunnel udp_tunnel mdio nls_utf8 ena kpp
> > >>>>>>>>>>>> nls_iso8859_1
> > >>>>>>>>>>>> nls_cp437 vfat fat igb button_hotplug tg3 ptp realtek
> > >>>>>>>>>>>> pps_core mii [  161.550507] ---[ end trace b1cb18ab2d1741b=
d
> > >>>>>>>>>>>> ]--- [ 161.555938] RIP: 0010:0xffffffff813ce19f [  161.560=
634] Code:
> > >>>>>>>>>>>> 03 01 4c 89 48 58 e9 2f ff ff ff 85 db 41 0f 95
> > >>>>>>>>>>>> c2 45 39 d9 41 0f 95 c1 45 84 ca 74 05 45 85 e4 78 0a 44 8=
9
> > >>>>>>>>>>>> c2
> > >>>>>>>>>>>> e9 10 ff ff ff <0f> 0b 01 d2 45 89 c1 41 29 d1 ba 00 00 00=
 00
> > >>>>>>>>>>>> 44 0f 48 ca eb
> > >>>>>>>>>>>> 80 cc
> > >>>>>>>>>>>> [  161.582281] RSP: 0018:ffffc90000118e88 EFLAGS: 00010283=
 [
> > >>>>>>>>>>>> 161.588426] RAX: ffff888101f8f200 RBX: ffffc900006f9bd0 RC=
X:
> > >>>>>>>>>>>> 000000000000050e [  161.596668] RDX: ffff888101fec000 RSI:
> > >>>>>>>>>>>> 0000000000000a1c RDI: 0000000000061a10 [  161.604860] RBP:
> > >>>>>>>>>>>> ffffc90000118ef8 R08: 0000000000000000 R09: 00000000000615=
02
> > >>>>>>>>>>>> [ 161.613052] R10: 0000000000000000 R11: 0000000000000000 =
R12:
> > >>>>>>>>>>>> 00000000ffffff3f [  161.621291] R13: ffff888101f8f140 R14:
> > >>>>>>>>>>>> 0000000000000000 R15: ffff888100ad9b00 [  161.629505] FS:
> > >>>>>>>>>>>> 0000000000000000(0000) GS:ffff88903fe80000(0000)
> > >>>>>>>>>>>> knlGS:00000 00000000000
> > >>>>>>>>>>>> [  161.638781] CS:  0010 DS: 0000 ES: 0000 CR0:
> > >>>>>>>>>>>> 0000000080050033 [  161.645549] CR2: 00007f941ad43a9b CR3:
> > >>>>>>>>>>>> 000000000340a000 CR4: 0000000000350ee0 [  161.653841] Kern=
el
> > >>>>>>>>>>>> panic - not syncing: Fatal exception in interrupt [
> > >>>>>>>>>>>> 161.661287] Kernel Offset: disabled [  161.665644] Rebooti=
ng in 3 seconds..
> > >>>>>>>>>>>> [  164.670313] ACPI MEMORY or I/O RESET_REG.
> > >>>>>>>>>>>>
> > >>>>>>>>>>>> Kyle.
> > >>>>>>>>>>>> _______________________________________________
> > >>>>>>>>>>>> Intel-wired-lan mailing list
> > >>>>>>>>>>>> Intel-wired-lan@osuosl.org
> > >>>>>>>>>>>> https://lists.osuosl.org/mailman/listinfo/intel-wired-lan
> > >>>>>>>>>>>
> > >>>>>>>>
> > >>
> > >>
> >
