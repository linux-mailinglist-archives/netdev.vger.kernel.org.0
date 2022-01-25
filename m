Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF78C49AA63
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 05:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1325494AbiAYDh2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 22:37:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S3418000AbiAYCM0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 21:12:26 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2061a.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e83::61a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 088FAC09F493;
        Mon, 24 Jan 2022 17:24:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DIJnNdKBGfr+4FAtQ9cwueU20mEOhY8E/w60um9U4OFUX9Q9NOEjhR1i3g6n9wbi6U/LGhblARtoQzDFaO4IQriyzJRr6av/9733VnnWm0awjDwiaVNb6p1jPaQ/rlzfqOzBYtrDDkMyyuoSRh4jrbKBjWcUrZvYP5Ch7D0tVouw0O/2Q+AIIlFw7KpcRrwBBVedLkAuYMRhbCpzjEhM6OSp0uS9gyGtCLuI5orilUBnsPOymyibx2tczYQLTjoAPdXXG+Ja5pJjryNvmKVoDfW/6QErxVQ5NTvh8A6Ae6OecEHqZcF3/BBSUdUU0GxbHujIf7luKAm2qjLpNxKNig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zSVbl9JsHgzoHnrW2ZChU783JGQNs8GpyOXTPWS3InU=;
 b=GzQQMqOTW916Ad25Ypju1uhCsA8tgDxY5thgtmU2UX9b/bK39TkqNXHAupoIIxLCMDv6UpaVJ6008r2P2Rwjuvs33RwAngiAS6I3C1t2i1dN1OHynGf5pZweLZADVmX+BRfsUYrllQfBsek8Qo1W1FGTMOmh+i9nbH3ekAfzxmSw7/9Xc6OzFchZLlnLiLCILXyknPG5nARUPUSjvE7z7gyBMAXhevNO3+0u+iMz0icywPJVI8DP4lno4d9SCiM1MCtyzDO1puHgNmEencU36AgEkSlVSDeo1m5OCZWQXX7W+BjKXItmilC9Zs0WM3je+f+7f2mKA/zKzm/Sc0ewTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zSVbl9JsHgzoHnrW2ZChU783JGQNs8GpyOXTPWS3InU=;
 b=IHslbCUCcaH1we5lm5PKjAfRKZBpRZSPoZVWcRAlm6yV/Wel8ZSDEQEQMHO3EGOU9p775neFw89ffDPZr9XudshQPj9OlARpR0S6dPX5/7uyTW3tSLtFsVI0Sx1kGxGLAPOdtYONv8qZUTRnZDgWQHEw+c8AnHH0VB4I+5DUw54=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BN9PR12MB5115.namprd12.prod.outlook.com (2603:10b6:408:118::14)
 by BN8PR12MB3058.namprd12.prod.outlook.com (2603:10b6:408:66::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8; Tue, 25 Jan
 2022 01:23:58 +0000
Received: from BN9PR12MB5115.namprd12.prod.outlook.com
 ([fe80::971:531c:e4f4:8a9a]) by BN9PR12MB5115.namprd12.prod.outlook.com
 ([fe80::971:531c:e4f4:8a9a%7]) with mapi id 15.20.4909.017; Tue, 25 Jan 2022
 01:23:58 +0000
Message-ID: <500a3aa0-f51e-92ac-82d6-7ffc7f603e2c@amd.com>
Date:   Mon, 24 Jan 2022 20:23:56 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: Build regressions/improvements in v5.17-rc1
Content-Language: en-US
To:     Randy Dunlap <rdunlap@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Alex Deucher <alexdeucher@gmail.com>
Cc:     ALSA Development Mailing List <alsa-devel@alsa-project.org>,
        KVM list <kvm@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-um <linux-um@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        "open list:BROADCOM NVRAM DRIVER" <linux-mips@vger.kernel.org>,
        Lakshmi Sowjanya D <lakshmi.sowjanya.d@intel.com>,
        sparclinux <sparclinux@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        "Tobin C. Harding" <me@tobin.cc>
References: <20220123125737.2658758-1-geert@linux-m68k.org>
 <alpine.DEB.2.22.394.2201240851560.2674757@ramsan.of.borg>
 <CADnq5_MUq0fX7wMLJyUUxxa+2xoRinonL-TzD8tUhXALRfY8-A@mail.gmail.com>
 <CAMuHMdWUWqHYbbavtMT-XAD_sarDPC5xnc3c0pX1ZAh3Wuzuzg@mail.gmail.com>
 <aca104cf-5f5f-b696-754a-35e62dbe64c3@infradead.org>
From:   Felix Kuehling <felix.kuehling@amd.com>
In-Reply-To: <aca104cf-5f5f-b696-754a-35e62dbe64c3@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: YTXPR0101CA0003.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b00::16) To BN9PR12MB5115.namprd12.prod.outlook.com
 (2603:10b6:408:118::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 04bcbaa5-ef8b-47a2-ea6d-08d9dfa15c79
X-MS-TrafficTypeDiagnostic: BN8PR12MB3058:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB30587CA5EE5B4A40821148CB925F9@BN8PR12MB3058.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sS1wRn8mUsx8ThWydY3jSQuCEBzwhuyTPl+Ax2bx14pFnwXlaaSKqyDAOQT7HDkbxKxOTIdGQm7ZVLVJWnP8mYfoIgQmv5xWeUzVo5IcRIzqUHAFVP7fPNL6Os4MQDlX6S/cdOTWdwYeienvC441qYw2JVYdsmKqFgD9lxt9CCkdz6uwBzJ9+fZFNfC7oahG7f1v2mIFj52NlAeNkYhPLe9Be/KF8p8OXcm//Rr3Y0o0FeDm5w6IkiXhsqUe0enMVOs6Igv4H2i0aVvb1UsUdQ0H8hs3a326Io27IbL0kS0epv3hyanZCwSoSTy25vwhh+kO53eMrTSYpuJhY8K+IZWKIt6Rk2qn/G88Gxwkzoeb9SHLu9T4Msft7Hdxt8iCx3l6QLwnVpVjSoyh82sa0gFqlVGWIXTTn8N48I+DX/mJwo3yy/hti6anTjGA+aSrtSQ9Xii1r7QTny2qtyHIqq7UFckoMQMDAsaLKslbvQpuAuLsCdPtNSkNfEUQ5Aeyj7nooJPiUTS6Go2g8TYkNLPEDuO79eslRbUC/SIE1hTBofs35svsDNXT8392B0RL5lb5kxqlVT/2cp+vVEDNmCPZEtS7iZlamq3hSa9nz0gH+isrtzMV7DYlDU/SDJVxULb7q/E3Vk533dEcj77eGaV/vDob7OYRU9E++goKLkeUREq5RUq2d1vPP3+Y2n7SCkM7MqCYq+4dLjHH05fOJtaOFKSbpoFQK7Zt7scbaUn1FXfX+EB5C+yQva/IvvAXQ3Pr5Zytqty3SXiZP1XTawQNXhVflKWUb0rNZUBW6ckig/Ymlh2rJR1Be9b8y86rV+C9Fr8nPA3PkazQubU5lQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5115.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(53546011)(31696002)(26005)(6486002)(8936002)(66476007)(86362001)(66556008)(66946007)(508600001)(31686004)(6506007)(5660300002)(110136005)(2616005)(316002)(84970400001)(83380400001)(2906002)(8676002)(44832011)(7416002)(38100700002)(54906003)(6512007)(4326008)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dWJjaXgrYjNSZWxOZVEwVGsyMlZHRG5PUHVnOEUrUmIyYk1OVlNPdjkwZHFu?=
 =?utf-8?B?b2VXSkFybE5XWnpQZ0p6bnJNazFmeWVuTExpQkI4eHY2M3JiSFM5NkZIeHk0?=
 =?utf-8?B?Mkd3N0U3TThaYUxTdFJKT09OOGJBQTIvcUcrd0ZrRUdkeEgvemx6OWVaQnV5?=
 =?utf-8?B?UVcxeTRYRVE3UkNFT1dEMERmQnBkVjhUbEhpbGMrdGZJWGVvVmcrOW5WTDFP?=
 =?utf-8?B?eEQ5dXdKYlRZbWVCMzNaVVNQZlBQNHZGVzNlUWF3N0Y3NHhuTFc2L2dVajVM?=
 =?utf-8?B?a1NETXlsWk9IZE9LZDFUVXMyMTJUYlRXRlNIZmxPOHU2cmtYMVJJdk44ZDRS?=
 =?utf-8?B?MElhRTBLc3NSWFYyWWFGNmxEcExwZnV1dXRaWW1oRXFpMVMwdGVXeDVscERm?=
 =?utf-8?B?cjd6Z3BqZ0dkRWFzRTFCd1Ntd2FId21SZXFXME5TVWZjNGduZWhxNWQ5NjND?=
 =?utf-8?B?K1ZkVzhFS1prZWplb2hrN1Q3YTBFNFRtYUR1ZGZzUmxJNjR1dU5yMXRHMXVN?=
 =?utf-8?B?VmdNczFqR3dEU2Q4VHJId1Q5Z3UxZFFFOUdBMXNFenlqcVNiUG1hUEsrOEp5?=
 =?utf-8?B?ZU51NUpXVkpsTHF2VHZJYjFXNi9MbVhnVkt5R255V0NKSjZieHZBQ1RIeVdw?=
 =?utf-8?B?d1lIN1BtTDB3Z1hBVG9Ca1g5RjVYUjZzUzlyZlBabWpDV1llUGFTc0laOVlO?=
 =?utf-8?B?VU9RbUZtSit6T0dEUmM3RnB3L3NycUNiMEduL052M1ZiMUxCeWV1ZG85cm1o?=
 =?utf-8?B?dHRaUmthWWR5ME5vK0dObmRRRzlyOGp4OVk0ejhueE1nRDk1c2UxZU5ZZ3NQ?=
 =?utf-8?B?WGdCZ25xN2JJVkhRRWo2dm1LcjQvNnV4Qm1vQ3hnSWxPWVZ6M0J5RXV6MXRI?=
 =?utf-8?B?MlA5K051OEQvSjNya3o0dEc3Y0RnRzhuZCtUWjhlVWhaSnFWbTRvcE1FN0NU?=
 =?utf-8?B?QWYzeUkwUTgzNXZHV1lzRGgxbkdEdCtWYmdod3Ezd1piWUMrMnV1U1pIS2Zs?=
 =?utf-8?B?ZkhuRTgyei9qSWVCL3g0bGlmbURocHJIK00rZWt3YTZBcTNHVWo1WVRXNVhn?=
 =?utf-8?B?cC9URnRLQWZwRnQybkwwOEd0M3BwTmFYNDRPRnhuVlppdmNoZzBDWlVNaFBx?=
 =?utf-8?B?eTljSmFJS1c0UEQ4ZXdFbnpzTWV1aW9XWTZTcUk1Q1p4R1FaTUZjdjZzaEJw?=
 =?utf-8?B?a2JoZGhzTUhESkJoSHpLQ1MyYnNaUVdLb0JSOXVQVTQ2dDR2MFY0eEExKzBW?=
 =?utf-8?B?NHhvUUg0SmZndFBCQlZTeGk2L1FZRElOU25PVVg1OTlvOXo0QmxpUTVvN1d3?=
 =?utf-8?B?SGsrT2lQWS9WY2tnWjE3czZDcDNvZjJUNnlnWVVkRWtvc0l6Rm5PdWdUeExi?=
 =?utf-8?B?c0lEQ1RDanRyT09mNldIbVkyWVd4Y2pMbmR2dkdmcWFndU16WEtOK1prZlJ6?=
 =?utf-8?B?aGhncWhFa3o4TkwvUVBIcnhwYkVYb1lQZ3FqMkFBZkN4NTEvMGZ0UnJOUk4y?=
 =?utf-8?B?bzdaTXh5NFkzZWRxaEZpSTZNMXdPMDBvRUdmYWc5NjJVL2hJOGdkalZjZ3pj?=
 =?utf-8?B?bkNmTVFjNnZvc3Y3S2tFdXZTNlI2ckFmOW9teHo4ZGNNc1d5Q1lrUkRYZkZo?=
 =?utf-8?B?R1VXMXBWN2tnMlJ2bEJDV2o5TytxRyt1WkUwZFhmdjBnT0E5UWlVMjhMa0t6?=
 =?utf-8?B?YTFkeXRXOW4zaHh3U2lKMVU5Q2ZpZlhYNFRvTTRVT243MHNUTXZObmZ1WFZF?=
 =?utf-8?B?RUtQWDRMZXhSKzBEVlFkVFp4TkM4eVNtMWZncVozRm8ybUtKVGUvNVkzbFZP?=
 =?utf-8?B?K0tvVU95UW9RMVlZQlpjMEg4TUNtZUN6OTlQUnB3ZkFsVk81RU1BbkZUcjFw?=
 =?utf-8?B?Tlh3UUI2aHVWa2RzbVVKSkgrbUZ0YjRhRWhCT2g2YW5WMVNGUUVxQTRpYWpJ?=
 =?utf-8?B?UmMxU3lWVURpdGNvcjNWMGdzbXhOVDZoTUYzRXhkVC8rYVBPdFYreWpjZW52?=
 =?utf-8?B?d0gxdkhpZ3ZFS0JkWGJ4UTJRcXY2cDFFUWF1NUlVa0d5bVJqbUM3UjFmNC9o?=
 =?utf-8?B?Q3dCNGdHYWFyUmFXSmFHOWdRYkpoVjFxT3JjN2lQbWEzbStZbVVZbithSWVm?=
 =?utf-8?B?bW1aeEJ2ck4vN2JxZEk0VUNQK0pUck1HMjVrbDBGd2g1ZngzMmYvU1ZVd0dJ?=
 =?utf-8?Q?kVWpGXnS3s1eVDHYBqqnZMs=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04bcbaa5-ef8b-47a2-ea6d-08d9dfa15c79
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5115.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2022 01:23:58.6202
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oXcSYPMslqvMz5gstb1SKEZF8muKJXbaWuLyg9snLBV1Gqx1CAjfZeeSS9TloKM+BTAPWtrVs3ELVz7U4t41mw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3058
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Am 2022-01-24 um 14:11 schrieb Randy Dunlap:
> On 1/24/22 10:55, Geert Uytterhoeven wrote:
>> Hi Alex,
>>
>> On Mon, Jan 24, 2022 at 7:52 PM Alex Deucher <alexdeucher@gmail.com> wrote:
>>> On Mon, Jan 24, 2022 at 5:25 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>>>> On Sun, 23 Jan 2022, Geert Uytterhoeven wrote:
>>>>>   + /kisskb/src/drivers/gpu/drm/amd/amdgpu/../amdkfd/kfd_topology.c: error: control reaches end of non-void function [-Werror=return-type]:  => 1560:1
>>> I don't really see what's going on here:
>>>
>>> #ifdef CONFIG_X86_64
>>> return cpu_data(first_cpu_of_numa_node).apicid;
>>> #else
>>> return first_cpu_of_numa_node;
>>> #endif
>> Ah, the actual failure causing this was not included:
>>
>> In file included from /kisskb/src/arch/x86/um/asm/processor.h:41:0,
>>                   from /kisskb/src/include/linux/mutex.h:19,
>>                   from /kisskb/src/include/linux/kernfs.h:11,
>>                   from /kisskb/src/include/linux/sysfs.h:16,
>>                   from /kisskb/src/include/linux/kobject.h:20,
>>                   from /kisskb/src/include/linux/pci.h:35,
>>                   from
>> /kisskb/src/drivers/gpu/drm/amd/amdgpu/../amdkfd/kfd_topology.c:25:
>> /kisskb/src/drivers/gpu/drm/amd/amdgpu/../amdkfd/kfd_topology.c: In
>> function 'kfd_cpumask_to_apic_id':
>> /kisskb/src/arch/um/include/asm/processor-generic.h:103:18: error:
>> called object is not a function or function pointer
>>   #define cpu_data (&boot_cpu_data)
>>                    ^
>> /kisskb/src/drivers/gpu/drm/amd/amdgpu/../amdkfd/kfd_topology.c:1556:9:
>> note: in expansion of macro 'cpu_data'
>>    return cpu_data(first_cpu_of_numa_node).apicid;
>>           ^
>> /kisskb/src/drivers/gpu/drm/amd/amdgpu/../amdkfd/kfd_topology.c:1560:1:
>> error: control reaches end of non-void function [-Werror=return-type]
>>   }
>>   ^
> ah yes, UML.
> I have a bunch of UML fixes that I have been hesitant to post.
>
> This is one of them.
> What do people think about this?

