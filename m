Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1799C5787F7
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 18:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235092AbiGRQ6e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 12:58:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234972AbiGRQ6d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 12:58:33 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7227B2BB2B;
        Mon, 18 Jul 2022 09:58:32 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id tk8so11041794ejc.7;
        Mon, 18 Jul 2022 09:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=fRCvvvF9GzaIfPnvMQNV8yQUqIZvorKN6xkwY8hw0T8=;
        b=nNbVKIZW76g7LNTS2JC/njnGiPZm6aJCEbgfqPz7x1qnQElnCgKmpq5aBhflJ+choY
         BUb/ICQC0ha0BFfTyLtRelWwhnl4eTgnF4eX8pQ3XfgFVXauikedokODpX7/S2kQdyvg
         CYS9NX0qb/DacVYIccaqEeTDhY7dGP8icmHF1muuWyX7Ci/R+LtSLDLcDtu1E2PS+40l
         MGKe7ss3n/yx8Nw7Ky+FPgg7NhwZyWHs1zh+G0mYsvtSjNVFyUU4tgTdChTPRgWNpAY2
         kbYWudaDBRrpL13VFAdGLPOeb4NTgv+ugH8qA6Rrlmhm2dLE30tMiiI0aA0XC8N6HJnF
         pddg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=fRCvvvF9GzaIfPnvMQNV8yQUqIZvorKN6xkwY8hw0T8=;
        b=xwoA7URYqHOpJMOG7U1xlYMrfB+HIJUhkt3tL1quTvCoM1DFZqEDNvEBRP9xLzI2iZ
         UndtLIsRv8ItDmf/KE1BxMhKoKYeu+6SAFnh4C8hUJHzx5uqX7K7AxXeybLi/3xzqHFb
         wiTs0VPO6gI0bEMAqN6HGJB8N0Lk7KVkY+FkZv69nAFH2gIXJd1QjZYAH7LdZzv+g5x3
         O5XK3O3udDyT06YNuSUwVDytqZVP8W67qSbheMEmrh/B0Ai2fS+iTw3HlgJfvQoBmB4g
         ceP0hdnEgbYUUzB2BTCuhk4CpQWLB17vgqXJQBL07wOTQiCdqjytC3jNIl7Ab6bkl2aG
         m5Lw==
X-Gm-Message-State: AJIora/jQ6gFMkGjPIObpX0aAZwrzKUWWqS+ZS+HxLOcAFGEH1Mnt/yT
        qM8QzslVV5r9YoApiRqA+A/0cFn1GMxIGGbyGOc=
X-Google-Smtp-Source: AGRyM1vedfmSH45+N/vQh+Ae3OU88cvPOKpUkT67zJEvQ/TEGlPM3x+HcyDApKtO8EWLUbkL5CFlx2SmRM7Rkdgzj0o=
X-Received: by 2002:a17:906:cc0c:b0:72b:68df:8aff with SMTP id
 ml12-20020a170906cc0c00b0072b68df8affmr26553792ejb.226.1658163510800; Mon, 18
 Jul 2022 09:58:30 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1657755188.git.jhpark1013@gmail.com> <56d57be31141c12e9034cfa7570f2012528ca884.1657755189.git.jhpark1013@gmail.com>
 <d6240f70-858b-07ac-cab0-8483e16eff57@6wind.com>
In-Reply-To: <d6240f70-858b-07ac-cab0-8483e16eff57@6wind.com>
From:   Jaehee <jhpark1013@gmail.com>
Date:   Mon, 18 Jul 2022 12:58:33 -0400
Message-ID: <CAA1TwFC8h318B5BPq7a58tBRBwy1KwVbZztXHxc9s4_7TwCiWg@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 2/3] net: ipv6: new accept_untracked_na option
 to accept na only if in-network
To:     nicolas.dichtel@6wind.com
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, shuah@kernel.org,
        linux-kernel@vger.kernel.org, Arun Ajith S <aajith@arista.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Roopa Prabhu <roopa.prabhu@gmail.com>,
        Andy Roulin <aroulin@nvidia.com>,
        Stefano Brivio <sbrivio@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 4:35 AM Nicolas Dichtel
