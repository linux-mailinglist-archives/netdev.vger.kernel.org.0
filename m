Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C64AF4FA5
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 16:28:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbfKHP2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 10:28:41 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:60605 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726101AbfKHP2l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 10:28:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573226920;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1QBNaeRqVhOTuFGhH+r1/YHHaqfBgjb8zMTl6JtH3Jw=;
        b=SOCxnQ4nbu04HJc+YyrULLNJsNG068lzDViJQN+ahrW1rZf6z7vrBgnyV1NFhaMb5hGyIx
        Lhhp5vZCichQj4oxavrio1N+vOwVhCee5Joj5QewYBNFsQEmdvbQT52mfPhym+9wkg78Ks
        dQqy9zRkCv5w/pV56qIgKyha1Mrpi7w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-385-BlfJgfpqPlCRIFNN-hdLvQ-1; Fri, 08 Nov 2019 10:28:36 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 607CF180496F;
        Fri,  8 Nov 2019 15:28:35 +0000 (UTC)
Received: from gondolin (dhcp-192-218.str.redhat.com [10.33.192.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 053EE50;
        Fri,  8 Nov 2019 15:28:30 +0000 (UTC)
Date:   Fri, 8 Nov 2019 16:28:28 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH net-next 19/19] mtty: Optionally support mtty alias
Message-ID: <20191108162828.6e12fc05.cohuck@redhat.com>
In-Reply-To: <AM0PR05MB48667622386BBC6D52BE8BE8D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191107160448.20962-1-parav@mellanox.com>
        <20191107160834.21087-1-parav@mellanox.com>
        <20191107160834.21087-19-parav@mellanox.com>
        <20191108144615.3646e9bb.cohuck@redhat.com>
        <AM0PR05MB48667622386BBC6D52BE8BE8D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: BlfJgfpqPlCRIFNN-hdLvQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 8 Nov 2019 15:10:42 +0000
Parav Pandit <parav@mellanox.com> wrote:

> > -----Original Message-----
> > From: Cornelia Huck <cohuck@redhat.com>
> > Sent: Friday, November 8, 2019 7:46 AM
> > To: Parav Pandit <parav@mellanox.com>
> > Cc: alex.williamson@redhat.com; davem@davemloft.net;
> > kvm@vger.kernel.org; netdev@vger.kernel.org; Saeed Mahameed
> > <saeedm@mellanox.com>; kwankhede@nvidia.com; leon@kernel.org; Jiri
> > Pirko <jiri@mellanox.com>; linux-rdma@vger.kernel.org
> > Subject: Re: [PATCH net-next 19/19] mtty: Optionally support mtty alias
> >=20
> > On Thu,  7 Nov 2019 10:08:34 -0600
> > Parav Pandit <parav@mellanox.com> wrote:
> >  =20
> > > Provide a module parameter to set alias length to optionally generate
> > > mdev alias.
> > >
> > > Example to request mdev alias.
> > > $ modprobe mtty alias_length=3D12
> > >
> > > Make use of mtty_alias() API when alias_length module parameter is se=
t.
> > >
> > > Signed-off-by: Parav Pandit <parav@mellanox.com>
> > > ---
> > >  samples/vfio-mdev/mtty.c | 13 +++++++++++++
> > >  1 file changed, 13 insertions(+) =20
> >=20
> > If you already have code using the alias interface, you probably don't =
need
> > to add it to the sample driver here. Especially as the alias looks kind=
 of
> > pointless here. =20
>=20
> It is pointless.
> Alex point when we ran through the series in August, was, QA should be ab=
le to do cover coverage of mdev_core where there is mdev collision and mdev=
_create() can fail.
> And QA should be able to set alias length to be short to 1 or 2 letters t=
o trigger it.
> Hence this patch was added.

If we want this for testing purposes, that should be spelled out
explicitly (the above had already dropped from my cache). Even better
if we had something in actual test infrastructure.

