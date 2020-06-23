Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3459F204D21
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 10:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731846AbgFWIyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 04:54:35 -0400
Received: from mail-bn7nam10on2083.outbound.protection.outlook.com ([40.107.92.83]:57281
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731775AbgFWIye (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 04:54:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OCeHJYf+A+u+HWxrP8VZj97nIQ8TPMYZBaL9E4MzHO4HnOR13oTUqLwgA+o8Rs+xE9vRcE3tFew0pQZ56IPaLK1AOOqb5rAFsrDPgFV+I4qao3Fx8B+nVJKjmwgBnIz1H0rtSxM6J20Q2Cj/L50WfXsYRT0Cp+fWWZhi1dxmPnkDb1jsqCuP60S6nAPriUFTub3h/lpI0/lyd2RWfWyJ5WbrAMp3zRUdDFNYXGZ11zwkyN+/EH78P/E7kUcoixs9tLnES5yQZ/DGI13k9CdMYmFr2Tg47xZ+91W6U/xZKMBwcPZJ4vPtgx4WSKmdjK7yLj+oxa24NE5IzHg84jp4tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qWJJ/E2/DSD4wvG2CerfLUqF3QkQnDDeewBx5AotU1I=;
 b=nr+LkMY1aw/6c7sc2+NqYoJ2H4yq3F9R63an8nuCnNfxHAV7jpIDHyQg0RWtw0BOUoEAXSCQcAJK2kUV4DNdf4lCq1NgY8tSTno3YKsUSiZ3dFp6cmg8zrWvY01wEHO3GszzCfDKSe142khTNetIbhCx5sECVkBjtPoo3ZScnu4SLjLsP9tUeqb3LN9owDwX3MuLNAFJUk0o5NktV5+rpkP8aFQ+CpRis7N5LxOrZBCzZMzOftgtS+fxCLPcpdp+1PUFtvMQvkiQiJDddKFU/1yI7Mz3ND+JcaVI/PluIGcpKmLCwXE8gyhnxgQzw8BdgJuMwtieBJFwLsZdQgRPLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qWJJ/E2/DSD4wvG2CerfLUqF3QkQnDDeewBx5AotU1I=;
 b=Hjr2qdOfIm+BK/MsrlTcNVGQJgt37dbw1+Fyid5ERWoO5TCf4iihZL+yRnquz3R78VK8taQcnW72cGrhqE6+qM+h9T6iGnkdeFiCuJ45j0YRUKTgUj/5H1pILfmB/MU86leFVYkcNaLRq1n3RnxOb9f6mIGj8/vlLnn5v+gxBfA=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=windriver.com;
Received: from BYAPR11MB2632.namprd11.prod.outlook.com (2603:10b6:a02:c4::17)
 by BYAPR11MB2677.namprd11.prod.outlook.com (2603:10b6:a02:cd::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.23; Tue, 23 Jun
 2020 08:54:31 +0000
Received: from BYAPR11MB2632.namprd11.prod.outlook.com
 ([fe80::3d7d:dfc1:b35d:63d1]) by BYAPR11MB2632.namprd11.prod.outlook.com
 ([fe80::3d7d:dfc1:b35d:63d1%7]) with mapi id 15.20.3109.027; Tue, 23 Jun 2020
 08:54:31 +0000
To:     guro@fb.com
Cc:     lizefan@huawei.com,
        "xiyou.wangcong@gmail.com netdev"@vger.kernel.org,
        lizefan@huawei.com, lufq.fnst@cn.fujitsu.com,
        netdev@vger.kernel.org, pgwipeout@gmail.com, tj@kernel.org,
        xiyou.wangcong@gmail.com
References: <20200622203910.GE301338@carbon.dhcp.thefacebook.com>
Subject: Re: [Patch net] cgroup: fix cgroup_sk_alloc() for sk_clone_lock()
From:   "Zhang,Qiang" <qiang.zhang@windriver.com>
Message-ID: <4cf06b23-78a8-8d0b-0f24-f1096a895bd1@windriver.com>
Date:   Tue, 23 Jun 2020 16:54:22 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
In-Reply-To: <20200622203910.GE301338@carbon.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: HK2PR02CA0152.apcprd02.prod.outlook.com
 (2603:1096:201:1f::12) To BYAPR11MB2632.namprd11.prod.outlook.com
 (2603:10b6:a02:c4::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [128.224.162.183] (60.247.85.82) by HK2PR02CA0152.apcprd02.prod.outlook.com (2603:1096:201:1f::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20 via Frontend Transport; Tue, 23 Jun 2020 08:54:28 +0000
X-Originating-IP: [60.247.85.82]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 88c0b465-9532-4988-313d-08d817530b11
X-MS-TrafficTypeDiagnostic: BYAPR11MB2677:
X-Microsoft-Antispam-PRVS: <BYAPR11MB267709C57CE4639EA38F217DFF940@BYAPR11MB2677.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 04433051BF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E+QsOIgMWnTukjD+5ZFyt3Qh5fXD6PSjO2T+5cLPBt1D3zQU6tYcObQ1Vc69UkMSngVrx7ZyeRC1RlHaqGS4YeDR1+UZSKNMJTNPZ4xeVGIu6qc6jYs2BHDtm4nE3KlRGCCML7alHFOBca+S3KJdXbnqlyzMfwtfp/7h86yOGN4VOLcpNzWyFQMurvHNhhLt5NfBzzQlVEgCOzmUKMXTW/0gBbeMbp3Rq6MYXJrd7uQ62jgk4lyOr2fewETVDKU3dxenyh54+twgdA+PSnzuQVggOODZOnshx3N3BWngDmJHtdZ5fqERRMI6goW64uYrPsbE6+rCGbK1jrgBzgCXqNWRCCXocFkfo5Tyjxz+q9FEt8PbGyANVdD0g4gQG6Srw68LaqDD2uxil2dlGKrZ2Ia4G/eqnm1DvDKQVywWDO8VLfXq11v//z/koXiYdgMc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB2632.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(366004)(396003)(39850400004)(136003)(376002)(6706004)(6916009)(66946007)(16576012)(6666004)(66476007)(66556008)(316002)(956004)(2616005)(2906002)(8676002)(6486002)(31686004)(478600001)(45080400002)(4326008)(186003)(31696002)(8936002)(36756003)(5660300002)(83380400001)(86362001)(26005)(16526019)(52116002)(78286006)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: KnfsLCtYOcsGoEuiGcbF69/fIOhYqvw5BOY+fooxgF2t8Wp23e10XID9Wc/EzIAz174luGHvJhDcbcpmaKEGtwvmHVjGwWJMEI9gNHITlWu/tSq95lMYmN3BTgwIJoU86kHbOZVGzF+rvE16kkJppyVBZxGgIhqcB0EdYTTZDlm/SJc6PRUmghI8iv8rcuiAo6HDFEwI9twwIK0Ifo9G+K8qVB5TJNfY/H7Lt4zRR0NsuT1NAia4dtEo3X7ncGsuxXcm7kkli5+WUZqOwIdIuEftxDP6LSl+XpoFqXWdOIPNcm4F0csJpkOkQ7VdGwSsxLy+sTUEnlHD3J6IaMk2Obp5utvwkFChT0khLvxUUXZICO282Ka/hESBwWSmSkv79F0mIaRsw+Ilw0IXW/aZCirHQdFRVze/g5StpeYT1BZf4RtMDbLR4SaA8mBwo3Oy4M1djxg+wiqWAXxH7t7tzLOxQheppzYdRTNM+d9iFV4=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88c0b465-9532-4988-313d-08d817530b11
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2020 08:54:31.0154
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 19WBhdQfYORtk4iRmlydJmxGItVoSWQJDDQU39JtkQLrrqXgfrMyI3w5g5+jH5NBqg7Hqk59LW9tGnmBq+VMg6m5uTDodPgmpwkE0bJ07iE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2677
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



The tester found the following information during the test

The dmesg information is as follows (kernelv5.4) I don't know if it 
helps for this question


root@intel-x86-64:~# cgroup: cgroup: disabling cgroup2 socket matching 
due to net_prio or net_cls activation
IPv6: ADDRCONF(NETDEV_CHANGE): veth4c31d8d2: link becomes ready
cni0: port 1(veth4c31d8d2) entered blocking state
cni0: port 1(veth4c31d8d2) entered disabled state
device veth4c31d8d2 entered promiscuous mode
cni0: port 1(veth4c31d8d2) entered blocking state
cni0: port 1(veth4c31d8d2) entered forwarding state
IPv4: martian source 10.244.1.2 from 10.244.1.2, on dev cni0
ll header: 00000000: ff ff ff ff ff ff 12 88 f0 cc 64 b8 08 06
IPv4: martian source 10.244.1.2 from 10.244.1.2, on dev eth0
ll header: 00000000: ff ff ff ff ff ff 12 88 f0 cc 64 b8 08 06
IPv4: martian source 10.244.1.1 from 10.244.1.2, on dev eth0
ll header: 00000000: ff ff ff ff ff ff 12 88 f0 cc 64 b8 08 06
IPv6: ADDRCONF(NETDEV_CHANGE): vethb556dc7b: link becomes ready
cni0: port 2(vethb556dc7b) entered blocking state
cni0: port 2(vethb556dc7b) entered disabled state
device vethb556dc7b entered promiscuous mode
cni0: port 2(vethb556dc7b) entered blocking state
cni0: port 2(vethb556dc7b) entered forwarding state
IPv4: martian source 10.244.1.3 from 10.244.1.3, on dev eth0
ll header: 00000000: ff ff ff ff ff ff 1a d7 25 1c ca 18 08 06
IPv4: martian source 10.244.1.1 from 10.244.1.3, on dev eth0
ll header: 00000000: ff ff ff ff ff ff 1a d7 25 1c ca 18 08 06
IPv4: martian source 10.244.1.2 from 10.244.1.3, on dev eth0
ll header: 00000000: ff ff ff ff ff ff 1a d7 25 1c ca 18 08 06
-----------[ cut here ]-----------
percpu ref (cgroup_bpf_release_fn) <= 0 (-12) after switching to atomic
WARNING: CPU: 1 PID: 0 at lib/percpu-refcount.c:161 
percpu_ref_switch_to_atomic_rcu+0x12a/0x140
Modules linked in: ipt_REJECT nf_reject_ipv4 vxlan ip6_udp_tunnel 
udp_tunnel xt_statistic xt_nat xt_tcpudp iptable_mangle xt_comment 
xt_mark xt_MASQUERADE nf_conntrack_netlink nfnetlink xfrm_user 
iptable_nat xt_addrtype iptable_filter ip_tables xt_conntrack x_tables 
br_netfilter bridge stp llc bnep iTCO_wdt iTCO_vendor_support watchdog 
intel_powerclamp gpio_ich mgag200 drm_vram_helper drm_ttm_helper ttm 
i2c_i801 coretemp lpc_ich acpi_cpufreq sch_fq_codel openvswitch nsh 
nf_conncount nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nfsd
CPU: 1 PID: 0 Comm: swapper/1 Tainted: G I 5.7.0-yoctodev-standard #1
Hardware name: Intel Corporation S5520HC/S5520HC, BIOS 
S5500.86B.01.10.0025.030220091519 03/02/2009
RIP: 0010:percpu_ref_switch_to_atomic_rcu+0x12a/0x140
Code: 80 3d b1 42 3b 01 00 0f 85 56 ff ff ff 49 8b 54 24 d8 48 c7 c7 68 
57 1d a9 c6 05 98 42 3b 01 01 49 8b 74 24 e8 e8 ea 14 aa ff <0f> 0b e9 
32 ff ff ff 0f 0b eb 97 cc cc cc cc cc cc cc cc cc cc cc
RSP: 0018:ffff996183268e90 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 7ffffffffffffff3 RCX: 0000000000000000
RDX: 0000000000000102 RSI: ffffffffa9794aa7 RDI: 00000000ffffffff
RBP: ffff996183268ea8 R08: ffffffffa9794a60 R09: 0000000000000047
R10: 0000000080000001 R11: ffffffffa9794a8c R12: ffff95855904fef0
R13: 000023dc1ba33080 R14: ffff996183268ee0 R15: ffff95855904fef0
FS: 0000000000000000(0000) GS:ffff958563c00000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f62622f8658 CR3: 000000044fc0a000 CR4: 00000000000006e0
Call Trace:
<IRQ>
rcu_core+0x227/0x870
? timerqueue_add+0x68/0xa0
rcu_core_si+0xe/0x10
__do_softirq+0x102/0x358
? tick_program_event+0x4d/0x90
irq_exit+0xa0/0x110
smp_apic_timer_interrupt+0xa1/0x1b0
apic_timer_interrupt+0xf/0x20
</IRQ>
RIP: 0010:cpuidle_enter_state+0xc0/0x3c0
Code: 85 c0 0f 8f 28 02 00 00 31 ff e8 5b 1a 5f ff 45 84 ff 74 12 9c 58 
f6 c4 02 0f 85 d0 02 00 00 31 ff e8 34 ba 65 ff fb 45 85 e4 <0f> 88 cc 
00 00 00 49 63 cc 4c 2b 75 d0 48 6b c1 68 48 6b d1 38 48
RSP: 0018:ffff9961831c3e48 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
RAX: ffff958563c00000 RBX: ffffffffa9515e60 RCX: 000000000000001f
RDX: 0000000000000000 RSI: 000000003286e833 RDI: 0000000000000000
RBP: ffff9961831c3e88 R08: 0000000000000002 R09: 0000000000000018
R10: 0000000000000364 R11: ffff958563c2a284 R12: 0000000000000003
R13: ffffb9617fc3fd00 R14: 00000194af870de5 R15: 0000000000000000
? cpuidle_enter_state+0xa5/0x3c0
cpuidle_enter+0x2e/0x40
call_cpuidle+0x23/0x40
do_idle+0x1c6/0x240
cpu_startup_entry+0x20/0x30
start_secondary+0x15b/0x190
secondary_startup_64+0xb6/0xc0
--[ end trace 805031dac04b28f5 ]--
