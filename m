Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C33C72882FB
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 08:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730078AbgJIGtp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 02:49:45 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:27448 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726347AbgJIGtp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 02:49:45 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0996jIXS029530;
        Thu, 8 Oct 2020 23:49:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=rA4bB/4a18bIneMsmT6b88p3sdG5nDnE+dA7HtHRymc=;
 b=hhS/U28/EqioFvoyVfvxAXCHGS6pR5uihRtV1AZR2Qzs1QlVlLts1OYaFC2oEl3e+RNa
 lmWtuxmBtaP/mgrzNDvDni+bqt6lw8FnJcIJTZuzk9Mh8/Za8eKxJVsl/YKHTdpm/+Dx
 g5CzMe/Wop8V43mAcEiXElPv6kaZXDvxPIU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3429ggt6ma-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 08 Oct 2020 23:49:31 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 8 Oct 2020 23:49:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X7VwCLyoicg8HkisDhRKyk0Tw5v8aofgi9NwVGpjclFLJxhZOSQd2/amnYiBl8vrU5E7UA3eWi6H6X/wzApOQCgP8n7xsLVr7+hmrzmcVK0CNTe/8kx9GRG2k4fg5f7NCYRCwUlUNf1rmqTjm9zQL+k/3zmkyFvMVRXYaFfthG/uxW2+DvfRX/TpmyPCxj9V5EyzzwXd8wmlUJ1YA302G355F1+zVvh7SufUOwFzKDlP/JODqdvcfnleXSBnY1StN5Lzwa04+gJU7Y9mfL/ydWNdwM87KAQ7h+BXJe+hGXDPpRSumdCydFZ+q5fq5ZIrg87jeX4dBAZ76NlkzA2ZGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q3Kg8rB7K/JUdPB8ik8LgvcSx6kNR5oZkZ+ph1KEqKY=;
 b=lfvW2Q+qpnywEzlFlNYF1d4LX5QvNJ/YxapAU4qQeqiU6y7oop28+lgpg7eLrLmdU0ZzEfAfMF9SxhTZGBxv/wYx5Eo16/EG1kFjqkSY5YKkA3qh2yTG9F354lL4uUNEF+GIuJA+sf9q0lXG7id750jebo8b+h4GHwtiUvCB51Iq5+QUUocuEmD5gcQCFQN1h7oPeTDDNf8KP4tLZc7dnT9+SeMYkEmVuD/NbnxWZXcJ1Nws3OFcR6B1KUkQzUCwKjBmCjAJBke4nnwqVyGrZ7/TXC+etxSeAXewK+K/DrVRlVyYooT+POldSyqeogFIY5hnD7ID5RC92IQ3U66S3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q3Kg8rB7K/JUdPB8ik8LgvcSx6kNR5oZkZ+ph1KEqKY=;
 b=VTeoDCs6zxF7SYi+HjGNtpKt36zqClQ1IhO/+joG1ovMU87WBGcdJoHgzid1satB+yao5wgDqUrFIkO32DzlD5yG51IlA9ltdmYLBIElkksFHZjrI4/19eh7LdyhneQqEYjc6st1P+1NVNK73FWLhAv0rc1Fdi1Ng+XTIzmiRxE=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2245.namprd15.prod.outlook.com (2603:10b6:a02:89::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.24; Fri, 9 Oct
 2020 06:49:30 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42%3]) with mapi id 15.20.3455.024; Fri, 9 Oct 2020
 06:49:29 +0000
Subject: Re: [PATCH v2 bpf-next 3/4] selftests/bpf: Add profiler test
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <john.fastabend@gmail.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-team@fb.com>
References: <20201009011240.48506-1-alexei.starovoitov@gmail.com>
 <20201009011240.48506-4-alexei.starovoitov@gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <5c129fe9-85ad-b914-67d3-435ca7eb2d47@fb.com>
