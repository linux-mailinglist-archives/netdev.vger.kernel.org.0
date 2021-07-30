Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D2733DBEBA
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 21:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbhG3THQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 15:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230408AbhG3THP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 15:07:15 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC109C06175F;
        Fri, 30 Jul 2021 12:07:09 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id hs10so9925366ejc.0;
        Fri, 30 Jul 2021 12:07:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=e8f4lcsPiJ3HGD4KPSWDS3ppWYq9M+P3wkpoyc+VO8w=;
        b=VzNCpodjTbGJ1h3RWJ4m7xZ0UvZI+Qk7PN1WqC8uE1LMFt1elPjP2OFe3tLRuyNdnE
         3z2j1nfPaTGY2n6tTyZn2MhgpX6B2Gx4WPV3is5QXHCOUOAYHA0pfSjW1aSKmwvFX0cD
         GZmKWnkVxtaj40+n51S8Edx7eFmJBYNYV4NPqfI+R3tFa2sNrFtoZ606NZk4E58U42cM
         //03VjkkcXuMg7ipYDa7kkp7i7z1QPeeySFPn5BAGBicX0bCVM1Wb+ZXzbmeL8gCnn2A
         CtmIcNJkXWWeKEqi7cWRxvlRH4k4a1TTLG/3CP6QqGkQGKQjPQ59P3uqzu3wWji00cQw
         ZqsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=e8f4lcsPiJ3HGD4KPSWDS3ppWYq9M+P3wkpoyc+VO8w=;
        b=r+B/rmS3tOc3el6TK3z6zA966wZyjG9AFD5kB1pcPuqLONr5Sv2OanlrNJqVzGGCB+
         O6hE/TJjAoJookM9cJhIlsCvsuXN0BWcQvVV3+cAtKbbH+SrN8p9sVvf0Sgpk9SobX13
         oO2CK9IRgMfQkXFyPhK1u25LpqXeC3DJSxsEhQAvSIZKIjhSa/ZbMB2pbAuZEKz1UOQw
         HC4bnlcWAhp8nr9maEisv+7aOwuhcs4UJxk436Il4S6HM6jC1SkK5pZgb/4r7050ebdx
         10nQs9zUPTtWqPZfk4TQZoib9weUdPsJVBal/HclJo9ViL5Div4bO5x8GNBBdEQ/M188
         elZw==
X-Gm-Message-State: AOAM5319JH9sSoz9eJMt/htr9l4zI7Dfrov/tUsWszcypWeW6hWrFSiw
        WTrac3OAd368NwkUQ1lDEcI=
X-Google-Smtp-Source: ABdhPJw7sKiaK516UBNTL6irnVQE7OfE7dl0ZV5DJI/pu6FmwyKwV5ypwy5U+LfXesW1jZecq43tkg==
X-Received: by 2002:a17:907:1b02:: with SMTP id mp2mr4139238ejc.196.1627672028400;
        Fri, 30 Jul 2021 12:07:08 -0700 (PDT)
Received: from skbuf ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id br3sm858993ejb.103.2021.07.30.12.07.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 12:07:08 -0700 (PDT)
Date:   Fri, 30 Jul 2021 22:07:06 +0300
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
Message-ID: <20210730190706.jm7uizyqltmle2bi@skbuf>
References: <20210728175327.1150120-1-dqfext@gmail.com>
 <20210728175327.1150120-2-dqfext@gmail.com>
 <20210728183705.4gea64qlbe64kkpl@skbuf>
 <20210730162403.p2dnwvwwgsxttomg@skbuf>
 <20210730190020.638409-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210730190020.638409-1-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 31, 2021 at 03:00:20AM +0800, DENG Qingfang wrote:
> On Fri, Jul 30, 2021 at 07:24:03PM +0300, Vladimir Oltean wrote:
> > Considering that you also have the option of setting
> > ds->assisted_learning_on_cpu_port = true and this will have less false
> > positives, what are the reasons why you did not choose that approach?
> 
> After enabling it, I noticed .port_fdb_{add,del} are called with VID=0
> (which it does not use now) unless I turn on VLAN filtering. Is that
> normal?

They are called with the VID from the learned packet.
If the bridge is VLAN-unaware, the MAC SA is learned with VID 0.
Generally, VID 0 is always used for VLAN-unaware bridging. You can
privately translate VID 0 to whatever VLAN ID you use in VLAN-unaware
mode.
