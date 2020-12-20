Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 288982DF461
	for <lists+netdev@lfdr.de>; Sun, 20 Dec 2020 09:08:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727262AbgLTIGj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Dec 2020 03:06:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726696AbgLTIGj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Dec 2020 03:06:39 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54F5AC0613CF;
        Sun, 20 Dec 2020 00:05:58 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id g20so9273405ejb.1;
        Sun, 20 Dec 2020 00:05:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=877C8AVqjHKt77VYGcchG1ePZwRG53cwgcE+oR4LK7w=;
        b=CzH1zD7ufC530iXBCdTSQZW8gQqFpDNbCJ6wgkZyJBssbN5CldUlVIAOXi8P0RvhRv
         59zl21T16Ah6FqT+2h6eSdv5tpNlSqHWQ48pnDseAMiOiiwPfSma00AvKq2I7GiL3pxL
         mp9E6leksJMEyv/DNLv3elCfVr6hcOin1oewezdnIAyZuuR0YY72kAQXmtnVqQR6hY07
         VK38yKSVK78eOmQO1oX29lZyxUazD7NPbImc/7QYdqnEjLz1pM2YzOlTtC/RvcmceSNw
         25x4MvHWMXLcWNmuMp3VwMZHoLAkMPUxO6+f6yyyFKeH7jKojDEYwF7XkHSgA5/hHKaE
         pXAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=877C8AVqjHKt77VYGcchG1ePZwRG53cwgcE+oR4LK7w=;
        b=sAss1jbcV6e3MHFkwHgwGnDUU1K5VkrfB7jnQgSdQuujbO4QL18oKu28N0vwBaBlwU
         aKE5Gu1XijVvaEnrBhQjWPlb7jFZZ2Dopg9yQkOVlx6brc+7MrWCAUydcVurA4KaDAYb
         2PB3E8jhlrdkx4RGaqy+E6bee97M57xzvX+FphdQLE9Mv5BsccDY4WNpMGIl/U9h9cYO
         lQkrPeNhZs16JKLimDClKGgcPFe22pEltgCqOeCia+cwKjyDSp9EGbLjNYHBMEVO57a9
         JtGI1Wscm8Mpg30tciNvJf2oa7z/v1LspSFaLiyk/+GfXxNxhU75zs6OhZCxto9zyejB
         oJTg==
X-Gm-Message-State: AOAM531p+z0ZYQJ4WN1+YeWKNrG1OK11pKUl687NXTe22loFgw9MSYjb
        EG0wtBMvHLYFy9lYWrIxO9Y=
X-Google-Smtp-Source: ABdhPJynVMZurDmNSLenosgb8bMP8vdQ10DonTxTAGAoNGqz/N57p65eFrgSPRBf8uOb3zTFquW+sg==
X-Received: by 2002:a17:906:4a47:: with SMTP id a7mr11035401ejv.345.1608451556949;
        Sun, 20 Dec 2020 00:05:56 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id cb21sm27615807edb.57.2020.12.20.00.05.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Dec 2020 00:05:56 -0800 (PST)
Date:   Sun, 20 Dec 2020 10:05:55 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Zhao Qiang <qiang.zhao@nxp.com>, Li Yang <leoyang.li@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net v2 1/3] ethernet: ucc_geth: set dev->max_mtu to 1518
Message-ID: <20201220080555.tgv3ndlkhzbvcpx7@skbuf>
References: <20201218105538.30563-1-rasmus.villemoes@prevas.dk>
 <20201218105538.30563-2-rasmus.villemoes@prevas.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201218105538.30563-2-rasmus.villemoes@prevas.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 18, 2020 at 11:55:36AM +0100, Rasmus Villemoes wrote:
> All the buffers and registers are already set up appropriately for an
> MTU slightly above 1500, so we just need to expose this to the
> networking stack. AFAICT, there's no need to implement .ndo_change_mtu
> when the receive buffers are always set up to support the max_mtu.
> 
> This fixes several warnings during boot on our mpc8309-board with an
> embedded mv88e6250 switch:
> 
> mv88e6085 mdio@e0102120:10: nonfatal error -34 setting MTU 1500 on port 0
> ...
> mv88e6085 mdio@e0102120:10: nonfatal error -34 setting MTU 1500 on port 4
> ucc_geth e0102000.ethernet eth1: error -22 setting MTU to 1504 to include DSA overhead
> 
> The last line explains what the DSA stack tries to do: achieving an MTU
> of 1500 on-the-wire requires that the master netdevice connected to
> the CPU port supports an MTU of 1500+the tagging overhead.
> 
> Fixes: bfcb813203e6 ("net: dsa: configure the MTU for switch ports")
> Cc: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
