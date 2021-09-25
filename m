Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48E95418405
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 20:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbhIYSqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 14:46:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbhIYSqC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Sep 2021 14:46:02 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF7BFC061570
        for <netdev@vger.kernel.org>; Sat, 25 Sep 2021 11:44:27 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id g8so49973813edt.7
        for <netdev@vger.kernel.org>; Sat, 25 Sep 2021 11:44:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=3vENapGn11+4krWHn5wfS+Xg0/r52raYNgquBVYnJxI=;
        b=N989MHD5Zu6LJs0X16y2T6QSzOnRPcaTlOUl8NZFKYNFaR0kqmUI68TBSP4HxA0mt0
         bkpdSXvg4C0zQWb4J6Ky2xeitpF4cUcR8eA16f6aU+qeM80xQvdCRzUR5SeE/w9DxxHq
         RW/QaQi3GXRLL3zahZxkKdq0u+OunsmLnD7IGdOH5jBSKniq2SFrEPwQfrn+yNerQcK2
         q3JoSr5XBiqLgckiDQd3jw1IkQJJ8z0othzMh55vYxkbD9DqkHLzCNzNMljIPhE8jLV7
         76yi+o9x6GJ2NFjUIxyV5+TdjDeARE7q1OtmPgD7E02Jt7qwzOKyIyBz7ZoA+gI4eHhV
         EzGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=3vENapGn11+4krWHn5wfS+Xg0/r52raYNgquBVYnJxI=;
        b=ziFPBn6ZqvjEbrwU07kXsdyh6XG8Mztz+0rMtc5p99bO826Mt4tuhf6QKkS7UmILGj
         NBjvN3GKu9SqwBCyYVKazOI0l28FeeaoQv+XHxoiiLK/11BVYUkVYzAyYZ9sJpHa7w5I
         Jip3k3jd8UOE1ILQxKI+q38V9EFnAdecAk0W/o0hlXg7oOKwyGvQ0Yd2Qpbyx4eEnzLr
         E0+yX5ZzaAiYsAj7qxaztbjWULfZEW7AtbYpW4rwhRKkhvZxmetfekmtigODGO0LGpe+
         cudvNxTTsL99duG1Vem3bpNobPkmS9SfvTMLxIMmgTYruXgzD+UaLx6XsFYdTDSId40b
         6xjg==
X-Gm-Message-State: AOAM530mkyzebJ3TTg+dk4o9hlcBMBnESrzslrrUAaFGYuGwNg3c5O5k
        Wxn5kGzH++rMz7cm3oBi7Cc=
X-Google-Smtp-Source: ABdhPJx7bAx0n/Egg8Z/+UFvTz3yGdmbPtdGgvBrkXlwyJZK4+XE4t7rx6XOKXDI3YdXG/uR9zgGjQ==
X-Received: by 2002:a50:8206:: with SMTP id 6mr1295293edf.265.1632595466314;
        Sat, 25 Sep 2021 11:44:26 -0700 (PDT)
Received: from skbuf ([188.26.53.217])
        by smtp.gmail.com with ESMTPSA id l16sm1181886eds.46.2021.09.25.11.44.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Sep 2021 11:44:25 -0700 (PDT)
Date:   Sat, 25 Sep 2021 21:44:24 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Mauri Sandberg <sandberg@mailfence.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Re: [PATCH net-next 4/6 v6] net: dsa: rtl8366rb: Fix off-by-one bug
Message-ID: <20210925184424.4gfdxmcg2bay575o@skbuf>
References: <20210925132311.2040272-1-linus.walleij@linaro.org>
 <20210925132311.2040272-5-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210925132311.2040272-5-linus.walleij@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 25, 2021 at 03:23:09PM +0200, Linus Walleij wrote:
> The max VLAN number with non-4K VLAN activated is 15, and the
> range is 0..15. Not 16.
> 
> The impact should be low since we by default have 4K VLAN and
> thus have 4095 VLANs to play with in this switch. There will
> not be a problem unless the code is rewritten to only use
> 16 VLANs.
> 
> Fixes: d8652956cf37 ("net: dsa: realtek-smi: Add Realtek SMI driver")
> Cc: Vladimir Oltean <olteanv@gmail.com>
> Cc: Mauri Sandberg <sandberg@mailfence.com>
> Cc: Alvin Šipraga <alsi@bang-olufsen.dk>
> Cc: DENG Qingfang <dqfext@gmail.com>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> ChangeLog v5->v6:
> - No changes just resending with the rest of the
>   patches.
> ChangeLog v4->v5:
> - Add some more text describing that this is not a critical bug.
> - Add Fixes tag
> ChangeLog v1->v4:
> - New patch for a bug discovered when fixing the other issues.
> ---
>  drivers/net/dsa/rtl8366rb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/rtl8366rb.c
> index 2c66a0c2ee50..6f25ee57069d 100644
> --- a/drivers/net/dsa/rtl8366rb.c
> +++ b/drivers/net/dsa/rtl8366rb.c
> @@ -1450,7 +1450,7 @@ static int rtl8366rb_set_mc_index(struct realtek_smi *smi, int port, int index)
>  
>  static bool rtl8366rb_is_vlan_valid(struct realtek_smi *smi, unsigned int vlan)
>  {
> -	unsigned int max = RTL8366RB_NUM_VLANS;
> +	unsigned int max = RTL8366RB_NUM_VLANS - 1;
>  
>  	if (smi->vlan4k_enabled)
>  		max = RTL8366RB_NUM_VIDS - 1;

Personally I would have preferred to make this "max" = RTL8366RB_NUM_VIDS,
and then the comparison right below:

	if (vlan >= max)
		return false;

because it's easier than to carry around "- 1" everywhere.
Anyway, this works just as well.

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
