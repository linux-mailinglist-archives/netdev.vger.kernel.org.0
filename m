Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED0D2960F7
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 16:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2900876AbgJVOee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 10:34:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390764AbgJVOee (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 10:34:34 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E892BC0613CE;
        Thu, 22 Oct 2020 07:34:33 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id o9so1047987plx.10;
        Thu, 22 Oct 2020 07:34:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Sosi2JPyi8kkDE2zAI3zuo0tpS/CAdUgJvIdNLZZJD4=;
        b=nPkATG0i9oqy7I6qI49vX3iIOwJ9rokwX8Vc5trOi5MqOuzQwiLV/WKWfP24TqUpIZ
         KHiL9OyTrTdNAt0aLQj7k+iWQ0Af2W6xFhuxvtEhDBS35t1LeNEIvJD1y/YJqPi80hxi
         Z18C0rbJcApQf/elUSham3vE8MveihB0WxvWijBBDDITR+52TuPobJF4wEiYYkzhmE3S
         zH8kYOr/u1jAIMw+ASZlPfLS22eatJ4bK0zrHsM/iSG8Iff+/MnkvLSnAOXU2kDHzIxj
         /mut4ZSrDVrXwGtVOUCQJBl6Bqy7SPR9ViPtirlZw9nqQ9COE/QI0JsMXxzBEBHDJ3s6
         YDlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Sosi2JPyi8kkDE2zAI3zuo0tpS/CAdUgJvIdNLZZJD4=;
        b=pXYLxbJca79shSwQIiBElumsPykel8GcFrhcjl2xq6drn0KPKeGYDkUETw+tOa+wsm
         YDNPE9vy39f9TBBZMq+2dSZFK7UvQ2SnyV6uw/uNgHuZNmCQ0srMZza4nDd5avjlciKX
         TXlynZNKR3VC7EKuNgORmp6nECOT6KCIQUL1QnWTDCXVEXdF/AlKwbGhfbRiTbQjOFcy
         jKMkzp4v4NrPoQLicYZbtX5M2bbEKrXRTcMetZDuymkuQGbEKEYyWXLLiVPtOZGC78aD
         0grvlzIL5XvGCDVYITcsNYr2MsF+JqaMbKq2Rb/0G+E+SroegAY+e8eUfBiI/aRSFsS8
         XPrw==
X-Gm-Message-State: AOAM533wsa1yK0l3LZI8OD2v81Kw/eCKu+lk4+dYC/T/9bbOwy01g/Gi
        zCZ81BrM1JrPMCWRb78ITGk=
X-Google-Smtp-Source: ABdhPJwuJk0G398FX/FO0OTxt/Uia8/PlH9Rmf2+TzNfBl2LEUYnfO92o2YyW1sJy7wKlCzUSC+Yaw==
X-Received: by 2002:a17:90a:4b84:: with SMTP id i4mr2441433pjh.132.1603377273489;
        Thu, 22 Oct 2020 07:34:33 -0700 (PDT)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id ca5sm2540864pjb.27.2020.10.22.07.34.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2020 07:34:32 -0700 (PDT)
Date:   Thu, 22 Oct 2020 07:34:29 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Christian Eggers <ceggers@arri.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next 7/9] net: dsa: microchip: ksz9477: add
 hardware time stamping support
Message-ID: <20201022143429.GA9743@hoboy.vegasvil.org>
References: <20201019172435.4416-1-ceggers@arri.de>
 <20201022090126.h64hfnlajqelveku@skbuf>
 <20201022105014.gflswfpie4qvbw3h@skbuf>
 <2541271.Km786uMvHt@n95hx1g2>
 <20201022113243.4shddtywgvpcqq6c@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201022113243.4shddtywgvpcqq6c@skbuf>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 22, 2020 at 02:32:43PM +0300, Vladimir Oltean wrote:
> On Thu, Oct 22, 2020 at 01:11:40PM +0200, Christian Eggers wrote:
> 
> > it seems that "moving" the timestamp back to the tail tag on TX is not
> > required anymore. Keeping the RX timestamp simply in the correction
> > field (negative value), works fine now. So this halves the effort in
> > the tag_ksz driver.
> 
> Ok, this makes sense.
> Depending on what Richard responds, it now looks like the cleanest
> approach would be to move your implementation that is currently in
> ksz9477_update_ptp_correction_field() into a generic function called

+1
