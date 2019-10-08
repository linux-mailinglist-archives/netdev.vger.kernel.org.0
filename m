Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42E7DCFFF4
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 19:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727604AbfJHRd1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 13:33:27 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:43052 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726138AbfJHRd1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 13:33:27 -0400
Received: by mail-pg1-f196.google.com with SMTP id i32so3321636pgl.10
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 10:33:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=vnFcDGZJh2ysFJVi/dwhui31uHSh1Rc8fUgzeGxoe44=;
        b=qUXQ8xOOG039kgGYSWpJeLoKEXBfrfJiP4dleGNmVQHkE9XFDAhDmNV6phvTqdg/re
         Suw5VhOal+KgonMome0cduGCZru1SYcxz90Hf8IZgbRMQIR5u+OsRJG6uMbEYXz1VQ84
         6qDplZJ8eSAy5+NGslzbcOhq4fL7zUCMRYzvgXbuQ1pJSiU9b55AspeSZn7Dv6PIY/7R
         TKXHc7OjUjqjtTXySl1KCQVbOgqNPblePodvxxtops8i1pO1WbS9teHaCV7io4IXfpwy
         yNYxIY6wTXjjhHBOHn8M67FrOubEoJjfY11+2mhPKgtG0xV//BSMnroO4JjiNt8M19jN
         nGcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=vnFcDGZJh2ysFJVi/dwhui31uHSh1Rc8fUgzeGxoe44=;
        b=I/5/qYIq2aMEb3NQ3B/zXjnF5SqSjjz83WZLE4m5FM2boW3qohyb54cUjBNAPV9Xrj
         cJXOkSPLdNhnOo4iRmxlstdOiFNc2BzOHtelRw8P+fwYsJrdSXP8v5vBMLQinhKW+VOY
         qnU6OCDidL+W3D1rceh1pxajtKzJs0cpoyAAcbMe0AM8dzQ/oLReIZCgmrT/cxnpLJRq
         YEr1cZtYVS7BL66+KIP2WLqdTG7z8n+DjaXBHmSBsODVKK0vSkqQbUBtv/zzM2YWw7uC
         9+PR8idQvl1vhYp6VvX269tTka02voGo4rH5R5/C/PY6xKQc1IYGJXDyHQtwoQtvY7c0
         aByg==
X-Gm-Message-State: APjAAAVvjvbIKRG2h2VJ7aalp7NXhPVd24CoYNcnzMQMqKqm+pfbabjp
        HBEwlyVrfHKi1d5/6f4z9ndmuJBP
X-Google-Smtp-Source: APXvYqwxSgzSjbPqw6RWZV61Vucp9hQ0u+K6Q3kfOonZID/6W4ldQOLmJofBwqsIEcrUV+2j0/mAOA==
X-Received: by 2002:a63:f852:: with SMTP id v18mr3477143pgj.198.1570556004119;
        Tue, 08 Oct 2019 10:33:24 -0700 (PDT)
Received: from [192.168.0.16] (97-115-119-26.ptld.qwest.net. [97.115.119.26])
        by smtp.gmail.com with ESMTPSA id v9sm17708818pfe.1.2019.10.08.10.33.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Oct 2019 10:33:23 -0700 (PDT)
