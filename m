Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 203CC429B71
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 04:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231560AbhJLCXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 22:23:02 -0400
Received: from mail-eopbgr1310103.outbound.protection.outlook.com ([40.107.131.103]:29033
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229556AbhJLCXB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Oct 2021 22:23:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T6IES+u5LmlN6kiOu7xK6/nucXC33lybYwZJoXYeS18GZai6Kp7pZVkGVmRoevECIb78GJ6yyRJowuazLecC5GbPDut97rUmZfR7DHTcGqPj13aw3/mvF61k4RQa4nsVX4E5GKg0/tRbTN75patcLOBNo2FECdZyy+OHcH/fVMNBBdyLtob9EBK3DRmg3/h+M1iYXvin29kV+EEyvBDwarT1ALNfCTSWBvxd87AUaqgZ4OCqwKGPDE/w/uvJ4wR+SQ+OmQvkhZ5UtF1TSndbdWp26R72ZsDC0hHWHYugXOQLJMMsIrjePwgFOzOxNRMBEBlSsKUieop511jXhrO0pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=91NhZmWK+3m64NOKvqD+0y+a0s99p/pvvcstekZcf7s=;
 b=etKn/0HscorTjAbc/tZWhVt6xtr/XIi1xIi04ejfICNJcUDqtGOOvEBfd1ASIhhUbyIX2YPbZdukhcBL+yeH7uFKxY0918TJVNmnWtzgUbaTkNrjhGtdSlUS8tI+n2FoQj3RxvMNTsQLuWesA5CvLQHymzg4SFGXITqF0yED1iN7Kf2tz2eKV5Xz1bGr0uJG4NqWeAmzYTsHJoDGluVLZ8uvoWx0UGomoqVMmhRGwFHUfK2H5iw9L7LXmJJvPyOP6J4WEJLCGs3SMSGKeqHtp+zPeff0WBggSJMWffboYpLw4+lfppI5d4rpyTtnbCvWIcrByz7b8GoDSTi6AB3cXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=91NhZmWK+3m64NOKvqD+0y+a0s99p/pvvcstekZcf7s=;
 b=EPVg/6/mszZb+0zJM+8y0c9XLJiaiIXJdK51e1HycKu5xP/yRRs+Bvy4XEoTByaCNYsz/9YmUDFdIZoftcPKTXpu6MlWcsYqcz72e4TWDevWszChsvJMzvGt/LcrJ1ARv4rii25kzlwoNCFXWH1F/0gLmmY8VX9zEuKebB8TuA8=
Authentication-Results: yeah.net; dkim=none (message not signed)
 header.d=none;yeah.net; dmarc=none action=none header.from=vivo.com;
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com (2603:1096:4:78::19) by
 SG2PR06MB3192.apcprd06.prod.outlook.com (2603:1096:4:71::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.25; Tue, 12 Oct 2021 02:20:48 +0000
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::fc12:4e1b:cc77:6c0]) by SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::fc12:4e1b:cc77:6c0%6]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 02:20:47 +0000
Subject: Re: [PATCH] selftests: bpf: Remove duplicated include in
 cgroup_helpers
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Wan Jiabing <wanjiabing@vivo.com>,
        Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kael_w@yeah.net
References: <20211011111948.19301-1-wanjiabing@vivo.com>
 <ALUAmAB4EgbN1cS90y4NDarn.9.1633962609302.Hmail.wanjiabing@vivo.com>
From:   Jiabing Wan <11126903@vivo.com>
Message-ID: <2defbe3c-c26f-012d-8b98-115da74bf752@vivo.com>
Date:   Tue, 12 Oct 2021 10:20:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <ALUAmAB4EgbN1cS90y4NDarn.9.1633962609302.Hmail.wanjiabing@vivo.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: HK2PR06CA0005.apcprd06.prod.outlook.com
 (2603:1096:202:2e::17) To SG2PR06MB3367.apcprd06.prod.outlook.com
 (2603:1096:4:78::19)
