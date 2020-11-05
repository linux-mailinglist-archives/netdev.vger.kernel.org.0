Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B13752A73A5
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 01:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732782AbgKEAKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 19:10:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728323AbgKEAKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 19:10:12 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A15DDC0613CF;
        Wed,  4 Nov 2020 16:10:11 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id w1so69058edv.11;
        Wed, 04 Nov 2020 16:10:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=o/8C8k1t0TWfRGW1aAodiDnrx3NIiE1zgqhYrFNKl4U=;
        b=o3SF3etiTvGwlgXr1ALr9N4WVhf8/QsPZelVEv3lF/j2NC5oCPiqI9/4mA4HhiFT72
         BklJGFs7kfoQoH3Iz+1ImbleTvtWtU02qDTiMYvwVi3xmyo3BVVDcvka86PcWSAMw/dQ
         cBcnWbHxc5MFWFkTvmTemgUkNfb2m63f4v8Za1/lVSN+MCdrMR1vUtmRnFN92HSL5qpo
         ZJ/rhvdzSn9xc+6ftrLRWVMr59aO/S8XSA6LmjwMBJSL8ioesEPCvfUuvaoyS9INnW5R
         xdyFCluDMbwQpJPw9RTID+z+N/qSedmX/kGdghURFavU7h07K0oLT5BXJuyNGw2aonYl
         K9iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=o/8C8k1t0TWfRGW1aAodiDnrx3NIiE1zgqhYrFNKl4U=;
        b=h65sKPcU7kgpSQ+Q6MS4dRnC5VU8WElC2OpnkwR+4cMyO9o39O7jNA0tq+L6xpeYsu
         0oPZirBdXw3Zjid4+cZTmk6NQurLNz1syj+a8wuTMfnn7cc2TLRFAG7QsBsdhJVHu0Zl
         aQi1k0cdsEqahOFjGWHDPqVGBHPzjCgtaWfmRZEH2OPDi1Lay8z3tjxJy8FXriWzZChE
         visLKf20oGFCxW1Q1gtuz9MFKTOtou+m75Y87IbTAp4mBHdEiLZn1LYgiZlLJPR2MJyT
         n87JduHrwoUBxzrg5pCmF0gQQHH43R7eS/8EVXPvC4JHvzHUriC/rD1x3w6NmDcAPWSR
         DHTw==
X-Gm-Message-State: AOAM532tqvl0PR4PKwLcVyAzpwXueF2R2AOviGYVtzw4RW3v65JX4HKQ
        jC36l9iMD2gFPJZWe7WkTApCftc9J5w=
X-Google-Smtp-Source: ABdhPJxDuVzHQ+7B7tBkA6qPNbqi77Ig+C1ocU6qYXrsgGgvT50f3KHVgoL4/9iN393LsSZ1c4uHMA==
X-Received: by 2002:aa7:c90d:: with SMTP id b13mr389808edt.136.1604535010422;
        Wed, 04 Nov 2020 16:10:10 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id l16sm4767ejd.70.2020.11.04.16.10.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 16:10:09 -0800 (PST)
Date:   Thu, 5 Nov 2020 02:10:08 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [PATCH net-next v2 06/19] net: phy: mscc: use
 phy_trigger_machine() to notify link change
Message-ID: <20201105001008.ze37olgnu5lisyie@skbuf>
References: <20201101125114.1316879-1-ciorneiioana@gmail.com>
 <20201101125114.1316879-7-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201101125114.1316879-7-ciorneiioana@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 01, 2020 at 02:51:01PM +0200, Ioana Ciornei wrote:
> From: Ioana Ciornei <ioana.ciornei@nxp.com>
> 
> According to the comment describing the phy_mac_interrupt() function, it
> it intended to be used by MAC drivers which have noticed a link change
> thus its use in the mscc PHY driver is improper and, most probably, was
> added just because phy_trigger_machine() was not exported.
> Now that we have acces to trigger the link state machine, use directly
> the phy_trigger_machine() function to notify a link change detected by
> the PHY driver.
> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> ---

Tested-by: Vladimir Oltean <olteanv@gmail.com>
