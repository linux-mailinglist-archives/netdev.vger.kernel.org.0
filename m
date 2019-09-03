Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A60C0A61AB
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 08:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbfICGms (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 02:42:48 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:38071 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726016AbfICGmr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Sep 2019 02:42:47 -0400
Received: from [192.168.0.6] (ip5f5bd172.dynamic.kabel-deutschland.de [95.91.209.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 0DF8120225704;
        Tue,  3 Sep 2019 08:42:45 +0200 (CEST)
Subject: Re: [Intel-wired-lan] [PATCH] i40e: clear __I40E_VIRTCHNL_OP_PENDING
 on invalid min tx rate
To:     Stefan Assmann <sassmann@kpanic.de>,
        intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <20190903060810.30775-1-sassmann@kpanic.de>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <36909884-1de6-a537-0341-b060d01e4c0d@molgen.mpg.de>
Date:   Tue, 3 Sep 2019 08:42:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190903060810.30775-1-sassmann@kpanic.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Stefan,


On 03.09.19 08:08, Stefan Assmann wrote:
> In the case of an invalid min tx rate being requested
> i40e_ndo_set_vf_bw() immediately returns -EINVAL instead of releasing
> __I40E_VIRTCHNL_OP_PENDING first.

What problem does this cause?

> Signed-off-by: Stefan Assmann <sassmann@kpanic.de>
> ---
>   drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
> index f8aa4deceb5e..3d2440838822 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
> @@ -4263,7 +4263,8 @@ int i40e_ndo_set_vf_bw(struct net_device *netdev, int vf_id, int min_tx_rate,
>   	if (min_tx_rate) {
>   		dev_err(&pf->pdev->dev, "Invalid min tx rate (%d) (greater than 0) specified for VF %d.\n",
>   			min_tx_rate, vf_id);
> -		return -EINVAL;
> +		ret = -EINVAL;
> +		goto error;
>   	}
>   
>   	vf = &pf->vf[vf_id];


Kind regards,

Paul
