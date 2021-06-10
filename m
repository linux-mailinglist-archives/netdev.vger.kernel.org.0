Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92A1C3A2174
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 02:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbhFJAdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 20:33:14 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:56734 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229507AbhFJAdN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 20:33:13 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15A0FStX018020;
        Wed, 9 Jun 2021 17:31:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=9NQAXr/UNN4cWGEkp5fqWcUtD4BzNZs6F7G3FHsLjmY=;
 b=N0xcV+prcL17CJngfMfOezUpKdhVg+MQrbYueEgIkyf64k1VitWfG0O2IOyu2vxZyWJ0
 98QmyBGiLdvQT2TVB8l12Z9tLhqkQSlTr7/NF0MtxXuKM64q6nfgJgCo7TKoTU79vwsA
 32XLbsfaW75Tg/ki8BmO4amvtbWWIJXCwfc= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 392rvqe2jh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 09 Jun 2021 17:31:01 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 9 Jun 2021 17:31:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J4QfFW2yxEMme8PuJJVBvLm/fr5Qn7LYAvC/EfaIZvn2BR0PzPBck1zMf7cm+hEQP0IG6zapiKPciYuuRwudx/m5Xb68S1+QJ1g1v9ZKiRqLm2EPXz1My++VzFpz6bQZPW0QxpxXBBv4UWT1j+RbpdgK+LABsnfcjnpjW9eP7g5SmXowidD0NucqeHigj3sboU17hPEdkG0YovvqJDn+9aQukC3ZigRhutARQR1ZC0ej5XAnsd+tr3IZG5xB1mvsj8Cg9MvoYIciIc/dzaBO2UEo6JltbW6XlPnyf+XoQn8rYAeLZ0KsNRwlaOUCkCDWKZPPi0WfABZ/mAMSMiRuAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9NQAXr/UNN4cWGEkp5fqWcUtD4BzNZs6F7G3FHsLjmY=;
 b=fNZOqAGaORKm/Oq8JjhJqsv0uCqqtz6vnlokL0Y12weRxXza10AJWINrb48fSbiYgvtoj7AFdY31WcjK1493YhU1PyqZm8Iss1vRbIzMDFFZobP1AtOp6YQsOcIJjrhKi5OJMiGaF8s22rtk82UD9B3hPwzj2uT63tCmbll/ggL39rxqAYYBoq/8hzxMuaoso8w+5si1ujFSgZpKaaho6oM8iPVH+ZJw06b+/kGODATHAvNVZBRje/RYnXg/s1bAHPv2k8VvsI/sUSL2MLDaV/10EBvpvChHAzFUGJkIAUgIqK7C4StSUVOgumWDgVzV9cgUPSBprVosjgPFUgdPWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4659.namprd15.prod.outlook.com (2603:10b6:806:19e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23; Thu, 10 Jun
 2021 00:30:59 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906%5]) with mapi id 15.20.4219.022; Thu, 10 Jun 2021
 00:30:59 +0000
Subject: Re: [PATCH bpf-next v1 07/10] bpfilter: Add struct rule
To:     Dmitrii Banshchikov <me@ubique.spb.ru>, <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <davem@davemloft.net>, <daniel@iogearbox.net>,
        <andrii@kernel.org>, <kafai@fb.com>, <songliubraving@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <netdev@vger.kernel.org>, <rdna@fb.com>
References: <20210603101425.560384-1-me@ubique.spb.ru>
 <20210603101425.560384-8-me@ubique.spb.ru>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <8040518a-572a-18d8-5a50-fd3e82f13f5c@fb.com>
