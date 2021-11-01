Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFC224423D2
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 00:12:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232539AbhKAXOs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 19:14:48 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:56682 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229684AbhKAXOr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 19:14:47 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A1GoVvX004904;
        Mon, 1 Nov 2021 16:12:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=AXFYiQ67TjAjTxfesIpvJZdtRO4M7l7FvASwDZhr18E=;
 b=qsDrbfn8bd3GVZ/vSE5EJ/B8D+6sk45lNK0PeWC8isRVu/M+EdSUft6BbF9Tv7pR1WzJ
 w3IV26bQqco2m1a+yT+kYmhI+b44VOyvsC01IbODXJ+smwi2D54pu3qlPwokxbdYKqeN
 0np7GctT1r7W2y8k4S95XSc9bsOm/SBIJFc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3c2gryv2bx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 01 Nov 2021 16:11:59 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Mon, 1 Nov 2021 16:11:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WfSunhvhCI7wvxCy9FR4nMFaJn+aqTPWDfMU+a6E9smbzLpU4ir5nwiS6uDXjvXy6iNA6h0XnHk5HkIiceD7XGtf6EZGLKIomvibkI/9LqTKydGSaPZYZOLWLh1DN0CfLmTMd+KyWlvyeo3l+/9z6jN+eWfkfMg+GJX9Og+u4BiCpy7hT/fn+4hufFKrngsA/7x3Y1f90c/pZ78lEfWDS23wmzGSJ0CotLgwVhFe2pkKWGa8EAErgIQhWnz2J/D+ky3tXJpNnoGPrSY4npB/4ODRJB6DatLCFPnsEb0AomqgfTyfluxdmfIHUvBADYhU3RTp7n0vIQ2qVPe8HdSaMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AXFYiQ67TjAjTxfesIpvJZdtRO4M7l7FvASwDZhr18E=;
 b=kNCcvj2VfRRTB9pPCFuGQifIhD5djIoPsNjOBonhqqE3/uuFPBAEpu5Q3T+trOrmflVVSyjvPft+0rz75axtKwYwxTuX/GRKX93+o+2q1gd/XmzVzGiKMkKOB8gIUtFOhrHrx9V1+CZEZbZTbt+1etsZzu7QWxjah/o241bqXIfnoaNTptsaqKa5PX13OefhA6l6ql39Vo/CFeU2NWBsbByLd3YlCku6nGu2H7JKyLINzmDZZYg6COwc0DkuwvMUg/wcC5WOdyniXala5FIcbNwQG/CsUY8Gfa2ucbcnleevpajdxJwWuBxGvDx7Gla5Jh8VTqL6Nwf6xL2MaAUx1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4869.namprd15.prod.outlook.com (2603:10b6:806:1d0::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Mon, 1 Nov
 2021 23:11:57 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::51ef:4b41:5aea:3f75]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::51ef:4b41:5aea:3f75%6]) with mapi id 15.20.4649.019; Mon, 1 Nov 2021
 23:11:57 +0000
Message-ID: <2f6df382-e752-2a53-0d2e-5d46c0567bff@fb.com>
Date:   Mon, 1 Nov 2021 16:11:54 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH v2 bpf-next 2/3] bpf: Fix propagation of signed bounds
 from 64-bit min/max into 32-bit.
Content-Language: en-US
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
References: <20211101222153.78759-1-alexei.starovoitov@gmail.com>
 <20211101222153.78759-2-alexei.starovoitov@gmail.com>
 <87ea129f-a861-5684-8071-cd3390375d3d@fb.com>
 <CAADnVQLYf-tqV7efxgeHQ8K_130r_v_8Zft2wBVBZn0EYOzm6A@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <CAADnVQLYf-tqV7efxgeHQ8K_130r_v_8Zft2wBVBZn0EYOzm6A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0290.namprd03.prod.outlook.com
 (2603:10b6:303:b5::25) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
