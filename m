Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B15881B63D2
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 20:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730311AbgDWSa6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 14:30:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730210AbgDWSa5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 14:30:57 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8660BC09B043
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 11:30:57 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id i68so5713954qtb.5
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 11:30:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=j6vx62T0cUnGorC7bQl2F/WmrnGQGNIQf7tVvJs2alQ=;
        b=kINT/mL8BJANHc3utJboA7e++/E97u13tPbXwtZsXtg6xIZbI5o2ksqDU5FSEo8bMC
         WJJy03Eds1xqsDhuQaNN7ZJ1OwSiDAyzlx09E46h2cGtcUDY/ee3NfpM2p1mrhQxt6OL
         I5QRMV/LAHoUyHa92JzJMMvJp9DOZQbzoPLAy9391WCI3Tz/VdW4Zr780p8+DFy0luYO
         9NwRigT3BcYhbsoyhXfPbCjT+zrv0gfeXNDOKdcxiXBalV9FUmGnC47UXg+0uTuUoHN1
         qk115iMNzVbf637wm1kzra4h5nRq9knmOGSwMcU21hWhXtDXf9kspo6ipjy0DcmoaJa1
         Tdvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=j6vx62T0cUnGorC7bQl2F/WmrnGQGNIQf7tVvJs2alQ=;
        b=jJ7BpkltMYcbxGLvv42hmEGHhVRTpptcoaoSeGJEojJZRz4oh1fvi6bkMngC3n0skx
         xS/SU46WFLc+5sTSWmJUsiHeWSS2eajRYM/7CoCR3EY07Pzp/GJB5OgyztO4D0mpbxUt
         m/tc3uwCTm2xE0EpsDPJgikXtPEk5NNnR5+43Vp67kxTfNUwQib0D6WeQEsToJTsA4IJ
         HvBj2W/rmrXW456LaWy+PXNQlU4kYxLI0POoyCLJd/AI8x+faHawsKzLRldAn/JEJ0+0
         xHf0B4TrkFWoBJ6hwFWpMCT6XOxhBDc9yM6hfqnCdzs9TiTmqj3DpTzW7NS33TwQEiV+
         lXuA==
X-Gm-Message-State: AGi0PuYGyLjj0MfbP1kqZS2sWrQoVORDmO4AgCb2RvHDYBO9vtDuRJbX
        KVFWSlWHMYnKIILX0zDIF2CKZA==
X-Google-Smtp-Source: APiQypKLmzIW/Ecao7idLzoJvjbffCPalu3gsWoeTzATgTxGBLsgz+Rj9v35dLweYr3CVQ7GCZwp4w==
X-Received: by 2002:aed:2b43:: with SMTP id p61mr5464265qtd.298.1587666656655;
        Thu, 23 Apr 2020 11:30:56 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id s8sm723438qtb.0.2020.04.23.11.30.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 23 Apr 2020 11:30:56 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jRgch-0006EC-Bq; Thu, 23 Apr 2020 15:30:55 -0300
Date:   Thu, 23 Apr 2020 15:30:55 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Nicolas Pitre <nico@fluxnic.net>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "masahiroy@kernel.org" <masahiroy@kernel.org>,
        "Laurent.pinchart@ideasonboard.com" 
        <Laurent.pinchart@ideasonboard.com>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jernej.skrabec@siol.net" <jernej.skrabec@siol.net>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jonas@kwiboo.se" <jonas@kwiboo.se>,
        "kieran.bingham+renesas@ideasonboard.com" 
        <kieran.bingham+renesas@ideasonboard.com>,
        "narmstrong@baylibre.com" <narmstrong@baylibre.com>,
        "leon@kernel.org" <leon@kernel.org>
Subject: Re: [RFC PATCH 1/2] Kconfig: Introduce "uses" keyword
Message-ID: <20200423183055.GB26002@ziepe.ca>
References: <62a51b2e5425a3cca4f7a66e2795b957f237b2da.camel@mellanox.com>
 <nycvar.YSQ.7.76.2004211411500.2671@knanqh.ubzr>
 <871rofdhtg.fsf@intel.com>
 <nycvar.YSQ.7.76.2004221649480.2671@knanqh.ubzr>
 <940d3add-4d12-56ed-617a-8b3bf8ef3a0f@infradead.org>
 <nycvar.YSQ.7.76.2004231059170.2671@knanqh.ubzr>
 <20200423150556.GZ26002@ziepe.ca>
 <nycvar.YSQ.7.76.2004231109500.2671@knanqh.ubzr>
 <20200423151624.GA26002@ziepe.ca>
 <nycvar.YSQ.7.76.2004231128210.2671@knanqh.ubzr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <nycvar.YSQ.7.76.2004231128210.2671@knanqh.ubzr>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 23, 2020 at 11:33:33AM -0400, Nicolas Pitre wrote:
> > > No. There is no logic in restricting MTD usage based on CRAMFS or 
> > > CRAMFS_MTD.
> > 
> > Ah, I got it backwards, maybe this:
> > 
> > config CRAMFS
> >    depends on MTD if CRAMFS_MTD
> > 
> > ?
> 
> Still half-backward. CRAMFS should not depend on either MTD nor
> CRAMFS_MTD.

Well, I would view this the same as all the other cases.. the CRAMFS
module has an optional ability consume symbols from MTD.  Here that is
controlled by another 'CRAMFS_MTD' selection, but it should still
settle it out the same way as other cases like this - ie CRAMFS is
restricted to m if MTD is m

Arnd's point that kconfig is acyclic does kill it though :(

> It is CRAMFS_MTD that needs both CRAMFS and MTD.
> Furthermore CRAMFS_MTD can't be built-in if MTD is modular.

CRAMFS_MTD is a bool feature flag for the CRAMFS tristate - it is
CRAMFS that can't be built in if MTD is modular.

Jason
