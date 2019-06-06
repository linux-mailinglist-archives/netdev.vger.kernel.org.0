Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD2F381E1
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 01:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727626AbfFFXm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 19:42:26 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:33252 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726918AbfFFXmZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 19:42:25 -0400
Received: by mail-qt1-f193.google.com with SMTP id 14so318357qtf.0
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 16:42:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=nrpTl9nls/aO71I8CVqzWKsqdb5/V3yUjgXfNhaAIHs=;
        b=KTprmGJis4vjAitKp8P3aROD8TpzAGq2N1CeHkNmYarkdEvaK13YAMBDKEu37JBBMd
         LAFmKd29G5UNZOyhxfJBA99sQpJlK8HIaGI3ca47PxJRjs2hnn0EBtCwsL05I/7xlTGL
         K+ZJXtwA+8qODOgWBnrdkODMmLB8EQRvp8sM1TFBp1j86IkU4dgycrcYMA27v/s9GtyZ
         +EVBL8pFf95gF9uy3ZNbDkck5IUyL1dPq4CmdEzxuwxcs/qa1Il8ooJqq/RPptvsDnjy
         z+uRs+B3u/kZyHcLvfVq3Apu+hNfZ0lua4YlwKoGpqTY4dD9BDyt4qi5oU65bg+FkHnx
         vKHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=nrpTl9nls/aO71I8CVqzWKsqdb5/V3yUjgXfNhaAIHs=;
        b=bJStOESIVMqPlfvk5zQaznHySATBdrB2dPiCjbeCGnV1z62nYzOX54HeDoDOZWV0Vf
         XMP7hSjE/0wEeyUDA/KPStHhBhh9xKrYBECz4nVjrgOav5S2OGuFA1Lik7s/n0mhaWm4
         xxLbuRXlq+QG2EKRCVBFV1fW2JhUo4oIVO4QNuByXB+6ihTmvMUviqgoG/o8dwKAWriv
         slAVmI6+NlcXnK8HUsjUQMEfKwKL/M/cpOefINjnPxDGdCFep49LTQND/Ppg88/B2zJn
         Mvee4zYnppap2BJ9pg8J0FKkQ2jagaZ8AxxV2FcRS6lB8pL9BQdVDmaaZLzlA53BLy0U
         Nc0g==
X-Gm-Message-State: APjAAAU+XjPM8tygxxGSxq+OzubXdBLd/0qH3Lon3pb0J9b+ggoblX0W
        go9/4UuakpDPnpvRiimJFJvNXw==
X-Google-Smtp-Source: APXvYqzYwIwrVP+ugsV9lnjTZ1X13KQJWE4RAevWJ3fdpc4RqNxOcKlK7GQcj2q6qww9NihVOeeHSg==
X-Received: by 2002:ac8:7342:: with SMTP id q2mr2693256qtp.134.1559864544792;
        Thu, 06 Jun 2019 16:42:24 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id e133sm213045qkb.76.2019.06.06.16.42.22
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 06 Jun 2019 16:42:24 -0700 (PDT)
Date:   Thu, 6 Jun 2019 16:42:19 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     "Bshara, Nafea" <nafea@amazon.com>
Cc:     David Woodhouse <dwmw2@infradead.org>,
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
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH V2 net 00/11] Extending the ena driver to support new
 features and enhance performance
Message-ID: <20190606164219.10dca54e@cakuba.netronome.com>
In-Reply-To: <35E875B8-FAE8-4C6A-BA30-FB3E2F7BA66B@amazon.com>
References: <20190603144329.16366-1-sameehj@amazon.com>
        <20190603143205.1d95818e@cakuba.netronome.com>
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
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 6 Jun 2019 23:21:25 +0000, Bshara, Nafea wrote:
> > On Jun 6, 2019, at 4:08 PM, Jakub Kicinski <jakub.kicinski@netronome.co=
m> wrote:
> > On Thu, 6 Jun 2019 22:57:21 +0000, Bshara, Nafea wrote: =20
> >>> Having said that, it's entirely unclear to me what the user scenario =
is
> >>> here.  You say "which two devices related", yet you only have one bit,
> >>> so it can indicate that there is another device, not _which_ device is
> >>> related.  Information you can full well get from running lspci =F0=9F=
=A4=B7
> >>> Do the devices have the same PCI ID/vendor:model?   =20
> >>=20
> >> Different model id =20
> >=20
> > Okay, then you know which one is which.  Are there multiple ENAs but
> > one EFA?
>=20
> Yes,  very possible. Very common
>=20
> Typical use case that instances have one ena for control plane, one
> for internet facing , and one 100G ena that also have efa capabilities

I see, and those are PCI devices..  Some form of platform data would
seem like the best fit to me.  There is something called:

/sys/bus/pci/${dbdf}/label

It seems to come from some ACPI table - DSM maybe?  I think you can put
whatever string you want there =F0=9F=A4=94

> >> Will look into sysfs  =20
> >=20
> > I still don't understand what is the problem you're trying to solve,
> > perhaps phys_port_id is the way to go...
> >=20
> >=20
> > The larger point here is that we can't guide you to the right API
> > unless we know what you're trying to achieve.  And we don't have=20
> > the slightest clue of what're trying to achieve if uAPI is forwarded=20
> > to the device. =20
> >=20
> > Honestly this is worse, and way more basic than I thought, I think
> > 315c28d2b714 ("net: ena: ethtool: add extra properties retrieval via ge=
t_priv_flags")
> > needs to be reverted. =20
>=20
> Let=E2=80=99s not do that until we finish this discussion and explain the=
 various use cases

Whatever we decide is the right API for tagging interfaces in a virtual
environment, it's definitely not going to be private feature flags.
