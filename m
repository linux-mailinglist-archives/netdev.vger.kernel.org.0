Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1031ACE8D
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 19:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731028AbgDPRUF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 13:20:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:37912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728494AbgDPRUE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Apr 2020 13:20:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CB562076D;
        Thu, 16 Apr 2020 17:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587057603;
        bh=Wk7+i30v37qY0mX+qzS0pNeXKWGSUHDgHHiYH1bxSPI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HjIuN20+tHuKI4fLU25dw+bcXktBNJjtB0smjVsvGGBvKvASQ6eYaV0iW6TCEwLvU
         lISAj0dOsUaxaLdr9WzJSiXWXKefOTUcVs0YD7wE+M38+E4Ft+9oJEiGUlV07tXAcY
         186yd1BtBtiOvHRpR+1h5Kc8zR9UOpMOqL9uhBBw=
Date:   Thu, 16 Apr 2020 19:20:01 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Or Gerlitz <gerlitz.or@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        Edward Cree <ecree@solarflare.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Stable <stable@vger.kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH AUTOSEL 4.9 09/26] net/mlx5e: Init ethtool steering for
 representors
Message-ID: <20200416172001.GC1388618@kroah.com>
References: <20200412105935.49dacbf7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200414015627.GA1068@sasha-vm>
 <CAJ3xEMh=PGVSddBWOX7U6uAuazJLFkCpWQNxhg7dDRgnSdQ=xA@mail.gmail.com>
 <20200414110911.GA341846@kroah.com>
 <CAJ3xEMhnXZB-HU7aL3m9A1N_GPxgOC3U4skF_qWL8z3wnvSKPw@mail.gmail.com>
 <a89a592a-5a11-5e56-a086-52b1694e00db@solarflare.com>
 <20200414205755.GF1068@sasha-vm>
 <41174e71-00e1-aebf-b67d-1b24731e4ab3@solarflare.com>
 <20200416000009.GL1068@sasha-vm>
 <CAJ3xEMjfWL=c=voGqV4pUCzWXmiTn-R6mrRi82UAVHMVysKU1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ3xEMjfWL=c=voGqV4pUCzWXmiTn-R6mrRi82UAVHMVysKU1g@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 16, 2020 at 04:40:31PM +0300, Or Gerlitz wrote:
> On Thu, Apr 16, 2020 at 3:00 AM Sasha Levin <sashal@kernel.org> wrote:
> > I'd maybe point out that the selection process is based on a neural
> > network which knows about the existence of a Fixes tag in a commit.
> >
> > It does exactly what you're describing, but also taking a bunch more
> > factors into it's desicion process ("panic"? "oops"? "overflow"? etc).
> 
> As Saeed commented, every extra line in stable / production kernel
> is wrong.

What?  On what do you base that crazy statement on?  I have 18+ years of
direct experience of that being the exact opposite.

> IMHO it doesn't make any sense to take into stable automatically
> any patch that doesn't have fixes line. Do you have 1/2/3/4/5 concrete
> examples from your (referring to your Microsoft employee hat comment
> below) or other's people production environment where patches proved to
> be necessary but they lacked the fixes tag - would love to see them.

Oh wow, where do you want me to start.  I have zillions of these.

But wait, don't trust me, trust a 3rd party.  Here's what Google's
security team said about the last 9 months of 2019:
	- 209 known vulnerabilities patched in LTS kernels, most without
	  CVEs
	- 950+ criticial non-security bugs fixes for device XXXX alone
	  with LTS releases

> We've been coaching new comers for years during internal and on-list
> code reviews to put proper fixes tag. This serves (A) for the upstream
> human review of the patch and (B) reasonable human stable considerations.

If your driver/subsystem is doing this, wonderful, just opt-out of the
autosel process and you will never be bothered again.

But, trust me, I think I know a bit about tagging stuff for stable
kernels, and yet the AUTOSEL tool keeps finding patches that _I_ forgot
to tag as such.  So, don't be so sure of yourself, it's humbling :)

Let the AUTOSEL tool run, and if it finds things you don't agree with, a
simple "No, please do not include this" email is all you need to do to
keep it out of a stable kernel.

So far the AUTOSEL tool has found so many real bugfixes that it isn't
funny.  If you don't like it, fine, but it has proven itself _way_
beyond my wildest hopes already, and it just keeps getting better.

greg k-h
