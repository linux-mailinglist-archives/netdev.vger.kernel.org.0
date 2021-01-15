Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5568E2F8937
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 00:13:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbhAOXNc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 18:13:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726176AbhAOXNb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 18:13:31 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71224C061757
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 15:12:51 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id ke15so7931149ejc.12
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 15:12:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yszj1Xdu5Of63DxcqrI/E73iuargLM9gLsuZ1vuFEjU=;
        b=Iz68oMy3zmS6q/erQIRtEnkhvxiAFRpTWtRSy73hFTl+SuyRIbaP/LUeaMZRvIO/FA
         UrRUz6ehFRwgeLEqYT+PC+ERYHoA0Y8swNJKwnheYwtXIEWMWOMSwjy7EdnBVtmFPJGZ
         2EkTunV4HjzEE7nNmTrb+jDLOEMbykTOZvsKdfLa1CWY4WKiTe38YAX3vKqLVVSygopq
         WpxotIxaezNWtPGBaERZu5KXB7x1PVLPgBFvZOPb9+sbRcuoo0NC7mcdGzcupfSAJAxu
         GYINn2TV7/d1Dp0M6E9s/dWfNAe71cP7ok/XuuCGnD3+B68UtmFbuCany0jajVJFXNED
         4piw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yszj1Xdu5Of63DxcqrI/E73iuargLM9gLsuZ1vuFEjU=;
        b=HeHfZGZ43U+Od394P/W7JezpY/Sa0Z1TrJlVnP3DeJb0kl74el79D0lAlSAG+LgLU8
         n5CdcT8T5fkYq18JIssAHc2ZjTz25T2G2qpfTh/kmGM5hlUvOXJXe/FRDYAyIxHmGdw6
         HK39laq5Z3s8m6GHSY6pY+7oKjqmudg5HlPhwTb0X3nR+6/xb1VTBb7RpWR0IPkxwgtq
         d095ZXwoJBcR9l7gTaYWMveNpeX5fmjJ1ElIIeJyLcygdeTzziA4HBBRUiP1pRQfNoeF
         zp1i8Fdiwmn2vXRu6W+p5hal/ZNR63FtjTRHJK0JTS09L8TDGFG4vfj2R3Ek12e/EAx8
         PIoQ==
X-Gm-Message-State: AOAM532Y40FoE9fWGi7gWaqJ5cYMcnz90jxZ3fRfE3E8IotpTHE5uz6O
        6fuybSqAWDtKo9Ky9ArYTLE=
X-Google-Smtp-Source: ABdhPJzg3/Ociun7THOGpQn0y3Uo5YFvQGmUYhpE2WpcFZj+bc2txEwJj1F5EhFiyppFVwhbM6t4Wg==
X-Received: by 2002:a17:906:b51:: with SMTP id v17mr10782494ejg.8.1610752370189;
        Fri, 15 Jan 2021 15:12:50 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id q4sm72054ejx.8.2021.01.15.15.12.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 15:12:49 -0800 (PST)
Date:   Sat, 16 Jan 2021 01:12:48 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Oleksij Rempel <linux@rempel-privat.de>
Subject: Re: [PATCH net-next] net: dsa: set
 configure_vlan_while_not_filtering to true by default
Message-ID: <20210115231248.gsebq3bqro23qz7y@skbuf>
References: <20210114173426.2731780-1-olteanv@gmail.com>
 <20210115150314.757c8740@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210115150314.757c8740@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 15, 2021 at 03:03:14PM -0800, Jakub Kicinski wrote:
> On Thu, 14 Jan 2021 19:34:26 +0200 Vladimir Oltean wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > 
> > As explained in commit 54a0ed0df496 ("net: dsa: provide an option for
> > drivers to always receive bridge VLANs"), DSA has historically been
> > skipping VLAN switchdev operations when the bridge wasn't in
> > vlan_filtering mode, but the reason why it was doing that has never been
> > clear. So the configure_vlan_while_not_filtering option is there merely
> > to preserve functionality for existing drivers. It isn't some behavior
> > that drivers should opt into. Ideally, when all drivers leave this flag
> > set, we can delete the dsa_port_skip_vlan_configuration() function.
> 
> No longer applies :(

What's the error?
