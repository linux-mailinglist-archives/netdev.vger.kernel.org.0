Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8027B5E7385
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 07:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbiIWFyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 01:54:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiIWFyf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 01:54:35 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 249E811ED6F;
        Thu, 22 Sep 2022 22:54:28 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id ay7-20020a05600c1e0700b003b49861bf48so4838709wmb.0;
        Thu, 22 Sep 2022 22:54:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date;
        bh=mX6LscYQaywr/arUNSlK6+ABiAAHXi/mztjD/fMbqMc=;
        b=H/k4tl3LY51MMlCnh3jcpoiROlbY15jk35YqS6e+egjkcnAuAdjc8XZO/OZhoGmG2A
         /M2eXfdbnQuMxRVATk90KUAjGuTP9OA67DzmZQyi+GKMPJSizzaDWFHgLE0p2KqzR93n
         Pum8oReOWjszPtTUyyHjHrbr9q7PhAw6DcqFGUdB4myCvIdrU1BKtITFBRitRTOMkNXw
         ui/owjDTfZwE2tnBJGTpzEuLt6cw0iQ9x6ACgmdEaAzH7I/j/+WGCyke2BFjMW/iDpy/
         eikDi7ILJL64kqdwKMSTYQqh14n1EFY/rtgx7U1xF7Vf1mwX1CDBde8NS4zZWDxWwbJC
         hO3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=mX6LscYQaywr/arUNSlK6+ABiAAHXi/mztjD/fMbqMc=;
        b=lxN00YoADqUqs2dbqaXxs546aDEV3xqWd+NfYyrlF2s6+r/xw670GpiWgwC5GErVXc
         qbhClS8D6UyALQwvdoTRpwKD8OtmknV7XuHFNxCIyGi6jtI4pDtILVtLyJMd1RvvdgLp
         4F6S+a1vzqE6JbyugtsqWv30O9ulVdYsUd/kTqDXnnjqsIcby+2oRCMkvJ8QcHgovRXX
         7d73P+j9EsNq4+QHdzQkwk4VgEdFZugC2q4Y9pJxygrjMl1TDmK3xdnQa1WziyaRofOr
         0MIwu1GemOXzeGICZtmgae8JvR0lqYhhNxBCuxu2RwtbgrSeGfFemv2zgvNKcyzSXuAx
         Dkwg==
X-Gm-Message-State: ACrzQf2/iofHqbt/TYMOvOM5FJETBEzPVS9eVC5JfMrHIn/6S4SqWiUx
        ONrXXDxTL9qM3wpoMXUDI9jc1MIqwmw=
X-Google-Smtp-Source: AMsMyM4kyd19qdmXlz38HdJUW/TlKt5nBsYWIUS+MWBWr5Vto3aCIEp5ArTxWGJRp9Je7TcZkybeYQ==
X-Received: by 2002:a05:600c:21c4:b0:3b4:9668:d3d5 with SMTP id x4-20020a05600c21c400b003b49668d3d5mr11694486wmj.155.1663912466334;
        Thu, 22 Sep 2022 22:54:26 -0700 (PDT)
Received: from smtpclient.apple ([178.254.237.20])
        by smtp.gmail.com with ESMTPSA id n13-20020adfe34d000000b002285f73f11dsm7949886wrj.81.2022.09.22.22.54.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Sep 2022 22:54:25 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: Bug Report Flowtable NFT with kernel 5.19.9
From:   Martin Zaharinov <micron10@gmail.com>
In-Reply-To: <20220922121254.GA19803@breakpoint.cc>
Date:   Fri, 23 Sep 2022 08:54:24 +0300
Cc:     Eric Dumazet <eric.dumazet@gmail.com>, pablo@netfilter.org,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org,
        linux-mm@kvack.org, mhocko@suse.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <0FE802BD-3E85-4038-9DBB-0B88E403BD92@gmail.com>
