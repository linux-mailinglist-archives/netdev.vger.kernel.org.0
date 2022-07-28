Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92C3E583903
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 08:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234314AbiG1GwS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 02:52:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234263AbiG1GwQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 02:52:16 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8C4B558EA
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 23:52:15 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id s204so1467218oif.5
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 23:52:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=GVYKTeZOs73kMVOGScvV1WQYPWwqW1DUKJOIJsaQhHs=;
        b=siEYlYcRE/DOMiSGZuRXKfgmHEV2pjykwMIZlOkXroO5b9WzXOaRAxHMIiJygjQqE8
         R5plCuxLTaJ1gCTQSsHaIvU46lcB8i4dAqAD4SqiaGER94W+M6f7yo1ekmlDrFzpqckd
         KfW5EQ32E58zt/RYXeRs2sL30qso+Jq8MYM5LSZwV+mZl+12QDBGl+BIhMxCiN9DzDxj
         Z5v2+45yBXjQn/vzABUFS+oCjgMOMT8ntN6K3KReILhbqsG/XVAT82E+YFg2SV1AxFKs
         ASoJfBKxW/n58C7M995Lgmy3Pk+4qy9qdlYmmOKMa/w09ACxXJMzTn3hgBcAnQcIXWpL
         88XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=GVYKTeZOs73kMVOGScvV1WQYPWwqW1DUKJOIJsaQhHs=;
        b=IhpRnY1hx/eIAoVrIvkPyx0zpV0w9VVpxME2V0+wUmoMzSzjDWn18m6gbT9dBe+bVn
         +KXwGo7ZY9xLEPp84QQsD9GEfmYwS25I94X7nLrrG6M2oWem8xlNJDEpM2afx+ndg+MF
         YbwgxXYtquTCPdPmM7InTYM8HFJdlbsgyx2fcoYKk41m9nduejBfMaad8vmFkmN0xI3i
         BWS4qfJyQxWt7qhm4lNhIG2Ib1IbTmjp9IMmhHZnO8wIiqU9C2qIKWOKu6YmUrcETDN4
         AgmwCO2VkOqgOWR169mynj3vRoxMpyQTWyyUqpDne3S40PgwU3se13Egye2lHBIdSrN3
         XgVg==
X-Gm-Message-State: AJIora8CUZNWn1L/epeTqiT/S3P79JTQ+3RlB7PDvsuAtIGE6PmacCTZ
        +5WF4DULkAlSGppry8awnABoSaSRttJe3ECL9ho0Vw==
X-Google-Smtp-Source: AGRyM1uuittOHwZWvzVERGk6XZ6tXmAB65uDcVv1Ac8dxuQqLXyVHYcRLUcRxtaHouYNxv8BbEMUtKBrw+i92ckH4ec=
X-Received: by 2002:a05:6808:4d7:b0:33a:9437:32d with SMTP id
 a23-20020a05680804d700b0033a9437032dmr3356302oie.97.1658991134942; Wed, 27
 Jul 2022 23:52:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220727064321.2953971-1-mw@semihalf.com> <20220727064321.2953971-7-mw@semihalf.com>
 <20220727143147.u6yd6wqslilspyhw@skbuf> <CAPv3WKc88KQN=athEqBg=Z5Bd1SC3QSOPZpDH7dfuYGHhR+oVg@mail.gmail.com>
 <20220727163848.f4e2b263zz3vl2hc@skbuf> <CAPv3WKe+e6sFd6+7eoZbA2iRTPhBorD+mk6W+kJr-f9P8SFh+w@mail.gmail.com>
 <CAHp75VfGfKx1fggoE7wf4ndmUv4FEVfV=-EaO0ypescmNqDFkw@mail.gmail.com>
In-Reply-To: <CAHp75VfGfKx1fggoE7wf4ndmUv4FEVfV=-EaO0ypescmNqDFkw@mail.gmail.com>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Thu, 28 Jul 2022 08:52:04 +0200
Message-ID: <CAPv3WKeXtwJRPSaERzo+so+_ZAPSNk5RjxzE+N7u-uNUTMaeKA@mail.gmail.com>
Subject: Re: [net-next: PATCH v3 6/8] net: core: switch to fwnode_find_net_device_by_node()
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Grzegorz Bernacki <gjb@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Samer El-Haj-Mahmoud <Samer.El-Haj-Mahmoud@arm.com>,
        "upstream@semihalf.com" <upstream@semihalf.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=C5=9Br., 27 lip 2022 o 23:15 Andy Shevchenko <andy.shevchenko@gmail.com> n=
