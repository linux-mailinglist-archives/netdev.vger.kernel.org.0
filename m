Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44FB73E866F
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 01:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235344AbhHJXZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 19:25:52 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:56054 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233570AbhHJXZv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 19:25:51 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17ANBUjJ006482;
        Tue, 10 Aug 2021 16:25:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=47b2XHkXTpXBfy9XUJbmQSd1Jo2rrPKObBSdOTXF4sE=;
 b=rEgRVdciysjG9ytrvTe3syGD9DoYIBZOZpp3CA9Z5JPiYuIxYqEN4AYJwTDpZIMstOOh
 mg74UZ7hpdY+PzQBAqqIYUA1JvwRzrJY3NYsKqb8lMjl4ydYeOqIwDC6Qze3CnbMvJql
 uP6+ehvuVfFbTBFcPwMaMGY40aI8lgA9qvY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3abyqws8u8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 10 Aug 2021 16:25:12 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 10 Aug 2021 16:25:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mXh04CJT58/ELZFmKASHmHV+XuXMRTBu9zbChtCIHxrPC+ek5LjunLNRBwPTXOY2b0AO0zjbGI/KhmILFwtCgl0DpOsn9DT58sg8KvRbfx2XIS6mBkL7kaXW4n/YjbHR4aJUQsfKSm1x/pUf6tHKRA0engxYO7diw2sF1c+AYA18tzoLrroPOoXAgHLieuACnolaSLXVU8cWlSCx2NrqIkR09aLtT72r3n1EqjbI8sd1yG7xjx5wVoMrOOSwDUnA2c/mT7MLD9KCAPVoPCEqoLzpVauy8MzvwKvbNAFkidLUeV1CnFZ5K2pTxRMdl7kLwty/6POeRskuvgfHkrXzcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=47b2XHkXTpXBfy9XUJbmQSd1Jo2rrPKObBSdOTXF4sE=;
 b=IEUcMCFJakQqFCrmKa2PyZAXbC0jCavdU48hhcopJdzzkwlZRJf3XTLjgV+nXFfOGmBkrM6sdxbXioWAqWlUuwrRe+eYgUgjTNFaPgXSElC4LBNW+YFa0xza+Gx94YlqWCrFwhfLL2eKSWHZlgGWvjPAYnWjqG7mS/Ec98VY3SCW2UeCC1JeNcW0rf3xtLZoNCaMQ/Uo0sLxORgwzAKb4JODU+eCW/YFqfn444xU2+SXGheJ1uh4xrFhsbybao3nMe1bmrviekgRhBmoQXcbJWsxe4M0TocBdtnoCh5XccQBK+jbGnocNYM4xXiUggPezgEB4gsgLcuckwk4+ZQwng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN6PR1501MB2126.namprd15.prod.outlook.com (2603:10b6:805:5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16; Tue, 10 Aug
 2021 23:25:11 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb%7]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 23:25:11 +0000
Subject: Re: [PATCH v4 bpf-next 1/3] bpf: af_unix: Implement BPF iterator for
 UNIX domain socket.
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
CC:     Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
References: <20210810092807.13190-1-kuniyu@amazon.co.jp>
 <20210810092807.13190-2-kuniyu@amazon.co.jp>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <aefde39d-33bd-d271-a320-c8de186569e9@fb.com>
