Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FDD7215AB2
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 17:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729382AbgGFP10 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 11:27:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729259AbgGFP1Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 11:27:25 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5474DC061755;
        Mon,  6 Jul 2020 08:27:25 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id h28so35358232edz.0;
        Mon, 06 Jul 2020 08:27:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=K2hYlLbTaZ/9O2oP7Scy79Kvu25UFPIsfaQ2aicAONA=;
        b=HUXAlh0eGk8q3sLHEStCVWgz1qwKv4QoU75L/UBCZ96vczx2WpKmk6/1rBXoVXTvEF
         VQ1dZTT9hdIFSHwpJ5fli08eBmUn0uWaQvu4hm76AttX4ZerWXSp1rWlWqDmKW+f23yB
         n3CWzgtw0LqXirLgp7sqMqJnIpR/MDDSwBy9ZYNdlY9t1bu03Gb+m+2T1+EtaqGi+6w5
         GPX7I7ff3wMG5b3Tjr7IV2PWHN6v8EMzlw8Cm2Uh9Ms4f8lE6i6uLxZSRsFsv1d+cwvl
         QCdqJxIidVJ1fCES/whT6atooSWGE4o+nWwHMWs6RQGkcTSqYUcYb2m2BzHZIMEzJKcN
         2JXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=K2hYlLbTaZ/9O2oP7Scy79Kvu25UFPIsfaQ2aicAONA=;
        b=ZRj5//udmzuj8o/f6vc1EF4CjecqFzIxnlmVZvAkDaSxzPm8lwsXk4yiexDS9juZI2
         C2LogbwB0GYTnhAhmZuHZQODRNraRQ/ayoCPluzR/HFyWgCNpP+M8rCsDHujyX8ibXYv
         mQyf87ihUoDI0PcOjX6EPKMkGlSw7wlGuo7fnL5M3Gv/1mqBnGwdof+Pq52MyIUPNB/M
         eZxOK3iE7euXM77pKxTTFcE05jIoYV/lS4KjjFRNPeN9PwKqm7RbAxUeBM7cxY9TLVu0
         8ay2IMjhAAc7wSKmXoxVlxzUuo3KPJnKHzxFgUbsNdQFu7a/C1OOZK2jGs1WGSddoVxI
         liQg==
X-Gm-Message-State: AOAM532ljXKnL1BQvcTm+ObSzAQMd3NBQwalC/gfHkpmdIkQQub96Rmq
        gbeckwu5teptRKub2jZcFOk=
X-Google-Smtp-Source: ABdhPJy3kPHK1hQzraPmK6B+fiV9rra8xghS6OR5j8Lg9Xi21oTxSVUZOkV/t09J0eNCP7p9mxn1nQ==
X-Received: by 2002:a05:6402:706:: with SMTP id w6mr55027066edx.326.1594049244075;
        Mon, 06 Jul 2020 08:27:24 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id y22sm16408319ejj.67.2020.07.06.08.27.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 08:27:23 -0700 (PDT)
Date:   Mon, 6 Jul 2020 18:27:21 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sergey Organov <sorganov@gmail.com>, richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH  3/5] net: fec: initialize clock with 0 rather than
 current kernel time
Message-ID: <20200706152721.3j54m73bm673zlnj@skbuf>
References: <20200706142616.25192-1-sorganov@gmail.com>
 <20200706142616.25192-4-sorganov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200706142616.25192-4-sorganov@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sergey,

On Mon, Jul 06, 2020 at 05:26:14PM +0300, Sergey Organov wrote:
> Initializing with 0 makes it much easier to identify time stamps from
> otherwise uninitialized clock.
> 
> Initialization of PTP clock with current kernel time makes little sense as
> PTP time scale differs from UTC time scale that kernel time represents.
> It only leads to confusion when no actual PTP initialization happens, as
> these time scales differ in a small integer number of seconds (37 at the
> time of writing.)
> 
> Signed-off-by: Sergey Organov <sorganov@gmail.com>
> ---

Reading your patch, I got reminded of my own attempt of making an
identical change to the ptp_qoriq driver:

https://www.spinics.net/lists/netdev/msg601625.html

Could we have some sort of kernel-wide convention, I wonder (even though
it might be too late for that)? After your patch, I can see equal
amounts of confusion of users expecting some boot-time output of
$(phc_ctl /dev/ptp0 get) as it used to be, and now getting something
else.

There's no correct answer, I'm afraid. Whatever the default value of the
clock may be, it's bound to be confusing for some reason, _if_ the
reason why you're investigating it in the first place is a driver bug.
Also, I don't really see how your change to use Jan 1st 1970 makes it
any less confusing.

>  drivers/net/ethernet/freescale/fec_ptp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
> index 4a12086..e455343 100644
> --- a/drivers/net/ethernet/freescale/fec_ptp.c
> +++ b/drivers/net/ethernet/freescale/fec_ptp.c
> @@ -264,7 +264,7 @@ void fec_ptp_start_cyclecounter(struct net_device *ndev)
>  	fep->cc.mult = FEC_CC_MULT;
>  
>  	/* reset the ns time counter */
> -	timecounter_init(&fep->tc, &fep->cc, ktime_to_ns(ktime_get_real()));
> +	timecounter_init(&fep->tc, &fep->cc, 0);
>  
>  	spin_unlock_irqrestore(&fep->tmreg_lock, flags);
>  }
> -- 
> 2.10.0.1.g57b01a3
> 

Thanks,
-Vladimir
