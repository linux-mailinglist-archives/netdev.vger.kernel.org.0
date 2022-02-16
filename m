Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A045F4B8A71
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 14:39:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234617AbiBPNjP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 08:39:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234222AbiBPNjO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 08:39:14 -0500
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 073172A39F3;
        Wed, 16 Feb 2022 05:39:01 -0800 (PST)
Received: by mail-qt1-x82d.google.com with SMTP id z1so2063757qto.3;
        Wed, 16 Feb 2022 05:39:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=21ndo1beMI8yP0ftAH82Ak+ucIbbctFR1VliNX6f60o=;
        b=Pm6qW+nuN1Uscn8S8rNAsFZPUQCquHw2f7nLd8iiWgi1VBSYRM2MCpojTcqJd6JGWP
         Qn6+Mhh+yJ7QYCvD2cL85h2KQWAIDAgPdl+C/PJm7TrM1mGRrGIkcK55unvVnEXXSvCp
         5L+l0XMcRAy+qoA9kFlvsTxMjOuHlP6V9vim/UxLN4CQQnPQtDbtyV6YogCzj9aoGue1
         O3a798PeDhuFGsJigaZ1H89jQur/b6F2mMy8mb6e29f4zzeSj4ALIEnXeqzuX13TJzgc
         J/MI5xXKQktWxXNgOsATslG7t/632uO8wyQ6HGRZL7EoFWNwMB7KyFUFU9+ojzqzEYUz
         LHRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=21ndo1beMI8yP0ftAH82Ak+ucIbbctFR1VliNX6f60o=;
        b=PSobMhaqH4dei023O+4wejUHGXPENk+WHqfVVg2b7u2t207htSo2NGvTXEr05o8HDA
         oIgVI/stOHsC264Jra3tAuGqJh+aLCuP3M70ZNP++sgfb6lNOMbKMQtD+PZ9NUXJfJXg
         Ha0LjjMN2cfW/Z+tz0KDd3lrbpXJ3qV1x3pM0ETUdTJYqdJw7izqnpCR6zYsAWHcXMEX
         wtWXYT9ajWIsltov1M1uFd6hFR0rJIAhIVoJLS1LOd7yxIRJ+9n7SNdFBofT/QA21zyj
         Ru9ddixrswFfNk+Fc0npFKxheuPhVdJxK3WJs6AFDJ2q+ObIn3Wdi67or8v9Hh39kVrQ
         uIAg==
X-Gm-Message-State: AOAM532Fc+7vpfpli4JorFvoWHOc1dmhIXUagXvNv8U0PHGjVUS0cwFo
        BKW8bNPCdsMtI9iaE6Mff9GBtgPCwKwjBIdH9Go=
X-Google-Smtp-Source: ABdhPJyFM58ntAw5nr1wH2+4e/Yx3d3h4s3txaYAHeouEPQwV8TP0rj6/pEZ9BuQyKT3p261yqWE5gmV5yn5L4GB6N0=
X-Received: by 2002:a05:622a:d0:b0:2d5:50c1:67a6 with SMTP id
 p16-20020a05622a00d000b002d550c167a6mr1898200qtw.297.1645018740038; Wed, 16
 Feb 2022 05:39:00 -0800 (PST)
MIME-Version: 1.0
References: <20211009221711.2315352-1-robimarko@gmail.com> <163890036783.24891.8718291787865192280.kvalo@kernel.org>
 <CAOX2RU5mqUfPRDsQNSpVPdiz6sE_68KN5Ae+2bC_t1cQzdzgTA@mail.gmail.com>
 <09a27912-9ea4-fe75-df72-41ba0fa5fd4e@gmail.com> <CAOX2RU6qaZ7NkeRe1bukgH6OxXOPvJS=z9PRp=UYAxMfzwD2oQ@mail.gmail.com>
 <EC2778B3-B957-4F3F-B299-CC18805F8381@slashdirt.org> <CAOX2RU7FOdSuo2Jgo0i=8e-4bJwq7ahvQxLzQv_zNCz2HCTBwA@mail.gmail.com>
In-Reply-To: <CAOX2RU7FOdSuo2Jgo0i=8e-4bJwq7ahvQxLzQv_zNCz2HCTBwA@mail.gmail.com>
From:   Robert Marko <robimarko@gmail.com>
Date:   Wed, 16 Feb 2022 14:38:48 +0100
Message-ID: <CAOX2RU7d9amMseczgp-PRzdOvrgBO4ZFM_+hTRSevCU85qT=kA@mail.gmail.com>
Subject: Re: [PATCH] ath10k: support bus and device specific API 1 BDF selection
To:     Thibaut <hacks@slashdirt.org>
Cc:     Christian Lamparter <chunkeey@gmail.com>,
        Kalle Valo <kvalo@kernel.org>, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
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

Silent ping,

Does anybody have an opinion on this?

Regards,
Robert

On Wed, 2 Feb 2022 at 19:49, Robert Marko <robimarko@gmail.com> wrote:
>
> Kalle,
>
> What is your opinion on this?
> I would really love to see this get merged as we are having more and
> more devices that are impacted without it.
>
> Regards,
> Robert
>
> On Fri, 17 Dec 2021 at 13:25, Thibaut <hacks@slashdirt.org> wrote:
> >
> >
> >
> > > Le 17 d=C3=A9c. 2021 =C3=A0 13:06, Robert Marko <robimarko@gmail.com>=
 a =C3=A9crit :
> > >
> > > On Wed, 8 Dec 2021 at 15:07, Christian Lamparter <chunkeey@gmail.com>=
 wrote:
> > >>
> > >> Isn't the only user of this the non-upstreamable rb_hardconfig
> > >> mikrotik platform driver?
> >
> > The driver could be upstreamed if desirable.
> > Yet I think it=E2=80=99s quite orthogonal to having the possibility to =
dynamically load a different BDF via API 1 for each available radio, which =
before this patch couldn=E2=80=99t be done and is necessary for this partic=
ular hardware.
> >
> > >> So, in your case the devices in question
> > >> needs to setup a detour through the userspace firmware (helper+scrip=
ts)
> > >> to pull on the sysfs of that mikrotik platform driver? Wouldn't it
> > >> be possible to do this more directly?
> > >
> > > Yes, its the sole current user as its the only vendor shipping the BD=
F
> > > as part of the
> > > factory data and not like a userspace blob.
> > >
> > > I don't see how can it be more direct, its the same setup as when
> > > getting pre-cal
> > > data for most devices currently.
> >
> > Indeed, not sure how it could be more direct than it already is. I=E2=
=80=99m open to suggestions though.
> >
> > > I am adding Thibaut who is the author of the platform driver.
> >
> > Best,
> > Thibaut
