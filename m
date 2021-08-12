Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0F33EA2E6
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 12:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236220AbhHLKRd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 06:17:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234093AbhHLKRc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 06:17:32 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55F47C061765;
        Thu, 12 Aug 2021 03:17:07 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id u3so10555340ejz.1;
        Thu, 12 Aug 2021 03:17:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QKSZMx3tYUS3bL0IF6JnGJC/q4lllMMZybPbkde8fbY=;
        b=uKS8E3WYxYhuLOuJuTONzYsxliI8X8JiM9JMzHFbTpTHKW/S23UfEzKgb63Nfq0dMc
         5VTwTGgUUTsloLIAGMIupEqq4WhD3NnG023l4d9RtwNSxiJqyFzeCLqUFchwGo0U/gXo
         BRkalXCiFJELZ0eS13IYNrdFuuUZDRT7gDITAbFZFm9fX3ZNGjixYHD3xRFCo4xqXtq7
         CReob6vyHWlZhJ8+unXnpbmqKOSCXgW+m5Pfug9dmg9tWufViCzLaP2o9mRGL2OdhxSr
         EdtXav5bsBmGero1Xk2SKjI/n28hpL0M9YcduNbD5rWbzuHh8h23f11leebnUt35XMla
         KjMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QKSZMx3tYUS3bL0IF6JnGJC/q4lllMMZybPbkde8fbY=;
        b=fPxg9g9e4On/5CHKyHDIFbKQfh4PczFrRbutkR35yaGb4x1GrmLD4N2sl6/tYBdeSQ
         kQRVA3u2gFWljSM/gt+Vp3sUoLQO7OEm4c+iFgqdIVLCMhDnaR1/utaevUS+nlOF8sHh
         6d3gysZhEAX/SPETp41i1x3Z7M9X1886jWH5fhOZ6cF//VcY9dgSG5hK0ih9Rv1ePCfG
         +fisrL7NWjLZQ152lAGiBnaMBdWoceSg381lNW8Z6yYxktaFAMsQ5DZ5Fj+jTXXWhDJ8
         HjWZlsXybShamc3LXFceSV+7gqVZR6tvb+wOCYhBpeeIKeJRtz5kFJ+7YQ5mIcyGyM6y
         CXEg==
X-Gm-Message-State: AOAM531Num3E/Fs6DZdu29S5vMjl9QKAW1g+DwJnKbOIyI6JEVLJIJ9/
        QXSfDcBHYKKeCawoPBvHhFw=
X-Google-Smtp-Source: ABdhPJw58nbLNRoQwhOvpBchfzaiXBu3AdywPlliVWiuXvXz0Km6IEDviegJ37Ul4ALHnTu55V33Ug==
X-Received: by 2002:a17:906:9b1:: with SMTP id q17mr2894045eje.546.1628763425870;
        Thu, 12 Aug 2021 03:17:05 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id q14sm898222edr.0.2021.08.12.03.17.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 03:17:04 -0700 (PDT)
Date:   Thu, 12 Aug 2021 13:17:03 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Ido Schimmel <idosch@idosch.org>, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "moderated list:ETHERNET BRIDGE" <bridge@lists.linux-foundation.org>,
        "open list:ETHERNET BRIDGE" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next] net: bridge: switchdev: allow port isolation to
 be offloaded
Message-ID: <20210812101703.lwp7y7dq6pnmnj3b@skbuf>
References: <20210811135247.1703496-1-dqfext@gmail.com>
 <YRRDcGWaWHgBkNhQ@shredder>
 <20210811214506.4pf5t3wgabs5blqj@skbuf>
 <YRRGsL60WeDGQOnv@shredder>
 <20210811215833.yst5tzgfvih2q4y2@skbuf>
 <20210812060410.1848228-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210812060410.1848228-1-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 12, 2021 at 02:04:10PM +0800, DENG Qingfang wrote:
> On Thu, Aug 12, 2021 at 12:58:33AM +0300, Vladimir Oltean wrote:
> > On Thu, Aug 12, 2021 at 12:52:48AM +0300, Ido Schimmel wrote:
> > >
> > > If the purpose is correctness, then this is not the only flag that was
> > > missed. BR_HAIRPIN_MODE is also relevant for the data path, for example.
> >
> > I never wanted to suggest that I'm giving a comprehensive answer, I just
> > answered Qingfang's punctual question here:
> > https://lore.kernel.org/netdev/CALW65jbotyW0MSOd-bd1TH_mkiBWhhRCQ29jgn+d12rXdj2pZA@mail.gmail.com/
> >
> > Tobias also pointed out the same issue about BR_MULTICAST_TO_UNICAST in
> > conjunction with tx_fwd_offload (although the same is probably true even
> > without it):
> > https://patchwork.kernel.org/project/netdevbpf/cover/20210426170411.1789186-1-tobias@waldekranz.com/
> >
> > > Anyway, the commit message needs to be reworded to reflect the true
> > > purpose of the patch.
> >
> > Agree, and potentially extended with all the bridge port flags which are
> > broken without switchdev driver intervention.
>
> So, what else flags should be added to BR_PORT_FLAGS_HW_OFFLOAD?

I can't think of others beside these 3, BR_ISOLATED, BR_HAIRPIN_MODE and BR_MULTICAST_TO_UNICAST.
