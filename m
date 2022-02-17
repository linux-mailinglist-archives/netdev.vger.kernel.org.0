Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A88074B9A2D
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 08:54:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236700AbiBQHxi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 02:53:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231381AbiBQHxi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 02:53:38 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2124.outbound.protection.outlook.com [40.107.20.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03BD6178386;
        Wed, 16 Feb 2022 23:53:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OnprSMfp2uJSPvcrEftPlfnNDkKu3qKJEM1DLeNn+FD71CGo5cRv/Ybf64OPdvD1iqPY0L7k816zQri61ftE8a9y9kWVdDloi6jLkG+/+bshnNntTOp4GXy6eNPzFgfPTQ3v8tfh/Jcf0s8JZ9hIf7pjui3IY1OVUT4qi47Y4DMuwkpjRIaWK5JDgOV5uYCrcNiPTBd3rIOFuEsj4x8QU1m9asp1hMaXAHw1RK7X/HQOa13NWd2IyhLrBVh0wws4/cvbrVvCwQ/mVYNhaVM1aspqgqW69mC784yzOm37Zmuqy2486Z6t3xHNtJn9j+SIY/IsBytJbHW35b3jVWBSUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=utDnPf9IUDGzB9IrLKj4oQ7ko2QgGqohipRM1mhtsqQ=;
 b=P44CFm7GEcahxSEEoghsZQh2EnYlPp11l30xPsYg8bmrrlpsKkWCVmwmaMSLS1rTbuK+J4mM1UXSVhoyC7v3gV+z/YsHE2OUlFj8ue1dt1mPAEbneLPAFgyFNhc6UCugiAUyEScVDhwRtre4RZb1xV21NaR0JHWwGyOYFStFzB4a7+VvzXc6UHQqGP5GM3spgkDrGpYyyhjK+RAIXaQ3bgTcI5umiGVrvKB95OHYDEbT6BoM/7e2OneDjfv3c7GQTZdJk4ZY4p9eT/v3ukxs7+KZ8Ia3CnqAaWcq5FRTWa5u3mgFOWNy4xEfEXtQ2cFGujBVY+YQLcE2VFHi89zKKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=utDnPf9IUDGzB9IrLKj4oQ7ko2QgGqohipRM1mhtsqQ=;
 b=DNBfBcI0EMVykmLX+blwZ1sR2Ll24Jv25n3cgpvObub8aQmsTeLfWUOIsQRnyxf1r6cWeoYvrR7MAyPsX9QXoQre2ynN4sem6SMEtJ83Pgl7dcvq0RntmQBMq62y+73szGmG5P/vghWMSSROOBzPzwUOjqGbPh26DBGH9QFcJnY=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by AM5PR03MB2882.eurprd03.prod.outlook.com (2603:10a6:206:18::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.17; Thu, 17 Feb
 2022 07:53:21 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::6123:22f6:a2a7:5c1e]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::6123:22f6:a2a7:5c1e%5]) with mapi id 15.20.4995.016; Thu, 17 Feb 2022
 07:53:21 +0000
From:   =?windows-1254?Q?Alvin_=8Aipraga?= <ALSI@bang-olufsen.dk>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
CC:     =?windows-1254?Q?Alvin_=8Aipraga?= <alvin@pqrs.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Rasmussen <MIR@bang-olufsen.dk>,
        =?windows-1254?Q?Ar=FDn=E7_=DCNAL?= <arinc.unal@arinc9.com>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 0/2] net: dsa: realtek: fix PHY register read
 corruption
Thread-Topic: [PATCH net-next 0/2] net: dsa: realtek: fix PHY register read
 corruption
Thread-Index: AQHYI06+Oi3bmZ4n+EmyFAzgV7y6pg==
Date:   Thu, 17 Feb 2022 07:53:21 +0000
Message-ID: <87zgmqq68e.fsf@bang-olufsen.dk>
References: <20220216160500.2341255-1-alvin@pqrs.dk>
        <CAJq09z6Mr7QFSyqWuM1jjm9Dis4Pa2A4yi=NJv1w4FM0WoyqtA@mail.gmail.com>
        <87k0dusmar.fsf@bang-olufsen.dk>
        <CAJq09z70QyuyNtQVBW+jWOZ-CgY3uvyTo95JkMvCFNvOs2S1dw@mail.gmail.com>
