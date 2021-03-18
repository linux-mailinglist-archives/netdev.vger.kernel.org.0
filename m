Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB9F340AE3
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 18:04:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232223AbhCRREH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 13:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232209AbhCRREE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 13:04:04 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46E9FC06174A;
        Thu, 18 Mar 2021 10:04:04 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id b9so5089483ejc.11;
        Thu, 18 Mar 2021 10:04:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kGBtG1asT+naathIVeBKnaUsxi5B/fID3cTEy5mBPQc=;
        b=c55hPvdd9epsvt7PhGitWFoldT52U22Ug5HNzDN/T7es7oYY/lCHk1pFBDWOFODTYm
         REywWd9SShikMMSVPlNYVqYx/A92vbr0ojKSNoxL0pAQ/OEjgFjtLuXnPRDEh11fQBhR
         NMcpOJlRB88B+Ln2gXSNe9zec64PmLQImVVTDn1Ou+dsI1HO4hoUrQ/i/tDX52eTk4GV
         OFQoikJ6Z61V4wqOl36HiExDQVBZSQf1JVCjrM9Qwb+YuN1vT6sij1Z7GmLe96VXdoIE
         I+KKHQqpz7yKffNssmUnkhwVSPaAe3lszzLxchYV0nrpz1XMgQP7s9aVEpuskjqlOeGg
         8cIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kGBtG1asT+naathIVeBKnaUsxi5B/fID3cTEy5mBPQc=;
        b=bT0DjZ1wr5/N7vMxX4oq2AAbos3/rahpiP0OFh1woZ8M7Iy7EpfnRAmdrk5OxZmHjv
         meGVdsTLhDjHiZGoaJiqk84bTDp/LwXvOOP94vDAQTsDiPLjOO2+n1wF1uxu+9XgU/qk
         8j7kyGGuzUZtJWtXDIp735ApnHtkoagDInd4CyH5ts9bG2MFDimW7wS6kp/zz6I6/5dP
         0nDT0h3e9g4YBkkZEXbxJvmkdoBxqah3Cbw4SaVC11nvFtLtsxbM2xSAzL+E5dkOJdAx
         aRPk61UGNfAnosm/tjkM9U77HtAM8nxAsxtwo8uXVB1h10ifKvgfI+ph57trGe2pMhCW
         tfCQ==
X-Gm-Message-State: AOAM530FH2aksY0RBQ2GU9MT9zbUs61AWJR0o4tLwduc3hPV6RoCNTqF
        SoXKXqWPD2nkQYqOZBIGtcc=
X-Google-Smtp-Source: ABdhPJxSLLaNIMAQ4v8UXlcygmjrzAvNeQO8iiZ+xrX3sa3p58SRwiKRsYlJBx/bTC/Mi9+08DREZg==
X-Received: by 2002:a17:906:d9c9:: with SMTP id qk9mr41349939ejb.504.1616087042982;
        Thu, 18 Mar 2021 10:04:02 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id v1sm2191787ejd.3.2021.03.18.10.04.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 10:04:02 -0700 (PDT)
Date:   Thu, 18 Mar 2021 19:04:01 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Michael Walle <michael@walle.cc>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: phy: at803x: remove at803x_aneg_done()
Message-ID: <20210318170401.mvvwryi7exouyrzy@skbuf>
References: <20210318142356.30702-1-michael@walle.cc>
 <411c3508-978e-4562-f1e9-33ca7e98a752@gmail.com>
 <20210318151712.7hmdaufxylyl33em@skbuf>
 <ee24b531-df8b-fa3d-c7fd-8c529ecba4c8@gmail.com>
 <ae201dadd6842f533aaa2e1440209784@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae201dadd6842f533aaa2e1440209784@walle.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 18, 2021 at 05:38:13PM +0100, Michael Walle wrote:
> Am 2021-03-18 17:21, schrieb Heiner Kallweit:
> > On 18.03.2021 16:17, Vladimir Oltean wrote:
> > > On Thu, Mar 18, 2021 at 03:54:00PM +0100, Heiner Kallweit wrote:
> > > > On 18.03.2021 15:23, Michael Walle wrote:
> > > > > at803x_aneg_done() is pretty much dead code since the patch series
> > > > > "net: phy: improve and simplify phylib state machine" [1].
> > > > > Remove it.
> > > > >
> > > >
> > > > Well, it's not dead, it's resting .. There are few places where
> > > > phy_aneg_done() is used. So you would need to explain:
> > > > - why these users can't be used with this PHY driver
> > > > - or why the aneg_done callback isn't needed here and the
> > > >   genphy_aneg_done() fallback is sufficient
> > >
> > > The piece of code that Michael is removing keeps the aneg reporting as
> > > "not done" even when the copper-side link was reported as up, but the
> > > in-band autoneg has not finished.
> > >
> > > That was the _intended_ behavior when that code was introduced, and
> > > you
> > > have said about it:
> > > https://www.spinics.net/lists/stable/msg389193.html
> > >
> > > | That's not nice from the PHY:
> > > | It signals "link up", and if the system asks the PHY for link details,
> > > | then it sheepishly says "well, link is *almost* up".
> > >
> > > If the specification of phy_aneg_done behavior does not include
> > > in-band
> > > autoneg (and it doesn't), then this piece of code does not belong
> > > here.
> > >
> > > The fact that we can no longer trigger this code from phylib is yet
> > > another reason why it fails at its intended (and wrong) purpose and
> > > should be removed.
> > >
> > I don't argue against the change, I just think that the current commit
> > description isn't sufficient. What you just said I would have expected
> > in the commit description.
>
> I'll come up with a better one, Vladimir, may I use parts of the text
> above?

My words aren't copyrighted, so feel free, however you might want to
check with Heiner too for his part, you never know.
