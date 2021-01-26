Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11D68305D47
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 14:33:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238383AbhA0Ncm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 08:32:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S313265AbhAZWeN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 17:34:13 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34609C0611BC;
        Tue, 26 Jan 2021 14:28:11 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id s11so21712719edd.5;
        Tue, 26 Jan 2021 14:28:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+dgO/DpRRBNVWm71phA7caMBgapa2l8prdi0ax2h0pM=;
        b=ruYCPXViPVKyA5CE7kkL5Uv04gOplxca4oXLlqqFqB9jj9s9KtR0m1ElgBORUAXTZr
         HUzKMdVq/By/ihHLfWHWX6W9rFToBFDb1dYT+htoYcLv0R9kWzdhS9miy0YaIX1K6Ka4
         MaKDZ1FbhkW6cUe4bWHszfI48QaxWWnUm1+QHMTbGlX0C4CpYfkHnRtLr9ncPP0bHrmg
         4iz39U3295cl2qc6l5DyBwrgmiNjad+AdHovMFIEr9uWHf8RRsMn5NTJZnJ7mOYgj1bx
         v4mxmbedlnr1orDLo9NAkiW35UflM3SfJDIMq2nRM5JN5LGNnpk7K2RZFzdE7yrcTjou
         GH9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+dgO/DpRRBNVWm71phA7caMBgapa2l8prdi0ax2h0pM=;
        b=gy7xmM/IWOGRF/YiA4a+Hknpk80KtigT0IMYHuibJgnxrQebDMUQ7WW/b1S/v7zDBY
         Pfhk1dagD2TUfQs6PmZxz/quP7WDwuN/1cVgeEALZ6cO0ODZEQRBEp0SYIfMBEuXi7So
         wm13mMfhDcCVYoNQhmTMCgV7mlbdWFTn2/8hzBymJpkMmB/owyzo/tv4WTcAit1eZVJU
         OvuCqDhLVf0yKnGP/MGbYnDsiqIspm/l/nDPnioaUZsYzC8dvcT3d4FdTy1ubxqJV4BQ
         V6thGg1uropHBhMPwt5+cErlBjNWF3lbEvVrZ9xKGIFcdMifNW4ILGSyMoFzXr1MuY+r
         QBVw==
X-Gm-Message-State: AOAM5323PxHB2CyZHq0lJ72LRFsMpcJO3E9QLZk3Gf6tPb7/nwTEkvBU
        0BMnrlFExCQJ5bB3aDCO4jN6N4s5Ygk=
X-Google-Smtp-Source: ABdhPJwcMyPl+oJH03Jpe/LND6TZJcEXfjjMW50IFcHIotUdeXFjhduzPBSt9qktgfj90ohzeGk/rw==
X-Received: by 2002:a05:6402:4242:: with SMTP id g2mr6319717edb.103.1611700089883;
        Tue, 26 Jan 2021 14:28:09 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id d5sm82563edu.12.2021.01.26.14.28.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 14:28:06 -0800 (PST)
Date:   Wed, 27 Jan 2021 00:28:05 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Lorenzo Carletti <lorenzo.carletti98@gmail.com>
Cc:     Linus Walleij <linus.walleij@linaro.org>, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] net: dsa: rtl8366rb: standardize init jam tables
Message-ID: <20210126222805.fd7pzt7zenl72mmo@skbuf>
References: <20210125045631.2345-1-lorenzo.carletti98@gmail.com>
 <20210125045631.2345-2-lorenzo.carletti98@gmail.com>
 <20210126210837.7mfzkjqsc3aui3fn@skbuf>
 <20210126213852.zjpejk7ryw7kq4dv@skbuf>
 <CABRCJOSzm6s3hv17KFXMZigJjuBEidLLAM8+dqrGk9xTE=FkcQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABRCJOSzm6s3hv17KFXMZigJjuBEidLLAM8+dqrGk9xTE=FkcQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 26, 2021 at 11:15:33PM +0100, Lorenzo Carletti wrote:
> > And did you manage to find out what these tables actually do?
>
> I was unable to do so. I was looking for Intel 8051 instructions in them:
> I created a small piece of code that generates an hypotetical
> registers space in which the tables are then jammed, but I didn't
> find anything.
> It's clear that some of the values of the tables are configuration
> parameters for stuff like the bandwidth, but that's the extent of what
> I was able to understand... So not that much.
>
> > Why? What difference does it make?
>
> So, allow me to explain. The kernel jams every "i + 1" value in the array
> tables into the registers at " i", and then increments "i" by 2.
> These can be seen as [n][2] matrixes, just like the ethernet one.
> Having the arrays converted to matrixes can help visualize which
> value is jammed where, or at least that's how I feel like it is.
> I know it's not a big change...

Got it, thanks. It is better, in fact, once you get over that whole
0xBE00 thing...

> > On which RTL8366RB chip revisions did you test for regressions?
>
> I don't have any of the chips to test this. What I agreed on with
> Linus Walleji was to send the patch after making sure everything
> compiled properly and checkpatch was happy with what I produced.
> Once the patch was sent, he said he'd test it.
> I ran some simulations, but that's pretty much it. I know those
> are not enough, so I'm waiting as well.

It is probably a safe change as it is, if you ran some simulations and
the same values at the same register addresses are jammed before and
after, it should be fine. The code looks okay.
