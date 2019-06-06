Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7AB38038
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 00:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728886AbfFFWEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 18:04:35 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:34449 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726554AbfFFWEf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 18:04:35 -0400
Received: by mail-qk1-f194.google.com with SMTP id t64so88690qkh.1
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 15:04:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=f5jeyWN3ZCOULXKA4PbUE9R3DF/qDqKhSbObw9RcDRA=;
        b=XEgBmL88IB2z5zcRUHN5uhWV4/IKiYyo95mpoA8SErtjFtztWY5ZeGf2oWBFAi9t4s
         KIrLEHR8t/AqbHtmQIl/e+STxt8Wn74OCh5PyBPcecw1lCtX+hMjcSbYYLVLImoHOBVU
         7NnxLJkRNe+whqs49YYuxDdjq+iL/3EPc7wsZDJqtNU7GJWI596mnogwD+0+70rLE7W3
         xSObz6YPJzUZ0rx1NVg6io4lnX3OPIIzn/9uz5cktMw44P6rqHgycvgdZ+4uSphoVJmv
         DmY0ttqXP5ueIeFnTwy1UeXO1Wg3O+wXN/I657CK/oYa+HRg0U2wW2OdobYArvhGfHH/
         RDGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=f5jeyWN3ZCOULXKA4PbUE9R3DF/qDqKhSbObw9RcDRA=;
        b=uSe4O3STNGoVbsK1cPmt+yeBZAUDvfhvzN6VHZsRAEV2FS8u9TdvmLtbFmUx5VXG9S
         Hlh+bIaQDnoTxeoO/ZGy70TD6f1R/SloZ8g2xT97AgkOm8zrfCnGqQa74xEN3xJ3tF/A
         rU196P/T7dJI5dLJVhTyx4z1zmeCJaz5FW5fOvMlRTGsom8xciUMda3LveF9WZ8I/Tpo
         sdKdGDHnJVq7bWiVAK62O13EiZX7BLzWgQJ7l+8JewtFb0AJowFv91Jx9RNGKubPAaCy
         +HL4XN2UM4NzdDDss3QB7iUX5p7aiytrFYa4FVBkQgsNg7QZS0L1DNMudt0XbPDl6qi1
         m13Q==
X-Gm-Message-State: APjAAAVLhlGGfJ0mf8EJ93+4ct9yF29pEzVFkumEXrH3zo6s5JtQxRii
        gLQzhIj/LT8q5T2iIHuXBgxYzA==
X-Google-Smtp-Source: APXvYqw1VssmTDUHK0ZrnflqM2Bt0yUG/Gtg94WXfTaJhSx3Z/xbxFt33GX0znJ5AKBfbwMCb7vkVA==
X-Received: by 2002:a37:9d04:: with SMTP id g4mr40194729qke.52.1559858673760;
        Thu, 06 Jun 2019 15:04:33 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id 34sm164780qtq.59.2019.06.06.15.04.31
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 06 Jun 2019 15:04:33 -0700 (PDT)
Date:   Thu, 6 Jun 2019 15:04:28 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     "Bshara, Nafea" <nafea@amazon.com>
Cc:     "Jubran, Samih" <sameehj@amazon.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Andrew Lunn <andrew@lunn.ch>,
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
Message-ID: <20190606150428.2e55eb08@cakuba.netronome.com>
In-Reply-To: <D9B372D5-1B71-4387-AA8D-E38B22B44D8D@amazon.com>
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
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 6 Jun 2019 21:40:19 +0000, Bshara, Nafea wrote:
> =EF=BB=BFOn 6/6/19, 10:16 AM, "Jakub Kicinski" <jakub.kicinski@netronome.=
com> wrote:
>=20
>     Hi Samih!
>    =20
>     Please don't top post on Linux kernel mailing lists.
>    =20
>     On Thu, 6 Jun 2019 10:23:40 +0000, Jubran, Samih wrote:
>     > As of today there are no flags exposed by ENA NIC device, however, =
we
>     > are planning to use them in the near future. We want to provide
>     > customers with extra methods to identify (and differentiate) multip=
le
>     > network interfaces that can be attached to a single VM. Currently,
>     > customers can identify a specific network interface (ENI) only by M=
AC
>     > address, and later look up this MAC among other multiple ENIs that
>     > they have. In some cases it might not be convenient. Using these
>     > flags will let us inform the customer about ENI`s specific
>     > properties. =20
>    =20
>     Oh no :(  You're using private _feature_ flags as labels or tags.
>    =20
>     > It's not finalized, but tentatively it can look like this:=20
>     > primary-eni: on /* Differentiate between primary and secondary ENIs=
 */ =20
>    =20
>     Did you consider using phys_port_name for this use case?
>    =20
>     If the intent is to have those interfaces bonded, even better would
>     be to extend the net_failover module or work on user space ABI for VM
>     failover.  That might be a bigger effort, though.

Someone else will address this point?

>     > has-associated-efa: on /* Will specify ENA device has another assoc=
iated EFA device */ =20
>    =20
>     IDK how your ENA/EFA thing works, but sounds like something that shou=
ld
>     be solved in the device model.
>=20
> [NB] ENA is a netDev,  EFA is an ib_dev.   Both share the same physical n=
etwork
> All previous attempt to make them share at device level leads to a
> lot of complexity at the OS level, with inter-dependencies that are
> pronged to error Not to mention that OS distribution that backport
> from mainline would backport different subset of each driver,  let
> alone they belong to two subtrees with two different maintainers and
> we don=E2=80=99t want to be in a place where we have to coordinate releas=
es
> between two subgroups
>
> As such, we selected a much safer path, that operational, development and=
 deployment of two different drivers (netdev vs ib_dev) much easier but exp=
osing the nic as two different Physical functions/devices
>=20
> Only cost we have is that we need this extra propriety to help user ident=
ify which two devices are related hence Samih's comments

I think you're arguing with a different point than the one I made :)
Do you think I said they should use the same PCI device?  I haven't.

IIUC you are exposing a "tag" through the feature API on the netdev to
indicate that there is another PCI device present on the system?

What I said is if there is a relation between PCI devices the best
level to expose this relation at is at the device model level.  IOW
have some form on "link" in sysfs, not in a random place on a netdev.

Having said that, it's entirely unclear to me what the user scenario is
here.  You say "which two devices related", yet you only have one bit,
so it can indicate that there is another device, not _which_ device is
related.  Information you can full well get from running lspci =F0=9F=A4=B7
Do the devices have the same PCI ID/vendor:model?
