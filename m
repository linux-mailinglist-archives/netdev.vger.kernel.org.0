Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84D5E4C8EDC
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 16:22:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235584AbiCAPXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 10:23:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233401AbiCAPXA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 10:23:00 -0500
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF37FA8ECB
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 07:22:19 -0800 (PST)
Received: by mail-qt1-x82b.google.com with SMTP id w1so10190012qtj.2
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 07:22:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=M9/JEVnJvWyMcgf/Ei/JoJH8yPdXLZfORGjH2dloKRc=;
        b=NlFrEJ1dEuJ0AcQqwJ+8p+coXsH+g3uANH4LRahRbKynTBadd3VdN0RcXP1ghojOle
         tE9Kgv2zAd0yYCpKyuQBM9lG2eFfhP+HbxVgiFno05OM9JQHe3bW+IADYKvg1QsCGqnq
         4gj8JuYK0VDWuZe8RkvlX4QR0DpiNyS0VRylU+1Clo+MORzKL/COJiwD8s8cXmsPg5dT
         qPPcUjSJJ2fthuorYka64tXuJeAw5WOx32b51sPBPc6kfsrz+vEVoTsKB5QMpcNqdyxJ
         R0u3xVoagGg2ymjsEk7GjKgEOScHogR7qJVS6Q1P4QLWQirnJv33b2/im9mAV062Hz5K
         IYSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=M9/JEVnJvWyMcgf/Ei/JoJH8yPdXLZfORGjH2dloKRc=;
        b=FyQ5dEGXRkHK7SdZvEtalJ13NazrHoQuitw1mSU3QU2A+XonZRtGbVbLjK+eOWKdxM
         6nuBLNO8GA3hj3WYg3vrTbfVPaF5wZsSD0f8Pq9YejzJCCoh44yWjZd/bVZSvf85iHtU
         6R7I3DArFxs5Cz6JicPVJ8DuHD/1OG5NLaK47qTWBHRlqW7QmOC6LoL6bRWsmSji6zpP
         HzkmFMs14Rsk0ALKIdlBDETiYBuCUD+38/BluDcnnZBk0c+nZhlzIfFqAgppfAxcdfSl
         /7a3GD4anrDtqJLUJV9uqTtwoGOf9u9bzSFiwMuQO0Jm/DXz+qdu+wTqeaUsdcZT5pKa
         yxIA==
X-Gm-Message-State: AOAM532iEQH4oDG5Sv0cJ8BCGpdSRI1j7Vk5M2fllWeau9+kzSkLZVPe
        15jthHCN7VfCIu463Izw3FwkdqtZdMw=
X-Google-Smtp-Source: ABdhPJzIRgSzrgheTMNk2z4jXVhI9qvzwf2VKmtR4ZRd3c6uZ71kOascEy9uWJ3zx4nGi3cyQAHysw==
X-Received: by 2002:ac8:590d:0:b0:2dd:a0b4:ae3d with SMTP id 13-20020ac8590d000000b002dda0b4ae3dmr20748929qty.176.1646148138919;
        Tue, 01 Mar 2022 07:22:18 -0800 (PST)
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com. [209.85.128.176])
        by smtp.gmail.com with ESMTPSA id 15-20020a37070f000000b0062cdc159505sm6626281qkh.89.2022.03.01.07.22.18
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Mar 2022 07:22:18 -0800 (PST)
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-2d6d0cb5da4so148060177b3.10
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 07:22:18 -0800 (PST)
X-Received: by 2002:a81:6603:0:b0:2d6:d166:8c31 with SMTP id
 a3-20020a816603000000b002d6d1668c31mr24869128ywc.351.1646148137765; Tue, 01
 Mar 2022 07:22:17 -0800 (PST)
MIME-Version: 1.0
References: <20220301144453.snstwdjy3kmpi4zf@begin> <CA+FuTSfi1aXiBr-fOQ+8XJPjCCTnqTicW2A3OUVfNHurfDL3jA@mail.gmail.com>
 <20220301150028.romzjw2b4aczl7kf@begin> <CA+FuTSeZw228fsDj+YoSpu5sLaXsp+uR+N+qHrzZ4e3yMWhPKw@mail.gmail.com>
 <20220301152017.jkx7amcbfqkoojin@begin>
In-Reply-To: <20220301152017.jkx7amcbfqkoojin@begin>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 1 Mar 2022 10:21:41 -0500
X-Gmail-Original-Message-ID: <CA+FuTSfVBVr_q6p+HcBL4NAX4z2BS0ZNaSfFF0yxO3QqeNX75Q@mail.gmail.com>
Message-ID: <CA+FuTSfVBVr_q6p+HcBL4NAX4z2BS0ZNaSfFF0yxO3QqeNX75Q@mail.gmail.com>
Subject: Re: [PATCH] SO_ZEROCOPY should rather return -ENOPROTOOPT
To:     Samuel Thibault <samuel.thibault@labri.fr>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        willemb@google.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>
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

On Tue, Mar 1, 2022 at 10:20 AM Samuel Thibault
<samuel.thibault@labri.fr> wrote:
>
> Willem de Bruijn, le mar. 01 mars 2022 10:14:18 -0500, a ecrit:
> > On Tue, Mar 1, 2022 at 10:00 AM Samuel Thibault
> > <samuel.thibault@labri.fr> wrote:
> > >
> > > Willem de Bruijn, le mar. 01 mars 2022 09:51:45 -0500, a ecrit:
> > > > On Tue, Mar 1, 2022 at 9:44 AM Samuel Thibault <samuel.thibault@labri.fr> wrote:
> > > > >
> > > > > ENOTSUPP is documented as "should never be seen by user programs", and
> > > > > is not exposed in <errno.h>, so applications cannot safely check against
> > > > > it. We should rather return the well-known -ENOPROTOOPT.
> > > > >
> > > > > Signed-off-by: Samuel Thibault <samuel.thibault@labri.fr>
> > > > >
> > > > > diff --git a/net/core/sock.c b/net/core/sock.c
> > > > > index 4ff806d71921..6e5b84194d56 100644
> > > > > --- a/net/core/sock.c
> > > > > +++ b/net/core/sock.c
> > > > > @@ -1377,9 +1377,9 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
> > > > >                         if (!(sk_is_tcp(sk) ||
> > > > >                               (sk->sk_type == SOCK_DGRAM &&
> > > > >                                sk->sk_protocol == IPPROTO_UDP)))
> > > > > -                               ret = -ENOTSUPP;
> > > > > +                               ret = -ENOPROTOOPT;
> > > > >                 } else if (sk->sk_family != PF_RDS) {
> > > > > -                       ret = -ENOTSUPP;
> > > > > +                       ret = -ENOPROTOOPT;
> > > > >                 }
> > > > >                 if (!ret) {
> > > > >                         if (val < 0 || val > 1)
> > > >
> > > > That should have been a public error code. Perhaps rather EOPNOTSUPP.
> > > >
> > > > The problem with a change now is that it will confuse existing
> > > > applications that check for -524 (ENOTSUPP).
> > >
> > > They were not supposed to hardcord -524...
> > >
> > > Actually, they already had to check against EOPNOTSUPP to support older
> > > kernels, so EOPNOTSUPP is not supposed to pose a problem.
> >
> > Which older kernels returned EOPNOTSUPP on SO_ZEROCOPY?
>
> Sorry, bad copy/paste, I meant ENOPROTOOPT.

Same point though, right? These are not legacy concerns, but specific
to applications written to SO_ZEROCOPY.

I expect that most will just ignore the exact error code and will work
with either.
