Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED4E06D7484
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 08:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231191AbjDEGmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 02:42:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236924AbjDEGml (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 02:42:41 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 713A440EE
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 23:42:40 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id u10so33548797plz.7
        for <netdev@vger.kernel.org>; Tue, 04 Apr 2023 23:42:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680676960;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y3Vt+9WerTApZuBjOFTazuxbW9yw+rQ1XLRBvE13Ilk=;
        b=OVM40v1etZI9pVp3+vj38ed037J4izsqzNhtpUldu3wrd3Z9nS4MVAhOI56/gAPXdl
         1VxuQliY9+6dK2vywKnFSshMn1r8FUpuMh4kZYlkPZvczBIPOFLR/oas+3maKyKmFNZE
         r0oUPdBOnIZy2Hp2vtyMewpXk+ARt8N7/XrAEBCtUUtFk5PLLqsZxusN0E5Wt9c59gjH
         bDBkEvddB50BGMYDQxZwIIewRCcz91pCs0CTebvr2gzB/Mnj0X/UAjTyAedRD1a5FYbR
         z9LnC9CYahzBliLZP6Ce5I6Iq4WliNgPnYdL7XsBOCNdJJYpWjIgQciJeFeqO9uC5bw4
         oQKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680676960;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y3Vt+9WerTApZuBjOFTazuxbW9yw+rQ1XLRBvE13Ilk=;
        b=gXS2ZDTLLc5M0fy6sIPOjV4YSBYRCHmYzEBgJBI/ymwjlrp9PvhpzTvXPDbRaW/r4O
         1/fRZe/vop5Rj6bTjQW9wLFNuJBmhblkVs4Y+5tkYGsWaB6rfU03tmQadJjYLvy1WJhH
         p+bznRdpCjx/Nn1Mb8Y6XkBkeyLyS5YWCT1RnLBW2OiqOw/WbEEoXxJzxXq+YlVNgYIp
         GyQnGmVdhHAo0nTBYDMeocCAP0WHekV2JVI/f4CRsVRcKXR4Z56QpKDjpZaRbk3R4yW0
         NAGkhFXInCo9Tqb66lTMXnk1o1qbapOEQX4jzAiJhgr8da2kNQtgxCDTh4rqJDeihRQ7
         3DFA==
X-Gm-Message-State: AAQBX9dEzOt06m0JhNKYc6sginoqg0GqPtOChuQH9c5Lgyru6vLVfKLG
        m8bAUdJRNLd5NwyxwTVkyLaXZvBcU4lVlz5bZP4=
X-Google-Smtp-Source: AKy350bapUJylxDh7WR1UolLicop5Z1cI8+13ZVgYVNa+avMIilwR9bg1Tv6qNO5pcbq8BDYboX7bEyyUXDti3VCgB0=
X-Received: by 2002:a17:902:c643:b0:1a1:ba37:d079 with SMTP id
 s3-20020a170902c64300b001a1ba37d079mr727343pls.3.1680676959785; Tue, 04 Apr
 2023 23:42:39 -0700 (PDT)
MIME-Version: 1.0
References: <20230402142435.47105-1-glipus@gmail.com> <20230403122622.ixpiy2o7irxb3xpp@skbuf>
 <CAP5jrPExLX5nF7BWSSc1LeE_HOSWsDNLiGB52U0dzxfXFKb+Lw@mail.gmail.com>
 <20230404123015.wzv5l5owgkppoarr@skbuf> <20230404162551.1d45d031@kernel.org>
In-Reply-To: <20230404162551.1d45d031@kernel.org>
From:   Max Georgiev <glipus@gmail.com>
Date:   Wed, 5 Apr 2023 00:42:28 -0600
Message-ID: <CAP5jrPGwyyLMTNpriOA71sMH4fRAefV5Bbe=X=2v_ML9JJdwdw@mail.gmail.com>
Subject: Re: [PATCH net-next RFC v2] Add NDOs for hardware timestamp get/set
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        kory.maincent@bootlin.com, netdev@vger.kernel.org,
        maxime.chevallier@bootlin.com,
        Vadim Fedorenko <vadim.fedorenko@linux.dev>,
        Richard Cochran <richardcochran@gmail.com>,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thank you for the comments!

I've sent out v3 of the RFC stack to let the comment flow, and to
potentially unblock K=C3=B6ry.
I've added patches to insert ifr pointer into struct
kernel_hwtstamp_config as Jakub suggested, but no code is relying on
this new field yet.
I also added a patch which is supposed to fix the VLAN code path. I
can implement ndo_hwtstamp_get/set in VLAN as well - please comment if
it would be a good idea.
I haven't fixed bond_eth_ioctl() yet - will add it in the next
version. More driver conversion patches are planned as was discussed.

On Tue, Apr 4, 2023 at 5:25=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wro=
te:
>
> On Tue, 4 Apr 2023 15:30:15 +0300 Vladimir Oltean wrote:
> > On Mon, Apr 03, 2023 at 09:42:09AM -0600, Max Georgiev wrote:
> > > The conversions are going to be easy (that was the point of adding th=
ese NDO
> > > functions). But there is still a problem of validating these
> > > conversions with testing.
> > > Unfortunately I don't have an e1000 card available to validate this c=
onversion.
> > > I'll let you and Jakub decide what will be the best strategy here.
> >
> > If you can convert one of the drivers under drivers/net/ethernet/freesc=
ale/
> > with the exception of fec_main.c, or net/dsa/ + drivers/net/dsa/sja1105=
/
> > or drivers/net/dsa/mv88e6xxx/, then I can help with testing.
> >
> > By the way, after inspecting the kernel code a bit more, it also looks
> > like we need to convert vlan_dev_ioctl() and bond_eth_ioctl() to
> > something compatible with lower interfaces using the new and the old
> > API, before converting any driver. Otherwise we'll need to do that late=
r
> > anyway, when regression reports start coming in. So these 2 are
> > non-optional whatever you do.
>
> Alternatively we could have them call back to the core helper
> to descend to a lower device. Stuff ifr into struct
> kernel_hwtstamp_config for now in case lower is not converted.
