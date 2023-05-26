Return-Path: <netdev+bounces-5769-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 48190712B41
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 18:58:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AC33F281958
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 16:58:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F7C428C01;
	Fri, 26 May 2023 16:58:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FCE92CA6;
	Fri, 26 May 2023 16:58:35 +0000 (UTC)
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB88ED9;
	Fri, 26 May 2023 09:58:32 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34Q7OvFB006960;
	Fri, 26 May 2023 09:58:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=17E265c56m6sDWidw1N70xcDNqx+RjWeBswLUuTRNkQ=;
 b=Dp4xRjFGvURMM/gro79IEHvO7KNrFo/tIs0LVXGx7p1k0UUUL6aTIfxX0sU6Ta25ZnHv
 hxbWTdg+hRcTUT8iLgRYSjHZmTgm48yNUovRcYWNC42Gs2gamAj9hSeFOHfJw8K5tCY5
 oatzWZg5+Z1VDg/QKtfqPGd/+Tlv3qJEwMZoVbNX0kmfRxxkbjoIG/icLaEBWHSvWMvT
 tgZ5U5pNUGtKFZIZn5HObi6VAxmh5bwWc8BodYdeqnBncwa4duwL9cUeflEugtepMHTq
 l4zHr9/h4UKVYBHJUID6/5AUbaFa5F3e5IjCouXNH/HpdYRhcDTjaa72T8WYryqSC/7o FQ== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3qtrbvk5ec-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 26 May 2023 09:58:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AgCeTijbKuO/p2n71iyDc9D0f78oFxfg7M9O+oXvPTTfDQvnovLHSH11iXy/l3j2TRZ+ScDtMYVEYL5GNuaqOxB5XjUdK9CqeZlqomyYsKJhbZ3ro7nKTfnWeETBakeCpZkSXh2xlUAAjVySyG5BDiCn405v8JDcrnxInHzgo/npfScTCZkEBXvbMXw0qyxd/R9vgoiBel0fLcYSchdp7PXSUpWyaHpfpzAqb4zQHiC9qoXdpYjvfoyaiVwRYsoyb34cQajEEGYTyBfyyRjLSJVBVOo1qj/FG5Oyk3NGWYLeD8acZqNYiJ5iNC3Hyp/8x/2q9BCqEHfK54hcTKAebQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=17E265c56m6sDWidw1N70xcDNqx+RjWeBswLUuTRNkQ=;
 b=dwZUU0k9eEY6TwYDTDncemgc74Kc+n+O4P9lNhWchQ9U2XnkLBfSiwXQ+oWfbqMuwEZ6ANVOnHNBmz08+A3VfqUDapcdkrzZTJwm0+Gu2A7nf/OV9F433FiT46XuWFr84+TxWR20tn3HTYfd+Bg58O4FctawE5YWW5Q8ZW/GXG/48CWS7idAsOagZa65oC/fzribcQDRiPfB7X5YAVzAkE3jCJi5ypOKSD0kTTL52eeLjCxt/bW+TapDynougkNqRTx80BPKLuDw2slMGCf1Qh5At3OEedqMG2aZEHVacNpem7qjI2PIoSFZZAjL6EEve+ymFCiX6z3IBvdRAhgPMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by CH0PR15MB6116.namprd15.prod.outlook.com (2603:10b6:610:18c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.19; Fri, 26 May
 2023 16:58:23 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::bf7d:a453:b8d9:cf0]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::bf7d:a453:b8d9:cf0%5]) with mapi id 15.20.6433.016; Fri, 26 May 2023
 16:58:23 +0000
Message-ID: <d8184124-3ff6-9c3c-07cf-78407738d616@meta.com>
Date: Fri, 26 May 2023 09:58:19 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.0
Subject: Re: [PATCH 1/2] bpf: add table ID to bpf_fib_lookup BPF helper
Content-Language: en-US
To: Louis DeLosSantos <louis.delos.devel@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc: Martin KaFai Lau <martin.lau@linux.dev>,
        Stanislav Fomichev <sdf@google.com>, razor@blackwall.org
References: <20230505-bpf-add-tbid-fib-lookup-v1-0-fd99f7162e76@gmail.com>
 <20230505-bpf-add-tbid-fib-lookup-v1-1-fd99f7162e76@gmail.com>
 <6470562cac756_2023020893@john.notmuch> <ZHC9BzCv6KiAUpbj@fedora>
