Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE3A26925F
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 19:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbgINRBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 13:01:39 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:49412 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726300AbgINQrN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 12:47:13 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08EGk4I1012425;
        Mon, 14 Sep 2020 09:46:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=8tf4Q1drG51WbA3RqYjONcrpDi9dloXYTr7xZOm5QjM=;
 b=Kl1NHYsXQ8OO+vc8MJA9a+5Zjvvr4eVcuDCJbUlz/QnsJJRyVfbgjeb2+5Kh2R1oloOS
 ZApbFJXdGSiqwPdvc+88Bh3uODADoeJczVp96BPL6Bg+KaWQlKtjkVZnOizZ1b3qnSNH
 99eNRg5cHqbK6rlp5mYL+wUD86jB+T73huo= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33gv2p9dpf-16
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 14 Sep 2020 09:46:50 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 14 Sep 2020 09:46:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U8ITjrCCMt3CYs70MPWRspcPj+4PdSDIieEWeyFxSZteYKK/MmodihkjN4x1SPPVyha2yN2YCACfdB/knymzqOt4oX6FMe3AJjWvQ/FBOvmKBVLfB39iqydRCuRyOZb0ri7K778OHyGVm1Rcy/bHBwY23G0hSvUyElL7y6m7dSSNV9s67Wvoy5NqJFDiZ58inaGoWC/Ynwzj65r5fwOqIDI685XEYaQy9wP+Rtl2YnAS+NEicrZZDUFAJRQHSFeFD8I0emCOT/LL2aKsX89k9PZ11KOL6tlzpnLikp6mkckuCcGAkCAO5pJayziuCpbv3Gf8iYEue+ZC2Mf4yGhpvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8tf4Q1drG51WbA3RqYjONcrpDi9dloXYTr7xZOm5QjM=;
 b=e3W2z+TXX4ZEBFFO0QHl/sOr94enEfjhgQrCUwd+q9IJwMIKbtbZAzrzltsf2awPyR64TujqYnYBMrMqde491YHPzfbNoucI6As2QMxJD01tsrr+w+A2tPXC3o1RXG6txy9JNs1UvuFXneSexEG0eDTNlhZExS4Cd4Dn5sQ4S2pktgbV6Psoo7ypWakdjWsyQge0T+LYvUn8IrwKF97YA9t6Oz/rbyJWZzsTlAK7P+qFOs2YjImIuxQ0mz+i8jk5qzGKLRX1rGmE6FIcEeVM1Og7XLoW5KnixA+n6WGHjEi45cwzj7pECXdtKX/X73XX30s6NDJN0fi+FGFyhM5D9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8tf4Q1drG51WbA3RqYjONcrpDi9dloXYTr7xZOm5QjM=;
 b=a2F5MuSX3fnyofJMVmCrwSjwBTYTN3cUEiDywP9PQ4Med/jyeNO5onC0ruADSdCjyIaKv3VV7q3mJcUIiW96kb0NjPmlNUIQg4LiRgSrfgblxjjv2naLFVZhOLFAtsfVsBsHb3Ez/KtuidM6MHxpJHdDMXA2+l2y3MHYT7g1ZpM=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2245.namprd15.prod.outlook.com (2603:10b6:a02:89::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Mon, 14 Sep
 2020 16:46:48 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42%3]) with mapi id 15.20.3370.019; Mon, 14 Sep 2020
 16:46:48 +0000
Subject: Re: [PATCH bpf-next] bpftool: fix build failure
To:     Quentin Monnet <quentin@isovalent.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
References: <20200914061206.2625395-1-yhs@fb.com>
 <b942625c-7140-0a57-337e-3a95020cfa99@isovalent.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <1ab672c7-f333-f953-16ec-49e9099b39d7@fb.com>
