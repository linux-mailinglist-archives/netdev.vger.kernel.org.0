Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 943B451DB86
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 17:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442649AbiEFPJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 11:09:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442629AbiEFPJ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 11:09:27 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66F45140F5
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 08:05:44 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id q76so6312779pgq.10
        for <netdev@vger.kernel.org>; Fri, 06 May 2022 08:05:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SrelFilWkNCqMWTtWTsaQER91a43bb9aDaGJrJzpx28=;
        b=fN29fuadLoIjoJ3lYh5AXU15YL6yc/VKSSAktaUFmlRyspIJlsbWh9Gjy1epdJoOk+
         n/VH4IoUunjmLRDhYjb1kiPuyk5gSafqSWPutjzyyKmP0SogfpYcz8fa0KTw8Filc7h6
         TaOec4GvTg21xAXB7wFWpmBECOs6J+A76jOcKvoQNA1QLZVsxp/m+AbGrB66Ny3iiFhC
         bQx8nU1hxqxwY8HB2jt7bBC9GvZOmJdAW3cLU8pQv8/Olv9nMCUQh0nKlKZe3KRYqzzJ
         HI78D2PAnNURewal18UFjgcLniNbDohTxCtXOKd1L6rm6Nfy9E8JnBk0AfJYDzHUH900
         8XPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SrelFilWkNCqMWTtWTsaQER91a43bb9aDaGJrJzpx28=;
        b=O5OUmT6XkoqptgXr1bUknbJ3n7e3yeEqlVkWSZd38U8rO4IUhfpYnV6ui1x2RBccRQ
         GRSYj+w3F/4O0f1v2M5UAPOqslPCiPj0mwkx1/v3Zjo2vsQJyr7+mQfA+4ysn/C4vbtX
         wt1v44oNLnwd6NSTxgGMBLtM9U+hAC3a5vzygZAcLJh664M38j7eLfQibNsSt9E47plP
         +AZ2yYFj+M+vCjNMxjLnB1dirTnF0qyrmJIyVKHGuhLqzQc5MptOfiwAsd54MCZCCkjZ
         G7MrurOeWpTSjqPgNR6RnBPrewEf4pSDPM+M1rQ3vQV46CPSoOPc9IPHyvY3PaY7nl5z
         1IKw==
X-Gm-Message-State: AOAM532P/9plo19sJ3oUz+Hcx+QNmp3UhkYkUIhDqAh7yLni/RIVvt4b
        Qo8QXxw/ZRLUYQaw7+lEOPy9JE/I5SOpmA==
X-Google-Smtp-Source: ABdhPJw8h3mZ3VJ2ctm9YRLg2p5smOgNFaTF2DPrH1O1FmYHJ92NPcqzA9Q8N8G2XMY/Hv27UP2EhA==
X-Received: by 2002:a05:6a00:cd4:b0:510:49f7:12a4 with SMTP id b20-20020a056a000cd400b0051049f712a4mr3989710pfv.59.1651849543892;
        Fri, 06 May 2022 08:05:43 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id j192-20020a638bc9000000b003c14af505fcsm3380500pge.20.2022.05.06.08.05.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 May 2022 08:05:43 -0700 (PDT)
Date:   Fri, 6 May 2022 08:05:40 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH RFC] net: bridge: Clear offload_fwd_mark when passing
 frame up bridge interface.
Message-ID: <20220506080540.5bc6094b@hermes.local>
In-Reply-To: <YnR3XikvI4tQy5IL@lunn.ch>
References: <20220505225904.342388-1-andrew@lunn.ch>
        <20220505160720.27358a55@hermes.local>
        <YnR3XikvI4tQy5IL@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 6 May 2022 03:18:22 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> On Thu, May 05, 2022 at 04:07:20PM -0700, Stephen Hemminger wrote:
> > On Fri,  6 May 2022 00:59:04 +0200
> > Andrew Lunn <andrew@lunn.ch> wrote:
> >   
> > > It is possible to stack bridges on top of each other. Consider the
> > > following which makes use of an Ethernet switch:
> > > 
> > >        br1
> > >      /    \
> > >     /      \
> > >    /        \
> > >  br0.11    wlan0
> > >    |
> > >    br0
> > >  /  |  \
> > > p1  p2  p3
> > > 
> > > br0 is offloaded to the switch. Above br0 is a vlan interface, for
> > > vlan 11. This vlan interface is then a slave of br1. br1 also has
> > > wireless interface as a slave. This setup trunks wireless lan traffic
> > > over the copper network inside a VLAN.
> > > 
> > > A frame received on p1 which is passed up to the bridge has the
> > > skb->offload_fwd_mark flag set to true, indicating it that the switch
> > > has dealt with forwarding the frame out ports p2 and p3 as
> > > needed. This flag instructs the software bridge it does not need to
> > > pass the frame back down again. However, the flag is not getting reset
> > > when the frame is passed upwards. As a result br1 sees the flag,
> > > wrongly interprets it, and fails to forward the frame to wlan0.
> > > 
> > > When passing a frame upwards, clear the flag.
> > > 
> > > RFC because i don't know the bridge code well enough if this is the
> > > correct place to do this, and if there are any side effects, could the
> > > skb be a clone, etc.
> > > 
> > > Fixes: f1c2eddf4cb6 ("bridge: switchdev: Use an helper to clear forward mark")
> > > Signed-off-by: Andrew Lunn <andrew@lunn.ch>  
> > 
> > Bridging of bridges is not supposed to be allowed.
> > See:
> > 
> > bridge:br_if.c
> > 
> > 	/* No bridging of bridges */
> > 	if (dev->netdev_ops->ndo_start_xmit == br_dev_xmit) {
> > 		NL_SET_ERR_MSG(extack,
> > 			       "Can not enslave a bridge to a bridge");
> > 		return -ELOOP;
> > 	}  
> 
> This is not direct bridging of bridges. There is a vlan interface in
> the middle. And even if it is not supposed to work, it does work, it
> is being used, and it regressed. This fixes the regression.
> 
>    Andrew

The problem is that doing this kind of nested bridging screws up
Spanning Tree.
