Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7F361E848
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 02:32:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbiKGBcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 20:32:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbiKGBcD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 20:32:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1505F2BD0
        for <netdev@vger.kernel.org>; Sun,  6 Nov 2022 17:31:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667784665;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ebETVAMNkvMHZvPTstF2I92l5sYs3AarM6rtxf9EG84=;
        b=JgBXQrOrG9yQ1rGeKCMw8l1p0FC3YaH3rex7TTTOJG0rIOQRyXcBNUtorwnGXL/On4zcII
        7eks0B9GQw10z3IIDaHeFWWd+j96O6pC5YE2h6ErJkrvUzttyZFr0c45REkKXELxsUHwS3
        6e9L9uQOpfQC3uxZmK3wko8WtDSXEKU=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-657-DuxP_n4IM9-Wc5LFEhk0IQ-1; Sun, 06 Nov 2022 20:31:01 -0500
X-MC-Unique: DuxP_n4IM9-Wc5LFEhk0IQ-1
Received: by mail-ed1-f71.google.com with SMTP id y20-20020a056402271400b004630f3a32c3so7235392edd.15
        for <netdev@vger.kernel.org>; Sun, 06 Nov 2022 17:31:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ebETVAMNkvMHZvPTstF2I92l5sYs3AarM6rtxf9EG84=;
        b=2JI/X1tW3cApEnw/etaDfOapTLPwOkp8Lm5ZjacnsqsuVM54ry+UccOIRFu0rMin2Z
         KXrxqm/XulyLhn2Y+MH1Wk6wXXQWi01Xlp2mncrjLPJuGZQ/z5TYhbM59oI+8aGsS5vM
         C4W/PVlJUus4geTFH+4AIZPDWwf6VUp/9AgFTWlzebFFoVH1XQFOl7jl3UkjF8FRo2mf
         KJ1SaU6s/489fdIGOV6kt02rJ2amf1qp5Rni5WDFprYUExfMlERUtZ4+TqnipEjbW74/
         PmQYG4YqUROOByg3TQXMJQCLL4cU7DYUzpK7mbD6TS/Bc0U/9WV2VVGNqCfFSZA1G1xv
         HFTw==
X-Gm-Message-State: ANoB5pmA9w99d7xT2VlPOB5a47R4vqWs0Infj5X2Ak6Vx1muX67IYdOU
        tOFyO+o4LOlgDKvIrLEi+2s64mIoyzOmNCngeecEkJuFJQyH3gfMJEA/WdygFPcS1JYZ2FSoyQq
        yykTPl5d70IBArm2LHa/l56rlsZg7q5fQ
X-Received: by 2002:a17:907:9555:b0:7ae:5471:379c with SMTP id ex21-20020a170907955500b007ae5471379cmr7980295ejc.123.1667784660093;
        Sun, 06 Nov 2022 17:31:00 -0800 (PST)
X-Google-Smtp-Source: AA0mqf66RUi6hFWS8hj1ldTbSWZ6KW5nPncj1ehZuqnQe6BqqVvXnM4RJZ9gU9VVni07soe+Dmozp7CL/pxwFYxIoGE=
X-Received: by 2002:a17:907:9555:b0:7ae:5471:379c with SMTP id
 ex21-20020a170907955500b007ae5471379cmr7980279ejc.123.1667784659836; Sun, 06
 Nov 2022 17:30:59 -0800 (PST)
MIME-Version: 1.0
References: <20221026093502.602734-1-miquel.raynal@bootlin.com>
 <CAK-6q+jXPyruvdtS3jgzkuH=f599EiPk7vWTWLhREFCMj5ayNg@mail.gmail.com>
 <20221102155240.71a1d205@xps-13> <CAK-6q+hi1dhyfoYAGET55Ku=_in7BbNNaqWQVX2Z_iOg1+0Nyg@mail.gmail.com>
 <20221104191720.776d033e@xps-13>
