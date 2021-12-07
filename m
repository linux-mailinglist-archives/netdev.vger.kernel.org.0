Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A79A46C3E0
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 20:44:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236417AbhLGTsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 14:48:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbhLGTsH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 14:48:07 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C977BC061574;
        Tue,  7 Dec 2021 11:44:36 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id v1so319661edx.2;
        Tue, 07 Dec 2021 11:44:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=Zq+yuFXqBJlvxepwYYo56GAdIfTptGEXaFm/n42pn8I=;
        b=WEK9i3bpZ/09USMxoUrHk/BjgYrKvAkCaLdu3AqUuTNEhXctqHdWLE9pQB3viOJLVJ
         3vD0Oa1O3UsjScKragWu9/TvDvA53Qj5kw9G9uMw2DpFIuF26Lj/IEkPlKq3+SjU7o40
         mgSPeyxPoHa+MMYDw/LNwl8eGPH+ISCt2HLCn3CxeXHZT9KfWehdLLEEquMRJZzS8f1W
         moi+r/X+NBHWJBJNQot5rxh/d37cES5yvpXRf/VFcQxdXbIz0/Vre9N5mh8NmOcjbEmh
         FCgtRxAIeAgQS+c71pw8QPml3BB62Fgo8S0mEXIg7wExcMxKIBMjWyx6isSrDgQek1n1
         v5rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=Zq+yuFXqBJlvxepwYYo56GAdIfTptGEXaFm/n42pn8I=;
        b=oko9pTQT5Tu1gY7lPriGet5/1Fh4xnUK46AbSFYvqQVMWH5Dj0skFFtQ/rpad/5Tkq
         J8sthvPpFyB4hDuQoTOtEiXASbnq/K/C5aFMp2KbIS1YIeKVJQAblSj2MSo3ytxrwVaU
         XifWPMpkCNqtpHP51mj0JoVILf59EO0P757rZ7LePKfucWDLNemkdUMdpwo5rYw6WeiE
         E/sHsR9+gk7cgXviAqLnAMXtOyTpt9S0c7zf862KwOG2agbxGKcOPksxRhbOjiZ+AMmk
         L3Xu0DHHcuhHbi0+N+ST7YamETforVTBiXtaN7X/MuOvpg/Sp5g3tqnXCcf+4hJXSDiu
         sUKg==
X-Gm-Message-State: AOAM531fFRhxIUFvEGEoyM+1S9vUc+M2gefSNR5NLrNGMbc1KvwWMCQK
        4s/08NRh4LEf4XRGzxnOl5c=
X-Google-Smtp-Source: ABdhPJwolB7x9GJ7FBrEtYLJhh9UWKwDgDYpPDHNrbkX+WX123qoEEgijRamE5Uu/MLqNEjUixEQTA==
X-Received: by 2002:aa7:dd56:: with SMTP id o22mr12170424edw.73.1638906275189;
        Tue, 07 Dec 2021 11:44:35 -0800 (PST)
Received: from Ansuel-xps. (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id 29sm477879edw.42.2021.12.07.11.44.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 11:44:34 -0800 (PST)
Message-ID: <61afb9a2.1c69fb81.9a5d0.1f85@mx.google.com>
X-Google-Original-Message-ID: <Ya+5ofCDyUR6Szf7@Ansuel-xps.>
Date:   Tue, 7 Dec 2021 20:44:33 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next RFC PATCH 0/6] Add support for qca8k mdio rw in
 Ethernet packet
References: <20211207145942.7444-1-ansuelsmth@gmail.com>
 <Ya96pwC1KKZDO9et@lunn.ch>
 <77203cb2-ba90-ff01-5940-2e9b599f648f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77203cb2-ba90-ff01-5940-2e9b599f648f@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 07, 2021 at 10:49:43AM -0800, Florian Fainelli wrote:
> On 12/7/21 7:15 AM, Andrew Lunn wrote:
> > On Tue, Dec 07, 2021 at 03:59:36PM +0100, Ansuel Smith wrote:
> >> Hi, this is still WIP and currently has some problem but I would love if
> >> someone can give this a superficial review and answer to some problem
> >> with this.
> >>
> >> The main reason for this is that we notice some routing problem in the
> >> switch and it seems assisted learning is needed. Considering mdio is
> >> quite slow due to the indirect write using this Ethernet alternative way
> >> seems to be quicker.
> >>
> >> The qca8k switch supports a special way to pass mdio read/write request
> >> using specially crafted Ethernet packet.
> > 
> > Oh! Cool! Marvell has this as well, and i suspect a few others. It is
> > something i've wanted to work on for a long long time, but never had
> > the opportunity.
> > 
> > This also means that, even if you are focusing on qca8k, please try to
> > think what could be generic, and what should specific to the
> > qca8k. The idea of sending an Ethernet frame and sometime later
> > receiving a reply should be generic and usable for other DSA
> > drivers. The contents of those frames needs to be driver specific.
> > How we hook this into MDIO might also be generic, maybe.
> > 
> > I will look at your questions later, but soon.
> 
> There was a priori attempt from Vivien to add support for mv88e6xxx over
> RMU frames:
> 
> https://www.mail-archive.com/netdev@vger.kernel.org/msg298317.html
> 
> This gets interesting because the switch's control path moves from MDIO
> to Ethernet and there is not really an "ethernet bus" though we could
> certainly come up with one. We have mdio-i2c, so maybe we should have
> mdio-ethernet?
> -- 
> Florian

I checked that series and I notice that the proposed implementation used
a workqueue. The current implementation here use completion and mutex so
the transaction is really one command at time and wait for response.
Considering most of the time we do read and write operation is seems a
bit overkill to use a queue... Also to track the response.
Using a single queue simplify the implementation and should be just
good. (btw qca8k supports a way to queue packet using a seq int but we
don't use it to keep things simple)

Is that acceptable? Also I notice in that series mru have some
limitation and can be used only for some kind of data...
Should we add a way to blacklist some particular reg and use the legacy
mdio way?

-- 
	Ansuel
