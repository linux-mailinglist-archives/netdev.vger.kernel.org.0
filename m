Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04F1B17E76
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 18:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728612AbfEHQuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 12:50:18 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:37226 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728504AbfEHQuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 12:50:18 -0400
Received: by mail-lj1-f195.google.com with SMTP id n4so2173693ljg.4
        for <netdev@vger.kernel.org>; Wed, 08 May 2019 09:50:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ragnatech-se.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=Q99ruiR45gwJaY1hsK6c83Y6z2eZZAuP8Z6Cbgg66WE=;
        b=Md27NvOP3Feqx9koFHHvNNz+jAco4I2TgDJn6/j97L+lR1XanNp6aLHcE4sPAQDHDP
         iN6zGYrtLfo6y+5EZfa8o/WvXTB3IAJjRvYcqa7+EKwdUrZcF+bV4dkk5hlR3Et6b0DJ
         +g/g/qjpyfNWTCNytLW9geso6rT0U28XuTEmiIJdwY3QTFSL6dLN04akwIKpLnqslFdp
         tVWXMMsmDtMGMDXDvuWv+paE50nXKlvtD3+dFbpcqB/XvWb0ouQzeMkzgFcSV6LTzqMv
         w1Boq2tdfDF7Mqwq0JPTEKxTu+uXUu837r/yNbasUcKLKXu96ivXT4iNnqOYef78RPe+
         XbPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=Q99ruiR45gwJaY1hsK6c83Y6z2eZZAuP8Z6Cbgg66WE=;
        b=AzWcrS3X3GVJrs9BTKKAuKTI3r20eaoQ6na6SzUTLs8mms/NTrj1uECnS+i9CXp/rY
         V6xsPV3+asHCCfynyfBFxybC5gBYTAECILpX6rWg8xZd9nFq/8nq2ihvNQkmJNpTyJ3H
         qUbXacmzFgsQkxEvZjf/zhkk9N1NJpSqwZ0+a9qtoBwrYLBw13D+5JXYVMxXPynijV2z
         rrKDegWaPv8lerrGT9DzYn9OrMX4xZk3Etc11aN+CFjJ83i41nzID7q2DoYdV3m45hUX
         g9AtDKuXPBrmBse3XMN+uQ+DK6YRlH9uGozM6gdGv30plWgTZzut5KpzM9ww/wrCvrBl
         14Lg==
X-Gm-Message-State: APjAAAXtWIYpGvARnB1IvnL4Y58mvEsqRluP0RgLW7eCPHePwk1Yupc0
        vkZhG25hkf9+PbEKqSOryEmhMA==
X-Google-Smtp-Source: APXvYqx4UijH/NEfhOJhhkDu0737FBjafPO3FRlWWRMGv6aiYIGIoFccbw1hFYwSoGbWh22miqLLWQ==
X-Received: by 2002:a2e:3c06:: with SMTP id j6mr19686763lja.99.1557334216429;
        Wed, 08 May 2019 09:50:16 -0700 (PDT)
Received: from localhost (89-233-230-99.cust.bredband2.com. [89.233.230.99])
        by smtp.gmail.com with ESMTPSA id x2sm4007373ljx.13.2019.05.08.09.50.15
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 08 May 2019 09:50:15 -0700 (PDT)
Date:   Wed, 8 May 2019 18:50:15 +0200
From:   Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund@ragnatech.se>
To:     Ulrich Hecht <uli+renesas@fpond.eu>
Cc:     linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, wsa@the-dreams.de, horms@verge.net.au,
        magnus.damm@gmail.com
Subject: Re: [PATCH] ravb: implement MTU change while device is up
Message-ID: <20190508165015.GD24112@bigcity.dyn.berto.se>
References: <1557328882-24307-1-git-send-email-uli+renesas@fpond.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1557328882-24307-1-git-send-email-uli+renesas@fpond.eu>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ulrich,

Thanks for your patch.

On 2019-05-08 17:21:22 +0200, Ulrich Hecht wrote:
> Uses the same method as various other drivers: shut the device down,
> change the MTU, then bring it back up again.
> 
> Tested on Renesas D3 Draak board.
> 
> Signed-off-by: Ulrich Hecht <uli+renesas@fpond.eu>

With or without the code relayout suggested by Sergei,

Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

Also as he points out I used the same pattern for sh_eth while adding 
MTU configuration support so a similar patch there would be nice. I'm 
happy to see the fix to allow for changing the MTU when the device is up 
was so simple, yet I could not figure it out ;-) Nice work!

> ---
>  drivers/net/ethernet/renesas/ravb_main.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
> index ef8f089..02c247c 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
> @@ -1810,13 +1810,16 @@ static int ravb_do_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
>  
>  static int ravb_change_mtu(struct net_device *ndev, int new_mtu)
>  {
> -	if (netif_running(ndev))
> -		return -EBUSY;
> +	if (!netif_running(ndev)) {
> +		ndev->mtu = new_mtu;
> +		netdev_update_features(ndev);
> +		return 0;
> +	}
>  
> +	ravb_close(ndev);
>  	ndev->mtu = new_mtu;
> -	netdev_update_features(ndev);
>  
> -	return 0;
> +	return ravb_open(ndev);
>  }
>  
>  static void ravb_set_rx_csum(struct net_device *ndev, bool enable)
> -- 
> 2.7.4
> 

-- 
Regards,
Niklas Söderlund
