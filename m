Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7879D494E78
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 13:58:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241360AbiATM6k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 07:58:40 -0500
Received: from mail-dm6nam10on2081.outbound.protection.outlook.com ([40.107.93.81]:20624
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237067AbiATM6i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jan 2022 07:58:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pv/E5fiFXo2YVWPqyolPycsfck5XGWwpV/ku1QxRHS1zLStgBzOsWWNk6ndfwqgs5GCUoP0nblc2g+S0PXg6Oo8SFD2NcSuCgU/T0PQ3S6bQzMd5HJ00/k+rAsj+1q21qDzpadMVofdNHOqPqgLCJHRCenX68OvyxTuIQ6kXR41idxN41IIivYYdO4DKLHpp4d70Nec4qcoYTDXXPkgEbAEM04XsHFF6Brg4lmswolj4j8FXLFsFRMnVdvwYvULAXBjNWSMlNsvvvWFkIeiub5Rbu1wkgTuVCJk5qkr77d7oYnWSNhDGspBCKIvuM5qUT7UM1F3GtRwnnfmt2YSAkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=03FltTfF8z1MTawavESvLGUtULWSnE+md2G8vdJi0fc=;
 b=ISIEnwWBi07xc9XFU3rHdn24QrA+4yQ0egZy25xxOH5Asct+tdClTUUd+LbtkDezAuoRV08UU064CNHwHaxOZJ2VRjQDh/6nFmqKYf8769Mu1rVTGgP142aHXfa/HII7ZMT98Wt0kGrGAWRLIEGCYmOYW70OUIL150iir17cbWZtUkGeEypcmnAz+Mhjo8LGR+m6be5WNz/qGQQnV4r8I8pYebXuerd01hPUksAzddST9Y3oDKjZi21K2COdGDdkV5sUjkAihV7xrPO/LO4Kp93UIxhy5plhXmwjkoyMqJGWVxehLUXjRWgfA7vqR9rUnlA5UI7wcTmahbLFog9EKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=03FltTfF8z1MTawavESvLGUtULWSnE+md2G8vdJi0fc=;
 b=kaQf9ydAizgmijzPfvMD1+gF8O863jGUcl/4Zubsrw06VcTS1+FXdt5DkQ6/WCt9NJKJ0oXwBJ9bGs6qtzFlz2onNOU5dNIINApz0FkHl0Ap0BZOurFqv1gJaX7orYNXdXAIxRUgeUvkTf28xjNxIVVxf/mS5WoxL/uiQUrrdFnEGvDija+XyVjwCGZmMw9SJ0vNf6FBNZqHoKuZDc4AQx55wnp7ZLfpV3mPF3xIUOdVtYHBSw10seyOPJFU6vwqLy3XLBXpoLQaMhkBy1PVdbUBMds732gI9YvAY+rrFzsH1xFOKB0YL7HE/X0BUCFzSOnPD7RMmXo6EF1xPnq+lg==
Received: from DM5PR13CA0060.namprd13.prod.outlook.com (2603:10b6:3:117::22)
 by BYAPR12MB2629.namprd12.prod.outlook.com (2603:10b6:a03:69::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.7; Thu, 20 Jan
 2022 12:58:25 +0000
Received: from DM6NAM11FT044.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:117:cafe::d3) by DM5PR13CA0060.outlook.office365.com
 (2603:10b6:3:117::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.6 via Frontend
 Transport; Thu, 20 Jan 2022 12:58:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT044.mail.protection.outlook.com (10.13.173.185) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4909.7 via Frontend Transport; Thu, 20 Jan 2022 12:58:24 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 20 Jan
 2022 12:58:24 +0000
Received: from localhost.localdomain.nvidia.com (10.127.8.14) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9;
 Thu, 20 Jan 2022 04:58:21 -0800
References: <20210325153533.770125-1-atenart@kernel.org>
 <20210325153533.770125-2-atenart@kernel.org> <ygnhh79yluw2.fsf@nvidia.com>
 <164267447125.4497.8151505359440130213@kwain>
User-agent: mu4e 1.4.15; emacs 27.2
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Antoine Tenart <atenart@kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <echaudro@redhat.com>,
        <sbrivio@redhat.com>, <netdev@vger.kernel.org>, <pshelar@ovn.org>
Subject: Re: [PATCH net 1/2] vxlan: do not modify the shared tunnel info
 when PMTU triggers an ICMP reply
In-Reply-To: <164267447125.4497.8151505359440130213@kwain>
Date:   Thu, 20 Jan 2022 14:58:18 +0200
Message-ID: <ygnhee52lg2d.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.127.8.14]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c63feb3c-abc6-4036-d0c8-08d9dc148b88
X-MS-TrafficTypeDiagnostic: BYAPR12MB2629:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB26293F3E82B294ABEA38342CA05A9@BYAPR12MB2629.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1850;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lsuCelDTVz1fBL6LAPVfRPNQQshIlCU2bQZRikruLapqUZNzas+wivMYNGdF9XOVR835ndm5uW133fuqas7ylyzn/e61IQo8GTHHdnS6ycQ9qR1ROWD1QudqL75QwWZ+u69fO9Qa/LRjuJ//ayXoR6UR2LbbTq9mgQ9YvEjVtXh+i5h3dEEYDj/GWGM7B7vkSl1PJjeep/h6UFnQhoZEWQlzFFChSxp6BceKRexljUrDM8Q+zQV10lUpxw2oz+OqcEgZyEKBpSbwfBc45gb7WO6RPgcx3eJADJijPqqm3iNiNSWLXivk4gfp5folM6xW9wzLunocrRzaaYBWxIn+kf+VfUZLgXAq5KzDh5a5s3o6pEyBpxGhVeM3oeHtOPWY9KwBZD+gg2C385ODQCgQbDno6RmsbLSlC8ch2S9qvzRl87xI130kojtKTSRhgHhjZs+xn7LTCmgSbv4lpZ8If44E/MVCAZK+/0DZoiIHfeadTrJT4IyrEe9jlzTLQ63xQC3gyF77agF8klboiDEE7KgSjHwR8PAWj5Ise2t1o1RUy9UQLXJT67WNBaWF/3H0w2SWbSsUmq/T8TONziw/BGGF5DujEogU0u4Tb7W4ltr5jaw338w8VdMAW11WmijgOnAyJzIgCTLxdfwl4RIFwfNfUKdWogiV6wlD8j39UdXewWawjBFTqmbGcEMSeVffhG9LHA6mAZQIz7vaZFCzpQYqPAFhcfO5sIxapAKOrxJKVzyTdwPjZEuQrydohHAEJpyg8uvXiRNIPCpq8Ag4pYjDHiOP0FvU9xlh9nMch18=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700002)(2616005)(82310400004)(70586007)(70206006)(2906002)(36756003)(8676002)(26005)(4326008)(508600001)(6666004)(36860700001)(47076005)(7696005)(426003)(45080400002)(336012)(16526019)(81166007)(83380400001)(5660300002)(40460700001)(356005)(6916009)(54906003)(316002)(8936002)(186003)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2022 12:58:24.6373
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c63feb3c-abc6-4036-d0c8-08d9dc148b88
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT044.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2629
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu 20 Jan 2022 at 12:27, Antoine Tenart <atenart@kernel.org> wrote:
> Hello Vlad,
>
> Quoting Vlad Buslov (2022-01-20 08:38:05)
>> On Thu 25 Mar 2021 at 17:35, Antoine Tenart <atenart@kernel.org> wrote:
>> >
>> > diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
>> > index 666dd201c3d5..53dbc67e8a34 100644
>> > --- a/drivers/net/vxlan.c
>> > +++ b/drivers/net/vxlan.c
>> > @@ -2725,12 +2725,17 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
>> >                       goto tx_error;
>> >               } else if (err) {
>> >                       if (info) {
>> > +                             struct ip_tunnel_info *unclone;
>> >                               struct in_addr src, dst;
>> >  
>> > +                             unclone = skb_tunnel_info_unclone(skb);
>> > +                             if (unlikely(!unclone))
>> > +                                     goto tx_error;
>> > +
>> 
>> We have been getting memleaks in one of our tests that point to this
>> code (test deletes vxlan device while running traffic redirected by OvS
>> TC at the same time):
>> 
>> unreferenced object 0xffff8882d0114200 (size 256):
>>   comm "softirq", pid 0, jiffies 4296140292 (age 1435.992s)
>>   hex dump (first 32 bytes):
>>     00 00 00 00 00 00 00 00 00 3b 85 84 ff ff ff ff  .........;......
>>     a1 26 b7 83 ff ff ff ff 00 00 00 00 00 00 00 00  .&..............
>>   backtrace:
>>     [<0000000097659d47>] metadata_dst_alloc+0x1f/0x470
>>     [<000000007571c30f>] tun_dst_unclone+0xee/0x360 [vxlan]
>>     [<00000000d2dcfd00>] vxlan_xmit_one+0x131d/0x2a00 [vxlan]
>>     [<00000000281572b6>] vxlan_xmit+0x8e6/0x4cd0 [vxlan]
>>     [<00000000d49d33fe>] dev_hard_start_xmit+0x1ba/0x710
>>     [<00000000eac444f5>] __dev_queue_xmit+0x17c5/0x25f0
>>     [<000000005fbd8585>] tcf_mirred_act+0xb1d/0xf70 [act_mirred]
>>     [<0000000064b6eb2d>] tcf_action_exec+0x10e/0x350
>>     [<00000000352821e8>] fl_classify+0x4e3/0x610 [cls_flower]
>>     [<0000000011d3f765>] tcf_classify+0x33d/0x800
>>     [<000000006c69b225>] __netif_receive_skb_core+0x18d6/0x2ae0
>>     [<00000000dd256fe3>] __netif_receive_skb_one_core+0xaf/0x180
>>     [<0000000065d43bd6>] process_backlog+0x2e3/0x710
>>     [<00000000964357ae>] __napi_poll+0x9f/0x560
>>     [<0000000059a93cf6>] net_rx_action+0x357/0xa60
>>     [<00000000766481bc>] __do_softirq+0x282/0x94e
>> 
>> Looking at the code the potential issue seems to be that
>> tun_dst_unclone() creates new metadata_dst instance with refcount==1,
>> increments the refcount with dst_hold() to value 2, then returns it.
>> This seems to imply that caller is expected to release one of the
>> references (second one if for skb), but none of the callers (including
>> original dev_fill_metadata_dst()) do that, so I guess I'm
>> misunderstanding something here.
>> 
>> Any tips or suggestions?
>
> I'd say there is no need to increase the dst refcount here after calling
> metadata_dst_alloc, as the metadata is local to the skb and the dst
> refcount was already initialized to 1. This might be an issue with
> commit fc4099f17240 ("openvswitch: Fix egress tunnel info."); I CCed
> Pravin, he might recall if there was a reason to increase the refcount.

I tried to remove the dst_hold(), but that caused underflows[0], so I
guess the current reference counting is required at least for some
use-cases.

[0]:

[  118.803011] ------------[ cut here ]------------                                    
[  118.803011] dst_release: dst:000000001fc13e61 refcnt:-2                             
[  118.803019] dst_release: dst:000000001fc13e61 refcnt:-2                             
[  118.803027] dst_release: dst:000000001fc13e61 refcnt:-2                             
[  118.803041] dst_release: dst:000000001fc13e61 refcnt:-2                             
[  118.803046] dst_release: dst:000000001fc13e61 refcnt:-2                             
[  118.803060] dst_release: dst:000000001fc13e61 refcnt:-2                             
[  118.803065] dst_release: dst:000000001fc13e61 refcnt:-2                             
[  118.803078] dst_release: dst:000000001fc13e61 refcnt:-2                             
[  118.803083] dst_release: dst:000000001fc13e61 refcnt:-2                             
[  118.803096] dst_release: dst:000000001fc13e61 refcnt:-2                             
[  118.803920] dst_release underflow                                                   
[  118.803937] WARNING: CPU: 4 PID: 0 at net/core/dst.c:173 dst_release+0x79/0x90                                                                                             
[  118.815961] Modules linked in: act_tunnel_key act_mirred act_skbedit veth vxlan ip6_udp_tunnel udp_tunnel act_gact cls_flower sch_ingress openvswitch nsh nf_conncount mlx5_ib mlx5_core mlxfw pci_hyperv_intf ptp pps_core nfsv3 nfs_acl xt_conntrack xt_MASQUERADE nf_conntrack_netlink nfnetlink xt_addrtype iptable_filter iptable_nat nf_nat nf_connt
rack nf_defrag_ipv6 nf_defrag_ipv4 br_netfilter bridge stp llc rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd grace fscache netfs rfkill overlay rpcrdma rdma_ucm ib_srpt ib_isert iscsi_target_mod target_core_mod ib_iser ib_umad rdma_cm ib_ipoib iw_cm ib_cm ib_uverbs sunrpc ib_core iTCO_wdt iTCO_vendor_support lpc_ich mfd_core virtio_net 
net_failover failover i2c_i801 i2c_smbus kvm_intel kvm pcspkr irqbypass crc32_pclmul ghash_clmulni_intel sch_fq_codel drm i2c_core ip_tables crc32c_intel serio_raw fuse [last unloaded: mlxfw]
[  118.829464] CPU: 4 PID: 0 Comm: swapper/4 Not tainted 5.16.0+ #3                                                                                                           
[  118.830567] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014                                                                                                                                                                                                                              
[  118.832541] RIP: 0010:dst_release+0x79/0x90                                         
[  118.833372] Code: 04 e8 db 14 01 00 8b 4c 24 04 85 c0 74 c7 e9 4d 60 22 00 48 c7 c7 35 00 32 82 89 4c 24 04 c6 05 c5 47 e5 00 01 e8 6f c2 1b 00 <0f> 0b 8b 4c 24 04 eb cb 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40                                                                                                                                       
[  118.836566] RSP: 0018:ffffc90000180ee0 EFLAGS: 00010282                             
[  118.837546] RAX: 0000000000000000 RBX: ffff88813a139ab0 RCX: 0000000000000000                                                                                              
[  118.838912] RDX: 0000000000000102 RSI: ffffffff82286273 RDI: 00000000ffffffff                                                                                              
[  118.840278] RBP: 0000000000000004 R08: 0000000000000015 R09: ffffc90000180e78                                                                                              
[  118.841646] R10: ffffffff825c7000 R11: 0000000000000001 R12: ffff88811d3ab480                                                                                              
[  118.843008] R13: 0000000000000170 R14: 0000000000000000 R15: ffff8882f5a2e1b8                                                                                              
[  118.844371] FS:  0000000000000000(0000) GS:ffff8882f5a00000(0000) knlGS:0000000000000000                                                                                   
[  118.845968] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033                                                                                                              
[  118.847100] CR2: 00007fa5e5abd7e0 CR3: 0000000175408005 CR4: 0000000000770ee0                                                                                              
[  118.848461] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000                                                                                              
[  118.849834] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400                                                                                              
[  118.851198] PKRU: 55555554                                                          
[  118.851815] Call Trace:                                                             
[  118.852387]  <IRQ>                                                                  
[  118.852894]  dst_cache_destroy+0x33/0x60                                            
[  118.853728]  dst_destroy+0xaa/0xb0                                                  
[  118.854465]  rcu_core+0x2a3/0x960                                                   
[  118.855197]  __do_softirq+0xf0/0x2f9                                                
[  118.855976]  __irq_exit_rcu+0xcc/0x120                                              
[  118.856765]  sysvec_apic_timer_interrupt+0xa2/0xd0                                  
[  118.857746]  </IRQ>                                                                 
[  118.858270]  <TASK>                                                                 
[  118.858775]  asm_sysvec_apic_timer_interrupt+0x12/0x20                              
[  118.859801] RIP: 0010:native_safe_halt+0xb/0x10                                     
[  118.860731] Code: 7e ff ff ff 7f 5b c3 65 48 8b 04 25 c0 cb 01 00 f0 80 48 02 20 48 8b 00 a8 08 75 c3 eb 80 cc eb 07 0f 00 2d 8f f5 4f 00 fb f4 <c3> 0f 1f 40 00 eb 07 0f 00 2d 7f f5 4f 00 f4 c3 cc cc cc cc cc 0f                                                                                                                                       
[  118.864175] RSP: 0018:ffffc9000009fef0 EFLAGS: 00000206                             
[  118.865223] RAX: 0000000000027f6c RBX: 0000000000000004 RCX: 0000000000000000                                                                                              
[  118.866504] RDX: ffff88817c090d50 RSI: ffffffff82286273 RDI: ffffffff8225bf7f                                                                                              
[  118.867774] RBP: ffff8881009d2e80 R08: 0000000000027f6b R09: 0000000000000000                                                                                              
[  118.869051] R10: 00000000fffd3b17 R11: 0000000000000001 R12: 0000000000000000                                                                                              
[  118.870326] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000                                                                                              
[  118.871601]  default_idle+0xa/0x10                                                  
[  118.872300]  default_idle_call+0x33/0xe0                                            
[  118.873081]  do_idle+0x208/0x270                                                    
[  118.873741]  cpu_startup_entry+0x19/0x20                                            
[  118.874562]  secondary_startup_64_no_verify+0xc3/0xcb                               
[  118.875604]  </TASK>                                                                
[  118.876140] ---[ end trace dec5061c76371ce7 ]---   
