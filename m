Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8894229925E
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 17:27:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1785861AbgJZQ1L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 12:27:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:35108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1776154AbgJZQ1L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 12:27:11 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3EA8122284;
        Mon, 26 Oct 2020 16:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603729631;
        bh=Jj7dXCUIRqXuMcm2U5jO9g/0PrOCjPgS1uEqXYKx9+4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sU6hDYuxK0umlYJ7JKxuxkqaInVTgg/FxiXTyAxCHZCQPnYukLUK0zVC0+bZ1yvCv
         ONEmDgTmQazIwtgy5/j51GFR3absqH1+GVir8MyTeWmcM+l5ak1aBK0C4VpUF0ylnO
         3WKGYvNcbTKEbotfFD+rr2haXp+qCW5eBeMXUOhA=
Date:   Mon, 26 Oct 2020 09:27:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: arping stuck with ENOBUFS in 4.19.150
Message-ID: <20201026092710.467c96e0@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <e09b367a58a0499f3bb0394596a9f87cc20eb5de.camel@infinera.com>
References: <9bede0ef7e66729034988f2d01681ca88a5c52d6.camel@infinera.com>
        <e09b367a58a0499f3bb0394596a9f87cc20eb5de.camel@infinera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Oct 2020 12:58:16 +0000 Joakim Tjernlund wrote:
> On Thu, 2020-10-22 at 17:19 +0200, Joakim Tjernlund wrote:
> > strace arping -q -c 1 -b -U  -I eth1 0.0.0.0
> > ...
> > sendto(3, "\0\1\10\0\6\4\0\1\0\6\234\v\6 \v\v\v\v\377\377\377\377\377\3=
77\0\0\0\0", 28, 0, {sa_family=3DAF_PACKET, proto=3D0x806, if4, pkttype=3DP=
ACKET_HOST, addr(6)=3D{1, ffffffffffff},
> > 20) =3D -1 ENOBUFS (No buffer space available)
> > ....
> > and then arping loops.
> >=20
> > in 4.19.127 it was:
> > sendto(3, "\0\1\10\0\6\4\0\1\0\6\234\5\271\362\n\322\212E\377\377\377\3=
77\377\377\0\0\0\0", 28, 0, {=E2=80=8Bsa_family=3DAF_PACKET, proto=3D0x806,=
 if4, pkttype=3DPACKET_HOST, addr(6)=3D{=E2=80=8B1,
> > ffffffffffff}=E2=80=8B, 20) =3D 28
> >=20
> > Seems like something has changed the IP behaviour between now and then ?
> > eth1 is UP but not RUNNING and has an IP address.

Seems like nobody knows off the top of their heads.

Any chance you can try 5.10-rc1 ? Or 5.9 ?

Or some versions in between 4.19.127 and 4.19.150 to narrow down the
search?
