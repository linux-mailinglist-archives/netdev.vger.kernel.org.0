Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E66FA33DFBC
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 22:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232426AbhCPVC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 17:02:26 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:27362 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232331AbhCPVCO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 17:02:14 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12GKx3aV017437;
        Tue, 16 Mar 2021 14:02:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=n2mjAOEThQ7ak7tgK6QWwX2RVDF4ideChOVZvv7yrnc=;
 b=iIYeFsR/NbsnyM8iErXtrJ4q1NihWDhB07a+LnwD2XMU0Cv41TjkiStu/+5MazIkoaHm
 l+OGYb95J+RQd9yRj+C/fm2kFnv1Y84Q+LDg7S9hcW+BKy6RHpydAe3RPi4+tyGhjlDa
 PgQHppV9R0Uo1kY92M/ZkgtzTMFwPlr1sqE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 379e11e788-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 16 Mar 2021 14:02:01 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 16 Mar 2021 14:01:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=javeGvLD662BlkEyNLr5zvhfkZz6OuY/sN/85Fm0TZTksld4nCZLeXZR6CLB3js+IRwfClMuMduidpeZSKbWd4jr0jwlxjc01bNiyPe+ZRwl7ULoKiHn4Zl+aZXcCtc/et0xu6NdFk7YxVMWXeGs2CRUrOPoqQtNjTacXhC8umA53LydIatK46mwXg/qu+GLc9GkvRvVMz8UzwDJnuXLjLK0OfqJ657aGjoH0LU1lTH9d/8ObjkGJIk+llfHMmQK6/vbG5fvFTmkN6/jGd5EPMnoHj1cVc5iTSYJ+ZB94J5DS85tTCYarbjgNU2I0jDFKvtFMFBs9IDF2YoSQYMLqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n2mjAOEThQ7ak7tgK6QWwX2RVDF4ideChOVZvv7yrnc=;
 b=NoImto0RvtOBjb3fdnrrpD2jX6RIgQDuuMCEOsecxeX8NqaK2fxoA0DXMrgXzzmoXrAObQ59oQVcPb2uWzqSWlfo5gUJyMBuDmaQAmKj3YmzLFmIQKxEPlh9gJAXSu81YtV7bbS3zNMcYicv09zTy+hYzDuTWzzIMDCAomjkbxjqlHfVCG36nIwFqvdrRBNw+egZBiwp9kwgekIv6Yz6hBRBIzpgR8rtZLf3B88KGvGA+r5cU6QFAwb8MB+1c1f3t72qAfNHVA1HiS1SmpbTQUlACfhqKP8o5AdsKyJAIQTVkQ5I1n70IYLFqQF1lc+WXGg+tEDQs5szE74ZWoa4GA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BN8PR15MB3282.namprd15.prod.outlook.com (2603:10b6:408:a8::32)
 by BN6PR15MB1539.namprd15.prod.outlook.com (2603:10b6:404:c6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Tue, 16 Mar
 2021 21:01:56 +0000
Received: from BN8PR15MB3282.namprd15.prod.outlook.com
 ([fe80::315e:e061:c785:e40]) by BN8PR15MB3282.namprd15.prod.outlook.com
 ([fe80::315e:e061:c785:e40%3]) with mapi id 15.20.3933.032; Tue, 16 Mar 2021
 21:01:56 +0000
Subject: Re: [PATCH v2 bpf-next 0/4] Build BPF selftests and its libbpf,
 bpftool in debug mode
To:     Andrii Nakryiko <andrii@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <daniel@iogearbox.net>
CC:     <kernel-team@fb.com>
References: <20210313210920.1959628-1-andrii@kernel.org>
From:   Alexei Starovoitov <ast@fb.com>
Message-ID: <272da26c-ec14-8c14-3766-acec6f07ed7f@fb.com>
Date:   Tue, 16 Mar 2021 14:01:49 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
In-Reply-To: <20210313210920.1959628-1-andrii@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:b9b5]
X-ClientProxiedBy: MW4PR04CA0127.namprd04.prod.outlook.com
 (2603:10b6:303:84::12) To BN8PR15MB3282.namprd15.prod.outlook.com
 (2603:10b6:408:a8::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:2103::3b8] (2620:10d:c090:400::5:b9b5) by MW4PR04CA0127.namprd04.prod.outlook.com (2603:10b6:303:84::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32 via Frontend Transport; Tue, 16 Mar 2021 21:01:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bbe6acd7-f14e-4125-2d01-08d8e8bebbb7
X-MS-TrafficTypeDiagnostic: BN6PR15MB1539:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN6PR15MB1539F927E68316C53960A214D76B9@BN6PR15MB1539.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oh5lvYnQUtKsN5fYvS3zfm95YAKl1QMaiLSfdR5BWE3+Wl8UbFy925uMp5SvYraCeGsmGwWbn+sUaTJLWA4A/em+1vLdN9yKBLUZXnDeWb+w3/sbmDeqRJCgHg43bp1TvwaMUVTV/c9FRTg+ZlS0fK6J0Xg7bdeJYJvDx8yPGvAYLvgsd5O/NVKS0ha8qlKww+LbgeQ9qEO76qY/zot7PM9XKmdv/zKutcDoZit/91Shqd/zgMpbIHkCssmx6VDB5FmxWBFwIigGdQYOwG1kRAoFVV2OtULh8rOHdq7mrIt5Bv6fAAzpK4wCtY/DSkTzgf9inspeHq1ELm1WbQ+xe9xi8x4CED0q+97353+C1LSxn1cbKp/fiv5JNwKKdIqFyVQA3quYl5LdENs/NKyjn5qLL+tH55ZCKSsW6Hu0uDLadU8vE4c2LvVd/Fn4SBne26fKGc9SgR1IV0FmQibfUtFcEQPq8DY5WaNZ7Ug32yYtbTGNTTxWWGBnlF9gyJsIGi9jFUPK/IrS3uIn5jXPquXM1GAbjAK7jMjRu1TsgWD8EJdqkO1+2hdVFeRRjt9ap/5YkkErX+fPqLiCFCTKD0DVwxLriKm457eA+9IIbk5bF+JsHzDm59EkD4SP1JzHOwf9USKwhexWtAcr5m1IIg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR15MB3282.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(376002)(39860400002)(366004)(136003)(52116002)(316002)(6666004)(5660300002)(86362001)(36756003)(53546011)(4744005)(66946007)(8676002)(6486002)(66556008)(4326008)(2906002)(83380400001)(66476007)(478600001)(8936002)(31696002)(16526019)(186003)(31686004)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RDRyQlJMV1pIQXorVUxOa1ZydHVPQ1haajF5SjdNRWJUN2VmUURLWVhnS1dr?=
 =?utf-8?B?Y2dLaFhzY2xpb2swUUY5OTZ2dDlTdGxuTFJOZ3FIMkVWKzhBemE0NDlXQXZh?=
 =?utf-8?B?b3ROWm84c2Qvd1p2YlhYdjFvY3RpZzJpN3JzMlBhVFpNWnRuWFc5ZWdoQ2Yw?=
 =?utf-8?B?M1pmQkppcnoyWlV1WFR6alZnczFNUWFRK1pLV0ZMS1lYUlpBOVdCL2VyQkJF?=
 =?utf-8?B?SEtKZm9tZ2NQUGw3UFRuS2drQXZTWm9lYW54bko3anpYSlNKbGR4dXQ1OGxt?=
 =?utf-8?B?aVRjRHg0dFBpWmg3bU9zZVE2QmE2K3ZlSUR2UmpVRUpRUDRHMU9IWkd3d3hO?=
 =?utf-8?B?ajBkSHZTNGQyb0NnQXFmcUUwRllxWks2ZXllYVZNZjd5U1BYNFI0ZERWMVZE?=
 =?utf-8?B?SDcwM21LTSsycVdmNEl2clo0UXpTWWk2ZDJ6dU5BQkxhRC92YXljdHZ0NVdE?=
 =?utf-8?B?NWZDc2MzQ1ZxWnZOc1NmWE5obmJyVkRhUmlDVmprczlITUdVQitGQzFWNHA2?=
 =?utf-8?B?V3JCbW5KQWgxU2ZWRThXaStsRXRWMGtzdzNwUVdRU0Fvc0ZTN25zaXVWbnV4?=
 =?utf-8?B?S0duUjFkaHlEeXY0YzVlK2FGYm1SZ1ZqZnVWSnZ4RWZPOVVWcEJzY25HSGwv?=
 =?utf-8?B?M0p0RXY0d2FXUDVON3NtNVhBa1o4Qk1vTnEzR0prWThPaEVMSkM4OUZQT010?=
 =?utf-8?B?eW1MbU5uVnVFT1hBQVhsT3g1WG4vSEYza2wxdkRqYmNNa2NkV3dBN201YlNU?=
 =?utf-8?B?Vy9Kcms4R01zMUhpNDV4OUpZeHMwYmtZTkZhb1JQclEzYzJ3TnRrOTEyYXRa?=
 =?utf-8?B?KzZRdkZlT0VuUkg3VUdUMW5EZnVldVZLbEs2SWxBQUZZbEVMdHVPeXE0Szdv?=
 =?utf-8?B?Zk9UOTkxOW5Sem9Xdmh0bS9iMzE1eTFQV1NXVFh1ams3V0dBcFp0enNWYStq?=
 =?utf-8?B?ZG14dGZ5VXl3VU1MS2piaG9GclJMRUIvMko3QjdwY1ozWlpMREhrakQ3bWtv?=
 =?utf-8?B?MXpUdEw1c3BZOFVLQ3VYMHl5am52STFIQ0ZBL0Jhdzhad3c1NmRvKzhQa2Js?=
 =?utf-8?B?bGM4SEtPWFA2U0pNQnNoakxJZ1RvYzBtcnBkNjlOUmFoeFloVWxnSlc3cjM4?=
 =?utf-8?B?Nklpc0tieFBlekdtRFRVZWdjRFJKVnZvYUs0WWlGZm5Jc3lSYkl0dENLSkxl?=
 =?utf-8?B?KzFCWkhJWFJIQnhBajdhSkkwelNuZFllcjkyVm1ScStGRDNmWEtvWnZPUzZ5?=
 =?utf-8?B?Q3pGaVBpb2tXbmJiN2w0ZDB2cnlmR2JBTVdPNGttdG5pWTNTY2tsL3kvWGtY?=
 =?utf-8?B?RWk0ZzZVTk96MEpsUE5SMGtkZmV0ZVBONFhxeVNtOU9DbVdSaXRsMXlleDJC?=
 =?utf-8?B?YytRMDRFT1F2U2J2M2pGQk9qWWdnTXc2OUdLbjMrVjNVdGZTYVo5cGlyeTVU?=
 =?utf-8?B?cFhqSG1abi9aL3ExWFcwUmU5NkRKN21MREFiRUZvd01QRGRpemdyTlZsWVM5?=
 =?utf-8?B?eG9TRGU1ajFYdHpMUEl2TkJKVW1lZTdaWlpoUGRKUmtyS3hGV3FtSnYxb1B4?=
 =?utf-8?B?QUhjMVVQdUlGNG96WElyaGtTMXFZTVB0bUxvUFVyM1dZb2ZQcUhKWXQwa2h3?=
 =?utf-8?B?NDJDRldCSDRrdzMxWmtZMFlzb0JOLzJ3cTRBSk9hNlVnUHlJSEEwWVAwaVVj?=
 =?utf-8?B?bVd0c2xCajcxczdaM1Y1djM1dUlYc0pMTUxrWHRwMkpuTUJNa3ZhVkd0bUVM?=
 =?utf-8?B?YklzcU4vbnpwMnIxRDhXSG5TdXZ6Z29EQ1owUTd3c3lGZHZzR0kzOE04bG5W?=
 =?utf-8?B?czNCZXVReFFlM2tiRUt5QT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bbe6acd7-f14e-4125-2d01-08d8e8bebbb7
X-MS-Exchange-CrossTenant-AuthSource: BN8PR15MB3282.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2021 21:01:56.6937
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 18RXRXZEljvR0gZBPeb9zg3TH4yaDcECY8HCIttvyHxNRTXq/zbTupeGfYqh4uWm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR15MB1539
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-16_08:2021-03-16,2021-03-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 adultscore=0 impostorscore=0 suspectscore=0 bulkscore=0
 mlxlogscore=930 lowpriorityscore=0 spamscore=0 mlxscore=0 phishscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103160134
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/13/21 1:09 PM, Andrii Nakryiko wrote:
> Build BPF selftests and libbpf and bpftool, that are used as part of
> selftests, in debug mode (specifically, -Og). This makes it much simpler and
> nicer to do development and/or bug fixing. See patch #4 for some unscientific
> measurements.
> 
> This patch set fixes new maybe-unitialized warnings produced in -Og build
> mode. Patch #1 fixes the blocker which was causing some XDP selftests failures
> due to non-zero padding in bpf_xdp_set_link_opts, which only happened in debug
> mode.

It was applied. gitbot doesn't seem to auto-reply anymore. hmm.
