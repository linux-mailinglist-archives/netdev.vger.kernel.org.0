Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23938219D03
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 12:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbgGIKHz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 06:07:55 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:53994 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726315AbgGIKHz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 06:07:55 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 069A1tV8105473;
        Thu, 9 Jul 2020 06:07:50 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 325kgxn7pe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Jul 2020 06:07:49 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 069A5233022762;
        Thu, 9 Jul 2020 10:07:47 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma02fra.de.ibm.com with ESMTP id 325mr2rqbx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Jul 2020 10:07:47 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 069A6TI158392700
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Jul 2020 10:06:29 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9A3F0AE04D;
        Thu,  9 Jul 2020 10:06:29 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 006EFAE051;
        Thu,  9 Jul 2020 10:06:29 +0000 (GMT)
Received: from oc5500677777.ibm.com (unknown [9.145.14.142])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  9 Jul 2020 10:06:28 +0000 (GMT)
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
From:   Niklas Schnelle <schnelle@linux.ibm.com>
Message-ID: <1d8966f1-bc62-3981-6889-cda6ef19ae44@linux.ibm.com>
Date:   Thu, 9 Jul 2020 12:06:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <AM0PR05MB4866B2F0A712A5DEAC1AFDA0D1670@AM0PR05MB4866.eurprd05.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-09_05:2020-07-09,2020-07-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 suspectscore=0 bulkscore=0 priorityscore=1501 mlxscore=0
 adultscore=0 clxscore=1015 malwarescore=0 mlxlogscore=999 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007090075
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 7/8/20 5:44 PM, Parav Pandit wrote:
... snip ..
>>
> 
> It is likely because events_cleanup() freed the memory using kvfree() that health recovery context is trying to access in notifier chain.
> 
> While reviewing I see few more errors as below.
> (a) mlx5_pci_err_detected() invokes mlx5_drain_health_wq() outside of intf_state_mutex.
> (b) mlx5_enter_error_state() in commit b6e0b6bebe0 read and updates dev state outside of intf_state_mutex.
> (c) due to drain_health_wq() introduction in mlx5_pci_close()  in commit 42ea9f1b5c625 health_wq is flushed twice.
> (d) priv->events freed is kvfree() but allocated using kzalloc().
> 
> This code certainly needs rework.
> 
> In meantime to avoid this regression, I believe below hunk eliminates error introduced in patch 41798df9bfc.
> Will you please help test it?
> 
> Shay and I did the review of below patch.
> If it works I will get it through Saeed's tree and internal reviews.
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> index ebec2318dbc4..529df5703737 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> @@ -785,11 +785,6 @@ static int mlx5_pci_init(struct mlx5_core_dev *dev, struct pci_dev *pdev,
> 
>  static void mlx5_pci_close(struct mlx5_core_dev *dev)
>  {
> -       /* health work might still be active, and it needs pci bar in
> -        * order to know the NIC state. Therefore, drain the health WQ
> -        * before removing the pci bars
> -        */
> -       mlx5_drain_health_wq(dev);
>         iounmap(dev->iseg);
>         pci_clear_master(dev->pdev);
>         release_bar(dev->pdev);
> @@ -1235,6 +1230,7 @@ void mlx5_unload_one(struct mlx5_core_dev *dev, bool cleanup)
>         if (cleanup) {
>                 mlx5_unregister_device(dev);
>                 mlx5_devlink_unregister(priv_to_devlink(dev));
> +               mlx5_drain_health_wq(dev);
I think with the above you can remove the mlx5_drain_health_wq(dev) in remove_one()
as that calls mlx5_unload_one() with cleanup == true. Also I wonder if it is a problem
that the order of mlx5_devlink_unregister(priv_to_devlink(dev)) and mlx5_unregister_device(dev)
is switched compared to the 5.7 code. That said changing both seems to result in a deadlock
though not the "leak of a command resource":

[   48.082222] mlx5_core 0000:00:00.0: poll_health:702:(pid 0): Fatal error 1 detected
[   48.082296] mlx5_core 0000:00:00.0: print_health_info:380:(pid 0): assert_var[0] 0xffffffff
[   48.082303] mlx5_core 0000:00:00.0: print_health_info:380:(pid 0): assert_var[1] 0xffffffff
[   48.082309] mlx5_core 0000:00:00.0: print_health_info:380:(pid 0): assert_var[2] 0xffffffff
[   48.082316] mlx5_core 0000:00:00.0: print_health_info:380:(pid 0): assert_var[3] 0xffffffff
[   48.082322] mlx5_core 0000:00:00.0: print_health_info:380:(pid 0): assert_var[4] 0xffffffff
[   48.082329] mlx5_core 0000:00:00.0: print_health_info:383:(pid 0): assert_exit_ptr 0xffffffff
[   48.082336] mlx5_core 0000:00:00.0: print_health_info:385:(pid 0): assert_callra 0xffffffff
[   48.082345] mlx5_core 0000:00:00.0: print_health_info:388:(pid 0): fw_ver 65535.65535.65535
[   48.082353] mlx5_core 0000:00:00.0: print_health_info:389:(pid 0): hw_id 0xffffffff
[   48.082360] mlx5_core 0000:00:00.0: print_health_info:390:(pid 0): irisc_index 255
[   48.082374] mlx5_core 0000:00:00.0: print_health_info:391:(pid 0): synd 0xff: unrecognized error
[   48.082390] mlx5_core 0000:00:00.0: print_health_info:393:(pid 0): ext_synd 0xffff
[   48.082396] mlx5_core 0000:00:00.0: print_health_info:395:(pid 0): raw fw_ver 0xffffffff
[   48.082824] crw_info : CRW reports slct=0, oflw=0, chn=0, rsc=B, anc=0, erc=0, rsid=0
[   48.082852] mlx5_core 0000:00:00.0: PME# disabled
[  244.103844] INFO: task kworker/u128:1:63 blocked for more than 122 seconds.
[  244.104076]       Not tainted 5.8.0-rc4-dirty #2
[  244.104081] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  244.104086] kworker/u128:1  D13264    63      2 0x00000000
[  244.104158] Workqueue: mlx5_health0000:00:00.0 mlx5_fw_fatal_reporter_err_work [mlx5_core]
[  244.104164] Call Trace:
[  244.104174]  [<0000000031cf1c46>] __schedule+0x2d6/0x5a8
[  244.104180]  [<0000000031cf1f72>] schedule+0x5a/0x130
[  244.104186]  [<0000000031cf2704>] schedule_preempt_disabled+0x2c/0x48
[  244.104192]  [<0000000031cf49c2>] __mutex_lock+0x372/0x960
[  244.104198]  [<0000000031cf4fe2>] mutex_lock_nested+0x32/0x40
[  244.104219]  [<000003ff801e4978>] mlx5_enter_error_state+0xa0/0x100 [mlx5_core]
[  244.104238]  [<000003ff801e4a0c>] mlx5_fw_fatal_reporter_err_work+0x34/0xb8 [mlx5_core]
[  244.104249]  [<000000003117f84c>] process_one_work+0x27c/0x478
[  244.104255]  [<000000003117faae>] worker_thread+0x66/0x368
[  244.104275]  [<0000000031188a96>] kthread+0x176/0x1a0
[  244.104280]  [<0000000031cfa820>] ret_from_fork+0x24/0x2c
[  244.104285] 3 locks held by kworker/u128:1/63:
[  244.104289]  #0: 00000000d0392948 ((wq_completion)mlx5_health0000:00:00.0){+.+.}-{0:0}, at: process_one_work+0x1dc/0x478
[  244.104298]  #1: 000003e00295fe18 ((work_completion)(&health->fatal_report_work)){+.+.}-{0:0}, at: process_one_work+0x1dc/0x478
[  244.104305]  #2: 00000000d1b2cbb8 (&dev->intf_state_mutex){+.+.}-{3:3}, at: mlx5_enter_error_state+0xa0/0x100 [mlx5_core]
[  244.104328] INFO: task kmcheck:73 blocked for more than 122 seconds.
[  244.104333]       Not tainted 5.8.0-rc4-dirty #2
[  244.104337] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  244.104341] kmcheck         D10888    73      2 0x00000000
[  244.104350] Call Trace:
[  244.104355]  [<0000000031cf1c46>] __schedule+0x2d6/0x5a8
[  244.104360]  [<0000000031cf1f72>] schedule+0x5a/0x130
[  244.104365]  [<0000000031cf8182>] schedule_timeout+0xfa/0x138
[  244.104370]  [<0000000031cf37e8>] wait_for_completion+0xc0/0x110
[  244.104374]  [<0000000031180798>] __flush_work+0xd8/0x120
[  244.104380]  [<0000000031180f88>] __cancel_work_timer+0x150/0x208
[  244.104398]  [<000003ff801d9c3a>] mlx5_unload_one+0x52/0x148 [mlx5_core]
[  244.104416]  [<000003ff801d9dc2>] remove_one+0x52/0xd8 [mlx5_core]
[  244.104422]  [<0000000031982500>] pci_device_remove+0x40/0x90
[  244.104429]  [<00000000319f0012>] __device_release_driver+0x17a/0x220
[  244.104433]  [<00000000319f00f8>] device_release_driver+0x40/0x50
[  244.104439]  [<0000000031977dcc>] pci_stop_bus_device+0x94/0xc0
[  244.104444]  [<00000000319780c0>] pci_stop_and_remove_bus_device_locked+0x30/0x48
[  244.104449]  [<000000003114efd6>] __zpci_event_availability+0x12e/0x318
[  244.104456]  [<0000000031c566fc>] chsc_process_event_information.constprop.0+0x214/0x228
[  244.104461]  [<0000000031c5daa8>] crw_collect_info+0x280/0x350
[  244.104466]  [<0000000031188a96>] kthread+0x176/0x1a0
[  244.104470]  [<0000000031cfa820>] ret_from_fork+0x24/0x2c
[  244.104475] 4 locks held by kmcheck/73:
[  244.104479]  #0: 0000000032205e48 (crw_handler_mutex){+.+.}-{3:3}, at: crw_collect_info+0x250/0x350
[  244.104486]  #1: 00000000321e5668 (pci_rescan_remove_lock){+.+.}-{3:3}, at: pci_stop_and_remove_bus_device_locked+0x26/0x48
[  244.104493]  #2: 00000000d7fd1238 (&dev->mutex){....}-{3:3}, at: device_release_driver+0x32/0x50
[  244.104553]  #3: 00000000d1b2cbb8 (&dev->intf_state_mutex){+.+.}-{3:3}, at: mlx5_unload_one+0x38/0x148 [mlx5_core]



>         } else {
>                 mlx5_detach_device(dev);
>         }
> @@ -1366,6 +1362,11 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *id)
>         return 0;
> 
>  err_load_one:
> +       /* health work might still be active, and it needs pci bar in
> +        * order to know the NIC state. Therefore, drain the health WQ
> +        * before removing the pci bars
> +        */
> +       mlx5_drain_health_wq(dev);
>         mlx5_pci_close(dev);
>  pci_init_err:
>         mlx5_mdev_uninit(dev);
> 
As is the patch above fixes the dereference but results in the same completion error
as current 5.8-rc4

