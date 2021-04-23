Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95D1B368BE1
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 06:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236425AbhDWENa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 00:13:30 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:44476 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229454AbhDWEN3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 00:13:29 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13N4CRVq030993;
        Thu, 22 Apr 2021 21:12:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Z3FqZmb3SraSr14CwyGvtZlpYgJa7lPO7hLKY5EiuR0=;
 b=LTqFvHg0gzAEYYYAuBLBAqItw9GafBQJ2bMmiEsua1WhQo0K9G7pfNMUtkisGO5shSHg
 YmgVu/g2gioJGAX0QPm/6kQWIHyxChEQG5bbscxlE0HRY4nUHuiublfvSe4nX1DJL/6Z
 XCup+GqpelmGzjSjOqrYXDP/Wt5Ff37JCcM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3839usmu8a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 22 Apr 2021 21:12:26 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 22 Apr 2021 21:12:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LFN+Yu5EJSuhMNeVzjEtpVQoUDMMsa5beKK0S4aXC+jAnfLp0membBewlF0H63tlMl87fqICaz8Xe9G+y+1Ba4Z329/lqoHOacp7eTJhqQd4srFtypZbI9leX3lG21o5aPTA7iO6LE8Jt3cHZa1cq4ErNrwT5ul+OBQ0nPEPdxN5XHFbL38qw1gCd/5NP7V7Lnn0xbsYO2uui3HEgFpOj+ugsvOuHCHDhMhlHIjA9QrT79jg6o9xV3vuEgcsHpzWyJtCZMT8bYql1PTRA578Lr+LjEtHWhMTaz95EKYH269ybC4pxk5iFKTamNVbGA7EblzHGHpXY5B6yHWETJ2xWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ShQVit5bauhC+IcW+g/CPXmqReNiXiCl3UJNcmVGJ6k=;
 b=kuR5qYiD0QD1+4KJY/xRDPO2ZTpYpMGjqx53zqT080WuZW1Czs22JuTqbZdnnIjjSB1dUNgrdVwMinxG3s4fVlvobg5AjnIJVP74MRt4CycaIBepDZgrJawVapcSFc9REqvZV4X3s8s6PwrzDu2uwkjPy94fUElTDKHCTYV6mtJ/OPIivmgMokrzzjyWzhWps6Y+phWk1Rsi3CnMlnWKNaUcc3HQNYM9/uZv7z/O8H8c2SpcWBM4zBYn0S+i3uDMcxjXkr3RS9QMVm62IoeSXS6qvovR7EKIUA25ZEv4r3tixLjVbWEzJjGCCN4lHcJbBJDVY5CHKqf2YD0qmOUsvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: loongson.cn; dkim=none (message not signed)
 header.d=none;loongson.cn; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA0PR15MB3968.namprd15.prod.outlook.com (2603:10b6:806:8d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Fri, 23 Apr
 2021 04:12:24 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.4065.021; Fri, 23 Apr 2021
 04:12:24 +0000
Subject: Re: [PATCH bpf-next] bpf: Document the pahole release info related to
 libbpf in bpf_devel_QA.rst
To:     Tiezhu Yang <yangtiezhu@loongson.cn>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
CC:     <linux-doc@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Xuefeng Li <lixuefeng@loongson.cn>
References: <1619141010-12521-1-git-send-email-yangtiezhu@loongson.cn>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <221ef66a-a7e4-14b7-e085-6062e8547b11@fb.com>
Date:   Thu, 22 Apr 2021 21:12:19 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <1619141010-12521-1-git-send-email-yangtiezhu@loongson.cn>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
X-Originating-IP: [2620:10d:c090:400::5:83f]
X-ClientProxiedBy: MW4PR03CA0275.namprd03.prod.outlook.com
 (2603:10b6:303:b5::10) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::17f2] (2620:10d:c090:400::5:83f) by MW4PR03CA0275.namprd03.prod.outlook.com (2603:10b6:303:b5::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.22 via Frontend Transport; Fri, 23 Apr 2021 04:12:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e337d8d2-b8e4-43e5-95d6-08d9060dff78
X-MS-TrafficTypeDiagnostic: SA0PR15MB3968:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR15MB3968304C0DA048B7BA889ED7D3459@SA0PR15MB3968.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:635;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VB1jkXtV8x50b6fzEq57kb1TXm/mMYsFl76MM1e6c6fV8sae4LRRRSQIJ9X5YFgxxXtQOut7GBYjtlhIyKK9lU/n3yC9SaN1E2q1GIy612oZ9geZBCYl772um4N9B/5KoZ5SvPIaJdFKdg5RSpmnqCZ2fuuVl8zDH7h/z6H7odRBR/8TSO8DfDtvaYzWbtXaixY6IglQlmo0UHz+svgSF58j2PXAVL8T2yuGflcqPMgT5fG1Kqv359hJfnBHwxdmrlFcGctw3JS24ugOpeEbdFeDgYjDhGy2x9JVa3pIy0FtfzzgBGjq/4RB0tZ5o9AP/xtP6J/VXorjhPClVf79+ujX1633VF6FhZB/tH8IJ/3hiXlPQszqrBJVZLav/tgSU75JpOX4w7+0U38mI5gpvZwXv/pH8h0TaqFKykX2WoEpbC/UdJmo53fSl51aKKBArDCIrxBtqJGHdTH99ADWQAfBAfMERwB8MkoNO+X/VKshbLlevttL0+sqXyWsfVjDrKQtY6UEsChe56iu09Ng4Z36OasNJ9kcyvZBG7SlVMtMJvOf+XzCU9ff88G3g1lMrsDlTQSNwpa/Q/VjebYfZaDDq/FSFX88r2yr1JRTOoAYshNLN4zaeZKZxTORqEARQQvakbcMf3Y98XsittPlxIb70Cyv/ckmdlGkbrMIeaBpZXWkzpT984MyH/xfZEhtZlKmnVtM2DwEoolK0sl6fcyAxeVcdrEtk6b/pI0BaSc6cnQcqStjymn3H1QCnukE8K5nNfVSrwWVB62WAPPxJpe15cRDXOaD/Tl3vOETn4U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(396003)(346002)(366004)(136003)(2906002)(83380400001)(4326008)(31696002)(31686004)(5660300002)(966005)(6486002)(110136005)(478600001)(86362001)(6666004)(316002)(66476007)(66556008)(8936002)(7416002)(38100700002)(8676002)(36756003)(66946007)(2616005)(52116002)(186003)(53546011)(16526019)(921005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TGlEQy9VYjhHUFlNMjd0R05xRTB6M05DbXV0MzAwVW1YR1JUZlZRVGQySjB1?=
 =?utf-8?B?S1JXM0tsUkdZNFp6US9UdURYMUd5dTQ5Y0tQaGczS3NVUnR0dmVpZWZPNWZV?=
 =?utf-8?B?cFJkSHMyMTR3Uk5lSGdRYW1HRzQ3OTIyODgvRFNzQWkrSjVxbjNDZkkxUit2?=
 =?utf-8?B?SGRSMDlUYmFTN1A5RHd0MHBWOEFmRi9qamxVQ0w4ZU9aY1hXbVlBYzJGM2hp?=
 =?utf-8?B?SUFYUjlYci83RWVYbFFxUFo2VTVsMFpjWTBWMWFlMm5mcFdETHRlRTdRc3pZ?=
 =?utf-8?B?dkt6d0ROZ3UzQVRUNzlXemVXdUZjV1Z2ckRqMzU4SGNWMjV0djZDakwraU5Y?=
 =?utf-8?B?dm5vUm1tSDhoUlJPYkZ6dHF0VDUrUGVvUG9wZldMenVuNHJwdDFwcWtHVVJZ?=
 =?utf-8?B?RlBsNE8xc2QxeGtnRDZXK3lXd3cyNnltNmdYSkw0WDdhdER2dFdWMkhvanhx?=
 =?utf-8?B?dFlEMmo2SkZ0TXZGNkNCVldmUW9ZdG14WGM2ZGZ1eHRXd2dMcERmc2VGa0tJ?=
 =?utf-8?B?eHJxZzFVVmtVcDJMdFB3dHhxNnZQZ0YzcUczZk80Z3Fxa1IweUZhVDZyRFhi?=
 =?utf-8?B?REI3aVJFRVNZbG1qWmVrbjQ4TGkwY1pQKzlIVFpuL1VPSmwzREUvRTErcWxz?=
 =?utf-8?B?OWRaeU1SenVUNkxmRXlNQW0vaURDRXIyZnNYeG1zUm5yRUo2NHRweVA2UGxz?=
 =?utf-8?B?UFZoWFdNSWtjK2M1TkswRi9zUmpTcjFXQUJqMTBFeHIzeDcxd0poTG1RNGVh?=
 =?utf-8?B?M1ZzMmgxTlBkUWFuZjZhNE96dEJHWlI0SndnOThCS0wwTmVsdnNZM0FJVmI5?=
 =?utf-8?B?ajVKaXVkSlUxS2JSWC9ycG9wTnZ2MnVmVVQzTzlXY0xKY2oyL1RoY2FkTHE3?=
 =?utf-8?B?VEZ3eWFWVzEwRWJiMndmWEN1VVp2YTVJWWxhZnM5cU1QWkNweGRPb2pTMFMy?=
 =?utf-8?B?R3FscVM0eENSTi9jWFpEMncyQ2hyaXFhYlY3UTJGazhvcklzWDBuN1pWLzFC?=
 =?utf-8?B?bldyTUE1ZUZiaUFyLytERFVsU2lCVFkwYUdNUmhKOElvNXRCN2x5YVY1bThP?=
 =?utf-8?B?MGZ1UGxzcGV4d0JpT2srdHEweEo2aVdWbUo5YThhamtiTTlnOEFXQ0xsQjdE?=
 =?utf-8?B?WkpNeEdiQzZySUh2V0JKMjdOT0J0bEQvcmoxcFF4aVFMQXFzaVVtYWtsRS84?=
 =?utf-8?B?WjJ4R1kxVHBMQjcvOUFsaEVQYVZud0Y1UVJ1dzlTajVnTTVJYm5aRHVzZDNN?=
 =?utf-8?B?TWlVYlV6SUdjN0lSYUFSUExwT3J5NEtVUFhQM1hXdWg1alVjcnVtVENpSXZH?=
 =?utf-8?B?d08wdG1DL05IVzlXdWFhdjNDd2hCQVNTT0tNM1J2am0zWTlNSEpuQ2pxODk3?=
 =?utf-8?B?aldDTTlqVlhjSlErTlhYcEZ4eDN5V2tlNWVCaHJuUGdUM3ptVEg1YWVVUFVN?=
 =?utf-8?B?Q204VWtrTnNyQWsrWlZJcU1sWUtYUy9DZ3hTMy9qQ0hOT2g1TzdsdGR4aEQz?=
 =?utf-8?B?b3QyL3h3YSs2c0xWZWk3dVozY0wxZUdTRFNnK1hUeXl5T0dyME1rc2QzaFpy?=
 =?utf-8?B?MUFNTDNPeDkvV2c1eDc1bUtINGpVSWF3R2FQVHV1UzVvZVBaaDQvcFRxUTZG?=
 =?utf-8?B?SGNtZ1dqejduR0JvR0JtbGVpZVJvaVB5Rk9oVjJuT3Qvc2N4MHZoa0FIaC9X?=
 =?utf-8?B?OFU1bUV5bk9tSUhhUU1ibE1qb3dMUUozN3o4MkVpU1B4WC9RbUZCUEVlY0hT?=
 =?utf-8?B?bWowNjVDbm9tK2kvN0twbU1Ka1BmczZ6TGdwRGx2NTZBZnhEVUFVQ1l4Vm1R?=
 =?utf-8?Q?J0bLoKXDtrFN6uF12SdUmG0x7i1oX1CagSuHk=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e337d8d2-b8e4-43e5-95d6-08d9060dff78
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 04:12:24.2148
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iWV4+DSAv/9GFLV3SRQR4yhPhIbTm9y/YdvN7hsB6ffZSolC1eoUY7kv/aVZ3zBq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3968
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: dsrzasKR_d2b_n-4oaxLFlrlLzOElQEB
X-Proofpoint-ORIG-GUID: dsrzasKR_d2b_n-4oaxLFlrlLzOElQEB
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 2 URL's were un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-22_15:2021-04-22,2021-04-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 impostorscore=0 adultscore=0 mlxlogscore=999 clxscore=1011
 lowpriorityscore=0 mlxscore=0 malwarescore=0 suspectscore=0 spamscore=0
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104230024
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/22/21 6:23 PM, Tiezhu Yang wrote:
> pahole starts to use libbpf definitions and APIs since v1.13 after the
> commit 21507cd3e97b ("pahole: add libbpf as submodule under lib/bpf").
> It works well with the git repository because the libbpf submodule will
> use "git submodule update --init --recursive" to update.
> 
> Unfortunately, the default github release source code does not contain
> libbpf submodule source code and this will cause build issues, the tarball
> from https://git.kernel.org/pub/scm/devel/pahole/pahole.git/ is same with
> github, you can get the source tarball with corresponding libbpf submodule
> codes from
> 
> https://fedorapeople.org/~acme/dwarves
> 
> This change documents the above issues to give more information so that
> we can get the tarball from the right place, early discussion is here:
> 
> https://lore.kernel.org/bpf/2de4aad5-fa9e-1c39-3c92-9bb9229d0966@loongson.cn/
> 
> Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
> ---
>   Documentation/bpf/bpf_devel_QA.rst | 13 +++++++++++++
>   1 file changed, 13 insertions(+)
> 
> diff --git a/Documentation/bpf/bpf_devel_QA.rst b/Documentation/bpf/bpf_devel_QA.rst
> index d05e67e..253496a 100644
> --- a/Documentation/bpf/bpf_devel_QA.rst
> +++ b/Documentation/bpf/bpf_devel_QA.rst
> @@ -449,6 +449,19 @@ from source at
>   
>   https://github.com/acmel/dwarves
>   
> +pahole starts to use libbpf definitions and APIs since v1.13 after the
> +commit 21507cd3e97b ("pahole: add libbpf as submodule under lib/bpf").
> +It works well with the git repository because the libbpf submodule will
> +use "git submodule update --init --recursive" to update.
> +
> +Unfortunately, the default github release source code does not contain
> +libbpf submodule source code and this will cause build issues, the tarball
> +from https://git.kernel.org/pub/scm/devel/pahole/pahole.git/ is same with
> +github, you can get the source tarball with corresponding libbpf submodule
> +codes from
> +
> +https://fedorapeople.org/~acme/dwarves
> +

Arnaldo, could you take a look at this patch? Thanks!

>   Some distros have pahole version 1.16 packaged already, e.g.
>   Fedora, Gentoo.
>   
> 
