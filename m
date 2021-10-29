Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14007440037
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 18:19:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbhJ2QWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 12:22:14 -0400
Received: from forwardcorp1o.mail.yandex.net ([95.108.205.193]:35894 "EHLO
        forwardcorp1o.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229607AbhJ2QWN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 12:22:13 -0400
X-Greylist: delayed 597 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Oct 2021 12:22:13 EDT
Received: from iva8-d2cd82b7433e.qloud-c.yandex.net (iva8-d2cd82b7433e.qloud-c.yandex.net [IPv6:2a02:6b8:c0c:a88e:0:640:d2cd:82b7])
        by forwardcorp1o.mail.yandex.net (Yandex) with ESMTP id E55202E098A;
        Fri, 29 Oct 2021 19:19:43 +0300 (MSK)
Received: from iva8-3a65cceff156.qloud-c.yandex.net (iva8-3a65cceff156.qloud-c.yandex.net [2a02:6b8:c0c:2d80:0:640:3a65:ccef])
        by iva8-d2cd82b7433e.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id RplQ8v0pXd-Jhs4YuoN;
        Fri, 29 Oct 2021 19:19:43 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1635524383; bh=jkZiO6HeZILWYqa3y1Z77EHPtdmQ6z8S3AcwbejZFng=;
        h=Message-Id:References:Date:Subject:Cc:To:In-Reply-To:From;
        b=z3E9PEtTZ2p68Cwvom0Apo4Q4VqWulvZ4fvKFpzNUysOwkeUlO7kV53qAsaibNmin
         EFnNrn0hbHqs2m+Kt6Vj+FJ3G36FMeXn0gu2kPrfxaNy0cPphGP3Y1X+qcnEsh23xy
         /7CkayPQa9weDKpUzqJF2F0aLyMHOrp99trd5zMA=
Authentication-Results: iva8-d2cd82b7433e.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from smtpclient.apple (dynamic-vpn.dhcp.yndx.net [2a02:6b8:b081:8931::1:8])
        by iva8-3a65cceff156.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPS id zTe4jxeMVr-Jh08fcZj;
        Fri, 29 Oct 2021 19:19:43 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
X-Yandex-Fwd: 2
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.100.0.2.22\))
Subject: Re: [PATCH] tcp: Use BPF timeout setting for SYN ACK RTO
From:   Akhmat Karakotov <hmukos@yandex-team.ru>
In-Reply-To: <87d9c47b-1797-3f9a-9707-48d2b398dba3@gmail.com>
Date:   Fri, 29 Oct 2021 19:19:42 +0300
Cc:     Alexander Azimov <mitradir@yandex-team.ru>, zeil@yandex-team.ru,
        Lawrence Brakmo <brakmo@fb.com>, netdev@vger.kernel.org,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <2A707577-CBEA-42C9-A234-2C2AB7E7F7BB@yandex-team.ru>
References: <20211025121253.8643-1-hmukos@yandex-team.ru>
 <b8700d59-d533-71ee-f8c3-b7f0906debc5@gmail.com>
 <6178131635190015@myt6-af0b0b987ed8.qloud-c.yandex.net>
 <87d9c47b-1797-3f9a-9707-48d2b398dba3@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
X-Mailer: Apple Mail (2.3654.100.0.2.22)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On Oct 25, 2021, at 23:48, Eric Dumazet <eric.dumazet@gmail.com> =
wrote:
>=20
> Also, have you checked if TCP syn cookies would still work
> if tcp_timeout_init() returns a small value like 5ms ?
>=20
> tcp_check_req()
> ...
> tmp_opt.ts_recent_stamp =3D ktime_get_seconds() - =
((tcp_timeout_init((struct sock *)req)/HZ)<<req->num_timeout);
>=20
> -> tmp_opt.ts_recent_stamp =3D ktime_get_seconds()
>=20
>=20

I may have overlooked this. As long as I remember TCP SYN cookies worked
but I will recheck this place again. Also could you please tell in what =
way exactly
does this relate to syn cookies? I may have misunderstood what the code =
does.=
