Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A3FB3F1441
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 09:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236730AbhHSHQl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 03:16:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23588 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236651AbhHSHQk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 03:16:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629357364;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UALzSo2GrJ9j01xCRrcgLejUq52T/7G8b3s1/Jyjb3g=;
        b=N8/qErVXUTeMJQCcEwbNY07Cap7bml9xZbiwsRqBDURhu962bv+FK4S5KtI9foN+lAZewk
        F8c74mdRulpVr8pBHX65BFL52n14wmu3C3etLX9cZ71b8boCe60Y+suDGIjwlZm2fM0CbW
        zAAwWgT0sL6YevRoNh0CewFCpl2u4zI=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-38-ztyNuvzJPZyhfIufrFyMSg-1; Thu, 19 Aug 2021 03:16:02 -0400
X-MC-Unique: ztyNuvzJPZyhfIufrFyMSg-1
Received: by mail-lj1-f200.google.com with SMTP id e17-20020a2ea551000000b001ba24d10343so1847492ljn.0
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 00:16:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=UALzSo2GrJ9j01xCRrcgLejUq52T/7G8b3s1/Jyjb3g=;
        b=ZVYw5SC5kruVEKqos7znu9+afHjRLsPsSN1hXEDNQa+pSAvqBvMk4WyXBAWV80vNbV
         y5s1kZWRDfkWo63mulrC2KWp6uDGkL4OSd613UT2uGlYIVV8TBZ9uSVdcAyEz9NPHtm4
         C3Fe7SzZtOpjj8XqjrXbNrh35qeoFaxeD7pyq8EcFPRkXpZCmpqtnX0sN4MTCuL9LuPb
         ikLjZFlWwSddlcq5OY1x0o/wL8hhdat/P+/nfslQ3g327VTn5luVfbm+HPQa8avYuSS3
         hEyNCxzrYcd+G4irtUJvgVJBchEh3y+zfjAiKShhMmhSSS2vMX+e+ZwBxrvki9NOu1MX
         7TTA==
X-Gm-Message-State: AOAM530CIa5F38YMw8G2jTeNWvAdi1VU0qCltAgsG2SEYQwz6LNMopwk
        yadbHHFyYqDO7Nvq1/5BtBRrT2OVbHn6jf/0paVYwlEC4HV1JwqXk6C+Y2Ly6UqieEuwduaK+tr
        8bgU855TJ8Y/seaQdTkxQ6lCcK/qxV1sa
X-Received: by 2002:ac2:5e7a:: with SMTP id a26mr9462709lfr.312.1629357361347;
        Thu, 19 Aug 2021 00:16:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz3IoEfD4gxn0Nr+TIGTIxAc4ooYHxWzFw8gFQUry5zBtizmgIUWjSZFiLRaGMqdxMlUDGirI0BKaxr54b0YkA=
X-Received: by 2002:ac2:5e7a:: with SMTP id a26mr9462701lfr.312.1629357361197;
 Thu, 19 Aug 2021 00:16:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210818095714.3220-1-lingshan.zhu@intel.com> <e3ec8ed7-84ac-73cc-0b74-4de1bb6c0030@redhat.com>
 <9e6f6cb0-eaed-9d83-c297-3a89f5cc9efd@intel.com>
In-Reply-To: <9e6f6cb0-eaed-9d83-c297-3a89f5cc9efd@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 19 Aug 2021 15:15:50 +0800
Message-ID: <CACGkMEsjyx9GDwm1tNtRozC4ooN_QFXBGL20yqc029PKVH2L-w@mail.gmail.com>
Subject: Re: [PATCH 0/2] vDPA/ifcvf: enable multiqueue and control vq
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>
Cc:     mst <mst@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 19, 2021 at 2:50 PM Zhu, Lingshan <lingshan.zhu@intel.com> wrot=
e:
>
>
>
> On 8/19/2021 12:11 PM, Jason Wang wrote:
> >
> > =E5=9C=A8 2021/8/18 =E4=B8=8B=E5=8D=885:57, Zhu Lingshan =E5=86=99=E9=
=81=93:
> >> This series enables multi-queue and control vq features
> >> for ifcvf.
> >>
> >> These patches are based on my previous vDPA/ifcvf management link
> >> implementation series:
> >> https://lore.kernel.org/kvm/20210812032454.24486-2-lingshan.zhu@intel.=
com/T/
> >>
> >>
> >> Thanks!
> >>
> >> Zhu Lingshan (2):
> >>    vDPA/ifcvf: detect and use the onboard number of queues directly
> >>    vDPA/ifcvf: enable multiqueue and control vq
> >>
> >>   drivers/vdpa/ifcvf/ifcvf_base.c |  8 +++++---
> >>   drivers/vdpa/ifcvf/ifcvf_base.h | 19 ++++---------------
> >>   drivers/vdpa/ifcvf/ifcvf_main.c | 32 +++++++++++++++----------------=
-
> >>   3 files changed, 24 insertions(+), 35 deletions(-)
> >>
> >
> > Patch looks good.
> >
> > I wonder the compatibility. E.g does it work on the qemu master
> > without cvq support? (mq=3Doff or not specified)
> Hi Jason,
>
> Yes, it works with qemu master. When no cvq/mq support, only one queue
> pair shown.

Good to know this.

Thanks

>
> Thanks,
> Zhu Lingshan
> >
> > Thanks
> >
>