From: Yonghong Song <yhs@meta.com>
In-Reply-To: <ZHC9BzCv6KiAUpbj@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0009.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::22) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|CH0PR15MB6116:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ab3deb2-9b64-4773-5948-08db5e0a6a5d
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	eXB7wmvnXcKJOSeVGt1/JEyPZA+2Sb0m7HpQPexHf6nIOdZhgGDBmY+z8ED6TXY5/saC0ozV9S2aGndSgan34d1H51n3PsCAh8wT3BFOVIJYwSKlCibdww6Mwt3J6Nt80UrpONGgkqV7RVzfy0Zz9+mcFvm+V3WfzKOGMnbY13e8s07/uyNXmDP/ostR0JWIJu7o+BFFSJ3bkgWF5wDpvVNwZv0r0xI7QJnOmwYPOC9pesFRGDuASRwYeKypUnZ2zWePaWMZNChDGzXqe14vzJaIAKkpECs4hjoedAgcyjAsorRyBa49QfjRP+W05wugDYaLFWIouFG3u1WPJEU2oiXH6YfqfVwujazH1W6MHrqRU0X4J8MSXXQwuU+l8B+aJMSXL8bq9QeA9s9WOZmcqE+1aP0ezCdJGB+W6uBjGQbsM4JBqef7GFVmIu1tNJuobCpIIEWrys+V6YG70bwQhk5PizGp6CpWcbb1I4z38CRFotAaPgVyUgf01TczUyvA5UERgrVGGqBuPqHB3XG/yG4mcCAYPcAX2AqDNiaKzvAs7oFmFzyklnKOW9A3UxoEKhEM0ODDT+SzJMwTswO7VLpRy4pGEOKuO7atWntIlBxO0i4po+j/ShS/QOcbkk7HxPmsTrFYO68z9XR84LERCw==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(396003)(39860400002)(346002)(366004)(451199021)(31686004)(110136005)(54906003)(186003)(86362001)(83380400001)(478600001)(31696002)(2616005)(2906002)(66946007)(53546011)(6512007)(6506007)(36756003)(316002)(66556008)(66476007)(38100700002)(4326008)(6486002)(6666004)(8676002)(41300700001)(8936002)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?cDVDOTJSeGZ0MFlJYnhsNm53NlA3R2RFVjFSTFAvM2JkU2V5aFBoa2I3RVp3?=
 =?utf-8?B?TTN0aDZ1NFdCd3kvcWNrMk0xUW56OURYRFF1cDlZcXNvYTB4SHlRdUp2WUJp?=
 =?utf-8?B?TDdoMHliN0ZGRFNadHRCRTJ2T1hUcWhoeFdNSTd2NDRpUDY1a3J1bzBTdytF?=
 =?utf-8?B?OEdoS29US0FYZHI3aXY1N2ZlUytUSUh5T0NieWFnRmxLQ1V1QnhadkZMQ2tL?=
 =?utf-8?B?c29icCtOWVJTV1cwV1h2NUhMZXB5M0xwcFBuNjVVN09IdFBKelNXVklBak1v?=
 =?utf-8?B?ODhqa09vYmJLVnVpdUdsNlJDZVgrMzJNTllqaEIyK3FacjR5dG8ydnlxTkJQ?=
 =?utf-8?B?TEVJYW1rL2p1d0Z3aDFhWFhjTHhtSlBPWFVPNEhyaXRDVFVWVnNQY1puSnpB?=
 =?utf-8?B?ckIvbVdGMGVJUHNEbjZTcjNFQnNZVEJyTWUvb0M1VTJPdk1hM0VTRDk0ZW8x?=
 =?utf-8?B?SFp0VDZhRHJ4WjAyTDZQK0VPa21SVFAxOU9Eb0JvbWpobFhjWWtUcit3NzNC?=
 =?utf-8?B?SHpYMzlVWVp3Q0pLYWF0bDhUcVdJMnVCTVE1SHRWalAxK2I2S3ZqQlB1N1RY?=
 =?utf-8?B?THVRNHRMekJjYS9oOU50U0ZvcGEwUDg1emxOaGF5NjJLQUpjSU15bjBaa1Zm?=
 =?utf-8?B?ZHR3VnNNelFzbjlZZU9NK0pwc1hZSitqUFBQNGVmUGJuaXczSytuU3NPaEZF?=
 =?utf-8?B?SG1yVUJsNHRXL3NNWGFuNWkycFJTQXZGWkdjMXI2VHVEbExPOCtXMEFzajIr?=
 =?utf-8?B?WFZzUkNZQXFKbGlFS1d2dndPaW1JVDZKTFZ0TUttN3pROSthSWNCU1FyMlM3?=
 =?utf-8?B?R2JyMmxsQytXaVRiL2hhWWpZTVdydHVEREhPdmV5WmljZHJmUzhrTVUrOFhn?=
 =?utf-8?B?cStpZTlDL0I5RnpWdk1iVDRNd21lZ3dNVFd0ODIwUWFleDJuSUpYV29nYTRQ?=
 =?utf-8?B?QnhuSHdVaEIycTBZNnRqdi9QUEVYdkdDMmpmTjZmazVoSmNXWGxkQTdPbktE?=
 =?utf-8?B?dDlpWVFVckxyZENpUEdyREFCMCtPZHZZekN2Nml5UUxld3dnN1UxTHlKRVVa?=
 =?utf-8?B?cWFVUXo3bWRiSUdQMnpjMXlJZmtNdStCclg4VE5wUWd1KzZOZE5TT1FBbTV3?=
 =?utf-8?B?T2o0SCtKNDFhdXdxRlk4cXVTSi9YT0pQZmdxSnR5V2JJeVJtQ2NzK0VTNGZm?=
 =?utf-8?B?MGw2MysxUUhCWUgvUUFMZHdsNXkyOU9jdkdid1pjQWpqcTUrb2Z5MU1FY0h0?=
 =?utf-8?B?Yi8wVlNKWkg0dGVScSsvMW5XbmlTV0hOMkhZcGNLMmx3OC9WaGRCTHBvQi9u?=
 =?utf-8?B?dnRTZjZxZXoxR1orckd2cDIrQlNKRm54SXlVYUtkYmh3REtTbC9ZdjNXcEZ0?=
 =?utf-8?B?QTNHUXlvNDI0VEZhdm9aQWxlNmhCdXArWkUvYndEeFJmTEZwTlpHU1pzNmZu?=
 =?utf-8?B?QTU5NnJHcDkrWWpFelUzd1EyTG1mR1BQeXUxZm5JWExrR1hCT1Vnekw2OEdN?=
 =?utf-8?B?bWNCclRvUmZKK3Arc0NycTBtM0VPckw4aWtpTjVIOWdFWTkzV1BFVGJXSTM2?=
 =?utf-8?B?QUk2aU4vWFhwTlQvUFlDeHFPRWdkVU9aWFJMcUFKOTVNSGs5b0JuakhFUE1o?=
 =?utf-8?B?REFEYzRWczVwRDZWMGsrTzdVZ3lSUzRwVjhvY0tDS1VUbCtMLzZxSWo1czhs?=
 =?utf-8?B?S2tCU0RPcXgzK2dBMm0wbHFGUFhZeHNxaTJuWHh2dVNoNklReFp2Zmg3Z3Fi?=
 =?utf-8?B?WWNtcEZFcHExWUNyVXVzZGt3MW9oU3Flb3FjblNtY3R0eGQzRUhFMmwwQVRF?=
 =?utf-8?B?ajllOHByU3dFWjBaQTNCOUJEaFR3VFUvVGxHQjA5RnJxQTc1dWtIOUxtVVJ1?=
 =?utf-8?B?MHdZS1VuT2NwWlIzSnhzTmZDNDlJQXV0d0d0S2FwM0x1Wk5DM2JwdmJpa0pO?=
 =?utf-8?B?Ym41dXYrOWVOakhGalpEMkUxUmVsQWtaeUNnMmcrWE1JQ3pFZlhJa1ozYSsv?=
 =?utf-8?B?di91blcvYXZBOW1LSHlZVGhiMVhLM2hITEV5ajNGTnYwZC9BVmkwTFlMcnNJ?=
 =?utf-8?B?SnhIaFZmNm9xVmtBclg2RlhBaFhOSm9JOWVFVURKTHpkbFFBNHI4VDRXVTA4?=
 =?utf-8?B?eEFwTXNZNXV4RGNKSkNxWWR5bkpENkhzSGhVakcxSEJHOWFLeXV1TWRkQjAy?=
 =?utf-8?B?S0E9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ab3deb2-9b64-4773-5948-08db5e0a6a5d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2023 16:58:23.1469
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +frZ0fGp9qfYBfX7pVPq7OaqjSYnr5A75cA7vD7Sav3TBeJe4jfQ5tGA9RYr6l/D
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR15MB6116
X-Proofpoint-GUID: _R0GmAPOQYN2XsSPFynaCAKXcr1ck6b4
X-Proofpoint-ORIG-GUID: _R0GmAPOQYN2XsSPFynaCAKXcr1ck6b4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-26_07,2023-05-25_03,2023-05-22_02
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/26/23 7:07 AM, Louis DeLosSantos wrote:
> On Thu, May 25, 2023 at 11:48:12PM -0700, John Fastabend wrote:
>> Louis DeLosSantos wrote:
>>> Add ability to specify routing table ID to the `bpf_fib_lookup` BPF
>>> helper.
>>>
>>> A new field `tbid` is added to `struct bpf_fib_lookup` used as
>>> parameters to the `bpf_fib_lookup` BPF helper.
>>>
>>> When the helper is called with the `BPF_FIB_LOOKUP_DIRECT` flag and the
>>> `tbid` field in `struct bpf_fib_lookup` is greater then 0, the `tbid`
>>> field will be used as the table ID for the fib lookup.
>>>
>>> If the `tbid` does not exist the fib lookup will fail with
>>> `BPF_FIB_LKUP_RET_NOT_FWDED`.
>>>
>>> The `tbid` field becomes a union over the vlan related output fields in
>>> `struct bpf_fib_lookup` and will be zeroed immediately after usage.
>>>
>>> This functionality is useful in containerized environments.
>>>
>>> For instance, if a CNI wants to dictate the next-hop for traffic leaving
>>> a container it can create a container-specific routing table and perform
>>> a fib lookup against this table in a "host-net-namespace-side" TC program.
>>>
>>> This functionality also allows `ip rule` like functionality at the TC
>>> layer, allowing an eBPF program to pick a routing table based on some
>>> aspect of the sk_buff.
>>>
>>> As a concrete use case, this feature will be used in Cilium's SRv6 L3VPN
>>> datapath.
>>>
>>> When egress traffic leaves a Pod an eBPF program attached by Cilium will
>>> determine which VRF the egress traffic should target, and then perform a
>>> FIB lookup in a specific table representing this VRF's FIB.
>>>
>>> Signed-off-by: Louis DeLosSantos <louis.delos.devel@gmail.com>
>>> ---
>>>   include/uapi/linux/bpf.h       | 17 ++++++++++++++---
>>>   net/core/filter.c              | 12 ++++++++++++
>>>   tools/include/uapi/linux/bpf.h | 17 ++++++++++++++---
>>>   3 files changed, 40 insertions(+), 6 deletions(-)
>>>
>>
>> Looks good one question. Should we hide tbid behind a flag we have
>> lots of room. Is there any concern a user could feed a bpf_fib_lookup
>> into the helper without clearing the vlan fields? Perhaps by
>> pulling the struct from a map or something where it had been
>> previously used.
>>
>> Thanks,
>> John
> 
> This is a fair point.
> 
> I could imagine a scenario where an individual is caching bpf_fib_lookup structs,
> pulls in a kernel with this change, and is now accidentally feeding the stale vlan
> fields as table ID's, since their code is using `BPF_FIB_LOOKUP_DIRECT` with
> the old semantics.
> 
> Guarding with a new flag like this (just a quick example, not a full diff)...
> 
> ```
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 2096fbb328a9b..22095ccaaa64d 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -6823,6 +6823,7 @@ enum {
>          BPF_FIB_LOOKUP_DIRECT  = (1U << 0),
>          BPF_FIB_LOOKUP_OUTPUT  = (1U << 1),
>          BPF_FIB_LOOKUP_SKIP_NEIGH = (1U << 2),
> +       BPF_FIB_LOOKUP_TBID    = (1U << 3),
>   };
>   
>   enum {
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 6f710aa0a54b3..9b78460e39af2 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -5803,7 +5803,7 @@ static int bpf_ipv4_fib_lookup(struct net *net, struct bpf_fib_lookup *params,
>                  u32 tbid = l3mdev_fib_table_rcu(dev) ? : RT_TABLE_MAIN;
>                  struct fib_table *tb;
>   
> -               if (params->tbid) {
> +               if (flags & BPF_FIB_LOOKUP_TBID) {
>                          tbid = params->tbid;
>                          /* zero out for vlan output */
>                          params->tbid = 0;
> ```
> 
> Maybe a bit safer, you're right.
> 
> In this case the semantics around `BPF_FIB_LOOKUP_DIRECT` remain exactly the same,
> and if we do `flags = BPF_FIB_LOOKUP_DIRECT | BPF_FIB_LOOKUP_TBID`, only then will
> the `tbid` field in the incoming params wil be considered.
> 
> If I squint at this, it technically also allows us to consider `tbid=0` as a
> valid table id, since the caller now explicitly opts into it, where previously
> table id 0 was not selectable, tho I don't know if there's a *real* use case
> for selecting the `all` table.
> 
> I'm happy to make this change, what are your thoughts?

Sounds good to me so we won't reject legal table id.

> 

