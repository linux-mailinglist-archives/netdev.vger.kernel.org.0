Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECE67224E14
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 23:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727055AbgGRVSL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 17:18:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726382AbgGRVSK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jul 2020 17:18:10 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 397CAC0619D2;
        Sat, 18 Jul 2020 14:18:10 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id bm28so10243550edb.2;
        Sat, 18 Jul 2020 14:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uZKlO7KE7NPBfJKLatbBaFgDsUNFCwc7y6QjYB+o7aA=;
        b=EDJkjoZr5B0HaatSqwYBvtzUnmr1Cbrq04DgKjFr44LODpl4tTK0zwcG01Rh73Vtjm
         jg5kwj9rDtbnby+y905jVjBtvoCB8lB5lrjxEVsVpT9XAQZM9hn55NciFZqPz9k1d440
         RPJ3qVRIQbIw+YkcrgcrP/6QIQi8IQzlszmRx4jPBCR9Wd444fZ60LmAfUINGaBgXYXO
         Ww8VLK1ZBlygztbHl69+Dfhxn2X0sXysWrFZxHddZd+x8NwRTHr7FcvxAS0Jo0/7pUSj
         7YwzCRZoBEMXDUXv8Th3TynBr9yED+WSnTWVeco3yWDzNoNFRUqyDxm2EG/bnCWMhM8Q
         uGiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uZKlO7KE7NPBfJKLatbBaFgDsUNFCwc7y6QjYB+o7aA=;
        b=SDU2r+JbHGo6fwAimf1iE6HiNYbasSPdftYWHkN5vuA0RsaOsCx0gR++kMbXqoi3og
         01NTGk7nZrJKdq5n9l9udgQZwK8coGlGaYp3V7MhGwmIRS2phWBHPyDBDc/V9xzNLjzg
         LqkYZSphr+joZqFQtDun2s8zvSuQOnXBFJlOKL9y7KbNQZ+j1jAag9Tt84IcjiF1zDTj
         DInTSeBkoHIMiv1b2dJy4PMmEekXKwuY/ynQz989AnP0SGjd/pq6mGIfTFKOz6BH4Buk
         GSxFVkqYxum3pAF/RnDgHpXdDA4kjgZ2pqKT9r9/Rx54bn4WrkIzzWSysNL6LeCiUj7n
         N3Tg==
X-Gm-Message-State: AOAM532E782vidZbnbrguPtZiPeLhZ4zezTKuiMI+T/NHfJclafAI+zr
        xYUyzKNZ16e6VNkkFg7MJD4=
X-Google-Smtp-Source: ABdhPJwWUlcYyuEUK1nTkGL/dHCbS50ZEhMNgrg4hj3fKq2NG/57OlOgono6kdvQ52hbSF9KuMyO6g==
X-Received: by 2002:aa7:d049:: with SMTP id n9mr15683837edo.39.1595107088743;
        Sat, 18 Jul 2020 14:18:08 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id m13sm11426599ejc.1.2020.07.18.14.18.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jul 2020 14:18:08 -0700 (PDT)
Date:   Sun, 19 Jul 2020 00:18:05 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <edumazet@google.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 3/4] net: Call into DSA netdevice_ops wrappers
Message-ID: <20200718211805.3yyckq23udacz4sa@skbuf>
References: <20200718030533.171556-1-f.fainelli@gmail.com>
 <20200718030533.171556-4-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200718030533.171556-4-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 17, 2020 at 08:05:32PM -0700, Florian Fainelli wrote:
> Make the core net_device code call into our ndo_do_ioctl() and
> ndo_get_phys_port_name() functions via the wrappers defined previously
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  net/core/dev.c       | 5 +++++
>  net/core/dev_ioctl.c | 5 +++++
>  2 files changed, 10 insertions(+)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 062a00fdca9b..19f1abc26fcd 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -98,6 +98,7 @@
>  #include <net/busy_poll.h>
>  #include <linux/rtnetlink.h>
>  #include <linux/stat.h>
> +#include <net/dsa.h>
>  #include <net/dst.h>
>  #include <net/dst_metadata.h>
>  #include <net/pkt_sched.h>
> @@ -8602,6 +8603,10 @@ int dev_get_phys_port_name(struct net_device *dev,
>  	const struct net_device_ops *ops = dev->netdev_ops;
>  	int err;
>  
> +	err  = dsa_ndo_get_phys_port_name(dev, name, len);

Stupid question, but why must these be calls to an inline function whose
name is derived through macro concatenation and hardcoded for 2
arguments, then pass through an additional function pointer found in a
DSA-specific lookup table, and why cannot DSA instead simply export
these 2 symbols (with a static inline EOPNOTSUPP fallback), and simply
provide the implementation inside those?

> +	if (err == 0 || err != -EOPNOTSUPP)
> +		return err;
> +
>  	if (ops->ndo_get_phys_port_name) {
>  		err = ops->ndo_get_phys_port_name(dev, name, len);
>  		if (err != -EOPNOTSUPP)
> diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
> index a213c703c90a..b2cf9b7bb7b8 100644
> --- a/net/core/dev_ioctl.c
> +++ b/net/core/dev_ioctl.c
> @@ -5,6 +5,7 @@
>  #include <linux/rtnetlink.h>
>  #include <linux/net_tstamp.h>
>  #include <linux/wireless.h>
> +#include <net/dsa.h>
>  #include <net/wext.h>
>  
>  /*
> @@ -231,6 +232,10 @@ static int dev_do_ioctl(struct net_device *dev,
>  	const struct net_device_ops *ops = dev->netdev_ops;
>  	int err = -EOPNOTSUPP;
>  
> +	err = dsa_ndo_do_ioctl(dev, ifr, cmd);
> +	if (err == 0 || err != -EOPNOTSUPP)
> +		return err;
> +
>  	if (ops->ndo_do_ioctl) {
>  		if (netif_device_present(dev))
>  			err = ops->ndo_do_ioctl(dev, ifr, cmd);
> -- 
> 2.25.1
> 

Thanks,
-Vladimir
