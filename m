Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 261B1166E70
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 05:20:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729701AbgBUEUh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 23:20:37 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:3572 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729280AbgBUEUh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 23:20:37 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01L4KM87016759;
        Thu, 20 Feb 2020 20:20:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=HlGBg6f3POlox6u581Dou65zmViAqTSHc1qphkgr2fE=;
 b=dtABED6rO1FPVdmyhT1r/s+HDHPnLMXfwGjIzTDBPHnJHXGtW3UYgnfyONFf4p+qr5dc
 mbQruWteyRi1LtAdEFCx0cvlVWShGaxsQ2GINskAWogJoWzwj4M3f+y1AGstxYxe4gDt
 T1Fp3MP3YhR3mPxZ/qTj8PPR95NVAYIQJ6o= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2y9y9njcqc-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 20 Feb 2020 20:20:23 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Thu, 20 Feb 2020 20:20:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fRFUb71GX1ZcHIoCZBYL4CtJePDjTU9ng07J3oSALQw+l8hjGedMvU/F2RKDtOja7tWgK9VB7fUHfjT/6RtqF8/X4ZE6r0KY1cpLDV0p5n11fyqhQyf4nfTsdBiKcqcY94YaG9M4prIP+JEUvqJVtVpcLxfcgqrwrbh26btCreHSIkC26Nm1uB9XGrrSy29+l2nkn3WJsSUxjBNomcoEyYvADxMkFkWFpmG9UD7hcwLGgMo/7qk6EqHrNieWKUd42SirLyc6GZ+qMKRwm0/kq1q7E81YYmsHWXp9SS0XpTYQONqImzaIUBtbVdD+yqi2gDqDifLsCVUSUFzJG65mew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HlGBg6f3POlox6u581Dou65zmViAqTSHc1qphkgr2fE=;
 b=jZ5Nx/NatLuINVyFbh9azVSXROKwHQ0hz660olAMYWsNpIo9CbZ/nAYp3I+rB9R8Sxml4IIXghVxPEL/95dnvUHLZbuF/lk5wCHp4/XZgzARDoYUlf9ZzHUcUELkSAgc4+jjn08iE14VKgCLFX5dLHnhBSUnsziDCDnKnKu7zwaPQtMgzHtSUsQ8WqMuSaitnzphi+mi/xsT0RYf05auev7X8b7kcnWOEhL3oAZpk8H5BXcUDkUB2z0gVYXgfEg1lp7v3gPiRcwR/hZaEySXnF7tWgHq8yjW4wxWKl9UwoFNcyabqDoppk776wngTxWLUn+Cdn8ETeW569lPFi7NdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HlGBg6f3POlox6u581Dou65zmViAqTSHc1qphkgr2fE=;
 b=MY3UudNqMTmna8zmSMupL52cDnxlMWhLJmfmM5CLS0SwNAmOJ/jI3DpwqMVnj2s0jeFTce4o1++9et44Nhza+9SYLP3tP12sP5rfqHDz7sX9VQ91OPOu96Y28q0lpcJ7dFuo9VgpfNvZfDCS7kKejXoanSqKtNqousOER7kyQnc=
Received: from MW3PR15MB3753.namprd15.prod.outlook.com (20.181.52.17) by
 MW3PR15MB3867.namprd15.prod.outlook.com (20.181.49.72) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.25; Fri, 21 Feb 2020 04:20:06 +0000
Received: from MW3PR15MB3753.namprd15.prod.outlook.com
 ([fe80::5956:e4d6:26a3:343e]) by MW3PR15MB3753.namprd15.prod.outlook.com
 ([fe80::5956:e4d6:26a3:343e%7]) with mapi id 15.20.2750.016; Fri, 21 Feb 2020
 04:20:06 +0000
Subject: Re: [PATCH bpf-next] selftests/bpf: fix trampoline_count clean up
 logic
To:     Song Liu <song@kernel.org>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>, Jiri Olsa <jolsa@kernel.org>
References: <20200220230546.769250-1-andriin@fb.com>
 <CAPhsuW60BM0JjTBLyE3mYea+W-5CFPouveMfEwkbMEwQUbNbZg@mail.gmail.com>
