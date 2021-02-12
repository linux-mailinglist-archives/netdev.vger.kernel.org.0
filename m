Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5493631A878
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 00:54:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231532AbhBLXxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 18:53:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbhBLXxU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 18:53:20 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89F79C0613D6
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 15:52:39 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id z11so1844684lfb.9
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 15:52:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=+stlhAKYXfKYY3GXMsAIF7N7KBpk2s1D5/pdtGOOwtw=;
        b=UyxaZ6QISnHku693SJC8o0UjvL5Rez4II6S8HhfWK62E0MMQl2Rtxqm9rGenKg/XSU
         zZfcEi66Swv0xzdA3SgONChrBTyIH5sArNSdmQvkwPx9XWNVujeFa4v7os44x3BZsdeH
         sv/60P32vzx+wGp83H493lIqmKSUfOzOAbst2duM39cpVPf+V+6z6rdcmDLD7Rpf6Qm5
         J+tCLNTll7z7iJyfKneU9qwNIKCq3lA9MnBy96YzArDeKMwTYpguhGdIWAypMGXMch5b
         phvBBxgaIlMxjHIFQp234HaLDr/w5psMggzcZPEzWkoYp+l2WyFt2Bys709Z99HTNnpg
         nKFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=+stlhAKYXfKYY3GXMsAIF7N7KBpk2s1D5/pdtGOOwtw=;
        b=sLGfMJ/HsLA9t9EPC/InUqJgA2FzJcVJwKMSpo5p+kdmu3Wtrk1G5sDmtOdH3yJVYZ
         qg6uSYvVXf28fRSGRlcdb6K9kkcFvG+XcND/xFZmLeA74TAOiWhIb+bw92WtKjFmbDyj
         BpRfRJb2Sjf9q6KMCaISksqpJOnpFapdXhe839VGNesKXQdx3l+wO2XGwE56NEkFpAE8
         y4Icm2Zc8wLGlJpHYIJa9OcVQi+WXmYSM6ILGFQPNnql4VNUWerD3lEViJNS10V3UzzY
         62FeEVTlnRKHXc4PZaKuwm5X+cqmq+VjajkN1mv3q2HniF4/99lLmj6eQ092DyGYnOrg
         +WyQ==
X-Gm-Message-State: AOAM5337BnpKZYBjMre5bOkMDV0n4MAgHpIL/enkQgbVsWEytB2HelLe
        vpdOjj9FEj3joeCrin2wKT5Ib0WPnGif8w==
X-Google-Smtp-Source: ABdhPJwdO09ODx05Kz1zQ2r1N0nDcvVjsCBCOB0MJL9ZjfCuAsEta/YFLg2CO+Q85izXMnFSzfmEbg==
X-Received: by 2002:a05:6512:31d3:: with SMTP id j19mr2822088lfe.495.1613173957630;
        Fri, 12 Feb 2021 15:52:37 -0800 (PST)
Received: from wkz-x280 (h-236-82.A259.priv.bahnhof.se. [98.128.236.82])
        by smtp.gmail.com with ESMTPSA id u11sm1870521ljj.45.2021.02.12.15.52.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 15:52:37 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     George McCollister <george.mccollister@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/4] add HSR offloading support for DSA switches
In-Reply-To: <20210210215524.m4vnztszcnsr6pxa@skbuf>
References: <20210204215926.64377-1-george.mccollister@gmail.com> <87sg6648nw.fsf@waldekranz.com> <CAFSKS=OO8oi=757b9DqOMpS4X6jqf5rg+X=GO8G-hOQ+S7LaKQ@mail.gmail.com> <87k0rh487y.fsf@waldekranz.com> <CAFSKS=NQN-OaQwYT8Crev33mUON3+6zYCss_nHoCD2gOzeYWTw@mail.gmail.com> <87eehn4ojt.fsf@waldekranz.com> <20210210215524.m4vnztszcnsr6pxa@skbuf>
Date:   Sat, 13 Feb 2021 00:52:36 +0100
Message-ID: <878s7s4zej.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 10, 2021 at 23:55, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Wed, Feb 10, 2021 at 10:10:14PM +0100, Tobias Waldekranz wrote:
>> On Tue, Feb 09, 2021 at 11:04, George McCollister <george.mccollister@gmail.com> wrote:
>> >> > It also doesn't implement a ProxyNodeTable (though that actually
>> >> > wouldn't matter if you were offloading to the xrs700x I think). Try
>> >> > commenting out the ether_addr_copy() line in hsr_xmit and see if it
>> >> > makes your use case work.
>> >>
>> >> So what is missing is basically to expand the current facility for
>> >> generating sequence numbers to maintain a table of such associations,
>> >> keyed by the SA?
>> >
>> > For the software implementation it would also need to use the
>> > ProxyNodeTable to prevent forwarding matching frames on the ring and
>> > delivering them to the hsr master port. It's also supposed to drop
>> > frames coming in on a redundant port if the source address is in the
>> > ProxyNodeTable.
>> 
>> This whole thing sounds an awful lot like an FDB. I suppose an option
>> would be to implement the RedBox/QuadBox roles in the bridge, perhaps by
>> building on the work done for MRP? Feel free to tell me I'm crazy :)
>
> As far as I understand, the VDAN needs to generate supervision frames on
> behalf of all nodes that it proxies. Therefore, implementing the
> RedBox/QuadBox in the bridge is probably not practical. What I was
> discussing with George though is that maybe we can make hsr a consumer
> of SWITCHDEV_FDB_ADD_TO_DEVICE events, similar to DSA with its
> assisted_learning_on_cpu_port functionality, and that would be how it
> populates its proxy node table.

Is it not easier to just implement learning in the HSR layer? Seeing as
you need to look up the table for each packet anyway, you might as well
add a new entry on a miss. Otherwise you run the risk of filling up your
proxy table with entries that never egress the HSR device. Perhaps not
likely on this particular device, but on a 48-port switch with HSR
offloading it might be.

This should also work for more exotic configs with multiple macvlans for
example:

macvlan0 macvlan1
      \  /
      hsr0
      /  \
   swp1  swp2

> A RedBox becomes a bridge with one HSR
> interface and one or more standalone interfaces, and a QuadBox becomes a
> bridge with two HSR interfaces. How does that sound?

Yeah that is the straight forward solution, and what I tried to describe
earlier in the thread with this illustration:

     >> >>       br0
     >> >>      /   \
     >> >>    hsr0   \
     >> >>    /  \    \
     >> >> swp1 swp2 swp3

I just wanted to double check that we had not overlooked a better
solution outside of the existing HSR code.
