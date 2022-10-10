Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3F2C5F9855
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 08:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbiJJG3U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 02:29:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230497AbiJJG3T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 02:29:19 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DDB3558D0
        for <netdev@vger.kernel.org>; Sun,  9 Oct 2022 23:29:18 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29A6JO8n013288;
        Mon, 10 Oct 2022 06:29:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : from : cc : subject : content-type :
 content-transfer-encoding; s=pp1;
 bh=bWtZYa0S/4/kujc8ozLLdwxGTmxtrppMsqPz2V/2iEA=;
 b=h3FjnS5SwhnAVGWNjJnrZ21u6rwBjlp1gInN5nIWyf1M0GhB/3+km0RTtU3VSKMgNQGY
 7Nu3Vppv4JI1zgUzIpfBQFxbvZQ2tbijSqQvqDY2MVa3MadqKkX7CjES2VumAVd+bsW6
 X7SMmMs8WhKQUgIF5enNF897z0991cZkZPbsBSa42CWQwNKBfnnGi3Qjfs7wF6G+FqpY
 fw+XOR1W08zjHpLW9DkTngv7d/3iGjYHeZVMbBWSZyMBUGoJF0mIUenofUN3czYvaTaK
 fbgLVp+TN06VA+JpaFDyW6w9uAB3gaMASWqUjxD+9YhyuE1DVJ6ylvfK0KYWDPqRFgbW ZA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k3k8saasy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Oct 2022 06:29:15 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29A6NlI5021339;
        Mon, 10 Oct 2022 06:29:14 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k3k8saas5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Oct 2022 06:29:14 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29A6KUvU010012;
        Mon, 10 Oct 2022 06:29:13 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3k30fjabdh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Oct 2022 06:29:12 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29A6TAYw787046
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Oct 2022 06:29:10 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AB45042047;
        Mon, 10 Oct 2022 06:29:10 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 26BF342042;
        Mon, 10 Oct 2022 06:29:09 +0000 (GMT)
Received: from [9.43.57.55] (unknown [9.43.57.55])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 10 Oct 2022 06:29:08 +0000 (GMT)
Message-ID: <b8f845d8-9642-2008-4d7d-819ed6e44d9f@linux.ibm.com>
Date:   Mon, 10 Oct 2022 11:59:07 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     saeedm@nvidia.com, tariqt@nvidia.com
From:   Ganesh <ganeshgr@linux.ibm.com>
Cc:     netdev@vger.kernel.org, oohall@gmail.com
Subject: mlx cards failing to recover from EEH errors
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: xjcZCWkhjOxA6vsFRGNOT5bCeEVsyk6-
X-Proofpoint-GUID: B_zG6oy9rIjRLu2fZ7MMfCl4MKTX3bM-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-07_04,2022-10-07_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 phishscore=0 impostorscore=0 mlxscore=0 mlxlogscore=999 spamscore=0
 malwarescore=0 lowpriorityscore=0 clxscore=1011 priorityscore=1501
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210100036
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_FILL_THIS_FORM_SHORT autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Saeed/Tariq,

On PPC, Since v5.17-rc1 EEH error recovery is not happening on mlx cards,

Any idea what has gone wrong ?

Log:

