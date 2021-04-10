Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2D5935AF57
	for <lists+netdev@lfdr.de>; Sat, 10 Apr 2021 19:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234956AbhDJRhN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Apr 2021 13:37:13 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:13620 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234851AbhDJRhM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Apr 2021 13:37:12 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13AHVXT5029703;
        Sat, 10 Apr 2021 10:36:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : references
 : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=iskfSXkjBf+sRwHyXcwyT3gJtvZuc6AqoZsMjaeBHPY=;
 b=NQZdXVY7mUpt/ew6JJvI83FwaFrqryz29y1SW2JWpl+DUa+/yIbHaJMp/fB2pKr0m3im
 PfsQ3Q54WaQckG8dYIrltM7+I7rSIx4thOk5PEpKoakGgrDcOewJrDw4SDxrkUVVRTEt
 Bgdv5Z3gy/gn6DDTVXj8blMj6gAJ+FP5K/M= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 37u9qe9k6d-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 10 Apr 2021 10:36:51 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 10 Apr 2021 10:36:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XXFLVJUFz/bNDXaCqFYmHJ1idJXa6xdLFPWMwnZNVaLAExvGuo9f5tEPeHe5RrsRl9VBkjJC9Dg6fEoH4Qs4AIwuaD1AZdCsVZSVihG5akvGq1KegIqeYIHPjGv/My3H9F9mQFJiMG5P+sSgpkOib2E5R9g+7R/u7K0C1ObsUaWkNWlHhhWTmrrxM7oz7t39reDJKzinmssPkO+5oHtcLu5+S4ZPxh5EQhhIfcYrvbnW44BCi/43P7uss548Tbpw+/2Y2mzTHvpVGu/GD8lbdgW2zdcjue8TtLzQ/Lq/czNuWbjvpGNAEg43wgbQrGknW6Hpeb4tOSJ3hjtpew7WLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UQ55ukBK8mkZk+gNIrrgF3j/n7IVLb+WlYdf1kKvs3s=;
 b=mOMHga/uePP8+Qt5k9uUwQKeNXDnKPIqg2CdM0WL41FfZFtiRxkNFtgHZNICo7aN7+tsexmo8I0oeXYSCuUL0t/ZsxNkrTo3UFrq/6nXrLt0hP9ZlTEK9UPLDNpz40xl/qR3nsX+ZyJzWGFrikmu/r0fX33q+HgAAtmZYFRoLUzNJX57oFxsSoaNG6Uj5GIX9YpkiYuIMW0KmwJrYpU5kvNcUmLqjO/msE9CPuM5F+G7+ENuUiE4C7SBEZBjNcM8gd4Fss7QjYcShMgtjqoDC0asgWAF/zPrLjnAQ9vJPNRmJwFUqVouFaw0ylH0vGs4dfU6LRPZiH+j1EvNlipFew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Sat, 10 Apr
 2021 17:36:46 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.3999.033; Sat, 10 Apr 2021
 17:36:46 +0000
Subject: Re: 5.?? regression: strace testsuite OOpses kernel on ia64
To:     Sergei Trofimovich <slyfox@gentoo.org>,
        <linux-ia64@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
