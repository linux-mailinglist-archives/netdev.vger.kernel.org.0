Return-Path: <netdev+bounces-8348-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CBD85723C7A
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 11:04:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 90A2B2815F6
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:04:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0241C290E7;
	Tue,  6 Jun 2023 09:03:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6BD4125C0
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 09:03:48 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 666038F
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 02:03:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1686042227; x=1717578227;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=B4BpfQHm9MQd+abSJc8cnrChLaBqe1+11MVv5UTPxLI=;
  b=A2ssOv6FCjBBFjeiWfptvBHsFTlzf57pvP3M+kaTBqaFvNqf0p562yi6
   VAq+M1YHOK39C/trkK+xOWCuuIxcV9WemFden+EPx6AHU1tor1OR5lkyK
   MVhjdOYBQPiQdvF6JiXSOK1F0o4uyFPnGhddOAf7zdxwsYpy5aTm5VJD9
   Na+4N+3JcSdc0xPk9Yvu5kc8TaXp+zsSX6Au4PjzNW6QL/8/v4PRJKsnN
   QsUAm7G0slLZqxtS6kX3P7Rus7ppn+QISdGejyq29IDL0f6wGZ+Bmrn0d
   pHcdEKuEY/kJqRQcjdIKOGOc7LuutqI2FkIag0Rmf2O1+HQZ8qGGh8eT4
   Q==;
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="217001330"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Jun 2023 02:03:47 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 6 Jun 2023 02:03:46 -0700
Received: from DEN-LT-70577 (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Tue, 6 Jun 2023 02:03:45 -0700
Date: Tue, 6 Jun 2023 09:03:45 +0000
From: Daniel Machon <daniel.machon@microchip.com>
To: Dave Ertman <david.m.ertman@intel.com>
CC: <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>, Jacob Keller
	<jacob.e.keller@intel.com>
Subject: Re: [PATCH net v2 01/10] ice: Correctly initialize queue context
 values
Message-ID: <20230606090345.lhbfllkslip7zbta@DEN-LT-70577>
References: <20230605182258.557933-1-david.m.ertman@intel.com>
 <20230605182258.557933-2-david.m.ertman@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230605182258.557933-2-david.m.ertman@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> From: Jacob Keller <jacob.e.keller@intel.com>
> 
> The ice_alloc_lan_q_ctx function allocates the queue context array for a
> given traffic class. This function uses devm_kcalloc which will
> zero-allocate the structure. Thus, prior to any queue being setup by
> ice_ena_vsi_txq, the q_ctx structure will have a q_handle of 0 and a q_teid
> of 0. These are potentially valid values.
> 
> Modify the ice_alloc_lan_q_ctx function to initialize every member of the
> q_ctx array to have invalid values. Modify ice_dis_vsi_txq to ensure that
> it assigns q_teid to an invalid value when it assigns q_handle to the
> invalid value as well.
> 
> This will allow other code to check whether the queue context is currently
> valid before operating on it.
> 
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_common.c |  1 +
>  drivers/net/ethernet/intel/ice/ice_sched.c  | 23 ++++++++++++++++-----
>  2 files changed, 19 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
> index a9f2e6bff806..23a9f169bc71 100644
> --- a/drivers/net/ethernet/intel/ice/ice_common.c
> +++ b/drivers/net/ethernet/intel/ice/ice_common.c
> @@ -4708,6 +4708,7 @@ ice_dis_vsi_txq(struct ice_port_info *pi, u16 vsi_handle, u8 tc, u8 num_queues,
>                         break;
>                 ice_free_sched_node(pi, node);
>                 q_ctx->q_handle = ICE_INVAL_Q_HANDLE;
> +               q_ctx->q_teid = ICE_INVAL_TEID;
>         }
>         mutex_unlock(&pi->sched_lock);
>         kfree(qg_list);
> diff --git a/drivers/net/ethernet/intel/ice/ice_sched.c b/drivers/net/ethernet/intel/ice/ice_sched.c
> index 824bac5ce003..0db9eb8fd402 100644
> --- a/drivers/net/ethernet/intel/ice/ice_sched.c
> +++ b/drivers/net/ethernet/intel/ice/ice_sched.c
> @@ -572,18 +572,24 @@ ice_alloc_lan_q_ctx(struct ice_hw *hw, u16 vsi_handle, u8 tc, u16 new_numqs)
>  {
>         struct ice_vsi_ctx *vsi_ctx;
>         struct ice_q_ctx *q_ctx;
> +       u16 idx;
> 
>         vsi_ctx = ice_get_vsi_ctx(hw, vsi_handle);
>         if (!vsi_ctx)
>                 return -EINVAL;
>         /* allocate LAN queue contexts */
>         if (!vsi_ctx->lan_q_ctx[tc]) {
> -               vsi_ctx->lan_q_ctx[tc] = devm_kcalloc(ice_hw_to_dev(hw),
> -                                                     new_numqs,
> -                                                     sizeof(*q_ctx),
> -                                                     GFP_KERNEL);
> -               if (!vsi_ctx->lan_q_ctx[tc])
> +               q_ctx = devm_kcalloc(ice_hw_to_dev(hw), new_numqs,
> +                                    sizeof(*q_ctx), GFP_KERNEL);
> +               if (!q_ctx)
>                         return -ENOMEM;
> +
> +               for (idx = 0; idx < new_numqs; idx++) {
> +                       q_ctx[idx].q_handle = ICE_INVAL_Q_HANDLE;
> +                       q_ctx[idx].q_teid = ICE_INVAL_TEID;
> +               }
> +
> +               vsi_ctx->lan_q_ctx[tc] = q_ctx;
>                 vsi_ctx->num_lan_q_entries[tc] = new_numqs;
>                 return 0;
>         }
> @@ -595,9 +601,16 @@ ice_alloc_lan_q_ctx(struct ice_hw *hw, u16 vsi_handle, u8 tc, u16 new_numqs)
>                                      sizeof(*q_ctx), GFP_KERNEL);
>                 if (!q_ctx)
>                         return -ENOMEM;
> +
>                 memcpy(q_ctx, vsi_ctx->lan_q_ctx[tc],
>                        prev_num * sizeof(*q_ctx));
>                 devm_kfree(ice_hw_to_dev(hw), vsi_ctx->lan_q_ctx[tc]);
> +
> +               for (idx = prev_num; idx < new_numqs; idx++) {
> +                       q_ctx[idx].q_handle = ICE_INVAL_Q_HANDLE;
> +                       q_ctx[idx].q_teid = ICE_INVAL_TEID;
> +               }
> +
>                 vsi_ctx->lan_q_ctx[tc] = q_ctx;
>                 vsi_ctx->num_lan_q_entries[tc] = new_numqs;
>         }
> --
> 2.40.1
> 
>

Hi Dave,

This does not apply to my net-next tree, but I guess that falls under
your 'fat-fingered' comment. I am still going ahead and reviewing this
version.

As for this patch:

Reviewed-by: Daniel Machon <daniel.machon@microchip.com>


