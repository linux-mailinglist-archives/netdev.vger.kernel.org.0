Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D068333170
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 23:18:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbhCIWRq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 17:17:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:48318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231929AbhCIWRk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Mar 2021 17:17:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA7E465020;
        Tue,  9 Mar 2021 22:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615328260;
        bh=+dDE9U2w7sqJWggWKYFQ8nXvh7d2iJ7rjzroUCZIjwI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=erxwvpWJ9tGF/TPuQwNLwgds3E8iKAixIIA1HBF7HwmOwXAzypAw7uBjw5eMO73/Y
         jXxw8oxEChsRjbaGhe1osuqDilZ8ggXvPN3Fv9W5e58GeouZQqSrz3arh+hQzIQ0AF
         CxGnki9L+jwJMFVW4DmYji7V+MeKw3MGKYvd4+yL9qu5hKdMYYcxYSsL34rTN1zUgh
         HMhorPud81aSEAaILXuPDVzStzFHmwG8bkh6BMIPshngM8U/L6SSZ0ucP2oh59CTnH
         m8Cv/IY017ygzcbHHsjpwfkic4FzSO8cLG8NjLyJlmIVWa62qBJ+q9PFM4rx+66wd4
         Gfp7sXOM0w3Zg==
Date:   Tue, 9 Mar 2021 14:17:38 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, alice.michael@intel.com,
        alan.brady@intel.com
Subject: Re: [RFC net-next] iavf: refactor plan proposal
Message-ID: <20210309141738.379feab3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210308162858.00004535@intel.com>
References: <20210308162858.00004535@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 8 Mar 2021 16:28:58 -0800 Jesse Brandeburg wrote:
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

Oh, that's still going? there wasn't any revision for such a long time
I deleted my notes :-o

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
> 
> We are looking to make sure that the mode of our refactoring will meet
> the community's expectations. Any advice or feedback is appreciated.

Sounds like a slow, drawn out process painful to everyone involved.

The driver is upstream. My humble preference is that Intel sends small
logical changes we can review, and preserve a meaningful git history.

