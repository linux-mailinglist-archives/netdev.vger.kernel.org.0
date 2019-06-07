Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F29DA3981A
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 23:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731499AbfFGVy1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 17:54:27 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36139 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729577AbfFGVy1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 17:54:27 -0400
Received: by mail-pf1-f196.google.com with SMTP id u22so1907012pfm.3
        for <netdev@vger.kernel.org>; Fri, 07 Jun 2019 14:54:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=PlcrqYat2Px5OUk90i9eGuZI0yXUJxXNQombye367oI=;
        b=E5m+tBbLCU1NskzEz99g4sxBdmWO40qKlBGJw/B8+6uLL5B2zdyTCDt+F8zRNddIO3
         FtuCvLnJnRzzSSueLU3nmebA4O8VMtLz72qsC0Gves1KxiOiZ2OdWLZDi1ntwMnkI/Dh
         yj58ZJn1iRhrNXod+28s3t3qIFmaKWC8QzGXo3KT/NomV0BZrfPjZb5jVT/jHP2sNygB
         AgFDQB9DIDqpFc+WAEllE7gPcR9TKbw9WOA1iAtQwSSgxVyI1+c0LfDIgABdpIwiHskc
         1lHY1CCWIWy307WGMWolhB7jM+utSHdX9YIKfNZ6J15q+kjYqyJkWVA5H7IO92jrohFh
         5Dcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=PlcrqYat2Px5OUk90i9eGuZI0yXUJxXNQombye367oI=;
        b=XIZr0htN0EMcXcbtbP6mZbws1JUIQhvw4v70TjQ9+sVOFUmNnG+nBQT4VPU2XKdQMZ
         i4tPsTSkYXgQscd/EVZ0qn16qNcI8SZdeNz2Y8+2xFeR9Dp39x8or1rQYFq3GldRaeGe
         9hJb4s/FR402hgJJQeiNdtTFUPT+ExgIO46u/NdhALEq7LipfRoF4FFtqTjE4/K4QlwN
         YyjWosURBD+SX5Vc/t+UMm+5wjS92w2Bv91qpsF4fCf9wUxuhTL0pGgmYM6jmJKPYOWB
         g9ye54556K56DLTjVRhQrjeo4gj3AFvAgZGE5JWrzdIP4Xs7JEnjC/Qk2hlfs0fKd1bf
         yOvA==
X-Gm-Message-State: APjAAAUofKetDvPoOOXj6d5MPU9h1q226o7rPtb7DQvQngOBz17xCbyA
        qFdqhn4scMyfbXiu0lIELmEBnQ==
X-Google-Smtp-Source: APXvYqzcORcSMihqOAniLhzqnG5b+j98C5Z/a+vfEsifoAK1DacEObBZ6W2d5hdgJ/nhwR8Jn4MaLA==
X-Received: by 2002:a17:90a:9514:: with SMTP id t20mr7959074pjo.124.1559944466185;
        Fri, 07 Jun 2019 14:54:26 -0700 (PDT)
Received: from cakuba.netronome.com (wsip-98-171-133-120.sd.sd.cox.net. [98.171.133.120])
        by smtp.gmail.com with ESMTPSA id e9sm3971315pfn.154.2019.06.07.14.54.24
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 07 Jun 2019 14:54:25 -0700 (PDT)
Date:   Fri, 7 Jun 2019 14:54:20 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     "Bshara, Nafea" <nafea@amazon.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        David Woodhouse <dwmw2@infradead.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Jubran, Samih" <sameehj@amazon.com>, Andrew Lunn <andrew@lunn.ch>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Wilson, Matt" <msw@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>
Subject: Re: [PATCH V2 net 00/11] Extending the ena driver to support new
 features and enhance performance
