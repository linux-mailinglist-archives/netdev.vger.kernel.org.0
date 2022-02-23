Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE05A4C0ABC
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 04:53:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235580AbiBWDyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 22:54:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231149AbiBWDyS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 22:54:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CA40266AC8
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 19:53:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645588431;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3uuENq0mwZK3ocIAxn7hRMdyfy5YF/bh1dVB+AAu0W0=;
        b=EvriUEYbIua/1jEle93FmNtSncjB80gDXVM8nIXZOV7a0y0Dtl842gcroWSlzoga/ngHnY
        Fk8mDHXBBzanA1xTCZ5fM/PlnFTsm/SYCdpFcZ2VmFTk0k23Q87PcSzyj00wlwWjol4S0X
        4Bk04lMtMsnskAa/pQArof+9siaG8cs=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-338-0Au23mUUMbawlL1iTzgSkA-1; Tue, 22 Feb 2022 22:53:49 -0500
X-MC-Unique: 0Au23mUUMbawlL1iTzgSkA-1
Received: by mail-lf1-f69.google.com with SMTP id m24-20020a056512359800b00442b6ff7a0eso3071424lfr.1
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 19:53:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3uuENq0mwZK3ocIAxn7hRMdyfy5YF/bh1dVB+AAu0W0=;
        b=uI4KuqRJMZ5o0kv8nH6LToc8qTLO8OQeHE8U87toFLDNE5KPYPHmyt57brshowY4B3
         qyh7lSv5LBfdc9fDkB9FmBtNhqWHPAcIcqZ8mFL6wqHWuS2DNdvfylas5btATG2lAFOy
         5S2GMeA0bGNrJnaag/phDKX12/BGTZ1kOznZK8B9MHYHuJl7bNbbT+tUqBS5grQhGS4M
         0Z04XscCniWF0rAsfoa/c64QQXKH+WW/jUfBLbbUeg6GttlGqclodxY6ePoOVGpLqSLM
         d0nOdJb2YoJ1BHyFgLGUzXhg9nPwaI0IjRka4viNp0Zri02xe3XndHWkpTXWiE6KHrOG
         1sEw==
X-Gm-Message-State: AOAM533ik+PkQNY2yrsjuvRhToyUtZmoM/+jIwrwd2fAi/kYlyvKAKeN
        Iq/fr+njsvpBtsoBH+3OIEDblJlylDXX3jMoFcy9WSha1jpym0C4ehpsIpAcUXkTzQUIh5uTH3l
        +jbuFBQGfv6kLP5o698gcTMUmlKXsWVDC
X-Received: by 2002:a05:6512:3147:b0:443:323d:179d with SMTP id s7-20020a056512314700b00443323d179dmr19783726lfi.98.1645588427957;
        Tue, 22 Feb 2022 19:53:47 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwTg1800Nq5+wExhYu7GSgkaGsiqwidtasywKGX7t1ujuxR3LE5nhHs54UMgx2PMMT6JvevH9IePF5C2GpdOuA=
X-Received: by 2002:a05:6512:3147:b0:443:323d:179d with SMTP id
 s7-20020a056512314700b00443323d179dmr19783713lfi.98.1645588427730; Tue, 22
 Feb 2022 19:53:47 -0800 (PST)
MIME-Version: 1.0
References: <20220125084702.3636253-1-andrew@daynix.com> <20220125084702.3636253-2-andrew@daynix.com>
 <06a90de0-57ae-9315-dc2c-03cc74b4ae0c@redhat.com> <CABcq3pH7HnH_-nCHcX7eet_ouqocQEptp6A9GCbs3=9guArhPA@mail.gmail.com>
