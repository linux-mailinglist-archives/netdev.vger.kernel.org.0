Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7636F4589D9
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 08:31:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238727AbhKVHeO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 02:34:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:35980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232801AbhKVHeO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 02:34:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B99AC60E0B;
        Mon, 22 Nov 2021 07:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637566268;
        bh=dl/3gMUs+MfvBeIi4F4MzgtOvH+bI0D2ANXL6sgWN2s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IIKrroKgMUqA50Fgm9Tq6UQWS98KKjxf1MoFwqj/lrllejpabkMuqflVjxu4cU3aY
         /aK5GHkvVZCPgDQavUzpN19gvWrAbZznC5jauTceP2uNBemqhw35PuaNfTQP4cGEmp
         vtSbB+cpKybmgHBq4Z7pV4uxP0qejrt1h2b8RaWE=
Date:   Mon, 22 Nov 2021 08:31:05 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jeremy Kerr <jk@codeconstruct.com.au>
Cc:     netdev@vger.kernel.org, Matt Johnston <matt@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>
Subject: Re: [PATCH net-next] mctp: Add MCTP-over-serial transport binding
Message-ID: <YZtHOfdn4HQdF3LD@kroah.com>
References: <20211122042817.2988517-1-jk@codeconstruct.com.au>
 <YZs1p+lkKO+194zN@kroah.com>
 <123a5491b8485f42c9279d397cdeb6358c610f6c.camel@codeconstruct.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <123a5491b8485f42c9279d397cdeb6358c610f6c.camel@codeconstruct.com.au>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 22, 2021 at 03:16:55PM +0800, Jeremy Kerr wrote:
> > > +static DEFINE_IDA(mctp_serial_ida);
> > 
> > I think you forgot to clean this up when the module is removed.
> 
> Would it be possible to have the module exit called while we still have
> ida bitmaps still allocated? It looks like a ldisc being open will
> require a reference on the module; so a module remove will mean we have
> no ldiscs in use, and therefore an empty ida, so the ida_destroy() will
> always be a no-op.

ida_destroy() will not be a no-op if you have allocated some things in
the past.  It should always be called when your module is removed.

Or at least that is how it used to be, if this has changed in the past
year, then I am mistaken here.

thanks,

greg k-h
