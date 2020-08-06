Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD97323E160
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 20:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728249AbgHFSrA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 14:47:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:35966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725927AbgHFSrA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Aug 2020 14:47:00 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0EB520855;
        Thu,  6 Aug 2020 18:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596739620;
        bh=Y0WLyMYc/6bL6sF+tllMOotA+LW00xdgYY/+OD2U6vU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PLgazSnh6Q7APAOQ9R2fEqDg3eJ4DImjX6Wk/9tQpbYrG5For71BgmDQraXcuOZpT
         YlLeFd2JjAqBeXiGVCqAgj2Ti3AKcgE9K3ByGwRJl7SDifQRfAF5aM70EGZHVbs/rp
         y6+jtIYUseHPvJviOSur5eW3dE5xTX2JRH4naccU=
Date:   Thu, 6 Aug 2020 11:46:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rouven Czerwinski <r.czerwinski@pengutronix.de>
Cc:     Boris Pismenny <borisp@mellanox.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next] net/tls: allow MSG_CMSG_COMPAT in sendmsg
Message-ID: <20200806114657.42f1ce8c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200806064906.14421-1-r.czerwinski@pengutronix.de>
References: <20200806064906.14421-1-r.czerwinski@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  6 Aug 2020 08:49:06 +0200 Rouven Czerwinski wrote:
> Trying to use ktls on a system with 32-bit userspace and 64-bit kernel
> results in a EOPNOTSUPP message during sendmsg:
>=20
>   setsockopt(3, SOL_TLS, TLS_TX, =E2=80=A6, 40) =3D 0
>   sendmsg(3, =E2=80=A6, msg_flags=3D0}, 0) =3D -1 EOPNOTSUPP (Operation n=
ot supported)
>=20
> The tls_sw implementation does strict flag checking and does not allow
> the MSG_CMSG_COMPAT flag, which is set if the message comes in through
> the compat syscall.
>=20
> This patch adds MSG_CMSG_COMPAT to the flag check to allow the usage of
> the TLS SW implementation on systems using the compat syscall path.
>=20
> Note that the same check is present in the sendmsg path for the TLS
> device implementation, however the flag hasn't been added there for lack
> of testing hardware.
>=20
> Signed-off-by: Rouven Czerwinski <r.czerwinski@pengutronix.de>

I don't know much about the compat stuff, I trust our cmsg handling is
fine?

Just to be sure - did you run tools/testing/selftests/net/tls ?
