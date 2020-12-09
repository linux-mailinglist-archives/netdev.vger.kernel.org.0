Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CFA72D4908
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 19:31:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733099AbgLISa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 13:30:28 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:53666 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726449AbgLISa2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 13:30:28 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B9IP8Mb025112;
        Wed, 9 Dec 2020 10:29:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=+OEqiiYcoRE9+DuZaQFZgD8YRc+Z4xH1L7hH/hSDK+0=;
 b=dVWX3SF5jCHczK0sFUDENz+4ziVIn3mz5bz7V7NQlUHLTsBU1ysv3J8Ybbb8Q95LaZd+
 UU/zavj73g155euqGk3Jo7MKFRdUy8eypkB1SfCO3LQgasSbigioOIuL8i0MLJCbRgCy
 G2SEozH5xyEhpL0s1sgHMc30y3J+1awB768= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35b3erg7sm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 09 Dec 2020 10:29:31 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 9 Dec 2020 10:29:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=evJ5TRWHiOzMzXX3H139kAJp4PCIDN8WTKs+Y6oMxDLljprfUgb2Jg/6W+NMVXpDACqpot3VHv0X4PzUzI04im/xDvMqlmmq3gfH/eZ+7mxRqBtlvNRBIEwR2k236MhjQKx97PircZHIxNWIac6hs2YD25aOF4FG+hLj95fK1+0cluEZvh4B7z1m+3ZRsAJFg5igMh9j0bpxcEduKytAwJpULWnXGW8AzXiX+TBTwH/DhGQJQhjKpJ/5Io5y1KVwL8xl8vGpt7Qk4lKLgAhLmbgvONlHcTvTULvR7RWjbdsKv1QuHIZARKW2PoPZ+Q1DmNRr5RF6gasOAga0RuOBWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+OEqiiYcoRE9+DuZaQFZgD8YRc+Z4xH1L7hH/hSDK+0=;
 b=MdGw1/3mIi2ZRpQ7jIc/t1eQlZ7xlbSmei9wljms+/osD27YNqdXkx99hoRu1njfKe0yZr5t+aQ503SKQ8w5KnqXNKSPDAp4T2WvsKO22QRbdGpAjlMEElMAaukbpGOq19AmE2VVVYd7iXTrhz9Pnz+lZnXNgqFg7l04gmfCVWyQCgx8GUf6LsWpn9clrIAIQUNnZ1w2JFbJGZk+S7rWivORMZ/AxF/GTHpn6IbxaZTMkUFniJ4c3/f/efrRim8Mf183wkmFlAV2eKxO64DV+FbG0VaVrlsSGn1CcusB28n+rVUsuZNor/kqKM735wcPsVK9TJwehExOASpATMCg0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+OEqiiYcoRE9+DuZaQFZgD8YRc+Z4xH1L7hH/hSDK+0=;
 b=PHoIz5rsWY3hHgYlGjL1m6xKliNFG7wxCn1NEFDhv7e20npp39hkoF/ll3/2xDNMX3HaxTfi+xQtHNScWi+9u+2Jog+TgQHlxPs8UVenKgP7qyox89sxbR9r1fMtlMpBE+9oZ5a3pqsa3T5yhdOu2ZIA3u2fQG3RUOrwVoGJtMI=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2725.namprd15.prod.outlook.com (2603:10b6:a03:158::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21; Wed, 9 Dec
 2020 18:29:27 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3632.021; Wed, 9 Dec 2020
 18:29:27 +0000
Subject: Re: [PATCH bpf-next v4 2/5] selftests/bpf: xsk selftests - SKB POLL,
 NOPOLL
To:     Weqaar Janjua <weqaar.janjua@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <daniel@iogearbox.net>, <ast@kernel.org>,
        <magnus.karlsson@gmail.com>, <bjorn.topel@intel.com>
CC:     Weqaar Janjua <weqaar.a.janjua@intel.com>, <shuah@kernel.org>,
        <skhan@linuxfoundation.org>, <linux-kselftest@vger.kernel.org>,
        <anders.roxell@linaro.org>, <jonathan.lemon@gmail.com>
References: <20201207215333.11586-1-weqaar.a.janjua@intel.com>
 <20201207215333.11586-3-weqaar.a.janjua@intel.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <760489c0-f935-437d-6213-6e8775693bbc@fb.com>
Date:   Wed, 9 Dec 2020 10:29:25 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
In-Reply-To: <20201207215333.11586-3-weqaar.a.janjua@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:3517]
X-ClientProxiedBy: SJ0PR05CA0022.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::27) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::113f] (2620:10d:c090:400::5:3517) by SJ0PR05CA0022.namprd05.prod.outlook.com (2603:10b6:a03:33b::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.5 via Frontend Transport; Wed, 9 Dec 2020 18:29:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eb43c8d2-d3b8-4734-2a63-08d89c705c66
X-MS-TrafficTypeDiagnostic: BYAPR15MB2725:
X-Microsoft-Antispam-PRVS: <BYAPR15MB27252145F7DC007CFEFA7510D3CC0@BYAPR15MB2725.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d+qbOXx7mdF/s+zCuupabeED0Oi9Sd8Jz5bALoo2SzSAPP/h3j2Qxo8HD27cI4alYzv17XfklckHqJYWouLna5vHRFjNKMETsYEstgAIqIbbI0q3wneGAN7X+jScKk6S2/Cc5OlkoxZOvFluL179RCLgv9KHGe1OMS3g6ojlq6VeQ84emtz5OEPKvQN55Eo7eTjNceVhJI1eENumlwph9Nc+oRapk/rdAdGZ9+2DB8P0ynCpp3nByXhVOGWh4+N+RmTqrN0GV1eLbWCn/efhgoiNCsdPtuY7wawSk/0fH1ki76aNhRLzCsTR32KFM2CEM54fbzl4TlSflAVeLlhLO3/zXqIZ5u83nujm1grRhd+2ckh04Oqq4EehhOJ+bPyGJQVvEM+3oN8rJuFep8M11ZXmSHOCuGb7z4mN57QHZIU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(136003)(366004)(8676002)(2906002)(36756003)(8936002)(31686004)(66556008)(508600001)(31696002)(52116002)(4326008)(6486002)(66476007)(53546011)(83380400001)(186003)(5660300002)(2616005)(16526019)(86362001)(66946007)(7416002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MDZqNnZHRkdzVmE0bWZOdHNabmRyMnIzLzRuWVVYK3NZVXBCU3k4Lzd0YUJK?=
 =?utf-8?B?ZkJGeXhkM0N6SUFyQWhSTWlNNXBhS0JmUDhqckcxeUhscVlnK1JSZmJJRzVS?=
 =?utf-8?B?dWhjaEJSVktFZ2ZsZTJtZk9pZGRIOUNmSmgwSGJRSlIyRlNoRjQvQ1VvTVdk?=
 =?utf-8?B?a0l2Zy9ueUwyMk9kTzBqNm9Kc1pPUDROY3B0RmNjOFRSTzZGZXRnUVo4YjFZ?=
 =?utf-8?B?eTVWTXdmRFpmbWQ3eXkyOGtTRlRjLzdidXhRNDFzcXpDWVgrdnFkZWtiSXpJ?=
 =?utf-8?B?QmhjL2Z0SmxrZlRYeEk4V3M2K0xDSTNRMWF3YjdLY0dPMFBvMTMrNUVVMjgz?=
 =?utf-8?B?SjBOUHFxT3VBeDRTQlFMUitOeWtMTE42Y28xQTVSU3o2Z21DNWpkWnM3UDRI?=
 =?utf-8?B?cUZJd1BoQmYrMzhFeHNYYTVsS0JmM2xyVmlCaFZRdDdDQ1UwaUdWK0s0RkQ5?=
 =?utf-8?B?ZURHQkZTYm5jTkdKSUdFa2JFUE00cHd5bFdOQkc4U0FPbGlqV0NlRFNIdHBC?=
 =?utf-8?B?TzNqY09LNThPRTNHNHRBb3VMb0ZMelFTOHMxMFpOSDVHRTJ3ZTlOT0FSOE94?=
 =?utf-8?B?b05jL1J6aDY4OU5rcEtoKzQ2OXhicEpabWtHNTVjK1B0cUJuMW9uUFhSNmU5?=
 =?utf-8?B?UjhiUzJXeHUvcXd3N3daQXFJK3E5ZG5ZRnhESUVTaFg3aWR5S2g2NFNSRUJk?=
 =?utf-8?B?dnRzcWVjQ0VDTnJtaWduRU9YN1kvMEQwa1lITnkrTy9ocE5tYzZpTFFocXdk?=
 =?utf-8?B?ZFRTa1hSY01RQkg0cUo5dWtyWEpaVFJXeU9TUkFORURlZlFDWm5MWjR0NVdY?=
 =?utf-8?B?STh4cXlXWVEvQ1BlTi9hLy8rNEE1OHBDKzZId015NG1LdDFUQk51a0R1L0pM?=
 =?utf-8?B?NUh5bFozTkpmUkRXRUVmWjFZQTlSWloyRGtwTCs2S00wZkhhMVUwdnZOWWlC?=
 =?utf-8?B?NE1VY0N3eHRZSEx1bWtadWpnUjRDSDdtdGZRa0d3bVBKanMwQkRkY0ZUQ3pw?=
 =?utf-8?B?RUJaQ3luRG5BNXcvMzFtdVQwR0Jmb01XeVBtRG45cmFzNWhBZXRWZnl1UVJh?=
 =?utf-8?B?cThKZzcrcjBXNldyVXR3eEF5RUd6dEIzcUQ5OTJJUHdXYkxOd1c3TmRjYzY1?=
 =?utf-8?B?NUZwR2lRQjlWR3NrbFBaWlVmM2NReStiaTdSZnZnc211TjdSM2I4bXNXbzU3?=
 =?utf-8?B?OG84M2FuR3BPdndJYkVuNXBMU3NXT1N4T09HTmlQblFxdWF0UE1QUm9heisz?=
 =?utf-8?B?UkUvaDZHRHlLMFdKMHA5N2NoYWh3d0RINzhDZGlOWnBCT0QwWEVDTXlra3hh?=
 =?utf-8?B?VCs2RnZJNUZJeEN6STFtNS9lQlUwMGw4U0hnVVpBUGdOK2R2dHB4dkVYdHFF?=
 =?utf-8?B?ZWtVRjFRa2ZDSkE9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2020 18:29:27.1975
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: eb43c8d2-d3b8-4734-2a63-08d89c705c66
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iAGat96yljikAYCEdI0RybuOObrQHbGuK6SYIt3jSXmlSZc7UJpMU4SEeJ9x03AD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2725
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-09_14:2020-12-09,2020-12-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 suspectscore=0
 phishscore=0 lowpriorityscore=0 spamscore=0 impostorscore=0
 priorityscore=1501 clxscore=1015 bulkscore=0 adultscore=0 mlxlogscore=823
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012090131
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/7/20 1:53 PM, Weqaar Janjua wrote:
> Adds following tests:
> 
> 1. AF_XDP SKB mode
>     Generic mode XDP is driver independent, used when the driver does
>     not have support for XDP. Works on any netdevice using sockets and
>     generic XDP path. XDP hook from netif_receive_skb().
>     a. nopoll - soft-irq processing
>     b. poll - using poll() syscall
> 
> Signed-off-by: Weqaar Janjua <weqaar.a.janjua@intel.com>
> ---
>   tools/testing/selftests/bpf/Makefile       |   3 +-
>   tools/testing/selftests/bpf/test_xsk.sh    |  39 +-
>   tools/testing/selftests/bpf/xdpxceiver.c   | 979 +++++++++++++++++++++
>   tools/testing/selftests/bpf/xdpxceiver.h   | 153 ++++
>   tools/testing/selftests/bpf/xsk_prereqs.sh |  16 +
>   5 files changed, 1187 insertions(+), 3 deletions(-)
>   create mode 100644 tools/testing/selftests/bpf/xdpxceiver.c
>   create mode 100644 tools/testing/selftests/bpf/xdpxceiver.h
> 
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index 6a1ddfe68f15..944ae17a39ed 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -82,7 +82,8 @@ TEST_PROGS_EXTENDED := with_addr.sh \
>   # Compile but not part of 'make run_tests'
>   TEST_GEN_PROGS_EXTENDED = test_sock_addr test_skb_cgroup_id_user \
>   	flow_dissector_load test_flow_dissector test_tcp_check_syncookie_user \
> -	test_lirc_mode2_user xdping test_cpp runqslower bench bpf_testmod.ko
> +	test_lirc_mode2_user xdping test_cpp runqslower bench bpf_testmod.ko \
> +	xdpxceiver

Could you have a patch to put xdpxceiver in .gitignore?

I see below:
Untracked files:
   (use "git add <file>..." to include in what will be committed)
         tools/testing/selftests/bpf/xdpxceiver

>   
>   TEST_CUSTOM_PROGS = urandom_read
>   
