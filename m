Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3601563373
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 14:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234233AbiGAMXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 08:23:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233243AbiGAMXs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 08:23:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B81FF192B3
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 05:23:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656678225;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PkXtsdRXd6BtH+3mU5ikqLfB8ljxJTyJjy1+V+U+W6c=;
        b=OgWkw26TLE+cPinEyIYtA1A266lWhBerFovxonulQ8w2CQ12WPOKZ+2yk4dW+0/sau9MC1
        X5+hhDixaxLzvYCOkztHx3yLJqKkTLNumybTbxCeR1X2Ik+7CS4UcLwZaNjd4YQE2G1U89
        /WAGFLSINOyxp5b2UiINPHhZg9GQufs=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-449-A0XoHH1FNv6BteCV2fennw-1; Fri, 01 Jul 2022 08:23:44 -0400
X-MC-Unique: A0XoHH1FNv6BteCV2fennw-1
Received: by mail-qt1-f197.google.com with SMTP id l9-20020ac84589000000b00317cd1e6ef4so267321qtn.23
        for <netdev@vger.kernel.org>; Fri, 01 Jul 2022 05:23:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PkXtsdRXd6BtH+3mU5ikqLfB8ljxJTyJjy1+V+U+W6c=;
        b=MrY9mQjYvJOjXx145TRjjLgBWTbpPqb9fKQS1hJrSy2mpwNYa1t2bQYgVMEBRID+Cd
         n9nlVepMf+Vnc3AChqMqmtn69BA6W4v8xjzfN0ns7vfue6xz8/5PfPSwOJeGrbvDTpQ8
         fHfn32NPP5BSoGR7MRE6oYF89dBw4dV9LFe61tPJ3HE/dQlTvg+WdKjf5rSFyYgExgqy
         4crDH4Wu0pDYD7IfBApWyHnjVBQUqyzmzTOq/QRuqOfqLGCnqYmpdqnBMOtT9A6Op6N6
         brCspit4VL0/wiCLIEbSDu4QdXSiNwP3Tlj+j42YaBclkda7p4F/JGF7eRXmsKiDctAp
         yOMQ==
X-Gm-Message-State: AJIora/inRiSdKDcdtatoXRrcyiz0cOTEfmcET+oKNm2zQ2u96I13KHl
        x/QC0wgcjL3Ppojq+0q6QkKEytDMrRfFZ1wJ7V1/p4TiaEJ3yZqFgJWlmloeblkKaFAmNJbiJ+w
        KDwwp8oUlObswCXQvucjM+tfnLvDOtVom
X-Received: by 2002:a05:620a:4723:b0:6af:46a2:8531 with SMTP id bs35-20020a05620a472300b006af46a28531mr10325042qkb.177.1656678224089;
        Fri, 01 Jul 2022 05:23:44 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1u3Ss0DwUx1PhK8u7hImSVQqBY/s9uBvmovyCQukCgw4tbRUVbH694GfFv9NkFHjvRbjwLo++brkzLuokKgQjM=
X-Received: by 2002:a05:620a:4723:b0:6af:46a2:8531 with SMTP id
 bs35-20020a05620a472300b006af46a28531mr10325019qkb.177.1656678223754; Fri, 01
 Jul 2022 05:23:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220620134018.62414-1-miquel.raynal@bootlin.com>
 <20220620134018.62414-3-miquel.raynal@bootlin.com> <CAK-6q+jAhikJq5tp-DRx1C_7ka5M4w6EKUB_cUdagSSwP5Tk_A@mail.gmail.com>
 <20220627104303.5392c7f6@xps-13> <CAK-6q+jYFeOyP_bvTd31av=ntJA=Qpas+v+xRDQuMNb74io2Xw@mail.gmail.com>
 <20220628095821.36811c5c@xps-13> <CAK-6q+g=Bbj7gS5a+fSqCsB9n=xrZK-z0-Rg9dn9yFK5xpZsvw@mail.gmail.com>
 <20220630101416.4dc42f29@xps-13> <CAK-6q+gR-+9K2LtwwVQQMmMcmmkG399jUgyd-X3Nj8xh0y+jBQ@mail.gmail.com>
 <20220701025012.5dd38c81@xps-13>
