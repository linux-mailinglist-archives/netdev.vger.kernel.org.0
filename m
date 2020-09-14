Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C09FE269462
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 20:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbgINSHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 14:07:31 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36080 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726112AbgINSG4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 14:06:56 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08EI0aMP000874;
        Mon, 14 Sep 2020 11:06:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=zu0HL6YogClYQ8VoVLAX74h5aKpUGR9D7dfAvkuZjY4=;
 b=arM+WArtA52kQWuMw0uFoJY9AkguKPHsGaG9602muBkgYAcp9Mq7xCubLCAnO89YHCxU
 Owduza73/euYTgmRQsdKcc/w4LcM3Yt7fZtHCJCCFxLV+RwRJ3e63b/8ikJtVFTP2SgR
 JV4LmS734B0+PrXZVSjyz4CFJ4lVSwaPLaI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33hed3xcdr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 14 Sep 2020 11:06:27 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 14 Sep 2020 11:06:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QsLaPdlOEEUpOE/kJYAZ1IMzMf/tHXcq5e5eS5KSnnBMFtPA2uqjRNcjeKBHufeoPhBt9M7uV48wkvqWf/9YAHF6TRumhhSN/bzIqFbt94FX5uvgIiFmR/YUo6IOFwQIuuZVq0CahwjMjIZ8yxuAniBreqNF95mBQK2ZdagPm88Cgca2wSug2M1bRMpkf4TyOGG2KRRGck/H7rgJSr2UazbpV9jK7SPlN3FXdlqjHTqqpzELeN9D2u6A1jULuogyMO32O41qlukixGFPBZtizSdF29DuFLFAaRWtOeCUjWcMJvHnU7Hk9eKbS6jDhmS5Ff5PKokRS7iMvjTdqveWPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zu0HL6YogClYQ8VoVLAX74h5aKpUGR9D7dfAvkuZjY4=;
 b=BH/ZzatBoyt6E4/CyjUeXCv+LwHmnWOjXuAns+TRoCT8FD/yI+AU6YECJyQZDnT07AGaTLDVZooGTSgcGVyuVQN6g3rcZznkwuvNYLBF4QqtLki5c5gfPADioRG/b4e8YuwRk7UJ8uV6+pWf9I7o4K61s1ZKvwJIXU44BX7PtImLSmOoaDBYXwDCB6yO2rDIGOa9goLostxSoO9RFcxe8USnZ61psddAalIbNiDfBwMZPKfs03fbWOG3SoQrovsiMiQRIVKONf7KRQARWEADom9rXA1y/w1iW1J3DWSGQtkhSsMchDW3/noIqToyxFBcQ18i27T59f1U6C7DPlUNdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zu0HL6YogClYQ8VoVLAX74h5aKpUGR9D7dfAvkuZjY4=;
 b=a9WoduHdP4L9URROj5Sd39enhypgDtqNBFDFICDTA/1xRAJLU1ykgMm6OPjq6wDghgoZs+pILVaPgfiK6znRA4yvlBQ5QYcwUrkgxbijAbVA8XnQ7X3NRgT0btKtFdWcjd88o73eZB/7QRq7lPxwkKS2EdqM+HN5Gza3aCmTjxM=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3046.namprd15.prod.outlook.com (2603:10b6:a03:fa::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Mon, 14 Sep
 2020 18:06:22 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42%3]) with mapi id 15.20.3370.019; Mon, 14 Sep 2020
 18:06:22 +0000
Subject: Re: [PATCH bpf-next] bpftool: fix build failure
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Quentin Monnet <quentin@isovalent.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
References: <20200914061206.2625395-1-yhs@fb.com>
 <b942625c-7140-0a57-337e-3a95020cfa99@isovalent.com>
 <1ab672c7-f333-f953-16ec-49e9099b39d7@fb.com>
 <ca0b4c63-5632-f8a0-9669-975d1119c1e6@fb.com>
 <c8c33847-9ca6-5b81-ef03-02ce382acfb6@isovalent.com>
 <8601f597-9c7e-a9a5-b375-75191fa93530@fb.com>
 <CAEf4BzYd8Yp_CX52xYmbWg56JjyS__SmBD6Cb3y0M5hvVPYARw@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <e98c3f11-fc23-203a-3be0-f4535d8b062c@fb.com>
