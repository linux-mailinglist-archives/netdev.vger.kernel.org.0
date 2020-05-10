Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA3971CC6FD
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 07:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726106AbgEJFT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 01:19:26 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:37476 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725786AbgEJFT0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 May 2020 01:19:26 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 04A5JDPf010424;
        Sat, 9 May 2020 22:19:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=lTp2KP+0nclRlhUUoE7Pxij/ssAg7ss6+DWi/05scf8=;
 b=mrqeKnINkDeN111V89mCSYp+tfcQbmHok1oq4KWQisN42Thh2T6lG6HAyhqCr/9jJ0kZ
 n6SAv13CwH4xQpi5VLu7T1IoMzinvLZWTesSqX8W9i58JwwKQ9hfvDPJtfzTWYVCIauA
 5v10nwq+nvcZ+5+CmO5bV8dxmD3kTbFgQCw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 30ws55b9vr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 09 May 2020 22:19:13 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Sat, 9 May 2020 22:18:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EUFSN0uOEyw95tsPhHANR+VJZHsfpHKlm1EVG9pJcR/Dcl8U/LfB3RiDHuM/J0GRtO1IlpUqoOKcjPY9X4kZvzxuvH0S64ZQhS440VqMG0Uw57aXiiWkoLXxto7M09Frv1wOsIegTFd4f6apTt5mc0k7io2FaNc4VPs+gVryKxiuozq9v6Yk/2zBADq2vGmRYhHeA6EKTkNzG6h31deJG+DxufJuuKi5DWmgyIJHHgarFcfcYdHhukud7sLFUKvMLePzkg95A1LUEDB+fDzXv3HtKZ7IV6PxvSEF6kLyRP1ronJKWcmHeXn6lQXhDVwUYFPgpRvcT8XP468maTMTyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lTp2KP+0nclRlhUUoE7Pxij/ssAg7ss6+DWi/05scf8=;
 b=a79qnceL8zw11lTNgQ/cnmR3ixV4jB57qUO8ceVYZxQ6b4/9Y9OR1PVzBT1D6h3p98iiEEgMGeioGUt1EyvwXWpqA2GpcYrSj5vZE2AcgFrwlukpiY0W+29Iod3eK+dWspbCzFfKxUzt6egcBkJuaKrxNZ2J+VdMLHmsb2QKP3m3PC2wPO8lvbFWu6tN4pD+nHoOlLeLkg94g1PmGvBTUrOb32+GKmzfY/YlN+fbNDICiRpONuaCim02oUjVXUSP+8DqRQwYjQUB4zfd9zqL0PR/2GDpm97HVBj+XE4xbzKvmTCEYfch+jvJKjNBuuRiokn6UQxrk+gOcB271uB3Uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lTp2KP+0nclRlhUUoE7Pxij/ssAg7ss6+DWi/05scf8=;
 b=UFhpQKr9hBdAJ5GVgdd7VaoCe3MGxVeYZRMclefWO9WVM1lL3s7nO4L3KwoEixQZrOq0y73JlHu6t0CCWq1xJbJcyLEoncHl75ZTl0iIaE4v2a7cx/LM0pEyCnIeLNQaoVg0l3pkRnKuOdbk4CeH0ZBv03rXvBb1f1fwSp9Bfaw=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3349.namprd15.prod.outlook.com (2603:10b6:a03:110::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.34; Sun, 10 May
 2020 05:18:39 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923%5]) with mapi id 15.20.2958.035; Sun, 10 May 2020
 05:18:39 +0000
Subject: Re: [PATCH bpf-next v4 12/21] bpf: add PTR_TO_BTF_ID_OR_NULL support
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
References: <20200509175859.2474608-1-yhs@fb.com>
 <20200509175912.2476576-1-yhs@fb.com>
 <20200510005059.d3zocagerrnsspez@ast-mbp>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <d5b04ac9-3e3c-3e32-4058-afc29e3d34ce@fb.com>
