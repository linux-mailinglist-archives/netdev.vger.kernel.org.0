Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4700331EFF
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 07:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbhCIGKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 01:10:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:46756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229480AbhCIGJi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Mar 2021 01:09:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9C5060235;
        Tue,  9 Mar 2021 06:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615270178;
        bh=MxGhTt3kmgcztH/LvjAi9KfLfR+ogOc7wq9IgbVBjgo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TF+vav/MmX+At40IUJvmTZNCL5jgjWeroJX6Ig3w2nwyUo+93hAwbbA3RKl+gPkp3
         FG/5I2XbBLnqYTWCXLdwDZvknoNaLwuIOyBk2aBgd7sQcT54IdToldzz/oxUTG9laZ
         IV4a6t3H4aJt000awxr8K/tHZi7a41KKLOIMk5FfHozhO6U+csqTQ0F1eP/2+LR4Tz
         L7CyDPtUYK548rDo2lKpTh+Py2FAIUVoAJUxfxM6Uw8ujBw8hC/cLxct54BV0/c5du
         fpmdVg8Acjqv+nb6mj63gyWVQfOchO0y4I0CpLiSWmQL6/1rKX8zaujDlpCAn4iDxz
         qdReEWZl16raw==
Date:   Tue, 9 Mar 2021 08:09:34 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, alice.michael@intel.com,
        alan.brady@intel.com
Subject: Re: [RFC net-next] iavf: refactor plan proposal
Message-ID: <YEcRHkhJIkZnTgza@unreal>
References: <20210308162858.00004535@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210308162858.00004535@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 08, 2021 at 04:28:58PM -0800, Jesse Brandeburg wrote:
> Hello,
>
> We plan to refactor the iavf module and would appreciate community and
> maintainer feedback on our plans.  We want to do this to realize the
> usefulness of the common code module for multiple drivers.  This
> proposal aims to avoid disrupting current users.
>
> The steps we plan are something like:
> 1) Continue upstreaming of the iecm module (common module) and
>    the initial feature set for the idpf driver[1] utilizing iecm.
> 2) Introduce the refactored iavf code as a "new" iavf driver with the
>    same device ID, but Kconfig default to =n to enable testing.
> 	a. Make this exclusive so if someone opts in to "new" iavf,
> 	   then it disables the original iavf (?)
> 	b. If we do make it exclusive in Kconfig can we use the same
> 	   name?
> 3) Plan is to make the "new" iavf driver the default iavf once
>    extensive regression testing can be completed.
> 	a. Current proposal is to make CONFIG_IAVF have a sub-option
> 	   CONFIG_IAVF_V2 that lets the user adopt the new code,
> 	   without changing the config for existing users or breaking
> 	   them.

I don't think that .config options are considered ABIs, so it is unclear
what do you mean by saying "disrupting current users". Instead of the
complication wrote above, do like any other driver does: perform your
testing, submit the code and switch to the new code at the same time.

>
> We are looking to make sure that the mode of our refactoring will meet
> the community's expectations. Any advice or feedback is appreciated.
>
> Thanks,
> Jesse, Alice, Alan
>
> [1]
> https://lore.kernel.org/netdev/20200824173306.3178343-1-anthony.l.nguyen@intel.com/

Please don't introduce module parameters in new code.

Thanks
