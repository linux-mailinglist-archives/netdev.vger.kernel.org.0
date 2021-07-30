Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 302053DC0F6
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 00:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235130AbhG3WTx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 18:19:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234366AbhG3WT1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 18:19:27 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C0C3C0613C1
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 15:19:22 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id mt6so17253958pjb.1
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 15:19:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=workware-net-au.20150623.gappssmtp.com; s=20150623;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=O24PNtKrKZ/R4LgVLMiIP6EoNyXsgw3ajELkWTG8RLo=;
        b=FZYQhFlDOs9Aq3bosQwrMNnX9gb4N5kUKVVl+0TWoiZ5E51sJZ46FwYyQwqp/ssPQI
         Dp39QLzC7K3xuoEsgd5hXAgimfYP7Ez9YaqCUhrRT42+hlKK/UfFBg2Zo518XMuVxJg8
         Ge604OBVtfnFAQEuNUGhALeksQotBzQ8tjIHUFxrTqN/0r01fRtbYztl+3kMRXSLQlvH
         A+ZzO0Qm53ABkqZ6nF53EuHtLoexENzcKPOn0Cfqh5fwwclL8T9C2A06EVxoL9zbKFu9
         g/+kd/29vrcrJP5JFZEzengql9pDFC5OzltBzJ8qCNuKsvE439nmqPonQGp6tVb4bQ7O
         ZzAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=O24PNtKrKZ/R4LgVLMiIP6EoNyXsgw3ajELkWTG8RLo=;
        b=Y0W/CfEI0niS0MVIzD4hJgcf4VhjP4mWrMLHYsk3+76ygb7gnLv3CVW+CBgnJ8cozH
         pTPNWrmJtmW+t8Cs3EiNN6mpU4+vi9eTph0EGDSKkCMjTbwCQflT4wEEyP38B+w5GcsB
         /CQvRBObqCO3cuGNuENTaGt+v8PeHRAJuBKocZXlO+U1RaUjSz+63Aa1S+Tz+SNmXBPY
         pm57p5TuDWf/RGaZLfEtW4tlZsFsMLjkO9cg8FrB9n/ZgmtAvKJzIt7uQvNwg92keoRw
         T5C3HhGb4PgQ77/FxcpQCe+qfE0XEPT1DU+2ekRm2RKpMNCCvUKTgekOo/EBERTyTYg3
         hfHA==
X-Gm-Message-State: AOAM532ttvsljf0CE9zHkISOMyoIBtbuJiGGmJmSFuUiyOQFK0dtBJtg
        vy6XO+peLvobpKq942rD0qkw/Q==
X-Google-Smtp-Source: ABdhPJyh4rFQzG8+Mb9p1u5b4EcqoZFKns1hLpbNhv2Pm3CdlC55gIOWgCMcLHWiCcTWWM8+0OwnUw==
X-Received: by 2002:a63:5fd4:: with SMTP id t203mr1278866pgb.141.1627683561826;
        Fri, 30 Jul 2021 15:19:21 -0700 (PDT)
Received: from smtpclient.apple (117-20-69-228.751445.bne.nbn.aussiebb.net. [117.20.69.228])
        by smtp.gmail.com with ESMTPSA id n15sm3538687pff.149.2021.07.30.15.19.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Jul 2021 15:19:21 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.100.0.2.22\))
Subject: Re: [PATCH] net: phy: micrel: Fix detection of ksz87xx switch
From:   Steve Bennett <steveb@workware.net.au>
In-Reply-To: <20210730095936.1420b930@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Sat, 31 Jul 2021 08:19:17 +1000
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Workware-Check: steveb@workware.net.au
Content-Transfer-Encoding: quoted-printable
Message-Id: <74BE3A85-61E2-45C9-BA77-242B1014A820@workware.net.au>
References: <20210730105120.93743-1-steveb@workware.net.au>
 <20210730095936.1420b930@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
To:     Jakub Kicinski <kuba@kernel.org>
X-Mailer: Apple Mail (2.3654.100.0.2.22)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On 31 Jul 2021, at 2:59 am, Jakub Kicinski <kuba@kernel.org> wrote:
>=20
> Please extend the CC list to the maintainers, and people who
> worked on this driver in the past, especially Marek.

Sure, I can do that in a v2 of the patch along with the more detailed
explanation below.

>=20
> On Fri, 30 Jul 2021 20:51:20 +1000 Steve Bennett wrote:
>> The previous logic was wrong such that the ksz87xx
>> switch was not identified correctly.
>=20
> Any more details of what is happening? Which extact device do you see
> this problem on?

I have a ksz8795 switch.

Without the patch:

ksz8795-switch spi3.1 ade1 (uninitialized): PHY [dsa-0.1:03] driver =
[Generic PHY]
ksz8795-switch spi3.1 ade2 (uninitialized): PHY [dsa-0.1:04] driver =
[Generic PHY]

With the patch:

ksz8795-switch spi3.1 ade1 (uninitialized): PHY [dsa-0.1:03] driver =
[Micrel KSZ87XX Switch]
ksz8795-switch spi3.1 ade2 (uninitialized): PHY [dsa-0.1:04] driver =
[Micrel KSZ87XX Switch]

>=20
> I presume ksz87xx devices used to work and gotten broken - would you
> mind clarifying and adding a Fixes tag to help backporting to the
> correct stable branches?

I looked at the original commit =
8b95599c55ed24b36cf44a4720067cfe67edbcb4, but
it couldn't ever have worked.

ksz8051_ksz8795_match_phy_device() uses the parameter ksz_phy_id to =
discriminate
whether it was called from ksz8051_match_phy_device() or from =
ksz8795_match_phy_device()
but since PHY_ID_KSZ87XX is the same value as PHY_ID_KSZ8051, this =
doesn't do anything.

Need to pass a different value to discriminate.

>=20
>> diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
>> index 4d53886f7d51..a4acec02c8cb 100644
>> --- a/drivers/net/phy/micrel.c
>> +++ b/drivers/net/phy/micrel.c
>> @@ -401,11 +401,11 @@ static int ksz8041_config_aneg(struct =
phy_device *phydev)
>> }
>>=20
>> static int ksz8051_ksz8795_match_phy_device(struct phy_device =
*phydev,
>> -					    const u32 ksz_phy_id)
>> +					    const u32 ksz_8051)
>=20
> bool and use true/false in the callers?

Sure.
