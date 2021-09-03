Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 958B33FFCD2
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 11:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348676AbhICJPl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 05:15:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233277AbhICJPk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 05:15:40 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7CF8C061575;
        Fri,  3 Sep 2021 02:14:40 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id c5so2039713plz.2;
        Fri, 03 Sep 2021 02:14:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=kb8Z5KH61dlFFT8cs85Ri7+/n7iNLKzAMoxXAmW2ceA=;
        b=VS5jH6/vJozUZwnuawGnyMC48QMXnhiunRInAGDzbwL/WM0K4OHttgn8v1WCHsygYV
         XtAU90YgcTIDbfWQpOteVNWViEFrEkjPcJJbHLsCiJAFOUNxLEK6hbYR9cNxExvnShpo
         LyqlT+c3lp5cystcpuSx+j0P2kH/r09xPyCfn8NuA0A1cshCiFaVISLRV+ZhlfT3bTUP
         PhxSKw5dKyHQXBpu3yLlhAYWERBo7a+fMAYKdQEVJADI+D33toqWqcNflbD1oxzKiRG8
         L35MKyfOzPdC/cBx/XIsdgFwmgaenK14tAvoVkxX5Zhywm8m/dL90ZbZ+9rnlCfrSOYJ
         TJuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=kb8Z5KH61dlFFT8cs85Ri7+/n7iNLKzAMoxXAmW2ceA=;
        b=iZ9VPsuIinKVpbO1zuTdkH5E6ijy/NU5Xqsk3waVgjFE3acjAsXWv7hFCYs4gfimjm
         +i1edhD4DdqvhHDJS7g74mX04KtVzylmBn8D4EBfqIm3Gp4Dbb7tqkrYOSF8hydm/Fcz
         WBdm5CU/0oDeTEQH5kBQwy9V4RkzXy0UUANcl/rvq3B+fUrMbcshc9n7pBji6C+AWb6T
         xlX1tDKhzI8GWRugLfX948WP3jQxuPrrvgYKR6mOsp8kxcoYuG7uGwcgkhluQOjgqWYT
         tNGJ2RrloS8DdTOEEslftfqeJ7zd5WhLBAowIH6JgmH9Wy9KZpqtgX0KGI6eS75ZcAJq
         Aw5g==
X-Gm-Message-State: AOAM533pT9ZpJ2UrGs9QLM7kxxtjGGy26MLFdq0tR7ygfSgrHsKjHdKI
        cn9mmvqRZHnH+CLI5EE1Kd0=
X-Google-Smtp-Source: ABdhPJz1EryyIfzYCwBsKI7WGd4sPcZ3VHNRIpfsK7XuoGifQUKu3AiOsDLxBMlWacWq67iuYF7Weg==
X-Received: by 2002:a17:90a:6282:: with SMTP id d2mr8791405pjj.189.1630660479349;
        Fri, 03 Sep 2021 02:14:39 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id y1sm5766231pga.50.2021.09.03.02.14.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Sep 2021 02:14:38 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        Sean Wang <sean.wang@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "open list:MEDIATEK SWITCH DRIVER" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
Subject: Re: [PATCH 4.19.y] net: dsa: mt7530: disable learning on standalone ports
Date:   Fri,  3 Sep 2021 17:14:30 +0800
Message-Id: <20210903091430.2209627-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <YTBoDaYDJfBz3YzN@kroah.com>
References: <20210824055509.1316124-1-dqfext@gmail.com> <YSUQV3jhfbhbf5Ct@sashalap> <CALW65ja3hYGmEqcWZzifP2-0WsJOnxcUXsey2ZH5vDbD0-nDeQ@mail.gmail.com> <YSi8Ky3GqBjnxbhC@kroah.com> <20210902053619.1824464-1-dqfext@gmail.com> <YTBoDaYDJfBz3YzN@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 02, 2021 at 07:58:37AM +0200, Greg KH wrote:
> On Thu, Sep 02, 2021 at 01:36:19PM +0800, DENG Qingfang wrote:
> > On Fri, Aug 27, 2021 at 12:19:23PM +0200, Greg KH wrote:
> > > On Tue, Aug 24, 2021 at 11:57:53PM +0800, DENG Qingfang wrote:
> > > > Standalone ports should have address learning disabled, according to
> > > > the documentation:
> > > > https://www.kernel.org/doc/html/v5.14-rc7/networking/dsa/dsa.html#bridge-layer
> > > > dsa_switch_ops on 5.10 or earlier does not have .port_bridge_flags
> > > > function so it has to be done differently.
> > > > 
> > > > I've identified an issue related to this.
> > > 
> > > What issue is that?  Where was it reported?
> > 
> > See Florian's message here
> > https://lore.kernel.org/stable/20210317003549.3964522-2-f.fainelli@gmail.com/
> 
> THat is just the patch changelog text, or is it unique to this
> stable-only patch?  It is not obvious at all.

The issue is with all DSA drivers that do not disable address learning
on standalone ports.

"With learning enabled we would end up with the switch having
incorrectly learned the address of the CPU port which typically results
in a complete break down of network connectivity until the address
learned ages out and gets re-learned, from the correct port this time."

> 
> > > > > 2. A partial backport of this patch?
> > > > 
> > > > The other part does not actually fix anything.
> > > 
> > > Then why is it not ok to just take the whole thing?
> > > 
> > > When backporting not-identical-patches, something almost always goes
> > > wrong, so we prefer to take the original commit when ever possible.
> > 
> > Okay. MDB and tag ops can be backported as is, and broadcast/multicast
> > flooding can be implemented in .port_egress_floods. 
> 
> So what are we supposed to do here?

Function port_egress_floods is refactored to port_bridge_flags in commit
a8b659e7ff75 ("net: dsa: act as passthrough for bridge port flags"). I can
backport the mt7530_port_bridge_flags function as port_egress_floods.

> 
> totally confused,
> 
> greg k-h
