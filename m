Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8D0C5ABF60
	for <lists+netdev@lfdr.de>; Sat,  3 Sep 2022 16:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbiICOby (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Sep 2022 10:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiICObx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Sep 2022 10:31:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BC8B53037
        for <netdev@vger.kernel.org>; Sat,  3 Sep 2022 07:31:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662215510;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=olK16FGKKB/44r4p61ENDPEYYBM2UVFGLBEQWvgpGpc=;
        b=ehHFROaHum+u/mxDJSd2E2re/y+EIpRMN2Jik4WfXHIgrAV10NMuAGLQf1e010m2J3racO
        +JRoVvYYRYI6nigIVPBDbN2dfG9y/R/5EQtmL9xHyu1uRztIw18ihAv9hhsEtR+ljI+cnk
        WfHgBDyvZIr3C+A/ZM/OUWKhB7BESfE=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-539-wEDYwBNVN76Ezh_XbfhkKg-1; Sat, 03 Sep 2022 10:31:49 -0400
X-MC-Unique: wEDYwBNVN76Ezh_XbfhkKg-1
Received: by mail-qv1-f72.google.com with SMTP id u4-20020a0c8dc4000000b00498f6359b6dso3058603qvb.17
        for <netdev@vger.kernel.org>; Sat, 03 Sep 2022 07:31:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=olK16FGKKB/44r4p61ENDPEYYBM2UVFGLBEQWvgpGpc=;
        b=FAXaygkDcEUWGCPhMKOQ6nKdeH+YVNkn6pZrhXH7hj90wjWYtkr5b3VEiFJh9nSc48
         /uRoHmARWMxYV8/i0A959RnauGRjf281CV+kQCTBSQx9592JRHAw9CgysJgncdWP0Fad
         nbPyDlzXkCrYrHHZZ1IxIO/v5qaAJsV2WaRdHlv0aLIwZpy5qhdQO8ARMdynG5Nc/f6v
         aYWS2xO1fjbicBp+hKzEw1LRXv9JGbcD9p2G8K3XzqTuW8q7rPQt12zQEV8mdEIjD0O0
         MmikeMMTDXM2SZts9soCCsfEmGoMACv1wHLYECgUz/o4IybyEKw5+BWXdEbo11lMrOrw
         MOFg==
X-Gm-Message-State: ACgBeo19jR/R75CoDs/Q6JAnlltjYQHXZ/GvRuQJU8gfltiJngyAMgEA
        kE3Gj6SR0FYE6s50nCgHxCPyVHM461kZT2TWoYrVPT6XmytoNX0ynaEj3b2WIcXHj5TVjw4TX3W
        pxYqz0qYmBtKMPcFg+EjAGE7FbSRKVqC6
X-Received: by 2002:a05:620a:2908:b0:6bb:5c2b:4226 with SMTP id m8-20020a05620a290800b006bb5c2b4226mr26789225qkp.27.1662215508924;
        Sat, 03 Sep 2022 07:31:48 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6b3mlOppN6cjfEVmQ+t3x3BXFGyuRrXMod3c8cMERARTmnYNqDWG9izYyYpwGEEP5GusaHDcMrrOe8JNGeTmo=
X-Received: by 2002:a05:620a:2908:b0:6bb:5c2b:4226 with SMTP id
 m8-20020a05620a290800b006bb5c2b4226mr26789211qkp.27.1662215508712; Sat, 03
 Sep 2022 07:31:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220701143052.1267509-1-miquel.raynal@bootlin.com>
 <20220819191109.0e639918@xps-13> <CAK-6q+gCY3ufaADHNQWJGNpNZJMwm=fhKfe02GWkfGEdgsMVzg@mail.gmail.com>
 <20220823182950.1c722e13@xps-13> <CAK-6q+jfva++dGkyX_h2zQGXnoJpiOu5+eofCto=KZ+u6KJbJA@mail.gmail.com>
 <20220824122058.1c46e09a@xps-13> <CAK-6q+gjgQ1BF-QrT01JWh+2b3oL3RU+SoxUf5t7h3Hc6R8pcg@mail.gmail.com>
 <20220824152648.4bfb9a89@xps-13> <CAK-6q+itA0C4zPAq5XGKXgCHW5znSFeB-YDMp3uB9W-kLV6WaA@mail.gmail.com>
 <20220825145831.1105cb54@xps-13> <CAK-6q+j3LMoSe_7u0WqhowdPV9KM-6g0z-+OmSumJXCZfo0CAw@mail.gmail.com>
 <20220826095408.706438c2@xps-13> <CAK-6q+gxD0TkXzUVTOiR4-DXwJrFUHKgvccOqF5QMGRjfZQwvw@mail.gmail.com>
 <20220829100214.3c6dad63@xps-13> <CAK-6q+gJwm0bhHgMVBF_pmjD9zSrxxHvNGdTrTm0fG-hAmSaUQ@mail.gmail.com>
 <20220831173903.1a980653@xps-13> <20220901020918.2a15a8f9@xps-13>
 <20220901150917.5246c2d0@xps-13> <CAK-6q+g1Gnew=zWsnW=HAcLTqFYHF+P94Q+Ywh7Rir8J8cgCgw@mail.gmail.com>
 <20220903020829.67db0af8@xps-13> <CAK-6q+hO1i=xvXx3wHo658ph93FwuVs_ssjG0=jnphEe8a+gxw@mail.gmail.com>
In-Reply-To: <CAK-6q+hO1i=xvXx3wHo658ph93FwuVs_ssjG0=jnphEe8a+gxw@mail.gmail.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Sat, 3 Sep 2022 10:31:37 -0400
Message-ID: <CAK-6q+gW=s=tWBrkN=CaiyoLM8kqeF0iRuS21AqDMQdQcE9H5A@mail.gmail.com>
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

On Sat, Sep 3, 2022 at 10:20 AM Alexander Aring <aahringo@redhat.com> wrote:
>
> Hi,
>
> On Fri, Sep 2, 2022 at 8:08 PM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> ...
> > >
> > > I am sorry, I never looked into Zephyr for reasons... Do they not have
> > > something like /proc/interrupts look if you see a counter for your
> > > 802.15.4 transceiver?
> > >
> > > > Also, can you please clarify when are we talking about software and
> > > > when about hardware filters.
> > > >
> > >
> > > Hardware filter is currently e.g. promiscuous mode on or off setting.
> > > Software filtering is depending which receive path the frame is going
> > > and which hardware filter is present which then acts like actually
> > > with hardware filtering.
> > > I am not sure if this answers this question?
> >
> > I think my understand gets clearer now that I've digged into Zephyr's
> > ieee802154 layer and in the at86rf230 datasheet.
> >
>
> okay, I think for zephyr questions you are here on the wrong mailinglist.
>
> > I will answer the previous e-mail but just for not I wanted to add that
> > I managed to get Zephyr working, I had to mess around in the code a
> > little bit and actually I discovered a net command which is necessary
> > to use in order to turn the iface up, whatever.
> >
>
> aha.
>
> > So I was playing with the atusb devices and I _think_ I've found a
> > firmware bug or a hardware bug which is going to be problematic. In
>
> the firmware is open source, I think it's fine to send patches here (I
> did it as well once for do a quick hack to port it to rzusb) the atusb
> is "mostly" at the point that they can do open hardware from the
> qi-hardware organization.
>
> > iface.c, when creating the interface, if you set the hardware filters
> > (set_panid/short/ext_addr()) there is no way you will be able to get a
> > fully transparent promiscuous mode. I am not saying that the whole
>
> What is a transparent promiscuous mode?
>
> > promiscuous mode does not work anymore, I don't really know. What I was
> > interested in were the acks, and getting them is a real pain. At least,
> > enabling the promiscuous mode after setting the hw filters will lead to
> > the acks being dropped immediately while if the promiscuous mode is
> > enabled first (like on monitor interfaces) the acks are correctly
> > forwarded by the PHY.
>
> If we would not disable AACK handling (means we receive a frame with
> ack requested bit set we send a ack back) we would ack every frame it
> receives (speaking on at86rf233).
>
> >
> > While looking at the history of the drivers, I realized that the
> > TX_ARET mode was not supported by the firmware in 2015 (that's what you
>
> There exists ARET and AACK, both are mac mechanisms which must be
> offloaded on the hardware. Note that those only do "something" if the
> ack request bit in the frame is set.
>
> ARET will retransmit if no ack is received after some while, etc.
> mostly coupled with CSMA/CA handling. We cannot guarantee such timings
> on the Linux layer. btw: mac80211 can also not handle acks on the
> software layer, it must be offloaded.
>
> AACK will send a back if a frame with ack request bit was received.

will send an ack back*

- Alex