Subject: Re: [PATCH net-next v2 00/10] optimize openvswitch flow looking up
To:     xiangxia.m.yue@gmail.com, pshelar@ovn.org
Cc:     netdev@vger.kernel.org
References: <1570496438-15460-1-git-send-email-xiangxia.m.yue@gmail.com>
From:   Gregory Rose <gvrose8192@gmail.com>
Message-ID: <a9784bad-6e8d-eddc-4ddd-dd90ae31bc20@gmail.com>
Date:   Tue, 8 Oct 2019 10:33:21 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1570496438-15460-1-git-send-email-xiangxia.m.yue@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/7/2019 6:00 PM, xiangxia.m.yue@gmail.com wrote:
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> This series patch optimize openvswitch for performance or simplify
> codes.
>
> Patch 1, 2, 4: Port Pravin B Shelar patches to
> linux upstream with little changes.
>
> Patch 5, 6, 7: Optimize the flow looking up and
> simplify the flow hash.
>
> Patch 8, 9: are bugfix.
>
> The performance test is on Intel Xeon E5-2630 v4.
> The test topology is show as below:
>
> +-----------------------------------+
> |   +---------------------------+   |
> |   | eth0   ovs-switch    eth1 |   | Host0
> |   +---------------------------+   |
> +-----------------------------------+
>        ^                       |
>        |                       |
>        |                       |
>        |                       |
>        |                       v
> +-----+----+             +----+-----+
> | netperf  | Host1       | netserver| Host2
> +----------+             +----------+
>
> We use netperf send the 64B packets, and insert 255+ flow-mask:
> $ ovs-dpctl add-flow ovs-switch "in_port(1),eth(dst=00:01:00:00:00:00/ff:ff:ff:ff:ff:01),eth_type(0x0800),ipv4(frag=no)" 2
> ...
> $ ovs-dpctl add-flow ovs-switch "in_port(1),eth(dst=00:ff:00:00:00:00/ff:ff:ff:ff:ff:ff),eth_type(0x0800),ipv4(frag=no)" 2
> $
> $ netperf -t UDP_STREAM -H 2.2.2.200 -l 40 -- -m 18
>
> * Without series patch, throughput 8.28Mbps
> * With series patch, throughput 46.05Mbps
>
> v1 -> v2:
> 1. use kfree_rcu instead of call_rcu.
> 2. add barrier when changing the ma->count.
> 3. change the ma->max to ma->count in flow_lookup.
>
> Tonghao Zhang (10):
>    net: openvswitch: add flow-mask cache for performance
>    net: openvswitch: convert mask list in mask array
>    net: openvswitch: shrink the mask array if necessary
>    net: openvswitch: optimize flow-mask cache hash collision
>    net: openvswitch: optimize flow-mask looking up
>    net: openvswitch: simplify the flow_hash
>    net: openvswitch: add likely in flow_lookup
>    net: openvswitch: fix possible memleak on destroy flow-table
>    net: openvswitch: don't unlock mutex when changing the user_features
>      fails
>    net: openvswitch: simplify the ovs_dp_cmd_new
>
>   net/openvswitch/datapath.c   |  65 +++++----
>   net/openvswitch/flow.h       |   1 -
>   net/openvswitch/flow_table.c | 315 +++++++++++++++++++++++++++++++++++++------
>   net/openvswitch/flow_table.h |  19 ++-
>   4 files changed, 328 insertions(+), 72 deletions(-)
>

Hi Tonghao,

I've applied your patch series and built a 5.4.0-rc1 kernel with them.

xxxxx@ubuntu-1604:~$ modinfo openvswitch
filename: /lib/modules/5.4.0-rc1+/kernel/net/openvswitch/openvswitch.ko
alias:          net-pf-16-proto-16-family-ovs_ct_limit
alias:          net-pf-16-proto-16-family-ovs_meter
alias:          net-pf-16-proto-16-family-ovs_packet
alias:          net-pf-16-proto-16-family-ovs_flow
alias:          net-pf-16-proto-16-family-ovs_vport
alias:          net-pf-16-proto-16-family-ovs_datapath
license:        GPL
description:    Open vSwitch switching datapath
srcversion:     F15EB8B4460D81BAA16216B
depends: nf_conntrack,nf_nat,nf_conncount,libcrc32c,nf_defrag_ipv6,nsh
retpoline:      Y
intree:         Y
name:           openvswitch
vermagic:       5.4.0-rc1+ SMP mod_unload modversions

I then built openvswitch master branch from github and ran 'make 
check-kernel'.

In doing so I ran into the following splat in this test:
63: conntrack - IPv6 fragmentation + vlan

