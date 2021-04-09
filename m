Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34C03359641
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 09:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231761AbhDIHUh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 03:20:37 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.51]:31259 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231675AbhDIHUg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 03:20:36 -0400
X-Greylist: delayed 536 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Apr 2021 03:20:36 EDT
ARC-Seal: i=1; a=rsa-sha256; t=1617952102; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=od1vyhFW61SKsfyryISOtz3sQDNdFyJHp8ZmjFBwsPN6WRQIjj5c0YZ1cSQIioMZlM
    7eN1UMr1+onaviJrXJSt8eJ48uWgGIyB+iWc0XQF8Z7vzJAfRPge9ZDF26zx23W0JXJT
    DiHDJYBlX7nCLuYkkdIoYQXf3IKcWGhlau3nQNYgFB03KlWBdMwy16p5YO+Whmq1y9D6
    2W6cbD6yw7hr9k1epA4HG1aMcMuGqDN3woayP9FPBqsb6dlwDLW8u8+Vw8B4+O4cFSpe
    GO+X9EOCtrAlOOYw8Xq+DsqbLAmYiDuSFhGLQ1tC4+5+e6+I/86VI1RH26pGQbcHiUOg
    C0eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1617952102;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=Bg6gn2LOvwTZ42howqjgccJ3uIiQX7ptCiz4jhSxmsA=;
    b=WP1jGw5mZVdj+254EruxVNcjGvPkUIztWcfOP1xxyWCWSsOmmMvDV2JRcKE0hLI18o
    qsA/q2QDVQl+Y+X/KyDQPyQG3rV8kHK+GY/knOjv4b4FHNaHvwkeDLw8w6j8B/EbWbgH
    aejz6sFhVHxsKVLlwxd5tURxBYMetypMoAEn36zYsolWNVy6+GX5sRYrNy0g5F5/E1rt
    j6OZFAs1DjblymWl2s/u/btsvfHco8crRhmxYhLk/+wuSzd7PHGqBRjpk6ljHjhItswF
    osAqRQgJKK/0P/ZEhuOuRDaMoe5TAIoTdXud7CsKdcvdSu9iDXltKa9NsNLZ1ZHXupG+
    HGlw==
ARC-Authentication-Results: i=1; strato.com;
    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1617952102;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=Bg6gn2LOvwTZ42howqjgccJ3uIiQX7ptCiz4jhSxmsA=;
    b=EZ/4R+OCZU8lp+IC9v/0CvzdQsI+6FPgJShMPFpwhsMdpMJbgXYTINwnvS9qr/ndhc
    /NtzppttEnEyZO3kQSSPjuOGuoMpRVBtFk4tXrjDph8svc3ZYiLy/yK3gNaDoewXRrkM
    +RH1tte6mx6/0POaFi7GdZLD15BjdqExstMurGSyywmEshewIdn68eaMUaNE7oYcvvCY
    BjFXJnHfUu9/A7SEk6b5PNgu0pBqAMQqB+C0CfMLp0O1czhlJy2NjloGJV02DT/FFh+2
    iycUug6C3HrJ3sa42/N0hhOECyvnAcv/M/nA5IRIGP09VnjOgx12EkPR+My4C8jgrjyW
    7oQA==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNzyCzy1Sfr67uExK884EC0GFGHavJSpCkMFYXg=="
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
    by smtp.strato.de (RZmta 47.24.0 DYNA|AUTH)
    with ESMTPSA id R06d2dx3978LC2i
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Fri, 9 Apr 2021 09:08:21 +0200 (CEST)
Message-ID: <7c2b6eff291b2d326e96c3a5f9cd70aa4ef92df3.camel@chronox.de>
Subject: Re: [PATCH net-next] [RESEND] wireguard: disable in FIPS mode
From:   Stephan Mueller <smueller@chronox.de>
To:     Hangbin Liu <liuhangbin@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>
Cc:     netdev@vger.kernel.org, "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        linux-crypto@vger.kernel.org
Date:   Fri, 09 Apr 2021 09:08:20 +0200
In-Reply-To: <20210409021121.GK2900@Leo-laptop-t470s>
References: <20210407113920.3735505-1-liuhangbin@gmail.com>
         <YG4gO15Q2CzTwlO7@quark.localdomain>
         <20210408010640.GH2900@Leo-laptop-t470s>
         <20210408115808.GJ2900@Leo-laptop-t470s> <YG8dJpEEWP3PxUIm@sol.localdomain>
         <20210409021121.GK2900@Leo-laptop-t470s>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Freitag, dem 09.04.2021 um 10:11 +0800 schrieb Hangbin Liu:
> On Thu, Apr 08, 2021 at 08:11:34AM -0700, Eric Biggers wrote:
> > On Thu, Apr 08, 2021 at 07:58:08PM +0800, Hangbin Liu wrote:
> > > On Thu, Apr 08, 2021 at 09:06:52AM +0800, Hangbin Liu wrote:
> > > > > Also, couldn't you just consider WireGuard to be outside your FIPS
> > > > > module
> > > > > boundary, which would remove it from the scope of the certification?
> > > > > 
> > > > > And how do you handle all the other places in the kernel that use
> > > > > ChaCha20 and
> > > > > SipHash?  For example, drivers/char/random.c?
> > > > 
> > > > Good question, I will check it and reply to you later.
> > > 
> > > I just read the code. The drivers/char/random.c do has some fips
> > > specific
> > > parts(seems not related to crypto). After commit e192be9d9a30 ("random:
> > > replace
> > > non-blocking pool with a Chacha20-based CRNG") we moved part of chacha
> > > code to
> > > lib/chacha20.c and make that code out of control.
> > > 
> > So you are saying that you removed drivers/char/random.c and
> > lib/chacha20.c from
> > your FIPS module boundary?  Why not do the same for WireGuard?
> 
> No, I mean this looks like a bug (using not allowed crypto in FIPS mode) and
> we should fix it.

The entirety of random.c is not compliant to FIPS rules. ChaCha20 is the least
of the problems. SP800-90B is the challenge. This is one of the motivation of
the design and architecture of the LRNG allowing different types of crypto and
have a different approach to post-process the data.

https://github.com/smuellerDD/lrng

Ciao
Stephan
> 
> Thanks
> Hangbin


