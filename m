Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6B642880C8
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 05:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731530AbgJIDpE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 23:45:04 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:7126 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726386AbgJIDpE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 23:45:04 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0993iBtW027494;
        Thu, 8 Oct 2020 20:44:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : mime-version :
 content-type : content-transfer-encoding; s=facebook;
 bh=QYyRAjaKoipNwUPqFSc+WpREu2R2byEfUW4v3ONECQQ=;
 b=P6egG8F5PhZDfn5JgR4wKkESjIM7z1rBeDA5RYckxHMIQhz4jZ+94G9O/YKnM3RuLW3/
 LJHFY+UMHUElPu50EUWGg3hu9Ud13dP4iJadZtD7UufK8N+V/SRg/fg0BYbbYQbbs6ar
 EzRHLXm9znibxF2tRJ7//+CXHKPe3admCDk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3429j51n6x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 08 Oct 2020 20:44:50 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 8 Oct 2020 20:44:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fWQcWyYf2DJt7b72Yw8+jos2BKR9ao2EGuGFfpL153V5VywqWcJKqo7QSR6s5JfFwFyvoFLFMw1n7D9zNiXraoFstFBGpUMFaSEl9ogWUJnwJfAHZc2tILEGYjOUky6sPTSuxsiA9Pz6sXR3tiNHJooPRuIWF9fxYy6nhxTpu0H1gpE/cyE9B116iJA+J3zKvHG5eIRksLtKJDcFgPXqZBN6zeEA6wOk4rMI9uBPrpxyrOeeDwi6v7SB0fAPlygXva0FkCfPjsch5TDXxJlJEJ9dZy6iIR0hjK8e4CeOzctq5DDwW6xsSq5EAX3c4wbgHHDSZLBkmd5GQxaOHMPAzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QYyRAjaKoipNwUPqFSc+WpREu2R2byEfUW4v3ONECQQ=;
 b=bigDsOdmoxKFIBCYl0XjSyH3As8oVM+KQrjLfzjLeirrLid/RGLe2dvCA31Fas6LnzfcXEso09S13PacCa5KpZfxiTlkdPJ4DuNaV4dgc3FnzNDpnmbDkaANDUS7PWbHPj4GWoQIFg1ez3E2YRwcj4HotVkEwExnzkEb6B6umDR0QnhdbHMnLjQaXjbG97D1Yl3mXvAlgvbzOLbkPWpMz0+SvJtsJ6Esc2+74NbYuP9L2vBjeUh/8MORdZokY7vwVpiQgAdW3jOPiXEKh9DTnbUPcrUeqTT/9KuzHGjYme9VFRN2XuIdy00k5pjfrbJzwyPeGN4noSGEWH2NyM1TTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QYyRAjaKoipNwUPqFSc+WpREu2R2byEfUW4v3ONECQQ=;
 b=UXkDyh8qoNjmpmWAGgcTGgOLjDwrmkpDDINatoje2X3DuG5fRDn3y9DGpTuzvaYKYS7K8Sl+oodRpChuUXSLeMzdfFQZNpam40or2wl4OL8EHXkvN0WpLNrtBszGmrOjb1ODn3TAMX6qlQzNC3wFm3pxBJaVJZWRMdxofL0rinI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2328.namprd15.prod.outlook.com (2603:10b6:a02:8b::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.38; Fri, 9 Oct
 2020 03:44:47 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42%3]) with mapi id 15.20.3455.024; Fri, 9 Oct 2020
 03:44:47 +0000
Subject: Re: [PATCH bpf-next 4/6] bpf, selftests: add test for different array
 inner map size
To:     Daniel Borkmann <daniel@iogearbox.net>, <ast@kernel.org>
CC:     <john.fastabend@gmail.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
References: <20201008213148.26848-1-daniel@iogearbox.net>
 <20201008213148.26848-5-daniel@iogearbox.net>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <79b58368-03d5-29cf-241c-1fb0dae5ee14@fb.com>
