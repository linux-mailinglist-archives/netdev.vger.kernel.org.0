Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6127421B16F
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 10:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727873AbgGJIfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 04:35:01 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54234 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726768AbgGJIfB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 04:35:01 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06A8XLN3071703;
        Fri, 10 Jul 2020 04:34:57 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 326bpkcnnq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Jul 2020 04:34:57 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06A8PL8j025304;
        Fri, 10 Jul 2020 08:34:55 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 326bch8e95-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Jul 2020 08:34:54 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06A8Ypco8520024
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jul 2020 08:34:51 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CD5984C04E;
        Fri, 10 Jul 2020 08:34:51 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4238D4C04A;
        Fri, 10 Jul 2020 08:34:51 +0000 (GMT)
Received: from oc5500677777.ibm.com (unknown [9.145.182.225])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 10 Jul 2020 08:34:51 +0000 (GMT)
Subject: Re: [REGRESSION] mlx5: Driver remove during hot unplug is broken
To:     Parav Pandit <parav@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Shay Drory <shayd@mellanox.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ubraun@linux.ibm.com" <ubraun@linux.ibm.com>,
        "kgraul@linux.ibm.com" <kgraul@linux.ibm.com>,
        "raspl@de.ibm.com" <raspl@de.ibm.com>
References: <f942d546-ee7e-60f6-612a-ae093a9459a5@linux.ibm.com>
 <7660d8e0d2cb1fbd40cf89ea4c9a0eff4807157c.camel@mellanox.com>
 <26dedb23-819f-8121-6e04-72677110f3cc@linux.ibm.com>
 <AM0PR05MB4866585FF543DA370E78B992D1670@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <0e94b811-7d2e-5c2d-f6a4-64dd536aa72d@linux.ibm.com>
 <AM0PR05MB4866B2F0A712A5DEAC1AFDA0D1670@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <1d8966f1-bc62-3981-6889-cda6ef19ae44@linux.ibm.com>
 <d4b590df-bc66-870f-2327-d207a3ee7134@mellanox.com>
From:   Niklas Schnelle <schnelle@linux.ibm.com>
Message-ID: <6323ccc1-c708-9a4f-aba8-6b3786136a92@linux.ibm.com>
Date:   Fri, 10 Jul 2020 10:34:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <d4b590df-bc66-870f-2327-d207a3ee7134@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-10_02:2020-07-10,2020-07-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 phishscore=0
 lowpriorityscore=0 clxscore=1015 priorityscore=1501 bulkscore=0
 impostorscore=0 mlxscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007100054
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/9/20 8:34 PM, Parav Pandit wrote:
> On 7/9/2020 3:36 PM, Niklas Schnelle wrote:
>>
>> On 7/8/20 5:44 PM, Parav Pandit wrote:
... snip ..

> 
>>>
>> As is the patch above fixes the dereference but results in the same completion error
>> as current 5.8-rc4
> 
> Below patch should hopefully fix it. It fixes the bug introduced in
> commit 41798df9bfca.
> Additionally it fixes one small change of 42ea9f1b5c62.
> Please remove all previous changes and apply below changes.
> Hopefully this should resolve.
> 
> 
> From a260b2e6a6065a57c2fa621271483cd51d0a1abf Mon Sep 17 00:00:00 2001
> From: Parav Pandit <parav@mellanox.com>
> Date: Thu, 9 Jul 2020 20:57:13 +0300
> Subject: [PATCH] net/mlx5: Drain health wq after unregistering device
> 
... snip ....Hmm, we still seem to be missing something, this patch
does not yet restore the v5.7 behavior and still results
in a hang on e.g. echo 1 > /proc/cio_settle after a vmcp detach pcif <fid>.
In particular the PCI device is never removed.
I do agree however that your changes make sense so maybe something else
broke the part that finally gives up on recovering the device.

By the you might want to turn off automatic line wrapping in your mail client
the patch was corrupted.

See the dmesg output below for the actual dmesg and below that
for the output on v5.7

