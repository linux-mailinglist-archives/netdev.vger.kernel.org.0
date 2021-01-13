Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13F322F42EC
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 05:15:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726288AbhAMEOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 23:14:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23333 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726249AbhAMEOc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 23:14:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610511185;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2uX+184DuL6+IbX64Mwow/W3eFyTHIEtajxhKilUb2U=;
        b=AiQf1f7qat+UbF8brPZtKCBX4w2TvhvrLjSUm+pZwlW+5oLQ9CUMQ1aLcUdQNMk2peoWo6
        LT+Vbq/fSrCBoD0moGy0ON+AqfClSZWm82tG6453pnYNbufYsciwXrB6KQVfaqesIL4QJG
        scysweHTdlmjd/h4FZ0tC1u0SjrLJQQ=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-533-8jqg6e9NMmyRmTNs5fvkWQ-1; Tue, 12 Jan 2021 23:13:03 -0500
X-MC-Unique: 8jqg6e9NMmyRmTNs5fvkWQ-1
Received: by mail-pj1-f69.google.com with SMTP id q21so370782pjp.3
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 20:13:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2uX+184DuL6+IbX64Mwow/W3eFyTHIEtajxhKilUb2U=;
        b=TrRnskE4dqRaVmTYw/OD82pBnSUnmc9W8lgwtidHvYxTxEjTrfQJn1CfWJF/7RkWc1
         Awbtf3I7cDSzpRYZVP/pCC/oN9wWrBNfB1STKchzLnf5CCJgDXJisS6LWLs78Re01O2b
         ilo8VU2eU4oCZFgfoECXy8FJl8P/9fUAFE3r0FSlN5ywQRxT1cz8K+AyV29LHlJZiDxk
         P8XS9Q41an80r9pkxNj6FxzKPB1WIHMK0YnmXZ9SUV8nSqdX/OaBgamAkhpgTvfQutbE
         CEUshtKuwBtt7UDvEjv87uAjcJ3iIQBC90r/bLkwPNHgRl1CXvhGptTgFqY7AoAtYaAQ
         t4LA==
X-Gm-Message-State: AOAM530J5tGzglvWd4enJFXsiovHZX7iFiiwhYcF0cEk+mVzCSraUlRx
        bEWy0ti87ZSBMmvEQA9IBIJJVDOy+ekgzEchnBKhKlTT7SK0L8AIkODp5bYexYX57+S1LObFA6t
        ucbu6Nt6JqR69oPCDilqTow3e6XfpkRFz
X-Received: by 2002:a17:902:8a8a:b029:db:e003:4044 with SMTP id p10-20020a1709028a8ab02900dbe0034044mr366031plo.19.1610511182731;
        Tue, 12 Jan 2021 20:13:02 -0800 (PST)
X-Google-Smtp-Source: ABdhPJynudTkku66m+FnxiitvS/UCRuOamqko46/CvqV825uh3S7t3CEzojH3Xb6x1N1Bhbp9yNW4vMWEWRPv+P7H60=
X-Received: by 2002:a17:902:8a8a:b029:db:e003:4044 with SMTP id
 p10-20020a1709028a8ab02900dbe0034044mr366015plo.19.1610511182494; Tue, 12 Jan
 2021 20:13:02 -0800 (PST)
MIME-Version: 1.0
References: <20210112053629.9853-1-lulu@redhat.com> <1403c336-4493-255f-54e3-c55dd2015c40@redhat.com>
In-Reply-To: <1403c336-4493-255f-54e3-c55dd2015c40@redhat.com>
From:   Cindy Lu <lulu@redhat.com>
Date:   Wed, 13 Jan 2021 12:12:25 +0800
Message-ID: <CACLfguVi7XZ_HR4Gxcc3=_XHZnZ8q2bcuJcqEuu56E+MCZB+RA@mail.gmail.com>
Subject: Re: [PATCH v3] vhost_vdpa: fix the problem in vhost_vdpa_set_config_call
To:     Jason Wang <jasowang@redhat.com>
Cc:     Michael Tsirkin <mst@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        "Zhu, Lingshan" <lingshan.zhu@intel.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 11:38 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2021/1/12 =E4=B8=8B=E5=8D=881:36, Cindy Lu wrote:
> > In vhost_vdpa_set_config_call, the cb.private should be vhost_vdpa.
> > this cb.private will finally use in vhost_vdpa_config_cb as
> > vhost_vdpa. Fix this issue.
> >
> > Fixes: 776f395004d82 ("vhost_vdpa: Support config interrupt in vdpa")
> > Acked-by: Jason Wang <jasowang@redhat.com>
> > Signed-off-by: Cindy Lu <lulu@redhat.com>
> > ---
>
>
> Hi Cindy:
>
> I think at least you forget to cc stable.
>
> Thanks
>
Sure Thanks Jason I will post a new version
>
> >   drivers/vhost/vdpa.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> > index ef688c8c0e0e..3fbb9c1f49da 100644
> > --- a/drivers/vhost/vdpa.c
> > +++ b/drivers/vhost/vdpa.c
> > @@ -319,7 +319,7 @@ static long vhost_vdpa_set_config_call(struct vhost=
_vdpa *v, u32 __user *argp)
> >       struct eventfd_ctx *ctx;
> >
> >       cb.callback =3D vhost_vdpa_config_cb;
> > -     cb.private =3D v->vdpa;
> > +     cb.private =3D v;
> >       if (copy_from_user(&fd, argp, sizeof(fd)))
> >               return  -EFAULT;
> >
>

