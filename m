Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6103A265F50
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 14:13:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725777AbgIKMNb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 08:13:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:27470 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725710AbgIKMML (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Sep 2020 08:12:11 -0400
IronPort-SDR: 79dnkh240JB5g8hhw6Lf9Qhdo4m+O5krF87lUP8I+QjBxiuWx4rWHGkvZnoD1LSBATM9HxgU0+
 okCjq1QrHHrA==
X-IronPort-AV: E=McAfee;i="6000,8403,9740"; a="176806750"
X-IronPort-AV: E=Sophos;i="5.76,415,1592895600"; 
   d="scan'208";a="176806750"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2020 05:11:26 -0700
IronPort-SDR: Lxq5tsUFDalIi32UgpA0sesjqCmyJ6/7Q5jzGLiZGEeOrMYlWSu2wfMcaSetZKbmykttHykEGc
 sxyPutPblglQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,415,1592895600"; 
   d="scan'208";a="344616585"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga007.jf.intel.com with ESMTP; 11 Sep 2020 05:11:24 -0700
Date:   Fri, 11 Sep 2020 14:05:19 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     magnus.karlsson@intel.com, bjorn.topel@intel.com,
        intel-wired-lan@lists.osuosl.org, jeffrey.t.kirsher@intel.com,
        netdev@vger.kernel.org, maciejromanfijalkowski@gmail.com
Subject: Re: [PATCH net-next] i40e: allow VMDQs to be used with AF_XDP
 zero-copy
Message-ID: <20200911120519.GA9758@ranger.igk.intel.com>
References: <1599826106-19020-1-git-send-email-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1599826106-19020-1-git-send-email-magnus.karlsson@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 11, 2020 at 02:08:26PM +0200, Magnus Karlsson wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Allow VMDQs to be used with AF_XDP sockets in zero-copy mode. For some
> reason, we only allowed main VSIs to be used with zero-copy, but
> there is now reason to not allow VMDQs also.

You meant 'to allow' I suppose. And what reason? :)

> 
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_xsk.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> index 2a1153d..ebe15ca 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> @@ -45,7 +45,7 @@ static int i40e_xsk_pool_enable(struct i40e_vsi *vsi,
>  	bool if_running;
>  	int err;
>  
> -	if (vsi->type != I40E_VSI_MAIN)
> +	if (!(vsi->type == I40E_VSI_MAIN || vsi->type == I40E_VSI_VMDQ2))
>  		return -EINVAL;
>  
>  	if (qid >= vsi->num_queue_pairs)
> -- 
> 2.7.4
> 
