Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E61710D187
	for <lists+netdev@lfdr.de>; Fri, 29 Nov 2019 07:43:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbfK2Gnn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Nov 2019 01:43:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:57564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726360AbfK2Gnm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Nov 2019 01:43:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2A532086A;
        Fri, 29 Nov 2019 06:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575009821;
        bh=1QPv961OeXaHyHKPM3S+xNobUeCP3cxoKrSmQHT7+N4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Gz603e8bJko4UukNTIJzmbygn8z5/KIAVbymVZXZDJatHsk9pCC89iCkxvMIPz91a
         j6w/+6cRiX0lUXBR0s36p0vPY3PJ9CS0tQsG8sbRxgD/FIih7j4j6X1ry1KuPQYoMF
         pQgQPDRxYd++OzvRiRAw6Ard/53uKR/RN4VLLL68=
Date:   Fri, 29 Nov 2019 07:43:38 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        jouni.hogander@unikie.com, "David S. Miller" <davem@davemloft.net>,
        lukas.bulwahn@gmail.com
Subject: Re: [PATCH 4.19 000/306] 4.19.87-stable review
Message-ID: <20191129064338.GA3532463@kroah.com>
References: <20191127203114.766709977@linuxfoundation.org>
 <CA+G9fYuAY+14aPiRVUcXLbsr5zJ-GLjULX=s9jcGWcw_vb5Kzw@mail.gmail.com>
 <20191128073623.GE3317872@kroah.com>
 <b4e6e9df-7334-763a-170a-6758916f420a@kernel.org>
 <ad21dd80-ac0c-a6c0-5e17-0814121bd33e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ad21dd80-ac0c-a6c0-5e17-0814121bd33e@kernel.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 28, 2019 at 04:57:09PM -0700, shuah wrote:
> On 11/28/19 8:56 AM, shuah wrote:
> > On 11/28/19 12:36 AM, Greg Kroah-Hartman wrote:
> > > On Thu, Nov 28, 2019 at 12:23:41PM +0530, Naresh Kamboju wrote:
> > > > On Thu, 28 Nov 2019 at 02:25, Greg Kroah-Hartman
> > > > <gregkh@linuxfoundation.org> wrote:
> > > > > 
> > > > > This is the start of the stable review cycle for the 4.19.87 release.
> > > > > There are 306 patches in this series, all will be posted as a response
> > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > let me know.
> > > > > 
> > > > > Responses should be made by Fri, 29 Nov 2019 20:18:09 +0000.
> > > > > Anything received after that time might be too late.
> > > > > 
> > > > > The whole patch series can be found in one patch at:
> > > > >           https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.87-rc1.gz
> > > > > 
> > > > > or in the git tree and branch at:
> > > > >           git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> > > > > linux-4.19.y
> > > > > and the diffstat can be found below.
> > > > > 
> > > > > thanks,
> > > > > 
> > > > > greg k-h
> > > > 
> > > > Kernel BUG noticed on x86_64 device while booting 4.19.87-rc1 kernel.
> > > > 
> > > > The problematic patch is,
> > > > 
> > > > > Jouni Hogander <jouni.hogander@unikie.com>
> > > > >      net-sysfs: Fix reference count leak in rx|netdev_queue_add_kobject
> > > > 
> > > > And this kernel panic is been fixed by below patch,
> > > > 
> > > > commit 48a322b6f9965b2f1e4ce81af972f0e287b07ed0
> > > > Author: Eric Dumazet <edumazet@google.com>
> > > > Date:   Wed Nov 20 19:19:07 2019 -0800
> > > > 
> > > >      net-sysfs: fix netdev_queue_add_kobject() breakage
> > > > 
> > > >      kobject_put() should only be called in error path.
> > > > 
> > > >      Fixes: b8eb718348b8 ("net-sysfs: Fix reference count leak in
> > > > rx|netdev_queue_add_kobject")
> > > >      Signed-off-by: Eric Dumazet <edumazet@google.com>
> > > >      Cc: Jouni Hogander <jouni.hogander@unikie.com>
> > > >      Signed-off-by: David S. Miller <davem@davemloft.net>
> > > 
> > > Now queued up, I'll push out -rc2 versions with this fix.
> > > 
> > > greg k-h
> > > 
> > 
> > Ran into this on my test system. I will try rc2.
> > 
> 
> rc2 worked for me.

Great, thanks for testing and confirming it.

greg k-h
