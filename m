Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 117D25AC096
	for <lists+netdev@lfdr.de>; Sat,  3 Sep 2022 20:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232361AbiICSVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Sep 2022 14:21:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbiICSVa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Sep 2022 14:21:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B1804C638
        for <netdev@vger.kernel.org>; Sat,  3 Sep 2022 11:21:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662229288;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9vUwm+ZLlJ49I/kvdB8M6Mu/W/Id29WXk+ZzGVSsdeY=;
        b=ION9KxBlpdOAHmSlJGMUHuAMP0SIEjez6E/l2zG7HwO75RA6yCSnjPKU+7Fpzq12tH7A81
        cOvOKD/0G/ktSt0jO7bBL02Za43HDfv4/d8L0kzISfIX33C7USx29hFPRcaS8RYrXcmQX1
        sY4W4N1qWkwEIQpYid3lTalEQV9+VgY=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-623-UltbrlMFPUW0uoFxuJ79WQ-1; Sat, 03 Sep 2022 14:21:27 -0400
X-MC-Unique: UltbrlMFPUW0uoFxuJ79WQ-1
Received: by mail-qt1-f199.google.com with SMTP id cm10-20020a05622a250a00b003437b745ccdso3907021qtb.18
        for <netdev@vger.kernel.org>; Sat, 03 Sep 2022 11:21:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=9vUwm+ZLlJ49I/kvdB8M6Mu/W/Id29WXk+ZzGVSsdeY=;
        b=Imoa4eJIfEIjYx3a1/g/a+QH65+sI7pYhk/VWAb4SCUyUOEVlf7EhjFxlvrxSDwFnv
         2K7znutfVevY9k3hoxVcp3W5PVBLDAYPIEVmtG/JMwbvsQV39iq5W3eZbP/Ec5qfRiJd
         +qKaV1TMoFsv3E2tWSVoDMbS+peG8hAMrriTRgB51PeiQhE59IxGQpfCD9pItTZpe2CJ
         83Rd/UTnqL/COfohyh08wLnCyw2vzCsRt1W3WIlAsVvnjxdDjYGPVCseamyVa9dsVznX
         S/G4ndyu8Rh4pylJbmi+UN+NyQj3hvdTnj7Pf/ICkWBmcOFHTL+x/8iQxVULd7R0ZCPf
         l3Qw==
X-Gm-Message-State: ACgBeo1/TP+RgT+9PtHkDH5S+mYmZeeVMfPwE9+yMHwrtDvjRmYZyXeM
        hVmyTcwifj4RXysa/bs01qWh2p2Pj4iEP+GpKOdqLovr2LYJWkZXNIcdFlDBe6HaDHOgk2A3pq3
        P0ATP0Qa48vw6NmaOW/m2gHw0TG9Xv/YS
X-Received: by 2002:a05:6214:5086:b0:499:2979:2df4 with SMTP id kk6-20020a056214508600b0049929792df4mr13266368qvb.2.1662229286577;
        Sat, 03 Sep 2022 11:21:26 -0700 (PDT)
X-Google-Smtp-Source: AA6agR65oJ1Qc8s8YzgUoRVDObKOWz/BWziJGs5Pajo4U0NT0AVw0EKynSHDFHkuMJlLC1rC8cjA4GdHotpbqyi8aR0=
X-Received: by 2002:a05:6214:5086:b0:499:2979:2df4 with SMTP id
 kk6-20020a056214508600b0049929792df4mr13266357qvb.2.1662229286249; Sat, 03
 Sep 2022 11:21:26 -0700 (PDT)
MIME-Version: 1.0
References: <20220701143052.1267509-1-miquel.raynal@bootlin.com>
 <20220823182950.1c722e13@xps-13> <CAK-6q+jfva++dGkyX_h2zQGXnoJpiOu5+eofCto=KZ+u6KJbJA@mail.gmail.com>
 <20220824122058.1c46e09a@xps-13> <CAK-6q+gjgQ1BF-QrT01JWh+2b3oL3RU+SoxUf5t7h3Hc6R8pcg@mail.gmail.com>
 <20220824152648.4bfb9a89@xps-13> <CAK-6q+itA0C4zPAq5XGKXgCHW5znSFeB-YDMp3uB9W-kLV6WaA@mail.gmail.com>
 <20220825145831.1105cb54@xps-13> <CAK-6q+j3LMoSe_7u0WqhowdPV9KM-6g0z-+OmSumJXCZfo0CAw@mail.gmail.com>
 <20220826095408.706438c2@xps-13> <CAK-6q+gxD0TkXzUVTOiR4-DXwJrFUHKgvccOqF5QMGRjfZQwvw@mail.gmail.com>
 <20220829100214.3c6dad63@xps-13> <CAK-6q+gJwm0bhHgMVBF_pmjD9zSrxxHvNGdTrTm0fG-hAmSaUQ@mail.gmail.com>
 <20220831173903.1a980653@xps-13> <20220901020918.2a15a8f9@xps-13>
 <20220901150917.5246c2d0@xps-13> <CAK-6q+g1Gnew=zWsnW=HAcLTqFYHF+P94Q+Ywh7Rir8J8cgCgw@mail.gmail.com>
 <20220903020829.67db0af8@xps-13> <CAK-6q+hO1i=xvXx3wHo658ph93FwuVs_ssjG0=jnphEe8a+gxw@mail.gmail.com>
 <20220903180556.6430194b@xps-13>
