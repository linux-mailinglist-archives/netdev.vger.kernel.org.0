Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A24464FD34
	for <lists+netdev@lfdr.de>; Sun, 18 Dec 2022 01:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbiLRAUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Dec 2022 19:20:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbiLRAUw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Dec 2022 19:20:52 -0500
Received: from mail-ua1-x92a.google.com (mail-ua1-x92a.google.com [IPv6:2607:f8b0:4864:20::92a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A72565BD;
        Sat, 17 Dec 2022 16:20:50 -0800 (PST)
Received: by mail-ua1-x92a.google.com with SMTP id v21so1346185uam.1;
        Sat, 17 Dec 2022 16:20:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/t6IoJ3va+Stkf1oSUoL7zegWmdcaZ0I+iIO0OQeIN8=;
        b=FRrkFgcYQdMPCxor46qGyW69SEr6L2mglGYfWsH8Fx2PH0Izdns78ZQXfzcWpxWbFC
         bk+iD0CxZODdI4It1lcDdZ85NKOF0NU1helFJIpCSlYHZHpkAsvxWcbJ02vNq/yjwhcy
         luFTBMI1KtTqDHVxph7pGP6qPkWeeiVjO6qSU/uMqixmQ+6QSbjbX5d5DM3PiX4SdRbS
         fJeDOJLRx4GwOeq1XeyEq5mPCuE6TsvU9EnaKfAm5YeR2WLx1WaLrkAUQrXC+exuTcUX
         uVt33GtQ+AwTi6SYxMq+OfFVEMJW8pRhsBfkcrU8eQNlt3cZhiuw4cdX8i07JRlDBmUj
         +VFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/t6IoJ3va+Stkf1oSUoL7zegWmdcaZ0I+iIO0OQeIN8=;
        b=Xj1AnpE9AwZU0w7iyveNfhMo4kEZ5ldLdgzR2+CsS0jL6DaXR1IHykfgmQ3FPZtYF6
         ZHbL24Yw7U/Zw0D+jOueHYkjiYWT6sK9fMI5JFg3OEZApW8AhUYnfnl0AZrbqnmYKYd+
         UBf2H4FIhC3y2yzmA7stLCDrpWfpTxOP70GfgHT9OGL/BVERe0eIm+Puyh4Yrv65LkkR
         7cIInLGPj+kj/MGmYMCEwy6blKV0vJOwWEuZQ2B0FbSj3HVGd6Yb/bDHqDkiuvPZFtwx
         tnjvjG6JHAPhLKtL1z7YLNqARJZ47mYJx6VqSXx/7asHDgz1zg8nHKyhgn5xYD58/z+C
         Ti3Q==
X-Gm-Message-State: ANoB5pnKdkVy4LWWDuc1M+8AJXh91aIeWaY6JcsAAhcKFkGqrQFTfKMM
        dq3BHgQZN56tBJrmzIfQLIyKI7pIDAGcDZnnyeMG5yNBsxw=
X-Google-Smtp-Source: AA0mqf7Rc5WCnP5xCpHajOYRt/VzkfNcl1MElpqBaTAQyK8S6TK+3U39K1mFNTessNEwxrD0qwPRm+bly7AxF6g4SzI=
X-Received: by 2002:ab0:3848:0:b0:419:d3f0:d6a6 with SMTP id
 h8-20020ab03848000000b00419d3f0d6a6mr11768093uaw.111.1671322849016; Sat, 17
 Dec 2022 16:20:49 -0800 (PST)
MIME-Version: 1.0
References: <CACsaVZL6ykbsVvEaV2Cv3r6m_jKt04MEUOw5=mSnR5AYTyE7qg@mail.gmail.com>
In-Reply-To: <CACsaVZL6ykbsVvEaV2Cv3r6m_jKt04MEUOw5=mSnR5AYTyE7qg@mail.gmail.com>
From:   Kyle Sanderson <kyle.leet@gmail.com>
Date:   Sat, 17 Dec 2022 16:20:39 -0800
Message-ID: <CACsaVZKGJ1uxC+-XV+tdy6nP01r7QjrzFH_iVGRw9acLRE-uvA@mail.gmail.com>
Subject: Re: igc: 5.10.146 Kernel BUG at 0xffffffff813ce19f
To:     Linux-Kernal <linux-kernel@vger.kernel.org>,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        openwrt-bugs@lists.openwrt.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi Intel igc maintainers,

just confirmed on the same box that 13-CURRENT on FBSD does not result
in a kernel panic when a single remote host loses power on the
network. Please let me know if there's any additional information you
need.

Kyle.

On Thu, Dec 15, 2022 at 2:28 PM Kyle Sanderson <kyle.leet@gmail.com> wrote:
>
> (Un)fortunately I can reproduce this bug by simply removing the
> ethernet cable from the box while there is traffic flowing. kprint
> below from a console line. Please CC / to me for any additional
> information I can provide for this panic.
>
> [  156.707054] igc 0000:01:00.0 eth0: NIC Link is Down
> [  156.712981] br-lan: port 1(eth0) entered disabled state
> [  156.719246] igc 0000:01:00.0 eth0: Register Dump
> [  156.724784] igc 0000:01:00.0 eth0: Register Name   Value
> [  156.731067] igc 0000:01:00.0 eth0: CTRL            181c0641
> [  156.737607] igc 0000:01:00.0 eth0: STATUS          00380681
> [  156.744133] igc 0000:01:00.0 eth0: CTRL_EXT        100000c0
> [  156.750759] igc 0000:01:00.0 eth0: MDIC            18017949
> [  156.757258] igc 0000:01:00.0 eth0: ICR             00000001
> [  156.763785] igc 0000:01:00.0 eth0: RCTL            0440803a
> [  156.770324] igc 0000:01:00.0 eth0: RDLEN[0-3]      00001000
> 00001000 00001000 00001000
> [  156.779457] igc 0000:01:00.0 eth0: RDH[0-3]        000000ef
> 000000a1 00000092 000000ba
> [  156.788500] igc 0000:01:00.0 eth0: RDT[0-3]        000000ee
> 000000a0 00000091 000000b9
> [  156.797650] igc 0000:01:00.0 eth0: RXDCTL[0-3]     02040808
> 02040808 02040808 02040808
> [  156.806688] igc 0000:01:00.0 eth0: RDBAL[0-3]      02f43000
> 02180000 02e7f000 02278000
> [  156.815781] igc 0000:01:00.0 eth0: RDBAH[0-3]      00000001
> 00000001 00000001 00000001
> [  156.824928] igc 0000:01:00.0 eth0: TCTL            a503f0fa
> [  156.831587] igc 0000:01:00.0 eth0: TDBAL[0-3]      02f43000
> 02180000 02e7f000 02278000
> [  156.840637] igc 0000:01:00.0 eth0: TDBAH[0-3]      00000001
> 00000001 00000001 00000001
> [  156.849753] igc 0000:01:00.0 eth0: TDLEN[0-3]      00001000
> 00001000 00001000 00001000
> [  156.858760] igc 0000:01:00.0 eth0: TDH[0-3]        000000d4
> 0000003d 000000af 0000002a
> [  156.867771] igc 0000:01:00.0 eth0: TDT[0-3]        000000e4
> 0000005a 000000c8 0000002a
> [  156.876864] igc 0000:01:00.0 eth0: TXDCTL[0-3]     02100108
> 02100108 02100108 02100108
> [  156.885905] igc 0000:01:00.0 eth0: Reset adapter
> [  160.307195] igc 0000:01:00.0 eth0: NIC Link is Up 1000 Mbps Full
> Duplex, Flow Control: RX/TX
> [  160.317974] br-lan: port 1(eth0) entered blocking state
> [  160.324532] br-lan: port 1(eth0) entered forwarding state
> [  161.197263] ------------[ cut here ]------------
> [  161.202669] Kernel BUG at 0xffffffff813ce19f [verbose debug info unavailable]
> [  161.210769] invalid opcode: 0000 [#1] SMP NOPTI
> [  161.216022] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.10.146 #0
> [  161.222980] Hardware name: Default string Default string/Default
> string, BIOS 5.19 09/23/2022
> [  161.232546] RIP: 0010:0xffffffff813ce19f
> [  161.237167] Code: 03 01 4c 89 48 58 e9 2f ff ff ff 85 db 41 0f 95
> c2 45 39 d9 41 0f 95 c1 45 84 ca 74 05 45 85 e4 78 0a 44 89 c2 e9 10
> ff ff ff <0f> 0b 01 d2 45 89 c1 41 29 d1 ba 00 00 00 00 44 0f 48 ca eb
> 80 cc
> [  161.258651] RSP: 0018:ffffc90000118e88 EFLAGS: 00010283
> [  161.264736] RAX: ffff888101f8f200 RBX: ffffc900006f9bd0 RCX: 000000000000050e
> [  161.272837] RDX: ffff888101fec000 RSI: 0000000000000a1c RDI: 0000000000061a10
> [  161.280942] RBP: ffffc90000118ef8 R08: 0000000000000000 R09: 0000000000061502
> [  161.289089] R10: 0000000000000000 R11: 0000000000000000 R12: 00000000ffffff3f
> [  161.297229] R13: ffff888101f8f140 R14: 0000000000000000 R15: ffff888100ad9b00
> [  161.305345] FS:  0000000000000000(0000) GS:ffff88903fe80000(0000)
> knlGS:00000 00000000000
> [  161.314492] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  161.321139] CR2: 00007f941ad43a9b CR3: 000000000340a000 CR4: 0000000000350ee0
> [  161.329284] Call Trace:
> [  161.332373]  <IRQ>
> [  161.334981]  ? 0xffffffffa0185f78 [igc@00000000f400031b+0x13000]
> [  161.341949]  0xffffffff8185b047
> [  161.345797]  0xffffffff8185b2ca
> [  161.349637]  0xffffffff81e000bb
> [  161.353465]  0xffffffff81c0109f
> [  161.357304]  </IRQ>
> [  161.359988]  0xffffffff8102cdac
> [  161.363783]  0xffffffff810bfdaf
> [  161.367584]  0xffffffff81a2e616
> [  161.371374]  0xffffffff81c00c9e
> [  161.375192] RIP: 0010:0xffffffff817e331b
> [  161.379840] Code: 21 90 ff 65 8b 3d 45 23 83 7e e8 80 20 90 ff 31
> ff 49 89 c6 e8 26 2d 90 ff 80 7d d7 00 0f 85 9e 01 00 00 fb 66 0f 1f
> 44 00 00 <45> 85 ff 0f 88 cf 00 00 00 49 63 cf 48 8d 04 49 48 8d 14 81
> 48 c1
> [  161.401397] RSP: 0018:ffffc900000d3e80 EFLAGS: 00000246
> [  161.407493] RAX: ffff88903fea5180 RBX: ffff88903feadf00 RCX: 000000000000001f
> [  161.415648] RDX: 0000000000000000 RSI: 0000000046ec0743 RDI: 0000000000000000
> [  161.423811] RBP: ffffc900000d3eb8 R08: 00000025881a3b81 R09: ffff888100317340
> [  161.432003] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000003
> [  161.440154] R13: ffffffff824c7bc0 R14: 00000025881a3b81 R15: 0000000000000003
> [  161.448285]  0xffffffff817e357f
> [  161.452123]  0xffffffff810e6258
> [  161.455938]  0xffffffff810e63fb
> [  161.459746]  0xffffffff8104bec0
> [  161.463526]  0xffffffff810000f5
> [  161.467290] Modules linked in: pppoe ppp_async nft_fib_inet
> nf_flow_table_ipv 6 nf_flow_table_ipv4 nf_flow_table_inet wireguard
> pppox ppp_generic nft_reject_i pv6 nft_reject_ipv4 nft_reject_inet
> nft_reject nft_redir nft_quota nft_objref nf t_numgen nft_nat nft_masq
> nft_log nft_limit nft_hash nft_flow_offload nft_fib_ip v6 nft_fib_ipv4
> nft_fib nft_ct nft_counter nft_chain_nat nf_tables nf_nat nf_flo
> w_table nf_conntrack libchacha20poly1305 curve25519_x86_64
> chacha_x86_64 slhc r8 169 poly1305_x86_64 nfnetlink nf_reject_ipv6
> nf_reject_ipv4 nf_log_ipv6 nf_log_i pv4 nf_log_common nf_defrag_ipv6
> nf_defrag_ipv4 libcurve25519_generic libcrc32c libchacha igc forcedeth
> e1000e crc_ccitt bnx2 i2c_dev ixgbe e1000 amd_xgbe ip6_u dp_tunnel
> udp_tunnel mdio nls_utf8 ena kpp nls_iso8859_1 nls_cp437 vfat fat igb
> button_hotplug tg3 ptp realtek pps_core mii
> [  161.550507] ---[ end trace b1cb18ab2d1741bd ]---
> [  161.555938] RIP: 0010:0xffffffff813ce19f
> [  161.560634] Code: 03 01 4c 89 48 58 e9 2f ff ff ff 85 db 41 0f 95
> c2 45 39 d9 41 0f 95 c1 45 84 ca 74 05 45 85 e4 78 0a 44 89 c2 e9 10
> ff ff ff <0f> 0b 01 d2 45 89 c1 41 29 d1 ba 00 00 00 00 44 0f 48 ca eb
> 80 cc
> [  161.582281] RSP: 0018:ffffc90000118e88 EFLAGS: 00010283
> [  161.588426] RAX: ffff888101f8f200 RBX: ffffc900006f9bd0 RCX: 000000000000050e
> [  161.596668] RDX: ffff888101fec000 RSI: 0000000000000a1c RDI: 0000000000061a10
> [  161.604860] RBP: ffffc90000118ef8 R08: 0000000000000000 R09: 0000000000061502
> [  161.613052] R10: 0000000000000000 R11: 0000000000000000 R12: 00000000ffffff3f
> [  161.621291] R13: ffff888101f8f140 R14: 0000000000000000 R15: ffff888100ad9b00
> [  161.629505] FS:  0000000000000000(0000) GS:ffff88903fe80000(0000)
> knlGS:00000 00000000000
> [  161.638781] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  161.645549] CR2: 00007f941ad43a9b CR3: 000000000340a000 CR4: 0000000000350ee0
> [  161.653841] Kernel panic - not syncing: Fatal exception in interrupt
> [  161.661287] Kernel Offset: disabled
> [  161.665644] Rebooting in 3 seconds..
> [  164.670313] ACPI MEMORY or I/O RESET_REG.
>
> Kyle.
