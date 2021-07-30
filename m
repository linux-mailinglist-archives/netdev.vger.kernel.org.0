Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 030A83DBDE1
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 19:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbhG3Rln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 13:41:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbhG3Rln (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 13:41:43 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D3A7C06175F;
        Fri, 30 Jul 2021 10:41:38 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id qk33so18098338ejc.12;
        Fri, 30 Jul 2021 10:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fApfSt5TfcvkOvSkBi+6JejmfVBJe/9djRChVT09DVY=;
        b=GQ945PepXalaR/gubS94TrHtXyUfJQUj/J0wpi2xt/pQppLDUysXjv1kVO/m/lqou4
         teYX1WFF4rVpP1ICN7TdzeiN4qh2eUkGkccjS5Px1586ZLToF/ra2F/0rzExRQsYuOt9
         Z58P/w6kgoodFXRW2aGRsp++t70y99E0+yT8kRUbnWIqBfaMkJL/8YdReCWBFTAL70RY
         g0kso1r+V+UnBAOM3QR8pvCVZL6LtX+/9leIza9T6eTn79ZsUh1AqNhk3fvRkLJO6biH
         MmMIq4Clm6HSZCg8YVKJ1eNXjEk0fWhAds+4BKx+rXISnQjYZxJReIdt4SHpZPk4eUFf
         cVzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fApfSt5TfcvkOvSkBi+6JejmfVBJe/9djRChVT09DVY=;
        b=ajgl6R+SVTIPaojve0bSlcfT4huxxpPgxZNgnTs/4Hvxu357Gy9uImBEEc+/Km9CDf
         ONhGMWpOixBMqymbJMnKD50echxvSBIfcsttXHHKCUXlRkpqo6teqI6qvJu1/WL20PJi
         erfyciIlwDma4aGXsX/Mxbafk++xi4/Xiih11Pq10yxHq+tU0LKjSe3b6vxMu4FjJgIg
         hGqkQj7ecp2prVMmvCuWoYMY4vKIzzeY/nY1yFpsK+67VP/yvHimPGC0z/hj0NMRLqB8
         bKUbPEEdTeqkRRkLqb0xhCkora5u2h3pr0sxXWDeB/23+QpzSuBYHXSGK6+JnCRV8kaP
         kn1g==
X-Gm-Message-State: AOAM53172p9J2mAjwvD1Zk/bEyhsZA9hiuU1bL3c8LblybBwuCCOKGkt
        mAshYvW+lX+D+z6egPgxef0=
X-Google-Smtp-Source: ABdhPJzbx218edLWLX17ssNbvT6tAZmN03lSwZl+pNjm6ZHecME9cktLF2EhRTTM1pyYebccYGHQzg==
X-Received: by 2002:a17:906:cecc:: with SMTP id si12mr3704553ejb.335.1627666896775;
        Fri, 30 Jul 2021 10:41:36 -0700 (PDT)
Received: from skbuf ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id n11sm820942ejg.111.2021.07.30.10.41.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 10:41:36 -0700 (PDT)
Date:   Fri, 30 Jul 2021 20:41:35 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC net-next 1/2] net: dsa: tag_mtk: skip address learning on
 transmit to standalone ports
Message-ID: <20210730174135.ycsq3dhpr57roxsy@skbuf>
References: <20210728175327.1150120-1-dqfext@gmail.com>
 <20210728175327.1150120-2-dqfext@gmail.com>
 <20210728183705.4gea64qlbe64kkpl@skbuf>
 <20210730162403.p2dnwvwwgsxttomg@skbuf>
 <20210730173203.518307-1-dqfext@gmail.com>
 <20210730173902.vezop3n55bk63o6f@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210730173902.vezop3n55bk63o6f@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 30, 2021 at 08:39:02PM +0300, Vladimir Oltean wrote:
> On Sat, Jul 31, 2021 at 01:32:03AM +0800, DENG Qingfang wrote:
> > On Fri, Jul 30, 2021 at 07:24:03PM +0300, Vladimir Oltean wrote:
> > > Considering that you also have the option of setting
> > > ds->assisted_learning_on_cpu_port = true and this will have less false
> > > positives, what are the reasons why you did not choose that approach?
> > 
> > You're right. Hardware learning on CPU port does have some limitations.
> > 
> > I have been testing a multi CPU ports patch, and assisted learning has
> > to be used, because FDB entries should be installed like multicast
> > ones, which point to all CPU ports.
> 
> Ah, mt7530 is one of the switches which has multiple CPU ports, I had
> forgotten that. In that case, then static FDB entries are pretty much
> the only way to go indeed.

I forget which ones are the modes in which the multi-CPU feature on
mt7530 is supposed to be used: static assignment of user ports to CPU
ports, or LAG between the CPU ports, or a mix of both?
