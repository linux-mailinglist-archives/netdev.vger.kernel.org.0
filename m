Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDF94570E5D
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 01:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbiGKXgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 19:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbiGKXgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 19:36:19 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BB462B25B;
        Mon, 11 Jul 2022 16:36:18 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26BNCLub013748;
        Mon, 11 Jul 2022 16:35:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Kau6xeLDI19s6Qa9Qk7vbAoBfCeI2Qbx3zKEm42mlVI=;
 b=gSyCrvI9ayg3x61FfxB65YBE/Cabi3qU/dYyJVyx2+ZCbVYc/wBPoNq+nXjjk+6Vh2p6
 PVvRL1Bvg64pTBJEjNRSmEGhooY77ixxqVmBCxmTZsE+oQT6gVTlqTnUpGH3HtsrgtGR
 PhVK1F6GQKPDc5Efx0oE2oKat+cA5o+nr58= 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3h8pgnu1p4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Jul 2022 16:35:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YFPyDEU8ovz0QA+MbP8TD7Ertr6QyIae2XJtrEaVERpd88QadTYtKa3pYtLUlv+fhovT2F9DtHlhPK/NRHElD9Dp8ytnrB87ZthCFoHBlw0hwOCRS6ZfWtYGwfLYBQUXpLtGuoC1t4uL+pyUxTvd+bxalPTVcTGCyaPztQuu9XLOE7xz83j4ycrFKHdrdqho47AulUHyIHZAgzXGlni9rlFy/pj1M0LKlniLjLQsj9NKHU/bpVZVoBHhX3In8XXGGGGwJcQh/TY2zCtPBx2YmRQHlU8e7W8Y1J3KLrfHKTbR1gYIHBWKN6QA1nbn5qzhIYG+Mb8/TejrL4Tzu7yetg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kau6xeLDI19s6Qa9Qk7vbAoBfCeI2Qbx3zKEm42mlVI=;
 b=ZvBZsAHWmksvi+gHN9IkvYIGDPZPy8b5Voq/LmKaVWaJLqD0Z9+L+pZuUPbuD8ZCOUQnVe+vixHREgjKkB851TquYlZxppRLqEreCRyej/kLHT9jDByh+QMgKVrAZQ67DZLZYuJI/TuZLYfO3fymJmH8n356LdQZ400JpQONJy39jUutzi5EA/xb/zDNaaOgA+QNbCMKEt4clfpovCe28ONBkawgXJnyOr56UNzyTMTkJfSAqDO6iq3K6KZ5MQfRFJhCD0762LI0zadPXq5rP8VdvMoew7MMg7cGKqueGBY4Z6S8E2IH4GVtikHTV54DWk/rAP0uu+6IoaAF9Hi/vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA0PR15MB3853.namprd15.prod.outlook.com (2603:10b6:806:84::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Mon, 11 Jul
 2022 23:35:57 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23%6]) with mapi id 15.20.5417.026; Mon, 11 Jul 2022
 23:35:57 +0000
Message-ID: <a0bddf0b-e8c4-46ce-b7c6-a22809af1677@fb.com>
Date:   Mon, 11 Jul 2022 16:35:55 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH v2] bpf/scripts: Generate GCC compatible helpers
Content-Language: en-US
To:     James Hilliard <james.hilliard1@gmail.com>, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
References: <20220706172814.169274-1-james.hilliard1@gmail.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220706172814.169274-1-james.hilliard1@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-ClientProxiedBy: BYAPR07CA0046.namprd07.prod.outlook.com
 (2603:10b6:a03:60::23) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7dbc732d-46c9-41e6-d6bd-08da63961af5
