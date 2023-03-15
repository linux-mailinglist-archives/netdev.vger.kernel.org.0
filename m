Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 674666BBEA2
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 22:12:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbjCOVMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 17:12:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230283AbjCOVMr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 17:12:47 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B7E179B00;
        Wed, 15 Mar 2023 14:12:08 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id r19-20020a05600c459300b003eb3e2a5e7bso2174627wmo.0;
        Wed, 15 Mar 2023 14:12:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678914726;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2i5cac6o/xZLVm7XeUiTqPlva/u9/ef/H/9FhTqfK9o=;
        b=cLentCqPxmTvmDUyZbKwCngMuk2qvFHZ5bu/Uf4wRCziSGcYgEOsZer1drCGIZQfP3
         Sx0Eh/i2KujfDHDKnCv3EgSJBjeR0ic1ZXdMgDein9U99QyjwxZqVhAopzkNXnr7t7N5
         6L3CE5aR/weZujaZ6Ortiob4ecXB0WEuTH+1G74yn681MrEKCSZkS1H8Vrii+RJKXSvl
         1Vdkzgb6WvuSJiEjgzKJcmjmd/l8h0KsB1FDRccYVPYIgSNaK1PCbmxZKDXH+lSbg+Fa
         0/ZAhgPxxrQH+vvFCsrHJb6PysFHWH77dVoIQxE4uud9b1GfLehs2bjtqs25Bi6iHhpb
         FjiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678914726;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2i5cac6o/xZLVm7XeUiTqPlva/u9/ef/H/9FhTqfK9o=;
        b=tEf1QSFl3YG80A69EEeum4eMDz6GpzH4YEEmdO3IRNTZnak5NY/ZaSncsYDK1SqQ2s
         ns+nq7W5/IlxP5JqfPH6RYoh5BnihH61RHKaEZLumPa+M/B55dfg5vwaLkXDLk3gZy2T
         m92jlnv5bBfkTGDbV4GiocfPSjLtybue6m7j2TL7CNhCsGtM+zQqd+h81dWP92xYXF7W
         UdPdGlXcO6CJWwL98w1UkN57Ptd3PJbfAwi/rXphzMCIiABmjd1vLzX6/CqDBaL2xGDR
         67jZ/mS/c41zMuFMz5m4zq68Z7ZrgJ+lytbqZuZiW6YeLbLSnM0b2McYZQieeSLD3721
         WaPg==
X-Gm-Message-State: AO0yUKVRhdK9ymgEPJ2p6cNIfPg41QT50v6pznp8/mwLrfzhww3Gbrjg
        I42yBJKTekYCUlAOlJoNJQY=
X-Google-Smtp-Source: AK7set+Y8+6ubqTJVxlfpG7xBGOOToD283CtFly+Uxd2XpNq7xBq7IOpqPFQu68D4a3Dsfl+LHJN4A==
X-Received: by 2002:a05:600c:4693:b0:3dc:4b87:a570 with SMTP id p19-20020a05600c469300b003dc4b87a570mr21412739wmo.35.1678914726460;
        Wed, 15 Mar 2023 14:12:06 -0700 (PDT)
Received: from suse.localnet (host-79-35-102-94.retail.telecomitalia.it. [79.35.102.94])
        by smtp.gmail.com with ESMTPSA id v7-20020a05600c214700b003eaf666cbe0sm2963099wml.27.2023.03.15.14.12.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 14:12:05 -0700 (PDT)
From:   "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
To:     Stefano Garzarella <sgarzare@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        eperezma@redhat.com, netdev@vger.kernel.org, stefanha@redhat.com,
        linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2 3/8] vringh: replace kmap_atomic() with kmap_local_page()
Date:   Wed, 15 Mar 2023 22:12:04 +0100
Message-ID: <1980067.5pFmK94fv0@suse>
In-Reply-To: <CACGkMEs6cW7LdpCdWQnX4Pif2gGOu=f3bjNeYQ6MVcdQe=X--Q@mail.gmail.com>
References: <20230302113421.174582-1-sgarzare@redhat.com>
 <20230302113421.174582-4-sgarzare@redhat.com>
 <CACGkMEs6cW7LdpCdWQnX4Pif2gGOu=f3bjNeYQ6MVcdQe=X--Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On marted=C3=AC 14 marzo 2023 04:56:08 CET Jason Wang wrote:
