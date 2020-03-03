Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7A51771FB
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 10:08:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727924AbgCCJIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 04:08:10 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46124 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727706AbgCCJIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 04:08:10 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0238xETp118999
        for <netdev@vger.kernel.org>; Tue, 3 Mar 2020 04:08:09 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yfnbfsmxq-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 03 Mar 2020 04:08:08 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Tue, 3 Mar 2020 09:08:06 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 3 Mar 2020 09:08:03 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 023982vG40435816
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 3 Mar 2020 09:08:02 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7D18D4C04E;
        Tue,  3 Mar 2020 09:08:02 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 44B864C05E;
        Tue,  3 Mar 2020 09:08:02 +0000 (GMT)
Received: from [9.145.12.79] (unknown [9.145.12.79])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  3 Mar 2020 09:08:02 +0000 (GMT)
Subject: Re: Crashes due to "s390/qeth: don't check for IFF_UP when scheduling
 napi"
To:     Qian Cai <cai@lca.pw>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        ubraun@linux.ibm.com
References: <5281E33C-21F3-4879-A539-52826D82AFBD@lca.pw>
From:   Julian Wiedmann <jwi@linux.ibm.com>
Date:   Tue, 3 Mar 2020 10:08:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <5281E33C-21F3-4879-A539-52826D82AFBD@lca.pw>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20030309-0016-0000-0000-000002ECA532
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20030309-0017-0000-0000-0000334FEB46
Message-Id: <713fa071-8d87-f728-371e-867e8c1438d9@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-03_02:2020-03-03,2020-03-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 suspectscore=27 adultscore=0 mlxlogscore=499
 clxscore=1015 priorityscore=1501 mlxscore=0 impostorscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003030071
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03.03.20 04:30, Qian Cai wrote:
> Reverted the linux-next commit 3d35dbe6224e “s390/qeth: don't check for IFF_UP when scheduling napi”
> fixed several crashes could happen during boot,
> 

Yep, that check did have a funny smell to it. Thanks for reporting, I think I see
what's going on - shouldn't be difficult to fix.