Date:   Thu, 8 Oct 2020 23:49:27 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
In-Reply-To: <20201009011240.48506-4-alexei.starovoitov@gmail.com>
Content-Language: en-US
X-Originating-IP: [2620:10d:c090:400::5:68ff]
X-ClientProxiedBy: MWHPR20CA0038.namprd20.prod.outlook.com
 (2603:10b6:300:ed::24) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::1844] (2620:10d:c090:400::5:68ff) by MWHPR20CA0038.namprd20.prod.outlook.com (2603:10b6:300:ed::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.35 via Frontend Transport; Fri, 9 Oct 2020 06:49:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ca6709dc-d1f9-41da-dc88-08d86c1f789b
X-MS-TrafficTypeDiagnostic: BYAPR15MB2245:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB224521B58B301B30D7389302D3080@BYAPR15MB2245.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YFd6zVpDCCA9VDXqTs3EaWLRCXgPk7rgjVsGzn7/TJpP9YIGIOeLdI4TZ9hjfUZRYJZqaZNbaMJhUPjx7MaWdehY/E8oX6xJyEwSPRH4Xygj6TMKbKbT3/s9ir2xxJfX4h6FGqbBk5emGFhhYVnjsMMw1PeGzkp3ZFDm85fN5TWpuCkd4acPN9mTYP+SGzXqY/VZj2KAZdyGW6npu+Dad+cKv1ZqME1C4RPwZuWZdzMY3iAfK7HLE5pVMWWUiVYxSvrLii6rR+QPeSKB+NrByV0DeCNoJXB9Kufr8AoTKiFtKLolP6lCKacXDCXvcEJjvivZVnIHxTIiJJ5CRe9mr5/C+9G1eiZEULYgtMi4tQgMyLio9SAv1gQitlAiGZ3qahSf/+GmZJSYJCrIqvAGrO1jYTRzSume9p+oxKJtjrmKVukgz+1zMhqvE8e4G/ui5YVkQtZLaqQN9/krAPZkkw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(396003)(376002)(39860400002)(346002)(66556008)(83080400001)(36756003)(16526019)(2906002)(186003)(86362001)(316002)(52116002)(4326008)(8936002)(66946007)(478600001)(31696002)(2616005)(966005)(66476007)(53546011)(8676002)(31686004)(5660300002)(6486002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: i3NIDlPQjk6YhUyhwAQX8I/jAboQZKxtShrwqNiCZiY6FGpnrzHLoM6C/OBaq7y2cjT5i56TOV8nq6Z0cnSa7c/ImVuXug3fvVIvbq/QJ2xMszDSpWXRDykKJ9n2dWH+J+sQ+wnx1eXxiauhaiKxoYhEq5zDa2Xj+mzRtOcrERTrD/lOI2MfisV1gTXTZHqftZGzRM6dMnlrCDV0IJ7cQ4yU9AGokKydyhunpk7KF2yWN2Eg/FKZnS1AN0Fokkdb5/rfn6g8CNWdBprOU8EDruN/V9N+UMrXKKZDFiIHgSb+jD3Z/JV8DmionrcEaaaBomddINVZq2vJoRIFQWFLYJtq3fY6c/JSJ03E/NzzilnNBlBdx39Z3/ogI/RJHqVaKPDpCh6DCECReF3TvXhRA21xKDURL3CI3vbSc1A2STaMcAeB7M9ZtFoMMOc6Xlba1ViFaBdlcihyydZ9MryY5rBzhAUtpqlWWlum5ch2FJ+tQhy5V1QnzifsYyJgoNb3VDKD8r/WwHlqdHSEm/OsglyJl8bXxockPrzHHw3Cq1u/pixGir0w9hGv8AlfOzBZxIxO7Q40BneXiMuhUI5g1pEdkvQX8IakOysXg2OfUXcEbGV4cDy0qbNMpflV87QeBbfKB0IrT79QedkbsEN2KVDmlbm8SqJYA3LTmFEGOBPVGlUgBE6pQua5Ehu6tC3h
X-MS-Exchange-CrossTenant-Network-Message-Id: ca6709dc-d1f9-41da-dc88-08d86c1f789b
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2020 06:49:29.8080
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DSg+r4kR9g0m08PiIvdk+IKuf8ml8l9UebccF7nDJPe+WmrtdeXhdh9lraCjXh2m
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2245
X-OriginatorOrg: fb.com
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 1 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-09_02:2020-10-09,2020-10-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=928
 priorityscore=1501 bulkscore=0 impostorscore=0 malwarescore=0 mlxscore=0
 adultscore=0 suspectscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010090047
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/8/20 6:12 PM, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> The main purpose of the profiler test to check different llvm generation
> patterns to make sure the verifier can load these large programs.
> 
> Note that profiler.inc.h test doesn't follow strict kernel coding style.
> The code was formatted in the kernel style, but variable declarations are
> kept as-is to preserve original llvm IR pattern.
> 
> profiler1.c should pass with older and newer llvm
> 
> profiler[23].c may fail on older llvm that don't have:
> https://reviews.llvm.org/D85570

Not sure but the below equivalent URL may be more intuitive:
   https://reviews.llvm.org/D85570

> because llvm may do speculative code motion optimization that
> will generate code like this:
> 
> // r9 is a pointer to map_value
> // r7 is a scalar
> 17:       bf 96 00 00 00 00 00 00 r6 = r9
> 18:       0f 76 00 00 00 00 00 00 r6 += r7
> 19:       a5 07 01 00 01 01 00 00 if r7 < 257 goto +1
> 20:       bf 96 00 00 00 00 00 00 r6 = r9
> // r6 is used here
> 
> The verifier will reject such code with the error:
> "math between map_value pointer and register with unbounded min value is not allowed"
> At insn 18 the r7 is indeed unbounded. The later insn 19 checks the bounds and
> the insn 20 undoes map_value addition. It is currently impossible for the
> verifier to understand such speculative pointer arithmetic. Hence llvm D85570
> addresses it on the compiler side.
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Acked-by: Yonghong Song <yhs@fb.com>

