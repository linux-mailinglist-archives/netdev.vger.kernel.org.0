Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6C563AA08F
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 17:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234660AbhFPP7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 11:59:35 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:33906 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234753AbhFPP7L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 11:59:11 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15GFuOlV025368;
        Wed, 16 Jun 2021 08:56:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=5p66hSDnIqtJGAMoXjpHYFo5SnG4G1+Rtsf5clffh5M=;
 b=crBWsyBVgznKMVBkPA8THyySBJmIario0ORVfvx6sQlRih+KbpUyvguWMhIPopoJwdqL
 ozS8fnKEpYIeAcfuNi/Gg+FBSL8Q7AwIY9qxRNj1VAp4MVAmP1knMf1NJ63dRsYPNl5f
 NK3GZD4CBiUeb0KvsPnY/Fi3izjM1YlBcF0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 396x3hyv6q-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 16 Jun 2021 08:56:50 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 16 Jun 2021 08:56:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G91GCsT+NAdCOMfY10M/5RkrWqfBUNUMa09vuB9VrQ4A4oqHTp2P6F8iGP4VGS7yzycgsT8rAm+OdxHznRk179F53b5vG7un0ERiQ/w9WqvTAnZJ0DnLe7sD2JY6a5dAVq1AMEZUwJ0lY2FojIHyLXyLSyvU5RK/R0kFT8L+NrHVv1hNzafOaV3a1bDXWroTcjxRSrQbB0P9s9LHTG/cGG0a+R9ipzDPh4jjWT/F83NKaGJwBLhe8CZPfS4WxOSqbF6guB9NFz9iH+lGjgvAjuql+JiuJJxGkg/bv0+1zxKcuIyw1hxnaMML7cG80WP4H1/BHtsWqkmt+6vpOWatbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5p66hSDnIqtJGAMoXjpHYFo5SnG4G1+Rtsf5clffh5M=;
 b=jexF5zz9Jep6n3FQppykE0lJPssITxQGRtMlUjgQNA7u5CJfy6YsWyGYAgOsRkMEpqEBH29ocu+cIIs8m+b/E1Fx9xrwrz/N0mEJQD93h2EQf/6aqFyIlzcaOD9HNq2Gpl2LXt7A+rpAP71U0HwxVWi5yDlLYalgWhvzvilXw8sJL7X85RcU0IHJnTPnFG3iyjCuKrZ4/bPklle6BJkWfDe7+kWjNNFXUtgh6Eye/SGZG4jG8e7Eevd02WZa65o4aDThFH6InKSd3OIO5x4xwAvV4bcONBQrhAcCG5ZK+GNED30MB3kx6LPgFDDg5jQ7dXILBgtlQXJ8G95OCx2+iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA0PR15MB3822.namprd15.prod.outlook.com (2603:10b6:806:83::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Wed, 16 Jun
 2021 15:56:45 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906%5]) with mapi id 15.20.4219.026; Wed, 16 Jun 2021
 15:56:45 +0000
