Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFD746567F4
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 08:49:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbiL0Htf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 02:49:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbiL0Hte (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 02:49:34 -0500
Received: from mail-ua1-x92f.google.com (mail-ua1-x92f.google.com [IPv6:2607:f8b0:4864:20::92f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF2FAE26
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 23:49:33 -0800 (PST)
Received: by mail-ua1-x92f.google.com with SMTP id j1so2791057uan.1
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 23:49:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=igel-co-jp.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W5to3Z4Sn21mWEIZEJGvSoWUEuZOvMtlIkM4pTNXTa4=;
        b=athKvejDkz6WSCUOqN63r4RkPc7PljBcdn1pqKggjZSE8/UMue7d69Hl0+z0dS1T14
         TMhEMq/PWya4AXj39g9+GOrmLL/6PF0RM4WrxXttFOwovqpHxNQYtyH4IboGtbgLeNqV
         SXdXhdL07fADUCEVkrw4TPoqd61my8VqkLH8JoelYHKVxjoTN/wxYvv/ArhTnhs9dRHG
         k5aaZcuYrmlAQmcwMjLycR0ZuNHCCCf3taivtDVAZ5oAdkOHU0A1//IUelvkKEKIWYYa
         jNK5gRLbWE3DV++L1ZnaRG6YpOx9jMjvsaOPkoQD+v6pnSzOtW7vFH5SC2hG7hXGo4AN
         ec2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W5to3Z4Sn21mWEIZEJGvSoWUEuZOvMtlIkM4pTNXTa4=;
        b=S8YMykex8YYcsXcaU0zovtXebP6caG4K8wSCGtlP6dcQ9A4Nunaq07GE7r+DLAMLyQ
         Go55EC5xQg1KOqZqoJPhPgsYRx0ErTcRWwztOjCoainr3tbAPf3KHW7bmC7AQb+1/Uog
         1HDh0Gc8tRZ9Tkg3CH+wKY+iLYy3HoSYpRSdCZiWO58USrKtlAAOl+oCq+SmDh5myU4m
         l5BspMdPb45yjs5+1F8c1Aa5oT+WU+pzdjRfolVUlNOHRoVKa6kT48lWqkVGmnlm7faq
         3v3OaomAtfzyjVnfZKmJQKK0EimdHWQ4dA54nZr/hCXk7MBjB6b3+lzulu4EoIwX7Zek
         9zUw==
X-Gm-Message-State: AFqh2kpfuVGCmlN9aFoVjdxTwDsoSDYtwJKNyfuaVRc09HqGxykKIHh0
        L2jRh8YvzRLvXAx7kRZpC7BscnZmYW9haLI60PPS6g==
X-Google-Smtp-Source: AMrXdXusNUsGQL0Ne/cKnzjlrEkV3MuC9iimVicFSzsdURbLbmAJZHBO2efWxuvY91KyNogPqzmtu2qQDpJ5tYpw3H8=
X-Received: by 2002:ab0:2eb7:0:b0:43a:243f:35b7 with SMTP id
 y23-20020ab02eb7000000b0043a243f35b7mr2032126uay.101.1672127372773; Mon, 26
 Dec 2022 23:49:32 -0800 (PST)
MIME-Version: 1.0
References: <20221227022528.609839-1-mie@igel.co.jp> <20221227022528.609839-5-mie@igel.co.jp>
 <20221227020007-mutt-send-email-mst@kernel.org>
In-Reply-To: <20221227020007-mutt-send-email-mst@kernel.org>
From:   Shunsuke Mie <mie@igel.co.jp>
Date:   Tue, 27 Dec 2022 16:49:21 +0900
Message-ID: <CANXvt5pRy-i7=_ikNkZPp2HcRmWZYNJYpjO_ieBJJVc90nds+A@mail.gmail.com>
Subject: Re: [RFC PATCH 4/9] vringh: unify the APIs for all accessors
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2022=E5=B9=B412=E6=9C=8827=E6=97=A5(=E7=81=AB) 16:04 Michael S. Tsirkin <ms=
t@redhat.com>:
>
> On Tue, Dec 27, 2022 at 11:25:26AM +0900, Shunsuke Mie wrote:
> > Each vringh memory accessors that are for user, kern and iotlb has own
> > interfaces that calls common code. But some codes are duplicated and th=
at
> > becomes loss extendability.
> >
> > Introduce a struct vringh_ops and provide a common APIs for all accesso=
rs.
> > It can bee easily extended vringh code for new memory accessor and
> > simplified a caller code.
> >
> > Signed-off-by: Shunsuke Mie <mie@igel.co.jp>
> > ---
> >  drivers/vhost/vringh.c | 667 +++++++++++------------------------------
> >  include/linux/vringh.h | 100 +++---
> >  2 files changed, 225 insertions(+), 542 deletions(-)
> >
> > diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
> > index aa3cd27d2384..ebfd3644a1a3 100644
> > --- a/drivers/vhost/vringh.c
> > +++ b/drivers/vhost/vringh.c
> > @@ -35,15 +35,12 @@ static __printf(1,2) __cold void vringh_bad(const c=
har *fmt, ...)
> >  }
> >
> >  /* Returns vring->num if empty, -ve on error. */
> > -static inline int __vringh_get_head(const struct vringh *vrh,
> > -                                 int (*getu16)(const struct vringh *vr=
h,
> > -                                               u16 *val, const __virti=
o16 *p),
> > -                                 u16 *last_avail_idx)
> > +static inline int __vringh_get_head(const struct vringh *vrh, u16 *las=
t_avail_idx)
> >  {
> >       u16 avail_idx, i, head;
> >       int err;
> >
> > -     err =3D getu16(vrh, &avail_idx, &vrh->vring.avail->idx);
> > +     err =3D vrh->ops.getu16(vrh, &avail_idx, &vrh->vring.avail->idx);
> >       if (err) {
> >               vringh_bad("Failed to access avail idx at %p",
> >                          &vrh->vring.avail->idx);
>
> I like that this patch removes more lines of code than it adds.
>
> However one of the design points of vringh abstractions is that they were
> carefully written to be very low overhead.
> This is why we are passing function pointers to inline functions -
> compiler can optimize that out.
>
> I think that introducing ops indirect functions calls here is going to br=
eak
> these assumptions and hurt performance.
> Unless compiler can somehow figure it out and optimize?
> I don't see how it's possible with ops pointer in memory
> but maybe I'm wrong.
I think your concern is correct. I have to understand the compiler
optimization and redesign this approach If it is needed.
> Was any effort taken to test effect of these patches on performance?
I just tested vringh_test and already faced little performance reduction.
I have to investigate that, as you said.

Thank you for your comments.
> Thanks!
>
>
Best,
Shunsuke.
