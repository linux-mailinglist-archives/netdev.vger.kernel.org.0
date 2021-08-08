Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 651B23E3BB7
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 18:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231882AbhHHQyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 12:54:24 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:62922 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230169AbhHHQyW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Aug 2021 12:54:22 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 178GmPSD014725;
        Sun, 8 Aug 2021 09:53:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=1ofKFripSml9OG4o1XPnygTGapBpFuE5Oo9wtPcbYns=;
 b=efG74tJtnlOXncZVcNEtpTgypLKX/QMTaOjcJ6m1orJhyzVn/6yCRJLpDLal6cmMe2/g
 o3Y9x602oXqYiMdTs6aiTKddSRfDpTeiow/8yAjwqfiPip5yK1sqhUhhmGenvrGBAyYT
 I5ZOPEYewaZpCnX7vfnUHmmQmdKxNrbiJ9w= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3a9q9ycsnq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 08 Aug 2021 09:53:46 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sun, 8 Aug 2021 09:53:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RdJTpjTuPkIT0hZCWRx8BgRY3VDE3ETNXSzpa2gZITsqa2nhl5NchhzmHR7NJQ6oAE+f4W4O5bsy3iujLF60xYqIvOiv1ujqvR1vUtLlwRS8k8T6GPUfmFlDE2EJWszHYM04PSVFktcpCKQa1xCOZlPCTqSXDe9pV9MiTqc0oGAZ2xLr9YuEDdykD5BxLC9NpZ7GZ5t5BLF/KmapBLwulfd/ealY7ddR6YbrXOUReZ9bi4suxkK66pXgM4Yoqo9rYxaL60uO4y2N4XqIrznoSbZRI8nqWSLaMI7zEaFoCTLjREXJFpflTB3NYG46lsYEk/lo22Y9oZwjfopgBhH5rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1ofKFripSml9OG4o1XPnygTGapBpFuE5Oo9wtPcbYns=;
 b=oZ7CqMWOof6aaWP+cShjlEq74VPViXFbuZCc6vBZQkgDWuk9ooXKSRucyEfQxS2G3UVnqE7x37+KDla86pxUlqLscSP72TSqhcxdTxJRTVaXmjiVOZkx53i8jbnNPpQGzN0a/Orphz9eFtAcU0gzlk69JQP99bxw+/Yi9DvSPCg8UvsSVbxFYqGbEa3rzPLvvrJdn/seBgPU7d5HmPLokMOk8o9jzlk6YCyi6VmKNUTbQYCDcTecvWeIk5Y1RdrbrRSj+9ZcnwTpaRghAF/5bXQL3B38b/JLiAA0rhONUrCgGHUcdEojJH65UskpyLKWO0ttph7hDxze72LEitG7kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (52.132.118.155) by
 SA0PR15MB4014.namprd15.prod.outlook.com (20.181.59.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4394.17; Sun, 8 Aug 2021 16:53:44 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb%7]) with mapi id 15.20.4394.022; Sun, 8 Aug 2021
 16:53:44 +0000
Subject: Re: [PATCH] samples: bpf: xdp1: remove duplicate code to find
 protocol