In-Reply-To: <20221104191720.776d033e@xps-13>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Sun, 6 Nov 2022 20:30:48 -0500
Message-ID: <CAK-6q+j4pCQNj5paCAXMNvtHi9+DHxW8wZH2-ZpbxKgpbe8R0Q@mail.gmail.com>
Subject: Re: [PATCH wpan-next v2 0/3] IEEE 802.15.4: Add coordinator interfaces
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, Nov 4, 2022 at 2:17 PM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hi Alexander,
>
> aahringo@redhat.com wrote on Thu, 3 Nov 2022 20:55:38 -0400:
>
> > Hi,
> >
> > On Wed, Nov 2, 2022 at 10:52 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > >
> > > Hi Alexander,
> > >
> > > aahringo@redhat.com wrote on Sun, 30 Oct 2022 22:20:03 -0400:
> > >
> > > > Hi,
> > > >
> > > > On Wed, Oct 26, 2022 at 5:35 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > > > >
> > > > > Hello,
> > > > > These three patches allow the creation of coordinator interfaces, which
> > > > > were already defined without being usable. The idea behind is to use
> > > > > them advertizing PANs through the beaconing feature.
> > > > >
> > > >
> > > > I still don't know how exactly those "leaves" and "non-leaves" are
> > > > acting here regarding the coordinator interfaces. If this is just a
> > > > bit here to set in the interface I am fine with it. But yea,
> > > > "relaying" feature is a project on its own, as we said previously.
> > > >
> > > > Another mail I was asking myself what a node interface is then,
> > > > currently it is a mesh interface with none of those 802.15.4 PAN
> > > > management functionality?
> > >
> > > Not "none", because I would expect a NODE to be able to perform minimal
> > > management operations, such as:
> > > - scanning
> > > - requesting an association
> > > But in no case it is supposed to:
> > > - send beacons
> > > - manage associations
> > > - be the PAN coordinator
> > > - act as a relay
> > >
> >
> > perfect, thanks. But still there is something which I don't get.
> >
> > The split you mentioned about the functionality is for me being a
> > coordinator (IEEE spec) or pan coordinator (IEEE spec) which has the
> > additional functionality of "send beacons, manage assocs, act as
> > relay".
>
> I would expect any coordinator (IEEE spec) to be able to send beacons
> and relay (but in this case it only makes sense to send beacons if
> relaying is supported, IMHO).
>
> The PAN coordinator (IEEE spec) only has the following additional
> capability: managing assocs within the PAN. But in practice it is very
> likely that it is the one with the greater computational resources and
> the highest networking capabilities (it is usually the one which acts
> as a bridge with eg. the internet, says the spec).
>
> > So a coordinator (iftype) is a pan coordinator (IEEE spec) and a node
> > (iftype) is a coordinator (IEEE spec), but _only_ when it's
> > associated, before it is just a manually setup mesh node?
>
> Mmmh, actually this is not how I see it. My current mental model:
> - COORD (iftype) may act as:
>   * a leaf device (associating with the PAN coordinator, sending data)
>   * a coordinator (like above + beaconing and relaying) once associated
>   * a PAN coordinator (like above + assoc management) if the device
>     started the PAN or after a PAN coordinator handover.
>   Note: physically, it can only be authorized on FFD.
> - NODE (iftype) may only be a leaf device no matter its association
>   status, this is typically a sensor that sends data.
>   Note: can be authorized on any type of device (FFD or RFD).
>
> If I understand correctly, your idea was to change the interface type
> depending of the role of the device within the network. But IMHO the
> interface type should only be picked up once for all in the lifetime of
> the device. Of course we can switch from one to another by quickly
> turning off and on again the device, but this is not a common use case.
> We must keep in mind that PAN coordinator handover may happen, which
> means the interface must stay on but stop acting as the PAN
> coordinator. Using two different interface types for that is not
> impossible, but does not seem relevant to me.
>
> Would you agree?
>

Okay, I think that if you have a node then you never want to act as
any PAN coordinators functionality. And yes it seems complicated to
switch such functionality during runtime. I am fine with that. The
future will show if there are any "special" requirements and how we
could react here.

> > I hope it's clear when meaning iftype and when meaning IEEE spec, but
> > for the manual setup thing (node iftype) there is no IEEE spec,
> > although it is legal to do it in my opinion.
>
> It's clear, no problem. In my previous e-mails, when talking about the
> interfaces I used the uppercase NODE and COORD keywords, while I used
> the plain english lowercase "[leaf] node", "coordinator" or "PAN
> coordinator" words when talking about the IEEE definitions.
>

That is great, we should use those terms to make the difference.

Thanks.

- Alex

