Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90ECD2213B8
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 19:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726023AbgGORtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 13:49:07 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:29914 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725861AbgGORtF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 13:49:05 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06FHjKwL029604;
        Wed, 15 Jul 2020 10:48:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=4O27lc3HJfa52oGh76iBTwdDSd/QIKuoA1Z3/cnHWik=;
 b=TL5lV3jrI2LLyDio4KE/XiZ+qmezz9LG3MqPsbh0nyFbK8f6CLCa8Ny8jdLtuC9YWYXm
 7BWBekGpaZS/91BDE/gF8JWVPkOUM+gjvSW6tQ7gzNQerBdRWIC1f2q1okm5TDCwdRMq
 YcmhP2O9AB2rMS5zMa/ZeqFWUEEjdY+fqco= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32a43f0tyh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 15 Jul 2020 10:48:50 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 15 Jul 2020 10:48:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nfsTVHztAdpuA93aeyLeKFMYNPcXoYfKdEtYeinP3tbDM86IpRjiTm/pANUD2B/Cjya4ZSLr7c8ggjLYjwlKvtDba8v1xPqR9F8AXU2CMbw4gXH7igqFE0IUPfWi1CCq1UhR3lJd8+WfbhLQqKCx11mA6jb+74m2Bl47JVyuwTOq3nXQMj7B5lJ6QDuc+66CRmXFvVQ+5bIhM0ifsu0q5zi7vUu+uyQLleMT5bi6J6WypQ1jjAhpj4EER2pVVHoYLiC7UBJG9Y0an/1FkzJ+C1AVQOx+0lnkhRZ9ZlXZRVuEck51OSxKpPdOMc23DSnYLBUBC6aqnr1K4pACWJd3kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4O27lc3HJfa52oGh76iBTwdDSd/QIKuoA1Z3/cnHWik=;
 b=EzNMTn/EBSME0bNb1WoBc59uBKqZrdtWtCUx81m3GgRo2Sfp6d8pjT1fHrMAvDalKyXlUFiJO3dN9pXafrXXBbXhYoXPu+tSKqNe2X3k1iKuJ8c0eP2weUmr1qKnrUaej5/KcvVQ8e6LlmlS9rtvwQAkRMIosoCNHhkFO350lFvA6wudhD2fc7M4HuZ8Q+o7gS/8SJ5HOl4XRsvUgPzZ8wabX/Ky3O/X3dJw1agXlBBQv0IWlpp0KYm6qRp37OZ271sIKrTOFoVwpje3YoUrPM6I7Z2nnHueOb31K+t/aLW1841hhQVJyf4EcZFYk2wwFfv27IIP7v8e368nledM+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4O27lc3HJfa52oGh76iBTwdDSd/QIKuoA1Z3/cnHWik=;
 b=WjsgdXPe02+4Tr9fTbXh4B6ov2B8tjZlYiTim5huFnt6h/Kxw/cKV6RK4wdR88hMia1TtOL2Ena6q3f34oagov99s7rB+yaS8WstHLJGwiifDCj7buovgaZKy71Vk3wpiL4s9kVETxzeaDMsBAFWogBhB8SrIB3tuVYnPyRPmVA=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2998.namprd15.prod.outlook.com (2603:10b6:a03:fc::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21; Wed, 15 Jul
 2020 17:34:20 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3174.026; Wed, 15 Jul 2020
 17:34:20 +0000
Subject: Re: [PATCH bpf-next 03/13] bpf: support readonly buffer in verifier
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
References: <20200713161739.3076283-1-yhs@fb.com>
 <20200713161742.3076597-1-yhs@fb.com>
 <20200713232545.mmocpqgqpiapcdvg@ast-mbp.dhcp.thefacebook.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <2b641c41-fd6e-b1fa-4043-02b92776140e@fb.com>
Date:   Wed, 15 Jul 2020 10:34:19 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
In-Reply-To: <20200713232545.mmocpqgqpiapcdvg@ast-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR06CA0056.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::33) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::1176] (2620:10d:c090:400::5:7353) by BYAPR06CA0056.namprd06.prod.outlook.com (2603:10b6:a03:14b::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.18 via Frontend Transport; Wed, 15 Jul 2020 17:34:20 +0000
X-Originating-IP: [2620:10d:c090:400::5:7353]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 10e36dc7-3272-4db8-4e76-08d828e54e7b
X-MS-TrafficTypeDiagnostic: BYAPR15MB2998:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2998D85FE5C28B961BBA5A28D37E0@BYAPR15MB2998.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C8Xs0OYkGeMXmHia4Sl5LiYGmbeak/sKF2hhADso/OvMPf9NtoYTD74fSGo2cJv37s0Rjd/5qVchV/lJvGctB78QDpVqkSuXKzTCItkGuleYUw7aGhVnp0Nw5vEPNa/Bwtn+IEPJVApdiK4eFVYbUttlmwMppWA3OoHQOJwpQN++eyjV8726851Y+Xr4F6Omz86Ds0yFKLT/s6ziIX935K6HvsBj4dLCqzdW8ZtyVXcgG9C9FoN0APsKAExIv7oTAVG6+8CaPpJHC1SIIJwi/PBQUpjMHxoJ1IONmHQvYgDgctEt/PtG7YuGc8AreAVvgnPj5dJXVwDzsFN24b2JTyCmvfFwqpxHzSuEeC3vu5GPsSYZwHOgesR/c12PBFfb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(366004)(346002)(396003)(39860400002)(376002)(16526019)(186003)(8676002)(66556008)(66476007)(2616005)(31696002)(66946007)(6486002)(8936002)(478600001)(54906003)(6916009)(31686004)(36756003)(2906002)(4326008)(316002)(83380400001)(5660300002)(86362001)(53546011)(52116002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 1WKMHVIgUtqRqahGbBZl+GUEnhs0qxb/qEF1Vxbx8KCHGAoyYN7mz3Z/vr1qL+eA5cFue13QD6wU9UVUUBmvNXWXva26nZ2hV8KXzSUR0mlmxxM2aMOEP6dRkhPl8dlozLnxD0iNo5K4IUyOlYlKJ2kwHcPs/0xo13nEt48kX2kszdfkVELNv6eUtVLNdQzyGHDSMg68ii7+pO87WKjwFavWp89FuXuMU4QDk55aPcn45JR0dK3xMTuJPBdGmGG6qQqyJ2bbxAj+9UIF3S4O0Zn/NncK/BSrvo+Av+z7WSlLrCA85zLA1+t+MhcVAKaKgz8xtrXi5W78g0hHa1GD/flcQCaTIBWFvhr1URk6gVn5ffSHSQOBmiKcydTR9hZb2OB2IRgBoE6XFjHr/CpulTE+EKMyyyg35Ce9pfH6gx9N5BTuEuytNXEnofdS/81yLIPOoUbvHUJYI2815hVaQKjmbCKyhMHPmkBsq5x9c1PEozYf1MVoNFzLPfCDOC7kGafynOChrYtDLlz4TAtFyQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 10e36dc7-3272-4db8-4e76-08d828e54e7b
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2020 17:34:20.4209
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 02qQISAPhJ7frzwp04c+XhzQk/2bOys5eGan5TAw2QLaDnNVYiHSmLHDIBX4rx4M
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2998
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-15_12:2020-07-15,2020-07-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 phishscore=0 clxscore=1015 impostorscore=0 mlxlogscore=999
 priorityscore=1501 spamscore=0 malwarescore=0 bulkscore=0 adultscore=0
 suspectscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007150138
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/13/20 4:25 PM, Alexei Starovoitov wrote:
> On Mon, Jul 13, 2020 at 09:17:42AM -0700, Yonghong Song wrote:
>> Two new readonly buffer PTR_TO_RDONLY_BUF or
>> PTR_TO_RDONLY_BUF_OR_NULL register states
>> are introduced. These new register states will be used
>> by later bpf map element iterator.
>>
>> New register states share some similarity to
>> PTR_TO_TP_BUFFER as it will calculate accessed buffer
>> size during verification time. The accessed buffer
>> size will be later compared to other metrics during
>> later attach/link_create time.
>>
>> Two differences between PTR_TO_TP_BUFFER and
>> PTR_TO_RDONLY_BUF[_OR_NULL].
>> PTR_TO_TP_BUFFER is for write only
>> and PTR_TO_RDONLY_BUF[_OR_NULL] is for read only.
>> In addition, a rdonly_buf_seq_id is also added to the
>> register state since it is possible for the same program
>> there could be two PTR_TO_RDONLY_BUF[_OR_NULL] ctx arguments.
>> For example, for bpf later map element iterator,
>> both key and value may be PTR_TO_TP_BUFFER_OR_NULL.
>>
>> Similar to reg_state PTR_TO_BTF_ID_OR_NULL in bpf
>> iterator programs, PTR_TO_RDONLY_BUF_OR_NULL reg_type and
>> its rdonly_buf_seq_id can be set at
>> prog->aux->bpf_ctx_arg_aux, and bpf verifier will
>> retrieve the values during btf_ctx_access().
>> Later bpf map element iterator implementation
>> will show how such information will be assigned
>> during target registeration time.
> ...
>>   struct bpf_ctx_arg_aux {
>>   	u32 offset;
>>   	enum bpf_reg_type reg_type;
>> +	u32 rdonly_buf_seq_id;
>>   };
>>   
>> +#define BPF_MAX_RDONLY_BUF	2
>> +
>>   struct bpf_prog_aux {
>>   	atomic64_t refcnt;
>>   	u32 used_map_cnt;
>> @@ -693,6 +699,7 @@ struct bpf_prog_aux {
>>   	u32 attach_btf_id; /* in-kernel BTF type id to attach to */
>>   	u32 ctx_arg_info_size;
>>   	const struct bpf_ctx_arg_aux *ctx_arg_info;
>> +	u32 max_rdonly_access[BPF_MAX_RDONLY_BUF];
> 
> I think PTR_TO_RDONLY_BUF approach is too limiting.
> I think the map value should probably be writable from the beginning,
> but I don't see how this RDONLY_BUF support can be naturally extended.

Agreed. Let me try to make map value read/write-able.

One thing we discussed earlier is whether and how we could make
map element deletable during iterator traversal. I will explore
this as well.

> Also key and value can be large, so just load/store is going to be
> limiting pretty quickly. People would want to use helpers to access
> key/value areas. I think any existing helper that accepts ARG_PTR_TO_MEM
> should be usable with data from this key/value.

This is a useful suggestion. I actually indeed hacked trying to
allow
   bpf_seq_write(seq, buf, buf_size) accepts rdonly_buf register state
so bpf iterator can also copy key/value to user space through seq_file.
The bpf_seq_write 2nd arg is ARG_PTR_TO_MEM. This actually works.

I originally planned to have this as a followup. Since you mentioned 
this, I will incorporate it in the next revision.

> PTR_TO_TP_BUFFER was a quick hack for tiny scratch area.
> Here I think the verifier should be smart from the start. >
> The next patch populates bpf_ctx_arg_aux with hardcoded 0 and 1.
> imo that's too hacky. Helper definitions shouldn't be in business
> of poking into such verifier internals.

The reason I am using 0/1 so later on I can easily correlate
which rdonly_buf access size corresponds to key or value. I guess
I can have a verifier callback to given an ctx argument index to
get the access size.
