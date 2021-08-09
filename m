Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51B673E4DDE
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 22:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236235AbhHIUdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 16:33:17 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:28616 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234678AbhHIUdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 16:33:16 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 179KTdn0018019;
        Mon, 9 Aug 2021 20:30:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=6H9usHMpIzmzFlxEr4cFoJDKdwLHyacFy5+4lPkNiLc=;
 b=mUaKh6pQVBnO8DUZSL/EQcAwaVa4bm/wvftzZ2x/gKBZYCQ4ADFeYFQJoA7OUm4YwG8v
 KfL6+vRg4TltesD92dwoSWpfPXf+OQBwK6rVyMzbNVfrUdabJbXPiF34DnyVsGM6Dkyc
 AQCuqE3KCghKyP39dUB3hRiIzgVMuItIJrtb7gb2HKyth7Su2f+X7ettuJDViy1HbrDB
 Kg7Pcd4MNWVz/fi1OxfZNpG9bNgPTJY9D1Tv2nTvD/dwM1I3oi/GnZ5EFp0pvfmTiwBT
 hWDqFf/5swyp0cSyaC6NSFWFtcTpHT+BlKhWuzEVLDWZ8i6qzXedV3fri0kpluEX5HEn 2w== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=6H9usHMpIzmzFlxEr4cFoJDKdwLHyacFy5+4lPkNiLc=;
 b=Y4sAaqmP+2YCCFzK1a9SIlMoA13Nfrab7NZ5HWorJkOsG3MKjxXD0LUOlMcL2YVDOuRg
 GhkPRMZwEy8x/1PS73NUInt/oGUi0M2Ys/Wl9Vrb+B1KeydvGoHAAwWhddnqDhsHO9Sl
 cZbwnCkb+I6338hLXJIF9YAhb1ivi1pQ2QIcbkWy64JZlmg2/WGcoBvjfeIExEAOu+L1
 B8fCIGgZ88c8yWpfhr4P/DG9ymJ8NOUxFqu3xknPGNVyKHFV9LG68lCPVfBmpj2gz/t4
 /IoY+8MoETVbffXr0+Z/I1IehOLPYbDMdD2UFx+XFEWlJcZJle4tf4FO6DFI6zjhNvYo dA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aay0fsyuw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Aug 2021 20:30:34 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 179KUT5N128134;
        Mon, 9 Aug 2021 20:30:33 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by aserp3030.oracle.com with ESMTP id 3aa8qrwm6e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Aug 2021 20:30:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J03Aglw3bmlf7e+CdvQIjpyLuqtfR7bOQuzR5tTa1HASM/bpvMmBDs1tAGSfKaX+FkTUwx9J5FZ0hWWXBJ0l4snQ1nrZk615At9qk2fy5Xa6fKOJqqj0S6DMLYg/PCACepYSdqM7RZ3ikW0porkOLMAkmqdxvizJQ1Uztgj2im5TrwwzfVqDUyAg53RbmnuwzNIbI2McipOt5GRoBZ+vCS5DwaQYqoRLGxtfA1NDiWyOnx7Svi99klJIS164pnL4VXDPu2LqD8oxjIW4t9IfieRekdkIHiuVeiU0oHgB7CIjkO5hNbvY2DseUdx5H5Ou/txGx2tGi8mXtCa/+p/SHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6H9usHMpIzmzFlxEr4cFoJDKdwLHyacFy5+4lPkNiLc=;
 b=gJRkplNv1i90Eb3r0HgYqIAL+rIHcHuQG4Bu8pY2AdgXqv3x3QChVY6D10qa6iaMEAKLWFbcnN3tla+A3+D/BLdLqLBqIVsa2NfTMt6mcGNws7jC/AvUfAv/rh2m+QvpQ6VpyxcSyY8pPT9sfhOkj9EWxPBqN6V3PiMGRFWxAy4vugh2Nh7Q1eUhxhksiNvJNdHBDpLwNjorXY9WAN/MglyFTHMW0lZk2f3Tu7iZ0DVv2e5nyd0i6wjjsQCsTun8IqLcRBoTSyjkFvLax9sHKJnpD387f/+wMM5d+iWM/j+8yoxJeOob7NHaOdxM6v4RJq2jcgtyc+6QBj4e49/TrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6H9usHMpIzmzFlxEr4cFoJDKdwLHyacFy5+4lPkNiLc=;
 b=Im73k3YdluEeZ3792hhqGAQRyn8wsssAaueU7uWjXrY9Wym1ww/jruwbmMGGANSHzkFMdAgPII18u8kRamEADnww0KJhf+gHX5MF45Lt/rZfDzhUZUoJOBvew7BSGp2NzkWO08f2QB/7LyR8Yi/pnQdtaJ+ANejNmq+3NtDA8aI=
