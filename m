Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB2E3093B8
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 10:51:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbhA3Juo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 04:50:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:33692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233305AbhA3DCH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 22:02:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F3E764D9F;
        Sat, 30 Jan 2021 03:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611975675;
        bh=1g7TFqM32r+X2G4XFMePCA3nPEQwqjwlXbzXGKcz2Fg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Fpstn8GumhB9aN2VYNzcfMHIETojhLD/lUsuuTb3UIhzrbqwoZIrnh14s4eqaFjZG
         oh3ragFnct6W0/owoHZBHl8UMx1haRVPyMSNWuV3w7bTkGJseMGTsipAS1lexGeY3z
         9j+AywEh1D2VFpQJdZSVTN7TctmGm379C7fb5Tq+0rZmIH0wGnw8nxX9BkbfTWkqw2
         E/2JsptAfTpqBqUD+Xiq1PEOKT/HEPNoIHZR8CvJZHEXuSuSTyW9q8hH4qzBbS3fpb
         t/dYSZwccpHCfjvzpxFaYikdcJpv5Gm6bvfR8AirRmvFJkZwJB0xnhnMVa+ZM+nyhf
         PPzTkGlGp4hPw==
Date:   Fri, 29 Jan 2021 19:01:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     <rasmus.villemoes@prevas.dk>, <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>, <jiri@resnulli.us>,
        <ivecera@redhat.com>, <davem@davemloft.net>, <roopa@nvidia.com>,
        <nikolay@nvidia.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bridge@lists.linux-foundation.org>
Subject: Re: [PATCH net-next v2 0/4] bridge: mrp: Extend br_mrp_switchdev_*
Message-ID: <20210129190114.3f5b6b44@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210127205241.2864728-1-horatiu.vultur@microchip.com>
References: <20210127205241.2864728-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Jan 2021 21:52:37 +0100 Horatiu Vultur wrote:
> This patch series extends MRP switchdev to allow the SW to have a better
> understanding if the HW can implement the MRP functionality or it needs
> to help the HW to run it. There are 3 cases:
> - when HW can't implement at all the functionality.
> - when HW can implement a part of the functionality but needs the SW
>   implement the rest. For example if it can't detect when it stops
>   receiving MRP Test frames but it can copy the MRP frames to CPU to
>   allow the SW to determine this.  Another example is generating the MRP
>   Test frames. If HW can't do that then the SW is used as backup.
> - when HW can implement completely the functionality.
> 
> So, initially the SW tries to offload the entire functionality in HW, if
> that fails it tries offload parts of the functionality in HW and use the
> SW as helper and if also this fails then MRP can't run on this HW.
> 
> v2:
>  - fix typos in comments and in commit messages
>  - remove some of the comments
>  - move repeated code in helper function
>  - fix issue when deleting a node when sw_backup was true

Folks who were involved in previous MRP conversations - does this look
good to you? Anyone planning to test?
