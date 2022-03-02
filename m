Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 042324C9E44
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 08:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237717AbiCBHN3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 02:13:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235356AbiCBHN1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 02:13:27 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFD654551F;
        Tue,  1 Mar 2022 23:12:44 -0800 (PST)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 2224cW9e010191;
        Tue, 1 Mar 2022 23:12:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=/UKVQZ42ZY5rqNBwO47B71AUOuaO9z1X2Ld0QROTa/U=;
 b=JTF0xrscgSS5zfdfiT8NSFcWopE988gRnjk7Qa/eQsC2EXSbfo4zPBswzKQd/y7WeXOV
 7qfnw/rvAY12VcS8XdoZkF2lJHeiAN/eyqYiz8bcSyhJebxe72lOZBL1Yxlybj4bx5rC
 boBhaluREfWIBSAlevqfFl7CM8yRnN26W5A= 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ej1r0ggxg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Mar 2022 23:12:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yz/ifOag/6+YfHG35v0Dqs4SVI2701+zaeyBWoFMOaMMk2DHGMPtd5QzYGdvZrmTnTbb6PFhKq/b2YBkWLyp2fz6WFMNOouTMCw75hiSL3Q5HjuGcTwz6G3ouSSndYcN4/UEEKbfQxAzgN15BBwynvitHPfcTxtUaUmSuVStWfWW0kdsUDQyHZYDVvRD4ShxUtUle0P0TWNVY4qxEOFUawVAm9eWK9OHY2TKiK474u2/C5Dj94OG3W2ULsb3NOlJ3NZw3BBYKqVKKdTh1vaBxsTLpn4P5QZrxy0T422itOXANrvOFqfnKKSRSSRI009Kt6bQS99IOccYjlRzMO6GRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/UKVQZ42ZY5rqNBwO47B71AUOuaO9z1X2Ld0QROTa/U=;
 b=MOhyFy6y2AD/Tyjxlp2pTjehDiVNiVcHTPVB8rx8uJZInE3b390VZ4rp+mgnZ6raIezEAd1Q12X0kp34FJBinn+Emp0jQLWZtwhq/q7STJLvpbNgsxl/+2q7lL+NjS0XelEoBOugdkL+0ZDdH1jcnsxXGuKQAqHYcfQwB+1sVc3MgYBvjD+8+QxQZEmUX2/Zkgb/GMEpcOT+ReO3po1Qfg2yTizmX4xA+LOQVy6dBJjdO9e1n3sEjf21BNluHfdESh8f9WEMOW6qukRdkkuBQkWxtfUd4Dh0chAaAX7xn8BrYBKInuEyJd+0YIYvbEh45e/Ks9zm1BvUmw7MFraT1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by BL0PR1501MB4260.namprd15.prod.outlook.com (2603:10b6:208:82::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Wed, 2 Mar
 2022 07:12:29 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::91dd:facd:e7a5:a8d1]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::91dd:facd:e7a5:a8d1%3]) with mapi id 15.20.5017.027; Wed, 2 Mar 2022
 07:12:29 +0000
Message-ID: <dceb436d-76f3-208f-3f68-d7d614259360@fb.com>
Date:   Tue, 1 Mar 2022 23:12:25 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH bpf-next 2/2] bpf, x86: set header->size properly before
 freeing it
Content-Language: en-US
To:     Song Liu <song@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kernel-team@fb.com, Kui-Feng Lee <kuifeng@fb.com>
References: <20220302004339.3932356-1-song@kernel.org>
 <20220302004339.3932356-3-song@kernel.org>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220302004339.3932356-3-song@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0163.namprd04.prod.outlook.com
 (2603:10b6:303:85::18) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9f6bc2e4-e447-4255-d99a-08d9fc1c031d
