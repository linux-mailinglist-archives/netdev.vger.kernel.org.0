Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9F810C4DB
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 09:21:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727493AbfK1IVe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Nov 2019 03:21:34 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41108 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727408AbfK1IVe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Nov 2019 03:21:34 -0500
Received: by mail-wr1-f68.google.com with SMTP id b18so29949291wrj.8
        for <netdev@vger.kernel.org>; Thu, 28 Nov 2019 00:21:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=VOI036BPUwrbZowHT5GDUEXOWOhQmQWDUMNaY8GO7tI=;
        b=aYsQAOKb1A7PKWIf5wGzlAze4eWPmdGPLKe1SsRZU2k+tm4SMPOV4cgWHesnBHGp+S
         UhuJTmeX6pC8+bfFMrJo8ASo5EZgv85U5ojeERcDI6qYQAaU/NdssXIMa4sf40VLFh7d
         7QRRyOvSR6Obq94UORxMiHh7CN+v/LEBj9X0XichLgfdrZezNY4/lhr9mI89UJcIWmN5
         Gib8pPmxplFkJrhJLjiE8xQxxltLaNGhNaQwJbSxtz+OqQUxUJOfoWUpo4Y+8gVUi46T
         qTLyVE8LlvEBsMD81mpln4RLMc4Gd7X3TvzNnjUotecTl3zoL1Ootn/mU1cM2egiLCeO
         YEYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=VOI036BPUwrbZowHT5GDUEXOWOhQmQWDUMNaY8GO7tI=;
        b=erOb7aAb3CKvbCxSzZsL8k2iqejJlxBPoIQub/wWCXSEhOa7tLiwYL4ixCMhC/xtUc
         8lckqUt9kYZlsq6VhpNQZgc84aR6GjbNxRMNgT2O21AHx2qSJ6yjRGvNZJ5xyBZtF70r
         KBhzA2ubussZ7oReWJ97SWiSzMMmWYYQGG1sbmonsj72+GejAKmr5kFWPXPqx/bRslg7
         HGj2ik52ml5Dc8Ug4RaZb/DcQk6xWqIDySV5erdw5s+Hn99rd32ePyox1nd9MJQczwja
         u4KmEHkxW9yLwpGOAxHk+P1XPJqXf6rXvJjtP021u4IpdOd4eonK4gXb8HvGZEni3SQU
         +0rg==
X-Gm-Message-State: APjAAAVMhCtms0Htq7HK3N8OpxObiZWZY6AhB0+qE745QqJRFX8BJUBP
        pCXUsFCiIO4xK6m6TywY/4MBUJyeTXY=
X-Google-Smtp-Source: APXvYqwnYPAyBuUvcvS1pBiBRsm7B8Y/eawgeM5AHpFMzHjgdUnfsDOjjE//piFuuaBq8Ij9fBLegg==
X-Received: by 2002:a5d:43c3:: with SMTP id v3mr38726407wrr.324.1574929290712;
        Thu, 28 Nov 2019 00:21:30 -0800 (PST)
Received: from apalos.home (athedsl-4476713.home.otenet.gr. [94.71.27.49])
        by smtp.gmail.com with ESMTPSA id q3sm502890wrn.33.2019.11.28.00.21.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Nov 2019 00:21:30 -0800 (PST)
Date:   Thu, 28 Nov 2019 10:21:27 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>, Sekhar Nori <nsekhar@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: ti: ale: ensure vlan/mdb deleted when no
 members
Message-ID: <20191128082127.GA16359@apalos.home>
References: <20191127155905.22921-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191127155905.22921-1-grygorii.strashko@ti.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 27, 2019 at 05:59:05PM +0200, Grygorii Strashko wrote:
> The recently updated ALE APIs cpsw_ale_del_mcast() and
> cpsw_ale_del_vlan_modify() have an issue and will not delete ALE entry even
> if VLAN/mcast group has no more members. Hence fix it here and delete ALE
> entry if !port_mask.
> 
> The issue affected only new cpsw switchdev driver.
> 
> Fixes: e85c14370783 ("net: ethernet: ti: ale: modify vlan/mdb api for switchdev")
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> ---
>  drivers/net/ethernet/ti/cpsw_ale.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/ti/cpsw_ale.c b/drivers/net/ethernet/ti/cpsw_ale.c
> index 929f3d3354e3..a5179ecfea05 100644
> --- a/drivers/net/ethernet/ti/cpsw_ale.c
> +++ b/drivers/net/ethernet/ti/cpsw_ale.c
> @@ -396,12 +396,14 @@ int cpsw_ale_del_mcast(struct cpsw_ale *ale, const u8 *addr, int port_mask,
>  	if (port_mask) {
>  		mcast_members = cpsw_ale_get_port_mask(ale_entry,
>  						       ale->port_mask_bits);
> -		mcast_members &= ~port_mask;
> -		cpsw_ale_set_port_mask(ale_entry, mcast_members,
> +		port_mask = mcast_members & ~port_mask;
> +	}
> +
> +	if (port_mask)
> +		cpsw_ale_set_port_mask(ale_entry, port_mask,
>  				       ale->port_mask_bits);
> -	} else {
> +	else
>  		cpsw_ale_set_entry_type(ale_entry, ALE_TYPE_FREE);
> -	}

The code assumed calls cpsw_ale_del_mcast() should have a port mask '0' when
deleting an entry. Do we want to have 'dual' functionality on it? 
This will delete mcast entries if port mask is 0 or port mask matches exactly
what's configured right?

>  	cpsw_ale_write(ale, idx, ale_entry);
>  	return 0;
> @@ -478,6 +480,10 @@ static void cpsw_ale_del_vlan_modify(struct cpsw_ale *ale, u32 *ale_entry,
>  	members = cpsw_ale_get_vlan_member_list(ale_entry,
>  						ale->vlan_field_bits);
>  	members &= ~port_mask;
> +	if (!members) {
> +		cpsw_ale_set_entry_type(ale_entry, ALE_TYPE_FREE);
> +		return;
> +	}

This makes sense the call was missing 

>  
>  	untag = cpsw_ale_get_vlan_untag_force(ale_entry,
>  					      ale->vlan_field_bits);
> -- 
> 2.17.1
> 


Thanks
/Ilias