To:     Muhammad Falak R Wani <falakreyaz@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        KP Singh <kpsingh@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>
References: <20210808122411.10980-1-falakreyaz@gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <be9121ef-cea7-d3f9-b1cf-edd9e4e1a756@fb.com>
Date:   Sun, 8 Aug 2021 09:53:41 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
In-Reply-To: <20210808122411.10980-1-falakreyaz@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR08CA0051.namprd08.prod.outlook.com
 (2603:10b6:a03:117::28) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::10d4] (2620:10d:c090:400::5:bf16) by BYAPR08CA0051.namprd08.prod.outlook.com (2603:10b6:a03:117::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Sun, 8 Aug 2021 16:53:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cdc35e45-fb43-483f-aac9-08d95a8d14ec
X-MS-TrafficTypeDiagnostic: SA0PR15MB4014:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR15MB4014F2DC8E77E3F7D0DF6A2FD3F59@SA0PR15MB4014.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VhpVvHHq8kV1Nqn1WRbWhshvoXAOEFYp+iXHnoQu0Uz8d/dxCbEvc8lqYHO2cRDbavcLJYyu8zpWdmn8YRgc+lraBwBRgEvA2nSRgov8GnKoMxWPsDvWbW9HGe0mTj8ib3WVkQwRrVHf0380upHQ25FeNfs8kFTIwv0dSivVeRhr4Qd/kuE8OMvu0fa//YVIsC1rvLGl4mQVMlmZnieIq7tgLSKuBQr0i6kxBg1tPqYFZ7DA45vrRGTYaZj13Fm/5RRY7uzUN7A/65nD0EltnM2zPfFi0Bk4kT5P5y+gobu83EzzE5Y/OIzvZJz8iRdRbk6ZMHS6snsPfV0oqJmbWq5U9/lE2D20B0TDFZP7iA2TuSYQ/g33fVXfS0SgB6eqeQCyp1niAzuDRO+I+XgAC3zAjzMKWUctMSXGGN251Dr0eBr9HjuBygTtnOQyHPnYYgXhFQGfeVXvMO4fyO7KVtW1TAsxL6vgpWj/Qzo5IkKGIxwJlnN6HrpOZUnUR34AyHmdip+rxxPol0hEzvi7Kygj2b0tOvQuWV3Omh1r9u6M4kdrTUAl2pc+fg/u8zhZDAe7v6Fepb3PXmY4RgyZBjNsHnFb83H6zUfE4hEIofWAbbqvvGL11NA+6rrmHB9MEyr2B3Hl8Wf9iNLvHEOASgk7+txmO/AjUjLtMf9pQrY/IGQmxufA7WwJ2RGXKq4sc5zU/utTS2fR+s6cTPOmBORasjgBfjQqK6AKIRhzDwJVbyXvNixD1prfj4uyXozY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(110136005)(53546011)(66946007)(54906003)(31686004)(186003)(508600001)(8936002)(316002)(8676002)(31696002)(83380400001)(5660300002)(2616005)(36756003)(6486002)(38100700002)(52116002)(4326008)(66556008)(66476007)(86362001)(7416002)(37363002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TGoyOTVwTU5HZGc2SFpta05JQ1dOSENXYzNhTVV3QnM2L1dzdkVBbVpvOWpq?=
 =?utf-8?B?SW51S0g4OXp4QzN2WHFOd2hCallTNUcrQU00YlJPTFd0OVJhSkFiM0EyRFRS?=
 =?utf-8?B?eVB1Vm1iNXdISWxQVUd6VEtKejBHcFZsakV3NXJZcEE4NVVpWTFvR25BRDRS?=
 =?utf-8?B?eXVONVVieUJRRW5LcDF4Tk9uMU9YcC9RSkZ3QnU5NGNKam1uMEI5ZTFsQ2pY?=
 =?utf-8?B?ZmpveG9BNGRCLy82aEpuQXVpY0JQQzhkNmswUnM1cEtzekt1YkZIVFdzUTRk?=
 =?utf-8?B?RHZHVnoxemJMQXMvOTJvTXNRS2lKcWdIemlzcVdKajlBeEJiRWo2aU53ekFR?=
 =?utf-8?B?T1J2L0dxZUlTdVVtM01tVHZ3VHRQVi83UkUvYWo0REdMYkFJU0xybkc3cUtq?=
 =?utf-8?B?b3Bzbm01Z2JRVGd5dXpNKzZxOXR1WnIwd1pqQTdXMEVlaWcvc0tQa1ZpeEdR?=
 =?utf-8?B?cXNjQVRzQzFYdktzSVpkWEpQK0RVbFI3cnpDZ1I4NWVkMmkxV3g3Y3lFZjRC?=
 =?utf-8?B?SkVjZlJiUG9Gb0ZIU1dYSXFoYm5RR2tmV0ZlY1RPMS94UjNZektWYnNhM1Z6?=
 =?utf-8?B?cnBVSmwyK09takNCckYydnZ2SXZPMjBUUWlHSWs2TkR5WHp3eE1PVitSQ0dz?=
 =?utf-8?B?blB0Ti9abWRJbU84emYycnVXZy9DVmtqUTJQOXVwcWxyeGVOMU9jRFM3Szcv?=
 =?utf-8?B?U1ZVN0FEWkNObUxzYlFOSWd2ejYvUjMxZlFOa1dFbzVwWWZqQ05VZVRDNURh?=
 =?utf-8?B?ZlVLWm11NEtvTUdEbHJJUG8yZnhoRWsxVjVYM1lLMFVrK3ZidVRHMzdsbm9h?=
 =?utf-8?B?SjRLWW54UWhXemZnd1VwUGl6dEg0QXFpYVhyaWxPZUQ0Yng0VjR0MDN5V0No?=
 =?utf-8?B?RWxMQlEzdGE0S0tMRDJMOXEySzNJWE5CV21odVVPR3EybEhldXlPT1Q2Y2Vr?=
 =?utf-8?B?RklzWVp5eDBxVVJsMi9PT3VPN2ppazBJOUlTQUY4bHNjQWZZcGhkNkZ5ZHZB?=
 =?utf-8?B?dG8zUXZ0WWs2WWh3QXRlbVB0UWgwSXNqcDRHYlg4cUNKZUpjaFlFYTJYWTlI?=
 =?utf-8?B?cnJrTUhaeXlNNTFqVmJEM2xFcVF4UG1mMTlOSWVRTUQ0d2ljZ1NkakRWYXJB?=
 =?utf-8?B?d0Q5SklUbHU2UVZhaFhVMS9Kc0x6b1R4WVU2K0RRU0FSK0NxQU53QjdreGhN?=
 =?utf-8?B?QnN3UWtOTVl1VXdyMCtpdGVXNnphQi9xaXIrT3UwZmxQRDdPcysrejM4MktD?=
 =?utf-8?B?aVlLVXh2UWlHZUxJK3FiMlFwYzh6L1ZRM1J5ei8wbnZTMkJIVWw5SnVucDg1?=
 =?utf-8?B?bFZUMlhGMW50YUx4ZVd2YmVDTUJuSVJDUDZHbkFQeEorS1MrQitzRDY4QnJv?=
 =?utf-8?B?TWpyakRMdWxSa1VwQXAwdlFWNUtQSVNybzFjZmNFTE04Vi9MU293STRuVjlq?=
 =?utf-8?B?ZUhlb3BxQmZ5MDBvS2pTaE1lMldhRnl1M2RaNTVtNVd2VlZDb3hrbFkzVWc5?=
 =?utf-8?B?T0hNSmJ0dTJlWnlQRW5kak5NMWdFZ1Njd1BYVWlBa2wzeG5mZ1JjQklnbFNs?=
 =?utf-8?B?cTNHNE04ZG5mQTBVT1RqWXZneldTOTdrbnpTbUpERjNWTFFldTJTMDNLNlNn?=
 =?utf-8?B?WHJFZmp0Vmo1NURyR0VaeXhlV1ZNODhCci9CMjJraDByRU94SVlJUDF0N3Jh?=
 =?utf-8?B?VllzYU1halhnbEJReFhpOVFiTGJNN2ZIaWd6bkwvWEJMR21DblR6VnREVHdK?=
 =?utf-8?B?bUxZMmV1SERLWVpwd0l6YkxqNXU1eCtEWDNPdmpUMjJXVmFkU0t5V1ZuTmRj?=
 =?utf-8?B?SVB5UTZjVlo2cTYwbEF4Zz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cdc35e45-fb43-483f-aac9-08d95a8d14ec
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2021 16:53:43.8828
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PMdrkUWQPcWAvV4hgjymEC2gKDz3BWX8XHWN/DEKtiT8TJXJ1M9LDgp5mHh0A0+f
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB4014
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: VQHC8z45gMSXGvF8YX-7oRV_s4t4mon8
X-Proofpoint-GUID: VQHC8z45gMSXGvF8YX-7oRV_s4t4mon8
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-08_05:2021-08-06,2021-08-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 spamscore=0 impostorscore=0 mlxscore=0 phishscore=0 bulkscore=0
 malwarescore=0 adultscore=0 priorityscore=1501 clxscore=1011
 suspectscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2107140000 definitions=main-2108080105
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/8/21 5:24 AM, Muhammad Falak R Wani wrote:
> The code to find h_vlan_encapsulated_proto is duplicated.
> Remove the extra block.
> 
> Signed-off-by: Muhammad Falak R Wani <falakreyaz@gmail.com>
> ---
>   samples/bpf/xdp1_kern.c | 9 ---------
>   1 file changed, 9 deletions(-)
> 
> diff --git a/samples/bpf/xdp1_kern.c b/samples/bpf/xdp1_kern.c
> index 34b64394ed9c..a35e064d7726 100644
> --- a/samples/bpf/xdp1_kern.c
> +++ b/samples/bpf/xdp1_kern.c
> @@ -57,15 +57,6 @@ int xdp_prog1(struct xdp_md *ctx)
>   
>   	h_proto = eth->h_proto;
>   
> -	if (h_proto == htons(ETH_P_8021Q) || h_proto == htons(ETH_P_8021AD)) {
> -		struct vlan_hdr *vhdr;
> -
> -		vhdr = data + nh_off;
> -		nh_off += sizeof(struct vlan_hdr);
> -		if (data + nh_off > data_end)
> -			return rc;
> -		h_proto = vhdr->h_vlan_encapsulated_proto;

No. This is not a duplicate. The h_proto in the above line will be used
in the below "if" condition.

> -	}
>   	if (h_proto == htons(ETH_P_8021Q) || h_proto == htons(ETH_P_8021AD)) {
>   		struct vlan_hdr *vhdr;
>   
> 
