Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1A1E552926
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 03:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240811AbiFUByv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 21:54:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbiFUByu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 21:54:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 972FD167DB
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 18:54:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655776486;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S/iPCoLZ7mJkyz+alWX/gHCh79oHM2jdy2kdd1CRF3M=;
        b=d7g/kc2uiXAZe50RAeo8rRwu8iLUIDIoX+hOSLUTSFYcrnFh1UiFByZBBeKR3msuUD9sWp
        xWR9tQ5LBpTzXVE7xgk2MxpJRA4JQ1oJu3C/Q1T5HTefxmqfj/dy4Ft/1sHMsgzhSP/9lE
        /hHthrmsbOv8cHcZ6vEA9E8jXMeNvZk=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-627-208H9DNlPc-EuP6CZCcRrQ-1; Mon, 20 Jun 2022 21:54:44 -0400
X-MC-Unique: 208H9DNlPc-EuP6CZCcRrQ-1
Received: by mail-qv1-f69.google.com with SMTP id b2-20020a0cb3c2000000b004703a79581dso6320804qvf.1
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 18:54:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=S/iPCoLZ7mJkyz+alWX/gHCh79oHM2jdy2kdd1CRF3M=;
        b=WHo6wPQsIkZoYXDU3zVyZ3yPqHrolUL/dhcNwxJyxe8ghkI1inFyNyaPoLhzmHoRvp
         o+lJP2WkhIMbhixYRqu56f/wv9bSHUnQJzz+1AgHE8KrdFmgGJ9eiHv6lc83A6lGhTjW
         JHV/J5r55RSvvPhGA+0EXeyVPs5V+5fmzJqO1i7t8pVaDer4pvXdCKHjoqOQzK/NHo8X
         FLzea1CpRBXEWOZMO9VxHRSUp/zYGxYENua1L4uQ1jYM0DggCqIafj5JDC3w00uKGB0t
         crVy/siqJAy2HvhIFiO0uAj/NENeBjysJ9xszHs/EIT3KghTEDrcOynpjxrYep4v5lwT
         6x0w==
X-Gm-Message-State: AJIora8q1L8enCfWHtt+IjG2sq4HDWj8fO47uAuSo6qI2616teN3mssS
        sLk1XIxFfC4SDlxmnHxik9Eq6wOVY8yE9LeGg1MQMx+50DkCXS/p8YJS3vIFTf7fMYbPHgvavto
        AA4dZaqc7mHNEKkUvGyO1inqIDSSr3K2i
X-Received: by 2002:a37:7d0:0:b0:6a6:ad21:b4f9 with SMTP id 199-20020a3707d0000000b006a6ad21b4f9mr17586574qkh.27.1655776484388;
        Mon, 20 Jun 2022 18:54:44 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tz8nx2J7QJCsaMZUxJrazjch9Pniv7xfkvPEwoSlPOZDJqzR6KjYM+eDsRyTdxRt3Wex8Lo2qkf08NkG90OxI=
X-Received: by 2002:a37:7d0:0:b0:6a6:ad21:b4f9 with SMTP id
 199-20020a3707d0000000b006a6ad21b4f9mr17586566qkh.27.1655776484104; Mon, 20
 Jun 2022 18:54:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220603182143.692576-1-miquel.raynal@bootlin.com>
 <20220603182143.692576-2-miquel.raynal@bootlin.com> <CAK-6q+hAZMqsN=S9uWAm4rTN+uZwz7_L42=emPHz7+MvfW6ZpQ@mail.gmail.com>
 <20220606174319.0924f80d@xps-13> <CAK-6q+itswJrmy-AhZ5DpnHH0UsfAeTPQTmX8WfG8=PteumVLg@mail.gmail.com>
 <20220607181608.609429cb@xps-13> <20220608154749.06b62d59@xps-13>
 <CAK-6q+iOG+r8fFa6_x4egHBUxxGLE+sYf2fKvPkY5T-MvvGiCQ@mail.gmail.com>
 <20220609175217.21a9acee@xps-13> <CAK-6q+jchHcge2_hMznO6fwx=xoUEpmoZTFYLAUwqM2Ue4Lx-A@mail.gmail.com>
 <20220617171256.2261a99e@xps-13> <CAK-6q+i-77wXoTN0vXi4s-sv20d13x+2fMpw4TB9dDyXAhjOGA@mail.gmail.com>
 <20220620111922.51189382@xps-13>
