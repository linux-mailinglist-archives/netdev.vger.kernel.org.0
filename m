Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78D06456799
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 02:49:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233417AbhKSBwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 20:52:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231176AbhKSBwP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 20:52:15 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4453BC061574;
        Thu, 18 Nov 2021 17:49:14 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id r11so35593912edd.9;
        Thu, 18 Nov 2021 17:49:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PYJQczZCLNFBRW/UPzFuHB0V9KHCxJ40qSb/c8Spilw=;
        b=pOBJQZWVCSNXY+G34DbOwf/+wdPRSkhNcppn9LIFN0VGyPiTkJ60pIPFj8F9U9P/xQ
         nbmSvPRbFC2XKECsIwMIMvlvO5+twd9jB2yS3loiz4MaFZy/C239c9jvRRj3HJQWfqm0
         bG0as1si4lZ3WVI3npAGEVCYZaQmm/ik42ggOtvmfIJV9w2n0yMqjZYWkIiK7loT3dY9
         rdO4ZkYpD0T5S1xcfa8LBV+uFOj/DFTk05wDt7a77ruQF4ng6e3QKhPKop6T5YpRofl1
         qLVva+DCnv6nSd0ezY1e55YknHo5Nj/Y9HrHNbmhmnN26BE76wsrPBcoysHfrlhcfgro
         wBbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PYJQczZCLNFBRW/UPzFuHB0V9KHCxJ40qSb/c8Spilw=;
        b=GP3ghNGel2y8RTtDVZTMNggNs3h2/g99q8DBjneAlvMyikOGG77nlN00Q9y7K50NXY
         x9fS1HTyPysUBgOLdLo+aQfsU3U9cuPLcSpjppZ1K3eSzVHI7j9nTz+PWW7vzodGnirb
         4FHZxPwcTsrzKjlMPj6PxLFVRH3+Gy3nBqAchH7cvpI0hGvBfuw6W/znsy+r3vsGpQpW
         9/vEhUUPdXXQDIMSpDPyRcUHSIu+Eg83gae6hQcp6VB5Cb2l1SjSYsjHnmQgJ6mLWyUJ
         0udMC0Ku4/0Ur/nQQ049aVWn3ngqbOcI2k7fDG8z8LXhhwICZ+qc3qKWUF2VWRqxkttk
         jXbQ==
X-Gm-Message-State: AOAM532UyAy3naDf79Pa5aKgeTVJsGTnMLDk4KFlvws60dYMFBFNzz0u
        nOEl9/YAZB57QhVNvD/9YmM=
X-Google-Smtp-Source: ABdhPJyCTdMjCPk7kn5KgkrlTNxtvGj4zBNC5GJG70djZaiLLLu+vlnLmRdkeObeaYBO63KeGict8g==
X-Received: by 2002:a17:907:2622:: with SMTP id aq2mr2784902ejc.76.1637286552898;
        Thu, 18 Nov 2021 17:49:12 -0800 (PST)
Received: from skbuf ([188.25.163.189])
        by smtp.gmail.com with ESMTPSA id n8sm777607edy.4.2021.11.18.17.49.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 17:49:12 -0800 (PST)
Date:   Fri, 19 Nov 2021 03:49:11 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [net-next PATCH 13/19] net: dsa: qca8k: add min/max ageing time
Message-ID: <20211119014911.jnfjqcqfkia7agl7@skbuf>
References: <20211117210451.26415-1-ansuelsmth@gmail.com>
 <20211117210451.26415-14-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211117210451.26415-14-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 17, 2021 at 10:04:45PM +0100, Ansuel Smith wrote:
> Add min and max ageing value for qca8k switch.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>  drivers/net/dsa/qca8k.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index 50f19549b97d..dda99263fe8c 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -1291,6 +1291,10 @@ qca8k_setup(struct dsa_switch *ds)
>  	/* We don't have interrupts for link changes, so we need to poll */
>  	ds->pcs_poll = true;
>  
> +	/* Set min a max ageing value supported */
> +	ds->ageing_time_min = 7000;
> +	ds->ageing_time_max = 458745000;
> +
>  	return 0;
>  }
>  
> -- 
> 2.32.0
> 

Squash with previous patch please, and you should be able to remove the
range check from qca8k_set_ageing_time.
