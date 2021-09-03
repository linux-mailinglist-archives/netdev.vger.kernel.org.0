Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12C924003D4
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 19:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350212AbhICRHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 13:07:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbhICRHs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 13:07:48 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30DE6C061575
        for <netdev@vger.kernel.org>; Fri,  3 Sep 2021 10:06:48 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id t19so13366955ejr.8
        for <netdev@vger.kernel.org>; Fri, 03 Sep 2021 10:06:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HOu/v3Ra8O/K9wAzVGGkkdCqDDE4ksGmT9ZXUBUzYGg=;
        b=KnmLsWaI7nAt7v0Ohft67cbHe0UVPbSk6NVAkQtIoaSlqGCtJnY4vj/Z5/d8DmdH0q
         PpG6iLDQ8zvWYgQnI9JZIv5XKojAav5TWwf1WipJLHY8sArciIOAv4RLPVfHm+XtPnYK
         zkM6eKMW2zUDpWjD2dGBSh55SNPzYTzry8Fnd4JsCA+i8RtHXC6DMRk3Bx9U9WVqoIz1
         NMKHMvFGebCB2hM6b4BcNAtXJuOE2NRw2M2sGNoDmQ8s8hOuuSf85sRB/gWiospKJ+oU
         nYf+uBSQDpbPhp4yihrbwTu62/KktDIt5h+15do+7BG5en9K+uJfvwV/sWKOVxCnfuTL
         TY/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HOu/v3Ra8O/K9wAzVGGkkdCqDDE4ksGmT9ZXUBUzYGg=;
        b=MAIkO49sx/vjNH/zns8QYBrLlRpi4f5mkC4hT8OSVBGuHIEZaVDb8YJ23TtzILHRH+
         gq+/bdhlpatDqLqO2FIGa72MGDovwQMuDgd7uFevhbOqknzGQ/juEiSKTgKgVj/tbqR7
         AyInEC3o/DRX3XcfwNWd9Hsu1Ji+a1x747nggnFtwVZ1I3n1lnExmZXpLl7AMQCs8Rlh
         EpvifCsTsLSnsncqOLoMt86OH8nJej389FWyQQivO9Ehb5TjrR3DTIsC3OMKkRZlzIIh
         Z0/Mqq7qNxtcacY8eWUXUl/jXJHZ7miG6NUdJmbP/dp0Ez1rfaep+WPYt4gb6dCGilWM
         U3xw==
X-Gm-Message-State: AOAM532HRS/kD9D8MQQApHdgMa+BasRnEh+fbO5Ildc8poxU2k7FO2P+
        AjPvExKHtaosEDkIunThwdc=
X-Google-Smtp-Source: ABdhPJzPnEbkASDevNel7TFli2FZVnwLYltOLsIxSrGReTUvtVmamE8eTtUuKExvTMbbAuvH1eZSfQ==
X-Received: by 2002:a17:906:919:: with SMTP id i25mr5225893ejd.171.1630688806742;
        Fri, 03 Sep 2021 10:06:46 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id rl23sm3124463ejb.50.2021.09.03.10.06.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Sep 2021 10:06:46 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
X-Google-Original-From: Ioana Ciornei <ciornei.ioana@gmail.com>
Date:   Fri, 3 Sep 2021 20:06:45 +0300
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Ioana Ciornei <ciorneiioana@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: dpaa2-mac: add support for more ethtool
 10G link modes
Message-ID: <20210903170645.pkejqmg2ayw3ijgr@skbuf>
References: <E1m5mVT-00032g-Km@rmk-PC.armlinux.org.uk>
 <YPbU59Kmpk0NvlQH@lunn.ch>
 <20210720141134.GT22278@shell.armlinux.org.uk>
 <20210816144752.vxliq642uipdsmdd@skbuf>
 <20210903103358.GU22278@shell.armlinux.org.uk>
 <20210903110916.bjjm6x3h4l4raf27@skbuf>
 <20210903113434.GV22278@shell.armlinux.org.uk>
 <YTIfCCzYK6RK1gYj@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YTIfCCzYK6RK1gYj@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 03, 2021 at 03:11:36PM +0200, Andrew Lunn wrote:

> > Thanks. I wonder why searching for it via google and also via patchworks
> > search facility didn't find it.
> > 
> > So, it got incorrectly tagged by netdev maintainers, presumably because
> > they're too quick to classify a patch while discussion on the patch was
> > still ongoing - and there's no way for those discussing that to ever
> > know without finding it in patchwork. Which is pretty much impossible
> > unless you know the patchwork URL format and message ID, and are
> > prepared to regularly poll the patchwork website.
> > 
> > The netdev process, as a patch submitter or reviewer, is really very
> > unfriendly.
> 
> H Russell, Ioana
> 
> It sounds like at LPC there is going to be a time slot to talk about
> netdev processes.

Is this on the Networking track? I didn't find any session that would
appear to target this topic.

> I would like to find out and discuss the new policy
> for the time it takes to merge patches. Patchwork issues, and the lack
> of integration with email workflows could be another interesting topic
> to discuss.

It would be interesting to have patchwork send a notification of some
sorts to the submitter when a certain patch set's state was changed.

Ioana
