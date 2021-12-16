Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB3B1477CAA
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 20:40:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240844AbhLPTkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 14:40:47 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:50026 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236556AbhLPTkq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 14:40:46 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BGGXuZA022813;
        Thu, 16 Dec 2021 11:40:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=/iX0LkI5rzv47lwjIePsw62vNj2H9fVWExzKCb74iS0=;
 b=Ev2jakw1ZQfhtUikIuLSyysneYcMslT5qJ+hyLlUKhobw7WZR38s321auJ//v0d6sFfl
 nxcbZMHE7P/4Y99rXvye6XP5lZHarcpqDXKcChi1SujtqLZusO9rhfMyK8a5Uu2rZb1s
 fqT13fK1GxAzQcR1hOOms+VcdF5iT0dUlTY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3cyuqsxfuf-14
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 16 Dec 2021 11:40:46 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 16 Dec 2021 11:40:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gZE79fJFgBVWgEUOSU+5ozBIwMF4mlrA1gFlA31PbhM7nzdZvojI8V3fm5d4KfCy0BaPqzLI9K+CxgX3vFYiFXKZCVwLoh63mIv+dFITvivwPeDurEQTjnXaevJaFW+3iidiBXg6aMHvl7MwUrO85gxc9rj/8tZci0Q3fNoKPKXmgXwFsESz5bXiQWcMbzL1kaMdw6iaAsXqMhnXVEBxq4JyhtqCK6ywtjCU1cHjJoH/xMb0flP7Fn+NZ6yEu66XDcmnAjhn6BKb4wSIPSYLYQaEBG7xHwsTnJD4tlS+1xxSXqRjzANdCItsuCaQTzv4GO4Dj0jJk56DtkGbyeFWMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/iX0LkI5rzv47lwjIePsw62vNj2H9fVWExzKCb74iS0=;
 b=ESa1lLlKbgD6gUgXX+wV/b89yHhmR/7v0Svt/J/QLfiYbE/qLwVmqj3JUmfpv00NniEW6nHMtyh75XAPk7S3EWbgTESyJcYTbrVjE0Q3KO5jDEGhD68wG2EzvvvWk6wXQZA3m46DwQ9wj8ekSRLeSMSZYPT70wVhklQge1ZAhPPTd2ENAbrrTJqE4kgRdmWKZeuBodJc1NHfCPYdus3TUlqm3EtZdYzU5F3t2gcOIUlNemHeUrwW8ZGkbnUVkP9eho5mnjKOkrCP4m6Vn+Hjhl4MB6KRZFGxsxjM51nJayxGgGR27m4pgIY0qPC8Cful5VHQVlT4Q4n85QVtMWGZ1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5281.namprd15.prod.outlook.com (2603:10b6:806:239::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Thu, 16 Dec
 2021 19:40:40 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::f826:e515:ee1a:a33]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::f826:e515:ee1a:a33%6]) with mapi id 15.20.4801.014; Thu, 16 Dec 2021
 19:40:40 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Peter Zijlstra <peterz@infradead.org>
CC:     Song Liu <song@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Andrii Nakryiko" <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v2 bpf-next 5/7] x86/alternative: introduce text_poke_jit
Thread-Topic: [PATCH v2 bpf-next 5/7] x86/alternative: introduce text_poke_jit
Thread-Index: AQHX8Xk068zNrl6+4Em/+GWBLWr3MKwzRj6AgAJAa4A=
Date:   Thu, 16 Dec 2021 19:40:40 +0000
Message-ID: <C82FEB90-B8F3-4869-B905-8940DEBD6889@fb.com>
References: <20211215060102.3793196-1-song@kernel.org>
 <20211215060102.3793196-6-song@kernel.org>
 <Ybmyr3GB5+nZbso2@hirez.programming.kicks-ass.net>
