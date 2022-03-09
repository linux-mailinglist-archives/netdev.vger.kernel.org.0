Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC814D3865
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 19:05:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232623AbiCISF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 13:05:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230361AbiCISFz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 13:05:55 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C358944744;
        Wed,  9 Mar 2022 10:04:55 -0800 (PST)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 2298UOfl017320;
        Wed, 9 Mar 2022 10:04:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=a0IGXKmNJVeadmGulOol9fkc8tYZeEYlmLgvLnmahFg=;
 b=Q1Ra+2ItJcJncIH6vsXAJd398Ejco7Yzwoy1139JTy+oWvuojAPSJefOrz2JUE1FEMQI
 lr3bM3hn52FCXG3kYSwbdEZW92H+HxX7l85P0c3rkX77rqRoVJ5rAZOeGk4rgk3N3I38
 cZG2xwl7HEaXIT3OjEFJamN2m3UmKA7oWFc= 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ep52tu25q-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Mar 2022 10:04:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i3/NCIxYDUVFLbdHKMMRJj309N6stBSNGI0i46EJP8tSrU1oxfku70BVNxPiJPUERJPhxTjL0Z1AuzIykEM7yOD59RLctxqhhiDKByBCP9ThJzZMHIoF0dvox9w2KxgyFmPSafzgbN95Ae/7i7VOqgbFkn4lRk9vguTvZXbKKFx9InqB31EPYxbxwtTBLQ2jyyNGYK6tPUEddRwYf5D/TQokLXJSweKF17/elWY6tM2mM61i80kixr7GlhTbINsTIslpWjxOzG9T6I88r9gLID1y93tbK5gWvDSGP4AWe8+jI1ZHdm0NXjqG4bXQraOL8+U0TFt0nuuEYx73ueKVnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a0IGXKmNJVeadmGulOol9fkc8tYZeEYlmLgvLnmahFg=;
 b=QH5rojgwqHU07Vtq7jBpys8VmB7VM1BQD165K8r6bMIUoubHn1MIupCaWGja8ECIcexpjf4Wbu103Gpqpy+/kdKkqM5ItXxa21IvmQMsIrmMNLPrVfxfFn2CjNfEz8sSIYbAngbxnTjsJIaQOcxaxWE6GzGxVD7O4+fJX3finh3vjJP/ys60B3dpXa4cY8I8LoWpIbwL6SUgkyDJMEfTL73yMjBzWq7TDUkM/cZp9S6G63b7WrsPEkGOKDJ0y4ajY8as1eujrWEVW/sCtsYV/LRCzOvkHf65VsjCPm8rmcCYkLD4eR8ORKX9M4TL79zmrgSchq0LWZwO7QqREPev4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by MW4PR15MB4778.namprd15.prod.outlook.com (2603:10b6:303:10c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Wed, 9 Mar
 2022 18:04:50 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7da4:795a:91b8:fa54]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7da4:795a:91b8:fa54%7]) with mapi id 15.20.5038.027; Wed, 9 Mar 2022
 18:04:47 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Song Liu <song@kernel.org>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "edumazet@google.com" <edumazet@google.com>
