Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AACCC44EBD7
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 18:11:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235333AbhKLRN6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 12:13:58 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:29640 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232399AbhKLRN6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 12:13:58 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ACH7NMD000613;
        Fri, 12 Nov 2021 09:10:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=avdAVBdra2Q9MIMjX1uvb8kIss1BeBW56yPwvckacO4=;
 b=ICOV47c0tFF4/rdHX3yUiawUkzgk61Em18zW/YZ1eg28f5TYu44RsIKShbTQZpIuSCOP
 B6U0//UoJN1dMl77rASgKgrUFoiNJBRIbCOOyC/WZ9cZw8xlsZnWfeQIRK4x5HZywu4o
 CYCVZwKmcdjFGe8w1pr2LntOk33u+VRfqls= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3c9txygtav-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 12 Nov 2021 09:10:52 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Fri, 12 Nov 2021 09:10:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YgRMQgRd8TxhNi5OfDrhsVhLZaB2mBxo0yRqauvCAPcy6kTk0hU7U98NkRNx38IRNKJ1xbdWPZG5XbhGJItay3/iLMwoTffTc7WTJNPZ/CJA8B5McqS1Qf5ZCIA5LyUfA5mMhI+ShRpu5qANvXcg4Cs+3giBSdC35K9IalIXs11yOffun8HhAJ5s3Dz6nKqX5TAVXQMuPW3MCS+ORgebYdY9ljtQQKaedoB0Erq3i0qU/QvIxdmewK8jOL4fuHHVNgP65jexrQcI9RGPRAH0l9cGTmP4FNTVPwkFMcizC1nlA8gdinTI7lMjqdCWOSf3SDyNrsMq9pf6cbkkkJH2Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=avdAVBdra2Q9MIMjX1uvb8kIss1BeBW56yPwvckacO4=;
 b=n8P5GsVBLaAy8nmt09mQeNdL6xqMiTslICzOeHNR6V9B0xp8ohZC1qls1kWix/hIQPkucP+3dVaos3xIY+pWR11bQT32aF77E4TvGi8QkKale1yty+8uEbgRes5tvKKIrMDouKiBRQYR81IYaQ4CYgYug01tttp327fajy/hTxb6pyoup8N/5KSA+RzeZ0f4qyfohhqBXeSIuSM3/QpofVXKBQX4VFkq/HH3JfSZcLsS6OYGXnG8C0qNVBdRsvvvhEDRTJyBJV/pb/uusRlyngz0nfC7wX9UqWjeTaK3pBX6g/2LVK7VKBs7U5+0zifVBgLGp9MV1J/JlgvnGSTfuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4418.namprd15.prod.outlook.com (2603:10b6:806:195::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.16; Fri, 12 Nov
 2021 17:10:44 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::51ef:4b41:5aea:3f75]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::51ef:4b41:5aea:3f75%6]) with mapi id 15.20.4669.016; Fri, 12 Nov 2021
 17:10:44 +0000
Message-ID: <cca830a7-ea94-970b-21a5-76e981fb1e9a@fb.com>
Date:   Fri, 12 Nov 2021 09:10:40 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Subject: Re: [PATCH v3 bpf-next 2/2] bpf: introduce btf_tracing_ids
Content-Language: en-US
To:     Song Liu <songliubraving@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kernel-team@fb.com>
References: <20211112150243.1270987-1-songliubraving@fb.com>
 <20211112150243.1270987-3-songliubraving@fb.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20211112150243.1270987-3-songliubraving@fb.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR12CA0071.namprd12.prod.outlook.com
 (2603:10b6:300:103::33) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
