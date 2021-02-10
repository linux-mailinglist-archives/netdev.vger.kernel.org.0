Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C9943172BB
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 22:56:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232045AbhBJV4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 16:56:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbhBJV4K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 16:56:10 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45C35C061574
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 13:55:27 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id y8so4815806ede.6
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 13:55:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GBNBcdT443ukh52Q9IStW7hcUFfI3CDecQ9vgpmYeJg=;
        b=sWfqegTUrgA9E7l6zPnpQEEG2jT7ZlUtdT3QKzYBPIpIQ+V6hWrFU7iMenDtGm0ru2
         VeZoH0WNX8ryJBSo8KsoCV+5toVVWt8SMO+Wgky3uPl1pkCrKIlStLufeMep/hGT0tCD
         zaF6SlMRz5yMhyO/uIZrNOwv4Y4CPMFeC1T1H6/dbrhsqjFz+Evy1JJ//VOy8caeI3wm
         rObJwBT/gjAjjqSMgEVbuoR7YGubj5bAXskRZBfUW5zKgmxTzbWcXQe956ZIjYsLFZLV
         p/fOfr7O1F3ykUCFM/hLY/Ris2sUcwYXRzCbrev+q/1kB9+Gnow4JK+E8L8ZUQ+sdUew
         t+Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GBNBcdT443ukh52Q9IStW7hcUFfI3CDecQ9vgpmYeJg=;
        b=cJQcDCgGBv+FmIihL+wPs9KrM1qL4aqRkQ9BH7UJbglDHbsvjB2bJxqevJedmysrgB
         A4/qs/PlRJFkEaFnEMkmvMXQCBKzLul1SNoxxLje1UYyc09/pEYw7/aNq7wW1Ut5PsPd
         farQsAJI2HDIK4xZUWKlGh3GXsbaR5x0KlEanMTH16YqffkL5wPSloN7SZXWxDS6uSQj
         KBES3sePB+w1B5SV3wnImqnYfmiShqQciv3rN+KonHToFlUyXyZhr82QeaUN8rjpKJ5X
         drnL2OHeiR+YeghfqGIp2ma4splhKCRS4btM7VaSRVjEUKzrusNtbLotV/zSP++HKuzN
         ssmA==
X-Gm-Message-State: AOAM530elsu19tc1AUhVSDC6PVdifr/wO6xTklgsHWhXW/RwBXyp/mkF
        HWZ1qR1gBfE5CK1rC5kOGbs=
X-Google-Smtp-Source: ABdhPJwVd7iOHhEzCUsHaQ47Mn2KNPZ639DzwqlfPRx3wDyedsDxjYKEMfZKycmvdpjBq0VQJQSLgg==
X-Received: by 2002:a50:e04d:: with SMTP id g13mr5259446edl.358.1612994126028;
        Wed, 10 Feb 2021 13:55:26 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id bo12sm2260588ejb.93.2021.02.10.13.55.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 13:55:25 -0800 (PST)
Date:   Wed, 10 Feb 2021 23:55:24 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     George McCollister <george.mccollister@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/4] add HSR offloading support for DSA
 switches
Message-ID: <20210210215524.m4vnztszcnsr6pxa@skbuf>
References: <20210204215926.64377-1-george.mccollister@gmail.com>
 <87sg6648nw.fsf@waldekranz.com>
 <CAFSKS=OO8oi=757b9DqOMpS4X6jqf5rg+X=GO8G-hOQ+S7LaKQ@mail.gmail.com>
 <87k0rh487y.fsf@waldekranz.com>
 <CAFSKS=NQN-OaQwYT8Crev33mUON3+6zYCss_nHoCD2gOzeYWTw@mail.gmail.com>
 <87eehn4ojt.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87eehn4ojt.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 10, 2021 at 10:10:14PM +0100, Tobias Waldekranz wrote:
> On Tue, Feb 09, 2021 at 11:04, George McCollister <george.mccollister@gmail.com> wrote:
> >> > It also doesn't implement a ProxyNodeTable (though that actually
> >> > wouldn't matter if you were offloading to the xrs700x I think). Try
> >> > commenting out the ether_addr_copy() line in hsr_xmit and see if it
> >> > makes your use case work.
> >>
> >> So what is missing is basically to expand the current facility for
> >> generating sequence numbers to maintain a table of such associations,
> >> keyed by the SA?
> >
> > For the software implementation it would also need to use the
> > ProxyNodeTable to prevent forwarding matching frames on the ring and
> > delivering them to the hsr master port. It's also supposed to drop
> > frames coming in on a redundant port if the source address is in the
> > ProxyNodeTable.
> 
> This whole thing sounds an awful lot like an FDB. I suppose an option
> would be to implement the RedBox/QuadBox roles in the bridge, perhaps by
> building on the work done for MRP? Feel free to tell me I'm crazy :)

As far as I understand, the VDAN needs to generate supervision frames on
behalf of all nodes that it proxies. Therefore, implementing the
RedBox/QuadBox in the bridge is probably not practical. What I was
discussing with George though is that maybe we can make hsr a consumer
of SWITCHDEV_FDB_ADD_TO_DEVICE events, similar to DSA with its
assisted_learning_on_cpu_port functionality, and that would be how it
populates its proxy node table. A RedBox becomes a bridge with one HSR
interface and one or more standalone interfaces, and a QuadBox becomes a
bridge with two HSR interfaces. How does that sound?
