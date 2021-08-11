Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83E543E9B13
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 00:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232693AbhHKWyO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 18:54:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232600AbhHKWyN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 18:54:13 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65123C061765
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 15:53:49 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id bo19so6269905edb.9
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 15:53:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=juTKEXdflTuuDBhrMAgDoDmJPLUq1zst3jNob5YnapY=;
        b=r8QpuKH7OdVzXVVpT8Ew1vApeLSXMP0X0Pl9AGW6DIN4XCKGZbIl4NYp8NUVFU9bjj
         a3j+aS4zdVQ4LBvbJEMBiDGjHf5linzK4ZKpwYOghKk15RFTWeZwPkH5T3XYS+4aTbr2
         Mwj+qBqsEL1A2Vk5Cs9ggfF0MaoIMpmS53uBOtBx4FrgEmdxCfWAJbNxDffraKBC3Eza
         8H/CzLzTZYI74dBva/wNOnB3jb+D76KJEoLYujMkbPTg3sjBDhYkJjhjWyeo75FUGP3A
         Q+Vshh0WmC76VTp7DtGkrRfh9KByBWa3DL6CE3JzQb0tzcS85SvOqFn9DJF2CqbBjGJx
         gVbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=juTKEXdflTuuDBhrMAgDoDmJPLUq1zst3jNob5YnapY=;
        b=USMp+ccuuegz/6QzBHr3jbiyzAugmD1ens9g7hAi8uyvp4Iu+rACe+9tN3KsXKpZ6D
         x9oW3rjqM3AgPzy3VQ7Zgp50T16KtPmtJtpfUUtP4G+738ppXQ0QRmocqM4/J4wp+yMp
         kzkGelpUIr6rY7Iw96CpsUX0VsEPUXNJYBa8SvqRz38bSF5llkDSSdDvPYVgzCZRckTr
         8j20DMCWN7f0K0Mg7GDBwXLjpebh3Au4dVi6/9Xc1KKJVE85ptHbuJpFeE+TDs6nzk7b
         J+U+pe7Rn6T3UYVfapcsNhL2j9xeT0VquassjchYV9VTgmkM4KJkn+dZvVK7ls0FQRf7
         TqhQ==
X-Gm-Message-State: AOAM530X6pbpDjsmtsD1kX2tLcGQXnZpq4J4r1QY/S6lV3sp4GIoegWb
        Fd4FuUXMpl49v8N8Wc0K+wo=
X-Google-Smtp-Source: ABdhPJyuOn0FF8SVfvdRJY6mNbVjshdQyWAiQL78yKmNHKgVrIrTOStPr6KI/962ymnDPtAHzkYbkw==
X-Received: by 2002:aa7:dcd1:: with SMTP id w17mr1593591edu.322.1628722428028;
        Wed, 11 Aug 2021 15:53:48 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id u20sm216339ejz.87.2021.08.11.15.53.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 15:53:47 -0700 (PDT)
Date:   Thu, 12 Aug 2021 01:53:46 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net] net: dsa: apply MTU normalization for ports that
 join a LAG under a bridge too
Message-ID: <20210811225346.46l3qd5kwtv5zglf@skbuf>
References: <20210811124520.2689663-1-vladimir.oltean@nxp.com>
 <20210811164441.vrg4pmivx4f6cuv6@skbuf>
 <20210811153833.0f63e9f5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210811153833.0f63e9f5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 11, 2021 at 03:38:33PM -0700, Jakub Kicinski wrote:
> On Wed, 11 Aug 2021 19:44:41 +0300 Vladimir Oltean wrote:
> > On Wed, Aug 11, 2021 at 03:45:20PM +0300, Vladimir Oltean wrote:
> > > We want the MTU normalization logic to apply each time
> > > dsa_port_bridge_join is called, so instead of chasing all callers of
> > > that function, we should move the call within the bridge_join function
> > > itself.
> > > 
> > > Fixes: 185c9a760a61 ("net: dsa: call dsa_port_bridge_join when joining a LAG that is already in a bridge")
> > > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > > ---  
> > 
> > I forgot to rebase this patch on top of 'net' and now I notice that it
> > conflicts with the switchdev_bridge_port_offload() work.
> > 
> > Do we feel that the issue this patch fixes isn't too big and the patch
> > can go into net-next, to avoid conflicts and all that?
> 
> The commit message doesn't really describe the impact so hard to judge,
> but either way you want to go - we'll need a repost so it can be build
> tested.

The impact is that if a DSA interface joins a bonding/team that is in a
bridge and the bonding/team had an MTU of 9000 bytes, the DSA interface
will still have what it had before (probably 1500). I found this through
code inspection, didn't hit an actual bug or anything like that. It
seems fairly low impact to me, and a rare occurrence in any case. The
common path is for the DSA interface to first join the bond, then the
bond to join the bridge anyway, and that would work I think.

Later edit: I just realized, while typing, that it's going to be more
complicated than that, so I'm going to just drop the patch at least for
now. While bond_enslave() does in fact make the lower interface inherit
the bond's MTU, that's not what we want here. DSA switches want their
bridged ports to have the same MTU, and they change it dynamically
whenever one MTU changes, but they don't change the MTU of any upper
interfaces they might have. So with the normalization logic as applied
by this patch, ports that join a bond will have an MTU of 9000, but the
bond itself will still have 1500, since
(a) DSA doesn't change it
(b) the bonding driver has a NETDEV_CHANGEMTU handler implementation
    which just wonders whether it should let DSA lowers change their MTU
    in the first place or not.

> Conflicts are not a huge deal. Obviously always best to wait for trees
> to merge if that fixes things, but if net has dependency on net-next
> you should just describe what you want the resolution to look like we
> should be able to execute :)

Yeah, thanks, I noticed you duly applied the instructions in the last
conflicting patch I sent exactly as described, and I appreciate it.
But I don't like conflicts either way, they're a pain to deal with when
you're backporting patches, since you can never get a clean cherry pick
list, so I try to avoid them myself now if I can.
