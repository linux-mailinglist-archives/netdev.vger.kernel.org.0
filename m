Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B9601295AB
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 12:46:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbfLWLqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 06:46:34 -0500
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:18754 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726257AbfLWLqe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 06:46:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1577101593; x=1608637593;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vvmp92KNUpBEgXRjRfQ+MICqzu1qMXT+80kMSZKetok=;
  b=RZW9Py3q1sMRx2fvzBMpOvftnXSo81qErb5ABgPl+oRDP9t8NhXWApz2
   Q8F6t/xTfHT8SxKkqfDJRWZoSSj73vHx32YEca4m+MMyUEsRnrM/4+ANe
   SN5o3jTi/ySnfJgxaverB1KgHnaH33qGUMj4Hv18UGO9ayXEc3vcUGlPk
   8=;
IronPort-SDR: bYFdawsqLJaf///3+Xmev8apsMjp4iYZk+WyLjr5J5nVgZ60Q04Yv7ot07mFMeKy50f3Bvfqg2
 YdpJMNxOkl2g==
X-IronPort-AV: E=Sophos;i="5.69,347,1571702400"; 
   d="scan'208";a="9790850"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 23 Dec 2019 11:46:31 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com (Postfix) with ESMTPS id 6C2C1A27B1;
        Mon, 23 Dec 2019 11:46:31 +0000 (UTC)
Received: from EX13D32EUC002.ant.amazon.com (10.43.164.94) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1236.3; Mon, 23 Dec 2019 11:46:30 +0000
Received: from EX13D32EUC003.ant.amazon.com (10.43.164.24) by
 EX13D32EUC002.ant.amazon.com (10.43.164.94) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 23 Dec 2019 11:46:29 +0000
Received: from EX13D32EUC003.ant.amazon.com ([10.43.164.24]) by
 EX13D32EUC003.ant.amazon.com ([10.43.164.24]) with mapi id 15.00.1367.000;
 Mon, 23 Dec 2019 11:46:29 +0000
From:   "Durrant, Paul" <pdurrant@amazon.com>
To:     Wei Liu <wei.liu@kernel.org>
CC:     "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Durrant <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: RE: [PATCH net-next] xen-netback: support dynamic unbind/bind
Thread-Topic: [PATCH net-next] xen-netback: support dynamic unbind/bind
Thread-Index: AQHVuXeo48GmlxuNH0abtWhDKbfEbafHl0uAgAACIOA=
Date:   Mon, 23 Dec 2019 11:46:29 +0000
Message-ID: <1d1189a3acd8473fadc420d902fd4692@EX13D32EUC003.ant.amazon.com>
References: <20191223095923.2458-1-pdurrant@amazon.com>
 <20191223113545.nwugg7lsorttunuu@debian>
In-Reply-To: <20191223113545.nwugg7lsorttunuu@debian>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.165.29]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Wei Liu <wei.liu@kernel.org>
> Sent: 23 December 2019 11:36
> To: Durrant, Paul <pdurrant@amazon.com>
> Cc: xen-devel@lists.xenproject.org; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; Wei Liu <wei.liu@kernel.org>; Paul Durrant
> <paul@xen.org>; David S. Miller <davem@davemloft.net>
> Subject: Re: [PATCH net-next] xen-netback: support dynamic unbind/bind
>=20
> On Mon, Dec 23, 2019 at 09:59:23AM +0000, Paul Durrant wrote:
> [...]
> > diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-
> netback/interface.c
> > index f15ba3de6195..0c8a02a1ead7 100644
> > --- a/drivers/net/xen-netback/interface.c
> > +++ b/drivers/net/xen-netback/interface.c
> > @@ -585,6 +585,7 @@ int xenvif_connect_ctrl(struct xenvif *vif,
> grant_ref_t ring_ref,
> >  	struct net_device *dev =3D vif->dev;
> >  	void *addr;
> >  	struct xen_netif_ctrl_sring *shared;
> > +	RING_IDX rsp_prod, req_prod;
> >  	int err;
> >
> >  	err =3D xenbus_map_ring_valloc(xenvif_to_xenbus_device(vif),
> > @@ -593,7 +594,14 @@ int xenvif_connect_ctrl(struct xenvif *vif,
> grant_ref_t ring_ref,
> >  		goto err;
> >
> >  	shared =3D (struct xen_netif_ctrl_sring *)addr;
> > -	BACK_RING_INIT(&vif->ctrl, shared, XEN_PAGE_SIZE);
> > +	rsp_prod =3D READ_ONCE(shared->rsp_prod);
> > +	req_prod =3D READ_ONCE(shared->req_prod);
> > +
> > +	BACK_RING_ATTACH(&vif->ctrl, shared, rsp_prod, XEN_PAGE_SIZE);
> > +
> > +	err =3D -EIO;
> > +	if (req_prod - rsp_prod > RING_SIZE(&vif->ctrl))
> > +		goto err_unmap;
>=20
> I think it makes more sense to attach the ring after this check has been
> done, but I can see you want to structure code like this to reuse the
> unmap error path.

Looks a little odd, agreed. The reason I did it this way is so that I can u=
se RING_SIZE() rather than having to use __RING_SIZE(); makes the code just=
 a little bit shorter... which reminds me I ought to neaten up blkback simi=
larly.

>=20
> So:
>=20
> Reviewed-by: Wei Liu <wei.liu@kernel.org>
>=20
> Nice work btw.

Thanks :-)

  Paul