Authentication-Results: fb.com; dkim=none (message not signed)
 header.d=none;fb.com; dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com (2603:10b6:a03:2d4::12)
 by BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Mon, 9 Aug
 2021 20:30:25 +0000
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::588f:a774:17de:1d1b]) by SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::588f:a774:17de:1d1b%3]) with mapi id 15.20.4394.023; Mon, 9 Aug 2021
 20:30:25 +0000
Subject: Re: [syzbot] BUG: sleeping function called from invalid context in
 _copy_to_iter
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+8760ca6c1ee783ac4abd@syzkaller.appspotmail.com>,
        andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        christian.brauner@ubuntu.com, cong.wang@bytedance.com,
        daniel@iogearbox.net, davem@davemloft.net, edumazet@google.com,
        jamorris@linux.microsoft.com, john.fastabend@gmail.com,
        kafai@fb.com, kpsingh@kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, shuah@kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
References: <0000000000006bd0b305c914c3dc@google.com>
 <0c106e6c-672f-474e-5815-97b65596139d@oracle.com>
 <CACT4Y+bK61B3r5Rx150FwKt5WJ8T-q-X0nC-r=oH7x4ZU5vdVw@mail.gmail.com>
 <e99cc036-2f83-ff9e-ea68-3eeb19bd4147@oracle.com>
 <CACT4Y+bFLFg9WUiGWq=8ubKFug47=XNjqQJkTX3v1Hos0r+Z_A@mail.gmail.com>
 <2901262f-1ba7-74c0-e5fc-394b65414d12@oracle.com>
 <YRGKWP7/n7+st7Ko@zeniv-ca.linux.org.uk>
 <YRGNIduUvw/kCLIU@zeniv-ca.linux.org.uk>
