Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAA56369A77
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 20:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243688AbhDWSyo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 14:54:44 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:65410 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243438AbhDWSyk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 14:54:40 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13NIrmd3005667;
        Fri, 23 Apr 2021 11:53:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=mKzHcACKF4Fa1hyO/sQzTEIQspI7SNQRC2JWIehHi94=;
 b=S/P8lc84zYLiDBUQBWoOUt/bmJipaKUt2+j0EWRqGvHMCmJLTPdKy08HnIqL2tpd5xJk
 0E7/K/rA70VVtblHOBwMrwQv9UuWysWUZKf3cq4YvrbPdKL0sP/PlxQzsJVeCwNlO41q
 0Fuob6c5wAz6g/gRN/NsN1c7pwf7MKJyTvU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3841bqh13y-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 23 Apr 2021 11:53:51 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 23 Apr 2021 11:53:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ivjP7v2Eh7CEACqleqwIZ/iF8ZusFgQHzv5BpdeJUkFwWNw/qtQIzlMwPzNi+DYLj5OE/agHSPKovYnl33KGAMMv2Lq7I00fzOeyA7j5FGC1TmnW1JouNN09Ce8WamTGmm+VRpg/0mfEu+uQjBlpQoIvOw9IDBrFa5tV8gjwhnsV0avedJY1B1fXvKD/NHNejw4f77QGsa8dGTfUGS/nUDktQiKCt/hFXpejmKtfSpBW+cQWthzuE3Pmc/kAyPR3JMpJgEMZe6EA93kcxzug1sMLAgxcSTponsYPJA7pjk29+DrpcOUupIbXTg0d/Nphh8rLWnasKiGeTHKps1sXIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mKzHcACKF4Fa1hyO/sQzTEIQspI7SNQRC2JWIehHi94=;
 b=YD3n8FF4xr/cIrLK0kaImqL3BDjXfq99UTIIcSEcRqMKZP/EUA6CDNrBWA83Pjy1E9GD/f8Ji4MKj4CEKLdxWd4/bGrJGIgJ8k+QZn0Kt6exadNBNkiJfc3z34nMqawxJpzrsQ+lsa1heKrdoqaTDhYlu6YMQzvuM6UdVFMoAChgmBJ4JHiT4FA+tRoROn8aEQ1LrysK/dg21fYrQbMch7pTaBB+uAwvwB+OqU9ONTaYDGsNj7FApMYcnbCJHoYWDcUrsOv2Z8ej4AKv8tmJ+hen4b3yPa5aw8BURhaWkuskC87SFCg4UQbGS0fPQFiXQDdymJxBbPeduRiO+FjlTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4337.namprd15.prod.outlook.com (2603:10b6:806:1ac::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20; Fri, 23 Apr
 2021 18:53:45 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.4065.025; Fri, 23 Apr 2021
 18:53:45 +0000
Subject: Re: [PATCH v3 bpf-next 17/18] selftests/bpf: add map linking selftest
To:     Andrii Nakryiko <andrii@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <kernel-team@fb.com>
References: <20210423181348.1801389-1-andrii@kernel.org>
 <20210423181348.1801389-18-andrii@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <5d96d205-1483-95a4-dc36-798fef934f72@fb.com>
Date:   Fri, 23 Apr 2021 11:53:42 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <20210423181348.1801389-18-andrii@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:bc07]
X-ClientProxiedBy: CO1PR15CA0068.namprd15.prod.outlook.com
 (2603:10b6:101:20::12) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::17f2] (2620:10d:c090:400::5:bc07) by CO1PR15CA0068.namprd15.prod.outlook.com (2603:10b6:101:20::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Fri, 23 Apr 2021 18:53:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3339c63b-489b-43aa-5acd-08d906891ef5
X-MS-TrafficTypeDiagnostic: SA1PR15MB4337:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB4337D6E198F67B64D397DF29D3459@SA1PR15MB4337.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R29DgjJXg972Bw9ZnAPUJusOpM6qPbkDCAeuU4VAnOdYQalfmUIA9wfknKQ6VWU+GcGRW8WvGfZ+IMS9kWfsFocDSOoQP4J8nScrO4iJJJTpGDedXXww+xnPT695U2Q6ciBDkdIed2tRrzlOJMVr+p/ZPpoHmAcVuJUOvMH+dd4aHIp2dkVKHbBDpkyBC7YWlmMXHE8y8V/Qr1L8HEl8cDEPTyKGM3bNlEhfdJ1/aKmV6pISZsBZd+Cd72Ud1CH++jyIzZk+jtt47Jd3E31RHL4bxHQIYEeaYv994XRu90Sdb1MLPBQs99Q+nDP6Ul4U8G80hiEFIEi+A9oCjXvdB5wpwygSLd3DBBcv0QbwFtpVvtVz4/L/z+fznFaFV0jUYuQjzXxL6oEiP3rfnf8wBeXQzQqIyklpC29w1hRp2t6gNPdiE9Ucn3YiD3HXWaE1AwPniSt40rDP1vfBIqFUdEFC03Xq2G4eyH4fVfkbQB31fYfm+P3fL1tLg+Ng4VTKHfQBb/dqcdeEZnWKPHBtts6lnOzXTDX9ojaClwJWy/DQ9xC757PB9tmcG6gIn1DnjYDL93QwDIKnWrZEH/mybknrTC8mzHwUszHlwpPlCyRxeQE92yQ1Ie3PcbOj86Oq0NFMWJYG/qb+/KjrNqBEZH0sWzuLkIXf4ngD8R626hrFT4EgKcD9AQDDZhXCp4Xx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(136003)(366004)(39860400002)(2906002)(53546011)(38100700002)(186003)(66946007)(2616005)(16526019)(6486002)(8676002)(5660300002)(66556008)(31696002)(66476007)(478600001)(8936002)(52116002)(83380400001)(86362001)(36756003)(31686004)(4326008)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TEg3VEtyV1hEZWtabWhoL1A1TzZxTGNpTXRJMHRhcmRiWnZEMWQ3M002amlN?=
 =?utf-8?B?UlBjT1VBSklUejZDTEUvdXZXSEh0ZnVzMjNqWkZGbkxWaHo4czNQNUZIeGtE?=
 =?utf-8?B?WmdrOTJxNnl3dkI2R3ZVdUN5RXFuTWk4QlQ4Qm5DVGNLL1c1aWRPMit2ajRx?=
 =?utf-8?B?NXl2aEd6V1BOSDA0MzY1c1V0em1rUHYyY3BlOFFwVXE3Nm1TUFRaa2loMkpO?=
 =?utf-8?B?R0VEcnBzclFPVXA0ZUlvZ1pZekprYm5TZ2x4cDE2dmRyM2RYcEN1ZjJvd1FC?=
 =?utf-8?B?N2p5NWdMOGF0aDdLL2luc0pNaHZKNW9KaFhrMllDOFJSYWkrZW9ZQVgyTjky?=
 =?utf-8?B?MXo2OWNOUElSa1RYSHkxb0lkOXdFSC9KaHhrUXNzdDkyWDRLUnBucUFKQnYw?=
 =?utf-8?B?U1pLdFIrODRJTGx1RWsvczhNN0ZQVk9TbUJJc2ZoNU9ta1Z0TlZzZ0tuYTNv?=
 =?utf-8?B?VjVtVTlCTHl5eGNMZjVnR1hCK3FKVFp0eUVjL25NeWNXcW9Ndmt4N2U2RFdH?=
 =?utf-8?B?NGpSb3ZoaGZkcWJQY3J4anJNbCtHZjExTm10U0R6b3JkN0V1ejZoN05IeVcy?=
 =?utf-8?B?ZWttK2V5NU5PbG10Ym14aDdqdTVvQU5yQkVYVm5yMVlqdXhrdGdJSXhxUDVo?=
 =?utf-8?B?a1JxaHhCMFpIeFREc1pyME5nUk1paG0vRXlqWlcvaWk5SUQ3SFF6clFxdE1X?=
 =?utf-8?B?bm9TeGhzZ1JPQUl5M2NUS2lENzVRSkJGMDdBNEFPODN3MUxSNVRJVHJac1pk?=
 =?utf-8?B?eENITDZENlh0UnBlQ2EwNkw5Zm8rOFFTbG9BUGdVWFVaUG16eTB3SVRkUXJT?=
 =?utf-8?B?ZzcxZWMxM2pxeTFyWGdUUno4N05GMFl0aXpWdlArS20xMm1yRlhZdmcwQ0tG?=
 =?utf-8?B?M1pPNUg1V3Y3Rk5XUHRLT3FmN3JMQW9MM1ZkZzdKanpVOWt6SkxTbGU1T25N?=
 =?utf-8?B?bEdKaFhTSURmbGJrSXlJU1FtRW56aXVaVnVHOUU1RXpxN1pVSVRoOU5TZHhI?=
 =?utf-8?B?RSszMy9nSkpDbnBaVHJKemZmWEhGeFNFY1ZsQ3ZBcHFFbUpKc3dPVmhxKysw?=
 =?utf-8?B?Y1hRWmNvTDlwTzBVcU4wWTYzbWVqNXBzK2F6N1Yya1pPVHVvQVp5Rk8wTzJI?=
 =?utf-8?B?TVdseGFTdENZQlhWOHNNVllQc1p6WWx5N0dkcnIxRE9Gb1VrMmZKeEJ0bXNz?=
 =?utf-8?B?SEhOZ2hpUVRjNnJBVlJmQ24vVnZqQ0dBL0NVLzZUZ2lpK3g5a0tMbzM2RlJI?=
 =?utf-8?B?TkpEMUxlVmdNTGljZ1hTcGkvMEJVQXJhZDBGb1hndUFJQ3lDSTZaNFVTMGxy?=
 =?utf-8?B?L0ZqUFd0Y3pTT2NPbFZ4TTJQQ0JSSDdib2lZUDFVVUl2Q1ZnTjhFM2NMVFcx?=
 =?utf-8?B?ZnJIVHlPMUx4QVc0NHB0Y01HWU9iOVY2RmErMlIxRGo4c1NLVk55Y290SzBY?=
 =?utf-8?B?cXF4V1ZMZmhjVS9jQnBNUFpLV0s0TkY1SU5Ldm1uUWVLSXdpOUlTdVFTMGNU?=
 =?utf-8?B?MjNQL1BOVzB4VjRqcDdZRVFFL2lhckFjYjRaNXR2cXJ5ekM2SkZ4NXAraTZi?=
 =?utf-8?B?MkM5MXd0UDJkZTJLa0pQMDRaejIyNUNIWDdRTTQ5THphN3JmSUxyT0V4VkJt?=
 =?utf-8?B?VE43cC9NMVZpUkFpTno0RHhLdGFoaTFYaWs3S0JHd0RCY014Z25vdnhRTS83?=
 =?utf-8?B?Wm1pMDFBblZiZ1IzVmVhejBqWDdVSnRhd2ZYRWVac2oxeEsxSWk4TzVMQjdS?=
 =?utf-8?B?NjY3RlVKY0Y0OENJcWtIaWlmNUt6NU96SlhzcEdPd0cxWnBXTGs5cHV1MG9n?=
 =?utf-8?Q?yUQVsWoQLMp2Dwdl0MR7LxeZBdFCXP0YMAOkA=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3339c63b-489b-43aa-5acd-08d906891ef5
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 18:53:45.0407
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WUcWyQHw/a6CEqFexy+AzdCNfFRQqz1CJ7xcgkX+FEEd8AuzUI0P7iTgCKIcM8Fd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4337
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: etT7E3OFW1jb1J_dY05hIqp8SBKYELka
X-Proofpoint-ORIG-GUID: etT7E3OFW1jb1J_dY05hIqp8SBKYELka
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-23_07:2021-04-23,2021-04-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 lowpriorityscore=0 impostorscore=0 clxscore=1015 mlxscore=0 suspectscore=0
 mlxlogscore=949 phishscore=0 bulkscore=0 malwarescore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104230122
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/23/21 11:13 AM, Andrii Nakryiko wrote:
> Add selftest validating various aspects of statically linking BTF-defined map
> definitions. Legacy map definitions do not support extern resolution between
> object files. Some of the aspects validated:
>    - correct resolution of extern maps against concrete map definitions;
>    - extern maps can currently only specify map type and key/value size and/or
>      type information;
>    - weak concrete map definitions are resolved properly.
> 
> Static map definitions are not yet supported by libbpf, so they are not
> explicitly tested, though manual testing showes that BPF linker handles them
> properly.
> 
> Acked-by: Yonghong Song <yhs@fb.com>
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
[...]
> +
> +SEC("raw_tp/sys_exit")
> +int BPF_PROG(handler_exit1)
> +{
> +	/* lookup values with key = 2, set in another file */
> +	int key = 2, *val;
> +	struct my_key key_struct = { .x = 2 };
> +	struct my_value *value_struct;
> +
> +	value_struct = bpf_map_lookup_elem(&map1, &key_struct);
> +	if (value_struct)
> +		output_first1 = value_struct->x;
> +
> +	val = bpf_map_lookup_elem(&map2, &key);
> +	if (val)
> +		output_second1 = *val;
> +
> +	val = bpf_map_lookup_elem(&map_weak, &key);
> +	if (val)
> +		output_weak1 = *val;
> +	

There is an extra tab in the above line. There is no need for new 
revision just for this. If no new revision is needed, maybe
the maintainer can help fix it.

> +	return 0;
> +}