> 01: [   79.051526] XFS (dm-2): Mounting V5 Filesystem                           
> 00: [   79.420398] XFS (dm-2): Ending clean mount                               
> 00: [   79.439284] xfs filesystem being mounted at /home supports timestamps unt
> 00: il 2038 (0x7fffffff)                                                        
> 00: [   98.203218] ------------[ cut here ]------------                         
> 00: [   98.203640] kernel BUG at include/linux/netdevice.h:516!                 
> 00: [   98.203725] monitor event: 0040 ilc:2 [#1] SMP DEBUG_PAGEALLOC           
> 00: [   98.203744] Modules linked in: ip_tables x_tables xfs dasd_fba_mod dasd_e
> 00: ckd_mod dm_mirror dm_region_hash dm_log dm_mod                              
> 00: [   98.203779] CPU: 0 PID: 1127 Comm: NetworkManager Not tainted 5.6.0-rc3-n
> 00: ext-20200302+ #4                                                            
> 00: [   98.203794] Hardware name: IBM 2964 N96 400 (z/VM 6.4.0)                 
> 00: [   98.203808] Krnl PSW : 0704c00180000000 00000000309cccc4 (qeth_open+0x2f4
> 00: /0x320)                                                                     
> 00: [   98.203836]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:0 PM:0
> 00:  RI:0 EA:3                                                                  
> 00: [   98.203853] Krnl GPRS: 0000000000000001 0000000000000010 000000004eca57bf
> 00:  000000004eca57bf                                                           
> 00: [   98.203870]            0000030000000000 00000000309ccb02 00000000384e5400
> 00:  00000000384e5408                                                           
> 00: [   98.203885]            000000004eca57a8 000000004eca57b8 00000000384e5000
> 00:  000000004eca5000                                                           
> 00: [   98.203902]            0000000030fdd900 0000000030d78d00 00000000309ccb02
> 00:  000003e00412ea88                                                           
> 00: [   98.203940] Krnl Code: 00000000309cccb4: c0200052cce6        larl    %r2,
> 00: 0000000031426680                                                            
> 00: [   98.203940]            00000000309cccba: c0e5fff5bf4f        brasl   %r14
> 00: ,0000000030884b58                                                           
> 00: [   98.203940]           #00000000309cccc0: af000000            mc      0,0 
> 00: [   98.203940]           >00000000309cccc4: c0200052ccfe        larl    %r2,
> 00: 00000000314266c0                                                            
> 00: [   98.203940]            00000000309cccca: c0e5fff5bf47        brasl   %r14
> 00: ,0000000030884b58                                                           
> 00: [   98.203940]            00000000309cccd0: a728fffb            lhi     %r2,
> 00: -5                                                                          
> 00: [   98.203940]            00000000309cccd4: a7f4ff55            brc     15,0
> 00: 0000000309ccb7e                                                             
> 00: [   98.203940]            00000000309cccd8: b9040039            lgr     %r3,
> 00: %r9                                                                         
> 00: [   98.204221] Call Trace:                                                  
> 00: [   98.204277]  [<00000000309cccc4>] qeth_open+0x2f4/0x320  
> napi_enable at include/linux/netdevice.h:516
> (inlined by) qeth_open at drivers/s390/net/qeth_core_main.c:6591                
> 00: [   98.204292] ([<00000000309ccaf8>] qeth_open+0x128/0x320)                 
> 00: [   98.204308]  [<0000000030a3c778>] __dev_open+0x190/0x268                 
> 00: [   98.204324]  [<0000000030a3ce80>] __dev_change_flags+0x2e8/0x378         
> 00: [   98.204340]  [<0000000030a3cf6e>] dev_change_flags+0x5e/0xb0             
> 00: [   98.204357]  [<0000000030a60a16>] do_setlink+0x59e/0x1728                
> 00: [   98.204372]  [<0000000030a62750>] __rtnl_newlink+0x708/0xbd0             
> 00: [   98.204388]  [<0000000030a62c86>] rtnl_newlink+0x6e/0x90                 
> 00: [   98.204404]  [<0000000030a59004>] rtnetlink_rcv_msg+0x29c/0x6e0          
> 00: [   98.204421]  [<0000000030aa9cd2>] netlink_rcv_skb+0xea/0x218             
> 00: [   98.204436]  [<0000000030aa8f5a>] netlink_unicast+0x2d2/0x3a0            
> 00: [   98.204451]  [<0000000030aa95dc>] netlink_sendmsg+0x5b4/0x6c0            
> 00: [   98.204469]  [<00000000309e76a6>] ____sys_sendmsg+0x32e/0x3c8            
> 00: [   98.204485]  [<00000000309e8d08>] ___sys_sendmsg+0x108/0x148             
> 00: [   98.204500]  [<00000000309ec2a8>] __sys_sendmsg+0xe0/0x148               
> 00: [   98.204515]  [<00000000309ecda6>] __s390x_sys_socketcall+0x356/0x430     
> 00: [   98.204532]  [<0000000030be3568>] system_call+0xd8/0x2b4                 
> 00: [   98.204544] INFO: lockdep is turned off.                                 
> 00: [   98.204555] Last Breaking-Event-Address:                                 
> 00: [   98.204568]  [<00000000309ccb0c>] qeth_open+0x13c/0x320                  
> 00: [   98.204585] Kernel panic - not syncing: Fatal exception: panic_on_oops   
> 01: HCPGSP2629I The virtual machine is placed in CP mode due to a SIGP stop from
>  CPU 01.                                                                        
> 01: HCPGSP2629I The virtual machine is placed in CP mode due to a SIGP stop from
>  CPU 00.                                                                        
> 00: HCPGIR450W CP entered; disabled wait PSW 00020001 80000000 00000000 302A66EE
> 
> 
> 
> 00: [   28.095006] illegal operation: 0001 ilc:1 [#1] SMP DEBUG_PAGEALLOC        
> 00: [   28.095045] Modules linked in: dm_mirror dm_region_hash dm_log dm_mod     
> 00: [   28.095075] CPU: 0 PID: 432 Comm: ccw_init Not tainted 5.6.0-rc3-next-20  
> 00: 00302+ #2                                                                    
> 00: [   28.095090] Hardware name: IBM 2964 N96 400 (z/VM 6.4.0)                  
> 00: [   28.095103] Krnl PSW : 0704e00180000000 0000000000000002 (0x2)            
> 00: [   28.095124]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:2 PM:0 
> 00:  RI:0 EA:3                                                                   
> 00: [   28.095141] Krnl GPRS: 0000000000000001 0000000000000000 00000000475597a8 
> 00:  0000000000000000                                                            
> 00: [   28.095157]            0000030000000000 0000000005e6b280 000000000639d197 
> 00:  00000000475597a8                                                            
> 00: [   28.095174]            000003e000000000 000003e00014fc78 000003e00014fbf8 
> 00:  00000000475597a8                                                            
> 00: [   28.095189]            000000000640d900 00000000061a8aa0 0000000005e6b29a 
> 00:  000003e00014fa68                                                            
> 00: [   28.095210] Krnl Code:#0000000000000000: 0000                illegal      
> 00: [   28.095210]           >0000000000000002: 0000                illegal      
> 00: [   28.095210]            0000000000000004: 0000                illegal      
> 00: [   28.095210]            0000000000000006: 0000                illegal      
> 00: [   28.095210]            0000000000000008: 0000                illegal      
> 00: [   28.095210]            000000000000000a: 0000                illegal      
> 00: [   28.095210]            000000000000000c: 0000                illegal      
> 00: [   28.095210]            000000000000000e: 0000                illegal      
> 00: [   28.095279] Call Trace:                                                   
> 00: [   28.095290]  [<0000000000000002>] 0x2                                     
> 00: [   28.095318] ([<0000000005e6b254>] net_rx_action+0x2c4/0x9e0)    
> arch_test_bit at arch/s390/include/asm/bitops.h:219
> (inlined by) test_bit at include/asm-generic/bitops/instrumented-non-atomic.h:111
> (inlined by) napi_poll at net/core/dev.c:6569
> (inlined by) net_rx_action at net/core/dev.c:6638          
> 00: [   28.095338]  [<00000000060147f2>] __do_softirq+0x1da/0xa28                
> 00: [   28.095362]  [<00000000056d488c>] do_softirq_own_stack+0xe4/0x100         
> 00: [   28.095665]  [<000000000571f438>] irq_exit+0x148/0x1c0                    
> 00: [   28.095684]  [<00000000056d4048>] do_IRQ+0xb8/0x108                       
> 00: [   28.095702]  [<0000000006013a3c>] io_int_handler+0x12c/0x2b8              
> 00: [   28.095719]  [<00000000057d4f48>] lock_acquire+0x248/0x460                
> 00: [   28.095735] ([<00000000057d4f12>] lock_acquire+0x212/0x460)               
> 00: [   28.095754]  [<0000000005a8c994>] lock_page_memcg+0x54/0x180              
> 00: [   28.095772]  [<00000000059f0dd2>] page_remove_rmap+0x17a/0x8c0            
> 00: [   28.095787]  [<00000000059cdde6>] unmap_page_range+0x956/0x1690           
> 00: [   28.095801]  [<00000000059cebe0>] unmap_single_vma+0xc0/0x148             
> 00: [   28.095816]  [<00000000059ceed4>] unmap_vmas+0x54/0x88                    
> 00: [   28.095831]  [<00000000059e3198>] exit_mmap+0x1b0/0x2a8                   
> 00: [   28.095846]  [<0000000005709ef6>] mmput+0xce/0x230                        
> 00: [   28.095860]  [<000000000571c750>] do_exit+0x5b0/0x1538                    
> 00: [   28.095875]  [<000000000571d7ce>] do_group_exit+0x7e/0x150                
> 00: [   28.095889]  [<000000000571d8d2>] __s390x_sys_exit_group+0x32/0x38        
> 00: [   28.095905]  [<00000000060136b6>] system_call+0x296/0x2b4                 
> 00: [   28.095917] INFO: lockdep is turned off.                                  
> 00: [   28.095928] Last Breaking-Event-Address:                                  
> 00: [   28.095944]  [<0000000005e6b298>] net_rx_action+0x308/0x9e0    
> napi_poll at net/core/dev.c:6570
> (inlined by) net_rx_action at net/core/dev.c:6638           
> 00: [   28.095964] Kernel panic - not syncing: Fatal exception in interrupt
> 
> 
> 00: [   28.034050] qeth 0.0.8000: MAC address 02:de:ad:be:ef:87 successfully reg 
> 00: istered                                                                      
> 00: [   28.040202] illegal operation: 0001 ilc:1 [#1] SMP DEBUG_PAGEALLOC        
> 00: [   28.040226] Modules linked in: dm_mirror dm_region_hash dm_log dm_mod     
> 00: [   28.040254] CPU: 0 PID: 402 Comm: systemd-udevd Not tainted 5.6.0-rc3-nex 
> 00: t-20200302+ #3                                                               
> 00: [   28.040271] Hardware name: IBM 2964 N96 400 (z/VM 6.4.0)                  
> 00: [   28.040286] Krnl PSW : 0704e00180000000 0000000000000002 (0x2)            
> 00: [   28.040307]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:2 PM:0 
> 00:  RI:0 EA:3                                                                   
> 00: [   28.040324] Krnl GPRS: 0000000000000001 0000000000000000 0000000001b517a8 
> 00:  0000000000000000                                                            
> 00: [   28.040340]            0000030000000000 00000000303eb2f0 000000003091d197 
> 00:  0000000001b517a8                                                            
> 00: [   28.040356]            000003e000000000 000003e00014fc78 000003e00014fbf8 
> 00:  0000000001b517a8                                                            
> 00: [   28.040371]            000000003098d900 0000000030728aa0 00000000303eb30  
> 00:  000003e00014fa68                                                            
> 00: [   28.040393] Krnl Code:#0000000000000000: 0000                illegal      
> 00: [   28.040393]           >0000000000000002: 0000                illegal      
> 00: [   28.040393]            0000000000000004: 0000                illegal      
> 00: [   28.040393]            0000000000000006: 0000                illegal      
> 00: [   28.040393]            0000000000000008: 0000                illegal      
> 00: [   28.040393]            000000000000000a: 0000                illegal      
> 00: [   28.040393]            000000000000000c: 0000                illegal      
> 00: [   28.040393]            000000000000000e: 0000                illegal      
> 00: [   28.040462] Call Trace:                                                   
> 00: [   28.040792]  [<0000000000000002>] 0x2                                     
> 00: [   28.040907] ([<00000000303eb2c4>] net_rx_action+0x2c4/0x9e0)              
> 00: [   28.040927]  [<0000000030594862>] __do_softirq+0x1da/0xa28                
> 00: [   28.040949]  [<000000002fc5488c>] do_softirq_own_stack+0xe4/0x100         
> 00: [   28.040966]  [<000000002fc9f438>] irq_exit+0x148/0x1c0                    
> 00: [   28.040981]  [<000000002fc54048>] do_IRQ+0xb8/0x108                       
> 00: [   28.040995]  [<0000000030593aac>] io_int_handler+0x12c/0x2b8              
> 00: [   28.041014]  [<000000002ffe55b0>] __asan_store8+0x10/0x98                 
> 00: [   28.041032] ([<000000002fc5fa90>] unwind_next_frame+0x168/0x3e0)          
> 00: [   28.041048]  [<000000002fc669b2>] arch_stack_walk+0x10a/0x178             
> 00: [   28.041065]  [<000000002fda0232>] stack_trace_save+0xba/0xd0              
> 00: [   28.041083]  [<0000000030025d7e>] create_object+0x1d6/0x5c8               
> 00: [   28.041113]  [<000000002ffdb6f2>] kmem_cache_alloc+0x1f2/0x548            
> 00: [   28.041141]  [<000000002ff72ece>] anon_vma_clone+0x96/0x248               
> 00: [   28.041157]  [<000000002ff730de>] anon_vma_fork+0x5e/0x1f0                
> 00: [   28.041175]  [<000000002fc8b9a6>] dup_mm+0x88e/0xa80                      
> 00: [   28.041190]  [<000000002fc8dc26>] copy_process+0x183e/0x2d20              
> 00: [   28.041205]  [<000000002fc8f504>] _do_fork+0x134/0xab0                    
> 00: [   28.041220]  [<000000002fc9009e>] __do_sys_clone+0xce/0x110               
> 00: [   28.041235]  [<000000002fc9038a>] __s390x_sys_clone+0x22/0x30             
> 00: [   28.041251]  [<0000000030593726>] system_call+0x296/0x2b4                 
> 00: [   28.041263] INFO: lockdep is turned off.                                  
> 00: [   28.041274] Last Breaking-Event-Address:                                  
> 00: [   28.041289]  [<00000000303eb308>] net_rx_action+0x308/0x9e0               
> 00: [   28.041308] Kernel panic - not syncing: Fatal exception in interrupt
> 

