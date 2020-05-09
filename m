Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F02DB1CC4FE
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 00:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728611AbgEIWjo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 18:39:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:46752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726771AbgEIWjn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 May 2020 18:39:43 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3643821473;
        Sat,  9 May 2020 22:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589063983;
        bh=SwQUS2Nt2C8FBvN11lGb6nzUbV64QKYF4/J0HiSqlRU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CVNbL4ksp91+dUs+vz47oyZ7p/mbQA1Iby6izWutLBGFbm4+7KM3jeamMIbqGi5In
         7OSkwBp3Dfny+nbscPdTYVHvP9MBH8lNGT9w58UB2ftCdRXhswFYYZJcd3hTOo2d/g
         U4DYV/bRr1GGnf0MMA9xoL/wR00BVb0fdVgVx1ws=
Date:   Sat, 9 May 2020 15:39:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stephen Kitt <steve@sk2.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Joe Perches <joe@perches.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: Protect INET_ADDR_COOKIE on 32-bit
 architectures
Message-ID: <20200509153941.03088923@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200509224928.26d44ac4@heffalump.sk2.org>
References: <20200508120457.29422-1-steve@sk2.org>
        <20200508205025.3207a54e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200509101322.12651ba0@heffalump.sk2.org>
        <20200509105914.04fd19c8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200509210548.116c7385@heffalump.sk2.org>
        <20200509224928.26d44ac4@heffalump.sk2.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 9 May 2020 22:49:28 +0200 Stephen Kitt wrote:
> On Sat, 9 May 2020 21:05:48 +0200, Stephen Kitt <steve@sk2.org> wrote:
> > On Sat, 9 May 2020 10:59:14 -0700, Jakub Kicinski <kuba@kernel.org> wro=
te: =20
> > > What if we went back to your original proposal of an empty struct but
> > > added in an extern in front? That way we should get linker error on
> > > pointer references.   =20
> >=20
> > That silently fails to fail if any other link object provides a definit=
ion
> > for the symbol, even if the type doesn=E2=80=99t match... =20
>=20
> And it breaks the build if INET_ADDR_COOKIE is used twice in the same uni=
t,
> e.g. in inet_hashtables.c.

Ah, so we'd have to use a valid type like, say, char.