> On Thu, Mar 2, 2023 at 7:34=E2=80=AFPM Stefano Garzarella <sgarzare@redha=
t.com>=20
wrote:
> > kmap_atomic() is deprecated in favor of kmap_local_page().
>=20
> It's better to mention the commit or code that introduces this.
>=20
> > With kmap_local_page() the mappings are per thread, CPU local, can take
> > page-faults, and can be called from any context (including interrupts).
> > Furthermore, the tasks can be preempted and, when they are scheduled to
> > run again, the kernel virtual addresses are restored and still valid.
> >=20
> > kmap_atomic() is implemented like a kmap_local_page() which also disabl=
es
> > page-faults and preemption (the latter only for !PREEMPT_RT kernels,
> > otherwise it only disables migration).
> >=20
> > The code within the mappings/un-mappings in getu16_iotlb() and
> > putu16_iotlb() don't depend on the above-mentioned side effects of
> > kmap_atomic(),
>=20
> Note we used to use spinlock to protect simulators (at least until
> patch 7, so we probably need to re-order the patches at least) so I
> think this is only valid when:
>=20
> The vringh IOTLB helpers are not used in atomic context (e.g spinlock,
> interrupts).

I'm probably missing some context but it looks that you are saying that=20
kmap_local_page() is not suited for any use in atomic context (you are=20
mentioning spinlocks).

The commit message (that I know pretty well since it's the exact copy, word=
 by=20
word, of my boiler plate commits) explains that kmap_local_page() is perfec=
tly=20
usable in atomic context (including interrupts).

I don't know this code, however I am not able to see why these vringh IOTLB=
=20
helpers cannot work if used under spinlocks. Can you please elaborate a lit=
tle=20
more?

> If yes, should we document this? (Or should we introduce a boolean to
> say whether an IOTLB variant can be used in an atomic context)?

Again, you'll have no problems from the use of kmap_local_page() and so you=
=20
don't need any boolean to tell whether or not the code is running in atomic=
=20
context.=20

Please take a look at the Highmem documentation which has been recently=20
reworked and extended by me: https://docs.kernel.org/mm/highmem.html

Anyway, I have been ATK 12 or 13 hours in a row. So I'm probably missing th=
e=20
whole picture.

Thanks,=20

=46abio

> Thanks
>=20
> > so that mere replacements of the old API with the new one
> > is all that is required (i.e., there is no need to explicitly add calls
> > to pagefault_disable() and/or preempt_disable()).
> >=20
> > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > ---
> >=20
> > Notes:
> >     v2:
> >     - added this patch since checkpatch.pl complained about deprecation
> >    =20
> >       of kmap_atomic() touched by next patch
> > =20
> >  drivers/vhost/vringh.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> >=20
> > diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
> > index a1e27da54481..0ba3ef809e48 100644
> > --- a/drivers/vhost/vringh.c
> > +++ b/drivers/vhost/vringh.c
> > @@ -1220,10 +1220,10 @@ static inline int getu16_iotlb(const struct vri=
ngh
> > *vrh,>=20
> >         if (ret < 0)
> >        =20
> >                 return ret;
> >=20
> > -       kaddr =3D kmap_atomic(iov.bv_page);
> > +       kaddr =3D kmap_local_page(iov.bv_page);
> >=20
> >         from =3D kaddr + iov.bv_offset;
> >         *val =3D vringh16_to_cpu(vrh, READ_ONCE(*(__virtio16 *)from));
> >=20
> > -       kunmap_atomic(kaddr);
> > +       kunmap_local(kaddr);
> >=20
> >         return 0;
> > =20
> >  }
> >=20
> > @@ -1241,10 +1241,10 @@ static inline int putu16_iotlb(const struct vri=
ngh
> > *vrh,>=20
> >         if (ret < 0)
> >        =20
> >                 return ret;
> >=20
> > -       kaddr =3D kmap_atomic(iov.bv_page);
> > +       kaddr =3D kmap_local_page(iov.bv_page);
> >=20
> >         to =3D kaddr + iov.bv_offset;
> >         WRITE_ONCE(*(__virtio16 *)to, cpu_to_vringh16(vrh, val));
> >=20
> > -       kunmap_atomic(kaddr);
> > +       kunmap_local(kaddr);
> >=20
> >         return 0;
> > =20
> >  }
> >=20
> > --
> > 2.39.2