Received: from [IPV6:2620:10d:c085:21e8::198e] (2620:10d:c090:400::5:38d3) by MW4PR03CA0290.namprd03.prod.outlook.com (2603:10b6:303:b5::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend Transport; Mon, 1 Nov 2021 23:11:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 37822633-7df2-4ba2-b51c-08d99d8d0098
X-MS-TrafficTypeDiagnostic: SA1PR15MB4869:
X-Microsoft-Antispam-PRVS: <SA1PR15MB48695DEA55822E4B359AD4C2D38A9@SA1PR15MB4869.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RWrJLnzI5XoFNQ7Jfdu3zJ4hWg+RDeTkdln70BbKsMRO21Emjwod5tzUqXTB5dOrUFT6YBVw71RmnggRHAj1i8mcltH4PgXNMlswCW/4qBaoxvyoH++wt4lwHAsccAC/+IK+N2BuiLYcxIacBZDCUOb7B4qoAGXtXLKvHHU4WLmeRgx0TGXB6KzGCajmZ7c5wQQ+uThQ7x/+gKSgSSfEeVN5zoGvTcM60dQk7ErKro7whU5UX6sD5HHScMY9w1BPK4Bd+qaC46wwGMoHjY8EL9woel41jfYyYqeKUZI33Q9ifBZFMxn88U9vMRMszfnjet2eL7Es4ZAOoOKzWxTi1ZTKU7Qy5Ue5Kb1JuvP7dGwizoMWyIhfsiCMNir78VSpiRrqrjnP9IgEJX8Yr9dNqWF2hPD4V8XMTQhIF037UAIwsabHzzy8CuYNfly9IpojwmtU3ubSqmhVh/9SDl7mmesB5F6hEi1JKVmwoKYPh3oXWpisTpjCpYRG5RZE1JJWE9Rr59cGYvwemy040qx61VvBdLj1NStoFnO04madgVPdbzYr4iJ88T5MKtCk9lJxsGKQwbXqvt6zhzkwyd8OR98tZYPoZtkf7zhjF00aLLFLqCA7tiOB10O1G/ZIANcAPAYx5UnAvbp8va4c0sgID/ZnX1YhyjbbcUB/jK34SyCqN7E7Qy8K8meWBXwx4sf2yU79Q7/5yudYK+GfcSYV0nXPZ/1/iFqgLWJkhk4f7Vs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(6486002)(66556008)(86362001)(4326008)(31696002)(8936002)(2616005)(8676002)(66476007)(38100700002)(5660300002)(83380400001)(52116002)(186003)(316002)(54906003)(53546011)(36756003)(2906002)(31686004)(4744005)(508600001)(6916009)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WXBRQXp4OWM0SmpvaVdmaXdOMktJbkFNY0lzUTZqL2hzWjBDc0tRa25Ndkxp?=
 =?utf-8?B?ekRUVUJRZmlPejg3WDNmcnVGL0t6YkVXQnBybFR1bi9rOHo3aStZaFhJUWZ6?=
 =?utf-8?B?cHNwZHdadTc2QXNKNUdaR1hKNmJmbWpSRjN3TVRwQnN1WXc2ZE5LRTBOSDVO?=
 =?utf-8?B?VmFZK2ltMDB6cStuMUNiSXR3L1J4SmxvcmZZK3ErbERIMllBTmQ5MnVwR3NC?=
 =?utf-8?B?clRhN2NBREliUTJHUzkwZENhR2oyU0dTa2U3YkNJd2h6Mnl1Vm5FNjVUaUV2?=
 =?utf-8?B?V2RmWUdOY0dZS1hyTHVEL1FEUjZEdEdGb2VMY1gzVk05WG83YlpYMzZycUxz?=
 =?utf-8?B?VThweWNLTFQyVkozMWRGUDUxMFIrclU4VGQ2a0RqQ284S21YT0RZUWVWWEZL?=
 =?utf-8?B?SWdGbHNTN2dmM2Q0S0IxcDVxeThOYmpxcGRwdW5YS0E5bENWblh5M1pMeUZ0?=
 =?utf-8?B?NElLMVYxTkM3SkszNENMdms2NGl6NjdLQXdTTmpZQ09USy9DUVl3OFFBWWFz?=
 =?utf-8?B?VlFCeUpYQy9qUEN0NEpJTEgvNkNqWnhiTGhNeHBuNTUwdGVOTDNZbCtGZjNo?=
 =?utf-8?B?empZU0d4SEJvVEh1TU1XaUhlcndmMWhxckdrbThsS3FjTms0MmM0VXdoeTVq?=
 =?utf-8?B?dkxGWnhiNEdUL1ZuRVIyS3Z0MytLME42ZksvM3NwZWlUKzZEZkFTQ3RhZUFX?=
 =?utf-8?B?QnRmb0Y1TWcvaUQ0SEtJbGx5RlVadFp4R0FBenYvcmpmMXJyWXhwZkxvVUt3?=
 =?utf-8?B?aGJjeDl2K21jOXRWM0JVeG9ZWWkrRUxVOUhralUzb09ZdlQzaEt0cFlJUjla?=
 =?utf-8?B?Qk56TWxhYUZ5RDROZ1hKVHB3L1YyOS9WdDZwKy9SV0h5WFVsZEE3b0djUG02?=
 =?utf-8?B?VlAyVS9MYjQvam54UkEwWlNLU3kveE84TGlFZTZGL295Kzc4cTBqRVcrWi9p?=
 =?utf-8?B?eUIxQU80V1hjZUMwT1ZoYi8zQW9EbXB1T2M5WjdVT0dLRld3ZllvdkEwem9C?=
 =?utf-8?B?TEQ0VERwTld4dkE5MUdvTnlNdDJxYmhTRzlkTDMzanYycURUWWcwR2lKdVdH?=
 =?utf-8?B?TXVKQ09scHpoK1dTM3FoZnpNdDY2bXE3UVlJbitWK0JkYlVXMDZwUDZLcmdW?=
 =?utf-8?B?RGRVRlpIaHZJQTZCVHRwK1hXdHlldE9uRFVnM0xqQUtkSGsyVEhpTTNIV0Vt?=
 =?utf-8?B?NXZ4YVQ2Z1pQU3ZTZGp5WUFyVnBQMmNUTE95Z0daYXNrZDJmQy83eHRudWhy?=
 =?utf-8?B?U0Q0K24zSzM0SEpFM090dlRjYzUvNFRpZFFQMGNJbi8yWUpTOWY5Z09lSXZy?=
 =?utf-8?B?RThabE0wcHFFRFFIOTdtS0c3MmZGMkZjSEZwZlA3MktVOSswc1pSWW9lY0l3?=
 =?utf-8?B?enJHVlRkTy9CYit0czRRS25pUkd4aDdpN3I4MnFVeTFjbFFVUkxJd1FxWlUz?=
 =?utf-8?B?VEUzVUlOdlNTcDdKL2xGbUgreFVJMGhFdGhhMWhMWkU2UUpIUlhLWHczcGx6?=
 =?utf-8?B?aU1SS0l4L0thRWNPRmRDUC9nREFaWFFuRnVub0luL1QrRGR0UGhRZm94SWZ2?=
 =?utf-8?B?NVI4R09CRUVDVjBrbXk3VnpCNDRJMitJaklvUHpYTlhybWF3d1ppSWQ5ME5m?=
 =?utf-8?B?ajFLZVJUaktsYnpQVXlzVlZ1L2pJdVBHVGI0Q05lc05ZRUVMTVVFWGZCUitU?=
 =?utf-8?B?RTlEanl3am16a2tkUW5aeUM0SkROcjFWNkZvdHJYN3dnNCt3UDZYc1B6Z1E5?=
 =?utf-8?B?Vzg1ZWdkUmdFaUtuaXFkcEJKN3JjVzUxL2tsWWx2VkpEMWdSVFlHd0VJWHg3?=
 =?utf-8?B?aUVqNE5ZcTNUc2ZyU2Jjc25iRlVseDRvY2lXMUs0YmdGNUFIdHVGejIyczVN?=
 =?utf-8?B?azZzby91RW0zemI3NzhzYlpHMm5JRlJaTWxXMkZCOVhtcUdxcE5CbnRyZUdN?=
 =?utf-8?B?VDVKWTdSV1hGTi9JWEMvVC93ME5EdkkwbTh0YS9EOURhc2Nlb0FYdTI3aEFL?=
 =?utf-8?B?UlQ5UndrMjIyUXFLTUU4UGZEUER6a2FIODYxSHZXZGwvMFFUQnNvVitTajE1?=
 =?utf-8?B?VTE0U2EzNXRDT3RCK29YaHhHZWp6VFU0R25DUk5wZ0VVTk1JR0NLK1JNNXp3?=
 =?utf-8?B?aFQ2N242VXRZUnJucnJnYmlWdXVHeGd3TjJKNWZFeHhKYldtWnRiV3BtMUI0?=
 =?utf-8?B?SWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 37822633-7df2-4ba2-b51c-08d99d8d0098
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2021 23:11:57.6972
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dEj+Lwbdckbyln/8yQHjldP6ZrpMgsYPnBNYxswZVCW4GHEDKH+Kf/EbAzRjD7ys
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4869
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: MfOyrA7SQj10c386_BkXdaoMiZ9IbgmM
X-Proofpoint-ORIG-GUID: MfOyrA7SQj10c386_BkXdaoMiZ9IbgmM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-01_08,2021-11-01_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 phishscore=0
 clxscore=1015 malwarescore=0 mlxlogscore=999 spamscore=0 impostorscore=0
 lowpriorityscore=0 adultscore=0 suspectscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111010122
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/1/21 4:06 PM, Alexei Starovoitov wrote:
> On Mon, Nov 1, 2021 at 4:03 PM Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 11/1/21 3:21 PM, Alexei Starovoitov wrote:
>>> From: Alexei Starovoitov <ast@kernel.org>
>>>
>>> Similar to unsigned bounds propagation fix signed bounds.
>>> The 'Fixes' tag is a hint. There is no security bug here.
>>> The verifier was too conservative.
>>>
>>> Fixes: 3f50f132d840 ("bpf: Verifier, do explicit ALU32 bounds tracking")
>>> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
>>
>> The change looks good. Should a new test_verifier test be added
>> to exercise the new change?
> 
> I think manually string comparing output the way VERBOSE_ACCEPT is doing
> is an overkill here.
> The real test case in .c will take some time to craft.

Okay. Sounds good to me.

Acked-by: Yonghong Song <yhs@fb.com>
