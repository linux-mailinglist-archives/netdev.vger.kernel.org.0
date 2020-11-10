Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 645712AD57B
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 12:43:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727536AbgKJLnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 06:43:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56610 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726462AbgKJLnV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 06:43:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605008600;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sR/UmW8U9HUE0hsqjkJo2y1L+rZQCSVJTJabk4GdygE=;
        b=U8Z9McCcIqAPH6AtZEEvzkLbc8rZVbxxlNK7ztuhkFau9RclJEFVB9XqgiazgM4E5ihPo3
        dkGjo5fKEJEcaUrkHINDuMs1iwxGqY49QG/lJqeE7ySBv97WozvfeV4SBtiRfVyV/epC7k
        4vNed5UQhIza6TaxvnAdhppO30SH2ok=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-594-iirgclJONoiU29HV8K3LzQ-1; Tue, 10 Nov 2020 06:43:18 -0500
X-MC-Unique: iirgclJONoiU29HV8K3LzQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 884B6802B51;
        Tue, 10 Nov 2020 11:43:16 +0000 (UTC)
Received: from carbon (unknown [10.36.110.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6948E5B4A4;
        Tue, 10 Nov 2020 11:43:13 +0000 (UTC)
Date:   Tue, 10 Nov 2020 12:43:09 +0100
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Alex Shi <alex.shi@linux.alibaba.com>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/xdp: remove unused macro REG_STATE_NEW
Message-ID: <20201110124309.6240df73@carbon>
In-Reply-To: <5fa9b850d6de5_8c0e2089d@john-XPS-13-9370.notmuch>
References: <1604641431-6295-1-git-send-email-alex.shi@linux.alibaba.com>
        <20201106171352.5c51342d@carbon>
        <3d39a08d-2e50-efeb-214f-0c7c2d1605d7@linux.alibaba.com>
        <5fa9b850d6de5_8c0e2089d@john-XPS-13-9370.notmuch>
Organization: Red Hat Inc.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 09 Nov 2020 13:44:48 -0800
John Fastabend <john.fastabend@gmail.com> wrote:

> Alex Shi wrote:
> >=20
> >=20
> > =E5=9C=A8 2020/11/7 =E4=B8=8A=E5=8D=8812:13, Jesper Dangaard Brouer =E5=
=86=99=E9=81=93: =20
> > > Hmm... REG_STATE_NEW is zero, so it is implicitly set via memset zero.
> > > But it is true that it is technically not directly used or referenced.
> > >=20
> > > It is mentioned in a comment, so please send V2 with this additional =
change: =20
> >=20
> > Hi Jesper,
> >=20
> > Thanks a lot for comments. here is the v2:
> >=20
> > From 2908d25bf2e1c90ad71a83ba056743f45da283e8 Mon Sep 17 00:00:00 2001
> > From: Alex Shi <alex.shi@linux.alibaba.com>
> > Date: Fri, 6 Nov 2020 13:41:58 +0800
> > Subject: [PATCH v2] net/xdp: remove unused macro REG_STATE_NEW
> >=20
> > To tame gcc warning on it:
> > net/core/xdp.c:20:0: warning: macro "REG_STATE_NEW" is not used
> > [-Wunused-macros]
> > And change related comments as Jesper Dangaard Brouer suggested.
> >=20
> > Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
> > --- =20
>=20
> >  net/core/xdp.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> >=20
> > diff --git a/net/core/xdp.c b/net/core/xdp.c
> > index 48aba933a5a8..0df5ee5682d9 100644
> > --- a/net/core/xdp.c
> > +++ b/net/core/xdp.c
> > @@ -19,7 +19,6 @@
> >  #include <trace/events/xdp.h>
> >  #include <net/xdp_sock_drv.h>
> > =20
> > -#define REG_STATE_NEW		0x0
> >  #define REG_STATE_REGISTERED	0x1
> >  #define REG_STATE_UNREGISTERED	0x2
> >  #define REG_STATE_UNUSED	0x3 =20
>=20
> I think having the define there makes it more readable and clear what
> the zero state is. But if we run with unused-macros I guess its even
> uglier to try and mark it with unused attribute.

I  agree having the define there makes it more readable and clear what
the zero state is.

We can also add code that replace the comment, that check/use these
defines.  It is slow-path code, so it doesn't hurt to add this extra
code.  Generally I find it strange to "fix" these kind of warnings, but
also don't care that we do fix them if it helps someone else spot code
where it actually matters.

> Acked-by: John Fastabend <john.fastabend@gmail.com>
>=20
> > @@ -175,7 +174,7 @@ int xdp_rxq_info_reg(struct xdp_rxq_info *xdp_rxq,
> >  		return -ENODEV;
> >  	}
> > =20
> > -	/* State either UNREGISTERED or NEW */
> > +	/* State either UNREGISTERED or zero */
> >  	xdp_rxq_info_init(xdp_rxq);
> >  	xdp_rxq->dev =3D dev;
> >  	xdp_rxq->queue_index =3D queue_index;
> > --=20
> > 1.8.3.1
> >  =20
>=20
>=20



--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