Date:   Mon, 14 Sep 2020 11:06:19 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
In-Reply-To: <CAEf4BzYd8Yp_CX52xYmbWg56JjyS__SmBD6Cb3y0M5hvVPYARw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CO2PR18CA0060.namprd18.prod.outlook.com
 (2603:10b6:104:2::28) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::11ed] (2620:10d:c090:400::5:e354) by CO2PR18CA0060.namprd18.prod.outlook.com (2603:10b6:104:2::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Mon, 14 Sep 2020 18:06:21 +0000
X-Originating-IP: [2620:10d:c090:400::5:e354]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 64f08b8f-dbac-4854-95dd-08d858d8e358
X-MS-TrafficTypeDiagnostic: BYAPR15MB3046:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB30469A1D13DFD8E79CDF7A3AD3230@BYAPR15MB3046.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E+5YcyqLaBuUlXTlMuwD15XoP6dwvCF5ZgzMWDQVyp9SpMs1bidKThpLq1O8m1PV5lTXY/2AMijyh9pzlH89MhFzI5rAd2Xp7y+rqprvoo+YbgYVVboX6Jgle6Ueriu2dA+XryWC5K9c+L7f60AuSz9KiJtyYL+Fik3CQa9MiNr2CcjMbzlsBf0k4L/67VFEuW3h+xD6NBuOV9HxxmHQyOOFmVBCgizunLBIVUipLxYAzVrGLGs6HFx8tWY/6RwtN00Fu2zl+z+AE9l51W7Z5RCoiKP+rl14/Ra7fgBt78l5pyOsgj0lLO9L+7KYG1L9s8KCoASFBu0Et46/RK1p7uTlO1U+6L5rdtYjg1vSRtvWmlWqR0Z9SekgXQx47kQ7ZQxMr7ux6mP+yV5VDBUpCQWOYy3TrulSs2TqQrSkrfN+qnAc27cvvhwbiEL3vbP6/H3hoyFffzURzbkQFLKUwQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(366004)(346002)(376002)(136003)(16526019)(36756003)(186003)(6916009)(66946007)(478600001)(8676002)(83380400001)(31696002)(53546011)(8936002)(6486002)(66476007)(66556008)(966005)(52116002)(86362001)(2616005)(31686004)(54906003)(2906002)(4326008)(5660300002)(316002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: BwEG5BjmuN6dLErg1hnpfOBNwiwISEHYlt6k0/ma6uW9n5F1NFdSYq6Q0jtV/UkeTOCrZaMMk9bLNF3e6PwwAPPVbIUCCwTR0IjSoHgSvSptR+0tHi2oNv+l7Pswx2pIJAjMsRHM0S9znzv5HzK8XdjDnPwbn7OecZjUvojjezPFhVAtGXEUIXxmjABFQQgO7OUcAYKU039HrVantIhJh9Qf7TWDjFK3vrvA2SVpPtN4bvTGvvUZmK2J7kNoffVx8aoHVoxtcq4TnuohrdIe/Sw6qp9F/WMsOdZHZjvBSX2WrIQmft4ByYK1AxMfL7Uy0IbDubAk4Iiu/LLb1DQUJGtxyMpnPdMCZK7e0ciUFGj8a1OCpBMpIXQozLtt6DfjqEs8MRB6WtBPFZV/Ofrz0Bp/KQ/+aZPO/HItgwZ/CupjlK4g2ZitYxhIw8yAJLxiBkkpWLSDF5Gt/tgMlUs0LPTA7hVzSB6Rggp9m+sEjeD2oJKq8CNuCR4stDe5gJY1BA82wPpm9BGaE2hTvOix5+xpqytERg5fDUVLxIFH5hMqYDDBn7330bnFdq+my+8x62OBI1PxLPkiyEhs3bYKQ20yHXhR9iNx/YVTMX1n6sDUs+/RvW3K+uOdj7ZJxrFm2YZ9P97QolnCIl1rEDCfvhKhzJrNpfzsoohbtJOqiko=
X-MS-Exchange-CrossTenant-Network-Message-Id: 64f08b8f-dbac-4854-95dd-08d858d8e358
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2020 18:06:22.4308
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3aVUDt8s4cQRd9bxLFzuhZRrnpCXLUrjGnp0ltWRME3bS+hwuRcs5Q4Akpo3zKVv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3046
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-14_07:2020-09-14,2020-09-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 adultscore=0 lowpriorityscore=0 suspectscore=0 mlxscore=0 bulkscore=0
 phishscore=0 impostorscore=0 spamscore=0 mlxlogscore=999
 priorityscore=1501 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009140144
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/14/20 10:55 AM, Andrii Nakryiko wrote:
> On Mon, Sep 14, 2020 at 10:46 AM Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 9/14/20 10:23 AM, Quentin Monnet wrote:
>>> On 14/09/2020 17:54, Yonghong Song wrote:
>>>>
>>>>
>>>> On 9/14/20 9:46 AM, Yonghong Song wrote:
>>>>>
>>>>>
>>>>> On 9/14/20 1:16 AM, Quentin Monnet wrote:
>>>>>> On 14/09/2020 07:12, Yonghong Song wrote:
>>>>>>> When building bpf selftests like
>>>>>>>      make -C tools/testing/selftests/bpf -j20
>>>>>>> I hit the following errors:
>>>>>>>      ...
>>>>>>>      GEN
>>>>>>> /net-next/tools/testing/selftests/bpf/tools/build/bpftool/Documentation/bpftool-gen.8
>>>>>>>
>>>>>>>      <stdin>:75: (WARNING/2) Block quote ends without a blank line;
>>>>>>> unexpected unindent.
>>>>>>>      <stdin>:71: (WARNING/2) Literal block ends without a blank line;
>>>>>>> unexpected unindent.
>>>>>>>      <stdin>:85: (WARNING/2) Literal block ends without a blank line;
>>>>>>> unexpected unindent.
>>>>>>>      <stdin>:57: (WARNING/2) Block quote ends without a blank line;
>>>>>>> unexpected unindent.
>>>>>>>      <stdin>:66: (WARNING/2) Literal block ends without a blank line;
>>>>>>> unexpected unindent.
>>>>>>>      <stdin>:109: (WARNING/2) Literal block ends without a blank line;
>>>>>>> unexpected unindent.
>>>>>>>      <stdin>:175: (WARNING/2) Literal block ends without a blank line;
>>>>>>> unexpected unindent.
>>>>>>>      <stdin>:273: (WARNING/2) Literal block ends without a blank line;
>>>>>>> unexpected unindent.
>>>>>>>      make[1]: ***
>>>>>>> [/net-next/tools/testing/selftests/bpf/tools/build/bpftool/Documentation/bpftool-perf.8]
>>>>>>> Error 12
>>>>>>>      make[1]: *** Waiting for unfinished jobs....
>>>>>>>      make[1]: ***
>>>>>>> [/net-next/tools/testing/selftests/bpf/tools/build/bpftool/Documentation/bpftool-iter.8]
>>>>>>> Error 12
>>>>>>>      make[1]: ***
>>>>>>> [/net-next/tools/testing/selftests/bpf/tools/build/bpftool/Documentation/bpftool-struct_ops.8]
>>>>>>> Error 12
>>>>>>>      ...
>>>>>>>
>>>>>>> I am using:
>>>>>>>      -bash-4.4$ rst2man --version
>>>>>>>      rst2man (Docutils 0.11 [repository], Python 2.7.5, on linux2)
>>>>>>>      -bash-4.4$
>>>>>>>
>>>>>>> Looks like that particular version of rst2man prefers to have a
>>>>>>> blank line
>>>>>>> after literal blocks. This patch added block lines in related .rst
>>>>>>> files
>>>>>>> and compilation can then pass.
>>>>>>>
>>>>>>> Cc: Quentin Monnet <quentin@isovalent.com>
>>>>>>> Fixes: 18841da98100 ("tools: bpftool: Automate generation for "SEE
>>>>>>> ALSO" sections in man pages")
>>>>>>> Signed-off-by: Yonghong Song <yhs@fb.com>
>>>>>>
>>>>>>
>>>>>> Hi Yonghong, thanks for the fix! I didn't see those warnings on my
>>>>>> setup. For the record my rst2man version is:
>>>>>>
>>>>>>       rst2man (Docutils 0.16 [release], Python 3.8.2, on linux)
>>>>>>
>>>>>> Your patch looks good, but instead of having blank lines at the end of
>>>>>> most files, could you please check if the following works?
>>>>>
>>>>> Thanks for the tip! I looked at the generated output again. My above
>>>>> fix can silent the warning, but certainly not correct.
>>>>>
>>>>> With the following change, I captured the intermediate result of the
>>>>> .rst file.
>>>>>
>>>>>     ifndef RST2MAN_DEP
>>>>>            $(error "rst2man not found, but required to generate man pages")
>>>>>     endif
>>>>> -       $(QUIET_GEN)( cat $< ; echo -n $(call see_also,$<) ) | rst2man
>>>>> $(RST2MAN_OPTS) > $@
>>>>> +       $(QUIET_GEN)( cat $< ; echo -n $(call see_also,$<) ) | tee
>>>>> /tmp/tt | rst2man $(RST2MAN_OPTS) > $@
>>>>>
>>>>> With below command,
>>>>>       make clean && make bpftool-cgroup.8
>>>>> I can get the new .rst file for bpftool-cgroup.
>>>>>
>>>>> At the end of file /tmp/tt (changed bpftool-cgroup.rst), I see
>>>>>
>>>>>        ID       AttachType      AttachFlags     Name
>>>>> \n SEE ALSO\n========\n\t**bpf**\ (2),\n\t**bpf-helpers**\
>>>>> (7),\n\t**bpftool**\ (8),\n\t**bpftool-btf**\
>>>>> (8),\n\t**bpftool-feature**\ (8),\n\t**bpftool-gen**\
>>>>> (8),\n\t**bpftool-iter**\ (8),\n\t**bpftool-link**\
>>>>> (8),\n\t**bpftool-map**\ (8),\n\t**bpftool-net**\
>>>>> (8),\n\t**bpftool-perf**\ (8),\n\t**bpftool-prog**\
>>>>> (8),\n\t**bpftool-struct_ops**\ (8)\n
>>>>>
>>>>> This sounds correct if we rst2man can successfully transforms '\n'
>>>>> or '\t' to proper encoding in the man page.
>>>>>
>>>>> Unfortunately, with my version of rst2man, I got
>>>>>
>>>>> .IP "System Message: WARNING/2 (<stdin>:, line 146)"
>>>>> Literal block ends without a blank line; unexpected unindent.
>>>>> .sp
>>>>> n SEE
>>>>> ALSOn========nt**bpf**(2),nt**bpf\-helpers**(7),nt**bpftool**(8),nt**bpftool\-btf**(8),nt**bpftool\-feature**(8),nt**bpftool\-gen**(8),nt**bpftool\-iter**(8),nt**bpftool\-link**(8),nt**bpftool\-map**(8),nt**bpftool\-net**(8),nt**bpftool\-perf**(8),nt**bpftool\-prog**(8),nt**bpftool\-struct_ops**(8)n
>>>>>
>>>>> .\" Generated by docutils manpage writer.
>>>>>
>>>>> The rst2man simply considered \n as 'n'. The same for '\t' and
>>>>> this caused the issue.
>>>>>
>>>>> I did not find a way to fix the problem https://urldefense.proofpoint.com/v2/url?u=https-3A__www.google.com_url-3Fq-3Dhttps-3A__zoom.us_j_94864957378-3Fpwd-253DbXFRL1ZaRUxTbDVKcm9uRitpTXgyUT09-26sa-3DD-26source-3Dcalendar-26ust-3D1600532408208000-26usg-3DAOvVaw3SJ0i8oz4ZM-2DGRb7hYkrYlyet&d=DwIDaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=DA8e1B5r073vIqRrFz7MRA&m=kEK7ScPMF-y-i8dli-or8wWEGREW5V4qPB7UqHqDnkg&s=Br0g0MFXxL_pJuDVTOY5UrmvfD2ru_6Uf_X_8Nr2Rhk&e= .
>>>>
>>>> The following change works for me.
>>>>
>>>> @@ -44,7 +44,7 @@ $(OUTPUT)%.8: %.rst
>>>>    ifndef RST2MAN_DEP
>>>>           $(error "rst2man not found, but required to generate man pages")
>>>>    endif
>>>> -       $(QUIET_GEN)( cat $< ; echo -n $(call see_also,$<) ) | rst2man
>>>> $(RST2MAN_OPTS) > $@
>>>> +       $(QUIET_GEN)( cat $< ; echo -e $(call see_also,$<) ) | rst2man
>>>> $(RST2MAN_OPTS) > $@
>>>>
>>>>    clean: helpers-clean
>>>>           $(call QUIET_CLEAN, Documentation)
>>>> -bash-4.4$
>>>>
>>>> I will send revision 2 shortly.
>>>
>>> Thanks Yonghong, but this does not work on my setup :/. The version of
>>> echo which is called on my machine from the Makefile does not seem to
>>> interpret the "-e" option and writes something like "-e\nSEE ALSO",
>>> which causes rst2man to complain.
>>>
>>> I suspect the portable option here would be printf, even though Andrii
>>> had some concerns that we could pass a format specifier through the file
>>> names [0].
>>>
>>> Would this work on your setup?
>>>
>>>        $(QUIET_GEN)( cat $< ; printf $(call see_also,$<) ) | rst2man...
>>>
>>> Would that be acceptable?
>>
>> It works for me. Andrii originally suggested `echo -e`, but since `echo
>> -e` does not work in your environment let us use printf then. I will add
>> a comment about '%' in the bpftool man page name.
> 
> It's amazing how incompatible echo can be. But that aside, I have
> nothing against printf itself, but:
> 
> printf "%s" "whatever we want to print out"
> 
> seems like the way to go, similarly how you'd do it in your C code, no?

This won't really work :-(

-bash-4.4$ printf "%s" "\n\n"
\n\n-bash-4.4$ printf "\n\n"


-bash-4.4$

Looks like "\n" needs to be in format string to make a difference.


> 
>>
>>>
>>> [0]
>>> https://lore.kernel.org/bpf/ca595fd6-e807-ac8e-f15f-68bfc7b7dbc4@isovalent.com/T/#m01bb298fd512121edd5e77a26ed5382c0c53939e
>>>
>>> Quentin
>>>
