Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE6E614068
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 23:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbiJaWIP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 18:08:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiJaWIN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 18:08:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B76D140F3
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 15:07:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667254040;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+iZ0pV3SBOzW1z26S60SpkgdQOzJ1jKWT7LgrMsWLSw=;
        b=YHRVBpUAM41TLYu3MbFEVWy9kK+MreJ8KJlMhAX1fvVlKKj2ZfgezIarcpANgnvPK4yfBQ
        jz1S3qaI3t5hrveg6Am+RlZdhnWNGOll/MefFvAy/lRf1e5efse/mPn+az9t+0cRGvd6sC
        qcjYM2uESWpvio045y7fJ7nme6EYQCQ=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-220-Le-LAP07Pu-upKdOjTsA8w-1; Mon, 31 Oct 2022 18:07:18 -0400
X-MC-Unique: Le-LAP07Pu-upKdOjTsA8w-1
Received: by mail-ed1-f69.google.com with SMTP id w4-20020a05640234c400b004631f8923baso3655606edc.5
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 15:07:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+iZ0pV3SBOzW1z26S60SpkgdQOzJ1jKWT7LgrMsWLSw=;
        b=xayCq59aTCDhis4xFpIV4fEM1Q7TqdCySpWXkQjQL4khW3oHvm0Qya+DtPd9EGrjko
         ifByMbDMc8L9e9cyUv0kjDuvjP2rFb4MkfTtd4RtIzaUareq9+mZKNLc78JuAOYedTii
         5skLSCp/OOm6eSFv6Wp3IM62/zCSGlhVxxT3tqX7zsk9NGtcrUUzHUYQLhq3S746Dl6U
         HC+LQjjflirr8I2UoG0VbFYqxV5JnoggwuK2xtTe3hY42V7FqV6hoVqIo7BJ01HMA1yg
         l5C2Izqifs9DbRJjLZc2cKx4Y3oRidUXqYwjNd1zQTArEbXw+o7YY1YSLewJh6Uky8rV
         JekQ==
X-Gm-Message-State: ACrzQf3FGpxFq1884g24ZGLXb4/2zHFNFQf8RL09hk84aMeQjbETStSX
        QrBHTv6blio8sEL0u+0go4JFQsSzQk86gcMKgOoCAF24GxxmOl3UZyOfABiEzvBRGSuOn2suWkM
        Z1VpexZ3KfiWd3z5N9Fs7pIIN4WqaR3KB
X-Received: by 2002:a17:906:a246:b0:78d:ee08:1867 with SMTP id bi6-20020a170906a24600b0078dee081867mr15055ejb.123.1667254037495;
        Mon, 31 Oct 2022 15:07:17 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7808CBkgMpm2IjH8zlljCUguJuPX1x0B9oPTLTfUq3CiS9A72iS2SRvn8xSQPXLui8a1FHlXuRoePvlJ0JBYM=
X-Received: by 2002:a17:906:a246:b0:78d:ee08:1867 with SMTP id
 bi6-20020a170906a24600b0078dee081867mr15052ejb.123.1667254037330; Mon, 31 Oct
 2022 15:07:17 -0700 (PDT)
MIME-Version: 1.0
References: <20221026093502.602734-1-miquel.raynal@bootlin.com> <CAK-6q+jXPyruvdtS3jgzkuH=f599EiPk7vWTWLhREFCMj5ayNg@mail.gmail.com>
In-Reply-To: <CAK-6q+jXPyruvdtS3jgzkuH=f599EiPk7vWTWLhREFCMj5ayNg@mail.gmail.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Mon, 31 Oct 2022 18:07:05 -0400
Message-ID: <CAK-6q+iRAjEPLQqH-_YSxNnobd7o=NLaF-4XB+zvNTXpWgpb8A@mail.gmail.com>
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
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Sun, Oct 30, 2022 at 10:20 PM Alexander Aring <aahringo@redhat.com> wrote:
>
> Hi,
>
> On Wed, Oct 26, 2022 at 5:35 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> >
> > Hello,
> > These three patches allow the creation of coordinator interfaces, which
> > were already defined without being usable. The idea behind is to use
> > them advertizing PANs through the beaconing feature.
> >
>
> I still don't know how exactly those "leaves" and "non-leaves" are
> acting here regarding the coordinator interfaces. If this is just a
> bit here to set in the interface I am fine with it. But yea,
> "relaying" feature is a project on its own, as we said previously.
>
> Another mail I was asking myself what a node interface is then,
> currently it is a mesh interface with none of those 802.15.4 PAN
> management functionality? Or can it act also as a "leave"
> coordinator... I am not sure about that.
>
> However I think we can think about something scheduled later as we can
> still decide later if we really want that "node" can do that.
> Regarding to 6LoWPAN I think the current type what "node" interface is
> as a just a node in a mesh is required, it might depends on if you
> want routing on IP or "relaying" on MAC (mesh-over vs mesh-under), but

*route-over

> I never saw mesh-under in 6LoWPAN.
>

we will see how that works, because you can actually run a 6lowpan
interface on the new coordinator type.

- Alex

