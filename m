Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCAA13DA7DC
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 17:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237977AbhG2PvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 11:51:07 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:13628 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237669AbhG2PvE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 11:51:04 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16TFmso3023412;
        Thu, 29 Jul 2021 08:50:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=qbMSiR3hLc0Zy/VYgM/9925+mZAd4cWU1oFkIWGFPKE=;
 b=LXuNZoNMAhegTwT/Qy9med7iQl8fH2JKN/411a3mAj5W37nDEL4rpYaGdL3dSDK26IgZ
 4AFAx2OVPcFMLVw6wL7QU0uEljIMzHUKwAV0UIPYb/UeSE0nXEnA/VTe2FvWX6jGjR4x
 SnG/vgZtWGYmB00MdFlKnu9poovakQ61rWE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3a3cddxewc-15
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 29 Jul 2021 08:50:48 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 29 Jul 2021 08:50:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z32BqoBvB0arKfrTnRk+tv5nDk4visUDpqhhNss+Ir+WGL37XleRVDOuQy9L5YkW06Y9Fp8jeP+OwWbALLZn4+eYMEtAfrzbpQGcQP8331Ia+eqtb1BrHHnQDvzM11wtA6MFUpVweX0SxobKQXUuMUYUSGFDp026Q5z+vAeuXyOF+V60OVhXZ9zYMIJbwYHF0sDzpS4sN0pts3ZQD7kjUOCqwVo3oHxRbN6Hxoys5uwDjZ5UY59M6YtDSDXTUiqkL5CxCDEkMSQU8etlmLOsI8MUa0DY5aP9NCd8GVzXc3bxuWRSnxBHx4BVBlRDFykCD3l9FGw9QOJckowYzNG/sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qbMSiR3hLc0Zy/VYgM/9925+mZAd4cWU1oFkIWGFPKE=;
 b=dMNgnWrPM2UavxTPkXLQcllit0ND0O7J8XTAiBu7Sq0mD5RRnoXoKQ/BemeqzJ+soCAYHSX7sSR281paizsmTAJhUZyhMP30lJgum1XAK18AWY0J1d2xX/eOlBUrpmpKsxRrHRemNSrkzvcv1x0p5moE2XJ+okv2d43e28IRxZGYjGzZL0JKM5Ktq3aJqY6RS2DhJlTbZ7d3bBMcyaXDT/XuJuwevwr8MshAbsXNyT3GBB/0RAe57KhDzDf8eRoMagz6dYv/XchPboi4hf6mHsyRz3KY/5r7DpUVVEKrK6NPHWKAiP+6+pGLhymopPlTcgbpwT4XtN5/qPAbxcYF7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4919.namprd15.prod.outlook.com (2603:10b6:806:1d2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.20; Thu, 29 Jul
 2021 15:50:46 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb%7]) with mapi id 15.20.4373.021; Thu, 29 Jul 2021
 15:50:46 +0000
Subject: Re: [PATCH 11/14] bpf/tests: Add test for 32-bit context pointer
 argument passing
To:     Johan Almbladh <johan.almbladh@anyfinetworks.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Tony Ambardar <Tony.Ambardar@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <20210728170502.351010-1-johan.almbladh@anyfinetworks.com>
 <20210728170502.351010-12-johan.almbladh@anyfinetworks.com>
 <deee75a2-a4ce-303c-981a-cd5b6e8cecdf@fb.com>
 <CAM1=_QSDhFQ6EBOi5F3cM9xEoxNFpX_4uCM71cUiOaurRpH0iw@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <79d4e1d1-7dd1-f234-54e3-6edbf799474b@fb.com>
