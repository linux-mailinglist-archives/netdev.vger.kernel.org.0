Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E6892DC85D
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 22:33:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbgLPVcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 16:32:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:34532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726523AbgLPVcU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 16:32:20 -0500
Date:   Wed, 16 Dec 2020 13:31:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608154299;
        bh=Y3cKq4nEretGiiOvp1mzXNJHWhT+tBKlxqRyefn+xbQ=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=NYSXsPvsNDBn4t8dCJIJ+aBdJ27doHWfl+WWdmPcIUDVgzCwkOOktVH52ezbleHGt
         7rMAcUDghL1hHstqpzpEtt5QDUGnPFofPeE0oJMG4w7PEQwnUTnSP/LmU/bddSuSIX
         qTgReG7wBu8k3ogv0oM0fOcOaIlYfWwQ+zvS2LCMb2VmncqCNRiTEACUVfaAnBbFbz
         bDzn1KnUbYJ6XRkpF1VdGH6JNRpLTa2ZF5D26nbykjwnddUOuMSWlNfizFFLdtzynJ
         CLy5ns/LdCQpCVOVCNC4cwb8SqslpCBzoskaqc1XA0GhRNNCUX7QUdGTJ6Z38nObAs
         IiTFnz2ViI2zg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     Ivan Vecera <ivecera@redhat.com>, netdev@vger.kernel.org,
        LiLiang <liali@redhat.com>
Subject: Re: [PATCH net] ethtool: fix error paths in ethnl_set_channels()
Message-ID: <20201216133138.7ec4ddde@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201215100921.3qnmqdbhxpniejnw@lion.mk-sys.cz>
References: <20201215090810.801777-1-ivecera@redhat.com>
        <20201215100921.3qnmqdbhxpniejnw@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Dec 2020 11:09:21 +0100 Michal Kubecek wrote:
> On Tue, Dec 15, 2020 at 10:08:10AM +0100, Ivan Vecera wrote:
> > Fix two error paths in ethnl_set_channels() to avoid lock-up caused
> > but unreleased RTNL.
> > 
> > Fixes: e19c591eafad ("ethtool: set device channel counts with CHANNELS_SET request")
> > Cc: Michal Kubecek <mkubecek@suse.cz>
> > Reported-by: LiLiang <liali@redhat.com>
> > Signed-off-by: Ivan Vecera <ivecera@redhat.com>
>
> Oh, the joys of mindless copy and paste... :-(

I wish sparse was able to catch rtnl_lock leaks. I tried to annotate
it a couple of weeks back but couldn't get it to work well even within
rtnetlink.c

> Reviewed-by: Michal Kubecek <mkubecek@suse.cz>

Applied, thanks!
