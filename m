Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9C974D022D
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 15:59:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240067AbiCGPAD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 10:00:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231239AbiCGPAA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 10:00:00 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 306B232983;
        Mon,  7 Mar 2022 06:59:06 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 227CfHgC002304;
        Mon, 7 Mar 2022 14:58:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : from : cc : subject : content-type :
 content-transfer-encoding; s=pp1;
 bh=soMhLiaITdUbpY2gguk/u56gbvgLb+dH6KAMmVJo1kM=;
 b=s5iSRpRBuLD8+CczYEKAaL8FdLJkd8LHb6Vn63D4t8cMWgCz8ExtniKjy9p0vyGZTnAE
 HtcQ0EGqa5qpHzEnyEVvLB/5vlF58VViN+V6F3jYjxhr0Qz5i4OQPpomKDK4ut5ZwLQR
 GAWCALZ0RcwtbkiWsWLFaCEXlGMNK9wVcu9lCdc0tT+sn4R17HCWF2mERgs8QzGuLOg5
 P8Ik4EoK7q7VVoWUlvk95wd+UvW9ToeJl14YywkTg/c24SPtLAZjEPS/kbkX0476DTR0
 t71BaQVRkpa+gO8k7FKfVScc+PWltQ7f4rYdOZFtMxGAYmDmZUx2xqQQnwAHFN93SUgf mw== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3emre2rcwq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Mar 2022 14:58:56 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 227EqlER010137;
        Mon, 7 Mar 2022 14:58:56 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma02dal.us.ibm.com with ESMTP id 3ekyg9t1cg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Mar 2022 14:58:56 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 227Ewsem23789896
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Mar 2022 14:58:54 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8F69DAE05F;
        Mon,  7 Mar 2022 14:58:54 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 72575AE067;
        Mon,  7 Mar 2022 14:58:50 +0000 (GMT)
Received: from [9.43.0.230] (unknown [9.43.0.230])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon,  7 Mar 2022 14:58:50 +0000 (GMT)
Message-ID: <68312f5c-13f4-71ee-a993-b523df59497b@linux.vnet.ibm.com>
Date:   Mon, 7 Mar 2022 20:25:46 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Content-Language: en-US
To:     netdev <netdev@vger.kernel.org>
From:   Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, ayal@nvidia.com,
        saeedm@nvidia.com, Jakub Kicinski <kuba@kernel.org>,
        roid@nvidia.com
Subject: [5.17.0-rc6][DLPAR][SRIOV/mlx5]EEH errors and WARNING: CPU: 7 PID:
 30505 at include/rdma/ib_verbs.h:3688 mlx5_ib_dev_res_cleanup
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: kvRSogpnF1H6MQtWRGJ_8VB0hsvXtLpy
X-Proofpoint-ORIG-GUID: kvRSogpnF1H6MQtWRGJ_8VB0hsvXtLpy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-07_05,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 impostorscore=0 phishscore=0 suspectscore=0 mlxscore=0
 bulkscore=0 spamscore=0 mlxlogscore=999 lowpriorityscore=0 clxscore=1011
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203070084
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greeting's

HMC DLPAR hotplug of SRIOV logical device backed with Everglade melanox adapter results in EEH error messages followed by WARNINGS on my PowerPC P10 LPAR running latest 5.17-rc6 kernel


from hmc dlpar remove and than add the SRIOV device
$ chhwres -r sriov -m ltcden11 --rsubtype logport -o r --id 9 -a  adapter_id=1,logical_port_id=2700400f
$ chhwres -r sriov -m ltcden11 --rsubtype logport -o a --id 9 -a	phys_port_id=0,adapter_id=1,logical_port_id=2700400f,logical_port_type=eth

the above command completed but the console is filled with EEH errors and warnings

