Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0348F19D7A8
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 15:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728213AbgDCNeX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 09:34:23 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25876 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727431AbgDCNeX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 09:34:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585920861;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WcqZKkN30Oa4RNXPaffsD8gyIcJm8OqDtkR/kTpWMVk=;
        b=FXvIS+w1RY1ecvFyqibTukEB7Hi938o1jO+//Z2EJxImR/oloL3Jj+i82JND3RB4hVlWWH
        Q6wGP2c6K1hKDma4a37JYRi9PWY6t/nD+Zux4Wq6Cqf0ZXrRsY1u9dQHfJBCYSSUQZt3Fj
        CPGDhYHhhXBrcK2de5fOcnEKEtdKBLQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-279-L16pSjjuPMyMpuNpcF0Xmw-1; Fri, 03 Apr 2020 09:34:16 -0400
X-MC-Unique: L16pSjjuPMyMpuNpcF0Xmw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3CCB28017F6;
        Fri,  3 Apr 2020 13:34:15 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 316D21147D4;
        Fri,  3 Apr 2020 13:34:15 +0000 (UTC)
Received: from zmail21.collab.prod.int.phx2.redhat.com (zmail21.collab.prod.int.phx2.redhat.com [10.5.83.24])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0E3C54E444;
        Fri,  3 Apr 2020 13:34:15 +0000 (UTC)
Date:   Fri, 3 Apr 2020 09:34:14 -0400 (EDT)
From:   Vladis Dronov <vdronov@redhat.com>
To:     Andrea Righi <andrea.righi@canonical.com>,
        Colin Ian King <colin.king@canonical.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <1196893766.20531178.1585920854778.JavaMail.zimbra@redhat.com>
In-Reply-To: <20200309172238.GJ267906@xps-13>
References: <20200309172238.GJ267906@xps-13>
Subject: Re: [PATCH v2] ptp: free ptp clock properly
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.40.195.210, 10.4.195.6]
Thread-Topic: free ptp clock properly
Thread-Index: uXvQdhztKiICOdqCuBxI3OGbRli1DA==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello, Andrea, Colin, all,

This fix is really not needed, as its creation is based on the assumption
that the Ubuntu kernel 5.3.0-40-generic has the upstream commit 75718584cb3=
c,
which is the real fix to this crash.

> > > I would guess that a kernel in question (5.3.0-40-generic) has the co=
mmit
> > > a33121e5487b but does not have the commit 75718584cb3c, which should =
be
> > > exactly fixing a docking station disconnect crash. Could you please,
> > > check this?
> >
> > Unfortunately the kernel in question already has 75718584cb3c:
> > https://git.launchpad.net/~ubuntu-kernel/ubuntu/+source/linux/+git/bion=
ic/commit/?h=3Dhwe&id=3Dc71b774732f997ef38ed7bd62e73891a01f2bbfe

Apologies, but the assumption above is not correct, 5.3.0-40-generic does
not have 75718584cb3c. If it had 75718584cb3c it would be a fix and the ptp=
-related
crash (described in https://bugs.launchpad.net/bugs/1864754) would not happ=
en.

This way https://lists.ubuntu.com/archives/kernel-team/2020-March/108562.ht=
ml fix
is not really needed.

Best regards,
Vladis Dronov | Red Hat, Inc. | The Core Kernel | Senior Software Engineer

----- Original Message -----
> From: "Andrea Righi" <andrea.righi@canonical.com>
> To: "Richard Cochran" <richardcochran@gmail.com>, "Vladis Dronov" <vdrono=
v@redhat.com>
> Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org, linu=
x-kernel@vger.kernel.org
> Sent: Monday, March 9, 2020 6:22:38 PM
> Subject: [PATCH v2] ptp: free ptp clock properly
>=20
> There is a bug in ptp_clock_unregister() where pps_unregister_source()
> can free up resources needed by posix_clock_unregister() to properly
> destroy a related sysfs device.
>=20
> Fix this by calling pps_unregister_source() in ptp_clock_release().
>=20
> See also:
> commit 75718584cb3c ("ptp: free ptp device pin descriptors properly").
>=20
> BugLink: https://bugs.launchpad.net/bugs/1864754
> Fixes: a33121e5487b ("ptp: fix the race between the release of ptp_clock =
and
> cdev")
> Tested-by: Piotr Morgwai Kotarbi=C5=84ski <foss@morgwai.pl>
> Signed-off-by: Andrea Righi <andrea.righi@canonical.com>
> ---
>=20
> v2: move pps_unregister_source() to ptp_clock_release(), instead of
>     posix_clock_unregister(), that would just introduce a resource leak
>=20
>  drivers/ptp/ptp_clock.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
> index ac1f2bf9e888..468286ef61ad 100644
> --- a/drivers/ptp/ptp_clock.c
> +++ b/drivers/ptp/ptp_clock.c
> @@ -170,6 +170,9 @@ static void ptp_clock_release(struct device *dev)
>  {
>  =09struct ptp_clock *ptp =3D container_of(dev, struct ptp_clock, dev);
> =20
> +=09/* Release the clock's resources. */
> +=09if (ptp->pps_source)
> +=09=09pps_unregister_source(ptp->pps_source);
>  =09ptp_cleanup_pin_groups(ptp);
>  =09mutex_destroy(&ptp->tsevq_mux);
>  =09mutex_destroy(&ptp->pincfg_mux);
> @@ -298,11 +301,6 @@ int ptp_clock_unregister(struct ptp_clock *ptp)
>  =09=09kthread_cancel_delayed_work_sync(&ptp->aux_work);
>  =09=09kthread_destroy_worker(ptp->kworker);
>  =09}
> -
> -=09/* Release the clock's resources. */
> -=09if (ptp->pps_source)
> -=09=09pps_unregister_source(ptp->pps_source);
> -
>  =09posix_clock_unregister(&ptp->clock);
> =20
>  =09return 0;
> --
> 2.25.0

