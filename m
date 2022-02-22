Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0557C4BF49E
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 10:25:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbiBVJZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 04:25:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiBVJZQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 04:25:16 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AD9213D92A;
        Tue, 22 Feb 2022 01:24:51 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id s24so28926415edr.5;
        Tue, 22 Feb 2022 01:24:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tG0N4GsMvluqwN7hLyreWf4WVYklGtFdMXvbW9AWJag=;
        b=dnud/zCQnhD0sZZU8bovA0ObMhMoe/FKEx2PhqHT7SHUuASH4fmXhamRY6HgJg6oJU
         plhWj8BBtGfmNntw5P1s6WuMtXlTBcrGiGTw7ilx0E//iTUkKW8r5Zf/ShYtamV/HKAY
         kzjCNt6ldGOThL6gNEdjCS11gdu9cVawSk1QU1k/9m+1bUcOEdzEykQQnm/JmwupRNiX
         zsYSRg+sQRrtYaOCHdK9rwT3NsDTHTEapOAB1SZWxmrHCXUFHgOeyr17Le62PuU5Vy6R
         RUFton38ZQ0PctxliCZTRF6YDXStuAOg+uaDQsAF2Fl4O/Z13oMTl4uJ7kfvUcNiNFnt
         ZFVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tG0N4GsMvluqwN7hLyreWf4WVYklGtFdMXvbW9AWJag=;
        b=5pDRtp41/M5SDtRZW4gcgdcSVKw9oEcDBAfH8kk3uhWa+DvJoY9P2RYR2UQ8F0Equd
         j7hnRFggk1iqAXFi2IW96088yPEfm7lOoYPNOL+UQBlLGp59IQzav69tALN25zE9iEKq
         AtIHiZdze4raQYKc4QteOhZzceyiydy2vVLUXDClt8Syif0hKtTDqmjBVgIDTXxg47PZ
         4UuYbmbTrA3oJOZCgMEdwp57CXfWLfmfAPt+MK6mFDKwAEhkjRTCW4HK/zGWWWJ9weDS
         OcYqJxWhzooVvVlTqTjvZ2Q7AdTerZW/F+bo6rFI0SCRkbDrF2OOYPSt+w1vADjvMY9X
         OScg==
X-Gm-Message-State: AOAM531VeAA9IGNBZqX+iPK4SgZUVTNqjKvG9DhJbDiy+TwjoG2o2Eyn
        YpO0+cr2BxvM3gMeQ4SKMCGAMMBu+hB/VfggZ0c=
X-Google-Smtp-Source: ABdhPJyI3GDjnoSQo+fN01UE7v65Zug0IXRCllwGih/MFgPgyibztVZL42KonHclXFqjafIjGF70IhRGsukb/bM10fk=
X-Received: by 2002:a05:6402:d08:b0:412:a33e:24fe with SMTP id
 eb8-20020a0564020d0800b00412a33e24femr25921136edb.281.1645521889689; Tue, 22
 Feb 2022 01:24:49 -0800 (PST)
MIME-Version: 1.0
References: <20220221162652.103834-1-clement.leger@bootlin.com>
 <20220221162652.103834-3-clement.leger@bootlin.com> <YhPP5GWt7XEv5xx8@smile.fi.intel.com>
 <20220222091902.198ce809@fixe.home> <CAHp75VdwfhGKOiGhJ1JsiG+R2ZdHa3N4hz6tyy5BmyFLripV5A@mail.gmail.com>
 <20220222094623.1f7166c3@fixe.home>
In-Reply-To: <20220222094623.1f7166c3@fixe.home>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 22 Feb 2022 10:24:13 +0100
Message-ID: <CAHp75VfduXwRvxkNg=At5jaN-tcP3=utiukEDL35PEv_grK4Pw@mail.gmail.com>
Subject: Re: [RFC 02/10] property: add fwnode_get_match_data()
To:     =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Wolfram Sang <wsa@kernel.org>, Peter Rosin <peda@axentia.se>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-i2c <linux-i2c@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 22, 2022 at 9:47 AM Cl=C3=A9ment L=C3=A9ger <clement.leger@boot=
lin.com> wrote:
> Le Tue, 22 Feb 2022 09:33:32 +0100,
> Andy Shevchenko <andy.shevchenko@gmail.com> a =C3=A9crit :
> > On Tue, Feb 22, 2022 at 9:24 AM Cl=C3=A9ment L=C3=A9ger <clement.leger@=
bootlin.com> wrote:
> > > Le Mon, 21 Feb 2022 19:46:12 +0200,
> > > Andy Shevchenko <andriy.shevchenko@linux.intel.com> a =C3=A9crit :

...

> > > The idea is to allow device with a software_node description to match
> > > with the content of the of_match_table. Without this, we would need a
> > > new type of match table that would probably duplicates part of the
> > > of_match_table to be able to match software_node against a driver.
> > > I did not found an other way to do it without modifying drivers
> > > individually to support software_nodes.
> >
> > software nodes should not be used as a replacement of the real
> > firmware nodes. The idea behind is to fill the gaps in the cases when
> > firmware doesn't provide enough information to the OS. I think Heikki
> > can confirm or correct me.
>
> Yes, the documentation states that:
>
> NOTE! The primary hardware description should always come from either
> ACPI tables or DT. Describing an entire system with software nodes,
> though possible, is not acceptable! The software nodes should only
> complement the primary hardware description.
>
> > If you want to use the device on an ACPI based platform, you need to
> > describe it in ACPI as much as possible. The rest we may discuss.
>
> Agreed but the PCIe card might also be plugged in a system using a
> device-tree description (ARM for instance). I should I do that without
> duplicating the description both in DT and ACPI ?

Why is it (duplication) a problem?
Each platform has its own kind of description, so one needs to provide
it in the format the platform accepts.

--=20
With Best Regards,
Andy Shevchenko