In-Reply-To: <Ybmyr3GB5+nZbso2@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.20.0.1.32)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9f7e2ddc-9fb9-461e-fcb6-08d9c0cbf105
x-ms-traffictypediagnostic: SA1PR15MB5281:EE_
x-microsoft-antispam-prvs: <SA1PR15MB5281AB9F9D8C9C5205866600B3779@SA1PR15MB5281.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:1169;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YXVzIU+Xvki+YtQPs2iVWqfNM/0+xRvN+TefGngfyp3EscJiQ0ur3nArPhAlRhIEjqCI1BZ79oOH9U4rTuUzKcIDT7Gw+zei6ogLuGc1iGHRDvm5Z6O4Cb/S2ZRTtqyIFKT7gCCpkbI3ffBAAPZGtPJY3tou6oXO3yW833ZhrBQPhY7af2JY6XlcdUi84zDco8Zbc9Crr7/ibeO4o5jE6zUXwphnHXDKWTaDSnnc6HZySW/Ve0wMdcDe64axqG/eSSQWFNL3FoqhyVmJ7/uPoMWd4BMtjKqbFtdMj6gDpyRH3162Ex2XuX0KpBMVguy/aLqhOT7ZRxliu4ZGDZO82GPLWSOE0xAtk+ndTy4bNQZK2Q2/A0Gu3a+QVVtZ1TmhxHoGhIlArO3ubl2CRj6aS/sBSJPdo6liOrxm7BaZXLF7s0/nTuluIIfrdX2j+YGyKhK3Kd6QGcVyPCKeVxi5w2249VjA4eEhxFgTJxdHaBp8QbkhW+s9Ya7u3j1bZP1w0iN/APiFBsVDHRF5Tg4Rm0rJ4ThwV4VtZHTsJG85SpyLLb+oLxTbfYA2AoUHOIX3zejAdWzrgqUb2xRZBtb3ixgTOB0dF+vZt4m64OiKZtG+J/dmcVnzkgdrxO2rH5aCx1XAwyuDIYgIglJphnMTTfB0qHWVuAQN/9KqgHBVZ/LO5DO8r9ofeB4q3sVZBGf2110b/SQ2pGw5YfRt8CeGJA8R7aP/AP+UPbRXE9INIfrN/1T95rFOIuZcVU9KzXoG
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(76116006)(91956017)(38100700002)(2906002)(4744005)(186003)(6916009)(54906003)(508600001)(71200400001)(66476007)(66946007)(8936002)(8676002)(4326008)(36756003)(33656002)(5660300002)(122000001)(6486002)(38070700005)(53546011)(64756008)(66446008)(2616005)(6512007)(66556008)(6506007)(86362001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?LXq7rEHuoydh+0lsOki+xJ19DHapBR41JBVuwj9S8woKFz3z4fw7Zm8YK3Ux?=
 =?us-ascii?Q?veUO1Q5pdFLs8xiUDGWUqH+5kv26iTSrGkU0iBNMi6AAUcoanbTLhw1S7uuD?=
 =?us-ascii?Q?Ho4FGGl1tA8eKZnUP8cX5Fl08L7h3NW4M0ouvlu6iPi4lTRfdY0+GlzJhxWi?=
 =?us-ascii?Q?lKCtaNtl4ZeCguhHVHrBzAt8k+P1LoBcxdEupIQtQ8yAxf3ATNzQP474W86F?=
 =?us-ascii?Q?DQRgOqJqmrTVOGu6LyhOlrQSJQ18fkaa1ca+uwgZ8bYE1Q4V4KYZNOqxpj7G?=
 =?us-ascii?Q?ADr9EyaxfDXmxSEu/cu6i40B9AG/C2WJHfKk2rLo/NeWfEZ6gIYWmk5YdZ3T?=
 =?us-ascii?Q?D9+1FgWwN/WeTBUABMNo4hjwapRBUSH5CrLAbkqh+PMQ8gXwI5wT3aYOTI+z?=
 =?us-ascii?Q?JhLPfDXAnvvJjmnLcMjamwywUTpDwmMxCXNmdo19wDUWA/vdXALGhn8iI5OK?=
 =?us-ascii?Q?E2LCvMyftLjX/wP/eIdp0zztVwzjJXKh0xt07PZWfhdUxWdMpr9qd/Z5VhzI?=
 =?us-ascii?Q?uYp0osoEGdq1Dl4wVLU1CBgtOQKe3wxqKWhP8cUex3NHigDvz0VqsSaC0x4R?=
 =?us-ascii?Q?niWlRn/q3oiDtDJlrZNlMOMh/RG4VJ9a6QjYYRSfT5+8wDoPMxLCdEMiAAqg?=
 =?us-ascii?Q?MSFfDCWWtocY83QHEpax0E+HnKIsfIq20KEyv/BxMhhVJAfDU0I/WILFfv5N?=
 =?us-ascii?Q?TNAMW+SqsW5T5Dmu4gi8hMX3G4+BVpEIgJ72uLhxhKknDs6YYtSbRpaSleG1?=
 =?us-ascii?Q?OpzD7w6NW8UcgquT5I2/jEAuIYk/Rn6WCjD1roW5Wc7AnWU6E5fhZznc+ydt?=
 =?us-ascii?Q?Hf5AKU/RUaeGQ8Fet+0d5NSmmsV6L5wXsjoA5jDBeimjCq8Y7PZ+e4tp1ddF?=
 =?us-ascii?Q?MAuQeOfVclb1KJxGqfKSqFLQhrixB34Rrn0atnISbeFGrooF32Y31TULHjG+?=
 =?us-ascii?Q?2V60c1af0hq9goRHSIT570hWmgpExztUeDLkGFs/P1+MzaoCYKjPkaKu818c?=
 =?us-ascii?Q?YdGWJHSQJlx5VYJeKb7QkR9yq32WvAL9C0rsfAw2yheY8ruYJbqxpzLTPtpp?=
 =?us-ascii?Q?5VudwYvyimGva3+PfM+LojQ8eFpOeMG5YIdoXg9y2OMdhgm1YYrH+8ZF33B9?=
 =?us-ascii?Q?Q8yAFgGl496I34YPd2Wh51PdK0j8uOI2CIGlHOEc71MJO2ztkLbgSUTWDOL7?=
 =?us-ascii?Q?W5WxtlAeElTBl2fl87RhtqXncp7/1zGVUkUfnCNXTdRXPvXGJ6LVVZ8MxFRV?=
 =?us-ascii?Q?orr+q6K53z5b2EpjAWM2kaabpDmBA2+pnJON8DBaytpwhDieFHzfpGnGLF7t?=
 =?us-ascii?Q?WNcPfZhcFyzK6dMMnlwZeaoLDYZiB1LV/3QGvdDXuVvy4gZMSTbzpYc6zMfN?=
 =?us-ascii?Q?SVj2E5sfBd39OY4muE94Uczz33PEiCjIYmFX17uKHMuVm9WROrFrHMkS8mUS?=
 =?us-ascii?Q?ukGv9J+es+F2QQKndIPMZWwbOONDajC0HpQIK689gRizlRqsBGpwBaFQB1db?=
 =?us-ascii?Q?hudoZ2YoSvBqwDfToa1sjvGOY2ORMbwUEAxgSwkBKWF/w+kFGBhc/6uBw+2D?=
 =?us-ascii?Q?cRBBRgjrswiCnrDtNkZfDqGQbMrrXTIu3AoOgGmsLOYDfGKGtja1+pIvlm74?=
 =?us-ascii?Q?e5uQc7BIHvTmptuV2SlUsN4M1m6JCkPOFP0a0SlvGXITctJZVtcRbEJQcCUO?=
 =?us-ascii?Q?Ywmg9Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FFB8D36894F2D24686B6CED5FD605564@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f7e2ddc-9fb9-461e-fcb6-08d9c0cbf105
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2021 19:40:40.2538
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AjRgNd2Og6NSKavbWmGf/xNyHniFoRzuim7O+PeIPhVt6PHuDtPPLvuo2Fiqts9kA+G/RDF/EI+HGOAlUqBD3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5281
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: qOHWTRHqOJl14r-ht27h8NkcY15Lq-hj
X-Proofpoint-ORIG-GUID: qOHWTRHqOJl14r-ht27h8NkcY15Lq-hj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-16_07,2021-12-16_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 spamscore=0
 mlxlogscore=764 impostorscore=0 malwarescore=0 lowpriorityscore=0
 suspectscore=0 phishscore=0 mlxscore=0 priorityscore=1501 adultscore=0
 bulkscore=0 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112160107
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Dec 15, 2021, at 1:17 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> 
> On Tue, Dec 14, 2021 at 10:01:00PM -0800, Song Liu wrote:
>> This will be used by BPF jit compiler to dump JITed binary to a RWX huge
> 
> OK, I read the actually allocator you use and the relevant code for this
> patch and the above is a typo, you meant: RX. Those pages are most
> definitely not writable.

Yeah, it was a typo. I meant to say ROX. 

Thanks,
Song
> 
> 
>> +void *text_poke_jit(void *addr, const void *opcode, size_t len)
>> +{
>> +	unsigned long start = (unsigned long)addr;
>> +	size_t patched = 0;
>> +
>> +	if (WARN_ON_ONCE(core_kernel_text(start)))
>> +		return NULL;
>> +
>> +	while (patched < len) {
>> +		unsigned long ptr = start + patched;
>> +		size_t s;
>> +
>> +		s = min_t(size_t, PAGE_SIZE * 2 - offset_in_page(ptr), len - patched);
> 
> Cute, should work.
> 
>> +
>> +		__text_poke((void *)ptr, opcode + patched, s);
>> +		patched += s;
>> +	}
>> +	return addr;
>> +}

