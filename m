Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFE412880A5
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 05:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731455AbgJIDUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 23:20:07 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:39128 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725909AbgJIDUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 23:20:06 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09939Wj2000585;
        Thu, 8 Oct 2020 20:19:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : mime-version :
 content-type : content-transfer-encoding; s=facebook;
 bh=j9p+JwA9GiWjMENtycaItPKMFoms7oH4JmdRzUOIio8=;
 b=b3M1jckxIj5BBnhm71SLcpTzmxOzz9sR5o74B7l5hycmbknOjO5KJIHk+p2iTKyDfJXt
 XAC7+JAtN+D+CGw8pDUSqGeVsyRg+QtFeV6n/ROJK8xXmvZ+qxCvp9kTz6QQXEky9DJe
 Q+S82W48JZDTLGbggwdig32+8Jzb4lp8v/k= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3429jq9j5k-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 08 Oct 2020 20:19:51 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 8 Oct 2020 20:19:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YYzutlqj8EHz83IKyiyMRzJRoxjaN3pcVqsqZDkaW7F1myGtI6ajayOG/beVd8+UTejgiVOcWCVoas5c+Ygggj1NOUKF8EXatkaWDNT8oSusUwwmp7cMsmYFz5VE9g6gGnzkaNN+A/zS73G3ejbVTk5m76cGklrff8CE8RRY6hhC3GONapeS3FYH3peV5FnyLb0XtnYUZnzLGm1t9/V//cKz6737PW2zD9VIx+PvXbEjpDlPCRjGFluLZS7RD3Fi5haAOVS24cYzGucZpt18KNORE/K0N/IIbE87St5kEe6DRvS+yUuy4oFF2b7pDEjMEATY86kgJgzpRjGBicsO2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j9p+JwA9GiWjMENtycaItPKMFoms7oH4JmdRzUOIio8=;
 b=L6sccn0tRxC1OTmM4gKInRhM+dszUe8ofZtPGhMstPuqAPKX0M9vedFDPcR2UkKlrTbGJfdBdlLFyYLw0/ulMkUSujSGHbOPx0TJfweAkxm66IJDkVvH0mn/1owe52V45x15Zw0eNqVvMHZKixENVQpKjw/py6qMVB6MU/WqMZ7ejFJzjxWNNWCU6AHs1yQHEnq7KOzob9UPAfhJxF0deBLgCkTfWOVB5JXsWgMYfQKakuVDJ5LnbqxlanRll9b7OPiGlnb2zsPqIL7fnJF8P/iABXy6AI2y4TpbuFrGW6T2GjRAc/ig5DpvFOaGnNS0yr8mIGWv55bo9x8NSyjggg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j9p+JwA9GiWjMENtycaItPKMFoms7oH4JmdRzUOIio8=;
 b=UNCskPkP1RpKbFGsdkHhfWP2WT+BgKI3xPV2knbxGwZXXZEC+NPLerTGDfp0tNQTT5FfNChvRTUb3qUutJgT9hNkY85+ks45elFxTzvRRandDOPUZ+Pd53HirbSoRUY9hmq75PRYtRB705S6mP9go8Qmd9Cg8VYZKbAvwzjByA8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2727.namprd15.prod.outlook.com (2603:10b6:a03:15b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.22; Fri, 9 Oct
 2020 03:19:50 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42%3]) with mapi id 15.20.3455.024; Fri, 9 Oct 2020
 03:19:50 +0000
Subject: Re: [PATCH bpf-next 3/6] bpf: allow for map-in-map with dynamic inner
 array map entries
To:     Daniel Borkmann <daniel@iogearbox.net>, <ast@kernel.org>
CC:     <john.fastabend@gmail.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
References: <20201008213148.26848-1-daniel@iogearbox.net>
 <20201008213148.26848-4-daniel@iogearbox.net>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <6137b220-3678-af3c-8cee-c1b5d2a6e4e1@fb.com>
