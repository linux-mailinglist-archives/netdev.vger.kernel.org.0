Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA8164EB97
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 13:50:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbiLPMu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 07:50:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiLPMuz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 07:50:55 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9775C43;
        Fri, 16 Dec 2022 04:50:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lJUh8eICHhLWBypSOjqNDC11zL35XL6+LTJUvTExAw1p2nN55ZG8b2uNVBkITKgqeraMrV8v3aChBFo3XHb61ma+swSbf7DoRGgsnsNhSdargxdpuCk6vHuEZXeTJfSs6wQMDMxcCf5RdbLEFGjMmRdPPtoCIrIfAtWbn/cPacyDsKB+sLYz34nEub/Q481b4c6DEybG0e3zg7HX0OJkeEUgxqMbhMaqh3qd+n423NBlxbp2CGpy//7BHnydyhyI0yrcfj16YdEffPpliF9BPIVuaRAAZE6i+OlNTxvw6Lgl6KCTbGUcVSwURlCPuepj3Ud+kBcP3WamGOgxmNCl5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cx4n5jxFekeaqWwEZBNVVP4EV0D8hFjCvfk80748nZ8=;
 b=c5efu2cRPT/smBZH+k6sd0hhEiEDGmP+3CXyH4CMVIhBIgSPbzRghIpeZwjXaU1pqavse960r4LZeYu+k5f1r1kld/sQoOy9ipD37AOWmGA8qtb70A320cQe2unQ5WahqciRdlkFif7uslI3JJVpeaJRC+ahvRrMfwNbOqXne8iAouC2otnVkEhV4qoS2rRkkrYH2YG0F2zt7uS31Gp8aGHPHIp39iCByB5x7Ys4L4liIIK2t8MKwVJuGiIrvpxJCej15yt1Mg/r1UV+z1qNbR448eV3UyJ1pBF+0Xt3gye7oOo/jMx9KxLSeH7/rVPoMEW/NdhlfLO2WxddGJDwbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cx4n5jxFekeaqWwEZBNVVP4EV0D8hFjCvfk80748nZ8=;
 b=FH4eNgq+vrSezeqHxqw9SPncOTneAgW9adfqdLANdE5CyEmIXvt6GGvcU/cs4bVCgx4y0xTget+z+ZkV71iNJzCfTHN62FyrXb6PCsI9omQX/77zkMHBJhn3cUWvFJNDAvlSIAHDfK1X4T6h9KTJuxwlK12ZtxKUOxi5UxvLoPI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5825.namprd12.prod.outlook.com (2603:10b6:208:394::20)
 by DM6PR12MB4355.namprd12.prod.outlook.com (2603:10b6:5:2a3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11; Fri, 16 Dec
 2022 12:50:48 +0000
Received: from BL1PR12MB5825.namprd12.prod.outlook.com
 ([fe80::2e66:40bf:438e:74b]) by BL1PR12MB5825.namprd12.prod.outlook.com
 ([fe80::2e66:40bf:438e:74b%9]) with mapi id 15.20.5924.015; Fri, 16 Dec 2022
 12:50:48 +0000
Message-ID: <bad68533-dc5e-7728-2e42-287fa91426d8@amd.com>
Date:   Fri, 16 Dec 2022 18:20:36 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next 02/11] sfc: implement MCDI interface for vDPA
 operations
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>,
        Gautam Dawar <gautam.dawar@amd.com>
Cc:     linux-net-drivers@amd.com, netdev@vger.kernel.org,
        eperezma@redhat.com, tanuj.kamde@amd.com, Koushik.Dutta@amd.com,
        harpreet.anand@amd.com, Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
References: <20221207145428.31544-1-gautam.dawar@amd.com>
 <20221207145428.31544-3-gautam.dawar@amd.com>
 <CACGkMEuEJ9+wkFSiwUFGUi4RuQyJe2mc4fCNTwMw=S4SsSboiQ@mail.gmail.com>
