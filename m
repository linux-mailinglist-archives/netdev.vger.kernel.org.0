Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9641243F752
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 08:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232027AbhJ2GkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 02:40:06 -0400
Received: from ivanoab7.miniserver.com ([37.128.132.42]:42232 "EHLO
        www.kot-begemot.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232024AbhJ2GkD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 02:40:03 -0400
Received: from tun252.jain.kot-begemot.co.uk ([192.168.18.6] helo=jain.kot-begemot.co.uk)
        by www.kot-begemot.co.uk with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <anton.ivanov@cambridgegreys.com>)
        id 1mgLVo-0001St-C8; Fri, 29 Oct 2021 06:37:15 +0000
Received: from madding.kot-begemot.co.uk ([192.168.3.98])
        by jain.kot-begemot.co.uk with esmtps (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <anton.ivanov@cambridgegreys.com>)
        id 1mgLVk-0005aG-5P; Fri, 29 Oct 2021 07:37:12 +0100
Subject: Re: [PATCH net-next 2/3] net: um: use eth_hw_addr_set()
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, jdike@addtoit.com, richard@nod.at,
        johannes.berg@intel.com, linux-um@lists.infradead.org
References: <20211029024707.316066-1-kuba@kernel.org>
 <20211029024707.316066-3-kuba@kernel.org>
From:   Anton Ivanov <anton.ivanov@cambridgegreys.com>
Organization: Cambridge Greys
Message-ID: <359d5737-2ac9-12aa-cca8-1b0c52def83e@cambridgegreys.com>
Date:   Fri, 29 Oct 2021 07:37:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211029024707.316066-3-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0
X-Spam-Score: -1.0
X-Clacks-Overhead: GNU Terry Pratchett
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/10/2021 03:47, Jakub Kicinski wrote:
> Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
> of VLANs...") introduced a rbtree for faster Ethernet address look
> up. To maintain netdev->dev_addr in this tree we need to make all
> the writes to it go through appropriate helpers.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: jdike@addtoit.com
> CC: richard@nod.at
> CC: anton.ivanov@cambridgegreys.com
> CC: johannes.berg@intel.com
> CC: linux-um@lists.infradead.org
> ---
>   arch/um/drivers/net_kern.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/um/drivers/net_kern.c b/arch/um/drivers/net_kern.c
> index 2fc0b038ff8a..59331384c2d3 100644
> --- a/arch/um/drivers/net_kern.c
> +++ b/arch/um/drivers/net_kern.c
> @@ -276,7 +276,7 @@ static const struct ethtool_ops uml_net_ethtool_ops = {
>   
>   void uml_net_setup_etheraddr(struct net_device *dev, char *str)
>   {
> -	unsigned char *addr = dev->dev_addr;
> +	u8 addr[ETH_ALEN];
>   	char *end;
>   	int i;
>   
> @@ -316,6 +316,7 @@ void uml_net_setup_etheraddr(struct net_device *dev, char *str)
>   		       addr[0] | 0x02, addr[1], addr[2], addr[3], addr[4],
>   		       addr[5]);
>   	}
> +	eth_hw_addr_set(dev, addr);
>   	return;
>   
>   random:
> 

Acked-by: Anton Ivanov <anton.ivanov@cambridgegreys.com>

-- 
Anton R. Ivanov
Cambridgegreys Limited. Registered in England. Company Number 10273661
https://www.cambridgegreys.com/
