Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC11C67DB4B
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 02:32:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229446AbjA0Bco (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 20:32:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233076AbjA0Bck (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 20:32:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC7EA5A373
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 17:31:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674783112;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IB23jpjOWwiScZrdSNH97m0VWtfdPWv6VI1/PnikCEM=;
        b=eTcp5+es5SCV4KSeVmZPkOPOro0Z9ZPR7V90g1v5qPfpDjhXlvN9z5zbhRyvpaJSXC32O/
        14yIKbZYCQ7uE7MT+B6TMS72p5I/VxepFYC/PlvBDSM16LUGVk0musBti3uLCDk46wXe7B
        VYNdWbNQLSJEWX54MyhoSR697CSeVeQ=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-635-SBScDNgoMjiNPiYJ9Lrxng-1; Thu, 26 Jan 2023 20:31:50 -0500
X-MC-Unique: SBScDNgoMjiNPiYJ9Lrxng-1
Received: by mail-ej1-f72.google.com with SMTP id du14-20020a17090772ce00b0087108bbcfa6so2338643ejc.7
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 17:31:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IB23jpjOWwiScZrdSNH97m0VWtfdPWv6VI1/PnikCEM=;
        b=3WQBgzOKfIi1BZa8+fKo6I3uEL+EUcPJpCmX3AY0mfiNM52s+oRvI+Sjwf+H4X0NAc
         6NWMm5TOIW+CsFRjFqiY+T67N2p+ikiqxdEYwAIQ4EfD6vzb9i8VqwAsP2E4is1+lzqG
         fzZv4IDRi/JoLzO8AzCvZhjey/Dr3U9AKM/9Yfl2WfUWvzdvapCZOm4m156vp48BFQMi
         Or/s/3kryf1nwXRKbeirHO13D9l2NW7go1ffj37bLN6tzb4dXZ4XEuaGCgvbAUNDh6iB
         eTz4nv7IvGdGGBB4b2TLDEIpW0UHqIqaYYKLaU0Ik7b1d3AvGqajXrZNlWEST9ZCyYsv
         /pHA==
X-Gm-Message-State: AO0yUKXflffb5UPs9kUKRJgEf9lG5+NM4pDaBv+tf+f2smdFT5RyJffD
        01qjr/iNe2N+Qbwe6lIZt75UCA8CbJDsm9KZA9xb6k9SDpsv9yMCmqQ/5skduqbxCLB4Q6k1LDd
        ro9UZPiwrBIL+3UCYCTYJAJraJ01DPr60
X-Received: by 2002:a05:6402:175c:b0:4a0:8f64:cddc with SMTP id v28-20020a056402175c00b004a08f64cddcmr2404091edx.58.1674783108958;
        Thu, 26 Jan 2023 17:31:48 -0800 (PST)
X-Google-Smtp-Source: AK7set/2jvzyMlmz6D/Vs0gWxbOhYdccx+gT9KnuRKuRgtwviUbQXvqD3SsNfJ8OZen2ynIbvvDnpdk+/hXt5Zho8+k=
X-Received: by 2002:a05:6402:175c:b0:4a0:8f64:cddc with SMTP id
 v28-20020a056402175c00b004a08f64cddcmr2404088edx.58.1674783108718; Thu, 26
 Jan 2023 17:31:48 -0800 (PST)
MIME-Version: 1.0
References: <20230106113129.694750-1-miquel.raynal@bootlin.com>
 <CAK-6q+jNmvtBKKxSp1WepVXbaQ65CghZv3bS2ptjB9jyzOSGTA@mail.gmail.com>
 <20230118102058.3b1f275b@xps-13> <CAK-6q+gwP8P--5e9HKt2iPhjeefMXrXUVy-G+szGdFXZvgYKvg@mail.gmail.com>
 <CAK-6q+gn7W9x2+ihSC41RzkhmBn1E44pKtJFHgqRdd8aBpLrVQ@mail.gmail.com>
 <20230124110814.6096ecbe@xps-13> <CAB_54W69KcM0UJjf8py-VyRXx2iEUvcAKspXiAkykkQoF6ccDA@mail.gmail.com>
 <20230125105653.44e9498f@xps-13> <CAK-6q+irhYroxV_P5ORtO9Ui9-Bs=SNS+vO5bZ7_X-geab+XrA@mail.gmail.com>
In-Reply-To: <CAK-6q+irhYroxV_P5ORtO9Ui9-Bs=SNS+vO5bZ7_X-geab+XrA@mail.gmail.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Thu, 26 Jan 2023 20:31:37 -0500
Message-ID: <CAK-6q+h6Xfa3x2XMjhgrw15LyQDGtfR7f+qgQDkSarteKqWaZA@mail.gmail.com>
Subject: Re: [PATCH wpan-next 0/2] ieee802154: Beaconing support
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

On Thu, Jan 26, 2023 at 8:29 PM Alexander Aring <aahringo@redhat.com> wrote:
>
> Hi,
>
> On Wed, Jan 25, 2023 at 5:00 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> >
> > Hi Alexander,
> >
> > alex.aring@gmail.com wrote on Tue, 24 Jan 2023 21:31:33 -0500:
> >
> > > Hi,
> > >
> > > On Tue, Jan 24, 2023 at 5:08 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > > >
> > > > Hi Alexander,
> > > >
> > > > aahringo@redhat.com wrote on Mon, 23 Jan 2023 09:02:48 -0500:
> > > >
> > > > > Hi,
> > > > >
> > > > > On Mon, Jan 23, 2023 at 9:01 AM Alexander Aring <aahringo@redhat.com> wrote:
> > > > > >
> > > > > > Hi,
> > > > > >
> > > > > > On Wed, Jan 18, 2023 at 4:21 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > > > > > >
> > > > > > > Hi Alexander,
> > > > > > >
> > > > > > > aahringo@redhat.com wrote on Sun, 15 Jan 2023 20:54:02 -0500:
> > > > > > >
> > > > > > > > Hi,
> > > > > > > >
> > > > > > > > On Fri, Jan 6, 2023 at 6:33 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > > > > > > > >
> > > > > > > > > Scanning being now supported, we can eg. play with hwsim to verify
> > > > > > > > > everything works as soon as this series including beaconing support gets
> > > > > > > > > merged.
> > > > > > > > >
> > > > > > > >
> > > > > > > > I am not sure if a beacon send should be handled by an mlme helper
> > > > > > > > handling as this is a different use-case and the user does not trigger
> > > > > > > > an mac command and is waiting for some reply and a more complex
> > > > > > > > handling could be involved. There is also no need for hotpath xmit
> > > > > > > > handling is disabled during this time. It is just an async messaging
> > > > > > > > in some interval and just "try" to send it and don't care if it fails,
> > > > > > > > or? For mac802154 therefore I think we should use the dev_queue_xmit()
> > > > > > > > function to queue it up to send it through the hotpath?
> > > > > > > >
> > > > > > > > I can ack those patches, it will work as well. But I think we should
> > > > > > > > switch at some point to dev_queue_xmit(). It should be simple to
> > > > > > > > switch it. Just want to mention there is a difference which will be
> > > > > > > > there in mac-cmds like association.
> > > > > > >
> > > > > > > I see what you mean. That's indeed true, we might just switch to
> > > > > > > a less constrained transmit path.
> > > > > > >
> > > > > >
> > > > > > I would define the difference in bypass qdisc or not. Whereas the
> > > > > > qdisc can drop or delay transmitting... For me, the qdisc is currently
> > > > > > in a "works for now" state.
> > > > >
> > > > > probably also bypass other hooks like tc, etc. :-/ Not sure if we want that.
> > > >
> > > > Actually, IIUC, we no longer want to go through the entire net stack.
> > > > We still want to bypass it but without stopping/flushing the full
> > > > queue like with an mlme transmission, so what about using
> > > > ieee802154_subif_start_xmit() instead of dev_queue_xmit()? I think it
> > > > is more appropriate.
> > >
> > > I do not understand, what do we currently do with mlme ops via the
> > > ieee802154_subif_start_xmit() function, or? So we bypass everything
> > > from dev_queue_xmit() until do_xmit() netdev callback.
> >
> > Yes, that's the plan. We don't want any of the net stack features when
> > sending beacons.
> >
> > > I think it is fine, also I think "mostly" only dataframes should go
> > > through dev_queue_xmit(). With a HardMAC transceiver we would have
> > > control about "mostly" other frames than data either. So we should do
> > > everything with mlme-ops do what the spec says (to match up with
> > > HardMAC behaviour?) and don't allow common net hooks/etc. to change
> > > this behaviour?
> >
> > To summarize:
> > - Data frames -> should go through dev_queue_xmit()
>
> there are exceptions... e.g. AF_PACKET raw sockets can build whatever
> it wants (but it will probably not being supported by HardMAC
> transceivers) and send it out. There is no real control about it. So
> mostly I would agree here.
>

with "no real control" I mean the user needs to know what it's doing
there and maybe the user just wants to play around e.g. monitor
interface sending, whereas a monitor does not have an address being
set up.

- Alex

