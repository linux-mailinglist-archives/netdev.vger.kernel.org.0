Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED20E1634C4
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 22:23:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbgBRVXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 16:23:38 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:39104 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726352AbgBRVXh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 16:23:37 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01ILET4V007498;
        Tue, 18 Feb 2020 13:23:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=lQxpTjAkWx89ygQ5ENRSEiHkjTEr+4y1Pulmx1o55JY=;
 b=VJ129/vlcQ3lWudmuihqTcGCdL6eU6fqOkwrv963w6zx2H0X5bJPiUIHVl/hw5nL5w+j
 Jef9ZYzZXTFc32v4j5AkjC4W0tW8BVVdfMOVUWry0ChBciw9WpPHVLqj1a0HrPGLWThd
 qjZHVUB7r2NwQdnLjJT9JQ9iZtfJ4+hCmt8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2y6fbqnuy8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 18 Feb 2020 13:23:20 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Tue, 18 Feb 2020 13:23:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n4rwQOthQfNqcHWdYlV93AvzDaDONkciv+6xtW8i5FieKh+qRxWRMB9afOSjpI2etRWPZx5u62gzBxKKIHi8Qhwu0QPZ10aZaktvjQyUVpy+yihf+83kMmzeOkysonBl+tj7N4PEbaJ1XaCk3JoHKfp0Ay4Svu8+f0om/EbyKoUdty6fZKunNsbPoEPuCaDUDbjNg98d+JA7KekznZgGpALrGhvauOQd6uZHT2b4jkiktgTkoekSgjzaRYMo4t/DohoTCL+RD1Q2LnMoRvGf++8M72QGSQ58IHu1O3YiDq48AtiDY9JwYAeAQqNEhVPkaUn+kFP6h8yHtRlrlzx6EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lQxpTjAkWx89ygQ5ENRSEiHkjTEr+4y1Pulmx1o55JY=;
 b=ZUrR19e4N/70Z6fkC6eLcVdLCgO/8wf9EMy5x64gxkPtEF9OI7Zy9EVpuka1ut4VyZ0hlhfTdyZDjDk3AFkssrkOJ7fr60tYIZ0FPLxvfoswwtsHNQx+rvQ+e8JuXwxc0gQzHRq1GBsz4SnL8cr1v38L6/40lIdUt5WbtqEeVfb5X9wcGLy4N7Q4Upg7Rgq4RnUgfN2KFGWP7FOr/woGOq6wjr5WcysP2pqm0KQtHExGM9jOdvYPVMlYjnudvkbdydU/Br97KwCd+xqoIkNMG89DAkyZDADjuG4vJx3BklUTL+l1XpltO6NnGBwmqFni9XGpRILF5ZbKjg3fQv55+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lQxpTjAkWx89ygQ5ENRSEiHkjTEr+4y1Pulmx1o55JY=;
 b=KQCUF9gJNpJ6nUNdSIEYoePkPpxacnTi3i5mtyGneEUasJTzpK/aftbP6faiT+gpYA2chlwTkAfyfAw5UaBCODNJsmTZRICdrNctz/UKquwCTfd70rp92YbQUzlWnx5MWG57A11D6J8NDvvPrloZuxRHZEXfLM0PXtWSJAYztUA=
Received: from DM6PR15MB3001.namprd15.prod.outlook.com (20.178.231.16) by
 DM6PR15MB3452.namprd15.prod.outlook.com (20.179.50.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.25; Tue, 18 Feb 2020 21:23:18 +0000
Received: from DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::294e:884:76fd:743c]) by DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::294e:884:76fd:743c%4]) with mapi id 15.20.2729.032; Tue, 18 Feb 2020
 21:23:18 +0000
Subject: Re: [PATCH v2 bpf] bpf: Do not grab the bucket spinlock by default on
 htab batch ops
To:     Brian Vazquez <brianvv@google.com>,
        Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
References: <20200218172552.215077-1-brianvv@google.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <c31be4c5-d4c7-5979-215e-de23b9ca0549@fb.com>
Date:   Tue, 18 Feb 2020 13:23:15 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
In-Reply-To: <20200218172552.215077-1-brianvv@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CO2PR04CA0160.namprd04.prod.outlook.com
 (2603:10b6:104:4::14) To DM6PR15MB3001.namprd15.prod.outlook.com
 (2603:10b6:5:13c::16)
