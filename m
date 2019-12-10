Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB8F2118ACC
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 15:27:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727516AbfLJO1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 09:27:36 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28627 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727061AbfLJO1f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 09:27:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575988054;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DzrfXrqS3i0iVxslRT9HAUzTMYttEiFFx6V9DjllFWk=;
        b=W4fAZHWP8bLvyk8hy1d4EWjsxjawEaI113wtarJYG3eQccSjbepiYAXxpEwDMf45AtF/FF
        YRF1buyhaY/vLD+SXGj4yIEKHzSk9rQp89uLbEr5Km1dkKTsJvAqh1NPi4avdimAabzrg6
        Lstw48hUmCOxGLL1jjE6tpgpD39boNM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-317-iykX1j-tMSuuq2-P97vuTg-1; Tue, 10 Dec 2019 09:27:33 -0500
Received: by mail-wm1-f71.google.com with SMTP id 7so654655wmf.9
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 06:27:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=X1lHEli2ZPEUphqWeLKjY7ANrLSq38w1XZiJ4O+hMh4=;
        b=rzarQfv6jYpTP3bIqeJB8DzoOuwao40p7DbznHrWNYENkqpTiQzZkD3pv/vO55fQhM
         4stV/WQ10FoK1uJNrsGcIMd3WsH5PL2BbIW21j4by9vMchGN1kBV1S8XL/Nocb6R1NLs
         cN6TUtL4Cr1vmyA5QrzuR5Uj5JhPMBwXSATWTcmE6hqHA6N3akaF5miedcCUA7KNoHzV
         mxg1OUZlf3Vl0HRX+JK93STT6/60N/OE5ijvMu4FLBse1oeqqlJdQ7fh2OI3QKKHTH65
         YLflYxhHAhSikcr6x3zFjEn1hrScCF3efQJ8+vIoIPE6kj1N1bpA5+m7+6SoXiaiizN0
         ThNw==
X-Gm-Message-State: APjAAAUIkobrCWgT/rD0Hab6Jgisoy/Yls0BC/6lm2Z1thDOim7CKmC/
        8w4urqY+2O7Y5wGfJsvTguHrh0tZgw6aNy6NNIEv0QDNiajHtFtPQe4CzcZ0+4c1PIw/SIZ5i2j
        j6LKxkYj9+xPyHbRG
X-Received: by 2002:a7b:c30b:: with SMTP id k11mr3443159wmj.36.1575988050871;
        Tue, 10 Dec 2019 06:27:30 -0800 (PST)
X-Google-Smtp-Source: APXvYqyORv9pUAClZj3uuRIeWG42TpWgdtau7zFiq4ztIMEHBp0R7wL6KdQcy5e01sv2Y+LjIftgSw==
X-Received: by 2002:a7b:c30b:: with SMTP id k11mr3443140wmj.36.1575988050692;
        Tue, 10 Dec 2019 06:27:30 -0800 (PST)
Received: from redhat.com (bzq-79-181-48-215.red.bezeqint.net. [79.181.48.215])
        by smtp.gmail.com with ESMTPSA id n1sm3420590wrw.52.2019.12.10.06.27.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 06:27:30 -0800 (PST)
Date:   Tue, 10 Dec 2019 09:27:27 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Julio Faracco <jcfaracco@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, dnmendes76@gmail.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Shannon Nelson <snelson@pensando.io>,
        Martin Habets <mhabets@solarflare.com>
Subject: Re: [PATCH RFC net-next v8 1/3] netdev: pass the stuck queue to the
 timeout handler
Message-ID: <20191210092623-mutt-send-email-mst@kernel.org>
References: <20191203201804.662066-1-mst@redhat.com>
 <20191203201804.662066-2-mst@redhat.com>
 <CAMuHMdXDm0NiCk1pD_-wS9c-ErmRKkrqnPc_pGKzG=QB35mj9A@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAMuHMdXDm0NiCk1pD_-wS9c-ErmRKkrqnPc_pGKzG=QB35mj9A@mail.gmail.com>
X-MC-Unique: iykX1j-tMSuuq2-P97vuTg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 09, 2019 at 08:40:06AM +0100, Geert Uytterhoeven wrote:
> Hi Michael,
>=20
> On Tue, Dec 3, 2019 at 9:21 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > This allows incrementing the correct timeout statistic without any mess=
.
> > Down the road, devices can learn to reset just the specific queue.
> >
> > The patch was generated with the following script:
>=20
> [...]
>=20
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>=20
> > --- a/drivers/net/ethernet/8390/8390p.c
> > +++ b/drivers/net/ethernet/8390/8390p.c
> > @@ -41,9 +41,9 @@ void eip_set_multicast_list(struct net_device *dev)
> >  }
> >  EXPORT_SYMBOL(eip_set_multicast_list);
> >
> > -void eip_tx_timeout(struct net_device *dev)
> > +void eip_tx_timeout(struct net_device *dev, unsigned int txqueue)
> >  {
> > -       __ei_tx_timeout(dev);
> > +       __ei_tx_timeout(dev, txqueue);
> >  }
> >  EXPORT_SYMBOL(eip_tx_timeout);
>=20
> On Mon, Dec 9, 2019 at 6:37 AM <noreply@ellerman.id.au> wrote:
> > FAILED linux-next/m68k-defconfig/m68k Mon Dec 09, 16:34
> >
> > http://kisskb.ellerman.id.au/kisskb/buildresult/14060060/
> >
> > Commit:   Add linux-next specific files for 20191209
> >           6cf8298daad041cd15dc514d8a4f93ca3636c84e
> > Compiler: m68k-linux-gcc (GCC) 4.6.3 / GNU ld (GNU Binutils) 2.22
> >
> > Possible errors
> > ---------------
> >
> > drivers/net/ethernet/8390/8390p.c:44:6: error: conflicting types for 'e=
ip_tx_timeout'
> > drivers/net/ethernet/8390/8390p.c:48:1: error: conflicting types for 'e=
ip_tx_timeout'
> > make[5]: *** [scripts/Makefile.build:266: drivers/net/ethernet/8390/839=
0p.o] Error 1
> > make[4]: *** [scripts/Makefile.build:503: drivers/net/ethernet/8390] Er=
ror 2
> > make[3]: *** [scripts/Makefile.build:503: drivers/net/ethernet] Error 2
> > make[2]: *** [scripts/Makefile.build:503: drivers/net] Error 2
> > make[1]: *** [Makefile:1693: drivers] Error 2
> > make: *** [Makefile:179: sub-make] Error 2
>=20
> Looks like you forgot to update the forward declaration in
> drivers/net/ethernet/8390/8390.h

Fixed now.

> There may be others...

Could not find any but pls do let me know.

> http://kisskb.ellerman.id.au/kisskb/head/6cf8298daad041cd15dc514d8a4f93ca=
3636c84e/
>=20
> Gr{oetje,eeting}s,
>=20
>                         Geert
>=20
> --=20
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m6=
8k.org
>=20
> In personal conversations with technical people, I call myself a hacker. =
But
> when I'm talking to journalists I just say "programmer" or something like=
 that.
>                                 -- Linus Torvalds

