Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB2D33C883
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 22:35:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232987AbhCOVe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 17:34:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233079AbhCOVeQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 17:34:16 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 331A8C06174A
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 14:34:16 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id si25so13059697ejb.1
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 14:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bgpNwJbaV2TZX0/n2RkwcGft2vK8bTgQMzTln6+69ag=;
        b=Yxl6OxIf8rdiZ3INGY7PXAsl4B7Yvsfl9HuA2aisd3k7EFSrcU6tImaiwN2qSXNAqG
         q443mO0+NK+p4M7YVkbxh8Kpoa64PXsj+4+MroPkm+rKtKjtdliWcdXNyC0B+Tgjit6s
         nbj0RB5Wgo5gN4+wAjMOJH+0rtSYyVPK7SVvrbW7h82pYqjl53mnwju7yazXxIUV7sou
         tdmOte6s599+2TKz+cM9EkXF3HeNl2rU4A+F3KRVndwL55Eqd3uJ9W+ATCby/RXnqMgN
         AuX6TWE6CQjKlblbLRPRslZl9lIvxwi8v2QuEguCgWmQAqmoQ+SGCSSlHDbbjjwGuNND
         gDrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bgpNwJbaV2TZX0/n2RkwcGft2vK8bTgQMzTln6+69ag=;
        b=Zs5Bn3qsDSTXElISxBBq+ozCI/UlcWSaovb1jNimjRyQ5WAGuF/O14x+QSyBt8yAYf
         ogBvQa7gR0HwpmSD6iYa6U7C07/SZoWrGOHBWRbHsgsbKoBOXBNGzPY3xyoTZfUhenN3
         GD/3oBlk/dFgbZt0YJF9yIUboYV972DFukKlMC7/zZYC3fpmsg91XgID/K1dSN4mcLkH
         c886AcT8ShBklU/vT0+cAKEbqvzG5709zlr6B4dWbj+F1RgZA10AjJ8VUT6whDq6pCck
         K7gwZ6ZapdYHic4ylny9B1/q/EKvxEc4piRZSQ06Hmn+WIw6CiBHmSPnZH/L/doaYbHT
         UKOQ==
X-Gm-Message-State: AOAM532M9bWZFoZqBoOzpkWAKvLleh3v2FOppHkJ20fAXQvvEBAh1ozY
        rCEDd9vKPBZNXPq8hZh8hgcFZntuVv4=
X-Google-Smtp-Source: ABdhPJyajuatcx2O3juWbDWUWDWCFcIsYqcFQnLm0tAhv1Foq6s+I9GOcodMdghkMrgpPEh9NXZ5hw==
X-Received: by 2002:a17:906:a44f:: with SMTP id cb15mr25523824ejb.420.1615844054979;
        Mon, 15 Mar 2021 14:34:14 -0700 (PDT)
Received: from skbuf ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id r17sm9298134edx.1.2021.03.15.14.34.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 14:34:14 -0700 (PDT)
Date:   Mon, 15 Mar 2021 23:34:13 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Kurt Kanzenbach <kurt@kmk-computers.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: hellcreek: Offload bridge port flags
Message-ID: <20210315213413.k4td2urqxl2sqflg@skbuf>
References: <20210314125208.17378-1-kurt@kmk-computers.de>
 <20210315200813.5ibjembguad2qnk7@skbuf>
 <87lfao88d3.fsf@kmk-computers.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lfao88d3.fsf@kmk-computers.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 15, 2021 at 09:33:44PM +0100, Kurt Kanzenbach wrote:
> On Mon Mar 15 2021, Vladimir Oltean wrote:
> > On Sun, Mar 14, 2021 at 01:52:08PM +0100, Kurt Kanzenbach wrote:
> >> +	if (enable)
> >> +		val &= ~HR_PTCFG_UUC_FLT;
> >> +	else
> >> +		val |= HR_PTCFG_UUC_FLT;
> >
> > What does 'unknown unicast filtering' mean/do, exactly?
> > The semantics of BR_FLOOD are on egress: all unicast packets with an
> > unknown destination that are received on ports from this bridging domain
> > can be flooded towards port X if that port has flooding enabled.
> > When I hear "filtering", I imagine an ingress setting, am I wrong?
> 
> It means that frames without matching fdb entries towards this port are
> discarded.

The phrasing is still not crystal clear, sorry.
You have a switch with 2 user ports, lan0 and lan1, and one CPU port.
lan0 and lan1 are under br0. lan0 has 'unknown unicast filtering'
disabled, lan1 has it enabled, and the CPU port has it disabled.
You receive a packet from lan0 towards an unknown unicast destination.
Is the packet discarded or is it sent to the CPU port?
