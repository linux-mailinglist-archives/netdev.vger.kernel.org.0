Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 353DA1A0AC0
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 12:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728140AbgDGKFS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 06:05:18 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:31031 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728091AbgDGKFS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 06:05:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586253917;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V6OOZIcMHbA4COKeQ3vI4ZGPp1DvSViJ7U0v6oxO7OU=;
        b=h3Jl+pEyjqlrMv0L+k4O8AC610s+TMNhYegY7f9vnETEUOjEewv42MsdbV3krzIqcCyutn
        eoU7v3vFH7pjqje2DeLWfeyBxalWPFjGhmizG2eaE2Nx5yRwB3rd2/61+kWpBKpaMXROBB
        KxJre+ajwlWpPpePiQCD3VRijfYXrcI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-371-QroJ8KuLO02FEL4Vw2CyIQ-1; Tue, 07 Apr 2020 06:05:12 -0400
X-MC-Unique: QroJ8KuLO02FEL4Vw2CyIQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DCBFC102C868;
        Tue,  7 Apr 2020 10:05:10 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 27CA394B4E;
        Tue,  7 Apr 2020 10:05:10 +0000 (UTC)
Received: from zmail21.collab.prod.int.phx2.redhat.com (zmail21.collab.prod.int.phx2.redhat.com [10.5.83.24])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3375E93A61;
        Tue,  7 Apr 2020 10:05:09 +0000 (UTC)
Date:   Tue, 7 Apr 2020 06:05:09 -0400 (EDT)
From:   Vladis Dronov <vdronov@redhat.com>
To:     Andrea Righi <andrea.righi@canonical.com>
Cc:     Piotr Morgwai =?utf-8?Q?Kotarbi=C5=84ski?= <morgwai@morgwai.pl>,
        Colin Ian King <colin.king@canonical.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <1493646639.21012930.1586253909001.JavaMail.zimbra@redhat.com>
In-Reply-To: <20200407093422.GD3665@xps-13>
References: <20200309172238.GJ267906@xps-13> <1196893766.20531178.1585920854778.JavaMail.zimbra@redhat.com> <20200407093422.GD3665@xps-13>
Subject: Re: [PATCH v2] ptp: free ptp clock properly
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.40.208.84, 10.4.195.29]
Thread-Topic: free ptp clock properly
Thread-Index: WLuFyIwSVbLAUz+GYlxwZs1rVfBFIw==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

----- Original Message -----
> From: "Andrea Righi" <andrea.righi@canonical.com>
> To: "Vladis Dronov" <vdronov@redhat.com>
> Cc: "Piotr Morgwai Kotarbi=C5=84ski" <morgwai@morgwai.pl>, "Colin Ian Kin=
g" <colin.king@canonical.com>, "Richard Cochran"
> <richardcochran@gmail.com>, "David S. Miller" <davem@davemloft.net>, netd=
ev@vger.kernel.org,
> linux-kernel@vger.kernel.org
> Sent: Tuesday, April 7, 2020 11:34:22 AM
> Subject: Re: [PATCH v2] ptp: free ptp clock properly
>=20
> On Fri, Apr 03, 2020 at 09:34:14AM -0400, Vladis Dronov wrote:
> > Hello, Andrea, Colin, all,
> >=20
> > This fix is really not needed, as its creation is based on the assumpti=
on
> > that the Ubuntu kernel 5.3.0-40-generic has the upstream commit
> > 75718584cb3c,
> > which is the real fix to this crash.
> >=20
> > > > > I would guess that a kernel in question (5.3.0-40-generic) has th=
e
> > > > > commit
> > > > > a33121e5487b but does not have the commit 75718584cb3c, which sho=
uld
> > > > > be
> > > > > exactly fixing a docking station disconnect crash. Could you plea=
se,
> > > > > check this?
> > > >
> > > > Unfortunately the kernel in question already has 75718584cb3c:
> > > > https://git.launchpad.net/~ubuntu-kernel/ubuntu/+source/linux/+git/=
bionic/commit/?h=3Dhwe&id=3Dc71b774732f997ef38ed7bd62e73891a01f2bbfe
> >=20
> > Apologies, but the assumption above is not correct, 5.3.0-40-generic do=
es
> > not have 75718584cb3c. If it had 75718584cb3c it would be a fix and the
> > ptp-related
> > crash (described in https://bugs.launchpad.net/bugs/1864754) would not
> > happen.
> >=20
> > This way
> > https://lists.ubuntu.com/archives/kernel-team/2020-March/108562.html fi=
x
> > is not really needed.
>=20
> Hi Vladis,
>=20
> for the records, I repeated the tests with a lot of help from the bug
> reporter (Morgwai, added in cc), this time making sure we were using the
> same kernels.
>=20
> I confirm that my fix is not really needed as you correctly pointed out.
> Thanks for looking into this and sorry for the noise! :)

Hei, great! Thank you for updating. I'm happy this situation has resolved
properly!

>=20
> -Andrea
>=20

Best regards,
Vladis Dronov | Red Hat, Inc. | The Core Kernel | Senior Software Engineer

