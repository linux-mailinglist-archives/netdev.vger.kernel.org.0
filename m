Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 623C7257F1C
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 18:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728653AbgHaQ52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 12:57:28 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:10710 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727929AbgHaQ51 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 12:57:27 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07VGqfBi024054;
        Mon, 31 Aug 2020 09:57:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=tNqDRCJGf0XDS0YiEPS+gpk6FaJxNCEagxp/hrU7tPY=;
 b=GFqA1gSaUSQw6DAHE2AeS9Mi0CAnjSF2BlQEARyyJ2uMpIe4vF45UD/QTa8fH2roNwru
 bCPIGIfkxLeUJ73DJ3nXxzM1KltENjgXK/m5W2FBQkFkpwUNYN1MKc7kBi3hSgYCGsa4
 3UrerpsvGDSfnCxz5abS/o8MrTJECewOA98= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 338734dp04-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 31 Aug 2020 09:57:07 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 31 Aug 2020 09:57:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OtIOJ4uafrL/3/yutIsJmnLfWrUxhUtTAgziqmKnUFwGoksv5FJMbn1e6A9Z/pNIWd97Fw9c2NziVqXugg55sz+tlf9erOs01NSQ/fkKxBorZpOIMUGKnRD1IVPd/mLqcvIhdtdXJRqT5coTwM82pHqx79FOH2vy/+7F/et68s+fY0xnrI2gfHcXKQfdBppy8EmZgdgDrwmnVsaE5m3F06DhwiHgCz5Plr87QIjo4WrnmGXAOMj6uSQAuHrL8MGnQbnCYJTyutsC+um1t74+mfVO3cNykdW/RhVr+xGVGO1RnFOR41vP9cR58OZs+2GpumFAIl7XibJbB1Dawoga/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tNqDRCJGf0XDS0YiEPS+gpk6FaJxNCEagxp/hrU7tPY=;
 b=jO0E6veMCJxRmqQdaiM2ALtDFoS022VsDTgDspvqB32IRzVxYqoAANG0vPpVE6QRheNmE+qgF9g0eEbswLxNXVgm3rbefpM5Xeevtyh6xhrYx8PCtsDScT5EakRZYOMaNJ4ii0G0YE0KzC6mCgmE0JonGbBWwNJRd20AzzPEQZ7SNHVh9o2hPqBanJTTNQ6pOEr7S6qkJBvNa1KVPzdZUkvO6hCn+QhY3NoldohgkxnWK7huf4Cj4AhdPw2FG/HgFHHAKNQ5odHZTYaC/pKD2VB/sskxR1vMSdOFk+hjSNa2A6FcvVm9KaKeE2ib4rhEwKT19RB6LWUDjctOVTXuEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tNqDRCJGf0XDS0YiEPS+gpk6FaJxNCEagxp/hrU7tPY=;
 b=CQ4sl4XnlIWZQyx8rikx8212xCFtpGsdTv3IjzkypXmoQDEMHMQYmxJOUh4ye8jKBV62dQyuwkyBE7VWwBJYiD9JLIgcL3px4f3nBKvDHPv4Bn2UHP7+veFntvGLcAQR1AcwwCKPUo4gbbAie/7TX4+lIv/3P7+EhfAX4pB/R4U=