References: <20210223185321.359e34bc@sf> <20210409222004.70968cd7@sf>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <2dba9671-b957-4404-e46b-4e9b947005c9@fb.com>
Date:   Sat, 10 Apr 2021 10:36:43 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
In-Reply-To: <20210409222004.70968cd7@sf>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
X-Originating-IP: [2620:10d:c090:400::5:fc9e]
X-ClientProxiedBy: CO2PR18CA0057.namprd18.prod.outlook.com
 (2603:10b6:104:2::25) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::19f8] (2620:10d:c090:400::5:fc9e) by CO2PR18CA0057.namprd18.prod.outlook.com (2603:10b6:104:2::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Sat, 10 Apr 2021 17:36:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 50e11265-4000-4a19-dfbb-08d8fc4736c6
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:
X-Microsoft-Antispam-PRVS: <SN6PR1501MB20640CED3BA4231A0943F6FAD3729@SN6PR1501MB2064.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y2KX+8Zhv53Azz08OHtr8Stt0cEBBTKazyTYA6ml9zJz/Yq+DflvTAQmAiAf9GZPQKuglPDVIX1+5f5j/fHWy13E7FJDf32nRboxwLCwyhIJTjUnm+9cfonPkV2q0NVxNqnqyLUNYuNqBzC/VAdlAEDxl+Vo4soHMYyjgXpoZf+vbQPwu50Ui3cSdH/gdnKKEbkD+5o6GNIazCmcG73EpVzNp0HEOf1nmgUZ08GIDCqazSadeXzmB7+8jrTj5neyoZPhdY7tHvlx7cRq61QXZ6yLfSWtNh+hBZ6dLY7ihTrOMY5EPHQPIeqg5xQDugDUqtQ+PtcNUkUnTKA2dFnj2wRvC7GrbTex6OUCPMXPIc++r5JXSiNSOWXWVlwLTUJx1waLsqrL64cwvzz+WRUOdjjC+4Pkh+SL4Rn++89e/2IoqSJ1c5oO+sBaDB5FXXJx5NPAWOKzj+jZZdwCI7QTlo0H0EjcxGTcxYOF3KXKOk81U4NuNc/6BXV9NvUZiChgz6GD/Wo95tvmdaWn10KFhC41yz/o1D6CuTFAP03fH//c6Yqshs8DCnk+7+2jCYAwNT8HsN4UHEzGvVKGU8T/dFnQSrsAxMaSuevlBxPWIR0bp277pSwFeMNidY5eHCu21OY2JTl8YJGJ0PRw1DgeZGPcy/bINovKpq1U8V2No9Fi8MNtlrdDFELhmmxhA/+FftqFPMobQSyqJVL1nlAx6Vw0qQF6L9WiBKvyFiutGqJFz1M28YXVt7T9wAuIcV+p/uOOkw9tCxRsWD81YOBURQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(346002)(376002)(366004)(396003)(66476007)(5660300002)(36756003)(66946007)(52116002)(66556008)(86362001)(83380400001)(38100700002)(2906002)(30864003)(316002)(53546011)(8676002)(478600001)(186003)(966005)(6486002)(45080400002)(8936002)(2616005)(31686004)(31696002)(16526019)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZFB4YTVQaHgzWlErZytiTFBhMitHdDlJVGs5TlZiRjJKRFNvYVVlU0JvNjhM?=
 =?utf-8?B?SUllNjVoSDZRUUJhSlVLY2JNNE9oNTZHdjkxY3hvQ1BqQzE4TlgvcFpCUUJS?=
 =?utf-8?B?RHJmaUJZc3NtYmZaZWpXZVlXRnpONHFWaUo2ZHBMSy8vQWlJUzRCK3dMbUE0?=
 =?utf-8?B?OUpYN2NZTE9WaWhweEhOcTFSSVpzUXp6RkNvemcrdlpzV1NiZmFpVTVzdDVy?=
 =?utf-8?B?N3ZiV25FQnhjL29kSlFBVjRzbGdnOENTUmsvT2lSc3VrNXVwRGIvdzlGT3Ba?=
 =?utf-8?B?S1c0cUR2YWhYSmduR1IwQ3ZuMTY2SkxDSGpmTXA4d09NMnZKS2pvR2czaWcv?=
 =?utf-8?B?V3c4Sms5MmhPcU56MEt6bW9Vc09wOFAzUDlmd05aS0JUMmM0NGQ3bEN1S21k?=
 =?utf-8?B?aUMvbEE3SnkwRHpyeDVSMTlKcEw5RWxXdWZzaDNBUlZWSXNlQ1phaUdyYzhx?=
 =?utf-8?B?WGppK2ZKVXNIVlAxeEdzOXBpWkxCMHhFWjBiTE5NV3dGSmlwUE14ejVSZVFN?=
 =?utf-8?B?THArcEVhd3BYZ0dHeEFFNW10TFhYem9tMmwyaEVFeSsydXFwTDdOYXlnZVZR?=
 =?utf-8?B?YVdKa2RCMjdTcXdEcUMzb1lwb29yNzBIMFNCK1ZnVFNmN0RpbVVDcWQzUjdp?=
 =?utf-8?B?UWtMSFVzRUdkMnY1M3dzZzQ1SjJSS2F0WlNCdnora1duRTJraVRwOEVpVkNH?=
 =?utf-8?B?T3V2VzNpZU1zUkJsVDJidGNwVE1icVNtRGlpNVB2WVY3bkR1ZC9KZTBBZFJI?=
 =?utf-8?B?blQzTmJOUStNRUJFTXlTNVVXbE4yMVBuRFdyWE56cVhsMUx0cmZkeHBaci9u?=
 =?utf-8?B?ay93MVppbFF4enN5VTJMWGthWEZJaG1tOHZDNGZnSXRnODZncUNSU3o2U1VO?=
 =?utf-8?B?clRVOGROWCttZkZOc2xIK1FBUFpQUGR0eUpacUpZQmpKcU5hYis2cVZsZTIw?=
 =?utf-8?B?WHloTkhJQ1FnU1hsTGlucjg2bGNoay9vZzNPckVUaGlJQnBuNlpGdENSeEt6?=
 =?utf-8?B?RmZxQ3ppYWhDTlVCeWo0dmsreC95emlSbWcySEN2bjBNdUVld2tsQXVVbFFE?=
 =?utf-8?B?ZktFc1FRSi9PUkhKUjJzTjBuUmJlM2dKU0UycEJnZlMzOWR2ODJYM3ppaldE?=
 =?utf-8?B?U0VlZzJuSHZsMjh6ckxQdFdGWDlIaWVOUis0ek01RjRLOWJIb3ZXU0FQek5B?=
 =?utf-8?B?RG5VRy8wN25BdUh1ZVVWTENEbHFPY3B2VVFIYmM2aUczcXpHSTB4dVBUaHd6?=
 =?utf-8?B?MlVocVlKRnhxVDg1Tkw2Z1JvOGJJemJnZWZiekF2K2Q5czlYTmRmQURxM1VT?=
 =?utf-8?B?S0d1dTJhT2ZPOHgzRTVCTXdNRVJZK3Bjc2pqU0N3NCs5ZlRZci94NExFcFdH?=
 =?utf-8?B?YzBsdVNwM2Zhdk1FRVhpc09pODVnRUhwQmE1azhUZkZJTU5KNThyUzNwaTdU?=
 =?utf-8?B?Tit5dDdMUUZWR2dibXBlTGRlckFUMFJaZGtPNEt1amQ4T1RteHB6c2Fjb1VH?=
 =?utf-8?B?eVNOWjBWK1dQS0NBNVFOUWNIOXAxQWM5Qlp4Y2I3bHFpVjJvZUxMWExEMlA1?=
 =?utf-8?B?aWQ1Ynpqb1BGMjJzQXhxaEx2aGlra3Y1blhFS0RWU3gxNC9rcjF4TFpvekk4?=
 =?utf-8?B?bVBDdDZ5cC9vcitLSEcvM3VGNWNZYUJqTTQxbTByekVodkYxS0N4bSszSkp1?=
 =?utf-8?B?MCtsbXppODc5V3dvb0xHT21jMWxidXdjeEU2QmRtakY1cGNBMDljOVlSUkhC?=
 =?utf-8?B?d0pnclRCTjhPUWJ6MXczMUZHeDlrS1F2bzRrOFdXWnM0ajQ2S2tFNWcrMkRM?=
 =?utf-8?B?NmlHWGRnQWpodGV5OHI0Zz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 50e11265-4000-4a19-dfbb-08d8fc4736c6
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2021 17:36:46.7034
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3IDxIP+lClbIxNGWrYOJjJY37FBdgsnLB6HGCJm+tvThug5Z4CVfz3iIUTWAdQ7N
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR1501MB2064
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: mMIJ-xqtiOnBaAvbCXOv2GyCKKRPwVxK
X-Proofpoint-GUID: mMIJ-xqtiOnBaAvbCXOv2GyCKKRPwVxK
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 1 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-10_07:2021-04-09,2021-04-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1011 mlxscore=0
 suspectscore=0 impostorscore=0 mlxlogscore=999 malwarescore=0 phishscore=0
 priorityscore=1501 adultscore=0 lowpriorityscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104100133
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/9/21 2:20 PM, Sergei Trofimovich wrote:
> On Tue, 23 Feb 2021 18:53:21 +0000
> Sergei Trofimovich <slyich@gmail.com> wrote:
> 
>> The crash seems to be related to sock_filter-v test from strace:
>>      https://github.com/strace/strace/blob/master/tests/seccomp-filter-v.c
>>
>> Here is an OOps:
>>
>> [  818.089904] BUG: Bad page map in process sock_filter-v  pte:00000001 pmd:118580001
>> [  818.089904] page:00000000e6a429c8 refcount:1 mapcount:-1 mapping:0000000000000000 index:0x0 pfn:0x0
>> [  818.089904] flags: 0x1000(reserved)
>> [  818.089904] raw: 0000000000001000 a000400000000008 a000400000000008 0000000000000000
>> [  818.089904] raw: 0000000000000000 0000000000000000 00000001fffffffe
>> [  818.089904] page dumped because: bad pte
>> [  818.089904] addr:0000000000000000 vm_flags:04044011 anon_vma:0000000000000000 mapping:0000000000000000 index:0
>> [  818.095483] file:(null) fault:0x0 mmap:0x0 readpage:0x0
>> [  818.095483] CPU: 0 PID: 5990 Comm: sock_filter-v Not tainted 5.11.0-00003-gbfa5a4929c90 #57
>> [  818.095483] Hardware name: hp server rx3600                   , BIOS 04.03                                                            04/08/2008
>> [  818.095483]
>> [  818.095483] Call Trace:
>> [  818.095483]  [<a000000100014a70>] show_stack+0x90/0xc0
>> [  818.095483]                                 sp=e000000118707bb0 bsp=e0000001187013c0
>> [  818.095483]  [<a00000010100c2b0>] dump_stack+0x120/0x160
>> [  818.095483]                                 sp=e000000118707d80 bsp=e000000118701348
>> [  818.095483]  [<a0000001002e7b40>] print_bad_pte+0x300/0x3a0
>> [  818.095483]                                 sp=e000000118707d80 bsp=e0000001187012e0
>> [  818.099483]  [<a0000001002ec190>] unmap_page_range+0xa90/0x11a0
>> [  818.099483]                                 sp=e000000118707d80 bsp=e000000118701140
>> [  818.099483]  [<a0000001002ecba0>] unmap_vmas+0xc0/0x100
>> [  818.099483]                                 sp=e000000118707da0 bsp=e000000118701108
>> [  818.099483]  [<a000000100302db0>] exit_mmap+0x150/0x320
>> [  818.099483]                                 sp=e000000118707da0 bsp=e0000001187010d8
>> [  818.099483]  [<a00000010005dba0>] mmput+0x60/0x200
>> [  818.099483]                                 sp=e000000118707e20 bsp=e0000001187010b0
>> [  818.103482]  [<a00000010006e570>] do_exit+0x6f0/0x18a0
>> [  818.103482]                                 sp=e000000118707e20 bsp=e000000118701038
>> [  818.103482]  [<a000000100072070>] do_group_exit+0x90/0x2a0
>> [  818.103482]                                 sp=e000000118707e30 bsp=e000000118700ff0
>> [  818.103482]  [<a0000001000722a0>] sys_exit_group+0x20/0x40
>> [  818.103482]                                 sp=e000000118707e30 bsp=e000000118700f98
>> [  818.107482]  [<a00000010000c5f0>] ia64_trace_syscall+0xf0/0x130
>> [  818.107482]                                 sp=e000000118707e30 bsp=e000000118700f98
>> [  818.107482]  [<a000000000040720>] ia64_ivt+0xffffffff00040720/0x400
>> [  818.107482]                                 sp=e000000118708000 bsp=e000000118700f98
>> [  818.115482] Disabling lock debugging due to kernel taint
>> [  818.115482] BUG: Bad rss-counter state mm:000000002eec6412 type:MM_FILEPAGES val:-1
>> [  818.132256] Unable to handle kernel NULL pointer dereference (address 0000000000000068)
>> [  818.133904] sock_filter-v-X[5999]: Oops 11012296146944 [1]
>> [  818.133904] Modules linked in: acpi_ipmi ipmi_si usb_storage e1000 ipmi_devintf ipmi_msghandler rtc_efi
>> [  818.133904]
>> [  818.133904] CPU: 0 PID: 5999 Comm: sock_filter-v-X Tainted: G    B             5.11.0-00003-gbfa5a4929c90 #57
>> [  818.133904] Hardware name: hp server rx3600                   , BIOS 04.03                                                            04/08/2008
>> [  818.133904] psr : 0000121008026010 ifs : 8000000000000288 ip  : [<a0000001001eaa61>]    Tainted: G    B             (5.11.0-00003-gbfa5a4929c90)
>> [  818.133904] ip is at bpf_prog_free+0x21/0xe0
>> [  818.133904] unat: 0000000000000000 pfs : 0000000000000307 rsc : 0000000000000003
>> [  818.133904] rnat: 0000000000000000 bsps: 0000000000000000 pr  : 00106a5a51665965
>> [  818.133904] ldrs: 0000000000000000 ccv : 0000000012088904 fpsr: 0009804c8a70033f
>> [  818.133904] csd : 0000000000000000 ssd : 0000000000000000
>> [  818.133904] b0  : a000000100d54080 b6  : a000000100d53fe0 b7  : a00000010000cef0
>> [  818.133904] f6  : 0ffefb0c50daa1b67f89a f7  : 0ffed8b3e4fdb08000000
>> [  818.133904] f8  : 10017fbd1bc0000000000 f9  : 1000eb95f000000000000
>> [  818.133904] f10 : 10008ade20716a6c83cc1 f11 : 1003e00000000000002b7
>> [  818.133904] r1  : a00000010176b300 r2  : a000000200008004 r3  : 0000000000000000
>> [  818.133904] r8  : 0000000000000008 r9  : e00000011873f800 r10 : e000000102c18600
>> [  818.133904] r11 : e000000102c19600 r12 : e00000011873f7f0 r13 : e000000118738000
>> [  818.133904] r14 : 0000000000000068 r15 : a000000200008028 r16 : e000000005606a70
>> [  818.133904] r17 : e000000102c18600 r18 : e000000104370748 r19 : e000000102c18600
>> [  818.133904] r20 : e000000102c18600 r21 : e000000005606a78 r22 : a00000010156bd28
>> [  818.133904] r23 : a00000010147fdf4 r24 : 0000000000004000 r25 : e000000104370750
>> [  818.133904] r26 : a0000001012f7088 r27 : a000000100d53fe0 r28 : 0000000000000001
>> [  818.133904] r29 : e00000011873f800 r30 : e00000011873f810 r31 : e00000011873f808
>> [  818.133904]
>> [  818.133904] Call Trace:
>> [  818.133904]  [<a000000100014a70>] show_stack+0x90/0xc0
>> [  818.133904]                                 sp=e00000011873f420 bsp=e0000001187396d0
>> [  818.133904]  [<a000000100015170>] show_regs+0x6d0/0xa40
>> [  818.133904]                                 sp=e00000011873f5f0 bsp=e000000118739660
>> [  818.133904]  [<a000000100026e90>] die+0x1b0/0x4a0
>> [  818.133904]                                 sp=e00000011873f610 bsp=e000000118739620
>> [  818.133904]  [<a000000100059220>] ia64_do_page_fault+0x820/0xb60
>> [  818.133904]                                 sp=e00000011873f610 bsp=e000000118739580
>> [  818.133904]  [<a00000010000c8e0>] ia64_leave_kernel+0x0/0x270
>> [  818.133904]                                 sp=e00000011873f620 bsp=e000000118739580
>> [  818.133904]  [<a0000001001eaa60>] bpf_prog_free+0x20/0xe0
>> [  818.133904]                                 sp=e00000011873f7f0 bsp=e000000118739540
>> [  818.133904]  [<a000000100d54080>] sk_filter_release_rcu+0xa0/0x120
>> [  818.133904]                                 sp=e00000011873f7f0 bsp=e000000118739510
>> [  818.133904]  [<a00000010016a7f0>] rcu_core+0x530/0xf20
>> [  818.133904]                                 sp=e00000011873f7f0 bsp=e0000001187394a8
>> [  818.133904]  [<a00000010016b200>] rcu_core_si+0x20/0x40
>> [  818.133904]                                 sp=e00000011873f810 bsp=e000000118739490
>> [  818.133904]  [<a0000001010279f0>] __do_softirq+0x230/0x640
>> [  818.133904]                                 sp=e00000011873f810 bsp=e0000001187393a0
>> [  818.133904]  [<a000000100074770>] irq_exit+0x170/0x200
>> [  818.133904]                                 sp=e00000011873f810 bsp=e000000118739388
>> [  818.133904]  [<a000000100013310>] ia64_handle_irq+0x1b0/0x360
>> [  818.133904]                                 sp=e00000011873f810 bsp=e000000118739308
>> [  818.133904]  [<a00000010000c8e0>] ia64_leave_kernel+0x0/0x270
>> [  818.133904]                                 sp=e00000011873f820 bsp=e000000118739308
>> [  818.133904]  [<a000000101027700>] flush_icache_range+0x80/0xa0
>> [  818.133904]                                 sp=e00000011873f9f0 bsp=e0000001187392f8
>> [  818.133904]  [<a0000001002f7ae0>] __access_remote_vm+0x1e0/0x320
>> [  818.133904]                                 sp=e00000011873f9f0 bsp=e000000118739258
>> [  818.133904]  [<a0000001002f7c80>] access_process_vm+0x60/0xa0
>> [  818.133904]                                 sp=e00000011873fa00 bsp=e000000118739210
>> [  818.133904]  [<a000000100018210>] ia64_sync_user_rbs+0x70/0xe0
>> [  818.133904]                                 sp=e00000011873fa00 bsp=e0000001187391d0
>> [  818.133904]  [<a000000100018b00>] do_sync_rbs+0xc0/0x100
>> [  818.133904]                                 sp=e00000011873fa10 bsp=e000000118739198
>> [  818.133904]  [<a00000010000cf30>] unw_init_running+0x70/0xa0
>> [  818.133904]                                 sp=e00000011873fa10 bsp=e000000118739170
>> [  818.133904]  [<a00000010001ae90>] ia64_ptrace_stop+0x130/0x160
>> [  818.133904]                                 sp=e00000011873fdf0 bsp=e000000118739158
>> [  818.133904]  [<a00000010008af60>] ptrace_stop+0xc0/0x880
>> [  818.133904]                                 sp=e00000011873fdf0 bsp=e000000118739118
>> [  818.133904]  [<a00000010008b820>] ptrace_do_notify+0x100/0x120
>> [  818.133904]                                 sp=e00000011873fdf0 bsp=e0000001187390e8
>> [  818.133904]  [<a00000010008b8d0>] ptrace_notify+0x90/0x260
>> [  818.133904]                                 sp=e00000011873fe30 bsp=e0000001187390c8
>> [  818.133904]  [<a00000010001e3d0>] syscall_trace_enter+0xf0/0x2c0
>> [  818.133904]                                 sp=e00000011873fe30 bsp=e000000118739070
>> [  818.133904]  [<a00000010000c540>] ia64_trace_syscall+0x40/0x130
>> [  818.133904]                                 sp=e00000011873fe30 bsp=e000000118739020
>> [  818.186114] Kernel panic - not syncing: Aiee, killing interrupt handler!
>> [  818.186114] ---[ end Kernel panic - not syncing: Aiee, killing interrupt handler! ]---
>>
>> I'm not sure how to interpret it. It looks like 'bpf_prog_free'
>> frees the memory that is not there anymore, but previous crash
>> hints at already broken page tables. Maybe VM is already corrupted
>> by previous strace tests?
>>
>> I wonder if I can enable a bit more kernel VM debugging to catch the corruption earlier.
> 
> I threw a bunch of CONFIG_DEBUG_* options at the kernel.
> None of them exposed any extra details or changed initial crash report.
> 
> I found out a few workarounds:
> 
> Workaround 1: switching vmalloc() to kmalloc() in kernel/bpf/core.c makes
> the crash disappear (largeish patch: https://bugs.gentoo.org/769614#c26 ).
> That might hint at the bug in ia64's virtual memory implementation
> (like missing tlb flush?) but nothing else seems to exhibit any problems.
> 
> Workaround 2: switching sk_filter_release() from RCU free to inline free:
> 
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
>   static void sk_filter_release(struct sk_filter *fp)
>   {
>   	if (refcount_dec_and_test(&fp->refcnt))
> -		call_rcu(&fp->rcu, sk_filter_release_rcu);
> +		//call_rcu(&fp->rcu, sk_filter_release_rcu);
> +		__sk_filter_release(fp);
>   }
> 
> +netdev@, +bpf@ for possible debugging help.
> 
> Now I can easily trigger the failure with the following test program:
> 
> $ cat bug.c
> #include <unistd.h>
> #include <netinet/in.h>
> #include <sys/socket.h>
> #include <linux/filter.h>
> 
> int
> main(void)
> {
> 	struct sock_filter bpf_filter[] = {
> 		BPF_STMT(BPF_RET|BPF_K, 0)
> 	};
> 	struct sock_fprog prog = {
> 		.len = 1,
> 		.filter = bpf_filter,
> 	};
> 
> 	int fd = socket(AF_INET, SOCK_DGRAM, 0);
> 	setsockopt(fd, SOL_SOCKET, SO_ATTACH_FILTER, &prog, sizeof(prog));
> 
> 	return 0;
> }
> 
> $ gcc bug.c -o bug; while ./bug; do echo again; done
> 
> After 8 iterations machine crashes.
> 
> If I interpret backtrace correctly:
> 
>> [  818.133904]  [<a0000001001eaa60>] bpf_prog_free+0x20/0xe0
>> [  818.133904]                                 sp=e00000011873f7f0 bsp=e000000118739540
> 
> ; void bpf_prog_free(struct bpf_prog *fp):
> ; fp is in r32
> Dump of assembler code for function bpf_prog_free:
>     0xa00000010023bea0 <+0>:	[MMI]       alloc r35=ar.pfs,8,5,0
>     0xa00000010023bea1 <+1>:	            adds r32=56,r32               ; r32 = fp + 56 (&fp->aux)
>     0xa00000010023bea2 <+2>:	            mov r34=b0;;
>     0xa00000010023beb0 <+16>:	[MMI]       ld8 r33=[r32];;             ; r33 = fp->aux
>     0xa00000010023beb1 <+17>:	            adds r14=112,r33              ; r14 = &(fp->aux->dst_prog)
>     0xa00000010023beb2 <+18>:	            nop.i 0x0;;
>     0xa00000010023bec0 <+32>:	[MMI]       nop.m 0x0
>     0xa00000010023bec1 <+33>:	            ld8 r37=[r14]                   ; r37 = fp->aux->dst_prog
>     0xa00000010023bec2 <+34>:	            nop.i 0x0;;
> 
> kernel crashes on aux NULL-ish dereference of fp->aux->dst_prog at:
> 
>> [  818.133904] r14 : 0000000000000068 r15 : a000000200008028 r16 : e000000005606a70
> 
> /* Free internal BPF program */
> void bpf_prog_free(struct bpf_prog *fp)
> {
>          struct bpf_prog_aux *aux = fp->aux;
> 
>          if (aux->dst_prog)
>                  bpf_prog_put(aux->dst_prog);
>          INIT_WORK(&aux->work, bpf_prog_free_deferred);
>          schedule_work(&aux->work);
> }
> 
> Could it be that fp->aux is sometimes free'd earlier than it should?
> It's a non-preemptible kernel.

I cannot reproduce the bug on x86_64. Maybe checking the jit difference
between x86 and ia64, e.g., regarding to freeing memory/prog?
