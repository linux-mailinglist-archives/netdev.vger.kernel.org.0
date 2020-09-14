Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5817D2694B1
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 20:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726004AbgINSVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 14:21:25 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:41710 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726065AbgINSVA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 14:21:00 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08EI8dMo004050;
        Mon, 14 Sep 2020 11:20:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=jojggWfokpO06pV68hfOv3b2McOBsnk0Im9CUIGUDTI=;
 b=of99srZcLEacN9DZDtsC/Mt/2tsnBetzNDXhr3IHV2cxrN5EBBwSMQK6XuEMnlgVkdw6
 USga6FsAxS3VTbBDsZwkrqMH0ISXJLPdxMyK8TDwNsY8ysf4K5UGnUXwflm5b1BZ+RvW
 fn8JzsQr0vMcFKRIlZ/IFK98/oItRwN4Htc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33j50dtk41-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 14 Sep 2020 11:20:44 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 14 Sep 2020 11:20:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m03w7hPq9K/yDnmfLnu+Q2pxg+NE5Qm4f5MQ+g6J7MoG1GjWLxpqJpx5VAuwUOM+D1oe9CUz5nkFSIFSRaF8qg4MlOJio51F9TBuU9detKyTIf1mn+QaoYyRAvBQCyIfbgDLHu+lquFfpKIqsUG85eaLs0XISPkPLUpsYHeMx3Oq9j3edNfOscxZe/kxuuiTVSouEU3L2Uc/FNLhcLMk8Cp5sNrsy4OmSVWMSCzs45rg0FaCgXfqxetDSZcdyIMGu38ES5VKsboWjKHGfL80SgK/eiJ7pXRtXkqUlEhu+REhM/k8Hzl1Hge9wehytRUo9ThWhsuf78SFokqFXvwU+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jojggWfokpO06pV68hfOv3b2McOBsnk0Im9CUIGUDTI=;
 b=KHplKg5lOqs9RrYylpbt7hHqfGbqSbYnap4UcnSTc8iLi6c5h5tc00QCUTwO8Qv6UavxcD8h46rM0MtkBnF5rq+e/L8DavdGH1/lTJEdrZRCkB28VwBAX7j8IpIQ8wV8nTb+5S6+fH6FjqKjNMJqyK8pu6HWlzuBOUe7/PSvryTOWycPbuG8XMnXoz71zNkv+I8IINJach1KXEAeJwsIksrlu9YNUI3nklBDFG1u5jj0x6g17zBsWcfvpFQ50fmWrDy2I81i7/Va27eFYX9A7cAO5ZEZm/L5ZW9TeCpS3mYT7onUVoKdA9eYwGkyBRW8f/ZEe7iepGXM4DVa/hku6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jojggWfokpO06pV68hfOv3b2McOBsnk0Im9CUIGUDTI=;
 b=euarwS1QWQ8FnvBrWhi8bD/n8gdy5v1e/CrkEPBUeX2C3ljQmdhZALkcXdcejsOH2LIh5Vvgc8GhGs/y9+y3KUHDq34tn9cZKnFIJNF6O/qPSAAgd+yy3nxrC387DBAfS9c7oEtJJyFO+75MVGsT+M6QOeFjtICbuoqpI9Wk6d0=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2325.namprd15.prod.outlook.com (2603:10b6:a02:85::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Mon, 14 Sep
 2020 18:20:28 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42%3]) with mapi id 15.20.3370.019; Mon, 14 Sep 2020
 18:20:28 +0000
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
 <e98c3f11-fc23-203a-3be0-f4535d8b062c@fb.com>
 <CAEf4BzY27sW4hmnD+XV2Ms6+EvP+_o4pu_6sr3p1mqr14rgjfw@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <22a85fba-546c-9341-edf6-de6dcc2aae3a@fb.com>