Date:   Wed, 9 Jun 2021 17:30:56 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
In-Reply-To: <20210603101425.560384-8-me@ubique.spb.ru>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:92ff]
X-ClientProxiedBy: BYAPR05CA0031.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::44) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::11dd] (2620:10d:c090:400::5:92ff) by BYAPR05CA0031.namprd05.prod.outlook.com (2603:10b6:a03:c0::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.9 via Frontend Transport; Thu, 10 Jun 2021 00:30:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: af334708-77d4-4e9e-db01-08d92ba7052c
X-MS-TrafficTypeDiagnostic: SA1PR15MB4659:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB46594F3D3504B91C06421245D3359@SA1PR15MB4659.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rcHHBuc76bCC8ksSlCA0GcZGOVsTNXFh4dDish76UHet9yZ/FkmHqM/0sQAiFeiU9yMlT26nRiY/zqzdSZHhKMZ6T3rjiGfqkdQoED1jEt+lEjbUO4YucbVYYoEAUlQZO85YcIlRNJsaHV4ORuuDPCkYKXEJdjhT/39e8F+DZmBLtnRPJi+gqz0cKhRDKpv5nOToW0pTKwQN+JL4sEWJrVcDkg7Zblne2/UrxZNP3ks9RyqpcAcHkkqrRfHLvXEpCdN/twgFIPEAVBUjB48uQe0hZh2Jyd7Bd6htASQSWd4JIVOoO38xy9EYngiGapKbSIxWnwZO5vfoLqE4aqQd7kpoGx8VBAweTnFEDkJPZ7Im+RE1oUEo56pqeJP9NDQgvMb80iXjY82r8ItSs5WqNaNi+qdCGYZ75yHSLqeonaG4+fSCV0UxB+puqxJAFmxiCbVgfuUinahIWIxgHnOZGEAxLErRGSiGM/FlAUunBsDlr9Ah4NS7a0SJwjGcMb5KfnaOhcBJZs/2jnn1IOKkyJ7i7DEsZZQahMi7VXwWZHQV6e0sVAIpimwRWLJ1yP9hAEl3B2VhGlBH8HIxXXIZtg/Pi+GgBk7Sc+LMbzgrAVdXrwCl6GOjEkL4R2S22pknhZcJKUF5IYgIUODTlJdG3+F0SzcCpm/YH1aGSaEmgaOOT/wHChXjwUQ0sPVduWl2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(376002)(366004)(39860400002)(2616005)(66556008)(8676002)(38100700002)(53546011)(52116002)(66476007)(86362001)(478600001)(6486002)(83380400001)(16526019)(8936002)(2906002)(36756003)(31696002)(31686004)(316002)(5660300002)(66946007)(186003)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZW5mSjBSb1JmVmQ0VkRkZVVnejBCUmtWK2RMV0FXTzJVVWVleW9NUk40OEhj?=
 =?utf-8?B?Q0pyZHFkUHFFT05wWEhRVkRoTklRQ1A2M1B2cFo5eXU0NCt1TjUvZEVMRU9W?=
 =?utf-8?B?ckxSRFZTcHJOMFdubmdUbytHeWZtR1lTMjBaK21XMWhsMDFURjloV3BxY0Rm?=
 =?utf-8?B?QXZ4MHVEQ1lYMHNzUHNsY0ZaKzlONklvblpiWmlnQXNOOU1RQ3pjL2Fyc052?=
 =?utf-8?B?QVZLUS9ZS3pGdVNzVFdZYTFILzFLejB6TU9WZ293NXJUeVI0WUsyK050RGdy?=
 =?utf-8?B?Y0FadFVLTW04YjU2MDZzeVVrOEw2ajZmUmU0cUkvR014bldPZWNmWVR2YzJB?=
 =?utf-8?B?VGlBeDNWcVhoa3RsNTNpVlZ4MHdpUTZScHpYYzl2QVBDSmZXN2NwYnJITzdZ?=
 =?utf-8?B?c2VYbERLaEFCSnJvLzh1MWxnS2ZtVEpHMEpKazlVcVhiSml2cVk2NGRHcmo1?=
 =?utf-8?B?c0h0Sk5nbmVTeW84OXk3YzRWMzJ4SkM3TFZxWC9rRXNkUUdlZVoySUorR3Zv?=
 =?utf-8?B?WUxuQWFEemN6ZWQwOXZTa3pQbE80NTJiQWhydTJ6T2VIV2ludkI0ZUI2ZGg3?=
 =?utf-8?B?UXkzdEZsZHRWeGZHNURLMi9BZ3BDZDhZV3htSjNMSEM5N2VVMHpXTnRoWU1v?=
 =?utf-8?B?OStGVG05UUs1cWs2V05SL3N3TXhHWDJqTWZnNUwySUo2MUMza3llZldVLzcv?=
 =?utf-8?B?a0wzOWJ0NnlxdGpHTnpnbXMzTVBBeWJMWngwUzVuQTY0eFZ5WEV2UWhQblNN?=
 =?utf-8?B?Y2lhVjc3VjhrcTQ1NTF6NDdwSURQUCtUNVBUKzhwSSt5b0pyeHV3c29NeE9N?=
 =?utf-8?B?QTRkY0c0N25PTXBZUm9LSUM0V2NMbTNDeDllY1hMSWFLaHdzMjJqczgzZUpx?=
 =?utf-8?B?SG9RK1BsTzdDZzhOYUhKMFgvM3d0ekI1OWpDYW5kSnkrWVVyd0ZzRlNvZG5S?=
 =?utf-8?B?U2ZUVmUyYzlZMTladzNvbEhqVThUZjJ4S0gvRUVkNmxsUEdKSndsYktRQjJt?=
 =?utf-8?B?c2wrbWx1ZGtsTFdFL3VIemo5OUprQU80dDIvQWkrb1FNdURXMit3d0cwM1U2?=
 =?utf-8?B?K0s3VjViTFlycklIU1NTbk1oME5NcERlWkFScEFjQ1NaMFVMNWdtb2JPUGZH?=
 =?utf-8?B?RDdoRVA3M2JpQms3UjFOK3hyUjJBNXB4SHFZS1E2ZGFCMEhMMkEwTkpRUjJU?=
 =?utf-8?B?Y1VQdTF0RitMSjNkQmtRcWhIN3JycGN1TDhQci9IUHNvZjlxajNBWHduNE1w?=
 =?utf-8?B?WXpIaFJ2WUxVcjNBWVM0RlBDZFNYSDVsdWh2bEhBc1hST1RyWnJjb1BWd0pU?=
 =?utf-8?B?amc3Rm1KY0xCS2FMOHpWTTI2YWVEbzYzTTV2OVJaSHJ4UVVkMzlrbWxNKzNQ?=
 =?utf-8?B?YWVXNHo0dGxsN3JZalVZYnpCNnJHbXFQUnVtL3c5VVQ4OHNGak9SOTJqRWM3?=
 =?utf-8?B?RDdRSk1HRmpSMXAyQUZ2c3BIbTJKR1dSYmhpeEpDRE9XYmErdjY0aFJRQThk?=
 =?utf-8?B?SDNvT3hvTHVqR09TeEhPa1V3TnMranZyQk1rK256MThTU29ydGhhT1pnU3ZC?=
 =?utf-8?B?dlpsSjloemhmWlcxYlc3czd6RU8xM1o5OUZzQnppb2gxRVZWb3VTVXd2VEVu?=
 =?utf-8?B?ZlN3bUhqMHI1VU1sbm5kcmpkL3VmVmZkTlJSeWt5VUg5alUwbUtzbFNOY2Zw?=
 =?utf-8?B?cjR0SE9EL0hkcDhISldqUGdxeVpNbnllNFdGaER3Y2VxdXJxbnJ1SkhsalZV?=
 =?utf-8?B?TlNsVW5QK1dsaDg1NEdJQTl0K3FxWVB2VUhUQzJyaWpMNUhDR2NlY00vSkN4?=
 =?utf-8?Q?yANXm44MCd2bp31+yxsTmvd+ZuMMvWhzpWNh0=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: af334708-77d4-4e9e-db01-08d92ba7052c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2021 00:30:59.6943
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A/E0mMioqTC+CmbOjRy2V/7r7sipue6SWt81YGBgJz/IxVis/V7ahNIcRU5BWjEj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4659
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: Jl8wUmZS0Is53kOwqvjJl_n9etnn46IC
X-Proofpoint-ORIG-GUID: Jl8wUmZS0Is53kOwqvjJl_n9etnn46IC
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-09_07:2021-06-04,2021-06-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 clxscore=1015 suspectscore=0 adultscore=0 impostorscore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 malwarescore=0 priorityscore=1501 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106100000
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/3/21 3:14 AM, Dmitrii Banshchikov wrote:
> struct rule is an equivalent of struct ipt_entry. A rule consists of
> zero or more matches and a target. A rule has a pointer to its ipt_entry
> in entries blob.  struct rule should simplify iteration over a blob and
> avoid blob's guts in code generation.
> 
> Signed-off-by: Dmitrii Banshchikov <me@ubique.spb.ru>
> ---
>   net/bpfilter/Makefile                         |   2 +-
>   net/bpfilter/rule.c                           | 163 ++++++++++++++++++
>   net/bpfilter/rule.h                           |  32 ++++
>   .../testing/selftests/bpf/bpfilter/.gitignore |   1 +
>   tools/testing/selftests/bpf/bpfilter/Makefile |   5 +-
>   .../selftests/bpf/bpfilter/bpfilter_util.h    |   8 +
>   .../selftests/bpf/bpfilter/test_rule.c        |  55 ++++++
>   7 files changed, 264 insertions(+), 2 deletions(-)
>   create mode 100644 net/bpfilter/rule.c
>   create mode 100644 net/bpfilter/rule.h
>   create mode 100644 tools/testing/selftests/bpf/bpfilter/test_rule.c
> 
[...]
> +
> +bool rule_has_standard_target(const struct rule *rule);
> +bool is_rule_unconditional(const struct rule *rule);
> +int init_rule(struct context *ctx, const struct bpfilter_ipt_entry *ipt_entry, struct rule *rule);
> +void free_rule(struct rule *rule);
> +
> +#endif // NET_BPFILTER_RULE_H
> diff --git a/tools/testing/selftests/bpf/bpfilter/.gitignore b/tools/testing/selftests/bpf/bpfilter/.gitignore
> index 7e077f506af1..4d7c5083d980 100644
> --- a/tools/testing/selftests/bpf/bpfilter/.gitignore
> +++ b/tools/testing/selftests/bpf/bpfilter/.gitignore
> @@ -2,3 +2,4 @@
>   test_map
>   test_match
>   test_target
> +test_rule
> diff --git a/tools/testing/selftests/bpf/bpfilter/Makefile b/tools/testing/selftests/bpf/bpfilter/Makefile
> index a11775e8b5af..27a1ddcb6dc9 100644
> --- a/tools/testing/selftests/bpf/bpfilter/Makefile
> +++ b/tools/testing/selftests/bpf/bpfilter/Makefile
> @@ -11,6 +11,7 @@ CFLAGS += -Wall -g -pthread -I$(TOOLSINCDIR) -I$(APIDIR) -I$(BPFILTERSRCDIR)
>   TEST_GEN_PROGS += test_map
>   TEST_GEN_PROGS += test_match
>   TEST_GEN_PROGS += test_target
> +TEST_GEN_PROGS += test_rule
>   
>   KSFT_KHDR_INSTALL := 1
>   
> @@ -19,9 +20,11 @@ include ../../lib.mk
>   BPFILTER_MATCH_SRCS := $(BPFILTERSRCDIR)/match.c $(BPFILTERSRCDIR)/xt_udp.c
>   BPFILTER_TARGET_SRCS := $(BPFILTERSRCDIR)/target.c
>   
> -BPFILTER_COMMON_SRCS := $(BPFILTERSRCDIR)/map-common.c $(BPFILTERSRCDIR)/context.c
> +BPFILTER_COMMON_SRCS := $(BPFILTERSRCDIR)/map-common.c $(BPFILTERSRCDIR)/context.c \
> +	$(BPFILTERSRCDIR)/rule.c
>   BPFILTER_COMMON_SRCS += $(BPFILTER_MATCH_SRCS) $(BPFILTER_TARGET_SRCS)
>   
>   $(OUTPUT)/test_map: test_map.c $(BPFILTERSRCDIR)/map-common.c
>   $(OUTPUT)/test_match: test_match.c $(BPFILTER_COMMON_SRCS)
>   $(OUTPUT)/test_target: test_target.c $(BPFILTER_COMMON_SRCS)
> +$(OUTPUT)/test_rule: test_rule.c $(BPFILTER_COMMON_SRCS)
> diff --git a/tools/testing/selftests/bpf/bpfilter/bpfilter_util.h b/tools/testing/selftests/bpf/bpfilter/bpfilter_util.h
> index d82ff86f280e..55fb0e959fca 100644
> --- a/tools/testing/selftests/bpf/bpfilter/bpfilter_util.h
> +++ b/tools/testing/selftests/bpf/bpfilter/bpfilter_util.h
> @@ -7,6 +7,7 @@
>   #include <linux/netfilter/x_tables.h>
>   
>   #include <stdio.h>
> +#include <string.h>
>   
>   static inline void init_standard_target(struct xt_standard_target *ipt_target, int revision,
>   					int verdict)
> @@ -28,4 +29,11 @@ static inline void init_error_target(struct xt_error_target *ipt_target, int rev
>   	snprintf(ipt_target->errorname, sizeof(ipt_target->errorname), "%s", error_name);
>   }
>   
> +static inline void init_standard_entry(struct ipt_entry *entry, __u16 matches_size)
> +{
> +	memset(entry, 0, sizeof(*entry));
> +	entry->target_offset = sizeof(*entry) + matches_size;
> +	entry->next_offset = sizeof(*entry) + matches_size + sizeof(struct xt_standard_target);
> +}
> +
>   #endif // BPFILTER_UTIL_H
> diff --git a/tools/testing/selftests/bpf/bpfilter/test_rule.c b/tools/testing/selftests/bpf/bpfilter/test_rule.c
> new file mode 100644
> index 000000000000..fe12adf32fe5
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/bpfilter/test_rule.c
> @@ -0,0 +1,55 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#define _GNU_SOURCE
> +
> +#include "rule.h"
> +
> +#include <linux/bpfilter.h>
> +#include <linux/err.h>
> +
> +#include <linux/netfilter_ipv4/ip_tables.h>
> +
> +#include <stdio.h>
> +#include <stdlib.h>
> +
> +#include "../../kselftest_harness.h"
> +
> +#include "context.h"
> +#include "rule.h"
> +
> +#include "bpfilter_util.h"
> +
> +FIXTURE(test_standard_rule)
> +{
> +	struct context ctx;
> +	struct {
> +		struct ipt_entry entry;
> +		struct xt_standard_target target;
> +	} entry;
> +	struct rule rule;
> +};
> +
> +FIXTURE_SETUP(test_standard_rule)
> +{
> +	const int verdict = BPFILTER_NF_ACCEPT;
> +
> +	ASSERT_EQ(create_context(&self->ctx), 0);
> +	self->ctx.log_file = stderr;
> +
> +	init_standard_entry(&self->entry.entry, 0);
> +	init_standard_target(&self->entry.target, 0, -verdict - 1);
> +}
> +
> +FIXTURE_TEARDOWN(test_standard_rule)
> +{
> +	free_rule(&self->rule);
> +	free_context(&self->ctx);
> +}
> +
> +TEST_F(test_standard_rule, init)
> +{
> +	ASSERT_EQ(0, init_rule(&self->ctx, (const struct bpfilter_ipt_entry *)&self->entry.entry,
> +			       &self->rule));
> +}
> +
> +TEST_HARNESS_MAIN

When compiling selftests/bpf/bpfilter, I got the following compilation 
warning:

gcc -Wall -g -pthread -I/home/yhs/work/bpf-next/tools/include 
-I/home/yhs/work/bpf-next/tools/include/uapi 
-I../../../../../net/bpfilter    test_rule.c 
../../../../../net/bpfilter/map-common.c 
../../../../../net/bpfilter/context.c ../../../../../net/bpfilter/rule.c 
../../../../../net/bpfilter/table.c ../../../../../net/bpfilter/match.c 
../../../../../net/bpfilter/xt_udp.c 
../../../../../net/bpfilter/target.c  -o 
/home/yhs/work/bpf-next/tools/testing/selftests/bpf/bpfilter/test_rule
In file included from test_rule.c:15:
../../kselftest_harness.h:674: warning: "ARRAY_SIZE" redefined
  #define ARRAY_SIZE(a) (sizeof(a) / sizeof(a[0]))

In file included from /usr/include/linux/netfilter/x_tables.h:4,
                  from /usr/include/linux/netfilter_ipv4/ip_tables.h:24,
                  from test_rule.c:10:
/home/yhs/work/bpf-next/tools/include/linux/kernel.h:105: note: this is 
the location of the previous definition
  #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + 
__must_be_array(arr))

