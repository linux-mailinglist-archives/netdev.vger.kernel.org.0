Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 099AE66028E
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 15:52:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235209AbjAFOvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 09:51:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234813AbjAFOvP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 09:51:15 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C955243A2C;
        Fri,  6 Jan 2023 06:51:13 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id qk9so3962664ejc.3;
        Fri, 06 Jan 2023 06:51:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=V/b5xdPDPSWVWTYlzwsggTEuli7HFWe9jfWKH5uUek0=;
        b=hGfxj6RHbFmBbqewngh/OVICsKnsIBOZRWn/uo9MZ7eC21Wbjmb+elLfxsKArutD3N
         sGGiFwAfX/0Y8yrOQ4pt5uebEuXonadJOq6VssFGM37UDC3Ph1lcvdx2F0tEuB583YWE
         EqpNXl0WPCsoLo/0nhc9fcS6l4NTbgWbCY8LfBkPeJEL1g4tT7GDnmHiwxKvZ9CEc0X/
         ouI8CHjV6ssbvJRCjy1Va6k4+tsz4z83O+kVZsPzBBVCd/ekf52TQOLKvaG2UoDU15eb
         +DCAcrRsM2sfBkgLQ7xbwMToLrCTm8zx6s7fQdweJ/hoVUXMfrNLs9UE6KtM3VsUiEXy
         RXKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V/b5xdPDPSWVWTYlzwsggTEuli7HFWe9jfWKH5uUek0=;
        b=14Yd9SiKbrxx+GhlFKbAmnXtRkny2IOLe7DvXWdt53FwI0Fe0c1bEeRp/RDXq7o63D
         SX9lhxXJjLQAjhv7tZA+1eJ0+edgi19sSSbCT9MDL/fAExTIhSjCYdc/WMTu6WM3nODM
         ZP8lfnZMpRFAcqI+nKuPrAKSveopCBk46JnCy68zDNlFnQgyLzI9ceBn3X5gVOpOPfvY
         SHfIYLbUAl6QU9WWn23vqhoIeXDepE73LcMtkWVqd3M/0obJby/gWqEmxZCmXJVCmhbx
         7O01ElrwU3JUuL7XpRDgnLZAJ7i+FXZ7ETyGLXzMmGy97yubjA3OGccxgLHjOCkMM9ig
         0YRw==
X-Gm-Message-State: AFqh2kpZxdAN3UA3Jcclb4w9Wld26eCgL++YlvT9zMJ6bDJ353VHRaXX
        eNqmfHW4LQ70HmF7UKkpJT0=
X-Google-Smtp-Source: AMrXdXuN+SnZKK25ZGLfrRBIQO7EkvwAUBENcaPQvGR0cFStWFWb9Nf9SDOOxviLB+TpgvqBg4Ep1A==
X-Received: by 2002:a17:907:7ea1:b0:7c4:f752:e95c with SMTP id qb33-20020a1709077ea100b007c4f752e95cmr60991198ejc.1.1673016672337;
        Fri, 06 Jan 2023 06:51:12 -0800 (PST)
Received: from skbuf ([188.26.184.223])
        by smtp.gmail.com with ESMTPSA id a17-20020a170906369100b007c0f2c4cdffsm471192ejc.44.2023.01.06.06.51.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jan 2023 06:51:12 -0800 (PST)
Date:   Fri, 6 Jan 2023 16:51:09 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Lukasz Majewski <lukma@denx.de>
Cc:     Andrew Lunn <andrew@lunn.ch>, Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/3] dsa: marvell: Provide per device information
 about max frame size
Message-ID: <20230106145109.mrv2n3ppcz52jwa2@skbuf>
References: <20230106101651.1137755-1-lukma@denx.de>
 <20230106101651.1137755-1-lukma@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230106101651.1137755-1-lukma@denx.de>
 <20230106101651.1137755-1-lukma@denx.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 06, 2023 at 11:16:49AM +0100, Lukasz Majewski wrote:
