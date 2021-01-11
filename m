Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D09892F2083
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 21:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390882AbhAKUQO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 15:16:14 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:26062 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388548AbhAKUQN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 15:16:13 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10BK33G3006833;
        Mon, 11 Jan 2021 12:15:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=f96GFSGY76IuaOMipT7l2V2vCbHr3U99RgW0xiOjdBo=;
 b=U3T+rZgf3vvOzepaqnBtmQUkDDUkQVvSPSbKB0CwBHRV8Afm7yZFpC5D34tLPssQNr14
 KOUzjF5gtWCA8P7pGaTtdeFL9WEJtfQLp+W8TbP2hDUO27eazFuihHKBcaeChg1jEgqM
 UGArm7L0RP9UZkUOokpbmcUf3NwOSKJWpMU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35yw876r09-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 11 Jan 2021 12:15:18 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 11 Jan 2021 12:15:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MjlaJeDwDIYEyj83tEffBOb+I6Xd9vwtGk7Wg6v/PEtCPLpvszMVhR26hzGzc3UdBv9YL+e9hvh8JMEizqV0MoRJrS0KhKCT+QhDrU78iphftc0Czt1uuiz3vyDVMOINrDL3i+kU2jXEsex5ms5F9cKtRiBuEBskyJ1MubKlwXLG7QrJfQyQmsRYqUF3xXRjiIHiwyqlS1pgp/OpfU/h/G7Af8rTmlUhQuim+ZXBNZBtytSmjWFIBBJmpSwo0z54E3IXiWTNh2r8I3ph/HjRZgZA+wRFBjxxVwNAqJXY5kZKKIweIfAqhwzv29C+SQAj6zFTw4yeeOgu/rY/OGfCWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f96GFSGY76IuaOMipT7l2V2vCbHr3U99RgW0xiOjdBo=;
 b=KhOglUoo0EC6dAJZ2naFT8sO7+zwmWkbBz6X5H4Cawe+kLpZKOARSovIh6C6zPLQiBP1QV3sYHj0WVuM0dNQ5bfGzQonSIjIIofX8UR6f7FgrJfXhzuhR6hS7vh5ltjVraq3jDy4hr86OSyaogBu60IS5SdaFUkVNT/SnVHlW0pwMBPpdnAKyRgnW6OsPq7RHc65p/RaFAtaaXkmeqIglycrNzr87nexFBvzNv8TmoP9d5GlsLFLMdyCp40up+zq+Kil5B4z8ajym5LYkpfM8wMHVdWnp8PjsD5i9dAbRBce6pKp9/+xtbNhMmdj3yxrr6cRTkPebDz9SDsKqSmhwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f96GFSGY76IuaOMipT7l2V2vCbHr3U99RgW0xiOjdBo=;
 b=Cqykt8dzd0OOd92j/nGAuWvDjYkYCeWXSV6IBp/kubPYqq2tC7/gvTb3yU6a/6knvqE6XwU6YR/C7uMZv64L0aYAqi5/+tPYZ27uFrEjWFHUtCYUncZbIcPDdNsOc20mwS4IiiT3erY1tSB9rWGfhVwz2G9hHsBBmQoFEMJjERE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2583.namprd15.prod.outlook.com (2603:10b6:a03:156::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Mon, 11 Jan
 2021 20:15:16 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3742.012; Mon, 11 Jan 2021
 20:15:16 +0000
Subject: Re: [PATCH bpf-next 2/2] bpf: extend bind v4/v6 selftests for
 mark/prio/bindtoifindex
To:     Daniel Borkmann <daniel@iogearbox.net>, <ast@kernel.org>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
References: <9dbbf51e7f6868b3e9c8610a8d49b4493fb1b50f.1610381606.git.daniel@iogearbox.net>
 <299c73acafd2c20d52624debb8a1e0019d85e6dd.1610381606.git.daniel@iogearbox.net>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <1cf3b794-6b84-e6a4-bed3-6b72c480eafa@fb.com>
Date:   Mon, 11 Jan 2021 12:15:14 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
In-Reply-To: <299c73acafd2c20d52624debb8a1e0019d85e6dd.1610381606.git.daniel@iogearbox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:6450]
X-ClientProxiedBy: CO2PR05CA0101.namprd05.prod.outlook.com
 (2603:10b6:104:1::27) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::1158] (2620:10d:c090:400::5:6450) by CO2PR05CA0101.namprd05.prod.outlook.com (2603:10b6:104:1::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.2 via Frontend Transport; Mon, 11 Jan 2021 20:15:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6ee0b937-3c2a-4207-b133-08d8b66d9c8b
X-MS-TrafficTypeDiagnostic: BYAPR15MB2583:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2583CCF96A5B384BCD3276C7D3AB0@BYAPR15MB2583.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BWiI6j4fFo4/CpgmerWqkRR9zgvUFgtVHKG1UVGphNFL0Xv3X1WK5U+P6kq95ex2hKag9gLwINn4BGtQOMudzidY9anyXX1h2e3LmfHSZuTbXRQyllm8TmXcD7sxpTnTMEG+q4mIriRtu/qbU+s+s9emYWgZozotDgCr9xXmHgObzfEKiC5btOm1YPDeaCcY7W0vCzTG6p2uK3DplJ3HtgWx0OeAjX/SFytWRfOYdU5OVthwAyfuVIGbGF8u79wRApT/pvUlgJttMW5XknVvPPupVGrrfqHTVLqw7SI2nfn1qWdUkKc4MmlKDzQ9Vnmg+5B8urlNlp+OV+RlpwuBqEwG5sL536pNDeOSs2vertSzxQWPgEbjx8wV33bE6RaTel1qUXikmxo/KBu2dG2yaiR//Wuvf/PddyWCZ55QFHBJc5qFEA4xu0mvpCM0AksIucChjPxR9E/faaxFLtYAghLa7DKpXfy24RjVDxBHpTI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(376002)(346002)(366004)(39860400002)(66946007)(53546011)(36756003)(4326008)(86362001)(6486002)(31686004)(8676002)(2616005)(31696002)(66556008)(186003)(66476007)(316002)(52116002)(83380400001)(16526019)(2906002)(8936002)(5660300002)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?cDBvcUZnQ1VIdEtnQTh0cGVHdXFJdTBMMElZdGxSajdhdkxyMmdjWm5ncktF?=
 =?utf-8?B?dXA0aGc1RzZoVDFwL0hYU3lVajBUWnJVMnk0Nyt1QUhuVlJWdGZOZnE2UVNP?=
 =?utf-8?B?TW1zbE54OUt5UTh0dzRabUxqL2VnUURPZGxuTWg0RVBZWGI4dGI1ZzlUdXBu?=
 =?utf-8?B?S0VFaGQwTy9YSlh6RGdYNFY5SDVtcUNKeUpiOUlJQTNlTE9rUUNnenEzMWxY?=
 =?utf-8?B?S3JoOXdQR1AvMlByMGxWRmFzVGdVdi9oK2M3QW9Zb3V6U3VPNlhhWFA0VUVq?=
 =?utf-8?B?a2VOVEdUbWUzRGtNazBPeS9KVVlTb2E4aVMwbmNYaWFMMHR6dFNRVXdJTXJs?=
 =?utf-8?B?MVpuaEtENEdzT29oR2JQSm1KNVp1NC95bnpITUN1U2lHM3dLQ2NESCtLZE1F?=
 =?utf-8?B?THM1MVNEZlBCcUkyNVNsajBraGpQU3I0TnBHRzFDeXNmQlBwejdBUWFSVWpk?=
 =?utf-8?B?K0hZeXNBNVpjS0F5VmM5R1o2cmsvT2Q5WkJHRW5jSFY5Nk5wbWFjUkt4bytU?=
 =?utf-8?B?Y2ZrWlZwWUZIckJRY0doOGVkWkNUUXlNSXA4KzBOVVZkb1h5eHQzK05PWERw?=
 =?utf-8?B?L1B2Y0NYd3dUUVBEalE1emxuK1QwZ3lRbytncS9zUEllZ3VLUUtyYmRZUVBp?=
 =?utf-8?B?c1h1RHpFcUUrb1pmWWVyS3hmVFlNUzdXM3RsZ2E5QXR2aEJ4WjJqR0l1eUFF?=
 =?utf-8?B?QjNBMHA0WTV4NnIvaFVGbHpmTW5KejBtZVBJTEo4Vml5d3k4RVlmYVNKQ3NX?=
 =?utf-8?B?UVh1Mm5VOG1EcUN6Zm5TdTVEYnE1OGpUeUR2NWtVZTdPd1RPdlpGL2twN0xB?=
 =?utf-8?B?QXlXSUJVSVJUdHhoQzczUkI3MGYzdkFYMG9tNFZDekd2QUJCS0d0Y3RaUmlX?=
 =?utf-8?B?M2x5dXkyUEpLQWlqTW9vNFZocWJ5UjFtVlVoTURzY2hGay9GQzFWQmVEQWll?=
 =?utf-8?B?WVNnR0F6YlpNVFZNcUZ5ZDBzait1ZFZ6OVJobmJJNVNlMGh1bUxFSU5EVVJ4?=
 =?utf-8?B?TElQd0h0OWo5NGZ4cE5IdXZMWVpCeVZ3Z3JNMk9RUFhNNG1EQXdvNGp2Zk9B?=
 =?utf-8?B?NnU1VnQ1dHVpcDVacUo4eTZnMTNNUWZNWTdsNEI5UWI2WHp1V3JnTU5mc2N0?=
 =?utf-8?B?d2Zpd0psZGx3SUR2R2Y4SGt4YnNiT0JMNGZHUmIvc1dxbEMrLzVDZVMyWWZD?=
 =?utf-8?B?bG9TVUZrNlBNaUNSc1BlOUZxdTlvSXduVGkrK3BsNVVkVDc4VDVyWTFmQTNk?=
 =?utf-8?B?dGJNMnduMFJiVHFPMlBYcTBPQU83cHNVOUNvYmhqU3VQRktXWml5aUlCa0h2?=
 =?utf-8?B?UGJqUCtFSm1DYWV4dXZnWVRhT2FpUzZDbWpVMXdldlEreUdkZ2l1Vk1UT1F0?=
 =?utf-8?B?TGc3MlJLanBLVEE9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2021 20:15:16.5597
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ee0b937-3c2a-4207-b133-08d8b66d9c8b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r2MCudGuWa0NJk3RmMnB9d323/xCKwEbM6JGauMyERFNy5fB2mlKh41P3vBRrCP+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2583
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-11_30:2021-01-11,2021-01-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 suspectscore=0
 mlxscore=0 spamscore=0 mlxlogscore=999 bulkscore=0 clxscore=1015
 impostorscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2101110113
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/11/21 8:17 AM, Daniel Borkmann wrote:
> Extend existing cgroup bind4/bind6 tests to add coverage for setting and
> retrieving SO_MARK, SO_PRIORITY and SO_BINDTOIFINDEX at the bind hook.
> 
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>

Ack with a minor comments below.

Acked-by: Yonghong Song <yhs@fb.com>

> ---
>   .../testing/selftests/bpf/progs/bind4_prog.c  | 41 +++++++++++++++++--
>   .../testing/selftests/bpf/progs/bind6_prog.c  | 41 +++++++++++++++++--
>   2 files changed, 74 insertions(+), 8 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/progs/bind4_prog.c b/tools/testing/selftests/bpf/progs/bind4_prog.c
> index c6520f21f5f5..4479ac27b1d3 100644
> --- a/tools/testing/selftests/bpf/progs/bind4_prog.c
> +++ b/tools/testing/selftests/bpf/progs/bind4_prog.c
> @@ -29,18 +29,47 @@ static __inline int bind_to_device(struct bpf_sock_addr *ctx)
>   	char veth2[IFNAMSIZ] = "test_sock_addr2";
>   	char missing[IFNAMSIZ] = "nonexistent_dev";
>   	char del_bind[IFNAMSIZ] = "";
> +	int veth1_idx, veth2_idx;
>   
>   	if (bpf_setsockopt(ctx, SOL_SOCKET, SO_BINDTODEVICE,
> -				&veth1, sizeof(veth1)))
> +			   &veth1, sizeof(veth1)))
> +		return 1;
> +	if (bpf_getsockopt(ctx, SOL_SOCKET, SO_BINDTOIFINDEX,
> +			   &veth1_idx, sizeof(veth1_idx)) || !veth1_idx)
>   		return 1;
>   	if (bpf_setsockopt(ctx, SOL_SOCKET, SO_BINDTODEVICE,
> -				&veth2, sizeof(veth2)))
> +			   &veth2, sizeof(veth2)))
> +		return 1;
> +	if (bpf_getsockopt(ctx, SOL_SOCKET, SO_BINDTOIFINDEX,
> +			   &veth2_idx, sizeof(veth2_idx)) || !veth2_idx ||
> +	    veth1_idx == veth2_idx)
>   		return 1;
>   	if (bpf_setsockopt(ctx, SOL_SOCKET, SO_BINDTODEVICE,
> -				&missing, sizeof(missing)) != -ENODEV)
> +			   &missing, sizeof(missing)) != -ENODEV)
> +		return 1;
> +	if (bpf_setsockopt(ctx, SOL_SOCKET, SO_BINDTOIFINDEX,
> +			   &veth1_idx, sizeof(veth1_idx)))
>   		return 1;
>   	if (bpf_setsockopt(ctx, SOL_SOCKET, SO_BINDTODEVICE,
> -				&del_bind, sizeof(del_bind)))
> +			   &del_bind, sizeof(del_bind)))
> +		return 1;
> +
> +	return 0;
> +}
> +
> +static __inline int misc_opts(struct bpf_sock_addr *ctx, int opt)
> +{
> +	int old, tmp, new = 0xeb9f;
> +
> +	if (bpf_getsockopt(ctx, SOL_SOCKET, opt, &old, sizeof(old)) ||
> +	    old == new)
> +		return 1;

Here, we assume old never equals to new. it would be good to add
a comment to explicitly state this is true. Maybe in the future
somebody will try to add more misc_opts which might have conflict
here.

Alternatively, you could pass in "new" values
from user space with global variables for each option,
but that may be an overkill.

> +	if (bpf_setsockopt(ctx, SOL_SOCKET, opt, &new, sizeof(new)))
> +		return 1;
> +	if (bpf_getsockopt(ctx, SOL_SOCKET, opt, &tmp, sizeof(tmp)) ||
> +	    tmp != new)
> +		return 1;
> +	if (bpf_setsockopt(ctx, SOL_SOCKET, opt, &old, sizeof(old)))
>   		return 1;
>   
>   	return 0;
> @@ -93,6 +122,10 @@ int bind_v4_prog(struct bpf_sock_addr *ctx)
>   	if (bind_to_device(ctx))
>   		return 0;
>   
> +	/* Test for misc socket options. */
> +	if (misc_opts(ctx, SO_MARK) || misc_opts(ctx, SO_PRIORITY))
> +		return 0;
> +
>   	ctx->user_ip4 = bpf_htonl(SERV4_REWRITE_IP);
>   	ctx->user_port = bpf_htons(SERV4_REWRITE_PORT);
>   
> diff --git a/tools/testing/selftests/bpf/progs/bind6_prog.c b/tools/testing/selftests/bpf/progs/bind6_prog.c
> index 4358e44dcf47..1b4142fcdd4b 100644
> --- a/tools/testing/selftests/bpf/progs/bind6_prog.c
> +++ b/tools/testing/selftests/bpf/progs/bind6_prog.c
> @@ -35,18 +35,47 @@ static __inline int bind_to_device(struct bpf_sock_addr *ctx)
>   	char veth2[IFNAMSIZ] = "test_sock_addr2";
>   	char missing[IFNAMSIZ] = "nonexistent_dev";
>   	char del_bind[IFNAMSIZ] = "";
> +	int veth1_idx, veth2_idx;
>   
>   	if (bpf_setsockopt(ctx, SOL_SOCKET, SO_BINDTODEVICE,
> -				&veth1, sizeof(veth1)))
> +			   &veth1, sizeof(veth1)))
> +		return 1;
> +	if (bpf_getsockopt(ctx, SOL_SOCKET, SO_BINDTOIFINDEX,
> +			   &veth1_idx, sizeof(veth1_idx)) || !veth1_idx)
>   		return 1;
>   	if (bpf_setsockopt(ctx, SOL_SOCKET, SO_BINDTODEVICE,
> -				&veth2, sizeof(veth2)))
> +			   &veth2, sizeof(veth2)))
> +		return 1;
> +	if (bpf_getsockopt(ctx, SOL_SOCKET, SO_BINDTOIFINDEX,
> +			   &veth2_idx, sizeof(veth2_idx)) || !veth2_idx ||
> +	    veth1_idx == veth2_idx)
>   		return 1;
>   	if (bpf_setsockopt(ctx, SOL_SOCKET, SO_BINDTODEVICE,
> -				&missing, sizeof(missing)) != -ENODEV)
> +			   &missing, sizeof(missing)) != -ENODEV)
> +		return 1;
> +	if (bpf_setsockopt(ctx, SOL_SOCKET, SO_BINDTOIFINDEX,
> +			   &veth1_idx, sizeof(veth1_idx)))
>   		return 1;
>   	if (bpf_setsockopt(ctx, SOL_SOCKET, SO_BINDTODEVICE,
> -				&del_bind, sizeof(del_bind)))
> +			   &del_bind, sizeof(del_bind)))
> +		return 1;
> +
> +	return 0;
> +}
> +
> +static __inline int misc_opts(struct bpf_sock_addr *ctx, int opt)
> +{
> +	int old, tmp, new = 0xeb9f;
> +
> +	if (bpf_getsockopt(ctx, SOL_SOCKET, opt, &old, sizeof(old)) ||
> +	    old == new)
> +		return 1;
> +	if (bpf_setsockopt(ctx, SOL_SOCKET, opt, &new, sizeof(new)))
> +		return 1;
> +	if (bpf_getsockopt(ctx, SOL_SOCKET, opt, &tmp, sizeof(tmp)) ||
> +	    tmp != new)
> +		return 1;
> +	if (bpf_setsockopt(ctx, SOL_SOCKET, opt, &old, sizeof(old)))
>   		return 1;
>   
>   	return 0;
> @@ -107,6 +136,10 @@ int bind_v6_prog(struct bpf_sock_addr *ctx)
>   	if (bind_to_device(ctx))
>   		return 0;
>   
> +	/* Test for misc socket options. */
> +	if (misc_opts(ctx, SO_MARK) || misc_opts(ctx, SO_PRIORITY))
> +		return 0;
> +
>   	ctx->user_ip6[0] = bpf_htonl(SERV6_REWRITE_IP_0);
>   	ctx->user_ip6[1] = bpf_htonl(SERV6_REWRITE_IP_1);
>   	ctx->user_ip6[2] = bpf_htonl(SERV6_REWRITE_IP_2);
> 
