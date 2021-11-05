Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E96B446B0A
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 23:53:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233615AbhKEWz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 18:55:27 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:45922 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233434AbhKEWz0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 18:55:26 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A5MF69v026787;
        Fri, 5 Nov 2021 15:52:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=gyzF/spRX9xpSoeDW7QoBgE+Dizk9eXBBGQVd937ap4=;
 b=nwCKoe0Tydpux8It4pC76NsEXEwSdtUrqXAsqhiHjc/4tC+jm0D8yQElsZm5rxOUQJ7o
 vra4AxuSd1K59NKI0ygAlEJbqsr9R9sO+ydF67ONjIKLE0V4eH2B/wKMlHajR9A5xX06
 /sn5K0gSxI/C8vlcYur7U/xhpvMe39wKUYc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3c4t34rrfx-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 05 Nov 2021 15:52:45 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Fri, 5 Nov 2021 15:52:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y4ppxyUKL8Uae5dURJmtj9xIEVuVcDoc09j6p1aI1Z4tIAIlbVQhM/1FO6DcWgJIdOtiGFj2hJGWJDsCD3aOL1WbCIxjBiihsmnnaOuGF4eKhqexNmH1WV5XJHe3LHAMIFW0xDZGmPfTC2eg6NmkeNYwMIp9r76fXlaT2Ik/DTXAT+ao5H3VRBru2UfTHsqV+Dj5rOG7XAXiT991sBmM+GqN8nd9bYMLEP5NtncJKfq0Dz5GSJjWZwlHXKiU31SNc1uAUPT64c+AZoTRwf4SriBoV2skFVpkKSsC9FEpXLO9Wj3K9nICs6denlgfFyXow5PFDEoW+v2Sj5HhwvcTVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gyzF/spRX9xpSoeDW7QoBgE+Dizk9eXBBGQVd937ap4=;
 b=g0SQTJU4NpBUsAaStmkolXjhZJ1UigH5ORD2KoeHRtNLOa+p1lVKQa0IQfY9/YoRhpht1mtscXn3HeaZO9PxPjlMuySDoThjhyE8lRacaqSSxxlf03rrnRHyKHNHImbR4b7hStOFERZrmPFKIn1vqjpFUVSFumkxrGM9TGWkn0YY3gNYqUuMf/C5igP1J9cGtnkwK4smZrUFmHk+I24HI9jvafWKeGYUV37aOXXVpJG7mePue/s83yl8YNI8FBEMo5UposM0qmLCC0L5q+T9UuUuHIru1CXsp7+01n/qCf8WFV/xW3X2cJ6c6B+6vgeVAbMMFsKN3Gwc+qeoXU2roQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5260.namprd15.prod.outlook.com (2603:10b6:806:239::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Fri, 5 Nov
 2021 22:52:42 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::30d5:5bb:f0af:d953]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::30d5:5bb:f0af:d953%9]) with mapi id 15.20.4669.013; Fri, 5 Nov 2021
 22:52:42 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <ast@fb.com>
CC:     Hengqi Chen <hengqi.chen@gmail.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "Kernel Team" <Kernel-team@fb.com>, KP Singh <kpsingh@kernel.org>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v4 bpf-next 1/2] bpf: introduce helper bpf_find_vma
Thread-Topic: [PATCH v4 bpf-next 1/2] bpf: introduce helper bpf_find_vma
Thread-Index: AQHX0cNmjspUhj3x/0iaOuPiWfpDeqv1DsAAgABhPICAAAFQgIAAGtqA
Date:   Fri, 5 Nov 2021 22:52:42 +0000
Message-ID: <4C63F03A-0561-430F-949E-FE65D69CE222@fb.com>
References: <20211104213138.2779620-1-songliubraving@fb.com>
 <20211104213138.2779620-2-songliubraving@fb.com>
 <6a6dd497-4592-7e28-72e0-ae253badba8b@gmail.com>
 <622ED3C4-7D40-46CF-B33E-32A73B0E0516@fb.com>
 <deed01c3-83aa-9d18-b803-ba0b427c58af@fb.com>
