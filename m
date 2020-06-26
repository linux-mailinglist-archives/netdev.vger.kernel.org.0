Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 257B820B52B
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 17:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729988AbgFZPpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 11:45:14 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:37952 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726013AbgFZPpN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 11:45:13 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05QFik6m013667;
        Fri, 26 Jun 2020 08:44:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=GKusuX7U3LUHpxOLlUwLXkOPJA/dGz1aQMl2PYv4mWs=;
 b=MQOZKaXDykElbuw3p0TazprVs1U7kJHRTMODXoRi/ullXniksp0s9jsAVoc6dvywM4aY
 SuWHub3OoQjwBPD9pIewe4IuwY03P/3MF7XU34s6MltrqHnzmr7Z1mnkokbnqj8Fv6Im
 THcwHi+byUDaTZACen8yK29OTP6R5i0aZTY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31ux1ewysn-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 26 Jun 2020 08:44:48 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 26 Jun 2020 08:44:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mTLKqhFHos3XF9Rc3gpMUrLbmg8XX70dKu4IL5ZNJC43DC6gi+ZOsGu4HESnugx9lzNxfp8XX0AOT/D1nneHEkDyurc040yuaTwQjSL5KhTiptSDmUzYThkT7NJFupgwKE1jPvuGxxKWBCTMTjfnV02jb7CLjKsH2Be1z5E7wHUwOpqXkza+kMkfYqGqatrYkl176C6unRU9sRA5q9rBbIzKuipEykW7Wtj+Im52QKo8/sA2XNKA9qOTrcBxE3zTjh3aIODdFPp94MrB+ORf856CsB5/zAg6wc+6dQkI/Xxff0t9nwtKbZ3uawxSGmjGYFij8Jg13/s8naMpiTNp5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GKusuX7U3LUHpxOLlUwLXkOPJA/dGz1aQMl2PYv4mWs=;
 b=kIfLNbuh6r4t/bV/MnClUFwZCmWTyImeQ6n6cgbgdwPNfpGVjYGruL/CJufoP7iIIPwz3gu1J6TXdUjvmt+g1Cwpk64KVjCHUgrgeeppFn9JjJ6soLJQ1SZFtpZks1hdCZbU/NT+de3OUSc8xR3Q4kwJFyD0kTWMavi/aam5tKt7RwMd9cejSwxpCH6gvhcxtA2krMwD1GIhb0eOBY1lL3PAYHOssy5xu6Y9jRR+S+g1bSeU5tP6dJmY99QthQvkafYHn1FJcb2aKMj2FzQtqPRPVoGi7BSRiCUe0FpMw+ZcxB2Uaej1GBzW1d21DK1FAWfN5ac2JbxsNBsbz3E21g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GKusuX7U3LUHpxOLlUwLXkOPJA/dGz1aQMl2PYv4mWs=;
 b=ZDG07VuYkK+nt42xXqOKiVNI1D7N+WXYj+Jbg8VfVkoX3j/bGFpV/lhXvfOjbYF/KG0UUCYe1pKR+yEsp8aY3ADwdL3r32IPDOs8lIXB/g3/x6cdWkTKdQxpqQKxwrUbsOaKOFKLniUOYb1agEVIbWBRWGw/eLPROqSWVqJwVZU=
