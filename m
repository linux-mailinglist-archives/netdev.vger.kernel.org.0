Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9997F25E5F8
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 09:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726372AbgIEH1D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 03:27:03 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:39826 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725818AbgIEH1C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Sep 2020 03:27:02 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id A7120D06C3C6472CE166
        for <netdev@vger.kernel.org>; Sat,  5 Sep 2020 15:26:56 +0800 (CST)
Received: from huawei.com (10.175.124.27) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.487.0; Sat, 5 Sep 2020
 15:26:47 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <weiyongjun1@huawei.com>, <yangyingliang@huawei.com>
Subject: [Question] Oops when using connector in linux-4.19
Date:   Sat, 5 Sep 2020 15:25:50 +0800
Message-ID: <20200905072550.886537-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I got some crashes when using connector module in linux-4.19:

log1:

[10385482.776385] Unable to handle kernel paging request at virtual address 000000030000004c
[10385482.777083] Mem abort info:
[10385482.777340]   ESR = 0x96000004
[10385482.777578]   Exception class = DABT (current EL), IL = 32 bits
[10385482.778034]   SET = 0, FnV = 0
[10385482.778282]   EA = 0, S1PTW = 0
[10385482.778531] Data abort info:
[10385482.778851]   ISV = 0, ISS = 0x00000004
[10385482.779162]   CM = 0, WnR = 0
[10385482.779419] user pgtable: 4k pages, 48-bit VAs, pgdp = 00000000c16a0f04
[10385482.779930] [000000030000004c] pgd=0000000000000000
[10385482.780318] Internal error: Oops: 96000004 [#1] SMP
[10385482.780690] Process sudo (pid: 60096, stack limit = 0x0000000066055412)
[10385482.781225] CPU: 0 PID: 60096 Comm: sudo Kdump: loaded Tainted: G           OE K   4.19.36 #1
[10385482.782098] Hardware name: OpenStack Foundation OpenStack Nova, BIOS 0.0.0 02/06/2015
[10385482.782732] pstate: 60400005 (nZCv daif +PAN -UAO)
[10385482.783192] pc : __kmalloc_node_track_caller+0x214/0x348
[10385482.783692] lr : __kmalloc_node_track_caller+0x6c/0x348
[10385482.784194] sp : ffff00001802bbb0
[10385482.784515] x29: ffff00001802bbb0 x28: ffff800b53290000
[10385482.784999] x27: 00000000ffffffff x26: 000000000000003c
[10385482.785487] x25: ffff800ffc3a7800 x24: ffff800ffc3a7800
[10385482.785970] x23: ffff000008864af0 x22: 00000000ffffffff
[10385482.786450] x21: 00000000000001c0 x20: 0000000000410200
[10385482.786995] x19: 000000030000004c x18: 0000000000000000
[10385482.787486] x17: 0000000000000000 x16: 0000000000000000
[10385482.787983] x15: 0000000000000000 x14: 0000000000000000
[10385482.788478] x13: 0000000000000000 x12: 0000000000000000
[10385482.788979] x11: 0000000000000000 x10: ffff800fb38ac800
[10385482.789441] x9 : 0000000000000000 x8 : 0000000000000000
[10385482.789947] x7 : ffff8011b2130380 x6 : ffff801eeb758500
[10385482.790456] x5 : 00000000089bccdf x4 : ffff800fff8d2620
[10385482.790997] x3 : ffff000008864af0 x2 : 0000800ff69ce000
[10385482.791509] x1 : 0000800ff69ce000 x0 : 0000000000000000
[10385482.792029] Call trace:
[10385482.792265]  __kmalloc_node_track_caller+0x214/0x348
[10385482.792726]  __kmalloc_reserve.isra.9+0x54/0xb0
[10385482.793158]  __alloc_skb+0x90/0x1b0
[10385482.793500]  cn_netlink_send_mult+0x148/0x268
[10385482.793909]  cn_netlink_send+0x40/0x50
[10385482.794261]  proc_id_connector+0x130/0x170
[10385482.794644]  commit_creds+0x10c/0x2c0
[10385482.795047]  __sys_setresuid+0x1f0/0x228
[10385482.795410]  __arm64_sys_setresuid+0x28/0x38
[10385482.795816]  el0_svc_common+0x78/0x130
[10385482.796174]  el0_svc_handler+0x38/0x78
[10385482.796537]  el0_svc+0x8/0xc


log2:

[22635000.696206] Unable to handle kernel paging request at virtual address 000000030000004c
[22635000.704370] Mem abort info:
[22635000.707417]   ESR = 0x96000004
[22635000.710723]   Exception class = DABT (current EL), IL = 32 bits
[22635000.716878]   SET = 0, FnV = 0
[22635000.720183]   EA = 0, S1PTW = 0
[22635000.723575] Data abort info:
[22635000.726709]   ISV = 0, ISS = 0x00000004
[22635000.730792]   CM = 0, WnR = 0
[22635000.734011] user pgtable: 4k pages, 48-bit VAs, pgdp = 00000000cfe46aff
[22635000.740859] [000000030000004c] pgd=0000000000000000
[22635000.745980] Internal error: Oops: 96000004 [#1] SMP
[22635000.751094] Process thread-pool-6 (pid: 44316, stack limit = 0x00000000378f8b35)
[22635000.758717] CPU: 49 PID: 44316 Comm: thread-pool-6 Kdump: loaded Tainted: G           OE K   4.19.36 #1
[22635000.771695] Hardware name: Huawei TaiShan 2280 V2/BC82AMDD, BIOS 1.05 09/18/2019
[22635000.779314] pstate: 60400009 (nZCv daif +PAN -UAO)
[22635000.784348] pc : __kmalloc_node_track_caller+0x214/0x348
[22635000.789894] lr : __kmalloc_node_track_caller+0x6c/0x348
[22635000.795353] sp : ffff0000259a3800
[22635000.798912] x29: ffff0000259a3800 x28: 0000000000000000
[22635000.804459] x27: 0000000000000022 x26: 0000000000000022
[22635000.810007] x25: ffff803f7f40f800 x24: ffff803f7f40f800
[22635000.815555] x23: ffff000008864af0 x22: 00000000ffffffff
[22635000.821103] x21: 00000000000001c0 x20: 00000000006102c0
[22635000.826650] x19: 000000030000004c x18: 0000000000000000
[22635000.832198] x17: 0000000000000000 x16: 0000000000000000
[22635000.837746] x15: 0000000000000000 x14: 0000000000000000
[22635000.843293] x13: 0000000000000000 x12: 0000000000000000
[22635000.848839] x11: 0000000000000001 x10: 0000000000000000
[22635000.854385] x9 : 0000000000000001 x8 : 0000000000000000
[22635000.859932] x7 : 0000000000000022 x6 : ffff805f0ef09a00
[22635000.865478] x5 : 00000001d01b24b0 x4 : ffff805f7fa8c620
[22635000.871017] x3 : ffff000008864af0 x2 : 0000805f76b88000
[22635000.876563] x1 : 0000805f76b88000 x0 : 0000000000000000
[22635000.882110] Call trace:
[22635000.884805]  __kmalloc_node_track_caller+0x214/0x348
[22635000.890009]  __kmalloc_reserve.isra.9+0x54/0xb0
[22635000.894778]  __alloc_skb+0x90/0x1b0
[22635000.898513]  __ip_append_data.isra.3+0x7bc/0x948
[22635000.903368]  ip_append_data.part.4+0x98/0xe8
[22635000.907878]  ip_append_data+0x7c/0xa0
[22635000.911783]  raw_sendmsg+0x354/0x918
[22635000.915603]  inet_sendmsg+0x4c/0xf0
[22635000.919336]  sock_sendmsg+0x4c/0x70
[22635000.923069]  __sys_sendto+0x120/0x150
[22635000.926973]  __arm64_sys_sendto+0x30/0x40
[22635000.931227]  el0_svc_common+0x78/0x130
[22635000.935218]  el0_svc_handler+0x38/0x78
[22635000.939210]  el0_svc+0x8/0xc


log3:

[7761457.509241] Unable to handle kernel paging request at virtual address 000000030000004c
[7761457.517330] Mem abort info:
[7761457.520291]   ESR = 0x96000004
[7761457.523510]   Exception class = DABT (current EL), IL = 32 bits
[7761457.529586]   SET = 0, FnV = 0
[7761457.532807]   EA = 0, S1PTW = 0
[7761457.536112] Data abort info:
[7761457.539163]   ISV = 0, ISS = 0x00000004
[7761457.543157]   CM = 0, WnR = 0
[7761457.546287] user pgtable: 4k pages, 48-bit VAs, pgdp = 00000000dc9f556b
[7761457.553053] [000000030000004c] pgd=0000000000000000
[7761457.558089] Internal error: Oops: 96000004 [#1] SMP
[7761457.563118] Process sh (pid: 32899, stack limit = 0x00000000a691f0bc)
[7761457.569702] CPU: 40 PID: 32899 Comm: sh Kdump: loaded Tainted: P           OE K   4.19.36 #1
[7761457.581642] Hardware name: Huawei TaiShan 2280 V2/BC82AMDD, BIOS 1.06 10/29/2019
[7761457.589177] pstate: 20400009 (nzCv daif +PAN -UAO)
[7761457.594124] pc : __kmalloc+0xb0/0x2a0
[7761457.597943] lr : __kmalloc+0x64/0x2a0
[7761457.601761] sp : ffff000040dcbbb0
[7761457.605233] x29: ffff000040dcbbb0 x28: ffff805d04f11a00
[7761457.610685] x27: ffff805d13b3a400 x26: ffff805d13b3cc00
[7761457.616146] x25: 0000000000000001 x24: ffff803f7f40f800
[7761457.621607] x23: ffff803f7f40f800 x22: ffff0000083b4870
[7761457.627068] x21: 0000000000000188 x20: 00000000006000c0
[7761457.632529] x19: 000000030000004c x18: 0000000000000000
[7761457.637990] x17: 0000000000000000 x16: 0000000000000000
[7761457.643450] x15: 0000000000000000 x14: 001b001c00400007
[7761457.648902] x13: 0038004000000000 x12: 0000000000037e48
[7761457.654362] x11: 0000000000000040 x10: 0000000000001200
[7761457.659823] x9 : 0000000100b70003 x8 : 0000000000000000
[7761457.665283] x7 : 00010102464c457f x6 : ffff805d04f11a40
[7761457.670744] x5 : 00000000598aa0d4 x4 : ffff805f7f9a2620
[7761457.676204] x3 : 000000006474e552 x2 : ffff7e01744ece00
[7761457.681664] x1 : 0000805f76a9e000 x0 : 0000000000000000
[7761457.687125] Call trace:
[7761457.689733]  __kmalloc+0xb0/0x2a0
[7761457.693207]  load_elf_phdrs+0x88/0x100
[7761457.697111]  load_elf_binary+0x6c8/0xd88
[7761457.701190]  search_binary_handler+0xcc/0x2a0
[7761457.705701]  __do_execve_file.isra.13+0x614/0x7d0
[7761457.710556]  do_execve+0x48/0x58
[7761457.713942]  __arm64_sys_execve+0x30/0x40
[7761457.718109]  el0_svc_common+0x78/0x130
[7761457.722013]  el0_svc_handler+0x38/0x78
[7761457.725918]  el0_svc+0x8/0xc


log4:

[9853181.110976] Unable to handle kernel paging request at virtual address 000000030000004c
[9853181.119040] Mem abort info:
[9853181.122005]   ESR = 0x96000004
[9853181.125225]   Exception class = DABT (current EL), IL = 32 bits
[9853181.131299]   SET = 0, FnV = 0
[9853181.134517]   EA = 0, S1PTW = 0
[9853181.137823] Data abort info:
[9853181.140865]   ISV = 0, ISS = 0x00000004
[9853181.144861]   CM = 0, WnR = 0
[9853181.147996] user pgtable: 4k pages, 48-bit VAs, pgdp = 0000000093620c09
[9853181.154759] [000000030000004c] pgd=0000000000000000
[9853181.159796] Internal error: Oops: 96000004 [#1] SMP
[9853181.164825] Process sudo (pid: 78630, stack limit = 0x0000000036b23fb5)
[9853181.171583] CPU: 0 PID: 78630 Comm: sudo Kdump: loaded Tainted: P           OE K   4.19.36 #1
[9853181.183608] Hardware name: Huawei TaiShan 2280 V2/BC82AMDD, BIOS 1.06 10/29/2019
[9853181.191141] pstate: 60400009 (nZCv daif +PAN -UAO)
[9853181.196088] pc : __kmalloc_node_track_caller+0x214/0x348
[9853181.201548] lr : __kmalloc_node_track_caller+0x6c/0x348
[9853181.206922] sp : ffff0000245d3bb0
[9853181.210393] x29: ffff0000245d3bb0 x28: ffff803f216b0f80
[9853181.215855] x27: 00000000ffffffff x26: 000000000000003c
[9853181.221316] x25: ffff803f7f40f800 x24: ffff803f7f40f800
[9853181.226778] x23: ffff000008864af0 x22: 00000000ffffffff
[9853181.232239] x21: 00000000000001c0 x20: 0000000000410200
[9853181.237700] x19: 000000030000004c x18: 0000000000000000
[9853181.243161] x17: 0000000000000000 x16: 0000000000000000
[9853181.248622] x15: 0000000000000000 x14: 0000000000000000
[9853181.254083] x13: 0000000000000000 x12: 0000000000000000
[9853181.259544] x11: 0000000000000000 x10: ffff805f66092300
[9853181.265006] x9 : 0000000000000000 x8 : 0000000000000000
[9853181.270467] x7 : ffffa05ff3eeaa00 x6 : ffff805c7969ec00
[9853181.275928] x5 : 000000006d699b9e x4 : ffff803f7f8d2620
[9853181.281389] x3 : ffff000008864af0 x2 : 0000803f769ce000
[9853181.286850] x1 : 0000803f769ce000 x0 : 0000000000000000
[9853181.292311] Call trace:
[9853181.294921]  __kmalloc_node_track_caller+0x214/0x348
[9853181.300036]  __kmalloc_reserve.isra.9+0x54/0xb0
[9853181.304718]  __alloc_skb+0x90/0x1b0
[9853181.308366]  cn_netlink_send_mult+0x148/0x268
[9853181.312876]  cn_netlink_send+0x40/0x50
[9853181.316781]  proc_id_connector+0x130/0x170
[9853181.321034]  commit_creds+0x10c/0x2c0
[9853181.324853]  __sys_setresuid+0x1f0/0x228
[9853181.328930]  __arm64_sys_setresuid+0x28/0x38
[9853181.333354]  el0_svc_common+0x78/0x130
[9853181.337259]  el0_svc_handler+0x38/0x78
[9853181.341164]  el0_svc+0x8/0xc


The invalid address[0x000000030000004c] is the value of nlmsghdr from cn netlink, nlmsg_type is 3 and nlmsg_len is 0x4c.

It seems the skb->data pointer is freed wrongly:

Process A                                                   Process B

calls cn_netlink_send_mult()
skb = nlmsg_new(size, gfp_mask);
							unknown process calls kfree(skb->data)
                                                        //put skb->data pointer back to freelist of struct kmem_cache_cpu or struct page

nlh = nlmsg_put(skb, 0, msg->seq, NLMSG_DONE, size, 0);
//set (*skb->data) to 0x000000030000004c,
//so the freelist is broken here.


It's hardly to reproduce this crash, but If I stop using the connector, the system won't crash.
Is it possible the connector or netlink module free the skb->data wrongly when send/recv the skb ?

Thanks,
Yang
