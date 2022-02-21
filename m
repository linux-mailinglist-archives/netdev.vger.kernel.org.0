Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7B74BEBC3
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 21:26:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233624AbiBUU1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 15:27:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232386AbiBUU1F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 15:27:05 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 884B022BFF;
        Mon, 21 Feb 2022 12:26:41 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id p14so36015184ejf.11;
        Mon, 21 Feb 2022 12:26:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Zg6QI43cUYWYG+TWwcIhH5OKBdyRlMuOBrZONjGyLCg=;
        b=qL1lYJLse3SUChloq+16cpnirFt9F8AFtz8Ol6x48/53TqFWU1O6PixOLYjoqHuVxZ
         yHaPk5yDQeBSSgG7b2n+QdI6wYVve7j8YRE6S+adcLsIqxmJXYRUP1VL5HRubrCjHacP
         s/x7i36XfpENQUx9v4ayfL2EcELNJ/J96wEUTfyT1qamjVimwRfgQIDVrrRlK3XtqnuA
         BvdjRfxHOR67kIxI0PWN7m5HFpVAsjNTWZlURnFuEzNVerevjjx+ymdbGgbKrFTDQ3au
         9u21yFLzjWTidR+iThtceeOpTOWAqSBD6D2p7egzLuP8WmEPgz+lOufcsYLmeYxl5EEy
         8yrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Zg6QI43cUYWYG+TWwcIhH5OKBdyRlMuOBrZONjGyLCg=;
        b=41uIhSFBoa5O07zqSwIt1/P55lVnVNldQPwgNwPaNYSy2fMBUCfLThkO4kk/NJxEqY
         jyTCEf26l3oxrxdy34S0h63dRWOeleaAjdHqopYUmvWglYPY+2wWBbtDCvRwOYv0mNxN
         E8fqFcFqFSU06YYeZp8WvvzlEq4xN13pxaUEUbMiHJQeQaM2lsyw+hKABfJrYegO3vJv
         aQTFklWUEQIt399Ulpw4RV57bAOrBuRR9OKP4CGK5/nPRxbvE+Rgdblefo+8jJEQzUjP
         LiijebGLIf0+iBt3Gyro/7EporSOGKdD+n/1GgybJZF97QnD3tqpNI2BLK2R5pVk5vm2
         ObiA==
X-Gm-Message-State: AOAM531m7SKrR1cfKkyy3vJiU/ETj773ym/ABiE2gUSlkjX4YbqM5J8x
        aArNyLl4qPdgMzsc8XGhN8/P1qn1BoM=
X-Google-Smtp-Source: ABdhPJygUonphjFhkpAiYFNcw7lL4wRq0aukvcEChL8vPqjvlcJzc+NUvu1CLLsUiuOIVrsrjscTAg==
X-Received: by 2002:a17:906:bc99:b0:6ce:e0b6:52bf with SMTP id lv25-20020a170906bc9900b006cee0b652bfmr16333960ejb.313.1645475199819;
        Mon, 21 Feb 2022 12:26:39 -0800 (PST)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id hs25sm5487974ejc.172.2022.02.21.12.26.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 12:26:39 -0800 (PST)
Date:   Mon, 21 Feb 2022 22:26:37 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <alvin@pqrs.dk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: fix panic when removing unoffloaded port
 from bridge
Message-ID: <20220221202637.he5hm6fbqhuayisv@skbuf>
References: <20220221201931.296500-1-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220221201931.296500-1-alvin@pqrs.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 21, 2022 at 09:19:31PM +0100, Alvin Šipraga wrote:
> From: Alvin Šipraga <alsi@bang-olufsen.dk>
> 
> If a bridged port is not offloaded to the hardware - either because the
> underlying driver does not implement the port_bridge_{join,leave} ops,
> or because the operation failed - then its dp->bridge pointer will be
> NULL when dsa_port_bridge_leave() is called. Avoid dereferncing NULL.
> 
> This fixes the following splat when removing a port from a bridge:
> 
>  Unable to handle kernel access to user memory outside uaccess routines at virtual address 0000000000000000
>  Internal error: Oops: 96000004 [#1] PREEMPT_RT SMP
>  CPU: 3 PID: 1119 Comm: brctl Tainted: G           O      5.17.0-rc4-rt4 #1
>  Call trace:
>   dsa_port_bridge_leave+0x8c/0x1e4
>   dsa_slave_changeupper+0x40/0x170
>   dsa_slave_netdevice_event+0x494/0x4d4
>   notifier_call_chain+0x80/0xe0
>   raw_notifier_call_chain+0x1c/0x24
>   call_netdevice_notifiers_info+0x5c/0xac
>   __netdev_upper_dev_unlink+0xa4/0x200
>   netdev_upper_dev_unlink+0x38/0x60
>   del_nbp+0x1b0/0x300
>   br_del_if+0x38/0x114
>   add_del_if+0x60/0xa0
>   br_ioctl_stub+0x128/0x2dc
>   br_ioctl_call+0x68/0xb0
>   dev_ifsioc+0x390/0x554
>   dev_ioctl+0x128/0x400
>   sock_do_ioctl+0xb4/0xf4
>   sock_ioctl+0x12c/0x4e0
>   __arm64_sys_ioctl+0xa8/0xf0
>   invoke_syscall+0x4c/0x110
>   el0_svc_common.constprop.0+0x48/0xf0
>   do_el0_svc+0x28/0x84
>   el0_svc+0x1c/0x50
>   el0t_64_sync_handler+0xa8/0xb0
>   el0t_64_sync+0x17c/0x180
>  Code: f9402f00 f0002261 f9401302 913cc021 (a9401404)
>  ---[ end trace 0000000000000000 ]---
> 
> Fixes: d3eed0e57d5d ("net: dsa: keep the bridge_dev and bridge_num as part of the same structure")
> Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
> ---

Sorry, I thought that the caller of dsa_port_bridge_leave() would check
this, but clearly that is not the case.

I see that there's a similar NULL pointer dereference in some patches I
sent today, so I'd better fix that too before they get accepted.

>  net/dsa/port.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/net/dsa/port.c b/net/dsa/port.c
> index eef4a98f2628..fc7a233653a0 100644
> --- a/net/dsa/port.c
> +++ b/net/dsa/port.c
> @@ -395,10 +395,17 @@ void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br)
>  		.tree_index = dp->ds->dst->index,
>  		.sw_index = dp->ds->index,
>  		.port = dp->index,
> -		.bridge = *dp->bridge,
>  	};
>  	int err;
>  
> +	/* If the port could not be offloaded to begin with, then
> +	 * there is nothing to do.
> +	 */
> +	if (!dp->bridge)
> +		return;
> +
> +	info.bridge = *dp->bridge,

By the way, does this patch compile, with the comma and not the
semicolon, like that?

> +
>  	/* Here the port is already unbridged. Reflect the current configuration
>  	 * so that drivers can program their chips accordingly.
>  	 */
> -- 
> 2.35.1
> 