In-Reply-To: <CAJq09z70QyuyNtQVBW+jWOZ-CgY3uvyTo95JkMvCFNvOs2S1dw@mail.gmail.com>       (Luiz
 Angelo Daros de Luca's message of "Thu, 17 Feb 2022 01:28:48   -0300")
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 846739f7-a7ac-4150-4b53-08d9f1ea917f
x-ms-traffictypediagnostic: AM5PR03MB2882:EE_
x-microsoft-antispam-prvs: <AM5PR03MB2882742DEEA00DF6A2D1A80383369@AM5PR03MB2882.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XQxPOdG+et3wXIgL6EX7096t7bRjCymLI+YD0BLyXyj9VfnYisyNAgv41Y6ZwnjwYl+F1qp63CBPHe6rQs/ZZvdvsRbFeOPNyPJGVyv2v2kdXBLX0F4ju9W+TMfK6QGtIR5RbZFe42O+FQtxtZGs1nEIbfWnPGzSUhixB8YNVkjoETJtH5N2u+GzDrYoCdHHnSYAfmi5kgSs2hanp6kngUllJpW51J68G53FSemJe8th+FYQrqyJreE1ikS0lKUfJOn0q6gSIu+tacqaC83k1ndH4loBbs7kx2mlZCyRnu0kS8RnUiFXuPlX3ai37BgeBs7qQIfAm5yHTyRPpnaY/o7H3RCszTXlP7rwbrKzkfwPDLpyF2X3Gsv6t1nR/FzvFTLJhiQ8f12eDPsPEwsWpgE49PKM7lyGI9r+2UCDMGS3rW39wtzI1lAQGUV70+H6QK4u2paLuHUKZwLoOj4O0NTgft5vCvhl4a7IVYJnaxuaBr6eQ510MPQFPsJyEFrbGVY40g5Pe0Et9p3MmWo7icZbKeq4uXqAdN2YYYgn6iq5ZuGB4hugMNutCwMQzXsDfUzBORp1GbakvfeYH2EKT+KWv6z9KCw922Pq/JQlU6aKAgY6Y/0q/Tx0oLUchVZzJNGhF8w1ELMsKysUSM760v/f+Cp1uatY4gKSxKGZgnJvNPd7uiMpCRoyz7gECxFGH3THpGj5exU7rNyLsJgQ8g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(6512007)(6506007)(6916009)(2616005)(26005)(186003)(36756003)(38070700005)(86362001)(38100700002)(316002)(2906002)(71200400001)(91956017)(122000001)(66476007)(8676002)(66556008)(64756008)(66446008)(54906003)(66946007)(4326008)(76116006)(7416002)(8936002)(8976002)(5660300002)(6486002)(508600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?windows-1254?Q?vAhEJwbfmuMqjX38j655vnMUqEOrTQ4uertpYGa56PDOg3/0we1U5zGZ?=
 =?windows-1254?Q?rjy3w6dJ8BvUnvKcIdfq/EFr5K/hOflFmeOMbSfdpzkqKCtxz3YdU9Ys?=
 =?windows-1254?Q?amwq2kkaESn0lX4xIVVBwleXCbVMQQO4RL+e1czgRu0vl7zaaQJc1Luw?=
 =?windows-1254?Q?NERJE17eHKELYTpWZM68xOdkrG5QAdOXK3bz4SMiJrVWflntz2LX0QKP?=
 =?windows-1254?Q?54MTVyRszV6MD5uzyS6n68QV1cc1jutpjlZqardQzkoDsZ9soL6aqVm1?=
 =?windows-1254?Q?Y9Ko1aeFYLwyMr+uylODOZuAzjmMtLCdniYxvAE//WmdGF/oR3R9wopt?=
 =?windows-1254?Q?BpQG6n5xrBc5iH1zkiUZjrX99PC1F9qwNrUia7VVVcRjGu0c7wmspBNJ?=
 =?windows-1254?Q?Vtif43BaHA9tYQmjJPLAKR8ohq0BemeoJcndkczQ5Ukc3qv26VYHeotj?=
 =?windows-1254?Q?H0GUcA1uJIB6hP37SymmKmDQSKSKGMWH6taRc3/HbA9Zt3G3rg3UCVVW?=
 =?windows-1254?Q?b+F39TmSJ1imSLDi7x/8i98JKRd5MVpUex1ArBpaWXz+tNkqB0gmrptn?=
 =?windows-1254?Q?xA1nnDmndLXTJRsuEcybyTBmkjPtWt532M5r0MgCLjo+Sy/aGiO5iId/?=
 =?windows-1254?Q?zhmvaiRvg8xx5du/EqQ8oTFEpBZ2hFcRefDQjMHyuyjU4bydoPgQSriN?=
 =?windows-1254?Q?nsS2uUzKAS/y/vUvI10E4GFW9uEU79W5NLIL0KjO1mDmoeRf5a+fW93z?=
 =?windows-1254?Q?P3ACd5qf7mlA1qSvyoNJl932wffskWiFqkLxR8ra4o1oIMJnLADzQBog?=
 =?windows-1254?Q?m7Dvd1WN/UyswyvWhDMOqTFpQT5j+0kdJ4ec+KS9WBqdmVZiUP/MDJJC?=
 =?windows-1254?Q?pHCySPqgmpeDr8bCcawqsYpf0Kjx3R+24GfPg5uh06t0kI7XJV7p4GR1?=
 =?windows-1254?Q?Z93/kpJXxITDHeBqK7dh+9toh5qSjoPvn9ggFMvNauQ31gQenkB/IrTy?=
 =?windows-1254?Q?ua2ANmlviAEjCncAYmEj3UwA/Z9Zm3cAGR9YvhScTr8l4lyxWbUpbmW4?=
 =?windows-1254?Q?WgToG3KvP6fT395PXQa16HiREjC2FAVlVVnosARN6+o50KPTf8X0tNWv?=
 =?windows-1254?Q?pxSVFF7qoOqUe/QxtkwAT/oyyVbHqugrPJKYu9dF+A/bDHTENpqJLDpL?=
 =?windows-1254?Q?LlE6+tjQLAWFITkqSbRidJlTtM/Fp+riiI1sUYsTV5eOUUuurRS0HUM4?=
 =?windows-1254?Q?u2zMEKU8clcPQbgFpNeecnD+FxkE9YKZN4Qs7zPfMlyi/YsNThZZlK9B?=
 =?windows-1254?Q?M5JHuPnltcc143D/1wYoGgvZOUHmYVoo6eftgnwCY/Zw+IuVw7/eBTfF?=
 =?windows-1254?Q?fg6hGi4IFMh/5iO/sfpxiiz5yFUKSKpQ1sYzYFKwZQfr1K3FktvUK09I?=
 =?windows-1254?Q?bTD1NAHQhZ8qBEhsHvg04LcTJHenG6Fbq9lboKZkcGazgGM7NWUbCkf4?=
 =?windows-1254?Q?/3R1T3xO/9GFq3rOH5Beqo7X0UiDfpA6Du/VG5X+LpWsxqYd7+rzijFS?=
 =?windows-1254?Q?TyKgdxTJ3XKlqO2vH4tYNTYxln4eIucWq60tclaBs/Rky/u7YmyHKcaM?=
 =?windows-1254?Q?xAlvKNW1Gs4For8vpFfWMbI6DWnCQUY5X8OJ9zPKn5aStDS7j67aLWKs?=
 =?windows-1254?Q?7ItCPwR9lRh0iEKkRz3lGJx9zPvwOh0M2nWblH7/5icvgGvDPmaDlZZ7?=
 =?windows-1254?Q?AFuGjXUj4GnUXt7deOg=3D?=
Content-Type: text/plain; charset="windows-1254"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 846739f7-a7ac-4150-4b53-08d9f1ea917f
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2022 07:53:21.4378
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QAgVxELBpOmb7VKFE/MyUoT0/n6F8Cx8I/hlCUiQ3gY44cRn396K7Y+TJ3BPqmWOszEFWEI3nnHEpTPiz75s2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR03MB2882
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Luiz Angelo Daros de Luca <luizluca@gmail.com> writes:

>> > I still feel like we are trying to go around a regmap limitation
>> > instead of fixing it there. If we control regmap lock (we can define a
>> > custom lock/unlock) and create new regmap_{read,write}_nolock
>> > variants, we'll just need to lock the regmap, do whatever you need,
>> > and unlock it.
>>
>> Can you show me what those regmap_{read,write}_nolock variants would
>> look like in your example? And what about the other regmap_ APIs we use,
>> like regmap_read_poll_timeout, regmap_update_bits, etc. - do you propose
>> to reimplement all of these?
>
> The option of having two regmaps is a nice way to have "_nolock"
> variants for free. It is much cleaner than any solutions I imagined!
> Ayway, I don't believe the regmap API expects to have an evil
> non-locked clone. It looks like it is being abused.
>
> What regmap API misses is a way to create a "transaction". Mdio, for
> example, expects the user to lock the bus before doing a series of
> accesses while regmap api assumes a single atomic access is enough.
> However, Realtek indirect register access shows that it is not enough.
> We could reimplement a mutex for every case where two calls might
> share the same register (or indirectly affect others like we saw with
> Realtek) but I believe a shared solution would be better, even if it
> costs a couple more wrap functions.
>
> It would be even nicer if we have a regmap "manual lock" mode that
> will expose the lock/unlock functions but it will never call them by
> itself. It would work if it could check if the caller is actually the
> same thread/context that locked it. However I doubt there is a clean
> solution in a kernel code that can check if the lock was acquired by
> the same context that is calling the read.

I went through all of this while preparing the patch, so your arguments
are familiar to me ;-)

What I sent was the cleanest solution I could eventually think of. I
don't think it is foul play, but I agree it is a bit funny to have this
kind of "shadow regmap". However, the interface is quite safe, and as I
implied in the commit message, quite foolproof as well.

Basically, rather than reimplementing every regmap API that I want to
use while manually taking the lock, I just use another regmap with
locking disabled. It boils down to exactly the same thing.

>
>
>> > BTW, I believe that, for realtek-mdio, a regmap custom lock mechanism
>> > could simply use mdio lock while realtek-smi already has priv->lock.
>>
>> Hmm OK. Actually I'm a bit confused about the mdio_lock: can you explain
>> what it's guarding against, for someone unfamiliar with MDIO? Currently
>> realtek-mdio's regmap has an additional lock around it (disable_locking
>> is 0), so with these patches applied the number of locks remains the
>> same.
>
> Today we already have to redundants locks (mdio and regmap). Your
> patch is just replacing the regmap lock.