Message-ID: <20190607145420.5a1811f8@cakuba.netronome.com>
In-Reply-To: <F6CECB83-63C5-4A91-8798-84846A3D7E00@amazon.com>
References: <20190603144329.16366-1-sameehj@amazon.com>
        <9da931e72debc868efaac144082f40d379c50f3c.camel@amazon.co.uk>
        <20190603160351.085daa91@cakuba.netronome.com>
        <20190604015043.GG17267@lunn.ch>
        <D26B5448-1E74-44E8-83DA-FC93E5520325@amazon.com>
        <af79f238465ebe069bc41924a2ae2efbcdbd6e38.camel@infradead.org>
        <20190604102406.1f426339@cakuba.netronome.com>
        <7f697af8f31f4bc7ba30ef643e7b3921@EX13D11EUB003.ant.amazon.com>
        <20190606100945.49ceb657@cakuba.netronome.com>
        <D9B372D5-1B71-4387-AA8D-E38B22B44D8D@amazon.com>
        <20190606150428.2e55eb08@cakuba.netronome.com>
        <861B5CF2-878E-4610-8671-9D66AB61ABD7@amazon.com>
        <20190606160756.73fe4c06@cakuba.netronome.com>
        <35E875B8-FAE8-4C6A-BA30-FB3E2F7BA66B@amazon.com>
        <20190606164219.10dca54e@cakuba.netronome.com>
        <9057E288-28BA-4865-B41A-5847EE41D66F@amazon.com>
        <20190606181416.5ce1400d@cakuba.netronome.com>
        <20190607142717.3ee89f12@cakuba.netronome.com>
        <F6CECB83-63C5-4A91-8798-84846A3D7E00@amazon.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 7 Jun 2019 21:34:00 +0000, Bshara, Nafea wrote:
> =EF=BB=BFOn 6/7/19, 2:27 PM, "Jakub Kicinski" <jakub.kicinski@netronome.c=
om> wrote:
>=20
>     On Thu, 6 Jun 2019 18:14:16 -0700, Jakub Kicinski wrote:
>     > On Fri, 7 Jun 2019 01:04:14 +0000, Bshara, Nafea wrote: =20
>     > > On Jun 6, 2019, at 4:43 PM, Jakub Kicinski wrote:   =20
>     > > >>> Okay, then you know which one is which.  Are there multiple E=
NAs but
>     > > >>> one EFA?   =20
>     > > >>=20
>     > > >> Yes,  very possible. Very common
>     > > >>=20
>     > > >> Typical use case that instances have one ena for control plane=
, one
>     > > >> for internet facing , and one 100G ena that also have efa capa=
bilities   =20
>     > > >=20
>     > > > I see, and those are PCI devices..  Some form of platform data =
would
>     > > > seem like the best fit to me.  There is something called:
>     > > >=20
>     > > > /sys/bus/pci/${dbdf}/label
>     > > >=20
>     > > > It seems to come from some ACPI table - DSM maybe?  I think you=
 can put
>     > > > whatever string you want there =F0=9F=A4=94     =20
>     > >=20
>     > > Acpi path won=E2=80=99t work, much of thee interface are hot atta=
ched, using
>     > > native pcie hot plug and acpi won=E2=80=99t be involved.    =20
>     >=20
>     > Perhaps hotplug break DSM, I won't pretend to be an ACPI expert.  S=
o you
>     > can find a way to stuff the label into that file from another sourc=
e.
>     > There's also VPD, or custom PCI caps, but platform data generally s=
eems
>     > like a better idea. =20
>    =20
>     Jiri, do you have any thoughts about using phys_port_name for exposing
>     topology in virtual environments.  Perhaps that's the best fit on the
>     netdev side.  It's not like we want any other port name in such case,
>     and having it automatically appended to the netdev name may be useful.
>    =20
> any preference for that vs /sysfs ?

I think so.  For the topology (control, internal, external) I feel like
its a reasonable fit, and well supported by udev/systemd.  We use it for
appending port names of the switch today (p0, p1, p2, etc).  Jiri was
working on making the core kernel generate those automatically so lets
give him a chance to speak up.

For the ENA<>EFA link I think you may still need to resort to sysfs,
unless it can be somehow implied by the topology label?