From:   Shoaib Rao <rao.shoaib@oracle.com>
Message-ID: <e5eb45b7-18e4-4a8d-7715-5b5b9f0a5bd5@oracle.com>
Date:   Mon, 9 Aug 2021 13:30:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <YRGNIduUvw/kCLIU@zeniv-ca.linux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: SA0PR11CA0020.namprd11.prod.outlook.com
 (2603:10b6:806:d3::25) To SJ0PR10MB4494.namprd10.prod.outlook.com
 (2603:10b6:a03:2d4::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2606:b400:400:744d:8000::918] (2606:b400:8301:1010::16aa) by SA0PR11CA0020.namprd11.prod.outlook.com (2603:10b6:806:d3::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Mon, 9 Aug 2021 20:30:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: de3dd82d-46e4-47aa-fc2f-08d95b748493
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:
X-Microsoft-Antispam-PRVS: <BY5PR10MB43069675CACF21C25E8406BEEFF69@BY5PR10MB4306.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o+DF7h8fsDQdIN0Dc1i+xv24MPKNf9n54R8g12nnI7r5z6s/prwHTsX5yyQlarlauzLNkWpLFTzKML/7IKMKvamf8M40sD/vOUtl6715WUEQpbXxMYzvEXkCVMS1lJ+ebiOgyrn022JSL3gi+QnVx4G04vL3huicLuJHUUv+9oh9kX1po+bpdQdSB21g7oBq7ipnXINhfu11l6SnSLVWafTLiABp23a2MddllMA/f9zom4m/LWhyUjOPsGznJoM++1Uq6COe7HhSLW4kb50b6jIokJAPepGfJJPfStSbti5S64xG3wIUWRg1wJILMQx4Cempig/+Ktu6iY6za1pS40LvGDJFyVnFfmrNJvEprbmfBXhcx7d9TWCCPiAW6/IaJ7c2pO/mGlp4eTtTsVrniIbeAo5Yf88DvFVlc4dtL6mjY/NJWve0W5r9oCEXnq+1qDbGLq1jpZheXVpHI6WAiAmpw9eejMR7GxwyKQYezORUOW67L2NDpANxVZMchTwSwpleZC5znE5kupYFs6OZ7l1XD7ZOK5Jnb0CfDG3Kh1qNmX5y7eODrc2QGUunoxgZcZFB7nYNOSLfzhTSR5hNdLVDkn+1rgOPPcOiqFN3nuqJ1SHvv2DV28S2k/z9LS3lwxLvQGgN7mKcef+0AEBRknozUgjR/cseCCn/fzRPXt8ADE96bD8JxpexH+/QLTHcj/AISuZhOwWE60IZimJeR5EpM4TrR5GoHDHWNmz0r7LzljkbncOM3RxUhzpACd0t
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4494.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(396003)(346002)(39860400002)(136003)(5660300002)(66476007)(186003)(66946007)(66556008)(83380400001)(316002)(2906002)(54906003)(53546011)(4326008)(478600001)(2616005)(38100700002)(6486002)(31686004)(86362001)(36756003)(7416002)(8676002)(8936002)(31696002)(6916009)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UDAwV1lLRVBZRmNIMnorWnF5V2hSMGFWMTkwWlZ0YXpob1hQd0lhZlJsaUE4?=
 =?utf-8?B?R0FGQmRDZStxbXBaUTRYZThjUGRHbFlFangvKzN2azZCOFVkVE9ITEFWT1F1?=
 =?utf-8?B?eVRUQnQ2M1g1TEFjUDA0NzI4VG1lWEJqaWpVZGRHUHdpOWg1eGZVbWxKTVNz?=
 =?utf-8?B?a3dxNktycDhwaWtrZmY2REkwaWZneHU4N0MyMk1TaUt3MVM3eXBxUFEzN2VU?=
 =?utf-8?B?dkR4ZFBod2o5dFk2UHlCRGlYaGVlMEVDNncwWEdFTW96bWdBTS9Ib25neVhp?=
 =?utf-8?B?ZkNQRmZta2dqWjZSaUFEMkgvaDFkSDJHcWZpQXRqanJMMHNoaEJESmZZdmVx?=
 =?utf-8?B?OWpOYjFxRDcvVS9BT1B2eHRUUlo1MDdMZ1YrSW9qNVBib0pHZUg4K2NtbFdh?=
 =?utf-8?B?YlYrUmNuY2VJallOamhSV3oyRHF3TUsrZTNlaE1TcXROaE15NVFNZmlRclo0?=
 =?utf-8?B?bXdPdSs0L0R0MTFMQzE3M3lNUDB4SnRvN3Q3ZEsrZmxBQ0YrZ1ZFT2VMOWM5?=
 =?utf-8?B?Z1dLVk9sMUNNeGJtaVNLRGFxT1hSYXdXeW1haFJLSUpPYmsvYXErTGIyd3g3?=
 =?utf-8?B?Z2M4YXd6Q0VYdVQzazVXVlhCS2o3cDlncGU2bFRxaVArVWh0L2p2VjdJYXUw?=
 =?utf-8?B?NjlqcjllZ21RcWFZY3NOODBxQ0ZQcjlJSXZjQUJDbFRLanNwQ01DNGd4R1Fz?=
 =?utf-8?B?VlJGY0EyUnFCUTlYWStBWlpPaEdmeTNiNmJqb3JQRWpwSGZUZ1Jtc0JWWnNY?=
 =?utf-8?B?QjhYK2w0T2VOWjVrOURHV2lvdTFJalBpeHR3SjFyNUw2WVViL0hNSUx5bDZB?=
 =?utf-8?B?TUNoNE93NW9SRElsNlk4ZFdtT29rQVpoZlBlMVdmQTZjZlh5Z2ZQWGpEWkNv?=
 =?utf-8?B?Ukp1TWdzS0pxa0lsa1ZpdjB1MG5vaHBhMW1pWm5qckpLc2U3Ui9vWVhxWkZu?=
 =?utf-8?B?UWNjRlVheHVydXVDb3drZGFDK1NjbDVLMmoxbDNaU1BBUVpheitzb2tjakRi?=
 =?utf-8?B?QjFjV0ZtVmorbFZyYmtDbEUxUjgzQURuQjh3aWdDNDZrMDlFV3AyQ3RhMTdy?=
 =?utf-8?B?Z1NxTFpiRXdvaEk3NWNCRGkrMFdJU2xnZ09KaXhtM3NBa0YrY3dmWk5mVW04?=
 =?utf-8?B?RkZuM1I4RWdQTS80bUZ0RDUyc2xRVVd6N1ZWUlJlTjF4d3VFRFMxUTFiL1Iz?=
 =?utf-8?B?QmZBRFF0WXF1bWU2RTlCbTNsR2ZXcGR5c256NjBPd1lQRERzdUQ1bXIxK1JH?=
 =?utf-8?B?cFZyMzZ3MmJ1QVFEbEo5SHkrRkNQc1JqeWF5ekZjbDhVUGRrUGNuZnZabXVw?=
 =?utf-8?B?NjBOcTMvOUdyRGdGWVd3SlgzTlpsdVRGM3dDQ1U0RmNhQlBzZmNyd2ZQZkdm?=
 =?utf-8?B?M3NZajBWUTR0Z3IwdGswNVo2Q3Z6Y2VsMkdlUnRFM213bGc1NXprRVFkRW44?=
 =?utf-8?B?UUdEUklrNzBTSWpPbXpwU2dNL0cwcjUyNTIrcldUeVh0MDlGZ2NNUGZ4N0hK?=
 =?utf-8?B?M1F1K2FodVNJeTQyczFYZ1Q2UURxYlp3ZlYvd3V1dmVNVDRZdGszK3haUWlG?=
 =?utf-8?B?cmEzVXpyTlpPRGowZWxEU2dSMmN0VnNraVBzREIrOHd0cVJTRDdPZXJFZ295?=
 =?utf-8?B?SWNZS1RzQkhmWFNrQU5vOUNNK2kwOUdIWnhFRmc5VWk3TG13RmMzRUltMU9j?=
 =?utf-8?B?eVpURDVHTWVEbm5hSHZ4c3d3c1NXTmNYeDVPWEpZd3N4ZTRYN29iUHRXZlkz?=
 =?utf-8?B?eFlqRGY5WXh0SWVrcWF5dTJZclVCbEZ0ZmlsT0RrSHByRTNibUxJWnpMRzFX?=
 =?utf-8?Q?b2dtfBu0sXJ3JkLmns3OZm3mGsx/JxAkJhcPE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de3dd82d-46e4-47aa-fc2f-08d95b748493
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4494.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2021 20:30:25.0849
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XVm34D1sF6U93HItnizj4y67szj42bBhp4mwOhoazTXqSOxcrcZiSPM9e6zy43ialnskFx5c5KDUbBQc3k8BNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4306
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10071 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 mlxscore=0
 spamscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108090145
X-Proofpoint-ORIG-GUID: nbxe5Q8xtibexjq-6j16u26M7MA_Idrt
X-Proofpoint-GUID: nbxe5Q8xtibexjq-6j16u26M7MA_Idrt
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/9/21 1:16 PM, Al Viro wrote:
> On Mon, Aug 09, 2021 at 08:04:40PM +0000, Al Viro wrote:
>> On Mon, Aug 09, 2021 at 12:40:03PM -0700, Shoaib Rao wrote:
>>
>>> Page faults occur all the time, the page may not even be in the cache or the
>>> mapping is not there (mmap), so I would not consider this a bug. The code
>>> should complain about all other calls as they are also copying  to user
>>> pages. I must not be following some semantics for the code to be triggered
>>> but I can not figure that out. What is the recommended interface to do user
>>> copy from kernel?
>> 	What are you talking about?  Yes, page faults happen.  No, they
>> must not be triggered in contexts when you cannot afford going to sleep.
>> In particular, you can't do that while holding a spinlock.
>>
>> 	There are things that can't be done under a spinlock.  If your
>> commit is attempting that, it's simply broken.
> ... in particular, this
>
> +#if IS_ENABLED(CONFIG_AF_UNIX_OOB)
> +               mutex_lock(&u->iolock);
> +               unix_state_lock(sk);
> +
> +               err = unix_stream_recv_urg(state);
> +
> +               unix_state_unlock(sk);
> +               mutex_unlock(&u->iolock);
> +#endif
>
> is 100% broken, since you *are* attempting to copy data to userland between
> spin_lock(&unix_sk(s)->lock) and spin_unlock(&unix_sk(s)->lock).
>
> You can't do blocking operations under a spinlock.  And copyout is inherently
> a blocking operation - it can require any kind of IO to complete.  If you
> have the destination (very much valid - no bad addresses there) in the middle
> of a page mmapped from a file and currently not paged in, you *must* read
> the current contents of the page, at least into the parts of page that
> are not going to be overwritten by your copyout.  No way around that.  And
> that can involve any kind of delays and any amount of disk/network/whatnot
> traffic.
>
> You fundamentally can not do that kind of thing without giving the CPU up.
> And under a spinlock you are not allowed to do that.
>
> In the current form that commit is obviously broken.

I am quiet aware of spinlock and mutex and all the other kernel 
structures etc... As I said the fact that Linux uses locks* for 
spinlocks and mutexes is confusing unless you look at the details of the 
lock. I will fix the issue, it is a simple fix, copy the byte to a 
kernel variable, release the lock. copy the byte to userland.

Shoaib

