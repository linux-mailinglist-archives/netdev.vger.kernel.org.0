Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B56BC2693E3
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 19:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726211AbgINRoc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 13:44:32 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:23378 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726062AbgINRoU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 13:44:20 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08EHP1da007110;
        Mon, 14 Sep 2020 10:44:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=BmQyvEavBVuRvM4nbpzwfI7UPYJsvRAslrEhptrhFcg=;
 b=Mq7K2h6O5jcP68XZF64IWe5S1ifK22/OJ4Qi502sybFITIm+qV3QIMvIPNPInLDnZeHE
 Ez84VeX5Vr3QIkuznB5G/pEqtYOpSUuYjyD3agBIl6a67ySD4P8MmzoJElM571yKDFwL
 1q6CzzufiP+h0ZbBISYQg8HWhnCFWmYbP2g= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33guumhus0-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 14 Sep 2020 10:44:04 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 14 Sep 2020 10:44:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iMdTmNKgRYDof8ajGvVKO5r9SRXt+FesMxjjHM1MP2/FZrR3SoT6Xd4nQYjGAnLCODMebm26QRQMKNK4stCxUKR466LwZ0l1vKUJufhvilGppeOYbvUNazZN2/1yGKVkgRV1yXEbrjPkdTLrjIspG+sMG2iQPbKFe5ny2yQidjJhCeqci7bnPygQr3fjJGFMAhfToFyDD33mSXXiNy5qCg2ZTUAagDVcJWgxReM7q9ZhiFu7yg2UDJpwllVBDec3DZFRbHQaQkzgwENEncs3S0ZUJUTIWcIGVUyCj6F4bTyoYnAF/GgzJeGrF72knfhxrdD27LB4CiZJ9CprqQUWyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BmQyvEavBVuRvM4nbpzwfI7UPYJsvRAslrEhptrhFcg=;
 b=M6H9V4erSo0eY7azwTPWKn8I3YogXU6gTxY4wwoLl8oJCOzvfmT83KcoxqBJjLes08JlKidxlpW0Xz1TOqdJ03vZeg92z85NGmw74g/sZTArVksqm/gSvAoBvWaG6Msl5R0M+asJmsu2lCGoAk8SU+cf7GpzjuedLfi78Y/tRF2coCs26h6J+H+3fHOFb23UkgoX/cV6kNyzvrku1HsVaaSc5acgheJyuXWPhWbSBcNCa1uRjfS6+KR2JYyqDytB/Ry62Y0dr797Y5WkD5eHZQ2tYsWmnlZNR7cNxX0vvrYwHEmQZ68deUrfSsl8WR+zHWYvDR0CTfIvmKRoq/3v5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BmQyvEavBVuRvM4nbpzwfI7UPYJsvRAslrEhptrhFcg=;
 b=ONWosUg50eWfkU/SuVXfw+HmDVR9sY10MzMtV6gupgf2DnN6YzZUwNqCoPdRWp7inBm7z57l1LLsj8uh5p4DfBMbI88WOEwCbBq8rxcVI2TaGHXpAHk8tq7bv7NxfUJ5+Z3Yu2rZGVAGN3u4EWjEcUsMz/oSV9WUY+2NCSGmHUQ=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3189.namprd15.prod.outlook.com (2603:10b6:a03:103::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.19; Mon, 14 Sep
 2020 17:44:02 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42%3]) with mapi id 15.20.3370.019; Mon, 14 Sep 2020
 17:44:02 +0000
Subject: Re: [PATCH bpf-next] bpftool: fix build failure
To:     Quentin Monnet <quentin@isovalent.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
References: <20200914061206.2625395-1-yhs@fb.com>
 <b942625c-7140-0a57-337e-3a95020cfa99@isovalent.com>
 <1ab672c7-f333-f953-16ec-49e9099b39d7@fb.com>
 <ca0b4c63-5632-f8a0-9669-975d1119c1e6@fb.com>
 <c8c33847-9ca6-5b81-ef03-02ce382acfb6@isovalent.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <8601f597-9c7e-a9a5-b375-75191fa93530@fb.com>