Subject: Re: [PATCH v2 bpf-next] bpf: select proper size for bpf_prog_pack
Thread-Topic: [PATCH v2 bpf-next] bpf: select proper size for bpf_prog_pack
Thread-Index: AQHYMyYr1M8LZzm5KEKxZSmO6g/0CKy3WgUA
Date:   Wed, 9 Mar 2022 18:04:47 +0000
Message-ID: <BFCBD489-5209-4A78-98B6-782528B5EF1D@fb.com>
References: <20220308195303.556765-1-song@kernel.org>
In-Reply-To: <20220308195303.556765-1-song@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.60.0.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 744b3d46-7a9d-44d0-816c-08da01f74c44
x-ms-traffictypediagnostic: MW4PR15MB4778:EE_
x-microsoft-antispam-prvs: <MW4PR15MB4778CE8E31C0D904AF46558FB30A9@MW4PR15MB4778.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MOkpQjrcRGyV82FCkEkHQkS28L0lZ9AlxHMnOoG/mi9MGxtX4sJYKrtgqPA2aX+pfjqvNyDG3shnZIKHOee0TNMhv3r6DZAqMb5RnQMqVzn+EdaJKQzR8F/NBZlwISzvGMV6vutnXEfdhI/uCTkt1VMgKfKfgtOQptrfqNOKU2apqGXcuds5hSRX9BXDJ6jV+d07AgsSfdRxp9TrpaL70PBrKcCVMRvhl+bpgdqyvN//qPFS81Aj92AximvR+f20mo3CW9yHFVKxAN0ZS4t0iBodlg5AAMZ0uWczQTlNOKIRTIansHTU8qCADRj2Pv8IOpX1k1D2uEYEeT+dKEOFwPE+i67O6AJwYXxF3J7GaDqe4K4EI7+Kxgv/W+jHx+KGiZinJMEFKsYur8yxQBq3bk/n/L6ftaqWj1b6/O5chx+3mJBVrDrwZ39uJfIk3DK+230/ktDxEwz8OEMMEqfAjgbWsJzWmm4R1o0146DavDUyERhZwIQdKZFJGphUbQj8g4CANJFHESDEAaz6WzzPU9DCZcb3p1yOTv5UblftMuA8tZnn8eZmRqvxaYPF17wUGlNuwI1j8tcFnGKZYh1Z0WDaWAKCxUeqeBYZ7SIbGOFaqqBT0WICxckPX7mcc/8C0ETaL69W/IJIV5DwQCtWSEnHCXoxA4E65S5KXYK8yqBxrxv2Ph+yxRBiPFqYSQTttqt3XAzPBbV/nBZVBpYkfHvq9TeewcKEhUKYEd1IZHDhnoIko8JrZ1tn/bkTh0qa
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6512007)(76116006)(53546011)(4326008)(6486002)(66476007)(316002)(2616005)(64756008)(66446008)(38070700005)(38100700002)(66946007)(508600001)(8676002)(71200400001)(86362001)(6506007)(6916009)(54906003)(91956017)(122000001)(66556008)(186003)(83380400001)(8936002)(2906002)(5660300002)(33656002)(36756003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ZXH+804++ARZ+S3hvTzK8ofQH6ECHnJsmVZOR4NYK+s9ddwbt/guYpI+FRVn?=
 =?us-ascii?Q?fPOsRBDeZnIkjGsDRuyACFmAChJ1OepwVX0F4Jh5H3kdCJzXFlW4BxErM6ZR?=
 =?us-ascii?Q?QfDJxsaipCB2t71nRry50SEJmI/cVAPllridRwuHlSYkDBdNQb2rpOTG60av?=
 =?us-ascii?Q?WKioO4XeH16pJLLL/h8HwVgdkvLF5IfD+aWhCQ6YBfZLEIK3ypWjut6fwC3+?=
 =?us-ascii?Q?xluw2JYZg3gPbn8pK5VE3BMLFfx/YZzp+VbKWjeqXJaHz9geJrYmiv0Zp5ps?=
 =?us-ascii?Q?ao1FgVSq/Fefr9J5HL+t1gsVVorTHHEwTnVPBoEdINyP8ga3mCG1Yajj6ShM?=
 =?us-ascii?Q?bdXZvvq9Ci+R3ROS6YM8yBNRmEvH1RVH+yGw+ugZWihlXMs57f4ASgg0tWnG?=
 =?us-ascii?Q?SDRts8jjLxy2BxnG5HzAsBr6/0mOLTl14h51Qfn2NTX0etrxT6O158Zdn1rH?=
 =?us-ascii?Q?PRyUFL7kULk7Dzm7OPNfnySAccbRxd71UriPp7dimocw8lVSE89QXLLlSbUa?=
 =?us-ascii?Q?m2bxJq7LxG2nlULUYgCpC2xK+RzY6kazEhFhe4TJjZMhQou4z2Lq5x77TKQS?=
 =?us-ascii?Q?VzZtlojYvpjLm8AqGc/yfabWyoRe0tkhkqCZ7wh0kaFHwfh4Gy1nRgb/CDzt?=
 =?us-ascii?Q?k3qlB+4h76c+ebMLKtr50XEMxaYhCVmAjqUc7edMDqhn9NtTxI8+5omysDP4?=
 =?us-ascii?Q?ChTkndCQqB5YhgDu4S5AjPwliWt2Anp5NtuSyuwRYkM/gVVO9a/qZq2ReyhT?=
 =?us-ascii?Q?oV3SyuyOR6/yUvQJ0lnf/oR12ckcw3gVce/yZnMN+BvEhZhqN+LakWZ1HKJE?=
 =?us-ascii?Q?DWr60715+QXKpos0QGWPJjnvnDH8PeFvcBYC6HKD/wrqEkSsT91UbtCZg0K9?=
 =?us-ascii?Q?wuZBPxTgxv+vuVdN3R3+rjQI9CtXacoSOMLdPM9H6MH+Suiiq7uWDNVTT2A4?=
 =?us-ascii?Q?/o3a/sy/vlXGVJpcPM2MYGAhPFI8hMTzYO8UGQXqaxrKZxzUCem33xx9WiIg?=
 =?us-ascii?Q?2u0Gpt9T/zvv9SeAdKo2pnuE5iJR5Hrkt9Vi0EH2YbCobW40pPAxP3Na7F8n?=
 =?us-ascii?Q?ZbjXPq4DZO1I/ECB/XDEP84P5POdWkQ6O8itTJalUXVPBB2yBTrO+4maAxZC?=
 =?us-ascii?Q?1wg6K0uH7ashrUUvdHaR/R5eXaPidS1segxmDDJACRVCxJ1h5UdsPWW7wnlR?=
 =?us-ascii?Q?S/L6i4l0KKBwGYvsHpuxeCcGngEK/HPJD27Zev9N2A8wO7p4Bi+xgM8Ufw8J?=
 =?us-ascii?Q?H2469aZuN/jfeJuXG8wr+EeC1G49KgEJOV3XNPX1haorYGnXxNgOLaG4xy35?=
 =?us-ascii?Q?QJ+al9bJnUK7oW5Ghpqk69mRuZDde3pqDdw4IPXgFFJYm5xOmvgVz0ghk6qi?=
 =?us-ascii?Q?6OZgKcmQEj3i1igZOWWwjmhxzKJA5IS5uNBKJyd5/3xdNoyfz3jl6bHREj8t?=
 =?us-ascii?Q?MeBXaanlccfIraXEp3OqQiyx3WGJqjZVwLU7UfjSeS48s5h61gE/N866Z9yi?=
 =?us-ascii?Q?cB11eLJRPsZFYa9pzSKy71S7t0tPd7KlT+bPZYE4sjKO0pvbXlqPliv78zHZ?=
 =?us-ascii?Q?WtxVAdTlN8hgA545ZLAR79TJcUycMPxLH1dkT/cLGy90sr0gXRKpUSAm4E9D?=
 =?us-ascii?Q?qoiKpMYRqaRKSr/PoF3Gnh7DE/K23EUylzNTtR7DWACJQebQhkQuHcM8Xguk?=
 =?us-ascii?Q?suxR9A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <497A12522233EE48A1AC51F73EA27660@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 744b3d46-7a9d-44d0-816c-08da01f74c44
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2022 18:04:47.3673
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KKH5k8P102+atgSG5cKH1Z6xsH3xKXLLCuSwEIXq5oU05He3q2UbeVX4xVfgPQG7GTxoOjF9IqEk+Nw34CfcZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR15MB4778
X-Proofpoint-ORIG-GUID: g-PD1F4OxB6BVkF-e_ROnkbZWfNvYHdA
X-Proofpoint-GUID: g-PD1F4OxB6BVkF-e_ROnkbZWfNvYHdA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-09_07,2022-03-09_01,2022-02-23_01
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 8, 2022, at 11:53 AM, Song Liu <song@kernel.org> wrote:
> 
> Using HPAGE_PMD_SIZE as the size for bpf_prog_pack is not ideal in some
> cases. Specifically, for NUMA systems, __vmalloc_node_range requires
> PMD_SIZE * num_online_nodes() to allocate huge pages. Also, if the system
> does not support huge pages (i.e., with cmdline option nohugevmalloc), it
> is better to use PAGE_SIZE packs.
> 
> Add logic to select proper size for bpf_prog_pack. This solution is not
> ideal, as it makes assumption about the behavior of module_alloc and
> __vmalloc_node_range. However, it appears to be the easiest solution as
> it doesn't require changes in module_alloc and vmalloc code.
> 
> Fixes: 57631054fae6 ("bpf: Introduce bpf_prog_pack allocator")
> Signed-off-by: Song Liu <song@kernel.org>

I messed something up... Please ignore this version. I will send v3
soon. 

Song

> 
> ---
> Changes v1 => v2:
> 1. Fix case with first program > PAGE_SIZE. (Daniel)
> 2. Add Fixes tag.
> 3. Remove a inline to avoid netdev/source_inline error.
> ---
> kernel/bpf/core.c | 75 ++++++++++++++++++++++++++++++++---------------
> 1 file changed, 51 insertions(+), 24 deletions(-)
> 
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index ab630f773ec1..f039c1f7e5dd 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -33,6 +33,7 @@
> #include <linux/extable.h>
> #include <linux/log2.h>
> #include <linux/bpf_verifier.h>
> +#include <linux/nodemask.h>
> 
> #include <asm/barrier.h>
> #include <asm/unaligned.h>
> @@ -814,15 +815,9 @@ int bpf_jit_add_poke_descriptor(struct bpf_prog *prog,
>  * allocator. The prog_pack allocator uses HPAGE_PMD_SIZE page (2MB on x86)
>  * to host BPF programs.
>  */
> -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> -#define BPF_PROG_PACK_SIZE	HPAGE_PMD_SIZE
> -#else
> -#define BPF_PROG_PACK_SIZE	PAGE_SIZE
> -#endif
> #define BPF_PROG_CHUNK_SHIFT	6
> #define BPF_PROG_CHUNK_SIZE	(1 << BPF_PROG_CHUNK_SHIFT)
> #define BPF_PROG_CHUNK_MASK	(~(BPF_PROG_CHUNK_SIZE - 1))
> -#define BPF_PROG_CHUNK_COUNT	(BPF_PROG_PACK_SIZE / BPF_PROG_CHUNK_SIZE)
> 
> struct bpf_prog_pack {
> 	struct list_head list;
> @@ -830,30 +825,59 @@ struct bpf_prog_pack {
> 	unsigned long bitmap[];
> };
> 
> -#define BPF_PROG_MAX_PACK_PROG_SIZE	BPF_PROG_PACK_SIZE
> #define BPF_PROG_SIZE_TO_NBITS(size)	(round_up(size, BPF_PROG_CHUNK_SIZE) / BPF_PROG_CHUNK_SIZE)
> 
> +static size_t bpf_prog_pack_size = -1;
> +
> +static int bpf_prog_chunk_count(void)
> +{
> +	WARN_ON_ONCE(bpf_prog_pack_size == -1);
> +	return bpf_prog_pack_size / BPF_PROG_CHUNK_SIZE;
> +}
> +
> static DEFINE_MUTEX(pack_mutex);
> static LIST_HEAD(pack_list);
> 
> +static size_t select_bpf_prog_pack_size(void)
> +{
> +	size_t size;
> +	void *ptr;
> +
> +	size = PMD_SIZE * num_online_nodes() - 1;
> +	ptr = module_alloc(size);
> +
> +	/* Test whether we can get huge pages. If not just use PAGE_SIZE
> +	 * packs.
> +	 */
> +	if (!ptr || !is_vm_area_hugepages(ptr))
> +		size = PAGE_SIZE;
> +
> +	vfree(ptr);
> +	return size;
> +}
> +
> static struct bpf_prog_pack *alloc_new_pack(void)
> {
> 	struct bpf_prog_pack *pack;
> +	void *ptr;
> 
> -	pack = kzalloc(sizeof(*pack) + BITS_TO_BYTES(BPF_PROG_CHUNK_COUNT), GFP_KERNEL);
> -	if (!pack)
> +	ptr = module_alloc(bpf_prog_pack_size);
> +	if (!ptr)
> 		return NULL;
> -	pack->ptr = module_alloc(BPF_PROG_PACK_SIZE);
> -	if (!pack->ptr) {
> -		kfree(pack);
> +
> +	pack = kzalloc(struct_size(pack, bitmap, BITS_TO_LONGS(bpf_prog_chunk_count())),
> +		       GFP_KERNEL);
> +	if (!pack) {
> +		vfree(ptr);
> 		return NULL;
> 	}
> -	bitmap_zero(pack->bitmap, BPF_PROG_PACK_SIZE / BPF_PROG_CHUNK_SIZE);
> +	pack->ptr = ptr;
> +	bitmap_zero(pack->bitmap, bpf_prog_pack_size / BPF_PROG_CHUNK_SIZE);
> 	list_add_tail(&pack->list, &pack_list);
> 
> 	set_vm_flush_reset_perms(pack->ptr);
> -	set_memory_ro((unsigned long)pack->ptr, BPF_PROG_PACK_SIZE / PAGE_SIZE);
> -	set_memory_x((unsigned long)pack->ptr, BPF_PROG_PACK_SIZE / PAGE_SIZE);
> +	set_memory_ro((unsigned long)pack->ptr, bpf_prog_pack_size / PAGE_SIZE);
> +	set_memory_x((unsigned long)pack->ptr, bpf_prog_pack_size / PAGE_SIZE);
> 	return pack;
> }
> 
> @@ -864,7 +888,11 @@ static void *bpf_prog_pack_alloc(u32 size)
> 	unsigned long pos;
> 	void *ptr = NULL;
> 
> -	if (size > BPF_PROG_MAX_PACK_PROG_SIZE) {
> +	mutex_lock(&pack_mutex);
> +	if (bpf_prog_pack_size == -1)
> +		bpf_prog_pack_size = select_bpf_prog_pack_size();
> +
> +	if (size > bpf_prog_pack_size) {
> 		size = round_up(size, PAGE_SIZE);
> 		ptr = module_alloc(size);
> 		if (ptr) {
> @@ -872,13 +900,12 @@ static void *bpf_prog_pack_alloc(u32 size)
> 			set_memory_ro((unsigned long)ptr, size / PAGE_SIZE);
> 			set_memory_x((unsigned long)ptr, size / PAGE_SIZE);
> 		}
> -		return ptr;
> +		goto out;
> 	}
> -	mutex_lock(&pack_mutex);
> 	list_for_each_entry(pack, &pack_list, list) {
> -		pos = bitmap_find_next_zero_area(pack->bitmap, BPF_PROG_CHUNK_COUNT, 0,
> +		pos = bitmap_find_next_zero_area(pack->bitmap, bpf_prog_chunk_count(), 0,
> 						 nbits, 0);
> -		if (pos < BPF_PROG_CHUNK_COUNT)
> +		if (pos < bpf_prog_chunk_count())
> 			goto found_free_area;
> 	}
> 
> @@ -904,12 +931,12 @@ static void bpf_prog_pack_free(struct bpf_binary_header *hdr)
> 	unsigned long pos;
> 	void *pack_ptr;
> 
> -	if (hdr->size > BPF_PROG_MAX_PACK_PROG_SIZE) {
> +	if (hdr->size > bpf_prog_pack_size) {
> 		module_memfree(hdr);
> 		return;
> 	}
> 
> -	pack_ptr = (void *)((unsigned long)hdr & ~(BPF_PROG_PACK_SIZE - 1));
> +	pack_ptr = (void *)((unsigned long)hdr & ~(bpf_prog_pack_size - 1));
> 	mutex_lock(&pack_mutex);
> 
> 	list_for_each_entry(tmp, &pack_list, list) {
> @@ -926,8 +953,8 @@ static void bpf_prog_pack_free(struct bpf_binary_header *hdr)
> 	pos = ((unsigned long)hdr - (unsigned long)pack_ptr) >> BPF_PROG_CHUNK_SHIFT;
> 
> 	bitmap_clear(pack->bitmap, pos, nbits);
> -	if (bitmap_find_next_zero_area(pack->bitmap, BPF_PROG_CHUNK_COUNT, 0,
> -				       BPF_PROG_CHUNK_COUNT, 0) == 0) {
> +	if (bitmap_find_next_zero_area(pack->bitmap, bpf_prog_chunk_count(), 0,
> +				       bpf_prog_chunk_count(), 0) == 0) {
> 		list_del(&pack->list);
> 		module_memfree(pack->ptr);
> 		kfree(pack);
> -- 
> 2.30.2
> 

