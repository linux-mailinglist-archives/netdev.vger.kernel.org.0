Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62F8F269232
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 18:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbgINQzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 12:55:18 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:63720 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726318AbgINQzD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 12:55:03 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08EGkVk3024102;
        Mon, 14 Sep 2020 09:54:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : from : to : cc
 : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=DkIVYatSHRcgXFPiafRYY2PqOXZKWmoM2GIBvYmfS2c=;
 b=W0GzLn8ssTQT0RVF7OjFGd0jlDlog5wUF6HF7Lw1ICqG0mQ2f7B88GdihuxTrzqA1Cqf
 Knp40SRhMqh9pQN3QBbr550JllRpIqIZfsUAcz1QO2AqPnInuw5lMjUqjyU9MCQ8ZNb6
 qqBq0BLwAUwFBthEmnFtCclLO7ehcnVk3Rw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33hed3wyp2-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 14 Sep 2020 09:54:48 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 14 Sep 2020 09:54:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UxTnT7Wn0NKLGyEVJsFuzZ4kifYbtppu3pezGMg/qqmcw97DsjSlIe5LaIZz4n5B/+Tbikq2rKLVBDRcUN5H5smAdVemX3NP3sRbcwP10L3azryZ7mm/HLJ0yiFZGdeETetpxFsSqQeChJz5aKMRtk/1xIeu+BC/SRXpRnoWwbOI8NVpQ4WeR3ljcz0w/lFkmVBpt7G2zMnXxduc1RybJcQxi07vt1W+208e0pPwdMfTLu6J6xWAdUGQppThZ2i09rtXVOP55Q5+lB0W9coAaQ3tYbG9ydNCEkL75sV3LVVcnCgUlTPXADGxqIlGO+nPRf1vDG+i+Tc4FTZLNqyGvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DkIVYatSHRcgXFPiafRYY2PqOXZKWmoM2GIBvYmfS2c=;
 b=CpMsncKxo2tAyQJiWuthmuLZFAL87QipuIooBspf4n5P8jv2Lsg1mYm9M71+EDu5T9jyaMJX/EoAtaLYKRIHFzb64ux6w2nF5VuahRt5/shpeQVpvwgkwAvo3wlaoyhjiFjOpJLH7Wp1vmI6CngEx7FquWhc8mUSt4haSr5pGO30Us2JijDLgz3LYVmVge6c45658SIAPeb+fjYc+ZgmEw0xcFQ2eUdlsjhm2xYxdMWi79q29lmsic6wZBtrH6HdnfjVEqoOS0C2zIQPyFpPxoqPXn8roGDF6LIMUCjYsnC+geDSFmdz6m62tySyXJc7EAihPZcx2s6j/MvnVHXXVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DkIVYatSHRcgXFPiafRYY2PqOXZKWmoM2GIBvYmfS2c=;
 b=Y0EGoV4aa5MngifM5X+ce3e2fE7SSvOtC4w/E/b/IWrSbJ5ll9v3c0ht9WaEdUlTPEISSv0yC9CJM+o1olNgg+qTAKgc9G0gEkRe7ipVDyyUBIg+ZHUdkdKkzWTg5FIZuGKPuFCPnWLmnSEx592Cb/J/sN4pHgmMKtLOaczTpCU=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3464.namprd15.prod.outlook.com (2603:10b6:a03:10a::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.17; Mon, 14 Sep
 2020 16:54:43 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42%3]) with mapi id 15.20.3370.019; Mon, 14 Sep 2020
 16:54:43 +0000
Subject: Re: [PATCH bpf-next] bpftool: fix build failure
From:   Yonghong Song <yhs@fb.com>
To:     Quentin Monnet <quentin@isovalent.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
References: <20200914061206.2625395-1-yhs@fb.com>
 <b942625c-7140-0a57-337e-3a95020cfa99@isovalent.com>
 <1ab672c7-f333-f953-16ec-49e9099b39d7@fb.com>