Date:   Thu, 8 Oct 2020 20:44:45 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
In-Reply-To: <20201008213148.26848-5-daniel@iogearbox.net>
Content-Language: en-US
X-Originating-IP: [2620:10d:c090:400::5:68ff]
X-ClientProxiedBy: MWHPR19CA0008.namprd19.prod.outlook.com
 (2603:10b6:300:d4::18) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::1844] (2620:10d:c090:400::5:68ff) by MWHPR19CA0008.namprd19.prod.outlook.com (2603:10b6:300:d4::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.25 via Frontend Transport; Fri, 9 Oct 2020 03:44:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c7f58781-abdb-4e37-55e8-08d86c05ab30
X-MS-TrafficTypeDiagnostic: BYAPR15MB2328:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2328B5721F824F96CC5ECFD0D3080@BYAPR15MB2328.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /GQcMNf5aXhFNivAUO8WONTWfb2acnLiJ7/2576E79Va9VBp5Fs2hWw0HTC/092asi6OcaHZNx9ouZHz3eAQBSPypypeujj55SBNL/p5AAsGPxs9cwe7azb2AEo+SNLquZOQOqSdWu3N+RbJsKRrbEoAq/cLb3Py5GvhHdJVZ7ACOBaJYnYtI43BdEErM4uzWEkd0EeCPMXjwTnsTFxvwzR9OMGzFOSy/bP23IJj6b9q+am1Fib7H0OdzklYPm7fGWfEi0hrmzU1yepOPzKOKOb2uiYxXljh7uZjiIXE9Q7dCu2jVcNqwqUHGUlhGcjFbuWQWNJN/KJFRGlECsVhz0opDapM0jPO6HjuEKOjB75xteMezpYzNs4ORJDBQO7R
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(136003)(396003)(376002)(346002)(186003)(66946007)(2616005)(83380400001)(8676002)(4326008)(53546011)(66476007)(66556008)(5660300002)(8936002)(86362001)(31686004)(16526019)(2906002)(478600001)(6486002)(316002)(36756003)(31696002)(52116002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: AkwSl8aa7fSCa5W4ocFNTzyt2l23tCtFDg4CrEAlrs4IgAaQ8iyB92nZWujqvOZ4C9/lUq3N2tirFJH2Z0pW8drpjYnjjGQDEuoYoJWFzmiqHJLvhN9COQgQdl96RJlbAQKxAnFMZI7YMIciXL5PdOYPwn/TFhwNvJzL3MFPhUh1FnC5gRPGqjoUu5Fn+HOuO+dZyGeDHNsZKp48N/MvLL30px4EF3gIbNtef5xM10BwRyUTTKqMjKc/xDQlUBRNGQ6Vp9Z8cuzQCHOfhh1RBHMaoJzxTanTHYDFM/r2moVdK4jvWn87RhBwyHrIDY38jh5LdCazQXx0QlI+pJ51288QxAdoFxBaSCW3LHJ3i79yI+lwBW4VEnbYPEo2MIR9ikd1eWnhpRllSxaSzRAW8lx2bOJZMjaQFl1casfoqmCwEMp/PS6W3duYPppY6cOH/fBx06l5cELyTiSrqHljCTbmaJtMCDvSVNP1Nbr8c+m3rCqz3pLe4naatOpBeOG13HC9qo6q0781kPgO4gfIwKMdOfp4DljG6BwjrL7Rx+tE4OMMfrmPAadioVC5oiFG7iz92AC/SYFzy3DlvfXcU0FsGzjc8sOs8hCiejCq0JnBDvys2bM4faVhskTj1sG1CJT6OC+5qWnDW7pVwdNYqZbNvkvHg1IIOdvfhveyla76J+dp3j+sjXr8bHH+9x3f
X-MS-Exchange-CrossTenant-Network-Message-Id: c7f58781-abdb-4e37-55e8-08d86c05ab30
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2020 03:44:47.8691
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SM7Am/fX2whZBqL/+KXN35agyC/HsrzmhIRk4XlPtHO1L7wrwr3kj7dEDlSkySPM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2328
X-OriginatorOrg: fb.com
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-09_01:2020-10-09,2020-10-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 bulkscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 mlxscore=0 malwarescore=0
 priorityscore=1501 impostorscore=0 phishscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010090024
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/8/20 2:31 PM, Daniel Borkmann wrote:
> Extend the "diff_size" subtest to also include a non-inlined array map variant
> where dynamic inner #elems are possible.
> 
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>

Ack with a minor comment below.

Acked-by: Yonghong Song <yhs@fb.com>

> ---
>   .../selftests/bpf/prog_tests/btf_map_in_map.c | 39 ++++++++++++-----
>   .../selftests/bpf/progs/test_btf_map_in_map.c | 43 +++++++++++++++++++
>   2 files changed, 72 insertions(+), 10 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/btf_map_in_map.c b/tools/testing/selftests/bpf/prog_tests/btf_map_in_map.c
> index 540fea4c91a5..e478bdec73b8 100644
> --- a/tools/testing/selftests/bpf/prog_tests/btf_map_in_map.c
> +++ b/tools/testing/selftests/bpf/prog_tests/btf_map_in_map.c
> @@ -55,10 +55,10 @@ static int kern_sync_rcu(void)
>   
>   static void test_lookup_update(void)
>   {
> -	int err, key = 0, val, i;
> +	int map1_fd, map2_fd, map3_fd, map4_fd, map5_fd, map1_id, map2_id;
> +	int outer_arr_fd, outer_hash_fd, outer_arr_dyn_fd;
>   	struct test_btf_map_in_map *skel;
> -	int outer_arr_fd, outer_hash_fd;
> -	int fd, map1_fd, map2_fd, map1_id, map2_id;
> +	int err, key = 0, val, i, fd;
>   
>   	skel = test_btf_map_in_map__open_and_load();
>   	if (CHECK(!skel, "skel_open", "failed to open&load skeleton\n"))
> @@ -70,32 +70,45 @@ static void test_lookup_update(void)
>   
>   	map1_fd = bpf_map__fd(skel->maps.inner_map1);
>   	map2_fd = bpf_map__fd(skel->maps.inner_map2);
> +	map3_fd = bpf_map__fd(skel->maps.inner_map3);
> +	map4_fd = bpf_map__fd(skel->maps.inner_map4);
> +	map5_fd = bpf_map__fd(skel->maps.inner_map5);
> +	outer_arr_dyn_fd = bpf_map__fd(skel->maps.outer_arr_dyn);
>   	outer_arr_fd = bpf_map__fd(skel->maps.outer_arr);
>   	outer_hash_fd = bpf_map__fd(skel->maps.outer_hash);
>   
> -	/* inner1 = input, inner2 = input + 1 */
> -	map1_fd = bpf_map__fd(skel->maps.inner_map1);
> +	/* inner1 = input, inner2 = input + 1, inner3 = input + 2 */
>   	bpf_map_update_elem(outer_arr_fd, &key, &map1_fd, 0);
> -	map2_fd = bpf_map__fd(skel->maps.inner_map2);
>   	bpf_map_update_elem(outer_hash_fd, &key, &map2_fd, 0);
> +	bpf_map_update_elem(outer_arr_dyn_fd, &key, &map3_fd, 0);
>   	skel->bss->input = 1;
>   	usleep(1);
> -
>   	bpf_map_lookup_elem(map1_fd, &key, &val);
>   	CHECK(val != 1, "inner1", "got %d != exp %d\n", val, 1);
>   	bpf_map_lookup_elem(map2_fd, &key, &val);
>   	CHECK(val != 2, "inner2", "got %d != exp %d\n", val, 2);
> +	bpf_map_lookup_elem(map3_fd, &key, &val);
> +	CHECK(val != 3, "inner3", "got %d != exp %d\n", val, 3);
>   
> -	/* inner1 = input + 1, inner2 = input */
> +	/* inner1 = input, inner2 = input + 1, inner4 = input + 2 */

The changed comments sound not right.


>   	bpf_map_update_elem(outer_arr_fd, &key, &map2_fd, 0);
>   	bpf_map_update_elem(outer_hash_fd, &key, &map1_fd, 0);
> +	bpf_map_update_elem(outer_arr_dyn_fd, &key, &map4_fd, 0);
>   	skel->bss->input = 3;
>   	usleep(1);
> -
>   	bpf_map_lookup_elem(map1_fd, &key, &val);
>   	CHECK(val != 4, "inner1", "got %d != exp %d\n", val, 4);

We have inner1 = input + 1 here.

>   	bpf_map_lookup_elem(map2_fd, &key, &val);
>   	CHECK(val != 3, "inner2", "got %d != exp %d\n", val, 3);

inner2 = input here.

> +	bpf_map_lookup_elem(map4_fd, &key, &val);
> +	CHECK(val != 5, "inner4", "got %d != exp %d\n", val, 5);
> +
[...]