apisa=C5=82(a):
>
>
>
> On Wednesday, July 27, 2022, Marcin Wojtas <mw@semihalf.com> wrote:
>>
>> =C5=9Br., 27 lip 2022 o 18:38 Vladimir Oltean <olteanv@gmail.com> napisa=
=C5=82(a):
>> >
>> > On Wed, Jul 27, 2022 at 05:18:16PM +0200, Marcin Wojtas wrote:
>> > > Do you mean a situation analogous to what I addressed in:
>> > > [net-next: PATCH v3 4/8] net: mvpp2: initialize port fwnode pointer
>> > > ?
>> >
>> > Not sure if "analogous" is the right word. My estimation is that the
>> > overwhelmingly vast majority of DSA masters can be found by DSA simply
>> > due to the SET_NETDEV_DEV() call that the Ethernet drivers need to mak=
e
>> > anyway.  I see that mvpp2 also needed commit c4053ef32208 ("net: mvpp2=
:
>> > initialize port of_node pointer"), but that isn't needed in general, a=
nd
>> > I can't tell you exactly why it is needed there, I don't know enough
>> > about the mvpp2 driver.
>>
>> SET_NETDEV_DEV() fills net_device->dev.parent with &pdev->dev
>> and in most cases it is sufficient apparently it is sufficient for
>> fwnode_find_parent_dev_match (at least tests with mvneta case proves
>> it's fine).
>>
>> We have some corner cases though:
>> * mvpp2 -> single controller can handle up to 3 net_devices and
>> therefore we need device_set_node() to make this work. I think dpaa2
>> is a similar case
>> * PCIE drivers with extra DT description (I think that's the case of ene=
tc).
>>
>> >
>> > > I found indeed a couple of drivers that may require a similar change
>> > > (e.g. dpaa2).
>> >
>> > There I can tell you why the dpaa2-mac code mangles with net_dev->dev.=
of_node,
>> > but I'd rather not go into an explanation that essentially doesn't mat=
ter.
>> > The point is that you'd be mistaken to think that only the drivers whi=
ch
>> > touch the net device's ->dev->of_node are the ones that need updating
>> > for your series to not cause regressions.
>>
>> As above - SET_NETDEV_DEV() should be fine in most cases, but we can
>> never be 100% sure untils it's verified.
>>
>> >
>> > > IMO we have 2 options:
>> > > - update these drivers
>> > > - add some kind of fallback? If yes, I am wondering about an elegant
>> > > solution - maybe add an extra check inside
>> > > fwnode_find_parent_dev_match?
>> > >
>> > > What would you suggest?
>> >
>> > Fixing fwnode_find_parent_dev_match(), of course.
>
>
>
> Fixing how?!
>
>
>>
>>
>> This change broke DSA
>> > on my LS1028A system (master in drivers/net/ethernet/freescale/enetc/)
>> > and LS1021A (master in drivers/net/ethernet/freescale/gianfar.c).
>>
>> Can you please check applying following diff:
>>
>> --- a/drivers/base/property.c
>> +++ b/drivers/base/property.c
>> @@ -695,20 +695,22 @@ EXPORT_SYMBOL_GPL(fwnode_get_nth_parent);
>>   * The routine can be used e.g. as a callback for class_find_device().
>>   *
>>   * Returns: %1 - match is found
>>   *          %0 - match not found
>>   */
>>  int fwnode_find_parent_dev_match(struct device *dev, const void *data)
>>  {
>>         for (; dev; dev =3D dev->parent) {
>>                 if (device_match_fwnode(dev, data))
>>                         return 1;
>> +               else if (device_match_of_node(dev, to_of_node(data))
>> +                       return 1;
>>         }
>>
>
> This adds a piece of dead code. device_match_fwnode() covers this already=
.
>

Yes, indeed. After recent update, I think we can assume the current
implementation of fwnode_find_parent_dev_match should work fine with
all existing cases.

Thank you for all remarks and comments, I'll address them in v4 later today=
.

Best regards,
Marcin
