Return-Path: <netdev+bounces-1684-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EEF96FECF5
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 09:35:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9157028163A
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 07:35:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 925371B8F8;
	Thu, 11 May 2023 07:35:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EB9A81F
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 07:35:40 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2135.outbound.protection.outlook.com [40.107.244.135])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A02B1903E
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 00:35:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e2ZHlJEafrpSodtAwossQNMeYASeqTyqnOqRjGDXicDF460nDzaQvFZeWwqxNfrJ8+a/Aj/Amzmx+OHWedFnOzulS25NDVcbv3WtwW3fdWFgH3n2O8RzwAKfcRx0U15Dtfye/U6MZANiWo0e9FTeo5QO/Avi9a5CO7obwJcz5UiCr+BthZx7ucLX+sEyz4CR17C/qHP1QRbmVtrwqUzaDV8sQxq8dyZc+B723l5VmmtwDbAHfSh5DAzyVfQVqBIzcMlImj0mQLl2BIwuqyY6kB26zRnUUX3shccYG1OricMviXNf1hLMt1xgzc7E81YWseWWYMQFJZJK2gw0iBFXdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qLUYJzkbNh4fzIxgkVGTIXdmcFlZ4h08Uo2thtZCyik=;
 b=FjCVv39ckgBsfTTA8e5inxI7g5sdhTdWYTMm/T0U9mIV5K1SbzSWOhedD0LHzE1QofFxgXekJw1D7c3ur967Txrdp1aYHkSIoIsawgnO53lQJui7kB5XMJp73eowVdXGhlJbSqU9D5cfCQmif8Uu/hodhu5aIsZESK2UUJhcC9f4bAwpRHQwhUKFy5nhwryI56KEB1+2/LCNaAkBsomWzQ4s/0ZLuRAwT8NuSfYCAwBSF26WFWBBh+8zDLOmgvz5Apko/oroSZWtnOQtinqJX727TLAHkgvOs77GypYwfi5p3W0fpR7eT3QxCFp2F6obk+otaWjoeJ2eQ6A97h+7tA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qLUYJzkbNh4fzIxgkVGTIXdmcFlZ4h08Uo2thtZCyik=;
 b=czCaqi5znAN/dqYggN5dD2/JhSUKvlQ4We5Tsca37Of8G6r9ZN3Vy9dKZ8atle1TSz63SfR9Cmk+33radAqu4HlhpILYAFvcRUWC+Kqqn9eBx5ZaQRuzwsWXezlR0+GxvyDyhiROjOL1LBx+iLvyqwHn950FxuthrysHqEnPVCQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB4039.namprd13.prod.outlook.com (2603:10b6:208:269::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.21; Thu, 11 May
 2023 07:34:25 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.020; Thu, 11 May 2023
 07:34:25 +0000
Date: Thu, 11 May 2023 09:34:19 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Jacob Keller <jacob.e.keller@intel.com>
Cc: Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
	kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
	netdev@vger.kernel.org, Piotr Raczynski <piotr.raczynski@intel.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: Re: [PATCH net-next 6/8] ice: add individual interrupt allocation
Message-ID: <ZFyae201uKt3gK9I@corigine.com>
References: <20230509170048.2235678-1-anthony.l.nguyen@intel.com>
 <20230509170048.2235678-7-anthony.l.nguyen@intel.com>
 <ZFtb1Uyr2j+wEM+g@corigine.com>
 <85bdedf5-930d-c47c-fee0-bb4fee480e42@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85bdedf5-930d-c47c-fee0-bb4fee480e42@intel.com>
X-ClientProxiedBy: AM9P193CA0008.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:20b:21e::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB4039:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f6a4f30-8eb7-4c57-7e61-08db51f224fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	UoqBTQEgG8w/AT2NgDUTBppF6arHc6VXrlfUbV7IuJD5XTqBaAdz0nvLRjHz5zr2nC3z1Hz9xxJnsq6Y3CsW/9r/jsg1YpE3+QoximN0kgsh0nyX0NU9Gvys6NHSclIcsPdDYfb0HowbeOOSLz8Qb6SRl7AcQwZCxVF1SNpk4q5TqMdTIOnaLknsmqFLz7EWTq5rcvhH4WNSfMfDJFrhHFvMiadJ4e8l7xFEjxoYO/1J1Kouql363gBdlwrdd9GT+Ps3bdoi+rBshgGxG9RIMYelPAUZbQo38DW8xEP78NdDgVDs8vuxKHllkJoUFtL+QGEzKfWl0KxuzoLKz5xFFui9kaqA/Wy5uoHw0dP0RVMTvP/wFrrtj0Mob0G181tcHldgSXcbQkUWv+vDWOjlSstJLUxQ4u4d9vKE5t5oJBoT16dH06o2iAbThXntb6t0tWjvsiStqLX+2lpGdmMZnRCONn8pdEyp4zy/grcV5S4J6VIODqdC/MNQ4yd334zXbE5MOmqGaBlPAWoD2Cl6lHuczaqhWTF5KZxfxwBYU50e7kbFO1zyzV6yq/DHKp/S
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(39840400004)(346002)(136003)(376002)(451199021)(186003)(6512007)(53546011)(6506007)(54906003)(6916009)(5660300002)(4326008)(66476007)(66946007)(66556008)(86362001)(478600001)(7416002)(44832011)(2906002)(41300700001)(83380400001)(316002)(8936002)(8676002)(38100700002)(2616005)(6666004)(36756003)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+4P6rBFFYugIkDRSHhzZ/ukyRIa5db1Mv0rsoySIj3LJIDppzSbbXWfNzGaw?=
 =?us-ascii?Q?ks2peU94gjuDiRo75l9QLTUD+7EgMVrD3Gt3bSi7M64VWFXa7lHe+dO+bSWH?=
 =?us-ascii?Q?5jYMf3VippIlUbgMjmE/nZ8NFyk7X4fQDDx/mAYyUuWD2/o75Do8Ho54/rfS?=
 =?us-ascii?Q?UCwyCugXHFsYNRxSdatgipWCC0rxnyxYnStFQLyDWZhwuA4M8uBaW+Fj71du?=
 =?us-ascii?Q?zYcRRbeKmGHZE0HlOtpoE76jaYIfevywaLG53lXMsGsjLUzqB8IZn0bdBhHK?=
 =?us-ascii?Q?lJ7DKLVhGKPpsmEwuDdywiATe7+JhuXdthasFkCb4jxdM/TSWfOYozWs2B3B?=
 =?us-ascii?Q?qAJEZxy8avXTHWojmGY02nfhB87Zddr4Vk+O6QlMVYDRWnUF2DCN9N48amQV?=
 =?us-ascii?Q?nQ0VFklcx3GopHIW4GamPY2KljLGb7i+bTFvdbQMkLG1oxMKif+1qj6KRkpR?=
 =?us-ascii?Q?IDXUaBOFPvNgTEmib9w9dQtsGoBjLdKwPXHLGtVDkybHaPSI+oSil4NSD/O3?=
 =?us-ascii?Q?Aj/6rsWKzR20idyzcnymAMj2OqQv0gfSk40gqUzPXVaMyWECH2XH5PnWTps5?=
 =?us-ascii?Q?kUl8ZBzN6PMtBUPhutuLdUVl26ZLai8TD9zw2vtRManf0902lfPCiHWdqRo9?=
 =?us-ascii?Q?c8+amj9NvN0uSUOTfhdMgfy8oQWDK4WVyqneCaKdxc8cl11e7hTAeFW+QVsI?=
 =?us-ascii?Q?p8LNGTIjThTHD3+WnP/sv2dKZtZUvsnEliaZbzVEGgMFuHXFZhmN3fxxMAd+?=
 =?us-ascii?Q?GBN87IPSdZxq/WAGOERtcJi5/gAb7c2uKnFSaVQgRN5AYRPKr92u0nKkPsQX?=
 =?us-ascii?Q?BnMYekrMt7NfkquO8j5zjT5LgZjsMbB1zhoRhyaSHU3XT9M06xs5Zyx1zS4t?=
 =?us-ascii?Q?zOdsaro2d8+t4yEiDy6VVZlF+55s3VK9IPpkHmvAjRDTuXcT4fYeOdqQoLRx?=
 =?us-ascii?Q?msxlQO9HAJyYIToqs7fsL21FNHkL2NYmGaXM4f2hbglMWXU6/CbQLQQyTPJ1?=
 =?us-ascii?Q?Ytb+fhmEgLQG8NGpe7HgK7BhOVnSJ9l/LUadFMa65iVYsQKnRlRBOMEAADID?=
 =?us-ascii?Q?RPJsh07O2sG0jm3YhE5TLdgMU4ArfeWwLoD98UsumN/xdqLqAXelBl6tZJXK?=
 =?us-ascii?Q?Xqj2kUFlL8RMj5Tp24yPr11UV+bIsfjqS4HC7QQwdcP9FVFt4urT0e5cA3q4?=
 =?us-ascii?Q?qaV7igtAXHf+rsIC9MFETEHe7LdhTbcEyuKsHWtgrd+bbQbEeoaeyNgBgD8D?=
 =?us-ascii?Q?3TBFic1idveTLW+jRxEr8H4IAY9p26Yvws76HIWCkawrPWPaimvazJvJ+cLm?=
 =?us-ascii?Q?NI59+qZx0JFQOM3Gi6Y+5uLCAfVJySN9fBCw4T2EpcELzpcbYhh+EtTFxIhD?=
 =?us-ascii?Q?usYc8vZkU1xsh1qj+iJDGkgULIDkwCs5rB+2/0sVucr7VpfnEdy13ghQAN2f?=
 =?us-ascii?Q?XKcSnsYf7YnQQskvQlzIXubRr/KdGtuTRK3ZM2SedBCcCn7tAhDRFdDHv9mc?=
 =?us-ascii?Q?93/pEqhWpo2yt8PAD7wgAQdj914+hkda2YP3wAJrU4gKf2OHXB+zDpdBZyuz?=
 =?us-ascii?Q?RFoHtDIlFD0n+Waz1tPXfc3u6PMVlVBRXcDmtJnAhiC4pwPH0qLrGxEbQyAb?=
 =?us-ascii?Q?zKJf7STJd/JLtc4haMoZ/dspXLZA3WjDTTSLOXYMYNnze5iDsYZQ/VYxHERJ?=
 =?us-ascii?Q?+tD7sg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f6a4f30-8eb7-4c57-7e61-08db51f224fb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 07:34:24.9413
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5Mwk97OKfn5J/cVoS2A/RCwSJVCUbLGk4InObDI2eewbi7pHS7qoSoBkHMqEVXFcbkNOGcrNkyWAnoMPLEc5Qix3B2cF61rLMHJh2WsQYKQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB4039
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 10, 2023 at 11:33:33AM -0700, Jacob Keller wrote:
> 
> 
> On 5/10/2023 1:54 AM, Simon Horman wrote:
> > On Tue, May 09, 2023 at 10:00:46AM -0700, Tony Nguyen wrote:
> >> From: Piotr Raczynski <piotr.raczynski@intel.com>
> >>
> >> Currently interrupt allocations, depending on a feature are distributed
> >> in batches. Also, after allocation there is a series of operations that
> >> distributes per irq settings through that batch of interrupts.
> >>
> >> Although driver does not yet support dynamic interrupt allocation, keep
> >> allocated interrupts in a pool and add allocation abstraction logic to
> >> make code more flexible. Keep per interrupt information in the
> >> ice_q_vector structure, which yields ice_vsi::base_vector redundant.
> >> Also, as a result there are a few functions that can be removed.
> >>
> >> Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
> >> Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> >> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> >> Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
> >> Signed-off-by: Piotr Raczynski <piotr.raczynski@intel.com>
> >> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> > 
> > ...
> > 
> >> diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
> >> index 1911d644dfa8..7dd7a0f32471 100644
> >> --- a/drivers/net/ethernet/intel/ice/ice_base.c
> >> +++ b/drivers/net/ethernet/intel/ice/ice_base.c
> >> @@ -105,8 +105,7 @@ static int ice_vsi_alloc_q_vector(struct ice_vsi *vsi, u16 v_idx)
> >>  	struct ice_q_vector *q_vector;
> >>  
> >>  	/* allocate q_vector */
> >> -	q_vector = devm_kzalloc(ice_pf_to_dev(pf), sizeof(*q_vector),
> >> -				GFP_KERNEL);
> >> +	q_vector = kzalloc(sizeof(*q_vector), GFP_KERNEL);
> 
> Especially since we moved away from devm_kzalloc here so it won't
> automatically get released at driver unload. (Which is fine, I think
> we're slowly moving away from devm here because we didn't really commit
> to using it properly and had devm_kfree a lot anyways...).
> 
> >>  	if (!q_vector)
> >>  		return -ENOMEM;
> >>  
> >> @@ -118,9 +117,31 @@ static int ice_vsi_alloc_q_vector(struct ice_vsi *vsi, u16 v_idx)
> >>  	q_vector->rx.itr_mode = ITR_DYNAMIC;
> >>  	q_vector->tx.type = ICE_TX_CONTAINER;
> >>  	q_vector->rx.type = ICE_RX_CONTAINER;
> >> +	q_vector->irq.index = -ENOENT;
> >>  
> >> -	if (vsi->type == ICE_VSI_VF)
> >> +	if (vsi->type == ICE_VSI_VF) {
> >> +		q_vector->reg_idx = ice_calc_vf_reg_idx(vsi->vf, q_vector);
> >>  		goto out;
> >> +	} else if (vsi->type == ICE_VSI_CTRL && vsi->vf) {
> >> +		struct ice_vsi *ctrl_vsi = ice_get_vf_ctrl_vsi(pf, vsi);
> >> +
> >> +		if (ctrl_vsi) {
> >> +			if (unlikely(!ctrl_vsi->q_vectors))
> >> +				return -ENOENT;
> > 
> > q_vector appears to be leaked here.
> 
> Yea that seems like a leak to me too. We allocate q_vector near the
> start of the function then perform some lookup checks here per VSI type
> to get the index. We wanted to obtain the irq value from the CTRL VSI. I
> bet this case is very rare since it would be unlikely that we have a
> ctrl_vsi pointer but do *not* have the q_vectors array setup yet.
> 
> Probably best if this was refactored a bit to have a cleanup exit label
> so that it was more difficult to miss the cleanup.

Thanks Jacob, agreed.

> >> +			q_vector->irq = ctrl_vsi->q_vectors[0]->irq;
> >> +			goto skip_alloc;
> >> +		}
> >> +	}
> >> +
> >> +	q_vector->irq = ice_alloc_irq(pf);
> >> +	if (q_vector->irq.index < 0) {
> >> +		kfree(q_vector);
> >> +		return -ENOMEM;
> >> +	}
> >> +
> >> +skip_alloc:
> >> +	q_vector->reg_idx = q_vector->irq.index;
> >> +
> >>  	/* only set affinity_mask if the CPU is online */
> >>  	if (cpu_online(v_idx))
> >>  		cpumask_set_cpu(v_idx, &q_vector->affinity_mask);
> > 
> > ...

