Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D2795A412A
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 04:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229379AbiH2Cwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Aug 2022 22:52:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbiH2Cwa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Aug 2022 22:52:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E4AB3CBFF
        for <netdev@vger.kernel.org>; Sun, 28 Aug 2022 19:52:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661741547;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4n40w7lsU3SEBOvBDWsTJ4TGPpjka0ekmbhmMJ3GL5Y=;
        b=LEcJ5BYDcqRMpfGDmvoh5M1kThCDeXyWOjUxrjml4uCEyNm2WccI2eYepWAeIcF8mBUcKV
        Kvr+AUJTzhluBe5Q+jM8bj9ItHJ1tXqSY0r/VtwETaCpIU6RAENKFIF4RY6vxkoFW/q5t0
        K/6+Zakx13okVIDZlE3qCxQat9PMiH0=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-557-hNgpLPq6NLupgc8MmH9a-w-1; Sun, 28 Aug 2022 22:52:26 -0400
X-MC-Unique: hNgpLPq6NLupgc8MmH9a-w-1
Received: by mail-qt1-f199.google.com with SMTP id v13-20020a05622a188d00b00343794bd1daso5604284qtc.23
        for <netdev@vger.kernel.org>; Sun, 28 Aug 2022 19:52:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=4n40w7lsU3SEBOvBDWsTJ4TGPpjka0ekmbhmMJ3GL5Y=;
        b=dPhS9sltvL6I2fac4rQNgL7ohq4ixgEwgOKOaVJAVRdcIT/ZL7gFiQWpYUeAe00ee+
         llRAuMvs5kYEQF+YhYpcq2pqFNnuaQX4DhHx88JUi1zuwoQzzVjeXb0WdS/QrO3FOLpC
         WR7afEaGoem7ppPEBQe8s1ifEYN0zbbpVeYrrJi6PCojWUlL8gK2mCB+4KAsiQaQrBwd
         QQgQzkS8enQCmnounUWy+LEmDRZ1QfVEi/XuAp+m/aHQDOsHk845WxkTKqGJaSBmtP4n
         AmuQHiabeZBqsLOVRfsh1atiIx0QgkUJwZ8EJ8RvoQy/+X8QmHDw7MA/h3Mnzv5J69bC
         TdHw==
X-Gm-Message-State: ACgBeo3fysANNwZOyVUvbvcDLmpvPkT0XGlfdPYI4vBLYiyAmQoOyrb0
        ++IchhmZfR4w1PcZcYh6q3FSjzo4BR/KZG7ovAafkVdVXgScZtbzX6fGT4vSIVuAI/ZzSvvWWc9
        ECTMBuhgihziOnYbCg+LJ8lOUXV/XUrfT
X-Received: by 2002:a37:b741:0:b0:6b9:3b67:d0a7 with SMTP id h62-20020a37b741000000b006b93b67d0a7mr6731110qkf.770.1661741545624;
        Sun, 28 Aug 2022 19:52:25 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5PWu0DF6Ip/YxW/aQhnHRzLQMR6Ngk1uL7SJq93ZQkHbYYwCdhx9wztpNST/cyKkVAhZgm3+aCkaIQpta9lec=
X-Received: by 2002:a37:b741:0:b0:6b9:3b67:d0a7 with SMTP id
 h62-20020a37b741000000b006b93b67d0a7mr6731098qkf.770.1661741545354; Sun, 28
 Aug 2022 19:52:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220701143052.1267509-1-miquel.raynal@bootlin.com>
 <20220701143052.1267509-2-miquel.raynal@bootlin.com> <CAK-6q+jkUUjAGqEDgU1oJvRkigUbvSO5SXWRau6+320b=GbfxQ@mail.gmail.com>
 <20220819191109.0e639918@xps-13> <CAK-6q+gCY3ufaADHNQWJGNpNZJMwm=fhKfe02GWkfGEdgsMVzg@mail.gmail.com>
 <20220823182950.1c722e13@xps-13> <CAK-6q+jfva++dGkyX_h2zQGXnoJpiOu5+eofCto=KZ+u6KJbJA@mail.gmail.com>
 <20220824122058.1c46e09a@xps-13> <CAK-6q+gjgQ1BF-QrT01JWh+2b3oL3RU+SoxUf5t7h3Hc6R8pcg@mail.gmail.com>
 <20220824152648.4bfb9a89@xps-13> <CAK-6q+itA0C4zPAq5XGKXgCHW5znSFeB-YDMp3uB9W-kLV6WaA@mail.gmail.com>
 <20220825145831.1105cb54@xps-13> <CAK-6q+j3LMoSe_7u0WqhowdPV9KM-6g0z-+OmSumJXCZfo0CAw@mail.gmail.com>
 <20220826095408.706438c2@xps-13>
