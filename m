Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43C4C226865
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 18:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388672AbgGTQSs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 12:18:48 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:15924 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388376AbgGTQSp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 12:18:45 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06KG0nN8027907;
        Mon, 20 Jul 2020 09:18:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=MBYy8R1pd5BK88S4AUfWs+fQSV0UHxrvq2A9klR1z90=;
 b=ahEZOkK0iCEvlO/YDyOe3FUPKXjppHhJ0sahJBG0Ip4OhaqQE8/BRtICyDRJSJBdDH8j
 MypHWRnVRimWcL/fjmMhsKLXg0GgH6ZRU+adAhBbc5BjDBFj3nyNaLKY61hi/O/hz8XH
 F9M/lJDGVGj8Ickz7xm8PE0F6Fj6awZ9NQ4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32chbnmve3-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 20 Jul 2020 09:18:16 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 20 Jul 2020 09:18:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yhx57Qh+C1WFiYm96CbGP30L0H1xXSDSiq6BjHxZJgOBKWkWuN5GykAA07DldDkdV1E+cBPdfvQc3Wah5x43DOU1gEvdG1lr7/RPar7kEW6iUnlQH1KJiV9YuIJiYD3LdqdwZb90aQix3Pb0RIChov8LveitPcSbnA9N273GB/cLfvrHUBdKGtY6a2McXA6BlSPctH9+xxet3STOnZ0QOZZShxrAAL0g2R+M8F/ywZuleO1NHaw5tUve1EZLJkS6H1hpSjCHqOwWu8tEvfsVRsawCWHWe2t0Dr05HqF2/t9jkIqeAld/ZF9WsSnTbRTuTlBWBISQ8N6fcsaOy7FC3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MBYy8R1pd5BK88S4AUfWs+fQSV0UHxrvq2A9klR1z90=;
 b=naAXrigxqmyZahpbt2vs568mN5Z+x5plr9+wtbdltW+PGNoWhNPTfngd5ZCk2/TwLgHgv5sW1iFiH6BE00Vm4ovsnerEeoBesRkjcDBE06AxrCk5exXs8eDjbMjVA7awe63UjobX2hKOKdo/OP4Dr8cjmG7Q8xt8DeuEkarDxa45ryqKsfNTsKt4P9qqMacqOXPPzPuyg0/I1AdIwjVscW+J8x6koGtk1TFzvgTFatlmfapqB1vtnNVoAJzrrp78E225MCfnCylGu/JzVnLHr1B1i+Zh/6nrP5+LLh4znH/X+OV9DDLIoirs442lbV9cD7Ziz4Sfkc79FA8oFBMRig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MBYy8R1pd5BK88S4AUfWs+fQSV0UHxrvq2A9klR1z90=;
 b=OorI3Cc7bwOBf5xdjtGaSfJ6BLQgfRaXfu7nmHbMIfBJfNsgFy5xVpfmhFwurtVMBeUplK8O64YdzKgT42vbNUuTTgUXvNyfeapad5afvacYE0Uj92joMwGefutk2eidCKtYXs0+LsvX+6l7aVRbrwbi+o/aKkucUB5ht1vQ24U=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB4120.namprd15.prod.outlook.com (2603:10b6:a02:c4::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.25; Mon, 20 Jul
 2020 16:18:15 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3195.025; Mon, 20 Jul 2020
 16:18:15 +0000
Subject: Re: [PATCH -next] bpf: Make some functions static
To:     Wang Hai <wanghai38@huawei.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <kafai@fb.com>, <songliubraving@fb.com>, <andriin@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20200718115135.34856-1-wanghai38@huawei.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <cf3411eb-8129-ecc4-4975-a995d114cf7e@fb.com>
Date:   Mon, 20 Jul 2020 09:18:13 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
In-Reply-To: <20200718115135.34856-1-wanghai38@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0034.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::47) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21d6::1083] (2620:10d:c090:400::5:bab9) by BY5PR17CA0034.namprd17.prod.outlook.com (2603:10b6:a03:1b8::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.18 via Frontend Transport; Mon, 20 Jul 2020 16:18:14 +0000
X-Originating-IP: [2620:10d:c090:400::5:bab9]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b2684594-4e5e-41b7-df6f-08d82cc88154
X-MS-TrafficTypeDiagnostic: BYAPR15MB4120:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB4120C43AC7FF684FC611F3A1D37B0@BYAPR15MB4120.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:12;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4bBABV1ppbuAHU3pxCTR2UXfsA7VNol8Qi47wCXlt2QCN52fDnFjsOoemlbBG/aFSLDSXYTYoXF4L6rCbF3yW8EzJuZ8xouYbCyyOUUnB2ovZz8DG6mYb/FFgiOtYQMxCi56nCj9MRWGgaQVBQVFG2/GQ25zEUHQPAzT2xiwxTa2sAw5jOBeVbWHzN5jGwteMUi3KGPEeUpSMzqfjskF8w8uRVvWwHIuLqj24SQwHSY+T3/DtaHwiiiRT7HMldQlR7k0IW/0BmXftaP5s6L5nJ2CIQuGrKA7dzH8hbVFnpHbcEfZmryCFQ7jGBUBGJhojWWhv6et5pfKu/R5Zd0FvRyzG1ouZRynuPvWNw8zWkbsKmdxetc/bCGaOeYgxoHUJuFwa6/LXiUGx7iBvJLg8Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(136003)(396003)(376002)(366004)(346002)(316002)(5660300002)(2616005)(186003)(16526019)(52116002)(31696002)(31686004)(53546011)(8936002)(8676002)(66556008)(86362001)(66476007)(66946007)(7416002)(36756003)(6486002)(478600001)(4326008)(83380400001)(2906002)(921003)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: vwwyk8qMsLk1LjMQTGnn+1MgG4P+zCIXlNuHAoHfzoMfYaaJFfvtNv/4ixabzlcPCTGztLgxtsbt7J8Mg7GdjqNAP0gmP+JqNNNiumbIni5+sNnPIuBZ1qe6/h6Kw2SbiBGAi6He1sdU2SWr/uTBtQGSIttO6rOQ0aqVY0dHwNHfSlpmTrJJm2vO/3tliSOjlt0lU5Ix9MU3C/e315iyF8YzGHz/IhGxVY4CrfJuLgTbU7Xt8UXRNJ5SdyecAnqULXeSKFQxiStJGAharbLMlhzozVTKKW5RD/FaxMQzNF14MuG4wE8mFisV9l7hJ/8uo1uFWk76PYcET34w4c3I2XCc1idkvJXltxDrEoU6IM9w+TBIikJ6pxi1fdfpcyTkDVcxkqaWB7KoFPwVOl6axfCUM6qjFuhzoFCR2bk//4WmUx2RnbjWWZ/aIWxA08CRab5HDsYyhX4wFPt89l+lzIw6GgoiNenzCWdH7DNwLENGgQfuAaYvKVFztakKnmVAoRNbDLGSiqMhhh79HClWug==
X-MS-Exchange-CrossTenant-Network-Message-Id: b2684594-4e5e-41b7-df6f-08d82cc88154
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2020 16:18:15.0498
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sjBRWnDGorGQ0OmodiI806J4fj7JbCJUVQ1ke8HsHNtNpiknzg/+j3qpvM0g5y6x
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB4120
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-20_09:2020-07-20,2020-07-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 bulkscore=0 spamscore=0 impostorscore=0 priorityscore=1501 mlxscore=0
 phishscore=0 malwarescore=0 suspectscore=0 clxscore=1011 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007200108
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/18/20 4:51 AM, Wang Hai wrote:
> Fix sparse build warning:
> 
> net/bpf/test_run.c:120:14: warning:
>   symbol 'bpf_fentry_test1' was not declared. Should it be static?
> net/bpf/test_run.c:125:14: warning:
>   symbol 'bpf_fentry_test2' was not declared. Should it be static?
> net/bpf/test_run.c:130:14: warning:
>   symbol 'bpf_fentry_test3' was not declared. Should it be static?
> net/bpf/test_run.c:135:14: warning:
>   symbol 'bpf_fentry_test4' was not declared. Should it be static?
> net/bpf/test_run.c:140:14: warning:
>   symbol 'bpf_fentry_test5' was not declared. Should it be static?
> net/bpf/test_run.c:145:14: warning:
>   symbol 'bpf_fentry_test6' was not declared. Should it be static?
> net/bpf/test_run.c:154:14: warning:
>   symbol 'bpf_fentry_test7' was not declared. Should it be static?
> net/bpf/test_run.c:159:14: warning:
>   symbol 'bpf_fentry_test8' was not declared. Should it be static?
> net/bpf/test_run.c:164:14: warning:
>   symbol 'bpf_modify_return_test' was not declared. Should it be static?
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>

Please see commit:

commit e9ff9d52540a53ce8c9eff5bf8b66467fe81eb2b
Author: Jean-Philippe Menil <jpmenil@gmail.com>
Date:   Fri Mar 27 21:47:13 2020 +0100

     bpf: Fix build warning regarding missing prototypes

     Fix build warnings when building net/bpf/test_run.o with W=1 due
     to missing prototype for bpf_fentry_test{1..6}.

     Instead of declaring prototypes, turn off warnings with
     __diag_{push,ignore,pop} as pointed out by Alexei.

You probably use an old compiler (gcc < 8) which is why
the warning is emitted.

> ---
>   net/bpf/test_run.c | 18 +++++++++---------
>   1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> index b03c469cd01f..0d78bd9b6c9d 100644
> --- a/net/bpf/test_run.c
> +++ b/net/bpf/test_run.c
> @@ -117,32 +117,32 @@ static int bpf_test_finish(const union bpf_attr *kattr,
>   __diag_push();
>   __diag_ignore(GCC, 8, "-Wmissing-prototypes",
>   	      "Global functions as their definitions will be in vmlinux BTF");
> -int noinline bpf_fentry_test1(int a)
> +static noinline int bpf_fentry_test1(int a)
>   {
>   	return a + 1;
>   }
>   
> -int noinline bpf_fentry_test2(int a, u64 b)
> +static noinline int bpf_fentry_test2(int a, u64 b)
>   {
>   	return a + b;
>   }
>   
> -int noinline bpf_fentry_test3(char a, int b, u64 c)
> +static noinline int bpf_fentry_test3(char a, int b, u64 c)
>   {
>   	return a + b + c;
>   }
>   
[...]
