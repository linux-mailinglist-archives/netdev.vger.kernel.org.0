Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 584332DBAE3
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 06:58:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725813AbgLPF6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 00:58:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57943 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725765AbgLPF6E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 00:58:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608098196;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6FqvnzyOC+7mLnS9oy1AAJEj1mGXM0+0Ror/7MkANS0=;
        b=h3kY4f74JXDlFvGTmioZ9YT+4jrjcsL3Oo20x6YyeLX4/W9t1U7itUogeZ+OTvPm7kvWR1
        DY1QI3lAZAL+LP7z1kvCv5yiPew2yECmroOK7CvrqVDcUY5Pm3+YoMXyXMu8bVJBUzzVJd
        J3bVAWRaVTZGbBhgkjL9Ri/RTEe4OEY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-17-aW_0H7fbOZmrkY45sCqfgQ-1; Wed, 16 Dec 2020 00:56:32 -0500
X-MC-Unique: aW_0H7fbOZmrkY45sCqfgQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 43764801A9D;
        Wed, 16 Dec 2020 05:56:31 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3942E60C5E;
        Wed, 16 Dec 2020 05:56:31 +0000 (UTC)
Received: from zmail21.collab.prod.int.phx2.redhat.com (zmail21.collab.prod.int.phx2.redhat.com [10.5.83.24])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id ECF574BB40;
        Wed, 16 Dec 2020 05:56:30 +0000 (UTC)
Date:   Wed, 16 Dec 2020 00:56:30 -0500 (EST)
From:   Jason Wang <jasowang@redhat.com>
To:     wangyunjian <wangyunjian@huawei.com>
Cc:     netdev@vger.kernel.org, mst@redhat.com,
        willemdebruijn kernel <willemdebruijn.kernel@gmail.com>,
        virtualization@lists.linux-foundation.org,
        "Lilijun (Jerry)" <jerry.lilijun@huawei.com>,
        chenchanghu <chenchanghu@huawei.com>,
        xudingke <xudingke@huawei.com>,
        "huangbin (J)" <brian.huangbin@huawei.com>
Message-ID: <205304638.36191504.1608098190622.JavaMail.zimbra@redhat.com>
In-Reply-To: <34EFBCA9F01B0748BEB6B629CE643AE60DB82A73@DGGEMM533-MBX.china.huawei.com>
References: <cover.1608024547.git.wangyunjian@huawei.com> <4be47d3a325983f1bfc39f11f0e015767dd2aa3c.1608024547.git.wangyunjian@huawei.com> <e853a47e-b581-18d9-f13c-b449b176a308@redhat.com> <34EFBCA9F01B0748BEB6B629CE643AE60DB82A73@DGGEMM533-MBX.china.huawei.com>
Subject: Re: [PATCH net 2/2] vhost_net: fix high cpu load when sendmsg fails
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.68.5.20, 10.4.195.8]
Thread-Topic: [PATCH net 2/2] vhost_net: fix high cpu load when sendmsg fails
Thread-Index: AQHW0oRuvV7yNtzm006vlEv0Vf1dkan3BR2AgADGt5Bmnr+pAA==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



