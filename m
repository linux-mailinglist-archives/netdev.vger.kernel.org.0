Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59E393F6881
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 19:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240323AbhHXR7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 13:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235557AbhHXR7A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 13:59:00 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BB6CC061151;
        Tue, 24 Aug 2021 10:37:18 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id dm15so7853499edb.10;
        Tue, 24 Aug 2021 10:37:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=96yzP4yz3JLzphy1QSUobmPAufme29yUUfQ0C0CWToI=;
        b=NG9DD7VYMrDSJ8MYlV0FkIB2v8q1mKFjZfj05Nnk5ESWT8HhHTyUVAsYFevs9IkNyL
         JXo9XP59AbbNqAIxp//KozFSIgv51nkiWoumTWAAW6RPwtS07R6ZZSyAgoKNQJCDQT8Y
         j4esFUzW0qFGXQOFh0Lk5hsP/Hw03KRWV9bgSUve1FL44AQXGAWJaHecZ7XLI1lv6DdL
         qpoECFR709R1Gcr6tsSeFWDqZ27mJOnxSKYf6jSJ2QYoWQ+E5Aa20lb1wU8hk/GU0XFV
         Wo7TjZpNxBx/5kFTSkZtLF66PTUz9W80O5SXRZg3HeXw6mEQXXe1deskGa2qb6/gz5+J
         Mh0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=96yzP4yz3JLzphy1QSUobmPAufme29yUUfQ0C0CWToI=;
        b=UknWO3hY0DE/wgwhpJq6EwJolokFHPR5w9x7+GtAD8g5qgij/evVv64VkJ+cKDvzdy
         UYA3Oj+iJ4bxgNCWCcZ6TQeSBsr7+k7AeLoSgQqZAXD+RTw3BotSdhngFh1ayuq6MO/G
         i6Olcx2xlFDNmR9yZEeD7ADQzGUmPqWM0pk/MaHQdb2GhaLysqCrTl/U0JVIt2+h0dzb
         T33KEZm7rx0B6SVl1eoagx6De4AaDh4tw8pxajEX+Z/PHSvdkoc3cr+rpr848Xa6h8WZ
         f8/JFBe+NTLXPYno9+Lt9eEACTMb24l5UYjmvhI7FQb1/fM2lJHrubYFwJ+0IaaQBAln
         oU/Q==
X-Gm-Message-State: AOAM532DYl5G+TFylX/yzWcxLzlStxSGvUztjGH9aQfiymQ9byMKKHza
        mvrXZJCIRtoW48V+WKkUtNg=
X-Google-Smtp-Source: ABdhPJzA9v8OaCPg4dfXbckH5OLHW+S0cfVd3W/bRRrUZfgwkih0AjV5JuTsER9E1AEn0bGG9WU7dg==
X-Received: by 2002:aa7:c94c:: with SMTP id h12mr25211234edt.378.1629826636863;
        Tue, 24 Aug 2021 10:37:16 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id p5sm9549629ejl.73.2021.08.24.10.37.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 10:37:16 -0700 (PDT)
Date:   Tue, 24 Aug 2021 20:37:14 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>,
        "open list:MEDIATEK SWITCH DRIVER" <netdev@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: dsa: mt7530: manually set up VLAN ID 0
Message-ID: <20210824173714.cgpt2addxyjzlbyy@skbuf>
References: <20210824165253.1691315-1-dqfext@gmail.com>
 <20210824165742.xvkb3ke7boryfoj4@skbuf>
 <20210824173237.1691654-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210824173237.1691654-1-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 25, 2021 at 01:32:37AM +0800, DENG Qingfang wrote:
> On Tue, Aug 24, 2021 at 07:57:42PM +0300, Vladimir Oltean wrote:
> > I understand that this is how you noticed the issue, but please remember
> > that one can always compile a kernel with CONFIG_VLAN_8021Q=n. So the
> > issue predates my patch by much longer. You might reconsider the Fixes:
> > tag in light of this, maybe the patch needs to be sent to stable.
>
> Okay. So the Fixes tag should be 6087175b7991, which initially adds the
> software fallback support for mt7530.

Ok. Did the old code not need VLAN 0 for VLAN-unaware ports, or are you
saying that since the VLAN table lookup was bypassed completely in the
old code, 'no VLAN 0' was an inconsequential error?

I think it's the latter. Just wanted to make sure. So that means, either
this Fixes: tag or the other, the patch still belongs to net-next. From
my side you shouldn't need to resend.

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

> > > +static int
> > > +mt7530_setup_vlan0(struct mt7530_priv *priv)
> > > +{
> > > +	u32 val;
> > > +
> > > +	/* Validate the entry with independent learning, keep the original
> > > +	 * ingress tag attribute.
> > > +	 */
> > > +	val = IVL_MAC | EG_CON | PORT_MEM(MT7530_ALL_MEMBERS) | FID(FID_BRIDGED) |
> >
> > FID_BRIDGED?
>
> What's wrong with that?

Nothing, I had a senior moment and I forgot how mt7530 sets up things.
