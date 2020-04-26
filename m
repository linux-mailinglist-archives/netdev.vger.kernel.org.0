Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1E681B8E8F
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 11:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726143AbgDZJpf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 05:45:35 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:42449 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbgDZJpf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Apr 2020 05:45:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1587894335; x=1619430335;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=T+6u9vZ0bxvKuHm/tKvl9srn0F7hDVWZt9uYnlSxmgg=;
  b=QBa8Bc6+9pPKSVNvMrCi9C2pnYj8uwynMpYx9Eu9GctOmp1zxjsw+8AM
   EPP9lTKY/n7HoWQJv3y11n6jvKFeF04ZtEW8RV9VeVAoW3s8/GZaBrsDE
   wdxPSSSGSDuVjwTPWsCjmPvtyy2e3prpRDkGeCcyiRhKkpmoQ4FMjc16J
   8=;
IronPort-SDR: brYDmst59TEJLXPzjyjCt5PdFFIEeNjMbZNzdFOHA2Zy/L6BZGch29nAO4TskXdXkaQnMBOZ21
 0mSIohH8rKEw==
X-IronPort-AV: E=Sophos;i="5.73,319,1583193600"; 
   d="scan'208";a="31145398"
Subject: RE: [PATCH V1 net-next 02/13] net: ena: avoid unnecessary admin command when
 RSS function set fails
Thread-Topic: [PATCH V1 net-next 02/13] net: ena: avoid unnecessary admin command when RSS
 function set fails
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1e-303d0b0e.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 26 Apr 2020 09:45:33 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-303d0b0e.us-east-1.amazon.com (Postfix) with ESMTPS id A8DC2A119B;
        Sun, 26 Apr 2020 09:45:31 +0000 (UTC)
Received: from EX13D08EUC004.ant.amazon.com (10.43.164.176) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 26 Apr 2020 09:45:31 +0000
Received: from EX13D11EUC003.ant.amazon.com (10.43.164.153) by
 EX13D08EUC004.ant.amazon.com (10.43.164.176) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 26 Apr 2020 09:45:30 +0000
Received: from EX13D11EUC003.ant.amazon.com ([10.43.164.153]) by
 EX13D11EUC003.ant.amazon.com ([10.43.164.153]) with mapi id 15.00.1497.006;
 Sun, 26 Apr 2020 09:45:30 +0000
From:   "Jubran, Samih" <sameehj@amazon.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
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
        "Dagan, Noam" <ndagan@amazon.com>
Thread-Index: AQHWGH5UipqhrBKko02bQiwsmxnUR6iF3l2AgAAA6YCABU3bYA==
Date:   Sun, 26 Apr 2020 09:45:19 +0000
Deferred-Delivery: Sun, 26 Apr 2020 09:44:52 +0000
Message-ID: <18461245e6654647bafa7cbdcb2897bf@EX13D11EUC003.ant.amazon.com>
References: <20200422081628.8103-1-sameehj@amazon.com>
        <20200422081628.8103-3-sameehj@amazon.com>
        <20200422173941.5d43c2df@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200422174254.54fa72ba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200422174254.54fa72ba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.165.8]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, April 23, 2020 3:43 AM
> To: Jubran, Samih <sameehj@amazon.com>
> Cc: davem@davemloft.net; netdev@vger.kernel.org; Kiyanovski, Arthur
> <akiyano@amazon.com>; Woodhouse, David <dwmw@amazon.co.uk>;
> Machulsky, Zorik <zorik@amazon.com>; Matushevsky, Alexander
> <matua@amazon.com>; Bshara, Saeed <saeedb@amazon.com>; Wilson,
> Matt <msw@amazon.com>; Liguori, Anthony <aliguori@amazon.com>;
> Bshara, Nafea <nafea@amazon.com>; Tzalik, Guy <gtzalik@amazon.com>;
> Belgazal, Netanel <netanel@amazon.com>; Saidi, Ali
> <alisaidi@amazon.com>; Herrenschmidt, Benjamin <benh@amazon.com>;
> Dagan, Noam <ndagan@amazon.com>
> Subject: RE: [EXTERNAL] [PATCH V1 net-next 02/13] net: ena: avoid
> unnecessary admin command when RSS function set fails
>=20
> CAUTION: This email originated from outside of the organization. Do not c=
lick
> links or open attachments unless you can confirm the sender and know the
> content is safe.
>=20
>=20
>=20
> On Wed, 22 Apr 2020 17:39:41 -0700 Jakub Kicinski wrote:
> > On Wed, 22 Apr 2020 08:16:17 +0000 sameehj@amazon.com wrote:
> > > From: Arthur Kiyanovski <akiyano@amazon.com>
> > >
> > > Currently when ena_set_hash_function() fails the hash function is
> > > restored to the previous value by calling an admin command to get
> > > the hash function from the device.
> >
> > I don't see how. func argument is NULL. If I'm reading the code right
> > if this function is restoring anything it's restoring the rss key.
>=20
> Ah, my bad, it sets the function in dev->rss, too.
>=20
> Please reorganize these changes, they are very poorly split up right now.
>=20
> > > In this commit we avoid the admin command, by saving the previous
> > > hash function before calling ena_set_hash_function() and using this
> > > previous value to restore the hash function in case of failure of
> > > ena_set_hash_function().
> > >
> > > Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
> > > Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
> > > ---
> > >  drivers/net/ethernet/amazon/ena/ena_com.c | 4 +++-
> > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c
> > > b/drivers/net/ethernet/amazon/ena/ena_com.c
> > > index 07b0f396d3c2..66edc86c41c9 100644
> > > --- a/drivers/net/ethernet/amazon/ena/ena_com.c
> > > +++ b/drivers/net/ethernet/amazon/ena/ena_com.c
> > > @@ -2286,6 +2286,7 @@ int ena_com_fill_hash_function(struct
> ena_com_dev *ena_dev,
> > >     struct ena_admin_get_feat_resp get_resp;
> > >     struct ena_admin_feature_rss_flow_hash_control *hash_key =3D
> > >             rss->hash_key;
> > > +   enum ena_admin_hash_functions old_func;
> > >     int rc;
> > >
> > >     /* Make sure size is a mult of DWs */ @@ -2325,12 +2326,13 @@
> > > int ena_com_fill_hash_function(struct ena_com_dev *ena_dev,
> > >             return -EINVAL;
> > >     }
> > >
> > > +   old_func =3D rss->hash_func;
> > >     rss->hash_func =3D func;
> > >     rc =3D ena_com_set_hash_function(ena_dev);
> > >
> > >     /* Restore the old function */
> > >     if (unlikely(rc))
> > > -           ena_com_get_hash_function(ena_dev, NULL, NULL);
> > > +           rss->hash_func =3D old_func;
> >
> > Please order your commits correctly.
You are right, the order of the commits is not ideal, will fix in v2.
> >
> > >     return rc;
> > >  }

