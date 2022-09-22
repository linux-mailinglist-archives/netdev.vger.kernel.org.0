Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE3335E5B17
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 08:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbiIVGI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 02:08:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbiIVGIz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 02:08:55 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5691AB514D;
        Wed, 21 Sep 2022 23:08:53 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id t7so13705628wrm.10;
        Wed, 21 Sep 2022 23:08:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:date:message-id:subject:mime-version:content-transfer-encoding
         :from:from:to:cc:subject:date;
        bh=l9Vt9e4Iu/ywfk86/2iuNNCQpd6QY/0DlVOVIc1eqdo=;
        b=YBl4ihSnxU9ZTRCFHxaL1JD0OVt+0kKYO6cLSj7BuUigaW5/95+KwuMH6nE9583p21
         Zxgv01yDsXQfI6iLVCSqdozNhqGKdp8Wz97vbHTDBTTFt/zCPuew9rL3TErBCfZDYzCz
         gk82YNfDDQYXiKbdy0TYuA3J6MN2jisW/g9lRN5zxbPlcdZiEgyvKhpVIDaMYu6sQHhX
         qKvmsBEFwBVDnHSZbqNm1CiRauvSAm4cFJlxvTbI1Kb6XQrgeEZUdunFswUvDbIwboRx
         47+BsLwlnsYMudYia+QzeCtKnMBdcghBbRCFgBvWxNRnmqx030QJAqvZrGkUZm6Iib3x
         FuTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:date:message-id:subject:mime-version:content-transfer-encoding
         :from:x-gm-message-state:from:to:cc:subject:date;
        bh=l9Vt9e4Iu/ywfk86/2iuNNCQpd6QY/0DlVOVIc1eqdo=;
        b=6UUqBPQ13AuvVu/El3iFcjkR4LU/xKoF4JHo0F8WCVl6zfT/Tj6lPU1mB0rlrrz+t0
         bRXIvVubsdxOkuuC6sMCaHN5JKDkuu1Qmmfqg3+cYug+qpc+rc5INESJDJ7//UTEEC2z
         shWhDJD22m7UrsEUUt/nftWW5hN7fzNIFFvZocDZUcad9eA9D7F81zh5RrbVrK0veXZe
         +FOg0xcthZyRmHsU1rNxW8C4GgeHBYWo7bF2X/XKK7NbKYVm5jX1YqISQXXjlTCneZkn
         ShhxP2NEfNZDZOjW4p2B2vWnvH/JUYUbbYiRmJy2vEPpdz4bmpr+Q9hnFdrQBdFXMq5C
         ZZyg==
X-Gm-Message-State: ACrzQf2veYVev0MMWRYra20qTl5FjoFjhuz6tkcvR+iE5JHT1yDMXadx
        cNiBZR4yk/l5IgrCi5X3tEN+fDADXxo=
X-Google-Smtp-Source: AMsMyM5h2615R+UQW3LJpdmFCWx03h2ZueSfqHDx1cOTvqlI78sCwI5yQ3j+sNnoyHhB7jihGRFGiQ==
X-Received: by 2002:a05:6000:1004:b0:22a:f5a7:747c with SMTP id a4-20020a056000100400b0022af5a7747cmr906324wrx.612.1663826931491;
        Wed, 21 Sep 2022 23:08:51 -0700 (PDT)
Received: from smtpclient.apple ([178.254.237.20])
        by smtp.gmail.com with ESMTPSA id z8-20020a05600c0a0800b003a342933727sm6140143wmp.3.2022.09.21.23.08.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 21 Sep 2022 23:08:50 -0700 (PDT)
From:   Martin Zaharinov <micron10@gmail.com>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Bug Report Flowtable NFT with kernel 5.19.9
Message-Id: <09BE0B8A-3ADF-458E-B75E-931B74996355@gmail.com>
Date:   Thu, 22 Sep 2022 09:08:49 +0300
To:     Florian Westphal <fw@strlen.de>,
        Eric Dumazet <eric.dumazet@gmail.com>, pablo@netfilter.org,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org,
        netfilter <netfilter@vger.kernel.org>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,Pablo and Eric