In-Reply-To: <20220701025012.5dd38c81@xps-13>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Fri, 1 Jul 2022 08:23:32 -0400
Message-ID: <CAK-6q+g4=jrO+kGVyimNi1HCC_PShL0fwitCuTRv4-5LBKJuKw@mail.gmail.com>
Subject: Re: [PATCH wpan-next v3 2/4] net: ieee802154: Add support for inter
 PAN management
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Network Development <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, Jun 30, 2022 at 8:50 PM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hi Alexander,
>
> aahringo@redhat.com wrote on Thu, 30 Jun 2022 19:27:49 -0400:
>
> > Hi,
> >
> > On Thu, Jun 30, 2022 at 4:14 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > >
> > > Hi Alexander,
> > >
> > > aahringo@redhat.com wrote on Wed, 29 Jun 2022 21:40:14 -0400:
> > >
> > > > Hi,
> > > >
> > > > On Tue, Jun 28, 2022 at 3:58 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > > > >
> > > > > Hi Alexander,
> > > > >
> > > > > aahringo@redhat.com wrote on Mon, 27 Jun 2022 21:32:08 -0400:
> > > > >
> > > > > > Hi,
> > > > > >
> > > > > > On Mon, Jun 27, 2022 at 4:43 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > > > > > >
> > > > > > > Hi Alexander,
> > > > > > >
> > > > > > > aahringo@redhat.com wrote on Sat, 25 Jun 2022 22:29:08 -0400:
> > > > > > >
> > > > > > > > Hi,
> > > > > > > >
> > > > > > > > On Mon, Jun 20, 2022 at 10:26 AM Miquel Raynal
> > > > > > > > <miquel.raynal@bootlin.com> wrote:
> > > > > > > > >
> > > > > > > > > Let's introduce the basics for defining PANs:
> > > > > > > > > - structures defining a PAN
> > > > > > > > > - helpers for PAN registration
> > > > > > > > > - helpers discarding old PANs
> > > > > > > > >
> > > > > > > >
> > > > > > > > I think the whole pan management can/should be stored in user space by
> > > > > > > > a daemon running in background.
> > > > > > >
> > > > > > > We need both, and currently:
> > > > > > > - while the scan is happening, the kernel saves all the discovered PANs
> > > > > > > - the kernel PAN list can be dumped (and also flushed) asynchronously by
> > > > > > >   the userspace
> > > > > > >
> > > > > > > IOW the userspace is responsible of keeping its own list of PANs in
> > > > > > > sync with what the kernel discovers, so at any moment it can ask the
> > > > > > > kernel what it has in memory, it can be done during a scan or after. It
> > > > > > > can request a new scan to update the entries, or flush the kernel list.
> > > > > > > The scan operation is always requested by the user anyway, it's not
> > > > > > > something happening in the background.
> > > > > > >
> > > > > >
> > > > > > I don't see what advantage it has to keep the discovered pan in the
> > > > > > kernel. You can do everything with a start/stop/pan discovered event.
> > > > >
> > > > > I think the main reason is to be much more user friendly. Keeping track
> > > > > of the known PANs in the kernel matters because when you start working
> > > > > with 802.15.4 you won't blindly use a daemon (if there is any) and will
> > > > > use test apps like iwpan which are stateless. Re-doing a scan on demand
> > > > > just takes ages (from seconds to minutes, depending on the beacon
> > > > > order).
> > > > >
> > > >
> > > > I can see that things should work "out-of the box" and we are already
> > > > doing it by manual setting pan_id, etc. However, doing it in an
> > > > automatic way there exists a lot of "interpretation" about how you
> > > > want to handle it (doesn't matter if this is what the spec says or
> > > > not)... moving it to user space will offload it to the user.
> > > >
> > > > > Aside from this non technical reason, I also had in mind to retrieve
> > > > > values gathered from the beacons (and stored in the PAN descriptors) to
> > > > > know more about the devices when eg. listing associations, like
> > > > > registering the short address of a coordinator. I don't yet know how
> > > > > useful this is TBH.
> > > > >
> > > > > > It also has more advantages as you can look for a specific pan and
> > > > > > stop afterwards. At the end the daemon has everything that the kernel
> > > > > > also has, as you said it's in sync.
> > > > > >
> > > > > > > > This can be a network manager as it
> > > > > > > > listens to netlink events as "detect PAN xy" and stores it and
> > > > > > > > offers it in their list to associate with it.
> > > > > > >
> > > > > > > There are events produced, yes. But really, this is not something we
> > > > > > > actually need. The user requests a scan over a given range, when the
> > > > > > > scan is over it looks at the list and decides which PAN it
> > > > > > > wants to associate with, and through which coordinator (95% of the
> > > > > > > scenarii).
> > > > > > >
> > > > > >
> > > > > > This isn't either a kernel job to decide which pan it will be
> > > > > > associated with.
> > > > >
> > > > > Yes, "it looks at the list and decides" referred to "the user".
> > > > >
> > > > > > > > We need somewhere to draw a line and I guess the line is "Is this
> > > > > > > > information used e.g. as any lookup or something in the hot path", I
> > > > > > > > don't see this currently...
> > > > > > >
> > > > > > > Each PAN descriptor is like 20 bytes, so that's why I don't feel back
> > > > > > > keeping them, I think it's easier to be able to serve the list of PANs
> > > > > > > upon request rather than only forwarding events and not being able to
> > > > > > > retrieve the list a second time (at least during the development).
> > > > > > >
> > > > > >
> > > > > > This has nothing to do with memory.
> > > > > >
> > > > > > > Overall I feel like this part is still a little bit blurry because it
> > > > > > > has currently no user, perhaps I should send the next series which
> > > > > > > actually makes the current series useful.
> > > > > > >
> > > > > >
> > > > > > Will it get more used than caching entries in the kernel for user
> > > > > > space? Please also no in-kernel association feature.
> > > > >
> > > > > I am aligned on this.
> > > > >
> > > >
> > > > I am sorry I am not sure what that means.
> > >
> > > I was referring to the "no in-kernel association feature".
> > >
> > > There is however one situation which I _had_ to be handled in the
> > > kernel: other devices asking for being associated or disassociated. In
> > > the case of the disassociation, the receiving device is only notified
> > > and cannot refuse the disassociation. For the association however,
> > > the device receiving the association request has to make a decision.
> > > There are three possible outcomes:
> > > - accepting
> > > - refusing because the PAN is at capacity
> > > - refusing because the device is blacklisted
> >
> > Why not move this decision to the user as well? The kernel will wait
> > for the reason? This isn't required to be fast and the decision may
> > depend on the current pan management...
>
> I've opted out for the simplest option, which is allowing X devices
> being associated, X being manageable by the user. For now I'll keep
> this very simple approach, I propose we add this filtering feature
> later?
>