Date:   Tue, 10 Aug 2021 16:25:08 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
In-Reply-To: <20210810092807.13190-2-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0090.namprd05.prod.outlook.com
 (2603:10b6:a03:332::35) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21d6::1572] (2620:10d:c090:400::5:d180) by SJ0PR05CA0090.namprd05.prod.outlook.com (2603:10b6:a03:332::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.7 via Frontend Transport; Tue, 10 Aug 2021 23:25:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 611b8234-954a-4026-5da0-08d95c56192c
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2126:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR1501MB212607E8D10887475ACBD8F5D3F79@SN6PR1501MB2126.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:200;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H38w1dyUKAEs5chjmzZjxk0RnKnXGMJHhhEv7JPiykb5GItCoN3hHSTeKjQRVSTtIN+U3+UGjIJoPrRqJocOJMFnMZJs+s1S2dXnQwXhJZTPV30PCPEtRlnkwbylo7T1eQMcKnBl5xp7VtN+U0thOPlXhOkQRDn4cXnd/GKOFGm9mP5o7K/ON30JEJGJEXvWa9qXdUUW/2eePdTph3ESSbSfoFOCSZlA9dd1VhQ/OxJyYQHteZtB1TjGmf2Xt8Q0K0DjClZmJ07yXIAWtYPUqhtNvwgehr0C66CLCs7UNjwXzujNn5FN/Ez5VN5GKrWZ38PMbEbMxz2FIkk9aqDnDu/GhMT8bqKe0luSzBK97vNfQQ6n3NWz/ABAJQmUwgeclCwdaBfkP887mitdPDxYLoGu8IUob8ZDcMQNIbw8U//I/GfEa65+0KlU7MbNDC0lJJvANa23yOxiuFq+kD+VOT0ZyzymlI+JVdqzf/TOl7W3VPWhKw5My5P/Qwpiu7pz1hfWBhJPzktVJsjgIjbL+UEsZPBvwrOVqYqHAmLT0o9uWZZP43WtmmPDshsy9qZn+XcX44iHZMHkFzlTUGHWrCBYs7DOGa5QC8H+P0JwKuFMfl0pRSrFbufpd9oi8wWV6PLONeZGLHyELtU+X9nSAJdky2dALPg68PQVlybT7LgmE7qCjVJIFrinq/CYq3PbW0PwA604ShLAggl/fL+rVjQL4ZSBIGGb1H9BjfyH/uXsPt+vwJCFJ20rnLyNE0Q1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(366004)(39860400002)(376002)(8936002)(36756003)(316002)(54906003)(31686004)(186003)(478600001)(66476007)(110136005)(66946007)(921005)(5660300002)(7416002)(8676002)(66556008)(31696002)(52116002)(38100700002)(4744005)(53546011)(2906002)(86362001)(4326008)(6486002)(2616005)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?emtkUXJrMmo2WVJLeUxLT1pPTWZYTngwcjNVUWhBeVRPdTNhSHk2ZWpuMFJR?=
 =?utf-8?B?a2pJNGMyek1HbkZkTW5HbDYveElWVnJkZTAyazZGY1NNTlJaemJGVEZ4MzZK?=
 =?utf-8?B?T05SR0pxQ0ZpL2F1YlJkRnZ0UzI1Mm1JdzI2REpNQzlpSytzcjdHRGovWVRy?=
 =?utf-8?B?N2pta0lXQ3pqbmZzL3dUSS8yQWliSEhvVWlseUVGcFc4U0VRajNZdy9lVkhl?=
 =?utf-8?B?Z25IREJlYXh0clBqeTdtNFBXTFloQS9FR1JrZG9GUmQwRTlUOTh3cEE1M1lv?=
 =?utf-8?B?ejZtN2YvUWNrenpIOXg3dXlXZEx1bDJhR0gycGpVMmlWQUNTQjdUOFNqMGIz?=
 =?utf-8?B?b0hmbVo5bkppOWhiMFlKQ2FEenpmT2MvMEI3eURCb3luaHQvM0NLUExtSDVP?=
 =?utf-8?B?N25kMjQ2TnpBZUtRcXFhemVrWVNseTk1c1hKK0ZKZnR2RUNiRTU5UlZTOWd3?=
 =?utf-8?B?NXJsL3JXMEwvZFc4L0o2SytKaGJ4VG9XU0E0T0VtZzhNOEhpZnRocGVUT0ZK?=
 =?utf-8?B?R29GMWhBYnVJbSswd0tibEtsMEdyRmRFcmVmYTUzdkkwQ09CZncyTHdzRG5t?=
 =?utf-8?B?dzAvcHZaWWJ5QXZETUhGZEZtRDFFNDRtd2N0NHJ0L2VRbTRna2dKOEZSY0t5?=
 =?utf-8?B?YXdoT1VSMVVsazZ1L3NMRFBBeVR1QUk4UUhxc2VuR1Qvemk0Uzd5Sm81RW9v?=
 =?utf-8?B?RlY1bmpRNjd3T2FQWW1rakdSZjhhYVExTWg0MHdOUHhwOHRZeThKR1ZIbmdn?=
 =?utf-8?B?SjJKRk5pOUYzUlIwSVBLd0hBRzhwVmt2NjJaVXJNSlg3aE1LN0lDMC9PVTF3?=
 =?utf-8?B?cExaelNTRVpTMXRlWDJsV1NHRUFvMi9qeXNyQTcwSHg0UDQvVXcvZWkxMWFN?=
 =?utf-8?B?bUNEdk5lZ1BZY1JTSEZldDV4TWlqZDEvRDF2U0V4czZEZFQxWEpJcEZKSGlm?=
 =?utf-8?B?dTdxelplRDB0Z0xJeFE2WHJMaHlSWjdPeEVLbVMwNFYyU0E0NHlRaWl4K0tJ?=
 =?utf-8?B?amVINStPNmh4aC9QS05FcnNBVDNVU2Rrc01TLzR1TXBaWUt0Wm5IUDNjRHJl?=
 =?utf-8?B?Nis2MEVJcTFNQzI3OXRvZnc0amQ1Snd0SVZWMmJ4ZFQ2ZjJZVkIvQTdrZG5a?=
 =?utf-8?B?NWNRVVVNc0RGMEV6Y29xN0srdjFRWWNEeVhWNVpqZ3Nuc1YzeGkxZklCOFMr?=
 =?utf-8?B?SWFacnNab2pGUGJCWnVLaW96cWkyWFhwR09vNUhBWDcyVEV4ODMwMXNSS1hp?=
 =?utf-8?B?OG8rTjNtcW1KTnRkRmNpRGdTNkVKcHpFMkRPRndDcitCbnU1SmtqcFNtbHNQ?=
 =?utf-8?B?R2syMncrL1lsT1BQMld2VnpwRktWL1BrbkovVnB2eG1aYjlmemM2SkNZZy9q?=
 =?utf-8?B?aTdMYmprRlBUWGFxd0lieXEwZlBvL3VWSm42Q0ZFelFvcGJzbE41clJyNTdB?=
 =?utf-8?B?U0pkZlBKbTk1a3Z6ZCtuM2c2L0VCY2pHU01XaDE4dlNwenpLTjlGYXFWSXRq?=
 =?utf-8?B?NDd6azZUNmdjd2dmSzVTcHhlU2Y3MFZDYzRtbVk4dlU4MjIwZ3hISU5CQytD?=
 =?utf-8?B?NW5oS0QrNm93NWJXMXJ0UUxVcXJ4bU5OVHExR3BsTlVqS1dkR1ZIdytqaDBu?=
 =?utf-8?B?Uy94N1ZWMU5VRUd5WmhVK2dDemdCRGhLbVRCdzVnV1RtRC9NVlRQOGhqYVNw?=
 =?utf-8?B?dlIvQWx6WjJBWVhZUmR1WkhSTFg4SHl3MHNPQU5aNFIxTHVmMExzUTlLSXds?=
 =?utf-8?B?Y09TNXRLN2xMaG13Sng2SGN2T0VwTllMeWswZDZQYWlZdEhIajlwZXg0VEpY?=
 =?utf-8?B?N2U3M3dQS2FySnRsQnhxZz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 611b8234-954a-4026-5da0-08d95c56192c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 23:25:11.0465
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IL117U24aKcHtpPnF9wvjqeGdhlfOh3h4F6U+nj0CLqJutU6bNPgBu+ayXMsXkBf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR1501MB2126
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: A2gPn7RgBtkkbU9LvW52jsKf2SzIPWGz
X-Proofpoint-ORIG-GUID: A2gPn7RgBtkkbU9LvW52jsKf2SzIPWGz
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-10_08:2021-08-10,2021-08-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=673 priorityscore=1501 spamscore=0
 malwarescore=0 impostorscore=0 clxscore=1015 adultscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108100153
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/10/21 2:28 AM, Kuniyuki Iwashima wrote:
> This patch implements the BPF iterator for the UNIX domain socket.
> 
> Currently, the batch optimisation introduced for the TCP iterator in the
> commit 04c7820b776f ("bpf: tcp: Bpf iter batching and lock_sock") is not
> used for the UNIX domain socket.  It will require replacing the big lock
> for the hash table with small locks for each hash list not to block other
> processes.
> 
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>

Acked-by: Yonghong Song <yhs@fb.com>