Date:   Mon, 14 Sep 2020 11:20:25 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
In-Reply-To: <CAEf4BzY27sW4hmnD+XV2Ms6+EvP+_o4pu_6sr3p1mqr14rgjfw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CO2PR04CA0091.namprd04.prod.outlook.com
 (2603:10b6:104:6::17) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::11ed] (2620:10d:c090:400::5:e354) by CO2PR04CA0091.namprd04.prod.outlook.com (2603:10b6:104:6::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.19 via Frontend Transport; Mon, 14 Sep 2020 18:20:27 +0000
X-Originating-IP: [2620:10d:c090:400::5:e354]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c1ce64d4-cd69-4efa-672d-08d858dadb92
X-MS-TrafficTypeDiagnostic: BYAPR15MB2325:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB23252E015ADF645D98D34B77D3230@BYAPR15MB2325.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y+LMSOr1OTAgZ3RYvMlkXZWyWS5f2U1KjtH9AP+xcYpv0c2rUjsum7igquOtOgutekqTpbF1tc7liJEEiWkFw+vrXKYWr31mAnhMTl+RVXzibhl/aMVOhQxP9+Gd0He6HqFMHKySZPgVhIKZ+MYdKi8F70KGIlQszSuRhe/1h6eIqWqP6CU0qZcBg17AGpgYhTcHsr8a2c7eJk8+l6RqHV/bFiZ6B6pTIHggJgDisHN+FaqaYCuj6u9OLk0JQzCT5sav9DtOUsjxyTZbvfkihQI8YUTNzL3ZwYy1AE457PMQTSGiViCl9xpMUJUy/tcwpOcmHARzdnPq6d3plAK6Umy2ujRiBoCF6NKl8xYLQx4BOa6VegwpjqiYM4wZaJXWWqfleslh2U2m+EmSUtJFzjvtHWdOCOloLy3IQfCkWZZF2dqn01jdPUlvdlX4quFxUdRr3MthljW7+U+kZnLpDw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(136003)(366004)(346002)(39860400002)(66946007)(66476007)(86362001)(8936002)(54906003)(36756003)(83380400001)(31696002)(5660300002)(52116002)(53546011)(186003)(16526019)(478600001)(2616005)(31686004)(66556008)(6486002)(316002)(6916009)(2906002)(8676002)(4326008)(966005)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: mr82Sr+iTDO9s9ufUcmlPbM6vAZ2bvBqi7gUq9zFANanfq4NvOywQxO2tOc8wbnWoybUu15YYYXhGb+krFxSZx5/sW7IMW4srcqxorYLlLxjva8JG5tz3cQzGSRMeIJ8yfBvufNzUIGwqhA+RPop+fI8wPlz509GTkuklAdVqc/ZWluYO7Oh40Fam4eOT7bqfWgzhVQNQboKUeIdjyImIO5rwGaVrTQgcYV3suwP/LHGb4J96ooRZn+B7RVKtOQ/4Zh5AX7p+mpvEZ+L3hxC+KDz8tomkWz3NzPBF06b01pM8chyXp+7usbHQFmYVzvZFtzREvBAsX38fgm88PYq0aHgsFM3QfvyYHNVTJ/EZh8U41zfhnlApuFm6P1yK+XjlbAyPk4j4hW125tQs/aV2Eth8Y4UujaIPgO+/Z0GzbOzRcFdxiyj8oSLgkOcx6msgykPElA6WirJYraUMiWzWNPAcML00xxtYI6Lz0MXnyaGFPHWlI9wNeHbz8m0WGUu2WbYivr5pRhQOfTsy6ERn75Ni07TwKaIKOYcHWTez34JgN+iixgAQBs9QfuU/tYbIvACfsFV8hvFHtembK6Fp/lhE0GIRwCNpabWFLon+1Tc4GhZn6Yp7QvJMEus162kTxaC8Q0IoresjOYjE06d5mdTjGC48Cl/jyJc2kEJynw=
X-MS-Exchange-CrossTenant-Network-Message-Id: c1ce64d4-cd69-4efa-672d-08d858dadb92
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2020 18:20:28.3754
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +ftYXvzetJEEPIBekfjLI0o2fd4R8ji9tu1/SlL1JDd+kt1jZzBwfkswNhhmRzwN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2325
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-14_07:2020-09-14,2020-09-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 clxscore=1015 priorityscore=1501 mlxscore=0 lowpriorityscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009140145
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/14/20 11:13 AM, Andrii Nakryiko wrote:
> On Mon, Sep 14, 2020 at 11:06 AM Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 9/14/20 10:55 AM, Andrii Nakryiko wrote:
>>> On Mon, Sep 14, 2020 at 10:46 AM Yonghong Song <yhs@fb.com> wrote:
>>>>
>>>>
>>>>
>>>> On 9/14/20 10:23 AM, Quentin Monnet wrote:
>>>>> On 14/09/2020 17:54, Yonghong Song wrote:
>>>>>>
>>>>>>
>>>>>> On 9/14/20 9:46 AM, Yonghong Song wrote:
>>>>>>>
>>>>>>>
>>>>>>> On 9/14/20 1:16 AM, Quentin Monnet wrote:
>>>>>>>> On 14/09/2020 07:12, Yonghong Song wrote:
>>>>>>>>> When building bpf selftests like
>>>>>>>>>       make -C tools/testing/selftests/bpf -j20
>>>>>>>>> I hit the following errors:
>>>>>>>>>       ...
>>>>>>>>>       GEN
>>>>>>>>> /net-next/tools/testing/selftests/bpf/tools/build/bpftool/Documentation/bpftool-gen.8
>>>>>>>>>
>>>>>>>>>       <stdin>:75: (WARNING/2) Block quote ends without a blank line;
>>>>>>>>> unexpected unindent.
>>>>>>>>>       <stdin>:71: (WARNING/2) Literal block ends without a blank line;
>>>>>>>>> unexpected unindent.
>>>>>>>>>       <stdin>:85: (WARNING/2) Literal block ends without a blank line;
>>>>>>>>> unexpected unindent.
>>>>>>>>>       <stdin>:57: (WARNING/2) Block quote ends without a blank line;
>>>>>>>>> unexpected unindent.
>>>>>>>>>       <stdin>:66: (WARNING/2) Literal block ends without a blank line;
>>>>>>>>> unexpected unindent.
>>>>>>>>>       <stdin>:109: (WARNING/2) Literal block ends without a blank line;
>>>>>>>>> unexpected unindent.
>>>>>>>>>       <stdin>:175: (WARNING/2) Literal block ends without a blank line;
>>>>>>>>> unexpected unindent.
>>>>>>>>>       <stdin>:273: (WARNING/2) Literal block ends without a blank line;
>>>>>>>>> unexpected unindent.
>>>>>>>>>       make[1]: ***
>>>>>>>>> [/net-next/tools/testing/selftests/bpf/tools/build/bpftool/Documentation/bpftool-perf.8]
>>>>>>>>> Error 12
>>>>>>>>>       make[1]: *** Waiting for unfinished jobs....
>>>>>>>>>       make[1]: ***
>>>>>>>>> [/net-next/tools/testing/selftests/bpf/tools/build/bpftool/Documentation/bpftool-iter.8]
>>>>>>>>> Error 12
>>>>>>>>>       make[1]: ***
>>>>>>>>> [/net-next/tools/testing/selftests/bpf/tools/build/bpftool/Documentation/bpftool-struct_ops.8]
>>>>>>>>> Error 12
>>>>>>>>>       ...
>>>>>>>>>
>>>>>>>>> I am using:
>>>>>>>>>       -bash-4.4$ rst2man --version
>>>>>>>>>       rst2man (Docutils 0.11 [repository], Python 2.7.5, on linux2)
>>>>>>>>>       -bash-4.4$
>>>>>>>>>
>>>>>>>>> Looks like that particular version of rst2man prefers to have a
>>>>>>>>> blank line
>>>>>>>>> after literal blocks. This patch added block lines in related .rst
>>>>>>>>> files
>>>>>>>>> and compilation can then pass.
>>>>>>>>>
>>>>>>>>> Cc: Quentin Monnet <quentin@isovalent.com>
>>>>>>>>> Fixes: 18841da98100 ("tools: bpftool: Automate generation for "SEE
>>>>>>>>> ALSO" sections in man pages")
>>>>>>>>> Signed-off-by: Yonghong Song <yhs@fb.com>
>>>>>>>>
>>>>>>>>
>>>>>>>> Hi Yonghong, thanks for the fix! I didn't see those warnings on my
>>>>>>>> setup. For the record my rst2man version is:
>>>>>>>>
>>>>>>>>        rst2man (Docutils 0.16 [release], Python 3.8.2, on linux)
>>>>>>>>
>>>>>>>> Your patch looks good, but instead of having blank lines at the end of
>>>>>>>> most files, could you please check if the following works?
>>>>>>>
>>>>>>> Thanks for the tip! I looked at the generated output again. My above
>>>>>>> fix can silent the warning, but certainly not correct.
>>>>>>>
>>>>>>> With the following change, I captured the intermediate result of the
>>>>>>> .rst file.
>>>>>>>
>>>>>>>      ifndef RST2MAN_DEP
>>>>>>>             $(error "rst2man not found, but required to generate man pages")
>>>>>>>      endif
>>>>>>> -       $(QUIET_GEN)( cat $< ; echo -n $(call see_also,$<) ) | rst2man
>>>>>>> $(RST2MAN_OPTS) > $@
>>>>>>> +       $(QUIET_GEN)( cat $< ; echo -n $(call see_also,$<) ) | tee
>>>>>>> /tmp/tt | rst2man $(RST2MAN_OPTS) > $@
>>>>>>>
>>>>>>> With below command,
>>>>>>>        make clean && make bpftool-cgroup.8
>>>>>>> I can get the new .rst file for bpftool-cgroup.
>>>>>>>
>>>>>>> At the end of file /tmp/tt (changed bpftool-cgroup.rst), I see
>>>>>>>
>>>>>>>         ID       AttachType      AttachFlags     Name
>>>>>>> \n SEE ALSO\n========\n\t**bpf**\ (2),\n\t**bpf-helpers**\
>>>>>>> (7),\n\t**bpftool**\ (8),\n\t**bpftool-btf**\
>>>>>>> (8),\n\t**bpftool-feature**\ (8),\n\t**bpftool-gen**\
>>>>>>> (8),\n\t**bpftool-iter**\ (8),\n\t**bpftool-link**\
>>>>>>> (8),\n\t**bpftool-map**\ (8),\n\t**bpftool-net**\
>>>>>>> (8),\n\t**bpftool-perf**\ (8),\n\t**bpftool-prog**\
>>>>>>> (8),\n\t**bpftool-struct_ops**\ (8)\n
>>>>>>>
>>>>>>> This sounds correct if we rst2man can successfully transforms '\n'
>>>>>>> or '\t' to proper encoding in the man page.
>>>>>>>
>>>>>>> Unfortunately, with my version of rst2man, I got
>>>>>>>
>>>>>>> .IP "System Message: WARNING/2 (<stdin>:, line 146)"
>>>>>>> Literal block ends without a blank line; unexpected unindent.
>>>>>>> .sp
>>>>>>> n SEE
>>>>>>> ALSOn========nt**bpf**(2),nt**bpf\-helpers**(7),nt**bpftool**(8),nt**bpftool\-btf**(8),nt**bpftool\-feature**(8),nt**bpftool\-gen**(8),nt**bpftool\-iter**(8),nt**bpftool\-link**(8),nt**bpftool\-map**(8),nt**bpftool\-net**(8),nt**bpftool\-perf**(8),nt**bpftool\-prog**(8),nt**bpftool\-struct_ops**(8)n
>>>>>>>
>>>>>>> .\" Generated by docutils manpage writer.
>>>>>>>
>>>>>>> The rst2man simply considered \n as 'n'. The same for '\t' and
>>>>>>> this caused the issue.
>>>>>>>
>>>>>>> I did not find a way to fix the problem https://urldefense.proofpoint.com/v2/url?u=https-3A__www.google.com_url-3Fq-3Dhttps-3A__zoom.us_j_94864957378-3Fpwd-253DbXFRL1ZaRUxTbDVKcm9uRitpTXgyUT09-26sa-3DD-26source-3Dcalendar-26ust-3D1600532408208000-26usg-3DAOvVaw3SJ0i8oz4ZM-2DGRb7hYkrYlyet&d=DwIDaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=DA8e1B5r073vIqRrFz7MRA&m=kEK7ScPMF-y-i8dli-or8wWEGREW5V4qPB7UqHqDnkg&s=Br0g0MFXxL_pJuDVTOY5UrmvfD2ru_6Uf_X_8Nr2Rhk&e= .
>>>>>>
>>>>>> The following change works for me.
>>>>>>
>>>>>> @@ -44,7 +44,7 @@ $(OUTPUT)%.8: %.rst
>>>>>>     ifndef RST2MAN_DEP
>>>>>>            $(error "rst2man not found, but required to generate man pages")
>>>>>>     endif
>>>>>> -       $(QUIET_GEN)( cat $< ; echo -n $(call see_also,$<) ) | rst2man
>>>>>> $(RST2MAN_OPTS) > $@
>>>>>> +       $(QUIET_GEN)( cat $< ; echo -e $(call see_also,$<) ) | rst2man
>>>>>> $(RST2MAN_OPTS) > $@
>>>>>>
>>>>>>     clean: helpers-clean
>>>>>>            $(call QUIET_CLEAN, Documentation)
>>>>>> -bash-4.4$
>>>>>>
>>>>>> I will send revision 2 shortly.
>>>>>
>>>>> Thanks Yonghong, but this does not work on my setup :/. The version of
>>>>> echo which is called on my machine from the Makefile does not seem to
>>>>> interpret the "-e" option and writes something like "-e\nSEE ALSO",
>>>>> which causes rst2man to complain.
>>>>>
>>>>> I suspect the portable option here would be printf, even though Andrii
>>>>> had some concerns that we could pass a format specifier through the file
>>>>> names [0].
>>>>>
>>>>> Would this work on your setup?
>>>>>
>>>>>         $(QUIET_GEN)( cat $< ; printf $(call see_also,$<) ) | rst2man...
>>>>>
>>>>> Would that be acceptable?
>>>>
>>>> It works for me. Andrii originally suggested `echo -e`, but since `echo
>>>> -e` does not work in your environment let us use printf then. I will add
>>>> a comment about '%' in the bpftool man page name.
>>>
>>> It's amazing how incompatible echo can be. But that aside, I have
>>> nothing against printf itself, but:
>>>
>>> printf "%s" "whatever we want to print out"
>>>
>>> seems like the way to go, similarly how you'd do it in your C code, no?
>>
>> This won't really work :-(
>>
>> -bash-4.4$ printf "%s" "\n\n"
>> \n\n-bash-4.4$ printf "\n\n"
>>
>>
>> -bash-4.4$
>>
>> Looks like "\n" needs to be in format string to make a difference.
>>
> 
> I just learned that %b was added specifically for that case:
> 
> $ printf "%b" "\n\n"

Great! I learned some bash magic today... Will send v3.

> 
> 
> $
> 
>>
>>>
>>>>
>>>>>
>>>>> [0]
>>>>> https://lore.kernel.org/bpf/ca595fd6-e807-ac8e-f15f-68bfc7b7dbc4@isovalent.com/T/#m01bb298fd512121edd5e77a26ed5382c0c53939e
>>>>>
>>>>> Quentin
>>>>>
