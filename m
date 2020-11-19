Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78AED2B96C8
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 16:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728916AbgKSPqi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 10:46:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:42152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728583AbgKSPqh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 10:46:37 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 813182224A;
        Thu, 19 Nov 2020 15:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605800796;
        bh=ZvKprxlPeDR11nAv0IeB4RNZKc7/A57CYBYK8dwYGvA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eJFgy/ERDAHnV44gummxbYRBsX1kbc6TtE7RiXMtxbNIkKe7OhRg5AJfcPrxFKqjD
         RvGoJEuoxmZSF+VACQj2A8eU2SVNDpagHniFKlgF8AkQdfRkaQSpgD5aLptwItPHad
         ogoqmgOfEn08wfYIcOdiAOnWKZDBDMa2FN3swJpI=
Date:   Thu, 19 Nov 2020 07:46:34 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Tao Ren <rentao.bupt@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Jean Delvare <jdelvare@suse.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-hwmon@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, openbmc@lists.ozlabs.org, taoren@fb.com,
        mikechoi@fb.com
Subject: Re: [PATCH v2 0/2] hwmon: (max127) Add Maxim MAX127 hardware
 monitoring
Message-ID: <20201119074634.2e9cb21b@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201119012653.GA249502@roeck-us.net>
References: <20201118230929.18147-1-rentao.bupt@gmail.com>
        <20201118232719.GI1853236@lunn.ch>
        <20201118234252.GA18681@taoren-ubuntu-R90MNF91>
        <20201119010119.GA248686@roeck-us.net>
        <20201119012653.GA249502@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Nov 2020 17:26:53 -0800 Guenter Roeck wrote:
> On Wed, Nov 18, 2020 at 05:01:19PM -0800, Guenter Roeck wrote:
> > On Wed, Nov 18, 2020 at 03:42:53PM -0800, Tao Ren wrote:  
> > > On Thu, Nov 19, 2020 at 12:27:19AM +0100, Andrew Lunn wrote:  
> > > > On Wed, Nov 18, 2020 at 03:09:27PM -0800, rentao.bupt@gmail.com wrote:  
> > > > > From: Tao Ren <rentao.bupt@gmail.com>
> > > > > 
> > > > > The patch series adds hardware monitoring driver for the Maxim MAX127
> > > > > chip.  
> > > > 
> > > > Hi Tao
> > > > 
> > > > Why are using sending a hwmon driver to the networking mailing list?
> > > > 
> > > >     Andrew  
> > > 
> > > Hi Andrew,
> > > 
> > > I added netdev because the mailing list is included in "get_maintainer.pl
> > > Documentation/hwmon/index.rst" output. Is it the right command to find
> > > reviewers? Could you please suggest? Thank you.  
> > 
> > I have no idea why running get_maintainer.pl on
> > Documentation/hwmon/index.rst returns such a large list of mailing
> > lists and people. For some reason it includes everyone in the XDP
> > maintainer list. If anyone has an idea how that happens, please
> > let me know - we'll want to get this fixed to avoid the same problem
> > in the future.
> 
> I found it. The XDP maintainer entry has:
> 
> K:    xdp
> 
> This matches Documentation/hwmon/index.rst.
> 
> $ grep xdp Documentation/hwmon/index.rst
>    xdpe12284
> 
> It seems to me that a context match such as "xdp" in MAINTAINERS isn't
> really appropriate. "xdp" matches a total of 348 files in the kernel.
> The large majority of those is not XDP related. The maintainers
> of XDP (and all the listed mailing lists) should not be surprised
> to get a large number of odd review requests if they want to review
> every single patch on files which include the term "xdp".

Agreed, we should fix this. For maintainers with high patch volume life
would be so much easier if people CCed the right folks to get reviews,
so we should try our best to fix get_maintainer.

XDP folks, any opposition to changing the keyword / filename to:

	[^a-z0-9]xdp[^a-z0-9]

?
