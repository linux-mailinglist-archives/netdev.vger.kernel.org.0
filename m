Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1932F5294
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 19:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728701AbhAMSmU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 13:42:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:42388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728371AbhAMSmQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 13:42:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A949D20739;
        Wed, 13 Jan 2021 18:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610563296;
        bh=Ajzo2UBqkOaFrPPXDMrjn/7W1vN7CH5O7vtnoKth8Vg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=g6+QzsrOVfLU0b9SBZcswCgc/mrafX6+DTvUhFlHAj+mVSGv7rqUVxyqXUQexVgJu
         H5QdlWNMu7XljVhdPL3FzxqCNNaycvLgKRF+vaZuf2cKVYAMuF2e8KxTd/iCUXbwTg
         Jyd/fZ4DsKSzf+Ft/z1c6nz8x0tsh7RZzxSdeHXFFmz9j4WiZUQsdANvmcAxAkGqBN
         AqUKni/XpJt2puNsKisa7rx2jnZbFZeoEIHxgxjudmGDKi9Wo9AlfCNJOkMqf7kowg
         mbWZs9FfQh6Id1IXyREYPKLNv3DGumoT9co6dFJo7v+0+k3YcJUOkFt6vHKCWXyezb
         u62aURau6GSiA==
Date:   Wed, 13 Jan 2021 10:41:34 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Howells <dhowells@redhat.com>
Cc:     netdev@vger.kernel.org,
        Baptiste Lepers <baptiste.lepers@gmail.com>,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] rxrpc: Call state should be read with READ_ONCE()
 under some circumstances
Message-ID: <20210113104134.40e9ebae@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <2630109.1610526234@warthog.procyon.org.uk>
References: <20210112182533.13b1c787@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <161046715522.2450566.488819910256264150.stgit@warthog.procyon.org.uk>
        <2630109.1610526234@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 Jan 2021 08:23:54 +0000 David Howells wrote:
> Jakub Kicinski <kuba@kernel.org> wrote:
> 
> > On Tue, 12 Jan 2021 15:59:15 +0000 David Howells wrote:  
> > > From: Baptiste Lepers <baptiste.lepers@gmail.com>
> > > 
> > > The call state may be changed at any time by the data-ready routine in
> > > response to received packets, so if the call state is to be read and acted
> > > upon several times in a function, READ_ONCE() must be used unless the call
> > > state lock is held.
> > > 
> > > As it happens, we used READ_ONCE() to read the state a few lines above the
> > > unmarked read in rxrpc_input_data(), so use that value rather than
> > > re-reading it.
> > > 
> > > Signed-off-by: Baptiste Lepers <baptiste.lepers@gmail.com>
> > > Signed-off-by: David Howells <dhowells@redhat.com>  
> > 
> > Fixes: a158bdd3247b ("rxrpc: Fix call timeouts")
> > 
> > maybe?  
> 
> Ah, yes.  I missed there wasn't a Fixes line.  Can you add that one in, or do
> I need to resubmit the patch?

Sure, added, just checking if you didn't leave it out on purpose.

Applied, thanks!
