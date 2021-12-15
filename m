Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42803475580
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 10:52:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241308AbhLOJvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 04:51:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233733AbhLOJvt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 04:51:49 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF86AC061574;
        Wed, 15 Dec 2021 01:51:48 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id x15so73580868edv.1;
        Wed, 15 Dec 2021 01:51:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=koGuE3MJrYmL3d3PsbPHNf+GbUxEW6jsrheOLs2z698=;
        b=a2WgJ+4kAFsCJ3iHDxrSZcQABLWbL6BHE6VcHtljgQpvAYCdKbSc9NmIxpVWLJtTPw
         PoKstj15djE1FKJmAVmIsCxnlfPuevUSA4vxQUtUP2h+dE1o6l+9kgQVH6XSn/1wKmjT
         FDpbTwSkyDe5ud5ToW/QbNeev8BdFrAbLuV8dZYMM4Thn2o4H0y+kypq47vm7utMBWxL
         sAHK2Z23D1e2Bd5F037j2WLuiZhxeOLhP7N7Hgk8yeQZUnrxKrFJqi4Q6D/v612h1Bns
         ELGP+3TaIqpfyF5QnSyWZaj4uM55wPlOgMjf3BDsYAfPPpmFz8A/uHe/R7SVf4vG63GL
         TdqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=koGuE3MJrYmL3d3PsbPHNf+GbUxEW6jsrheOLs2z698=;
        b=efY+PZlTSPwYfVdsNVqOdjMqHhJ8a4dhFdJiOHtiDRPoYR/mFB5pfQLJ5nnca/NmFw
         YDMsgP+9f/sc+Cbst6f8B0nlmcnw7mE9CZj1hKT048EQjD4mRgXfhVAJ49Q91bxoQoxf
         zomgu+l4twJdnzDtbXvW6XaMex99QhpeXjACfu2f8/x7sGbAOINZ+TziFOluZdF+03B3
         KS89w9I0DbH6x80OMAEdmh8mZBvS64lj2uOMS1IYhZbQBhQTZ3O5Zspoi3c6qqzav9Ty
         DsEaPWnjcAtYKsT5H9L3qPCgd+s8d343hXMNH0NKGl2p/FxhhFKuF1XS1rO8dsV+Vct8
         aJBQ==
X-Gm-Message-State: AOAM530b+h4laKZZlbOLFsDPE5jJVNoks3/Pe1auOo/6Ib5rz7zwQEly
        1lpBGtw0hzvN1Gxzr1V5pMc=
X-Google-Smtp-Source: ABdhPJyxc1IVQbZfU1zzVP1mlmXfXaW1qthX7TgqpAE412/diUOFYuVfEQkLv+vwhgcMKfrE0dv1MA==
X-Received: by 2002:a17:907:97c7:: with SMTP id js7mr9866654ejc.235.1639561907314;
        Wed, 15 Dec 2021 01:51:47 -0800 (PST)
Received: from skbuf ([188.25.173.50])
        by smtp.gmail.com with ESMTPSA id w17sm319149edu.48.2021.12.15.01.51.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 01:51:47 -0800 (PST)
Date:   Wed, 15 Dec 2021 11:51:46 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next PATCH RFC v6 11/16] net: dsa: qca8k: add tracking
 state of master port
Message-ID: <20211215095146.6awhx44lamojipoo@skbuf>
References: <20211214224409.5770-1-ansuelsmth@gmail.com>
 <20211214224409.5770-12-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211214224409.5770-12-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 14, 2021 at 11:44:04PM +0100, Ansuel Smith wrote:
> MDIO/MIB Ethernet require the master port and the tagger availabale to
> correctly work. Use the new api master_state_change to track when master
> is operational or not and set a bool in qca8k_priv.
> We cache the first cached master available and we check if other cpu
> port are operational when the cached one goes down.
> This cached master will later be used by mdio read/write and mib request to
> correctly use the working function.
> 
> qca8k implementation for MDIO/MIB Ethernet is bad. CPU port0 is the only
> one that answers with the ack packet or sends MIB Ethernet packets. For
> this reason the master_state_change ignore CPU port6 and checkes only
> CPU port0 if it's operational and enables this mode.

CPU port 0 may not always be wired, it depends on board design, right?
So the Ethernet management protocol may or may not be available to all users.

> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
> diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
> index ab4a417b25a9..6edd6adc3063 100644
> --- a/drivers/net/dsa/qca8k.h
> +++ b/drivers/net/dsa/qca8k.h
> @@ -353,6 +353,7 @@ struct qca8k_priv {
>  	struct dsa_switch_ops ops;
>  	struct gpio_desc *reset_gpio;
>  	unsigned int port_mtu[QCA8K_NUM_PORTS];
> +	const struct net_device *master; /* Track if mdio/mib Ethernet is available */

Maybe "mgmt_master" would be a clearer naming scheme?

>  };
>  
>  struct qca8k_mib_desc {
> -- 
> 2.33.1
> 

