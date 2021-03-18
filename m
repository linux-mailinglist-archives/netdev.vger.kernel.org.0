Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF02B340801
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 15:36:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231558AbhCROfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 10:35:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbhCROfI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 10:35:08 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 864F7C06174A
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 07:35:08 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id u9so4315559ejj.7
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 07:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9i6mcgfGpOWj5mFTrTHdrGRjMjpGwpAxQho+UnhI+XQ=;
        b=qqcuI2a7IMK1HMrQ8Gmh1HhChmhXRxdPzf3+9kRSo6aFMseX3LGdgmV52ob14QVjzn
         AFLCglmr3Tr9FE0epIlemvDmTTeYVytgI1xRQfdsz60o5tOjYfZagcvtOwec6J6lUSf7
         lUyhq8YbD1JiJ5W71UjyKZONZr7lB5URHpBg5ZReWPNzFxUV6OHNciERJA9E6IsMuOE/
         QJUWXFMqnAZIDsxcJ0PQvQK6Ck+miOOPp02J6GTQsE8Z8URfO96Cw6YXYVj+8lYqkSO8
         5YBtZ6WpiuapvQ/k7uT7t1wID0E7eh77eB4zzVCKUa90ir4d0irIaubBtDH/FCqy4T+5
         XZOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9i6mcgfGpOWj5mFTrTHdrGRjMjpGwpAxQho+UnhI+XQ=;
        b=Z2J9rTWsXdmBVXW8gZg2Dsg5RZEmqoCK8MFAQa8JLIhS1oG3sEYSWqwc2dSC71u+B0
         PJtTO2gCo8H4udnOFoESd9bG2W2Unst/a4WwDW2vySiQBUVc98WJiRUHxtKrmF1ILEGB
         XIpnIKLCCazt9c3UUQzQYoqzivNgTOwdZdSCHN9TVHcp/rNvAzmfNb/uWFOcI/+7BBrq
         YTkSUkXqWOI5+Mlyb9nMAv8IE4rs2FOiXluXSPaFAjC3US1uo1e0LQcOjqbMITYM9mrV
         ZBRYh7HI628eKIDj17crY6XTvBVgXFABvfmad0nIgwbNSnx/dN3eKStZh0855li+AlKA
         e96A==
X-Gm-Message-State: AOAM531eO1+7Du2B95ao9xWHgxdFcKofYytv4Y7vWxGItMWjUC0tGhS1
        a54FxWRbkt8WtRrI0yA2Mlc=
X-Google-Smtp-Source: ABdhPJxV5iQMaXG4C7jynyOsJq9SKQwzjYx3X+xb+u9MG1/EMJsSQJouWPlLm43OgFbr/1ltWuX5aA==
X-Received: by 2002:a17:906:85b:: with SMTP id f27mr14461562ejd.414.1616078107326;
        Thu, 18 Mar 2021 07:35:07 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id t17sm2270603edr.36.2021.03.18.07.35.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 07:35:07 -0700 (PDT)
Date:   Thu, 18 Mar 2021 16:35:05 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 8/8] net: dsa: mv88e6xxx: Offload bridge
 broadcast flooding flag
Message-ID: <20210318143505.5lu3ebozbkrayygp@skbuf>
References: <20210318141550.646383-1-tobias@waldekranz.com>
 <20210318141550.646383-9-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210318141550.646383-9-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 18, 2021 at 03:15:50PM +0100, Tobias Waldekranz wrote:
> These switches have two modes of classifying broadcast:
> 
> 1. Broadcast is multicast.
> 2. Broadcast is its own unique thing that is always flooded
>    everywhere.
> 
> This driver uses the first option, making sure to load the broadcast
> address into all active databases. Because of this, we can support
> per-port broadcast flooding by (1) making sure to only set the subset
> of ports that have it enabled whenever joining a new bridge or VLAN,
> and (2) by updating all active databases whenever the setting is
> changed on a port.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---
>  drivers/net/dsa/mv88e6xxx/chip.c | 73 +++++++++++++++++++++++++++++++-
>  1 file changed, 72 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index 7976fb699086..3baa4dadb0dd 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -1982,6 +1982,21 @@ static int mv88e6xxx_broadcast_setup(struct mv88e6xxx_chip *chip, u16 vid)
>  	int err;
>  
>  	for (port = 0; port < mv88e6xxx_num_ports(chip); port++) {
> +		struct dsa_port *dp = dsa_to_port(chip->ds, port);
> +		struct net_device *brport;
> +
> +		if (dsa_is_unused_port(chip->ds, port))
> +			continue;
> +
> +		brport = dsa_port_to_bridge_port(dp);
> +
> +		if (dp->bridge_dev &&
> +		    !br_port_flag_is_set(brport, BR_BCAST_FLOOD))

I think I would have liked to see a dsa_port_to_bridge_port helper that
actually returns NULL when dp->bridge_dev is NULL.

This would make your piece of code look as follows:

		brport = dsa_port_to_bridge_port(dp);
		if (brport && !br_port_flag_is_set(brport, BR_BCAST_FLOOD)
			continue;

> +			/* Skip bridged user ports where broadcast
> +			 * flooding is disabled.
> +			 */
> +			continue;
> +
>  		err = mv88e6xxx_port_add_broadcast(chip, port, vid);
>  		if (err)
>  			return err;
