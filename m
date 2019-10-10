Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6809D257E
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 11:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389332AbfJJJAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 05:00:34 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:38531 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387951AbfJJImq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 04:42:46 -0400
Received: by mail-ot1-f68.google.com with SMTP id e11so4173764otl.5
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 01:42:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aqKZzGWOzxwXTBlg4CGLMyhswIoplu9ByGdalU5gdY4=;
        b=CqSZ8F7NSle3JC9BIJtqPIdalxGz4ZLLIDpoLEQfTtkySNgmQQOfuMThtN2EGOvx2O
         HVACPD9YXJGbpDotapfQw74YIfEMMDVJSybDJKvwxMDI+fRZGjT46trWSrhw2cf6WrJD
         M/bNxTIeMfXwLkuKmvJ99hrkDACH6dGDyOMpdtbspRZ4D74k/nGaja5vCk41erY1+nIG
         PUau5+NDHFLifPx0RJ18q/j5ib3tTMlYtt7KKO9wYbT/GylMTAgcsMv+S0+pTq5pwakF
         5cF5xNt4v6wNHeh6wBT3e0PX2CmL5MjkCNRAMQxoKMoWVzhVBqoLFPXUD40XwXYgOxrw
         IgcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aqKZzGWOzxwXTBlg4CGLMyhswIoplu9ByGdalU5gdY4=;
        b=rXwh6GFH91Xqrv+xfAnxI85AUIpyWFGbTfNLmzOpzcCXbfD0jdZQ4ksr2/tdeRJjb3
         KE4eg8OmU5Qg5BaH6/Dy62e0h/Ye82scK6TGvfIeOqDFDGr0If0czvVg71Q3CvStx478
         NWx7raBo5LEp7GylWDewcEs2QBZwxtJQ+Br1rGcILglYh1mXroyKLtSR2LEAz//pY97M
         gXsuqCsvw8NDSTxW/Y5s+DSohiJ2VEriS05SfgDG6LO/jjS5SkatVzTX3zmtXZ4XKif4
         3A7JZM3mqW6jQhxA3K1JQ1vBuZ+Il1yIF9dWIddA5QHQ40xpd7DJHbY2+JoejVLmchtg
         Tsvg==
X-Gm-Message-State: APjAAAV2M7tXw8trw5dnlsSZ85LHEH9bStuyS3FI+t6UgAmhjkxyzDBW
        2GHClLkuyc51XU6lGt1k2zOnH8bfFB3m0WfRyf0=
X-Google-Smtp-Source: APXvYqz36RnbsKxjgRuWvfvmKsk1BPCDpboMvZuDB2yiicqibOssJgAXnQl0vzVwYi2FmW+Wyt9p6bDVdexxgQ1j9Lo=
X-Received: by 2002:a05:6830:2105:: with SMTP id i5mr7074006otc.334.1570696963834;
 Thu, 10 Oct 2019 01:42:43 -0700 (PDT)
