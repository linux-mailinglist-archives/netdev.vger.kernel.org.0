Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42D3948B3D3
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 18:28:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241661AbiAKR2X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 12:28:23 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:31726 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344591AbiAKR1s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 12:27:48 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20BHRimB014650;
        Tue, 11 Jan 2022 09:27:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=hZhlKcXzkEzAVrhZ3zOx85mpzLNGUhUa/5BPK1xX79o=;
 b=hof8kVtRm8b9zZdvwSN1gTfbUzeTUfb9AVL7rbxjjzoPD1Ll3mP6AvDXie/RHDKfDioE
 hK4deSEQlBBG8w81crGlLEOI2d1SeG4NT0JXwm1/K905YZ4eJc1IY2E9ITfxjj14U6Gm
 mItWk6tK1dglvfaULCxmJt0QkJLbW21Z3Qw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3dgtfff9u9-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 11 Jan 2022 09:27:46 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 11 Jan 2022 09:27:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fw3120tAIJyIxoNcuFDoeLD/DZ1ymqsSPMSX5/ZSCsy2Moet7dD9F9NfOz+dtuPD0o+RDCPkE5qeDgFxIgAD1u1SJwz5+DqoaeRTNpItPPlVQ//08QdhO9LNvIX1fFfWxReNyRRo+Ax97ZW2I2gCanFy2v6rOXgV0d5mRkYWhTt0RnlOPSphpRoXEq8q/Qfq6iqZl9LZqZV5M1rjpGyO1ISLKe0V869kcVL+3CQXaHKPMWDCvFwDwGZl/lvX+NMBjQzZMIr7PC/LWsIR6XCKsv84aJKYfqKhMuLqItWFk4gsLSv80Ov4ZxDTh0W3dUp6j9+72Tp44A+Q0xyezDMHjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hZhlKcXzkEzAVrhZ3zOx85mpzLNGUhUa/5BPK1xX79o=;
 b=BL22P+NiVNDQqLHw2/d74vGUt18l6RLtRtCivwGQsjdmmG+zpv3S60C+vdwRHnMck4NkyWIs9hrt20bEdYMYmHGBBmHGQmkvBa7iiLUop7qxgrMmomlsrOsoKKjZvBI1oydr9sLFFBHAOThrEBqU/J9FaZxonLian2tmdRKUWW/+2s1y/+aT/aGzUvl8Iyu53uW2UgiDaugDq5q88dOH24+jY8eiKXxAuZewHy+VOhBZiAa36FCbcEPUpp40kGkTFxL4FlL7ZiJc0yUr+a0bBWpTv1OodxvjfWG0ar3y5zq704DQgchnjMHnDLsEO3hlHcRd5OE2uXz/JViLTbbdMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5187.namprd15.prod.outlook.com (2603:10b6:806:237::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.9; Tue, 11 Jan
 2022 17:26:55 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::1d7e:c02b:ebe1:bf5e]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::1d7e:c02b:ebe1:bf5e%4]) with mapi id 15.20.4867.011; Tue, 11 Jan 2022
 17:26:55 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Peter Zijlstra <peterz@infradead.org>
CC:     Song Liu <song@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 bpf-next 7/7] bpf, x86_64: use bpf_prog_pack allocator
Thread-Topic: [PATCH v3 bpf-next 7/7] bpf, x86_64: use bpf_prog_pack allocator
Thread-Index: AQHYAqTI9fXucKh4qEa4ZUFl2xLE9KxdwWcAgABaKQA=
Date:   Tue, 11 Jan 2022 17:26:55 +0000
Message-ID: <F8E1FCB9-C168-454D-B765-DF1F65370ABF@fb.com>
References: <20220106022533.2950016-1-song@kernel.org>
 <20220106022533.2950016-8-song@kernel.org>
 <Yd1yPATp1viijqbi@hirez.programming.kicks-ass.net>
