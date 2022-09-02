Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCF55AA579
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 04:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234186AbiIBCJ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 22:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231394AbiIBCJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 22:09:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 692E6EB9
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 19:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662084591;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Glclh5v/Wd515YHsUVu6CqjDmnWddkL3V2d3UpUAO5g=;
        b=isOP0sX2pA7/Q7PAOsnEyu2z9u/bdQIb0hWPAgaxDJg/3d/BLHnXkMUifYErygMEQXjCAm
        pwNjZec3JIVNAZkUwIqD2C6hToKSzl1cDjRmqz65w7dHHnzUWbLZSCHtyudANKceZu4Qxa
        bl+9fmBesTL5JXqoex00kdApuwrNgpc=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-32-E5pFBEM7Nx2k_Ijtcy9hcQ-1; Thu, 01 Sep 2022 22:09:50 -0400
X-MC-Unique: E5pFBEM7Nx2k_Ijtcy9hcQ-1
Received: by mail-qt1-f200.google.com with SMTP id v13-20020a05622a188d00b00343794bd1daso529845qtc.23
        for <netdev@vger.kernel.org>; Thu, 01 Sep 2022 19:09:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=Glclh5v/Wd515YHsUVu6CqjDmnWddkL3V2d3UpUAO5g=;
        b=2kRYtIxvbtnYD55elZiiqlXE4oKZwZdLmCeHJ7KOW+fneVDkZA6DhOkCJBpxV9iy+A
         7Dji6gD5jxAVFtAMOecnlls6cuFHtHxxB5qcVfRT8SEfaz7vSF9iiBuDoWRlTigA6mPf
         wyGgl98MovY5XWZ9OHf3wlyJ0hSv1Amoi3SO5j1qrtNA+f5aTybYs2ZMM9zc5McTrVJn
         swpYtKJd9WUfyhW0j+nN5OsmTx80T7a6EwZjnspYQ6wKy53Msohr//IKAkQ4sXzlfbQn
         AckNnrgjLocPtMYgeu8tW02vTzOYUusK/eUl/MJHDYXlBC0FcoM0JIkw/71ipgxoLJCI
         mZEg==
X-Gm-Message-State: ACgBeo2gtYYIfIO0s2i/32Szm2Qe6AKim5bBx47VjABbBomX8UydkJ1B
        BkAQcM2N5Zfof9yjeV9ckFkajaeiuE0pLijpJKTCTeAfgf3mKn6e4eXF9//ZuLRkMj6oaMKSyEu
        y6vVqKZOLbeH2slItH5yQh8r9iqwmJBMQ
X-Received: by 2002:a05:622a:1302:b0:344:8a9d:817d with SMTP id v2-20020a05622a130200b003448a9d817dmr26446564qtk.339.1662084590009;
        Thu, 01 Sep 2022 19:09:50 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4Un99Kv+7MWxTnnA6cj8sXjWtQ2lyfiPpnnHJEuN6JRm6toB3pjlq+PX8Vi1+jD4tyOJ4AWle0W/ExIHE7/3Y=
X-Received: by 2002:a05:622a:1302:b0:344:8a9d:817d with SMTP id
 v2-20020a05622a130200b003448a9d817dmr26446557qtk.339.1662084589801; Thu, 01
 Sep 2022 19:09:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220701143052.1267509-1-miquel.raynal@bootlin.com>
 <20220701143052.1267509-2-miquel.raynal@bootlin.com> <CAK-6q+jkUUjAGqEDgU1oJvRkigUbvSO5SXWRau6+320b=GbfxQ@mail.gmail.com>
 <20220819191109.0e639918@xps-13> <CAK-6q+gCY3ufaADHNQWJGNpNZJMwm=fhKfe02GWkfGEdgsMVzg@mail.gmail.com>
 <20220823182950.1c722e13@xps-13> <CAK-6q+jfva++dGkyX_h2zQGXnoJpiOu5+eofCto=KZ+u6KJbJA@mail.gmail.com>
 <20220824122058.1c46e09a@xps-13> <CAK-6q+gjgQ1BF-QrT01JWh+2b3oL3RU+SoxUf5t7h3Hc6R8pcg@mail.gmail.com>
 <20220824152648.4bfb9a89@xps-13> <CAK-6q+itA0C4zPAq5XGKXgCHW5znSFeB-YDMp3uB9W-kLV6WaA@mail.gmail.com>
 <20220825145831.1105cb54@xps-13> <CAK-6q+j3LMoSe_7u0WqhowdPV9KM-6g0z-+OmSumJXCZfo0CAw@mail.gmail.com>
 <20220826095408.706438c2@xps-13> <CAK-6q+gxD0TkXzUVTOiR4-DXwJrFUHKgvccOqF5QMGRjfZQwvw@mail.gmail.com>
 <20220829100214.3c6dad63@xps-13> <CAK-6q+gJwm0bhHgMVBF_pmjD9zSrxxHvNGdTrTm0fG-hAmSaUQ@mail.gmail.com>
 <20220831173903.1a980653@xps-13>