Is that so? Andrew seems to imply that you shouldn't be using the
mdio_lock like this, but only for per-register access, and then
implement your own higher level lock:

> For PHYs this is sufficient. For switches, sometimes you need
> additional protection. The granularity of an access might not be a
> single register read or a write. It could be you need to read or write
> a few registers in an atomic way. If that is the case, you need a lock
> at a higher level.

It seems to me like you should have used mdiobus_{read,write} or even
mdiobus_{read,write}_nested? Although the state of the art in other DSA
drivers seems like a mixed bag, so I don't know.

Since I do not have an MDIO switch in front of me to test with, and
since the existing MDIO code looks a little suspect, again I would
prefer to stick in my lane and just fix the problem without
refactoring.

>
> regmap_read is something like this:
>
> regmap_read
>     lock regmap
>     realtek_mdio_read()
>         lock mdio
>         ...
>         unlock mdio
>    unlock regmap
>
> If you are implementing a custom lock, simply use mdio lock directly.
>
> And the map_nolock you created does not mean "access without locks"
> but "you must lock it yourself before using anything here". If that
> lock is actually mdio_lock, it would be ok to remove the lock inside
> realtek_mdio_{read,write}. You just need a reference to those
> lock/unlock functions in realtek_priv.
>
>> priv->lock is a spinlock which is inappropriate here. I'm not really
>> sure what the point of it is, besides to handle unlocked calls to the
>> _noack function. It might be removable altogether but I would prefer not
>> to touch it for this series.
>
> If spinlock is inappropriate, it can be easily converted to a mutex.
> Everything else from realtek-mdio might apply.

Well, this is a bugfix series, not a refactoring. I am not adding more
locks than were here before. If I start touching old code (this spinlock
predates my engagement with this driver), I will have to answer to that
in the commit message too. If we want to do this, let's do it after the
bugfix has been reviewed and merged. It will be easier to justify as
well.

Kind regards,
Alvin

>
>> Kind regards,
>> Alvin=
