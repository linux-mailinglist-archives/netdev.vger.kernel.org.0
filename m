Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B12632D7F39
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 20:15:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732403AbgLKTMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 14:12:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728198AbgLKTMf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 14:12:35 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22F70C0613CF
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 11:11:55 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id g20so13853525ejb.1
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 11:11:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DU0zog1ZqLuqAvCIYsUQGKS8GLoSJnDCg9BlZ3FS3Ss=;
        b=KEgJkvJyy4wnn32ZMXtfCK81kmVZt1HFkJyX+dGr3GX093Ik0lyu77Q/HHHrR6ZG4r
         tGcAPkSaMKP8VUIsn23f1iUAL40AdLmwcCjyeZrkgcP5dlfYjJorVrghP/86D52gJrFG
         pla7AmvIvoQ4eeJp3B3XGaQ3bOmaq7KgUcGqJyqIf8f3RnpTmP9N4kc5qqW5f1HLakk6
         BCZCuMIk1EVqODLlToUM7P56cCR+jldi7yjNZ0vHoN+HUb8N8PzPruRZjLhOwPjBINsu
         XFsw6+/A0SFPhKkw5yQ0kuC20eLULAhNEjZ/KcZ4sOQKkbt0iIeb72EmprGUBP/Czqsi
         BHTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DU0zog1ZqLuqAvCIYsUQGKS8GLoSJnDCg9BlZ3FS3Ss=;
        b=q9NPxDnpd1+WdGMhSJwE+l3E0LnJkgA8yXLHAwOXKOhKygqtFsz8WPoy+uOBmKFA4l
         Id56Rdry99pLwzT+BKffiRHMVk+Qz7g15IcA9xqidDj88aWxOSBgEx1rptfxDqPeBqJk
         FByyASU7k/henhsocr0mluHE48Vc1RVaLHiYt0p5D81U6djUcatRDA+ZHhEISSLQxTNv
         vKNWiEWdR5wpgiZhg0AS/SONkRyjgwVej0tqNZUUoQL7hhE98hxexJm7cLiYTowjxJs9
         xA5i40V7MXXYfXr8uz6SPGt0a0qhKBso4gdbxO4NY5Yo8yNomgefiqYpxL8PTDKdbH1X
         FhaA==
X-Gm-Message-State: AOAM530ickDDu6kdkbWiwiPXVIg3/46dDz2Or682TJX0kufeRdSkK2ti
        4aHzUZQWaIBSPSxGMfoJilg=
X-Google-Smtp-Source: ABdhPJzBP4ujgKsAae2aipyAbtGDcmsZMa1jvAQxgd/m4gQYE+brK2FaCm05CreuuD82LS8Vk1Hb3Q==
X-Received: by 2002:a17:907:9705:: with SMTP id jg5mr12446174ejc.448.1607713913773;
        Fri, 11 Dec 2020 11:11:53 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id p24sm5654624edr.65.2020.12.11.11.11.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 11:11:53 -0800 (PST)
Date:   Fri, 11 Dec 2020 21:11:51 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next] net: dsa: mt7530: enable MTU normalization
Message-ID: <20201211191151.3xrcv2voaws4xhjl@skbuf>
References: <20201210170322.3433-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201210170322.3433-1-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 11, 2020 at 01:03:22AM +0800, DENG Qingfang wrote:
> MT7530 has a global RX length register, so we are actually changing its
> MRU.
> Enable MTU normalization for this reason.
>
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> ---

Makes sense. Since it's global and not per port, this also helps the
stack to be aware of the fact that all bridged interfaces have the same
MTU. We could probably do a little bit better by also informing the
standalone interfaces about the updated MTU, but since the value that we
program into the standalone ports is >= than what the stack knows about,
there isn't an issue really.

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

>  drivers/net/dsa/mt7530.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index 99bf8fed6536..a67cac15a724 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -1657,6 +1657,7 @@ mt7530_setup(struct dsa_switch *ds)
>  	 */
>  	dn = dsa_to_port(ds, MT7530_CPU_PORT)->master->dev.of_node->parent;
>  	ds->configure_vlan_while_not_filtering = true;
> +	ds->mtu_enforcement_ingress = true;
>
>  	if (priv->id == ID_MT7530) {
>  		regulator_set_voltage(priv->core_pwr, 1000000, 1000000);
> @@ -1895,6 +1896,7 @@ mt7531_setup(struct dsa_switch *ds)
>  	}
>
>  	ds->configure_vlan_while_not_filtering = true;
> +	ds->mtu_enforcement_ingress = true;
>
>  	/* Flush the FDB table */
>  	ret = mt7530_fdb_cmd(priv, MT7530_FDB_FLUSH, NULL);
> --
> 2.25.1
>