X-MS-TrafficTypeDiagnostic: BL0PR1501MB4260:EE_
X-Microsoft-Antispam-PRVS: <BL0PR1501MB4260C0CCFBA71EA17A1848EDD3039@BL0PR1501MB4260.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rCg1FDz91pBtOsUDut4kTRxA0aGSoDVh7VrRirOjQKSPC/kpipDggbAM8Ww160zUkRi+ND9+RFzIfdpRqyvKpmbftnOycX+rdJCXhIcPKKT5uu+89ECkG9iv4haPumc9jwteYmCjKsRnTmWQlrdQdokSVlB/CZZA7FyKOQKmY9eB6unevo0mArE6u13Q8aj3lW040pZcb3pXVwy+QTvh91Qn5hgTJcK0QGFACulTsv7Cs+UnKU0MafFq1PMijBfddGoCI2yTZPO0e2e9TAFYnhFldtqFbFHxdtIzsZzLidQe6CtfzimxRkOBvCq5mSdV6FBI/xrrFYV//ti03bxrLSXn4EfSxXRX+aBX2pys829wOUQQiXVZlrnoXJ45px8yb55DGq6FIE7EY10G1q+kYml4Pp7gaLmYjiw6y08iHgFyd3KDowy+3dNxgvlB92WLi3R7F0Ww+tvyz7sXVzQUcnGFWuaLSxe2JdkuxEOCZl4f5jL666w0odVoo8Ezsl+Itta5r0IEjRlrtBvz64I06tE0YEjMhmw82G/uUSzNVXneXwdouBfScmXGc16ZMkKyf5raperAC8q5MA8mTjKl6Icaq9n9X2ZYqW491BEsWnOhElmu3k3KeSWn3skz0MrUqWS1rU/HxDxcNPQmPnAxc87Y0Q94k95BxxMMKtnNPV83KaS8Z1TheHrjbuGm9IRmk0BWpsUd3jgk3NfFGsJ6++JCgklM0QseWElm+R46bohOOH01vdLM0s21AbTlDJcc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6666004)(83380400001)(31696002)(508600001)(316002)(4326008)(66556008)(66946007)(66476007)(8676002)(36756003)(31686004)(186003)(53546011)(5660300002)(6512007)(6486002)(6506007)(8936002)(52116002)(86362001)(38100700002)(2906002)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WisrR2N3cHIwdjUwVERCeTBOeDNkVEV5S3R5dUltTER1dnYrQ3l3aVNkdU13?=
 =?utf-8?B?Ui91UW5qUHBNT21hRlQwbHdNMFJkZGVGby9RNjFKN3ZyMU1vT2lMWEhRRTdl?=
 =?utf-8?B?SVNwZ0hkcThoMTdlNXJ0RnFWSXRjcU1jc1hlcXlMc1lxNkxkWkVKRm5ZU1pa?=
 =?utf-8?B?QkNZdFNPVjFQUjV3NXpoeEprSUxxMzMzbzNVVDJHRCttSjMyUFBmUnB0Vmk4?=
 =?utf-8?B?K1AxQnl3Y2MrSW5Ja0MxWlMwZUJNN3hCc0RSYm8wenVqTzRiSXU3ZWRSKzJp?=
 =?utf-8?B?ZVQrakRYOXc4WmVuek1IMS9SRVpOOG0veDV6d2luVElLSHV1a04wMi9VbDR0?=
 =?utf-8?B?UnZuWThSWDdvU3JOaUhUNmxKd0c0c2h4V3NXcWJEeVZpK25oM2dDczFDSWpq?=
 =?utf-8?B?MTBTTDlacTBGY0lOMnowWUFRdnd3WGt0UnF5R3NCclEvdWxDU0pPbDNXaFhZ?=
 =?utf-8?B?WXJKNnpQa1hQcVQ2L0NuUzM3NW5kcnRXN3pMWE9qeTVCUWh1QjlOMUtwNTVm?=
 =?utf-8?B?WWtSSnhwZFRJQUNLTng3ZnRjVnRVWVNUZ2IyVlU2aGsyMWMwbWdFRysrb0hp?=
 =?utf-8?B?TjN5cDlIWjJZemNBOXEyaDFxbkp4OGhrY1VCbEZGREVPVVhEQmR2V0hxQkxs?=
 =?utf-8?B?M3gvbVFwektXM3dDMVE5TCtORUxlczRSZXN0VHNSKy9oNVZMVmpOTnhKNmFs?=
 =?utf-8?B?ZFFROWN1VXRwQ2dXVExBMlQ1N29mZUtuZ1FMbk9EdDFWRmhkdjhYcXg0K201?=
 =?utf-8?B?NFlSTDhtUXVIdDk0MjE3SHVhaHpOUVlXb09ocVdhVTlTVWN2TFpXanVPR3hk?=
 =?utf-8?B?bEM2ZGlHMkxvVVRMU1dHRlA5Rjl1V0I2MjFFNkJjeU9QQlZyWUh4eEpkdjNu?=
 =?utf-8?B?ZmpYQlFFYmdIcHoxRCtLZWtjMmkwQXlqUkxCQm9OQXdBdzAvc25aL0ZwZG1D?=
 =?utf-8?B?SzRPUjhDdzk0UUQ0TnFkT0I1TXo3V200a0pCYXJ0UFhkZUI3Q01nWGRKQzVI?=
 =?utf-8?B?czFSQ1pERy9vNFliQVloZEdHelYyakordzJtNXg2bGg4aGF4b0kySloxZlJv?=
 =?utf-8?B?YXB5bjhiQ0lJVW8zWnNPSXk3TUVVTjhHcWM2bmxGWGNVa3ZvVWsvaTI0a2FQ?=
 =?utf-8?B?TmhxZERwZkh2Wlo2Q1JObmV6b2loeGRMajEyWG1ZSXFsUmJnSGU4dVQ4ZEFv?=
 =?utf-8?B?SVlxRGxXSElUSFBYWEFYcEtDSE5PREdHb1FCSFkrbko5QWxTdy9oM0ZkbitD?=
 =?utf-8?B?dXpDZFowUzdHbm5yYmJzQ1lQd3h2M2FDZUFvQm1hck82NTlCVjQvQkZ0eUVl?=
 =?utf-8?B?VXl5Z2F5SHBzUjRDR1NxYUM0Rm9BRnZpcjROcE93MnFnc3c4TVVRMXJ5aFVH?=
 =?utf-8?B?WWo3M29GNUJZNTIyTWpzWjFCajdMVExrWUsyNU1rMUEzK0tmaXJ6VlZVYWM2?=
 =?utf-8?B?ck9QNmVPMFFiMC9Yb0NsODBYdGl1TkNVSHRudG9jV2FFc2RXUHg4VnB5QXRl?=
 =?utf-8?B?bWdXeWFUTXBBVHdQdGZWRkd6QS8wVm16YmdNaUZWZGJXajlPQWJzVGxqNHg4?=
 =?utf-8?B?TGROa1lGZWxpU1Mzbng1Q01aZjRFNXF5ZmNYMWRFQzYvbnRUZERPdkVZZHZL?=
 =?utf-8?B?cE13eWFMbnFjUG5IcnpaTVYzcTlvUUpudEU0QnlBZFJ5U2lVaVlwZ1FBd3pY?=
 =?utf-8?B?ZnJHaHJRQVVPdzNvZmoxc0pDZmM0U0ZvK0pxejZrWHNaWHhJcG51c084YWh6?=
 =?utf-8?B?N3FhWjlGdkpNSjc4UURkR2RQeG9qNzJrYUhRYkpsUU9NNGtwcDFCaUJsTFhr?=
 =?utf-8?B?ak9WZndENE9nYmorRjg3WFEwNFNSMTJlOVJXMHFZdXdmTWZITW9Ec3E4bDdC?=
 =?utf-8?B?cDVmQXBIZy9rVjZLcGFtY29pcXUyV2x2VTZFa3hyUTNYQ01GQUFsbXJjazFL?=
 =?utf-8?B?aVJKbWdOTEEyN0JPTTR2M3hrZ0dNZVRoc0ZUOS9GN2dERUlWTTIvMjFOKzZn?=
 =?utf-8?B?QTZPTXBzZkV4NUgzSU11MmRUWnBvRTlrbzJhTFlWR0l0SmhYWjlFemtyRUVz?=
 =?utf-8?B?YmxEYXN2N1ZrNkFubitpcEhYVkZ6MWoxcSt4MmNES0NEVXNScWg2R09BMUhI?=
 =?utf-8?B?bjhteDc5RHJTYmhYODZseE55OVM1TEpwd0ltTmdoZUpGb0dmTnVDYmhHSjRl?=
 =?utf-8?B?RGc9PQ==?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f6bc2e4-e447-4255-d99a-08d9fc1c031d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2022 07:12:29.2145
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RnMgfa9UCsatoUM7rKLOgkJ+Hc2bSxeHCZrNI78XAYbq1s/fvS0sLt2mmJbAu4Ma
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR1501MB4260
X-Proofpoint-ORIG-GUID: Zbikg468Ioa1P-q8tCQnHC7tj1LNnPjC
X-Proofpoint-GUID: Zbikg468Ioa1P-q8tCQnHC7tj1LNnPjC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-02_01,2022-02-26_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 bulkscore=0
 phishscore=0 mlxscore=0 impostorscore=0 lowpriorityscore=0 mlxlogscore=934
 clxscore=1015 spamscore=0 malwarescore=0 adultscore=0 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2203020030