From:   Gautam Dawar <gdawar@amd.com>
In-Reply-To: <CACGkMEuEJ9+wkFSiwUFGUi4RuQyJe2mc4fCNTwMw=S4SsSboiQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0174.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:26::29) To BL1PR12MB5825.namprd12.prod.outlook.com
 (2603:10b6:208:394::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5825:EE_|DM6PR12MB4355:EE_
X-MS-Office365-Filtering-Correlation-Id: 935c1ee8-e69d-4e62-31e9-08dadf6427ac
X-LD-Processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BdfqUrFaEIKilb5U2hkRNfdgzwSDiXz5MfwtaUH+GdSpggCBsfxDsp08YHdw2IsTqKPQ3gY0TbGxF4/T9OL8wqqoprgikdMobeZCN0bBMHGkldQjNfKcV84NU7i5cpkdXtb9RJ2qsv0nskId46pyMBIE6QvYZjSPI+xv+cv1NuBiUIWK05RqFMTdRJV2E4YKUbdTYYtoaGD8AuaMn4tO7ActIWNr/woN9BuTiRR7iRHJx7T/1Gj6MNqRGDBGQTZ0ozEIhIkGnGzhbqH6NQAjEFXry0WmrEnAakYxgXgkV9oTkJ9Vkp7wLxTs8/Qsm4rbgfgO8X5+HqTvQGkhSv3D8R1MEUAq6eFXGkDrRvFmWraS/Te/Ow5Aw6fB2Ci5cMeLJtB/MsXvAJUhHbk8mSMcK3lbnUd1uGW8Lzb/JDe9/iVPjaeyd56lqswy8cqR9dreqxI4ZM6Q8uhACUV71Qu5yj7RW0zqbEBfkYZIZGWmScBJAd/Lz/6IZgf3qhYlSoHFWYHO12aRXJ1x61is49AXn4iCUtpSx0a5PTgX3fDpkNnu8KX75FeMf3rcl0fXrApgwEuzmeRXGW9XopOevNjV8ryVPvjBWWNLLf7mDBwlVBAI8P2D07QriuCkR4jp/QWAep+RKXWOEVq7bDryI4z/LqqDGdgnkAlStcX76tZxWmC3mESGuUHdZ8Ohs90l+xa7ub9GXmCQarDzOTgQb0Vy1KUNiF3kDjqhmybNMRNXZsacKFo5xl9TCUtqfK8bTJ3z
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5825.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(346002)(136003)(39860400002)(376002)(451199015)(31686004)(36756003)(54906003)(7416002)(8936002)(30864003)(5660300002)(6506007)(38100700002)(31696002)(41300700001)(110136005)(83380400001)(6636002)(478600001)(66946007)(6486002)(26005)(6666004)(6512007)(4326008)(8676002)(66476007)(66556008)(53546011)(186003)(316002)(2616005)(2906002)(2004002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dnIwY1NLbU13cUIxNmowdm42T1VocXNCS21SdWE5VmtWRGkxc1poR0FvdDJx?=
 =?utf-8?B?R3JLL08yTm1ueVFWc0IxcFdabHJQVVg5VC83VElOaGJpVXZwVThaTlVDZTBs?=
 =?utf-8?B?K2NOWEI3R0MvQUhqeWdQWm5nS0xPODVLYU9veFFaR28vdGtoa1NHakpUWjVL?=
 =?utf-8?B?VnBERjVacy9SNk15WkoxOUxDWHB4WEFMOTJVdy9lZHZ4djB2cnR6TU9OdTBn?=
 =?utf-8?B?MUcrUkhJYkgxaVBSQ1BHTWdGZGdQZnAzbWZXQnZZSkp2S0pvSU5peVJtdHli?=
 =?utf-8?B?bk5XaStWSFpUSEx5MUF6a3BDd1AxT3gzMldDbnZPV24yZlMzQ0xXaElaY1ZE?=
 =?utf-8?B?OVJ5SEpEclJHcGxmKzNCY3lPSG1xZG1nMDNOSFllNkpQb25nVGdiVDF6ZVZL?=
 =?utf-8?B?citBOE5kbWdOMlM4bjVrcHRuSWlGTjdScEZ3L3ZvaEVDQzlHQmptTGN6RHZh?=
 =?utf-8?B?RXJQWEJVZEprdFc2ZjNlY3pTZ1J2UlVMT3duWC90STBrN2Y5ZExtVGNRUUtF?=
 =?utf-8?B?OENzVzM3MVFyTmRndE5JbEZNRlRTOFlKRFQwdkZ6SU9XdjFOS0hQYUpCdDlL?=
 =?utf-8?B?bzh6N0tOY1V0T29ndmNCOFpKR1dJSXdRRU9jWDBoT3Bwc2N0WGQvUjFWZUtB?=
 =?utf-8?B?K3VlVStnbXJpRlNwTmNzSHZBUm00VUxTekhtVG5zT0xmZ3JwWHFIOVRVUFE0?=
 =?utf-8?B?Y2JBWnNVMG5jVXJVd3dQR2dNcFRoWmFkVnp1VTZGb0tKVmM3S09nK09NczFK?=
 =?utf-8?B?YmtEaWN1aFBqNDJwUC9lbW1Ob2IwVzlJd3cxZWp3cFBLZS9OMGQ5RFRvbkRD?=
 =?utf-8?B?dDJjWWtqQjd5THdpTDR6Rm5oT0pIN2xHNTBROU1qclRrZWtDN0ZuSWQzV3p4?=
 =?utf-8?B?eGZkUGd0cDZ3T0VUYmJEWFRCN2JvZ3NnYUFWTWFzMG93cmtkVFM3K0RHMDBi?=
 =?utf-8?B?RWJaMWlKSlRVWjZJeER1Z0YvZVIrbmJzNTlqZzhKUGtVbElPckdEOXRENnM1?=
 =?utf-8?B?SkxtbFlQbTJ4ZUtlK1FaeFRzTUliZ0szUitmcmdlNzVNb1BocnJtM3N0Tk1a?=
 =?utf-8?B?YUFodkJ4c0FMZDJmR3VtUHM4WmZHa01zWTVEbGFQQkp0YnAzNFBMZEZKZFRL?=
 =?utf-8?B?TWVGSlpLRTZkcUloeG02emhlNmIxYVJHalFId3EyU2xvZHlNY2JqRm1NM3pj?=
 =?utf-8?B?Nk5sQWNlaDRyNlJQVmUwWTN2K2FCU2pzUGZzTTBMOHE2L2s5VXRacnVOUytI?=
 =?utf-8?B?TjJBZlcrMS9FNG5VR3RyYnFVbkF1OVM0REJiaXk0dm5uZUxwNUluS2x5Szd6?=
 =?utf-8?B?OFErQlNPcUI2VitIUC8rajBkaFBoTVVFMWdhNURGTlBNVkZMb1IwQzRPU3FK?=
 =?utf-8?B?UUxwbzZUcEFaT016TmdpeUJPK0pGaGtpOWxpbDMwY1gzM2FwY1FUd1U5K3M3?=
 =?utf-8?B?OFovMVJqRW5wbDNINmhPZjZ6dEhrdWFaM3MvOURFQmtjYmxzL0tsd3Z6Mnll?=
 =?utf-8?B?SHoycXkzM0JFNzBGWGJpR2ZuYlBCTXhiSGIvaEtOUnZMWmJMMTlFc0VoRDAx?=
 =?utf-8?B?b3BveUlnSlZ1WXA3SWl1MlZzUjN2bThsQ3VoT1EwRDZoMnc5MHJhaFFrZC9x?=
 =?utf-8?B?SVBia1VmekhCZ3Jra0dXSVlWODlSK2M0MHBMUEhheG11V0hNU2JQTTVUVDdi?=
 =?utf-8?B?OEFiV3d6Q0JYcjhYbEFNNGIyc0t4ZlQydUExVUNQT3pDUnBCV2pOVkxjVkRG?=
 =?utf-8?B?Rk1yUXVlMGFQd21VMHpvQTRpRHJwdjRpSXJtQlpSRy8wWmgvQUp5bk9SdW1q?=
 =?utf-8?B?RksxK0VHendwMlc5N0hKYjNWWWNzb1huN2prYUxwNTZUY0pua0V5d2U0UUV6?=
 =?utf-8?B?YlRJVzRDTk9vSWdSWFFIOUFZY3BDS3NKblQyc3NyWFNwVjNWajAxNVJ2dXhW?=
 =?utf-8?B?MmxueHQ0emRncHJzQWVPS1IxemNxbWkrZEsrWkJyWU1yc0xGTnFmbnEzVDlR?=
 =?utf-8?B?VXZRMHZtY2JBRlQrOHhtMzlWWUExdWFlOHFwUFRhTTB3UWFoOUh1SzhGbVlU?=
 =?utf-8?B?cy9Vb2U5QjM0R21yaVZzL0twQVNFSThkbnNGS1lCZjJaWW9mQjJGSWFXTVdM?=
 =?utf-8?Q?/K+PE25L0eBQrmTAV3T5q9wdE?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 935c1ee8-e69d-4e62-31e9-08dadf6427ac
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5825.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2022 12:50:48.2604
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2gTKIUfHlmmstWBr6nwjqiv4KvG2C8QFToM7B7FPtUF0T0b17BxDe1ve8d7jPIV6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4355
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 12/14/22 12:13, Jason Wang wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
>
>
> On Wed, Dec 7, 2022 at 10:56 PM Gautam Dawar <gautam.dawar@amd.com> wrote:
>> Implement functions to perform vDPA operations like creating and
>> removing virtqueues, getting doorbell register offset etc. using
>> the MCDI interface with FW.
>>
>> Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
>> ---
>>   drivers/net/ethernet/sfc/Kconfig      |   8 +
>>   drivers/net/ethernet/sfc/Makefile     |   1 +
>>   drivers/net/ethernet/sfc/ef100_vdpa.h |  32 +++
>>   drivers/net/ethernet/sfc/mcdi.h       |   4 +
>>   drivers/net/ethernet/sfc/mcdi_vdpa.c  | 268 ++++++++++++++++++++++++++
>>   drivers/net/ethernet/sfc/mcdi_vdpa.h  |  84 ++++++++
>>   6 files changed, 397 insertions(+)
>>   create mode 100644 drivers/net/ethernet/sfc/ef100_vdpa.h
>>   create mode 100644 drivers/net/ethernet/sfc/mcdi_vdpa.c
>>   create mode 100644 drivers/net/ethernet/sfc/mcdi_vdpa.h
>>
>> diff --git a/drivers/net/ethernet/sfc/Kconfig b/drivers/net/ethernet/sfc/Kconfig
>> index 0950e6b0508f..1fa626c87d36 100644
>> --- a/drivers/net/ethernet/sfc/Kconfig
>> +++ b/drivers/net/ethernet/sfc/Kconfig
>> @@ -63,6 +63,14 @@ config SFC_MCDI_LOGGING
>>            Driver-Interface) commands and responses, allowing debugging of
>>            driver/firmware interaction.  The tracing is actually enabled by
>>            a sysfs file 'mcdi_logging' under the PCI device.
>> +config SFC_VDPA
>> +       bool "Solarflare EF100-family VDPA support"
>> +       depends on SFC && VDPA && SFC_SRIOV
>> +       default y
>> +       help
>> +         This enables support for the virtio data path acceleration (vDPA).
>> +         vDPA device's datapath complies with the virtio specification,
>> +         but control path is vendor specific.
>>
>>   source "drivers/net/ethernet/sfc/falcon/Kconfig"
>>   source "drivers/net/ethernet/sfc/siena/Kconfig"
>> diff --git a/drivers/net/ethernet/sfc/Makefile b/drivers/net/ethernet/sfc/Makefile
>> index 712a48d00069..059a0944e89a 100644
>> --- a/drivers/net/ethernet/sfc/Makefile
>> +++ b/drivers/net/ethernet/sfc/Makefile
>> @@ -11,6 +11,7 @@ sfc-$(CONFIG_SFC_MTD) += mtd.o
>>   sfc-$(CONFIG_SFC_SRIOV)        += sriov.o ef10_sriov.o ef100_sriov.o ef100_rep.o \
>>                              mae.o tc.o tc_bindings.o tc_counters.o
>>
>> +sfc-$(CONFIG_SFC_VDPA) += mcdi_vdpa.o
>>   obj-$(CONFIG_SFC)      += sfc.o
>>
>>   obj-$(CONFIG_SFC_FALCON) += falcon/
>> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.h b/drivers/net/ethernet/sfc/ef100_vdpa.h
>> new file mode 100644
>> index 000000000000..f6564448d0c7
>> --- /dev/null
>> +++ b/drivers/net/ethernet/sfc/ef100_vdpa.h
>> @@ -0,0 +1,32 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/* Driver for Xilinx network controllers and boards
>> + * Copyright (C) 2020-2022, Xilinx, Inc.
>> + * Copyright (C) 2022, Advanced Micro Devices, Inc.
>> + *
>> + * This program is free software; you can redistribute it and/or modify it
>> + * under the terms of the GNU General Public License version 2 as published
>> + * by the Free Software Foundation, incorporated herein by reference.
>> + */
>> +
>> +#ifndef __EF100_VDPA_H__
>> +#define __EF100_VDPA_H__
>> +
>> +#include <linux/vdpa.h>
>> +#include <uapi/linux/virtio_net.h>
>> +#include "net_driver.h"
>> +#include "ef100_nic.h"
>> +
>> +#if defined(CONFIG_SFC_VDPA)
>> +
>> +enum ef100_vdpa_device_type {
>> +       EF100_VDPA_DEVICE_TYPE_NET,
>> +};
>> +
>> +enum ef100_vdpa_vq_type {
>> +       EF100_VDPA_VQ_TYPE_NET_RXQ,
>> +       EF100_VDPA_VQ_TYPE_NET_TXQ,
>> +       EF100_VDPA_VQ_NTYPES
>> +};
>> +
>> +#endif /* CONFIG_SFC_VDPA */
>> +#endif /* __EF100_VDPA_H__ */
>> diff --git a/drivers/net/ethernet/sfc/mcdi.h b/drivers/net/ethernet/sfc/mcdi.h
>> index 7e35fec9da35..db4ca4975ada 100644
>> --- a/drivers/net/ethernet/sfc/mcdi.h
>> +++ b/drivers/net/ethernet/sfc/mcdi.h
>> @@ -214,6 +214,10 @@ void efx_mcdi_sensor_event(struct efx_nic *efx, efx_qword_t *ev);
>>   #define _MCDI_STRUCT_DWORD(_buf, _field)                               \
>>          ((_buf) + (_MCDI_CHECK_ALIGN(_field ## _OFST, 4) >> 2))
>>
>> +#define MCDI_SET_BYTE(_buf, _field, _value) do {                       \
>> +       BUILD_BUG_ON(MC_CMD_ ## _field ## _LEN != 1);                   \
>> +       *(u8 *)MCDI_PTR(_buf, _field) = _value;                         \
>> +       } while (0)
>>   #define MCDI_STRUCT_SET_BYTE(_buf, _field, _value) do {                        \
>>          BUILD_BUG_ON(_field ## _LEN != 1);                              \
>>          *(u8 *)MCDI_STRUCT_PTR(_buf, _field) = _value;                  \
>> diff --git a/drivers/net/ethernet/sfc/mcdi_vdpa.c b/drivers/net/ethernet/sfc/mcdi_vdpa.c
>> new file mode 100644
>> index 000000000000..35f822170049
>> --- /dev/null
>> +++ b/drivers/net/ethernet/sfc/mcdi_vdpa.c
>> @@ -0,0 +1,268 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/* Driver for Xilinx network controllers and boards
>> + * Copyright (C) 2020-2022, Xilinx, Inc.
>> + * Copyright (C) 2022, Advanced Micro Devices, Inc.
>> + *
>> + * This program is free software; you can redistribute it and/or modify it
>> + * under the terms of the GNU General Public License version 2 as published
>> + * by the Free Software Foundation, incorporated herein by reference.
>> + */
>> +
>> +#include <linux/vdpa.h>
>> +#include "ef100_vdpa.h"
>> +#include "efx.h"
>> +#include "nic.h"
>> +#include "mcdi_vdpa.h"
>> +#include "mcdi_pcol.h"
>> +
>> +/* The value of target_vf in virtio MC commands like
>> + * virtqueue create, delete and get doorbell offset should
>> + * contain the VF index when the calling function is a PF
>> + * and VF_NULL (0xFFFF) otherwise. As the vDPA driver invokes
>> + * MC commands in context of the VF, it uses VF_NULL.
>> + */
>> +#define MC_CMD_VIRTIO_TARGET_VF_NULL 0xFFFF
>> +
>> +struct efx_vring_ctx *efx_vdpa_vring_init(struct efx_nic *efx,  u32 vi,
>> +                                         enum ef100_vdpa_vq_type vring_type)
>> +{
>> +       struct efx_vring_ctx *vring_ctx;
>> +       u32 queue_cmd;
>> +
>> +       vring_ctx = kzalloc(sizeof(*vring_ctx), GFP_KERNEL);
>> +       if (!vring_ctx)
>> +               return ERR_PTR(-ENOMEM);
>> +
>> +       switch (vring_type) {
>> +       case EF100_VDPA_VQ_TYPE_NET_RXQ:
>> +               queue_cmd = MC_CMD_VIRTIO_INIT_QUEUE_REQ_NET_RXQ;
>> +               break;
>> +       case EF100_VDPA_VQ_TYPE_NET_TXQ:
>> +               queue_cmd = MC_CMD_VIRTIO_INIT_QUEUE_REQ_NET_TXQ;
>> +               break;
>> +       default:
>> +               pci_err(efx->pci_dev,
>> +                       "%s: Invalid Queue type %u\n", __func__, vring_type);
>> +               kfree(vring_ctx);
>> +               return ERR_PTR(-ENOMEM);
>> +       }
>> +
>> +       vring_ctx->efx = efx;
>> +       vring_ctx->vf_index = MC_CMD_VIRTIO_TARGET_VF_NULL;
>> +       vring_ctx->vi_index = vi;
>> +       vring_ctx->mcdi_vring_type = queue_cmd;
>> +       return vring_ctx;
>> +}
>> +
>> +void efx_vdpa_vring_fini(struct efx_vring_ctx *vring_ctx)
>> +{
>> +       kfree(vring_ctx);
>> +}
>> +
>> +int efx_vdpa_get_features(struct efx_nic *efx,
>> +                         enum ef100_vdpa_device_type type,
>> +                         u64 *features)
>> +{
>> +       MCDI_DECLARE_BUF(outbuf, MC_CMD_VIRTIO_GET_FEATURES_OUT_LEN);
>> +       MCDI_DECLARE_BUF(inbuf, MC_CMD_VIRTIO_GET_FEATURES_IN_LEN);
>> +       u32 high_val, low_val;
>> +       ssize_t outlen;
>> +       u32 dev_type;
>> +       int rc;
>> +
>> +       if (!efx) {
>> +               pci_err(efx->pci_dev, "%s: Invalid NIC pointer\n", __func__);
>> +               return -EINVAL;
>> +       }
>> +       switch (type) {
>> +       case EF100_VDPA_DEVICE_TYPE_NET:
>> +               dev_type = MC_CMD_VIRTIO_GET_FEATURES_IN_NET;
>> +               break;
>> +       default:
>> +               pci_err(efx->pci_dev,
>> +                       "%s: Device type %d not supported\n", __func__, type);
>> +               return -EINVAL;
>> +       }
>> +       MCDI_SET_DWORD(inbuf, VIRTIO_GET_FEATURES_IN_DEVICE_ID, dev_type);
>> +       rc = efx_mcdi_rpc(efx, MC_CMD_VIRTIO_GET_FEATURES, inbuf, sizeof(inbuf),
>> +                         outbuf, sizeof(outbuf), &outlen);
>> +       if (rc)
>> +               return rc;
>> +       if (outlen < MC_CMD_VIRTIO_GET_FEATURES_OUT_LEN)
>> +               return -EIO;
>> +       low_val = MCDI_DWORD(outbuf, VIRTIO_GET_FEATURES_OUT_FEATURES_LO);
>> +       high_val = MCDI_DWORD(outbuf, VIRTIO_GET_FEATURES_OUT_FEATURES_HI);
>> +       *features = ((u64)high_val << 32) | low_val;
>> +       return 0;
>> +}
>> +
>> +int efx_vdpa_verify_features(struct efx_nic *efx,
>> +                            enum ef100_vdpa_device_type type, u64 features)
>> +{
>> +       MCDI_DECLARE_BUF(inbuf, MC_CMD_VIRTIO_TEST_FEATURES_IN_LEN);
>> +       u32 dev_type;
>> +       int rc;
>> +
>> +       BUILD_BUG_ON(MC_CMD_VIRTIO_TEST_FEATURES_OUT_LEN != 0);
>> +       switch (type) {
>> +       case EF100_VDPA_DEVICE_TYPE_NET:
>> +               dev_type = MC_CMD_VIRTIO_GET_FEATURES_IN_NET;
>> +               break;
>> +       default:
>> +               pci_err(efx->pci_dev,
>> +                       "%s: Device type %d not supported\n", __func__, type);
>> +               return -EINVAL;
>> +       }
>> +       MCDI_SET_DWORD(inbuf, VIRTIO_TEST_FEATURES_IN_DEVICE_ID, dev_type);
>> +       MCDI_SET_DWORD(inbuf, VIRTIO_TEST_FEATURES_IN_FEATURES_LO, features);
>> +       MCDI_SET_DWORD(inbuf, VIRTIO_TEST_FEATURES_IN_FEATURES_HI,
>> +                      features >> 32);
>> +       rc = efx_mcdi_rpc(efx, MC_CMD_VIRTIO_TEST_FEATURES, inbuf,
>> +                         sizeof(inbuf), NULL, 0, NULL);
>> +       return rc;
>> +}
>> +
>> +int efx_vdpa_vring_create(struct efx_vring_ctx *vring_ctx,
>> +                         struct efx_vring_cfg *vring_cfg,
>> +                         struct efx_vring_dyn_cfg *vring_dyn_cfg)
>> +{
>> +       MCDI_DECLARE_BUF(inbuf, MC_CMD_VIRTIO_INIT_QUEUE_REQ_LEN);
>> +       struct efx_nic *efx = vring_ctx->efx;
>> +       int rc;
>> +
>> +       BUILD_BUG_ON(MC_CMD_VIRTIO_INIT_QUEUE_RESP_LEN != 0);
>> +
>> +       MCDI_SET_BYTE(inbuf, VIRTIO_INIT_QUEUE_REQ_QUEUE_TYPE,
>> +                     vring_ctx->mcdi_vring_type);
>> +       MCDI_SET_WORD(inbuf, VIRTIO_INIT_QUEUE_REQ_TARGET_VF,
>> +                     vring_ctx->vf_index);
>> +       MCDI_SET_DWORD(inbuf, VIRTIO_INIT_QUEUE_REQ_INSTANCE,
>> +                      vring_ctx->vi_index);
>> +
>> +       MCDI_SET_DWORD(inbuf, VIRTIO_INIT_QUEUE_REQ_SIZE, vring_cfg->size);
>> +       MCDI_SET_DWORD(inbuf, VIRTIO_INIT_QUEUE_REQ_DESC_TBL_ADDR_LO,
>> +                      vring_cfg->desc);
>> +       MCDI_SET_DWORD(inbuf, VIRTIO_INIT_QUEUE_REQ_DESC_TBL_ADDR_HI,
>> +                      vring_cfg->desc >> 32);
>> +       MCDI_SET_DWORD(inbuf, VIRTIO_INIT_QUEUE_REQ_AVAIL_RING_ADDR_LO,
>> +                      vring_cfg->avail);
>> +       MCDI_SET_DWORD(inbuf, VIRTIO_INIT_QUEUE_REQ_AVAIL_RING_ADDR_HI,
>> +                      vring_cfg->avail >> 32);
>> +       MCDI_SET_DWORD(inbuf, VIRTIO_INIT_QUEUE_REQ_USED_RING_ADDR_LO,
>> +                      vring_cfg->used);
>> +       MCDI_SET_DWORD(inbuf, VIRTIO_INIT_QUEUE_REQ_USED_RING_ADDR_HI,
>> +                      vring_cfg->used >> 32);
>> +       MCDI_SET_WORD(inbuf, VIRTIO_INIT_QUEUE_REQ_MSIX_VECTOR,
>> +                     vring_cfg->msix_vector);
>> +       MCDI_SET_DWORD(inbuf, VIRTIO_INIT_QUEUE_REQ_FEATURES_LO,
>> +                      vring_cfg->features);
>> +       MCDI_SET_DWORD(inbuf, VIRTIO_INIT_QUEUE_REQ_FEATURES_HI,
>> +                      vring_cfg->features >> 32);
>> +
>> +       if (vring_dyn_cfg) {
>> +               MCDI_SET_DWORD(inbuf, VIRTIO_INIT_QUEUE_REQ_INITIAL_PIDX,
>> +                              vring_dyn_cfg->avail_idx);
>> +               MCDI_SET_DWORD(inbuf, VIRTIO_INIT_QUEUE_REQ_INITIAL_CIDX,
>> +                              vring_dyn_cfg->used_idx);
>> +       }
>> +       MCDI_SET_DWORD(inbuf, VIRTIO_INIT_QUEUE_REQ_MPORT_SELECTOR,
>> +                      MAE_MPORT_SELECTOR_ASSIGNED);
>> +
>> +       rc = efx_mcdi_rpc(efx, MC_CMD_VIRTIO_INIT_QUEUE, inbuf, sizeof(inbuf),
>> +                         NULL, 0, NULL);
> It looks to me the mcdi_buffer belongs to the VF (allocated by the
> calling of ef100_probe_vf()), I wonder how it is isolated from the DMA
> that is initiated by userspace(guest)?
>
> Thanks
Yes, I just responded to this concern on a similar comment in patch 9/11.
>
>
>> +       return rc;
>> +}
>> +
>> +int efx_vdpa_vring_destroy(struct efx_vring_ctx *vring_ctx,
>> +                          struct efx_vring_dyn_cfg *vring_dyn_cfg)
>> +{
>> +       MCDI_DECLARE_BUF(outbuf, MC_CMD_VIRTIO_FINI_QUEUE_RESP_LEN);
>> +       MCDI_DECLARE_BUF(inbuf, MC_CMD_VIRTIO_FINI_QUEUE_REQ_LEN);
>> +       struct efx_nic *efx = vring_ctx->efx;
>> +       ssize_t outlen;
>> +       int rc;
>> +
>> +       MCDI_SET_BYTE(inbuf, VIRTIO_FINI_QUEUE_REQ_QUEUE_TYPE,
>> +                     vring_ctx->mcdi_vring_type);
>> +       MCDI_SET_WORD(inbuf, VIRTIO_INIT_QUEUE_REQ_TARGET_VF,
>> +                     vring_ctx->vf_index);
>> +       MCDI_SET_DWORD(inbuf, VIRTIO_INIT_QUEUE_REQ_INSTANCE,
>> +                      vring_ctx->vi_index);
>> +       rc = efx_mcdi_rpc(efx, MC_CMD_VIRTIO_FINI_QUEUE, inbuf, sizeof(inbuf),
>> +                         outbuf, sizeof(outbuf), &outlen);
>> +
>> +       if (rc)
>> +               return rc;
>> +
>> +       if (outlen < MC_CMD_VIRTIO_FINI_QUEUE_RESP_LEN)
>> +               return -EIO;
>> +
>> +       if (vring_dyn_cfg) {
>> +               vring_dyn_cfg->avail_idx = MCDI_DWORD(outbuf,
>> +                                                     VIRTIO_FINI_QUEUE_RESP_FINAL_PIDX);
>> +               vring_dyn_cfg->used_idx = MCDI_DWORD(outbuf,
>> +                                                    VIRTIO_FINI_QUEUE_RESP_FINAL_CIDX);
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +int efx_vdpa_get_doorbell_offset(struct efx_vring_ctx *vring_ctx,
>> +                                u32 *offset)
>> +{
>> +       MCDI_DECLARE_BUF(outbuf, MC_CMD_VIRTIO_GET_NET_DOORBELL_OFFSET_RESP_LEN);
>> +       MCDI_DECLARE_BUF(inbuf, MC_CMD_VIRTIO_GET_DOORBELL_OFFSET_REQ_LEN);
>> +       struct efx_nic *efx = vring_ctx->efx;
>> +       ssize_t outlen;
>> +       int rc;
>> +
>> +       if (vring_ctx->mcdi_vring_type != MC_CMD_VIRTIO_INIT_QUEUE_REQ_NET_RXQ &&
>> +           vring_ctx->mcdi_vring_type != MC_CMD_VIRTIO_INIT_QUEUE_REQ_NET_TXQ) {
>> +               pci_err(efx->pci_dev,
>> +                       "%s: Invalid Queue type %u\n",
>> +                       __func__, vring_ctx->mcdi_vring_type);
>> +               return -EINVAL;
>> +       }
>> +
>> +       MCDI_SET_BYTE(inbuf, VIRTIO_GET_DOORBELL_OFFSET_REQ_DEVICE_ID,
>> +                     MC_CMD_VIRTIO_GET_FEATURES_IN_NET);
>> +       MCDI_SET_WORD(inbuf, VIRTIO_GET_DOORBELL_OFFSET_REQ_TARGET_VF,
>> +                     vring_ctx->vf_index);
>> +       MCDI_SET_DWORD(inbuf, VIRTIO_GET_DOORBELL_OFFSET_REQ_INSTANCE,
>> +                      vring_ctx->vi_index);
>> +
>> +       rc = efx_mcdi_rpc(efx, MC_CMD_VIRTIO_GET_DOORBELL_OFFSET, inbuf,
>> +                         sizeof(inbuf), outbuf, sizeof(outbuf), &outlen);
>> +       if (rc)
>> +               return rc;
>> +
>> +       if (outlen < MC_CMD_VIRTIO_GET_NET_DOORBELL_OFFSET_RESP_LEN)
>> +               return -EIO;
>> +       if (vring_ctx->mcdi_vring_type == MC_CMD_VIRTIO_INIT_QUEUE_REQ_NET_RXQ)
>> +               *offset = MCDI_DWORD(outbuf,
>> +                                    VIRTIO_GET_NET_DOORBELL_OFFSET_RESP_RX_DBL_OFFSET);
>> +       else
>> +               *offset = MCDI_DWORD(outbuf,
>> +                                    VIRTIO_GET_NET_DOORBELL_OFFSET_RESP_TX_DBL_OFFSET);
>> +
>> +       return 0;
>> +}
>> +
>> +int efx_vdpa_get_mtu(struct efx_nic *efx, u16 *mtu)
>> +{
>> +       MCDI_DECLARE_BUF(outbuf, MC_CMD_SET_MAC_V2_OUT_LEN);
>> +       MCDI_DECLARE_BUF(inbuf, MC_CMD_SET_MAC_EXT_IN_LEN);
>> +       ssize_t outlen;
>> +       int rc;
>> +
>> +       MCDI_SET_DWORD(inbuf, SET_MAC_EXT_IN_CONTROL, 0);
>> +       rc =  efx_mcdi_rpc(efx, MC_CMD_SET_MAC, inbuf, sizeof(inbuf),
>> +                          outbuf, sizeof(outbuf), &outlen);
>> +       if (rc)
>> +               return rc;
>> +       if (outlen < MC_CMD_SET_MAC_V2_OUT_LEN)
>> +               return -EIO;
>> +
>> +       *mtu = MCDI_DWORD(outbuf, SET_MAC_V2_OUT_MTU);
>> +       return 0;
>> +}
>> diff --git a/drivers/net/ethernet/sfc/mcdi_vdpa.h b/drivers/net/ethernet/sfc/mcdi_vdpa.h
>> new file mode 100644
>> index 000000000000..2a0f7c647c44
>> --- /dev/null
>> +++ b/drivers/net/ethernet/sfc/mcdi_vdpa.h
>> @@ -0,0 +1,84 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/* Driver for Xilinx network controllers and boards
>> + * Copyright (C) 2020-2022, Xilinx, Inc.
>> + * Copyright (C) 2022, Advanced Micro Devices, Inc.
>> + *
>> + * This program is free software; you can redistribute it and/or modify it
>> + * under the terms of the GNU General Public License version 2 as published
>> + * by the Free Software Foundation, incorporated herein by reference.
>> + */
>> +
>> +#ifndef EFX_MCDI_VDPA_H
>> +#define EFX_MCDI_VDPA_H
>> +
>> +#if defined(CONFIG_SFC_VDPA)
>> +#include "mcdi.h"
>> +
>> +/**
>> + * struct efx_vring_ctx: The vring context
>> + *
>> + * @efx: pointer of the VF's efx_nic object
>> + * @vf_index: VF index of the vDPA VF
>> + * @vi_index: vi index to be used for queue creation
>> + * @mcdi_vring_type: corresponding MCDI vring type
>> + */
>> +struct efx_vring_ctx {
>> +       struct efx_nic *efx;
>> +       u32 vf_index;
>> +       u32 vi_index;
>> +       u32 mcdi_vring_type;
>> +};
>> +
>> +/**
>> + * struct efx_vring_cfg: Configuration for vring creation
>> + *
>> + * @desc: Descriptor area address of the vring
>> + * @avail: Available area address of the vring
>> + * @used: Device area address of the vring
>> + * @size: Queue size, in entries. Must be a power of two
>> + * @msix_vector: msix vector address for the queue
>> + * @features: negotiated feature bits
>> + */
>> +struct efx_vring_cfg {
>> +       u64 desc;
>> +       u64 avail;
>> +       u64 used;
>> +       u32 size;
>> +       u16 msix_vector;
>> +       u64 features;
>> +};
>> +
>> +/**
>> + * struct efx_vring_dyn_cfg - dynamic vring configuration
>> + *
>> + * @avail_idx: last available index of the vring
>> + * @used_idx: last used index of the vring
>> + */
>> +struct efx_vring_dyn_cfg {
>> +       u32 avail_idx;
>> +       u32 used_idx;
>> +};
>> +
>> +int efx_vdpa_get_features(struct efx_nic *efx, enum ef100_vdpa_device_type type,
>> +                         u64 *featuresp);
>> +
>> +int efx_vdpa_verify_features(struct efx_nic *efx,
>> +                            enum ef100_vdpa_device_type type, u64 features);
>> +
>> +struct efx_vring_ctx *efx_vdpa_vring_init(struct efx_nic *efx, u32 vi,
>> +                                         enum ef100_vdpa_vq_type vring_type);
>> +
>> +void efx_vdpa_vring_fini(struct efx_vring_ctx *vring_ctx);
>> +
>> +int efx_vdpa_vring_create(struct efx_vring_ctx *vring_ctx,
>> +                         struct efx_vring_cfg *vring_cfg,
>> +                         struct efx_vring_dyn_cfg *vring_dyn_cfg);
>> +
>> +int efx_vdpa_vring_destroy(struct efx_vring_ctx *vring_ctx,
>> +                          struct efx_vring_dyn_cfg *vring_dyn_cfg);
>> +
>> +int efx_vdpa_get_doorbell_offset(struct efx_vring_ctx *vring_ctx,
>> +                                u32 *offsetp);
>> +int efx_vdpa_get_mtu(struct efx_nic *efx, u16 *mtu);
>> +#endif
>> +#endif
>> --
>> 2.30.1
>>
