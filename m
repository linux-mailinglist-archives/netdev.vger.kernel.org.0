Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45DAA344D20
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 18:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232021AbhCVRTj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 13:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230198AbhCVRTa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 13:19:30 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96325C061574;
        Mon, 22 Mar 2021 10:19:29 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id h10so20275703edt.13;
        Mon, 22 Mar 2021 10:19:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=obigrzeRlsxyJhJGxEn25zyUrKSr2P3Xsf8Amp4vU2M=;
        b=Tcqn6nVvfDHtgGKcSsiX0pdtAFdlCWdVWYDk/RZY73UZnRkciiALmC+s0vooIWhdyZ
         HD+atSXNViZpFJITvEUePWBumO+sa4oW6XERPZD5XlPuU/maho611olKR8sSkiioTpIr
         cR3z36CG/VF/+JyyCnbP6PrPUJkqv4uvayontO9R/ip+YU2jmTHXOtXzvCH6Loxz5w9s
         mQX8V6JCj+3Iv1iFtYpKVqUkK1VXtYIcZisxLCEbdvSwkq60dj4gDVcFf1CrToYDECF3
         8d8ThoT36sdgneXN+0vNbrTcbgW7BjLwLHewv9kTAxinrGC8elKCwFhH+/Lr5bq2wp9+
         Bcyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=obigrzeRlsxyJhJGxEn25zyUrKSr2P3Xsf8Amp4vU2M=;
        b=PCoqpqsKigArwPO/Ef55AxTDYHjlxdu00FjUJ4443125pj301PFeqHUDd/sgn0l3Tv
         1eW4qToz0xVJGOvnEivYXNY7Ih5Uz48zjrg9kZQN2mOO2Aq1Z328sHFsS9jt4YxUWYk0
         8nUhvmDeeKBIF1ReOGO8FdSDmz4GvBPrloFlFpcRYHNq9/pi7olDqkFGLw/V6xdw9SU4
         dEzUtZTJbFQT2XraDENIkfsbNvg91MeVsW4S75TKpujkzirBL/eGzMYEGMz403DwNH/I
         M2JLlDxWdYtkQbtomo/A5KOONKzjQ1WL2p4ksP4yO57Qmg6Xe3sEgivLKgMB3GEg7Nte
         2Tig==
X-Gm-Message-State: AOAM531X+SHA1AzGc/ByvGWKUVKlK8g9TeXp21TottCPBWYq+q+OgMIL
        qg4oNq9oLCzETvv8k2eRiNM=
X-Google-Smtp-Source: ABdhPJzBtQbPZaMBPwvpsqTOGHK79IKL6SlqJBghC5TY+3Akmc2NG5gnfmhIpCZhFvvpkjW0/ZLpmg==
X-Received: by 2002:a05:6402:34c4:: with SMTP id w4mr636417edc.367.1616433568335;
        Mon, 22 Mar 2021 10:19:28 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id bj7sm10332818ejb.28.2021.03.22.10.19.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 10:19:27 -0700 (PDT)
Date:   Mon, 22 Mar 2021 19:19:26 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [RFC PATCH v2 net-next 16/16] net: bridge: switchdev: let
 drivers inform which bridge ports are offloaded
Message-ID: <20210322171926.hgfl2d6pxxxwmsts@skbuf>
References: <20210318231829.3892920-1-olteanv@gmail.com>
 <20210318231829.3892920-17-olteanv@gmail.com>
 <87r1k7m9qb.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r1k7m9qb.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 22, 2021 at 05:30:52PM +0100, Tobias Waldekranz wrote:
> > ---
> >  .../ethernet/freescale/dpaa2/dpaa2-switch.c   |  4 +-
> >  .../marvell/prestera/prestera_switchdev.c     |  7 ++
> >  .../mellanox/mlxsw/spectrum_switchdev.c       |  4 +-
> >  drivers/net/ethernet/mscc/ocelot_net.c        |  4 +-
> >  drivers/net/ethernet/rocker/rocker_ofdpa.c    |  8 +-
> >  drivers/net/ethernet/ti/am65-cpsw-nuss.c      |  7 +-
> >  drivers/net/ethernet/ti/cpsw_new.c            |  6 +-
> 
> Why is not net/dsa included in this change?

I don't know, must have went shopping somewhere?
I'll make sure DSA is included in this change when I resend.
