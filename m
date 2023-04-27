Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 950976F000E
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 06:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242702AbjD0EIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 00:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjD0EIA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 00:08:00 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C8872738
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 21:07:59 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id 98e67ed59e1d1-2472dc49239so7057086a91.1
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 21:07:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682568478; x=1685160478;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T3yhnAczn78gwn8HjEX2d2hPZ3uxeY+DCDwwnbfSZ68=;
        b=NufAeFFAtBtYMCaO1N3KoB0/l7jHIcDfH/ejHOLIN620t3sb4C9CYKDzs8a0E0wAtE
         GkbzFWw7mwRsRSnYhKezKsHipq4OKzUnAfOemAdhjO0LcU/RHC9uACen1EF96ANFf36W
         78392M7s5T4QPkOUaHLKM0eJUqeqCivbHV9UN8jqfpwgzqALEwKsocKf5oVzkqCkpzCj
         4Bbbgmd9vly2GpVEFV8qNJ+ircXfUDq6XCU42DH0TsP82/4Ke/PYlm4gkfTlyuftXGH1
         UCTumFhmw2HcGG4qvWTn6DiGeCHy9J+bxUhV0CPQl54khmbRJ4S2ur4HHXxsa/A4w8zO
         Q9jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682568478; x=1685160478;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T3yhnAczn78gwn8HjEX2d2hPZ3uxeY+DCDwwnbfSZ68=;
        b=NJMA9uIsgEUUaf+V8OWCcvqOhx9aBg+Cyu1ZY0esAQ2jz1jymXrSgiOzoHvUJuH26Q
         fqPJfnVE55RshLf+ynGQ3NrW29Zwpt55trfrE4LI4oG8HGACNtaxpDSrEDx8a5rL7ukl
         uTLXYvz2diDfA+7XaPcOo9tE+kqlFpAQEE0okFc2I5gEYrS43UOnTG57YxyGfpdYr2Nu
         9MS+thfyMFUpzAC1WkGaSnu/Eu5ACRU2m3KmeKVlGpI3Ni2A8yEkRNKagDNJ0Lr5zWP7
         XfOxHkt2lJAraa3vtaHUV2BnRX5T5YEU79dujvZR7zxm2t5mIvfAcCfOAzhgU4n7Xgv3
         iGsg==
X-Gm-Message-State: AC+VfDwVoUo5h+N367qPhmOnXESeW2klBQidyEX7Ra3F8wmgRyK9+mKo
        YfCyFb3RXx6ctaAgBVe7QHqqfr/nY6ZSNu2DEOE=
X-Google-Smtp-Source: ACHHUZ60zlrxMLXcAwhN8EK5cXIi7SR7uw4Hq+BTA9WAjFHVOJg7CvZHK1GlE86yB9Hd070/A9a9kgKOacT5x2VxrVA=
X-Received: by 2002:a17:90a:b106:b0:234:889f:c35d with SMTP id
 z6-20020a17090ab10600b00234889fc35dmr579687pjq.3.1682568478456; Wed, 26 Apr
 2023 21:07:58 -0700 (PDT)
MIME-Version: 1.0
References: <20230423032835.285406-1-glipus@gmail.com> <20230425085854.1520d220@kernel.org>
 <CAP5jrPEZ12UFbNC4gtah9RFxVZrbHDMCr8DQ_vBCtMY+6FWr7Q@mail.gmail.com> <20230426193749.70b948d5@kernel.org>
In-Reply-To: <20230426193749.70b948d5@kernel.org>
From:   Max Georgiev <glipus@gmail.com>
Date:   Wed, 26 Apr 2023 22:07:47 -0600
Message-ID: <CAP5jrPE-mQ33PGfX4vGtDfn_WU7wM-ZJBw9dGO7JrPJfxh8x8w@mail.gmail.com>
Subject: Re: [RFC PATCH v4 3/5] Add ndo_hwtstamp_get/set support to
 vlan/maxvlan code path
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     kory.maincent@bootlin.com, netdev@vger.kernel.org,
        maxime.chevallier@bootlin.com, vladimir.oltean@nxp.com,
        vadim.fedorenko@linux.dev, richardcochran@gmail.com,
        gerhard@engleder-embedded.com
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

On Wed, Apr 26, 2023 at 8:37=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> On Tue, 25 Apr 2023 22:43:34 -0600 Max Georgiev wrote:
> > > On Sat, 22 Apr 2023 21:28:35 -0600 Maxim Georgiev wrote:
> > > > -             if (!net_eq(dev_net(dev), &init_net))
> > > > -                     break;
> > >
> > > Did we agree that the net namespace check is no longer needed?
> > > I don't see it anywhere after the changes.
> >
> > My bad, I was under the impression that you, guys, decided that this
> > check wasn't needed.
> > Let me add it back and resend the patch.
>
> My memory holds for like a week at best :)
> I was genuinely asking if we agreed, if we did just mention that
> in the commit msg and add a link to the discussion :)

I looked through the discussion between you and Vladimir on vlan
and maxvlan driver conversion - there were no comments on the namespace
check
(https://lore.kernel.org/netdev/20230406165055.egz32amam6o2bmqu@skbuf/T/)
I guess I was delusional by excluding this check - thank you for catching i=
t!