References: <09BE0B8A-3ADF-458E-B75E-931B74996355@gmail.com>
 <20220922121254.GA19803@breakpoint.cc>
To:     Florian Westphal <fw@strlen.de>
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

Hi Florian


Update kernel to 5.19.10 but still same now have small more info in =
dmesg check log down=20


this rull add for flow:

table inet filter {
        flowtable f {
                hook ingress priority 0
                devices =3D { bond0.100, vlan200, vlan234, vlan340, =
vlan2432, vlan3214,  vlan3675 }
        }

        chain forward {
                type filter hook forward priority raw; policy accept;
                ip protocol { tcp , udp, icmp } flow offload @f;
		ct state established,related accept
		ip protocol { tcp, udp, icmp } accept
        }
}

bond0.100 - is uplink

other vlanXXXX is to users

LOG. =E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=
=94>>>>

Sep 23 07:10:01  [  179.651419][   C16] invalid opcode: 0000 [#1] SMP
Sep 23 07:10:01  [  179.652068][   C16] CPU: 16 PID: 1565 Comm: zebra =
Tainted: G           O      5.19.10 #1
Sep 23 07:10:01  [  179.653170][   C16] Hardware name: Supermicro =
SYS-5038MR-H8TRF/X10SRD-F, BIOS 3.3 10/28/2020
Sep 23 07:10:01  [  179.654320][   C16] RIP: =
0010:__get_vm_area_node+0x120/0x130
Sep 23 07:10:01  [  179.655094][   C16] Code: ff bd ff ff ff ff 48 0f bd =
e8 b8 0c 00 00 00 ff c5 39 c5 0f 4c e8 b8 1e 00 00 00 39 c5 0f 4f e8 c4 =
e2 d1 f7 e9 e9 2e ff ff ff <0f> 0b 4c 89 ff e8 86 80 01 00 45 31 ff eb =
b6 90 41 57 41 56 41 55
Sep 23 07:10:01  [  179.657748][   C16] RSP: 0000:ffff8f47c0b8f888 =
EFLAGS: 00010206
Sep 23 07:10:01  [  179.658553][   C16] RAX: 00000000ffffffff RBX: =
0000000000002b20 RCX: 0000000000000100
Sep 23 07:10:01  [  179.659619][   C16] RDX: 0000000000000015 RSI: =
0000000000200000 RDI: 0000000000400040
Sep 23 07:10:01  [  179.660684][   C16] RBP: 0000000000000015 R08: =
ffff8f47c0000000 R09: ffffaf47bfffffff
Sep 23 07:10:01  [  179.661750][   C16] R10: 0000000000000010 R11: =
ffff8cce2ad46e40 R12: 0000000000000422
Sep 23 07:10:01  [  179.662815][   C16] R13: 0000000000400040 R14: =
0000000000000015 R15: fffffffffffffff5
Sep 23 07:10:01  [  179.663880][   C16] FS:  00007ff4c21d1bc0(0000) =
GS:ffff8cd41fa00000(0000) knlGS:0000000000000000
Sep 23 07:10:01  [  179.665077][   C16] CS:  0010 DS: 0000 ES: 0000 CR0: =
0000000080050033
Sep 23 07:10:01  [  179.665953][   C16] CR2: 0000000002492e98 CR3: =
000000010ffb3002 CR4: 00000000003706e0
Sep 23 07:10:01  [  179.667020][   C16] DR0: 0000000000000000 DR1: =
0000000000000000 DR2: 0000000000000000
Sep 23 07:10:01  [  179.668085][   C16] DR3: 0000000000000000 DR6: =
00000000fffe0ff0 DR7: 0000000000000400
Sep 23 07:10:01  [  179.669153][   C16] Call Trace:
Sep 23 07:10:01  [  179.669582][   C16]  <TASK>
Sep 23 07:10:01  [  179.669962][   C16]  __vmalloc_node_range+0x96/0x1e0
Sep 23 07:10:01  [  179.670639][   C16]  ? =
bucket_table_alloc.isra.0+0x47/0x140
Sep 23 07:10:01  [  179.670672][    C6] ------------[ cut here =
]------------
Sep 23 07:10:01  [  179.670714][   C14] ------------[ cut here =
]------------
Sep 23 07:10:01  [  179.670716][   C14] kernel BUG at mm/vmalloc.c:2437!
Sep 23 07:10:01  [  179.671395][   C16]  kvmalloc_node+0x92/0xb0
Sep 23 07:10:01  [  179.672111][   C27] ------------[ cut here =
]------------
Sep 23 07:10:01  [  179.672112][   C27] kernel BUG at mm/vmalloc.c:2437!
Sep 23 07:10:01  [  179.672118][    C6] kernel BUG at mm/vmalloc.c:2437!
Sep 23 07:10:01  [  179.672839][   C16]  ? =
bucket_table_alloc.isra.0+0x47/0x140
Sep 23 07:10:01  [  179.676931][   C16]  =
bucket_table_alloc.isra.0+0x47/0x140
Sep 23 07:10:01  [  179.677423][   C29] ------------[ cut here =
]------------
Sep 23 07:10:01  [  179.677662][   C16]  =
rhashtable_try_insert+0x3a4/0x440
Sep 23 07:10:01  [  179.678385][   C29] kernel BUG at mm/vmalloc.c:2437!
Sep 23 07:10:01  [  179.679082][   C16]  =
rhashtable_insert_slow+0x1b/0x30
Sep 23 07:10:01  [  179.680319][    C4] ------------[ cut here =
]------------
Sep 23 07:10:01  [  179.680444][   C16]  flow_offload_add+0x4d/0x130 =
[nf_flow_table]
Sep 23 07:10:01  [  179.681167][    C4] kernel BUG at mm/vmalloc.c:2437!
Sep 23 07:10:01  [  179.681985][   C16]  =
nft_flow_offload_eval+0x22c/0x2ab [nft_flow_offload]
Sep 23 07:10:01  [  179.683598][   C16]  ? dev_hard_start_xmit+0x95/0xe0
Sep 23 07:10:01  [  179.684275][   C16]  nft_do_chain+0x120/0x4c0 =
[nf_tables]
Sep 23 07:10:01  [  179.685017][   C16]  ? __pppoe_xmit+0x11c/0x190 =
[pppoe]
Sep 23 07:10:01  [  179.685727][   C16]  ? fib_validate_source+0x37/0xd0
Sep 23 07:10:01  [  179.686403][   C16]  ? __mkroute_input+0x102/0x310
Sep 23 07:10:01  [  179.687054][   C16]  ? =
ip_route_input_slow+0x394/0x8c0
Sep 23 07:10:01  [  179.687753][   C16]  ? =
nf_nat_ipv4_manip_pkt+0x53/0xe0 [nf_nat]
Sep 23 07:10:01  [  179.714083][   C16]  nft_do_chain_inet+0x76/0xc0 =
[nf_tables]
Sep 23 07:10:01  [  179.740597][   C16]  nf_hook_slow+0x36/0xa0
Sep 23 07:10:01  [  179.767009][   C16]  ip_forward+0x46c/0x4c0
Sep 23 07:10:01  [  179.792958][   C16]  ? lookup+0x82/0xf0
Sep 23 07:10:01  [  179.818252][   C16]  ? ip4_obj_hashfn+0xc0/0xc0
Sep 23 07:10:01  [  179.843125][   C16]  =
__netif_receive_skb_one_core+0x3f/0x50
Sep 23 07:10:01  [  179.867784][   C16]  process_backlog+0x7c/0x110
Sep 23 07:10:01  [  179.881772][    C1] ------------[ cut here =
]------------
Sep 23 07:10:01  [  179.891767][   C16]  __napi_poll+0x20/0x100
Sep 23 07:10:01  [  179.891772][   C16]  net_rx_action+0x26d/0x330
Sep 23 07:10:01  [  179.915310][    C1] kernel BUG at mm/vmalloc.c:2437!
Sep 23 07:10:01  [  179.938247][   C16]  __do_softirq+0xaf/0x1d7
Sep 23 07:10:01  [  180.006648][   C16]  __irq_exit_rcu+0x9a/0xd0
Sep 23 07:10:01  [  180.029429][   C16]  =
sysvec_call_function_single+0x32/0x80
Sep 23 07:10:01  [  180.052361][   C16]  =
asm_sysvec_call_function_single+0x16/0x20
Sep 23 07:10:01  [  180.075020][   C16] RIP: 0033:0x4cd65e
Sep 23 07:10:01  [  180.097176][   C16] Code: 5b 41 5c 41 5d 41 5e 41 5f =
5d c3 90 48 8b 50 08 48 81 fa 20 f7 58 00 74 d3 48 85 d2 74 ce 31 f6 0f =
1f 40 00 48 89 d0 48 8b 12 <8b> 48 38 48 81 fa 20 f7 58 00 74 26 83 f9 =
01 75 09 83 48 54 02 be
Sep 23 07:10:01  [  180.144341][   C16] RSP: 002b:00007ffce18b4490 =
EFLAGS: 00000246
Sep 23 07:10:01  [  180.168545][   C16] RAX: 00000000020edb60 RBX: =
0000000000000000 RCX: 00000000020e3f10
Sep 23 07:10:01  [  180.192866][   C16] RDX: 000000000058f720 RSI: =
0000000000000000 RDI: 00000000020e3f10
Sep 23 07:10:01  [  180.217209][   C16] RBP: 00007ffce18b44d0 R08: =
00007ff4c24d5b20 R09: 00007ff4c24d5b20
Sep 23 07:10:01  [  180.241690][   C16] R10: 0000000000000000 R11: =
0000000000000020 R12: 00000000ffffffff
Sep 23 07:10:01  [  180.266212][   C16] R13: 00000000020edec0 R14: =
00007ff4c2ae6340 R15: 00007ffce18b4540
Sep 23 07:10:01  [  180.290653][   C16]  </TASK>
Sep 23 07:10:01  [  180.315127][   C16] Modules linked in: =
nf_conntrack_netlink nft_limit pppoe pppox ppp_generic slhc nft_ct =
nft_flow_offload nf_flow_table_inet nf_flow_table nft_nat nft_chain_nat =
nf_tables netconsole coretemp bonding i40e nf_nat_sip nf_conntrack_sip =
nf_nat_pptp nf_conntrack_pptp nf_nat_tftp nf_conntrack_tftp nf_nat_ftp =
nf_conntrack_ftp nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 =
acpi_ipmi ipmi_si ipmi_devintf ipmi_msghandler rtc_cmos
Sep 23 07:10:04  [  180.427060][   C14] invalid opcode: 0000 [#2] SMP
Sep 23 07:10:04  [  180.427076][   C16] ---[ end trace 0000000000000000 =
]---
Sep 23 07:10:04  [  180.456698][   C14] CPU: 14 PID: 0 Comm: swapper/14 =
Tainted: G      D    O      5.19.10 #1
Sep 23 07:10:04  [  180.456702][   C14] Hardware name: Supermicro =
SYS-5038MR-H8TRF/X10SRD-F, BIOS 3.3 10/28/2020
Sep 23 07:10:04  [  180.456703][   C14] RIP: =
0010:__get_vm_area_node+0x120/0x130
Sep 23 07:10:04  [  180.486304][   C16] RIP: =
0010:__get_vm_area_node+0x120/0x130
Sep 23 07:10:04  [  180.516494][   C14] Code: ff bd ff ff ff ff 48 0f bd =
e8 b8 0c 00 00 00 ff c5 39 c5 0f 4c e8 b8 1e 00 00 00 39 c5 0f 4f e8 c4 =
e2 d1 f7 e9 e9 2e ff ff ff <0f> 0b 4c 89 ff e8 86 80 01 00 45 31 ff eb =
b6 90 41 57 41 56 41 55
Sep 23 07:10:04  [  180.516497][   C14] RSP: 0018:ffff8f47c0450950 =
EFLAGS: 00010206
Sep 23 07:10:04  [  180.547033][   C16] Code: ff bd ff ff ff ff 48 0f bd =
e8 b8 0c 00 00 00 ff c5 39 c5 0f 4c e8 b8 1e 00 00 00 39 c5 0f 4f e8 c4 =
e2 d1 f7 e9 e9 2e ff ff ff <0f> 0b 4c 89 ff e8 86 80 01 00 45 31 ff eb =
b6 90 41 57 41 56 41 55
Sep 23 07:10:04  [  180.577559][   C14]
Sep 23 07:10:04  [  180.577560][   C14] RAX: 00000000ffffffff RBX: =
0000000000002b20 RCX: 0000000000000100
Sep 23 07:10:04  [  180.577563][   C14] RDX: 0000000000000015 RSI: =
0000000000200000 RDI: 0000000000400040
Sep 23 07:10:04  [  180.607691][   C16] RSP: 0000:ffff8f47c0b8f888 =
EFLAGS: 00010206
Sep 23 07:10:04  [  180.670750][   C14] RBP: 0000000000000015 R08: =
ffff8f47c0000000 R09: ffffaf47bfffffff
Sep 23 07:10:04  [  180.670752][   C14] R10: 0000000000000010 R11: =
ffff8cce08348180 R12: 0000000000000422
Sep 23 07:10:04  [  180.670753][   C14] R13: 0000000000400040 R14: =
0000000000000015 R15: fffffffffffffff5
Sep 23 07:10:04  [  180.670755][   C14] FS:  0000000000000000(0000) =
GS:ffff8cd41f980000(0000) knlGS:0000000000000000
Sep 23 07:10:04  [  180.702393][   C16]
Sep 23 07:10:04  [  180.767917][   C14] CS:  0010 DS: 0000 ES: 0000 CR0: =
0000000080050033
Sep 23 07:10:04  [  180.767920][   C14] CR2: 00007fd6aad174a0 CR3: =
0000000106941004 CR4: 00000000003706e0
Sep 23 07:10:04  [  180.767921][   C14] DR0: 0000000000000000 DR1: =
0000000000000000 DR2: 0000000000000000
Sep 23 07:10:04  [  180.767922][   C14] DR3: 0000000000000000 DR6: =
00000000fffe0ff0 DR7: 0000000000000400
Sep 23 07:10:04  [  180.767923][   C14] Call Trace:
Sep 23 07:10:04  [  180.800058][   C16] RAX: 00000000ffffffff RBX: =
0000000000002b20 RCX: 0000000000000100
Sep 23 07:10:04  [  180.833230][   C14]  <IRQ>
Sep 23 07:10:04  [  180.833233][   C14]  __vmalloc_node_range+0x96/0x1e0
Sep 23 07:10:04  [  180.866187][   C16] RDX: 0000000000000015 RSI: =
0000000000200000 RDI: 0000000000400040
Sep 23 07:10:04  [  180.899166][   C14]  ? =
bucket_table_alloc.isra.0+0x47/0x140
Sep 23 07:10:04  [  180.932671][   C16] RBP: 0000000000000015 R08: =
ffff8f47c0000000 R09: ffffaf47bfffffff
Sep 23 07:10:04  [  180.966165][   C14]  kvmalloc_node+0x92/0xb0
Sep 23 07:10:04  [  180.999641][   C16] R10: 0000000000000010 R11: =
ffff8cce2ad46e40 R12: 0000000000000422
Sep 23 07:10:04  [  181.033426][   C14]  ? =
bucket_table_alloc.isra.0+0x47/0x140
Sep 23 07:10:04  [  181.066801][   C16] R13: 0000000000400040 R14: =
0000000000000015 R15: fffffffffffffff5
Sep 23 07:10:04  [  181.101028][   C14]  =
bucket_table_alloc.isra.0+0x47/0x140
Sep 23 07:10:04  [  181.135829][   C16] FS:  00007ff4c21d1bc0(0000) =
GS:ffff8cd41fa00000(0000) knlGS:0000000000000000
Sep 23 07:10:04  [  181.170624][   C14]  =
rhashtable_try_insert+0x3a4/0x440
Sep 23 07:10:04  [  181.205056][   C16] CS:  0010 DS: 0000 ES: 0000 CR0: =
0000000080050033
Sep 23 07:10:04  [  181.239090][   C14]  =
rhashtable_insert_slow+0x1b/0x30
Sep 23 07:10:04  [  181.274046][   C16] CR2: 0000000002492e98 CR3: =
000000010ffb3002 CR4: 00000000003706e0
Sep 23 07:10:04  [  181.308594][   C14]  flow_offload_add+0x4d/0x130 =
[nf_flow_table]
Sep 23 07:10:04  [  181.343542][   C16] DR0: 0000000000000000 DR1: =
0000000000000000 DR2: 0000000000000000
Sep 23 07:10:04  [  181.379181][   C14]  =
nft_flow_offload_eval+0x22c/0x2ab [nft_flow_offload]
Sep 23 07:10:04  [  181.414802][   C16] DR3: 0000000000000000 DR6: =
00000000fffe0ff0 DR7: 0000000000000400
Sep 23 07:10:04  [  181.451204][   C14]  nft_do_chain+0x120/0x4c0 =
[nf_tables]
Sep 23 07:10:04  [  181.487413][   C16] Kernel panic - not syncing: =
Fatal exception in interrupt
Sep 23 07:10:04  [  181.524356][   C14]  ? rt_cache_route+0xc5/0xe0
Sep 23 07:10:04  [  181.561275][   C14]  ? =
rt_set_nexthop.constprop.0+0x1bf/0x420
Sep 23 07:10:04  [  181.598336][   C14]  ? dst_alloc+0x133/0x150
Sep 23 07:10:04  [  181.634807][   C14]  ? __mkroute_input+0x192/0x310
Sep 23 07:10:04  [  181.671737][   C14]  ? =
ip_route_input_slow+0x394/0x8c0
Sep 23 07:10:04  [  181.708488][   C14]  ? =
nf_nat_ipv4_manip_pkt+0x53/0xe0 [nf_nat]
Sep 23 07:10:04  [  181.745869][   C14]  nft_do_chain_inet+0x76/0xc0 =
[nf_tables]
Sep 23 07:10:04  [  181.783168][   C14]  nf_hook_slow+0x36/0xa0
Sep 23 07:10:04  [  181.821108][   C14]  ip_forward+0x46c/0x4c0
Sep 23 07:10:04  [  181.859196][   C14]  ? lookup+0x82/0xf0
Sep 23 07:10:04  [  181.897547][   C14]  ? ip4_obj_hashfn+0xc0/0xc0
Sep 23 07:10:04  [  181.935410][   C14]  =
__netif_receive_skb_one_core+0x3f/0x50
Sep 23 07:10:04  [  181.972790][   C14]  process_backlog+0x7c/0x110
Sep 23 07:10:04  [  182.009175][   C14]  __napi_poll+0x20/0x100
Sep 23 07:10:04  [  182.045007][   C14]  net_rx_action+0x26d/0x330
Sep 23 07:10:04  [  182.079976][   C14]  __do_softirq+0xaf/0x1d7
Sep 23 07:10:04  [  182.115176][   C14]  do_softirq+0x5a/0x80
Sep 23 07:10:04  [  182.150034][   C14]  </IRQ>
Sep 23 07:10:04  [  182.184488][   C14]  <TASK>
Sep 23 07:10:04  [  182.218568][   C14]  =
flush_smp_call_function_queue+0x3f/0x60
Sep 23 07:10:04  [  182.253213][   C14]  do_idle+0xa6/0xc0
Sep 23 07:10:04  [  182.287348][   C14]  cpu_startup_entry+0x14/0x20
Sep 23 07:10:04  [  182.320668][   C14]  start_secondary+0xd6/0xe0
Sep 23 07:10:04  [  182.353300][   C14]  =
secondary_startup_64_no_verify+0xd3/0xdb
Sep 23 07:10:04  [  182.385163][   C14]  </TASK>
Sep 23 07:10:04  [  182.416402][   C14] Modules linked in: =
nf_conntrack_netlink nft_limit
Sep 23 07:10:04  [  182.516786][   C16] Shutting down cpus with NMI
Sep 23 07:10:04  [  182.620973][   C16] Kernel Offset: 0x13000000 from =
0xffffffff81000000 (relocation range: =
0xffffffff80000000-0xffffffffbfffffff)
Sep 23 07:10:04  [  182.624896][   C16] Rebooting in 10 seconds..


Best regrads,
Martin

> On 22 Sep 2022, at 15:12, Florian Westphal <fw@strlen.de> wrote:
>=20
> Martin Zaharinov <micron10@gmail.com> wrote:
>> This is bug report for flowtable and kernel 5.19.9
>>=20
>> simple config nat + flowtable=20
>=20
> CC mm experts.  I'm not sure that this is a bug in =
netfilter/rhashtable,
> looks like mm problem perhaps?
>=20
> I am a bit confused wrt. kvzalloc+GFP_ATOMIC.  This looks like =
following is happening:
>=20
> 5.19.9 kernel BUGs with:
>=20
>> Sep 22 07:43:49  [460691.305266][   C28] kernel BUG at =
mm/vmalloc.c:2437!
>=20
> [ BUG_ON(in_interrupt ]
>=20
>> Sep 22 07:43:50  [460692.031617][   C28] Call Trace:
>> Sep 22 07:43:50  [460692.064498][   C28]  <IRQ>
>> Sep 22 07:43:50  [460692.096177][   C28]  =
__vmalloc_node_range+0x96/0x1e0
>> Sep 22 07:43:50  [460692.128014][   C28]  ? =
bucket_table_alloc.isra.0+0x47/0x140
>> Sep 22 07:43:50  [460692.160134][   C28]  kvmalloc_node+0x92/0xb0
>> Sep 22 07:43:50  [460692.191885][   C28]  ? =
bucket_table_alloc.isra.0+0x47/0x140
>> Sep 22 07:43:50  [460692.224234][   C28]  =
bucket_table_alloc.isra.0+0x47/0x140
>> Sep 22 07:43:50  [460692.256840][   C28]  =
rhashtable_try_insert+0x3a4/0x440
>=20
> [ rest irrelevant ]
>=20
> AFAICS this is caused by kvzalloc(GFP_ATOMIC) which somehow ends up in
> GFP_KERNEL-only territory?  Looking at recent history I see
>=20
> commit a421ef303008b0ceee2cfc625c3246fa7654b0ca
> Author: Michal Hocko <mhocko@suse.com>
> Date:   Fri Jan 14 14:07:07 2022 -0800
>=20
>    mm: allow !GFP_KERNEL allocations for kvmalloc
>=20
> before this, GFP_ATOMIC made sure we stay with plain kmalloc, but
> now it appears that we can end up in places where GFP_ATOMIC isn't
> allowed?
>=20
> Original bug report is here:
> =
https://lore.kernel.org/netdev/09BE0B8A-3ADF-458E-B75E-931B74996355@gmail.=
com/T/#u