[  111.243608] mlx5_core 0000:00:00.0: poll_health:702:(pid 0): Fatal error 1 detected
[  111.243851] mlx5_core 0000:00:00.0: print_health_info:380:(pid 0): assert_var[0] 0xffffffff
[  111.243858] mlx5_core 0000:00:00.0: print_health_info:380:(pid 0): assert_var[1] 0xffffffff
[  111.243864] mlx5_core 0000:00:00.0: print_health_info:380:(pid 0): assert_var[2] 0xffffffff
[  111.243871] mlx5_core 0000:00:00.0: print_health_info:380:(pid 0): assert_var[3] 0xffffffff
[  111.243878] mlx5_core 0000:00:00.0: print_health_info:380:(pid 0): assert_var[4] 0xffffffff
[  111.243885] mlx5_core 0000:00:00.0: print_health_info:383:(pid 0): assert_exit_ptr 0xffffffff
[  111.243892] mlx5_core 0000:00:00.0: print_health_info:385:(pid 0): assert_callra 0xffffffff
[  111.243902] mlx5_core 0000:00:00.0: print_health_info:388:(pid 0): fw_ver 65535.65535.65535
[  111.243909] mlx5_core 0000:00:00.0: print_health_info:389:(pid 0): hw_id 0xffffffff
[  111.243916] mlx5_core 0000:00:00.0: print_health_info:390:(pid 0): irisc_index 255
[  111.243925] mlx5_core 0000:00:00.0: print_health_info:391:(pid 0): synd 0xff: unrecognized error
[  111.243942] mlx5_core 0000:00:00.0: print_health_info:393:(pid 0): ext_synd 0xffff
[  111.243949] mlx5_core 0000:00:00.0: print_health_info:395:(pid 0): raw fw_ver 0xffffffff
[  111.244263] crw_info : CRW reports slct=0, oflw=0, chn=0, rsc=B, anc=0, erc=0, rsid=0
[  111.244291] mlx5_core 0000:00:00.0: PME# disabled
[  244.092384] INFO: task kmcheck:73 blocked for more than 122 seconds.
[  244.092626]       Not tainted 5.8.0-rc4-dirty #2
[  244.092631] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  244.092636] kmcheck         D10888    73      2 0x00000000
[  244.092648] Call Trace:
[  244.092659]  [<00000000088a1c46>] __schedule+0x2d6/0x5a8
[  244.092664]  [<00000000088a1f72>] schedule+0x5a/0x130
[  244.092671]  [<00000000088a8182>] schedule_timeout+0xfa/0x138
[  244.092677]  [<00000000088a37e8>] wait_for_completion+0xc0/0x110
[  244.092685]  [<0000000007d30798>] __flush_work+0xd8/0x120
[  244.092691]  [<0000000007d30f88>] __cancel_work_timer+0x150/0x208
[  244.092750]  [<000003ff801d5c4c>] mlx5_unload_one+0x64/0x148 [mlx5_core]
[  244.092770]  [<000003ff801d5dc2>] remove_one+0x52/0xd8 [mlx5_core]
[  244.092778]  [<0000000008532500>] pci_device_remove+0x40/0x90
[  244.092787]  [<00000000085a0012>] __device_release_driver+0x17a/0x220
[  244.092794]  [<00000000085a00f8>] device_release_driver+0x40/0x50
[  244.092812]  [<0000000008527dcc>] pci_stop_bus_device+0x94/0xc0
[  244.092817]  [<00000000085280c0>] pci_stop_and_remove_bus_device_locked+0x30/0x48
[  244.092822]  [<0000000007cfefd6>] __zpci_event_availability+0x12e/0x318
[  244.092829]  [<00000000088066fc>] chsc_process_event_information.constprop.0+0x214/0x228
[  244.092834]  [<000000000880daa8>] crw_collect_info+0x280/0x350
[  244.092840]  [<0000000007d38a96>] kthread+0x176/0x1a0
[  244.092844]  [<00000000088aa820>] ret_from_fork+0x24/0x2c
[  244.092863] 4 locks held by kmcheck/73:
[  244.092868]  #0: 0000000008db5e48 (crw_handler_mutex){+.+.}-{3:3}, at: crw_collect_info+0x250/0x350
[  244.092878]  #1: 0000000008d95668 (pci_rescan_remove_lock){+.+.}-{3:3}, at: pci_stop_and_remove_bus_device_locked+0x26/0x48
[  244.092887]  #2: 00000000de431238 (&dev->mutex){....}-{3:3}, at: device_release_driver+0x32/0x50
[  244.092896]  #3: 00000000d152cbb8 (&dev->intf_state_mutex){+.+.}-{3:3}, at: mlx5_unload_one+0x38/0x148 [mlx5_core]
[  244.092922] INFO: task kworker/u128:2:346 blocked for more than 122 seconds.
[  244.092932]       Not tainted 5.8.0-rc4-dirty #2
[  244.092936] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  244.092940] kworker/u128:2  D10848   346      2 0x02000000
[  244.092968] Workqueue: mlx5_health0000:00:00.0 mlx5_fw_fatal_reporter_err_work [mlx5_core]
[  244.092974] Call Trace:
[  244.092979]  [<00000000088a1c46>] __schedule+0x2d6/0x5a8
[  244.092985]  [<00000000088a1f72>] schedule+0x5a/0x130
[  244.092990]  [<00000000088a2704>] schedule_preempt_disabled+0x2c/0x48
[  244.092996]  [<00000000088a49c2>] __mutex_lock+0x372/0x960
[  244.093002]  [<00000000088a4fe2>] mutex_lock_nested+0x32/0x40
[  244.093021]  [<000003ff801e0978>] mlx5_enter_error_state+0xa0/0x100 [mlx5_core]
[  244.093041]  [<000003ff801e0a0c>] mlx5_fw_fatal_reporter_err_work+0x34/0xb8 [mlx5_core]
[  244.093047]  [<0000000007d2f84c>] process_one_work+0x27c/0x478
[  244.093054]  [<0000000007d2faae>] worker_thread+0x66/0x368
[  244.093061]  [<0000000007d38a96>] kthread+0x176/0x1a0
[  244.093067]  [<00000000088aa820>] ret_from_fork+0x24/0x2c
[  244.093077] 3 locks held by kworker/u128:2/346:
[  244.093081]  #0: 00000000d230d948 ((wq_completion)mlx5_health0000:00:00.0){+.+.}-{0:0}, at: process_one_work+0x1dc/0x478
[  244.093089]  #1: 000003e000783e18 ((work_completion)(&health->fatal_report_work)){+.+.}-{0:0}, at: process_one_work+0x1dc/0x478
[  244.093097]  #2: 00000000d152cbb8 (&dev->intf_state_mutex){+.+.}-{3:3}, at: mlx5_enter_error_state+0xa0/0x100 [mlx5_core]
[  244.093136]
               Showing all locks held in the system:
