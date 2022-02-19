Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 605984BCAB8
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 22:33:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbiBSVWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 16:22:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230404AbiBSVWr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 16:22:47 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8E163134D
        for <netdev@vger.kernel.org>; Sat, 19 Feb 2022 13:22:27 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id d10so23158790eje.10
        for <netdev@vger.kernel.org>; Sat, 19 Feb 2022 13:22:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EOogGeuI64yHvl9Z+xbxaGRk6UC+hsBNQtzEmQyz9U8=;
        b=eQJggaX1tOfUdSh343erKj/Z4s7gdLUgXa5tf4CiQ4EY1cbYJz3uXqtylUSwSVdmtu
         QgyUxEyJZyEyAnV1iTuPqFQOt9YHZygo1sjcwtspLxZzRb3iyOzW5PmsQYA0fW2s+LYL
         fZS28qh9WeO8yJydJjlZ+7o3KMHRyP6aF8AFYyPgfpW1ggq0RjR7ZlOXaLCuBytNkn6d
         /ABHwXV3uk4JKrCKchbPN6xRI0fFR+sfsJlkOx6ky4I+ASRVLYjJkbfZfxJWIKWPx25Z
         NX2mq6jQdkN6asbS/kB8sf5+zXeewBggVhFWevj1Kb8r3lpvnu0W5nvPO0/GfZG5NotS
         248g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EOogGeuI64yHvl9Z+xbxaGRk6UC+hsBNQtzEmQyz9U8=;
        b=YDr+U6V5q6x4y4n1XdFSH1EYjraKaS53nM6OiWoubYyYzy0GxLl0PpW6ifl0pKTwBu
         9Eyp2L/eZzWEZhU0Sv3Fby0faBVLrj9pAvcGkJzMsJqWCLJjtM2NQZ9QcjXDXe0f6QCn
         hc4sK3IhITYIL6MApPYSFLiVo36aKkviD01s41H18vBSVkanDsnRJ1WOPsM/oXyBnkBr
         5w7qEe+3oA9GNCuGHd296YtPbNTQIrtfeK+sG3HZZgD6fR7X9zjOg188PySEryKX9siI
         sNYAIXl7xg4XwIesRSyLfupEEBR6ScyduYP+J7r2tGL+ac3NQutJnPj2VFyTJ25FyOgR
         +62g==
X-Gm-Message-State: AOAM530ATCIxxrepqDjGFsRWPKMcGw4jqLVZsT7Msr/y0WpJ07MgzXVd
        /aOW2l2qydKNuwlVWXaPRE8=
X-Google-Smtp-Source: ABdhPJy1MeFUnWsGjA02SrSnIShvOgiyi9JllNC1nTgsHd17JWof14I0xZseDJqRl58Osk3DEcRtOw==
X-Received: by 2002:a17:907:986d:b0:6d0:7e8:a0a with SMTP id ko13-20020a170907986d00b006d007e80a0amr10389194ejc.81.1645305746244;
        Sat, 19 Feb 2022 13:22:26 -0800 (PST)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id x7sm3293457edr.12.2022.02.19.13.22.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Feb 2022 13:22:25 -0800 (PST)
Date:   Sat, 19 Feb 2022 23:22:24 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next v2 1/6] net: dsa: add support for phylink
 mac_select_pcs()
Message-ID: <20220219212223.efd2mfxmdokvaosq@skbuf>
References: <Yg6UHt2HAw7YTiwN@shell.armlinux.org.uk>
 <E1nKlY3-009aKs-Oo@rmk-PC.armlinux.org.uk>
 <20220219211241.beyajbwmuz7fg2bt@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220219211241.beyajbwmuz7fg2bt@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 19, 2022 at 11:12:41PM +0200, Vladimir Oltean wrote:
> >  static const struct phylink_mac_ops dsa_port_phylink_mac_ops = {
> >  	.validate = dsa_port_phylink_validate,
> > +	.mac_select_pcs = dsa_port_phylink_mac_select_pcs,
> 
> This patch breaks probing on DSA switch drivers that weren't converted
> to supported_interfaces, due to this check in phylink_create():

And this is only the most superficial layer of breakage. Everywhere in
phylink.c where pl->mac_ops->mac_select_pcs() is used, its presence is
checked and non-zero return codes from it are treated as hard errors,
even -EOPNOTSUPP, even if this particular error code is probably
intended to behave identically as the absence of the function pointer,
for compatibility.
