Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 576D8F5305
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 18:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730250AbfKHRyp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 12:54:45 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:47140 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729373AbfKHRyo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 12:54:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573235684;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v3rsQ1SyGmFjleFRYQvhYsS907wi6igkjG4267YPbXk=;
        b=H7xlLkni66OkynRsJVbUWrjv7r7R9GCVGLEj6FB0kASQ21Z91J6zFv80c/IoGFXAk5SG9b
        DQCxNxc1H84Orl+bVkrMzMi3mDr3KCYWk7hcA84LZEFwt8CoSlL97kc3HjVuaNoUdb7No3
        XIrIQm8OM7llfNfYJWY9BiRARe9Q+pU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-19-MVVx2RtVO3amMDUd9uaHbA-1; Fri, 08 Nov 2019 12:54:40 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E6F578017DD;
        Fri,  8 Nov 2019 17:54:38 +0000 (UTC)
Received: from x1.home (ovpn-116-138.phx2.redhat.com [10.3.116.138])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 896B06084E;
        Fri,  8 Nov 2019 17:54:37 +0000 (UTC)
Date:   Fri, 8 Nov 2019 10:54:37 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH net-next 19/19] mtty: Optionally support mtty alias
Message-ID: <20191108105437.206ec2f5@x1.home>
In-Reply-To: <AM0PR05MB486622134AD1F1A83714629CD17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191107160448.20962-1-parav@mellanox.com>
        <20191107160834.21087-1-parav@mellanox.com>
        <20191107160834.21087-19-parav@mellanox.com>
        <20191108144615.3646e9bb.cohuck@redhat.com>
        <AM0PR05MB48667622386BBC6D52BE8BE8D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20191108162828.6e12fc05.cohuck@redhat.com>
        <AM0PR05MB486622134AD1F1A83714629CD17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: MVVx2RtVO3amMDUd9uaHbA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 8 Nov 2019 15:30:59 +0000
Parav Pandit <parav@mellanox.com> wrote:

> > -----Original Message-----
> > From: Cornelia Huck <cohuck@redhat.com>
> > Sent: Friday, November 8, 2019 9:28 AM
> > To: Parav Pandit <parav@mellanox.com>
> > Cc: alex.williamson@redhat.com; davem@davemloft.net;
> > kvm@vger.kernel.org; netdev@vger.kernel.org; Saeed Mahameed
> > <saeedm@mellanox.com>; kwankhede@nvidia.com; leon@kernel.org; Jiri
> > Pirko <jiri@mellanox.com>; linux-rdma@vger.kernel.org
> > Subject: Re: [PATCH net-next 19/19] mtty: Optionally support mtty alias
> >=20
> > On Fri, 8 Nov 2019 15:10:42 +0000
> > Parav Pandit <parav@mellanox.com> wrote:
> >  =20
> > > > -----Original Message-----
> > > > From: Cornelia Huck <cohuck@redhat.com>
> > > > Sent: Friday, November 8, 2019 7:46 AM
> > > > To: Parav Pandit <parav@mellanox.com>
> > > > Cc: alex.williamson@redhat.com; davem@davemloft.net;
> > > > kvm@vger.kernel.org; netdev@vger.kernel.org; Saeed Mahameed
> > > > <saeedm@mellanox.com>; kwankhede@nvidia.com; leon@kernel.org; Jiri
> > > > Pirko <jiri@mellanox.com>; linux-rdma@vger.kernel.org
> > > > Subject: Re: [PATCH net-next 19/19] mtty: Optionally support mtty
> > > > alias
> > > >
> > > > On Thu,  7 Nov 2019 10:08:34 -0600
> > > > Parav Pandit <parav@mellanox.com> wrote:
> > > > =20
> > > > > Provide a module parameter to set alias length to optionally
> > > > > generate mdev alias.
> > > > >
> > > > > Example to request mdev alias.
> > > > > $ modprobe mtty alias_length=3D12
> > > > >
> > > > > Make use of mtty_alias() API when alias_length module parameter i=
s =20
> > set. =20
> > > > >
> > > > > Signed-off-by: Parav Pandit <parav@mellanox.com>
> > > > > ---
> > > > >  samples/vfio-mdev/mtty.c | 13 +++++++++++++
> > > > >  1 file changed, 13 insertions(+) =20
> > > >
> > > > If you already have code using the alias interface, you probably
> > > > don't need to add it to the sample driver here. Especially as the
> > > > alias looks kind of pointless here. =20
> > >
> > > It is pointless.
> > > Alex point when we ran through the series in August, was, QA should b=
e =20
> > able to do cover coverage of mdev_core where there is mdev collision an=
d
> > mdev_create() can fail. =20
> > > And QA should be able to set alias length to be short to 1 or 2 lette=
rs to =20
> > trigger it. =20
> > > Hence this patch was added. =20
> >=20
> > If we want this for testing purposes, that should be spelled out explic=
itly (the
> > above had already dropped from my cache). Even better if we had
> > something in actual test infrastructure. =20
>=20
> What else purpose sample driver has other than getting reference on how t=
o use API? :-)

Yup, personally I still find the ROI for this worthwhile.  It gives us a
mechanism to test aliases, and particularly alias collisions, without
special hardware, as well as providing an example of the API.

FWIW, there will be merge conflicts with the alias support in this
series versus the mdev parent ops refactoring to allow class specific
device ops.  As the use of the alias support solidifies we can revisit
which branch we want to use to merge it upstream.  Thanks,

Alex

