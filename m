Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87C34669953
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 15:03:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241805AbjAMOC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 09:02:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241770AbjAMOCA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 09:02:00 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 740B0E0E7;
        Fri, 13 Jan 2023 05:59:34 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id mp20so5912272ejc.7;
        Fri, 13 Jan 2023 05:59:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5I4m/EnweQ5SqB1DHqUreYhEufcWoW7oFYxI0NTJspA=;
        b=cX9POSfg1VNn+g1+ero6V6UjGb7H9mLduuabZEeInSH2IW4z75eYg//ouJP/FYhwV1
         u7LD20+3n7/F3YRjpN/VfJ3R5PWj3jRuJB4YFXiVv114C0Ljmr2d2nt51iaSqgVAVsTh
         SRF/qEmiPDgTjPP69y0uF/OzdAkf10qPlIylu+HvoQjizlqUWoJNLArSnfC07dUh5NWY
         U3AAwu+qOjE2ltBqUPQ0TwD1umnNM0JC+DFpunyB5cokiwJF4z36rKHu5olEJjqOyQ5B
         5efik53s5GngQ7TUN8ssyE+TZujB5oSD9rFErny+eVGGrc2bIETL3vm41FVNRFd+Iqal
         h4BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5I4m/EnweQ5SqB1DHqUreYhEufcWoW7oFYxI0NTJspA=;
        b=WUhzo5FSvQuPyCZr6ii1V5/SCQnpNKU7XF5eIAdkLxXs7ry7FVga7qfYOAswn8qaIE
         boRyZwY3jK40dnwfF1D7iiXfMLnpHEeS+SYgUmp/aFVxVFNz/Z5XfW6aIUxDfJdyNuXv
         QbNjuLFEQPQu1UjhGJAmrnAaoOhT8w1MRdQcqNe8YOklmsLH7WkSP2K55ovRypCEWf3M
         /Wo4FzFu+XeEQ4s+9Jo7faA3Qd2BpLfn8B/wVpc/JS14TwPYQocG/5xCaspMuXvh4xSr
         g5FB2M4jsR5a4OzK3QBIXF+lHbdjOsfO9En1Rh9BR50NpUE0nZ/SSsc3mrmdsAi4KOPQ
         dIsQ==
X-Gm-Message-State: AFqh2kqSj6XfpncaY4vCadwUuoAteq/hnpJtBeRxsljcAQBdeLRpRozr
        x4SM1P7lqfCiyBm/T4XzdGQ=
X-Google-Smtp-Source: AMrXdXuD6T1yk7qurYpUiH6yo27/FdUjp8etImogdv44WzUG/B2H4OVrR7fNqY+XDi9/GJVOTueVlw==
X-Received: by 2002:a17:907:73c1:b0:7e7:4dd7:bc0c with SMTP id es1-20020a17090773c100b007e74dd7bc0cmr65354966ejc.66.1673618372910;
        Fri, 13 Jan 2023 05:59:32 -0800 (PST)
Received: from skbuf ([188.26.184.223])
        by smtp.gmail.com with ESMTPSA id 17-20020a170906329100b007c0bb571da5sm8473751ejw.41.2023.01.13.05.59.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 05:59:32 -0800 (PST)
Date:   Fri, 13 Jan 2023 15:59:30 +0200
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
Message-ID: <20230113135930.27hpr5uxtrv77z44@skbuf>
References: <20230106101651.1137755-1-lukma@denx.de>
 <20230106101651.1137755-1-lukma@denx.de>
 <20230106145109.mrv2n3ppcz52jwa2@skbuf>
 <20230113131331.28ba7997@wsk>
 <20230113122754.52qvl3pvwpdy5iqk@skbuf>
 <20230113142017.78184ce1@wsk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230113142017.78184ce1@wsk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 13, 2023 at 02:20:17PM +0100, Lukasz Majewski wrote:
> The fixed function maybe should look like below:
> 
> static int mv88e6xxx_get_max_mtu(struct dsa_switch *ds, int port)
> {
> 	....
> 	
> 	int max_mtu;
> 
> 	max_mtu = chip->info->max_frame_size - VLAN_ETH_HLEN -
> 		  ETH_FCS_LE;
> 
> 	if (dsa_is_dsa_port(ds, port) || dsa_is_cpu_port(ds, port))
> 		  max_mtu -= EDSA_HLEN;
> 
> 	return max_mtu;
> }
> 
> Comments more than welcome.

I suspect that looking at the DSA code which calls these methods will
answer a lot of your questions. ds->ops->port_max_mtu() is only called
for user ports. As for ds->ops->port_change_mtu(), this will always be
called with the requested L2 payload length (default 1500) on user ports,
and with the maximum among user ports for DSA and CPU ports.
