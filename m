Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3771AEBE9
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 12:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725958AbgDRKvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 06:51:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:42724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725857AbgDRKvn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Apr 2020 06:51:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF32E21D82;
        Sat, 18 Apr 2020 10:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587207101;
        bh=c4H2T6YfJ3r5S2AwBtnFzXTEb/H4k9+x1+5GaBZ096E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=azhHfcCEKHxcswoieB3tZa8ifKQVj/wB/PYpPyLhv0BUJjqLvcSA8WALHCKwt/Gfe
         lNWecU4qU1zBVHvjpqN/J5SJDSOWYJZZmykEH5h/qN7fIW0OVYCdFcxiP/s9z1pANr
         9QpzemyJMzSN+r7kePkvc3yUuaPYISCHSwOy7MUs=
Date:   Sat, 18 Apr 2020 12:51:39 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "ecree@solarflare.com" <ecree@solarflare.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gerlitz.or@gmail.com" <gerlitz.or@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "sashal@kernel.org" <sashal@kernel.org>,
        "leon@kernel.org" <leon@kernel.org>
Subject: Re: [PATCH AUTOSEL 4.9 09/26] net/mlx5e: Init ethtool steering for
 representors
Message-ID: <20200418105139.GA2867185@kroah.com>
References: <41174e71-00e1-aebf-b67d-1b24731e4ab3@solarflare.com>
 <20200416000009.GL1068@sasha-vm>
 <434329130384e656f712173558f6be88c4c57107.camel@mellanox.com>
 <20200416052409.GC1309273@unreal>
 <20200416133001.GK1068@sasha-vm>
 <550d615e14258c744cb76dd06c417d08d9e4de16.camel@mellanox.com>
 <20200416195859.GP1068@sasha-vm>
 <3226e1df60666c0c4e3256ec069fee2d814d9a03.camel@mellanox.com>
 <20200417082804.GB140064@kroah.com>
 <934a503d2f75f614c040d300fc080fb76c3725fb.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <934a503d2f75f614c040d300fc080fb76c3725fb.camel@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 17, 2020 at 10:23:37PM +0000, Saeed Mahameed wrote:
> On Fri, 2020-04-17 at 10:28 +0200, gregkh@linuxfoundation.org wrote:
> > > Let me simplify: there is a bug in the AI, where it can choose a
> > > wrong
> > > patch, let's fix it.
> > 
> > You do realize that there are at least 2 steps in this "AI" where
> > people
> > are involved.  The first is when Sasha goes thorough the patches and
> > weeds out all of the "bad ones".
> > 
> > The second is when you, the maintainer, is asked if you think there
> > is a
> > problem if the patch is to be merged.
> > 
> > Then there's also the third, when again, I send out emails for the
> > -rc
> > process with the patches involved, and you are cc:ed on it.
> > 
> > This isn't an unchecked process here running with no human checks at
> > all
> > in it, so please don't speak of it like it is.
> > 
> 
> Sure I understand,
> 
> But with all do respect to Sasha and i know he is doing a great job, he
> just can't sign-off on all of the patches on all of the linux kernel
> and determine just by himself if a patch is good or not.. and the
> maintainer review is what actually matters here.

The maintainer review already happened when the patch went into Linus's
tree.

> But the maintainer ack is an optional thing, and I bet that the vast
> majority don't even look at these e-mails.

That is true.

> My vision is that we make this an opt-in thing, and we somehow force
> all active and important kernel subsystems to opt-in, and make it the
> maintainer responsibility if something goes wrong. 

That's a nice vision, and I too want a pony :)

Seriously, the first rule of the stable trees being created was that it
was not going to cause any extra work for a maintainer to do, given that
even 18 years ago, our maintainers were overloaded.  Now that didn't
totally happen, as I do ask for a cc: stable line to be added to patches
to give me a hint as to what to apply.

Now some maintainers really don't care about stable trees, and don't
even put those lines, which is fine for them, but not fine for me in
wanting to make stable trees that contain the needed fixes for them that
are going into Linus's tree.  So over the years we have come up with
tools to dig these patches out of Linus's tree.  The latest version of
that is this AUTOSEL tool, and after a number of maintainers complained
that being notified at the last possible second (i.e. during a -rc
cycle) was not early enough to stop some AUTOSEL patches from being
merged, Sasha started up the process you see now, giving maintainers a
few _weeks_ to object.

For the maintainers that don't care, fine, they just write a nice
procmail rule and send the email to the round filing cabinet.  For the
maintainers that do care, they get a chance to object.  For the
maintainers that insist they are doing this all right and marking things
correctly and don't want AUTOSEL running on their subsystems, they too
have that option, which a few have already taken.

So that's where we are today, a process that has evolved over the
decades into the one that at the moment, is producing pretty solid and
good stable kernels as per the review of external parties.  Yes, we can
do better and find more patches that need to be backported, and are
working on that.  But to stop and try to go to an opt-in-only process
would cause us to go backwards in the ability for us to provide kernels
with useful bugfixes to users.

> I understand from your statistics that this system is working very
> well, so i believe eventually every maintainer with a code that matters
> will come on board.

Sorry, that just will not happen.  As proof of that, look at all of the
maintainers today that are not "on board" with just a simple "cc:
stable".  And as I say above, that's fine, I am not going to ask them to
do extra work that they do not want to do.  And because of that, I, and
others like Sasha, are going to have to do _extra_ work to make a better
stable kernel release, and that's fine, we are the crazy ones here.

> this way we don't risk it for inactive and less important
> subsystems/drivers.. and we guarantee the whole thing is properly
> audited with the maintainers on-board.. 

Have you met these maintainers that you can tell what to do despite not
being their manager?  If you think you can get them on board, then
please, try to get them to do the simple thing first (cc: stable) and
then we can talk :)

good luck!

greg k-h
