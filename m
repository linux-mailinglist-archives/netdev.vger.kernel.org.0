Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 306E5686C9D
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 18:16:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232000AbjBARQp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 12:16:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231185AbjBARQo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 12:16:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1582F65BD
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 09:15:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675271756;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0gzT36ewgNE+R9sO4cnT/wtnArdFhfnssBOprO3RY7o=;
        b=C2B0czcrdZY2Ss06HRyCvCvtKN5vdgEwMaKyuYjV/yR1k6+0QhNtbSEBVzI+U9HLQ77R8T
        r2hvKQTM8uUY3t3nC39cPG0gJXUrDDW+0fu/s9nbElVGJz0PjI9rf48cs9K3ZnIxfM3fyA
        Oub2Zwydi6TNcejIJ9F//neGrXRnwLg=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-166-ZqpkmTYMOMaMxuBJaFJpHg-1; Wed, 01 Feb 2023 12:15:55 -0500
X-MC-Unique: ZqpkmTYMOMaMxuBJaFJpHg-1
Received: by mail-ej1-f71.google.com with SMTP id qa17-20020a170907869100b0088ea39742c8so432145ejc.13
        for <netdev@vger.kernel.org>; Wed, 01 Feb 2023 09:15:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0gzT36ewgNE+R9sO4cnT/wtnArdFhfnssBOprO3RY7o=;
        b=yT3M4nsitNxVAUib2Hn98BRSOUJrtOY4TRknXA1OUEDN7WCNWwaTIiSlo8Q1z34BJ6
         LolXuPCG8Z4u07WzpwWKFPpE/5mMFfRkMtwm+NaDqCDpd+unGTiYXmcOaQyk4xxzZf52
         sKaZ74Uc68o26n7SN3v7PAIrF2qCMeHkdLtoBrS3Ww/k8fm0zOJ5LS7E/C52oy65EdZ0
         EDJ7vFmYm8Lkp4HgNkP1/CtNAyDK8NOUdHIm5kGkb4+ply4jPWaUK0bj83EystJcxXai
         2W0i4zv87pp9nbcR7KgtKOKV2FPdNE5IpkE82H93jK1HokKdNnvZRRvaIDjXEaT6NCgt
         FbNA==
X-Gm-Message-State: AO0yUKVkpXhRXUZnPX6C1x9FaSU7m96UF5RzFus32oiZZV3TVFIklRRO
        Q0Mxwa8abRzPPfPAF0LuljPoGG1KxiK/SQZCgIGPTSgFpdrzeMtGai7r57URqgfT/EeRBZ+DX2N
        v3UY7qv7LbtBC4i1x6yGrgxK+iRX5OfsK
X-Received: by 2002:a17:906:1155:b0:882:c2dd:f29e with SMTP id i21-20020a170906115500b00882c2ddf29emr1045598eja.268.1675271753997;
        Wed, 01 Feb 2023 09:15:53 -0800 (PST)
X-Google-Smtp-Source: AK7set9B1Q2R+IjQ0DwAJ9OEgIZzbhxXmqFRXFMAltQje6Ao2YS8s7kqlk8kYzYfHTu/rpqvNio2oJvFSLsqjJH+yU4=
X-Received: by 2002:a17:906:1155:b0:882:c2dd:f29e with SMTP id
 i21-20020a170906115500b00882c2ddf29emr1045587eja.268.1675271753834; Wed, 01
 Feb 2023 09:15:53 -0800 (PST)
MIME-Version: 1.0
References: <20230125102923.135465-1-miquel.raynal@bootlin.com>
 <CAK-6q+jN1bnP1FdneGrfDJuw3r3b=depEdEP49g_t3PKQ-F=Lw@mail.gmail.com>
 <CAK-6q+hoquVswZTm+juLasQzUJpGdO+aQ7Q3PCRRwYagge5dTw@mail.gmail.com>
 <20230130105508.38a25780@xps-13> <CAK-6q+gqQgFxqBUAhHDMaWv9VfuKa=bCVee_oSLQeVtk_G8=ow@mail.gmail.com>
 <20230131122525.7bd35c2b@xps-13>
