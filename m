Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 478B8565C8B
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 19:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232549AbiGDRAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 13:00:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231965AbiGDRAB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 13:00:01 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 422902614
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 09:59:57 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id 73-20020a9d084f000000b00616b04c7656so8000064oty.3
        for <netdev@vger.kernel.org>; Mon, 04 Jul 2022 09:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=MMk+cR6ZY9Nwr5ExQfED6G6FK+s2iHn1JDuVaBA0PuI=;
        b=ZYNj3j/Ri85Wac+5fVsTfJhqoQeDAgKLCm4jsWWp7Sw4MDGnkNgfOhhpoThHcl6BYo
         GmPfL7mwvBY8B70vn5cF1hbeBC0b4x4l9/K8EGO5n18hyLGRx0cjH6pd/9hHIElieDGP
         OIF6zTxXpdsqCsmyie4CP4OsRDYaI7bdXPJvqkJjGb3XdvHm5DgwoP2AmLDJupUXsiEo
         ofFXjEVZpQ4aev/KHFo1/kkgl1zlM1L+MPKAnmNqzRriG9idF+jGCpaeqAvxHaJUvQZR
         DXGDrw4nN8MI4jASgI61U30fOP/lCu+oumVUMiwwNUlmYtw+ZCBguo2c9yj6g8xRFsJM
         ktZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=MMk+cR6ZY9Nwr5ExQfED6G6FK+s2iHn1JDuVaBA0PuI=;
        b=qNBj+LMq9xZBDreo/TmZHK59/LrRiPemFhGm4Z+5cxhYXyBCyJXOsq7W04glWHMIX7
         tmAiiq6Q5vuSDxh+RilpMOKQ4UHBFdY/CAq0fWZeuEqQHIVLYo4Apy1LVVbQa3J/Lkv6
         nxjrk3bcU69U1KCQxnwFdVpjbIPhBEOJdGVF92yxriyqrM1TwqYRRTo3IPZU7bLiszC6
         CwFC4H+jdWc3lRGCJcr8eSgMEWYPSSpXfoEynbOZa+K+SJwmNKZHL3d2D98bb5q1/gbR
         y2nU2rl5pT7Hpmnp9Rz+L3c9Ee5/PSf9jZfinNxGjLwget/uG8gnOef75i9Tappy6E2F
         2iIA==
X-Gm-Message-State: AJIora83jXQ3UYhXvvHmhrz6YLxuhZcyh9hsqf1m81RdYwz3Kikqep6Z
        krB0yCS1UjrhEGncx1G9JVDGdHLdjXryGEuBevy65Q==
X-Google-Smtp-Source: AGRyM1tsAJZvXrjIoztG0Y/tuF2jZmCM1Ei1G818wh0M8luiLzWwbQYQ1qhrmh4SjAPutlP/MwgBnz8FFVbGPjsRC6o=
X-Received: by 2002:a05:6830:1ae9:b0:616:d5b3:8cde with SMTP id
 c9-20020a0568301ae900b00616d5b38cdemr13105329otd.34.1656953996651; Mon, 04
 Jul 2022 09:59:56 -0700 (PDT)
MIME-Version: 1.0
References: <CAM0EoMkWjOYRuJx3ebY-cQr5odJekwCtxeM5_Cmu1G4vxZ5dpw@mail.gmail.com>
 <YsMWpgwY/9GzcMC8@shredder>
In-Reply-To: <YsMWpgwY/9GzcMC8@shredder>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Mon, 4 Jul 2022 12:59:45 -0400
Message-ID: <CAM0EoM=Gycw88wC+tSOXFjEu3jKkqgLU8mNZfe48Zg0JXbtPiQ@mail.gmail.com>
Subject: Re: Report: iproute2 build broken?
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Petr Machata <petrm@nvidia.com>, David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks Ido. That fixed it.
General question: do we need a "stable" iproute2?

cheers,
jamal

On Mon, Jul 4, 2022 at 12:34 PM Ido Schimmel <idosch@idosch.org> wrote:
>
> On Mon, Jul 04, 2022 at 11:51:39AM -0400, Jamal Hadi Salim wrote:
> > I have to admit i am being lazy here digging into the
> > root cause but normally iproute2 should just build
> > standalone regardless especially when it is a stable
> > version:
> >
> > $ cat include/version.h
> > static const char version[] =3D "5.18.0";
> >
> > $make
> > ..
> > ....
> > .....
> >   CC       iplink_bond.o
> > iplink_bond.c:935:10: error: initializer element is not constant
> >   .desc =3D ipstats_stat_desc_bond_tmpl_lacp,
> >           ^
> > iplink_bond.c:935:10: note: (near initialization for
> > =E2=80=98ipstats_stat_desc_xstats_bond_lacp.desc=E2=80=99)
> > iplink_bond.c:957:10: error: initializer element is not constant
> >   .desc =3D ipstats_stat_desc_bond_tmpl_lacp,
> >           ^
> > iplink_bond.c:957:10: note: (near initialization for
> > =E2=80=98ipstats_stat_desc_xstats_slave_bond_lacp.desc=E2=80=99)
> > ../config.mk:40: recipe for target 'iplink_bond.o' failed
> > make[1]: *** [iplink_bond.o] Error 1
> > Makefile:77: recipe for target 'all' failed
> > make: *** [all] Error 2
>
> Petr is OOO, not sure he will see your mail till later this week so I
> will try to help. Can you try with current main branch [1] or just take
> this patch [2] ?
>
> [1] https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/log/
> [2] https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?=
id=3D11e41a635cfab54e8e02fbff2a03715467e77ae9
>
> >
> > There's more if you fix that one given a whole lot
> > of dependencies
> >
> > cheers,
> > jamal
