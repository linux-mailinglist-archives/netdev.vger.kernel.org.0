Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC8317B03B
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 22:03:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726142AbgCEVDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 16:03:50 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:39838 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbgCEVDt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 16:03:49 -0500
Received: by mail-pl1-f194.google.com with SMTP id j20so2752738pll.6
        for <netdev@vger.kernel.org>; Thu, 05 Mar 2020 13:03:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eH7ynw3jBFgcNBV3X9mskIeEm5wcw4wRTDtmVE20pDs=;
        b=djy9heWz023puFrACD1wI6KQG0yKFXZpDHZSekTyN76vxF0xcF8UCxEBt+4vFibHoM
         38uq7eL2xdr6wE3G9/j335BgFPVM15WN2Jz/d9TxIIfBdNioQ2trswh3UgTzEZwgRTOy
         8/a7+1Giiuds4lrWGIL8k+vtzT3YMir+2PdsMsE2+VtcSu9EYGfYSL6GlFhBA+1GyOg9
         evLUPZGi85Wx7u/gdzPJYA0DTkoG9st4M1SSre8/uaRMs/iQqk9wu5X95HjXahIkek6H
         AoLMRxZtQDr8QZ5MSuXWeqlAiJulT2a/DQGQKxeXAKTGpgWpK/7ebt02mOcZaxxOQhQD
         AtPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eH7ynw3jBFgcNBV3X9mskIeEm5wcw4wRTDtmVE20pDs=;
        b=TaFyKDh1N/TGwYGTSGryQSUrA2TPc19JY9W4FisXjSj0SI/cxg5FNWQqTFwOHCI3KZ
         9CJ7H/qyxhyq6DaFxTG3dAJGXH4ZPkc3rUKqXOioe2i9entGVfYWzmSxnk2VFgLnriq2
         KAdBrwhxEOdcHkWfvRn9h0o1CBDz2P0XvjFhwV9VhPbOc7sT+hOR9h7aLnl3dIp6U5NQ
         A6JeaMUtPhG8Y7ipJ7YfhqedG1KQ31cEWyMpShfWExdlOLIP21+7i8Aq+QEXGc2OM+ZW
         BTEFBFxs47ciRs5NK+89G/dJvP3uc0RIYjVniXSrEgH20TXUTAeQfPZw/6saXicuZFTC
         Gg6Q==
X-Gm-Message-State: ANhLgQ3qwPmqhmkLedY+YRdgWjlMKqlyX1geCqdp6b2beTN2a7lC0oXQ
        gfdh5wPoDNkiokfRZRHwAtY=
X-Google-Smtp-Source: ADFU+vtdDJ0TILR5p8kZbFBX1Vo6ewSYOkDiWNtKjF+7otkBgvSJb5D2NOlKhG0wYBVbU2/bPqMmaQ==
X-Received: by 2002:a17:902:6b03:: with SMTP id o3mr9753297plk.331.1583442228481;
        Thu, 05 Mar 2020 13:03:48 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id b10sm6970055pjo.32.2020.03.05.13.03.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Mar 2020 13:03:47 -0800 (PST)
Subject: Re: [PATCH net] ipvlan: do not add hardware address of master to its
 unicast filter list
To:     Jiri Wiesner <jwiesner@suse.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Mahesh Bandewar <maheshb@google.com>,
        Andreas Taschner <Andreas.Taschner@suse.com>,
        Michal Kubecek <mkubecek@suse.cz>
References: <20200305193101.GA16264@incl>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <36cdfab2-aa29-fa21-2f46-bf9d744ee6db@gmail.com>
Date:   Thu, 5 Mar 2020 13:03:46 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200305193101.GA16264@incl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/5/20 11:31 AM, Jiri Wiesner wrote:
> There is a problem when ipvlan slaves are created on a master device that
> is a vmxnet3 device (ipvlan in VMware guests). The vmxnet3 driver does not
> support unicast address filtering. When an ipvlan device is brought up in
> ipvlan_open(), the ipvlan driver calls dev_uc_add() to add the hardware
> address of the vmxnet3 master device to the unicast address list of the
> master device, phy_dev->uc. This inevitably leads to the vmxnet3 master
> device being forced into promiscuous mode by __dev_set_rx_mode().
> 
> Promiscuous mode is switched on the master despite the fact that there is
> still only one hardware address that the master device should use for
> filtering in order for the ipvlan device to be able to receive packets.
> The comment above struct net_device describes the uc_promisc member as a
> "counter, that indicates, that promiscuous mode has been enabled due to
> the need to listen to additional unicast addresses in a device that does
> not implement ndo_set_rx_mode()". Moreover, the design of ipvlan
> guarantees that only the hardware address of a master device,
> phy_dev->dev_addr, will be used to transmit and receive all packets from
> its ipvlan slaves. Thus, the unicast address list of the master device
> should not be modified by ipvlan_open() and ipvlan_stop() in order to make
> ipvlan a workable option on masters that do not support unicast address
> filtering.
> 
> Fixes: 2ad7bf3638411 ("ipvlan: Initial check-in of the IPVLAN driver")
> Reported-by: Per Sundstrom <per.sundstrom@redqube.se>
> Signed-off-by: Jiri Wiesner <jwiesner@suse.com>
> ---
>  drivers/net/ipvlan/ipvlan_main.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_main.c
> index a70662261a5a..f23214003d42 100644
> --- a/drivers/net/ipvlan/ipvlan_main.c
> +++ b/drivers/net/ipvlan/ipvlan_main.c
> @@ -178,7 +178,7 @@ static int ipvlan_open(struct net_device *dev)
>  		ipvlan_ht_addr_add(ipvlan, addr);
>  	rcu_read_unlock();
>  
> -	return dev_uc_add(phy_dev, phy_dev->dev_addr);
> +	return 0;
>  }
>  
>  static int ipvlan_stop(struct net_device *dev)
> @@ -190,8 +190,6 @@ static int ipvlan_stop(struct net_device *dev)
>  	dev_uc_unsync(phy_dev, dev);
>  	dev_mc_unsync(phy_dev, dev);
>  
> -	dev_uc_del(phy_dev, phy_dev->dev_addr);
> -
>  	rcu_read_lock();
>  	list_for_each_entry_rcu(addr, &ipvlan->addrs, anode)
>  		ipvlan_ht_addr_del(addr);
> 

This makes perfect sense, not sure why we left these calls in ipvlan
submission.

Thanks for the patch !

Reviewed-by: Eric Dumazet <edumazet@google.com>
