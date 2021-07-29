Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE5D83D9A22
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 02:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232993AbhG2AgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 20:36:25 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:23476 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232869AbhG2AgY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 20:36:24 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16T0SpaA015660;
        Wed, 28 Jul 2021 17:36:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=UODhUHPo1JSOTQ/4VIMYQi3Jq+jalJRJEjSWGVNVUrU=;
 b=KTwOfwzGM8Gdiv7Sbl/2t5iXtzDboIkp8Ph+q1MCpu3hLwjhrzjRvsUczyUYsAhQV7ZE
 vpoYEHE4rd5KyC7DKFhPsb7cDQ+7KGt8GNlu0M/oq3zlmVyHGk62RsIAS0Gz8WJQphwk
 GshCwRErPJpKFnTdklqeUjANIuLD09HiAfQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3a3cddsxtr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 28 Jul 2021 17:36:08 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 28 Jul 2021 17:36:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TbrfKK9RqkjnBNFirKD6IbHSbjnHzEc+pDHvSNsdTf7aO3wkyMwfBP+3kqnSsjLYzU8DU1Qg+b72Cnk/T2lrqNotppArzNsUtJCmG7zglRiZEqBY5QlGUqsZNxlpHf8c0gmfGKSiF+HXx/WclIJbL8bgiOnNaGlNTIti6eJt5kMPSxqQfrnBlLxSwItnsa3WQ9iSRDPE650NiA9uvJ4eu3JgCFdgWJsjlLfyFzpSHtF1XNZSL3aB8f3lB3Wnlnt31nLW/8bVJtskkP1X80ZYp9ma2zO5IQyhw29tw/yo+48ct1wl7Gyu7PdSkx8HWBYKNtwULLFyt+E/IZDauaPqvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UODhUHPo1JSOTQ/4VIMYQi3Jq+jalJRJEjSWGVNVUrU=;
 b=iqwc6az47wf4nN3BzwJ9PwsWoQSMiO04ShIRfdB3Ldm7MNqStigdq3ROIJU+AJ7odP/DU/Yx5rA8NQRv+IdHwef6KOL1paFlRpBpSAeYerX8bhDv8RAJ9MbrgPoYA8OAYdV2TOxjSR9MMXW2Sy2T47WQOsXUbf8Dm/jPoAIvTp0oPiV79qei83Y1droygfHdq/jBZkY6G15gFI0kv2Szxil1jISbjSaowQF2FqtPS1Odhw0DsZC6TdVRd16p6DMQYhsdpxA2TxgdfHtJ/PGj+0bqrpSDC1lKmrD+QgEPeFqvaD9GMeciukFA6AsfaAQ9MFIMnxQVzID0Jily/x1AZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN6PR15MB2333.namprd15.prod.outlook.com (2603:10b6:805:19::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24; Thu, 29 Jul
 2021 00:36:06 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb%7]) with mapi id 15.20.4373.021; Thu, 29 Jul 2021
 00:36:06 +0000
Subject: Re: [PATCH 12/14] bpf/tests: Add tests for atomic operations
To:     Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>
CC:     <kafai@fb.com>, <songliubraving@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <Tony.Ambardar@gmail.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
References: <20210728170502.351010-1-johan.almbladh@anyfinetworks.com>
 <20210728170502.351010-13-johan.almbladh@anyfinetworks.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <1f1b7376-b274-d97b-0692-b6ccda2a6eab@fb.com>
