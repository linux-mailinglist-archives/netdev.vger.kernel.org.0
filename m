Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A24F82D2B96
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 14:03:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728619AbgLHNDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 08:03:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728287AbgLHNDK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 08:03:10 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D29EC061749
        for <netdev@vger.kernel.org>; Tue,  8 Dec 2020 05:02:24 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id c79so13847825pfc.2
        for <netdev@vger.kernel.org>; Tue, 08 Dec 2020 05:02:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=GO232AaSYAolnBA6Esu/diTSHezjJYFknTrZKm6nSpw=;
        b=nSHxBR9oznkVPVbwjyq3dZvvHUza5tWtqGNuep0pBr8jixfTi6uiMhNj6XSesKsM7n
         DWjD5eMTQUR95p4cJP9s0Yl3C9qy+wCYU746r1TVGzhm/LpU3fx3wGGNBv3bpDklI3NI
         55sO31MvB7ZSmYXx1/DhJg6DuOT3pIs5fZtjiP9itRuJDM7I4NzWhG4uBw6Z0xwkYDxV
         ku15/smfAg9+rl4JjCR5VKcWAo3KFDs6LuogbpNRa88JojQSaadFlEfc9CsQBs3OzpIj
         yptLuc+Iu96OV3PJYKSL+llPlMHlexNh/pRQm5Ac0E5uH/hxCUG833VH6eaHlfxz42cO
         mvrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=GO232AaSYAolnBA6Esu/diTSHezjJYFknTrZKm6nSpw=;
        b=roJeu7J+Ti5WgHuA8xLNWblEzkDrZw96XtQLjSCnUT3k9NOfcpLiuNRo0sdvI2aVud
         anhH5yrY5OqbMHhZf7SrlGuns76jkGgzoUF4UuIq70JIKJQYAhoHsdVaAxyiumPFylIL
         i8MoMgzX/a73XbdC9+2ZloExNJw6to9Vh+GzHDmQIA9vRTzs5Foa6fdR4gwLv5WCQ7Ty
         uzKjw5CwJynOQk2Hich4KtKPJwUaysO7i4vyhSU19squSNUt9zAW7HIHoViCZHsxLbWM
         5eFdE+QstNx9SrCNESKQus8ktip29d0lXrpPbW2f84ZNSx3NH+1rRdpa3ftdIkS54Z4F
         1d+g==
X-Gm-Message-State: AOAM533TKteMwiuLpAwXhun/zOXwqHtYeQs2IjPF3DKT4SWwDLCn7LBj
        e0lED0IbVJsOZf/97k1W1me2E1u8UtM=
X-Google-Smtp-Source: ABdhPJyWZeYMhvVnnQQvF3RcBhY2/3vGPGqZzBjQHJWJe+650lD2imWQSn4aPQ9NW5p6nrDveO+Vfg==
X-Received: by 2002:a17:90a:460b:: with SMTP id w11mr4262372pjg.12.1607432543883;
        Tue, 08 Dec 2020 05:02:23 -0800 (PST)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id p9sm684439pfq.136.2020.12.08.05.02.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 05:02:23 -0800 (PST)
Date:   Tue, 8 Dec 2020 05:02:20 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [net-next V2 08/15] net/mlx5e: Add TX PTP port object support
Message-ID: <20201208130220.GC17489@hoboy.vegasvil.org>
References: <20201204122613.542c2362@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <999c9328747d4edbfc8d2720b886aaa269e16df8.camel@kernel.org>
 <20201204151743.4b55da5c@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <a20290fa3448849e84d2d97b2978d4e05033cd80.camel@kernel.org>
 <20201204162426.650dedfc@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <a4a8adc8-4d4c-3b09-6c2f-ce1d12e0b9bc@nvidia.com>
 <20201206170834.GA4342@hoboy.vegasvil.org>
 <a03538c728bf232ccae718d78de43883c4fca70d.camel@kernel.org>
 <20201207151906.GA30105@hoboy.vegasvil.org>
 <20201207124233.22540545@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201207124233.22540545@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 07, 2020 at 12:42:33PM -0800, Jakub Kicinski wrote:

> The behavior is not entirely dissimilar to the time stamps on
> multi-layered devices (e.g. DSA switches). The time stamp can either 
> be generated when the packet enters the device (current mlx5 behavior)
> or when it actually egresses thru the MAC (what this set adds).

To be useful, the time stamps must be taken on the external ports.
Generating the time stamp at the DMA reception in the device doesn't
even make sense, unless the delay through the device is constant.

> My main concern is the user friendliness. I think there is no question
> that user running ptp4l would want this mlx5 knob to be enabled.

Right.

> Would
> we rather see a patch to ptp4l that turns per driver knob or should we
> shoot for some form of an API that tells the kernel that we're
> expecting ns level time accuracy? 

This is a hardware-specific "feature".  One of the guiding principles
of the linuxptp user space stack is not to become a catalog of
workarounds for random hardware.  IMO the kernel's API should not
encourage "special" hardware either.  After all, we have lots and lots
of PTP hardware supported, all of them already working with the
existing API just fine.

My preference is for a global knob for users of this hardware, either

- a compile time Kconfig option on the driver, or
- some kind of sysctl/debugfs knob

Thanks,
Richard



