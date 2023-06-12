Return-Path: <netdev+bounces-9975-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 255FB72B81F
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 08:34:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5217928110D
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 06:34:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77CE2C2D3;
	Mon, 12 Jun 2023 06:34:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A07B2567
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 06:34:23 +0000 (UTC)
Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 722311705;
	Sun, 11 Jun 2023 23:29:22 -0700 (PDT)
Received: from [192.168.0.185] (ip5f5aee35.dynamic.kabel-deutschland.de [95.90.238.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 3A68161EA1BFF;
	Mon, 12 Jun 2023 08:23:27 +0200 (CEST)
Message-ID: <77eaaa44-25af-84c4-91ec-c7b5ec2f6f64@molgen.mpg.de>
Date: Mon, 12 Jun 2023 08:23:24 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [Intel-wired-lan] [PATCH net-next] ice: Remove managed memory
 usage in ice_get_fw_log_cfg()
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>,
 Tony Nguyen <anthony.l.nguyen@intel.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 intel-wired-lan@lists.osuosl.org, kernel-janitors@vger.kernel.org,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <e86a1ab7b450462a1e92264dccb5a5855546e384.1686516193.git.christophe.jaillet@wanadoo.fr>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <e86a1ab7b450462a1e92264dccb5a5855546e384.1686516193.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Dear Christophe,


Thank you for the patch.

Am 11.06.23 um 22:44 schrieb Christophe JAILLET:
> There is no need to use managed memory allocation here. The memory is
> released at the end of the function.
> 
> You kzalloc()/kfree() to simplify the code.

s/You/Use/?


Kind regards,

Paul


> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>   drivers/net/ethernet/intel/ice/ice_common.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
> index eb2dc0983776..4b799a5d378a 100644
> --- a/drivers/net/ethernet/intel/ice/ice_common.c
> +++ b/drivers/net/ethernet/intel/ice/ice_common.c
> @@ -834,7 +834,7 @@ static int ice_get_fw_log_cfg(struct ice_hw *hw)
>   	u16 size;
>   
>   	size = sizeof(*config) * ICE_AQC_FW_LOG_ID_MAX;
> -	config = devm_kzalloc(ice_hw_to_dev(hw), size, GFP_KERNEL);
> +	config = kzalloc(size, GFP_KERNEL);
>   	if (!config)
>   		return -ENOMEM;
>   
> @@ -857,7 +857,7 @@ static int ice_get_fw_log_cfg(struct ice_hw *hw)
>   		}
>   	}
>   
> -	devm_kfree(ice_hw_to_dev(hw), config);
> +	kfree(config);
>   
>   	return status;
>   }