X-MS-TrafficTypeDiagnostic: SA0PR15MB3853:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +6QSJLPwAPsElKlKbNfRX1oAVqKAHCKYj9hVoFZk37JPecFe401BkjekEd3xpdpW5/2VlJoH3hpKtUg7d47pLTUHgYl7gX8glHvQz51dw0G8p+2SMQAyKpZGt86bEm8gNysovFcYWpdRlR1c7vouuNwJyO33anz96f9dGHzb/3UBNO+Qrt4U8f+5atEOEQb+nQeUBN7M3tlqvQo0k6NGCTnU0onecQKQ5eb8KFRFd6Q2poNoSeL829Dc1VdHqVYPZk3a7vxcnucc5Yt7Uy3s47SX/nVbVKb/ZAE+hXlkcpdSdOnU5LLzmViyYCr/61Gg/QjK4cn2YAGLuqL5LQ3nB4RR8UTQKNTOthrjCm+jvMB8QRdPk7he9XlL5JQCIw1m+QT/psXvX5PHx+VPasMtTV6vQxM/WDr21IZp89bNhyzu+S2t0f5rP4TEcd7fBXxhQYdaUU+E0VyFSjuE3d3/MfrN80mlyJrtWrR/bUoiDtSMRYjAuAdP6c2FNqtMRow8Ef2PVz4XKZyzxtajXTGOslhFL7AnCiKeFd9lk6i7JOWBMxU1Y1JL9cM2z8W9QpIpgzlKhAWWEISnPc0joBIecRm5HJzf3wK6Siopc4QHeiei+E4YpCv2wSFzwr1kqWCEz75SfLiC2ekFM9o4v17Jz2Ve98JUT0vhoVLyefqpAe4pkhPOrMaqQCWwSHSv1Lz05f+u8ASx60Ylj/u7G/tsVfUkfRAZwT6xLKrxpK+56iFawrLa+RSiWJa5AUzVuN/ZcJKz/Du/dvtTL/bxYz1eNAqz+qZg5cmFd/EqQpLcBEByk560ikAcCIS2/rp7dnea9MMxK/REcDKnJTbZW5KmHDrqZD2Vg64huOU3y7I031yXo+DhEIpsMJ6ZzP1cwf7+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(39860400002)(376002)(366004)(136003)(38100700002)(31696002)(5660300002)(8936002)(8676002)(4326008)(66476007)(66946007)(66556008)(7416002)(83380400001)(86362001)(2906002)(6512007)(186003)(2616005)(36756003)(53546011)(6506007)(966005)(31686004)(316002)(41300700001)(54906003)(478600001)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bjNLem40QVIrRmg0OEhBY0hBYjZMSG94NkdsNnJhUDVia2hTanpnd2FvMzlJ?=
 =?utf-8?B?RzFXUFhYTmRRVlhCWDV6aDVONzhOWEpmMkpmK1ljNWp1MkJTSmhYLzdUUGl0?=
 =?utf-8?B?NmkyRHNMV2luanB1SkZGdTRjUnUza3JBbXlkcStyNDFSNXE1TndPc3hwd0xh?=
 =?utf-8?B?YWtQSThxZ3BUS0JYR3NBQWYyd1lLQnk0Tlk5T1c2K293dTBhdURMKzJiK3pX?=
 =?utf-8?B?dFZLNWQ2Mkl6QUNaS3FsRlp3d1hEaTc0cVNNT2FIdHRyZU1JWWlrRWE1eFdF?=
 =?utf-8?B?N1gvRzN0ZHZIbDZYSGtYdTdJRFZlQlQ1NEVjNHEvY1FLb1hEaDlIZWxLb25j?=
 =?utf-8?B?ODJNNGhCVHkzRzQyYUpJeVJlWWV5YTNqTThsM2hDYkNPbW8yTlU4dk1HQU5P?=
 =?utf-8?B?aTFHOTJQZU5Na1pFQmdmZVpVYjlQR2xxVE1GdWd6RElIQS9rZk8veHY1VElI?=
 =?utf-8?B?a1NJYlNZMzE4QVFUYWxYSFBYbldqK0V6Q09RcEdLckhZdEVyS3g3WVBDZE9a?=
 =?utf-8?B?T05BRERUc1Q0eUpyWUlRaTJma0ZoSFRKd3Y1WXVvY2d5TEhBbHdLaXFWcXk0?=
 =?utf-8?B?WTEwTW5vNGdnUUEvU3VROGlUdW94OGlvb01tbEhzdklNc29WSVFycC91ZlZn?=
 =?utf-8?B?NlFuNU5jTUxhdUVCR20vMDQvQkttV1RVbzdUM0pka2RWUW1qSk5CTGZTYlBS?=
 =?utf-8?B?bDFjTEc4dlUxejhCWGhqeXFEdlh2aVBxc3JMTlNlTFE5VmhoWDB3U2puOTlT?=
 =?utf-8?B?WWd3N1BXK3ZGSVp6ZFhSR3E1cmNJMWFUem5wOUFWU2x5THRESnNkVUk5ZHBZ?=
 =?utf-8?B?ald5RWpTYXZQaEIwZDFRQzBNZ2RNOWFhT3ZvZVNobXRNOFJOdElaK05qYThV?=
 =?utf-8?B?MDU5TFU1akN1M3VvNzJxS0xuSW5GbW0zbjlUL0xXVUNiVzYyakRXZUpSN2VV?=
 =?utf-8?B?bnRhZEUrYUxoaHNDMUJ2VWw2Z0JwN04wNGdQYlF1VHNpby8xcU9pYmZlN05u?=
 =?utf-8?B?eXo3S2pESEZsRnd6ZHpKWHB5TjFjd256YllmS2tuN0RMalNOTWpQSEdBVGNY?=
 =?utf-8?B?czBZQmJwaWViVlU0SUZjV2NuekpweHhRYXdndEdscHdDMDJPSVVpS01VdGcx?=
 =?utf-8?B?Q2ZGVkpBMmttdE0yYndob1M0UHBFY3hSR2duMU1NLzRxRWdZazBWQ1QxK2Yr?=
 =?utf-8?B?UnQ0Y1pXMzFwM09CZDh0eGF3VzlqMnY4eW5RNmh1SmdjcnZDY3I1RS9LbFhq?=
 =?utf-8?B?MGJqUjFHbVZ6dFpFUjU2VjlKcC9mSkJDQ0tyRU42L29NWkFOSlo0M28rN2J1?=
 =?utf-8?B?MFVzbWpZT0Y4NGMwc2FLZlJackRXMjNRR0dOZit0Y2VVMDBnZWdlS2tOSUdt?=
 =?utf-8?B?aVNIOVJWcWNEU05EUnVWcnYzSXgydVRLMTRZMENURWR2K3NGUnFnZEZXeGc5?=
 =?utf-8?B?Q00zc0tyT2JnWHppRFF0bytqdUN2andma0V1b2ZhSVg2OXJyNDhJRURPMG5j?=
 =?utf-8?B?K3ZvYy9rWDUxSWFWMEZKRkRYY1VaZXZza1hweUxvS3lSbXdRZHBWU2hDV1lz?=
 =?utf-8?B?ZEorUTdycTI0U0pOeVlFZHpPTFR1eWRZejV4RXpsTXlCTUxodWhqQ3B6VnJC?=
 =?utf-8?B?MUozZFg1eWwzYnhvejBhTDJ6c1huelpIRkozZDM2OHJaVGVtaW0xSWh0S2JQ?=
 =?utf-8?B?UkFNUGxEcHBKMy94MThLQy9nTWtsaXJWVUUvdFI3NjJOZkF2aDQySWlSWUdn?=
 =?utf-8?B?UkFDU0ExK2FTS1pGWDZPTXNJQTAveEthQnpONDM2aS9MbXBHZnk5cTBIeVJQ?=
 =?utf-8?B?VjdWSUxEUGJ1dGNYYkdMVEZndTQzTWdwaE9zSVNycnlIZGZvUWUxbGl6cEYw?=
 =?utf-8?B?b2tTeWxOQTNlak1UVmtPVFNBRHdqNmFKQXA1bm1aQVdrTkdiNjJ4enZ0eEJH?=
 =?utf-8?B?cHZTZktPc3Z2bmtLK0NDQmJzZTUvUjN3amtBLytlckJQSzZxWnRBdEloSDNn?=
 =?utf-8?B?bUhmaXpVM2xmRmZuWGtTUXF3ekNVVjVGeDNzNXpLeWtkenJJNHA3Q0RGZkxW?=
 =?utf-8?B?RVNOQWNST2gyU1RSWGxrSHB6SklVdFdFSjlDeUc0dmhrOVlDdXhHcjcxNEw0?=
 =?utf-8?B?MFFKL3JBYU9ScHdBZXBGVFRIVForNlUrVU1CQmhRVEhPdFdtY0MweXc3RmpJ?=
 =?utf-8?B?NlE9PQ==?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7dbc732d-46c9-41e6-d6bd-08da63961af5
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2022 23:35:57.6159
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UbvcQZ47ORhvpPQjXL3FTSAV9a/Slz1cdWmkzJO4WshOwTQWfhtxBIEXGNCYAmux
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3853
X-Proofpoint-ORIG-GUID: RE3L1uuM_kKtXKDEioppKPmWg3-3sd37
X-Proofpoint-GUID: RE3L1uuM_kKtXKDEioppKPmWg3-3sd37
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-11_25,2022-07-08_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/6/22 10:28 AM, James Hilliard wrote:
> The current bpf_helper_defs.h helpers are llvm specific and don't work
> correctly with gcc.
> 
> GCC appears to required kernel helper funcs to have the following
> attribute set: __attribute__((kernel_helper(NUM)))
> 
> Generate gcc compatible headers based on the format in bpf-helpers.h.
> 
> This adds conditional blocks for GCC while leaving clang codepaths
> unchanged, for example:
> 	#if __GNUC__ && !__clang__
> 	void *bpf_map_lookup_elem(void *map, const void *key) __attribute__((kernel_helper(1)));
> 	#else
> 	static void *(*bpf_map_lookup_elem)(void *map, const void *key) = (void *) 1;
> 	#endif

It does look like that gcc kernel_helper attribute is better than
'(void *) 1' style. The original clang uses '(void *) 1' style is
just for simplicity.

Do you mind to help implement similar attribute in clang so we
don't need "#if" here?

> 
> 	#if __GNUC__ && !__clang__
> 	long bpf_map_update_elem(void *map, const void *key, const void *value, __u64 flags) __attribute__((kernel_helper(2)));
> 	#else
> 	static long (*bpf_map_update_elem)(void *map, const void *key, const void *value, __u64 flags) = (void *) 2;
> 	#endif
> 
> See:
> https://github.com/gcc-mirror/gcc/blob/releases/gcc-12.1.0/gcc/config/bpf/bpf-helpers.h#L24-L27
> 
> This fixes the following build error:
> error: indirect call in function, which are not supported by eBPF
> 
> Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
> ---
> Changes v1 -> v2:
>    - more details in commit log
> ---
>   scripts/bpf_doc.py | 43 ++++++++++++++++++++++++++-----------------
>   1 file changed, 26 insertions(+), 17 deletions(-)
> 
[...]
