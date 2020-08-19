Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1172624948E
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 07:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725903AbgHSFo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 01:44:57 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:46118 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725497AbgHSFow (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 01:44:52 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 07J5icIU000990;
        Tue, 18 Aug 2020 22:44:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=uow3bXj0/J8IBspDfqZQEree83M3vjyLh32j4OQm1qE=;
 b=NKaI0gYuuwXTli7+tbDFVlQG2EkSkrOnwcU1S+ryq3ktpl+P+78qAYWptY/Cp4mzBfmH
 fzOhGAhYJC+nChfQL5OOuYxUEXLn+8fwjdmxcjMsRAAs4wb1qU11d3AjhKXJk2BJaGBk
 EuHSgunOc+2uEIvQOPN7/rXPzvT27O2weBM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 3304jq6t43-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 18 Aug 2020 22:44:39 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 18 Aug 2020 22:44:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cEmzO3l3XDuVtHkH6jalYU4OThhJFxWPnLJ1qe/5j9eUkea/C+G8zLHPioqdFjyIGbER0wLtIt2bcM7c1oOO0d3wE3OZfQvgHonNkHSZPiTSpblf5rrCOjPGSYe0WtIRlsEAp7TX67M0K6IwkFsiDlwxW23PiP5wnbT2r4Wp25UmBI13Td1iWWdkTR1BZ52hLSZo5m5uuX+mcugE+VSZ7isglNAZKTEeTADojG/g2XliBEqD6jnOIUa+KFCMdKTXFhJg9C7O/lL4o0G4B9xGtie7QI3we4F/tLIDONGQIe2r5nvNpdTgCcJ2vFgL4D/14k1tNWYfl8b9krxDbNWGmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uow3bXj0/J8IBspDfqZQEree83M3vjyLh32j4OQm1qE=;
 b=AYop/PH6gRWltNnofSeKLYpeYOOO+WW22Z9xqOWB39/i/oK2IATNtPCAA1tsAREdm425oEQDVKEwQOSAB8nHWdPGw+1/xV5nouhzvrfN/lc9WUWSIJ4VOAnde3LKyNyEdmy1jNTwhVHfMbPlsDwog8vRZO8LIO7RrKNAum4UI5lPoZ3h1MZaLu+v+TtY/9VwRCceQfu7x8Auig0/zX71thx8DjR3MpTW5k0Ovriq3EBc4rGopBu9ZqGuIo+MF2a9RRIh/5hEvDP8U/S5RsHCvQQWlUfvKHuE1sVBx0SGuKimtbVI10g0z+Y/eT+Gq3qJPphgxeeFK/deuuFkkwtS8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uow3bXj0/J8IBspDfqZQEree83M3vjyLh32j4OQm1qE=;
 b=ZclvssFFw8GK8U40MfndL+Ack/qzLy7iemebgKu7CwZTbVMBWFN+JU+z2MDjrjtTelBoorxSuf16k5L4i08NOIpXiYBat7GJV4dLFdG+0zoWkRf0Xw2L8oWqP+cBhSegL3ChTKV13X03YZ1QQSdu4oZoblOm0BFxwdCw739+UbE=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BY5PR15MB3569.namprd15.prod.outlook.com (2603:10b6:a03:1ff::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.16; Wed, 19 Aug
 2020 05:44:32 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3283.028; Wed, 19 Aug 2020
 05:44:32 +0000
Subject: Re: [PATCH bpf-next 1/7] libbpf: disable -Wswitch-enum compiler
 warning
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20200818213356.2629020-1-andriin@fb.com>
 <20200818213356.2629020-2-andriin@fb.com>
 <b26b5c66-f335-2e47-bf6c-f557853ce2d7@fb.com>
 <CAEf4BzaTWVhymaGuSHHHL8+TCbP=qRFc+YvG+ZMYMNTEg-vA-A@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <d69666c9-9c63-386f-130c-e30aba92e7c1@fb.com>
Date:   Tue, 18 Aug 2020 22:44:26 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <CAEf4BzaTWVhymaGuSHHHL8+TCbP=qRFc+YvG+ZMYMNTEg-vA-A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR13CA0028.namprd13.prod.outlook.com
 (2603:10b6:208:160::41) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c0a8:11e8::10d3] (2620:10d:c091:480::1:374f) by MN2PR13CA0028.namprd13.prod.outlook.com (2603:10b6:208:160::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.15 via Frontend Transport; Wed, 19 Aug 2020 05:44:30 +0000
X-Originating-IP: [2620:10d:c091:480::1:374f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0650cd8f-1875-4b15-fc01-08d84402f27b
X-MS-TrafficTypeDiagnostic: BY5PR15MB3569:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR15MB35695DECA12AB2D89C60D5FED35D0@BY5PR15MB3569.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kaFo0+BvTmQOR/MYxalukLUt8AF5SO3CCyP0ea8Myxef5YTtJCp5yQI1W9Zgwx0FMIlmulTenkFBdLtBDtGfzqEYSrmOKU6q2aZuhoGJXX5yDR8hZndrWVseVAHOnFnfq0SB/ItGs3KTzkmi2GCTQZ78lVGK48wvuQ2Cflr+s9N0Kzt0IGqRTUF+zqK/Q3b97poxotsseZd6/DxSBxH05ctyYx8egEp9YGe0gMfmP/phyvjTio3JkN7DCsJpR6vndWSr4EzVNpMtEj2/bL6krnFaJFqNO88At7pywPVVDHofF6KXfTvMdqoiZrIA5bdOCuUAMdP7ZiuiuVbxc2g1/Mn2FDuLAXx4S0rdVTK9/tA7Vn/iQ+FpATIHKbMEoQ94
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(366004)(376002)(136003)(346002)(186003)(8936002)(2616005)(66946007)(316002)(5660300002)(86362001)(31696002)(36756003)(16526019)(66476007)(2906002)(83380400001)(66556008)(6486002)(478600001)(4326008)(8676002)(53546011)(6666004)(54906003)(6916009)(52116002)(31686004)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 9w1AzQIZmZMnO3LK7L2zjXO4wikDcZkSXCSFV7LP9uoHNmIl7FX6rc/DOO9+mcmovXhqA+1uP8ssAj0nz9kDyuSAC1DZaa7hw5trHxOduRLXeeMVmvPxl2Z75puf6pYU90ZdSc304QIDcdyikwoaZTGpeQGmpsJix7DFPWD4FwP2wDlREFHye2VBpU8CJi7foRdklK+ye6Jx6hNxyr7bcURrnBSHGB6SczWHRdLVBiS6fGTyg8PJz7lOt9QHAMaJcMLf9sSv9xhcqjNnuV4oDu34ikiEta2ZLybfyjxO+33MfV2iLNtq0ADYiIZWJ7hQVEnartmSK7tgGii+iZsFuyrLh151JOdLZohNv4Mh+HYZ4ecv7SLixKlKodUP23Lzd2dOZgc4Ze9oVK1wDy2xAD+y8+CGBWl5Z0JzdWsSPdDrCE2Jbix3Qf0CpRPgz7oE5lkBIJ5pft6B+JwJ0N9QFERBNs4kTOa0k7Acd2G7RT5sVLMMLYBW7Z39v43JytuTLFutTcqn3W1r2/aHoX9ap+SA2uIV7R5zLGN9WZtcKp+pgPVCkzUSonMZHWOjnIxdS6g/7+YS693WBysUzYQrrJZMTSsVUmZBl+qObxreFUoGwKrv+P/+r/a0I92NCl6xFsk0W04wzOGcmV9k+zJuw5XxjWed41eViz/d0Qvs0G8=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0650cd8f-1875-4b15-fc01-08d84402f27b
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2020 05:44:32.3519
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AIvT2ZvASUL2qjFo2kK0IBTbfKo9Y3mUSJPPcPGFZhyZ9FXJZyvqVMMlkSXUSTUL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3569
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-19_04:2020-08-18,2020-08-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 impostorscore=0 adultscore=0 lowpriorityscore=0 mlxlogscore=916
 clxscore=1015 malwarescore=0 suspectscore=0 phishscore=0 spamscore=0
 mlxscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008190048
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/18/20 6:39 PM, Andrii Nakryiko wrote:
> On Tue, Aug 18, 2020 at 6:23 PM Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 8/18/20 2:33 PM, Andrii Nakryiko wrote:
>>> That compilation warning is more annoying, than helpful.
>>
>> Curious which compiler and which version caused this issue?
>> I did not hit with gcc 8.2 or latest clang in my environment.
>>
> 
> Strange, I just tried on bpf-next, removed -Wno-switch-enum and got
> tons of errors:
> 
> libbpf.c: In function ‘bpf_object__sanitize_prog’:
> libbpf.c:5560:3: error: enumeration value ‘BPF_FUNC_unspec’ not
> handled in switch [-Werror=switch-enum]
>     switch (func_id) {
>     ^~~~~~
> libbpf.c:5560:3: error: enumeration value ‘BPF_FUNC_map_lookup_elem’
> not handled in switch [-Werror=switch-enum]
> libbpf.c:5560:3: error: enumeration value ‘BPF_FUNC_map_update_elem’
> not handled in switch [-Werror=switch-enum]
> ... and many more ...

Okay I can reproduce now with latest bpf-next but not bpf.
Now I understand why you introduced this additional option.
The issue is introduced by the above code in Patch #4. To compile
patch #4, you need -Wno-switch-enum.

> 
> My compiler:
> 
> $ cc --version
> cc (GCC) 8.2.1 20180801 (Red Hat 8.2.1-2)
> 
> 
>>>
>>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>>> ---
>>>    tools/lib/bpf/Makefile | 2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
>>> index bf8ed134cb8a..95c946e94ca5 100644
>>> --- a/tools/lib/bpf/Makefile
>>> +++ b/tools/lib/bpf/Makefile
>>> @@ -107,7 +107,7 @@ ifeq ($(feature-reallocarray), 0)
>>>    endif
>>>
>>>    # Append required CFLAGS
>>> -override CFLAGS += $(EXTRA_WARNINGS)
>>> +override CFLAGS += $(EXTRA_WARNINGS) -Wno-switch-enum
>>>    override CFLAGS += -Werror -Wall
>>>    override CFLAGS += -fPIC
>>>    override CFLAGS += $(INCLUDES)
>>>