----- Original Message -----
>=20
>=20
> > -----Original Message-----
> > From: Jason Wang [mailto:jasowang@redhat.com]
> > Sent: Tuesday, December 15, 2020 12:10 PM
> > To: wangyunjian <wangyunjian@huawei.com>; netdev@vger.kernel.org;
> > mst@redhat.com; willemdebruijn.kernel@gmail.com
> > Cc: virtualization@lists.linux-foundation.org; Lilijun (Jerry)
> > <jerry.lilijun@huawei.com>; chenchanghu <chenchanghu@huawei.com>;
> > xudingke <xudingke@huawei.com>; huangbin (J)
> > <brian.huangbin@huawei.com>
> > Subject: Re: [PATCH net 2/2] vhost_net: fix high cpu load when sendmsg
> > fails
> >=20
> >=20
> > On 2020/12/15 =E4=B8=8A=E5=8D=889:48, wangyunjian wrote:
> > > From: Yunjian Wang <wangyunjian@huawei.com>
> > >
> > > Currently we break the loop and wake up the vhost_worker when sendmsg
> > > fails. When the worker wakes up again, we'll meet the same error. Thi=
s
> > > will cause high CPU load. To fix this issue, we can skip this
> > > description by ignoring the error. When we exceeds sndbuf, the return
> > > value of sendmsg is -EAGAIN. In the case we don't skip the descriptio=
n
> > > and don't drop packet.
> > >
> > > Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
> > > ---
> > >   drivers/vhost/net.c | 21 +++++++++------------
> > >   1 file changed, 9 insertions(+), 12 deletions(-)
> > >
> > > diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c index
> > > c8784dfafdd7..f966592d8900 100644
> > > --- a/drivers/vhost/net.c
> > > +++ b/drivers/vhost/net.c
> > > @@ -827,16 +827,13 @@ static void handle_tx_copy(struct vhost_net *ne=
t,
> > struct socket *sock)
> > >   =09=09=09=09msg.msg_flags &=3D ~MSG_MORE;
> > >   =09=09}
> > >
> > > -=09=09/* TODO: Check specific error and bomb out unless ENOBUFS? */
> > >   =09=09err =3D sock->ops->sendmsg(sock, &msg, len);
> > > -=09=09if (unlikely(err < 0)) {
> > > +=09=09if (unlikely(err =3D=3D -EAGAIN)) {
> > >   =09=09=09vhost_discard_vq_desc(vq, 1);
> > >   =09=09=09vhost_net_enable_vq(net, vq);
> > >   =09=09=09break;
> > > -=09=09}
> >=20
> >=20
> > As I've pointed out in last version. If you don't discard descriptor, y=
ou
> > probably
> > need to add the head to used ring. Otherwise this descriptor will be al=
ways
> > inflight that may confuse drivers.
>=20
> Sorry for missing the comment.
>=20
> After deleting discard descriptor and break, the next processing will be =
the
> same
> as the normal success of sendmsg(), and vhost_zerocopy_signal_used() or
> vhost_add_used_and_signal() method will be called to add the head to used
> ring.

It's the next head not the one that contains the buggy packet?

Thanks

>=20
> Thanks
> >=20
> >=20
> > > -=09=09if (err !=3D len)
> > > -=09=09=09pr_debug("Truncated TX packet: len %d !=3D %zd\n",
> > > -=09=09=09=09 err, len);
> > > +=09=09} else if (unlikely(err < 0 || err !=3D len))
> >=20
> >=20
> > It looks to me err !=3D len covers err < 0.
>=20
> OK
>=20
> >=20
> > Thanks
> >=20
> >=20
> > > +=09=09=09vq_err(vq, "Fail to sending packets err : %d, len : %zd\n",=
 err,
> > > +len);
> > >   done:
> > >   =09=09vq->heads[nvq->done_idx].id =3D cpu_to_vhost32(vq, head);
> > >   =09=09vq->heads[nvq->done_idx].len =3D 0;
> > > @@ -922,7 +919,6 @@ static void handle_tx_zerocopy(struct vhost_net
> > *net, struct socket *sock)
> > >   =09=09=09msg.msg_flags &=3D ~MSG_MORE;
> > >   =09=09}
> > >
> > > -=09=09/* TODO: Check specific error and bomb out unless ENOBUFS? */
> > >   =09=09err =3D sock->ops->sendmsg(sock, &msg, len);
> > >   =09=09if (unlikely(err < 0)) {
> > >   =09=09=09if (zcopy_used) {
> > > @@ -931,13 +927,14 @@ static void handle_tx_zerocopy(struct vhost_net
> > *net, struct socket *sock)
> > >   =09=09=09=09nvq->upend_idx =3D ((unsigned)nvq->upend_idx - 1)
> > >   =09=09=09=09=09% UIO_MAXIOV;
> > >   =09=09=09}
> > > -=09=09=09vhost_discard_vq_desc(vq, 1);
> > > -=09=09=09vhost_net_enable_vq(net, vq);
> > > -=09=09=09break;
> > > +=09=09=09if (err =3D=3D -EAGAIN) {
> > > +=09=09=09=09vhost_discard_vq_desc(vq, 1);
> > > +=09=09=09=09vhost_net_enable_vq(net, vq);
> > > +=09=09=09=09break;
> > > +=09=09=09}
> > >   =09=09}
> > >   =09=09if (err !=3D len)
> > > -=09=09=09pr_debug("Truncated TX packet: "
> > > -=09=09=09=09 " len %d !=3D %zd\n", err, len);
> > > +=09=09=09vq_err(vq, "Fail to sending packets err : %d, len : %zd\n",=
 err,
> > > +len);
> > >   =09=09if (!zcopy_used)
> > >   =09=09=09vhost_add_used_and_signal(&net->dev, vq, head, 0);
> > >   =09=09else
>=20
>=20

