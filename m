Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A11546D62A
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 15:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbhLHO5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 09:57:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbhLHO5Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 09:57:24 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB46BC061746;
        Wed,  8 Dec 2021 06:53:52 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id r11so9092313edd.9;
        Wed, 08 Dec 2021 06:53:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sTcURiIQ8RnWwJ1LvErUaG9rDDP1ZDMbGbFVTr/q3W8=;
        b=B1BzV0+ygHi3gibMFqpJqSzi6/lPAuO6BleXaiwaUwpF3f2d3qla5J7EL3Wiy0ZDr3
         Nuu4MiZ4OeFcROFWMD/gyeDNsQRaQUAp8zy8FwpmAfom+Tk09NW5X/Hqhi21yVNJD92b
         zEtNtK16HpxlwVSR2nCI/Jf9prIyMRq56BidyBKwC7VvahCTMsXcaApxUrEfio0goHgE
         Sk9QpceRv8qnH/1NcigD37ovjAlSsKisI1Sz83khPGK0zAdVwGAxbmFRP8CNDSuJH8W+
         GfsWfJE2cdJvLE2pRJxWLGbNK8NaADuojKGpMVBl2EmCvwR4S9lBCGduQwzVW8US1QLU
         L8Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sTcURiIQ8RnWwJ1LvErUaG9rDDP1ZDMbGbFVTr/q3W8=;
        b=g3CN+AimTuDtzXE+kcuRFwRmsEa8kdGKc6uHuaFNe3csKqzvFy2V4K9jJFCSpcyX4h
         m6xVh4ALVbZCLHFqeMl+UO173uZ6z2C10RVA4Tt3hom6nSrtGQ+0HUAgGSS4uS39dZMC
         dfXVU6VgmZVgNTla2FoUTel/TYUTAfj8RR/+LCUqeHSupDH86dIDlYLXkhQQRc3ufdmE
         GOOVg+Aa34jQ3LOoQSYqf9HJmmYIEg88FaGz0E1PIbxcXH3WUguz52pvKuq3ecBLN40M
         zwOijZmz510szNm9m6SRLJXBUIWcINUgwA5FIimJgHWcaV3Gld/q8gFADAdBCrHvhig/
         aHvA==
X-Gm-Message-State: AOAM533EpTjONp0Bg95bvS6lFbxEHidiHnzt9PiUj70xXuj/fHxcO3FU
        3cnMXArjsJJDmFMRS0/jIhM=
X-Google-Smtp-Source: ABdhPJxt1VvSgndQf2skuU/RFOIXZd3WIAImB9sf1ag7POEUesUB7b0ENtobFGD6UGy5g4yHVsF68g==
X-Received: by 2002:a17:906:58d5:: with SMTP id e21mr8140684ejs.540.1638975223528;
        Wed, 08 Dec 2021 06:53:43 -0800 (PST)
Received: from skbuf ([188.25.173.50])
        by smtp.gmail.com with ESMTPSA id i8sm2557243edc.12.2021.12.08.06.53.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 06:53:43 -0800 (PST)
Date:   Wed, 8 Dec 2021 16:53:41 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next RFC PATCH v2 0/8] Add support for qca8k mdio rw in
 Ethernet packet
Message-ID: <20211208145341.degqvm23bxc3vo7z@skbuf>
References: <20211208034040.14457-1-ansuelsmth@gmail.com>
 <20211208123222.pcljtugpq5clikhq@skbuf>
 <61b0c239.1c69fb81.9dfd0.5dc2@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61b0c239.1c69fb81.9dfd0.5dc2@mx.google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 08, 2021 at 03:33:27PM +0100, Ansuel Smith wrote:
> > But there are some problems with offering a "master_going_up/master_going_down"
> > set of callbacks. Specifically, we could easily hook into the NETDEV_PRE_UP/
> > NETDEV_GOING_DOWN netdev notifiers and transform these into DSA switch
> > API calls. The goal would be for the qca8k tagger to mark the
> > Ethernet-based register access method as available/unavailable, and in
> > the regmap implementation, to use that or the other. DSA would then also
> > be responsible for calling "master_going_up" when the switch ports and
> > master are sufficiently initialized that traffic should be possible.
> > But that first "master_going_up" notification is in fact the most
> > problematic one, because we may not receive a NETDEV_PRE_UP event,
> > because the DSA master may already be up when we probe our switch tree.
> > This would be a bit finicky to get right. We may, for instance, hold
> > rtnl_lock for the entirety of dsa_tree_setup_master(). This will block
> > potentially concurrent netdevice notifiers handled by dsa_slave_nb.
> > And while holding rtnl_lock() and immediately after each dsa_master_setup(),
> > we may check whether master->flags & IFF_UP is true, and if it is,
> > synthesize a call to ds->ops->master_going_up(). We also need to do the
> > reverse in dsa_tree_teardown_master().
> 
> Should we care about holding the lock for that much time? Will do some
> test hoping the IFF_UP is sufficient to make the Ethernet mdio work.

I'm certainly not smart enough to optimize things, so I'd rather hold
the rtnl_lock for as long as I'm comfortable is enough to avoid races.
The reason why we must hold rtnl_lock is because during
dsa_master_setup(), the value of netdev_uses_dsa(dp->master) changes
from false to true.
The idea is that if IFF_UP isn't set right now, no problem, release the
lock and we'll catch the NETDEV_UP notifier when that will appear.
But we want to
(a) replay the master up state if it was already up while it wasn't a
    DSA master
(b) avoid a potential race where the master does go up, we receive that
    notification, but netdev_uses_dsa() doesn't yet return true for it.

The model would be similar to what we have for the NETDEV_GOING_DOWN
handler.

Please wait for me to finish the sja1105 conversion. There are some
issues I've noticed in your connect/disconnect implementation that I
haven't had a chance to comment on, yet. I've tested ocelot-8021q plus
the tagging protocol change and these appear fine.
I'd like to post the changes I have, to make sure that what works for me
works for you, and what works for you works for me. I may also have some
patches laying around that track the master up/down state (I needed
those for some RFC DSA master change patches). I'll build a mini patch
series and post it soon-ish.