Date:   Mon, 14 Sep 2020 10:43:59 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
In-Reply-To: <c8c33847-9ca6-5b81-ef03-02ce382acfb6@isovalent.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW2PR16CA0029.namprd16.prod.outlook.com (2603:10b6:907::42)
 To BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::11ed] (2620:10d:c090:400::5:e354) by MW2PR16CA0029.namprd16.prod.outlook.com (2603:10b6:907::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Mon, 14 Sep 2020 17:44:01 +0000
X-Originating-IP: [2620:10d:c090:400::5:e354]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0a65004c-67bc-4818-6073-08d858d5c448
X-MS-TrafficTypeDiagnostic: BYAPR15MB3189:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB3189BD7DC26D280FD2946542D3230@BYAPR15MB3189.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ezKIHiz3X1zqJpNTYyU5xjKw9D9KWkAKMzgWnK7IjY2GFPaoC3lZj4L5/OqAr85my3LAW76UMmmfGzIUJii8kat/0I0GuxxCRJ+G+VDarsnCwmCT5v+LqaK0aoM5GXZmFka5Tzk7xGd1pOYGkF/Dw2BsdRMvNQi9WocQI4qPnXv/8OZbst9ssCwvzabMRNe0IeAthRoLdXMhEwygGhxYxYqWgBL69H27kUtTrW2Gfy1VphHLfLHX897MLQO0ZnmbMYZyrHYk7Us7a8hq8LlCRiCHC6ClFv35QKz1Yw1a1xwd0mitW6/XjSue2O/FFVfxPtXC+pHdo1lNFYqjZ/BtFC3SqsHHYnz//4OviEP2YWGxT8YDcg9eqH1IDUO8HPIJ+BJtn9Etsn8/Nmp+3AIhAGLGY/y8J73Q9GxI2rba8BdFPobbQE0buOBkYPAEi1HACBMW75wyapjA+vz7zG0WlA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(346002)(39860400002)(396003)(136003)(316002)(31696002)(31686004)(8676002)(966005)(54906003)(86362001)(6486002)(4326008)(2616005)(83380400001)(2906002)(52116002)(186003)(16526019)(53546011)(8936002)(478600001)(66556008)(66946007)(66476007)(5660300002)(36756003)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: QFNpooeUMX/2/f67cE9/Tv8yTFu3r48hlgp9vXczsujCz0FoD73iys1JSdAdMq80Cbd/SLGw24XruHxhHHVQtyA6bANaUB4/BGx5RaRvAdEgNRrOEiwbPPoeytDnFk5TUEa8tNSclgC+6tDhpEPm7lniYPMHetQFmc7/udAlAnz4FVzM2KcIJQrIUriRdvqZahutsPqNgYaijZB4YBYc3mFLeizVVoE982jvvYw/FCRH9m9J4R98l0UKuUmhN5QV5kQJDc9L4QgIKoH/URCQzq8RPVllcgf0lcdJLvQj/4Z2S4M6O5DV8ioZMGK9bfEON8SyYf3jscgTHomActay2DJXDozgye2VEHPFkqsGh94STOjmVSqFMcIhPWBnqeeunNDu0D/BXZRu/R3BCaGSC874ytCSYZzqmUdSKftg+aUfvZsnec23hXIGKtX/BUKnOBzSbcqf0tI/y59zlBx5dSOarV1I94eNSqQToijSsN132FU+O9/BNXpuDmTd8+O51ef1Nnlvc/GM2e6jcSqTNGTKMictRnJpHHVXbAOTsCRjspf0TKDgA2MR6P8S1B2TdGAnJoovx5jJdMkSJDBAZ99nAMw/h9EOVsatlaC7xXCwjlIkZ16gd9Cb7vhdn4Y+WStJFpOGs0tXaDpH3fNvGeGJ0nshQOEks/B4CGJpKfo=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a65004c-67bc-4818-6073-08d858d5c448
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2020 17:44:01.8610
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 661FrMAMsVPxdyXvR/HCe9N02wI+XDSqzHhZ1kgcdJzVBbX2Ze0+ke7JFhyMWqQw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3189
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-14_07:2020-09-14,2020-09-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 priorityscore=1501 bulkscore=0
 malwarescore=0 clxscore=1015 mlxlogscore=999 phishscore=0 adultscore=0
 suspectscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009140142
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/14/20 10:23 AM, Quentin Monnet wrote:
> On 14/09/2020 17:54, Yonghong Song wrote:
>>
>>
>> On 9/14/20 9:46 AM, Yonghong Song wrote:
>>>
>>>
>>> On 9/14/20 1:16 AM, Quentin Monnet wrote:
>>>> On 14/09/2020 07:12, Yonghong Song wrote:
>>>>> When building bpf selftests like
>>>>>     make -C tools/testing/selftests/bpf -j20
>>>>> I hit the following errors:
>>>>>     ...
>>>>>     GEN
>>>>> /net-next/tools/testing/selftests/bpf/tools/build/bpftool/Documentation/bpftool-gen.8
>>>>>
>>>>>     <stdin>:75: (WARNING/2) Block quote ends without a blank line;
>>>>> unexpected unindent.
>>>>>     <stdin>:71: (WARNING/2) Literal block ends without a blank line;
>>>>> unexpected unindent.
>>>>>     <stdin>:85: (WARNING/2) Literal block ends without a blank line;
>>>>> unexpected unindent.
>>>>>     <stdin>:57: (WARNING/2) Block quote ends without a blank line;
>>>>> unexpected unindent.
>>>>>     <stdin>:66: (WARNING/2) Literal block ends without a blank line;
>>>>> unexpected unindent.
>>>>>     <stdin>:109: (WARNING/2) Literal block ends without a blank line;
>>>>> unexpected unindent.
>>>>>     <stdin>:175: (WARNING/2) Literal block ends without a blank line;
>>>>> unexpected unindent.
>>>>>     <stdin>:273: (WARNING/2) Literal block ends without a blank line;
>>>>> unexpected unindent.
>>>>>     make[1]: ***
>>>>> [/net-next/tools/testing/selftests/bpf/tools/build/bpftool/Documentation/bpftool-perf.8]
>>>>> Error 12
>>>>>     make[1]: *** Waiting for unfinished jobs....
>>>>>     make[1]: ***
>>>>> [/net-next/tools/testing/selftests/bpf/tools/build/bpftool/Documentation/bpftool-iter.8]
>>>>> Error 12
>>>>>     make[1]: ***
>>>>> [/net-next/tools/testing/selftests/bpf/tools/build/bpftool/Documentation/bpftool-struct_ops.8]
>>>>> Error 12
>>>>>     ...
>>>>>
>>>>> I am using:
>>>>>     -bash-4.4$ rst2man --version
>>>>>     rst2man (Docutils 0.11 [repository], Python 2.7.5, on linux2)
>>>>>     -bash-4.4$
>>>>>
>>>>> Looks like that particular version of rst2man prefers to have a
>>>>> blank line
>>>>> after literal blocks. This patch added block lines in related .rst
>>>>> files
>>>>> and compilation can then pass.
>>>>>
>>>>> Cc: Quentin Monnet <quentin@isovalent.com>
>>>>> Fixes: 18841da98100 ("tools: bpftool: Automate generation for "SEE
>>>>> ALSO" sections in man pages")
>>>>> Signed-off-by: Yonghong Song <yhs@fb.com>
>>>>
>>>>
>>>> Hi Yonghong, thanks for the fix! I didn't see those warnings on my
>>>> setup. For the record my rst2man version is:
>>>>
>>>>      rst2man (Docutils 0.16 [release], Python 3.8.2, on linux)
>>>>
>>>> Your patch looks good, but instead of having blank lines at the end of
>>>> most files, could you please check if the following works?
>>>
>>> Thanks for the tip! I looked at the generated output again. My above
>>> fix can silent the warning, but certainly not correct.
>>>
>>> With the following change, I captured the intermediate result of the
>>> .rst file.
>>>
>>>    ifndef RST2MAN_DEP
>>>           $(error "rst2man not found, but required to generate man pages")
>>>    endif
>>> -       $(QUIET_GEN)( cat $< ; echo -n $(call see_also,$<) ) | rst2man
>>> $(RST2MAN_OPTS) > $@
>>> +       $(QUIET_GEN)( cat $< ; echo -n $(call see_also,$<) ) | tee
>>> /tmp/tt | rst2man $(RST2MAN_OPTS) > $@
>>>
>>> With below command,
>>>      make clean && make bpftool-cgroup.8
>>> I can get the new .rst file for bpftool-cgroup.
>>>
>>> At the end of file /tmp/tt (changed bpftool-cgroup.rst), I see
>>>
>>>       ID       AttachType      AttachFlags     Name
>>> \n SEE ALSO\n========\n\t**bpf**\ (2),\n\t**bpf-helpers**\
>>> (7),\n\t**bpftool**\ (8),\n\t**bpftool-btf**\
>>> (8),\n\t**bpftool-feature**\ (8),\n\t**bpftool-gen**\
>>> (8),\n\t**bpftool-iter**\ (8),\n\t**bpftool-link**\
>>> (8),\n\t**bpftool-map**\ (8),\n\t**bpftool-net**\
>>> (8),\n\t**bpftool-perf**\ (8),\n\t**bpftool-prog**\
>>> (8),\n\t**bpftool-struct_ops**\ (8)\n
>>>
>>> This sounds correct if we rst2man can successfully transforms '\n'
>>> or '\t' to proper encoding in the man page.
>>>
>>> Unfortunately, with my version of rst2man, I got
>>>
>>> .IP "System Message: WARNING/2 (<stdin>:, line 146)"
>>> Literal block ends without a blank line; unexpected unindent.
>>> .sp
>>> n SEE
>>> ALSOn========nt**bpf**(2),nt**bpf\-helpers**(7),nt**bpftool**(8),nt**bpftool\-btf**(8),nt**bpftool\-feature**(8),nt**bpftool\-gen**(8),nt**bpftool\-iter**(8),nt**bpftool\-link**(8),nt**bpftool\-map**(8),nt**bpftool\-net**(8),nt**bpftool\-perf**(8),nt**bpftool\-prog**(8),nt**bpftool\-struct_ops**(8)n
>>>
>>> .\" Generated by docutils manpage writer.
>>>
>>> The rst2man simply considered \n as 'n'. The same for '\t' and
>>> this caused the issue.
>>>
>>> I did not find a way to fix the problem https://urldefense.proofpoint.com/v2/url?u=https-3A__www.google.com_url-3Fq-3Dhttps-3A__zoom.us_j_94864957378-3Fpwd-253DbXFRL1ZaRUxTbDVKcm9uRitpTXgyUT09-26sa-3DD-26source-3Dcalendar-26ust-3D1600532408208000-26usg-3DAOvVaw3SJ0i8oz4ZM-2DGRb7hYkrYlyet&d=DwIDaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=DA8e1B5r073vIqRrFz7MRA&m=kEK7ScPMF-y-i8dli-or8wWEGREW5V4qPB7UqHqDnkg&s=Br0g0MFXxL_pJuDVTOY5UrmvfD2ru_6Uf_X_8Nr2Rhk&e= .
>>
>> The following change works for me.
>>
>> @@ -44,7 +44,7 @@ $(OUTPUT)%.8: %.rst
>>   ifndef RST2MAN_DEP
>>          $(error "rst2man not found, but required to generate man pages")
>>   endif
>> -       $(QUIET_GEN)( cat $< ; echo -n $(call see_also,$<) ) | rst2man
>> $(RST2MAN_OPTS) > $@
>> +       $(QUIET_GEN)( cat $< ; echo -e $(call see_also,$<) ) | rst2man
>> $(RST2MAN_OPTS) > $@
>>
>>   clean: helpers-clean
>>          $(call QUIET_CLEAN, Documentation)
>> -bash-4.4$
>>
>> I will send revision 2 shortly.
> 
> Thanks Yonghong, but this does not work on my setup :/. The version of
> echo which is called on my machine from the Makefile does not seem to
> interpret the "-e" option and writes something like "-e\nSEE ALSO",
> which causes rst2man to complain.
> 
> I suspect the portable option here would be printf, even though Andrii
> had some concerns that we could pass a format specifier through the file
> names [0].
> 
> Would this work on your setup?
> 
> 	$(QUIET_GEN)( cat $< ; printf $(call see_also,$<) ) | rst2man...
> 
> Would that be acceptable?

It works for me. Andrii originally suggested `echo -e`, but since `echo 
-e` does not work in your environment let us use printf then. I will add
a comment about '%' in the bpftool man page name.

> 
> [0]
> https://lore.kernel.org/bpf/ca595fd6-e807-ac8e-f15f-68bfc7b7dbc4@isovalent.com/T/#m01bb298fd512121edd5e77a26ed5382c0c53939e
> 
> Quentin
> 
