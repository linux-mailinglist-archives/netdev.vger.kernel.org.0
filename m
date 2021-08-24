Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 384923F6858
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 19:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234028AbhHXRpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 13:45:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:50226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238532AbhHXRoI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Aug 2021 13:44:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 005E8610A7;
        Tue, 24 Aug 2021 17:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629827004;
        bh=4jCvr+I/iLOJvuIZpXwCpkufSGJtYNJRnIqcDzGS90s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=A9ARQUt0vw+7rroTHf0ZfULpG2YK1z6zZlSpdXHcfZQu+VORfWHYotzOR9wAO3Eqx
         6Yo92ir+34bNI0Lm63JDJkm6FY1TUlEGVOpVlRxkiRqxTEPcBSUT0rPFn5KgrxmE89
         2CRckcUq5290ZUjyTCnP9cpyZH0za/BhNOTemIG/VxZ4WAZjXbOAMx9c+PZrYjx3z0
         PpYf35tR7m9FPE7OHDEwqGSyeHqC4xoFvTcrl+dpN06/fzLPM5UXHBjfZxFW8/zcjn
         fP2j6VjCc0uphRUaSQ8Fkf/5JEOk+Ve3COCJWVyI4Cev85MBrxUoXwWfriinv5N9cV
         MJjL/sEvLGHlw==
Date:   Tue, 24 Aug 2021 10:43:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     andrew@lunn.ch, netdev@vger.kernel.org, dcavalca@fb.com,
        filbranden@fb.com, michel@fb.com
Subject: Re: [PATCH ethtool 2/3] ethtool: use dummy args[] entry for no-args
 case
Message-ID: <20210824104323.12dce041@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210824174123.h6iispbooeqrychw@lion.mk-sys.cz>
References: <20210813171938.1127891-1-kuba@kernel.org>
        <20210813171938.1127891-3-kuba@kernel.org>
        <20210824174123.h6iispbooeqrychw@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Aug 2021 19:41:23 +0200 Michal Kubecek wrote:
> On Fri, Aug 13, 2021 at 10:19:37AM -0700, Jakub Kicinski wrote:
> > Note that this patch adds a false-positive warning with GCC 11:
> >=20
> > ethtool.c: In function =E2=80=98find_option=E2=80=99:
> > ethtool.c:6082:29: warning: offset =E2=80=981=E2=80=99 outside bounds o=
f constant string [-Warray-bounds]
> >  6082 |                         opt +=3D len + 1;
> >       |                         ~~~~^~~~~~~~~~
> >=20
> > we'll never get to that code if the string is empty. =20
>=20
> Unless I missed something, an easy workaround should be starting the
> loop in find_option() from 1 rather than from 0. It would IMHO even make
> more sense as there is little point comparing the first argument against
> the dummy args[0] entry.

SGTM, will you commit a patch or should I send one?
