Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 600553DBDF3
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 19:51:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbhG3Rvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 13:51:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbhG3Rvy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 13:51:54 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92912C06175F;
        Fri, 30 Jul 2021 10:51:48 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id q18so10236797ile.9;
        Fri, 30 Jul 2021 10:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=sAh2TyVPupc4SlO/7+ZRZndIoKJA5QlMvjRl7Cc62vo=;
        b=vZaWUIG9YhzoHq/DrESu1sNvIu/+WtI93Ev4/7u26zHEJwAkhM9T/x0vyZhjWIEfpW
         drknizjaupZUrwoTTO5eXxZKB+MduPyzoZ2+qul0opbUSFMl0STzKHlp72bIb5YbBGUa
         mU35xosjPM3VJA6kzSqxJX+PLQMfiYWSolg5DKrAWvqWhRPG+nUea+PEnyggSofkrKLZ
         S3GCYrkb1UeGgCfiGO/6zPnZmDnREVbMY1H5VmYfTR2qG0FS4AU98lkDnGt/WYXbWlcT
         vVX500xSOkVAUUoAKm2q/tZJHqyPTlTGxGWgUzJNHLjOkY/j+ZivlXUotWvw4LmauAVZ
         4GGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=sAh2TyVPupc4SlO/7+ZRZndIoKJA5QlMvjRl7Cc62vo=;
        b=np+Man5lgTn60jHl7RrOclJH84oao4i1l+2DPKDHsUrRgQHm+r/ARuUsWJnjnY7EcP
         sCNKLDzsqGcZ/vyacHAZ2fWcP4hRoK3aZTdW3XY5JDSIpwgNVH41STbfO9s4p2GGdM4y
         I4C5JFK7+tJuofa7n67jOKJBL5gDXoxmIaUf3j/tyHlodXRYDr8C6MsML2ui8juG7yuc
         m3R+Dv7HNH1S8WsV6N4QWDo649/At9TMPOKbC48HBPd4+NJGI/Tz4Vf+hZ3PZm1X+8K6
         5/lCRnkXvP1Cs0iA6AWLiPVHFvLFbaVtUGWJxZuX05srJrxj9hH3YIDZmivfg4u1wXCF
         SEsQ==
X-Gm-Message-State: AOAM532MGy5ElOmIpshh60nHl03rSUf7LfBCkfqsEBMCzEdft25fP6E7
        GmxRPB3vBM6+YJ20AlDb5u4=
X-Google-Smtp-Source: ABdhPJwikl+WdVj7X74h8YFsRMAjuzkEZaOB6L6n9wMeM+n+iyQaSmmXyece5DyOUrBOjpnmxFi/Rg==
X-Received: by 2002:a92:bf11:: with SMTP id z17mr1793894ilh.3.1627667508071;
        Fri, 30 Jul 2021 10:51:48 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id t11sm1427256ioc.4.2021.07.30.10.51.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 10:51:47 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC net-next 2/2] net: dsa: mt7530: trap packets from standalone ports to the CPU
Date:   Sat, 31 Jul 2021 01:51:39 +0800
Message-Id: <20210730175139.518992-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210730173511.ulsv7wfogk5cpx5j@skbuf>
References: <20210728175327.1150120-1-dqfext@gmail.com> <20210728175327.1150120-3-dqfext@gmail.com> <20210729152805.o2pur7pp2kpxvvnq@skbuf> <CALW65jbHwRhekX=7xoFvts2m7xTRM4ti9zpTiah8ed0n0fCrRg@mail.gmail.com> <20210729165027.okmfa3ulpd3e6gte@skbuf> <CALW65jYYmpnDou0dC3=1AjL9tmo_9jqLSWmusJkeqRb4mSwCGQ@mail.gmail.com> <20210730161852.4weylgdkcyacxhci@skbuf> <20210730171935.GA517710@haswell-ubuntu20> <20210730173511.ulsv7wfogk5cpx5j@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 30, 2021 at 08:35:11PM +0300, Vladimir Oltean wrote:
> On Sat, Jul 31, 2021 at 01:21:14AM +0800, DENG Qingfang wrote:
> > I just found a cleaner solution: Leaving standalone ports in port matrix
> > mode. As all bridges use independent VLAN learning, standalone ports'
> > FDB lookup with FID 0 won't hit.
> 
> So standalone ports are completely VLAN-unaware and always use a FID of
> 0, ports under a VLAN-unaware bridge are in fallback mode (look up the
> VLAN table but don't drop on miss), use a FID of 1-7, and ports under a
> VLAN-aware bridge are in the security mode and use the CVID instead of
> the FID for VLAN classification?

No. Both VLAN-unaware and VLAN-aware bridges use independent VLAN learning
i.e. use CVID for FDB lookup.

> 
> Make sure to test a mix of standalone, VLAN-unaware bridge and
> VLAN-aware bridge with the same MAC address in all 3 domains. If that
> works well this should be really good.