Date:   Mon, 14 Sep 2020 09:46:45 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
In-Reply-To: <b942625c-7140-0a57-337e-3a95020cfa99@isovalent.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR03CA0008.namprd03.prod.outlook.com
 (2603:10b6:300:117::18) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21d6::11f0] (2620:10d:c090:400::5:5351) by MWHPR03CA0008.namprd03.prod.outlook.com (2603:10b6:300:117::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Mon, 14 Sep 2020 16:46:47 +0000
X-Originating-IP: [2620:10d:c090:400::5:5351]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cb474e8a-6919-4546-d717-08d858cdc568
X-MS-TrafficTypeDiagnostic: BYAPR15MB2245:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB22456183FAFA0DDB21BFB90AD3230@BYAPR15MB2245.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Opmx0DfbtAqEcMigkgiOYsmhDM0fkp5qqi0oARavSV31WB3gmrKAubXOLh2SngmP0aHde6LYdvs1l9CFe9AKovOcHdHbx+XFBk1eNWkhEcjhMsPA+a8zpOzC3wCiVUWabrhPa6mdpdwpD5y4MJ1sAQayPHogF+kxhyLxfjn7Jfmr7pz8mIQpaDeteJZ+umZK48BgM6bkRuCn/ZUyoya2Td+WfM5v/xcfZm2Rg3fsHN3SAX7AEtWSctsYAY9WA+hOhxiBV9y4hB0F4b5W7kkpASrWuAYmwkto0rxcQlHg7lJIACQVWJOEMRQlmMZ1+dImZ+vZoWYtgmbhqUsIEn41V+mmWQg+2TFaFmROMeZgIQAPcFnhDoIKwtm7nU/7UGEr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(39860400002)(396003)(366004)(136003)(86362001)(478600001)(83380400001)(31686004)(316002)(54906003)(2616005)(8676002)(5660300002)(36756003)(6486002)(53546011)(4326008)(52116002)(31696002)(2906002)(66476007)(66556008)(16526019)(8936002)(66946007)(186003)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: suHkqGx/ejSgeIsnEHR6KEXgMbHIQnf0wLtCgHPaZyfoGBdnnMoyv/iEOk2Wm8o1zmIopT5Ujwilf0PYBRhD6nd9K4m7JctVRr1BSN4PH0+Pw6CwF3LlfbpDjfoVY5jy1eOGMZxcGDZYwKHkXwNd3l1RiaJspmr4hWjTmidaXaqL5/MPgODpUXo5TDuUGBoM9ujSjBx2n6/qqBOWOJRE17ISOMXCAJi37fLkF973F81W9b8pJc/S0uiTK9ioP/lVrjJCG/D9v+yM0qP0aLpPN8aZXBpzXwlyFD0aW0vQNTTBU4d0RTsIh/1oHO5FsSXB0qX9OkAi3ju5hhR6g8In22STYixFuLbtenOZVLyMC54AyVSlMUEoMAWP1rdvD6kHSX1Wc5vSBF8Wamf3yglIZa04cTKc0YhKDZEOdfmyz8mD2FteYSh/R17dA6IuJhkzYPCQMjI0fvRpiiqsQhW9njE6HLpnng/G1arBlAnSRzTc8JAY4cl+h9mo+OG8ta8DjdrRITOV2Xz93pd2ZUKv2HwS8SCxXlv4MfRTmyY865em9/4Na7589470ub5CvgQEz6Um56lJGZoVV+8JFane/M0m1NQZtLXU98GIcq3M9eZrc3o6TVWI0qNfYE2sp02StVJwtmGdwa2cjHAsvYK/cpAy60sAfCmg6AwYw6WDvmo=
X-MS-Exchange-CrossTenant-Network-Message-Id: cb474e8a-6919-4546-d717-08d858cdc568
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2020 16:46:48.3713
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DNkEURIuzeCNCcS94DPeiiTPMKTXMhtjgPfhcTYWhGz64w4PLabGXMaFvUnx4+w7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2245
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-14_06:2020-09-14,2020-09-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 malwarescore=0 mlxscore=0 spamscore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 suspectscore=0 mlxlogscore=999 lowpriorityscore=0
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009140135
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/14/20 1:16 AM, Quentin Monnet wrote:
> On 14/09/2020 07:12, Yonghong Song wrote:
>> When building bpf selftests like
>>    make -C tools/testing/selftests/bpf -j20
>> I hit the following errors:
>>    ...
>>    GEN      /net-next/tools/testing/selftests/bpf/tools/build/bpftool/Documentation/bpftool-gen.8
>>    <stdin>:75: (WARNING/2) Block quote ends without a blank line; unexpected unindent.
>>    <stdin>:71: (WARNING/2) Literal block ends without a blank line; unexpected unindent.
>>    <stdin>:85: (WARNING/2) Literal block ends without a blank line; unexpected unindent.
>>    <stdin>:57: (WARNING/2) Block quote ends without a blank line; unexpected unindent.
>>    <stdin>:66: (WARNING/2) Literal block ends without a blank line; unexpected unindent.
>>    <stdin>:109: (WARNING/2) Literal block ends without a blank line; unexpected unindent.
>>    <stdin>:175: (WARNING/2) Literal block ends without a blank line; unexpected unindent.
>>    <stdin>:273: (WARNING/2) Literal block ends without a blank line; unexpected unindent.
>>    make[1]: *** [/net-next/tools/testing/selftests/bpf/tools/build/bpftool/Documentation/bpftool-perf.8] Error 12
>>    make[1]: *** Waiting for unfinished jobs....
>>    make[1]: *** [/net-next/tools/testing/selftests/bpf/tools/build/bpftool/Documentation/bpftool-iter.8] Error 12
>>    make[1]: *** [/net-next/tools/testing/selftests/bpf/tools/build/bpftool/Documentation/bpftool-struct_ops.8] Error 12
>>    ...
>>
>> I am using:
>>    -bash-4.4$ rst2man --version
>>    rst2man (Docutils 0.11 [repository], Python 2.7.5, on linux2)
>>    -bash-4.4$
>>
>> Looks like that particular version of rst2man prefers to have a blank line
>> after literal blocks. This patch added block lines in related .rst files
>> and compilation can then pass.
>>
>> Cc: Quentin Monnet <quentin@isovalent.com>
>> Fixes: 18841da98100 ("tools: bpftool: Automate generation for "SEE ALSO" sections in man pages")
>> Signed-off-by: Yonghong Song <yhs@fb.com>
> 
> 
> Hi Yonghong, thanks for the fix! I didn't see those warnings on my
> setup. For the record my rst2man version is:
> 
> 	rst2man (Docutils 0.16 [release], Python 3.8.2, on linux)
> 
> Your patch looks good, but instead of having blank lines at the end of
> most files, could you please check if the following works?

Thanks for the tip! I looked at the generated output again. My above fix 
can silent the warning, but certainly not correct.

With the following change, I captured the intermediate result of the 
.rst file.

  ifndef RST2MAN_DEP
         $(error "rst2man not found, but required to generate man pages")
  endif
-       $(QUIET_GEN)( cat $< ; echo -n $(call see_also,$<) ) | rst2man 
$(RST2MAN_OPTS) > $@
+       $(QUIET_GEN)( cat $< ; echo -n $(call see_also,$<) ) | tee 
/tmp/tt | rst2man $(RST2MAN_OPTS) > $@

With below command,
    make clean && make bpftool-cgroup.8
I can get the new .rst file for bpftool-cgroup.

At the end of file /tmp/tt (changed bpftool-cgroup.rst), I see

     ID       AttachType      AttachFlags     Name
\n SEE ALSO\n========\n\t**bpf**\ (2),\n\t**bpf-helpers**\ 
(7),\n\t**bpftool**\ (8),\n\t**bpftool-btf**\ 
(8),\n\t**bpftool-feature**\ (8),\n\t**bpftool-gen**\ 
(8),\n\t**bpftool-iter**\ (8),\n\t**bpftool-link**\ 
(8),\n\t**bpftool-map**\ (8),\n\t**bpftool-net**\ 
(8),\n\t**bpftool-perf**\ (8),\n\t**bpftool-prog**\ 
(8),\n\t**bpftool-struct_ops**\ (8)\n

This sounds correct if we rst2man can successfully transforms '\n'
or '\t' to proper encoding in the man page.

Unfortunately, with my version of rst2man, I got

.IP "System Message: WARNING/2 (<stdin>:, line 146)"
Literal block ends without a blank line; unexpected unindent.
.sp
n SEE 
ALSOn========nt**bpf**(2),nt**bpf\-helpers**(7),nt**bpftool**(8),nt**bpftool\-btf**(8),nt**bpftool\-feature**(8),nt**bpftool\-gen**(8),nt**bpftool\-iter**(8),nt**bpftool\-link**(8),nt**bpftool\-map**(8),nt**bpftool\-net**(8),nt**bpftool\-perf**(8),nt**bpftool\-prog**(8),nt**bpftool\-struct_ops**(8)n
.\" Generated by docutils manpage writer.

The rst2man simply considered \n as 'n'. The same for '\t' and
this caused the issue.

I did not find a way to fix the problem yet.

> 
> ------
> 
> diff --git a/tools/bpf/bpftool/Documentation/Makefile
> b/tools/bpf/bpftool/Documentation/Makefile
> index 4c9dd1e45244..01b30ed86eac 100644
> --- a/tools/bpf/bpftool/Documentation/Makefile
> +++ b/tools/bpf/bpftool/Documentation/Makefile
> @@ -32,7 +32,7 @@ RST2MAN_OPTS += --verbose
> 
>   list_pages = $(sort $(basename $(filter-out $(1),$(MAN8_RST))))
>   see_also = $(subst " ",, \
> -       "\n" \
> +       "\n\n" \
>          "SEE ALSO\n" \
>          "========\n" \
>          "\t**bpf**\ (2),\n" \
> 
