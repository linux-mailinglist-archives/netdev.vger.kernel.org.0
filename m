Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA21A52977E
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 04:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234225AbiEQCtw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 22:49:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiEQCtu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 22:49:50 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1D3F34BAF;
        Mon, 16 May 2022 19:49:49 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24GIWtJL015641;
        Mon, 16 May 2022 19:49:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=93ri6eakOu0RPB9xwbjaO5SFABbVtc7/D09Qc3GNRZE=;
 b=IXKgawXQhh5TFuvJ1cxDjHhIpHXqMr1nFEUxD/2wBkRXU8Q++SpGE5g0e+YfoZ7QgUic
 3xyuacqN5MpzUuYEWs9Ua+hyrSfCxvRJmoNVNZRUQOdraIJUybNh3mzUa1Q2oXRy0tCQ
 zl9JQI0eFcYUYpLZLgGeiH4axvidcx/OZAY= 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g28fkekpm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 19:49:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XouIWKr/LgPq1IjG/zi0sbb1u7ovL5cJl7KETR4mCgbQ7p7K5yK+oPCDbDMMz+/U52P7wnQGW7Zva6Y3biM7fkqefj3Ob2dnanKgjEqqdpK5CqtQN8T6OIhkNZjQV51xPs3KL+IWJCfV6vWV4pFXarpFtKr9HOX8803koUmu4dKOH1j75uHQ5kMoFxl9jpvsQbnAAvc7V8Vi4bdOG6HTTvYV1lVNlJpWDUPIFQYVBil4E8+LAmvalIL/w54jfvG9WJSx4sSOIHGlK6om4cXpdoyQl1+Y0xaIUwCs47YniK3SGg1Lu/V5G6tTHPziw791qUS5M0xI7JReq2Dn7RCbdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=93ri6eakOu0RPB9xwbjaO5SFABbVtc7/D09Qc3GNRZE=;
 b=FetYuXtyyMUXA6LOrUlxW58fuvFQED2laEFFS9Ov33UwiCEAZDOcMFd75Q13LZzV8ktcTDPx9CJQs7uZgHyw9HF4GSo4aOqQoPX44LSzxzDIEnZWTug8G4zp6TFvFxybxrJVaWcSzikOqUFdg31U3sYyr4/3rtQ7sBV84VYO0CLQkCKBrri1Ds8IcZ3XbJu+/Fy0wLeSsJf0G6AWbjxyA2JoygxcUPsQZGTn4fEo1DDe/4R/8CwkWMxznQiJ4NWcDFIzfZTcvsSn8H+HOr4MZVVi1Ude7snMP2Q3qZsapUu0MvMyj/IwZTMnrWNDfWma9A4Z0CCMTBHb2GSUk+4BMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by MWHPR15MB1455.namprd15.prod.outlook.com (2603:10b6:300:bc::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Tue, 17 May
 2022 02:49:26 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53%7]) with mapi id 15.20.5250.018; Tue, 17 May 2022
 02:49:26 +0000
Message-ID: <9560ec84-9b05-63f9-0090-590c0f1bd6c1@fb.com>
Date:   Mon, 16 May 2022 19:49:23 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH bpf-next] selftests/bpf: Add missing trampoline program
 type to trampoline_count test
Content-Language: en-US
To:     Yuntao Wang <ytcoode@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Yucong Sun <sunyucong@gmail.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Kui-Feng Lee <kuifeng@fb.com>, Jiri Olsa <jolsa@kernel.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20220515063120.526063-1-ytcoode@gmail.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220515063120.526063-1-ytcoode@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR10CA0014.namprd10.prod.outlook.com
 (2603:10b6:a03:255::19) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 43fefa57-251b-4598-17e5-08da37afdb0a
