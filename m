Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A87F31A471
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 19:20:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbhBLSUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 13:20:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbhBLSUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 13:20:06 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30336C061574;
        Fri, 12 Feb 2021 10:19:26 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id u143so9590pfc.7;
        Fri, 12 Feb 2021 10:19:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LjggpD0ZH/Pqu3nkvvYgvuE8A11ApMPMgPJmvgr5AOc=;
        b=hCYlf9Bd/xukRXSaj9KNSXuGNpdT3LKCCM8afVgruvN/IgilhYlrbApS/H5kvBac9C
         f20TZYDRynrncNa2dFQbzpnaMyHHr+xWjKtv9FDQlZmfm2C/Wltc7IRtcYTi2miEGQy6
         Yv93I3W90ML3E6FnkeThqAXXjA/jE9X1vEXaS1B+Q6NBKCU/tYWkg9qfXr4um3LOUMpj
         DZjUxQhM77V1uxArxyyFeuAQICGDypJmtORkXElLLX3Fs+JsOJsRDbSNoA9m9W92quiu
         gyzKcoG7JFOuySRWQrtnxJMAKARgb1I6Mt+AIhAb32l3YXdwLGkJNNfZo/YnnoptZAfT
         1hjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LjggpD0ZH/Pqu3nkvvYgvuE8A11ApMPMgPJmvgr5AOc=;
        b=uCz6TpwtOEyoIcM2XmfEb5vnrnxgz6BbgAW/hZy1sUJAWYVGp2Webc5FQa9ZLoeciE
         wCnjuBNwbBjQeJsAMxss9UvhAL16160Y/0hYOHeMbi+0BYit2IOZJlfLz2LUKdOCDlNw
         KLmbTdn7JHDINEzUVjbdmY4oVzd6Dyxar8B/ixhzZOSGMO6br4rRcoNWDrGczgHulq0d
         Cx3AoiwcO/KTWfX2zuSfsdmGN/QiQw3inYYtKPo0zqbdC9eJFq8mZAQk9MGMtPw0NxJK
         g6bT+GmORpP99qqsw2pmP39RCGXsx5WYlvtoum6mNyNNcUliUygtQd6GUTLbTRaLa4H2
         qQtA==
X-Gm-Message-State: AOAM533o0/d5z4CfbZfPOsWUqs5w1Jf4smpaLMh1dxDfXQ5nZd0OlAbA
        aa56fkPAQZgz8x1yizjNkkRUVVvZSQs=
X-Google-Smtp-Source: ABdhPJwUWkZNP1RymSaYKEK/YXsJ7CqqjBW+nAYgg7/2jvH1y7TsgdRhr0Er2w7QRW4OaHMs+VCEHA==
X-Received: by 2002:aa7:8f0a:0:b029:1de:4d20:8346 with SMTP id x10-20020aa78f0a0000b02901de4d208346mr4255553pfr.15.1613153965260;
        Fri, 12 Feb 2021 10:19:25 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w19sm9842592pgf.23.2021.02.12.10.19.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Feb 2021 10:19:24 -0800 (PST)
Subject: Re: [PATCH v5 net-next 06/10] net: dsa: act as passthrough for bridge
 port flags
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org
References: <20210212151600.3357121-1-olteanv@gmail.com>
 <20210212151600.3357121-7-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <77072163-86e3-a6a5-350c-22bdab10d890@gmail.com>
Date:   Fri, 12 Feb 2021 10:19:21 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210212151600.3357121-7-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/12/2021 7:15 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> There are multiple ways in which a PORT_BRIDGE_FLAGS attribute can be
> expressed by the bridge through switchdev, and not all of them can be
> emulated by DSA mid-layer API at the same time.
> 
> One possible configuration is when the bridge offloads the port flags
> using a mask that has a single bit set - therefore only one feature
> should change. However, DSA currently groups together unicast and
> multicast flooding in the .port_egress_floods method, which limits our
> options when we try to add support for turning off broadcast flooding:
> do we extend .port_egress_floods with a third parameter which b53 and
> mv88e6xxx will ignore? But that means that the DSA layer, which
> currently implements the PRE_BRIDGE_FLAGS attribute all by itself, will
> see that .port_egress_floods is implemented, and will report that all 3
> types of flooding are supported - not necessarily true.
> 
> Another configuration is when the user specifies more than one flag at
> the same time, in the same netlink message. If we were to create one
> individual function per offloadable bridge port flag, we would limit the
> expressiveness of the switch driver of refusing certain combinations of
> flag values. For example, a switch may not have an explicit knob for
> flooding of unknown multicast, just for flooding in general. In that
> case, the only correct thing to do is to allow changes to BR_FLOOD and
> BR_MCAST_FLOOD in tandem, and never allow mismatched values. But having
> a separate .port_set_unicast_flood and .port_set_multicast_flood would
> not allow the driver to possibly reject that.
> 
> Also, DSA doesn't consider it necessary to inform the driver that a
> SWITCHDEV_ATTR_ID_BRIDGE_MROUTER attribute was offloaded, because it
> just calls .port_egress_floods for the CPU port. When we'll add support
> for the plain SWITCHDEV_ATTR_ID_PORT_MROUTER, that will become a real
> problem because the flood settings will need to be held statefully in
> the DSA middle layer, otherwise changing the mrouter port attribute will
> impact the flooding attribute. And that's _assuming_ that the underlying
> hardware doesn't have anything else to do when a multicast router
> attaches to a port than flood unknown traffic to it.  If it does, there
> will need to be a dedicated .port_set_mrouter anyway.
> 
> So we need to let the DSA drivers see the exact form that the bridge
> passes this switchdev attribute in, otherwise we are standing in the
> way. Therefore we also need to use this form of language when
> communicating to the driver that it needs to configure its initial
> (before bridge join) and final (after bridge leave) port flags.
> 
> The b53 and mv88e6xxx drivers are converted to the passthrough API and
> their implementation of .port_egress_floods is split into two: a
> function that configures unicast flooding and another for multicast.
> The mv88e6xxx implementation is quite hairy, and it turns out that
> the implementations of unknown unicast flooding are actually the same
> for 6185 and for 6352:
> 
> behind the confusing names actually lie two individual bits:
> NO_UNKNOWN_MC -> FLOOD_UC = 0x4 = BIT(2)
> NO_UNKNOWN_UC -> FLOOD_MC = 0x8 = BIT(3)
> 
> so there was no reason to entangle them in the first place.
> 
> Whereas the 6185 writes to MV88E6185_PORT_CTL0_FORWARD_UNKNOWN of
> PORT_CTL0, which has the exact same bit index. I have left the
> implementations separate though, for the only reason that the names are
> different enough to confuse me, since I am not able to double-check with
> a user manual. The multicast flooding setting for 6185 is in a different
> register than for 6352 though.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
