Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9E754413B
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 04:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232221AbiFICGY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 22:06:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbiFICGX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 22:06:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3F82E38B5
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 19:06:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654740381;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PVkbQ2QFVJf0z3i4dPUc0Ah3x1kqdO64gGzuDksuCis=;
        b=i1Azd1yMRjBP9DYAXRsuyZ41LHDQFjpTZZuGhFTD/IfswoL3yf4MycNS0zSseyhgrFZi5O
        TlTtYuWDGxXW3DphYUIEAKys7noXO5ViWKABNeqDwih9GPOzmoPUTn20IZKsPvfm+g+FMM
        +cXUkaNsIFcP3/cojttlLvD51DPaGHU=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-574--yCH1hJ4Mq2ydnslUJrPUg-1; Wed, 08 Jun 2022 22:06:20 -0400
X-MC-Unique: -yCH1hJ4Mq2ydnslUJrPUg-1
Received: by mail-qk1-f197.google.com with SMTP id bq11-20020a05620a468b00b006a71592a2abso2012477qkb.21
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 19:06:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PVkbQ2QFVJf0z3i4dPUc0Ah3x1kqdO64gGzuDksuCis=;
        b=CB3W4kiFD7uT3GEcbUb5B9P2Kld/mvioli3EYV+AF6U83d+1nJbfSc4HMAOv5fa9XQ
         HTCec5muML/CuULC8EbpMf0+Ka6hzJ8EJRCNyINj5kTxJQyzwVld2LdZZCoxn5U6r43p
         TtCpOz+rHz5rtgwvX/y/lrsNcnB4CCACWpRPZnpqU0w6atnETfKqN1/bxeOSVSxHFXKO
         ZrhYeSX1WvA7heM334hibB2H8bF/X+Z7kejmkMdgDmdUqnFjoCFqYGvXXZCHboxXo4N+
         DMXlD23ib2D4lFSfnfeBeYVDJX+kC/TtLH+XQhVqoiD3iROOqUNNg7y698NakYGZXtV3
         wQqQ==
X-Gm-Message-State: AOAM533J97/E2+aXHn3j6ZaSbRS75rZCr6s4rGIPvoPSIvO9jlwoeB9Q
        ZcHD1G4ZF+Z6yopdl2PWxAK+4Xe6Kw6jBR57F9vFtzeM53/hCa/pmxjXOlpufX1eHSoAL8+skvf
        UlviZ3JLtXKx2RPyTd7NVxf10z17c6y+R
X-Received: by 2002:ac8:5752:0:b0:304:c7db:2cde with SMTP id 18-20020ac85752000000b00304c7db2cdemr28910231qtx.291.1654740379608;
        Wed, 08 Jun 2022 19:06:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxW1PJyY7hYXJeVkGMAQ50fhMmhm3Pf7hJw/DuqRzS1drL45OyaqUc16wThsYYqn1ByuCAHyDW+pOtR/fsA/No=
X-Received: by 2002:ac8:5752:0:b0:304:c7db:2cde with SMTP id
 18-20020ac85752000000b00304c7db2cdemr28910216qtx.291.1654740379343; Wed, 08
 Jun 2022 19:06:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220603182143.692576-1-miquel.raynal@bootlin.com>
 <20220603182143.692576-2-miquel.raynal@bootlin.com> <CAK-6q+hAZMqsN=S9uWAm4rTN+uZwz7_L42=emPHz7+MvfW6ZpQ@mail.gmail.com>
 <20220606174319.0924f80d@xps-13> <CAK-6q+itswJrmy-AhZ5DpnHH0UsfAeTPQTmX8WfG8=PteumVLg@mail.gmail.com>
 <20220607181608.609429cb@xps-13> <20220608154749.06b62d59@xps-13> <20220608163708.26ccd4cc@xps-13>
