Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D75DA3825F
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 03:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbfFGBOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 21:14:23 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:42384 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725784AbfFGBOW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 21:14:22 -0400
Received: by mail-qt1-f196.google.com with SMTP id s15so463708qtk.9
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 18:14:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=KNz4e5bUMg+XnLTwRtGD9uEaFBb0H1HAmLR3U4ktyjY=;
        b=jHst8Gbg7XXc9t2sagT513SmkmUOAcuPQ6zh/HKWT/ODwLcdNyMbrWFy9BKm8kS2MJ
         hlBslJTpBQGWz2D3hNZ51hsI1IdJVzUOVJVvX8uFMI4ZRANiFO6LmvU67baomZRw8Qhh
         YiT0F2K2L2lc3harVajeNlDDc/WuxwQM79Y9d2sVLfnAlbD59kQaXYRMDHIFAs12yz9w
         MwgyQNbAtpDE0/JO0ov5Pn8r17nlVdFQHuGT35ad4PNi9TSHLKXgkHO4blUdQCiSylS6
         TcXAL7Uw/inmCb5CytFpPzLFnzK8/cTUgEbCEJmYxoiUYmH02KEJpK3CbYRZqcb86Xdt
         3Ebw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=KNz4e5bUMg+XnLTwRtGD9uEaFBb0H1HAmLR3U4ktyjY=;
        b=XhOOgx1iZ1CHuoUCtEMMeW2jFHhcxE8tWli/LObz3TTObZlY5B7U+Cmrjiovce7RuG
         MqMqOhJuO/ym8L2JUgIzp1AQZM9Mf1NV5cZE56oNxzraqkyL0IKrQRJsBqWjJwmcm9OA
         /E00mLOlpaE1oNzA0nxiH9JcrK8WJ93AoS9YQSjBMbZGrx07FrK6fhuIgGG0BXS7rsNQ
         gS7ND+tmuktzdQBXPz3N1Xoa2QU64lttScOZp7vk6k9x2QofauP3yYZpI5/HiqjXbYwl
         0sVcpdSdHBf7h9ODoi9pft3mczrTojkHxdMcIxr2OvSg4E0hPyJANKjX1SsQRfXwGqZW
         IMKQ==
X-Gm-Message-State: APjAAAXRt28Su3Anrw2aq1c1aqmpbpDG4lPsmGNg+JNVz4XNeCKg7k0t
        T2ymb3znu2BKY4Ld03cXavn/+w==
X-Google-Smtp-Source: APXvYqzhpuEMuiCKkULr/9WifnOh25Pdc1ffgWBW+MYzHcdj1IKpPFGftfnjgxGv3jnUttacRf3Glg==
X-Received: by 2002:ac8:2c33:: with SMTP id d48mr44555624qta.40.1559870061747;
        Thu, 06 Jun 2019 18:14:21 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id z12sm269310qkf.20.2019.06.06.18.14.19
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 06 Jun 2019 18:14:21 -0700 (PDT)
Date:   Thu, 6 Jun 2019 18:14:16 -0700
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
Message-ID: <20190606181416.5ce1400d@cakuba.netronome.com>
In-Reply-To: <9057E288-28BA-4865-B41A-5847EE41D66F@amazon.com>
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
        <20190606164219.10dca54e@cakuba.netronome.com>
        <9057E288-28BA-4865-B41A-5847EE41D66F@amazon.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 7 Jun 2019 01:04:14 +0000, Bshara, Nafea wrote:
> On Jun 6, 2019, at 4:43 PM, Jakub Kicinski wrote:
> >>> Okay, then you know which one is which.  Are there multiple ENAs but
> >>> one EFA?
> >>=20
> >> Yes,  very possible. Very common
> >>=20
> >> Typical use case that instances have one ena for control plane, one
> >> for internet facing , and one 100G ena that also have efa capabilities
> >=20
> > I see, and those are PCI devices..  Some form of platform data would
> > seem like the best fit to me.  There is something called:
> >=20
> > /sys/bus/pci/${dbdf}/label
> >=20
> > It seems to come from some ACPI table - DSM maybe?  I think you can put
> > whatever string you want there =F0=9F=A4=94 =20
>=20
> Acpi path won=E2=80=99t work, much of thee interface are hot attached, us=
ing
> native pcie hot plug and acpi won=E2=80=99t be involved.=20

Perhaps hotplug break DSM, I won't pretend to be an ACPI expert.  So you
can find a way to stuff the label into that file from another source.
There's also VPD, or custom PCI caps, but platform data generally seems
like a better idea.
