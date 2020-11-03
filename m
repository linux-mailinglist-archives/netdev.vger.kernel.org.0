Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA8D92A3781
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 01:11:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726533AbgKCALI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 19:11:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:38960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725910AbgKCALI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 19:11:08 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F98722268;
        Tue,  3 Nov 2020 00:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604362268;
        bh=xYlt+o/tjn9ZZRxb1tIfDPKyepwiOGaJb6Uca7kGR3c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=zcnaO81e0v7Y9y1sUUuFFckrNwPQkecprrQFmU+Y7cP7bdyeSX/iPgXxEM6Nn1bjB
         WzkI4fUTKNQ2cao+RjHo3zHc7+AyYgIB2nHuYrqeo2Is2tJHTMep9aT3v1ndMcXNlN
         +6AfX4Pfdb/TVLNX/W07hKnM4Sp3yZOJB58WfN/Y=
Date:   Mon, 2 Nov 2020 16:11:07 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net: driver: hamradio: Fix potential
 unterminated string
Message-ID: <20201102161107.1293263f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201031181700.1081693-1-andrew@lunn.ch>
References: <20201031181700.1081693-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 31 Oct 2020 19:17:00 +0100 Andrew Lunn wrote:
> With W=3D1 the following error is reported:
>=20
> In function =E2=80=98strncpy=E2=80=99,
>     inlined from =E2=80=98hdlcdrv_ioctl=E2=80=99 at drivers/net/hamradio/=
hdlcdrv.c:600:4:
> ./include/linux/string.h:297:30: warning: =E2=80=98__builtin_strncpy=E2=
=80=99 specified bound 32 equals destination size [-Wstringop-truncation]
>   297 | #define __underlying_strncpy __builtin_strncpy
>       |                              ^
> ./include/linux/string.h:307:9: note: in expansion of macro =E2=80=98__un=
derlying_strncpy=E2=80=99
>   307 |  return __underlying_strncpy(p, q, size);
>=20
> Replace strncpy with strlcpy to guarantee the string is terminated.
>=20
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Looks like the longest name in tree is 14, so there should be no
truncation and therefore uAPI change.

Applied, thanks!