MIME-Version: 1.0
Received: from [172.22.218.43] (218.213.202.190) by HK2PR06CA0005.apcprd06.prod.outlook.com (2603:1096:202:2e::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18 via Frontend Transport; Tue, 12 Oct 2021 02:20:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 85ce3950-a9ae-4a02-e8bf-08d98d26e6da
X-MS-TrafficTypeDiagnostic: SG2PR06MB3192:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SG2PR06MB3192D80A63B30C18D1E98732ABB69@SG2PR06MB3192.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:747;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2Y/BwIotVnfSGAte+W/pKQsb+5BPsidFxnB6vp5oewWfzbTax5pdinML71jU3G59BgnQAbVZUUJEVLAxOI1nXscO78p/thgAiQ7HzN4EjD1dA8jDhoHELFhIv3aD7lKcJQN3PctWn4tfK/lyWN+Ohk/jxBtHKXX+6joFLW8bOCQwO5dXKOalDfaV7bwYn/Db1+FOXrUJVJcYl6eNy0eRlbogHv198y8IIz36jaAYEHeU9pQvJ3mfBJMe2yOkxZOwp6ffixqQMAfJKihICvwSlu1gdns5vqPFonGbWmt3wAAjummlheTNT5PLeVL5BkrT0tKFWy0BD2RjnyjYaMOgd6Rrpv0gBzLege/jjyh4tyMWbth2gsmE95BYCsc9r5lJzrp9T4s5ew+dGOLzfdjOvwiMcK6PRw4p9sh9GrYd9QvWBLZCHFAtRIGZ4rKk16GDuPdQ5ckuwHpRvMszGztzezKi+n0lcN15IIlKzFoinJ+XbKT5LAT2jHkLrpzY0W/7f+uHXn7vViq6oj9Xj700cOx9qhH0AAEUeikf+eYr7DxginURecilr6dA7RyZU1mFo2bB4fTjFWW6ha+js8Xzlu1atF3PWi3ZZrQdtoeUXpTUp6NcO7Sym7dZlcsOa8Eh7bNqJdKqHsK5Ddwmvq2MLgSwAXIlW14M3eJUiVFa3u2WqbDXV2egStRWBqMDQoq1q7l3T44g3JS7fk3U1cZp0cx1EKcRyyyUDDfbpbjryIAvIjaD8507C6Dqec4sFXo4kg8m5UT2ASbaHea9S0B8pnjxpTP8NPGPuyxD/db+dmFUqstFzPRlPxHSMDMYIe1y
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SG2PR06MB3367.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(2616005)(4326008)(7416002)(316002)(52116002)(8676002)(8936002)(66946007)(16576012)(110136005)(921005)(956004)(26005)(66556008)(38350700002)(38100700002)(508600001)(66476007)(31696002)(6486002)(53546011)(2906002)(83380400001)(31686004)(36756003)(186003)(81742002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?Windows-1252?Q?+l1PgUtDdj41pfbTGUyavXsZw7Vyb27Xjm8Oq4GKEDmVfh9+2Lki1r99?=
 =?Windows-1252?Q?NgjZfAc59gQ0qjUaLPFy8OfxjzACtE1XxHvq1JIdPnCjTr1d74CWCS8A?=
 =?Windows-1252?Q?70rBFrHWU9qWbOCT1IROTm2hJBoh9VwbpDvWQR+EFpU/2wHwayWiJ2vb?=
 =?Windows-1252?Q?euYrOn/pjh3keyr+UbqLG1UdLxYbPYyh/7dto82yC9Y+jfB+H5pCVwX3?=
 =?Windows-1252?Q?Wy8PlJRhru8OmvazdeAWZd4NHT/NRrDUPXN/XT/5Bol3ImhcmlSRr0SP?=
 =?Windows-1252?Q?0tv6wPQEb5E0izQsFm4GBzH/zUzAGePXLaebf4kB1LgISkgqCiDqpoJg?=
 =?Windows-1252?Q?hDM804Picra7GGEHG2pDDqmOIqiKEtdSnhCGUTAZhpr9UP4gCWbjq8sv?=
 =?Windows-1252?Q?pnEwzbfLIWjZyBKIsE/lKcIk0OTCgr+kDAXqF7i+Ja90xcW2sbalWoUA?=
 =?Windows-1252?Q?9CrMwqhF3meEah8n3oFfVJKR5iMSDlj0hWbZPYxZFZYf/IU2RqcYz7XB?=
 =?Windows-1252?Q?mwUPBIzamrHAToMojH8D2cg7FDJYDL0a0TOIz/DC2u4qlKJ9HbI5NnTJ?=
 =?Windows-1252?Q?UiZWkL41LMmQW8QW7cUmL1WdXi1bL6r+7mrLw74DXMUpfmaA+cxzZChi?=
 =?Windows-1252?Q?hUFErxciYA1VtI5h+uAp/OXuOraVkI4krfzL8Uw6BbwIEuxKQoZYxaaA?=
 =?Windows-1252?Q?G/1hVxBoFspx7MW9bS3iHizxSGbLpS7u/zTUu33IaDysglAxpxV7M1qN?=
 =?Windows-1252?Q?rqodIuitGh2uMZ+SIr4NmICqje+mqkWcas27z1hHnSCA/aSzoqWgByws?=
 =?Windows-1252?Q?6K/u0kBsoi0ltOkewx0SgQeqhS6VK9scO/Olch4wOSXrOo66Vz9sLT+J?=
 =?Windows-1252?Q?BnTL4exwtrfiGUH+lqBbK/K6LbloFFegc6Y4sRAwIVGju0TvYF+mqVls?=
 =?Windows-1252?Q?kCg4Buoch8zt/9PhtSh9S3qlQ1TC8zvvaheHdxe7qh4w+nZm3xEDnHSp?=
 =?Windows-1252?Q?ykLLp0Mr0BUkaKaYdzYWI5OBl61RFyPO923pMmVa+HF8HOSwnBZuDiLo?=
 =?Windows-1252?Q?JIAesiBRhbqv0hEjTdaLFZ3rPq82uCUm/dgs4dcG5WcCrJh9B7kqT8El?=
 =?Windows-1252?Q?URK60y61l7pAm0FbJrKNKrypY1yaTgPxlZHATQxQ8ROBzMGCpKk7Y7W/?=
 =?Windows-1252?Q?e3iQEPWjscPuobGOI6gWjyQD7Cp6FB5armi2t9h/X5PDcWPvPC7MBF2H?=
 =?Windows-1252?Q?ks38Bp9BDlC9XUMQvaga3VWyCQBI20KvbcrcggWE2DELM9bjo2b/5LXo?=
 =?Windows-1252?Q?/Wu2XTSDluvp7hfNo5Ajql2ZwACb2p9eH0Uppktwnxk7jptHP7vdR3IF?=
 =?Windows-1252?Q?wiwIaBCkfUiLrkwkVPx2rKIMjgXHa3ag6M3bgCkuAY5NVLeEKzCluTBH?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85ce3950-a9ae-4a02-e8bf-08d98d26e6da
X-MS-Exchange-CrossTenant-AuthSource: SG2PR06MB3367.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 02:20:47.3574
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cQ7jnQaZoZqs/RjtMU3yHfhJvvKjJFR4vASskJRfLLnuedr386EftnEPnysRTh6OgiDNmKyyp0YQ4Wk3EKCeuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2PR06MB3192
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/10/11 22:30, Daniel Borkmann wrote:
> On 10/11/21 1:19 PM, Wan Jiabing wrote:
>> Fix following checkincludes.pl warning:
>> ./tools/testing/selftests/bpf/cgroup_helpers.c
>> 12    #include <unistd.h>
>>      14    #include <unistd.h>
>
> What does the 12 vs 14 mean here? Please provide a proper commit 
> description, e.g. if
> you used checkincludes.pl, maybe include the full command invocation 
> and the relevant
> output, so that this is more obvious and in a better shape. Thanks!

Sorry for my fuzzy description. 12 and 14 mean the line of includes file.
The script checkincludes.pl can only show which file is included 
duplicated, like

./scripts/checkincludes.pl tools/testing/selftests/bpf/cgroup_helpers.c
tools/testing/selftests/bpf/cgroup_helpers.c: unistd.h is included more 
than once.

So I upgrade the script so it can tell me the position of the duplicated 
includes.

I'll fix the description in v2.

>> Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
>> ---
>>   tools/testing/selftests/bpf/cgroup_helpers.c | 1 -
>>   1 file changed, 1 deletion(-)
>>
>> diff --git a/tools/testing/selftests/bpf/cgroup_helpers.c 
>> b/tools/testing/selftests/bpf/cgroup_helpers.c
>> index 8fcd44841bb2..9d59c3990ca8 100644
>> --- a/tools/testing/selftests/bpf/cgroup_helpers.c
>> +++ b/tools/testing/selftests/bpf/cgroup_helpers.c
>> @@ -11,7 +11,6 @@
>>   #include <fcntl.h>
>>   #include <unistd.h>
>>   #include <ftw.h>
>> -#include <unistd.h>
>>     #include "cgroup_helpers.h"
>>
>

