Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB56472C18
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 13:14:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236635AbhLMMOK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 07:14:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236620AbhLMMOK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 07:14:10 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00CBFC061574
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 04:14:10 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id i12so14771510pfd.6
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 04:14:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=pu7c1wcP402KWNHD9dPBzkqwQoQWqxMYnBL92eSZ8l4=;
        b=OC+wnOfUNgnVHHIwIHPcK1eJLoCR61LggQEru+D7B1MZiuQGxHYw/sR3IOPjR0yyYk
         jr9dDdjriHNW3U8I9i4ye4x1/2isIaGj2/kpCUaPtSm5YZjrZsDY5LdaoHM/i5WZTtA4
         zEa2yrBamT/HABg216nuH8Cup1+tldOyU8dh+bOUWce6GzMLfCVrRiib3TQG5OA6JuiV
         sCH09KXNvVfpA9MRH9DwBH8shL8gPSdW7BlSWr+TIvYNSVCmEZdqUNf5FLaC4J9p3qL3
         0gpiE+a5cUNk48TqevW0WsCleG8IJ/0ugqpIqHUhhyd0EslvyT21mHstgMgeywGKiMKi
         fn8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=pu7c1wcP402KWNHD9dPBzkqwQoQWqxMYnBL92eSZ8l4=;
        b=HHROem180s0FnK8GPJCAeRF6TZrVcwX6jsu99HSwuOR4anEy7dhBczreStGHHe/2gr
         zyMCWeYb0efod5QV1VXmF3RsAbx4S8UYR4SiElk5i0mdnbJ7i17biO+lmud3bAJ9uvhG
         x9C0WeTfnEYJSWOdmteeWFPJz5wzGKX3Qzqz/MzJTwfsr/2Jac7PE9qcmMqUOKiM9TvV
         g5jFr7bYIBaLwd6k4NyqqyiUrKH5Wjyh08M9yGFKXSaf8Olq2gg561og/ImZu/lsiRa0
         wwkKQBJsnD2KXo8AVSjtny0okcUEmuQ+hcZeDzxOBOaH/hNB9fIdL2aCbOOwHrSSC4PG
         VQDw==
X-Gm-Message-State: AOAM531ds9LxHDK++wbgSfpK6Gc3zQBcVa+fBoLIzJ6KAp7VNvGMUZaH
        Aerx2k+2y68wex5hAjeUah0=
X-Google-Smtp-Source: ABdhPJzjwP1IvvxmIaGMyGORJG3SYyONfT+4foDWYOk+nBVyb9hqnkF8FJfeLq/LH4HQpkhc8Lk+7A==
X-Received: by 2002:aa7:8386:0:b0:4b0:29bf:b0d4 with SMTP id u6-20020aa78386000000b004b029bfb0d4mr23381898pfm.26.1639397649574;
        Mon, 13 Dec 2021 04:14:09 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id u14sm12690413pfi.219.2021.12.13.04.14.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 04:14:09 -0800 (PST)
Date:   Mon, 13 Dec 2021 04:14:06 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: hellcreek: Allow PTP on blocked ports
Message-ID: <20211213121406.GB14042@hoboy.vegasvil.org>
References: <20211213101810.121553-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211213101810.121553-1-kurt@linutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 13, 2021 at 11:18:10AM +0100, Kurt Kanzenbach wrote:

> @@ -1055,7 +1058,7 @@ static int hellcreek_setup_fdb(struct hellcreek *hellcreek)
>  		.portmask     = 0x03,	/* Management ports */
>  		.age	      = 0,
>  		.is_obt	      = 0,
> -		.pass_blocked = 0,
> +		.pass_blocked = 1,

This one should stay blocked.

>  		.is_static    = 1,
>  		.reprio_tc    = 6,	/* TC: 6 as per IEEE 802.1AS */
>  		.reprio_en    = 1,
> @@ -1066,7 +1069,7 @@ static int hellcreek_setup_fdb(struct hellcreek *hellcreek)
>  		.portmask     = 0x03,	/* Management ports */
>  		.age	      = 0,
>  		.is_obt	      = 0,
> -		.pass_blocked = 0,
> +		.pass_blocked = 1,

This one is okay.

>  		.is_static    = 1,
>  		.reprio_tc    = 6,	/* TC: 6 as per IEEE 802.1AS */
>  		.reprio_en    = 1,
> -- 
> 2.30.2
> 

Thanks,
Richard