In-Reply-To: <20220826095408.706438c2@xps-13>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Sun, 28 Aug 2022 22:52:14 -0400
Message-ID: <CAK-6q+gxD0TkXzUVTOiR4-DXwJrFUHKgvccOqF5QMGRjfZQwvw@mail.gmail.com>
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
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, Aug 26, 2022 at 3:54 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hi Alexander,
>
> aahringo@redhat.com wrote on Thu, 25 Aug 2022 21:05:09 -0400:
>
> > Hi,
> >
> > On Thu, Aug 25, 2022 at 8:58 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > >
> > > Hi Alexander,
> > >
> > > aahringo@redhat.com wrote on Wed, 24 Aug 2022 17:53:45 -0400:
> > >
> > > > Hi,
> > > >
> > > > On Wed, Aug 24, 2022 at 9:27 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > > > >
> > > > > Hi Alexander,
> > > > >
> > > > > aahringo@redhat.com wrote on Wed, 24 Aug 2022 08:43:20 -0400:
> > > > >
> > > > > > Hi,
> > > > > >
> > > > > > On Wed, Aug 24, 2022 at 6:21 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > > > > > ...
> > > > > > >
> > > > > > > Actually right now the second level is not enforced, and all the
> > > > > > > filtering levels are a bit fuzzy and spread everywhere in rx.c.
> > > > > > >
> > > > > > > I'm gonna see if I can at least clarify all of that and only make
> > > > > > > coord-dependent the right section because right now a
> > > > > > > ieee802154_coord_rx() path in ieee802154_rx_handle_packet() does not
> > > > > > > really make sense given that the level 3 filtering rules are mostly
> > > > > > > enforced in ieee802154_subif_frame().
> > > > > >
> > > > > > One thing I mentioned before is that we probably like to have a
> > > > > > parameter for rx path to give mac802154 a hint on which filtering
> > > > > > level it was received. We don't have that, I currently see that this
> > > > > > is a parameter for hwsim receiving it on promiscuous level only and
> > > > > > all others do third level filtering.
> > > > > > We need that now, because the promiscuous mode was only used for
> > > > > > sniffing which goes directly into the rx path for monitors. With scan
> > > > > > we mix things up here and in my opinion require such a parameter and
> > > > > > do filtering if necessary.
> > > > >
> > > > > I am currently trying to implement a slightly different approach. The
> > > > > core does not know hwsim is always in promiscuous mode, but it does
> > > > > know that it does not check FCS. So the core checks it. This is
> > > > > level 1 achieved. Then in level 2 we want to know if the core asked
> > > > > the transceiver to enter promiscuous mode, which, if it did, should
> > > > > not imply more filtering. If the device is working in promiscuous
> > > > > mode but this was not asked explicitly by the core, we don't really
> > > > > care, software filtering will apply anyway.
> > > > >
> > > >
> > > > I doubt that I will be happy with this solution, this all sounds like
> > > > "for the specific current behaviour that we support 2 filtering levels
> > > > it will work", just do a parameter on which 802.15.4 filtering level
> > > > it was received and the rx path will check what kind of filter is
> > > > required and which not.
> > > > As driver ops start() callback you should say which filtering level
> > > > the receive mode should start with.
> > > >
> > > > > I am reworking the rx path to clarify what is being done and when,
> > > > > because I found this part very obscure right now. In the end I don't
> > > > > think we need additional rx info from the drivers. Hopefully my
> > > > > proposal will clarify why this is (IMHO) not needed.
> > > > >
> > > >
> > > > Never looked much in 802.15.4 receive path as it just worked but I
> > > > said that there might be things to clean up when filtering things on
> > > > hardware and when on software and I have the feeling we are doing
> > > > things twice. Sometimes it is also necessary to set some skb fields
> > > > e.g. PACKET_HOST, etc. and I think this is what the most important
> > > > part of it is there. However, there are probably some tune ups if we
> > > > know we are in third leveling filtering...
> > >
> > > Ok, I've done the following.
> > >
> > > - Adding a PHY parameter which reflects the actual filtering level of
> > >   the transceiver, the default level is 4 (standard situation, you're
> >
> > 3?
>
> Honestly there are only two filtering levels in the normal path and one
> additional for scanning situations. But the spec mentions 4, so I
> figured we should use the same naming to avoid confusing people on what
> "level 3 means, if it's level 3 because level 1 and 2 are identical at
> PHY level, or level 3 which is the scan filtering as mentioned in the
> spec?".
>
> I used this enum to clarify the amount of filtering that is involved,
> hopefully it is clear enough. I remember we talked about this already
> but an unrelated thread, and was not capable of finding it anymore O:-).
>
> /** enum ieee802154_filtering_level - Filtering levels applicable to a PHY
>  * @IEEE802154_FILTERING_NONE: No filtering at all, what is received is
>  *      forwarded to the softMAC
>  * @IEEE802154_FILTERING_1_FCS: First filtering level, frames with an invalid
>  *      FCS should be dropped
>  * @IEEE802154_FILTERING_2_PROMISCUOUS: Second filtering level, promiscuous
>  *      mode, identical in terms of filtering to the first level at the PHY
>  *      level, but no ACK should be transmitted automatically and at the MAC
>  *      level the frame should be forwarded to the upper layer directly
>  * @IEEE802154_FILTERING_3_SCAN: Third filtering level, enforced during scans,
>  *      which only forwards beacons
>  * @IEEE802154_FILTERING_4_FRAME_FIELDS: Fourth filtering level actually
>  *      enforcing the validity of the content of the frame with various checks
>  */
> enum ieee802154_filtering_level {
>         IEEE802154_FILTERING_NONE,
>         IEEE802154_FILTERING_1_FCS,
>         IEEE802154_FILTERING_2_PROMISCUOUS,
>         IEEE802154_FILTERING_3_SCAN,
>         IEEE802154_FILTERING_4_FRAME_FIELDS,
> };
>

