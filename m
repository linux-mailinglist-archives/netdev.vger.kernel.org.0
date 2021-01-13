Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1E622F5714
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 02:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728858AbhANB6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 20:58:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729544AbhAMXkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 18:40:14 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6873EC061384;
        Wed, 13 Jan 2021 15:39:32 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id g1so3163169edu.4;
        Wed, 13 Jan 2021 15:39:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=egYNssqgRcswRNH1skLRAUiu45TpWsk2pFXggn83jwE=;
        b=Fg69qKV9CXscWnFSBov/if1L+293kc8tZiDS2z52GAiM12z0BmWMIuRH2H8e5dJsy1
         p4xAq0flJxSG2EbB3gSIwC8Awwrez7ElCZlJNqVGUjDfmhMxBvp+f0Ukp1Atgrk4gIrJ
         31tU6hcgWhFN+9EJUS5kuO8fF9W4PhW22fVvFbUeRvBDOa1YPGPLjiD7LX+CbeXpk/Uo
         x/fpSTVWkXfe9TvHGv8bjtOBzgQ3dSOVKc+D+w8FOUxegBficrXTyJZuNBiG0mVeMQ3D
         bGIteWnemF9bhRw0A/RTNIP5hoh4fDWsV+upwP7wjrztQ40EUr+0kUlQ9WrDR1xi9oaZ
         VJsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=egYNssqgRcswRNH1skLRAUiu45TpWsk2pFXggn83jwE=;
        b=QnMuotsRaup20J9fpiQd6uBWsTQZf3cXu+tvt4Yl9Yzt02qb0iDGH7rZkoqFTAS93p
         mxBV6bmXs6+9/+SrJ9GtvCTQfrTHofIh/u2jZFRwCOf5WwCTP3ninaXQh/OuGdXFl56y
         ky70Jh6mo5Uw23t8EDDGeHOXtLDlKDXoD0OTbc04E34TsV5Ri6jLQRAeIxK+BPa9HSX2
         qvm6BgJJDcYtmQ2dJuOaqiA6Agb8tzXckijE7Dq4VdKXoGfdY7ze/4/KLhJGNdpi7tsz
         MUMVqGRdB9hVkusH5oXkrgR8M7kYPPCqb3acJmxIv1SAxtiwMAk0cswwBWh6KEot2clC
         rvBg==
X-Gm-Message-State: AOAM532aQBQYY3J6yXryw+LkZerGkdiLxofpw/RUarNiB+L+FzkKjFsH
        v7S/L1ga4eF37HsoFczY5Jc=
X-Google-Smtp-Source: ABdhPJwZK5/5TpMS09kO8Vtl6Wm+PGYmP4pVR/uFaCgIGeS1CxYMwywulHGAyLI/f2Q3BA1kFBOfig==
X-Received: by 2002:a50:ccc3:: with SMTP id b3mr3086356edj.41.1610581169645;
        Wed, 13 Jan 2021 15:39:29 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id i15sm1281269ejj.28.2021.01.13.15.39.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 15:39:28 -0800 (PST)
Date:   Thu, 14 Jan 2021 01:39:27 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Gilles DOFFE <gilles.doffe@savoirfairelinux.com>
Cc:     netdev@vger.kernel.org, Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 6/6] net: dsa: ksz: fix wrong read cast to u64
Message-ID: <20210113233927.njnrwuduo77bbma2@skbuf>
References: <cover.1610540603.git.gilles.doffe@savoirfairelinux.com>
 <28e0730f2bdac275384fac85c4a342fb91f9455f.1610540603.git.gilles.doffe@savoirfairelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28e0730f2bdac275384fac85c4a342fb91f9455f.1610540603.git.gilles.doffe@savoirfairelinux.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 01:45:22PM +0100, Gilles DOFFE wrote:
> '(u64)*value' casts a u32 to a u64. So depending on endianness,
> LSB or MSB is lost.
> The pointer needs to be cast to read the full u64:
> '*((u64 *)value)'
> 
> Signed-off-by: Gilles DOFFE <gilles.doffe@savoirfairelinux.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
