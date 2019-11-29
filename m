Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07CB810D2D9
	for <lists+netdev@lfdr.de>; Fri, 29 Nov 2019 09:58:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbfK2I6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Nov 2019 03:58:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:55780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726143AbfK2I6D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Nov 2019 03:58:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76CF120833;
        Fri, 29 Nov 2019 08:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575017882;
        bh=hxgcVGCFjV8KdJ5bsDJdVKwzzbFr9eQ1ZdMO+leIuvg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aGKDLLLQFx1z6UmOairq0IA62Xbya1bbl3Ix4JpSKTXVXRKlmGnj6rrCY4IWKumhE
         ItOpB0kGPcGwCazlrFFyQX04B7ldKBpzVL1Tyfi/kwpFBlCViVAPVZ5GRy5wQ3FYfy
         kuBHRbuE9VJOWRkcy4lVjJhugKt3UuJQTxW5PE9w=
Date:   Fri, 29 Nov 2019 09:58:00 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Jouni =?iso-8859-1?Q?H=F6gander?= <jouni.hogander@unikie.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 4.19 000/306] 4.19.87-stable review
Message-ID: <20191129085800.GF3584430@kroah.com>
References: <20191127203114.766709977@linuxfoundation.org>
 <CA+G9fYuAY+14aPiRVUcXLbsr5zJ-GLjULX=s9jcGWcw_vb5Kzw@mail.gmail.com>
 <20191128073623.GE3317872@kroah.com>
 <CAKXUXMy_=gVVw656AL5Rih_DJrdrFLoURS-et0+dpJ2cKaw6SQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKXUXMy_=gVVw656AL5Rih_DJrdrFLoURS-et0+dpJ2cKaw6SQ@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 29, 2019 at 06:46:23AM +0100, Lukas Bulwahn wrote:
> On Thu, Nov 28, 2019 at 8:37 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Thu, Nov 28, 2019 at 12:23:41PM +0530, Naresh Kamboju wrote:
> > > On Thu, 28 Nov 2019 at 02:25, Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > This is the start of the stable review cycle for the 4.19.87 release.
> > > > There are 306 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > >
> > > > Responses should be made by Fri, 29 Nov 2019 20:18:09 +0000.
> > > > Anything received after that time might be too late.
> > > >
> > > > The whole patch series can be found in one patch at:
> > > >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.87-rc1.gz
> > > > or in the git tree and branch at:
> > > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> > > > and the diffstat can be found below.
> > > >
> > > > thanks,
> > > >
> > > > greg k-h
> > >
> > > Kernel BUG noticed on x86_64 device while booting 4.19.87-rc1 kernel.
> > >
> > > The problematic patch is,
> > >
> > > > Jouni Hogander <jouni.hogander@unikie.com>
> > > >     net-sysfs: Fix reference count leak in rx|netdev_queue_add_kobject
> > >
> > > And this kernel panic is been fixed by below patch,
> > >
> > > commit 48a322b6f9965b2f1e4ce81af972f0e287b07ed0
> > > Author: Eric Dumazet <edumazet@google.com>
> > > Date:   Wed Nov 20 19:19:07 2019 -0800
> > >
> > >     net-sysfs: fix netdev_queue_add_kobject() breakage
> > >
> > >     kobject_put() should only be called in error path.
> > >
> > >     Fixes: b8eb718348b8 ("net-sysfs: Fix reference count leak in
> > > rx|netdev_queue_add_kobject")
> > >     Signed-off-by: Eric Dumazet <edumazet@google.com>
> > >     Cc: Jouni Hogander <jouni.hogander@unikie.com>
> > >     Signed-off-by: David S. Miller <davem@davemloft.net>
> >
> > Now queued up, I'll push out -rc2 versions with this fix.
> >
> > greg k-h
> 
> We have also been informed about another regression these two commits
> are causing:
> 
> https://lore.kernel.org/lkml/ace19af4-7cae-babd-bac5-cd3505dcd874@I-love.SAKURA.ne.jp/
> 
> I suggest to drop these two patches from this queue, and give us a
> week to shake out the regressions of the change, and once ready, we
> can include the complete set of fixes to stable (probably in a week or
> two).

Ok, thanks for the information, I've now dropped them from all of the
queues that had them in them.

greg k-h
