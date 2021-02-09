Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61F123154D4
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 18:18:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233159AbhBIRPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 12:15:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233141AbhBIROu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 12:14:50 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E87EC061574
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 09:14:09 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id jj19so32958198ejc.4
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 09:14:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Z2bJK9dOsVsQJoD1vE3mMFOxuCi7fyUImg+jWuKN6W0=;
        b=QL/CN6AJI2y/ujDBIkWdhaXfzipSU0Y4/LCgFENxcabOBDDD5UFVgsx2oYAe8gB8ae
         3QBEkB4+tZaUdgRCUhtgkcKrV3NZ1iLB3/9DBj6ch7JTou3PdpLpvlwx1rjllL3LupIX
         3Gk/qPFufOWnc4wG2a/YVonEdOSJZYrZOAVjuAupGL48BWgyHwxUOcxnyCxNV5S0m4Ww
         i/efwL4Gnpvwz5CFsKHt3eYgVzC3zDRH1oKrWBaei+T2WX2d0eQ1O42YFEDkefLfjqSh
         9bTtP9pJ9rQGWVD7ige28FPWi6cpocfn7r16Ez/l1Afv9jpNimbZ1gjzo2wUYXM+ZFFd
         nSKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Z2bJK9dOsVsQJoD1vE3mMFOxuCi7fyUImg+jWuKN6W0=;
        b=uR0YVceCNShOztgouj1E9Go+uYMx8dgwad7wbcHIh4gzF/djBFtB+px5orGVmFIbSi
         lVVKHdqi+bQaaGg4GB9iqe31Epu47JinnBT4HN8YlqZHdNAuREwHGHuyB7ONAGCJEPa8
         46lHvY+8hksyxq7OyDfd8Wz787U0WtsE2nZizV8C4CFc6Ar6CA1fWkaBifoKFIrg38yL
         xhUs4fB9+bNXuMfGe2zRQnDPdYUkf9PhPmWC5jB9aB0KKVaOlBEFK5mZ+lGJB6fts41h
         6TtgNW1Y08Mxkqz/TZg33qgUcngGV1HYCHu3TXO7nGYyr3zmwIA9uCXE9+xcIk4Q3oxt
         Q4ww==
X-Gm-Message-State: AOAM530GT4Zj8qb1+8TaqVduCuIPQPBknH0JUaoTlqCBV1OpwJ3Gal05
        uvrZt8Lw4Cp9OVQGQBCENIE=
X-Google-Smtp-Source: ABdhPJwLdmgnrRmGhH6ZNZs/Q2/RfT6IX5jLxQCRe+yW++O+J1TgnCgiEXAMIlkU89Y/dZcqyCUUHg==
X-Received: by 2002:a17:906:4707:: with SMTP id y7mr23157812ejq.445.1612890848369;
        Tue, 09 Feb 2021 09:14:08 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id a9sm12036754edk.22.2021.02.09.09.14.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 09:14:07 -0800 (PST)
Date:   Tue, 9 Feb 2021 19:14:06 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/4] add HSR offloading support for DSA
 switches
Message-ID: <20210209171406.ce35de7dxnjsfmpk@skbuf>
References: <20210204215926.64377-1-george.mccollister@gmail.com>
 <87sg6648nw.fsf@waldekranz.com>
 <CAFSKS=OO8oi=757b9DqOMpS4X6jqf5rg+X=GO8G-hOQ+S7LaKQ@mail.gmail.com>
 <87k0rh487y.fsf@waldekranz.com>
 <CAFSKS=NQN-OaQwYT8Crev33mUON3+6zYCss_nHoCD2gOzeYWTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFSKS=NQN-OaQwYT8Crev33mUON3+6zYCss_nHoCD2gOzeYWTw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 09, 2021 at 11:04:08AM -0600, George McCollister wrote:
> > >> In the DSA layer (dsa_slave_changeupper), could we merge the two HSR
> > >> join/leave calls somehow? My guess is all drivers are going to end up
> > >> having to do the same dance of deferring configuration until both ports
> > >> are known.
> > >
> > > Describe what you mean a bit more. Do you mean join and leave should
> > > each only be called once with both hsr ports being passed in?
> >
> > Exactly. Maybe we could use `netdev_for_each_lower_dev` to figure out if
> > the other port has already been switched over to the new upper or
> > something. I find it hard to believe that there is any hardware out
> > there that can do something useful with a single HSR/PRP port anyway.
>
> If one port failed maybe it would still be useful to join one port if
> the switch supported it? Maybe this couldn't ever happen anyway due
> the way hsr is designed.
>
> How were you thinking this would work? Would it just not use
> dsa_port_notify() and call a switch op directly after the second
> port's dsa_slave_changeupper() call? Or would we instead keep port
> notifiers and calls to dsa_switch_hsr_join for each port and just make
> dsa_switch_hsr_join() not call the switch op to create the HSR until
> the second port called it? I'm not all that familiar with how these
> dsa notifiers work and would prefer to stick with using a similar
> mechanism to the bridge and lag support. It would be nice to get some
> feedback from the DSA maintainers on how they would prefer it to work
> if they indeed had a preference at all.

Even though I understand where this is coming from, I have grown to
dislike overengineered solutions. DSA is there to standardize how an
Ethernet-connected switch interacts with the network stack, not to be
the middle man that tries to offer a lending hand everywhere.
If there is a 50/50 chance that this extra logic in the DSA mid layer
will not be needed for the second switch that offloads HSR/PRP, then I'd
go with "don't do it". Just emit a hsr_join for both ports and let the
driver deal with it.
