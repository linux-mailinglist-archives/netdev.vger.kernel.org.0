Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56FAC4B1519
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 19:17:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245625AbiBJSR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 13:17:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234495AbiBJSR0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 13:17:26 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2716E1169;
        Thu, 10 Feb 2022 10:17:27 -0800 (PST)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21AF7TFg006986;
        Thu, 10 Feb 2022 10:17:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=YRk8OZzjqdd7Ot3SuMcIgTf//U8f3XeAqoAecaXllVo=;
 b=EmzN9l4ZrNHuLu5TEOz8enD6K2IhsF6yjVWyJZRUaOHKbKreqYWrRkCesMFjzLUdd3ZE
 G2Jl/8cepmIWyrj1kB4alGAwrttafm1n0RdnfSzAl/8c3302mUMAK3kjtuqVKPrcrN80
 rKSzMkAvLZo49gGXaVplyBitep1ZtxW/wng= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e4fxb19yj-15
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 10 Feb 2022 10:17:08 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 10 Feb 2022 10:17:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KTkdklrzIYTx71R3gQnnJqmlRgZVgOOmIukJ3/3Lw1W+8z6HJ+yQC32B4jEHEa5VURrvOr3cTD+jPA8tVXtN5UmUtfUfJdSf+Y95vrNxQhAcsSFUj29haYI+qmlylwB1TEGJNFJr8IB2KmPZFNYGGt3PWTqeD+Gfgfi72+RL0ByNDIJIPDHhde7jcVB8s/6Jm7ciUl4y4tY3m1LgSHjUpv6/jrSt94Ba3OBA3uZW8pclmGJwnoqQSRGpmiwLr681LoE05TJxYIUbZ0M1KvsG0jehG8C5YiHtEDe+RflB42TrXbXSukypYBD0WObXMsbsOECnTKsukjo5sTUiAp15eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YRk8OZzjqdd7Ot3SuMcIgTf//U8f3XeAqoAecaXllVo=;
 b=lBXtxr81oEjjP9ZKK3OnEiv64u2tD3i1Bfi/nGWx4m006iZH8439kzaXKWv8tcJsPmKQMnzWnk3xgRTDBDiCve9u3E2k4Ch0/YwjRGLvydKWQvt7y+ciMk90uh24qCCfXtPjo2zOgttSt9qWSEqjY/qHNsDXphgiJAFbBrB+ceOndyDcVZAwqInzq0WKk/dNGpf6QEl2ZMWHHHTeXbIbETsHDOkhcU9GwbaAznDA2ZiXusN3Ef7U349IiacthcFR1MG34bkBCO4cQu5ggL6H7uc65gaABGhOFMzOohW9biqJqL+NwaR8FX8bwCA8IJMx0ldXCGurXtwMSnjHGnXgYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by DM6PR15MB3258.namprd15.prod.outlook.com (2603:10b6:5:16a::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18; Thu, 10 Feb
 2022 18:17:04 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f54e:cd09:acc2:1092]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f54e:cd09:acc2:1092%4]) with mapi id 15.20.4975.011; Thu, 10 Feb 2022
 18:17:04 +0000
Message-ID: <bb445e64-de50-e287-1acc-abfec4568775@fb.com>
Date:   Thu, 10 Feb 2022 10:17:00 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: BTF compatibility issue across builds
Content-Language: en-US
To:     =?UTF-8?Q?Michal_Such=c3=a1nek?= <msuchanek@suse.de>
CC:     Shung-Hsi Yu <shung-hsi.yu@suse.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
References: <YfK18x/XrYL4Vw8o@syu-laptop>
 <8d17226b-730f-5426-b1cc-99fe43483ed1@fb.com>
 <20220210100153.GA90679@kunlun.suse.cz>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220210100153.GA90679@kunlun.suse.cz>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MWHPR19CA0019.namprd19.prod.outlook.com
 (2603:10b6:300:d4::29) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fec4794a-5fa0-49a9-29a7-08d9ecc18a25