[  244.093147] 1 lock held by khungtaskd/27:
[  244.093153]  #0: 0000000008d16990 (rcu_read_lock){....}-{1:2}, at: rcu_lock_acquire.constprop.0+0x0/0x50
[  244.093164] 4 locks held by kmcheck/73:
[  244.093170]  #0: 0000000008db5e48 (crw_handler_mutex){+.+.}-{3:3}, at: crw_collect_info+0x250/0x350
[  244.093178]  #1: 0000000008d95668 (pci_rescan_remove_lock){+.+.}-{3:3}, at: pci_stop_and_remove_bus_device_locked+0x26/0x48
[  244.093187]  #2: 00000000de431238 (&dev->mutex){....}-{3:3}, at: device_release_driver+0x32/0x50
[  244.093199]  #3: 00000000d152cbb8 (&dev->intf_state_mutex){+.+.}-{3:3}, at: mlx5_unload_one+0x38/0x148 [mlx5_core]
[  244.093221] 3 locks held by kworker/u128:2/346:
[  244.093225]  #0: 00000000d230d948 ((wq_completion)mlx5_health0000:00:00.0){+.+.}-{0:0}, at: process_one_work+0x1dc/0x478
[  244.093233]  #1: 000003e000783e18 ((work_completion)(&health->fatal_report_work)){+.+.}-{0:0}, at: process_one_work+0x1dc/0x478
[  244.093241]  #2: 00000000d152cbb8 (&dev->intf_state_mutex){+.+.}-{3:3}, at: mlx5_enter_error_state+0xa0/0x100 [mlx5_core]

