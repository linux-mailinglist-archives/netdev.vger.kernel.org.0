Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A2D13C1D34
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 03:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbhGIByZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 21:54:25 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:26148 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229637AbhGIByY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 21:54:24 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 1691kRJx027453;
        Thu, 8 Jul 2021 18:51:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=++E+J2Pq40hIu+TsSH+7DttW2hezo1s1kk35L+Vs5z4=;
 b=Yw4v8txfxQMID5JBIOTnLDMtCwQ1OsSGnRlc+DT4wHuehXwPappBgXa/e7dm7HC9WbVC
 zLnAuaodoTu5DdmZ6LED2rG4JkI0ACNgONnBZutOlk5YuPAWtBV+mzID9PXZvEp6V40w
 VAt4kSYu0cnUooWwNkjF0RZgWy38lvwrkCQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 39nwprwv1m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 08 Jul 2021 18:51:26 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 8 Jul 2021 18:51:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f1BXZFlZiPC3QcDjxd5zxhgKgXTS+NYTcxaJfui6e+KEIclKHy8wtPM4YlKGk689PpPvgI7rNeIP261PiCgPFPJb+LMn07as5MyAUeAFWX2FxA0neOtsNHfa9gvoTvMQZdTiY7JvieFfgq//GZb4vdD/zpOgFucGT1/Jz5K5dH4/Vfcf1pzOL6/G0Xs9SrOBHD8YacGkJlp8ClshmrFSwlEoQgxQYdfC8b5TUppvOx4fo9Ep4TzuS6CGn3OBOBPUjD6PBli6axR0j2Zb4VfetCYyD7LvNPAfkjar918dXDu8I9BBaByzAuDDZXtCMBo+s1Mj4u70RbZDR+ulcvqFFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=++E+J2Pq40hIu+TsSH+7DttW2hezo1s1kk35L+Vs5z4=;
 b=HIq9UxgK3bHeVlbZILvXlXKtkGWX5FGlIzMzP8tOpgeWeKjGwz9HmrplP1wddGTbXHf7R3vQ0G82CkdUbPfK6yILbRNSKcnPX9r8ZITm+XR7k4buQuRAGqvnFgcj4FAAKzU4LPqlQ5Iv0I/fV0k7rO04b0EFrHcTGRMbU4xEeo4nWF3hdOLsao9nBjdo+k6RQnjTchoerazdO+x5J7K6p/ei/TIY911bwYdGHfc/Av1Bqqd2IA8pYNWGVCTwLA+rL05+pqCcJR/UFAJIhctdfSN5HsVT1DvXX7lLeZkg2n2HJ+k7hTdbwUfRytZf5i1yvd44rwPRKAfrxHmmCc+zIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SN6PR1501MB4142.namprd15.prod.outlook.com (2603:10b6:805:e7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.19; Fri, 9 Jul
 2021 01:51:22 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1b5:fa51:a2b9:28f]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1b5:fa51:a2b9:28f%7]) with mapi id 15.20.4287.035; Fri, 9 Jul 2021
 01:51:22 +0000
Date:   Thu, 8 Jul 2021 18:51:19 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     <davem@davemloft.net>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: Re: [PATCH v5 bpf-next 04/11] bpf: Add map side support for bpf
 timers.
Message-ID: <20210709015119.l5kxp5kao24bjft7@kafai-mbp.dhcp.thefacebook.com>
References: <20210708011833.67028-1-alexei.starovoitov@gmail.com>
 <20210708011833.67028-5-alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210708011833.67028-5-alexei.starovoitov@gmail.com>
