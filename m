Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D17B453345
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 14:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236871AbhKPN4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 08:56:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbhKPN4g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 08:56:36 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A28D1C061570;
        Tue, 16 Nov 2021 05:53:38 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id g14so24532600edb.8;
        Tue, 16 Nov 2021 05:53:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4r46U79Xnn5A553L35MQm25MqRjJGh5MMeYZAVoJQPw=;
        b=IqGuxjK5l/6r/Q5brrXdbF+XW1kTYolX43VIBr+WwPjOQhMk17palDl1xQSlcOJBXV
         CMcKi6wMCIICGTw2L9so7n16XDfTOQnlrUt6BwxhDIBXKmrJNbILze4gwxuiak8lWLSb
         rBbs2qPXgotT/g0Mkhsr0FJoG5azgL7EhIgoXpgPn/mFbzIov62Cu+TAv9Bsvw8Hm1t2
         wL+vxW4ElC7AeohTgwMfe0ujwVW0dtpqXTzcnYC/CnuSYjuEaniiyfSB6j9rLnordxhP
         u526ByluCovheewcEaAGG1d4wGvSllJx1DLQbO09xnFQChI6K71lrAnpTUO58GDa1YuA
         O4SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4r46U79Xnn5A553L35MQm25MqRjJGh5MMeYZAVoJQPw=;
        b=b5qAfnwMyz8M+FoKuIRnR9M3jXEwF3rAh/mNTfQ74dlY+lPhsrT9Q/4KEOqXuJBwUk
         k5WJfKBCzlGAOAruMBgB/fZQSstLmni5TxPh4GMogjbpDN79CIVz//8psEKW3VYZnP8j
         uMb3XZ4py6pC2DNEg2KidBb4McDJd+HD5CoI0KBKc7/JYwbmTEOgqF8c7WAjnv6+ZesV
         dt9ssX36gTfdT5tTA6sPFZibls52EjCQNIxOJbgQsmHo4mX/lom+0v6/rWggg/pqMOxV
         ynunNageJwCNIv5TkIK52cb+mHO8N5X45JJwgHsDvQaHjsnPrGsz08QL2Jr4PtybzXnU
         1u1Q==
X-Gm-Message-State: AOAM533xg7pYnsvmFAIQKJ0aezQ6a1HeSEbx7/3vI7CLjWhScLl07+aR
        DYzElXlmG/rGKLH6X6hp+1A=
X-Google-Smtp-Source: ABdhPJwdgVpYC4edTzyRH712uU9uQVONuz3pUB2MbGL/5MbNgP0xhvFl3SIGtLMTASdlp8iesBJTlg==
X-Received: by 2002:a17:907:75f0:: with SMTP id jz16mr10445186ejc.77.1637070817156;
        Tue, 16 Nov 2021 05:53:37 -0800 (PST)
Received: from skbuf ([188.25.163.189])
        by smtp.gmail.com with ESMTPSA id da24sm1611286edb.37.2021.11.16.05.53.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 05:53:36 -0800 (PST)
Date:   Tue, 16 Nov 2021 15:53:35 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, g@pengutronix.de,
        Woojung Huh <woojung.huh@microchip.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com,
        kernel@pengutronix.de, Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [RFC PATCH net-next] net: dsa: microchip: implement multi-bridge
 support
Message-ID: <20211116135335.j5mmvpnfzw4hfz67@skbuf>
References: <20211108111034.2735339-1-o.rempel@pengutronix.de>
 <20211110123640.z5hub3nv37dypa6m@skbuf>
 <20211112075823.GJ12195@pengutronix.de>
 <20211115234546.spi7hz2fsxddn4dz@skbuf>
 <20211116083903.GA16121@pengutronix.de>
 <20211116124723.kivonrdbgqdxlryd@skbuf>
 <20211116131657.GC16121@pengutronix.de>
 <YZO0tuMtDUIbRfcC@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YZO0tuMtDUIbRfcC@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 16, 2021 at 02:40:06PM +0100, Andrew Lunn wrote:
> > > What logging noise?
> > 
> > I get this with current ksz driver:
> > [   40.185928] br0: port 2(lan2) entered blocking state
> > [   40.190924] br0: port 2(lan2) entered listening state
> > [   41.043186] br0: port 2(lan2) entered blocking state
> > [   55.512832] br0: port 1(lan1) entered learning state
> > [   61.272802] br0: port 2(lan2) neighbor 8000.ae:1b:91:58:77:8b lost
> > [   61.279192] br0: port 2(lan2) entered listening state
> > [   63.113236] br0: received packet on lan1 with own address as source address (addr:00:0e:cd:00:cd:be, vlan:0)
> 
> I would guess that transmission from the CPU is broken in this
> case. It could be looking up the destination address in the
> translation table and not finding an entry. So it floods the packet
> out all interfaces, including the CPU. So the CPU receives its own
> packet and gives this warning.
> 
> Flooding should exclude where the frame came from.

I interpret this very differently. If Oleksij is looping lan1 with lan2
and he keeps the MAC addresses the way DSA sets them up by default, i.e.
equal and inherited from the DSA master, then receiving a packet with a
MAC SA (lan2) equal with the address of the receiving interface (lan1)
is absolutely natural. What is not natural is that the bridge attempts
to learn from this packet (the message is printed from br_fdb_update),
which in turn is caused by the fact that the port is allowed to proceed
to the LEARNING state despite there being a loop (which is not detected
by STP because STP is broken as Oleksij describes).
