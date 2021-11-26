Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AFC345F60C
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 21:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240703AbhKZUsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 15:48:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241098AbhKZUqI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 15:46:08 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 174E5C061574;
        Fri, 26 Nov 2021 12:41:03 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id l25so43156822eda.11;
        Fri, 26 Nov 2021 12:41:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OKsS2VBzzc/tYXgXzO7xiKe6VTOcM/AUGTPgRtdxw1A=;
        b=lEWSh+vpqx/cCMLU8/tKnXdgaFYpN3ZHHWpwPigLGQeu4k5aqPh9U7NZn0blvRvg+s
         ID6FCPD4KVBT3Ywfn+O/8woU0n85OZEdd45fze8PPtW63nEO9Uo1t07C4bEcqnvVuNeK
         5tvAnuNqUZhnBv8E0NnrTZaMIK3jtG20N8fftDqZDSG6JHQaTPe7gW5OjB9N/tKbfiW4
         zq2hfJl8drJ5JetkEvYsHSTou0Nf8QPzY/RvBBhiPyZSS0c5Y0fh8pHILP3I+I6jCiIG
         DTCgYOlp/7PPaI3g7drHhXpYj/zDM4XAW8Ies86RLzIGSg8O5PYbGVPVx27uZbRKe0KV
         4kIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OKsS2VBzzc/tYXgXzO7xiKe6VTOcM/AUGTPgRtdxw1A=;
        b=JfMJhN4j/rUyMAgVJfBo2WPxWERsgCxtmbhDNe4rDTDQXyQHPuNzE4XcF5p9eqYaj1
         Wuui9dALZDqnbDXToIAKmjbMlMgWCnWs0y8WKtrlBSlA1uXIO8lmG7F8JmvKOVW4AZkv
         YJ21EyG7BYRZjEnblUaG6+dFqCv4ooAg0oYATuDGAt6XdFCSGLz7AmIwPA5F94qWBLOY
         53bZH10kuyLVogpX7/sgoZ1dqFBje79uaWZVGmv5iafTWdjBcp8jXjqtsfbuTA0oreJi
         9Qw7rirFFo75PqshL80yJ6sjS+X3ecMa0NeUnUUXW0+oe+IGp+RV6KeegX48/qnt+bYO
         Lccw==
X-Gm-Message-State: AOAM5304NbYM4IBp/ObeavYCZDksagEisMc89Se7wgrjildf3UHHUnz+
        w8gDEMcYhbTHPc3vqJyqiIHOxJ7u5R8=
X-Google-Smtp-Source: ABdhPJy40Uo0DkuaWW+a1xLkC0YdTjDA59fansEUFqjRW8eEiCHLfgNdW3cxHeWUuJnAYvv0X8KKsA==
X-Received: by 2002:aa7:cc82:: with SMTP id p2mr49875327edt.201.1637959261507;
        Fri, 26 Nov 2021 12:41:01 -0800 (PST)
Received: from skbuf ([188.25.173.50])
        by smtp.gmail.com with ESMTPSA id s16sm4273010edt.30.2021.11.26.12.41.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Nov 2021 12:41:01 -0800 (PST)
Date:   Fri, 26 Nov 2021 22:40:59 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v3 1/1] net: dsa: microchip: implement multi-bridge
 support
Message-ID: <20211126204059.l24m2n6tsjxaycvl@skbuf>
References: <20211126123926.2981028-1-o.rempel@pengutronix.de>
 <20211126114336.05fd7ebd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211126114336.05fd7ebd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 26, 2021 at 11:43:36AM -0800, Jakub Kicinski wrote:
> On Fri, 26 Nov 2021 13:39:26 +0100 Oleksij Rempel wrote:
> > Current driver version is able to handle only one bridge at time.
> > Configuring two bridges on two different ports would end up shorting this
> > bridges by HW. To reproduce it:
> > 
> > 	ip l a name br0 type bridge
> > 	ip l a name br1 type bridge
> > 	ip l s dev br0 up
> > 	ip l s dev br1 up
> > 	ip l s lan1 master br0
> > 	ip l s dev lan1 up
> > 	ip l s lan2 master br1
> > 	ip l s dev lan2 up
> > 
> > 	Ping on lan1 and get response on lan2, which should not happen.
> > 
> > This happened, because current driver version is storing one global "Port VLAN
> > Membership" and applying it to all ports which are members of any
> > bridge.
> > To solve this issue, we need to handle each port separately.
> > 
> > This patch is dropping the global port member storage and calculating
> > membership dynamically depending on STP state and bridge participation.
> > 
> > Note: STP support was broken before this patch and should be fixed
> > separately.
> > 
> > Fixes: c2e866911e25 ("net: dsa: microchip: break KSZ9477 DSA driver into two files")
> 
> Suspicious, this sounds like a code reshuffling commit.

This intrigued me, so I looked it up. If you look at the git diff of
that commit, you'll see that the "member" variable of struct ksz_port
only appears in the green portion of the delta, not even once in the red
portion. In fact, struct ksz_port was _introduced_ by that commit!

> Where was the bad code introduced? The fixes tag should point at the
> earliest point in the git history where the problem exists.

What bad code? As far as I can tell, prior to that commit, there was no
restriction of forwarding domain applied to this switch. Heck,
->port_bridge_join() was added in that commit! After that commit,
restricting the forwarding domain was done poorly. No wonder, since
reviewers probably did not notice what was going on.

We are talking here about a very poorly written and subpar driver.
I wouldn't be too mad at Oleksij for not doing a cleaner job for this
commit, it's pretty much "delete the bogus stuff and rewrite it the way
it should be", which I think is fine at this stage, this driver needs that.
His code appears fine to my non-expert fine, I've added very similar
logic to ocelot which has the same constraints of juggling with the
forwarding domain based on STP states.

Also, in case you're wondering why I'm responding in his defense, it is
for very selfish reasons, of course :) I'd like to continue working on
this patch series:
https://patchwork.kernel.org/project/netdevbpf/cover/20211026162625.1385035-1-vladimir.oltean@nxp.com/
which is invasive because it touches every driver's bridging callbacks.
So the sooner that in-flight patches related to bridging can go in, the
sooner I can resend a new version of my API rework.
