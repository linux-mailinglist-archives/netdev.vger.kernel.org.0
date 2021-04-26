Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0D536B10E
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 11:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232954AbhDZJvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 05:51:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:35660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232239AbhDZJv3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Apr 2021 05:51:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3EE98610A5;
        Mon, 26 Apr 2021 09:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619430647;
        bh=5HK7sHxtSNFTvEowRYNk3JfWcvB1OJlsfiq4lhdMea4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VwlwhaKhG0Sib4seccmy6Azz+GwQS6EmVmoqM5RFbKA13KYdW/XtmANzxcPc9ef55
         NUU8ahsJp80dYw9dxvItK9tCdaSZq9du+Q5Anh95xOoT06Qz/9Z7al9sie7sX5gfUh
         9n7mQaIGYfEtVN1KICrlKbxZ/SSTOjb8BdxTPzEk=
Date:   Mon, 26 Apr 2021 11:50:44 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     Leonardo Antoniazzi <leoanto@aruba.it>, linux-usb@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Anirudh Rayabharam <mail@anirudhrb.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: hso: fix NULL-deref on disconnect regression
Message-ID: <YIaM9B/UZ1qHAC9+@kroah.com>
References: <20210426081149.10498-1-johan@kernel.org>
 <20210426112911.fb3593c3a9ecbabf98a13313@aruba.it>
 <YIaJcgmiJFERvbEF@hovoldconsulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YIaJcgmiJFERvbEF@hovoldconsulting.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 26, 2021 at 11:35:46AM +0200, Johan Hovold wrote:
> On Mon, Apr 26, 2021 at 11:29:11AM +0200, Leonardo Antoniazzi wrote:
> > On Mon, 26 Apr 2021 10:11:49 +0200
> > Johan Hovold <johan@kernel.org> wrote:
> > 
> > > Commit 8a12f8836145 ("net: hso: fix null-ptr-deref during tty device
> > > unregistration") fixed the racy minor allocation reported by syzbot, but
> > > introduced an unconditional NULL-pointer dereference on every disconnect
> > > instead.
> > > 
> > > Specifically, the serial device table must no longer be accessed after
> > > the minor has been released by hso_serial_tty_unregister().
> > > 
> > > Fixes: 8a12f8836145 ("net: hso: fix null-ptr-deref during tty device unregistration")
> > > Cc: stable@vger.kernel.org
> > > Cc: Anirudh Rayabharam <mail@anirudhrb.com>
> > > Reported-by: Leonardo Antoniazzi <leoanto@aruba.it>
> > > Signed-off-by: Johan Hovold <johan@kernel.org>
> > > ---
> 
> > the patch fix the problem
> 
> Thanks for confirming.
> 
> Next time, please keep the CC list intact when replying so that everyone
> sees that you've tested it.

Wonderful.  Johan, thanks for the quick fix.

netdev maintainers, mind if I take this fix through my tree to Linus
this week, or can you all get it to him before -rc1 through the
networking tree?

thanks,

greg k-h
