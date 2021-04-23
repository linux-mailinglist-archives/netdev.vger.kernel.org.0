Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38A9B369CEF
	for <lists+netdev@lfdr.de>; Sat, 24 Apr 2021 00:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234465AbhDWW7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 18:59:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:43718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231359AbhDWW7O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 18:59:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5CCA261465;
        Fri, 23 Apr 2021 22:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619218717;
        bh=0cCVAfM16m5wt4jGNqpiMyqbG8SYHJHNYom3Egbmiq8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JUUUMdxj4NQ1GZlTFKGUSCWlm4wiWjE1r0CJBi9LwtehqAMbnOTbiTbmWSQugY9uU
         tzAHQPmauvo+xLXbY2LP/UUPiVtslSCs+aO2c0scBQTbZnZjzMoALE4FwryIZ7QXHd
         lucYG4gnv/hPUN3o1gX1EPjJJQxLlFpfjnFYNhLpuy9Q72mGkg42tTKTjhNTDhh54R
         46KdzQViccewvKE+KzAXS5oJH8n/tE/qwfZ9ymnu1unvka7dh07TLoi7cGL2ZfvD/W
         oj8xZ8bK29zW6BXHneTZictEhGpBbBhRUqg4eM4YH9Zf+V0SqBndtNvovfx+Ewg80z
         tUrPWHmUF87vg==
Date:   Fri, 23 Apr 2021 15:58:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oleksandr Natalenko <oleksandr@natalenko.name>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        linux-kernel@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: Re: [igb] netconsole triggers warning in netpoll_poll_dev
Message-ID: <20210423155836.25ef1e77@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210423081944.kvvm4v7jcdyj74l3@spock.localdomain>
References: <20210406123619.rhvtr73xwwlbu2ll@spock.localdomain>
        <20210406114734.0e00cb2f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210407060053.wyo75mqwcva6w6ci@spock.localdomain>
        <20210407083748.56b9c261@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAKgT0UfLLQycLsAZQ98ofBGYPwejA6zHbG6QsNrU92mizS7e0g@mail.gmail.com>
        <20210407110722.1eb4ebf2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAKgT0UcQXVOifi_2r_Y6meg_zvHDBf1me8VwA4pvEtEMzOaw2Q@mail.gmail.com>
        <20210423081944.kvvm4v7jcdyj74l3@spock.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 23 Apr 2021 10:19:44 +0200 Oleksandr Natalenko wrote:
> On Wed, Apr 07, 2021 at 04:06:29PM -0700, Alexander Duyck wrote:
> > On Wed, Apr 7, 2021 at 11:07 AM Jakub Kicinski <kuba@kernel.org> wrote:  
> > > Sure, that's simplest. I wasn't sure something is supposed to prevent
> > > this condition or if it's okay to cover it up.  
> > 
> > I'm pretty sure it is okay to cover it up. In this case the "budget -
> > 1" is supposed to be the upper limit on what can be reported. I think
> > it was assuming an unsigned value anyway.
> > 
> > Another alternative would be to default clean_complete to !!budget.
> > Then if budget is 0 clean_complete would always return false.  
> 
> So, among all the variants, which one to try? Or there was a separate
> patch sent to address this?

Alex's suggestion is probably best.

I'm not aware of the fix being posted. Perhaps you could take over and
post the patch if Intel doesn't chime in?