<nicolas.dichtel@6wind.com> wrote:
>
>
> Le 14/07/2022 =C3=A0 01:40, Jaehee Park a =C3=A9crit :
> > This patch adds a third knob, '2', which extends the
> > accept_untracked_na option to learn a neighbor only if the src ip is
> > in the same subnet as an address configured on the interface that
> > received the neighbor advertisement. This is similar to the arp_accept
> > configuration for ipv4.
> >
> > Signed-off-by: Jaehee Park <jhpark1013@gmail.com>
> > Suggested-by: Roopa Prabhu <roopa@nvidia.com>
> > ---
> >  Documentation/networking/ip-sysctl.rst | 51 +++++++++++++++-----------
> >  net/ipv6/addrconf.c                    |  2 +-
> >  net/ipv6/ndisc.c                       | 29 ++++++++++++---
> >  3 files changed, 55 insertions(+), 27 deletions(-)
> >
> > diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/net=
working/ip-sysctl.rst
> > index 5c017fc1e24d..722ec4f491db 100644
> > --- a/Documentation/networking/ip-sysctl.rst
> > +++ b/Documentation/networking/ip-sysctl.rst
> > @@ -2483,27 +2483,36 @@ drop_unsolicited_na - BOOLEAN
> >
> >       By default this is turned off.
> >
> > -accept_untracked_na - BOOLEAN
> > -     Add a new neighbour cache entry in STALE state for routers on rec=
eiving a
> > -     neighbour advertisement (either solicited or unsolicited) with ta=
rget
> > -     link-layer address option specified if no neighbour entry is alre=
ady
> > -     present for the advertised IPv6 address. Without this knob, NAs r=
eceived
> > -     for untracked addresses (absent in neighbour cache) are silently =
ignored.
> > -
> > -     This is as per router-side behaviour documented in RFC9131.
> > -
> > -     This has lower precedence than drop_unsolicited_na.
> > -
> > -     This will optimize the return path for the initial off-link commu=
nication
> > -     that is initiated by a directly connected host, by ensuring that
> > -     the first-hop router which turns on this setting doesn't have to
> > -     buffer the initial return packets to do neighbour-solicitation.
> > -     The prerequisite is that the host is configured to send
> > -     unsolicited neighbour advertisements on interface bringup.
> > -     This setting should be used in conjunction with the ndisc_notify =
setting
> > -     on the host to satisfy this prerequisite.
> > -
> > -     By default this is turned off.
> > +accept_untracked_na - INTEGER
> > +     Define behavior for accepting neighbor advertisements from device=
s that
> > +     are absent in the neighbor cache:
> > +
> > +     - 0 - (default) Do not accept unsolicited and untracked neighbor
> > +       advertisements.
> > +
> > +     - 1 - Add a new neighbor cache entry in STALE state for routers o=
n
> > +       receiving a neighbor advertisement (either solicited or unsolic=
ited)
> > +       with target link-layer address option specified if no neighbor =
entry
> > +       is already present for the advertised IPv6 address. Without thi=
s knob,
> > +       NAs received for untracked addresses (absent in neighbor cache)=
 are
> > +       silently ignored.
> > +
> > +       This is as per router-side behavior documented in RFC9131.
> > +
> > +       This has lower precedence than drop_unsolicited_na.
> > +
> > +       This will optimize the return path for the initial off-link
> > +       communication that is initiated by a directly connected host, b=
y
> > +       ensuring that the first-hop router which turns on this setting =
doesn't
> > +       have to buffer the initial return packets to do neighbor-solici=
tation.
> > +       The prerequisite is that the host is configured to send unsolic=
ited
> > +       neighbor advertisements on interface bringup. This setting shou=
ld be
> > +       used in conjunction with the ndisc_notify setting on the host t=
o
> > +       satisfy this prerequisite.
> > +
> > +     - 2 - Extend option (1) to add a new neighbor cache entry only if=
 the
> > +       source IP address is in the same subnet as an address configure=
d on
> > +       the interface that received the neighbor advertisement.
> >
> >  enhanced_dad - BOOLEAN
> >       Include a nonce option in the IPv6 neighbor solicitation messages=
 used for
> > diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
> > index 88becb037eb6..6ed807b6c647 100644
> > --- a/net/ipv6/addrconf.c
> > +++ b/net/ipv6/addrconf.c
> > @@ -7042,7 +7042,7 @@ static const struct ctl_table addrconf_sysctl[] =
=3D {
> >               .data           =3D &ipv6_devconf.accept_untracked_na,
> >               .maxlen         =3D sizeof(int),
> >               .mode           =3D 0644,
> > -             .proc_handler   =3D proc_dointvec_minmax,
> > +             .proc_handler   =3D proc_dointvec,
> >               .extra1         =3D (void *)SYSCTL_ZERO,
> >               .extra2         =3D (void *)SYSCTL_ONE,
> Maybe keeping proc_dointvec_minmax with SYSCTL_TWO for extra2 is better t=
o avoid
> accepting all values. It enables to add another value later.
>

Hi Nicolas, your suggested fix seems to work well in helping us avoid
accepting values >2. When I applied this change, and try to set
accept_untracked_na=3D3, it gives me a warning: "invalid argument" which
is the desired behavior, thanks! There might be a similar way for arp;
i'm looking for this now.

>
> Regards,
> Nicolas