What I suggest here is to move the filtering logic into the user
space. If the interface is a coordinator it will trigger an event for
the user and waits for an upper layer user space logic to get an
answer back what to do as answer.

However as I said I don't force you to program a user space software
which does that job but you code should be prepared to be get replaced
by such handling.

> > > For now I've only implemented the first reason, because it's much
> > > easier and only requires a maximum device number variable, set by the
> > > user. For the second reason, it requires handling a
> > > whitelist/blacklist, I don't plan to implement this for now, but that
> > > should not impact the rest of the code. I'll let that to other
> > > developers, or future-me, perhaps :-). Anyhow, you can kick-out devices
> > > at any time anyway if needed with a disassociation notification
> > > controlled by the user.
> > >
> > > > > > We can maybe agree to that point to put it under
> > > > > > IEEE802154_NL802154_EXPERIMENTAL config, as soon as we have some
> > > > > > _open_ user space program ready we will drop this feature again...
> > > > > > this program will show that there is no magic about it.
> > > > >
> > > > > Yeah, do you want to move all the code scan/beacon/pan/association code
> > > > > under EXPERIMENTAL sections? Or is it just the PAN management logic?
> > > >
> > > > Yes, why not. But as I can see there exists two categories of
> > > > introducing your netlink api:
> > > >
> > > > 1. API candidates which are very likely to become stable
> > > > 2. API candidates which we want to remove when we have a user
> > > > replacement for it (will probably never go stable)
> > > >
> > > > The 2. should be defining _after_ the 1. In the "big" netlink API
> > > > enums of EXPERIMENTAL sections.
> > >
> > > Yeah, got it.
> > >
> > > > Also you should provide for 2. some kind of ifdef/functions dummy/etc.
> > > > that it's easy to remove from the kernel when we have a user
> > > > replacement for it.
> > > > I hope that is fine for everybody.
> > > >
> > > > I try to find solutions here, I don't see a reason for putting this
> > > > pan management into the kernel... whereas I appreciate the effort
> > > > which is done here and will not force you to write some user space
> > > > software that does this job. From my point of view I can't accept this
> > > > functionality in the kernel "yet".
> > >
> > > I've already spent a couple of days reworking all that part, I've
> > > dropped most of the in-kernel PAN management, which means:
> > > - when a new coordinator gets discovered (beacon received), if the mac
> > >   was scanning then it calls a generic function from the cfg layer to
> > >   advertise this pan.
> > > - the cfg layer will send a NL message to the user with all the
> > >   important information
> > > - BUT the cfg layer will also keep in memory the beacon information for
> > >   the time of the scan (only), to avoid polluting the user with the same
> > >   information over and over again, this seems a necessary step to me,
> > >   because otherwise if you track on the same channel two coordinators
> > >   not emitting at the same pace, you might end up with 100 user
> > >   notifications, for just 2 devices. I think this is the kernel duty to
> > >   filter out identical beacons.
> > >
> >
> > Okay, I am sure if somebody complains about such kernel behaviour and
> > has a good argument to switch back... we still can do it.
>
> Great!
>

I would say more here... there might be some API documentation where
you cannot expect anything from the kernel but it tries to avoid
stupid things (Whatever that means). As the API is experimental it can
be easily changed, otherwise some additional flag is required to
enable this feature or not. However I can say more about this when I
see code and we have some user experience about whatever the default
behaviour should be or such flag is really necessary.

We probably will find some solution...

- Alex

