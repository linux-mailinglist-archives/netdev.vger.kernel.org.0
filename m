Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA814848FE
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 20:53:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbiADTxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 14:53:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbiADTxI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 14:53:08 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DFD2C061761
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 11:53:08 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id q16so78349800wrg.7
        for <netdev@vger.kernel.org>; Tue, 04 Jan 2022 11:53:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=TNrYqZuLL+yEHVf4OZ5s47u4B/1oVfP7uSuqYHnd6oM=;
        b=RS6KLt89EP3+DBc0B+Tf7Ydl1RW2aFKKawAcYl0kf2NOEIVrgGlZWy3RpZO2QHwj9A
         XxXkCHR/EnJSTipCrJwDgdNxOsm6+xmWzKivjqDR3xRCL2FnaW/rg3RvS1hUd0ylLaaM
         WmHXy5QSRKmB3tflnPh0fR5BGKBa8S/MtYVIZPKiTkjpDKwvgQRyWNJ2HTfL35EROwE2
         tM7Qebc6z8atLqEscXRJmE8MUG5dr7R7yLNyk8ZtxaeL0JRc+XT21pdx4XBszCi5Op8B
         1MJb0noJGyJFLAHgR7krdXU9tP/uUZ1JlyYIh32d54qpQox400KqAC4EEYl3FajaD8Dz
         bACg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=TNrYqZuLL+yEHVf4OZ5s47u4B/1oVfP7uSuqYHnd6oM=;
        b=qyobA4CoaWPDUI3HXGa7z6X/84Rlo0++EiKH7/kYZw/pkGDNJ8RggrlaMVgLMfwOSD
         H2YpRj6c4touZwETZmUZom/EPRE0QYQFleGdQNuZ0NpYS0mrSmQsjNcPkrtNEqzO7ugP
         FsUbbT5cED7OsmU8ebps3VJkICPZrTZ2Nu0opGFaHtv6kGITbyQbeIdPLWJMozs0nOFy
         UOX/1BXyR8mCSpwAq8CZVg7qbr7Pk3OtCl1Gvk7/phNMqSO8+0gTbTMj9Q7+xNEs1Mfz
         lx2zl2yH3PznNjy6djtcsxMIhkLhu5GS4op6HCMF9G2I7bYzWEglqRhMljxDg5+k7O/u
         WtNA==
X-Gm-Message-State: AOAM532N7equCzj7xpeFlx7UW8ZPiFMOBmd37vg5B4MbmwA9ZO5WtI2I
        gT2spEF9ExQ+rax5etJAuvX2ZsriaZw=
X-Google-Smtp-Source: ABdhPJxqjyWb2n3K2PjAmMRzvjeM50LHviPmV6ahNvc0O67c/xKU5uQ2AtPyVd2LUioA6FsAhfuzsw==
X-Received: by 2002:a5d:60c8:: with SMTP id x8mr45609113wrt.695.1641325987041;
        Tue, 04 Jan 2022 11:53:07 -0800 (PST)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id g1sm39239026wri.103.2022.01.04.11.53.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 11:53:06 -0800 (PST)
Date:   Tue, 4 Jan 2022 20:53:02 +0100
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: phy: marvell: use phy_write_paged() to
 set MSCR
Message-ID: <YdSlnsAtpm4jZIj1@Red>
References: <YdR3wYFkm4eJApwb@shell.armlinux.org.uk>
 <E1n4mpB-002PKE-UM@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <E1n4mpB-002PKE-UM@rmk-PC.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Tue, Jan 04, 2022 at 04:38:13PM +0000, Russell King (Oracle) a écrit :
> Use phy_write_paged() in m88e1118_config_init() to set the MSCR value.
> We leave the other paged write for the LEDs in case the DT register
> parsing is relying on this page.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/phy/marvell.c | 22 ++++++++--------------
>  1 file changed, 8 insertions(+), 14 deletions(-)
> 

Tested-by: Corentin Labbe <clabbe.montjoie@gmail.com>

Thanks!