Message-ID: <ca0b4c63-5632-f8a0-9669-975d1119c1e6@fb.com>
Date:   Mon, 14 Sep 2020 09:54:40 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
In-Reply-To: <1ab672c7-f333-f953-16ec-49e9099b39d7@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW2PR16CA0003.namprd16.prod.outlook.com (2603:10b6:907::16)
 To BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21d6::11f0] (2620:10d:c090:400::5:5351) by MW2PR16CA0003.namprd16.prod.outlook.com (2603:10b6:907::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Mon, 14 Sep 2020 16:54:42 +0000
X-Originating-IP: [2620:10d:c090:400::5:5351]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 120c46db-2eff-43a4-1c85-08d858cee0b8
X-MS-TrafficTypeDiagnostic: BYAPR15MB3464:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB3464FEB770A3034393259AFFD3230@BYAPR15MB3464.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KaRTcga6WN4YVLP6x8xr7PNo9xiwePf+2LgFbM9BeFb9I5pxZTQWHk7z28EtXtGO3WsqJX/Wz8o4HfQBJSEQH0G7TjAMHuAgYpX+jwtHstt6FgJbgooPRjDcKPol0Bb19HPZxzolBC0DmgLfsZWqAxfqP27RRMrphy2t4RfWymjL0OabadzBKz91EPfB2OTUseglogEwyJ1g2d5O6nf5InI/1LcXwwbsnRESU4J3tgTZ2+/YGWwfWkzd5H0TPeqTYoAmQwylxtjbarkXX3GHENxpK5J8RfxhlwpRM8gc5HVqibrfEsm0b3JuonR6vkL6lg6lvxA3gDflXXugsuPLzbMcW3yj6VGoaBn6b71poCYvyrI2hAwQqHR99WUoUCr1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(136003)(396003)(366004)(39860400002)(316002)(66946007)(4326008)(6486002)(31696002)(8936002)(5660300002)(36756003)(86362001)(66556008)(66476007)(2906002)(2616005)(83380400001)(54906003)(186003)(16526019)(8676002)(53546011)(52116002)(478600001)(31686004)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: yLS/4knTrzGK/osw8QvooAy8WSx++agjZY6SuRYJ18YSlEz7mGeeoiQcwd1NS3+unvKowj6srhk5jQkiS5pzksXVDQJWLSYsr/A+pquOzCxlhu6Bz67L4PbKkIHrPKPGRwY3CtxfGrkkqirKCT9eZKc+zQOVSosD1XonvXD5Hls1pRPEGplTsFJ/Nidm/5tj0btvNLPPtFWrvoHuPXXY0JplcvxcHoQCHiL/4OoOMJSqXNJ0V72WMGv+x+mJj4xgflvGlyau22bCVRPEMFLuznqpx05OgFMmloYm6Nc+9MwysO9SHzQ5QpBOW0sxaOkPNKwGoV5R3zDG0Wpks3vxazEn14kbk7PcQ/fzq5KRzTWCRptV0hX23zaxkmCPmpB407ZZYFA3gPiiOabsbMVj+cQzDKy0oDm7Z5dyuwxUJLlgx71VNXBYyAoQW3OHltGhPeAFOlOT+ArwGRkz6Q82Zw9VqsoXn051XAYD94tGuG21YZ6ph+UZYYlU+HXndnmZB2wgKTTT29T6vU0YTEDQaWB0Zo4PQOjbxBhYBFckukwSjigpzXOumV+kwfR87l0TZjWfajPQvojCTvpMCL/sO0LA7K7P0YqXu4znNPcTkiUzDE2XjAVNmyqsGBx9Ap5Y8AR9AQuTVcS+U92AKRnSHxUrxu79Bvi5MVpHAreYH7I=
X-MS-Exchange-CrossTenant-Network-Message-Id: 120c46db-2eff-43a4-1c85-08d858cee0b8
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2020 16:54:43.0734
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fWlA3Rlxu0PFJkpdrE2lzlaS3WMbhTD3gyaqQaA+0JcZvmKKbvQDiyTZL3x1HwF1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3464
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-14_06:2020-09-14,2020-09-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 adultscore=0 lowpriorityscore=0 suspectscore=0 mlxscore=0 bulkscore=0
 phishscore=0 impostorscore=0 spamscore=0 mlxlogscore=999
 priorityscore=1501 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009140136
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/14/20 9:46 AM, Yonghong Song wrote:
> 
> 
> On 9/14/20 1:16 AM, Quentin Monnet wrote:
>> On 14/09/2020 07:12, Yonghong Song wrote:
>>> When building bpf selftests like
>>>    make -C tools/testing/selftests/bpf -j20
>>> I hit the following errors:
>>>    ...
>>>    GEN      
>>> /net-next/tools/testing/selftests/bpf/tools/build/bpftool/Documentation/bpftool-gen.8 
>>>
>>>    <stdin>:75: (WARNING/2) Block quote ends without a blank line; 
>>> unexpected unindent.
>>>    <stdin>:71: (WARNING/2) Literal block ends without a blank line; 
>>> unexpected unindent.
>>>    <stdin>:85: (WARNING/2) Literal block ends without a blank line; 
>>> unexpected unindent.
>>>    <stdin>:57: (WARNING/2) Block quote ends without a blank line; 
>>> unexpected unindent.
>>>    <stdin>:66: (WARNING/2) Literal block ends without a blank line; 
>>> unexpected unindent.
>>>    <stdin>:109: (WARNING/2) Literal block ends without a blank line; 
>>> unexpected unindent.
>>>    <stdin>:175: (WARNING/2) Literal block ends without a blank line; 
>>> unexpected unindent.
>>>    <stdin>:273: (WARNING/2) Literal block ends without a blank line; 
>>> unexpected unindent.
>>>    make[1]: *** 
>>> [/net-next/tools/testing/selftests/bpf/tools/build/bpftool/Documentation/bpftool-perf.8] 
>>> Error 12
>>>    make[1]: *** Waiting for unfinished jobs....
>>>    make[1]: *** 
>>> [/net-next/tools/testing/selftests/bpf/tools/build/bpftool/Documentation/bpftool-iter.8] 
>>> Error 12
>>>    make[1]: *** 
>>> [/net-next/tools/testing/selftests/bpf/tools/build/bpftool/Documentation/bpftool-struct_ops.8] 
>>> Error 12
>>>    ...
>>>
>>> I am using:
>>>    -bash-4.4$ rst2man --version
>>>    rst2man (Docutils 0.11 [repository], Python 2.7.5, on linux2)
>>>    -bash-4.4$
>>>
>>> Looks like that particular version of rst2man prefers to have a blank 
>>> line
>>> after literal blocks. This patch added block lines in related .rst files
>>> and compilation can then pass.
>>>
>>> Cc: Quentin Monnet <quentin@isovalent.com>
>>> Fixes: 18841da98100 ("tools: bpftool: Automate generation for "SEE 
>>> ALSO" sections in man pages")
>>> Signed-off-by: Yonghong Song <yhs@fb.com>
>>
>>
>> Hi Yonghong, thanks for the fix! I didn't see those warnings on my
>> setup. For the record my rst2man version is:
>>
>>     rst2man (Docutils 0.16 [release], Python 3.8.2, on linux)
>>
>> Your patch looks good, but instead of having blank lines at the end of
>> most files, could you please check if the following works?
> 
> Thanks for the tip! I looked at the generated output again. My above fix 
> can silent the warning, but certainly not correct.
> 
> With the following change, I captured the intermediate result of the 
> .rst file.
> 
>   ifndef RST2MAN_DEP
>          $(error "rst2man not found, but required to generate man pages")
>   endif
> -       $(QUIET_GEN)( cat $< ; echo -n $(call see_also,$<) ) | rst2man 
> $(RST2MAN_OPTS) > $@
> +       $(QUIET_GEN)( cat $< ; echo -n $(call see_also,$<) ) | tee 
> /tmp/tt | rst2man $(RST2MAN_OPTS) > $@
> 
> With below command,
>     make clean && make bpftool-cgroup.8
> I can get the new .rst file for bpftool-cgroup.
> 
> At the end of file /tmp/tt (changed bpftool-cgroup.rst), I see
> 
>      ID       AttachType      AttachFlags     Name
> \n SEE ALSO\n========\n\t**bpf**\ (2),\n\t**bpf-helpers**\ 
> (7),\n\t**bpftool**\ (8),\n\t**bpftool-btf**\ 
> (8),\n\t**bpftool-feature**\ (8),\n\t**bpftool-gen**\ 
> (8),\n\t**bpftool-iter**\ (8),\n\t**bpftool-link**\ 
> (8),\n\t**bpftool-map**\ (8),\n\t**bpftool-net**\ 
> (8),\n\t**bpftool-perf**\ (8),\n\t**bpftool-prog**\ 
> (8),\n\t**bpftool-struct_ops**\ (8)\n
> 
> This sounds correct if we rst2man can successfully transforms '\n'
> or '\t' to proper encoding in the man page.
> 
> Unfortunately, with my version of rst2man, I got
> 
> .IP "System Message: WARNING/2 (<stdin>:, line 146)"
> Literal block ends without a blank line; unexpected unindent.
> .sp
> n SEE 
> ALSOn========nt**bpf**(2),nt**bpf\-helpers**(7),nt**bpftool**(8),nt**bpftool\-btf**(8),nt**bpftool\-feature**(8),nt**bpftool\-gen**(8),nt**bpftool\-iter**(8),nt**bpftool\-link**(8),nt**bpftool\-map**(8),nt**bpftool\-net**(8),nt**bpftool\-perf**(8),nt**bpftool\-prog**(8),nt**bpftool\-struct_ops**(8)n 
> 
> .\" Generated by docutils manpage writer.
> 
> The rst2man simply considered \n as 'n'. The same for '\t' and
> this caused the issue.
> 
> I did not find a way to fix the problem yet.

The following change works for me.

@@ -44,7 +44,7 @@ $(OUTPUT)%.8: %.rst
  ifndef RST2MAN_DEP
         $(error "rst2man not found, but required to generate man pages")
  endif
-       $(QUIET_GEN)( cat $< ; echo -n $(call see_also,$<) ) | rst2man 
$(RST2MAN_OPTS) > $@
+       $(QUIET_GEN)( cat $< ; echo -e $(call see_also,$<) ) | rst2man 
$(RST2MAN_OPTS) > $@

  clean: helpers-clean
         $(call QUIET_CLEAN, Documentation)
-bash-4.4$

I will send revision 2 shortly.

> 
>>
>> ------
>>
>> diff --git a/tools/bpf/bpftool/Documentation/Makefile
>> b/tools/bpf/bpftool/Documentation/Makefile
>> index 4c9dd1e45244..01b30ed86eac 100644
>> --- a/tools/bpf/bpftool/Documentation/Makefile
>> +++ b/tools/bpf/bpftool/Documentation/Makefile
>> @@ -32,7 +32,7 @@ RST2MAN_OPTS += --verbose
>>
>>   list_pages = $(sort $(basename $(filter-out $(1),$(MAN8_RST))))
>>   see_also = $(subst " ",, \
>> -       "\n" \
>> +       "\n\n" \
>>          "SEE ALSO\n" \
>>          "========\n" \
>>          "\t**bpf**\ (2),\n" \
>>