Does it make sense to configure a UML kernel with a real device driver 
in the first place? Or should we just prevent enabling amdgpu for UML 
with a Kconfig dependency?

Regards,
   Felix


>
> thanks.
>
> ---
> From: Randy Dunlap <rdunlap@infradead.org>
>
>
> ../drivers/gpu/drm/amd/amdgpu/../amdkfd/kfd_topology.c:1556:9: note: in expansion of macro ‘cpu_data’
>    return cpu_data(first_cpu_of_numa_node).apicid;
>           ^~~~~~~~
> ../drivers/gpu/drm/amd/amdgpu/../amdkfd/kfd_topology.c:1560:1: error: control reaches end of non-void function [-Werror=return-type]
>
> ../drivers/gpu/drm/amd/amdgpu/../amdkfd/kfd_crat.c: In function ‘kfd_fill_iolink_info_for_cpu’:
> ../arch/um/include/asm/processor-generic.h:103:19: error: called object is not a function or function pointer
>   #define cpu_data (&boot_cpu_data)
>                    ~^~~~~~~~~~~~~~~
> ../drivers/gpu/drm/amd/amdgpu/../amdkfd/kfd_crat.c:1688:27: note: in expansion of macro ‘cpu_data’
>    struct cpuinfo_x86 *c = &cpu_data(0);
>                             ^~~~~~~~
> ../drivers/gpu/drm/amd/amdgpu/../amdkfd/kfd_crat.c:1691:7: error: dereferencing pointer to incomplete type ‘struct cpuinfo_x86’
>    if (c->x86_vendor == X86_VENDOR_AMD)
>         ^~
> ../drivers/gpu/drm/amd/amdgpu/../amdkfd/kfd_crat.c:1691:23: error: ‘X86_VENDOR_AMD’ undeclared (first use in this function); did you mean ‘X86_VENDOR_ANY’?
>    if (c->x86_vendor == X86_VENDOR_AMD)
>                         ^~~~~~~~~~~~~~
>                         X86_VENDOR_ANY
>
> ../drivers/gpu/drm/amd/amdgpu/../amdkfd/kfd_crat.c: In function ‘kfd_create_vcrat_image_cpu’:
> ../drivers/gpu/drm/amd/amdgpu/../amdkfd/kfd_crat.c:1742:11: warning: unused variable ‘entries’ [-Wunused-variable]
>    uint32_t entries = 0;
>
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> ---
>   drivers/gpu/drm/amd/amdkfd/kfd_crat.c     |    6 +++---
>   drivers/gpu/drm/amd/amdkfd/kfd_topology.c |    2 +-
>   2 files changed, 4 insertions(+), 4 deletions(-)
>
> --- linux-next-20220107.orig/drivers/gpu/drm/amd/amdkfd/kfd_topology.c
> +++ linux-next-20220107/drivers/gpu/drm/amd/amdkfd/kfd_topology.c
> @@ -1552,7 +1552,7 @@ static int kfd_cpumask_to_apic_id(const
>   	first_cpu_of_numa_node = cpumask_first(cpumask);
>   	if (first_cpu_of_numa_node >= nr_cpu_ids)
>   		return -1;
> -#ifdef CONFIG_X86_64
> +#if defined(CONFIG_X86_64) && !defined(CONFIG_UML)
>   	return cpu_data(first_cpu_of_numa_node).apicid;
>   #else
>   	return first_cpu_of_numa_node;
> --- linux-next-20220107.orig/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
> +++ linux-next-20220107/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
> @@ -1679,7 +1679,7 @@ static int kfd_fill_mem_info_for_cpu(int
>   	return 0;
>   }
>   
> -#ifdef CONFIG_X86_64
> +#if defined(CONFIG_X86_64) && !defined(CONFIG_UML)
>   static int kfd_fill_iolink_info_for_cpu(int numa_node_id, int *avail_size,
>   				uint32_t *num_entries,
>   				struct crat_subtype_iolink *sub_type_hdr)
> @@ -1738,7 +1738,7 @@ static int kfd_create_vcrat_image_cpu(vo
>   	struct crat_subtype_generic *sub_type_hdr;
>   	int avail_size = *size;
>   	int numa_node_id;
> -#ifdef CONFIG_X86_64
> +#if defined(CONFIG_X86_64) && !defined(CONFIG_UML)
>   	uint32_t entries = 0;
>   #endif
>   	int ret = 0;
> @@ -1803,7 +1803,7 @@ static int kfd_create_vcrat_image_cpu(vo
>   			sub_type_hdr->length);
>   
>   		/* Fill in Subtype: IO Link */
> -#ifdef CONFIG_X86_64
> +#if defined(CONFIG_X86_64) && !defined(CONFIG_UML)
>   		ret = kfd_fill_iolink_info_for_cpu(numa_node_id, &avail_size,
>   				&entries,
>   				(struct crat_subtype_iolink *)sub_type_hdr);
>
>