[  244.093274] =============================================

On v5.7 on the other hand the recovery flow is aborted and the device is released so
that the hard unplug can complete with the device completely removed:
(Note there are SMC messages in the below example that are not in the one above
but you can ignore them)

[78144.718600] mlx5_core 0001:00:00.0: poll_health:695:(pid 3222): Fatal error 1 detected
[78144.718608] mlx5_core 0001:00:00.0: print_health_info:373:(pid 3222): assert_var[0] 0xffffffff
[78144.718611] mlx5_core 0001:00:00.0: print_health_info:373:(pid 3222): assert_var[1] 0xffffffff
[78144.718613] mlx5_core 0001:00:00.0: print_health_info:373:(pid 3222): assert_var[2] 0xffffffff
[78144.718616] mlx5_core 0001:00:00.0: print_health_info:373:(pid 3222): assert_var[3] 0xffffffff
[78144.718619] mlx5_core 0001:00:00.0: print_health_info:373:(pid 3222): assert_var[4] 0xffffffff
[78144.718621] mlx5_core 0001:00:00.0: print_health_info:376:(pid 3222): assert_exit_ptr 0xffffffff
[78144.718625] mlx5_core 0001:00:00.0: print_health_info:378:(pid 3222): assert_callra 0xffffffff
[78144.718629] crw_info : CRW reports slct=0, oflw=0, chn=0, rsc=B, anc=0, erc=0, rsid=0
[78144.718634] mlx5_core 0001:00:00.0: print_health_info:381:(pid 3222): fw_ver 65535.65535.65535
[78144.718638] mlx5_core 0001:00:00.0: print_health_info:382:(pid 3222): hw_id 0xffffffff
[78144.718642] mlx5_core 0001:00:00.0: print_health_info:383:(pid 3222): irisc_index 255
[78144.718652] mlx5_core 0001:00:00.0: print_health_info:384:(pid 3222): synd 0xff: unrecognized error
[78144.718654] mlx5_core 0001:00:00.0: print_health_info:386:(pid 3222): ext_synd 0xffff
[78144.718656] mlx5_core 0001:00:00.0: print_health_info:388:(pid 3222): raw fw_ver 0xffffffff
[78144.718906] smc: removing ib device mlx5_0
[78144.719016] mlx5_core 0001:00:00.0: mlx5_health_try_recover:308:(pid 3174): handling bad device here
[78144.719020] mlx5_core 0001:00:00.0: mlx5_error_sw_reset:225:(pid 3174): start
[78145.754943] mlx5_core 0001:00:00.0: NIC IFC still 7 after 1000ms.
[78145.754947] mlx5_core 0001:00:00.0: mlx5_error_sw_reset:258:(pid 3174): end
[78206.864928] mlx5_core 0001:00:00.0: mlx5_health_try_recover:313:(pid 3174): health recovery flow aborted, PCI reads still not working
[78206.864955] mlx5_core 0001:00:00.0: mlx5_unload_one:1252:(pid 121): mlx5_unload_one: interface is down, NOP
[78206.905176] pci 0001:00:00.0: Removing from iommu group 1
[78206.906828] sclp_cmd: configure PCI I/O adapter failed: cmd=0x001b0001  response=0x09f0
[78206.906873] pci_bus 0001:00: busn_res: [bus 00] is released
