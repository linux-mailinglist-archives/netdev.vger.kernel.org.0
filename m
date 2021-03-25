Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF19434958D
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 16:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbhCYPbi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 11:31:38 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:37755 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231499AbhCYPbV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 11:31:21 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 12PF9UY0028096;
        Thu, 25 Mar 2021 08:31:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=DBx9lPFQ1/zCFPxoN2F8DmeqNSGUCNhtq3lupgjSUN4=;
 b=Ecitwmw9SkCWycvjgcz3LLNoHJoe+YW2mxCWP/98aEA5y0o7wGqAXhBLrOSKfpk389m9
 zSUEGVhVLeNQvlwcGuqRnMRxGi/gL1+snAvrbQq2/w3TVSQf4eSi80Kgx2N9gAyGWKpJ
 CvLa56amGB+tI+oOC3Af6wJSG9u/4KuScTU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 37gt01s7ye-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 25 Mar 2021 08:31:08 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 25 Mar 2021 08:31:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LK4XDkpyem+ORYQzih2jk1L67f/kGrFjZN31dGwmSg/jdHtGm/GE4ZLPMWpwh0xgrYz/gQNzExq/vNRzzh1O1B9rqR7wVIMrJIoHZarBUbwopWniG+PGuWpXFePT9UfM2mwumuaNac6OblrquR1Q/4ko1E1dH2hshvkHrt5X4c4uIvzQJEAMDnjd10MhZaDTCVE3sF1mzGL8iCqmpJNPOSMTmQQPqk6d3GVdcCjRNqzMO19HnUuGY4yHt3ty3QS7F6oztLLRUY8nDlIm88waNKIeL8JLUUPUap9deso2izFOZSYYRmPnJLc1ixgfFMTImDh7b/X8iGbBZgtN08pUiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DBx9lPFQ1/zCFPxoN2F8DmeqNSGUCNhtq3lupgjSUN4=;
 b=GPJpG1gb7lr06iLU2eUQVvcnK1SuNA3cIEVJe/Ah6m7MXiuf3Gi8vkaTOqcyS1p3qxC12xpmQa+mD6glwypWiSqtwgaOrW89522KdHtPgd9pP0om+ZpJjqogzBLaJUGPykcDKtbz8N07Km4yKzrTEuioejXlF/j3+lxV/0i/glBt0b/VgDihJuthhfB+h8sGny++vEHBY1iTvpG6l+Zkwyb13KXLC/o1jcBGqLkEm56m9cSN6/RO+imG12QoeV/GkX3eA1/tRTj3oCNrlCbEy6HMpWDzMe1RvlswlV3PUJ45E8VqNNTAaQN2ndx+zJAVSyM17Y4GgYUay/tEEESTTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4385.namprd15.prod.outlook.com (2603:10b6:806:190::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.26; Thu, 25 Mar
 2021 15:31:06 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.3977.025; Thu, 25 Mar 2021
 15:31:06 +0000
Subject: Re: [PATCH bpf-next] libbpf: preserve empty DATASEC BTFs during
 static linking
To:     Andrii Nakryiko <andrii@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <kernel-team@fb.com>, Alexei Starovoitov <ast@kernel.org>
References: <20210325051131.984322-1-andrii@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <c2e9328c-1998-d921-c875-c1d53c5a5d9a@fb.com>
Date:   Thu, 25 Mar 2021 08:31:02 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
In-Reply-To: <20210325051131.984322-1-andrii@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:fb7e]
X-ClientProxiedBy: MWHPR03CA0011.namprd03.prod.outlook.com
 (2603:10b6:300:117::21) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::150c] (2620:10d:c090:400::5:fb7e) by MWHPR03CA0011.namprd03.prod.outlook.com (2603:10b6:300:117::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Thu, 25 Mar 2021 15:31:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 29a07a11-b241-4e2f-566f-08d8efa301c8
X-MS-TrafficTypeDiagnostic: SA1PR15MB4385:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB4385D1DD96245C7965EE0DFCD3629@SA1PR15MB4385.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iXbk/h5h2Dst3LvSudMv8F4Bz6PbunjmiaJbQajdwcApI2Dur5k9MKfhqIPagWGmHL2Lm2vOgfvj4naja8Jqh0k81c/eyiPAza9JoU7aaCWI/vsekYsKO5G/wNMo4UmGprQZsBMHiIO7nsXFbtbO3Ria36h7xPGEn4v5SHFzpP+T4vfJ+xz8lhchmNnthjZGGNeFOG3zI0ypWYdSVb6jabt9IYsa17gxqEDGI0dtiuXmjI401HF1E9I9at9g+oM5rpPPlx0fuqZfP1EJAUM/ACiO2lelG4gBZkqCpqIt87kHYyh9NCpsAlS9HgUFYi+HnJozTc7QWOjwT8t0ZDP1S8nLnL2cGhv+WK+zeVEHHh5hSntmeTs92JdAdlmc8QR+fKvcYO1/42b05U6yd812yvJx9IL3EZuU+bQPPB+iGAA+UOdEd2CLicT270pHBu8da8gpYZn0UnoNfZup7yUlGSdKsJQJAB0yERWl5EP+1cTHqf5kQb7TOBHrkFMhUukx76sIqeM9FkYivfgZOsE9FI2PdZxtJPU/GfeDgkc8i4q6YEQ8UJXjsvysLzJFlae7wOS1bqfdH2Ecs4DHv9vXmDeyvX3seUNAqywYwshGaC6plhbPo8Ry0m2Z/MYwcuZGHwxXEtCFjzGrO53PkQnTBCB5nN2J4wDUM9lUDtXJ/AsxslYSSyRSR2PaUUVmY/pkr8vPSs9s70BkPkwmRAggbw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(346002)(396003)(366004)(39860400002)(6666004)(53546011)(2906002)(66556008)(66476007)(36756003)(2616005)(66946007)(83380400001)(8676002)(478600001)(31696002)(8936002)(316002)(86362001)(5660300002)(38100700001)(52116002)(4326008)(31686004)(186003)(6486002)(16526019)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?aHRDakIzQVNsa2lnVlpaa2FKMnV5UXNtV2F4VnAxTDhwVlVOYnpmY0FSaGRo?=
 =?utf-8?B?RzRCTjJTTGNoYnZrdlY2RTdRTkxEOVhiVFJpTFBkMEpsQVZweEFXcXZ6amlE?=
 =?utf-8?B?djZGVEowSFp1ZmdNQktKamZGS3FEWE82a3RqOVRsQitZUkdxeG56My92RVo1?=
 =?utf-8?B?UTJwbHFXRCszZHB6R1I4T1RkZUo4ai9PNUh5Nyt0N2hQVC9aYUR5YjAzYXJY?=
 =?utf-8?B?d2lmbUR6aWllbVBWd0xnOGIzVjdINFBmZ2dFME14R1puSWI0QUdqVEJvY1B4?=
 =?utf-8?B?ODlmV2dleEhWNHZVeENaM25DNlMxbWJLQkd5Qm1sTEVFZVFIbEI3RklubG5D?=
 =?utf-8?B?bGVleERuemxiRnhSa0licTVhN2xZbjlnYWYyODExYTlVK2lsckZubGcveXdv?=
 =?utf-8?B?RzRMbEp4Mng1QWlwYzNzbTVXZkxkTWhlL0JrY2dTanB1YmVkdWY2NVVxWXo0?=
 =?utf-8?B?U0xwYkdGb2l3YmIwUDVWK1BxcHAwbW9WRkpNS3lXWWxvTzdmTVFPVVg4SGg2?=
 =?utf-8?B?cVpPL05kYUFOSDNBcHdkRndUN0YxRFBiZ1h2Mmt2N0xYWk1ZQmpSTC93bGtP?=
 =?utf-8?B?QlF4ZVZYYjRORlR3SHQyZTFMbjZlNVNXTTJ4LzU3bFdLSkhYNCtpai9qSUZZ?=
 =?utf-8?B?UlhDbktmN29nWlJaWFR0aWR4U2JBbTlFRW00YTdCNXFHQ1RXYzlSSEt0eDZt?=
 =?utf-8?B?V3hTS29YRTVVMUZTR2hQTy96WSs3a3pQMGdDVkZiRXpVaFhUUWxOQ0xmakcw?=
 =?utf-8?B?ZExQZjBqRWp4SWFHbWVCSkhnRzl6SDE3cEY4a3g3UENzemY4UVBSbStKNStC?=
 =?utf-8?B?Sy9icGxzNVFzZE9iYWRQWDE5SWp4MnZvRGVqQmE0ZUJ3Y0pxZ2ZodTNiRGFH?=
 =?utf-8?B?QkloN1N3NldEb2pKZXZicjBsT2dSK1ZiWGk1RGcydlpYMnJyd1locFV3elky?=
 =?utf-8?B?b3FCZHdoUE5qUmRxR2R0TU9Fa1pBNXhLREZlY1VyNXJFTW5ZVVNzRksxQVNU?=
 =?utf-8?B?VkR5VlQrREdHcmlhQ0NTMzg5cVFnL3psTGQ4MnNPSmp6M01xMUk3QUVkNmQw?=
 =?utf-8?B?NFg3WEEwREFSV3k3RlZUMXlKSENKaUdmWmpMNWZ0ck0vRnZySHd3NElRem9T?=
 =?utf-8?B?QVRNaFNteWMySGVFTE1Da0s0Um14UGFmNktRQ2FCNHJYM2NYRkRFbjU2RDA0?=
 =?utf-8?B?aUtPNkNIYjkvNmtXWEFNZ3pUajZqZ08rMXlwOW9LOS9JMkxvZzFkdlJaUklL?=
 =?utf-8?B?OHJnZXRpQzFIZ09POTI5MXZPcEs5UVpkWkJ6Z08rNXdLS21VZkFYM3M4aC9K?=
 =?utf-8?B?MnFWY3JENmk2UVN1MkZXSys4L0pMK2psS090bUFTN0xtWWpvNEtEWDlMQ1ow?=
 =?utf-8?B?TEl6eWU1MXduVEdPYjRUaXBJUkhMc2JhZEh6d2JIb1FGZFJ2RWk3TVRyYTBL?=
 =?utf-8?B?ZThkWWNMVXQ0dWhuUGRDUlR5cEgwVTUrMWFJcGJxa09YZE9DRURwclNHZC8z?=
 =?utf-8?B?N1IrUWlYQnduV0lqcHU3OXJmQ1pTb3N5NDNKZG8wVVNmcndqYVM1WnNYNFUv?=
 =?utf-8?B?ME9VTzF4bWM1Tzh1YVVqK1lZbWUwWXVoQjhwTzk3ckJpbVprMGNRcWJRYmpW?=
 =?utf-8?B?Z2VBUCtyU3lmSHFybzI3bm9LenVCQUJEUUpITE9BQWJETnhKRG1UL2RxalBX?=
 =?utf-8?B?eU1aQnBSUGFTSURwQXdsY09LNnpxWGRRa0lCUkw2MFdDSWpZYUJJc3lMVStP?=
 =?utf-8?B?YUtrR3RlcXFYMDlOOXFOSmxpWE5zTkdqOGRRcy95d1ZXVnJtLzd1c2xWQWYz?=
 =?utf-8?B?Q1lRcDV1RnJmN3JFMVpnQT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 29a07a11-b241-4e2f-566f-08d8efa301c8
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2021 15:31:06.2398
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FvDYRGuNkn5ONz1TiYJxm2qvMmYsVosB7vaMTWr9vzmffI8xtO00vQFEoUPo9jDs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4385
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-25_04:2021-03-24,2021-03-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 bulkscore=0 suspectscore=0 lowpriorityscore=0 impostorscore=0 phishscore=0
 adultscore=0 mlxscore=0 priorityscore=1501 spamscore=0 mlxlogscore=999
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103250111
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/24/21 10:11 PM, Andrii Nakryiko wrote:
> Ensure that BPF static linker preserves all DATASEC BTF types, even if some of
> them might not have any variable information at all. It's not completely clear
> in which cases Clang chooses to not emit variable information, so adding
> reliable repro is hard. But manual testing showed that this work correctly.

This may happen if the compiler promotes local initialized variable
contents into .rodata section and there are no global or static 
functions in the program.

For example,
$ cat t.c
struct t { char a; char b; char c; };
void bar(struct t*);
void find() {
   struct t tmp = {1, 2, 3};
   bar(&tmp);
}

$ clang -target bpf -O2 -g -S t.c
you will find:

         .long   104                             # BTF_KIND_DATASEC(id = 8)
         .long   251658240                       # 0xf000000
         .long   0

         .ascii  ".rodata"                       # string offset=104

$ clang -target bpf -O2 -g -c t.c
$ readelf -S t.o | grep data
   [ 4] .rodata           PROGBITS         0000000000000000  00000090

> 
> Reported-by: Alexei Starovoitov <ast@kernel.org>
> Fixes: 8fd27bf69b86 ("libbpf: Add BPF static linker BTF and BTF.ext support")
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>

Ack with a nit below.

Acked-by: Yonghong Song <yhs@fb.com>

> ---
>   tools/lib/bpf/linker.c | 12 +++++++++++-
>   1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/lib/bpf/linker.c b/tools/lib/bpf/linker.c
> index 5e0aa2f2c0ca..2c43943da30c 100644
> --- a/tools/lib/bpf/linker.c
> +++ b/tools/lib/bpf/linker.c
> @@ -94,6 +94,7 @@ struct dst_sec {
>   	int sec_sym_idx;
>   
>   	/* section's DATASEC variable info, emitted on BTF finalization */
> +	bool has_btf;
>   	int sec_var_cnt;
>   	struct btf_var_secinfo *sec_vars;
>   
> @@ -1436,6 +1437,15 @@ static int linker_append_btf(struct bpf_linker *linker, struct src_obj *obj)
>   			continue;
>   		dst_sec = &linker->secs[src_sec->dst_id];
>   
> +		/* Mark section as having BTF regardless of the presence of
> +		 * variables. It seems to happen sometimes when BPF object
> +		 * file has only static variables inside functions, not
> +		 * globally, that DATASEC BTF with zero variables will be
> +		 * emitted by Clang. We need to preserve such empty BTF and

Maybe give a more specific example here, e.g.,
For example, these static variables may be generated by the compiler
by promoting local array/structure variable initial values.

> +		 * just set correct section size.
> +		 */
> +		dst_sec->has_btf = true;
> +
>   		t = btf__type_by_id(obj->btf, src_sec->sec_type_id);
>   		src_var = btf_var_secinfos(t);
>   		n = btf_vlen(t);
> @@ -1717,7 +1727,7 @@ static int finalize_btf(struct bpf_linker *linker)
>   	for (i = 1; i < linker->sec_cnt; i++) {
>   		struct dst_sec *sec = &linker->secs[i];
>   
> -		if (!sec->sec_var_cnt)
> +		if (!sec->has_btf)
>   			continue;
>   
>   		id = btf__add_datasec(btf, sec->sec_name, sec->sec_sz);
> 
