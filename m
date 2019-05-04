Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B01A136FA
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 04:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbfEDCHm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 22:07:42 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:38421 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726059AbfEDCHl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 22:07:41 -0400
Received: by mail-pg1-f193.google.com with SMTP id j26so3590341pgl.5;
        Fri, 03 May 2019 19:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=38+4eU8WgqZwPRPwmTdRt5lD2lmx6xd+gWZh4oao4Mw=;
        b=NpnaNJZ+ZjJBwtiAZryBHs3e5jDy7zGcBHZNsCYK5RUApK29m9vLtrWBewlgKRYQBp
         2z2TmqR9thnzJBgPKE0xnCz03VViGry9MLrGsYyWaCk/Tulx09Jv2VME2t/6pzMo3OIN
         iY6YfIH24iASLB7GoZQrMKO7eSp0onbEs5HGvPgWgsaZ9/bv3UHxdRXxFV0vvK/rMYjz
         mby8dnZbnxtjiO/a1vDDgQanXI/8EJHOoIkwVbzD+D6jPu/loGMuQ9Qc5H2Qz3MmLDWJ
         sU/evkNPzUb7e1JpBKjLS6O8AgmlDBqKKL+lWpT9FQuefDNvkr3DGEnNHArIh26qF5Dh
         L0gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=38+4eU8WgqZwPRPwmTdRt5lD2lmx6xd+gWZh4oao4Mw=;
        b=pCCIolnELmjvn+9uYqxMFBpg7rrNe1+Z4H3J+VeYLJ4bjcTDS2obhj+E+nXPvslQb7
         dMFzCQOJZjG+uT88f3dYVM0//RbiGn5R/CWgrSKEEtQ5C8LZJ0YQY1ix/ZrUoCA/YUBs
         qW6jk0c5HDQYjdBASsbl/1VGx/hogyELX0kP+vGSxMhJBgJTgAit02pOJtJfOo1HBscY
         v735NUTIbhuPtSC83qKAB5ta57uUrHoWaWX8Cfe1L0VyTRVrK85x/2iQN2EItAZlZrVi
         DXxVXo5FX3SiHr37ADCZKRTf43qZq5opvzvijTPmZjTDBxzyhX+gi78bTnqSwfQf3GVo
         JRQw==
X-Gm-Message-State: APjAAAXrVMkcSDutumOsBcMrGMgrFYvjtfr5C9e9yCzNMPW/Q9AAfNv7
        G4jUk7O/ZPXWL8ZflYjDIIKzQ00C
X-Google-Smtp-Source: APXvYqyVijvW2WSBxF0LRYWIF0AVfL4T8/oWXKh2ztmFogrmIfKHZ3bGGHSOslw/AjcRPAF8lOpVng==
X-Received: by 2002:a63:4a5a:: with SMTP id j26mr14329988pgl.361.1556935660616;
        Fri, 03 May 2019 19:07:40 -0700 (PDT)
Received: from [10.230.28.107] ([192.19.223.250])
        by smtp.gmail.com with ESMTPSA id f15sm3976351pgf.18.2019.05.03.19.07.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 May 2019 19:07:39 -0700 (PDT)
Subject: Re: [PATCH net-next 5/9] net: dsa: Add support for deferred xmit
To:     Vladimir Oltean <olteanv@gmail.com>, vivien.didelot@gmail.com,
        andrew@lunn.ch, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190504011826.30477-1-olteanv@gmail.com>
 <20190504011826.30477-6-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <3232ef43-d568-0851-4511-6fe7c86d9e8a@gmail.com>
Date:   Fri, 3 May 2019 19:07:37 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190504011826.30477-6-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/3/2019 6:18 PM, Vladimir Oltean wrote:
> Some hardware needs to take some convincing work in order to receive
> frames on the CPU port (such as the sja1105 which takes temporary L2
> forwarding rules over SPI that last for a single frame). Such work needs
> a sleepable context, and because the regular .ndo_start_xmit is atomic,
> this cannot be done in the tagger. So introduce a generic DSA mechanism
> that sets up a transmit skb queue and a workqueue for deferred
> transmission.
> 
> The new driver callback (.port_deferred_xmit) is in dsa_switch and not
> in the tagger because the operations that require sleeping typically
> also involve interacting with the hardware, and not simply skb
> manipulations. Therefore having it there simplifies the structure a bit
> and makes it unnecessary to export functions from the driver to the
> tagger.
> 
> The driver is responsible of calling dsa_enqueue_skb which transfers it
> to the master netdevice. This is so that it has a chance of performing
> some more work afterwards, such as cleanup or TX timestamping.
> 
> To tell DSA that skb xmit deferral is required, I have thought about
> changing the return type of the tagger .xmit from struct sk_buff * into
> a enum dsa_tx_t that could potentially encode a DSA_XMIT_DEFER value.
> 
> But the trailer tagger is reallocating every skb on xmit and therefore
> making a valid use of the pointer return value. So instead of reworking
> the API in complicated ways, right now a boolean property in the newly
> introduced DSA_SKB_CB is set.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> ---

[snip]

>  static inline struct dsa_port *dsa_slave_to_port(const struct net_device *dev)
>  {
>  	struct dsa_slave_priv *p = netdev_priv(dev);
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index 8ad9bf957da1..cfb8cba6458c 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -120,6 +120,9 @@ static int dsa_slave_close(struct net_device *dev)
>  	struct net_device *master = dsa_slave_to_master(dev);
>  	struct dsa_port *dp = dsa_slave_to_port(dev);
>  
> +	cancel_work_sync(&dp->xmit_work);
> +	skb_queue_purge(&dp->xmit_queue);
> +
>  	phylink_stop(dp->pl);

Don't you also need to do that for dsa_slave_suspend() in case the
xmit() raced with netif_device_detach() somehow?


-- 
Florian
