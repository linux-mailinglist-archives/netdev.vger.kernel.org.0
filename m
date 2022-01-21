Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B795A496280
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 17:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381726AbiAUQAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 11:00:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381731AbiAUQAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 11:00:15 -0500
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAA0FC061401;
        Fri, 21 Jan 2022 08:00:14 -0800 (PST)
Received: from [IPV6:2003:e9:d70c:7733:6a50:4603:7591:b048] (p200300e9d70c77336a5046037591b048.dip0.t-ipconnect.de [IPv6:2003:e9:d70c:7733:6a50:4603:7591:b048])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 03DB6C05A4;
        Fri, 21 Jan 2022 17:00:10 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1642780811;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iC5RnqdqkyoCjekA4tZvGpeSxet8pxQyzrvWnq6zJ60=;
        b=RKKjHZgO862SvAXujd53vYCv0eFOXxI7TH5ZiQA6roBb+Hoqwx9ijZMju/wwPxSLapHVdd
        QptSjgAKHi6HutqNGyXV65JNc2OOJxo9fGHIDJfK7rI/Ob/keX4eugI3lMt++ikKSmsiFm
        AaZ/OVoGjz66b8oW6D4AuOZUYlCVsmFKxsVbNvQulboSNaxHSj4bJfhfPyYPeELEheAkHv
        VuStPVcmk9t6nGO9Msi6xLLqtH761CokndPD+LNM/UlgzrVcQK2obSowD2OrQtSgpwNHcD
        x2h0V2pnSqMDR9B6hdiOVMeQeqfADBWS++8e0Z6ihHDeGUUuhK7ngoENSmm+hw==
Message-ID: <faea7b84-d89e-5ba0-9169-5fb8ddf98dc5@datenfreihafen.org>
Date:   Fri, 21 Jan 2022 17:00:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [wpan-next v2 6/9] net: ieee802154: Use the IEEE802154_MAX_PAGE
 define when relevant
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
 <20220120112115.448077-7-miquel.raynal@bootlin.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20220120112115.448077-7-miquel.raynal@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hello.

On 20.01.22 12:21, Miquel Raynal wrote:
> This define already exist but is hardcoded in nl-phy.c. Use the
> definition when relevant.
> 
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>   net/ieee802154/nl-phy.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/net/ieee802154/nl-phy.c b/net/ieee802154/nl-phy.c
> index dd5a45f8a78a..02f6a53d0faa 100644
> --- a/net/ieee802154/nl-phy.c
> +++ b/net/ieee802154/nl-phy.c
> @@ -30,7 +30,8 @@ static int ieee802154_nl_fill_phy(struct sk_buff *msg, u32 portid,
>   {
>   	void *hdr;
>   	int i, pages = 0;
> -	uint32_t *buf = kcalloc(32, sizeof(uint32_t), GFP_KERNEL);
> +	uint32_t *buf = kcalloc(IEEE802154_MAX_PAGE + 1, sizeof(uint32_t),

Please use u32 here. I know we have some uint*_t leftovers but for new 
code we should not use them anymore.

> +				GFP_KERNEL);
>   
>   	pr_debug("%s\n", __func__);
>   
> @@ -47,7 +48,7 @@ static int ieee802154_nl_fill_phy(struct sk_buff *msg, u32 portid,
>   	    nla_put_u8(msg, IEEE802154_ATTR_PAGE, phy->current_page) ||
>   	    nla_put_u8(msg, IEEE802154_ATTR_CHANNEL, phy->current_channel))
>   		goto nla_put_failure;
> -	for (i = 0; i < 32; i++) {
> +	for (i = 0; i <= IEEE802154_MAX_PAGE; i++) {
>   		if (phy->supported.channels[i])
>   			buf[pages++] = phy->supported.channels[i] | (i << 27);
>   	}
> 

regards
Stefan Schmidt
