Return-Path: <netdev+bounces-1374-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 713336FDA14
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 10:55:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 437762812E4
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 08:55:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30DB863E;
	Wed, 10 May 2023 08:55:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1795B364
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 08:55:02 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2094.outbound.protection.outlook.com [40.107.94.94])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8A2D4499
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 01:55:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n8Y206bYh6yf3Q0V71PRoTbgSW/ML1Fx/uqeKOLLsoqokfDh/gWqOPVbQq7pfowM8W3oFa1110xS0IBRtgelR8VyNW4LZMJLoaQrODjsxyZwd1aFQfYeIKd9VOEfRcAM7fNCF+0wtVTn+e7dUsu2UyDQJ9zgIf+1a47mduI8jOt9UUG29VUdStjhEwpYln0JTbL73gfGeNmqGcIJpC772YBBgzsl0uOUn56g8jP3tlp67+LSY4LPZXES+gBKaZIGzf4a3w2xsmxDqKhUd229zpHd9qu2x9jJ+socxK05D3+vCaelK/n5p31VudmSOFOG++WX23H6TviF+B8+2H7+Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tL3V1TGvFKo/D7xVmaZt1XK2x6LvrpbPLk7Z3KHA7YE=;
 b=cbu6QNNGgOGO58tUXMnKmwA3MK/HRwi3k8QZJGnik4dZ88xE7S2bskXmsXK2/ZMLMr+LpGH/TfVqvolMdog4C2eyAL7LbOV2X9X4hmgrfwSE9F0O0/gLdzeC79aNRGbOzH1yTMqDbu81fzSxMwtv1a3gufanJ2dsy2b0JcXeteTe7TatI44i2SO9VqhSkvQrG5gOGYfoPu2VG2SEZ4d0n6U0rYCYu/OYToo3kNgFYCTCVwALdCYV7adppn8nd4LwNT5/FytK6tj5jr9cb8S40UcemiexhU6S88lLfXsyxxBghXBqJ0BOUwIbRtQGoCv6YiLSmMH7RUfsf08ViEAJJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tL3V1TGvFKo/D7xVmaZt1XK2x6LvrpbPLk7Z3KHA7YE=;
 b=RUDHs3Igesw2lFKbXuUOx9BiMOHKxoqH51d1s4OW3so0ROmXvrVEV/Ta3GsOtLjRdB1jy/2LreBLJlUWCq5TDfN5wsgtcQkismJdOE2ZZjhdby2daIAkbrCY2Y2hpu8pLP03wiZ96zUMxLxlIoAA2QaSTBdmvddGMLI8LrA9OVU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN0PR13MB5135.namprd13.prod.outlook.com (2603:10b6:408:165::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Wed, 10 May
 2023 08:54:57 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.020; Wed, 10 May 2023
 08:54:57 +0000
Date: Wed, 10 May 2023 10:54:45 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com, netdev@vger.kernel.org,
	Piotr Raczynski <piotr.raczynski@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: Re: [PATCH net-next 6/8] ice: add individual interrupt allocation
Message-ID: <ZFtb1Uyr2j+wEM+g@corigine.com>
References: <20230509170048.2235678-1-anthony.l.nguyen@intel.com>
 <20230509170048.2235678-7-anthony.l.nguyen@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230509170048.2235678-7-anthony.l.nguyen@intel.com>
X-ClientProxiedBy: AM9P195CA0007.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:21f::12) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BN0PR13MB5135:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c0656d9-4258-439b-efa4-08db51343b1c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	/CgqQD79Xh0Bwt/NEC2FJkFIybOQ9C33l9hpikk0Fr5v5M9g7kCf7QIhs8lNt9PjDA0jmrnCUkio3/7vskB979Rbb7bT10wmIdiwd6C5DLEaKgbkJAamsFU2fO4vZ+6QCoxo2yKZbdNcHg7oLFvlXYcLo/zsi34YzQjReERUfXKOzUzHMMM4vPh71K2mrqP1aQYbWoHb/sV802W104Oahg8egHYxiI8PbjPv3b3jHKXptZpArNVCytZndWuvRoDOFvgPSDY5hnoVt+3zjC3yt9qydbCkdsWENAi+LldPJZGJ+v3JQsPnzf9D8BQ6ve/TY2YuNwpPDYMZzO7tru5zt4x1cwE+z96RhYROCShz06Gz1qmvZs4UjSSQuu+6159Iu0R/drsOFq69ogZNl7Y3vldnm2wqN1EV/UfRmR7uCr/EYZyxIkvbx75MUPyq64JqU5mUxRxa6C5HxPlVFSkvOfyW633iTRPhoKYzSZp1XAV4EXcSJJ04KrJ2LsUBgcEwCppIYGNID3PG/O/PewCRL7zmiW4qUupr2vBqjoGTgh9ZbMp3b0VTMULktg20RmOs
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(136003)(366004)(39840400004)(396003)(451199021)(7416002)(2616005)(2906002)(186003)(44832011)(478600001)(36756003)(6486002)(6666004)(316002)(6506007)(41300700001)(6512007)(38100700002)(83380400001)(54906003)(66946007)(66476007)(6916009)(66556008)(4326008)(5660300002)(8936002)(86362001)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oOaG2RmzzecGp/TjlDsTs+TvV0Tj1PzwLvZO7jQUqzf194eSeGoqsGoCw453?=
 =?us-ascii?Q?fGPMar21Id/owl2l5em6jUfu+Xb1eK6y7OoB/P6L3DH0TwqL7DI3K0dOrom5?=
 =?us-ascii?Q?tVEtal985k28Cx4E0x+eTvOqIH1RSZiJtJzPcZqxaq0rxuAhBnYJN1ipRDVc?=
 =?us-ascii?Q?JVNlUP7T6HjGKwOXbmAhDwYlpP4oPy0BvsBYyAqlxDxGFosJ32zygrLjrWNB?=
 =?us-ascii?Q?JM8qUjjaQkmdnFoOF0FHdJmO+fDhM2BWM9Nz5rz0giQYufB3DnsP3CyEYa/r?=
 =?us-ascii?Q?RcXPpRJiymphahP8bo1+PQAnH7236fo0Ey2W6FrBN+YZ+ZLQ1u2+q2fwp7W1?=
 =?us-ascii?Q?hy7VZnygUsWlAuB+OUZBXishSLgAeDjbXXha+v9F8k9zq32Tf6oQMUUrubDq?=
 =?us-ascii?Q?0BMyvxGa6OR9YW9j84234TeHly00xFkjZDpyKVgH4y3xOd+mZpqDoraKcmte?=
 =?us-ascii?Q?/OflSVoW1BVAq31keRJP9uR6JmqPWpBhrCL2XbxJbKe9uyoDg6SYWPdZZz5s?=
 =?us-ascii?Q?eMdrxG6Fgi18mbuFDpaYdKb116EWR6r6TLPTbtEXkedUl+22ITZNAal/60Qh?=
 =?us-ascii?Q?HCnOOwSxR5UVQJLIew/jdcgYWTJkDprRnjcD6A62RlLVB8p70BsA2d83SorY?=
 =?us-ascii?Q?+NYfUnK9+LBDVQc33Zyft7BQuwSk/lhr1ocXfDPtFaloDXyJ6Ziyzn07i10K?=
 =?us-ascii?Q?FA/+jJiJl8twZuJKrmmXOWy/oMzYR8hrdikoBc9SZICp1y90XzB9vGXGuFqg?=
 =?us-ascii?Q?1qqQcC3Py26EIVeOVmhFMWLphcG1pFxHDAm9TJbvql2QWqbCp5xgXpXpkkzF?=
 =?us-ascii?Q?9ZHe0ip1qEx9uAW5ZkLApAjZ1Ry3kjGXb9rtz+XrtnJ7yDHOq9suuS8WI6oR?=
 =?us-ascii?Q?/X+o+C51O6+eZa55V3JmJanyR7WejP8jfuZ0sUw9CStBEfzimtQypbIr6D2O?=
 =?us-ascii?Q?3TcYVfHw4jOfnzr03qcqUcJtVTgGnWmqvel8ula+j8KH5Ds4hzkHZSFpda2O?=
 =?us-ascii?Q?gIRWH/q3T0iN1/+PeAH5fdMXrPeabis0FQLzaeHssXeRyCTru0I/j3XbO3q9?=
 =?us-ascii?Q?PstrfryOtGN5hOd3EB/bXOKf9Rmuo95SC96Va4PuIqQZjNdNJMPM/Qz/8r0i?=
 =?us-ascii?Q?7+GO9qdZtB4hXhj1arqaYpLoh/f6/f4NTIx4QxdvqHkt2fiRuFt7Xce370TH?=
 =?us-ascii?Q?KWT++HWs3GNXX4nSa7s7rA9x4c84PzaihRbNoESADLS/3K8cn0C7cNcE4gsp?=
 =?us-ascii?Q?WRPef5kycmAWTHOw+qn/bH0B76T9/QMvJMeUCsGxS3clVDo22wtWeQzFhTzh?=
 =?us-ascii?Q?mnOIWWke+5gjd7Ihi5zZGukXP/GXbOVpKutG6jJtAnZIz+twRlmtU8ZA8gZm?=
 =?us-ascii?Q?0ly2WRmW6PUMJg4T8vz5rMQ5okBoiN3SndKI5oIryiDi5AximmZH6qB7LEti?=
 =?us-ascii?Q?sZq/jQEf8pOARsd+I79VHl0DrLHnVgAYy4Jc0jGHk/3OgKP3er7arU7NPWsq?=
 =?us-ascii?Q?xxTsud5DLzM6/GQGlJi5ApN5QBZm/eUr/St2FGtlTtqjy6VvsqdQanfJLgrH?=
 =?us-ascii?Q?BSIgQuC/mXJAdANJo3S+4REQH31GXHhYaeeCtqbRsQ+n3e1qHokHNL60NhJC?=
 =?us-ascii?Q?6eeCNFQqUrFljHnoyvl7X1ZnRBCMGUB9uFDBc6WnZzGbV2+pQcCHJdEHdItS?=
 =?us-ascii?Q?3zgEEg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c0656d9-4258-439b-efa4-08db51343b1c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 08:54:57.6949
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LJ/W9zmHn6HFfO+N16pmovufEzi73bFU72hpmSc+gDmDTfuRzXti4WP6MyuhhxIZDJKo/LhcDJNYHHKGSRY31WCvI8x5U99kMidyqHj0Ylg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR13MB5135
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 09, 2023 at 10:00:46AM -0700, Tony Nguyen wrote:
> From: Piotr Raczynski <piotr.raczynski@intel.com>
> 
> Currently interrupt allocations, depending on a feature are distributed
> in batches. Also, after allocation there is a series of operations that
> distributes per irq settings through that batch of interrupts.
> 
> Although driver does not yet support dynamic interrupt allocation, keep
> allocated interrupts in a pool and add allocation abstraction logic to
> make code more flexible. Keep per interrupt information in the
> ice_q_vector structure, which yields ice_vsi::base_vector redundant.
> Also, as a result there are a few functions that can be removed.
> 
> Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
> Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
> Signed-off-by: Piotr Raczynski <piotr.raczynski@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>

