Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0D3349628B
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 17:02:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381765AbiAUQB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 11:01:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381761AbiAUQBs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 11:01:48 -0500
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9EADC061744;
        Fri, 21 Jan 2022 08:01:47 -0800 (PST)
Received: from [IPV6:2003:e9:d70c:7733:6a50:4603:7591:b048] (p200300e9d70c77336a5046037591b048.dip0.t-ipconnect.de [IPv6:2003:e9:d70c:7733:6a50:4603:7591:b048])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 25CC9C051B;
        Fri, 21 Jan 2022 17:01:46 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1642780906;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uGCKLhpDY3wR2EwywhWtpaHmQtc2sgXRghldfRzyTR0=;
        b=VrYv/MEeLCU0qDvXfsQ/FOHsWM+eJkG0E6AyqFPaGgZi/xg8EyD5s0n7sNvn+wXgu+Opxd
        5Q1XJ9ZVr+80QEqgRNnpB8uz0fIj8/TFKFocMfG4xHbIGavsP8SONMWTkCFxSWa40LxOqe
        aTcS5aGLRmVWo8dYRFIu8ayuHR06ijgyBw2Zis4kkzqvwPEXRx8da9uemenqRJ3oOfGyC8
        ykK72fs6/+Zpjl6jae30HYCC6ZWSj3Ttc8MYu+5ZFcnHFqnVSqLgWQYT4rLF8rZplMdXKS
        cSbpGaM0tXMJYZX7eIU4Cm8eIox/LlPHTmqpeB2dS7keOcoTLU7CyemsDC35ow==
Message-ID: <43295627-66c0-3dee-3127-ae9d60eaf8fe@datenfreihafen.org>
Date:   Fri, 21 Jan 2022 17:01:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [wpan-next v2 3/9] net: ieee802154: mcr20a: Fix lifs/sifs periods
Content-Language: en-US
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Alexander Aring <alex.aring@gmail.com>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Xue Liu <liuxuenetmail@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Harry Morris <harrymorris12@gmail.com>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
References: <20220120112115.448077-1-miquel.raynal@bootlin.com>
 <20220120112115.448077-4-miquel.raynal@bootlin.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20220120112115.448077-4-miquel.raynal@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Xue.

You are still listed as maintainer for the mcr20a driver, thus this mail.

On 20.01.22 12:21, Miquel Raynal wrote:
> These periods are expressed in time units (microseconds) while 40 and 12
> are the number of symbol durations these periods will last. We need to
> multiply them both with phy->symbol_duration in order to get these
> values in microseconds.
> 
> Fixes: 8c6ad9cc5157 ("ieee802154: Add NXP MCR20A IEEE 802.15.4 transceiver driver")
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>   drivers/net/ieee802154/mcr20a.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ieee802154/mcr20a.c b/drivers/net/ieee802154/mcr20a.c
> index 8dc04e2590b1..383231b85464 100644
> --- a/drivers/net/ieee802154/mcr20a.c
> +++ b/drivers/net/ieee802154/mcr20a.c
> @@ -976,8 +976,8 @@ static void mcr20a_hw_setup(struct mcr20a_local *lp)
>   	dev_dbg(printdev(lp), "%s\n", __func__);
>   
>   	phy->symbol_duration = 16;
> -	phy->lifs_period = 40;
> -	phy->sifs_period = 12;
> +	phy->lifs_period = 40 * phy->symbol_duration;
> +	phy->sifs_period = 12 * phy->symbol_duration;

To me this looks correct and I would go ahead and apply it. Xue, if you 
disagree please reply and explain why.

regards
Stefan Schmidt
