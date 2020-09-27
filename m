Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF0C6279D45
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 03:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728580AbgI0BLg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 21:11:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726587AbgI0BLg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Sep 2020 21:11:36 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA241C0613CE
        for <netdev@vger.kernel.org>; Sat, 26 Sep 2020 18:11:35 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id n22so6313792edt.4
        for <netdev@vger.kernel.org>; Sat, 26 Sep 2020 18:11:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HQzmZKvS0gNE1SOV3Y2oYCdf0r/uPBvBDzxKle75xlo=;
        b=ZpREMCx4A/EIi4k6lMR9hzPYSsYjDawFCjaRWnTs0wydHgUDpg9HVVa/eDRpGCILeF
         vLXxqBZ95DkSfEefgRuEPjqAeDQ4M+tSkt3BsqDbvffnn5fniDK0C8mVcevl55ZBeD+x
         GBNtivBevVMRfmZJkzyz0DHjMKgebTDCM6j+84lCH73BdjYcijAmUL36gtkS83JLTZMv
         9DITK8F5+swhL03PVeVfC+mkLXVgb+7q6Izg042tCx3JMEb6AIltuLYkbDsim9DbUvV/
         qRQw1e9EM4JRaNKES+2qjx9zaZNqYi4hXG0o9G2U6chM/zF2E9OUli2h41xzfMiv/df/
         rcyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HQzmZKvS0gNE1SOV3Y2oYCdf0r/uPBvBDzxKle75xlo=;
        b=U5JBOFOzrAq74IVoLivslBSz+hziFGZSg8B8OIMP/iq4i596sUj1SpNr+zoMWeRMIE
         CfWCSLi70116eCfqGG1mjp88EYtCE3Y6VNPIEkGY7hwi5AHmCEzeBfv1nW42Dczkas8X
         uXZ4X+PMN/T09f9pMyJgGtV5XdV1C1+VuqTUeBsRrj8GUs5jIcqQqIJuYmFcsMaowhsT
         4HHtq8/lufKnTh6reCPRFUuBFIMGYoVW3bdGt/YGg0MeDTgFjv1HyiKbNjknL+OSG/bQ
         tIEtOQKk6Z4Q3n+nF/1rpoGdU1jFAd/0KVEQyvk2Uq18uiJ3N+8dsPB9YjG07RlBaWh6
         5ILg==
X-Gm-Message-State: AOAM533KKE3obnME0wtsyG6cVkvw63ZDpEpUQTyLsjckMS4v9p+D1Vtz
        aNyizGQ//Q3XItkU5xvizOY=
X-Google-Smtp-Source: ABdhPJyLVW1p9NCriMM4DR7WtKkyED/r2SFNcEY7GfyRU/z2+I2/oBY+3AgGd1IDOT9+uzdxTB4rug==
X-Received: by 2002:a05:6402:3075:: with SMTP id bs21mr8942265edb.236.1601169094360;
        Sat, 26 Sep 2020 18:11:34 -0700 (PDT)
Received: from skbuf ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id o6sm5736810edh.40.2020.09.26.18.11.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2020 18:11:33 -0700 (PDT)
Date:   Sun, 27 Sep 2020 04:11:31 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next v2 7/7] net: dsa: mv88e6xxx: Add per port
 devlink regions
Message-ID: <20200927011131.56ol5vlldq3yttmr@skbuf>
References: <20200926210632.3888886-1-andrew@lunn.ch>
 <20200926210632.3888886-8-andrew@lunn.ch>
 <20200926235246.sk6jmeqdrd5oivj4@skbuf>
 <20200927010300.GD3889809@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200927010300.GD3889809@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 27, 2020 at 03:03:00AM +0200, Andrew Lunn wrote:
> > I was meaning to ask this since the global regions patchset, but I
> > forgot.
> >
> > Do we not expect to see, under the same circumstances, the same region
> > snapshot on a big endian and on a little endian system?
>
> We have never had any issues with endinness with MDIO. PHY/DSA drivers
> work with host endian. The MDIO bus controller does what it needs to
> do when shifting the bits out, as required by class 22 or 45.
>
> netlink in general assume host endian, as far as i know. So a big
> endian and a little endian snapshot are going to be different.

If the binary form of the snapshot is supposed to be consumed and done
with immediately after the netlink communication is over, sure. But it
is presented to the user, and in fact this is even the way it is
presented by default, with devlink, there's no pretty-printing.

> Arnd did an interesting presentation for LPC. He basically shows that
> big endian is going away, with the exception of IBM big iron. I don't
> expect an IBM Z to have a DSA switch!

Tell that to my T1040 chip with an 8-port Seville switch driven by the
Ocelot driver.

Also, armv8 can also boot in big-endian mode.
