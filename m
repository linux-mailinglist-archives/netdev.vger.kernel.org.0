Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3E84C226F
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 04:36:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbiBXDel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 22:34:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiBXDek (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 22:34:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1A37722A281
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 19:34:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645673651;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dRVV6TmPyQlUU8AVGLAcBRDwJHwTdqvbfx7jgBXGTKI=;
        b=hImqZutijLMVBa40aK/yN/92Lvedl58ALTHoYS6Ccw/jl1jbaDN6/oq9W81labi+Tsuoql
        U8IUmVpNkx7YVG67ATKVMtnPrj9oSvCbcfnIghUkGz2/mopzZuirD50hCiy+OgZ0GcCIxF
        dtSYV3PLYamBMxfm3cWoIDU/x/zm+Ak=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-440-QXH3bRvPPPaWdJ5UpQJ8tg-1; Wed, 23 Feb 2022 22:34:09 -0500
X-MC-Unique: QXH3bRvPPPaWdJ5UpQJ8tg-1
Received: by mail-lj1-f198.google.com with SMTP id d23-20020a05651c089700b002463e31a5ffso413076ljq.3
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 19:34:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dRVV6TmPyQlUU8AVGLAcBRDwJHwTdqvbfx7jgBXGTKI=;
        b=YIXQDpYkSrTEigA6DNp3V7Wi8zm2ufKQ8hKdUZw/gvke5u4GHypR5TgdFaUcR2q7Is
         xvwl4BmxTuUQWJ3kAGHqawPOp4v8FdFuJffpz/Awlju9uSRF9/B+GRZCOqBs8RJkHuRT
         p4ypiLcdS+bD6nYcFE8SbdYCg6T2DbT16T/i1D51d+92KGT5FmdJcTCojp2eaY/ORayr
         9VmANHiYaK0nGK8mNE77kkTwQeFSQLSe26U7H4NNOJ1gFMsFOz/p2O4vTjmaO/OiFhDI
         HM6c7/edCu0zNnAO6QXol4KpmfFVjJISy7gucLjvEYqsL6bP0om3mIbhB7HfiALytoQY
         zBIA==
X-Gm-Message-State: AOAM533qXDH1FXJsgFJYJUjwxF4W5esmZHQACnRHhrIHzdkizvRbF6OE
        hb8k1UbEWUq81vJDbtfaW5qVlHwsy31xcWTd+ELhuyoVyEpJulcd/eVBglmge9z7FnkwdtxSZnM
        zTfRFd4GaZa51JRJiYrkI6NmMkjC0DB2R
X-Received: by 2002:a05:651c:90b:b0:244:c4a4:d5d8 with SMTP id e11-20020a05651c090b00b00244c4a4d5d8mr505695ljq.97.1645673648369;
        Wed, 23 Feb 2022 19:34:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzpmLs9g/U0Nam8IX5XUKO+vHZBxi+ea87oOifawu8S182lz+abrWGFM4Nuj1sMsYtNTba1YT9wi3dOmn1L1ts=
X-Received: by 2002:a05:651c:90b:b0:244:c4a4:d5d8 with SMTP id
 e11-20020a05651c090b00b00244c4a4d5d8mr505687ljq.97.1645673648154; Wed, 23 Feb
 2022 19:34:08 -0800 (PST)
MIME-Version: 1.0
References: <20220125084702.3636253-1-andrew@daynix.com> <20220125084702.3636253-2-andrew@daynix.com>
 <06a90de0-57ae-9315-dc2c-03cc74b4ae0c@redhat.com> <CABcq3pH7HnH_-nCHcX7eet_ouqocQEptp6A9GCbs3=9guArhPA@mail.gmail.com>
 <CACGkMEu3biQ+BM29nDu82jP8y+p4iiL4K=GzM6px+yktU5Zqjw@mail.gmail.com> <CAOEp5OeGNezTasp7zsvpFHGfjkM4bWRbbFY7WEWc7hRYVDSxdA@mail.gmail.com>
In-Reply-To: <CAOEp5OeGNezTasp7zsvpFHGfjkM4bWRbbFY7WEWc7hRYVDSxdA@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 24 Feb 2022 11:33:56 +0800
Message-ID: <CACGkMEvJj040VqzhaJkAZs-bLeGoWWUYtBguEZAqTqVBH7ShLg@mail.gmail.com>
Subject: Re: [RFC PATCH 1/5] uapi/linux/if_tun.h: Added new ioctl for tun/tap.
To:     Yuri Benditovich <yuri.benditovich@daynix.com>
Cc:     Andrew Melnichenko <andrew@daynix.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Yan Vugenfirer <yan@daynix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 23, 2022 at 9:31 PM Yuri Benditovich
<yuri.benditovich@daynix.com> wrote:
>
> Hi Jason,
> We agree that the same can be done also using the old way, i.e. try to
> set specific offload - if failed, probably it is not supported.
> We think this is a little not scalable and we suggest adding the ioctl
> that will allow us to query allo the supported features in a single
> call.

Possibly but then you need some kind of probing. E.g we need endup
with probing TUNGETSUPPORTEDOFFLOADS iotctl itself.

> We think this will make QEMU code more simple also in future.

We can discuss this when qemu patches were sent.

> Do I understand correctly that you suggest to skip this new ioctl and
> use the old way of query for this (USO) feature and all future
> extensions?

Yes, since it's not a must. And we can do the TUNGETSUPPORTEDOFFLOADS
in a separate series.

Thanks

>
> Thanks
>
>
> On Wed, Feb 23, 2022 at 5:53 AM Jason Wang <jasowang@redhat.com> wrote:
> >
> > On Tue, Feb 22, 2022 at 9:28 PM Andrew Melnichenko <andrew@daynix.com> =
wrote:
> > >
> > > Hi all,
> > >
> > > On Wed, Feb 9, 2022 at 6:26 AM Jason Wang <jasowang@redhat.com> wrote=
:
> > > >
> > > >
> > > > =E5=9C=A8 2022/1/25 =E4=B8=8B=E5=8D=884:46, Andrew Melnychenko =E5=
=86=99=E9=81=93:
> > > > > Added TUNGETSUPPORTEDOFFLOADS that should allow
> > > > > to get bits of supported offloads.
> > > >
> > > >
> > > > So we don't use dedicated ioctls in the past, instead, we just prob=
ing
> > > > by checking the return value of TUNSETOFFLOADS.
> > > >
> > > > E.g qemu has the following codes:
> > > >
> > > > int tap_probe_has_ufo(int fd)
> > > > {
> > > >      unsigned offload;
> > > >
> > > >      offload =3D TUN_F_CSUM | TUN_F_UFO;
> > > >
> > > >      if (ioctl(fd, TUNSETOFFLOAD, offload) < 0)
> > > >          return 0;
> > > >
> > > >      return 1;
> > > > }
> > > >
> > > > Any reason we can't keep using that?
> > > >
> > > > Thanks
> > > >
> > >
> > > Well, even in this example. To check the ufo feature, we trying to se=
t it.
> > > What if we don't need to "enable" UFO and/or do not change its state?
> >
> > So at least Qemu doesn't have such a requirement since during the
> > probe the virtual networking backend is not even started.
> >
> > > I think it's a good idea to have the ability to get supported offload=
s
> > > without changing device behavior.
> >
> > Do you see a real user for this?
> >
> > Btw, we still need to probe this new ioctl anyway.
> >
> > Thanks
> >
> > >
> > > >
> > > > > Added 2 additional offlloads for USO(IPv4 & IPv6).
> > > > > Separate offloads are required for Windows VM guests,
> > > > > g.e. Windows may set USO rx only for IPv4.
> > > > >
> > > > > Signed-off-by: Andrew Melnychenko <andrew@daynix.com>
> > > > > ---
> > > > >   include/uapi/linux/if_tun.h | 3 +++
> > > > >   1 file changed, 3 insertions(+)
> > > > >
> > > > > diff --git a/include/uapi/linux/if_tun.h b/include/uapi/linux/if_=
tun.h
> > > > > index 454ae31b93c7..07680fae6e18 100644
> > > > > --- a/include/uapi/linux/if_tun.h
> > > > > +++ b/include/uapi/linux/if_tun.h
> > > > > @@ -61,6 +61,7 @@
> > > > >   #define TUNSETFILTEREBPF _IOR('T', 225, int)
> > > > >   #define TUNSETCARRIER _IOW('T', 226, int)
> > > > >   #define TUNGETDEVNETNS _IO('T', 227)
> > > > > +#define TUNGETSUPPORTEDOFFLOADS _IOR('T', 228, unsigned int)
> > > > >
> > > > >   /* TUNSETIFF ifr flags */
> > > > >   #define IFF_TUN             0x0001
> > > > > @@ -88,6 +89,8 @@
> > > > >   #define TUN_F_TSO6  0x04    /* I can handle TSO for IPv6 packet=
s */
> > > > >   #define TUN_F_TSO_ECN       0x08    /* I can handle TSO with EC=
N bits. */
> > > > >   #define TUN_F_UFO   0x10    /* I can handle UFO packets */
> > > > > +#define TUN_F_USO4   0x20    /* I can handle USO for IPv4 packet=
s */
> > > > > +#define TUN_F_USO6   0x40    /* I can handle USO for IPv6 packet=
s */
> > > > >
> > > > >   /* Protocol info prepended to the packets (when IFF_NO_PI is no=
t set) */
> > > > >   #define TUN_PKT_STRIP       0x0001
> > > >
> > >
> >
>