Here is the splat:
[  480.024215] ------------[ cut here ]------------
[  480.024218] kernel BUG at net/openvswitch/flow_table.c:725!
[  480.024267] invalid opcode: 0000 [#1] SMP PTI
[  480.024297] CPU: 2 PID: 15717 Comm: ovs-vswitchd Tainted: G            E
5.4.0-rc1+ #131
[  480.024345] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
[  480.024386] RIP: 0010:ovs_flow_tbl_remove+0x151/0x160 [openvswitch]
[  480.024424] Code: 55 f7 ea 89 f0 c1 f8 1f 29 c2 39 53 10 0f 8f 6a ff 
ff ff 48 89 ef d1 fe 5b 5d e9 8a ed ff ff 0f 0b 0f 0b b8 18 00 00 00 eb 
92 <0f> 0b 0f 1f 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 41 57
[  480.024527] RSP: 0018:ffffaf32c05e38c8 EFLAGS: 00010246
[  480.024560] RAX: 0000000000000010 RBX: ffff9e4f6cd5a000 RCX: 
ffff9e4f6c585000
[  480.024601] RDX: ffff9e4f6cd5a098 RSI: 0000000000000010 RDI: 
ffff9e4f6b2c6d20
[  480.024642] RBP: ffffaf32c05e3b70 R08: ffff9e4f6c1651c0 R09: 
ffff9e4f756a43c0
[  480.024684] R10: 0000000000000000 R11: ffffffffc06e5500 R12: 
ffff9e4f6baf7800
[  480.024742] R13: ffff9e4f6b2c6d20 R14: ffff9e4f724a4e14 R15: 
0000000000000007
[  480.024790] FS:  00007fdd76058980(0000) GS:ffff9e4f77b00000(0000) 
knlGS:0000000000000000
[  480.024836] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  480.024871] CR2: 00007ffd18a5ac60 CR3: 0000000230f3a002 CR4: 
00000000001606e0
[  480.024917] Call Trace:
[  480.024941]  action_fifos_exit+0x3240/0x37b0 [openvswitch]
[  480.024979]  ? __switch_to_asm+0x40/0x70
[  480.025005]  ? __switch_to_asm+0x34/0x70
[  480.025031]  ? __switch_to_asm+0x40/0x70
[  480.025056]  ? __switch_to_asm+0x40/0x70
[  480.025082]  ? __switch_to_asm+0x34/0x70
[  480.025108]  ? __switch_to_asm+0x40/0x70
[  480.025134]  ? __switch_to_asm+0x34/0x70
[  480.025159]  ? __switch_to_asm+0x40/0x70
[  480.025185]  ? __switch_to_asm+0x34/0x70
[  480.025210]  ? __switch_to_asm+0x40/0x70
[  480.025236]  ? __switch_to_asm+0x34/0x70
[  480.025262]  ? __switch_to_asm+0x40/0x70
[  480.025287]  ? __switch_to_asm+0x34/0x70
[  480.025312]  ? __switch_to_asm+0x40/0x70
[  480.025338]  ? __switch_to_asm+0x34/0x70
[  480.025364]  ? __switch_to_asm+0x40/0x70
[  480.025389]  ? __switch_to_asm+0x34/0x70
[  480.025415]  ? __switch_to_asm+0x40/0x70
[  480.025443]  ? __update_load_avg_se+0x11c/0x2e0
[  480.025472]  ? __update_load_avg_se+0x11c/0x2e0
[  480.025503]  ? update_load_avg+0x7e/0x600
[  480.025529]  ? update_load_avg+0x7e/0x600
[  480.025556]  ? update_curr+0x85/0x1d0
[  480.025582]  ? cred_has_capability+0x85/0x130
[  480.025611]  ? __nla_validate_parse+0x57/0x8a0
[  480.025640]  ? _cond_resched+0x15/0x40
[  480.025666]  ? genl_family_rcv_msg_attrs_parse.isra.14+0x93/0x100
[  480.026523]  genl_rcv_msg+0x1d9/0x490
[  480.027385]  ? __switch_to_asm+0x34/0x70
[  480.028230]  ? __switch_to_asm+0x40/0x70
[  480.029050]  ? __switch_to_asm+0x40/0x70
[  480.029874]  ? genl_family_rcv_msg_attrs_parse.isra.14+0x100/0x100
[  480.030673]  netlink_rcv_skb+0x4a/0x110
[  480.031465]  genl_rcv+0x24/0x40
[  480.032312]  netlink_unicast+0x1a0/0x250
[  480.033059]  netlink_sendmsg+0x2b4/0x3b0
[  480.033758]  sock_sendmsg+0x5b/0x60
[  480.034422]  ___sys_sendmsg+0x278/0x2f0
[  480.035083]  ? file_update_time+0x60/0x130
[  480.035680]  ? pipe_write+0x286/0x400
[  480.036290]  ? new_sync_write+0x12d/0x1d0
[  480.036882]  ? __sys_sendmsg+0x5e/0xa0
[  480.037452]  __sys_sendmsg+0x5e/0xa0
[  480.038013]  do_syscall_64+0x52/0x1a0
[  480.038546]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  480.039083] RIP: 0033:0x7fdd7537fa6d
[  480.039596] Code: b9 20 00 00 75 10 b8 2e 00 00 00 0f 05 48 3d 01 f0 
ff ff 73 31 c3 48 83 ec 08 e8 fe f6 ff ff 48 89 04 24 b8 2e 00 00 00 0f 
05 <48> 8b 3c 24 48 89 c2 e8 47 f7 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[  480.040769] RSP: 002b:00007ffd18a6ad40 EFLAGS: 00000293 ORIG_RAX: 
000000000000002e
[  480.041391] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 
00007fdd7537fa6d
[  480.042045] RDX: 0000000000000000 RSI: 00007ffd18a6ada0 RDI: 
0000000000000014
[  480.042713] RBP: 0000000002300870 R08: 0000000000000000 R09: 
00007ffd18a6bd58
[  480.043438] R10: 0000000000000000 R11: 0000000000000293 R12: 
00007ffd18a6bb70
[  480.044138] R13: 00007ffd18a6bd00 R14: 00007ffd18a6bb78 R15: 
00007ffd18a6b230
[  480.044852] Modules linked in: vport_vxlan(E) vxlan(E) vport_gre(E) 
ip_gre(E) ip_tunnel(E) vport_geneve(E) geneve(E) ip6_udp_tunnel(E) 
udp_tunnel(E) openvswitch(E) nsh(E) nf_conncount(E) nf_nat_tftp(E) 
nf_conntrack_tftp(E) nf_nat_ftp(E) nf_conntrack_ftp(E) nf_nat(E) 
nf_conntrack_netlink(E) ip6table_filter(E) ip6_tables(E) 
iptable_filter(E) ip_tables(E) x_tables(E) ip6_gre(E) ip6_tunnel(E) 
tunnel6(E) gre(E) bonding(E) 8021q(E) garp(E) stp(E) mrp(E) llc(E) 
veth(E) nfnetlink_cttimeout(E) nfnetlink(E) nf_conntrack(E) 
nf_defrag_ipv6(E) nf_defrag_ipv4(E) binfmt_misc(E) intel_rapl_msr(E) 
snd_hda_codec_generic(E) ledtrig_audio(E) snd_hda_intel(E) 
snd_intel_nhlt(E) joydev(E) snd_hda_codec(E) input_leds(E) 
snd_hda_core(E) snd_hwdep(E) intel_rapl_common(E) snd_pcm(E) 
snd_timer(E) serio_raw(E) snd(E) soundcore(E) i2c_piix4(E) mac_hid(E) 
ib_iser(E) rdma_cm(E) iw_cm(E) ib_cm(E) ib_core(E) configfs(E) 
iscsi_tcp(E) libiscsi_tcp(E) libiscsi(E) scsi_transport_iscsi(E) 
autofs4(E) btrfs(E) zstd_decompress(E)
[  480.044888]  zstd_compress(E) raid10(E) raid456(E) 
async_raid6_recov(E) async_memcpy(E) async_pq(E) async_xor(E) 
async_tx(E) xor(E) raid6_pq(E) libcrc32c(E) raid1(E) raid0(E) 
multipath(E) linear(E) crct10dif_pclmul(E) crc32_pclmul(E) 
ghash_clmulni_intel(E) aesni_intel(E) qxl(E) crypto_simd(E) ttm(E) 
cryptd(E) glue_helper(E) drm_kms_helper(E) syscopyarea(E) sysfillrect(E) 
sysimgblt(E) fb_sys_fops(E) psmouse(E) drm(E) floppy(E) pata_acpi(E) 
[last unloaded: nf_conntrack_ftp]
[  480.056765] ---[ end trace 4a8c4eceeb9f5dec ]---
[  480.057953] RIP: 0010:ovs_flow_tbl_remove+0x151/0x160 [openvswitch]
[  480.059134] Code: 55 f7 ea 89 f0 c1 f8 1f 29 c2 39 53 10 0f 8f 6a ff 
ff ff 48 89 ef d1 fe 5b 5d e9 8a ed ff ff 0f 0b 0f 0b b8 18 00 00 00 eb 
92 <0f> 0b 0f 1f 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 41 57
[  480.061623] RSP: 0018:ffffaf32c05e38c8 EFLAGS: 00010246
[  480.062959] RAX: 0000000000000010 RBX: ffff9e4f6cd5a000 RCX: 
ffff9e4f6c585000
[  480.064248] RDX: ffff9e4f6cd5a098 RSI: 0000000000000010 RDI: 
ffff9e4f6b2c6d20
[  480.065524] RBP: ffffaf32c05e3b70 R08: ffff9e4f6c1651c0 R09: 
ffff9e4f756a43c0
[  480.066830] R10: 0000000000000000 R11: ffffffffc06e5500 R12: 
ffff9e4f6baf7800
[  480.068870] R13: ffff9e4f6b2c6d20 R14: ffff9e4f724a4e14 R15: 
0000000000000007
[  480.070081] FS:  00007fdd76058980(0000) GS:ffff9e4f77b00000(0000) 
knlGS:0000000000000000
[  480.071340] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  480.072610] CR2: 00007ffd18a5ac60 CR3: 0000000230f3a002 CR4: 
00000000001606e0

You're hitting the BUG_ON here:

/* Must be called with OVS mutex held. */
void ovs_flow_tbl_remove(struct flow_table *table, struct sw_flow *flow)
{
         struct table_instance *ti = ovsl_dereference(table->ti);
         struct table_instance *ufid_ti = ovsl_dereference(table->ufid_ti);

         BUG_ON(table->count == 0); 
<------------------------------------------------ Here

Thanks,

- Greg