> Different Marvell DSA switches support different size of max frame
> bytes to be sent. This value corresponds to the memory allocated
> in switch to store single frame.
> 
> For example mv88e6185 supports max 1632 bytes, which is now in-driver
> standard value. On the other hand - mv88e6250 supports 2048 bytes.
> To be more interresting - devices supporting jumbo frames - use yet
> another value (10240 bytes)
> 
> As this value is internal and may be different for each switch IC,
> new entry in struct mv88e6xxx_info has been added to store it.
> 
> This commit doesn't change the code functionality - it just provides
> the max frame size value explicitly - up till now it has been
> assigned depending on the callback provided by the IC driver
> (e.g. .set_max_frame_size, .port_set_jumbo_size).
> 
> Signed-off-by: Lukasz Majewski <lukma@denx.de>
> 
> ---
> Changes for v2:
> - Define max_frame_size with default value of 1632 bytes,
> - Set proper value for the mv88e6250 switch SoC (linkstreet) family
> 
> Changes for v3:
> - Add default value for 1632B of the max frame size (to avoid problems
>   with not defined values)
> 
> Changes for v4:
> - Rework the mv88e6xxx_get_max_mtu() by using per device defined
>   max_frame_size value
> 
> - Add WARN_ON_ONCE() when max_frame_size is not defined
> 
> - Add description for the new 'max_frame_size' member of mv88e6xxx_info
> ---
>  drivers/net/dsa/mv88e6xxx/chip.c | 41 ++++++++++++++++++++++++++++----
>  drivers/net/dsa/mv88e6xxx/chip.h |  6 +++++
>  2 files changed, 42 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index 242b8b325504..fc6d98c4a029 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -3545,11 +3545,10 @@ static int mv88e6xxx_get_max_mtu(struct dsa_switch *ds, int port)
>  {
>  	struct mv88e6xxx_chip *chip = ds->priv;
>  
> -	if (chip->info->ops->port_set_jumbo_size)
> -		return 10240 - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN;
> -	else if (chip->info->ops->set_max_frame_size)
> -		return 1632 - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN;
> -	return 1522 - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN;
> +	WARN_ON_ONCE(!chip->info->max_frame_size);
> +
> +	return chip->info->max_frame_size - VLAN_ETH_HLEN - EDSA_HLEN
> +		- ETH_FCS_LEN;

VLAN_ETH_HLEN (18) + EDSA_HLEN (8) + ETH_FCS_LEN (4) = 30

>  }
>  
>  static int mv88e6xxx_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
> @@ -4955,6 +4954,7 @@ static const struct mv88e6xxx_ops mv88e6250_ops = {
>  	.avb_ops = &mv88e6352_avb_ops,
>  	.ptp_ops = &mv88e6250_ptp_ops,
>  	.phylink_get_caps = mv88e6250_phylink_get_caps,
> +	.set_max_frame_size = mv88e6185_g1_set_max_frame_size,
>  };
>  
>  static const struct mv88e6xxx_ops mv88e6290_ops = {
> @@ -5543,6 +5543,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
>  		.num_internal_phys = 5,
>  		.max_vid = 4095,
>  		.max_sid = 63,
> +		.max_frame_size = 1522,

1522 - 30 = 1492.

I don't believe that there are switches which don't support the standard
MTU of 1500 ?!

>  		.port_base_addr = 0x10,
>  		.phy_base_addr = 0x0,
>  		.global1_addr = 0x1b,

Note that I see this behavior isn't new. But I've simulated it, and it
will produce the following messages on probe:

[    7.425752] mscc_felix 0000:00:00.5 swp0 (uninitialized): PHY [0000:00:00.3:10] driver [Microsemi GE VSC8514 SyncE] (irq=POLL)
[    7.437516] mscc_felix 0000:00:00.5: nonfatal error -34 setting MTU to 1500 on port 0
[    7.588585] mscc_felix 0000:00:00.5 swp1 (uninitialized): PHY [0000:00:00.3:11] driver [Microsemi GE VSC8514 SyncE] (irq=POLL)
[    7.600433] mscc_felix 0000:00:00.5: nonfatal error -34 setting MTU to 1500 on port 1
[    7.752613] mscc_felix 0000:00:00.5 swp2 (uninitialized): PHY [0000:00:00.3:12] driver [Microsemi GE VSC8514 SyncE] (irq=POLL)
[    7.764457] mscc_felix 0000:00:00.5: nonfatal error -34 setting MTU to 1500 on port 2
[    7.900771] mscc_felix 0000:00:00.5 swp3 (uninitialized): PHY [0000:00:00.3:13] driver [Microsemi GE VSC8514 SyncE] (irq=POLL)
[    7.912501] mscc_felix 0000:00:00.5: nonfatal error -34 setting MTU to 1500 on port 3

I wonder, shouldn't we first fix that, and apply this patch set afterwards?
