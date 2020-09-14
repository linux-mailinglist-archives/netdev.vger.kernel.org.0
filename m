Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0166269255
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 18:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbgINQ7E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 12:59:04 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:11056 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726121AbgINQ4J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 12:56:09 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08EGkUWF024062;
        Mon, 14 Sep 2020 09:55:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=QFNyuXaaYsablfInsdUabNzuD6lvsQrrCYOEZyJyuR8=;
 b=FZPD2ggtXfVxfr192XbCWML2O3P9r/8kA/9Pc7pc8I0gRJRkkkkcK8iglQFSgwMDSGgs
 FXlcPECxO8413rjxDeT1YDvK3Z3Z4jGKY5bsTiJIEq/Twt0txkkBW8WmZRE0WuMrekKL
 mUjl2I3hncvcLzQnYwi5iQxtEtgCzm6V+84= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33hed3wyup-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 14 Sep 2020 09:55:52 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 14 Sep 2020 09:55:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NnPrcSWa5w2JEt+gT0Q2JbTsz+VT3XgckaJBgjBErloqKG9w1u88Jps0z0BcFqhOCJfjjBb6TrUWKFTCAivd3vfzW3k0rWmuDr8OpVFenznlJYLUgkZAg0jgCXSKMdWZeit2moiEdwsb/n86nxJDWwNihKSuOohs/NGJMWPUwtFqh/ntgeSWr19BYKyIpZ8YEWKKg/tvbaGGfNb1F2W47GsQzXsfB7rjb6nQcafDdoMWSr/1xf9U4A0uiwaPvNxDV/pMEOO+0Ivwor6q4K96zaWi7bUdRK8Jb2L0R49t17WtX8M22D+nHoJQXBUx9oXexLooVAhYh0BjjaxAhJu9bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QFNyuXaaYsablfInsdUabNzuD6lvsQrrCYOEZyJyuR8=;
 b=C+hmcp8AsPbSJgQBq31leW+AZXr+/AWdtgppGV13PfM8BsQ+1b5S5dvrIeXJZ0Eekoj7CwjHjXxePwY4S75UQ77qz3TKPtWsvuLlgzZ/N8tU4mpmXvzDmYvGYYwaShyQKtB7pZfPop1IsRqqqd2n0IejTdr7VNf+FNWQloCokXW1PnWYr3ASTdYmfqZAYUL3n+VIhwB5CHp8aIfX4s78VqHUjzZcj/DpArhitqlK9Wh82Wsy0hL8mVOuOjESlmdFfbnb085sJnXmEbGgF7SF8wOEGYAa8heQj63w6rzqWn7b+36rq8XeP+JzKXUgw+30m2PezGiJ0LMt0QteLsmtTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QFNyuXaaYsablfInsdUabNzuD6lvsQrrCYOEZyJyuR8=;
 b=iIKeB7X+AFj+c+Y455gMNjjcz2Ikk0+CxNbUViYx1E0YNO5F9lHXK0d71jSOBozsCw4T/GWYK76TGIzMMru7vS/e7C56Ay6VV5J72/zpMwj6TC/AzHVvCessb7uBfo5RBNIoROYwgmRy0NKEWSb9qJ5oF34denfD7ZDEDwSx9no=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2567.namprd15.prod.outlook.com (2603:10b6:a03:151::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Mon, 14 Sep
 2020 16:55:46 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42%3]) with mapi id 15.20.3370.019; Mon, 14 Sep 2020
 16:55:46 +0000
Subject: Re: [PATCH bpf-next] bpftool: fix build failure
To:     Song Liu <song@kernel.org>, Quentin Monnet <quentin@isovalent.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20200914061206.2625395-1-yhs@fb.com>
 <b942625c-7140-0a57-337e-3a95020cfa99@isovalent.com>
 <CAPhsuW5Ja5if-DOPQn1FrbiEsH-YXXYVGzM59XQkyG5_xNmD-A@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <c33a5edc-ea0a-e575-d229-d0aaf2812fa7@fb.com>