In-Reply-To: <20230131122525.7bd35c2b@xps-13>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Wed, 1 Feb 2023 12:15:42 -0500
Message-ID: <CAK-6q+hAgyx3YML7Lw=MAkUX4i8PVqxSKiVzeAM-wGJOdL9aXA@mail.gmail.com>
Subject: Re: [PATCH wpan-next v2 0/2] ieee802154: Beaconing support
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

On Tue, Jan 31, 2023 at 6:25 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hi Alexander,
>
> > > > > > Changes in v2:
> > > > > > * Clearly state in the commit log llsec is not supported yet.
> > > > > > * Do not use mlme transmission helpers because we don't really need to
> > > > > >   stop the queue when sending a beacon, as we don't expect any feedback
> > > > > >   from the PHY nor from the peers. However, we don't want to go through
> > > > > >   the whole net stack either, so we bypass it calling the subif helper
> > > > > >   directly.
> > > > > >
> > > >
> > > > moment, we use the mlme helpers to stop tx
> > >
> > > No, we no longer use the mlme helpers to stop tx when sending beacons
> > > (but true MLME transmissions, we ack handling and return codes will be
> > > used for other purposes).
> > >
> >
> > then we run into an issue overwriting the framebuffer while the normal
> > transmit path is active?
>
> Crap, yes you're right. That's not gonna work.
>
> The net core acquires HARD_TX_LOCK() to avoid these issues and we are
> no bypassing the net core without taking care of the proper frame
> transmissions either (which would have worked with mlme_tx_one()). So I
> guess there are two options:
>
> * Either we deal with the extra penalty of stopping the queue and
>   waiting for the beacon to be transmitted with an mlme_tx_one() call,
>   as proposed initially.
>
> * Or we hardcode our own "net" transmit helper, something like:
>
> mac802154_fast_mlme_tx() {
>         struct net_device *dev = skb->dev;
>         struct netdev_queue *txq;
>
>         txq = netdev_core_pick_tx(dev, skb, NULL);
>         cpu = smp_processor_id();
>         HARD_TX_LOCK(dev, txq, cpu);
>         if (!netif_xmit_frozen_or_drv_stopped(txq))
>                 netdev_start_xmit(skb, dev, txq, 0);
>         HARD_TX_UNLOCK(dev, txq);
> }
>
> Note1: this is very close to generic_xdp_tx() which tries to achieve the
> same goal: sending packets, bypassing qdisc et al. I don't know whether
> it makes sense to define it under mac802154/tx.c or core/dev.c and give
> it another name, like generic_tx() or whatever would be more
> appropriate. Or even adapting generic_xdp_tx() to make it look more
> generic and use that function instead (without the xdp struct pointer).
>

The problem here is that the transmit handling is completely
asynchronous. Calling netdev_start_xmit() is not "transmit and wait
until transmit is done", it is "start transmit here is the buffer" an
interrupt is coming up to report transmit is done. Until the time the
interrupt isn't arrived the framebuffer on the device is in use, we
don't know when the transceiver is done reading it. Only after tx done
isr. The time until the isr isn't arrived is for us a -EBUSY case due
hardware resource limitation. Currently we do that with stop/wake
queue to avoid calling of xmit_do() to not run into such -EBUSY
cases...

There might be clever things to do here to avoid this issue... I am
not sure how XDP does that.

> Note2: I am wondering if it makes sense to disable bh here as well?

May HARD_TX_LOCK() already do that? If they use spin_lock_bh() they
disable local softirqs until the lock isn't held anymore.

>
> Once we settle, I send a patch.
>

Not sure how to preceded here, but do see the problem? Or maybe I
overlooked something here...

- Alex

