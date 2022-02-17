Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF5184B97AC
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 05:29:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233823AbiBQE3O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 23:29:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233814AbiBQE3O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 23:29:14 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73E6425DA44;
        Wed, 16 Feb 2022 20:29:00 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id d17so3996017pfl.0;
        Wed, 16 Feb 2022 20:29:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cD4DY/iuVWWWEU+B7lYuOW47EogbL76oMXy+TtExHBA=;
        b=Cs0D46Hd+lQrpa2kOOAiTZYdV7O7dnetV0EpOnsEfabfZv/Xdfa93fYpnS4lxs9090
         UoVQEgLnYOA+fHRdDx8MTztD/w10a54FSnCdXbEZS9MdkL60Sk00iEbg5HndEVWWuxW1
         MnMSIxhkf5iFbl8udXXVRv5QKi66qDmTM9hKCUMdoLUjg3mcT+7lq2ekV2MlAxKm8ZhH
         J9GmOi+SYcdcwKk5md0nGM+0WXUZCs9zE2O4KfRVE8qk2ScVlp2Yc0lsGssP7Fz6VStJ
         7FJW2Ttw+ydwJEY/v+3w6kcwyDvrG0iDMvk4BM6wM+Ex0G9SYb4LEuvx091QQHhjXcY+
         qIiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cD4DY/iuVWWWEU+B7lYuOW47EogbL76oMXy+TtExHBA=;
        b=5d3s7rbR3ui/N2kniWDTL1MNg2CnK02I7p+WAnH/0wbMnW6vslDdpxf9UzcpXe4LMs
         YzP8dMHwq4797N+9D3zL6M5y4TWp4F5GpDfq0iS3MsV+bAPDyyG1ML2ROafe1rBnjEkO
         z5IXAZmP2oQFw6zx9esuCZgSe+BXybeo8/oZCKptttqlBE7vNX0ybsXMeYe8lNyZw62S
         6aMc6zdrPntnUf2pwJvfPVQBHGUm39iwcx/sJVP4HyNeSu4QnT1HGFSi1bzhfmIfqiQe
         lUbUEcMzFAaIAxJIMSLeOugOvf1r9mZXHlwmfa9Ea9ir5/aKw27cstOaYlG6Lsi4VXB7
         PmJg==
X-Gm-Message-State: AOAM530tzpaXlZis5kY46TY7oR7lsyKayKFpk5Hx1K+6zTgjoz8FFscD
        6C1UJbMJSq3vJ+P1qX6cDs/xjLjgr/KHSDvR8uM=
X-Google-Smtp-Source: ABdhPJze8Ut/k/1DEebzGtunX62i6DluhRcm1Ern0+DrP6QJLxWIrQnVah76np+9jKRQgWSkeGiw5Sn0qeJPGekh818=
X-Received: by 2002:a63:ce54:0:b0:364:f310:6e0c with SMTP id
 r20-20020a63ce54000000b00364f3106e0cmr1029941pgi.456.1645072139872; Wed, 16
 Feb 2022 20:28:59 -0800 (PST)
MIME-Version: 1.0
References: <20220216160500.2341255-1-alvin@pqrs.dk> <CAJq09z6Mr7QFSyqWuM1jjm9Dis4Pa2A4yi=NJv1w4FM0WoyqtA@mail.gmail.com>
 <87k0dusmar.fsf@bang-olufsen.dk>
In-Reply-To: <87k0dusmar.fsf@bang-olufsen.dk>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Thu, 17 Feb 2022 01:28:48 -0300
Message-ID: <CAJq09z70QyuyNtQVBW+jWOZ-CgY3uvyTo95JkMvCFNvOs2S1dw@mail.gmail.com>
Subject: Re: [PATCH net-next 0/2] net: dsa: realtek: fix PHY register read corruption
To:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alvin@pqrs.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Rasmussen <MIR@bang-olufsen.dk>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > I still feel like we are trying to go around a regmap limitation
> > instead of fixing it there. If we control regmap lock (we can define a
> > custom lock/unlock) and create new regmap_{read,write}_nolock
> > variants, we'll just need to lock the regmap, do whatever you need,
> > and unlock it.
>
> Can you show me what those regmap_{read,write}_nolock variants would
> look like in your example? And what about the other regmap_ APIs we use,
> like regmap_read_poll_timeout, regmap_update_bits, etc. - do you propose
> to reimplement all of these?

The option of having two regmaps is a nice way to have "_nolock"
variants for free. It is much cleaner than any solutions I imagined!
Ayway, I don't believe the regmap API expects to have an evil
non-locked clone. It looks like it is being abused.

What regmap API misses is a way to create a "transaction". Mdio, for
example, expects the user to lock the bus before doing a series of
accesses while regmap api assumes a single atomic access is enough.
However, Realtek indirect register access shows that it is not enough.
We could reimplement a mutex for every case where two calls might
share the same register (or indirectly affect others like we saw with
Realtek) but I believe a shared solution would be better, even if it
costs a couple more wrap functions.

It would be even nicer if we have a regmap "manual lock" mode that
will expose the lock/unlock functions but it will never call them by
itself. It would work if it could check if the caller is actually the
same thread/context that locked it. However I doubt there is a clean
solution in a kernel code that can check if the lock was acquired by
the same context that is calling the read.


> > BTW, I believe that, for realtek-mdio, a regmap custom lock mechanism
> > could simply use mdio lock while realtek-smi already has priv->lock.
>
> Hmm OK. Actually I'm a bit confused about the mdio_lock: can you explain
> what it's guarding against, for someone unfamiliar with MDIO? Currently
> realtek-mdio's regmap has an additional lock around it (disable_locking
> is 0), so with these patches applied the number of locks remains the
> same.

Today we already have to redundants locks (mdio and regmap). Your
patch is just replacing the regmap lock.

regmap_read is something like this:

regmap_read
    lock regmap
    realtek_mdio_read()
        lock mdio
        ...
        unlock mdio
   unlock regmap

If you are implementing a custom lock, simply use mdio lock directly.

And the map_nolock you created does not mean "access without locks"
but "you must lock it yourself before using anything here". If that
lock is actually mdio_lock, it would be ok to remove the lock inside
realtek_mdio_{read,write}. You just need a reference to those
lock/unlock functions in realtek_priv.

> priv->lock is a spinlock which is inappropriate here. I'm not really
> sure what the point of it is, besides to handle unlocked calls to the
> _noack function. It might be removable altogether but I would prefer not
> to touch it for this series.

If spinlock is inappropriate, it can be easily converted to a mutex.
Everything else from realtek-mdio might apply.

> Kind regards,
> Alvin