This is bug report for flowtable and kernel 5.19.9

simple config nat + flowtable=20


Sep 22 07:43:49  [460691.259144][   C28] ------------[ cut here =
]------------
Sep 22 07:43:49  [460691.305266][   C28] kernel BUG at =
mm/vmalloc.c:2437!
Sep 22 07:43:49  [460691.350494][   C28] invalid opcode: 0000 [#1] SMP
Sep 22 07:43:49  [460691.394815][   C28] CPU: 28 PID: 0 Comm: swapper/28 =
Tainted: G        W  O      5.19.9 #1
Sep 22 07:43:49  [460691.438893][   C28] Hardware name: Supermicro =
SYS-5038MR-H8TRF/X10SRD-F, BIOS 3.3 10/28/2020
Sep 22 07:43:49  [460691.482545][   C28] RIP: =
0010:__get_vm_area_node+0x120/0x130
Sep 22 07:43:50  [460691.525384][   C28] Code: ff bd ff ff ff ff 48 0f =
bd e8 b8 0c 00 00 00 ff c5 39 c5 0f 4c e8 b8 1e 00 00 00 39 c5 0f 4f e8 =
c4 e2 d1 f7 e9 e9 2e ff ff ff <0f> 0b 4c 89 ff e8 86 80 01 00 45 31 ff =
eb b6 90 41 57 41 56 41 55
Sep 22 07:43:50  [460691.611308][   C28] RSP: 0018:ffffb484406c0950 =
EFLAGS: 00010206
Sep 22 07:43:50  [460691.653294][   C28] RAX: 00000000ffffffff RBX: =
0000000000002b20 RCX: 0000000000000100
Sep 22 07:43:50  [460691.694895][   C28] RDX: 0000000000000015 RSI: =
0000000000200000 RDI: 0000000000400040
Sep 22 07:43:50  [460691.735452][   C28] RBP: 0000000000000015 R08: =
ffffb48440000000 R09: ffffd4843fffffff
Sep 22 07:43:50  [460691.775139][   C28] R10: 0000000000000010 R11: =
ffff9f0263dfc6c0 R12: 0000000000000422
Sep 22 07:43:50  [460691.813944][   C28] R13: 0000000000400040 R14: =
0000000000000015 R15: fffffffffffffff5
Sep 22 07:43:50  [460691.851938][   C28] FS:  0000000000000000(0000) =
GS:ffff9f089fd00000(0000) knlGS:0000000000000000
Sep 22 07:43:50  [460691.889498][   C28] CS:  0010 DS: 0000 ES: 0000 =
CR0: 0000000080050033
Sep 22 07:43:50  [460691.926124][   C28] CR2: 0000000000460ea0 CR3: =
000000023899a003 CR4: 00000000003706e0
Sep 22 07:43:50  [460691.962349][   C28] DR0: 0000000000000000 DR1: =
0000000000000000 DR2: 0000000000000000
Sep 22 07:43:50  [460691.997569][   C28] DR3: 0000000000000000 DR6: =
00000000fffe0ff0 DR7: 0000000000000400
Sep 22 07:43:50  [460692.031617][   C28] Call Trace:
Sep 22 07:43:50  [460692.064498][   C28]  <IRQ>
Sep 22 07:43:50  [460692.096177][   C28]  =
__vmalloc_node_range+0x96/0x1e0
Sep 22 07:43:50  [460692.128014][   C28]  ? =
bucket_table_alloc.isra.0+0x47/0x140
Sep 22 07:43:50  [460692.160134][   C28]  kvmalloc_node+0x92/0xb0
Sep 22 07:43:50  [460692.191885][   C28]  ? =
bucket_table_alloc.isra.0+0x47/0x140
Sep 22 07:43:50  [460692.224234][   C28]  =
bucket_table_alloc.isra.0+0x47/0x140
Sep 22 07:43:50  [460692.256840][   C28]  =
rhashtable_try_insert+0x3a4/0x440
Sep 22 07:43:50  [460692.288863][   C28]  =
rhashtable_insert_slow+0x1b/0x30
Sep 22 07:43:50  [460692.320345][   C28]  flow_offload_add+0x6e/0x130 =
[nf_flow_table]
Sep 22 07:43:50  [460692.351709][   C28]  =
nft_flow_offload_eval+0x22c/0x2ab [nft_flow_offload]
Sep 22 07:43:50  [460692.382998][   C28]  ? nft_rhash_lookup+0xe8/0x1b0 =
[nf_tables]
Sep 22 07:43:50  [460692.414226][   C28]  nft_do_chain+0x120/0x4c0 =
[nf_tables]
Sep 22 07:43:50  [460692.445492][   C28]  ? nft_do_chain+0x60/0x4c0 =
[nf_tables]
Sep 22 07:43:50  [460692.476915][   C28]  ? __dev_xmit_skb+0x1fc/0x4c0
Sep 22 07:43:51  [460692.508318][   C28]  ? =
fib_validate_source+0x37/0xd0
Sep 22 07:43:51  [460692.539150][   C28]  ? __mkroute_input+0x102/0x310
Sep 22 07:43:51  [460692.569601][   C28]  ? =
ip_route_input_slow+0x394/0x8c0
Sep 22 07:43:51  [460692.599666][   C28]  ? nf_conntrack_in+0x32f/0x500 =
[nf_conntrack]
Sep 22 07:43:51  [460692.629598][   C28]  nft_do_chain_inet+0x76/0xc0 =
[nf_tables]
Sep 22 07:43:51  [460692.659203][   C28]  nf_hook_slow+0x36/0xa0
Sep 22 07:43:51  [460692.688275][   C28]  ip_forward+0x46c/0x4c0
Sep 22 07:43:51  [460692.716786][   C28]  ? lookup+0x42/0xf0
Sep 22 07:43:51  [460692.744774][   C28]  ? ip4_obj_hashfn+0xc0/0xc0
Sep 22 07:43:51  [460692.772405][   C28]  =
__netif_receive_skb_one_core+0x3f/0x50
Sep 22 07:43:51  [460692.799925][   C28]  process_backlog+0x7c/0x110
Sep 22 07:43:51  [460692.827146][   C28]  __napi_poll+0x20/0x100
Sep 22 07:43:51  [460692.853971][   C28]  net_rx_action+0x26d/0x330
Sep 22 07:43:51  [460692.880116][   C28]  __do_softirq+0xaf/0x1d7
Sep 22 07:43:51  [460692.905939][   C28]  do_softirq+0x5a/0x80
Sep 22 07:43:51  [460692.931585][   C28]  </IRQ>
Sep 22 07:43:51  [460692.956920][   C28]  <TASK>
Sep 22 07:43:51  [460692.981744][   C28]  =
flush_smp_call_function_queue+0x3f/0x60
Sep 22 07:43:51  [460693.006615][   C28]  do_idle+0xa6/0xc0
Sep 22 07:43:51  [460693.031211][   C28]  cpu_startup_entry+0x14/0x20
Sep 22 07:43:51  [460693.054932][   C28]  start_secondary+0xd6/0xe0
Sep 22 07:43:51  [460693.077931][   C28]  =
secondary_startup_64_no_verify+0xd3/0xdb
Sep 22 07:43:51  [460693.100596][   C28]  </TASK>
Sep 22 07:43:51  [460693.122724][   C28] Modules linked in: =
nft_flow_offload nf_flow_table_inet nf_flow_table nf_nat_sip =
nf_conntrack_sip nf_nat_pptp nf_conntrack_pptp nf_nat_tftp =
nf_conntrack_tftp nf_nat_ftp nf_conntrack_ftp nft_limit =
nf_conntrack_netlink pppoe pppox ppp_generic slhc nft_nat nft_chain_nat =
nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables netconsole =
coretemp bonding i40e acpi_ipmi ipmi_si ipmi_devintf ipmi_msghandler =
rtc_cmos
Sep 22 07:43:51  [460693.225006][   C28] ---[ end trace 0000000000000000 =
]---=