Date:   Thu, 29 Jul 2021 08:50:44 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
In-Reply-To: <CAM1=_QSDhFQ6EBOi5F3cM9xEoxNFpX_4uCM71cUiOaurRpH0iw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR13CA0006.namprd13.prod.outlook.com
 (2603:10b6:a03:180::19) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21d6::11d1] (2620:10d:c090:400::5:81b5) by BY5PR13CA0006.namprd13.prod.outlook.com (2603:10b6:a03:180::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.6 via Frontend Transport; Thu, 29 Jul 2021 15:50:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5c9bfd6c-c918-4282-3cf9-08d952a8a154
X-MS-TrafficTypeDiagnostic: SA1PR15MB4919:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB4919B61168E804B065D10114D3EB9@SA1PR15MB4919.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FsD+KQkYNiLuW6+pWzf4N9SG2hvqrVfZujNetNS3p6UpuDppo4ZM+5KJWPsEusoPLgvn294BTilFg6S2AU6naAaCvXG7HS4YyDkzkeb9JxeL0phPYHS15KZXPez1XILsvGdBgId6XRFZw47Al+pXdpj2fcwuUIpKoJ/Di+fpIQ/D8C5+9ppt7pYKzibYL3V3x6EdSGcNOSnMPVP/GXhrpNaDMWdoZNLPSbOgTnYpCefemOpwmclAA3mJGLJcsy39WMezLPc94iFJP42Na0FXcZXD9RxNuLILKi5+Su3g0DqG3TXPzM3Sz/+UdsC7KpYRcvcZPvPAea9uWZbJq6UaIKXjSVY837Msxmjsv9sI76+z+iGDQqAwJjHNPwGxWKXyT6yBk66HO7M8dh/4Hj42jDWDUaKbsIBnnD3H2RAY2I65OHlTuZBv0SJi6Mm1wP2+NQ8weR6wGna/rIF6oFpTKJ6KPmNwVVNfXLL2kfOlBHM5vAVQf2UP7jpQOEyWjZ/I7GPPMDPeEDhBqxVSUtvZpR/jtp57YKPygzQUbcOHnRHk/qFhhbpdnkiExtueq29/DG/5KLY3hxq1iahBs85IdHXshUnscA9om8C+m46FzHJ694QoQeJTCALaMKAW7egvouEbkcB9n/3PjVIssnsmnFpT0grHyA6/q4aWF+y62ZopIMnKE/BaJRRquIwrxSdco79oMifZKyVc+wJTvRcR13xQ2oMz/8geFXPzW1BGMqQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(366004)(346002)(396003)(39860400002)(53546011)(8676002)(2906002)(31686004)(186003)(66476007)(6916009)(2616005)(6486002)(4744005)(66556008)(36756003)(478600001)(4326008)(86362001)(8936002)(316002)(54906003)(38100700002)(66946007)(52116002)(5660300002)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bERJU3I0Mi9pT2dicEsybGdvZTAyWDBXWUg2Ni8vSUN5cUJnMzBPb1NkMVgy?=
 =?utf-8?B?VU5YRE9tTi9tNVVacWV3Y0ZOTGhKM3FPd1FqeGlGdWFZZDZBSzAwMzhlY2JK?=
 =?utf-8?B?a0M1MDZJY1BBdk9nU0FCaktQRVhiUW50aW5pK3pETlROemNwbUNaQWdoaHdv?=
 =?utf-8?B?ZGl0L3dyZWpqUEZudnFpM1prMEc1Z3VFOEl2d2ErUjhReTF2UGp4Wlp1NGFx?=
 =?utf-8?B?cTBycVhSRURvb3NQeHZ0UURNZGp2YW4zUWcvMHgrTzU2VlpDb256UXpHYWg0?=
 =?utf-8?B?eWtoZkppbndCWjg3N0ZRMVhpWXk2QlVsMXdyL0ZVdnFQcFhXZjFVVXV4UnA3?=
 =?utf-8?B?YTZZU1VVZlJBQ3RiOWdCNEtUcHRhdlU0SkdKWXNXRVRqQlpjamJXQmN4YzRO?=
 =?utf-8?B?MnhOUjdpUnd0ayszeTd3NjlYR2x4clY5U0VCQ1E2bEhISzFLaHlBTE1ndnBK?=
 =?utf-8?B?bkUxbWVLTU82YnoxOFBSTlBxUVYwWUU1aHh5NjRFV3pQSlpVUVl4K0t2TUEz?=
 =?utf-8?B?ak5xTC9EeTdxNVNUMDdBdnZkQURjbU5Gd0loN3NTMlBBL21FMUdoaVE1TFBi?=
 =?utf-8?B?STRTS2hjQWU1aTllNjRqZ3N3QU5yZWVNMmZIZHBweUJDR1ZFUS81Tk9TbEw4?=
 =?utf-8?B?c2RlcHhiL1lhK1VNNHduVXlyZmhpdWYwU2NMQnJJMm9HVDYyM0NKOXlLcmZX?=
 =?utf-8?B?cVowS2UxVlZZRVVnZlFGbnh6UVZjdTk2VFU1dzNiTmFMV3hzQ1JVaHB3T1ZV?=
 =?utf-8?B?VEpVaTB3MTF5TEpoRUVQOXcza2xSZHBjQ0gzaStPZGN3ejQybFZNalVvSDdZ?=
 =?utf-8?B?L2V5bmVMVURtNVN6WUthNitRNFVHWlRpcDdhb1o4Z09KRjBhcGNSS3BKZHlE?=
 =?utf-8?B?a09vc25xVGZrb1ZhTnFuVEtvOVJoQmw1UVhXNHF2L3ozd2tUYlpyZWd0WFRX?=
 =?utf-8?B?SCthKzVQZXp5d1NMV05STGY2RTUzbTBaa0k5Rk9COGJnTklSSTZQdGhVNW1t?=
 =?utf-8?B?VnVKNjh5SXlGTGFXVEp3ZHJTSllrcU5jNjFtaVFLVHpLNEh2NWNzVnRQaTBw?=
 =?utf-8?B?bStXcXViWVd6TEROVVJlY2VVRFVGemJES1lnU1A0RXkwRHNYN2VnOEh0N0dl?=
 =?utf-8?B?VDkramV4R0FOdGpLZTNBczlGci81ZE5zbUFlUjJqWGpZcnIxbUk3NWlyUVc5?=
 =?utf-8?B?KzZrV1NQOXNudWRrMTRzenUzdXROZDhBZUtyRnVYd0pWM3Npbm44TVAwdXVK?=
 =?utf-8?B?ZEsrdVlod3JONE1US2NzZmZETGZEYU10eDVqeWdYdVNhR2c4b0EwUEpqTmVs?=
 =?utf-8?B?VlhQUGtyWTVqcFdwZUNVNTk5ekV5cFRTTmVkUEtCTjBkdStHKytJTHZENFU3?=
 =?utf-8?B?b0JNWjlLNmdYMWo4Yk5WaEtVd05sTlBuNnRsMVNUaHNLaUNCSllCb0dEenJ6?=
 =?utf-8?B?S2R1RERGMmYyVGVCWHh3WGp3cHRWUDdDVmJVOHJVT01JWkdrYTBhL3YwTkRT?=
 =?utf-8?B?VkFLNm9acVZYb1NWcE1XU1VZenkxM1k1aDNGTzhaOHpqQUxPOEdqeVNBOVhv?=
 =?utf-8?B?QStXUTc5WmZuS1RYYTAzakUyWHIzcjFoMnNOVStTa0ZHbC9OQ05RSWdnUVMw?=
 =?utf-8?B?Mk5xTDhoWm5nbW1ia1duNHZuYllpMm5Dby9PMHFQYWtCa1JpL0hoSWVxUDVC?=
 =?utf-8?B?cklnK0ZaYkw5bTJ4elJqRmhUVGZncllFRUpxUFlJU01XN3gyMXoyYlgxRmVV?=
 =?utf-8?B?TmNnWkt1T0NLN0Z2cnZaSUc3c29kdU5lbXg3VVh0QWZHV3d5bmxHWU5hMW9i?=
 =?utf-8?Q?Bws6h/sLscrMfEsKyScvC1Z0YXXuRfVbp1oGM=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c9bfd6c-c918-4282-3cf9-08d952a8a154
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2021 15:50:46.5550
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OLaCZyatkBNd0Bn9GaIWG6RaY78nkylwxQqTp2Kmyar7l5y/lPlqdOyDflkrBlrM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4919
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: gzzMfhGg7JrXVu0HBa32jeOd7Ct81VpV
X-Proofpoint-GUID: gzzMfhGg7JrXVu0HBa32jeOd7Ct81VpV
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-29_10:2021-07-29,2021-07-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 lowpriorityscore=0 adultscore=0 clxscore=1015 impostorscore=0
 priorityscore=1501 mlxlogscore=843 phishscore=0 mlxscore=0 malwarescore=0
 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107290099
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/29/21 6:29 AM, Johan Almbladh wrote:
> On Thu, Jul 29, 2021 at 2:09 AM Yonghong Song <yhs@fb.com> wrote:
>> On 7/28/21 10:04 AM, Johan Almbladh wrote:
>>> On a 32-bit architecture, the context pointer should occupy the low
>>> half of R0, and the other half should be zero.
>>
>> I think this is probably true. The word choice "should" indicates
>> this doesn't need to be the case if people choose a different
>> implementation, right?
>>
> 
> Right. To the best of my knowledge this is true. I can change the
> wording to "will" to remove the ambiguity.

Sounds good. thanks!
