Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC8610857F
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 00:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbfKXXSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Nov 2019 18:18:13 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:41569 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726952AbfKXXSN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Nov 2019 18:18:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574637491;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PClP5vcK7H2hH8iu9CCJfFi1HH/SjqItErOS3dnGhZA=;
        b=B/4vbwilry7b5EBNRHfptH0fo2zN10cRv9BSdLEG/GY0yBxinylm313fcOTx2pjtHB0tdb
        z1OMKZ86bKnu2sAGNJrorjPZjVA+P2FWX2d76uUMH2US2NCeU/RCGmIJL/2C9FtyORPEbG
        5z4Rea1LIsvzDbOygUVTGsDfwXJN2QE=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-326-ExJxhr-HMD-44AgfvyXmDQ-1; Sun, 24 Nov 2019 18:18:08 -0500
Received: by mail-qt1-f200.google.com with SMTP id v92so9067751qtd.18
        for <netdev@vger.kernel.org>; Sun, 24 Nov 2019 15:18:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fuJZGXqNTPkHKKy9Zo1tRW4D2w7eYV51Z20agxm/QfY=;
        b=oICChJAyOV23ngMoXC5f2AWNSQ69cIqOsryiRvZO3wepwcRBU5gmq098rFetkcWHJn
         HcMiygnrvTeset4UERVaaw/XYUjfIHUlU7Zr8lAFgItZvUfqN51OZqsYPa9UKrEjvUZ0
         vv2+irhmpTRvv7mbrXAl0BBb2n9zv5lDDqo3WKCrkwvHgDgSQttptcDMqT+0nMvpR2yM
         Xe8iyxeOzCbw/ZPr/fp6gxJXm3hU/8kmrub6inSgDEQaLoffrNtRXsoqmJFnU6Afq0PL
         B1NcYnDfwpLt78jizialIeCMJymEMgNnxoKLjMsy02whyO78Q454ASis/6bc7pk5FM3V
         qQ+g==
X-Gm-Message-State: APjAAAWAg/ZoloF6CtjkDolnC4VngOzFbg7OYD38thM26blmSczGyFAP
        jOLRVpf98tLXo/Ve3Uh50tWvyY9ftPyGZchWG3Sxi+Uyf23vBvIhW2IFqIfAJ6/0bR143Xe8KWG
        /QK9IbgAqDYwoFwQL
X-Received: by 2002:ac8:754c:: with SMTP id b12mr16779098qtr.291.1574637488459;
        Sun, 24 Nov 2019 15:18:08 -0800 (PST)
X-Google-Smtp-Source: APXvYqzifxug591hBiIzAoyGSEYaT6MrOBiQSwRPRmdW7PdE6LTobqahiQLu0xVWQAlGqwHRLz37Eg==
X-Received: by 2002:ac8:754c:: with SMTP id b12mr16779087qtr.291.1574637488287;
        Sun, 24 Nov 2019 15:18:08 -0800 (PST)
Received: from redhat.com (bzq-79-176-6-42.red.bezeqint.net. [79.176.6.42])
        by smtp.gmail.com with ESMTPSA id l45sm2841796qtb.32.2019.11.24.15.18.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Nov 2019 15:18:07 -0800 (PST)
Date:   Sun, 24 Nov 2019 18:18:02 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Julio Faracco <jcfaracco@gmail.com>, netdev@vger.kernel.org,
        Daiane Mendes <dnmendes76@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] drivers: net: virtio_net: Implement a
 dev_watchdog handler
Message-ID: <20191124181750-mutt-send-email-mst@kernel.org>
References: <20191122013636.1041-1-jcfaracco@gmail.com>
 <20191122052506-mutt-send-email-mst@kernel.org>
 <CAENf94KX1XR4_KXz9KLZQ09Ngeaq2qzYY5OE68xJMXMu13SuEg@mail.gmail.com>
 <20191124100157-mutt-send-email-mst@kernel.org>
 <20191124164411-mutt-send-email-mst@kernel.org>
 <20191124150352.5cab3209@cakuba.netronome.com>
MIME-Version: 1.0
In-Reply-To: <20191124150352.5cab3209@cakuba.netronome.com>
X-MC-Unique: ExJxhr-HMD-44AgfvyXmDQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 24, 2019 at 03:03:52PM -0800, Jakub Kicinski wrote:
> On Sun, 24 Nov 2019 16:48:35 -0500, Michael S. Tsirkin wrote:
> > diff --git a/arch/m68k/emu/nfeth.c b/arch/m68k/emu/nfeth.c
> > index a4ebd2445eda..8e06e7407854 100644
> > --- a/arch/m68k/emu/nfeth.c
> > +++ b/arch/m68k/emu/nfeth.c
> > @@ -167,7 +167,7 @@ static int nfeth_xmit(struct sk_buff *skb, struct n=
et_device *dev)
> >  =09return 0;
> >  }
> > =20
> > -static void nfeth_tx_timeout(struct net_device *dev)
> > +static void nfeth_tx_timeout(struct net_device *dev, int txqueue)
>=20
> Given the recent vf ndo problems, I wonder if it's worth making the
> queue id unsigned from the start? Since it's coming from the stack
> there should be no range checking required, but also signed doesn't
> help anything so why not?
>=20
> >  {
> >  =09dev->stats.tx_errors++;
> >  =09netif_wake_queue(dev);

You are right. I'll change this.