I am fine to drop all this level number naming at all and we do our
own filtering definition here, additionally to the mandatory ones.
E.g. The SCAN filter can also be implemented in e.g. atusb by using
other filter modes which are based on 802.15.4 modes (or level
whatever).

I am currently thinking about if we might need to change something
here in the default handling of the monitor interface, it should use
802.15.4 compatible modes (and this is what we should expect is always
being supported). IEEE802154_FILTERING_NONE is not a 802.15.4
filtering mode and is considered to be optional. So the default
behaviour of the monitor should be IEEE802154_FILTERING_FCS with a
possibility to have a switch to change to IEEE802154_FILTERING_NONE
mode if it's supported by the hardware.

You should also add a note on the filter level/modes which are
mandatory (means given by the spec) and put their level inside there?

> >
> > >   receiving data) but of course if the PHY does not support this state
> > >   (like hwsim) it should overwrite this value by setting the actual
> > >   filtering level (none, in the hwsim case) so that the core knows what
> > >   it receives.
> > >
> >
> > ok.
> >
> > > - I've replaced the specific "do not check the FCS" flag only used by
> > >   hwsim by this filtering level, which gives all the information we
> > >   need.
> > >
> >
> > ok.
> >
> > > - I've added a real promiscuous filtering mode which truly does not
> > >   care about the content of the frame but only checks the FCS if not
> > >   already done by the xceiver.
> > >
> >
> > not sure what a "real promiscuous filtering here is" people have
> > different understanding about it, but 802.15.4 has a definition for
> > it.
>
> Promiscuous, by the 802154 spec means: the FCS is good so the content of
> the received packet must means something, just forward it and let upper
> layers handle it.
>
> Until now there was no real promiscuous mode in the mac NODE rx path.
> Only monitors would get all the frames (including the ones with a wrong
> FCS), which is fine because it's a bit out of the spec, so I'm fine
> with this idea. But otherwise in the NODE/COORD rx path, the FCS should
> be checked even in promiscuous mode to correctly match the spec.
>

If we parse the frame, the FCS should always be checked. The frame
should _never_ be parsed before it hits the monitor receive path.

The wording "real promiscuous mode" is in my opinion still debatable,
however that's not the point here.

> Until now, ieee802154_parse_frame_start() was always called in these
> path and this would validate the frame headers. I've added a more
> precise promiscuous mode in the rx patch which skips any additional
> checks. What happens however is that, if the transceiver disables FCS
> checks in promiscuous mode, then FCS is not checked at all and this is
> invalid. With my current implementation, the devices which do not check
> the FCS might be easily "fixed" by changing their PHY filtering level
> to "FILTERING_NONE" in the promiscuous callback.
>
> > You should consider that having monitors, frames with bad fcs
> > should not be filtered out by hardware. There it comes back what I
> > said before, the filtering level should be a parameter for start()
> > driver ops.
> >
> > > - I've also implemented in software filtering level 4 for most
> > > regular
> >
> > 3?
> >
> > >   data packets. Without changing the default PHY level mentioned in
> > > the first item above, this additional filtering will be skipped
> > > which ensures we keep the same behavior of most driver. In the case
> > > of hwsim however, these filters will become active if the MAC is
> > > not in promiscuous mode or in scan mode, which is actually what
> > > people should be expecting.
> > >
> >
> > To give feedback to that I need to see code. And please don't send the
> > whole feature stuff again, just this specific part of it. Thanks.
>
> The entire filtering feature is split: there are the basis introduced
> before the scan, and then after the whole scan+association thing I've
> introduced additional filtering levels.
>

No idea what that means.

> > > Hopefully all this fits what you had in mind.
> > >
> > > I have one item left on my current todo list: improving a bit the
> > > userspace tool with a "monitor" command.
> > >
> > > Otherwise the remaining things to do are to discuss the locking
> > > design which might need to be changed to avoid lockdep issues and
> > > keep the rtnl locked eg. during a channel change. I still don't
> > > know how to do that, so it's likely that the right next version
> > > will not include any change in this area unless something pops up.
> >
> > I try to look at that on the weekend.
>
> I've had an idea yesterday night which seem to work, I think I can drop
> the two patches which you disliked regarding discarding the rtnl in the
> tx path and in hwsim:change_channel().

I would like to bring the filtering level question at first upstream.
If you don't mind.

- Alex

