Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04E1A32B3C0
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:22:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1574910AbhCCEFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:05:49 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:49546 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1835470AbhCBTJl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 14:09:41 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 122I7L4O013595;
        Tue, 2 Mar 2021 10:14:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=to : from : subject :
 message-id : date : content-type : content-transfer-encoding :
 mime-version; s=facebook; bh=xpJEhpQ2GWsXxXgysxj3qZ6P5jHEhmmxrmxPwP2CFhw=;
 b=EkfDvvTtJIrAKSHobOLUeUHOb4dM6fgLXoJ6Qlfe4f8q4kcbhDxZFP29HSIM7XcKwlC8
 1BTluU9QlsHFJgTlUBcyDKLyR2MG+zv2Ox3aqLvk/hpA83CI4I6QtqMqqegV8xkUAEwF
 QL4+aKOKkunVqqDuUtJN8G788zjSTwR8udg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 36yjmug22q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 02 Mar 2021 10:14:51 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 2 Mar 2021 10:14:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SOdQU3bS4CYWjYtPmqNB3wx6iZEym6vW3nZNGKJ7cp1/Fgw6jMv08eC5MR9Nfq3UwQMDFS3VNGeIae9y5OccYHP85gDDAo7YDzu7zSwpwpNXm5wFy+jgkzI4+5ucKP5b9W43Q+XFevjmrc3y9FMr/LKlqnKqJBfTLJKkfkro9BcJZfa3Soa7HonEkJ3u3k0wPmEnPHiXkmISO0wvxBJKmPPGK/BiWttnscSfxozs6k4spJ9SGlvVkBQulHGNDAn2dz0fMpv4Sk7HDRB6Ug6lPVEbToLatMmCvII1RUcYagXuSXXWD2niEd4GsGBbzvMDVt3xA/3zg+JpB+ShWvYUqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xpJEhpQ2GWsXxXgysxj3qZ6P5jHEhmmxrmxPwP2CFhw=;
 b=VyLCDrJ/IYfqeec1i501DZvJgQuFhDCJUM7Rb36PK3v7W3l/Nj87lDBmyb5Vxzcbqd2xgdIHglymwhGfUwld3dFGUOD+Ip5URvWpg1TWzg5UkTNWgpPMun9a2Xq4JP/jFuG15W3oFdxnSYhRRPPUcz/y12KHo5NeS9kytSkWuNvqkvBIqeuajoll8qSM0acElx8AUqpry4p7R+YTUiCGRCG7sVQCGouc1ZX2EDlbgzRjlUkBiYMP+ZBE9SU6AdcBc1D+Se8O7f+yvWx2o82f+vRKkO21hmZI20PLiXgUVOTx3IZMpH82S56kTzoTCQx1nBgKsxucq+MOk4htm0j1rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB2566.namprd15.prod.outlook.com (2603:10b6:a03:150::24)
 by SJ0PR15MB4487.namprd15.prod.outlook.com (2603:10b6:a03:374::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Tue, 2 Mar
 2021 18:14:50 +0000
Received: from BYAPR15MB2566.namprd15.prod.outlook.com
 ([fe80::2d24:5f51:7230:9a5d]) by BYAPR15MB2566.namprd15.prod.outlook.com
 ([fe80::2d24:5f51:7230:9a5d%7]) with mapi id 15.20.3890.028; Tue, 2 Mar 2021
 18:14:49 +0000
To:     <netdev@vger.kernel.org>, Luca Coelho <luciano.coelho@intel.com>
From:   Jens Axboe <axboe@fb.com>
Subject: [PATCH] iwlwifi: ensure that DMI scan table is properly terminated
Message-ID: <8bf2440e-efb1-9974-31b9-97359ec820d6@fb.com>
Date:   Tue, 2 Mar 2021 11:14:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [65.144.74.34]
X-ClientProxiedBy: CH0PR03CA0036.namprd03.prod.outlook.com
 (2603:10b6:610:b3::11) To BYAPR15MB2566.namprd15.prod.outlook.com
 (2603:10b6:a03:150::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.30] (65.144.74.34) by CH0PR03CA0036.namprd03.prod.outlook.com (2603:10b6:610:b3::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20 via Frontend Transport; Tue, 2 Mar 2021 18:14:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1ba33c04-cf53-4028-4be1-08d8dda7111a
X-MS-TrafficTypeDiagnostic: SJ0PR15MB4487:
X-Microsoft-Antispam-PRVS: <SJ0PR15MB4487FA4ABA2D146450DC5270C0999@SJ0PR15MB4487.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gtHLSmo0FikUEsUbBN7U0kEty/g+4dGttF7npZm87ZyC0HC6qfz003FBlV/D6/2AN6338fIjWIkjC84673YRdi5mMfokKnUUr43yFTKgpXKn/g8TzdFz7Pw4WvpkaljlFWFHD0i7ZmGAdphmL/fpZsNzBUrMfoUo82v1F0cVJv1y1tb1mhTAOfYdcjdh1PMqsSIXwjEmPZNjLyMJvaSZuajCP3SMDbWkx1j13Nijhpct073aLrqU+kZhUdtUnTDMWorE0hi3X4tS77i+usoK7mn8ouU/gPBtLcAZ55fKxBH8fFye/3+GAEc+cv1rN06v9Mt/lV3Oi2VhUa9KQF8JXyyWJQob43p8wbnN68jTRNSJi3mL8gOsq+iN4yhK1nAOTphA0zL6u28Qbzm1J2Pch2wIeu8sYE13m8tGf7d+As1FFIxj4X85aw5PRF5ECWVHiVa7KLhARsW4aZ9DCfNECvA1pWwCwpbNfA/3lbneppL89InLXQZdDgM9Y3yvmg8+ZuhLqkHUUKgau2qsmlJMMQV95YGNsiPAzxkdp4WfD2w6eFpP2s0Up+ltV1dev9Jpw/PZKc2oPxUK/8Q4ELnh3dkGPflkhSMIh/2Agnf9Zrp2xRL9SVJ9CKxdIT5NWiDv6okDMWplAhA41lGikwJaDA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2566.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(346002)(376002)(366004)(136003)(16576012)(316002)(5660300002)(2906002)(956004)(2616005)(6916009)(36756003)(186003)(31696002)(83380400001)(66476007)(6486002)(52116002)(26005)(66556008)(86362001)(31686004)(8676002)(8936002)(66946007)(478600001)(16526019)(45980500001)(43740500002)(505234006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TWFrV044Wm1TWUIydzh0RlM1YWJpYnQvMEQ2V2R6ZHN4ZUx3R3NFcmY2anRZ?=
 =?utf-8?B?cHhldE1lUHQ0QmpOeGtRcjMreWIrdDRDSXNwN25HWWhqOUM5eVJtdkZuRVRY?=
 =?utf-8?B?U0JPV1NVNU11VkVrc0o1ZDkrWmRUSGJaU1Bsb3c5KytOVWE2MUZRVHJ5NnFR?=
 =?utf-8?B?NW5vRHhWbWNiVFJxdHJyeXBOaHZhSTBnaEQrTm1NRjZlZTAxMHplTkpndEsy?=
 =?utf-8?B?WUZHbTBxMVNCRDR3S0JpRzZBNUg0M1B6ZGNmNDdRQmVrMTJiNndTdlZEOFhH?=
 =?utf-8?B?ZkI1bjlzK1Q0MDdENDB6enZUN2JOSTdoWkZJNGNTbmNzK3F1OE5JSEw4TFph?=
 =?utf-8?B?OWt1bTdLNVNHUlY4V3VFZHpPalBoWmNkRzVyN1FYekhmV0N0QVBoTlJ4aHZP?=
 =?utf-8?B?cE1sdzh5V1FWdFBLT3NOMHN1Ty8zVWM0NWdoK2JGZkwrTG5ORHpOdnR1aVRo?=
 =?utf-8?B?U3VPaE9KTnJ1YVNMMnh2aEJHK2diektCRHJyY01xcm5Ja0ppMXpJOXhvRFZn?=
 =?utf-8?B?MlQ3cG5xcWVBYWszTDdabXdISCsrYWtxV1VrbEZ1cEY0dG5FaUZvdUMxd1dI?=
 =?utf-8?B?RFVCWGt0OUNkR2lXYkJNTllpTG0ybXJoOEJMMU8xck0xNkFsWWNIaHR4WmR6?=
 =?utf-8?B?VmkvVENHUys3aG16RGdHOU9WUVFwVSt5K3VncUpSVTBvQllEbHpwcjA1TzFV?=
 =?utf-8?B?VlFjVmU4bE5TVHBXR3JQYjVNVlhDRUpWN2dreW05QUZESHArYkh4M2tVWjRM?=
 =?utf-8?B?cWo5ZElqTFNLMTBIZXU5UEdiT1Zhc280RlAzZ09BY1ZPWmxzdWRYeG5QOUlr?=
 =?utf-8?B?Zk0xbngzZHkrV09WUER4aTduZDJkci9WdklRdlJRSXRSRnh1Q1JHZFlrVDkz?=
 =?utf-8?B?QThBQzIweEQ5ODBHVFRlUmNLTkNCQjVkUWFYSFh2b1BrRndYcUpUV2x5VEtx?=
 =?utf-8?B?OEg2Z3JwUVdRektpMmdvdks3eFliQVYrWElndmpnSnFQQ0dCZ0V1dno2a1dH?=
 =?utf-8?B?b0JhQ3RtQXMwaHVWWUI1Si91dGJKUXRwSWxsSFJ2YjFqcE9wcFF0YzRPSjFt?=
 =?utf-8?B?RzRuREVCWjdIUURDMHp4cG5aZ0Jicy9PK2NrOGFmRUE0YTRJT3BNYWJwM2hM?=
 =?utf-8?B?ZCszWm9KYVVxNEpwdXl3SkhpUVh5MGs3WGhYUnJ2N2haZ3JyOHdZYlZ4UURE?=
 =?utf-8?B?OUFZRWcxWFVzU3BCU3lmYk1mWFVBa2kwUTI5dlY4NGdyR0p2MGo3NEVVZHlx?=
 =?utf-8?B?OWNacmcxUUpYcHRxTEV1blVoWmhueVVaUk9IODhSL0dVelByM016YXdWbWlk?=
 =?utf-8?B?VmF0d1BiOGpHUnVIVXp2eUplaU9uMjFTbmorSE5KSGhCOTJFdE80K0lKNkZv?=
 =?utf-8?B?OGRzSmdwNlpJNjhvSjJUMkFub296cjJLMVR2S0d1U0hKN1hCL0gxb2EwTmt2?=
 =?utf-8?B?NGRaRVUxemxVTCttRSsxZTQ5TUhyaTEyMk5BZmV1bWRxYzZlZmRwbGJzNWly?=
 =?utf-8?B?amE4NCs4M0ZUUzd0SWFkZzNuTUZ2TmVoT0NkV29ObGdtR0JaQjBUZkErRGJ0?=
 =?utf-8?B?YTZnMDJkQ2dJNXBXNkd0Q1ljZGFhWmpQaXo0Z2xiMmtPc3VsWnJLNXFocG1j?=
 =?utf-8?B?cUVyVzNOdC9NK0lMclZzYjdtZmhoOHhHbjFaTXZQcjFhSUZQdHVLTDlWUDUy?=
 =?utf-8?B?VGJBK2tLMitHVTZ4ajN2OWNlZkhPbFJYdy9kNS9JaHQyVlFNdk1aRDBDZUNp?=
 =?utf-8?Q?4oq32tL87QxTHWe00AfTo0GfbRYW7+CcnJbWIVb?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ba33c04-cf53-4028-4be1-08d8dda7111a
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2566.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2021 18:14:49.8422
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gMhwh5SEp8/vB7eZErgFXDfM8Psx45iBL0YgBnwp523I9ZDloczxr1FGh4A+vbxN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4487
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-02_08:2021-03-01,2021-03-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 bulkscore=0
 lowpriorityscore=0 priorityscore=1501 clxscore=1011 spamscore=0
 impostorscore=0 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103020141
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

My laptop crashes at boot, and I ran the same kernel with KASAN enabled.
Turns out the DMI addition for iwlwifi is broken (and untested?), since
it doesn't properly terminate the scan table. Ensure that we do so.

==================================================================
BUG: KASAN: global-out-of-bounds in dmi_check_system+0x5a/0x70
Read of size 1 at addr ffffffffc16af750 by task NetworkManager/1913

CPU: 4 PID: 1913 Comm: NetworkManager Not tainted 5.12.0-rc1+ #10057
Hardware name: LENOVO 20THCTO1WW/20THCTO1WW, BIOS N2VET27W (1.12 ) 12/21/2020
Call Trace:
 dump_stack+0x90/0xbe
 print_address_description.constprop.0+0x1d/0x140
 ? dmi_check_system+0x5a/0x70
 ? dmi_check_system+0x5a/0x70
 kasan_report.cold+0x7b/0xd4
 ? dmi_check_system+0x5a/0x70
 __asan_load1+0x4d/0x50
 dmi_check_system+0x5a/0x70
 iwl_mvm_up+0x1360/0x1690 [iwlmvm]
 ? iwl_mvm_send_recovery_cmd+0x270/0x270 [iwlmvm]
 ? setup_object.isra.0+0x27/0xd0
 ? kasan_poison+0x20/0x50
 ? ___slab_alloc.constprop.0+0x483/0x5b0
 ? mempool_kmalloc+0x17/0x20
 ? ftrace_graph_ret_addr+0x2a/0xb0
 ? kasan_poison+0x3c/0x50
 ? cfg80211_iftype_allowed+0x2e/0x90 [cfg80211]
 ? __kasan_check_write+0x14/0x20
 ? mutex_lock+0x86/0xe0
 ? __mutex_lock_slowpath+0x20/0x20
 __iwl_mvm_mac_start+0x49/0x290 [iwlmvm]
 iwl_mvm_mac_start+0x37/0x50 [iwlmvm]
 drv_start+0x73/0x1b0 [mac80211]
 ieee80211_do_open+0x53e/0xf10 [mac80211]
 ? ieee80211_check_concurrent_iface+0x266/0x2e0 [mac80211]
 ieee80211_open+0xb9/0x100 [mac80211]
 __dev_open+0x1b8/0x280
 ? dev_set_rx_mode+0x40/0x40
 __dev_change_flags+0x32f/0x3a0
 ? dev_set_allmulti+0x20/0x20
 ? is_bpf_text_address+0x24/0x30
 ? kernel_text_address+0xbb/0xd0
 dev_change_flags+0x63/0xc0
 do_setlink+0xb59/0x18c0
 ? rtnetlink_put_metrics+0x2e0/0x2e0
 ? stack_trace_consume_entry+0x90/0x90
 ? if6_seq_show+0xb0/0xb0
 ? kasan_save_stack+0x42/0x50
 ? kasan_save_stack+0x23/0x50
 ? kasan_set_track+0x20/0x30
 ? kasan_set_free_info+0x24/0x40
 ? __kasan_slab_free+0xea/0x120
 ? kfree+0x94/0x250
 ? memset+0x3c/0x50
 ? __nla_validate_parse+0xc1/0x12d0
 ? ____sys_sendmsg+0x430/0x450
 ? ___sys_sendmsg+0xf2/0x160
 ? __sys_sendmsg+0xc8/0x150
 ? __x64_sys_sendmsg+0x48/0x50
 ? do_syscall_64+0x32/0x80
 ? entry_SYSCALL_64_after_hwframe+0x44/0xae
 ? nla_get_range_signed+0x1c0/0x1c0
 ? nla_put_ifalias+0x86/0xf0
 ? __cgroup_bpf_run_filter_skb+0xc1/0x6f0
 ? memcpy+0x4e/0x60
 ? __kasan_check_read+0x11/0x20
 __rtnl_newlink+0x905/0xde0
 ? ipv6_dev_get_saddr+0x4c0/0x4c0
 ? rtnl_setlink+0x250/0x250
 ? ftrace_graph_ret_addr+0x2a/0xb0
 ? entry_SYSCALL_64_after_hwframe+0x44/0xae
 ? bpf_ksym_find+0x94/0xe0
 ? __rcu_read_unlock+0x39/0x60
 ? is_bpf_text_address+0x24/0x30
 ? kernel_text_address+0xbb/0xd0
 ? __kernel_text_address+0x12/0x40
 ? unwind_get_return_address+0x36/0x50
 ? create_prof_cpu_mask+0x30/0x30
 ? arch_stack_walk+0x98/0xf0
 ? stack_trace_save+0x94/0xc0
 ? stack_trace_consume_entry+0x90/0x90
 ? arch_stack_walk+0x98/0xf0
 ? __kasan_kmalloc+0x81/0xa0
 ? kmem_cache_alloc_trace+0xf4/0x220
 rtnl_newlink+0x55/0x80
 rtnetlink_rcv_msg+0x22f/0x560
 ? __kasan_slab_alloc+0x5f/0x80
 ? rtnl_calcit.isra.0+0x1e0/0x1e0
 ? __x64_sys_sendmsg+0x48/0x50
 ? do_syscall_64+0x32/0x80
 ? entry_SYSCALL_64_after_hwframe+0x44/0xae
 ? kernel_text_address+0xbb/0xd0
 ? __kernel_text_address+0x12/0x40
 ? unwind_get_return_address+0x36/0x50
 netlink_rcv_skb+0xe7/0x210
 ? rtnl_calcit.isra.0+0x1e0/0x1e0
 ? netlink_ack+0x580/0x580
 ? netlink_deliver_tap+0x68/0x3d0
 rtnetlink_rcv+0x15/0x20
 netlink_unicast+0x3a8/0x4f0
 ? netlink_attachskb+0x430/0x430
 ? __alloc_skb+0xd7/0x1e0
 netlink_sendmsg+0x3ff/0x710
 ? __rcu_read_unlock+0x39/0x60
 ? netlink_unicast+0x4f0/0x4f0
 ? iovec_from_user+0x6c/0x170
 ? __import_iovec+0x137/0x1c0
 ? netlink_unicast+0x4f0/0x4f0
 sock_sendmsg+0x74/0x80
 ____sys_sendmsg+0x430/0x450
 ? kernel_sendmsg+0x40/0x40
 ? do_recvmmsg+0x440/0x440
 ? kasan_save_stack+0x42/0x50
 ? kasan_save_stack+0x23/0x50
 ? kasan_record_aux_stack+0xac/0xc0
 ? call_rcu+0x5a/0x450
 ? __fput+0x1d7/0x3d0
 ? ____fput+0xe/0x10
 ___sys_sendmsg+0xf2/0x160
 ? sendmsg_copy_msghdr+0x120/0x120
 ? __kasan_check_write+0x14/0x20
 ? _raw_spin_lock+0x82/0xd0
 ? _raw_read_lock_irq+0x50/0x50
 ? __fget_files+0xce/0x110
 ? __fget_light+0x72/0x100
 ? __fdget+0x13/0x20
 __sys_sendmsg+0xc8/0x150
 ? __sys_sendmsg_sock+0x20/0x20
 ? __kasan_check_read+0x11/0x20
 ? fpregs_assert_state_consistent+0x5a/0x70
 __x64_sys_sendmsg+0x48/0x50
 do_syscall_64+0x32/0x80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f752cc7312d
Code: 28 89 54 24 1c 48 89 74 24 10 89 7c 24 08 e8 ca ee ff ff 8b 54 24 1c 48 8b 74 24 10 41 89 c0 8b 7c 24 08 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 2f 44 89 c7 48 89 44 24 08 e8 fe ee ff ff 48
RSP: 002b:00007ffd1962bc70 EFLAGS: 00000293 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000055e6574ba880 RCX: 00007f752cc7312d
RDX: 0000000000000000 RSI: 00007ffd1962bcc0 RDI: 000000000000000c
RBP: 00007ffd1962bcc0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000293 R12: 000055e6574ba880
R13: 00007ffd1962be78 R14: 00007ffd1962be6c R15: 0000000000000000

The buggy address belongs to the variable:
 dmi_ppag_approved_list+0x570/0xffffffffffffde20 [iwlmvm]

Memory state around the buggy address:
 ffffffffc16af600: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffffffffc16af680: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffffffffc16af700: 00 00 00 00 00 00 00 00 f9 f9 f9 f9 00 00 00 01
                                                 ^
 ffffffffc16af780: f9 f9 f9 f9 00 00 00 00 00 00 02 f9 f9 f9 f9 f9
 ffffffffc16af800: 00 00 00 07 f9 f9 f9 f9 00 00 00 00 00 00 00 01
==================================================================

Fixes: a2ac0f48a07c ("iwlwifi: mvm: implement approved list for the PPAG feature")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 15e2773ce7e7..71e5306bd695 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -1083,6 +1083,7 @@ static const struct dmi_system_id dmi_ppag_approved_list[] = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTek COMPUTER INC."),
 		},
 	},
+	{ },
 };
 
 static int iwl_mvm_ppag_init(struct iwl_mvm *mvm)

-- 
Jens Axboe

