Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D90AB1859E
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 08:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbfEIG6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 02:58:02 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.51]:30719 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725908AbfEIG6C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 02:58:02 -0400
X-Greylist: delayed 56007 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 May 2019 02:58:01 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1557385076;
        s=strato-dkim-0002; d=fpond.eu;
        h=Subject:References:In-Reply-To:Message-ID:Cc:To:From:Date:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=lq2ThzZUgIPEzsVkvFwdCcqObMNuFuqm5D1Xn8exSCQ=;
        b=QuE7J33khPTmrI8Dg4ivF4LKn9QjsSAUQapNAATB3jETqLskdIN4fQrlfNKSOoloM1
        89mjeodbQJJAwBBBG2whUzrulDN0xB6luHSlmmp3C+vEjRpzmWbIbfrTNhdNVlM5l9nD
        SVSoHfYQN0FwRFhkUMTqlRh0G3SoDyaVvoUeryd5vUYO+wd6C2MSTp1sypq4OzPgjgA8
        9iA0L975ahgeR8XvmwVq5mkVLrUq7ZCykM0zZUbupCjMEA0x/daaPJqSVCTUnwPb1awx
        ONvieSfljx23oBgTLOUty2yqMw5OdZTwoD6c6oMOY6AaNiVaK7+o4pC+EgoS8nd2FBmE
        B/dw==
X-RZG-AUTH: ":OWANVUa4dPFUgKR/3dpvnYP0Np73amq+g13rqGzmt2bYDnKIKaws6YXTsc4="
X-RZG-CLASS-ID: mo00
Received: from oxapp01-01.back.ox.d0m.de
        by smtp-ox.front (RZmta 44.18 AUTH)
        with ESMTPSA id y08c83v496viVOV
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve X9_62_prime256v1 with 256 ECDH bits, eq. 3072 bits RSA))
        (Client did not present a certificate);
        Thu, 9 May 2019 08:57:44 +0200 (CEST)
Date:   Thu, 9 May 2019 08:57:44 +0200 (CEST)
From:   Ulrich Hecht <uli@fpond.eu>
To:     =?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc:     Ulrich Hecht <uli+renesas@fpond.eu>,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, wsa@the-dreams.de, horms@verge.net.au,
        magnus.damm@gmail.com
Message-ID: <434070244.1141414.1557385064484@webmail.strato.com>
In-Reply-To: <20190508165219.GA26309@bigcity.dyn.berto.se>
References: <1557328882-24307-1-git-send-email-uli+renesas@fpond.eu>
 <1f7be29e-c85a-d63d-c83f-357a76e8ca45@cogentembedded.com>
 <20190508165219.GA26309@bigcity.dyn.berto.se>
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


> On May 8, 2019 at 6:52 PM Niklas S=C3=B6derlund <niklas.soderlund@ragnate=
ch.se> wrote:
>=20
>=20
> Hi Sergei,
>=20
> On 2019-05-08 18:59:01 +0300, Sergei Shtylyov wrote:
> > Hello!
> >=20
> > On 05/08/2019 06:21 PM, Ulrich Hecht wrote:
> >=20
> > > Uses the same method as various other drivers: shut the device down,
> > > change the MTU, then bring it back up again.
> > >=20
> > > Tested on Renesas D3 Draak board.
> > >=20
> > > Signed-off-by: Ulrich Hecht <uli+renesas@fpond.eu>
> >=20
> >    You should have CC'ed me (as an reviewer for the Renesas drivers).

Sorry, will do next time.

> >=20
> >    How about the code below instead?
> >=20
> > =09if (netif_running(ndev))
> > =09=09ravb_close(ndev);
> >=20
> >  =09ndev->mtu =3D new_mtu;
> > =09netdev_update_features(ndev);
>=20
> Is there a need to call netdev_update_features() even if the if is not=20
> running?

In my testing, it didn't seem so.

CU
Uli
