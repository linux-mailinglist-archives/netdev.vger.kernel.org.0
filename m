Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83CFA1CB514
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 18:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbgEHQk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 12:40:27 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:15154 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726756AbgEHQk1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 12:40:27 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 048GZDI9015912;
        Fri, 8 May 2020 09:40:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=d03mzLlKLoTVN7Evo0ynYcZtc0N0we8cDt78RbF8sq0=;
 b=A+wNaFl8jX5U//lVTvIcgzH39r/plDVI8FaShrMvzzZdGbp/Yn4t6S9d1YjN8m8u7SXX
 SO6fPeWmAVMdRIMPzb+npC4ckwDDBvTLBn4qcBskWIv0hLJv6F1h6gYathl3pk42JYh9
 9bsvQUA7tbvOKdh+9/0OmehjAhSmmPURvYc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 30vtd0ck66-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 08 May 2020 09:40:15 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 8 May 2020 09:40:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b+4OgiIoTFkbPx00tcMGtcgjj6XNtRQ08aMeKV/0JW4BAAyDqOgnfogEnU4o3SHoX8lY+CXoG08zDf9okgQ5MyKEyDno5yAVLUdVggprdRZYfSvv1MBCtWg8+DSf89Mnvn7kRIYMjh46ZWee7S0EyO+p9tR9DkFU4Cul3pge4eyoJ5weks19EgCjqBASbbmkT2B1QwEgEFjiaJGo1i+BMKf2nvfCZzVtUM1bYG3AaO/lJc1mm1bOiMf+h9CmmF0OBop5b/oHO7uDEJz7NzezPWEIdCYX4cNmDbrBPO7hFNyRMYtH20+ZTRSGq0ELxhVX2oKebZ6iL/tI7eHuJoSesA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d03mzLlKLoTVN7Evo0ynYcZtc0N0we8cDt78RbF8sq0=;
 b=TbvftL3qVAd4LEfGBXmrQ5Ek5OJKqgYS66SODFRj4OXI6jb3oq0E0rCiQaA/BU9d+4TnWylBN6H39YI5P1yciIlcmUyjWdKrqnQ7xRJhK/vZi9BBFVUhEeIO2iGskYvNgRWzLoh2t9Z+hhDbnp83Y6HzUGjjDXP6E8xj1vSJE6n8mZXUvDCUQ7H8SD9xJBqmE3xrbCTD9drUUFuRfJxUbzF3XWC5LIrsu2N8MHI2quR89foNSpsefxhZrYcq2i0KGIyuf3qMRX+8h0L906iy6xl1Z85zlO3P40BBpHmcuevmAYx+eyinOBmbe+MRRwwEqNlCWFe9rmsNgHWgK9V3Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d03mzLlKLoTVN7Evo0ynYcZtc0N0we8cDt78RbF8sq0=;
 b=C1s/l1inAjc51ylhWeYbET28pN84xh35pmD/St4LwuNuwSm4flNZQV38Fp+FxEtoGb1pAHGthFEAymYxr7ltOzpNkHvjzr/zCZ0fIxE/UwKOsFEWaogTPO2+AB87SXROYc6+cUHS7B066X1XX6yMV38DxdFvTk0hfPTl2PjYRk8=
