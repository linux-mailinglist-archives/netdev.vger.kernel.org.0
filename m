Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0C3232B3C5
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:22:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1576692AbhCCEGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:06:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381237AbhCBTmN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 14:42:13 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 102E0C06121F;
        Tue,  2 Mar 2021 08:11:44 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id mm21so35972845ejb.12;
        Tue, 02 Mar 2021 08:11:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cimOH74ExOm9n45WQhr2uwq67qtoQ7z880rvlczqwuo=;
        b=lia4ZT8TqvrwoMgkKSX2e6p/voNPp4KfheU9My7YSyJu+O0vf/lx6oeOB5vWSztukm
         lW2fWp87EdzWpntwmu1+89J5j9Z3f8Onj787Jxn5Ii7wHzf0VpTGhhwPl454uK1O6Bjv
         7KdxQocMnc7bcPuExxpeI4YVxuobUuPprW9/9aVbEc8NrLm+07ARj+HgiVDj9Zi39Dco
         DN+guwJTa5ufvMYqg3OgqjigwgfP6Wfvk/YNS7HZjM3/CRk//1gQf5PKVvOUQAGpLHqZ
         Hsb7XLHmgvkGN9Yg6eAMndxIgjeZEKCAy0f8EtVURCYgmpNFCBg43QLoGDO4GpKmU1hh
         BJfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cimOH74ExOm9n45WQhr2uwq67qtoQ7z880rvlczqwuo=;
        b=SQToOhi7Cl2D5/dCeVVIkVDH8LvhBuIeYd/MZbEDwsOpZqbo4mF9NjyzUOcUGUzsRY
         5KohYiEbyz8UMobeNGMeQdiGLMyzIcHzGdt/GyxTStDDBRb/4nB3l4PCJ7kfPDYK3dTO
         eM2X3/P87E/oYNTMqZurH+SIxhfo6ED5+qNIEO8wezLKWvuf/+dhjeykiPUCMA7rYoK7
         l2SYaJfn2xRT2vqEhIBgYfv3UyidtWQaC+UeM8vbkwXyUa0+9D6Xh6m/UExJuGDFDDDH
         JoSazjJB/ulVKSPxdjTwo3hImvYQQfJMQNkzL1YuZdSoWslCYgiMKjr/NgIHBwWFlo5d
         b3yA==
X-Gm-Message-State: AOAM531xPGmwl19braqoaZQrL798QJCSYB7LxfHzWCHCFaXdzaca3I10
        fKQAcFe1iqqDy1UCTbr7n4M=
X-Google-Smtp-Source: ABdhPJxBEHbIAr9oL6dyFLIaky9rTvZwAzmWifVZVvQpbPSK5A4ogtHIa5jmErDB3J/6JfqMld8AlQ==
X-Received: by 2002:a17:906:71d3:: with SMTP id i19mr1210810ejk.347.1614701502805;
        Tue, 02 Mar 2021 08:11:42 -0800 (PST)
Received: from skbuf ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id q11sm17924852ejr.36.2021.03.02.08.11.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Mar 2021 08:11:42 -0800 (PST)
Date:   Tue, 2 Mar 2021 18:11:40 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC net-next] net: dsa: rtl8366rb: support bridge offloading
Message-ID: <20210302161140.l3jtvkcm3tvlv5q3@skbuf>
References: <20210224061205.23270-1-dqfext@gmail.com>
 <CACRpkdZykWgxM7Ge40gpMBaVUoa7WqJrOugrvSpm2Lc52hHC8w@mail.gmail.com>
 <CALW65jYRaUHX7JBWbQa+y83_3KBStaMK1-_2Zj25v9isFKCLpQ@mail.gmail.com>
 <CACRpkdZW1oWx-gnRO7gBuOM9dO23r+iifQRm1-M8z4Ms8En9cw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdZW1oWx-gnRO7gBuOM9dO23r+iifQRm1-M8z4Ms8En9cw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 02, 2021 at 05:05:00PM +0100, Linus Walleij wrote:
> On Tue, Mar 2, 2021 at 4:58 AM DENG Qingfang <dqfext@gmail.com> wrote:
> > On Mon, Mar 1, 2021 at 9:48 PM Linus Walleij <linus.walleij@linaro.org> wrote:
> > > With my minor changes:
> > > Tested-by: Linus Walleij <linus.walleij@linaro.org>
> >
> > How about using a mutex lock in port_bridge_{join,leave} ?
> > In my opinion all functions that access multiple registers should be
> > synchronized.
> 
> That's one way, in some cases the framework (DSA) serialize
> the accesses so I don't know if that already happens on a
> higher level? Since it is accessed over a slow bus we should go
> for mutex in that case indeed.

DSA does not serialize this. The .port_bridge_join and
.port_bridge_leave calls are initiated from the NETDEV_CHANGEUPPER net
device event, which is called under rtnl_mutex (see call_netdevice_notifiers).
This is pretty fundamental and I don't think it will ever change.

However, if you still want to add an extra layer of locking (with code
paths that for some reason are not under the rtnl_mutex), then go ahead,
I suppose. It will be challenging to make sure they do something that
isn't snake oil, though.