X-MS-TrafficTypeDiagnostic: DM6PR15MB3258:EE_
X-Microsoft-Antispam-PRVS: <DM6PR15MB32584CDB869EA8BDEC4E1CC3D32F9@DM6PR15MB3258.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mq9mAvZszrnxY/lzmPNMIg0d/3GpvKQzlggf+UKUduOqK5djjyF2oHLOTccdlUi4xK8oat5ge7Y/cwJAv1uM1wnVw+EDesv+bYfZq6lOM6uD062jorvSi1a/gIfnKyuUiLq1Gkg9ybmudtgg0D+kq5eUL+W4JmIfOqpmUaUUbetlutBo39QrTV3p4i2lqLO6F/8FrwvwEtqf0ms+q6eO2RHqibMDHNf6YNF2Uk4wUVz3uj8pqKBYef4n0x3THh2NIudn3QFydp3ca8IaYe7LrHiQbqFtc01PhC3Ob9m9hCBq7Fo6CwzGSKQp1jkv0Ej+eRcV5SugtMMQQVhabZ2FWlj3S6OJRtnzS3YsXJ/+dHTZldeVmO/6qNJ4rhmI+V1MRXOD+pVMmoVPc7Fr1oyFK2xSwM/vzms6oVT9WsIlyD/4SO6FLi+KYL3aN41fOSQB0YZaAK5dJALHsODyCwIxk53MPKr4FYdFkwjLTFojpRIyNMoUt6N5EFvai0RyEJ5sZtXzLcFOCquHdy/qjwsduQfSZ83GOxmF3DovLUn3YMrGG5ChOl5EfT3xo0nbti6VYnQnaOfZm2LuFMfDRojYD2+XxcbtLONbkBDpY0mqbRqDe+dR8n5A4ciA9yqQPxUf/VkQCRmaqHXcBiMtaaHcGuv+haOeMGC7g8mLmmPamwFcWLDwFv4IT7VN9Vx7w7bIjRJavOACUxiywluSaE81aT26irkgvWYGzSY9Iiu4/hMuUofzhAMo3N2H8Bv3Fvvk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2616005)(31686004)(8936002)(4326008)(66556008)(66574015)(66476007)(83380400001)(8676002)(36756003)(6486002)(508600001)(31696002)(38100700002)(54906003)(52116002)(6512007)(53546011)(86362001)(2906002)(6506007)(186003)(6916009)(66946007)(6666004)(316002)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UVpEQnRyOHkzekx0MlBaRjlORWxabUh4YVRybWNFR3lINVRxd1R0a01QUWtv?=
 =?utf-8?B?S2R4Rkt3WkpwbDBUekNsMTQrTHR5QWp3YnBtRXREY3hEaGZ3aFNQTmZGTlRj?=
 =?utf-8?B?blBtTmxxMy9XNVBTOXQ0MHNrL0hPUnhETnllclpXVXVkL0QxYmdzRXM4N2Nv?=
 =?utf-8?B?OUlVZnVLQUxUaFhBT3BRU0YxbDJqVG5uRlYyUmhXVTB0R285WlZUczdJMjY1?=
 =?utf-8?B?N2x5cHBoODFURGlsbk9uSnhYSEkxMnNnRVBtd1ZXS1drNlpxMEw2Wkl5dkcv?=
 =?utf-8?B?b0RVdmQzelpjMTZBMFF3ZmlGWDhwVUJBSkk4elhKTFpDbDlGUHdCRW5meTZs?=
 =?utf-8?B?bDlDemJ3S3ErbFhsakRNOEROc05TSmRsanEyTWVrU3FtRTViNWVFQ1B1S3pF?=
 =?utf-8?B?cXVIaWJqNkYyMUl0dy8vczBWSmpsVUZYbkRPdFFlb3hkd2RKdHh5WDVYNnpX?=
 =?utf-8?B?MTNrZEtMMUYwTWxKSVlaSFZ3cFdLa2Q3a0FuUDFtcGRVZjNnUXVnVlFpb3E4?=
 =?utf-8?B?VU5uVWk0d0dpNllKS1d6Y1ZyS28xYUk4TURmZEhGSWV5czc1MDBFd2Y5WjNm?=
 =?utf-8?B?SkVmcWljOVlhaXpUL1dYaTI0QUhpZDZ6SnZjeHRBeG5TamdRQzlPSnkvV2Nj?=
 =?utf-8?B?bTVrL29CWVNYK2JFVnJVM2svWVl4T3Q2OUppc3ptak0rTXVmcU9YOFowMzc2?=
 =?utf-8?B?S3JvRmdQRXE5OTVxR2JiVDllTXpSeWhPaTdKckNJVThXdU9ydGhhRkZ3ZFVO?=
 =?utf-8?B?V1lqUGxFeFk4dm9MZ0IxbmFQTEpIUmZXaEUrWmVESEN6RUwrU1RLbGI4ZENQ?=
 =?utf-8?B?TkZBVFNKbWhCZEhqMGhlcGhaK25TVE5wbzBIdzVSeTA4Ry90bTZKNHJ2Zy9h?=
 =?utf-8?B?VktxRkZ5UlhKQ05zK1BadWpINU9vV1dzU0RoeklyREpEaWZSNjNERHN4N21r?=
 =?utf-8?B?WDNWTEIzQjJXWHRDL24vUmpKNVdWV1pILzNtcmU0UlpiTjJ5ZjgwL0J6c0lB?=
 =?utf-8?B?R1BreXovK3NROWl6TlNtcHhsN3N6VWNMZVRFZEN6T3JSQjFZUzJkTk0rS2R0?=
 =?utf-8?B?dEN3ZHBYOU14S2wyQUptd0w2Zkt5TUo4WnBCalRJeGczYnBjaVYwRjBPblZm?=
 =?utf-8?B?ZFA5cStiRERzU3AraXJOemd4WVRxTkJIQmw5NEt3NGZsOGJXbnAxVFczZ3BY?=
 =?utf-8?B?SXJWYlJ4UTRtMzcrQkw4aENNMExIMEVOSFhoNjJpNjY4UU1EdDBOWm05Y1FH?=
 =?utf-8?B?RWlLaFJVejdoaFQzc1lIaUJaRWcrS3pvUkdJellzYzFWVDM4Y3lUaGJzcFlr?=
 =?utf-8?B?SUtJNDhOSzhQaFVEdDUzOW9XNlFXUkE4VXVWb21PdEhLcVJvSkx2RWEvZmha?=
 =?utf-8?B?N1U2V2YxNXZQRzQrUWlVbUxSeVAydHlRa3I4Y0xEQXQxcnQ3dXU5T2Fqam5Z?=
 =?utf-8?B?QWpta2VXSGJ0cXA0eUpTTndEVXN6T2dkNEVCMEgrbk0rOWhaM3pjcUhJSlNj?=
 =?utf-8?B?a0xMTVBoYldUazdLaENlOG1BbTNCQnVLVmZlZXVYaVJHamIweXJpeEZaT1o4?=
 =?utf-8?B?cjhzZGFzQmJTVXZRdS9wL2VxanZRYXBWMkJ6UHM1bzM2YjhSUFhRdjhwaE5T?=
 =?utf-8?B?NXVMVzN5SFdjL1g0dEdNSGM4aXZKM1FXeis1NnVQaldnWmgwVHlpREdvYld0?=
 =?utf-8?B?MUw1dWh1TmVCNUYzR1dJTHIvbUQ4MjFnbHkzQ2FlOWJFQzVjN1lMcTI2Nzh2?=
 =?utf-8?B?Q0dBNmJlaVRqalFmM3p5cEM1OHorU2RJMC8yRkpmeUN4WVdvUEwrYlNVVnRr?=
 =?utf-8?B?YUhkZjBrQTBFUTBXMUc1M1FDaTBmSk5TWi91SzZqQ1FWazVzY2RZeTVGT3dq?=
 =?utf-8?B?Qk1UQ0N3dHNpNTZ0elZuZzVkUmxOUXNlNE1NVSt1ZDFrNWl2M0pkS0d0R2Zy?=
 =?utf-8?B?S2NTVVZ6akFITTdaVklxRmYwbEVrYzNOSHhwbGRwQTVlTVI5MmZOWjN1Vno0?=
 =?utf-8?B?a0ZyMjdpNitzbzhiZXlkMDA5cFhBWFV4cDJIK1lnWjk4eXgvK3RNQWpha0hB?=
 =?utf-8?B?QW9OQnpQSllhTVl4UnlDdGhpRFBhUVUyMVRldkZ4K1Q4akdpaTZJbWFObVor?=
 =?utf-8?B?ZlNiaTZ2US8yQXAyQzVPWFIxMjA4MEU3b3d4RDl4Skg0U1UzVk5nc0pxMDl0?=
 =?utf-8?B?Zmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fec4794a-5fa0-49a9-29a7-08d9ecc18a25
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 18:17:04.1576
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FxrCrkKVdHvOU/jxx2PlCsJZPJ6qIpPR8+0A3SEoDGM8HlTA4Y87TmxUVYsE/kav
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3258
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: jhnb_dKmoZl5cEAhLLJIHNNVzNy_Z9ia
X-Proofpoint-GUID: jhnb_dKmoZl5cEAhLLJIHNNVzNy_Z9ia
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-10_08,2022-02-09_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 spamscore=0 mlxscore=0
 priorityscore=1501 suspectscore=0 phishscore=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 clxscore=1011 impostorscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202100096
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/10/22 2:01 AM, Michal Suchánek wrote:
> Hello,
> 
> On Mon, Jan 31, 2022 at 09:36:44AM -0800, Yonghong Song wrote:
>>
>>
>> On 1/27/22 7:10 AM, Shung-Hsi Yu wrote:
>>> Hi,
>>>
>>> We recently run into module load failure related to split BTF on openSUSE
>>> Tumbleweed[1], which I believe is something that may also happen on other
>>> rolling distros.
>>>
>>> The error looks like the follow (though failure is not limited to ipheth)
>>>
>>>       BPF:[103111] STRUCT BPF:size=152 vlen=2 BPF: BPF:Invalid name BPF:
>>>
>>>       failed to validate module [ipheth] BTF: -22
>>>
>>> The error comes down to trying to load BTF of *kernel modules from a
>>> different build* than the runtime kernel (but the source is the same), where
>>> the base BTF of the two build is different.
>>>
>>> While it may be too far stretched to call this a bug, solving this might
>>> make BTF adoption easier. I'd natively think that we could further split
>>> base BTF into two part to avoid this issue, where .BTF only contain exported
>>> types, and the other (still residing in vmlinux) holds the unexported types.
>>
>> What is the exported types? The types used by export symbols?
>> This for sure will increase btf handling complexity.
> 
> And it will not actually help.
> 
> We have modversion ABI which checks the checksum of the symbols that the
> module imports and fails the load if the checksum for these symbols does
> not match. It's not concerned with symbols not exported, it's not
> concerned with symbols not used by the module. This is something that is
> sustainable across kernel rebuilds with minor fixes/features and what
> distributions watch for.
> 
> Now with BTF the situation is vastly different. There are at least three
> bugs:
> 
>   - The BTF check is global for all symbols, not for the symbols the
>     module uses. This is not sustainable. Given the BTF is supposed to
>     allow linking BPF programs that were built in completely different
>     environment with the kernel it is completely within the scope of BTF
>     to solve this problem, it's just neglected.
>   - It is possible to load modules with no BTF but not modules with
>     non-matching BTF. Surely the non-matching BTF could be discarded.
>   - BTF is part of vermagic. This is completely pointless since modules
>     without BTF can be loaded on BTF kernel. Surely it would not be too
>     difficult to do the reverse as well. Given BTF must pass extra check
>     to be used having it in vermagic is just useless moise.
> 
>>> Does that sound like something reasonable to work on?
>>>
>>>
>>> ## Root case (in case anyone is interested in a verbose version)
>>>
>>> On openSUSE Tumbleweed there can be several builds of the same source. Since
>>> the source is the same, the binaries are simply replaced when a package with
>>> a larger build number is installed during upgrade.
>>>
>>> In our case, a rebuild is triggered[2], and resulted in changes in base BTF.
>>> More precisely, the BTF_KIND_FUNC{,_PROTO} of i2c_smbus_check_pec(u8 cpec,
>>> struct i2c_msg *msg) and inet_lhash2_bucket_sk(struct inet_hashinfo *h,
>>> struct sock *sk) was added to the base BTF of 5.15.12-1.3. Those functions
>>> are previously missing in base BTF of 5.15.12-1.1.
>>
>> As stated in [2] below, I think we should understand why rebuild is
>> triggered. If the rebuild for vmlinux is triggered, why the modules cannot
>> be rebuild at the same time?
> 
> They do get rebuilt. However, if you are running the kernel and install
> the update you get the new modules with the old kernel. If the install
> script fails to copy the kernel to your EFI partition based on the fact
> a kernel with the same filename is alreasy there you get the same.
> 
> If you have 'stable' distribution adding new symbols is normal and it
> does not break module loading without BTF but it breaks BTF.

Okay, I see. One possible solution is that if kernel module btf
does not match vmlinux btf, the kernel module btf will be ignored
with a dmesg warning but kernel module load will proceed as normal.
I think this might be also useful for bpf lskel kernel modules as
well which tries to be portable (with CO-RE) for different kernels.

Alexei, what do you think?

> 
> Thanks
> 
> Michal