Date:   Sat, 9 May 2020 22:18:37 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
In-Reply-To: <20200510005059.d3zocagerrnsspez@ast-mbp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR06CA0014.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::27) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro-52.local.dhcp.thefacebook.com (2620:10d:c090:400::5:e956) by BYAPR06CA0014.namprd06.prod.outlook.com (2603:10b6:a03:d4::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.28 via Frontend Transport; Sun, 10 May 2020 05:18:38 +0000
X-Originating-IP: [2620:10d:c090:400::5:e956]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ce826c4b-2008-4e00-b3c1-08d7f4a19924
X-MS-TrafficTypeDiagnostic: BYAPR15MB3349:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB334925A4643426BDC5941BD2D3A00@BYAPR15MB3349.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 039975700A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9y8+DAluSYfCtt2J3/qQAqz422QT870JBPWuo5VNoWwyT6awgX++quV40GtN7SC9kidspbZGQCMq3yhSgEk3xiR37pvWE1rSLNAXU98VeDtbxjpFrB5GcM+c9Nb6jeiHq03Mh8nYBoHIHpqaUqg9VWo3gAkkULNyyZb+8e0TNf4sAuFCm9cIupAQr0XifKsLlnkEYfTA2jd27IMG7UFJXyuCgJkDPUJyiZJuXK7EAKo2OEGiViPZxA9+U87tFeCoZU4VNCkYWwhZsPt6XA7Ffs9UiL6zt3zAM/evk0EMEi5RD/kCqDn7wAfc5h1qXaBZ1XHKG1/xFwIPzwLtQuKNrABuXqf3+TD2pXmARv2aBHIpbst5xs075TsU66rg+Dcr3Ht//wHqdWK8fmGLyvAV0+JG3CvdLEspLYAQLI4845kz6yLI7m/WJxPl8RCjO2XwmUCzs4K720c1rgREvLvFhhvUz4Lw/ycEG0WC9mNrOEaS9hEWN6k0pDqsFmBqPp7tZBJNjbj9og/ytxPjooGKIMpB0j1vjPQlFLcXZQpw3wV15myrAUV0vZpHbPLrduKn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(366004)(39860400002)(136003)(346002)(376002)(33430700001)(86362001)(2616005)(31686004)(6486002)(16526019)(33440700001)(186003)(53546011)(66476007)(6506007)(8936002)(66946007)(31696002)(8676002)(52116002)(66556008)(5660300002)(6916009)(54906003)(6512007)(2906002)(316002)(4326008)(478600001)(36756003)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: t8WUouskPf5pq5dCdXgSICSH8g+GAIs04CfySosU2eSb6h/Vj9pDNJz8FRvxLxD5Doad8X5r72mI7HLdhT7wi2BVeHVuU56ZwCb6S4GCmkHJ3Dc/Rq/zXPMe6HuUPQoM3hzgp8ipjBjIdCN6rmxSRlA0NSrD6YDQP2MN7Fgshty11wSk8+bQ21SH7W67c0licn4rdbIxLp/bnybNYcmeKEAD3KolYvsaEgbYm5nlapORzllkGOqyyBDJH27VbI1tr1vmhm7QmXmDMnWGMsiRasDUwupZRDRffg0iOGGmtQquoLpPHO1Iz3X5kFQief15tphfkFSaNzbBF1wvCTCP91YvVPfslT2LyHI7wRtEg43Jzztk1uiqTZppEicdg7LYYsk69iklUpvW4fxKFzo2N2vDrNaKBhBD3iOK4YDB9pD42mfFe9/4YiL1/enXPxJTZzcVBK4hgAn28vqHFMEV4nZ09dSwu3+AWFQqWdx4wJAdBZu4Ht/JwwH+ubomWhvRatGyaSIorM4SDZFzGuOMiQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: ce826c4b-2008-4e00-b3c1-08d7f4a19924
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2020 05:18:39.4094
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: USm0lpKi+cU6ATcBahwp+AtY6d2SVTSMePYzgjf2x2mrUoGZO7MVS7zdP+MiCq6p
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3349
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-10_01:2020-05-08,2020-05-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 adultscore=0
 clxscore=1015 mlxscore=0 spamscore=0 impostorscore=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=999 priorityscore=1501 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005100048
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/9/20 5:50 PM, Alexei Starovoitov wrote:
> On Sat, May 09, 2020 at 10:59:12AM -0700, Yonghong Song wrote:
>> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
>> index a2cfba89a8e1..c490fbde22d4 100644
>> --- a/kernel/bpf/btf.c
>> +++ b/kernel/bpf/btf.c
>> @@ -3790,7 +3790,10 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
>>   		return true;
>>   
>>   	/* this is a pointer to another type */
>> -	info->reg_type = PTR_TO_BTF_ID;
>> +	if (off != 0 && prog->aux->btf_id_or_null_non0_off)
>> +		info->reg_type = PTR_TO_BTF_ID_OR_NULL;
>> +	else
>> +		info->reg_type = PTR_TO_BTF_ID;
> 
> I think the verifier should be smarter than this.
> It's too specific and inflexible. All ctx fields of bpf_iter execpt first
> will be such ? let's figure out a different way to tell verifier about this.
> How about using typedef with specific suffix? Like:
> typedef struct bpf_map *bpf_map_or_null;
>   struct bpf_iter__bpf_map {
>     struct bpf_iter_meta *meta;
>     bpf_map_or_null map;
>   };
> or use a union with specific second member? Like:
>   struct bpf_iter__bpf_map {
>     struct bpf_iter_meta *meta;
>     union {
>       struct bpf_map *map;
>       long null;
>     };
>   };

I have an alternative approach to refactor this for future
support for map elements as well.

For example, for bpf_map_elements iterator the prog context type
can be
     struct bpf_iter_bpf_map_elem {
  	struct bpf_iter_meta *meta;
	strruct bpf_map *map;
	<key type>  *key;
	<value type> *val;
    };

target will pass the following information to bpf_iter registration:
    arg 1: PTR_TO_BTF_ID
    arg 2: PTR_TO_BTF_ID_OR_NULL
    arg 3: PTR_TO_BUFFER
    arg 4: PTR_TO_BUFFER

verifier will retrieve the reg_type from target.