In-Reply-To: <20220831173903.1a980653@xps-13>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Thu, 1 Sep 2022 22:09:38 -0400
Message-ID: <CAK-6q+ghghhPeV1O57_Rp4YNAjcN-Z-1nPhNvmM1kSYHJSb4Uw@mail.gmail.com>
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
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, Aug 31, 2022 at 11:39 AM Miquel Raynal
<miquel.raynal@bootlin.com> wrote:
>
> Hi Alexander & Stefan,
>
> aahringo@redhat.com wrote on Mon, 29 Aug 2022 22:23:09 -0400:
>
> I am currently testing my code with the ATUSB devices, the association
> works, so it's a good news! However I am struggling to get the
> association working for a simple reason: the crafted ACKs are
> transmitted (the ATUSB in monitor mode sees it) but I get absolutely

What is a crafted ACK here?

> nothing on the receiver side.
>
> The logic is:
>
> coord0                 coord1
> association req ->
>                 <-     ack
>                 <-     association response
> ack             ->
>
> The first ack is sent by coord1 but coord0 never sees anything. In
> practice coord0 has sent an association request and received a single
> one-byte packet in return which I guess is the firmware saying "okay, Tx
> has been performed". Shall I interpret this byte differently? Does it
> mean that the ack has also been received?
>
> I could not find a documentation of the firmware interface, I went
> through the wiki but I did not find something clear about what to
> expect or "what the driver should do". But perhaps this will ring a
> bell on your side?
>
> [...]
>
> > I did not see the v2 until now. Sorry for that.
>
> Ah! Ok, no problem :)
>
> >
> > However I think there are missing bits here at the receive handling
> > side. Which are:
> >
> > 1. Do a stop_tx(), stop_rx(), start_rx(filtering_level) to go into
> > other filtering modes while ifup.
>
> Who is supposed to change the filtering level?
>

depending on what mac802154 is doing, for scan it's required to switch
the filter level to promiscuous?

> For now there is only the promiscuous mode being applied and the user
> has no knowledge about it, it's just something internal.
>

Okay, sounds good.

> Changing how the promiscuous mode is applied (using a filtering level
> instead of a "promiscuous on" boolean) would impact all the drivers
> and for now we don't really need it.
>

no, it does not. Okay, you can hide the promiscuous mode driver
callback from start()... but yes the goal would be to remove the
promiscuous mode op in future.

> > I don't want to see all filtering modes here, just what we currently
> > support with NONE (then with FCS check on software if necessary),
> > ?THIRD/FOURTH? LEVEL filtering and that's it. What I don't want to see
> > is runtime changes of phy flags. To tell the receive path what to
> > filter and what's not.
>
> Runtime changes on a dedicated "filtering" PHY flag is what I've used
> and it works okay for this situation, why don't you want that? It
> avoids the need for (yet) another rework of the API with the drivers,
> no?
>

I am not sure what exactly here is "dedicated "filtering" PHY flag" if
it's the hwflags it was never made to be changed during runtime.

I also don't know what "yet another rework of the API" means here,
there is a current behaviour which we can assume and only hwsim is a
little bit out of range which should overwrite the "default".

> > 2. set the pan coordinator bit for hw address filter. And there is a
> > TODO about setting pkt_type in mac802154 receive path which we should
> > take a look into. This bit should be addressed for coordinator support
> > even if there is the question about coordinator vs pan coordinator,
> > then the kernel needs a bit as coordinator iface type parameter to
> > know if it's a pan coordinator and not coordinator.
>
> This is not really something that we can "set". Either the device
> had performed an association and it is a child device: it is not the
> PAN coordinator, or it initiated the PAN and it is the PAN coordinator.
> There are commands to change that later on but those are not supported.
>
> The "PAN coordinator" information is being added in the association
> series (which comes after the scan). I have handled the pkt_type you are
> mentioning.
>

okay.

- Alex

