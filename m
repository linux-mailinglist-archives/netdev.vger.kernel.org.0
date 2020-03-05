Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF0EE17A76A
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 15:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726271AbgCEO3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 09:29:12 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:25848 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725880AbgCEO3L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 09:29:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1583418551; x=1614954551;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=h3rUPDGzMA38aEW95vO6qYZkreMqrEqH16spjYa9gDk=;
  b=tlTU9gYCUj+5zB9ZpDENM+FtrfFNn4u7jWCt4lf1Wfffkr51RUqSaccJ
   aHNxIkVtL8TjFwq7msZcWk8ntPjPzsLY38UqlBibFaOf81lc+yGPfQSM6
   CYRPKOs9+Ctd/Hbd3ZIcGToIW4N5xqvPAm+n0tEPYUdUcLw2fjZaMNadW
   Y=;
IronPort-SDR: 2gK8bSGiIiATd2McMUXYBzGY2JDBLvaj70p7u1MxI1wsfj6R2wymXojKu5ndgh7GDaNTPn8B7/
 Qgie1Qw+vt5g==
X-IronPort-AV: E=Sophos;i="5.70,518,1574121600"; 
   d="scan'208";a="29448283"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-119b4f96.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 05 Mar 2020 14:29:09 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-119b4f96.us-west-2.amazon.com (Postfix) with ESMTPS id 7FB701A80AD;
        Thu,  5 Mar 2020 14:29:08 +0000 (UTC)
Received: from EX13D06EUA003.ant.amazon.com (10.43.165.206) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1236.3; Thu, 5 Mar 2020 14:29:08 +0000
Received: from EX13D22EUA004.ant.amazon.com (10.43.165.129) by
 EX13D06EUA003.ant.amazon.com (10.43.165.206) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 5 Mar 2020 14:29:07 +0000
Received: from EX13D22EUA004.ant.amazon.com ([10.43.165.129]) by
 EX13D22EUA004.ant.amazon.com ([10.43.165.129]) with mapi id 15.00.1367.000;
 Thu, 5 Mar 2020 14:29:07 +0000
From:   "Kiyanovski, Arthur" <akiyano@amazon.com>
To:     Leon Romanovsky <leon@kernel.org>,
        David Miller <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Agroskin, Shay" <shayagr@amazon.com>,
        "Jubran, Samih" <sameehj@amazon.com>
Subject: RE: [RESEND PATCH V1 net-next] net: ena: fix broken interface between
 ENA driver and FW
Thread-Topic: [RESEND PATCH V1 net-next] net: ena: fix broken interface
 between ENA driver and FW
Thread-Index: AQHV7IwHKl+97IhQuEmcElMR/H8Ee6gueR+AgAVOa4CABlNp4A==
Date:   Thu, 5 Mar 2020 14:28:33 +0000
Deferred-Delivery: Thu, 5 Mar 2020 14:28:24 +0000
Message-ID: <37c7130a38ab46cda8a0f7a3e07e7fa3@EX13D22EUA004.ant.amazon.com>
References: <1582711415-4442-1-git-send-email-akiyano@amazon.com>
 <20200226.204809.102099518712120120.davem@davemloft.net>
 <20200301135007.GS12414@unreal>
In-Reply-To: <20200301135007.GS12414@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.164.41]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Leon Romanovsky <leon@kernel.org>
> Sent: Sunday, March 1, 2020 3:50 PM
> To: David Miller <davem@davemloft.net>
> Cc: Kiyanovski, Arthur <akiyano@amazon.com>; netdev@vger.kernel.org;
> Woodhouse, David <dwmw@amazon.co.uk>; Machulsky, Zorik
> <zorik@amazon.com>; Matushevsky, Alexander <matua@amazon.com>;
> Bshara, Saeed <saeedb@amazon.com>; Wilson, Matt <msw@amazon.com>;
> Liguori, Anthony <aliguori@amazon.com>; Bshara, Nafea
> <nafea@amazon.com>; Tzalik, Guy <gtzalik@amazon.com>; Belgazal, Netanel
> <netanel@amazon.com>; Saidi, Ali <alisaidi@amazon.com>; Herrenschmidt,
> Benjamin <benh@amazon.com>; Dagan, Noam <ndagan@amazon.com>;
> Agroskin, Shay <shayagr@amazon.com>; Jubran, Samih
> <sameehj@amazon.com>
> Subject: Re: [RESEND PATCH V1 net-next] net: ena: fix broken interface be=
tween
> ENA driver and FW
>=20
> On Wed, Feb 26, 2020 at 08:48:09PM -0800, David Miller wrote:
> > From: <akiyano@amazon.com>
> > Date: Wed, 26 Feb 2020 12:03:35 +0200
> >
> > > From: Arthur Kiyanovski <akiyano@amazon.com>
> > >
> > > In this commit we revert the part of commit 1a63443afd70
> > > ("net/amazon: Ensure that driver version is aligned to the linux
> > > kernel"), which breaks the interface between the ENA driver and FW.
> > >
> > > We also replace the use of DRIVER_VERSION with DRIVER_GENERATION
> > > when we bring back the deleted constants that are used in interface
> > > with ENA device FW.
> > >
> > > This commit does not change the driver version reported to the user
> > > via ethtool, which remains the kernel version.
> > >
> > > Fixes: 1a63443afd70 ("net/amazon: Ensure that driver version is
> > > aligned to the linux kernel")
> > > Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
> >
> > Applied.
>=20
> Dave,
>=20
> I see that I'm late here and my email sounds like old man grumbling, but =
I asked
> from those guys to update their commit with request to put the following =
line:
> "/* DO NOT CHANGE DRV_MODULE_GEN_* values in in-tree code */"
> https://lore.kernel.org/netdev/20200224162649.GA4526@unreal/
>=20
> I also asked how those versions are transferred to FW and used there, but=
 was
> ignored.
> https://lore.kernel.org/netdev/20200224094116.GD422704@unreal/
>=20
> BTW, It is also unclear why I wasn't CCed in this patch.
>=20
> Thanks

Leon,
 Sorry for not responding earlier to your inquiries, they are exactly touch=
ing the
 points that we would like to discuss.
 Up until now, we in AWS, have been monitoring the drivers in the datacente=
r using the
 driver version, and actively suggesting driver updates to our customers
 whenever a critical bug was fixed, or a new important feature was added.
 Removing the driver version and not allowing to maintain our own internal
 version negatively impacts our effort to give our customers the best possi=
ble cloud
 experience. We therefore prefer to maintain using our internal driver vers=
ion.

 Are there any other recommended ways to achieve our goal without a driver
 version?
=20
 Thanks!