Date:   Wed, 28 Jul 2021 17:36:03 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
In-Reply-To: <20210728170502.351010-13-johan.almbladh@anyfinetworks.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0030.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::43) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::1398] (2620:10d:c090:400::5:8298) by BYAPR05CA0030.namprd05.prod.outlook.com (2603:10b6:a03:c0::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.9 via Frontend Transport; Thu, 29 Jul 2021 00:36:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2893cbe7-50cf-48f4-fe40-08d95228da0d
X-MS-TrafficTypeDiagnostic: SN6PR15MB2333:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR15MB2333E62890B1F17A0E02CC9BD3EB9@SN6PR15MB2333.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:849;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rZDSf45euyyiDb1JybfCB6KKzayvx6DwfoMTvh/sL7TYhpPUZeDUBZw3cNLAgX+5DOt3gQGjNJyk9QJ6fs+0rrpApXqZnoYWIKKXcpxrMuNSoy61TkO8eTfxds00I98PJvx15Ej8d7533BflgaDUEk0ppnKNqIgI4c3hFKYbxkA73g064mdGcNXQDAgrVKueyTFvuwdWLLhXRshX9kthL8/MgeNNSFPiQjCsO5tXZvGQ/9eb2ZneMfl/UT+JhAjxGuMJXTRy+rS9bNCUOcsQIHnAv3bFm98ZQg5hJ1VAS9Fktepv0muA633StmKmbAKwEkN6XErmYhh1OZmR6G6sYOg8zQ370Q0l2o51uelLL5sZg99QBCNMuekfEuyhHzxgf0nlaupfR7SUxM8vtHbMSGJqKIIB+pgwphgV8RY1NgZdc8g7U3Aet4giKBy1xkATO5UG9l58BBa81vQDMtfBhvEm8jihg1Nk5gY2eW+QhTDhifkMU1WjbRuf9lF8txmHiMfkWfJjyllrsY/77pbzQUNSuMmm1Fzb4bEWDoMTqH6G0W+ScODVvDB0cF4Yr4hfphPcNvXgSHOPNnSvdjH8tCxd3WPEGdrkRCCvCIjhWdqqDelHN+aYox1Pojyy9YXgDAfilk4jGlnAIZPuHxLJrmeOiMMHpxqEw6kYvOp+6wKdjlG5LdDNHNW2+UkW5JNFcsoabxKKK/1QVF+pU+hJWPjzjApj1JmzaRE+M9wqP0Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(366004)(346002)(376002)(136003)(5660300002)(66946007)(66476007)(53546011)(4326008)(31696002)(66556008)(2616005)(52116002)(558084003)(6486002)(38100700002)(8676002)(36756003)(2906002)(31686004)(8936002)(478600001)(186003)(86362001)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZWVWcUlsdHQxbmtvVW42RHl6SHkrVTVkcGNjWlVFS3F3aWJVZjlNL29zejNH?=
 =?utf-8?B?RFBkajM0NG5sSXZjbjBRMGtHSjQydmgxTTNtc1VldnUxWVpyS0ZvWE16cG0v?=
 =?utf-8?B?SnJoZkNPc0VWQVVJRG1QRXFPRXFGdC9mbWZUeVpNRjRwa2NoK3ZkZkpIcE1w?=
 =?utf-8?B?d1VwZEFWNzdvWEk4bHd3ZWc1Z3JNY2IzTUVzaHhYVHQ5aEQxY2huSEJpTWlx?=
 =?utf-8?B?NStYS0hQVnRLSW9WZFI0NVlrWTA3MlIvOFEyenB2aTVZMEprcStKQjVHOTE5?=
 =?utf-8?B?Q1ZuTDV1TDJHWjFSeDkzd1VORnpxTWRWbGRkVlpUbGwrdjRpUUpxenBlWWFE?=
 =?utf-8?B?MEJKSUlQUHJvdDJvaGMzc1pGR1ZnY3NMcXNhSzh3aGdSc1VKczJheE9Ya3Mr?=
 =?utf-8?B?YXkxWDBHYStFalVUZGlWSXlUdGZ6WkRkRzdtOUdPTCtvWE9qSGFIbWFJdE5x?=
 =?utf-8?B?MjVDT25NcmxXaGl6aVVqbnl1UFlaMXZRMjZubERodkpDWGt4TlNXSTUxSHph?=
 =?utf-8?B?ZlFodnZsUk5BZEJQRHg2TEx5a1dYUGNWaVhBMXh0dk9CeHJrQnlHNFVhcVI3?=
 =?utf-8?B?Qk1QRWhEMmFhZitOb1AzaTlaYjBUUy9iZFVPbkhCNUxKMWlXQ0p5MEJmVDdn?=
 =?utf-8?B?NkN0RSsyK29Lall2U1djM2xOck1kTGlua0ZSazlSYVhjRHl4SnlOdWJNZGt0?=
 =?utf-8?B?TzkzVFFjNXczMTVyYlpFaWZKVGMxcHp4TmR6cTE4b3dyTnh6ZHg0V2J6U2tz?=
 =?utf-8?B?emUvYjBWc3BnMDBYTy9IakV6d1dET0FCRGtKYzBXK3QxdDFySkZsMzJCS2dp?=
 =?utf-8?B?OXhjTW15MmhDRmQzT0VJMGxhN2RtWHNmcFYwNUFhcXdXb0JIRGlsWEZiN2NJ?=
 =?utf-8?B?a0RLaldzT3hVcVZmRndJQWFoNWdHR0l6UVpTTkpEOUZHUGFoWFVYbmlZNHll?=
 =?utf-8?B?V09zZFRMTWdoczBUWXk5eTY0Y1Q0WmNpMlhaNDA4M054OHFGS21Na0xkeVhG?=
 =?utf-8?B?V2lFMFY5SHhUaDA3RW12R2FueThrTGFrdmJaaXF3eGJpNEMrRytqZnI1TWsv?=
 =?utf-8?B?dWIzZlhWS2VnMEU5ZEd1WXM3V3BidG9hbXNvc2VHcFV1T0JuQXd1RTMycWlQ?=
 =?utf-8?B?elZWTGxWaDZEUE9xQUNaRGRFRGNWTGVFdkRTdmtoTHVGQUlOb1NUcjlvWjdS?=
 =?utf-8?B?bDB0dTlwZ1Zsa2RFSGhFcUlYNFVRNjhPZEJ5b1Zod0lBNUV3bDdFU3U2ZVRu?=
 =?utf-8?B?MFNSZ1NKOHBEMUhwcjVTcDVwaFJGV1lIbDFMNTRVTEpYMVFIbDRibEdyRWh2?=
 =?utf-8?B?RjlNKzA1UG1rVU5ZRW9lTUpGMWRNT3kvSG9nVDVZbTg3enk5N1BHcklLT2NG?=
 =?utf-8?B?bmxQYXhRYWJtL3p2bzUvZXN6MFFQbXVYaDc3OHdZS285VERUVlYrUXpEUDFS?=
 =?utf-8?B?ODY2U0RyVnE4eDNYeVNlTk5kTm1MdGxGUVJHTEpNc2cvVTVJMU1LVDBVQWhO?=
 =?utf-8?B?ck5tSUU4dzFmM3FCZmJoUXZLTFM1VkQwV2l4QTJYdzhpeDdvaWdiRER6YjBt?=
 =?utf-8?B?R0FxcWVlUFVpam5BSUl6RjM5YnFjOFl0WHJjMUZneXJQM0x0bzBYWDJPd3cz?=
 =?utf-8?B?aVE0c2tHMmQ4L0RJdXp3bUpyVm82VS95K1FTTVBhWDJhUDlKU01qanBsRjVI?=
 =?utf-8?B?WGJWSTBXYVJVU3E0UGZXNWtXbERxei92cmlORWwzUEdXZmRwNzhFckUyM05U?=
 =?utf-8?B?bmJIeklUeWtVM296MFZEdEJpaUVSQlRKMVE2Q3gzWGdMSXNsZWJMRHd5clo2?=
 =?utf-8?Q?XD8LzezWjxmj3d5/l/SSszzttomHbzOux+nzs=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2893cbe7-50cf-48f4-fe40-08d95228da0d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2021 00:36:06.1544
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jNFC3z63+uKkn8dnI3eTgwmPYoryPAKGvVAWA/2kze6ckScpjfZysHFSjKTCnY8i
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2333
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: pHfxkzDPybdVWHy3gAJMxuxb7nvZdLN0
X-Proofpoint-GUID: pHfxkzDPybdVWHy3gAJMxuxb7nvZdLN0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-28_12:2021-07-27,2021-07-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 lowpriorityscore=0 adultscore=0 clxscore=1015 impostorscore=0
 priorityscore=1501 mlxlogscore=999 phishscore=0 mlxscore=0 malwarescore=0
 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107290001
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/28/21 10:05 AM, Johan Almbladh wrote:
> Tests for each atomic arithmetic operation and BPF_XCHG, derived from
> old BPF_XADD tests. The tests include BPF_W/DW and BPF_FETCH variants.
> 
> Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>

Acked-by: Yonghong Song <yhs@fb.com>