[  649.335564] mlx5_core 0041:01:00.0: poll_health:817:(pid 0): Fatal 
error 1 detected
[  649.335588] mlx5_core 0041:01:00.0: print_health_info:423:(pid 0): 
PCI slot is unavailable
[  649.336397] EEH: Recovering PHB#41-PE#10000
[  649.336410] EEH: PE location: N/A, PHB location: N/A
[  649.336416] EEH: Frozen PHB#41-PE#10000 detected
[  649.336422] EEH: Call Trace:
[  649.336426] EEH: [c000000000053b78] __eeh_send_failure_event+0x78/0x150
[  649.336597] EEH: [c00000000004ccf8] eeh_dev_check_failure+0x318/0x6b0
[  649.336607] EEH: [c00000000004d158] eeh_check_failure+0xc8/0x100
[  649.336615] EEH: [c0000000007e1454] ioread32be+0x114/0x180
[  649.336623] EEH: [c008000002eb4308] 
mlx5_health_check_fatal_sensors+0x30/0x190 [mlx5_core]
[  649.336684] EEH: [c008000002eb4c10] poll_health+0x58/0x270 [mlx5_core]
[  649.336740] EEH: [c000000000237098] call_timer_fn+0x58/0x1f0
[  649.336748] EEH: [c000000000238490] run_timer_softirq+0x360/0x7f0
[  649.336756] EEH: [c000000000e971f8] __do_softirq+0x158/0x3d0
[  649.336766] EEH: [c0000000000167c0] do_softirq_own_stack+0x40/0x60
[  649.336775] EEH: [c00000000014dd98] irq_exit+0x178/0x1c0
[  649.336782] EEH: [c0000000000273f4] timer_interrupt+0x194/0x410
[  649.336791] EEH: [c000000000009964] decrementer_common_virt+0x214/0x220
[  649.336805] EEH: [0000009721f89180] 0x9721f89180
[  649.336813] EEH: [c000000000b349bc] dedicated_cede_loop+0x9c/0x1b0
[  649.336825] EEH: [c000000000b31114] cpuidle_enter_state+0x364/0x570
[  649.336835] EEH: [c000000000b313c0] cpuidle_enter+0x50/0x70
[  649.336845] EEH: [c0000000001bac68] do_idle+0x3a8/0x420
[  649.336855] EEH: [c0000000001baf18] cpu_startup_entry+0x38/0x40
[  649.336869] EEH: [c0000000000125bc] rest_init+0xec/0xf0
[  649.336878] EEH: [c000000002004274] arch_post_acpi_subsys_init+0x0/0xc
[  649.336889] EEH: [c000000002004cc4] start_kernel+0xa14/0xa64
[  649.336900] EEH: [c00000000000d780] start_here_common+0x1c/0x9c
[  649.336909] EEH: This PCI device has failed 1 times in the last hour 
and will be permanently disabled after 5 failures.
[  649.336921] EEH: Notify device drivers to shutdown
[  649.336929] EEH: Beginning: 'error_detected(IO frozen)'
[  649.336937] PCI 0041:01:00.0#10000: EEH: Invoking 
mlx5_core->error_detected(IO frozen)
[  649.336943] mlx5_core 0041:01:00.0: mlx5_pci_err_detected Device 
state = 2 health sensors: 1 pci_status: 1. Enter, pci channel state = 2
[  649.336967] mlx5_core 0041:01:00.0: mlx5_error_sw_reset:243:(pid 
198): start
[  649.339914] mlx5_core 0041:01:00.0: mlx5_crdump_fill:34:(pid 206): 
failed to read full dump, read 32 out of 1179644
[  649.340586] mlx5_core 0041:01:00.0: mlx5_health_try_recover:335:(pid 
206): handling bad device here
[  650.695123] mlx5_core 0041:01:00.1: poll_health:817:(pid 0): Fatal 
error 1 detected
[  650.695140] mlx5_core 0041:01:00.1: print_health_info:423:(pid 0): 
PCI slot is unavailable
[  650.698918] mlx5_core 0041:01:00.1: mlx5_crdump_fill:34:(pid 1016): 
failed to read full dump, read 32 out of 1179644
[  650.699581] mlx5_core 0041:01:00.1: mlx5_health_try_recover:335:(pid 
1016): handling bad device here
[  650.699594] mlx5_core 0041:01:00.1: mlx5_error_sw_reset:243:(pid 
1016): start
[  651.375132] mlx5_core 0041:01:00.0: NIC IFC still 7 after 2000ms.
[  651.375149] mlx5_core 0041:01:00.0: mlx5_error_sw_reset:276:(pid 
198): end
[  651.375171] mlx5_core 0041:01:00.0: mlx5_error_sw_reset:243:(pid 
206): start
[  652.735131] mlx5_core 0041:01:00.1: NIC IFC still 7 after 2000ms.
[  652.735143] mlx5_core 0041:01:00.1: mlx5_error_sw_reset:276:(pid 
1016): end
[  653.075350] mlx5_core 0041:01:00.1: mlx5_wait_for_pages:759:(pid 
1016): Skipping wait for vf pages stage
[  653.135142] mlx5_core 0041:01:00.1: E-Switch: Disable: mode(LEGACY), 
nvfs(0), active vports(0)
[  653.395129] mlx5_core 0041:01:00.0: NIC IFC still 7 after 2000ms.
[  653.395151] mlx5_core 0041:01:00.0: mlx5_error_sw_reset:276:(pid 
206): end
[  653.765354] mlx5_core 0041:01:00.0: mlx5_wait_for_pages:759:(pid 
206): Skipping wait for vf pages stage
[  653.835135] mlx5_core 0041:01:00.0: E-Switch: Disable: mode(LEGACY), 
nvfs(0), active vports(0)
[  716.685141] mlx5_core 0041:01:00.1: mlx5_health_try_recover:338:(pid 
1016): health recovery flow aborted, PCI reads still not working
[  717.245141] mlx5_core 0041:01:00.0: mlx5_health_try_recover:338:(pid 
206): health recovery flow aborted, PCI reads still not working
[  717.245175] mlx5_core 0041:01:00.0: 
mlx5_unload_one_devl_locked:1505:(pid 198): mlx5_unload_one_devl_locked: 
interface is down, NOP
[  717.245290] mlx5_core 0041:01:00.0: mlx5_pci_err_detected Device 
state = 2 health sensors: 1 pci_status: 0. Exit, result = 3, need reset
[  717.245332] PCI 0041:01:00.0#10000: EEH: mlx5_core driver reports: 
'need reset'
[  717.245338] PCI 0041:01:00.1#10000: EEH: Invoking 
mlx5_core->error_detected(IO frozen)
[  717.245352] mlx5_core 0041:01:00.1: mlx5_pci_err_detected Device 
state = 2 health sensors: 1 pci_status: 1. Enter, pci channel state = 2
[  717.245380] mlx5_core 0041:01:00.1: mlx5_error_sw_reset:243:(pid 
198): start
[  719.265142] mlx5_core 0041:01:00.1: NIC IFC still 7 after 2000ms.
[  719.265160] mlx5_core 0041:01:00.1: mlx5_error_sw_reset:276:(pid 
198): end
[  719.265170] mlx5_core 0041:01:00.1: 
mlx5_unload_one_devl_locked:1505:(pid 198): mlx5_unload_one_devl_locked: 
interface is down, NOP
[  719.265350] mlx5_core 0041:01:00.1: mlx5_pci_err_detected Device 
state = 2 health sensors: 1 pci_status: 0. Exit, result = 3, need reset
[  719.265385] PCI 0041:01:00.1#10000: EEH: mlx5_core driver reports: 
'need reset'
[  719.265391] EEH: Finished:'error_detected(IO frozen)' with aggregate 
recovery state:'need reset'
[  719.265526] EEH: Collect temporary log
[  719.267450] EEH: of node=0041:01:00.0
[  719.267543] EEH: PCI device/vendor: 101515b3
[  719.267616] EEH: PCI cmd/status register: 00100140
[  719.267625] EEH: PCI-E capabilities and status follow:
[  719.267962] EEH: PCI-E 00: 00024810 10008fe2 0009595f 00417883
[  719.268232] EEH: PCI-E 10: 10830000 00000000 00000000 00000000
[  719.268241] EEH: PCI-E 20: 00000000
[  719.268245] EEH: PCI-E AER capability register set follows:
[  719.268567] EEH: PCI-E AER 00: 15010001 00000000 00000000 00062010
[  719.268827] EEH: PCI-E AER 10: 00002000 00002000 000001e4 00000000
[  719.269087] EEH: PCI-E AER 20: 00000000 00000000 00000000 00000000
[  719.269157] EEH: PCI-E AER 30: 00000000 00000000
[  719.269165] EEH: of node=0041:01:00.1
[  719.269234] EEH: PCI device/vendor: 101515b3
[  719.269305] EEH: PCI cmd/status register: 00100142
[  719.269312] EEH: PCI-E capabilities and status follow:
[  719.269649] EEH: PCI-E 00: 00024810 10008fe2 0009595f 00417883
[  719.269913] EEH: PCI-E 10: 10830000 00000000 00000000 00000000
[  719.269921] EEH: PCI-E 20: 00000000
[  719.269926] EEH: PCI-E AER capability register set follows:
[  719.270245] EEH: PCI-E AER 00: 15010001 00000000 00000000 00062010
[  719.270507] EEH: PCI-E AER 10: 00002000 00002000 000001e4 00000000
[  719.270765] EEH: PCI-E AER 20: 00000000 00000000 00000000 00000000
[  719.270835] EEH: PCI-E AER 30: 00000000 00000000
[  719.272823] EEH: Reset without hotplug activity
[  721.637535] EEH: Beginning: 'slot_reset'
[  721.637547] PCI 0041:01:00.0#10000: EEH: Invoking mlx5_core->slot_reset()
[  721.637907] mlx5_core 0041:01:00.0: mlx5_pci_slot_reset Device state 
= 2 health sensors: 1 pci_status: 0. Enter
[  721.638058] mlx5_core 0041:01:00.0: enabling device (0140 -> 0142)
[  728.645144] mlx5_core 0041:01:00.0: mlx5_pci_slot_reset:1856:(pid 
198): mlx5_pci_slot_reset: wait vital failed with error code: -110
[  728.645164] mlx5_core 0041:01:00.0: mlx5_pci_slot_reset Device state 
= 2 health sensors: 1 pci_status: 1. Exit, err = -110, result = 4, 
disconnect
[  728.645177] PCI 0041:01:00.0#10000: EEH: mlx5_core driver reports: 
'disconnect'
[  728.645182] PCI 0041:01:00.1#10000: EEH: Invoking mlx5_core->slot_reset()
[  728.645191] mlx5_core 0041:01:00.1: mlx5_pci_slot_reset Device state 
= 2 health sensors: 1 pci_status: 0. Enter
[  728.645351] mlx5_core 0041:01:00.1: enabling device (0140 -> 0142)
[  735.645147] mlx5_core 0041:01:00.1: mlx5_pci_slot_reset:1856:(pid 
198): mlx5_pci_slot_reset: wait vital failed with error code: -110
[  735.645169] mlx5_core 0041:01:00.1: mlx5_pci_slot_reset Device state 
= 2 health sensors: 1 pci_status: 1. Exit, err = -110, result = 4, 
disconnect
[  735.645182] PCI 0041:01:00.1#10000: EEH: mlx5_core driver reports: 
'disconnect'
[  735.645187] EEH: Finished:'slot_reset' with aggregate recovery 
state:'disconnect'
[  735.645199] EEH: Unable to recover from failure from PHB#41-PE#10000.
[  735.645199] Please try reseating or replacing it
[  735.647109] EEH: of node=0041:01:00.0
[  735.647180] EEH: PCI device/vendor: 101515b3
[  735.647251] EEH: PCI cmd/status register: 00100546
[  735.647259] EEH: PCI-E capabilities and status follow:
[  735.647592] EEH: PCI-E 00: 00024810 10008fe2 0009595f 00417883
[  735.647858] EEH: PCI-E 10: 10830000 00000000 00000000 00000000
[  735.647866] EEH: PCI-E 20: 00000000
[  735.647870] EEH: PCI-E AER capability register set follows:
[  735.648195] EEH: PCI-E AER 00: 15010001 00000000 00000000 00062010
[  735.648456] EEH: PCI-E AER 10: 00000000 00002000 000001e4 00000000
[  735.648713] EEH: PCI-E AER 20: 00000000 00000000 00000000 00000000
[  735.648783] EEH: PCI-E AER 30: 00000000 00000000
[  735.648791] EEH: of node=0041:01:00.1
[  735.648861] EEH: PCI device/vendor: 101515b3
[  735.648930] EEH: PCI cmd/status register: 00100546
[  735.648937] EEH: PCI-E capabilities and status follow:
[  735.649267] EEH: PCI-E 00: 00024810 10008fe2 0009595f 00417883
[  735.649533] EEH: PCI-E 10: 10830000 00000000 00000000 00000000
[  735.649540] EEH: PCI-E 20: 00000000
[  735.649544] EEH: PCI-E AER capability register set follows:
[  735.649864] EEH: PCI-E AER 00: 15010001 00000000 00000000 00062010
[  735.650127] EEH: PCI-E AER 10: 00000000 00002000 000001e4 00000000
[  735.650386] EEH: PCI-E AER 20: 00000000 00000000 00000000 00000000
[  735.650456] EEH: PCI-E AER 30: 00000000 00000000
[  735.652599] EEH: Beginning: 'error_detected(permanent failure)'
[  735.652608] PCI 0041:01:00.0#10000: EEH: not actionable (1,1,1)
[  735.652612] PCI 0041:01:00.1#10000: EEH: not actionable (1,1,1)
[  735.652619] EEH: Finished:'error_detected(permanent failure)'
[  735.725229] mlx5_core 0041:01:00.1: E-Switch: Unload vfs: 
mode(LEGACY), nvfs(0), active vports(0)
[  735.725265] mlx5_core 0041:01:00.1: mlx5_wait_for_pages:759:(pid 
198): Skipping wait for vf pages stage
[  736.005168] mlx5_core 0041:01:00.1: mlx5_uninit_one:1424:(pid 198): 
mlx5_uninit_one: interface is down, NOP
[  736.005425] mlx5_core 0041:01:00.1: E-Switch: cleanup
[  736.165474] pci 0041:01:00.1: Removing from iommu group 0
[  736.265197] mlx5_core 0041:01:00.0: E-Switch: Unload vfs: 
mode(LEGACY), nvfs(0), active vports(0)
[  736.265214] mlx5_core 0041:01:00.0: mlx5_wait_for_pages:759:(pid 
198): Skipping wait for vf pages stage
[  736.515164] mlx5_core 0041:01:00.0: mlx5_uninit_one:1424:(pid 198): 
mlx5_uninit_one: interface is down, NOP
[  736.515366] mlx5_core 0041:01:00.0: E-Switch: cleanup
[  736.605455] pci 0041:01:00.0: Removing from iommu group 0
[  736.605562] eeh_handle_normal_event: Cannot find PCI bus for 
PHB#41-PE#10000