X-ClientProxiedBy: SJ0PR13CA0119.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::34) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:552d) by SJ0PR13CA0119.namprd13.prod.outlook.com (2603:10b6:a03:2c5::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.10 via Frontend Transport; Fri, 9 Jul 2021 01:51:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5f6577db-706c-4b86-b63e-08d9427c0d61
X-MS-TrafficTypeDiagnostic: SN6PR1501MB4142:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR1501MB4142748BD040F236371AD739D5189@SN6PR1501MB4142.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WDQgKF/ePwVrrgCcjSIMY+bTvlwJ0ARkD4LDhU+VtbbqUDOZNxf/k1OVqyK/cLGqEqDPI3q004qBjSF3MxDMo+NuF92BJtttf2bK8Lhglezug6Jy6lO5zBv5Kew6quLwM9lOGJWjiv5Ui/kB1tYx5QzNJtZpoqiqjfxdalXnksmU5ECLbF5ElY5KF/plHIOO2wCWEWNEiPeEhrgiIzENfkAe1sipCEj3QANqqUBc1MoBeV77soSNE/GR0iIJ71mn5Nd5Skkw7/V8euD+BZPpHQuEHHA68m6zS9FQPDx+SLV7XtNpiW5ZUzhQGaOZp1suv9SLBWKna8vzcjh7rCnoAS3UysFNn274q3LZy2WXS1eQbqV8gDHsARybdTSVuUGXSDQTp/wXbXRnFEHpQ1DsauqI2d3QS6hCrSVucwPrnkJyj7Gsul/cRAApOlrJhickE6+O9g8IUs94qlrvzEIkJphInbgTCDZJVhHvu/zuAeGImbmESMuBdclhb8HM/vIvyTiFhY9+h23m40pgkOJpaUrC6H24N9JhATxSCRJCNiSxobdg20oPJ6bhDp7gAie1pDJcC3gXGdVCyVxMnRyAYEM9hyVI/jk/dowWqHZl7ROevk6Qt6qUaLkoa+04d++oPj3RkDY4eygByFTKG3ce5w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(39860400002)(376002)(366004)(66946007)(66476007)(83380400001)(8936002)(6916009)(7696005)(52116002)(66556008)(86362001)(478600001)(8676002)(186003)(5660300002)(316002)(1076003)(55016002)(38100700002)(4326008)(9686003)(6506007)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RNzhWhJibIxXEhClLtbpPR8ZI5Nad/dnhfM/VhjcDkOpnwLMqrtpdfm7x1u+?=
 =?us-ascii?Q?nKPNH+sonsWavdALCEy9M1Q0dekCYMxehn0sUhUYH5RYVUOAfhSm8Q/uHjXS?=
 =?us-ascii?Q?KBk766trt4xJ6eY/Lrz12h5MDZ1nbhRFB2dHVNOqW2aOznPzgo4Wr3jlzqmZ?=
 =?us-ascii?Q?KZVOeFwOyRBVcHKI9Jysm7lUwl4CFvNx+nfqOxFoymR0kkQyP/iNH0myiT5G?=
 =?us-ascii?Q?TRDHJaWrdG+7WDACaureoholE8ZK41rr0NKWaNwq36UIlJBGm4i1O1VGTful?=
 =?us-ascii?Q?RU9Srvxou7qw3Ez/NimQv67aBOT5/2g0mj0togeBQm7SkGC09jRlYbzSWivV?=
 =?us-ascii?Q?r5mro7IkyHuIUO9uM+ZPLRiQZUxSLGysF3eNSlNCQmHhwXnBGQnR4tO47Kxh?=
 =?us-ascii?Q?6yQ12CmhIKebM/nnRIYEfTa8xhX6OXNCKus0OOY52nRc72Ild8/DXUdmI/Ov?=
 =?us-ascii?Q?P0BpNi8ABvfC9NbK01sdzLuHZ9zcjMnOk6ovfysj7+a3j1feITcO3P7iigJJ?=
 =?us-ascii?Q?YstJtvvj74FokKEWvMW6dgcdy8cIzkaTjACWrlNLOWqUu+I5+KdqlEGZCVG2?=
 =?us-ascii?Q?Shu3jA4Y68CZadU86p3RGTyqOiKK7qRLgIeTzvhsgidCtV/8AE7Cb3TapcSf?=
 =?us-ascii?Q?gudjD3Uu04IWo2BAOeFaQPx++XCYiihWvcusLJDSZT5d8lEvHONN8NwOXCJi?=
 =?us-ascii?Q?7rgcJ0JJ5GS5N7fpVu74qDV8CJHJc0hK1VgT25YdFdNCVMpyl+AuF/PMzVK1?=
 =?us-ascii?Q?JUcEnseqOYme0E38DFIoFW+Jjgb2MLn4WwIJ+33YoJaplyHNv+0+2PQb7seg?=
 =?us-ascii?Q?ctQPuRmLsrcTn0Jk8ASQerWgVD0OzHm/zRzBXknP5BWL4dMUuxfGHIxDMkeC?=
 =?us-ascii?Q?6VL7kYQ19ijmnvoT2lDWojGyUG42Qn1o51dHMHE2g51cyKX0t5s6v4NHRADJ?=
 =?us-ascii?Q?GqB9ATZjYCslvW0kRkvZQUvBkYXIVXpqVU5epq2nxBdGb2I6uypfiqTYrTsi?=
 =?us-ascii?Q?zFI+1Y28xfHmyCcPLOlStBYAnbEvMMwMzdSdjzcNVBqJedPB9wToWShNZ6GE?=
 =?us-ascii?Q?W5QA8Z8F+h/gWSiR+Ic+Vs82kwkRhNhsjLeozCfSqRRCBR0QxvSDJ/N/dPsM?=
 =?us-ascii?Q?NL4wYmNBW2J9kphFaezuvrHn5HEdwzqYkvZ2xOkJUXNP1gLtVBFM1pPP6+0O?=
 =?us-ascii?Q?jmbKxxsPLUXwc1wvIMSOa/9BeQKAYX0TTDmtz6qGasKuDNK6CdNokLVImiQw?=
 =?us-ascii?Q?WZD7svVQVCNskBA/bkwrkY03kZ13C+4L4S7Qv/iNJvjERkQc0WLa50WLUY4Q?=
 =?us-ascii?Q?Vm/LiGN+PNpSNcZGe918+VGFtJNFu6dVIRny6A3bkD2EZw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f6577db-706c-4b86-b63e-08d9427c0d61
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2021 01:51:22.0468
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K/9bUvMZuE9/tF07bdrbhUp+jAcAAJeZLwgwBoPRR+VWp6ww9WrlMdxdh/V6Jder
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR1501MB4142
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: 33DxnlVbT2bloAHc4qDhuuiv2exUGEkK
X-Proofpoint-ORIG-GUID: 33DxnlVbT2bloAHc4qDhuuiv2exUGEkK
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-09_01:2021-07-09,2021-07-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 clxscore=1015 bulkscore=0
 mlxscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107090007
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 07, 2021 at 06:18:26PM -0700, Alexei Starovoitov wrote:
[ ... ]
> +static void array_map_free_timers(struct bpf_map *map)
> +{
> +	struct bpf_array *array = container_of(map, struct bpf_array, map);
> +	int i;
> +
> +	if (likely(!map_value_has_timer(map)))
> +		return;
> +
> +	for (i = 0; i < array->map.max_entries; i++)
> +		bpf_timer_cancel_and_free(array->value + array->elem_size * i +
> +					  map->timer_off);
> +}
> +
>  /* Called when map->refcnt goes to zero, either from workqueue or from syscall */
>  static void array_map_free(struct bpf_map *map)
>  {
> @@ -382,6 +402,7 @@ static void array_map_free(struct bpf_map *map)
>  	if (array->map.map_type == BPF_MAP_TYPE_PERCPU_ARRAY)
>  		bpf_array_free_percpu(array);
>  
> +	array_map_free_timers(map);
array_map_free() is called when map->refcnt reached 0.
By then, map->usercnt should have reached 0 before
and array_map_free_timers() should have already been called,
so no need to call it here again?  The same goes for hashtab.

[ ... ]

> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index cb4b72997d9b..7780131f710e 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -3046,43 +3046,92 @@ static void btf_struct_log(struct btf_verifier_env *env,
>  	btf_verifier_log(env, "size=%u vlen=%u", t->size, btf_type_vlen(t));
>  }
>  
> -/* find 'struct bpf_spin_lock' in map value.
> - * return >= 0 offset if found
> - * and < 0 in case of error
> - */
> -int btf_find_spin_lock(const struct btf *btf, const struct btf_type *t)
> +static int btf_find_struct_field(const struct btf *btf, const struct btf_type *t,
> +				 const char *name, int sz, int align)
>  {
>  	const struct btf_member *member;
>  	u32 i, off = -ENOENT;
>  
> -	if (!__btf_type_is_struct(t))
> -		return -EINVAL;
> -
>  	for_each_member(i, t, member) {
>  		const struct btf_type *member_type = btf_type_by_id(btf,
>  								    member->type);
>  		if (!__btf_type_is_struct(member_type))
>  			continue;
> -		if (member_type->size != sizeof(struct bpf_spin_lock))
> +		if (member_type->size != sz)
>  			continue;
> -		if (strcmp(__btf_name_by_offset(btf, member_type->name_off),
> -			   "bpf_spin_lock"))
> +		if (strcmp(__btf_name_by_offset(btf, member_type->name_off), name))
>  			continue;
>  		if (off != -ENOENT)
> -			/* only one 'struct bpf_spin_lock' is allowed */
> +			/* only one such field is allowed */
>  			return -E2BIG;
>  		off = btf_member_bit_offset(t, member);
>  		if (off % 8)
>  			/* valid C code cannot generate such BTF */
>  			return -EINVAL;
>  		off /= 8;
> -		if (off % __alignof__(struct bpf_spin_lock))
> -			/* valid struct bpf_spin_lock will be 4 byte aligned */
> +		if (off % align)
> +			return -EINVAL;
> +	}
> +	return off;
> +}
> +
> +static int btf_find_datasec_var(const struct btf *btf, const struct btf_type *t,
> +				const char *name, int sz, int align)
> +{
> +	const struct btf_var_secinfo *vsi;
> +	u32 i, off = -ENOENT;
> +
> +	for_each_vsi(i, t, vsi) {
> +		const struct btf_type *var = btf_type_by_id(btf, vsi->type);
> +		const struct btf_type *var_type = btf_type_by_id(btf, var->type);
> +
> +		if (!__btf_type_is_struct(var_type))
> +			continue;
> +		if (var_type->size != sz)
> +			continue;
> +		if (vsi->size != sz)
> +			continue;
> +		if (strcmp(__btf_name_by_offset(btf, var_type->name_off), name))
> +			continue;
> +		if (off != -ENOENT)
> +			/* only one such field is allowed */
> +			return -E2BIG;
> +		off = vsi->offset;
> +		if (off % align)
>  			return -EINVAL;
>  	}
>  	return off;
>  }
>  
> +static int btf_find_field(const struct btf *btf, const struct btf_type *t,
> +			  const char *name, int sz, int align)
> +{
> +
> +	if (__btf_type_is_struct(t))
> +		return btf_find_struct_field(btf, t, name, sz, align);
> +	else if (btf_type_is_datasec(t))
> +		return btf_find_datasec_var(btf, t, name, sz, align);
iiuc, a global struct bpf_timer is not supported.  I am not sure
why it needs to find the timer in datasec here. or it meant to error out
and potentially give a verifier log?  I don't see where is the verifier
reporting error though.

> +static void htab_free_malloced_timers(struct bpf_htab *htab)
> +{
> +	int i;
> +
> +	rcu_read_lock();
> +	for (i = 0; i < htab->n_buckets; i++) {
> +		struct hlist_nulls_head *head = select_bucket(htab, i);
> +		struct hlist_nulls_node *n;
> +		struct htab_elem *l;
> +
> +		hlist_nulls_for_each_entry(l, n, head, hash_node)
need the _rcu() variant here.

May be put rcu_read_lock/unlock() in the loop and do a
cond_resched() in case the hashtab is large.
