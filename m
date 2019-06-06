Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A4C238191
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 01:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727198AbfFFXID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 19:08:03 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:45988 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726623AbfFFXID (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 19:08:03 -0400
Received: by mail-qt1-f196.google.com with SMTP id j19so181291qtr.12
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 16:08:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=GoVYGT6ex09flLfRVNADZVlN5HF4okwXCmUVwtfG7sE=;
        b=WOOTKMvtmw88PePTcV+3Uggo+aM5wCjn+LLrWce4Aq9vdiHU/FANjSVKGbEIC7mhfv
         3nmzgEfvmGyqr9CnOpOoZzkCaNu8fCbDWUtDC1KU9Vak9SHtWpfCrndjklcwDsWpsL69
         HsJD5Lm6kEIJvTbs9GNVYUKNWM0sOmjrlykp/SPAAR5eULXM0Wj0qTdC/Rs2WvHnwLpV
         crvPOGjeYCzl0OS9iLzo05ZasAZNaqRVc3mrt1HbfPuZPcVCwGpWG+Wlh9zHuCHRJDCb
         7XTJ1xOx8qbRsTLhT/UYiLoJ77eUSdXFIBhPDhc8DMNL3tPmhf2kuvd4+hj9/4u7rHJ1
         yGgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=GoVYGT6ex09flLfRVNADZVlN5HF4okwXCmUVwtfG7sE=;
        b=M1x3spvGcdHuatCAh4Uhoy0jeW68lN64ge6sXRAVSAaXcgsFCbW7U0NX4wX1dGQ0DJ
         orMjD0alCt5PruGrcmOIGqfjgziP8fxymd6b17aZ+e/rd8wPEKRbTK81dyEg8oDLfepk
         cMfmNrC0FEGsAYPn8kLVtfSMRk7Mzz8JVXCRouBcHIBIlpXzoVDT97d1jTEnMKr3YzfK
         Vl1vgPQ39KFktuqIiu7tRMuyk/5gabof9ZZi7CrWto9YzcsVt23CY3vATFmf/D1tnWoK
         +RlZycfmt76eNkbkAsodFPXbpvBs8bdpI02KlVToFw3WvZ7c3JmzkWHT/19ZyCWiPNYz
         MsLQ==
X-Gm-Message-State: APjAAAXhAdHmGtBaAAyXUtBQnufyTVaX7PmfUgukOROiJYtwFjWN/D21
        hY1hnwtePHQv3nlrflpA9Yh+/g==
X-Google-Smtp-Source: APXvYqwi+iWknPlty5xBSL1aJJRF4zUjpn30IAp0fZjUUTXqpRvl/KcO8Wy58hJIst0T6ouOVENMIw==
X-Received: by 2002:ac8:70cf:: with SMTP id g15mr40520088qtp.254.1559862482535;
        Thu, 06 Jun 2019 16:08:02 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id j37sm235281qtb.76.2019.06.06.16.08.00
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 06 Jun 2019 16:08:02 -0700 (PDT)
Date:   Thu, 6 Jun 2019 16:07:56 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     "Bshara, Nafea" <nafea@amazon.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Cc:     "Jubran, Samih" <sameehj@amazon.com>, Andrew Lunn <andrew@lunn.ch>,
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
Message-ID: <20190606160756.73fe4c06@cakuba.netronome.com>
In-Reply-To: <861B5CF2-878E-4610-8671-9D66AB61ABD7@amazon.com>
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
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 6 Jun 2019 22:57:21 +0000, Bshara, Nafea wrote:
> > Having said that, it's entirely unclear to me what the user scenario is
> > here.  You say "which two devices related", yet you only have one bit,
> > so it can indicate that there is another device, not _which_ device is
> > related.  Information you can full well get from running lspci =F0=9F=
=A4=B7
> > Do the devices have the same PCI ID/vendor:model? =20
>=20
> Different model id

Okay, then you know which one is which.  Are there multiple ENAs but
one EFA?

> Will look into sysfs=20

I still don't understand what is the problem you're trying to solve,
perhaps phys_port_id is the way to go...


The larger point here is that we can't guide you to the right API
unless we know what you're trying to achieve.  And we don't have=20
the slightest clue of what're trying to achieve if uAPI is forwarded=20
to the device. =20

Honestly this is worse, and way more basic than I thought, I think
315c28d2b714 ("net: ena: ethtool: add extra properties retrieval via get_pr=
iv_flags")
needs to be reverted.