In-Reply-To: <CABcq3pH7HnH_-nCHcX7eet_ouqocQEptp6A9GCbs3=9guArhPA@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 23 Feb 2022 11:53:36 +0800
Message-ID: <CACGkMEu3biQ+BM29nDu82jP8y+p4iiL4K=GzM6px+yktU5Zqjw@mail.gmail.com>
Subject: Re: [RFC PATCH 1/5] uapi/linux/if_tun.h: Added new ioctl for tun/tap.
To:     Andrew Melnichenko <andrew@daynix.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Yuri Benditovich <yuri.benditovich@daynix.com>,
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

On Tue, Feb 22, 2022 at 9:28 PM Andrew Melnichenko <andrew@daynix.com> wrot=
e:
>
> Hi all,
>
> On Wed, Feb 9, 2022 at 6:26 AM Jason Wang <jasowang@redhat.com> wrote:
> >
> >
> > =E5=9C=A8 2022/1/25 =E4=B8=8B=E5=8D=884:46, Andrew Melnychenko =E5=86=
=99=E9=81=93:
> > > Added TUNGETSUPPORTEDOFFLOADS that should allow
> > > to get bits of supported offloads.
> >
> >
> > So we don't use dedicated ioctls in the past, instead, we just probing
> > by checking the return value of TUNSETOFFLOADS.
> >
> > E.g qemu has the following codes:
> >
> > int tap_probe_has_ufo(int fd)
> > {
> >      unsigned offload;
> >
> >      offload =3D TUN_F_CSUM | TUN_F_UFO;
> >
> >      if (ioctl(fd, TUNSETOFFLOAD, offload) < 0)
> >          return 0;
> >
> >      return 1;
> > }
> >
> > Any reason we can't keep using that?
> >
> > Thanks
> >
>
> Well, even in this example. To check the ufo feature, we trying to set it=
.
> What if we don't need to "enable" UFO and/or do not change its state?

So at least Qemu doesn't have such a requirement since during the
probe the virtual networking backend is not even started.

> I think it's a good idea to have the ability to get supported offloads
> without changing device behavior.

Do you see a real user for this?

Btw, we still need to probe this new ioctl anyway.

Thanks

>
> >
> > > Added 2 additional offlloads for USO(IPv4 & IPv6).
> > > Separate offloads are required for Windows VM guests,
> > > g.e. Windows may set USO rx only for IPv4.
> > >
> > > Signed-off-by: Andrew Melnychenko <andrew@daynix.com>
> > > ---
> > >   include/uapi/linux/if_tun.h | 3 +++
> > >   1 file changed, 3 insertions(+)
> > >
> > > diff --git a/include/uapi/linux/if_tun.h b/include/uapi/linux/if_tun.=
h
> > > index 454ae31b93c7..07680fae6e18 100644
> > > --- a/include/uapi/linux/if_tun.h
> > > +++ b/include/uapi/linux/if_tun.h
> > > @@ -61,6 +61,7 @@
> > >   #define TUNSETFILTEREBPF _IOR('T', 225, int)
> > >   #define TUNSETCARRIER _IOW('T', 226, int)
> > >   #define TUNGETDEVNETNS _IO('T', 227)
> > > +#define TUNGETSUPPORTEDOFFLOADS _IOR('T', 228, unsigned int)
> > >
> > >   /* TUNSETIFF ifr flags */
> > >   #define IFF_TUN             0x0001
> > > @@ -88,6 +89,8 @@
> > >   #define TUN_F_TSO6  0x04    /* I can handle TSO for IPv6 packets */
> > >   #define TUN_F_TSO_ECN       0x08    /* I can handle TSO with ECN bi=
ts. */
> > >   #define TUN_F_UFO   0x10    /* I can handle UFO packets */
> > > +#define TUN_F_USO4   0x20    /* I can handle USO for IPv4 packets */
> > > +#define TUN_F_USO6   0x40    /* I can handle USO for IPv6 packets */
> > >
> > >   /* Protocol info prepended to the packets (when IFF_NO_PI is not se=
t) */
> > >   #define TUN_PKT_STRIP       0x0001
> >
>