Received: from MW3PR15MB3772.namprd15.prod.outlook.com (2603:10b6:303:4c::14)
 by MW3PR15MB3852.namprd15.prod.outlook.com (2603:10b6:303:45::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.27; Fri, 8 May
 2020 16:40:13 +0000
Received: from MW3PR15MB3772.namprd15.prod.outlook.com
 ([fe80::3032:6927:d600:772a]) by MW3PR15MB3772.namprd15.prod.outlook.com
 ([fe80::3032:6927:d600:772a%8]) with mapi id 15.20.2958.034; Fri, 8 May 2020
 16:40:13 +0000
Subject: Re: [PATCH bpf-next 3/3] selftest/bpf: add BPF triggring benchmark
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>
References: <20200508070548.2358701-1-andriin@fb.com>
 <20200508070548.2358701-4-andriin@fb.com>
From:   Alexei Starovoitov <ast@fb.com>
Message-ID: <35e656a9-91d1-203d-44d4-ea5f002ad232@fb.com>
Date:   Fri, 8 May 2020 09:40:10 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <20200508070548.2358701-4-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR11CA0056.namprd11.prod.outlook.com
 (2603:10b6:a03:80::33) To MW3PR15MB3772.namprd15.prod.outlook.com
 (2603:10b6:303:4c::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e1::13cf] (2620:10d:c090:400::5:d7c7) by BYAPR11CA0056.namprd11.prod.outlook.com (2603:10b6:a03:80::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26 via Frontend Transport; Fri, 8 May 2020 16:40:11 +0000
X-Originating-IP: [2620:10d:c090:400::5:d7c7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c4686b81-a820-4420-8440-08d7f36e7aee
X-MS-TrafficTypeDiagnostic: MW3PR15MB3852:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB38520FB21A0060B8CDF1A256D7A20@MW3PR15MB3852.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:254;
X-Forefront-PRVS: 039735BC4E
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iDUvq6JfAo5+iNO2u9zGjHwrZDhZAEjCkYaoYX66TvFhE/aKSUpZqEJQCgZlvBraPsU/3GPYNNoS6vsLA4oGYZQHoPtCBwvvKzZuvc8oqKGx6plD7wLWQLWNcdeCgj5+xviIifKajxXYr5/ikj6kHSc5yZBWGol5HVucWVUFbizb51ZKJByew7mgM0XMbQsCXSbEeSJABPdsTdUqC+XHrQQS9A3bRJO35iRSpys7211oEiOA5dKHdFAqc6+OKaIxsn9a+x+V+0n55Kcq2JY8q+ZwPJytovmwpPLYZTGc6c8dGetqydklgf0StD1Q0x8kSSNdRiS6/gZM6KXbMZEwrxZxVSPYogrJchpdiyn2n5wt5jNJW5XQLHFtDmgMfk6sqzyDsp+u7v6Yedw/+L0HvRiX/i6+4cJ5GlZLXIqrZbW5WpOL+rkVrXQTbKPKhuURlW6MPlnVgaX+5aB3+1nnWN6sAJDQYUBDerRqq2l4Uw11RZTAAmHCpfs1LbJcwfMI7Mf0LgVY3ksyCiKzIu078+7Sm/uRsG82AErFhqp2GYwXjsP4vXYObNBY3d+/243j
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB3772.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(346002)(396003)(366004)(136003)(39860400002)(33430700001)(6486002)(8676002)(52116002)(66556008)(53546011)(5660300002)(186003)(16526019)(4326008)(66476007)(66946007)(31686004)(4744005)(8936002)(316002)(31696002)(83280400001)(33440700001)(2906002)(2616005)(83310400001)(83300400001)(478600001)(83290400001)(83320400001)(36756003)(86362001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: tCM9XrnDsNfX9QNq46V2ObWTb6iWYBxvDAF9QZ6y+g12mvo9GyXKvzw8h6RxhD399a4UOUElKSbeF4CMgkFHZkhM0CemFODfbwEXP7oUAYc6Q+NEIo6FPC4aooiaYsLzwn6s+BjnUPJUsk6AB4EvpxwkY1bczVJDjQtAeTmw9WqFEtL8tRA5YNYJSxHZq95CQ3G49qtd4aB4iK/GwGsK4GD17XUNQjCXYbTT2e034Bxo8outuUsnzIrcZ5AFxOXwJBGQGmjb/8xRuE+RyCGMbRHQQICMP5VfXygdzl7JXdp/CS1qSr1Gpm1zQ/0D/z4fL7ZDNyJBrkfXN3eZVjVkiHpqqDehweyxSvYA3teK6PUiJ73Fo2ocVKTLalCyefS9Pl+1jnzb0SqUoX8g6M+lLXZOeWqM5PA8/nYFFqvO2xcXKcvcCTbVIhVzbXsVE26SOpKzbv9M1+fJOjIhpf37A81fop4tBUXCINsEadG5njP6rcFTDs0tYT/LqpSyvUCZdDkGIQBQY2WmhiS/8BrjDw==
X-MS-Exchange-CrossTenant-Network-Message-Id: c4686b81-a820-4420-8440-08d7f36e7aee
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2020 16:40:13.2838
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sYt7fuzedQmlOuX5YTziSSa+CdbNFTBUjjX2gFRcunh1SZJ67G2XBrQPxKQJGuOZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3852
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-08_15:2020-05-08,2020-05-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 mlxscore=0 suspectscore=0 malwarescore=0 spamscore=0 priorityscore=1501
 phishscore=0 mlxlogscore=930 adultscore=0 bulkscore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005080142
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/8/20 12:05 AM, Andrii Nakryiko wrote:
> 
> base      :    9.200 ± 0.319M/s
> fentry    :    8.955 ± 0.241M/s

> +SEC("fentry/__x64_sys_getpgid")
> +int bench_trigger_fentry(void *ctx)
> +{
> +	__sync_add_and_fetch(&hits, 1);
> +	return 0;
> +}

adding 'lock xadd' is not cheap.
I wonder how much of the delta come from it and from the rest of
trampoline.
