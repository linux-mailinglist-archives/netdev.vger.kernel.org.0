Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B883A3E9997
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 22:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231723AbhHKUUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 16:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbhHKUUq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 16:20:46 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9508BC061765;
        Wed, 11 Aug 2021 13:20:22 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id g21so5674509edb.4;
        Wed, 11 Aug 2021 13:20:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3SzsmOsH/ZksAiu3m5vkV53kJ8Io7UQPxk+6rle6cO0=;
        b=lvBxo2KzvOWNFyRckKcLAbbGR59F+R2DoLPmUTpzerl9JMwJMmkkdZAIv8daFCVrLj
         2u4SmTDuoJ+dpIUNbaqCGXV+AK+74NjPL+QiTjBEPnDevcI4w1zDF2BvzD0UiTIVVN55
         NfbXT9fLsK6T3feZR+ZuZWTXw4p/u64WLRtcQR3o/aM4aCJkAww1DmttIWzgF5sCm+1u
         Kugbh1y+MIq8yH6JWHHtMApKWHs6hqHdc6WoF4Jc+qVx1L8Y8RZOHU6l8je98SKbnPlV
         1ToZHUsZF9F20FivoFCHvGSxf+VSkgeTOhDgoBDG2co4kMq1spjoA5P3/yJdTIFKZFR6
         nb3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3SzsmOsH/ZksAiu3m5vkV53kJ8Io7UQPxk+6rle6cO0=;
        b=J3y2uCcNDhBtRq4fcQrG23VneJWhvpDXE+IPqPTbuP3fsb1f6eXGrXOJDOq/OSC4b2
         3cSikD+8loIHh/4Assovi/wehYAtaRNbakiFEyLT1xGIUuSSLjhdIHylhpH2xtiTLDCK
         F0VjQpkgmY71VQEktoBnhtDs0msZasS6n107cB90Mq15h0xK4tU1SqFPvKRGyxMh21zc
         GaN0Ohi3rCROAjSpLO9Eaep7K27gQK2FMq0kDnO1sVqPkGOLE2sn1D/vpsYVXGE0ePII
         aLDWPftbC+4TA+C6QdghubWu5H4kBzUNeGP+x6MMQctNNG4FjNN0vKtqt6DsLjB1dr1M
         gHig==
X-Gm-Message-State: AOAM533eQHBKeMbYWPhxMBxb6GVo/9c62H6y0EbMnWM5HH6gKx89nRxp
        Gc5fjRVGmUxkCGQdL9elOvI=
X-Google-Smtp-Source: ABdhPJyvwO/Gnm8uSMs8+Y3MrhV+NqCdvwB31wUYlY1ezFahsPpm5JjMGJr9ATJiRFBnUjINy6DgtQ==
X-Received: by 2002:a05:6402:5:: with SMTP id d5mr817303edu.359.1628713221097;
        Wed, 11 Aug 2021 13:20:21 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id n10sm138237ejk.86.2021.08.11.13.20.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 13:20:20 -0700 (PDT)
Date:   Wed, 11 Aug 2021 23:20:19 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        netdev@vger.kernel.org, robh+dt@kernel.org,
        UNGLinuxDriver@microchip.com, Woojung.Huh@microchip.com,
        hkallweit1@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 net-next 05/10] net: dsa: microchip: add DSA support
 for microchip lan937x
Message-ID: <20210811202019.seskua7bzagxis7u@skbuf>
References: <YQfvXTEbyYFMLH5u@lunn.ch>
 <20210802135911.inpu6khavvwsfjsp@skbuf>
 <50eb24a1e407b651eda7aeeff26d82d3805a6a41.camel@microchip.com>
 <20210803235401.rctfylazg47cjah5@skbuf>
 <20210804095954.GN22278@shell.armlinux.org.uk>
 <20210804104625.d2qw3gr7algzppz5@skbuf>
 <YQ6pc6EZRLftmRh3@lunn.ch>
 <20191b895a56e2a29f7fee8063d9cc0900f55bfe.camel@microchip.com>
 <YRQViFYGsoG3OUCc@lunn.ch>
 <20210811201414.GX22278@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210811201414.GX22278@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 11, 2021 at 09:14:14PM +0100, Russell King (Oracle) wrote:
> On Wed, Aug 11, 2021 at 08:23:04PM +0200, Andrew Lunn wrote:
> > > I hope that using "*-internal-delay-ps" for Mac would be the right option.
> > > Shall i include these changes as we discussed in next revision of the patch? 
> > 
> > Yes, that seems sensible. But please limit them to the CPU port. Maybe
> > return -EINVAL for other ports.
> 
> Hmm. Don't we want ports that are "MAC like" to behave "MAC like" ?
> In other words, shouldn't a DSA port that can be connected to an
> external PHY should accept the same properties as a conventional
> Ethernet MAC e.g. in a SoC device?

+1, I thought the whole purpose of the discussion was to stop singling
out the CPU port as being special in any way w.r.t. RGMII delays.