MIME-Version: 1.0
Received: from macbook-pro-52.dhcp.thefacebook.com (2620:10d:c090:500::5:fd19) by CO2PR04CA0160.namprd04.prod.outlook.com (2603:10b6:104:4::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.23 via Frontend Transport; Tue, 18 Feb 2020 21:23:17 +0000
X-Originating-IP: [2620:10d:c090:500::5:fd19]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 53b00de9-69b9-4986-8486-08d7b4b8c5fb
X-MS-TrafficTypeDiagnostic: DM6PR15MB3452:
X-Microsoft-Antispam-PRVS: <DM6PR15MB3452C2DD363AB45A73008553D3110@DM6PR15MB3452.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-Forefront-PRVS: 031763BCAF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(366004)(39860400002)(396003)(376002)(136003)(346002)(189003)(199004)(4326008)(6486002)(316002)(6506007)(53546011)(36756003)(31686004)(19627235002)(52116002)(2906002)(110136005)(66556008)(16526019)(6512007)(186003)(66946007)(2616005)(66476007)(81166006)(478600001)(31696002)(8936002)(5660300002)(81156014)(8676002)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR15MB3452;H:DM6PR15MB3001.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NEeWPpM6nWikPxq+h42t3k//b6nPzQ7hnS8sBaehMS11e5IJhku43/E7AqkZBZ2luoBujoAx2eh1gP0PbcGnOZpB3Wi1j6YToEAhaPyU85VV4FOpR1aWLJvLnItjSavz4K1c8CRpoSc68392wZ2z1V27fAUcw/ie1JWpwEnUDiYAfKLkgNY8jNQxTGraz0oidcshrJaSAwOu1JNBCf3P9RVgfX/F5RDT5gLElP1pnv1/zEYIVJeHl+cb4gmUPuQNEb/5ixR7iLwsz0vcg852Mzs1jC0Kf7QZIW0t46dcgcQut8dAt5BywTQguD+UdEOZoERqPHFjMTczcJWIoQmU1IhBOGP5u26BJSzu2zQY4Bxq2xhfwC0xdSvf7YDOsi8fTl3jKuOGLKQpUUlO+NHiRnrzFq6Ba5QHeCwoJMFqObvJxt/h32rJ7pI5ZBeigkXx
X-MS-Exchange-AntiSpam-MessageData: Q9xAiFJkMgtxx8h9NR4M9DEXSwdHtmm3BHdeuaufDhJwLnxwoVCqcoNZLWczaurNkTDFSSBy2oy7Wz5do8rFitNG8qWbUy4WkGaHdb11Xmu0SRtFfmoveVgazWKqZEDWBKyO1p88AveVQIXjzQCZJqYiPIk9RXyY/ShYOCu0bvbil5RdK3inDE6e5dlF0LK0
X-MS-Exchange-CrossTenant-Network-Message-Id: 53b00de9-69b9-4986-8486-08d7b4b8c5fb
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2020 21:23:18.6610
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eeok71UK0k3HjTwpUSOtjGZtBcGuMal/jTSSqNRT/v7dXGl6/v31i6tQT6CAPuFv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3452
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-18_07:2020-02-18,2020-02-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 clxscore=1015 impostorscore=0 lowpriorityscore=0 priorityscore=1501
 mlxscore=0 bulkscore=0 malwarescore=0 phishscore=0 mlxlogscore=961
 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002180139
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/18/20 9:25 AM, Brian Vazquez wrote:
> Grabbing the spinlock for every bucket even if it's empty, was causing
> significant perfomance cost when traversing htab maps that have only a
> few entries. This patch addresses the issue by checking first the
> bucket_cnt, if the bucket has some entries then we go and grab the
> spinlock and proceed with the batching.
> 
> Tested with a htab of size 50K and different value of populated entries.
> 
> Before:
>    Benchmark             Time(ns)        CPU(ns)
>    ---------------------------------------------
>    BM_DumpHashMap/1       2759655        2752033
>    BM_DumpHashMap/10      2933722        2930825
>    BM_DumpHashMap/200     3171680        3170265
>    BM_DumpHashMap/500     3639607        3635511
>    BM_DumpHashMap/1000    4369008        4364981
>    BM_DumpHashMap/5k     11171919       11134028
>    BM_DumpHashMap/20k    69150080       69033496
>    BM_DumpHashMap/39k   190501036      190226162
> 
> After:
>    Benchmark             Time(ns)        CPU(ns)
>    ---------------------------------------------
>    BM_DumpHashMap/1        202707         200109
>    BM_DumpHashMap/10       213441         210569
>    BM_DumpHashMap/200      478641         472350
>    BM_DumpHashMap/500      980061         967102
>    BM_DumpHashMap/1000    1863835        1839575
>    BM_DumpHashMap/5k      8961836        8902540
>    BM_DumpHashMap/20k    69761497       69322756
>    BM_DumpHashMap/39k   187437830      186551111
> 
> Fixes: 057996380a42 ("bpf: Add batch ops to all htab bpf map")
> Cc: Yonghong Song <yhs@fb.com>
> Signed-off-by: Brian Vazquez <brianvv@google.com>

Thanks for the fix.
Acked-by: Yonghong Song <yhs@fb.com>

> ---
> v1 -> v2: Skip hlist_nulls_for_each_entry_safe if lock is not held
> 
>   kernel/bpf/hashtab.c | 22 +++++++++++++++++++++-
>   1 file changed, 21 insertions(+), 1 deletion(-)