In-Reply-To: <20220608163708.26ccd4cc@xps-13>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Wed, 8 Jun 2022 22:06:08 -0400
Message-ID: <CAK-6q+iD0_bS2z_BdKsyeqYvzxj2x-v+SWAo2UO02j7yGtEcEg@mail.gmail.com>
Subject: Re: [PATCH wpan-next 1/6] net: ieee802154: Drop coordinator interface type
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, Jun 8, 2022 at 10:37 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
>
> miquel.raynal@bootlin.com wrote on Wed, 8 Jun 2022 15:47:49 +0200:
>
> > Hi Alex,
> >
> > > > 3. coordinator (any $TYPE specific) userspace software
> > > >
> > > > May the main argument. Some coordinator specific user space daemon
> > > > does specific type handling (e.g. hostapd) maybe because some library
> > > > is required. It is a pain to deal with changing roles during the
> > > > lifetime of an interface and synchronize user space software with it.
> > > > We should keep in mind that some of those handlings will maybe be
> > > > moved to user space instead of doing it in the kernel. I am fine with
> > > > the solution now, but keep in mind to offer such a possibility.
> > > >
> > > > I think the above arguments are probably the same why wireless is
> > > > doing something similar and I would avoid running into issues or it's
> > > > really difficult to handle because you need to solve other Linux net
> > > > architecture handling at first.
> > >
> > > Yep.
> >
> > The spec makes a difference between "coordinator" and "PAN
> > coordinator", which one is the "coordinator" interface type supposed to
> > picture? I believe we are talking about being a "PAN coordinator", but
> > I want to be sure that we are aligned on the terms.
> >
> > > > > > You are mixing things here with "role in the network" and what
> > > > > > the transceiver capability (RFD, FFD) is, which are two
> > > > > > different things.
> > > > >
> > > > > I don't think I am, however maybe our vision differ on what an
> > > > > interface should be.
> > > > >
> > > > > > You should use those defines and the user needs to create a new
> > > > > > interface type and probably have a different extended address
> > > > > > to act as a coordinator.
> > > > >
> > > > > Can't we just simply switch from coordinator to !coordinator
> > > > > (that's what I currently implemented)? Why would we need the user
> > > > > to create a new interface type *and* to provide a new address?
> > > > >
> > > > > Note that these are real questions that I am asking myself. I'm
> > > > > fine adapting my implementation, as long as I get the main idea.
> > > > >
> > > >
> > > > See above.
> > >
> > > That's okay for me. I will adapt my implementation to use the
> > > interface thing. In the mean time additional details about what a
> > > coordinator interface should do differently (above question) is
> > > welcome because this is not something I am really comfortable with.
> >
> > I've updated the implementation to use the IFACE_COORD interface and it
> > works fine, besides one question below.
> >
> > Also, I read the spec once again (soon I'll sleep with it) and
> > actually what I extracted is that:
> >
> > * A FFD, when turned on, will perform a scan, then associate to any PAN
> >   it found (algorithm is beyond the spec) or otherwise create a PAN ID
> >   and start its own PAN. In both cases, it finishes its setup by
> >   starting to send beacons.
> >
> > * A RFD will behave more or less the same, without the PAN creation
> >   possibility of course. RFD-RX and RFD-TX are not required to support
> >   any of that, I'll assume none of the scanning features is suitable
> >   for them.
>
> Acutally, RFDs do not send beacons, AFAIU.
>
> > I have a couple of questions however:
> >
> > - Creating an interface (let's call it wpancoord) out of wpan0 means
> >   that two interfaces can be used in different ways and one can use
> >   wpan0 as a node while using wpancoord as a PAN coordinator. Is that
> >   really allowed? How should we prevent this from happening?
> >
> > - Should the device always wait for the user(space) to provide the PAN
> >   to associate to after the scan procedure right after the
> >   add_interface()? (like an information that must be provided prior to
> >   set the interface up?)
> >
> > - How does an orphan FFD should pick the PAN ID for a PAN creation?
> >   Should we use a random number? Start from 0 upwards? Start from
> >   0xfffd downwards? Should the user always provide it?
> >
> > - Should an FFD be able to create its own PAN on demand? Shall we
> >   allow to do that at the creation of the new interface?
>
> Additional questions:
>
>   - How is chosen the beacon order? Should we have a default value?
>     Should we default to 15 (not on a beacon enabled PAN)? Should we be
>     able to update this value during the lifetime of the PAN?
>

Is there no mib default value for this?

>   - The spec talks about the cluster topology, where a coordinator that
>     just associated to a PAN starts emitting beacons, which may enable
>     other devices in its range to ask to join the PAN (increased area
>     coverage). But then, there is no information about how the newly
>     added device should do to join the PAN coordinator which is anyway
>     out of range to require the association, transmit data, etc. Any
>     idea how this is supposed to work?
>

I think we should maybe add a feature for this later if we don't know
how it is supposed to work or there are still open questions and first
introduce the manual setup. After that, maybe things will become
clearer and we can add support for this part. Is this okay?

- Alex