Date:   Mon, 14 Sep 2020 09:55:44 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
In-Reply-To: <CAPhsuW5Ja5if-DOPQn1FrbiEsH-YXXYVGzM59XQkyG5_xNmD-A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW2PR16CA0035.namprd16.prod.outlook.com (2603:10b6:907::48)
 To BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21d6::11f0] (2620:10d:c090:400::5:5351) by MW2PR16CA0035.namprd16.prod.outlook.com (2603:10b6:907::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Mon, 14 Sep 2020 16:55:45 +0000
X-Originating-IP: [2620:10d:c090:400::5:5351]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3939d389-4f66-4034-5223-08d858cf067b
X-MS-TrafficTypeDiagnostic: BYAPR15MB2567:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2567BF3AC00DF44973F085CBD3230@BYAPR15MB2567.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Wt71cJhpZNtcKQslYQh2lnYr82Bw0s7uI4QFfo0h8Ap/ka7sn64ptmBhZbic4N9gUNv7ZYDpVfSSpcNFExJlWEHD8TbCFXvbB9BA+5WmR4ygkecZ5uQh4qefjUmGAm5Srg2ufAlHk9y2nFI4Ue3S6jrj/1uu+QTYIZHddIEnE7hv9wjlTcQ+XtDP8/CoJaoGYcr7d7m0KL1q8BxbjJLVsP89JErLuSVpQJdd/DgMD8TWgt5/Ky+vmXlFXasnYYj5KvRbH5PWxf/P9wsFUxcQq1r/ySH4eRRzg2EkCrpDd9CSznzWd6iM6QzAf30Ab5Ipa84eCIhDeeFiLdbywLg5DOhGRirOsSz1MmOXp9EFLTmT1Aj1QqOoBOhj6HzKA/uc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(39860400002)(346002)(396003)(366004)(6486002)(2616005)(36756003)(53546011)(5660300002)(54906003)(4326008)(52116002)(31686004)(110136005)(8676002)(16526019)(316002)(478600001)(66556008)(66476007)(2906002)(186003)(66946007)(8936002)(83380400001)(31696002)(86362001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: lhhhSdY3z2C4dJ03diALp0Se9BZSv1BI1pZq1LV53SY0LO125ns7AZkC7Wadt5edNAcipYYJCesOxGKYwdeyUuU7txgS7HTy3WW3IHoYXpPX6pj6dg2W7M5zvbQs4ryX+5dcLFJh7Hkftiuk90kv8YwV+3NGMhQP8ld9FkJYZUSNtCrzMx5jHJ8FtkGI48oH5qiFR1XkFDSp3Cu6702g7VDHnCy4hjQC1P4UUZno/NPCiDnbQJD09p5qDHMVD5I9RrRcI4hpb/nKZ+oiKdU4kMFLlrEG441MApXCASd5GIwCmIrUnf/PwtPtbIry2K8pMp+Om85dob+KuGlgPhVMgE6x/IfokLNAPOwBKjnG+2PkHDj6nNpsy0GFOpFW8x5C12O0muNNvASxmiObW6z2EnGgvQEsrMXwGuwTW8Dw+8TrAs/QlQQKtj+BxErzXg6q91lpTnuf1WInIlY9raBz863MhmOrGpcwxo/6HC4BkbT/ASBrWonA3TCJ8g9wmgojH2sQsFSQEOBnN6q0DXfcSIc6IiDzXzLYOBuwHmFqu/HrJmxkr1P1BWLO8OHn7V52i7NPz7RXpPkgBkC4UIH32FfzwT7iwunySqS2hM+tz9eM1jlwO7jqjheY4inYaCkuD0HyfkkFknTKxKscEqeUbDwoFii/jOXnziMsf42TyGc=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3939d389-4f66-4034-5223-08d858cf067b
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2020 16:55:46.3954
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qwacYkBmYBvvb6k3pSy7KcfJgJ9rFAw407ZjCs2iDyJSEX6Q0MjslI90iOilP+l4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2567
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-14_06:2020-09-14,2020-09-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1011
 adultscore=0 lowpriorityscore=0 suspectscore=0 mlxscore=0 bulkscore=0
 phishscore=0 impostorscore=0 spamscore=0 mlxlogscore=999
 priorityscore=1501 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009140136
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/14/20 9:20 AM, Song Liu wrote:
> On Mon, Sep 14, 2020 at 1:20 AM Quentin Monnet <quentin@isovalent.com> wrote:
>>
>> On 14/09/2020 07:12, Yonghong Song wrote:
>>> When building bpf selftests like
>>>    make -C tools/testing/selftests/bpf -j20
>>> I hit the following errors:
>>>    ...
>>>    GEN      /net-next/tools/testing/selftests/bpf/tools/build/bpftool/Documentation/bpftool-gen.8
>>>    <stdin>:75: (WARNING/2) Block quote ends without a blank line; unexpected unindent.
>>>    <stdin>:71: (WARNING/2) Literal block ends without a blank line; unexpected unindent.
>>>    <stdin>:85: (WARNING/2) Literal block ends without a blank line; unexpected unindent.
>>>    <stdin>:57: (WARNING/2) Block quote ends without a blank line; unexpected unindent.
>>>    <stdin>:66: (WARNING/2) Literal block ends without a blank line; unexpected unindent.
>>>    <stdin>:109: (WARNING/2) Literal block ends without a blank line; unexpected unindent.
>>>    <stdin>:175: (WARNING/2) Literal block ends without a blank line; unexpected unindent.
>>>    <stdin>:273: (WARNING/2) Literal block ends without a blank line; unexpected unindent.
>>>    make[1]: *** [/net-next/tools/testing/selftests/bpf/tools/build/bpftool/Documentation/bpftool-perf.8] Error 12
>>>    make[1]: *** Waiting for unfinished jobs....
>>>    make[1]: *** [/net-next/tools/testing/selftests/bpf/tools/build/bpftool/Documentation/bpftool-iter.8] Error 12
>>>    make[1]: *** [/net-next/tools/testing/selftests/bpf/tools/build/bpftool/Documentation/bpftool-struct_ops.8] Error 12
>>>    ...
>>>
>>> I am using:
>>>    -bash-4.4$ rst2man --version
>>>    rst2man (Docutils 0.11 [repository], Python 2.7.5, on linux2)
>>>    -bash-4.4$
>>>
>>> Looks like that particular version of rst2man prefers to have a blank line
>>> after literal blocks. This patch added block lines in related .rst files
>>> and compilation can then pass.
>>>
>>> Cc: Quentin Monnet <quentin@isovalent.com>
>>> Fixes: 18841da98100 ("tools: bpftool: Automate generation for "SEE ALSO" sections in man pages")
>>> Signed-off-by: Yonghong Song <yhs@fb.com>
>>
>>
>> Hi Yonghong, thanks for the fix! I didn't see those warnings on my
>> setup. For the record my rst2man version is:
>>
>>          rst2man (Docutils 0.16 [release], Python 3.8.2, on linux)
>>
>> Your patch looks good, but instead of having blank lines at the end of
>> most files, could you please check if the following works?
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
>>   list_pages = $(sort $(basename $(filter-out $(1),$(MAN8_RST))))
>>   see_also = $(subst " ",, \
>> -       "\n" \
>> +       "\n\n" \
>>          "SEE ALSO\n" \
>>          "========\n" \
>>          "\t**bpf**\ (2),\n" \
> 
> Yes, this works (I am using the same rst2man as Yonghong's).

Song, could you help check whether the following change works for you or 
not?

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

> 
> Thanks,
> Song
> 