Date:   Thu, 8 Oct 2020 20:19:47 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
In-Reply-To: <20201008213148.26848-4-daniel@iogearbox.net>
Content-Language: en-US
X-Originating-IP: [2620:10d:c090:400::5:68ff]
X-ClientProxiedBy: CO1PR15CA0086.namprd15.prod.outlook.com
 (2603:10b6:101:20::30) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::1844] (2620:10d:c090:400::5:68ff) by CO1PR15CA0086.namprd15.prod.outlook.com (2603:10b6:101:20::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.23 via Frontend Transport; Fri, 9 Oct 2020 03:19:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c272c7e6-5f6a-4fff-fedb-08d86c022e51
X-MS-TrafficTypeDiagnostic: BYAPR15MB2727:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2727F0FA26ED4F60601F4D70D3080@BYAPR15MB2727.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oadPYIAUAYXTOXTDx8UGNqsCUEbiN/d/4maAqbrn2MINlKlumeN0PeDFr42sxLBLoNxFJA3XukGuMjtOhha5slbgrUgXGH3pqhh2NDwjkZBxe0JzpaGUZ88V0zS0Lhwhr7yZfiWm2+73x0Lcy/d8NJud3tEj+ZipH5sGgpTHeTgzynta+l3eCVSITpcm4yz+dJApbUD7pmmzSXiCKTJBtKAbfOk+q715LEMWsYj1bQHDLxzY9ZAYWQ99DnsoAI6W9A9wxxGELfxrFVJtpdsy/sbuEmRYm5J7WbiZ5buwF9cgum9LgV8X5rCUZdv2qvEIsTEqbbp8+A0af3gUsvoyPRLnzy8p1xKsoM4q8IAnmZdCWvihvAHjn1pXeNTnMJNA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(366004)(346002)(39860400002)(376002)(31696002)(53546011)(16526019)(186003)(86362001)(316002)(478600001)(66476007)(66946007)(66556008)(83380400001)(8936002)(8676002)(5660300002)(31686004)(6486002)(52116002)(4326008)(36756003)(2906002)(2616005)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: RHhBRCXKY05H2XPT6K1SVL7nmsG9pgIuq+/mqud2Be1D042lg2GjmzMdPyHpkhCfaQNfX14Gs2ZnJROrbxOEpRMF/8g9kYrfjxAjFnDUp8WtC7OOAT7dAPeDwiNXS9mX3NWI3Jjn5MnLdMYmHjALXG1Xo6EpJqSI3QRfSSH97/ja8POGG008SrC04AsYcxjshbrzMhm+Re/qPooSlJnGV6q4czgjumOQwzia2wR2dWT/GeD2WyQ/cYN0N8ld53WngnyML3iXDpAx1lr79cmFFsNmFzKOGjUf4Fc99oEQGqXTpoxzwBs4Xu/w0gYiqS0Pwjyd8PEJN2Vd9nbPJrcCKsCHcowYqqryGmy2Sezt5uo/GZy+3taN2doIhwYm2PsHSAdMvVrTmy3LzU27vW9ZiA68Y/ckAqreZxOkf0F4HYuq1WFrinDmjCfJ2Au3HtVi+b3pUqTxygMU7VnisieXPOjLaMau9Iv+Rk0pyU3GnNeHHp4iTKW3taXy2UPoN80+95M7WlGW/UYnzGLKlhr6UpX26XrjBS0AKicVIEwTUZ+SOFNqKuU1JxaZ7qmCh5NFu0dYlUN6Ksx94GpUNV9guAc25D/fy1FtTYePb/Xltx9tr9Rfdx04pUvEHPGnVAgCuzBly5oiS07fGz6tv1qXzGyEqDTgymSbrePW/xKSP9M=
X-MS-Exchange-CrossTenant-Network-Message-Id: c272c7e6-5f6a-4fff-fedb-08d86c022e51
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2020 03:19:50.1232
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c3GRjfrD83DcyreQMHuLoMdaGSTRRRAcyzlMQKi9ygtJSS2iAs3pKLuSePpp0YaD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2727
X-OriginatorOrg: fb.com
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-09_01:2020-10-09,2020-10-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 mlxscore=0
 lowpriorityscore=0 phishscore=0 impostorscore=0 suspectscore=0
 adultscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 priorityscore=1501
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010090022
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/8/20 2:31 PM, Daniel Borkmann wrote:
> Recent work in f4d05259213f ("bpf: Add map_meta_equal map ops") and 134fede4eecf
> ("bpf: Relax max_entries check for most of the inner map types") added support
> for dynamic inner max elements for most map-in-map types. Exceptions were maps
> like array or prog array where the map_gen_lookup() callback uses the maps'
> max_entries field as a constant when emitting instructions.
> 
> We recently implemented Maglev consistent hashing into Cilium's load balancer
> which uses map-in-map with an outer map being hash and inner being array holding
> the Maglev backend table for each service. This has been designed this way in
> order to reduce overall memory consumption given the outer hash map allows to
> avoid preallocating a large, flat memory area for all services. Also, the
> number of service mappings is not always known a-priori.
> 
> The use case for dynamic inner array map entries is to further reduce memory
> overhead, for example, some services might just have a small number of back
> ends while others could have a large number. Right now the Maglev backend table
> for small and large number of backends would need to have the same inner array
> map entries which adds a lot of unneeded overhead.
> 
> Dynamic inner array map entries can be realized by avoiding the inlined code
> generation for their lookup. The lookup will still be efficient since it will
> be calling into array_map_lookup_elem() directly and thus avoiding retpoline.
> The patch adds a BPF_F_NO_INLINE flag to map creation which internally swaps
> out map ops with a variant that does not have map_gen_lookup() callback and
> a relaxed map_meta_equal() that calls bpf_map_meta_equal() directly.
> 
> Example code generation where inner map is dynamic sized array:
> 
>    # bpftool p d x i 125
>    int handle__sys_enter(void * ctx):
>    ; int handle__sys_enter(void *ctx)
>       0: (b4) w1 = 0
>    ; int key = 0;
>       1: (63) *(u32 *)(r10 -4) = r1
>       2: (bf) r2 = r10
>    ;
>       3: (07) r2 += -4
>    ; inner_map = bpf_map_lookup_elem(&outer_arr_dyn, &key);
>       4: (18) r1 = map[id:468]
>       6: (07) r1 += 272
>       7: (61) r0 = *(u32 *)(r2 +0)
>       8: (35) if r0 >= 0x3 goto pc+5
>       9: (67) r0 <<= 3
>      10: (0f) r0 += r1
>      11: (79) r0 = *(u64 *)(r0 +0)
>      12: (15) if r0 == 0x0 goto pc+1
>      13: (05) goto pc+1
>      14: (b7) r0 = 0
>      15: (b4) w6 = -1
>    ; if (!inner_map)
>      16: (15) if r0 == 0x0 goto pc+6
>      17: (bf) r2 = r10
>    ;
>      18: (07) r2 += -4
>    ; val = bpf_map_lookup_elem(inner_map, &key);
>      19: (bf) r1 = r0                               | No inlining but instead
>      20: (85) call array_map_lookup_elem#149280     | call to array_map_lookup_elem()
>    ; return val ? *val : -1;                        | for inner array lookup.
>      21: (15) if r0 == 0x0 goto pc+1
>    ; return val ? *val : -1;
>      22: (61) r6 = *(u32 *)(r0 +0)
>    ; }
>      23: (bc) w0 = w6
>      24: (95) exit
> 
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>

Acked-by: Yonghong Song <yhs@fb.com>