In-Reply-To: <deed01c3-83aa-9d18-b803-ba0b427c58af@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8f7af46a-11cb-40d2-d900-08d9a0aef9e7
x-ms-traffictypediagnostic: SA1PR15MB5260:
x-microsoft-antispam-prvs: <SA1PR15MB5260F712FF71EE769791AFD0B38E9@SA1PR15MB5260.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:2276;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zqftXVjg7pSmwjcWgSoX3XUUFNj0xbN+OvyzH0eLdzOhzQu7iYnjuRdWlhJkrU9dEpiO3ftOrwGPBdEzOztKPesYAlhcfeSsidc2Bm/LOF3eslusffv+9kqFnielVqsfACf/F44Q+zMa0uI7r9fSWSfVc59IXopRoGkoS45JAQsLBIsiPjr0ilWBQhlDngzOsC8H7qUU2Z51F+5MNy7+tnBXmnMxYE6yfDgzOjCl2ZUPXIR/B94pugl3v50Y9INk0IWfFKDTyxoAB13gtckWaR26NqPPdsV+ILM3Mfh55B5L0CuC24NQk+9M1on+taTFsqDX1pX+tsGftcvPN8vxDLbsa8tsvz/9xZiDPTKuS/F/acVYDi//+ORB2X6YY0YlJjjz5LgzXOsYGxg9Vuz6vVpQMaCcoR3rapbfnwTvwSIv2o40zrSiCjJvTR/a9RXljuBEmrrEUFb+dI/G2TJKx5YGmja8jy8sHflHP/v+DVgNzRumIlzHcqBr5AwwM9zPanC2thXOovxxFSdGt+sbdu0wdiQmXijuik0pzhqghs0cVCI0DLAZh9U2LHGSJAfsjqtlMEe7J3a9fhS6zHaBWcIr56StBqK07pBTvktzq7TxT1nutMTiohmdrkMfB9dazVSMqRIQUn04oM8De8Nb8YGiuz2On4tKVdTLuq3+rjAGlALzW9W7g5yoJOgEaMiwl8iGLZYQM5l7d7SDBF5fLm8nVj3t2Uh8JHguLnTDlP6ixDsvrxEZuAH0UrC3eoP4
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(6862004)(6512007)(122000001)(66946007)(37006003)(91956017)(316002)(76116006)(2906002)(86362001)(2616005)(38070700005)(71200400001)(4326008)(186003)(54906003)(36756003)(33656002)(8676002)(66446008)(6636002)(66556008)(64756008)(38100700002)(66476007)(5660300002)(8936002)(53546011)(6506007)(6486002)(83380400001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?mQHS/xVjXDsybkDyte3Ixx/HCrFCVy9I3ZeZaaoQ8FwtHK1FH5Cl2CS78FNN?=
 =?us-ascii?Q?EkUiCREpwR/+BDceD5npYhWlFE+h9nrQQcxbxBu4mrHd7Pef9g8xnpQPxFAw?=
 =?us-ascii?Q?TS1JNCiTUdi4grhFOq/tRtsB+do7vfovMNhy9ppphikmakkDq4gpnCSqn5Jp?=
 =?us-ascii?Q?roDsc1475g6BuKo5X633j70q8C/oqY0Fv7ImxDMIWLLoMmV5eCMqkSYEK7dW?=
 =?us-ascii?Q?dj90mGdrDd2P/miGZ2T9sjmCSL89VytqxGNSdZoVtNGRXR/sibir1DGrBKui?=
 =?us-ascii?Q?sy0icsPm0IaQtPMKLKFm9GkYgWaAryMTuuCLPea39Qmya+PFGRzpBpTX6oQx?=
 =?us-ascii?Q?jHH5h1S72NIP1Ls/R4h0n80BHIoIJHkaJohXCvupPXPz4XVMN3dZyohXuQZV?=
 =?us-ascii?Q?OxjMEGCJEVNTajhrCq5pP9R4Hf+gvfWzvK2mwrInKVTP7bjkkzCvpUPn1Pbo?=
 =?us-ascii?Q?JmVLdM0on1Mnf2221ftIzr4KtCalOTZ9HAPbHkUPFI0I/hw1F76v8ywgj46u?=
 =?us-ascii?Q?QQvGbHOXS8Q6HRIX5aRBOsAK6ePENPZ4MdwddOa7ggsPOR0CDNJKAZhfXX7O?=
 =?us-ascii?Q?V0QvKFG6oDqh5JATze1fXYSLfdQYhtpn1sFNJs773dVJoIzyF9kpYVg8kWsJ?=
 =?us-ascii?Q?kyPz8IuUYrAoBv4pPCdXbFHT3XkAKE5dYGoHqoCAIqVMmdQGlXEGxfc62Nzu?=
 =?us-ascii?Q?Df9iUADNJSL8016I7itxE9VhsvNGCJwtosqmoXgm+Evlq1lU0YDDMM5HHt+q?=
 =?us-ascii?Q?IYEPQSowyQU2lmoToO61bTVlSihXA3T/B6jHofknvHlmA49J75FNgPh5FZSB?=
 =?us-ascii?Q?JWBt+bbwx8plwRgafBuw4vSbxVlMDJgSaFdrBewhWYoS8Cx3f8Z+v1GgEauw?=
 =?us-ascii?Q?c5V2zvVos6WgCRNP8SuGL96V7coE2HQWv8YggGnofjRr0rHdfF0k8hgooPit?=
 =?us-ascii?Q?/gactjenNuevlorbrEZJee+Z0IGUNQWVn2tkg0qm/TDjNC9KzI8mGqQWHyCy?=
 =?us-ascii?Q?AUJNgx3Qw2gKwVTR9Q342usV4L1cUJWjGVjxxiGlSc0TuzHPNJFKTbRq96Vm?=
 =?us-ascii?Q?bnreg/CwSV3N/Q3j6wtv5BvLtX9vHsvyOKmBls0ZH7zsR9ZrU6kyFTzpromr?=
 =?us-ascii?Q?cjHlz9biKgQBfkI5+iCZwL9RWfEoCqRL5HK68sS287Wjv+V7CeL5c9Wqs9oQ?=
 =?us-ascii?Q?tG/DWMSCezQVWYSp331as60sYksHsBeqfSOyWcU7dWgxoxJCpjrSCt/PpmP9?=
 =?us-ascii?Q?HvEqrbdi4I7rP/7N2VqvjYuI0xffX4tUj/im1rVcDvWhC1LmqWe0OC0/72vM?=
 =?us-ascii?Q?N5fxrkaSQI1ozD8oc1L4mF6ixd6TFWeSJv3fAzKoqwfKEqzVxFgC2zCeC8Dk?=
 =?us-ascii?Q?l5iXp6xDY1RaNn3BS+zB7SMA9B6YoT56lPXr2Kz1YNjFkLyjWH98wfbGcfn/?=
 =?us-ascii?Q?kYcxN05vaCCBLlJXyw0JopCnftmSG30o8lTuXYfPQguPA4Q/TqRHM7df8SME?=
 =?us-ascii?Q?nXDCgWKFMDuVWR34FGHZ/o+Cyet1eOH79FPyypu3xhMo8Bmn/+4DWi9aCIbB?=
 =?us-ascii?Q?HuGy4h2w6h9zDoSrt9QL0Hjp9T23tZsQKtPXdHE4mpmAsWof520E1dtLFuNU?=
 =?us-ascii?Q?s55h3GbodzsBhlO8vDxFTpKyjXsxhIsgpONnHnqvPFW3aAezvBbWUhqslU/v?=
 =?us-ascii?Q?F3JYvA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <336E054471DBC04B810A691BAD24A5A8@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f7af46a-11cb-40d2-d900-08d9a0aef9e7
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2021 22:52:42.6085
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MXQRH+eaqrvjuwfpBJnFriFOGVIqJy8T+JGnZjjbZXSEbWbBK2gw2WZw003yRfvlprFO7VIayQ4rauadmosb+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5260
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: NSrEZmJC7yfcag1Wp8q3QswZsdCuK9ps
X-Proofpoint-GUID: NSrEZmJC7yfcag1Wp8q3QswZsdCuK9ps
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-05_03,2021-11-03_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 lowpriorityscore=0 impostorscore=0 malwarescore=0 phishscore=0 spamscore=0
 adultscore=0 mlxscore=0 bulkscore=0 suspectscore=0 priorityscore=1501
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111050123
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 5, 2021, at 2:16 PM, Alexei Starovoitov <ast@fb.com> wrote:
> 
> On 11/5/21 2:11 PM, Song Liu wrote:
>>> On Nov 5, 2021, at 8:23 AM, Hengqi Chen <hengqi.chen@gmail.com> wrote:
>>> 
>>> Hi, Song
>>> 
>>> On 2021/11/5 5:31 AM, Song Liu wrote:
>>>> In some profiler use cases, it is necessary to map an address to the
>>>> backing file, e.g., a shared library. bpf_find_vma helper provides a
>>>> flexible way to achieve this. bpf_find_vma maps an address of a task to
>>>> the vma (vm_area_struct) for this address, and feed the vma to an callback
>>>> BPF function. The callback function is necessary here, as we need to
>>>> ensure mmap_sem is unlocked.
>>>> 
>>>> It is necessary to lock mmap_sem for find_vma. To lock and unlock mmap_sem
>>>> safely when irqs are disable, we use the same mechanism as stackmap with
>>>> build_id. Specifically, when irqs are disabled, the unlocked is postponed
>>>> in an irq_work. Refactor stackmap.c so that the irq_work is shared among
>>>> bpf_find_vma and stackmap helpers.
>>>> 
>>>> Reported-by: kernel test robot <lkp@intel.com>
>>>> Signed-off-by: Song Liu <songliubraving@fb.com>
>>>> ---
>>> 
>>> [...]
>>> 
>>>> 
>>>> -BTF_ID_LIST(btf_task_file_ids)
>>>> -BTF_ID(struct, file)
>>>> -BTF_ID(struct, vm_area_struct)
>>>> -
>>>> static const struct bpf_iter_seq_info task_seq_info = {
>>>> 	.seq_ops		= &task_seq_ops,
>>>> 	.init_seq_private	= init_seq_pidns,
>>>> @@ -586,9 +583,74 @@ static struct bpf_iter_reg task_vma_reg_info = {
>>>> 	.seq_info		= &task_vma_seq_info,
>>>> };
>>>> 
>>>> +BPF_CALL_5(bpf_find_vma, struct task_struct *, task, u64, start,
>>>> +	   bpf_callback_t, callback_fn, void *, callback_ctx, u64, flags)
>>>> +{
>>>> +	struct mmap_unlock_irq_work *work = NULL;
>>>> +	struct vm_area_struct *vma;
>>>> +	bool irq_work_busy = false;
>>>> +	struct mm_struct *mm;
>>>> +	int ret = -ENOENT;
>>>> +
>>>> +	if (flags)
>>>> +		return -EINVAL;
>>>> +
>>>> +	if (!task)
>>>> +		return -ENOENT;
>>>> +
>>>> +	mm = task->mm;
>>>> +	if (!mm)
>>>> +		return -ENOENT;
>>>> +
>>>> +	irq_work_busy = bpf_mmap_unlock_get_irq_work(&work);
>>>> +
>>>> +	if (irq_work_busy || !mmap_read_trylock(mm))
>>>> +		return -EBUSY;
>>>> +
>>>> +	vma = find_vma(mm, start);
>>>> +
>>> 
>>> I found that when a BPF program attach to security_file_open which is in
>>> the bpf_d_path helper's allowlist, the bpf_d_path helper is also allowed
>>> to be called inside the callback function. So we can have this in callback
>>> function:
>>> 
>>>    bpf_d_path(&vma->vm_file->f_path, path, sizeof(path));
>>> 
>>> 
>>> I wonder whether there is a guarantee that vma->vm_file will never be null,
>>> as you said in the commit message, a backing file.
>> I don't think we can guarantee vma->vm_file never be NULL here, so this is
>> a real problem. Let me see how to fix it.
> 
> It's unrelated. There was a separate thread about this.

I see. I will not fix it here then. 

Thanks,
Song

