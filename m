Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 148D6441FF4
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 19:22:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231952AbhKASYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 14:24:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:44504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231983AbhKASYh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Nov 2021 14:24:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8905660F45;
        Mon,  1 Nov 2021 18:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635790289;
        bh=m9p1N+GEBGnzb6Je5a17red2Fr7vkekxGIBw+pL7VoA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=r4U0qDKzMQ9Fq+zYWEQJY81dUcXu/9vDexC4oukHPk0yTb3gqXqnZnH4mJ5Nv8vkL
         HYEi447dtDBGK8BXD+otA+GFiAzQup8iz3qZMdp+8EW8OpkKJP+u2RaPj4dR0VRj0A
         RHQ7jdjbICOipXvRRw2C1l00oFPAHhTc64nzYPS+MmO3D7XoP2tQG+NBrjhthNqsFA
         gNPz70dSNgFwxvAfJOkf6PIdH7vgDLwdUAuFTjkVk3yIdB6yMdbgdoIVskHzTDGFvD
         RW/Wb7G38s+auM2Ukp2HIWfhQHwVrfJj4e0Oayhbl0NQcoxdotrSurkn+Qp/8djGKn
         q0ke6VknzbAiw==
Date:   Mon, 1 Nov 2021 20:11:25 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, jiri@resnulli.us,
        mkubecek@suse.cz, andrew@lunn.ch, f.fainelli@gmail.com
Subject: Re: [PATCH net-next v2 3/4] devlink: expose get/put functions
Message-ID: <YYAtzVqgbkfjsx5E@unreal>
References: <20211030171851.1822583-1-kuba@kernel.org>
 <20211030171851.1822583-4-kuba@kernel.org>
 <YX43wGPh5+TcXR81@unreal>
 <20211101064440.57a587bf@kicinski-fedora-PC1C0HJN>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211101064440.57a587bf@kicinski-fedora-PC1C0HJN>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 01, 2021 at 06:44:40AM -0700, Jakub Kicinski wrote:
> On Sun, 31 Oct 2021 08:29:20 +0200 Leon Romanovsky wrote:
> > I really like this series, but your latest netdevsim RFC made me worry.
> > 
> > It is important to make sure that these devlink_put() and devlink_get()
> > calls will be out-of-reach from the drivers. Only core code should use
> > them.
> 
> get/put symbols are not exported so I think we should be safe
> from driver misuse at this point. If we ever export them we 
> should add a 
> 
>   WARN_ON(!(devlink->lock_flags & DEVLINK_LOCK_USE_REF));

Right, for now we are safe.

> 
> > Can you please add it as a comment above these functions?
> 
> Will do if the RFC sinks.

I have a solution at hand that doesn't require exporting get/put interfaces.

> 
> > At least for now, till we discuss your RFC.