X-FB-Internal: deliver
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/1/22 4:43 PM, Song Liu wrote:
> On do_jit failure path, the header is freed by bpf_jit_binary_pack_free.
> While bpf_jit_binary_pack_free doesn't require proper ro_header->size,
> bpf_prog_pack_free still uses it. Set header->size in bpf_int_jit_compile
> before calling bpf_jit_binary_pack_free.
> 
> Fixes: 1022a5498f6f ("bpf, x86_64: Use bpf_jit_binary_pack_alloc")
> Fixes: 33c9805860e5 ("bpf: Introduce bpf_jit_binary_pack_[alloc|finalize|free]")
> Reported-by: Kui-Feng Lee <kuifeng@fb.com>
> Signed-off-by: Song Liu <song@kernel.org>

LGTM with a nit below related to comments.

Acked-by: Yonghong Song <yhs@fb.com>

> ---
>   arch/x86/net/bpf_jit_comp.c | 6 +++++-
>   kernel/bpf/core.c           | 7 ++++---
>   2 files changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> index c7db0fe4de2f..b923d81ff6f9 100644
> --- a/arch/x86/net/bpf_jit_comp.c
> +++ b/arch/x86/net/bpf_jit_comp.c
> @@ -2330,8 +2330,12 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
>   		if (proglen <= 0) {
>   out_image:
>   			image = NULL;
> -			if (header)
> +			if (header) {
> +				/* set header->size for bpf_arch_text_copy */

This comment is confusing. Setting header->size is not for 
bpf_arch_text_copy. Probably you mean 'by bpf_arch_text_copy?
I think this comment is not necessary.

> +				bpf_arch_text_copy(&header->size, &rw_header->size,
> +						   sizeof(rw_header->size));
>   				bpf_jit_binary_pack_free(header, rw_header);
> +			}
>   			prog = orig_prog;
>   			goto out_addrs;
>   		}
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index ebb0193d07f0..da587e4619e0 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -1112,13 +1112,14 @@ int bpf_jit_binary_pack_finalize(struct bpf_prog *prog,
>    *   1) when the program is freed after;
>    *   2) when the JIT engine fails (before bpf_jit_binary_pack_finalize).
>    * For case 2), we need to free both the RO memory and the RW buffer.
> - * Also, ro_header->size in 2) is not properly set yet, so rw_header->size
> - * is used for uncharge.
> + *
> + * If bpf_jit_binary_pack_free is called before _finalize (jit error),

Do you mean bpf_jit_binary_pack_free() is called before calling
bpf_jit_binary_pack_finalize()? This seems not the case.

> + * it is necessary to set ro_header->size properly before freeing it.
>    */
>   void bpf_jit_binary_pack_free(struct bpf_binary_header *ro_header,
>   			      struct bpf_binary_header *rw_header)
>   {
> -	u32 size = rw_header ? rw_header->size : ro_header->size;
> +	u32 size = ro_header->size;
>   
>   	bpf_prog_pack_free(ro_header);
>   	kvfree(rw_header);
