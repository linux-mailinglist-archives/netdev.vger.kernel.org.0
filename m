Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 869B8510D0A
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 02:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353492AbiD0ANj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 20:13:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243996AbiD0ANh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 20:13:37 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 909861A805;
        Tue, 26 Apr 2022 17:10:26 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23QLZGeU004354;
        Tue, 26 Apr 2022 17:10:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=yGbb/N17JW5pvkKNkKnnC4qN77WjdRloUs6uNq+pM3o=;
 b=Y5NqhCH3ZIjYnH7AUbPXSA+NwV+keNUmUjK8LxzwjeY1tjp7tI/0mLdvfkAkVHigfWGH
 qa4lIUr+VGTq3L8JbHlvxxeXmiuCymT1CO/B8ukNTkZVEZvKJBuMJbAQdfyEuU8RHjwT
 tUw2q/fm/SnsZIGom7dxMbqFYcFrZT4eZ9M= 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fprscrub4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Apr 2022 17:10:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gQeBZHOyY8paBj4pQXimSkYhEJmCg7uKQLnpSG9a9iGh/46ITDOW5aq6hEWXNJVrGZ/JY/dPGSWpQmcMkJ4bFRtkxoinvBHmSjTg4NSNAke373l2gqgJlan6gINsFGohWQmhwJLRdTyqWDnWtxJ892E+g8uR5qDBuZBMvJw91SYfUPZaX0ffr/PASrlynUwKypwm4HpwyMCwX+2l2OoTz8DkjfINrZ/VlYZGwJB0km07r7N/AHyZmvo1elnAYnnTVZc5BngwOBl0l/37aNuGuH5Aq3t8lC9wLUTVAsc5p4TNAzo25VBvBR5EaEs+Nd96XY+VkLAc6OSi53c6yogyDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yGbb/N17JW5pvkKNkKnnC4qN77WjdRloUs6uNq+pM3o=;
 b=KJlPkmmhng8t1tNVhyqUbg9+M4IA86UD/kyb/fjcQcoHmgAui10EENLu3+KPAl0/t+d3Uu5P7cfKIWzBXCe67OL3Tx94uvYLRo2OwDkOg93FXJc4SHT07xZufbmUzdM7VYCezmtISKU04YfPVOVNYKV0AuLOLy2RzyZ1DhsnriXCuHUvVW0OMhTLcigZnk92s3IY+UmQnjPu2owFWJJ1jORg7Scca8bhaK/CCW/o2X2eaebP3Ele3sdsWCf8Oc7o0PNDvaeEKRgQygMxXFuuZwpDGJmEcoEZ5POLOHQ0eS8hKHhA1QshCBc6/8mPuAH9ijBCuD9A7oqWja2E+c2qBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from CO1PR15MB5017.namprd15.prod.outlook.com (2603:10b6:303:e8::19)
 by CO6PR15MB4226.namprd15.prod.outlook.com (2603:10b6:5:340::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.21; Wed, 27 Apr
 2022 00:10:08 +0000
Received: from CO1PR15MB5017.namprd15.prod.outlook.com
 ([fe80::944f:1cc2:ff9d:68de]) by CO1PR15MB5017.namprd15.prod.outlook.com
 ([fe80::944f:1cc2:ff9d:68de%9]) with mapi id 15.20.5186.021; Wed, 27 Apr 2022
 00:10:08 +0000
Date:   Tue, 26 Apr 2022 17:10:06 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Subject: Re: [PATCH bpf-next v5 3/8] bpf: per-cgroup lsm flavor
Message-ID: <20220427001006.dr5dl5mocufskmvv@kafai-mbp.dhcp.thefacebook.com>
References: <20220419190053.3395240-1-sdf@google.com>
 <20220419190053.3395240-4-sdf@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220419190053.3395240-4-sdf@google.com>
X-ClientProxiedBy: MW4PR04CA0268.namprd04.prod.outlook.com
 (2603:10b6:303:88::33) To CO1PR15MB5017.namprd15.prod.outlook.com
 (2603:10b6:303:e8::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3f823db0-af07-4b52-df9c-08da27e249ec
X-MS-TrafficTypeDiagnostic: CO6PR15MB4226:EE_
X-Microsoft-Antispam-PRVS: <CO6PR15MB42267D85584C41C67DBD12AED5FA9@CO6PR15MB4226.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DcYcAM5trLUdpLsghvqFKEZ7mEA0h+UI17HjBlaomBJOWaxPAZgqMVoYvbfBl6C3fFHqK1RZAoyDl1LxJyp2ZF8nYv+ihSkT36Ceg6epUmwB6is6f2/HSqouDMS3xectTnpSxtbIwz+qHxy9LUS2D4jJkfC8Ecb8Qk+5Rde7CZ3ocYpo/g1bDnhGukGupPf5WboCQBrpnXX1HZ//NsALeW7d+DHuB0aYS3qBH92dBwuv2HUx2bq6qn11OxOIi0gDDyZUySNklmuL6NdaJt/6OXspeiCWTT5Da88zwlUn5nn+1FL4JQtjsKHESivRjQFTs5KV3mkUqimCWNBVPrn7sU+7ecrwyvuEg5AkCoBsAwsBKYw9TEm2gAdTgmDplLekWhE3Lbj5E6OUdjs3ElA9RIrDqstP4ZiRTdny+RNYrfuHtNFN1+a5nx9pUKSMUeLSX33yj+U9sBHElg5oizuq6iIULw4+zsJwtFhfWbdXmqTwVRqJR67ZyiDKNq8FvAqixxYGYKGf5UqsDEEbNvBBLyEzi8sNSWbEg0lic5N6D4UPwR8eMSFvuY1kmc1EnA/LxCluGYXp8oMrqxvlTZlJc9X03V7Xc3xU9rE5abHphakPR29Vv9UbYjw/C81iHIWNMrxRudQz9JUDfD/OV8n/Dg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR15MB5017.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(1076003)(5660300002)(66476007)(66556008)(6506007)(6512007)(9686003)(52116002)(6916009)(316002)(8676002)(83380400001)(30864003)(66946007)(4326008)(8936002)(508600001)(2906002)(38100700002)(86362001)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uI0VG2949+/6MXGbn/8NQk97n4pNgyh7Aa/mc2h9fMynZVUlCa+WN6IdH/Op?=
 =?us-ascii?Q?o4V3dmHBaMRrqspx7e1UUcJK4bCRby2RLZMQy9W87k58C3cIdTZ12VgIyyLh?=
 =?us-ascii?Q?vUl6sACt0SV/Ts3hLHiL47rh7K2iPD0sMyC8U4oNLVHRiNwxPopPFSLzlzVZ?=
 =?us-ascii?Q?d7Xbs2ppmScOJGJRw8vc45F19hHjUfYKJY/B7auZy5kwH5uB1qRIhkqGxS9g?=
 =?us-ascii?Q?GSi3hmvBFksScP5Lr9IEJmqFt17UxB7B+J3koozg2QJkl5VANn/KgoWUj1t+?=
 =?us-ascii?Q?qL/yvNGn1QNh2eJbBdjeQY2BzwJ9pgreb2P0iYcmccBQ4egutIbkv7vVvC2R?=
 =?us-ascii?Q?pyxxOernDi/xxrJtAc/bSQlbtGqgGgumwDkKPG//xoH0KO/l+I8AP7eJ2IdW?=
 =?us-ascii?Q?/c0TatjHceeOYd5nALfM24VrTQsM2pApF/bhjd+Cho/laKUV52U9KI89SgyQ?=
 =?us-ascii?Q?3grMtfozeMcbkkhuJalOyIOi0AVNCN7irlSpN+3Hs9LCki+ltySLsZ3sDP1V?=
 =?us-ascii?Q?rGELURPBcoKp9TjLh97C9pWXbK1keMNa9KZDOpHxotpd8lGaT7Jfdt5zUnhR?=
 =?us-ascii?Q?XliMoh0lTuU8TvGE2E87n2C9YTQFGMgxL2E1V699E6+wunYaw6ni0tIwGkYJ?=
 =?us-ascii?Q?Y08cSTI9AYrvHJ8Cp/7N6BdUxQcB81lQBKhxG14I3cx7B5FEhIzPWk6qUXEj?=
 =?us-ascii?Q?cUXs9hAmGOFyrz/U+YPnxxUxltJGcHDmfT8w3Hpwp/xq1gMyI+0K/myTaFG/?=
 =?us-ascii?Q?p85bcldtsdO89wck70rAHeAjefL7huxnhrwz01Yz2VMcVJNi+Lxlc0YXkpFA?=
 =?us-ascii?Q?xepHbkBnnGiDRDO2pzpiRC+zV6Oywh03mb0E8HA61SPFdmHX8HbHAhAMNAFH?=
 =?us-ascii?Q?rnUfXccxq0NE4YT7Whyokfp9F38H6Owv/q8RmOcVQDvxMjGU/7FUCkPlRse8?=
 =?us-ascii?Q?tAptqz5lXZAQ6wORP14NZXroKJoWQW159nUe5Ov3nFnA98YlUXfRaQrfKqCl?=
 =?us-ascii?Q?d1/KL6JGFzh/16mEZECIkAcYpUzvnL/JtGDsp+AnmAnu1V915DJG7DxJ3P5O?=
 =?us-ascii?Q?Iy7onw8mpdfVnU3os35bhZZCzRHYpLKcnK284tnQDviV2geCQIrKDRLbNNiN?=
 =?us-ascii?Q?Xm+VJkcUU7jap2CU8XYLc4pD3uJAjHivO0+WV+1or7i5wxnq3TS2Uw2zfnO5?=
 =?us-ascii?Q?kXjJTRuEuTX+S7jCO5hNSe9NxZ9vQrytgWKXQSz6k72ALZyR1+hR1gThk13k?=
 =?us-ascii?Q?Rjv5hN5MY4FohCIrND4XZxMCu2eqkW8veMWxumzrFJZTluvvrzJ/yC0xm6pm?=
 =?us-ascii?Q?C1EcNETqsApBsBdpQmBo4QhvN9ey1s0dLku+vt1xiooL5H2NRaawdA6DO5sw?=
 =?us-ascii?Q?c4lFEqPjIMHQ8Au7cgnfjtB/Fokr4cqN32VWPjE0SS52nsSAoN6KMUWQpOtn?=
 =?us-ascii?Q?wlSHXL7PCsmiZ8JID65sMpxdiWaltwY8CrZb/ROBLJK0zhAbZplN7R8NPRdn?=
 =?us-ascii?Q?R2Km3ByrMf/8nvbzLgZcW7qnVHipcpTVgOJfnjKpY+l8GBTMlDojgvuybrE5?=
 =?us-ascii?Q?fO2U8uYLK+7icJJWV1B28SSbLw36k+7MSeei67m1TdZKJFnpxeEmQiI3Vtxt?=
 =?us-ascii?Q?gEsWR4+kkfbLCgbgNZ74H7cCsUe81dsDwFgUfdpX4Vdlxf1529fJMPTR6hDt?=
 =?us-ascii?Q?Pxq7bwhUAIvOw05Gy//bnTbEuptrB21J3l2pIidcoZ4rxAL/n5IWav0/Kro3?=
 =?us-ascii?Q?yTfsVkKoJyoLCL3eXixXLl7DA9DQ8Lo=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f823db0-af07-4b52-df9c-08da27e249ec
X-MS-Exchange-CrossTenant-AuthSource: CO1PR15MB5017.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2022 00:10:08.6448
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 22Hn2jBEyZWL+tLUYMt4ycsp+4kxo+3IN1czTHZhRSan14ejOH+71ea+i+i+8Nm5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR15MB4226
X-Proofpoint-GUID: X5HSqJikb0zPpCLOrT4sZw3ns3H4nKsJ
X-Proofpoint-ORIG-GUID: X5HSqJikb0zPpCLOrT4sZw3ns3H4nKsJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-26_06,2022-04-26_02,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 19, 2022 at 12:00:48PM -0700, Stanislav Fomichev wrote:
> +static void bpf_cgroup_storages_unlink(struct bpf_cgroup_storage *storages[])
> +{
> +	enum bpf_cgroup_storage_type stype;
> +
> +	for_each_cgroup_storage_type(stype)
> +		bpf_cgroup_storage_unlink(storages[stype]);
> +}
> +
>  /* Called when bpf_cgroup_link is auto-detached from dying cgroup.
>   * It drops cgroup and bpf_prog refcounts, and marks bpf_link as defunct. It
>   * doesn't free link memory, which will eventually be done by bpf_link's
> @@ -166,6 +256,16 @@ static void bpf_cgroup_link_auto_detach(struct bpf_cgroup_link *link)
>  	link->cgroup = NULL;
>  }
>  
> +static void bpf_cgroup_lsm_shim_release(struct bpf_prog *prog,
> +					enum cgroup_bpf_attach_type atype)
> +{
> +	if (prog->aux->cgroup_atype < CGROUP_LSM_START ||
> +	    prog->aux->cgroup_atype > CGROUP_LSM_END)
> +		return;
> +
> +	bpf_trampoline_unlink_cgroup_shim(prog);
> +}
> +
>  /**
>   * cgroup_bpf_release() - put references of all bpf programs and
>   *                        release all cgroup bpf data
> @@ -190,10 +290,18 @@ static void cgroup_bpf_release(struct work_struct *work)
>  
>  		hlist_for_each_entry_safe(pl, pltmp, progs, node) {
>  			hlist_del(&pl->node);
> -			if (pl->prog)
> +			if (pl->prog) {
> +				if (atype == BPF_LSM_CGROUP)
> +					bpf_cgroup_lsm_shim_release(pl->prog,
> +								    atype);
>  				bpf_prog_put(pl->prog);
> -			if (pl->link)
> +			}
> +			if (pl->link) {
> +				if (atype == BPF_LSM_CGROUP)
> +					bpf_cgroup_lsm_shim_release(pl->link->link.prog,
> +								    atype);
>  				bpf_cgroup_link_auto_detach(pl->link);
> +			}
>  			kfree(pl);
>  			static_branch_dec(&cgroup_bpf_enabled_key[atype]);
>  		}
> @@ -506,6 +614,7 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
>  	struct bpf_prog *old_prog = NULL;
>  	struct bpf_cgroup_storage *storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {};
>  	struct bpf_cgroup_storage *new_storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {};
> +	struct bpf_attach_target_info tgt_info = {};
>  	enum cgroup_bpf_attach_type atype;
>  	struct bpf_prog_list *pl;
>  	struct hlist_head *progs;
> @@ -522,9 +631,35 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
>  		/* replace_prog implies BPF_F_REPLACE, and vice versa */
>  		return -EINVAL;
>  
> -	atype = to_cgroup_bpf_attach_type(type);
> -	if (atype < 0)
> -		return -EINVAL;
> +	if (type == BPF_LSM_CGROUP) {
> +		struct bpf_prog *p = prog ? : link->link.prog;
> +
> +		if (replace_prog) {
> +			/* Reusing shim from the original program.
> +			 */
> +			if (replace_prog->aux->attach_btf_id !=
> +			    p->aux->attach_btf_id)
> +				return -EINVAL;
> +
> +			atype = replace_prog->aux->cgroup_atype;
> +		} else {
> +			err = bpf_check_attach_target(NULL, p, NULL,
> +						      p->aux->attach_btf_id,
> +						      &tgt_info);
> +			if (err)
> +				return -EINVAL;
> +
> +			atype = bpf_lsm_attach_type_get(p->aux->attach_btf_id);
> +			if (atype < 0)
> +				return atype;
> +		}
> +
> +		p->aux->cgroup_atype = atype;
> +	} else {
> +		atype = to_cgroup_bpf_attach_type(type);
> +		if (atype < 0)
> +			return -EINVAL;
> +	}
>  
>  	progs = &cgrp->bpf.progs[atype];
>  
> @@ -580,13 +715,26 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
>  	if (err)
>  		goto cleanup;
>  
> +	bpf_cgroup_storages_link(new_storage, cgrp, type);
After looking between this patch 3 and the next patch 4, I can't
quite think this through quickly, so it may be faster to ask :)

I have questions on the ordering between update_effective_progs(),
bpf_cgroup_storages_link(), and bpf_trampoline_link_cgroup_shim().

Why bpf_cgroup_storages_link() has to be moved up and done before
bpf_trampoline_link_cgroup_shim() ?

> +
> +	if (type == BPF_LSM_CGROUP && !old_prog) {
> +		struct bpf_prog *p = prog ? : link->link.prog;
> +
> +		err = bpf_trampoline_link_cgroup_shim(p, &tgt_info);
update_effective_progs() was done a few lines above, so the effective[atype]
array has the new_prog now.

If bpf_trampoline_link_cgroup_shim() did fail to add the
shim_prog to the trampoline, the new_prog will still be left in
effective[atype].  There is no shim_prog to execute effective[].
However, there may be places that access effective[]. e.g.
__cgroup_bpf_query() although I think to_cgroup_bpf_attach_type()
is not handling BPF_LSM_CGROUP now.  More on __cgroup_bpf_query()
later.

Doing bpf_trampoline_link_cgroup_shim() just before activate_effective_progs() ?

Have you thought about what is needed to support __cgroup_bpf_query() ?
bpf_attach_type and cgroup_bpf_attach_type is no longer a 1:1 relationship.
Looping through cgroup_lsm_atype_usecnt[] and output them under BPF_LSM_CGROUP ?
Same goes for local_storage.  All lsm-cgrp attaching to different
attach_btf_id sharing one local_storage because the key is only
cgroup-id and attach_type.  Is it enough to start with that
first and the key could be extended later with a new map_flag?
This is related to the API.

> +		if (err)
> +			goto cleanup_trampoline;
> +	}
> +
>  	if (old_prog)
>  		bpf_prog_put(old_prog);
>  	else
>  		static_branch_inc(&cgroup_bpf_enabled_key[atype]);
> -	bpf_cgroup_storages_link(new_storage, cgrp, type);
> +
>  	return 0;
>  
> +cleanup_trampoline:
> +	bpf_cgroup_storages_unlink(new_storage);
> +
>  cleanup:
>  	if (old_prog) {
>  		pl->prog = old_prog;
> @@ -678,9 +826,13 @@ static int __cgroup_bpf_replace(struct cgroup *cgrp,
>  	struct hlist_head *progs;
>  	bool found = false;
>  
> -	atype = to_cgroup_bpf_attach_type(link->type);
> -	if (atype < 0)
> -		return -EINVAL;
> +	if (link->type == BPF_LSM_CGROUP) {
> +		atype = link->link.prog->aux->cgroup_atype;
> +	} else {
> +		atype = to_cgroup_bpf_attach_type(link->type);
> +		if (atype < 0)
> +			return -EINVAL;
> +	}
>  
>  	progs = &cgrp->bpf.progs[atype];
>  
> @@ -696,6 +848,9 @@ static int __cgroup_bpf_replace(struct cgroup *cgrp,
>  	if (!found)
>  		return -ENOENT;
>  
> +	if (link->type == BPF_LSM_CGROUP)
> +		new_prog->aux->cgroup_atype = atype;
> +
>  	old_prog = xchg(&link->link.prog, new_prog);
>  	replace_effective_prog(cgrp, atype, link);
>  	bpf_prog_put(old_prog);
> @@ -779,9 +934,15 @@ static int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
>  	u32 flags;
>  	int err;
>  
> -	atype = to_cgroup_bpf_attach_type(type);
> -	if (atype < 0)
> -		return -EINVAL;
> +	if (type == BPF_LSM_CGROUP) {
> +		struct bpf_prog *p = prog ? : link->link.prog;
> +
> +		atype = p->aux->cgroup_atype;
> +	} else {
> +		atype = to_cgroup_bpf_attach_type(type);
> +		if (atype < 0)
> +			return -EINVAL;
> +	}
>  
>  	progs = &cgrp->bpf.progs[atype];
>  	flags = cgrp->bpf.flags[atype];
> @@ -803,6 +964,10 @@ static int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
>  	if (err)
>  		goto cleanup;
>  
> +	if (type == BPF_LSM_CGROUP)
> +		bpf_cgroup_lsm_shim_release(prog ? : link->link.prog,
> +					    atype);
> +
>  	/* now can actually delete it from this cgroup list */
>  	hlist_del(&pl->node);
>  

[ ... ]

> diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
> index 0c4fd194e801..c76dfa4ea2d9 100644
> --- a/kernel/bpf/trampoline.c
> +++ b/kernel/bpf/trampoline.c
> @@ -11,6 +11,8 @@
>  #include <linux/rcupdate_wait.h>
>  #include <linux/module.h>
>  #include <linux/static_call.h>
> +#include <linux/bpf_verifier.h>
> +#include <linux/bpf_lsm.h>
>  
>  /* dummy _ops. The verifier will operate on target program's ops. */
>  const struct bpf_verifier_ops bpf_extension_verifier_ops = {
> @@ -485,6 +487,149 @@ int bpf_trampoline_unlink_prog(struct bpf_prog *prog, struct bpf_trampoline *tr)
>  	return err;
>  }
>  
> +#if defined(CONFIG_BPF_JIT) && defined(CONFIG_BPF_SYSCALL)
> +static struct bpf_prog *cgroup_shim_alloc(const struct bpf_prog *prog,
> +					  bpf_func_t bpf_func)
> +{
> +	struct bpf_prog *p;
> +
> +	p = bpf_prog_alloc(1, 0);
> +	if (!p)
> +		return NULL;
> +
> +	p->jited = false;
> +	p->bpf_func = bpf_func;
> +
> +	p->aux->cgroup_atype = prog->aux->cgroup_atype;
> +	p->aux->attach_func_proto = prog->aux->attach_func_proto;
> +	p->aux->attach_btf_id = prog->aux->attach_btf_id;
> +	p->aux->attach_btf = prog->aux->attach_btf;
> +	btf_get(p->aux->attach_btf);
> +	p->type = BPF_PROG_TYPE_LSM;
> +	p->expected_attach_type = BPF_LSM_MAC;
> +	bpf_prog_inc(p);
> +
> +	return p;
> +}
> +
> +static struct bpf_prog *cgroup_shim_find(struct bpf_trampoline *tr,
> +					 bpf_func_t bpf_func)
> +{
> +	const struct bpf_prog_aux *aux;
> +	int kind;
> +
> +	for (kind = 0; kind < BPF_TRAMP_MAX; kind++) {
> +		hlist_for_each_entry(aux, &tr->progs_hlist[kind], tramp_hlist) {
> +			struct bpf_prog *p = aux->prog;
> +
> +			if (p->bpf_func == bpf_func)
> +				return p;
> +		}
> +	}
> +
> +	return NULL;
> +}
> +
> +int bpf_trampoline_link_cgroup_shim(struct bpf_prog *prog,
> +				    struct bpf_attach_target_info *tgt_info)
> +{
> +	struct bpf_prog *shim_prog = NULL;
> +	struct bpf_trampoline *tr;
> +	bpf_func_t bpf_func;
> +	u64 key;
> +	int err;
> +
> +	key = bpf_trampoline_compute_key(NULL, prog->aux->attach_btf,
> +					 prog->aux->attach_btf_id);
> +
> +	err = bpf_lsm_find_cgroup_shim(prog, &bpf_func);
> +	if (err)
> +		return err;
> +
> +	tr = bpf_trampoline_get(key, tgt_info);
> +	if (!tr)
> +		return  -ENOMEM;
> +
> +	mutex_lock(&tr->mutex);
> +
> +	shim_prog = cgroup_shim_find(tr, bpf_func);
> +	if (shim_prog) {
> +		/* Reusing existing shim attached by the other program.
> +		 */
> +		bpf_prog_inc(shim_prog);
> +		mutex_unlock(&tr->mutex);
> +		return 0;
> +	}
> +
> +	/* Allocate and install new shim.
> +	 */
> +
> +	shim_prog = cgroup_shim_alloc(prog, bpf_func);
> +	if (!shim_prog) {
> +		err = -ENOMEM;
> +		goto out;
> +	}
> +
> +	err = __bpf_trampoline_link_prog(shim_prog, tr);
> +	if (err)
> +		goto out;
> +
> +	mutex_unlock(&tr->mutex);
> +
> +	return 0;
> +out:
> +	if (shim_prog)
> +		bpf_prog_put(shim_prog);
> +
> +	mutex_unlock(&tr->mutex);
> +	return err;
> +}
> +
> +void bpf_trampoline_unlink_cgroup_shim(struct bpf_prog *prog)
> +{
> +	struct bpf_prog *shim_prog;
> +	struct bpf_trampoline *tr;
> +	bpf_func_t bpf_func;
> +	u64 key;
> +	int err;
> +
> +	key = bpf_trampoline_compute_key(NULL, prog->aux->attach_btf,
> +					 prog->aux->attach_btf_id);
> +
> +	err = bpf_lsm_find_cgroup_shim(prog, &bpf_func);
> +	if (err)
> +		return;
> +
> +	tr = bpf_trampoline_lookup(key);
> +	if (!tr)
> +		return;
> +
> +	mutex_lock(&tr->mutex);
> +
> +	shim_prog = cgroup_shim_find(tr, bpf_func);
> +	if (shim_prog) {
> +		/* We use shim_prog refcnt for tracking whether to
> +		 * remove the shim program from the trampoline.
> +		 * Trampoline's mutex is held while refcnt is
> +		 * added/subtracted so we don't need to care about
> +		 * potential races.
> +		 */
> +
> +		if (atomic64_read(&shim_prog->aux->refcnt) == 1)
> +			WARN_ON_ONCE(__bpf_trampoline_unlink_prog(shim_prog, tr));
> +
> +		bpf_prog_put(shim_prog);
> +	}
> +
> +	mutex_unlock(&tr->mutex);
> +
> +	bpf_trampoline_put(tr); /* bpf_trampoline_lookup */
> +
> +	if (shim_prog)
> +		bpf_trampoline_put(tr);
> +}
> +#endif
> +
