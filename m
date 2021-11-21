Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 582AE4585DD
	for <lists+netdev@lfdr.de>; Sun, 21 Nov 2021 19:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235965AbhKUSRi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 13:17:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231214AbhKUSRh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Nov 2021 13:17:37 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E732C061574;
        Sun, 21 Nov 2021 10:14:32 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id r11so66690522edd.9;
        Sun, 21 Nov 2021 10:14:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fQHIbJRBk7doa/Y7HuWJn6OmTTaP5LB/b60eVfyiu5M=;
        b=I9aDEtuBACIm02PiuIKfxb/0DPS0rWKFD013l9J1+WlMtlUTknLjiykIuHPqAa38/Q
         dcgP8eOPfjCuua2MwQKN5hMMu1sreNZuhDtinz1x5Y79pTtVwHT+XSgznR1beGGDk6IU
         Lahs6lFXhZuU1D29MhVsYs8dCq3DL9F510G4N5bzJDfe5BqY+bA+5y04shcFmgTVX4wG
         zMn7LPN9jJmD2aLvC0MEtRiRSLFx2x/OtXEDEVx1Pi8DT4VGykcchd0b2hPn3dEnzfbv
         Kk0+JNTJK8CgrzPLAlrqGeBl41Oh4Xf6WhfclMrsbJisiV3dfJUdi51FQKUmWFt+OHtQ
         qpCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fQHIbJRBk7doa/Y7HuWJn6OmTTaP5LB/b60eVfyiu5M=;
        b=XhmWGoxPolW5ho8Ntker1nVSFp+HKYS4Rg73nxMZ6tOG51zNEhoIT9CGFuY7c7zSoI
         aeQBIPqJ6oe9WRX6ctk7W+QKjtUAY7wodoAXiVjKI1bQdlmY1k7SUQ8UQ+WCRPXetWdV
         DzNhoiaWjWzFjNeog59dXAcv9EcerCiR2djBVdggM6WRTqPcl9g3mgFET5VejIqMf1az
         gE8L0V1FEzLmKEyMhCcaRj777SuWWn9zN7PGDnk2038aiO+NQsnGFVcmheFI9jx2gqVf
         VGU69Fj/JTqVOi87fL4qvLoIBV/MGHzvaYlgBNDXcdQ5Yw57ewfQMzokza8rcNT2isHZ
         oduw==
X-Gm-Message-State: AOAM531NA4KeCkKsP5jGer8T+8SPHGD+5V2YMqqPvmEPOEHa7ZkGxvJ4
        /l2LK25eS7CBYFpHqJCzoec=
X-Google-Smtp-Source: ABdhPJx1RvMK2YcYKeH0ysEKQda6MxMT95puk4YslbfDfcCvL/omTghKrRgjBjRYwZjUsOKrjXu+gw==
X-Received: by 2002:a17:907:6e8e:: with SMTP id sh14mr32912010ejc.536.1637518470754;
        Sun, 21 Nov 2021 10:14:30 -0800 (PST)
Received: from skbuf ([188.25.163.189])
        by smtp.gmail.com with ESMTPSA id o8sm2939601edc.25.2021.11.21.10.14.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Nov 2021 10:14:30 -0800 (PST)
Date:   Sun, 21 Nov 2021 20:14:29 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan McDowell <noodles@earth.li>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Robert Marko <robert.marko@sartura.hr>
Subject: Re: [net PATCH 2/2] net: dsa: qca8k: fix MTU calculation
Message-ID: <20211121181429.jyelad2jbiebdtic@skbuf>
References: <20211119020350.32324-1-ansuelsmth@gmail.com>
 <20211119020350.32324-2-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211119020350.32324-2-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 19, 2021 at 03:03:50AM +0100, Ansuel Smith wrote:
> From: Robert Marko <robert.marko@sartura.hr>
> 
> qca8k has a global MTU, so its tracking the MTU per port to make sure
> that the largest MTU gets applied.
> Since it uses the frame size instead of MTU the driver MTU change function
> will then add the size of Ethernet header and checksum on top of MTU.
> 
> The driver currently populates the per port MTU size as Ethernet frame
> length + checksum which equals 1518.
> 
> The issue is that then MTU change function will go through all of the
> ports, find the largest MTU and apply the Ethernet header + checksum on
> top of it again, so for a desired MTU of 1500 you will end up with 1536.
> 
> This is obviously incorrect, so to correct it populate the per port struct
> MTU with just the MTU and not include the Ethernet header + checksum size
> as those will be added by the MTU change function.
> 
> Fixes: f58d2598cf70 ("net: dsa: qca8k: implement the port MTU callbacks")
> Signed-off-by: Robert Marko <robert.marko@sartura.hr>
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