In-Reply-To: <Yd1yPATp1viijqbi@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 095b1b27-ce66-4f82-99d9-08d9d5279066
x-ms-traffictypediagnostic: SA1PR15MB5187:EE_
x-microsoft-antispam-prvs: <SA1PR15MB5187EB83E11B512D00A6699BB3519@SA1PR15MB5187.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:826;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Cvblkh+brRRPIosw1ZSxuC5JPE0RgjkOmmHGbSAAFoxMG/a4KTELTMtvYjflRMkzqEFZG9j1quLpPR+O8++gZ9PPNaAaZpmX3ANWyr9q/ov9rAEvAJDWhDACWeClmhrczAQH/abTLjj06iMIp6kgA/DDRzdiqdX4JBkPOs6Z/NogsEP9OfmXG1IGDuj5RzuX9EuQnFBNpNKvdABbdQNtPdSzS8KYT7k/G1yfhDyrKOmYZN2gLjhsPJ3DOL4oGorKK5GPXRSBA0aHP3jfGWN50TPM1wwdBfkNXUqSp8tRX5e66zkLwb9vpHKiV5/MK3vJpJgldf3zxbY5rv9y34dfio4xrpL4EOYpkfoaZDVEzch7wjDvoqjJLeDSQxFNTDqtK+82GaAJU766bShkJWVoM873EMVn2qvHlczPhSSAmfg/vXIDK6R3tUkFs3aG57jO6sEnHv1/VqXoNYM7Z7KiDsosLcgaafDNA83MfuLpLg+R062QS8BDMpzGiWQFLSANgorjMlTd3dFk16X3Aj9ENqKLcHaTpAgscab2uw2phxoGfCO9s7cO2WO+yo1IpDDXrTgqPZvYO0wUnjQswTtrq18PB8DtQOxdlVCSdl+hOuleY6qz2WRBdHiEy/nuD07uCkG7Y3RLkgvU1QUk8ZaJ5XnNQIdO27ERXr3NhfViW1zKJ6C7SB/2pRm2cm32LiZrubfjow322xfy0Ib+uo/rNQtg030yslqJz8BpBTLR4TQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(2616005)(33656002)(38100700002)(122000001)(6916009)(36756003)(71200400001)(6512007)(86362001)(508600001)(66946007)(53546011)(76116006)(186003)(5660300002)(8936002)(316002)(6486002)(66556008)(66446008)(64756008)(54906003)(6506007)(8676002)(66476007)(91956017)(83380400001)(38070700005)(4326008)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6XTyoEIX1NG16vzgtO1zuyp7TtSi9CkP+6NXJvMfAi1rSmOZE48Sej5kKmdj?=
 =?us-ascii?Q?g2M5SqPPlgHT8OCj9V5qXFmGetNztpRzDj+4c8zw7moUabdlFri5FI8zXYdh?=
 =?us-ascii?Q?3PzBf9BQXIk6h5CdiUqHDcgjBCVKRbBXQfEqgoC6kDAJ6mHbiZfAX0lTV3xI?=
 =?us-ascii?Q?A9WQb+i7nTPX539pFOFsG+oVSsBONBCkywRKeIIj50hpkAytc5aXAUxBCAnW?=
 =?us-ascii?Q?cYdzRku9sS9j8gNquN0Q/Wya9/5D9cpF7YNIkZKVKM3CqV93oq7buDPNc4Lk?=
 =?us-ascii?Q?70zXzF5FNJXwagUIed+vs8aTUsCD6F5boJtpgjKdaxGy2wDsHBqIpxlmfP0B?=
 =?us-ascii?Q?cEURGLu+BUOrQ51AsKnEyVe9xp6fXTw2m7NCEBN2haOj8z+Mzgh34eWcLgOH?=
 =?us-ascii?Q?VHK2pp18tTeJl/9eZJIXHbX9o1rVfA1hIf1XSryOt0AVzzhDci7CTCkzAa2k?=
 =?us-ascii?Q?4ZOVx9cRjXxk/LyugMdSCp6GzimDOKApQJU49HtYRk5BEQijWREnS+z+nshm?=
 =?us-ascii?Q?9RL9/ELbuR2iOnSlxsyFUtFmmDtuePg1OR3fAnuNOBhT63XonDOL+nxmn0QG?=
 =?us-ascii?Q?tW+F0a4WTzFPQcvm0O+xc5GfxLQ3K1XPhZ1+fpz6ivOv7jksPxWQkFpizreG?=
 =?us-ascii?Q?NdiuzQV7EaYnNqc0GbmB3oUmGLzgyQNGAaHOuoa8nWCMK0k3XtOfJqGEi6kw?=
 =?us-ascii?Q?OfPlgyjPjvErVtyLLMlFaRGmxerWh9P5zvVelFAb8HhQp64/13Hn6MZ+6vV2?=
 =?us-ascii?Q?LPK4A5buomK1+XXzPoi4UbS7/h+K/sDxQ0UyY0t6c3GwMdyoolv220bTVdVa?=
 =?us-ascii?Q?9/KQsFed8LEj86KZirMtnjtDK9TMUZ+KO0v92vcJw6LWIQYqVBrsNN8YDZ+R?=
 =?us-ascii?Q?J+CbYRKZv7koJS98Fd4H1EJu2Z72UQf5ysFl+1F01THrWU9kYE8OuDHTLy3j?=
 =?us-ascii?Q?HzHCUyvvu/ZlG6T3YL047xsVbQ8aCtM6KWDmwcGf6NAMyDL9JNL3o4BRdZ8j?=
 =?us-ascii?Q?j8LLn1Dhc4qwlIBv/RGyrArwmL3Wnu7xt4La7vyyhXxWftbiO7xtO2icxgep?=
 =?us-ascii?Q?YNBJoYZJYCd2qNeOFOZgxo88OOrMcBfDP650gGKhOabEyDM1vMdYOw9KNMmH?=
 =?us-ascii?Q?BCPLZQbA+cIIjLdtVDU/t19S51ajCJqRIB9Mswb/hpmJdodxJdnmxr5kyHfV?=
 =?us-ascii?Q?w+QeMj5Zpb95JnzZ4cNwzF0uuN7B8x0ll6UmXB+CmX/QUnmXql6R5EnDgON4?=
 =?us-ascii?Q?VJkYqC+NoI1E04QV/h8PqmLycNeKSJqO5YP5ef02LxpMjQjpsTsDaPJfPTci?=
 =?us-ascii?Q?TBxydkRKGJw/FTtppZv6Kldw7zwgKeQSuUHtoQMDlRbI4uvclM8bvyV3iW1l?=
 =?us-ascii?Q?FkmoqbL4CAw92fb1EzU0JX/uNU0/tyK9RdWA732Mjc8njIBgjiWk1wdDqlMZ?=
 =?us-ascii?Q?ezQAsi7omTApoKFBbksL0HUOcbvBCb1b5iYN3V+jIG3IH8g3a+5BPWXcxO9b?=
 =?us-ascii?Q?vj6B2J/b6MMH0jm7XcauyABJ6CJ0hWPLVc+bBIArNHyFePDMBgj0dYSZUIGI?=
 =?us-ascii?Q?F4bTMOG4m7yYMHqv4o4Q7DvpdkVlT/uLRsUw4nr3izltFWbuBtpK9qrnSd9d?=
 =?us-ascii?Q?UsQT0ol7RFXcVmb4n1TootINUV9pr7vgLgtomraKIv5osH3HQf8ovucIDRxT?=
 =?us-ascii?Q?uau0MA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <469144ACB9848C4CAE8A6138596FCE2B@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 095b1b27-ce66-4f82-99d9-08d9d5279066
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2022 17:26:55.2094
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: d+5Jee4rYqYYLJSzD6oaeqlDz658+h6AavdDiLeOhv+1OB/DCyZPPEsuKMiynqdQphwpd14RUd6s2hZkZmdU2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5187
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: B5GJoVHWW3pUqMl9lHwnqnz5dyN55ul2
X-Proofpoint-ORIG-GUID: B5GJoVHWW3pUqMl9lHwnqnz5dyN55ul2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-11_04,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 bulkscore=0
 priorityscore=1501 malwarescore=0 adultscore=0 mlxscore=0 suspectscore=0
 mlxlogscore=981 impostorscore=0 spamscore=0 lowpriorityscore=0
 clxscore=1011 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201110095
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jan 11, 2022, at 4:04 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> 
> On Wed, Jan 05, 2022 at 06:25:33PM -0800, Song Liu wrote:
>> From: Song Liu <songliubraving@fb.com>
>> 
>> Use bpf_prog_pack allocator in x86_64 jit.
>> 
>> The program header from bpf_prog_pack is read only during the jit process.
>> Therefore, the binary is first written to a temporary buffer, and later
>> copied to final location with text_poke_jit().
>> 
>> Similarly, jit_fill_hole() is updated to fill the hole with 0xcc using
>> text_poke_jit().
>> 
>> Signed-off-by: Song Liu <songliubraving@fb.com>
>> ---
>> arch/x86/net/bpf_jit_comp.c | 131 +++++++++++++++++++++++++++---------
>> 1 file changed, 100 insertions(+), 31 deletions(-)
>> 
>> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
>> index fe4f08e25a1d..ad69a64ee4fe 100644
>> --- a/arch/x86/net/bpf_jit_comp.c
>> +++ b/arch/x86/net/bpf_jit_comp.c
>> @@ -216,11 +216,33 @@ static u8 simple_alu_opcodes[] = {
>> 	[BPF_ARSH] = 0xF8,
>> };
>> 
>> +static char jit_hole_buffer[PAGE_SIZE] = {};
>> +
>> static void jit_fill_hole(void *area, unsigned int size)
>> +{
>> +	struct bpf_binary_header *hdr = area;
>> +	int i;
>> +
>> +	for (i = 0; i < roundup(size, PAGE_SIZE); i += PAGE_SIZE) {
>> +		int s;
>> +
>> +		s = min_t(int, PAGE_SIZE, size - i);
>> +		text_poke_jit(area + i, jit_hole_buffer, s);
>> +	}
>> +
>> +	/* bpf_jit_binary_alloc_pack cannot write size directly to the ro
>> +	 * mapping. Write it here with text_poke_jit().
>> +	 */
> 
> Could we move this file towards regular comment style please? It's
> already mixed style, let's take the opportunity and not add more
> net-style comments.

Aha, I didn't realize the file is about 50:50 with the two styles. I can 
change it in v4. 

Thanks,
Song

