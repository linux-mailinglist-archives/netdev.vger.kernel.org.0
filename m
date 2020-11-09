Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78E0C2AC438
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 19:55:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730315AbgKISyw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 13:54:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:59132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729451AbgKISyu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 13:54:50 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 671CF206D8;
        Mon,  9 Nov 2020 18:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604948089;
        bh=CXi+qyej1yrl+qniGQlwSacd07ZVkKzvg4C2OSmI29E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XBnYe+ko5N1c2hg5/TYtW+thHZf8bpoF+VYpgn3OEj5WvmFYJDV5ZKEgiNuXISj4k
         4JulehaAUK0oaLxM08XbQ2xlmjJxC7z14W2WuVexUHvlhujXY2RmX+SAR1ZhFykP9Q
         cZtbrYlYa3gfYyoGZFbNxu2tmR0GWcA9+8O45Ewk=
Date:   Mon, 9 Nov 2020 10:54:48 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jarod Wilson <jarod@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Davis <tadavis@lbl.gov>, Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v4 0/5] bonding: rename bond components
Message-ID: <20201109104627.4a5af5bb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAKfmpSfkmo1GVVThadDDtXma1m1yrNwPoPz87sMy5664uJbevg@mail.gmail.com>
References: <20201106200436.943795-1-jarod@redhat.com>
        <20201106184432.07a6ab18@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAKfmpSfkmo1GVVThadDDtXma1m1yrNwPoPz87sMy5664uJbevg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 9 Nov 2020 11:47:58 -0500 Jarod Wilson wrote:
> On Fri, Nov 6, 2020 at 9:44 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Fri,  6 Nov 2020 15:04:31 -0500 Jarod Wilson wrote:  
> > > The bonding driver's use of master and slave, while largely understood
> > > in technical circles, poses a barrier for inclusion to some potential
> > > members of the development and user community, due to the historical
> > > context of masters and slaves, particularly in the United States. This
> > > is a first full pass at replacing those phrases with more socially
> > > inclusive ones, opting for bond to replace master and port to
> > > replace slave, which is congruent with the bridge and team drivers.  
> >
> > If we decide to go ahead with this, we should probably also use it as
> > an opportunity to clean up the more egregious checkpatch warnings, WDYT?
> >
> > Plan minimum - don't add new ones ;)  
> 
> Hm. I hadn't actually looked at checkpatch output until now. It's...
> noisy here. But I'm pretty sure the vast majority of that is from
> existing issues, simply reported now due to all the renaming.

I don't think all of them:

-					tx_slave = slaves->arr[hash_index %
+					tx_port = ports->arr[hash_index %
 							       count];

It should be relatively trivial to find incremental warnings.

AFAIR checkpatch has a mode to run on a file, not on a patch, so you
can run it before and after and diff.

> I can
> certainly take a crack at cleanups, but I'd be worried about missing
> another merge window trying to sort all of these, when they're not
> directly related.

TBH I haven't followed the previous discussions too closely, as much 
as I applaud the effort I'm not signing up for reviewing 3.5kLoC of
renames, so I hope you can find someone to review this for you.

Another simple confidence booster would be a confirmation that given
patches do not change the object code.
