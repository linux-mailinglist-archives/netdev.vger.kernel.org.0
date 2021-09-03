Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 783353FFEAF
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 13:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348673AbhICLKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 07:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234713AbhICLKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 07:10:19 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 289D2C061575
        for <netdev@vger.kernel.org>; Fri,  3 Sep 2021 04:09:19 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id e21so11297503ejz.12
        for <netdev@vger.kernel.org>; Fri, 03 Sep 2021 04:09:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=W6ljUs/PjsmmLVX/sZJ8kvl5ahXkIrEb8P420GoQWPE=;
        b=psOr3fB+ev6xUO0jWXQVcQ+L2Y2FSld3KyuTES/6k52xmocyGs+DEkzlmms8HZzsXe
         DMgpLeeynSHNv1bazcBYtgHgx32d+zO1ml30B0DZkHLrFhBlnNa9HYyrIYIYKRXwvCea
         tDZj+yBI37teuomf1rsiGJ7f8ApaW/pamAKORQ+iXh7TdabteXtQIdxeogNs0qJ+Otoi
         W8fLEjkdPy+5Hsf8sgwpRFWuSUXA8CTA6uqYdXjjBBcj19UYX1b9Uo9Q5AO4gFSgSQmY
         3evhg3xcEwhCdBZbfBKf5PL8qkA/+bKYmvKI2DxApDqMcm4CDZda97gPSrw7A8BlhUmr
         v3qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=W6ljUs/PjsmmLVX/sZJ8kvl5ahXkIrEb8P420GoQWPE=;
        b=EcaVpOHoD17M2mYvyPwPWvuIx72EnxjMbru1fXgu/SodYqRYfVuQpuJtZ4WBZGWkBV
         lENFZOUJCDlE1cjoOuyvarVRM6c8IRnw06i5KgfP/fCksPG4pWnwo/ZD1z39mk8M47S3
         aT+geSJ5cqg1mZapRj3nVjrsLf8jm5t1fHCqppP24oVpqFXUOT9r1KON1Nd7Hg+wK6sH
         J2f3eJS0l61GkFcwwf3NmwWYwcqGsI7s2MfSfDkT4L10TdVTiOEeBFf7fgRZkNnHzJZw
         ugiBhAxxTj/y3GsiMMthr5s+QBnS59+zRFPG/VU/h48uThWC4Z4AXtUewW8Im+QO+R9A
         L9Pg==
X-Gm-Message-State: AOAM532O4GMjPHKhW+wNvVtVnpkj/+CWqJRoQrHP3MV0zzeQQYjBq8jj
        PaMOii1pzpjJWUaSdGisjjI=
X-Google-Smtp-Source: ABdhPJzPSw8SSCDAmdDeisj3XI4ogQkqWtLeg/SJTAHMgDchG0LeN+UW2UZ4QQGj/C176r+0difq2Q==
X-Received: by 2002:a17:906:4d01:: with SMTP id r1mr3507510eju.471.1630667357665;
        Fri, 03 Sep 2021 04:09:17 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id p23sm2955501edw.94.2021.09.03.04.09.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Sep 2021 04:09:17 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
X-Google-Original-From: Ioana Ciornei <ciornei.ioana@gmail.com>
Date:   Fri, 3 Sep 2021 14:09:16 +0300
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Ioana Ciornei <ciorneiioana@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: dpaa2-mac: add support for more ethtool
 10G link modes
Message-ID: <20210903110916.bjjm6x3h4l4raf27@skbuf>
References: <E1m5mVT-00032g-Km@rmk-PC.armlinux.org.uk>
 <YPbU59Kmpk0NvlQH@lunn.ch>
 <20210720141134.GT22278@shell.armlinux.org.uk>
 <20210816144752.vxliq642uipdsmdd@skbuf>
 <20210903103358.GU22278@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210903103358.GU22278@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 03, 2021 at 11:33:58AM +0100, Russell King (Oracle) wrote:
> On Mon, Aug 16, 2021 at 05:47:52PM +0300, Ioana Ciornei wrote:
> > On Tue, Jul 20, 2021 at 03:11:34PM +0100, Russell King (Oracle) wrote:
> > > On Tue, Jul 20, 2021 at 03:51:35PM +0200, Andrew Lunn wrote:
> > > > On Tue, Jul 20, 2021 at 10:57:43AM +0100, Russell King wrote:
> > > > > Phylink documentation says:
> > > > >   Note that the PHY may be able to transform from one connection
> > > > >   technology to another, so, eg, don't clear 1000BaseX just
> > > > >   because the MAC is unable to BaseX mode. This is more about
> > > > >   clearing unsupported speeds and duplex settings. The port modes
> > > > >   should not be cleared; phylink_set_port_modes() will help with this.
> > > > > 
> > > > > So add the missing 10G modes.
> > > > 
> > > > Hi Russell
> > > > 
> > > > Would a phylink_set_10g(mask) helper make sense? As you say, it is
> > > > about the speed, not the individual modes.
> > > 
> > > Yes, good point, and that will probably help avoid this in the future.
> > > We can't do that for things like e.g. SGMII though, because 1000/half
> > > isn't universally supported.
> > > 
> > > Shall we get this patch merged anyway and then clean it up - as such
> > > a change will need to cover multiple drivers anyway?
> > > 
> > 
> > This didn't get merged unfortunately.
> > 
> > Could you please resend it? Alternatively, I can take a look into adding
> > that phylink_set_10g() helper if that is what's keeping it from being
> > merged.
> 
> It looks like the original patch didn't appear in patchwork for some
> reason - at least google can find it in lore's netdev archives, but
> not in patchwork. I can only put this down to some kernel.org
> unreliability - we've seen this unreliability in the past with netdev,
> and it seems to be an ongoing issue.
> 

Yes, it cannot be found though google but the patch appears in
patchwork, it was tagged with 'Changes requested'.
https://patchwork.kernel.org/project/netdevbpf/patch/E1m5mVT-00032g-Km@rmk-PC.armlinux.org.uk/


> It's now too late to re-send for this merge window - net-next is
> currently closed. Whether I remember in a fortnight or so time when
> net-next re-opens is another problem.
> 
> And yes, I also have the phylink_set_10g() patches in my tree, which
> was waiting for this patch to have been merged.
> 

Ok, thanks!

Ioana