X-MS-TrafficTypeDiagnostic: MWHPR15MB1455:EE_
X-Microsoft-Antispam-PRVS: <MWHPR15MB14556F8D44EDBB8B9AEDF993D3CE9@MWHPR15MB1455.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Rfy3zHFDH9OcVHkprFiuqximNHzSqkNtSIs6jUigEVJyAWtUD/yZz3ReVTfBra7ELukRi83rHIrDXrB6k7m54UzIA6suhrqckV4PPGWd+/O7EFn9gQyDFw3FHxGS6qvSrp+pb+ztWxRlim7gOzfWNoeyaZyXU/MiNKB3p06E1WNywicNy5+yEJzDzIQFM6QqU2DELOhBTjhpb9JPiESjxzGof/OenhvlPa56lmkTUvzX+8HOJWzp0LZLHlSFnK+g1qmo64bkc2J3FAU+4UP53LMWZHx9S3QeweItR7dRWeT1vBQcOtxjEof+UNS7tQNVbgjouacPrEt8CPhmrTqc7x7pXRLHu4hCO9X1KEPbCJt3zSw2y+BqIvqsVlZjLIQE4rVZ1ClvbrWmVRt1GCS7tFEeQkHCFFkZoUN1SZN6asuVLBzCLD+y3rz02Of9HlFEz1HxPAM3sb/YYmIX7jP4V+ZiwzIGMtcUzFD8aFQuBPHcR4JfUBxwKR7PROAVu2jXnmQhCJUJRKP4/GLJ80x+s71wnWlAQEf5gylTvF2NqwXJVZml/W3ARpPmOG0jYXAWA9v9MiEVhe4Tf6IdXdqmqjTbgWiOqsle+MOpR3uizQ3dayY7CG0QsZIFYFf0JTuEntpM4KG8SCIfdxclXpHiB8Weycx+HmvaQA6m/hhHFGfxRVE9Usq+ZEbACyVhbknzNM04WuQs9iJOe6v/O+P3sBgN+e4laGvZ9YTUNJlAvYQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(83380400001)(31686004)(54906003)(6512007)(6666004)(316002)(2616005)(6506007)(2906002)(6486002)(110136005)(53546011)(508600001)(8936002)(31696002)(66556008)(8676002)(66476007)(66946007)(86362001)(4326008)(186003)(7416002)(4744005)(38100700002)(5660300002)(52116002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eG1Lak9FVjBKMHliTnl1VWxoYitzcXJqc1oxVkRMd2lDQzdJVjErbllmOXFo?=
 =?utf-8?B?dXp6MFZoY2VjTGY1Mk1tdE40UHJPbHBtWTJPMGt0UEpRMGVFM0tTdmo1a01W?=
 =?utf-8?B?blRGOUkvS0M2YXhpTTFEYlJRNllhV0RzRU1VQVBLODkxVTFYTzRxU3dzbW42?=
 =?utf-8?B?VEJqaHg2bENIZGMzd2VHV1dqKy82eHJlVXBSVHZXcFp2bWNnZThqd05JSU9X?=
 =?utf-8?B?ckxyVFhlenIxNmUzc25KNksreWpneEwxdFJQZEsxa0xUNUZtL29PdE5NM3VM?=
 =?utf-8?B?dDloSDgyKzZrRjZibllERGRmY3hTaVo0Wi9yUFFsZFNPZzZFTzRvMy9PdXll?=
 =?utf-8?B?YWp5V3IzdG83UTNsS3BBcmpVRHEzbFdNVHNuRldETVdGUVhYeWQwT3ZPbURE?=
 =?utf-8?B?Q21GN25IOTJZaFhsR1FKc0ZaTi9RRENGaXBNaXJrZTVIRjhqZEZPbjRVd2V3?=
 =?utf-8?B?SlhMWmszU1RISkc4K2xhS0Y2cmhMcWsrdGFnUHNjemJJaGJJamYxS0RCenNM?=
 =?utf-8?B?R09sVnBjZFAvOWFkYTA4WkZjYWpjeDU3WU5EdkphNEYzakZDbmxiY0M5aUQr?=
 =?utf-8?B?OUNZVmY4R3BQT0o3VHNNc2dLNnFtMWhRSnhSL1BDUTM0M2lWWUcydERMcFZp?=
 =?utf-8?B?alhEbmhqWEVpZVUzMnZZOXRvMysxK3FlQXlkOFJxU2hnUlB5L2lXNnhLdzBZ?=
 =?utf-8?B?SEg0UXhnVVQ0Vlh6TUhwZ2xYcG83R2dpb25oYTBEQWxSZ0dyc3RGaDliYjdT?=
 =?utf-8?B?T0J6a2Zrdm15QzFQcENrTXMyMEdibXdUYnVYVjJlbml2elp1Qk5xck0wNHRS?=
 =?utf-8?B?SDh3ZVpKSXNYaGdaRitPbHBXaFRGMEpSb3Z6Y3RsMUFhYUcrRUVsdVJxUUM0?=
 =?utf-8?B?M0xqRUFUSmJxazJZKzZEMXpNQVBJbXIyTVJQVVIyTExqWnhYcTAwbW9VZFNS?=
 =?utf-8?B?MGlkY0FLM2IyVDQrNTg1ZTI3SVNTaEZsNVQ2eC9jYndXSU0vVHdZVVQ3Q0lC?=
 =?utf-8?B?RXBUdnBOSTljamJhYnNESkd3eWo5Q2hlR1RzNEtxa212bHozekJ2cERoSm1W?=
 =?utf-8?B?MG5XTjBKd25qakZPV0swTkhpendhVi9DeGpZbXo3R0luN1BGSVA0S3NxL2Ni?=
 =?utf-8?B?eGdHNmZsY3lsbFl2RUNOa1lqOUY2bEphdWFrUGs1WWl1RzlON2Q4OVlEMjV6?=
 =?utf-8?B?OWhIN05XMnRVL1g5elF2RWVaSWZMWlliNzlBTXJHTGFmMDlJSnNMQ1U3MmVl?=
 =?utf-8?B?Y2ZSZ1RvdWxObmJ0NlF5dzM4TFJlRzZONVMxc2dQTmlEVTNETEdKSzBVbW1M?=
 =?utf-8?B?MVJ0d1BTZXlNV3kwNDZabVFYQVdOR1h3Zkdzc29UVFp6S05FOTRmVE14eENp?=
 =?utf-8?B?alNHNU9ldHlwZnBKbGhHd0UrSDhUdG53Z2RZWmpQMDU3d3lWQUhrTlJ5bDVI?=
 =?utf-8?B?STRiNmhDdFk5Sk1uSlpjSlVTY2Y2a056cXpka0FkMGVWYnV6SnV6ZzdZaWU3?=
 =?utf-8?B?SWkvMkZzWkZnZFdNOVduWnpITjYrczNVZ2RRdXh4NjVUS0hoWCtGMk02V1FC?=
 =?utf-8?B?SWVrS0syb3dIV2F4S1dSU0hMdk9kYXdDZ2lQWkU3VmJjRmFQS01jaDNtYSsv?=
 =?utf-8?B?SlVVY0FCQWNPcVovSkJvdFJJSkxyNkhTU0dBdlhidzIrQ2xjN2x1eFllVTFS?=
 =?utf-8?B?TEw5ZDIrL2ZCU2tXS2UwYjZBWE5jNzZvdE45dlVZVG9GSHBBS1gwKzFIbnlB?=
 =?utf-8?B?ZDlaK0w3YkpxK1cvWkJQdW9kcTVnU09CL2xsMjZlSHhSK0hHYnlvdHZpVlZJ?=
 =?utf-8?B?eEhiQXdMa09heXZjSThCVG1DZXVnTGRrYTVFV05XOG5UcE9USE1LT2FSVzBN?=
 =?utf-8?B?YmxEL2ZUWld2b0wvV2dDeUNmOXI3KzFlanVKbEJxRTNmUkFWa1pvdTlINTBW?=
 =?utf-8?B?VEpILzRFaDFwa3FtUzBHYjB0QmlaWG5XUU5YVzlzTmxSRzFQUFdITzU1dEtK?=
 =?utf-8?B?UkJRK0hlZVRzeVlMeHhDOTdVYlA0SmNHVVJtU1Q2dGhqL2VzNnpoRWY2TkZQ?=
 =?utf-8?B?TXZvNkFmakVVbTRzN2t6ZVJYS0pNL3BQWjJvSktwRUdaNzBtYTBPSWdQQUF4?=
 =?utf-8?B?Z21QTWRMMU04V3JMek10YldaQmpNOWtCSmZSTnBTY3Z5WVRlV2srWHFXNjF0?=
 =?utf-8?B?VnU5MzdEYXdEOW5odVNpeVZicGdqdkN5eGh3QW5iUUttZ3dQTU92QmZFbmlH?=
 =?utf-8?B?SDc2QTFXTzdlSXR6QTQwZ001akk5ZkNGSUE2T1BKU2UwdzJQbVZ5UzlCbVdI?=
 =?utf-8?B?MFphOTV1cWZHL2h1dG1HbXBtaGU4SDJSU3Y2Y2RnellWbWk3VjZIMGZpSjJp?=
 =?utf-8?Q?LhtBFegY0Izw9u3c=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43fefa57-251b-4598-17e5-08da37afdb0a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 02:49:26.2053
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FLfUxW1V1kUwUsTkpswKFaKjdBKeGrE85RNAbS80abuhcZ8O9uheH62JUQOiXkEd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1455
X-Proofpoint-ORIG-GUID: UcG00h_rySRnLv_2IqQCd1tRENggZBjG
X-Proofpoint-GUID: UcG00h_rySRnLv_2IqQCd1tRENggZBjG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-16_16,2022-05-16_02,2022-02-23_01
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/14/22 11:31 PM, Yuntao Wang wrote:
> Currently the trampoline_count test doesn't include any fmod_ret bpf
> programs, fix it to make the test cover all possible trampoline program
> types.
> 
> Since fmod_ret bpf programs can't be attached to __set_task_comm function,
> as it's neither whitelisted for error injection nor a security hook, change
> it to bpf_modify_return_test.
> 
> This patch also does some other cleanups such as removing duplicate code,
> dropping inconsistent comments, etc.
> 
> Signed-off-by: Yuntao Wang <ytcoode@gmail.com>

Acked-by: Yonghong Song <yhs@fb.com>
