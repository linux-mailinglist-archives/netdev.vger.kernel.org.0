Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA63E5E5651
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 00:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbiIUWlM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 18:41:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbiIUWlL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 18:41:11 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 487C599B5A
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 15:41:10 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id 9so7393670pfz.12
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 15:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date;
        bh=ewiTBmEkjrLeRgH8XDZlgRceITtN7XK9skR1s0n7f1g=;
        b=2Hb1yo8+QeJQ/7rO8igJvKEZ02OUbfVRZlNptwFM9W3FNhCONdyYVOVu1oCYGnc8Dn
         Uf0JyY/X8msE313GCG/tg/v3u88DfDVhpZdeJqmmS6f0QXYqYUbeKNGhsXa38zQY39D8
         nLiaTiPM2GI7agp+gvFa1ZQUBrtuh2kI4qIsjbnFgglj+bE4hrZEVHqU7pAJO7uQjYQ/
         GeaLqM25LGBnTpn+Hxv4witL+/BYMyuv4XNmkVY5BG7ww7hQBdHByfbElwlGb5+fmykA
         eA+BnsxY+zhFIuPoT1qjUVTjK4HlyeKrsi4GIRcixm2AUd+b3P7bbKYPGecIkElePmVb
         V17w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date;
        bh=ewiTBmEkjrLeRgH8XDZlgRceITtN7XK9skR1s0n7f1g=;
        b=FqEBCXnU/TrG/pDInPSa5x+2TyA7q7rt1O2SqIi0AnEOBSbLnenA7j+KenSfiI7mSb
         Q/jZDaj74tuv7RfD4ThelrUwFtedPQ+IV99b1wS8GcGB5rttxa4IFm0714te23HFKYdh
         KQKo0tpGm4RZs8GrS1RPtBA23yuQ5oGR+ksB2LBsdp2L0ZOdQzP3SwyFEXuAQzsSk7Kz
         t19SGV90RN/xdsAOTjO5hCr5FkHXmpxwUGo58KTIJtgrua6fj8cMGRilfibN6v4GBxcI
         FO9MOjtDv8TkBQsV6TSeoNICwSQbBUhAtlPkN5P84mKWri0TXZ6VOjU+tt0LtiiWs1J+
         ssnA==
X-Gm-Message-State: ACrzQf306c4qRQdcKbdhGVpJPJIbVOmXxA7bWII128uJNebx4ZYM9/Vv
        6v2BjMdUyvJqSn8JL+Up7uDNTQ==
X-Google-Smtp-Source: AMsMyM4RNham9Q17Ndxq471/Cd3A8WPNposi9DxUNxZl85HVkGRNSvxveF0MbzTB7nMNn6kBF+/Yyg==
X-Received: by 2002:aa7:9dde:0:b0:53e:5af7:ac10 with SMTP id g30-20020aa79dde000000b0053e5af7ac10mr562653pfq.16.1663800069826;
        Wed, 21 Sep 2022 15:41:09 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id ik24-20020a170902ab1800b0017495461db7sm2553812plb.190.2022.09.21.15.41.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 15:41:09 -0700 (PDT)
Date:   Wed, 21 Sep 2022 15:41:07 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH v2 iproute2-next] ip link: add sub-command to view and
 change DSA master
Message-ID: <20220921154107.61399763@hermes.local>
In-Reply-To: <20220921183827.gkmzula73qr4afwg@skbuf>
References: <20220921165105.1737200-1-vladimir.oltean@nxp.com>
        <20220921113637.73a2f383@hermes.local>
        <20220921183827.gkmzula73qr4afwg@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Sep 2022 18:38:28 +0000
Vladimir Oltean <vladimir.oltean@nxp.com> wrote:

> On Wed, Sep 21, 2022 at 11:36:37AM -0700, Stephen Hemminger wrote:
> > On Wed, 21 Sep 2022 19:51:05 +0300
> > Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
> >  =20
> > > +.BI master " DEVICE"
> > > +- change the DSA master (host network interface) responsible for han=
dling the
> > > +local traffic termination of the given DSA switch user port. The sel=
ected
> > > +interface must be eligible for operating as a DSA master of the swit=
ch tree
> > > +which the DSA user port is a part of. Eligible DSA masters are those=
 interfaces
> > > +which have an "ethernet" reference towards their firmware node in th=
e firmware
> > > +description of the platform, or LAG (bond, team) interfaces which co=
ntain only
> > > +such interfaces as their ports. =20
> >=20
> > We still need to find a better name for this.
> > DSA predates the LF inclusive naming but that doesn't mean it can't be
> > fixed in user visible commands. =20
>=20
> Need? Why need? Who needs this and since when?

Also see: https://www.kernel.org/doc/html/v6.0-rc6/process/coding-style.htm=
l#naming

For symbol names and documentation, avoid introducing new usage of =E2=80=
=98master / slave=E2=80=99 (or =E2=80=98slave=E2=80=99 independent of =E2=
=80=98master=E2=80=99) and =E2=80=98blacklist / whitelist=E2=80=99.

Recommended replacements for =E2=80=98master / slave=E2=80=99 are:
=E2=80=98{primary,main} / {secondary,replica,subordinate}=E2=80=99 =E2=80=
=98{initiator,requester} / {target,responder}=E2=80=99 =E2=80=98{controller=
,host} / {device,worker,proxy}=E2=80=99 =E2=80=98leader / follower=E2=80=99=
 =E2=80=98director / performer=E2=80=99

Recommended replacements for =E2=80=98blacklist/whitelist=E2=80=99 are:
=E2=80=98denylist / allowlist=E2=80=99 =E2=80=98blocklist / passlist=E2=80=
=99

Exceptions for introducing new usage is to maintain a userspace ABI/API, or=
 when updating code for an existing (as of 2020) hardware or protocol speci=
fication that mandates those terms. For new specifications translate specif=
ication usage of the terminology to the kernel coding standard where possib=
le.