In-Reply-To: <20220903180556.6430194b@xps-13>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Sat, 3 Sep 2022 14:21:15 -0400
Message-ID: <CAK-6q+guC=eYQtUX=2wvhUTyNC+iNWSVuiBHC94soVUrLoBYGg@mail.gmail.com>
Subject: Re: [PATCH wpan-next 01/20] net: mac802154: Allow the creation of
 coordinator interfaces
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
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Sat, Sep 3, 2022 at 12:06 PM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hi Alexander,
>
> aahringo@redhat.com wrote on Sat, 3 Sep 2022 10:20:24 -0400:
>
> > Hi,
> >
> > On Fri, Sep 2, 2022 at 8:08 PM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > ...
> > > >
> > > > I am sorry, I never looked into Zephyr for reasons... Do they not have
> > > > something like /proc/interrupts look if you see a counter for your
> > > > 802.15.4 transceiver?
> > > >
> > > > > Also, can you please clarify when are we talking about software and
> > > > > when about hardware filters.
> > > > >
> > > >
> > > > Hardware filter is currently e.g. promiscuous mode on or off setting.
> > > > Software filtering is depending which receive path the frame is going
> > > > and which hardware filter is present which then acts like actually
> > > > with hardware filtering.
> > > > I am not sure if this answers this question?
> > >
> > > I think my understand gets clearer now that I've digged into Zephyr's
> > > ieee802154 layer and in the at86rf230 datasheet.
> > >
> >
> > okay, I think for zephyr questions you are here on the wrong mailinglist.
> >
> > > I will answer the previous e-mail but just for not I wanted to add that
> > > I managed to get Zephyr working, I had to mess around in the code a
> > > little bit and actually I discovered a net command which is necessary
> > > to use in order to turn the iface up, whatever.
> > >
> >
> > aha.
> >
> > > So I was playing with the atusb devices and I _think_ I've found a
> > > firmware bug or a hardware bug which is going to be problematic. In
> >
> > the firmware is open source, I think it's fine to send patches here (I
> > did it as well once for do a quick hack to port it to rzusb) the atusb
> > is "mostly" at the point that they can do open hardware from the
> > qi-hardware organization.
> >
> > > iface.c, when creating the interface, if you set the hardware filters
> > > (set_panid/short/ext_addr()) there is no way you will be able to get a
> > > fully transparent promiscuous mode. I am not saying that the whole
> >
> > What is a transparent promiscuous mode?
>
> I observe something very weird:
>
> A/ If at start up time we set promisc_mode(true) and then we set the hw
> address filters, all the frames are forwarded to the MAC.
>
> B/ If at start up time we set the hw address filters and then set
> promisc_mode(true), there is some filtering happening (like the Acks
> which are dropped by the PHY.
>
> I need to investigate this further because I don't get why in case B we
> don't have the same behavior than in case A.
>

Looking in the datasheet I see only set address filters -> then
setting promiscuous mode is specified? Not the other way around...

> > > promiscuous mode does not work anymore, I don't really know. What I was
> > > interested in were the acks, and getting them is a real pain. At least,
> > > enabling the promiscuous mode after setting the hw filters will lead to
> > > the acks being dropped immediately while if the promiscuous mode is
> > > enabled first (like on monitor interfaces) the acks are correctly
> > > forwarded by the PHY.
> >
> > If we would not disable AACK handling (means we receive a frame with
> > ack requested bit set we send a ack back) we would ack every frame it
> > receives (speaking on at86rf233).
>
> Yes, but when sending MAC frames I would like to:
> - be in promiscuous mode in Rx (tx paused) in order for the MAC to be
>   aware of the acks being received (unless there is another way to do
>   that, see below)
> - still ack the received frames automatically
>
> Unless we decide that we must only ack the expected frames manually?
>

We can't handle ack frames on mac802154 in my opinion. Or what does
manually mean?

Is the ack frame required as a mac command operation or as a response
to a transmitted frame because the other side will do retransmissions
if they don't see an ack back? The second case is not possible to
implement on mac802154, it must be offloaded.

> > > While looking at the history of the drivers, I realized that the
> > > TX_ARET mode was not supported by the firmware in 2015 (that's what you
> >
> > There exists ARET and AACK, both are mac mechanisms which must be
> > offloaded on the hardware. Note that those only do "something" if the
> > ack request bit in the frame is set.
>
> Absolutely (for the record, that's also an issue I had with Zephyr, I
> had to use the shell to explicitly ask the AR bit to be set in the
> outgoing frames, even though this in most MAC frames this is not a user
> choice, it's expected by the spec).
>

fyi: we have also a default_ackreq behaviour if we set the ack frame
on all data frames or not. However it's currently set to not set the
ackreq bit because most hardware outside can't handle it (even if
required by the spec). If you have a requirement to set ack request
bit then do it, if there is hardware outside which cannot handle it,
it's their problem. However the dataframes which are sent via user
space socket depending on the use case if they want to set it or not
but if they set it you need to know your network.

> > ARET will retransmit if no ack is received after some while, etc.
> > mostly coupled with CSMA/CA handling. We cannot guarantee such timings
> > on the Linux layer. btw: mac80211 can also not handle acks on the
> > software layer, it must be offloaded.
>
> On the Tx side, when sending eg. an association request or an
> association response, I must expect and wait for an ack. This is
> what I am struggling to do. How can I know that a frame which I just
> transmitted has been acked? Bonus points, how can I do that in such a
> way that it will work with other devices? (hints below)
>

You can't do this in mac802154 if there is a timing critical
requirement here. Is there a timing critical requirement here?

> > AACK will send a back if a frame with ack request bit was received.
> >
> > > say in a commit) I have seen no further updates about it so I guess
> > > it's still not available. I don't see any other way to know if a
> > > frame's ack has been received or not reliably.
> >
> > You implemented it for the at86rf230 driver (the spi one which is what
> > also atusb uses). You implemented the
> >
> > ctx->trac = IEEE802154_NO_ACK;
> >
> > which signals the upper layer that if the ack request bit is set, that
> > there was no ack.
> >
> > But yea, there is a missing feature for atusb yet which requires
> > firmware changes as well.
>
> :'(
>
> Let's say I don't have the time to update the firmware ;). I also assume
> that other transceivers (or even the drivers) might be limited on this
> regard as well. How should I handle those "I should wait for the ack to
> be received" situation while trying to associate?
>