Received: from MW3PR15MB3772.namprd15.prod.outlook.com (2603:10b6:303:4c::14)
 by MW2PR1501MB2156.namprd15.prod.outlook.com (2603:10b6:302:d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.25; Mon, 31 Aug
 2020 16:57:02 +0000
Received: from MW3PR15MB3772.namprd15.prod.outlook.com
 ([fe80::6db3:9f8b:6fd6:9446]) by MW3PR15MB3772.namprd15.prod.outlook.com
 ([fe80::6db3:9f8b:6fd6:9446%3]) with mapi id 15.20.3326.025; Mon, 31 Aug 2020
 16:57:02 +0000
Subject: Re: [PATCH v3 bpf-next 5/5] selftests/bpf: Add sleepable tests
To:     Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <josef@toxicpanda.com>,
        <bpoirier@suse.com>, <akpm@linux-foundation.org>,
        <hannes@cmpxchg.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
References: <20200827220114.69225-1-alexei.starovoitov@gmail.com>
 <20200827220114.69225-6-alexei.starovoitov@gmail.com>
 <00667ff9-1f1d-068b-4f5d-4a90385437b1@fb.com>
 <6ffb1b52-51a0-3faa-04d8-77a9e54d03a9@fb.com>
 <d6528f9e-088b-725d-273e-a4f1d8a38f11@fb.com>
From:   Alexei Starovoitov <ast@fb.com>
Message-ID: <2b52935f-1592-0720-1a0e-71c97e42a7d8@fb.com>
Date:   Mon, 31 Aug 2020 09:56:59 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <d6528f9e-088b-725d-273e-a4f1d8a38f11@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR05CA0012.namprd05.prod.outlook.com
 (2603:10b6:a03:254::17) To MW3PR15MB3772.namprd15.prod.outlook.com
 (2603:10b6:303:4c::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by BY3PR05CA0012.namprd05.prod.outlook.com (2603:10b6:a03:254::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.7 via Frontend Transport; Mon, 31 Aug 2020 16:57:01 +0000
X-Originating-IP: [2620:10d:c090:400::5:4d4f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9e11e91f-6d4e-46ef-dc72-08d84dcee1c9
X-MS-TrafficTypeDiagnostic: MW2PR1501MB2156:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW2PR1501MB215655027F8B797CF98F7A89D7510@MW2PR1501MB2156.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7PTewXtb7BsnusosLVV/St5Bkv5/lEFD6TJBDhCmr2h/7zELQ75hgn+H63bif4XiEkLaoBw7PVUyIcvoF8+fKr8bUb7aSQ8mufWUNVBjqhHUEcwL9OKAYRua4lFeRH6ZvFK2SJUvMHlIe3+G59ImQrluWuTbqxLYauHseD5HrSLhJ56NwGP4mE15R76Svhar79Og9ESyDL4RfSA/X1Ou+BdbQYxmirFnbwVpUrDczlMPmAvEwyTYpyNIyHxjZzhnoL0F10Khz4zMqVqPB8lGOS8LcqZoiUWfJECoyyq7TrWIcJElRPtoHWo0Uv2wxg0jekaBz/Bs3J/9ICWJUZypJh1kHv3aHlKzMtDmolM72mv5o6Qc2H8Z1R4s/Pn/Dwuu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB3772.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(39860400002)(346002)(366004)(136003)(66556008)(66476007)(110136005)(66946007)(956004)(2616005)(186003)(16576012)(478600001)(83380400001)(31696002)(8936002)(316002)(4744005)(8676002)(53546011)(86362001)(6486002)(31686004)(4326008)(52116002)(5660300002)(2906002)(36756003)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: KWkMBp00R7q77ZuoL1C0DwJrM7ztEQfPSNCWU30UhK+w8GULqsRDw2YfuU1dlxeJvNx15nFeSaPYaqH2jgyzr7k46bQGNoX34PdLDEXNzqHW25rmzmxtvLHk9bsUGe+FgE8vTPmCY5oCvFPfydrk1b6aYREdpJHgsKfEAEqm/DmloSuYslC+wNWE9xTtW855vDoClNv2ae4ALD6Wc8zyo2abvBtE3aOT6vd9FnQ3AQSrwc22gSGeleiwdZ1jZZVy02PaFio3OJe0+BnBaRH1KFgi1zzXVMnj6b3HOqtjORAqgwbY7/mQ2dcoxMWKfpcae7+bFfOJF11zhiixaBrGUkHAZLwsxquSLtvtBatext+Z252BCvNR6jhM54ozusE52Yq2U4cKliuODC58d5VFy3X7UnL14PCuJ+ASEIdVnV/o65XN7jntFxeRwp5YP3CTS5wUTSDZ9shbE1kcWDHKAp6VKw/ueOfKofm+XMG/9D0RJT4ccvL4QkGGtDzzCtBDx+Krr23BuPyoGodLZ4xdAkab5jHRtLclbINonoTlKMHevWMoHKBIbehouQQI/YRm1tNChN0z0QM1Qg4r6iydQREMalOW/2wGUhyeeUsj4erRpyUom8PMJTvBPVDWqE1D0JlDA+pwjR96cXi+yi0naaUdi/Y2uoVwNpImxaUU2h0=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e11e91f-6d4e-46ef-dc72-08d84dcee1c9
X-MS-Exchange-CrossTenant-AuthSource: MW3PR15MB3772.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2020 16:57:02.2118
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BaStuWWNhzhnEiRJarSWQy9gZnICbXUmB59pwRr3sc/Um3JtWzvB+3/DBmgOXYzM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR1501MB2156
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-31_08:2020-08-31,2020-08-31 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 suspectscore=0 impostorscore=0 lowpriorityscore=0 phishscore=0 mlxscore=0
 malwarescore=0 bulkscore=0 mlxlogscore=840 priorityscore=1501 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008310101
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/29/20 5:22 PM, Yonghong Song wrote:
>> LOCKDEP=y
>> DEBUG_ATOMIC_SLEEP=y
>> LOCK_DEBUGGING_SUPPORT=y
>> KASAN=y
>> in my .config and don't see it :(
>> Could pls send me your .config?
> 
> The config file is attached. In my environment, the warning is only
> printed out during the first run of `./test_progs -t lsm`. All later
> runs did not have this warning.

Thanks. Turned out LOCKDEP=y and DEBUG_ATOMIC_SLEEP=y wasn't enough.
My config was missing PROVE_LOCKING=y.
