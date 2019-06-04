Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F20F234EAD
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 19:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbfFDRYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 13:24:15 -0400
Received: from mail-vs1-f68.google.com ([209.85.217.68]:39461 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725932AbfFDRYO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 13:24:14 -0400
Received: by mail-vs1-f68.google.com with SMTP id n2so5615773vso.6
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 10:24:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=6vF6vWczRo15d9MqKsV2duT9QJCGYYTgyMWR73TsF80=;
        b=qXj2fEFbDpyNV4UDZETcc/GsGAv9STePtlJRWGY34hgl8S05eYp+oSfWqiXS1IF/Mo
         Dv/InP68lPrTjLcF2xN6sOixosfKr+9j4jkxpgyyuCX7hBtcQ220pj94ih9koLPERtKS
         KwERlT1l0IzuaJ81OafcayHIFTXbQmHSCz3oInyzCm9wnBecODrxAHGDcRJNa79xF6c9
         TxxVN0kHHt8Zd9aGtAwvfj9XxnAF9Ktlt13hUCgF1a0OU3XPelSOdLdv7M6W0rU5pWW4
         Z2mIqmY/7Wi/njBh2MtQrEbk8kh3CnGoTC+8OWAKWBrzz1z9+XS62zKSVUZWs91Y7KIc
         IzMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=6vF6vWczRo15d9MqKsV2duT9QJCGYYTgyMWR73TsF80=;
        b=T4hNKM1WzqMB1oNYKUzE7pDsrctAri4E5sLyfU/P+tR3AppIzaNVzcFr3JEHcOMDDR
         9OYs+NfhrGcaStkUSshlZe5JxHqfxyVExPsKzmcFPXEWptGghS023ATgXLVlVkzxzhHl
         zQ0K+jcO6D9+jK3etrlJcU912mPcKSl9qSe6cXkxCdFvauP6wlGCBqerHrV2SIhIPo/o
         +Mxh4Uo6AVh+pbNf6qXS5wG2dhwXx+CRJiaogaBv0uJ5xBmFbKVUDhupbsBVnVzK9Lbv
         N+jd0oNagX0IW3+b2kcXs0KoyuFa4EnWS+eL5lrmWS/n+0BGJJcHFf7P/32fBynOzJR3
         R3Yg==
X-Gm-Message-State: APjAAAUT5RBwSd3G+MSyv0xzDTH3hMEiYYvUkyUxvBwbKPpzrXpU4W16
        CyIDDqavf+7WYH67tVoPDSho+g==
X-Google-Smtp-Source: APXvYqzEM0c5GRunKAju7RXx11uoW+0HNABigQjs4vBGHoJ3IUXOEP0JmnE8cfQsDGnELwaN8skeQQ==
X-Received: by 2002:a67:688f:: with SMTP id d137mr7834366vsc.198.1559669053791;
        Tue, 04 Jun 2019 10:24:13 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id d79sm6461664vkd.23.2019.06.04.10.24.11
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 04 Jun 2019 10:24:13 -0700 (PDT)
Date:   Tue, 4 Jun 2019 10:24:06 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     "Bshara, Nafea" <nafea@amazon.com>, Andrew Lunn <andrew@lunn.ch>,
        "Jubran, Samih" <sameehj@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Wilson, Matt" <msw@amazon.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>
Subject: Re: [PATCH V2 net 00/11] Extending the ena driver to support new
 features and enhance performance
Message-ID: <20190604102406.1f426339@cakuba.netronome.com>
In-Reply-To: <af79f238465ebe069bc41924a2ae2efbcdbd6e38.camel@infradead.org>
References: <20190603144329.16366-1-sameehj@amazon.com>
        <20190603143205.1d95818e@cakuba.netronome.com>
        <9da931e72debc868efaac144082f40d379c50f3c.camel@amazon.co.uk>
        <20190603160351.085daa91@cakuba.netronome.com>
        <20190604015043.GG17267@lunn.ch>
        <D26B5448-1E74-44E8-83DA-FC93E5520325@amazon.com>
        <af79f238465ebe069bc41924a2ae2efbcdbd6e38.camel@infradead.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 04 Jun 2019 07:57:48 +0100, David Woodhouse wrote:
> On Tue, 2019-06-04 at 02:15 +0000, Bshara, Nafea wrote:
> > On Jun 3, 2019, at 6:52 PM, Andrew Lunn <andrew@lunn.ch> wrote:
> > > > Any "SmartNIC" vendor has temptation of uAPI-level hand off to the
> > > > firmware (including my employer), we all run pretty beefy processors
> > > > inside "the NIC" after all.  The device centric ethtool configurati=
on
> > > > can be implemented by just forwarding the uAPI structures as they a=
re
> > > > to the FW.  I'm sure Andrew and others who would like to see Linux
> > > > takes more control over PHYs etc. would not like this scenario, eit=
her. =20
> > >=20
> > > No, i would not. There are a few good examples of both firmware and
> > > open drivers being used to control the same PHY, on different
> > > boards. The PHY driver was developed by the community, and has more
> > > features than the firmware driver. And it keeps gaining features. The
> > > firmware i stuck, no updates. The community driver can be debugged,
> > > the firmware is a black box, no chance of the community fixing any
> > > bugs in it.
> > >=20
> > > And PHYs are commodity devices. I doubt there is any value add in the
> > > firmware for a PHY, any real IPR which makes the product better, magic
> > > sauce related to the PHY. So just save the cost of writing and
> > > maintaining firmware, export the MDIO bus, and let Linux control it.
> > > Concentrate the engineers on the interesting parts of the NIC, the
> > > Smart parts, where there can be real IPR.
> > >=20
> > > And i would say this is true for any NIC. Let Linux control the PHY.
> >=20
> > It may be true for old GbE PHYs where it=E2=80=99s a discrete chip from=
 the
> > likes of Marvell or broadcom
> >=20
> > But at 25/50/100G, the PHy is actually part of the nic. It=E2=80=99s a =
very
> > complex SERDES.  Cloud providers like us spend enormous amount of
> > time testing the PHY across process and voltage variations, all cable
> > types, length and manufacturing variations, and against all switches
> > we use.  Community drivers won=E2=80=99t be able to validate and tune a=
ll
> > this.
> >=20
> > Plus we would need exact same setting for Linux, including all
> > distributions even 10year old like RHEL6, for all Windows, ESX, DPDK,
> > FreeBSD,  and support millions of different customers with different
> > sets of Machine images.=20
> >=20
> > In this case, there is no practical choice by have the firmware to
> > manage the PHY =20
>=20
> I don't quite know why we're talking about PHYs in this context.
> ENA is basically a virtio NIC. It has no PHY.

I brought it up as an example, to illustrate that we'd rather see less
trust and control being blindly handed over to the firmware.

Would you mind answering what are the examples of very important flags
you need to expose to users with 10yo kernels?  Or any examples for that
matter..
