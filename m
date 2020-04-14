Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9AAF1A87AD
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 19:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440297AbgDNRhd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 13:37:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:47418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440468AbgDNRhX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Apr 2020 13:37:23 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 837132054F;
        Tue, 14 Apr 2020 17:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586885842;
        bh=px6nIS9Hq8DELBCY1DMCHeoxcg0ZQMm/RLpGKa5szKk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iiY3kzO+laiG3lCFR1uDWI/Nz+MHp0TQrD0I+0wn2KS8GVhcZ/PNz5liOtGbVTXg8
         n5RVTd0YSK2UFXEtKyxjMzxaOZuM+uhwqSKKyIFyBhmCCl81cXMyxkFPvJg1c6mrUQ
         9UEpjTgeFSIDUzDQq1veRnOgZxGBLw0391LBBXFg=
Date:   Tue, 14 Apr 2020 20:37:18 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     Or Gerlitz <gerlitz.or@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Stable <stable@vger.kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH AUTOSEL 4.9 09/26] net/mlx5e: Init ethtool steering for
 representors
Message-ID: <20200414173718.GE1011271@unreal>
References: <20200411231413.26911-1-sashal@kernel.org>
 <20200411231413.26911-9-sashal@kernel.org>
 <CAJ3xEMhhtj77M5vercHDMAHPPVZ8ZF-eyCVQgD4ZZ1Ur3Erbdw@mail.gmail.com>
 <20200412105935.49dacbf7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200414015627.GA1068@sasha-vm>
 <CAJ3xEMh=PGVSddBWOX7U6uAuazJLFkCpWQNxhg7dDRgnSdQ=xA@mail.gmail.com>
 <20200414110911.GA341846@kroah.com>
 <CAJ3xEMhnXZB-HU7aL3m9A1N_GPxgOC3U4skF_qWL8z3wnvSKPw@mail.gmail.com>
 <a89a592a-5a11-5e56-a086-52b1694e00db@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a89a592a-5a11-5e56-a086-52b1694e00db@solarflare.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 14, 2020 at 04:49:20PM +0100, Edward Cree wrote:
> On 14/04/2020 16:16, Sasha Levin wrote:
> > Are you suggesting that a commit without a fixes tag is never a fix?
> Because fixes are much more likely than non-fixes to have a Fixes tag,
>  the absence of a fixes tag is Bayesian evidence that a commit is not
>  a fix.  It's of course not incontrovertible evidence, since (as you
>  note) some fixes do not have a Fixes tag, but it does increase the
>  amount of countervailing evidence needed to conclude a commit is a fix.
> In this case it looks as if the only such evidence was that the commit
>  message included the phrase "NULL pointer dereference".
>
> > Fixes can (and should) come in during a merge window as well. They are
> > not put on hold until the -rc releases.
> In networking-land, fixes generally go through David's 'net' tree, rather
>  than 'net-next'; the only times a fix goes to net-next are when
> a) the code it's fixing is only in net-next; i.e. it's a fix to a previous
>  patch from the same merge window.  In this case the fix should not be
>  backported, since the code it's fixing will not appear in stable kernels.
> b) the code has changed enough between net and net-next that different
>  fixes are appropriate for the two trees.  In this case, only the fix that
>  went to 'net' should be backported (since it's the one that's appropriate
>  for net, it's probably more appropriate for stable trees too); the fix
>  that went to 'net-next' should not.
> Or's original phrasing was that this patch "was pushed to net-next", which
>  is not quite exactly the same thing as -next vs. -rc (though it's similar
>  because of David's system of closing net-next for the duration of the
>  merge window).  And this, again, is quite strong Bayesian evidence that
>  the patch should not be selected for stable.
>
> To be honest, that this needs to be explained to you does not inspire
>  confidence in the quality of your autoselection process...

It is a little bit harsh to say that.

The autoselection process works good enough for everything outside
of netdev community. The amount of bugs in those stable@ trees is
not such high if you take into account the amount of fixes automatically
brought in.

I think that all Fedora users are indirectly use those stable@ trees.

Thanks
