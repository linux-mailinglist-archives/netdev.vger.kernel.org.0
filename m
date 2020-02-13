Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94D8115BFE3
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 15:00:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730156AbgBMOAE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 09:00:04 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:56633 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730036AbgBMOAE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 09:00:04 -0500
Received: from soja.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:13da])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <o.rempel@pengutronix.de>)
        id 1j2F28-0005zr-0t; Thu, 13 Feb 2020 15:00:00 +0100
Subject: Re: [PATCH net 2/2] net: dsa: tag_ar9331: Make sure there is headroom
 for tag
To:     Per@axis.com, "\"Forlin" <"per.forlin\""@axis.co>,
        netdev@vger.kernel.org, andrew@lunn.ch, davem@davemloft.net
Cc:     Per Forlin <per.forlin@axis.com>, Per Forlin <perfn@axis.com>
References: <20200213135100.2963-1-per.forlin@axis.com>
 <20200213135100.2963-3-per.forlin@axis.com>
From:   Oleksij Rempel <o.rempel@pengutronix.de>
Message-ID: <e1c554fa-fde7-0e8b-959d-603e66db54b0@pengutronix.de>
Date:   Thu, 13 Feb 2020 14:59:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200213135100.2963-3-per.forlin@axis.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:3ad5:47ff:feaf:13da
X-SA-Exim-Mail-From: o.rempel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 13.02.20 14:51, Per@axis.com wrote:
> From: Per Forlin <per.forlin@axis.com>
> 
> Passing tag size to skb_cow_head will make sure
> there is enough headroom for the tag data.
> This change does not introduce any overhead in case there
> is already available headroom for tag.
> 
> Signed-off-by: Per Forlin <perfn@axis.com>

Tested-by: Oleksij Rempel <o.rempel@pengutronix.de>

Thank you!

Are you using this driver?

> ---
>   net/dsa/tag_ar9331.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/dsa/tag_ar9331.c b/net/dsa/tag_ar9331.c
> index 466ffa92a474..55b00694cdba 100644
> --- a/net/dsa/tag_ar9331.c
> +++ b/net/dsa/tag_ar9331.c
> @@ -31,7 +31,7 @@ static struct sk_buff *ar9331_tag_xmit(struct sk_buff *skb,
>   	__le16 *phdr;
>   	u16 hdr;
>   
> -	if (skb_cow_head(skb, 0) < 0)
> +	if (skb_cow_head(skb, AR9331_HDR_LEN) < 0)
>   		return NULL;
>   
>   	phdr = skb_push(skb, AR9331_HDR_LEN);
> 

Kind regards,
Oleksij Rempel

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