MIME-Version: 1.0
References: <1570496438-15460-1-git-send-email-xiangxia.m.yue@gmail.com> <a9784bad-6e8d-eddc-4ddd-dd90ae31bc20@gmail.com>
In-Reply-To: <a9784bad-6e8d-eddc-4ddd-dd90ae31bc20@gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Thu, 10 Oct 2019 16:42:07 +0800
Message-ID: <CAMDZJNX79mZkaB-eWPR_hZbVL21Ccm0ySxcwopi3HLvFUNYw6w@mail.gmail.com>
Subject: Re: [PATCH net-next v2 00/10] optimize openvswitch flow looking up
To:     Gregory Rose <gvrose8192@gmail.com>
Cc:     Pravin Shelar <pshelar@ovn.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 9, 2019 at 1:33 AM Gregory Rose <gvrose8192@gmail.com> wrote:
>
>
> On 10/7/2019 6:00 PM, xiangxia.m.yue@gmail.com wrote:
> > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> >
> > This series patch optimize openvswitch for performance or simplify
> > codes.
> >
> > Patch 1, 2, 4: Port Pravin B Shelar patches to
> > linux upstream with little changes.
> >
> > Patch 5, 6, 7: Optimize the flow looking up and
> > simplify the flow hash.
> >
> > Patch 8, 9: are bugfix.
> >
> > The performance test is on Intel Xeon E5-2630 v4.
> > The test topology is show as below:
> >
> > +-----------------------------------+
> > |   +---------------------------+   |
> > |   | eth0   ovs-switch    eth1 |   | Host0
> > |   +---------------------------+   |
> > +-----------------------------------+
> >        ^                       |
> >        |                       |
> >        |                       |
> >        |                       |
> >        |                       v
> > +-----+----+             +----+-----+
> > | netperf  | Host1       | netserver| Host2
> > +----------+             +----------+
> >
> > We use netperf send the 64B packets, and insert 255+ flow-mask:
> > $ ovs-dpctl add-flow ovs-switch "in_port(1),eth(dst=00:01:00:00:00:00/ff:ff:ff:ff:ff:01),eth_type(0x0800),ipv4(frag=no)" 2
> > ...
> > $ ovs-dpctl add-flow ovs-switch "in_port(1),eth(dst=00:ff:00:00:00:00/ff:ff:ff:ff:ff:ff),eth_type(0x0800),ipv4(frag=no)" 2
> > $
> > $ netperf -t UDP_STREAM -H 2.2.2.200 -l 40 -- -m 18
> >
> > * Without series patch, throughput 8.28Mbps
> > * With series patch, throughput 46.05Mbps
> >
> > v1 -> v2:
> > 1. use kfree_rcu instead of call_rcu.
> > 2. add barrier when changing the ma->count.
> > 3. change the ma->max to ma->count in flow_lookup.
> >
> > Tonghao Zhang (10):
> >    net: openvswitch: add flow-mask cache for performance
> >    net: openvswitch: convert mask list in mask array
> >    net: openvswitch: shrink the mask array if necessary
> >    net: openvswitch: optimize flow-mask cache hash collision
> >    net: openvswitch: optimize flow-mask looking up
> >    net: openvswitch: simplify the flow_hash
> >    net: openvswitch: add likely in flow_lookup
> >    net: openvswitch: fix possible memleak on destroy flow-table
> >    net: openvswitch: don't unlock mutex when changing the user_features
> >      fails
> >    net: openvswitch: simplify the ovs_dp_cmd_new
> >
> >   net/openvswitch/datapath.c   |  65 +++++----
> >   net/openvswitch/flow.h       |   1 -
> >   net/openvswitch/flow_table.c | 315 +++++++++++++++++++++++++++++++++++++------
> >   net/openvswitch/flow_table.h |  19 ++-
> >   4 files changed, 328 insertions(+), 72 deletions(-)
> >
>
> Hi Tonghao,
>
> I've applied your patch series and built a 5.4.0-rc1 kernel with them.
>
> xxxxx@ubuntu-1604:~$ modinfo openvswitch
> filename: /lib/modules/5.4.0-rc1+/kernel/net/openvswitch/openvswitch.ko
> alias:          net-pf-16-proto-16-family-ovs_ct_limit
> alias:          net-pf-16-proto-16-family-ovs_meter
> alias:          net-pf-16-proto-16-family-ovs_packet
> alias:          net-pf-16-proto-16-family-ovs_flow
> alias:          net-pf-16-proto-16-family-ovs_vport
> alias:          net-pf-16-proto-16-family-ovs_datapath
> license:        GPL
> description:    Open vSwitch switching datapath
> srcversion:     F15EB8B4460D81BAA16216B
> depends: nf_conntrack,nf_nat,nf_conncount,libcrc32c,nf_defrag_ipv6,nsh
> retpoline:      Y
> intree:         Y
> name:           openvswitch
> vermagic:       5.4.0-rc1+ SMP mod_unload modversions
>
> I then built openvswitch master branch from github and ran 'make
> check-kernel'.
>
> In doing so I ran into the following splat in this test:
> 63: conntrack - IPv6 fragmentation + vlan
>
> Here is the splat:
> [  480.024215] ------------[ cut here ]------------
> [  480.024218] kernel BUG at net/openvswitch/flow_table.c:725!
> [  480.024267] invalid opcode: 0000 [#1] SMP PTI
> [  480.024297] CPU: 2 PID: 15717 Comm: ovs-vswitchd Tainted: G            E
> 5.4.0-rc1+ #131
> [  480.024345] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
> [  480.024386] RIP: 0010:ovs_flow_tbl_remove+0x151/0x160 [openvswitch]
> [  480.024424] Code: 55 f7 ea 89 f0 c1 f8 1f 29 c2 39 53 10 0f 8f 6a ff
> ff ff 48 89 ef d1 fe 5b 5d e9 8a ed ff ff 0f 0b 0f 0b b8 18 00 00 00 eb
> 92 <0f> 0b 0f 1f 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 41 57
> [  480.024527] RSP: 0018:ffffaf32c05e38c8 EFLAGS: 00010246
> [  480.024560] RAX: 0000000000000010 RBX: ffff9e4f6cd5a000 RCX:
> ffff9e4f6c585000
> [  480.024601] RDX: ffff9e4f6cd5a098 RSI: 0000000000000010 RDI:
> ffff9e4f6b2c6d20
> [  480.024642] RBP: ffffaf32c05e3b70 R08: ffff9e4f6c1651c0 R09:
> ffff9e4f756a43c0
> [  480.024684] R10: 0000000000000000 R11: ffffffffc06e5500 R12:
> ffff9e4f6baf7800
> [  480.024742] R13: ffff9e4f6b2c6d20 R14: ffff9e4f724a4e14 R15:
> 0000000000000007
> [  480.024790] FS:  00007fdd76058980(0000) GS:ffff9e4f77b00000(0000)
> knlGS:0000000000000000
> [  480.024836] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  480.024871] CR2: 00007ffd18a5ac60 CR3: 0000000230f3a002 CR4:
> 00000000001606e0
> [  480.024917] Call Trace:
> [  480.024941]  action_fifos_exit+0x3240/0x37b0 [openvswitch]
> [  480.024979]  ? __switch_to_asm+0x40/0x70
> [  480.025005]  ? __switch_to_asm+0x34/0x70
> [  480.025031]  ? __switch_to_asm+0x40/0x70
> [  480.025056]  ? __switch_to_asm+0x40/0x70
> [  480.025082]  ? __switch_to_asm+0x34/0x70
> [  480.025108]  ? __switch_to_asm+0x40/0x70
> [  480.025134]  ? __switch_to_asm+0x34/0x70
> [  480.025159]  ? __switch_to_asm+0x40/0x70
> [  480.025185]  ? __switch_to_asm+0x34/0x70
> [  480.025210]  ? __switch_to_asm+0x40/0x70
> [  480.025236]  ? __switch_to_asm+0x34/0x70
> [  480.025262]  ? __switch_to_asm+0x40/0x70
> [  480.025287]  ? __switch_to_asm+0x34/0x70
> [  480.025312]  ? __switch_to_asm+0x40/0x70
> [  480.025338]  ? __switch_to_asm+0x34/0x70
> [  480.025364]  ? __switch_to_asm+0x40/0x70
> [  480.025389]  ? __switch_to_asm+0x34/0x70
> [  480.025415]  ? __switch_to_asm+0x40/0x70
> [  480.025443]  ? __update_load_avg_se+0x11c/0x2e0
> [  480.025472]  ? __update_load_avg_se+0x11c/0x2e0
> [  480.025503]  ? update_load_avg+0x7e/0x600
> [  480.025529]  ? update_load_avg+0x7e/0x600
> [  480.025556]  ? update_curr+0x85/0x1d0
> [  480.025582]  ? cred_has_capability+0x85/0x130
> [  480.025611]  ? __nla_validate_parse+0x57/0x8a0
> [  480.025640]  ? _cond_resched+0x15/0x40
> [  480.025666]  ? genl_family_rcv_msg_attrs_parse.isra.14+0x93/0x100
> [  480.026523]  genl_rcv_msg+0x1d9/0x490
> [  480.027385]  ? __switch_to_asm+0x34/0x70
> [  480.028230]  ? __switch_to_asm+0x40/0x70
> [  480.029050]  ? __switch_to_asm+0x40/0x70
> [  480.029874]  ? genl_family_rcv_msg_attrs_parse.isra.14+0x100/0x100
> [  480.030673]  netlink_rcv_skb+0x4a/0x110
> [  480.031465]  genl_rcv+0x24/0x40
> [  480.032312]  netlink_unicast+0x1a0/0x250
> [  480.033059]  netlink_sendmsg+0x2b4/0x3b0
> [  480.033758]  sock_sendmsg+0x5b/0x60
> [  480.034422]  ___sys_sendmsg+0x278/0x2f0
> [  480.035083]  ? file_update_time+0x60/0x130
> [  480.035680]  ? pipe_write+0x286/0x400
> [  480.036290]  ? new_sync_write+0x12d/0x1d0
> [  480.036882]  ? __sys_sendmsg+0x5e/0xa0
> [  480.037452]  __sys_sendmsg+0x5e/0xa0
> [  480.038013]  do_syscall_64+0x52/0x1a0
> [  480.038546]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [  480.039083] RIP: 0033:0x7fdd7537fa6d
> [  480.039596] Code: b9 20 00 00 75 10 b8 2e 00 00 00 0f 05 48 3d 01 f0
> ff ff 73 31 c3 48 83 ec 08 e8 fe f6 ff ff 48 89 04 24 b8 2e 00 00 00 0f
> 05 <48> 8b 3c 24 48 89 c2 e8 47 f7 ff ff 48 89 d0 48 83 c4 08 48 3d 01
> [  480.040769] RSP: 002b:00007ffd18a6ad40 EFLAGS: 00000293 ORIG_RAX:
> 000000000000002e
> [  480.041391] RAX: ffffffffffffffda RBX: 0000000000000001 RCX:
> 00007fdd7537fa6d
> [  480.042045] RDX: 0000000000000000 RSI: 00007ffd18a6ada0 RDI:
> 0000000000000014
> [  480.042713] RBP: 0000000002300870 R08: 0000000000000000 R09:
> 00007ffd18a6bd58
> [  480.043438] R10: 0000000000000000 R11: 0000000000000293 R12:
> 00007ffd18a6bb70
> [  480.044138] R13: 00007ffd18a6bd00 R14: 00007ffd18a6bb78 R15:
> 00007ffd18a6b230
> [  480.044852] Modules linked in: vport_vxlan(E) vxlan(E) vport_gre(E)
> ip_gre(E) ip_tunnel(E) vport_geneve(E) geneve(E) ip6_udp_tunnel(E)
> udp_tunnel(E) openvswitch(E) nsh(E) nf_conncount(E) nf_nat_tftp(E)
> nf_conntrack_tftp(E) nf_nat_ftp(E) nf_conntrack_ftp(E) nf_nat(E)
> nf_conntrack_netlink(E) ip6table_filter(E) ip6_tables(E)
> iptable_filter(E) ip_tables(E) x_tables(E) ip6_gre(E) ip6_tunnel(E)
> tunnel6(E) gre(E) bonding(E) 8021q(E) garp(E) stp(E) mrp(E) llc(E)
> veth(E) nfnetlink_cttimeout(E) nfnetlink(E) nf_conntrack(E)
> nf_defrag_ipv6(E) nf_defrag_ipv4(E) binfmt_misc(E) intel_rapl_msr(E)
> snd_hda_codec_generic(E) ledtrig_audio(E) snd_hda_intel(E)
> snd_intel_nhlt(E) joydev(E) snd_hda_codec(E) input_leds(E)
> snd_hda_core(E) snd_hwdep(E) intel_rapl_common(E) snd_pcm(E)
> snd_timer(E) serio_raw(E) snd(E) soundcore(E) i2c_piix4(E) mac_hid(E)
> ib_iser(E) rdma_cm(E) iw_cm(E) ib_cm(E) ib_core(E) configfs(E)
> iscsi_tcp(E) libiscsi_tcp(E) libiscsi(E) scsi_transport_iscsi(E)
> autofs4(E) btrfs(E) zstd_decompress(E)
> [  480.044888]  zstd_compress(E) raid10(E) raid456(E)
> async_raid6_recov(E) async_memcpy(E) async_pq(E) async_xor(E)
> async_tx(E) xor(E) raid6_pq(E) libcrc32c(E) raid1(E) raid0(E)
> multipath(E) linear(E) crct10dif_pclmul(E) crc32_pclmul(E)
> ghash_clmulni_intel(E) aesni_intel(E) qxl(E) crypto_simd(E) ttm(E)
> cryptd(E) glue_helper(E) drm_kms_helper(E) syscopyarea(E) sysfillrect(E)
> sysimgblt(E) fb_sys_fops(E) psmouse(E) drm(E) floppy(E) pata_acpi(E)
> [last unloaded: nf_conntrack_ftp]
> [  480.056765] ---[ end trace 4a8c4eceeb9f5dec ]---
> [  480.057953] RIP: 0010:ovs_flow_tbl_remove+0x151/0x160 [openvswitch]
> [  480.059134] Code: 55 f7 ea 89 f0 c1 f8 1f 29 c2 39 53 10 0f 8f 6a ff
> ff ff 48 89 ef d1 fe 5b 5d e9 8a ed ff ff 0f 0b 0f 0b b8 18 00 00 00 eb
> 92 <0f> 0b 0f 1f 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 41 57
> [  480.061623] RSP: 0018:ffffaf32c05e38c8 EFLAGS: 00010246
> [  480.062959] RAX: 0000000000000010 RBX: ffff9e4f6cd5a000 RCX:
> ffff9e4f6c585000
> [  480.064248] RDX: ffff9e4f6cd5a098 RSI: 0000000000000010 RDI:
> ffff9e4f6b2c6d20
> [  480.065524] RBP: ffffaf32c05e3b70 R08: ffff9e4f6c1651c0 R09:
> ffff9e4f756a43c0
> [  480.066830] R10: 0000000000000000 R11: ffffffffc06e5500 R12:
> ffff9e4f6baf7800
> [  480.068870] R13: ffff9e4f6b2c6d20 R14: ffff9e4f724a4e14 R15:
> 0000000000000007
> [  480.070081] FS:  00007fdd76058980(0000) GS:ffff9e4f77b00000(0000)
> knlGS:0000000000000000
> [  480.071340] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  480.072610] CR2: 00007ffd18a5ac60 CR3: 0000000230f3a002 CR4:
> 00000000001606e0
>
> You're hitting the BUG_ON here:
>
> /* Must be called with OVS mutex held. */
> void ovs_flow_tbl_remove(struct flow_table *table, struct sw_flow *flow)
> {
>          struct table_instance *ti = ovsl_dereference(table->ti);
>          struct table_instance *ufid_ti = ovsl_dereference(table->ufid_ti);
>
>          BUG_ON(table->count == 0);
> <------------------------------------------------ Here
Hi Greg,
Thanks for your work, I fixed it, when relloac mask_array I don't
update ma point in patch 5.

diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
index bc14b12..210018a 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -827,6 +827,8 @@ static int tbl_mask_array_add_mask(struct flow_table *tbl,
                                              MASK_ARRAY_SIZE_MIN);
                if (err)
                        return err;
+
+               ma = ovsl_dereference(tbl->mask_array);
        }

        BUG_ON(ovsl_dereference(ma->masks[ma->count]));

> Thanks,
>
> - Greg