Authentication-Results: chromium.org; dkim=none (message not signed)
 header.d=none;chromium.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3094.namprd15.prod.outlook.com (2603:10b6:a03:ff::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.23; Fri, 26 Jun
 2020 15:44:18 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.3109.033; Fri, 26 Jun 2020
 15:44:18 +0000
Subject: Re: [Potential Spoof] [PATCH v2 bpf-next 3/4] bpf: allow %pB in
 bpf_seq_printf() and bpf_trace_printk()
To:     Song Liu <songliubraving@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <peterz@infradead.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <kernel-team@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@chromium.org>
References: <20200626001332.1554603-1-songliubraving@fb.com>
 <20200626001332.1554603-4-songliubraving@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <808e5374-564f-da07-86d6-2636e79331ce@fb.com>
Date:   Fri, 26 Jun 2020 08:44:16 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
In-Reply-To: <20200626001332.1554603-4-songliubraving@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR08CA0013.namprd08.prod.outlook.com
 (2603:10b6:a03:100::26) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::18ce] (2620:10d:c090:400::5:ca25) by BYAPR08CA0013.namprd08.prod.outlook.com (2603:10b6:a03:100::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.23 via Frontend Transport; Fri, 26 Jun 2020 15:44:17 +0000
X-Originating-IP: [2620:10d:c090:400::5:ca25]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5ebd078c-1746-4814-e7ce-08d819e7c99a
X-MS-TrafficTypeDiagnostic: BYAPR15MB3094:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB3094870DB388CC0E29D27F06D3930@BYAPR15MB3094.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:78;
X-Forefront-PRVS: 0446F0FCE1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4VJxRIaZvu/vz4Rx/8tGFx1Tk5ykUq3rMxFVmN9L56ixlP2bdh2haet3DXH2jQujKggFuYbZoBX9Gp3G6nZJtUVkF/QJz9D9qQAkKdnk2eJHGMuo9YwHyVbJD9mBKtWgt6ePrBco16ksA4tQx+uE4eta38XJ+uP4URTLcuTW6Dqehbp3fkSW1nJuI5Qgs4sug+dse5ytgWcngrgZuBMj3YON68+HSYU3HwsF4e2prSK04ZmQQty4UB8YzXl+HAP1mWlIdZJrJzIGIEmDlhG6Ph1z4mbPwXpEcnYlHlDwEo5xP6h3VdAdZG1WhtHGuxmZnCSxPxWt4UBMVrumE/7ZJSVttfNeMgjuTOnanGA2bENzKvrZTakCpZUAfhGOMQEs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(366004)(376002)(39860400002)(346002)(396003)(31686004)(6486002)(4326008)(52116002)(2616005)(186003)(66946007)(5660300002)(66476007)(16526019)(66556008)(478600001)(36756003)(316002)(2906002)(8936002)(8676002)(31696002)(83380400001)(86362001)(53546011)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: a16kJisvXaZnBSbawmtB1ns3m8l0dIGy6JstepMVCbPD41Wln1lWO7raXTt4GTnvAOfoe8zH6UVi70rKTYo8FWz9jncYTrgJJVNP3AMgrrT8nVERfZE4AxttPnseOwUXEmY4WBuA0RwVWywaK+P78HRrETvs61h59aKmOucgK0bC4afFhq6ejmw/VJIgtRJownyKB+uLxn1Q/hcCtgd3kQefx1x5KL+l5fH+N65uoNIaWhtGrbRSOapS/PIMRrTzXOcm2GYxixmOX7aRZrjqeGtPWmA9Ovwtgn3j8B9Bm3bRgbmEpsIS9cSdgJOCoaISga4I+obhEg6hIw/90SGER2w4jGW9eRfiv/RoOoR8qn02dKXqUPJ3u8eGzma0ND4E1sUWbI1DuIkPDzOc4gfW6R1B9GjOR2e/PqpSeXanwP4qsghqsTClhQ1EhiX0e511/GpdQPivFYIbY4YjLD6LXJKa6yXdwrNbJO9B+KB6V8Qkuscja/Y9baYvFChWGivl3MNqjZsRfBF7tz04uulpBw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ebd078c-1746-4814-e7ce-08d819e7c99a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2020 15:44:18.5326
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DddL4yor6SB+TNHYRetk09Ghw/VLy+8HmYo1Egt+L+WB7l5MG85Sm1qfgyP1p/Yn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3094
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-26_08:2020-06-26,2020-06-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 clxscore=1015 cotscore=-2147483648 spamscore=0 mlxlogscore=999 bulkscore=0
 adultscore=0 phishscore=0 priorityscore=1501 malwarescore=0 mlxscore=0
 suspectscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006260110
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/25/20 5:13 PM, Song Liu wrote:
> This makes it easy to dump stack trace in text.
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>

Ack with a small nit below.
Acked-by: Yonghong Song <yhs@fb.com>

> ---
>   kernel/trace/bpf_trace.c | 12 +++++++++---
>   1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index 65fa62723e2f8..1cb90b0868817 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -376,7 +376,7 @@ static void bpf_trace_copy_string(char *buf, void *unsafe_ptr, char fmt_ptype,
>   
>   /*
>    * Only limited trace_printk() conversion specifiers allowed:
> - * %d %i %u %x %ld %li %lu %lx %lld %lli %llu %llx %p %pks %pus %s
> + * %d %i %u %x %ld %li %lu %lx %lld %lli %llu %llx %p %pB %pks %pus %s
>    */
>   BPF_CALL_5(bpf_trace_printk, char *, fmt, u32, fmt_size, u64, arg1,
>   	   u64, arg2, u64, arg3)
> @@ -420,6 +420,11 @@ BPF_CALL_5(bpf_trace_printk, char *, fmt, u32, fmt_size, u64, arg1,
>   				goto fmt_str;
>   			}
>   
> +			if (fmt[i + 1] == 'B') {
> +				i++;
> +				goto fmt_next;
> +			}
> +
>   			/* disallow any further format extensions */
>   			if (fmt[i + 1] != 0 &&
>   			    !isspace(fmt[i + 1]) &&
> @@ -479,7 +484,7 @@ BPF_CALL_5(bpf_trace_printk, char *, fmt, u32, fmt_size, u64, arg1,
>   #define __BPF_TP_EMIT()	__BPF_ARG3_TP()
>   #define __BPF_TP(...)							\
>   	__trace_printk(0 /* Fake ip */,					\
> -		       fmt, ##__VA_ARGS__)
> +		       fmt, ##__VA_ARGS__)\

Accidental change?

>   
>   #define __BPF_ARG1_TP(...)						\
>   	((mod[0] == 2 || (mod[0] == 1 && __BITS_PER_LONG == 64))	\
> @@ -636,7 +641,8 @@ BPF_CALL_5(bpf_seq_printf, struct seq_file *, m, char *, fmt, u32, fmt_size,
>   		if (fmt[i] == 'p') {
>   			if (fmt[i + 1] == 0 ||
>   			    fmt[i + 1] == 'K' ||
> -			    fmt[i + 1] == 'x') {
> +			    fmt[i + 1] == 'x' ||
> +			    fmt[i + 1] == 'B') {
>   				/* just kernel pointers */
>   				params[fmt_cnt] = args[fmt_cnt];
>   				fmt_cnt++;
> 