console messages
PC: Registered rdma backchannel transport module.
mlx5_core 400f:01:00.0 eth1: Link up
IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
mlx5_core 8005:01:00.0 eth2: Link up
IPv6: ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
rpaphp: RPA HOT Plug PCI Controller Driver version: 0.1
sit: IPv6, IPv4 and MPLS over IPv4 tunneling driver
mlx5_core 400f:01:00.0: poll_health:800:(pid 0): Fatal error 1 detected
EEH: Recovering PHB#400f-PE#10000
EEH: PE location: N/A, PHB location: N/A
mlx5_core 400f:01:00.0: print_health_info:424:(pid 0): PCI slot is unavailable
mlx5_core 400f:01:00.0: mlx5_trigger_health_work:756:(pid 0): new health works are not permitted at this stage
EEH: Frozen PHB#400f-PE#10000 detected
EEH: Call Trace:
EEH: [c000000000054d10] __eeh_send_failure_event+0x70/0x150
EEH: [c00000000004df98] eeh_dev_check_failure+0x2e8/0x6c0
EEH: [c00000000004e438] eeh_check_failure+0xc8/0x100
EEH: [c0000000006a04b4] ioread32be+0x114/0x180
EEH: [c008000000d42bc0] mlx5_health_check_fatal_sensors+0x28/0x180 [mlx5_core]
EEH: [c008000000d43448] poll_health+0x50/0x260 [mlx5_core]
EEH: [c00000000021fed0] call_timer_fn+0x50/0x200
EEH: [c000000000220e90] run_timer_softirq+0x340/0x7c0
EEH: [c000000000c9e85c] __do_softirq+0x15c/0x3d0
EEH: [c00000000014f068] irq_exit+0x168/0x1b0
EEH: [c000000000026f84] timer_interrupt+0x1a4/0x3e0
EEH: [c000000000009a08] decrementer_common_virt+0x208/0x210
EEH: [c00000000367bdc0] 0xc00000000367bdc0
EEH: [c0000000009bf764] dedicated_cede_loop+0x94/0x1a0
EEH: [c0000000009bc094] cpuidle_enter_state+0x2d4/0x4e0
EEH: [c0000000009bc338] cpuidle_enter+0x48/0x70
EEH: [c00000000019ded4] call_cpuidle+0x44/0x80
EEH: [c00000000019e4b0] do_idle+0x340/0x390
EEH: [c00000000019e730] cpu_startup_entry+0x30/0x40
EEH: [c0000000000605a0] start_secondary+0x290/0x2b0
EEH: [c00000000000d154] start_secondary_prolog+0x10/0x14
EEH: This PCI device has failed 1 times in the last hour and will be permanently disabled after 5 failures.
EEH: Notify device drivers to shutdown
EEH: Beginning: 'error_detected(IO frozen)'
mlx5_core 400f:01:00.0: wait_func_handle_exec_timeout:1108:(pid 30505): cmd[0]: DESTROY_RMP(0x90e) No done completion
mlx5_core 400f:01:00.0: wait_func:1136:(pid 30505): DESTROY_RMP(0x90e) timeout. Will cause a leak of a command resource
------------[ cut here ]------------
Destroy of kernel SRQ shouldn't fail
WARNING: CPU: 7 PID: 30505 at include/rdma/ib_verbs.h:3688 mlx5_ib_dev_res_cleanup+0x104/0x1a0 [mlx5_ib]
Modules linked in: sit tunnel4 ip_tunnel rpadlpar_io rpaphp tcp_diag udp_diag inet_diag unix_diag af_packet_diag netlink_diag bonding rfkill rpcrdma sunrpc rdma_ucm ib_srpt ib_isert iscsi_target_mod target_core_mod ib_iser ib_umad rdma_cm ib_ipoib iw_cm ib_cm libiscsi scsi_transport_iscsi mlx5_ib ib_uverbs ib_core xts pseries_rng vmx_crypto gf128mul sch_fq_codel binfmt_misc ip_tables ext4 mbcache jbd2 dm_service_time mlx5_core sd_mod t10_pi sg ibmvfc scsi_transport_fc ibmveth mlxfw ptp pps_core dm_multipath dm_mirror dm_region_hash dm_log dm_mod fuse
CPU: 7 PID: 30505 Comm: drmgr Not tainted 5.17.0-rc6-autotest-g669b258a793d #1
NIP:  c0080000023cf20c LR: c0080000023cf208 CTR: c000000000702790
REGS: c0000000111b7420 TRAP: 0700   Not tainted  (5.17.0-rc6-autotest-g669b258a793d)
MSR:  800000000282b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  CR: 48088224  XER: 00000005
CFAR: c000000000143c90 IRQMASK: 0
GPR00: c0080000023cf208 c0000000111b76c0 c008000002438000 0000000000000024
GPR04: 00000000ffff7fff c0000000111b7390 c0000000111b7388 0000000000000027
GPR08: c0000018fd067e00 0000000000000001 0000000000000027 c0000000027a68f0
GPR12: 0000000000008000 c0000018ff984e80 0000000000000000 0000000119d902a0
GPR16: 00007fffd673e838 0000000119d90ed0 0000000119da3070 0000000106ad1e38
GPR20: 0000000106acf330 0000000106acf3d8 0000000106acd838 0000000119da3208
GPR24: 0000000000000007 0000000000000000 c008000000e78320 c000000002818eb8
GPR28: c00000000fd210d0 c0080000024328a8 c000000017808000 c000000017808000
NIP [c0080000023cf20c] mlx5_ib_dev_res_cleanup+0x104/0x1a0 [mlx5_ib]
LR [c0080000023cf208] mlx5_ib_dev_res_cleanup+0x100/0x1a0 [mlx5_ib]
Call Trace:
[c0000000111b76c0] [c0080000023cf208] mlx5_ib_dev_res_cleanup+0x100/0x1a0 [mlx5_ib] (unreliable)
[c0000000111b7730] [c0080000023d4c00] __mlx5_ib_remove+0x78/0xc0 [mlx5_ib]
[c0000000111b7770] [c00000000082479c] auxiliary_bus_remove+0x3c/0x70
[c0000000111b77a0] [c000000000814278] device_release_driver_internal+0x168/0x2d0
[c0000000111b77e0] [c000000000811748] bus_remove_device+0x118/0x210
[c0000000111b7860] [c000000000809a18] device_del+0x1d8/0x4e0
[c0000000111b7920] [c008000000d601b0] mlx5_rescan_drivers_locked.part.9+0xf8/0x250 [mlx5_core]
[c0000000111b79d0] [c008000000d60870] mlx5_unregister_device+0x48/0x80 [mlx5_core]
[c0000000111b7a00] [c008000000d32930] mlx5_uninit_one+0x38/0x100 [mlx5_core]
[c0000000111b7a70] [c008000000d33330] remove_one+0x58/0xa0 [mlx5_core]
[c0000000111b7aa0] [c000000000736d0c] pci_device_remove+0x5c/0x100
[c0000000111b7ae0] [c000000000814278] device_release_driver_internal+0x168/0x2d0
[c0000000111b7b20] [c000000000728a98] pci_stop_bus_device+0xa8/0x100
[c0000000111b7b60] [c000000000728cdc] pci_stop_and_remove_bus_device_locked+0x2c/0x50
[c0000000111b7b90] [c000000000739d20] remove_store+0xc0/0xe0
[c0000000111b7be0] [c000000000806870] dev_attr_store+0x30/0x50
[c0000000111b7c00] [c0000000005767c0] sysfs_kf_write+0x60/0x80
[c0000000111b7c20] [c000000000574e50] kernfs_fop_write_iter+0x1a0/0x2a0
[c0000000111b7c70] [c00000000045e3ec] new_sync_write+0x14c/0x1d0
[c0000000111b7d10] [c000000000461904] vfs_write+0x234/0x340
[c0000000111b7d60] [c000000000461bc4] ksys_write+0x74/0x130
[c0000000111b7db0] [c00000000002f608] system_call_exception+0x178/0x380
[c0000000111b7e10] [c00000000000c64c] system_call_common+0xec/0x250
--- interrupt: c00 at 0x20000026bd74
NIP:  000020000026bd74 LR: 00002000001e34c4 CTR: 0000000000000000
REGS: c0000000111b7e80 TRAP: 0c00   Not tainted  (5.17.0-rc6-autotest-g669b258a793d)
MSR:  800000000280f033 <SF,VEC,VSX,EE,PR,FP,ME,IR,DR,RI,LE>  CR: 24004222  XER: 00000000
IRQMASK: 0
GPR00: 0000000000000004 00007fffd673e650 0000200000367100 0000000000000007
GPR04: 0000000119da3ea0 0000000000000001 fffffffffbad2c84 0000000119d902a0
GPR08: 0000000000000001 0000000000000000 0000000000000000 0000000000000000
GPR12: 0000000000000000 000020000005b520 0000000000000000 0000000119d902a0
GPR16: 00007fffd673e838 0000000119d90ed0 0000000119da3070 0000000106ad1e38
GPR20: 0000000106acf330 0000000106acf3d8 0000000106acd838 0000000119da3208
GPR24: 0000000119da3219 00007fffd673e878 0000000000000001 0000000119da3ea0
GPR28: 0000000000000001 0000000119d902a0 0000000119da3ea0 0000000000000001
NIP [000020000026bd74] 0x20000026bd74
LR [00002000001e34c4] 0x2000001e34c4
--- interrupt: c00
Instruction dump:
60000000 3d420000 e94a84c8 892a0000 2f890000 409eff64 3c620000 e86384d0
39200001 992a0000 48032a1d e8410018 <0fe00000> 3d420000 e94a84c8 892a0000
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
WARNING: CPU: 7 PID: 30505 at drivers/infiniband/core/verbs.c:347 ib_dealloc_pd_user+0x68/0xd0 [ib_core]
Modules linked in: sit tunnel4 ip_tunnel rpadlpar_io rpaphp tcp_diag udp_diag inet_diag unix_diag af_packet_diag netlink_diag bonding rfkill rpcrdma sunrpc rdma_ucm ib_srpt ib_isert iscsi_target_mod target_core_mod ib_iser ib_umad rdma_cm ib_ipoib iw_cm ib_cm li

-- 
Regard's

Abdul Haleem
IBM Linux Technology Center

