Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BBCA2F901E
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 03:05:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727942AbhAQCFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 21:05:17 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:30458 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727796AbhAQCFN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jan 2021 21:05:13 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10H23Wu8008171;
        Sat, 16 Jan 2021 18:03:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=I76mxI+hI/siQ1+BgnzXVRd9Cj6WcCu5t8Mj1PltLt8=;
 b=DbkfJb19ZUOlXMkKgTb4we7O/7B4AMEzMfYImyCGzNWUdfUI9NLm6ehYdzXc9KWn5l3e
 rKNoG5MKdg9qpGUGPIMm9unDGPoAPWFvBEdF+Qj0CQErRclNe19LPv1pgCHRSkfmzPxu
 IYmAu5bA88q6q9kmFQj4ny9Rkayj4KNCUrc= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 363xunhv26-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 16 Jan 2021 18:03:43 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sat, 16 Jan 2021 18:03:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZZj24UDjs5iTLVNXySKBoUWM9i8bKXv9yIc5IBa+4cOxgwi2TNLvpDtO6IlkRCoGP2camKM6o0yeJ2UdtAJDIZWGjOuOKPrqezV2IxZ0HyUzRaILip4aNKkMvZ/VN1rS5jGKw4bTqq34D2y06Ds+7QcT3N51f8NYdJxz5EMnEQA+YdTtTXHWEad8eBbSeIhG31gLCG0XqNRnAhEQ9BnyJHwI5vypA/0RaWwe2E0Gjk0Hue8KTkWTD59iABEnCt/r6lnxOhWUBDPUPlm7J1B2FS/RYNS6XVxpGoRsQIXa2ZI6Q71jHZYcEJk7n3EphkCyd0guUy6ZdS+62pAIbQyiHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I76mxI+hI/siQ1+BgnzXVRd9Cj6WcCu5t8Mj1PltLt8=;
 b=hUGfoNTFC1QVKVkmHiTVKG1U+xsZEucp3AwS35LmgWOXJrQFCWiUpL5Kyw9qwSPEqiNVYe/MhVOKUtyksXvC2LCswFugLBN0A13p+cL7mbutPD5vIkKxXVqbruplOS1u70MykY/R7F5WTlAcYYRGscNy6md3ZUN4EF0SvA41Wr4ofOdcvmFMzhqdoaT59WhCTdKA/3ruGEtDiogw5d2WhWUi1Cq1FQRYYNUy0CeHTQ1md4teh0TZh8nr2YN6/lWTQa7/Tm6alsMACMNvfdEc2bqflrGGk1kqvJu0xQZHgwEWjuG/0D4/uZyuBbhSGsa0M4X3m/yR0KX1Fvj6ftrLkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I76mxI+hI/siQ1+BgnzXVRd9Cj6WcCu5t8Mj1PltLt8=;
 b=N06f8I1yNXZ4UlNxiTcullyRRrEpZjnlBDo+GtRjRE82Hhj+uiXAAkXVBZrbVSnu6Qh7WJEuaUnB5p32W6aMMz1p6daHEzmtv9L+bfJN8UORzZbScPIJfUEr1XLRQLCzofkw2NnzkY1VGX1xbREjQsb4SVzcGgwNen5zKDoXE4w=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BY5PR15MB3714.namprd15.prod.outlook.com (2603:10b6:a03:1f7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.14; Sun, 17 Jan
 2021 02:03:40 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3763.014; Sun, 17 Jan 2021
 02:03:40 +0000
Subject: Re: [PATCH v2 bpf-next 1/2] trace: bpf: Allow bpf to attach to bare
 tracepoints
To:     Qais Yousef <qais.yousef@arm.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        <linux-kernel@vger.kernel.org>
References: <20210116182133.2286884-1-qais.yousef@arm.com>
 <20210116182133.2286884-2-qais.yousef@arm.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <2e63b638-1500-c323-0fec-1aecfef5f033@fb.com>
Date:   Sat, 16 Jan 2021 18:03:37 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
In-Reply-To: <20210116182133.2286884-2-qais.yousef@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:a571]
X-ClientProxiedBy: CO2PR04CA0135.namprd04.prod.outlook.com (2603:10b6:104::13)
 To BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::1366] (2620:10d:c090:400::5:a571) by CO2PR04CA0135.namprd04.prod.outlook.com (2603:10b6:104::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11 via Frontend Transport; Sun, 17 Jan 2021 02:03:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b5a6c00a-aa24-4f8c-418e-08d8ba8c1bd8
X-MS-TrafficTypeDiagnostic: BY5PR15MB3714:
X-Microsoft-Antispam-PRVS: <BY5PR15MB37140154A308E20C32655736D3A50@BY5PR15MB3714.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LI5M9I3PoZ5Clcm93D2qeGj/7mVIsCKn+W3s5zFr7PH9WfsqsGrkN7beQCrFPnAYLUyeem7eq1+kmPArbauW2fpqaNrOjr8NJcCThbdP+Vs6YdRF3UP8A2rN2/e9lzSipK0/NOGhcUhEIzER9//ZckDuEoP9Qx3YYv8wwj/S+HWctTS0B22rbfwSD7w01TnmC/QX7LUXJgfTEJkQWg/fnOVT1LDgd2zLEb6uUqjDEaMwVTjDeyhDtg34ly4Qs1S3MMbykpTRdchUU1UDm3foW65sJH9wqoLkIkBoqdYljBqaENAvo7T9Py1FQWvzWP/6xlrvYtVv4uFlZjoOOWz4s2j+ej1Yl30K9THFeFwRU9ZlNJ3B5ArODIXtwZ/0eyUrATLsDmHPUKhA+tn6lyiL0xtNBhsYZs61VB9wg95FBE+D4GpnJzgi9rAqGjf3de7n3jJwjlMcSGU4a7FDG3mbQH9Uj/a8HkWkyz5kizxN3Cc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(366004)(396003)(136003)(39860400002)(36756003)(31696002)(186003)(2616005)(16526019)(53546011)(66556008)(8936002)(66946007)(66476007)(5660300002)(31686004)(83380400001)(316002)(52116002)(6486002)(54906003)(8676002)(478600001)(2906002)(86362001)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bTVNVzZMSHhmMndJeG5HMmJ1a2RnRzlDaXlWZXV0MURaekFwb1J1aUkxS3do?=
 =?utf-8?B?ZFdSVFlTcjB6M2RIekVOdDVrakV5dWFDS0xqZ3BiaE5nSU1nMW10cWhCSHRK?=
 =?utf-8?B?YzZvRFBGVjBleGVEL1RUc1Q5L1lhbW9PWkhONDFLaW54YmVCMitpNmNnS3Np?=
 =?utf-8?B?TFpCaExkMGR4M0xmRXhjSGRsajY2aUtIVnNoc0k1SWZIS1pQOU9pRXNwQVQz?=
 =?utf-8?B?eFB4SWdMUkpyMGxFZ1lnSnVoRlRWTzcrWTZJandGaGJkYVJ3d1dGb1JVdU1l?=
 =?utf-8?B?MEtrWmNGRFBiRDUxcENaTkJzUktlbVVTbHkwSlhYalBSNU51djNlaTBQSmdI?=
 =?utf-8?B?NHpzMHpJMFg0YmUySFhMQndGdGZNWWZ0RmpBUGVDRjIrcDBHcVdOV0krSHJM?=
 =?utf-8?B?SklsZHdSYmhwamNDYTlzem1hVDNoMFZ6VGh2ZTh2N3QydEtzUnlLNmpWY1Jv?=
 =?utf-8?B?RmozYjVTZXRCbmE3Mng0NEI4U2FENnlSYXRseUJZeiszZTJQUWxUZVJkMGx0?=
 =?utf-8?B?eW52UHBUYTg0TVl6cS9vd2tRck5yeTNHK0I3MUYxZmgxWWhkZENXMHZCMjdr?=
 =?utf-8?B?ZHI0a0wvV3FXeTY3YnFWUFozQithdHZvNDM0WE9KVkhreHNvVnBmaUVUY29s?=
 =?utf-8?B?K2t1N1VjMXpxdnliYVJoa0RSL0VnWGg2OGpvTkc1M0x1MUdQdGc1eGhVQ2Vu?=
 =?utf-8?B?WUQ4UVJjc2ZUb2JRSVJoMmpoVFVDRHZOZ3hUZzFtS1d6dlI5OGJobFFKWXpx?=
 =?utf-8?B?TFJ5L3NpUGRRVGlnQ2pqMlFDTVQvam9sVDZmQWNtN01hTFlVOEZLeVdXMFRq?=
 =?utf-8?B?R3FyS1JCNDZFaDBpZXYzR2FRdWZVYThIY0xOSnd4UmJSeVZiN1NEOU1kQ2ti?=
 =?utf-8?B?Ti8wakhPMnhzMWlIRU8yWks3SlpHeGRBUDdaOGhzNkJnZ3MxTWlwMUx2ZUE4?=
 =?utf-8?B?VHhvT0F0ZjlwWlN6emtURXBOTVZVZTBKd3hmdjBsSjd1SFc1RmdpMmxqbjV5?=
 =?utf-8?B?VlpjOUFMVUwxQmQ1KzBPeFBYSDFwYTQ2V2ZPcUxHZXd3WHlZWExXVHJxMkc3?=
 =?utf-8?B?SHNydTFnTjdEeUl0MWNJYzd6c1h4QXcvNW9IRERjL1hicXpGdGFtMTRWaHA3?=
 =?utf-8?B?VnRjRnRJR281UEZMSjg5UVB6Qi9rWCtmRmdKa1BGRUMydEljRWNZNzRMUURi?=
 =?utf-8?B?ODYzNFA1SGlscHZQT2lENDgzclFtSjNQdm9ITjJMdVZqRGRVSENuOFdLdUxK?=
 =?utf-8?B?WFhpVlZjcFV1Qmc3aUU4V3ZzSDZJVlJWOXlsR2djcXJVQ3ZuczJSakc1Tjhy?=
 =?utf-8?B?Tm1oUXhuemFtTStoaC9scXNpZjY4alhmb3QwYUZVQ204OXZiUXYvMHlFbEZF?=
 =?utf-8?B?TEYxS0Q0VXYyQXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b5a6c00a-aa24-4f8c-418e-08d8ba8c1bd8
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2021 02:03:40.1168
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5aycdIf4YUsluPNTPXlvM19D9U6mJpCLNV6M5k4PHIrHKnYASFYyeKOvEDd+d8bu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3714
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-16_16:2021-01-15,2021-01-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 malwarescore=0
 clxscore=1015 adultscore=0 lowpriorityscore=0 priorityscore=1501
 mlxlogscore=728 spamscore=0 suspectscore=0 phishscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101170011
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/16/21 10:21 AM, Qais Yousef wrote:
> Some subsystems only have bare tracepoints (a tracepoint with no
> associated trace event) to avoid the problem of trace events being an
> ABI that can't be changed.
> 
>  From bpf presepective, bare tracepoints are what it calls
> RAW_TRACEPOINT().
> 
> Since bpf assumed there's 1:1 mapping, it relied on hooking to
> DEFINE_EVENT() macro to create bpf mapping of the tracepoints. Since
> bare tracepoints use DECLARE_TRACE() to create the tracepoint, bpf had
> no knowledge about their existence.
> 
> By teaching bpf_probe.h to parse DECLARE_TRACE() in a similar fashion to
> DEFINE_EVENT(), bpf can find and attach to the new raw tracepoints.
> 
> Enabling that comes with the contract that changes to raw tracepoints
> don't constitute a regression if they break existing bpf programs.
> We need the ability to continue to morph and modify these raw
> tracepoints without worrying about any ABI.
> 
> Update Documentation/bpf/bpf_design_QA.rst to document this contract.
> 
> Signed-off-by: Qais Yousef <qais.yousef@arm.com>

Acked-by: Yonghong Song <yhs@fb.com>
