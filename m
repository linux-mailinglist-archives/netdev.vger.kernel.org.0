Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA4064567C6
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 03:02:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232046AbhKSCFp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 21:05:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbhKSCFo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 21:05:44 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E028CC061574;
        Thu, 18 Nov 2021 18:02:43 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id e3so35804912edu.4;
        Thu, 18 Nov 2021 18:02:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=yn4YIsFOgcqLSDskvyS6o6i32vX9wcbEQJKMw7jEbvY=;
        b=qBSe3n9PbtKq8vwCjwxzPR9JCQfNAdJukQLFEMMbQjcJ+7KPMvJdP7MsCLTlXGL1IR
         85DClaI6sg9tJoybrCcbqOUxcxL/oYTfpMp8Ahi3OwDXsrkbC5Hgaow8CV8OPwaIyk9Y
         7vD7wJQKZQ2QAiVFNcNrW0PVaS3Wy9TdjNWJ9a5OGZ/2C3TDRXQWUjJx8CuTW1FnaPz+
         pmoXLSNAmrX6JTWPLoebCgDUV4pu8JNL3wH8xs1kXrLDloexYBo1nd9Pe5pcZzcY/Cdv
         /hcP0dakfNxQcWrlarF2eDR5Tcv9jJCUPnJoWtuL7J1YaQx/Hi5otk9z0jBv4R8t6V7j
         pcFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=yn4YIsFOgcqLSDskvyS6o6i32vX9wcbEQJKMw7jEbvY=;
        b=T0nvbsphRuhP9qhbvSEmUaeQ6/q1E6nkY2FEeeiLXrjcD3PHFARpLBqk6PvDXM9nGs
         ENr/21D/8hP9I2SH3q9Vw7s8g9Dwg9uVXjYBfWxltJgBl1hifQNAzpnUHv6IGvbjKgzV
         Q4woKl2RnDUA9uvVVB34/mJF/5BskPKXp81UMWAnOfVSUEJURjScSyJuUiM4pAFcefIu
         CmdBf730ru3RxBTi8nBRmerzmehUR5xTcIHcfhY7wzNGcPwfIh5SVS377fotnmBGGxPB
         mbAFKfLtMm11gLSQtRrepl8toa557ycwcxlaoJhE8nWB1ap1d6c4AIHYFK+R5uHdoJWc
         oEJQ==
X-Gm-Message-State: AOAM532Gqbsd9W4BzLD7opMjYLkSwD5urPL6HbMrq1kOo1klZcQSYSBf
        ojKcTVkYRyr6TUF6IqxcgRs=
X-Google-Smtp-Source: ABdhPJxLByV3lQ01vz10QQS8zvX/gMAxWxnwkM0wOUOQGRkprrXXBabFxnw2imQ/3Kwq54Crwf3U3Q==
X-Received: by 2002:a05:6402:34d6:: with SMTP id w22mr18650324edc.35.1637287362288;
        Thu, 18 Nov 2021 18:02:42 -0800 (PST)
Received: from Ansuel-xps. (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id gt18sm546909ejc.88.2021.11.18.18.02.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 18:02:42 -0800 (PST)
Message-ID: <619705c2.1c69fb81.ba160.2a40@mx.google.com>
X-Google-Original-Message-ID: <YZcFRV/wkMhsbIPh@Ansuel-xps.>
Date:   Fri, 19 Nov 2021 03:00:37 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Mark Brown <broonie@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: regmap: allow to define reg_update_bits for no bus configuration
References: <20211117210451.26415-1-ansuelsmth@gmail.com>
 <20211117210451.26415-2-ansuelsmth@gmail.com>
 <YZV/GYJXKTE4RaEj@sirena.org.uk>
 <61958011.1c69fb81.31272.2dd5@mx.google.com>
 <YZWDOidBOssP10yS@sirena.org.uk>
 <20211118175430.226ca5da@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211118175430.226ca5da@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 18, 2021 at 05:54:30PM -0800, Jakub Kicinski wrote:
> On Wed, 17 Nov 2021 22:33:30 +0000 Mark Brown wrote:
> > On Wed, Nov 17, 2021 at 11:19:39PM +0100, Ansuel Smith wrote:
> > > On Wed, Nov 17, 2021 at 10:15:53PM +0000, Mark Brown wrote:  
> > 
> > > > I've applied this already?  If it's needed by something in another tree
> > > > let me know and I'll make a signed tag for it.  
> > 
> > > Yes, I posted this in this series as net-next still doesn't have this
> > > commit. Don't really know how to hanle this kind of corner
> > > case. Do you have some hint about that and how to proceed?  
> > 
> > Ask for a tag like I said in the message you're replying to:
> > 
> > The following changes since commit fa55b7dcdc43c1aa1ba12bca9d2dd4318c2a0dbf:
> > 
> >   Linux 5.16-rc1 (2021-11-14 13:56:52 -0800)
> > 
> > are available in the Git repository at:
> > 
> >   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git tags/regmap-no-bus-update-bits
> > 
> > for you to fetch changes up to 02d6fdecb9c38de19065f6bed8d5214556fd061d:
> > 
> >   regmap: allow to define reg_update_bits for no bus configuration (2021-11-15 13:27:13 +0000)
> > 
> > ----------------------------------------------------------------
> > regmap: Allow regmap_update_bits() to be offloaded with no bus
> > 
> > Some hardware can do this so let's use that capability.
> 
> Pulled into net-next, thanks Mark!
> 
> Ansuel, please make sure to post fewer than 15 patches at a time.

Thx for the merge. Ok will split the series, sorry. It was really to
get some idea about the regmap and split changes.

-- 
	Ansuel