If other transceivers cannot handle giving us feedback if ack was
received or not and we have the mandatory requirement to know it, it
is poor hardware/driver. As I said if the spec requires to check on an
ack or not we need to get his information, if the hardware/driver
can't deliver this... then just assume an ACK was received as it
returns TX_SUCCESS (or whatever the return value was). I said before
that some hardware will act weird if they don't support it.

> The tricky case is the device receiving the ASSOC_REQ:
> - the request is received
> - an ack must be sent (this is okay in most cases I guess)
> - the device must send an association response (also ok)
> - and wait for the response to be acked...
>         * either I use the promisc mode when sending the response
>           (because of possible race conditions) and I expect the ack to
>           be forwarded to the MAC
>                 -> This does not work on atusb, enabling promiscuous
>                 mode after the init does not turn the PHY into
>                 promiscuous mode as expected (discussed above)
>         * or I don't turn the PHY in promiscuous mode and I expect it
>           to return a clear status about if the ACK was received
>                 -> But this seem to be unsupported with the current
>                 ATUSB firmware, I fear other devices could have similar
>                 limitations
>         * or I just assume the acks are received blindly
>                 -> Not sure this is robust enough?
>

Assume you always get an ack back until somebody implements this
feature in their driver (It's already implemented so as they return
TX_SUCCESS). We cannot do much more I think... it is not robust but
then somebody needs to update the driver/firmware.

It's more weird if the otherside does not support AACK, because ARET
will send them 3 times (by default) the same frame. That's why we have
the policy to not set the ackreq bit if it's not required.

> What is your "less worse" choice?
>
> > Btw: I can imagine that hwsim "fakes" such
> > offload behaviours.
>
> My current implementation actually did handle all the acks (waiting for
> them and sending them) from the MAC. I'm currently migrating the ack
> sending part to the hw. For the reception, that's the big question.
>

In my opinion we should never deal with ack frames on mac802154 level,
neither on hwsim, this is an offloaded functionality. What I have in
mind is to fake a "TX_NO_ACK" return value as a probability parameter
to return it sometimes. E.g. as netem and drop rate, etc. Then we
could do some testing with it.

> > > Do you think I can just ignore the acks during an association in
> > > mac802154?
> >
> > No, even we should WARN_ON ack frames in states we don't expect them
> > because they must be offloaded on hardware.
> >
> > I am not sure if I am following what is wrong with the trac register
> > and NO_ACK, this is the information if we got an ack or not. Do you
> > need to turn off address filters while "an association"?
>
> If we have access to the TRAC register, I believe we no longer need to
> turn off address filters.
>

That sounds good.

- Alex

