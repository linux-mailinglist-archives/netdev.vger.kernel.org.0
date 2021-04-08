Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC1E73587EF
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 17:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232071AbhDHPL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 11:11:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:43694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231848AbhDHPL6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 11:11:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BE58610F9;
        Thu,  8 Apr 2021 15:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617894706;
        bh=bMl0ZspmxcDB+rdC2aWpV/e54pDlpgNYgQrS5CBCgww=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lYUeGcO10VSf9p+yUdo9CkkX3KcPvxSgTjbgFg68zvDLnNzjeSXbComUqrWid70N/
         tAV2XZ+UqrS7wtXFRMMeEGYhDjWhirxUvt+0JzZsrADzsP6ZI4QVdJtSsaRkTzpSqE
         R6RQlkhFmzOzRukvf9SiCLTBgkFvrSTyVFLd6QaqBigGMP5AufjfFXBnrF+ymnzRox
         3sjXAxWDxDATV4wATbTMqvwEW0Bw9Y9a9CbiAA82nXzm90Y93Su4/MpTtj74sy4Nsy
         MBZTqQFn+f0U/sEHeUevoTY4nNMOtJVkRM7ekHBCU/wfPj3CxY8+Or5gN0QA+BClOk
         LI7awGyZp7O9g==
Date:   Thu, 8 Apr 2021 08:11:34 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH net-next] [RESEND] wireguard: disable in FIPS mode
Message-ID: <YG8dJpEEWP3PxUIm@sol.localdomain>
References: <20210407113920.3735505-1-liuhangbin@gmail.com>
 <YG4gO15Q2CzTwlO7@quark.localdomain>
 <20210408010640.GH2900@Leo-laptop-t470s>
 <20210408115808.GJ2900@Leo-laptop-t470s>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210408115808.GJ2900@Leo-laptop-t470s>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 08, 2021 at 07:58:08PM +0800, Hangbin Liu wrote:
> On Thu, Apr 08, 2021 at 09:06:52AM +0800, Hangbin Liu wrote:
> > > Also, couldn't you just consider WireGuard to be outside your FIPS module
> > > boundary, which would remove it from the scope of the certification?
> > > 
> > > And how do you handle all the other places in the kernel that use ChaCha20 and
> > > SipHash?  For example, drivers/char/random.c?
> > 
> > Good question, I will check it and reply to you later.
> 
> I just read the code. The drivers/char/random.c do has some fips specific
> parts(seems not related to crypto). After commit e192be9d9a30 ("random: replace
> non-blocking pool with a Chacha20-based CRNG") we moved part of chacha code to
> lib/chacha20.c and make that code out of control.
> 

So you are saying that you removed drivers/char/random.c and lib/chacha20.c from
your FIPS module boundary?  Why not do the same for WireGuard?

- Eric
