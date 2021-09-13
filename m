Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9462940909A
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 15:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243736AbhIMNx5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 09:53:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24869 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242749AbhIMNvu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 09:51:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631541034;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aBjIIvcb5dunWtRsVviIpL9DBOBpPMCvEHR7NyeCpew=;
        b=jVyALL4fF5rGaMeuDIctAKv2DgvLVwcUNFj5A+AglGbMxyGTxN9FEelKQNeLRLd/UGs1Mk
        47F+ItWPYOk+znu0nB49VUz2pHEv1S9C0fljulPHGCr7lO0kk1pIABxAl1RmxfWY61Ehrq
        mL56a7TNTnXw9OF3NuABmssn49yv7VM=
Received: from mail-yb1-f198.google.com (mail-yb1-f198.google.com
 [209.85.219.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-309-u3Ub6kTzMiiNM7YFBjB9EQ-1; Mon, 13 Sep 2021 09:50:33 -0400
X-MC-Unique: u3Ub6kTzMiiNM7YFBjB9EQ-1
Received: by mail-yb1-f198.google.com with SMTP id f8-20020a2585480000b02905937897e3daso13054474ybn.2
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 06:50:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=aBjIIvcb5dunWtRsVviIpL9DBOBpPMCvEHR7NyeCpew=;
        b=47JSW8XhjfSbQxIifAhIVqQWyJVoi0mAW8c1SdBTdRchHoPJjlfX/m8WA5L14IJDX3
         5EIblHDgAN8KuYaa0C5Kl+go5nFF3cGyiaY7NqEWaPgmDBOy8TT0z2nEL8ZNpm4WeuH3
         ePdPBrUbqJ5bV83j35urC78u7SHBvZDcD7QdVrmel1sTUQB0WTcEqZTEkcSj0bqIZ+Bq
         kXbPeesI0POSKTATu0B8x2+5YDISmbvGpF82UKp85JgOLvH8zVNOWF53OYlIFWTQhCFK
         pRJpj3YSxJPXKwdg46XGIz9nvTqekT8C1lwjxJ/99eD86TyjmvwN88S/eV1HJNN3mDGp
         8Q0w==
X-Gm-Message-State: AOAM531ccY2tZvAlOZgi1Nj5OsRLwHnuZoRBZDVt7Z26sXwpUohgqJEl
        59Xnq55iDv2RV2/KK0Yd5XsLV85sNcdRcDQEyv5QomkdkpE/X8X7MFGJBof0GOpopvoewG5bN6F
        bUVcD+K/nMVN/y2Jo1BHHtztBgrm4X/n6
X-Received: by 2002:a25:6913:: with SMTP id e19mr15482536ybc.25.1631541032795;
        Mon, 13 Sep 2021 06:50:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxaynW83umBqEPokVSSibnO6NtuWoQhuE0RyA2lBp5gkMZ2HjvBKRYnpKQf1MqN054h1RGdfDAUtNC2myJBoIU=
X-Received: by 2002:a25:6913:: with SMTP id e19mr15482493ybc.25.1631541032487;
 Mon, 13 Sep 2021 06:50:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210912122234.GA22469@asgard.redhat.com> <CAFqZXNtmN9827MQ0aX7ZcUia5amXuZWppb-9-ySxVP0QBy=O8Q@mail.gmail.com>
 <20210913102316.GA30886@asgard.redhat.com>
In-Reply-To: <20210913102316.GA30886@asgard.redhat.com>
From:   Ondrej Mosnacek <omosnace@redhat.com>
Date:   Mon, 13 Sep 2021 15:50:21 +0200
Message-ID: <CAFqZXNsp84kFLDfJfdu5fboB8vMm85FU7BDDjpiqeiJ2WSjWAg@mail.gmail.com>
Subject: Re: [PATCH v2] include/uapi/linux/xfrm.h: Fix XFRM_MSG_MAPPING ABI breakage
To:     Eugene Syromiatnikov <esyr@redhat.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Antony Antony <antony.antony@secunet.com>,
        Christian Langrock <christian.langrock@secunet.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        SElinux list <selinux@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Eric Paris <eparis@parisplace.org>,
        network dev <netdev@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        "Dmitry V. Levin" <ldv@strace.io>,
        Linux API <linux-api@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 13, 2021 at 12:23 PM Eugene Syromiatnikov <esyr@redhat.com> wro=
te:
> On Mon, Sep 13, 2021 at 09:16:39AM +0200, Ondrej Mosnacek wrote:
> > Perhaps it would be a good idea to put a comment here to make it less
> > likely that this repeats in the future. Something like:
> >
> > /* IMPORTANT: Only insert new entries right above this line, otherwise
> > you break ABI! */
>
> Well, this statement is true for (almost) every UAPI-exposed enum, and
> netlink is vast and relies on enums heavily.  I think it is already
> mentioned somewhere in the documentation, and in the end it falls on the
> shoulders of the maintainers=E2=80=94to pay additional attention to UAPI =
changes.

Ok, fair enough.

--=20
Ondrej Mosnacek
Software Engineer, Linux Security - SELinux kernel
Red Hat, Inc.