Received: from [IPV6:2620:10d:c085:21cf::19db] (2620:10d:c090:400::5:4b3e) by MWHPR12CA0071.namprd12.prod.outlook.com (2603:10b6:300:103::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.25 via Frontend Transport; Fri, 12 Nov 2021 17:10:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 89e42654-018a-456b-881e-08d9a5ff5cff
X-MS-TrafficTypeDiagnostic: SA1PR15MB4418:
X-Microsoft-Antispam-PRVS: <SA1PR15MB44185705C3DB35BC3B3E11C2D3959@SA1PR15MB4418.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:751;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lb5xFRBcuEbiNr2BiLAE+I7uEP22LxymywJF1+bxWTLjGanWfEK/RTZPJtf2JhTJm34270OeifzPpyWl1t4Z8EHXXTwjB6JEjnIBeY7A+8DkLtuRqmF9wiaFOOGpgWms6d/Nq+ZNFcaf9bhfjDfPCeF5V+E6DLw2hWFT/dS04+2LAZG2T+x3lZA9D5W3zPfuCnTW+Ln324xsVYYLSTjZXjmi3/twZJeGzXcuHbzEbwM8brALUvblOb6mpeFnDu3GRy7uzcaSXX0BwdnVd63+JeaiajdVXytsb/xZlsDrZnmtEflzPYU/BtDlXRj339WA+TGlj0lsRM2Z9vN2UNKTtjAvr3USAM2i8tz1Z5LnRK8XH1lD2lAKNM5OcWCiOh7Sfh0PQGcRqoPw4j5SpzmfLCd0UxbDb+0mtYeQuEswgxKBdi+TmgyEY+Rvr4UlFWFJsNW4nEXm/S3otDiNIWBS7zXbkml/zsjTPe2H9XStZ2Y+ZBGIJKx5OdjfUiRLVRiUfW8dpsDO0ZkCNopRlvuDaGwefhiOTWzZMu3E9fKMdgszYQtms7JS//Gjc0yrc6bdgMUVGA7mrwkKeERT5XOIXIpZ9Jko1028Hx4vz77V8nINE8rcKRErhsjIEE+MtgzeaInicaTJjW9O/NJ1EypmdRP59Xa9onp7KIwPCh4U0VVB2u6CH3F5P4boUQ98XDgNcPwkf7NlHyf2OKs+eIpp7hD6tEfpxO7O66nxtOMeVjh3uyz89fJZ2zhoX/EhxcWE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(86362001)(52116002)(2616005)(31696002)(38100700002)(8936002)(66476007)(66946007)(508600001)(4326008)(36756003)(31686004)(2906002)(316002)(8676002)(5660300002)(53546011)(4744005)(6486002)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OFdWRlFuSTJEVk4vRDdicTVqRzJBNkN5cHRUamdRRC9WRGZUNU1oMzVmUDZ4?=
 =?utf-8?B?OUk5b2kwYVpIeE5ZeG53RzArbTkzdTFhQjhERUl6NEYzMTdJdUUzVjIvYnIz?=
 =?utf-8?B?a1o4b2FqTXp0ZjdnazFvSlcrZ0h6ekM3Tm1KbkJzVTRmTCtLOE14SUEwelc4?=
 =?utf-8?B?V3dTWXA1VkQ2c0dhTkNjd1hySllLSk1zbWVqeCt6aGRreGVLSzF4S2xZZU9M?=
 =?utf-8?B?aGMzcUJ3NE9mSm5EME03QUExaTlrNnNCTFd3S2liNVk0YUdZN2VVSjVFTVNG?=
 =?utf-8?B?eEs0dXZwLy91OVpVSGFDVVJxZmxmQ21HRnJiZTljcUxCbXNPeFRjNnJGM2g4?=
 =?utf-8?B?WURWOFVGdEk3bUZuRERaZmEzMlI3aTRyZjBiWEtxc2N5eE5kUkxyMGpwdXE2?=
 =?utf-8?B?RFFWUDNoSkJBOGhvRGcyWXNXTVowWnRwYXhxeW0wbXk2b21hZGxFNjJQQmx4?=
 =?utf-8?B?Z3NUUFlIVUNLZHFZL0JveXNTTUxBUGlORGFaYkREamVjeDRMaVh0WDJickxq?=
 =?utf-8?B?S1dTVWdjYXFnWk9LU2p4aFk2a1NSUkNzUXQvVys3QXdObFEzS2NJL0Irb3Vr?=
 =?utf-8?B?bWJtY3lGSVlldHhFanhOUG1NV1ZOM3ZYSXpTLzcySTIrUS94b1hoTjNURHUw?=
 =?utf-8?B?eXUyZHA3S0JRU1dXYUl1S2lmd1U2WVU5UXd3UytsOEY3YTl1bFlFVnB0Z1pt?=
 =?utf-8?B?Y3JQVmQ5TFlCT243bGpZMnl6dGFuOXNpYjZFWTd0RjFVc0UwL0tjTkl0NUVX?=
 =?utf-8?B?cm5jRUVCSEtSKzVDMnBZaGRtMm5MY2dqbXRaWU8yOWNnQWZsWnNubHNuSTdW?=
 =?utf-8?B?ZGYxWmNDcCthaWM0NzRMYzhmUEVrYWJyMmJhVUVQK2ZJdGIrdjNuUmZnWm1V?=
 =?utf-8?B?TjdRU1dmNXJtNmU5U0MzejFHeTl6SVk5bzQ3ejlNWjFoUlVnazZEVHBqUEdS?=
 =?utf-8?B?Z1J2d2t4Y3ZFc1NpNnRwTklwSU5ab2lqbDlBWUN0N3cyaDluV1BvdlBKZG9a?=
 =?utf-8?B?UkVLVkx5cGVwV3cxM3Y4K0Z0Y0VHYWlYcDhtT1M5ZEpRR1JDMkh2QmhhampC?=
 =?utf-8?B?QzROWnpLSFIvS3ZVWmdDeUR3b2hIcnpmMjlvVkxHcXJjeVBoVzVlVTBQK1dt?=
 =?utf-8?B?akdxcWlydTByVXhYN0NuakxRcSsxT1V1UGg5dzhUdzBlTXJiMWxQdzdoVlNP?=
 =?utf-8?B?NXdncW1lY3BZNGE1YkJIQmdwaWl1MGt4TGJiaUNidlI0MWx3Q2owU1BpT3NR?=
 =?utf-8?B?TXRRZUtXeThZZjdSYm5FTFdpaTMzNEtocGtBNWNjNStVNi8vUmw3d0NrWUlq?=
 =?utf-8?B?aVg1NzlReU95MGc0amZUblc2d0l3YU9IT1BNdFZPdGRkeERLMS9yR1pISGw2?=
 =?utf-8?B?OXNDaGtOdy9GTFpXeG14SGhrMktrSVRqUDVMSEJGdmhDNEJFcmQrczMra0hM?=
 =?utf-8?B?dU52cFpVQzBaMnFPMUtQZmVOcmVmZStXUTVZMVdGWmtITWFFMjRzelJEOGMy?=
 =?utf-8?B?a25GSlVDN1VVQjJFWllXZWs5MkxlNkVYdUdqOVJuUXFKb3Jad1QwOG5ubm45?=
 =?utf-8?B?T2lZemxxSVF6OWVlaTc1SkcvcmttZU9RSXM4SkE1dysveUVJSXVMSFdKM1d2?=
 =?utf-8?B?NTZXbDhFd2dLOXZQcEJDenV4S0pkc0NhWHlJZ1ljK3VGWFNBSDJ3NWtnUDlp?=
 =?utf-8?B?TDJNUVhBZmMyaFVXSFh1M1hRT1h4bTVkMjJ3S3gybmFHVlEwN3ljdHFKZFZB?=
 =?utf-8?B?ck9rU3JWUi9QMVkydmFEb0p3WnVKVzZXNUdjbC9ldjBna2pRbnVsNCtGaXZQ?=
 =?utf-8?B?eWJJQXAwN3FUajU1Y1pSbW16K1ZxN1lJVEVqWHdlNXlXZ2NBUXcxbkVDYmM0?=
 =?utf-8?B?ckZCN0NETG1HL05NaENxdk91S2VScDIxRkFVL1Jyc09Lcmd4K1d4YXF1VU5x?=
 =?utf-8?B?a3ZQNUVnSE9XVzdjbitGZjU1ejdUNVB5SWVFZzA2Q3VHcUZKNmpLQVJ6allv?=
 =?utf-8?B?MzVrTVVGTUpFR2gwTmcySTF4K24yZlRXbHM2c2lTMUNySVdvRnluY3FYT1RD?=
 =?utf-8?B?U2FvSGNkaUxiZnErdFNObkQrcGxrSGFRb3FOUUptb0o4TThQemtQVjExejQ0?=
 =?utf-8?B?Z2o2ZjhqZGx4SGdjYmJHZ3R1OVRmMXFWdzFjUEtRTjdJMjN6Y2NCTUlrOFRn?=
 =?utf-8?B?aXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 89e42654-018a-456b-881e-08d9a5ff5cff
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2021 17:10:44.6748
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PEgygnA/nLpnitwa0zPxzHmqPfs5aWO4ogfDvsbi2VdVGiXcuwFbFbNW8+yNDgSW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4418
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: mcIL1G0WT9GhNzPzU60_Q_adSlmO1elC
X-Proofpoint-ORIG-GUID: mcIL1G0WT9GhNzPzU60_Q_adSlmO1elC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-12_05,2021-11-12_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 malwarescore=0 mlxscore=0 priorityscore=1501 mlxlogscore=593 spamscore=0
 phishscore=0 bulkscore=0 impostorscore=0 clxscore=1015 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111120096
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/12/21 7:02 AM, Song Liu wrote:
> Similar to btf_sock_ids, btf_tracing_ids provides btf ID for task_struct,
> file, and vm_area_struct via easy to understand format like
> btf_tracing_ids[BTF_TRACING_TYPE_[TASK|file|VMA]].

file => FILE

> 
> Suggested-by: Alexei Starovoitov <ast@kernel.org>
> Signed-off-by: Song Liu <songliubraving@fb.com>

Acked-by: Yonghong Song <yhs@fb.com>
