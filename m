Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 940DA41EBFE
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 13:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353944AbhJALex (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 07:34:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353928AbhJALev (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 07:34:51 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 703FDC061775;
        Fri,  1 Oct 2021 04:33:07 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id bd28so33518314edb.9;
        Fri, 01 Oct 2021 04:33:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uG+FsR2ZVaMG3D4Jjpme5SqiABkN8ahayf8+njWuNAo=;
        b=DIroYdYJEOYNDXDEnLbwozDObDvQNaLsQyIpMmEZn8wJG/7pyhfssFPZIdk8dBhJLw
         L83TPGomwElibS8tLrN+rBWmbT/7pbhWiHsO8NFxHJoVKq0V1MF0Xa8lcCUCzn7nVdvS
         LpQJFEXXTIGjQv1WyRKY066uWfS82J86ZKQ9DYWa7ctxdh0WbOlh0IwQz+BQE7h36+/A
         2AvCdBjmzGNR1gR8XQkqEmtiogEM7BExNfYIKnTnDwItHws2p2/WIw/XvDHRIMXSDF/f
         tU3/DBG6QsKv2fawYPWrCXTNqxLpiOeoazRZf/HUDLIv0Q797c7ahPVSXOInZzcw9GAy
         9GbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uG+FsR2ZVaMG3D4Jjpme5SqiABkN8ahayf8+njWuNAo=;
        b=JAY0VXcBd0JSlwNWjwmbHmmOQ/n20xtUA22SfLzL28qADALbTbkVZJrVAKNFmuncom
         dvCk5kW8zPJtH/KbSxZ7fBJTyx8Fiwb29kxCMv0wTJxkWyMNbLhCWfYqOKd02duyz6BI
         EdY6+TNyyMn0JOnFYXaUuNJb57yxsRtgT0MeliGtFb3+Ugz+Phtsv/KE7vN2FA1GBmDB
         8K3LKLpzjW/6TInwJw1KaL/wbKAQCLRVlJfBA3qBKCBpLE5Lj0Wn+6a0M63ZXZr6f0DF
         ZLq62GslmBPNv19xYaHExRSzwJOnisf9SnYJuDjGKRQVOJkEjzGjUfs0093MN6GAlzsR
         mx5w==
X-Gm-Message-State: AOAM530cnak2mEGB+6MHOlG2BlD1ltm1inWgutOlGQuI2Sop+vCEWEMX
        ZLO8+8cmtN1ODFp4CDpyfoM=
X-Google-Smtp-Source: ABdhPJxxp9CKTeo2biWhd1LMMk5iS/VKrfUd78iBEIrt2EuMenBZS3wHX175OW4dPepbZbHl0FXMiQ==
X-Received: by 2002:a17:906:60c3:: with SMTP id f3mr5419778ejk.561.1633087985724;
        Fri, 01 Oct 2021 04:33:05 -0700 (PDT)
Received: from skbuf ([188.26.53.217])
        by smtp.gmail.com with ESMTPSA id n23sm3087091edw.75.2021.10.01.04.33.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 04:33:05 -0700 (PDT)
Date:   Fri, 1 Oct 2021 14:33:04 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next] drivers: net: dsa: qca8k: convert to
 GENMASK/FIELD_PREP/FIELD_GET
Message-ID: <20211001113304.bxuhsavgvl5xny2m@skbuf>
References: <20211001013729.21849-1-ansuelsmth@gmail.com>
 <91eb5d7e-b62c-45e6-16a3-1d9c1c780c7b@gmail.com>
 <YVbqbq180jgrhiIe@Ansuel-xps.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YVbqbq180jgrhiIe@Ansuel-xps.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 01, 2021 at 01:01:02PM +0200, Ansuel Smith wrote:
> On Thu, Sep 30, 2021 at 07:14:13PM -0700, Florian Fainelli wrote:
> > 
> > 
> > On 9/30/2021 6:37 PM, Ansuel Smith wrote:
> > > Convert and try to standardize bit fields using
> > > GENMASK/FIELD_PREP/FIELD_GET macros. Rework some logic to support the
> > > standard macro and tidy things up. No functional change intended.
> > > 
> > > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > > ---
> > > 
> > > I still need to test this in every part but I would like to have some
> > > approval about this kind of change. Also there are tons of warning by
> > > checkpatch about too long line... Are they accepted for headers? I can't
> > > really find another way to workaround the problem as reducing the define
> > > name would make them less descriptive.
> > > Aside from that I did the conversion as carefully as possible so in
> > > theory nothing should be broken and the conversion should be all
> > > correct. Some real improvement by using filed macro are in the
> > > fdb_read/fdb_write that now are much more readable.
> > 
> > My main concern is that it is going to be a tad harder to back port fixes
> > made to this driver with such changes in place, so unfortunately it is
> > usually a matter of either the initial version of the driver use BIT(),
> > FIELD_{PREP,GET} and GENMASK, or the very few commits following the initial
> > commit take care of that, and then it is all rosy for everyone, or else it
> > may be complicated.
> > 
> > You are one of the active contributors to this driver, so ultimately you
> > should decide.
> > -- 
> > Florian
> 
> Problem I'm trying to solve here is that I notice various name scheme
> used and not an unique one... (many _S and _M mixed with MASK and SHIFT)
> Various shift and strange bits handling. I think this is needed to
> improve the code in all the next release.
> About backports you mean for older kernel (bugfixes)

this

> or for external project (backports for openwrt, for example?) Anyway
> in the main code (the one in theory that should receive backports) I
> just reworked the ACL code that should be stable and the switch ID
> handling (I don't think there is anything to fix there).

Famous last words :)

> Aside from that and some improvement to VLAN, I tried to implement
> FIELD_PREP only in the define without touching qca8k code. 
> I honestly don't know if this would cause that much of a problem with
> backports (assuming they only touch qca8k code and not header).
> Would love to receive some feedback if I'm wrong about my idea.
> Any feedback about the warning for long names in the define? Are they
> accepted? I can't find anywhere how we should handle them.

While it does look pretty ugly, and you could perhaps split them like
this:

#define QCA8K_VTU_FUNC0_EG_MODE_PORT_MASK(_i) \
	(GENMASK(1, 0) << QCA8K_VTU_FUNC0_EG_MODE_PORT_SHIFT(_i))

it's more or less a judgement call, I've seen worse in a header file,
and exceeding a certain line length is certainly not among the worst of
sins - putting complex control flow logic inside the C preprocessor
would take that place, I think.

Anyway, Florian's point is that you're touching up the following
functions:

qca8k_port_vlan_filtering
qca8k_port_vlan_add
qca8k_read_switch_id
qca8k_setup
qca8k_vlan_del
qca8k_vlan_add
qca8k_vlan_access
qca8k_fdb_access
qca8k_fdb_write
qca8k_fdb_read

quite gratuitously, but this is another judgement call for you to make.
The only thing you should consider is that future you might hate you for
giving him extra work when a new bug in those functions is discovered.
You'll have to prepare a fix patch that applies on the refactored code,
to submit to the "net" tree, and and a fix patch that applies to the
pre-refactoring code, to submit to the "stable" tree directly.

As a proponent of code cleanups myself, I would still choose to do the
refactoring, but just be aware that it doesn't come for free.
