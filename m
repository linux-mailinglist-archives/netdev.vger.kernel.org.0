Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CFF91C6A1E
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 09:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728314AbgEFHfc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 03:35:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:37220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728069AbgEFHfc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 May 2020 03:35:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B997420753;
        Wed,  6 May 2020 07:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588750527;
        bh=wJB7AVgD0h7fCY7ouJXiaTz3ZITva1KOZ+RtXVFf+gI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R3i+qZy5IfS2N3VlFHdc2WEfSK/bY6El8PmmoTZ6sXyW50BL/Zu6sCFbupelNktoI
         5Wftdz5V8zLoFsrrbwz1aVv5OdSjBVYpJp9r9E3bqg3V9zyq/Gy82ypV+g733qeEQU
         cUA7bOsbPwJNorsKbfq7frvec8s1Ohp7BwhzxJ24=
Date:   Wed, 6 May 2020 09:35:25 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Justin He <Justin.He@arm.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ldigby@redhat.com" <ldigby@redhat.com>,
        "n.b@live.com" <n.b@live.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] vhost: fixes
Message-ID: <20200506073525.GC2336830@kroah.com>
References: <20200504081540-mutt-send-email-mst@kernel.org>
 <AM6PR08MB40696EFF8BE389C134AC04F6F7A40@AM6PR08MB4069.eurprd08.prod.outlook.com>
 <20200506031918-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200506031918-mutt-send-email-mst@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 06, 2020 at 03:19:55AM -0400, Michael S. Tsirkin wrote:
> On Wed, May 06, 2020 at 03:28:47AM +0000, Justin He wrote:
> > Hi Michael
> > 
> > > -----Original Message-----
> > > From: Michael S. Tsirkin <mst@redhat.com>
> > > Sent: Monday, May 4, 2020 8:16 PM
> > > To: Linus Torvalds <torvalds@linux-foundation.org>
> > > Cc: kvm@vger.kernel.org; virtualization@lists.linux-foundation.org;
> > > netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Justin He
> > > <Justin.He@arm.com>; ldigby@redhat.com; mst@redhat.com; n.b@live.com;
> > > stefanha@redhat.com
> > > Subject: [GIT PULL] vhost: fixes
> > >
> > > The following changes since commit
> > > 6a8b55ed4056ea5559ebe4f6a4b247f627870d4c:
> > >
> > >   Linux 5.7-rc3 (2020-04-26 13:51:02 -0700)
> > >
> > > are available in the Git repository at:
> > >
> > >   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
> > >
> > > for you to fetch changes up to
> > > 0b841030625cde5f784dd62aec72d6a766faae70:
> > >
> > >   vhost: vsock: kick send_pkt worker once device is started (2020-05-02
> > > 10:28:21 -0400)
> > >
> > > ----------------------------------------------------------------
> > > virtio: fixes
> > >
> > > A couple of bug fixes.
> > >
> > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > >
> > > ----------------------------------------------------------------
> > > Jia He (1):
> > >       vhost: vsock: kick send_pkt worker once device is started
> > 
> > Should this fix also be CC-ed to stable? Sorry I forgot to cc it to stable.
> > 
> > --
> > Cheers,
> > Justin (Jia He)
> 
> 
> Go ahead, though recently just including Fixes seems to be enough.

You are getting lucky if you only apply a "Fixes:" tag, as that is much
lower down our list of things to look at.  We are forced to do that
because of subsystems and maintainers that do not use the cc: stable
tag, as has been documented for the patch 15+ years :(

So please be explicit if you know you want it merged to the stable
trees, otherwise it is not a guarantee at all if you only use "fixes:".

thanks,

greg k-h