In-Reply-To: <20220620111922.51189382@xps-13>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Mon, 20 Jun 2022 21:54:33 -0400
Message-ID: <CAK-6q+jR00MD+W02AAH8P5xG7hUD-x8NEnOG_W3mifj=6ybBzg@mail.gmail.com>
Subject: Re: [PATCH wpan-next 1/6] net: ieee802154: Drop coordinator interface type
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        Alexander Aring <alex.aring@gmail.com>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Jun 20, 2022 at 5:19 AM Miquel Raynal <miquel.raynal@bootlin.com> w=
rote:
...
> >
> > > - Beacons can only be sent when part of a PAN (PAN ID !=3D 0xffff).
> >
> > I guess that 0xffff means no pan is set and if no pan is set there is n=
o pan?
>
> Yes, Table 8-94=E2=80=94MAC PIB attributes states:
>
>         "The identifier of the PAN on which the device is operating. If
>         this value is 0xffff, the device is not associated."
>

I am not sure if I understand this correctly but for me sending
beacons means something like "here is a pan which I broadcast around"
and then there is "'device' is not associated". Is when "associated"
(doesn't matter if set manual or due scan/assoc) does this behaviour
implies "I am broadcasting my pan around, because my panid is !=3D
0xffff" ?

> > > - The choice of the beacon interval is up to the user, at any moment.
> > > OTHER PARAMETERS
> >
> > I would say "okay", there might be an implementation detail about when
> > it's effective.
> > But is this not only required if doing such "passive" mode?
>
> The spec states that a coordinator can be in one of these 3 states:
> - Not associated/not in a PAN yet: it cannot send beacons nor answer
>   beacon requests

so this will confirm, it should send beacons if panid !=3D 0xffff (as my
question above)?

> - Associated/in a PAN and in this case:
>     - It can be configured to answer beacon requests (for other
>       devices performing active scans)
>     - It can be configured to send beacons "passively" (for other
>       devices performing passive scans)
>
> In practice we will let to the user the choice of sending beacons
> passively or answering to beacon requests or doing nothing by adding a
> fourth possibility:
>     - The device is not configured, it does not send beacons, even when
>       receiving a beacon request, no matter its association status.
>

Where is this "user choice"? I mean you handle those answers for
beacon requests in the kernel?

> > > - The choice of the channel (page, etc) is free until the device is
> > >   associated to another, then it becomes fixed.
> > >
> >
> > I would say no here, because if the user changes it it's their
> > problem... it's required to be root for doing it and that should be
> > enough to do idiot things?
>
> That was a proposal to match the spec, but I do agree we can let the
> user handle this, so I won't add any checks regarding channel changes.
>

okay.

> > > ASSOCIATION (to be done)
> > > - Device association/disassociation procedure is requested by the
> > >   user.
> >
> > This is similar like wireless is doing with assoc/deassoc to ap.
>
> Kind of, yes.
>

In the sense of "by the user" you don't mean putting this logic into
user space you want to do it in kernel and implement it as a
netlink-op, the same as wireless is doing? I just want to confirm
that. Of course everything else is different, but from this
perspective it should be realized.

> > > - Accepting new associations is up to the user (coordinator only).
> >
> > Again implementation details how this should be realized.
>
> Any coordinator can decide whether new associations are possible or
> not. There is no real use case besides this option besides the memory
> consumption on limited devices. So either we say "we don't care about
> that possible limitation on Linux systems" or "let's add a user
> parameter which tells eg. the number of devices allowed to associate".
>
> What's your favorite?
>

Sure there should be a limitation about how many pans should be
allowed, that is somehow the bare minimum which should be there.
I was not quite sure how the user can decide of denied assoc or not,
but this seems out of scope for right now...

> > > - If the device has no parent (was not associated to any device) it i=
s
> > >   PAN coordinator and has additional rights regarding associations.
> > >
> >
> > No idea what a "device' here is, did we not made a difference between
> > "coordinator" vs "PAN coordinator" before and PAN is that thing which
> > does some automatically scan/assoc operation and the other one not? I
> > really have no idea what "device" here means.
>
> When implementing association, we need to keep track of the
> parent/child relationship because we may expect coordinators to
> propagate messages from leaf node up to their parent. A device without
> parent is then the PAN coordinator. Any coordinator may advertise the
> PAN and subsequent devices may attach to it, this is creating a tree of
> nodes.
>


Who is keeping track of this relationship? So we store pans which we
found with a whole "subtree" attached to it?

btw: that sounds similar to me to what RPL is doing...,

- Alex