From:   Andrii Nakryiko <andriin@fb.com>
Message-ID: <c7df7db0-0c47-37a5-0764-ee45864f7e55@fb.com>
Date:   Thu, 20 Feb 2020 20:20:03 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
In-Reply-To: <CAPhsuW60BM0JjTBLyE3mYea+W-5CFPouveMfEwkbMEwQUbNbZg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR17CA0096.namprd17.prod.outlook.com
 (2603:10b6:300:c2::34) To MW3PR15MB3753.namprd15.prod.outlook.com
 (2603:10b6:303:50::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:2103:51:fde8:f2bb:1332] (2620:10d:c090:400::5:c0d0) by MWHPR17CA0096.namprd17.prod.outlook.com (2603:10b6:300:c2::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.17 via Frontend Transport; Fri, 21 Feb 2020 04:20:05 +0000
X-Originating-IP: [2620:10d:c090:400::5:c0d0]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 225cb21f-f9e7-4685-d26a-08d7b6855447
X-MS-TrafficTypeDiagnostic: MW3PR15MB3867:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB38672FA64B3633B9A2AF2615C6120@MW3PR15MB3867.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 0320B28BE1
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(39860400002)(136003)(396003)(366004)(346002)(376002)(189003)(199004)(52116002)(66556008)(2616005)(66476007)(54906003)(316002)(478600001)(53546011)(31686004)(66946007)(186003)(86362001)(31696002)(16526019)(6916009)(8936002)(36756003)(6486002)(8676002)(5660300002)(81156014)(2906002)(4326008)(81166006);DIR:OUT;SFP:1102;SCL:1;SRVR:MW3PR15MB3867;H:MW3PR15MB3753.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZJQ8A5OII+5jAmQJQn0MgW/1hTPpSNwi8FSEouM5xFxMHXJwqeKIAJn4NNJtzyC9LtduiFgBfTyATZOXkNbSlshhmNmMPfOWi2RdYXpZKhZRFGWhiuzCK9ftkHaTyx/7LY3dic/nN/czj6uEKnEpvrfnr7z52dt380bAJTe1jguNIuWObC3Cx2197yF0Ltnaa1cP2egEMlTylID2d2lvTwpB9vFoUMGe3aMjHfFMroq7XsfaGSap1LpVmDYQwf81zowMxtp6prfKM4Gf4dutGdzsLjmApyhcqpxaIVEzLzIlCWLm3Q7+2Cn9c3lHOxTY/SbtkRfarkimaonbpVX8WhYfWFkOsF3WTeRTRsy2O0GZLQoWIkgSsAq3GK/D8zrzVATIegoxfDfMlzpjSNNEImzyw7awQ8wnvJRQeZE4gV/Vcr+x4tbU2eRv2xnFGI0n
X-MS-Exchange-AntiSpam-MessageData: QYgh03iyqD/i6vpSa4DNcESSHBmQSpS+IqC8V8m0e52GjffcKkAhJuYUIQ72oePwviCnwZlpF0/gBz+Ky4/ojVJnu6O+hvyZuyogMF1yr5NBt33fMJLyJSSeujFGLBhmTC2HNOuXgz94iWz2ZR3/0sLEMXn3Mk2Aolkiu/DYd0E9QWvotQv1S6REiOv8tv8q
X-MS-Exchange-CrossTenant-Network-Message-Id: 225cb21f-f9e7-4685-d26a-08d7b6855447
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2020 04:20:05.8795
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uNbB5nr6CVyoT5bLcH42kPIKUKPmgzht0XOymuGkWJyAb1SBq2mgRzIOI/LJfnhD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3867
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-20_19:2020-02-19,2020-02-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 spamscore=0 impostorscore=0
 mlxscore=0 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002210029
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/20/20 6:06 PM, Song Liu wrote:
> On Thu, Feb 20, 2020 at 3:07 PM Andrii Nakryiko <andriin@fb.com> wrote:
>>
>> Libbpf's Travis CI tests caught this issue. Ensure bpf_link and bpf_object
>> clean up is performed correctly.
>>
>> Fixes: d633d57902a5 ("selftest/bpf: Add test for allowed trampolines count")
>> Cc: Jiri Olsa <jolsa@kernel.org>
>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>> ---
>>   .../bpf/prog_tests/trampoline_count.c         | 25 +++++++++++++------
>>   1 file changed, 18 insertions(+), 7 deletions(-)
>>
>> diff --git a/tools/testing/selftests/bpf/prog_tests/trampoline_count.c b/tools/testing/selftests/bpf/prog_tests/trampoline_count.c
>> index 1f6ccdaed1ac..781c8d11604b 100644
>> --- a/tools/testing/selftests/bpf/prog_tests/trampoline_count.c
>> +++ b/tools/testing/selftests/bpf/prog_tests/trampoline_count.c
>> @@ -55,31 +55,40 @@ void test_trampoline_count(void)
>>          /* attach 'allowed' 40 trampoline programs */
>>          for (i = 0; i < MAX_TRAMP_PROGS; i++) {
>>                  obj = bpf_object__open_file(object, NULL);
>> -               if (CHECK(IS_ERR(obj), "obj_open_file", "err %ld\n", PTR_ERR(obj)))
>> +               if (CHECK(IS_ERR(obj), "obj_open_file", "err %ld\n", PTR_ERR(obj))) {
>> +                       obj = NULL;
> 
> I think we don't need obj and link in cleanup? Did I miss anything?
> 

We do set obj below (line 87) after this loop, so need to clean it up as 
well. As for link, yeah, technically link doesn't have to be set to 
NULL, but I kind of did it for completeness without thinking too much.