...

> diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
> index 1911d644dfa8..7dd7a0f32471 100644
> --- a/drivers/net/ethernet/intel/ice/ice_base.c
> +++ b/drivers/net/ethernet/intel/ice/ice_base.c
> @@ -105,8 +105,7 @@ static int ice_vsi_alloc_q_vector(struct ice_vsi *vsi, u16 v_idx)
>  	struct ice_q_vector *q_vector;
>  
>  	/* allocate q_vector */
> -	q_vector = devm_kzalloc(ice_pf_to_dev(pf), sizeof(*q_vector),
> -				GFP_KERNEL);
> +	q_vector = kzalloc(sizeof(*q_vector), GFP_KERNEL);
>  	if (!q_vector)
>  		return -ENOMEM;
>  
> @@ -118,9 +117,31 @@ static int ice_vsi_alloc_q_vector(struct ice_vsi *vsi, u16 v_idx)
>  	q_vector->rx.itr_mode = ITR_DYNAMIC;
>  	q_vector->tx.type = ICE_TX_CONTAINER;
>  	q_vector->rx.type = ICE_RX_CONTAINER;
> +	q_vector->irq.index = -ENOENT;
>  
> -	if (vsi->type == ICE_VSI_VF)
> +	if (vsi->type == ICE_VSI_VF) {
> +		q_vector->reg_idx = ice_calc_vf_reg_idx(vsi->vf, q_vector);
>  		goto out;
> +	} else if (vsi->type == ICE_VSI_CTRL && vsi->vf) {
> +		struct ice_vsi *ctrl_vsi = ice_get_vf_ctrl_vsi(pf, vsi);
> +
> +		if (ctrl_vsi) {
> +			if (unlikely(!ctrl_vsi->q_vectors))
> +				return -ENOENT;

q_vector appears to be leaked here.

> +			q_vector->irq = ctrl_vsi->q_vectors[0]->irq;
> +			goto skip_alloc;
> +		}
> +	}
> +
> +	q_vector->irq = ice_alloc_irq(pf);
> +	if (q_vector->irq.index < 0) {
> +		kfree(q_vector);
> +		return -ENOMEM;
> +	}
> +
> +skip_alloc:
> +	q_vector->reg_idx = q_vector->irq.index;
> +
>  	/* only set affinity_mask if the CPU is online */
>  	if (cpu_online(v_idx))
>  		cpumask_set_cpu(v_idx, &q_vector->affinity_mask);

...

