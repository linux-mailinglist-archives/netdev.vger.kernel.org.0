Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B340B18D04
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 17:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbfEIPcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 11:32:31 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.53]:34152 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbfEIPcb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 11:32:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1557415949;
        s=strato-dkim-0002; d=fpond.eu;
        h=Subject:References:In-Reply-To:Message-ID:Cc:To:From:Date:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=Vtv+jgeVgNdjXl2W9P9Zxp/xrhkh/2eKFcG2rY6WA74=;
        b=sEfcMevmmDAhtPcKRKtHyUe30rhnkeH91wS4zN34dSBxw93AKg25qax0dBs87qWXWn
        1usKvuTIS4ako3qwOzIIPoWLS2fKvJSkxxn8l836m9WC+v2pjP5mdEnwqZROuKlsiK+R
        jngdHjhHy35onU5QXgIcI8hG32/nfTgUNp/+LCZPONbEZK+JmPLTh4pX2/zIy9wTBxyb
        XHSomfm0jvdfX9ivge2gH00mIRTeeerFai32GqJ6JieCbaoErl7ci1TAB9213/0sJ6zk
        fAeiZuO5rU89sBRJRicNkPqI/mjnDn7k4QEn8IqAXKdFArC+qSbXquV+nBsZa+N2PAnh
        3p3A==
X-RZG-AUTH: ":OWANVUa4dPFUgKR/3dpvnYP0Np73amq+g13rqGzmt2bYDnKIKaws6YXTsc4="
X-RZG-CLASS-ID: mo00
Received: from oxapp01-01.back.ox.d0m.de
        by smtp-ox.front (RZmta 44.18 AUTH)
        with ESMTPSA id y08c83v49FWLYBZ
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve X9_62_prime256v1 with 256 ECDH bits, eq. 3072 bits RSA))
        (Client did not present a certificate);
        Thu, 9 May 2019 17:32:21 +0200 (CEST)
Date:   Thu, 9 May 2019 17:32:21 +0200 (CEST)
From:   Ulrich Hecht <uli@fpond.eu>
To:     Simon Horman <horms@verge.net.au>
Cc:     =?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, wsa@the-dreams.de, magnus.damm@gmail.com
Message-ID: <344020243.1186987.1557415941124@webmail.strato.com>
In-Reply-To: <20190509101020.4ozvazptoy53gh55@verge.net.au>
References: <1557328882-24307-1-git-send-email-uli+renesas@fpond.eu>
 <1f7be29e-c85a-d63d-c83f-357a76e8ca45@cogentembedded.com>
 <20190508165219.GA26309@bigcity.dyn.berto.se>
 <434070244.1141414.1557385064484@webmail.strato.com>
 <20190509101020.4ozvazptoy53gh55@verge.net.au>
Subject: Re: [PATCH] ravb: implement MTU change while device is up
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.8.4-Rev55
X-Originating-IP: 85.212.120.228
X-Originating-Client: open-xchange-appsuite
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On May 9, 2019 at 12:10 PM Simon Horman <horms@verge.net.au> wrote:
>=20
>=20
> On Thu, May 09, 2019 at 08:57:44AM +0200, Ulrich Hecht wrote:
> >=20
> > > On May 8, 2019 at 6:52 PM Niklas S=C3=B6derlund <niklas.soderlund@rag=
natech.se> wrote:
> > >=20
> > >=20
> > > Hi Sergei,
> > >=20
> > > On 2019-05-08 18:59:01 +0300, Sergei Shtylyov wrote:
> > > > Hello!
> > > >=20
> > > > On 05/08/2019 06:21 PM, Ulrich Hecht wrote:
> > > >=20
> > > > > Uses the same method as various other drivers: shut the device do=
wn,
> > > > > change the MTU, then bring it back up again.
> > > > >=20
> > > > > Tested on Renesas D3 Draak board.
> > > > >=20
> > > > > Signed-off-by: Ulrich Hecht <uli+renesas@fpond.eu>
> > > >=20
> > > >    You should have CC'ed me (as an reviewer for the Renesas drivers=
).
> >=20
> > Sorry, will do next time.
> >=20
> > > >=20
> > > >    How about the code below instead?
> > > >=20
> > > > =09if (netif_running(ndev))
> > > > =09=09ravb_close(ndev);
> > > >=20
> > > >  =09ndev->mtu =3D new_mtu;
> > > > =09netdev_update_features(ndev);
> > >=20
> > > Is there a need to call netdev_update_features() even if the if is no=
t=20
> > > running?
> >=20
> > In my testing, it didn't seem so.
>=20
> That may be because your testing doesn't cover cases where it would make
> any difference.

Cases other than changing the MTU while the device is up?

CU
Uli
