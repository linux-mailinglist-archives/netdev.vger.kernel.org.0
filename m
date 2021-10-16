Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA91430508
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 23:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235312AbhJPVVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 17:21:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbhJPVV3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Oct 2021 17:21:29 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07E30C061765
        for <netdev@vger.kernel.org>; Sat, 16 Oct 2021 14:19:21 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id np13so9621944pjb.4
        for <netdev@vger.kernel.org>; Sat, 16 Oct 2021 14:19:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=H2vfa1KnTkQVtDRUFEuIFMq6bjCePka0fFqwVfsNpro=;
        b=SaAw+vrHjgj6xe4D6sG+dAilqogSOr3KgbPpneB1nxAObbYcyuqRiCAkQtCTxnRHps
         5nrx6kh7FQN8m8n/flrmwq6J/tPXAxt8t88X0p8Ur/VoFEwjQ/2KXt3Nwz2+H7nacSCK
         4LZjpoP8Fo2u4LbJqpPXL7ZadJbVzDutyuM5NTBRb4MHzznkwkmvYpMMmtm/cnDC1aIG
         hXoCwBwRnzfvJ1P9ff5ItM/2dKHOt9tXRHx2L+FFWn00gsCvfaXXecuCWHk8OMbCWDsF
         okBJ0EzTCFZd9oyh/Nfj7yr76h0i8KhuqTn+ymkatdRc9CxNDR8HNIKMwEotXZ/C+Zpx
         SgTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=H2vfa1KnTkQVtDRUFEuIFMq6bjCePka0fFqwVfsNpro=;
        b=ok6ZFyQSsMa/fKBPtURvm7bBNLANvUjlP04FXY4H/xz7sYaXZ159NBhqRO3exNTrqN
         HjXP6Fv+SemCEISwarNG6Ul4fPzffr4BHE+y3xYcyMI30QT172U6zqABnjnhNh7vvOMe
         LM7m0qY7bg4rZynNzOfa3pFBPcr/xo/LE/gO1HTSMjKdpDnakUoceEVlI7M9ugTbzIfO
         OXcK5uL1Z515tdBI0dqwZqFk/QIwaEHTRmuBB0ZtnYnKpvUnufA2SPfO6sy+rjXzljqM
         l68CRAe4lMWzN+JnvaN9l6dm4g6SOdHVfKcTC+ryjYyY6iBUjXrJ6eukJDVUQiePiMH7
         fcKg==
X-Gm-Message-State: AOAM532oo9zp5nP5D5qrgJnR5hUBtOhpuUKAfYGCUma9oXdCSHPmb+x+
        YPK4oMCVNkIR8LmIWt8sBLmA1JMIycqCiw==
X-Google-Smtp-Source: ABdhPJyGaldEvqsGtN/uCiB9ILRO+P3+JFPg6lCdFX504uVBk+EInVnUuljgpjySqr9OQe+NaDKYcQ==
X-Received: by 2002:a17:903:1247:b0:139:f1af:c044 with SMTP id u7-20020a170903124700b00139f1afc044mr18292552plh.23.1634419160534;
        Sat, 16 Oct 2021 14:19:20 -0700 (PDT)
Received: from [192.168.0.14] ([50.53.47.17])
        by smtp.gmail.com with ESMTPSA id i2sm15021838pjg.48.2021.10.16.14.19.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Oct 2021 14:19:20 -0700 (PDT)
Message-ID: <186dd3ec-6bab-fe3c-cbab-a54898d51f57@pensando.io>
Date:   Sat, 16 Oct 2021 14:19:18 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.0
Subject: Re: [RFC net-next 3/6] ethernet: prestera: use eth_hw_addr_set_port()
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     olteanv@gmail.com, andrew@lunn.ch, idosch@idosch.org,
        f.fainelli@gmail.com, vkochan@marvell.com, tchornyi@marvell.com
References: <20211015193848.779420-1-kuba@kernel.org>
 <20211015193848.779420-4-kuba@kernel.org>
From:   Shannon Nelson <snelson@pensando.io>
In-Reply-To: <20211015193848.779420-4-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/15/21 12:38 PM, Jakub Kicinski wrote:
> Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
> of VLANs...") introduced a rbtree for faster Ethernet address look
> up. To maintain netdev->dev_addr in this tree we need to make all
> the writes to it got through appropriate helpers.
>
> We need to make sure the last byte is zeroed.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: vkochan@marvell.com
> CC: tchornyi@marvell.com
> ---
>   drivers/net/ethernet/marvell/prestera/prestera_main.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
> index b667f560b931..7d179927dabe 100644
> --- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
> +++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
> @@ -290,6 +290,7 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
>   {
>   	struct prestera_port *port;
>   	struct net_device *dev;
> +	u8 addr[ETH_ALEN] = {};
>   	int err;
>   
>   	dev = alloc_etherdev(sizeof(*port));
> @@ -341,8 +342,8 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
>   	/* firmware requires that port's MAC address consist of the first
>   	 * 5 bytes of the base MAC address
>   	 */
> -	memcpy(dev->dev_addr, sw->base_mac, dev->addr_len - 1);
> -	dev->dev_addr[dev->addr_len - 1] = port->fp_id;
> +	memcpy(addr, sw->base_mac, dev->addr_len - 1);
> +	eth_hw_addr_set_port(dev, addr, port->fp_id);

Notice in this case I think the original code is setting the last byte 
to port->fp_id, found I think by a call to their firmware, not by adding 
fp_id to the existing byte value.

This is an example of how I feel a bit queezy about this suggested 
helper: each driver that does something like this may need to do it 
slightly differently depending upon how their hardware/firmware works.  
We may be trying to help too much here.

As a potential consumer of these helpers, I'd rather do my own mac 
address byte twiddling and then use eth_hw_addr_set() to put it into place.

sln


>   
>   	err = prestera_hw_port_mac_set(port, dev->dev_addr);
>   	if (err) {

