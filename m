Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6AAF40DB49
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 15:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240057AbhIPNem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 09:34:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:35386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240116AbhIPNek (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 09:34:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C392E60F11;
        Thu, 16 Sep 2021 13:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631799200;
        bh=uOL+5HttzD8vO7NoHwzx0B7Jm5+HQgl/bCl77os9SJ0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XwNKOaZQvN8fjtbpM7bOI1PhjPU6IRi/fX7PcgLvZG9MN7kgSFISEYwOwTYM/BidG
         vsXH4rZ5MOHmr0HbgevYl5WNxb02mK97sE8Vvl0MUXGF/Fg4TvUr3fubTupbF0FS9h
         0VeJ/X6TjamewLo4V9ghyflNqyDJgeAbwRCC3CuG1srNweMDOQax2V2XY3nWPf3Blu
         koYn4zqKx7jlUuv0SFauAGZb7s2FKflb4UkUddGD+TC5LRTSPIcyhLUbqj7DK7WGuk
         qcIF/TKrTyCKi/olscn7Ql9t9TZX5cUmzxTGq8XkiiEfHEx8EP5asS6mjiJOyt0M48
         yk5Uh6r+RLaAA==
Date:   Thu, 16 Sep 2021 06:33:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] devlink: Delete not-used devlink APIs
Message-ID: <20210916063318.7275cadf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <a45674a8cb1c1e0133811d95756357b787673e52.1631788678.git.leonro@nvidia.com>
References: <a45674a8cb1c1e0133811d95756357b787673e52.1631788678.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Sep 2021 13:38:33 +0300 Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Devlink core exported generously the functions calls that were used
> by netdevsim tests or not used at all.
> 
> Delete such APIs with one exception - devlink_alloc_ns(). That function
> should be spared from deleting because it is a special form of devlink_alloc()
> needed for the netdevsim.

Do you have a reason to do this or are you just cleaning up?

The fmsg functions are not actually removed, just unexported.
Are there out of tree drivers abusing them?

The port_param functions are "symmetric" with the global param 
ones. Removing them makes the API look somewhat incomplete.

Obviously the general guidance is that we shouldn't export 
functions which have no upstream users but that applies to 
meaningful APIs. For all practical purposes this is just a 
sliver of an API, completeness gives nice warm feelings.

Anyway, just curious what made you do this. I wouldn't do it 
myself but neither am I substantially opposed.