Subject: Re: [PATCH bpf v1] bpf: fix libelf endian handling in resolv_btfids
To:     Tony Ambardar <tony.ambardar@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <stable@vger.kernel.org>, Jiri Olsa <jolsa@kernel.org>
References: <20210616092521.800788-1-Tony.Ambardar@gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <caf1dcbd-7a07-993c-e940-1b2689985c5a@fb.com>
Date:   Wed, 16 Jun 2021 08:56:42 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
In-Reply-To: <20210616092521.800788-1-Tony.Ambardar@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
X-Originating-IP: [2620:10d:c090:400::5:b5ff]
X-ClientProxiedBy: BYAPR06CA0038.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::15) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::11da] (2620:10d:c090:400::5:b5ff) by BYAPR06CA0038.namprd06.prod.outlook.com (2603:10b6:a03:14b::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend Transport; Wed, 16 Jun 2021 15:56:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 85ec8b74-2e59-4344-862c-08d930df5755
X-MS-TrafficTypeDiagnostic: SA0PR15MB3822:
X-Microsoft-Antispam-PRVS: <SA0PR15MB3822CA187EACB633320384EBD30F9@SA0PR15MB3822.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pBuYiNJ9gG/ESJjgJwpASLfZENLRjAY/PnhtvOnqe/DQyonyPzRaaPOiLOZqysY1xRQAzm7bG28yjNOx5/GxtMW/nJ6uSEmvENKV+bjzuy5TwlVPf8LB4jXkdaCgrMNB0wIuz7kyYd2d80ZHjTEvFiUVQDz9lhEULRIR5AHQRFGi9dpkcKec6W2CXwsVZeI/HEAKfdMx1386mPMFTI7Zw7DKq5hH1E8rLVJd62UD4zXKCJYlIX/SCkyhzLLLnY3QrIXrMxbjpM4AsDh6LieLyi2i+iVZ9p1LkfcQlhWV5noeyhfUtErgS4spunBhkDaWADKhMsMelKf4AG8wyAc8AiHl1cLqnCytM8p2/p/Y8AYtrzTyXXe6HdHJsVcGeVZkzjVLHso/4Gm+BDJFOHZT8R0XQUQgQBkObyEjqJjzKeTak1bi4LsnDCERRMCH3/1Q2Rv0HmZR4vbXwFm85G/wPhb046ma4CnKXdzretXwcAb0LtfMt05CsKAMQ6tVn4BWOGpHHsrrOHXOwM8/m+tno3jTIRlPmjHhWhkFgAnQ8M+ZKqhTLzLk19i3scXcG3pMVy8jgsIjMIRMbyUUKP6I0FTKCQZv2C/fHQdYPnvGNQhuaaDMgK5ihjG+/UYNbViiGHHdrmZqJzamYw58N8IIxJLtMDf9DG8qGHEvJb0d9JpmUg3dtY3eOz99jBT4X0Kl+so2aAsNUvvixZqYtpJyWAUL0GgWTg0/2dyxxabn9mnOxXbCbvxLUlZ9fLm42ROmjLK4HZRWsKWFmm2IrEV6Jj7HikICFMAbcmI1ybD7SZ+JgaTBwOqzbRBAoiJAu/uD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(376002)(136003)(396003)(346002)(31686004)(4326008)(186003)(16526019)(66946007)(66556008)(36756003)(53546011)(8676002)(66476007)(478600001)(966005)(5660300002)(8936002)(86362001)(110136005)(316002)(2616005)(31696002)(2906002)(38100700002)(6486002)(83380400001)(52116002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eGZBNWV6TUVVZGJoeDZhWXJPMWxTMHBVb1kzeXJJWEh4Ym5uVnUwTDRabGEr?=
 =?utf-8?B?NDE4eVBGZGc4eFYvMW5wNXpYczNVRDcwU3dKdklKNGs5Zjl3Sm00MU5EZXl6?=
 =?utf-8?B?WnkyeDI3QVpJc243ZFFXUExyZVlxVCtZSVZzM3hKc01zSXh5YnJ1cjMzSVo1?=
 =?utf-8?B?RzMreHI3WUlUYXB3VURGOWxNT3pWU1VzaGQrTzBORmNVcW5ZK1k3SWx5dmtC?=
 =?utf-8?B?TytveUhMd2ZTWTdHYjNJcEtKTHZLVEJaaG9GclNqQUNDUU8yRFYvazJmSFhW?=
 =?utf-8?B?eVNud1JaUWlTU3FrUEFjMnk1RGZOY3Z2RDVRSXRIWlExd3NDWHVxQitBOTVn?=
 =?utf-8?B?K0pSUjFmekVxQ1RpdWVOLzNHYVBFSmQ0L2U3MTF4blN6dHlQdWVTMmtiYlp5?=
 =?utf-8?B?d3NqUXFPbVFHdVNyMFh6K2R6Nm9PaXZzci9BczVkbUFESFoyVU8rOUZ3YWVN?=
 =?utf-8?B?Wi9ZbGFLVy96Wm1IaVV4THdLMXJ1QXNsanpLK1dQNFBad0NLRzN0VER5M3Ex?=
 =?utf-8?B?U1ZTeVQ1VVhHakR2TTdoOGYrek5MTzJyY3NZdUphMkNDa0FlUmlzUWpCQlRI?=
 =?utf-8?B?RmVreE1ZdEhGZ2YzRm53a1R6SDlkc0VMRjVFa0JMaDR6bnphSVJJWVAyQk9U?=
 =?utf-8?B?UW15VVBYdG40OGhpVXl4eWNDOEdUcmNFSWZBdDJ6V1d3bitzVFZPalB1cVJz?=
 =?utf-8?B?YWg2TVdFUDhHRW0yaktCTm1icTR5ZDZaNGpsc3FEYnl4UGEzZHBxYmJOK3NI?=
 =?utf-8?B?bnlPZldQUGdSeVM4NEs1OUE4U1daeUdiQ2hNNVEyTFQ5eG95Q1B5bU9nTVNQ?=
 =?utf-8?B?T2JnaXBwKzRKWnk0WWNWQ1dxTW84THltWERENi9XOUZINy9sWnJaYVMwcXRC?=
 =?utf-8?B?UmV2ZzJFYlk3OUNWbmxwZDJQWGl1K0Z5VkQxYVdGdHk1dmxHam0vaUJVODBO?=
 =?utf-8?B?RGhyd2Fxbyt4VHA0UTBpQS9nMjBzT29pVFZHSWhmdW92TFh4MlVDZFNZY3ow?=
 =?utf-8?B?R2RTRVA3Qk9FVWhSL3hRK0FhNGRsRUxOeDM4eHV5QlhKQVpRK3MrQ2lBQzVD?=
 =?utf-8?B?OTZzMmd0R0c2WVdCc1V1bFVhNUc2Z0ZMVmtjMWlmeEE3cy9yVGQxTXprYzNw?=
 =?utf-8?B?Y004UEFrRCtERzVUbVo0QzJkNVJuTDdDL2JTeERYZ0dZc1VobzlLRnJqTmVo?=
 =?utf-8?B?eGlobTJBV21TMStIK3hJMDhlcGxDL0EvN3RkaTZkMHFnTjh2L3JHcWQrQTNM?=
 =?utf-8?B?bjhHZ293ZDJNbWR4bndQVTZEZVZod3JyQW1rVXU2bWNERU9sNHhWSmQwQlY3?=
 =?utf-8?B?TE5rUjBkejVZdE5hb1I3VjBwMGZicXdEbEZZb0s5c2p5V2pnL2JZOG5pNnpT?=
 =?utf-8?B?d1l5VmwrOXY0ZkZXcmpNMDk2Wk5MejFqRkt1bWkwK2NRVTlDUmhpb0F1VWFs?=
 =?utf-8?B?aDRpNzBaa05pcUw3THg3ZjFEL21vWnVkOTIrd1hCcFcrWHlaakc3MXA5SXpJ?=
 =?utf-8?B?KzJzbi85Rnk5WnhHallyeTBEb21sWHdUSUpkVFROdzh5bWJ4WmJpbnhZamJk?=
 =?utf-8?B?MTBVMHpqcWF5WlA5TVdpUDhOa2JlcForQ0Z3eEw4eUpHMStDdXY0V0MyZDl0?=
 =?utf-8?B?bkFMQkZWdWU3OWpEMm9ka29OY0lMR1QwYUxDTGQ2WWo4YUF3MjJnb0F6VE5s?=
 =?utf-8?B?bllqejVuWFJKQ1k3c2dDcXBBR1YydU5hT2dvaU9rSUt1azY1d1hBbHhGU2ta?=
 =?utf-8?B?UExINy9vakhCMm5Pd0VoY0lwUHhEd1BUY2RlUStwK01ROFVLeTFuRjVpV0E0?=
 =?utf-8?B?eklPbVg5NFRMelIyYmg5UT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 85ec8b74-2e59-4344-862c-08d930df5755
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 15:56:45.1698
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rlkguV2Ry0E4Qgj5vaY7n/COi4r4eh4OVEToyWIrh3etr9zDvuGtNz2CWSXMGsr7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3822
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: 50lc4yqKWaItZR79Mc4Fr1T1x5NFeK9Y
X-Proofpoint-ORIG-GUID: 50lc4yqKWaItZR79Mc4Fr1T1x5NFeK9Y
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-16_08:2021-06-15,2021-06-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1011
 adultscore=0 impostorscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 lowpriorityscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106160092
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/16/21 2:25 AM, Tony Ambardar wrote:
> While patching the .BTF_ids section in vmlinux, resolve_btfids writes type
> ids using host-native endianness, and relies on libelf for any required
> translation when finally updating vmlinux. However, the default type of the
> .BTF_ids section content is ELF_T_BYTE (i.e. unsigned char), and undergoes
> no translation. This results in incorrect patched values if cross-compiling
> to non-native endianness, and can manifest as kernel Oops and test failures
> which are difficult to debug.
> 
> Explicitly set the type of patched data to ELF_T_WORD, allowing libelf to
> transparently handle the endian conversions.
> 
> Fixes: fbbb68de80a4 ("bpf: Add resolve_btfids tool to resolve BTF IDs in ELF object")
> Cc: stable@vger.kernel.org # v5.10+
> Cc: Jiri Olsa <jolsa@kernel.org>
> Cc: Yonghong Song <yhs@fb.com>
> Link: https://lore.kernel.org/bpf/CAPGftE_eY-Zdi3wBcgDfkz_iOr1KF10n=9mJHm1_a_PykcsoeA@mail.gmail.com/
> Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
> ---
>   tools/bpf/resolve_btfids/main.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/tools/bpf/resolve_btfids/main.c b/tools/bpf/resolve_btfids/main.c
> index d636643ddd35..f32c059fbfb4 100644
> --- a/tools/bpf/resolve_btfids/main.c
> +++ b/tools/bpf/resolve_btfids/main.c
> @@ -649,6 +649,9 @@ static int symbols_patch(struct object *obj)
>   	if (sets_patch(obj))
>   		return -1;
>   
> +	/* Set type to ensure endian translation occurs. */
> +	obj->efile.idlist->d_type = ELF_T_WORD;

The change makes sense to me as .BTF_ids contains just a list of
u32's.

Jiri, could you double check on this?

> +
>   	elf_flagdata(obj->efile.idlist, ELF_C_SET, ELF_F_DIRTY);
>   
>   	err = elf_update(obj->efile.elf, ELF_C_WRITE);
> 
