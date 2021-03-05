Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A24C32E441
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 10:04:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbhCEJEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 04:04:05 -0500
Received: from mx3.molgen.mpg.de ([141.14.17.11]:51989 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229631AbhCEJEB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Mar 2021 04:04:01 -0500
Received: from [192.168.0.2] (ip5f5aea8b.dynamic.kabel-deutschland.de [95.90.234.139])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id BE07820647914;
        Fri,  5 Mar 2021 10:03:58 +0100 (CET)
Subject: Re: [Intel-wired-lan] [PATCH RESEND][next] ice: Fix fall-through
 warnings for Clang
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-hardening@vger.kernel.org, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, linux-kernel@vger.kernel.org
References: <20210305085257.GA138498@embeddedor>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <833549f5-a191-b532-50bf-4ec343c48dd0@molgen.mpg.de>
Date:   Fri, 5 Mar 2021 10:03:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210305085257.GA138498@embeddedor>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Gustavo,


Thank you for working on that.

Am 05.03.21 um 09:52 schrieb Gustavo A. R. Silva:
> In preparation to enable -Wimplicit-fallthrough for Clang, fix a warning
> by explicitly adding a break statement instead of just letting the code
> fall through to the next case.

It would be nice to have a short summary of the discrepancy between GCC 
and clang, and it was decided to go with the “clang decision”, and not 
have clang adapt to GCC.

> Link: https://github.com/KSPP/linux/issues/115
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>   drivers/net/ethernet/intel/ice/ice_txrx_lib.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
> index 02b12736ea80..207f6ee3a7f6 100644
> --- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
> +++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
> @@ -143,6 +143,7 @@ ice_rx_csum(struct ice_ring *ring, struct sk_buff *skb,
>   	case ICE_RX_PTYPE_INNER_PROT_UDP:
>   	case ICE_RX_PTYPE_INNER_PROT_SCTP:
>   		skb->ip_summed = CHECKSUM_UNNECESSARY;
> +		break;
>   	default:
>   		break;
>   	}


Kind regards,

Paul