[  103.257202] mlx5_core 0000:00:00.0: poll_health:702:(pid 930): Fatal error 1 detected
[  103.257405] mlx5_core 0000:00:00.0: print_health_info:380:(pid 930): assert_var[0] 0xffffffff
...
[  114.268505] mlx5_core 0000:00:00.0: poll_health:717:(pid 0): device's health compromised - reached miss count
[  114.268524] mlx5_core 0000:00:00.0: print_health_info:380:(pid 0): assert_var[0] 0xffffffff
...
[  167.308576] mlx5_core 0000:00:00.0: wait_func:1008:(pid 73): 2RST_QP(0x50a) timeout. Will cause a leak of a command resource
[  167.308799] infiniband mlx5_0: destroy_qp_common:2367:(pid 73): mlx5_ib: modify QP 0x000724 to RESET failed
[  198.028576] mlx5_core 0000:00:00.0: wait_func:1008:(pid 407): QUERY_VPORT_COUNTER(0x770) timeout. Will cause a leak of a command resource
[  228.748700] mlx5_core 0000:00:00.0: wait_func:1008:(pid 73): DESTROY_QP(0x501) timeout. Will cause a leak of a command resource
[  259.468867] mlx5_core 0000:00:00.0: wait_func:1008:(pid 407): QUERY_Q_COUNTER(0x773) timeout. Will cause a leak of a command resource
[  290.189284] mlx5_core 0000:00:00.0: wait_func:1008:(pid 73): DESTROY_CQ(0x401) timeout. Will cause a leak of a command resource
[  320.909972] mlx5_core 0000:00:00.0: wait_func:1008:(pid 407): QUERY_Q_COUNTER(0x773) timeout. Will cause a leak of a command resource
[  351.628945] mlx5_core 0000:00:00.0: wait_func:1008:(pid 73): DESTROY_CQ(0x401) timeout. Will cause a leak of a command resource
> 
> 
> 
... snip ...
