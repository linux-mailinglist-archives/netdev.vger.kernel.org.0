Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FCF8677E2F
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 15:37:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232176AbjAWOhi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 09:37:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231663AbjAWOhh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 09:37:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D8227693
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 06:36:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674484609;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HBpjmEQyfavPuUGASQW20In6kphIvOV/Jy7jnr721lM=;
        b=AEKkidxp4e9FPol4HLqybRj1aSl+TB8v+3yVOmMbjfDq10YIXxt44Cmhvl26Odoe17OoFo
        BzIrVeOYEJAYBdbVQIvJ5mxYC3I3BDvSC8igI3MtMxF1bBxPQg6q7qpp3X/JpVc3wR/Z2D
        iIb6yUdgbIj4rkBGwWDb4UmdJLW7K5o=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-300-ZrzJ81qGPC28350HMZe5Aw-1; Mon, 23 Jan 2023 09:36:48 -0500
X-MC-Unique: ZrzJ81qGPC28350HMZe5Aw-1
Received: by mail-ej1-f69.google.com with SMTP id sb39-20020a1709076da700b0086b1cfb06f0so7802451ejc.4
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 06:36:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HBpjmEQyfavPuUGASQW20In6kphIvOV/Jy7jnr721lM=;
        b=ZWuEcQfQucCtHcZwhhqfvbELdQ/NiiFQfzFkd6fx8M6PUIkK8aRK7vLAAOCyq6luEp
         gCCoQNltiapyfEwhftHi9J1WXv7g6uZOdVAQ5+BnIpbYUuhbjpWivlFkFe0j8W52sjPy
         C6uZ56vklBKhhX9VzSSFW2vnUkrHRma2uMlbnOMwNuqZWG7R3jRIRPAz32LtF/Nkae4R
         vwz4Tt6I3yq2EMenNgkKK5wjBndin8NnaTO63DjoIGufRxGhbTseouShSAI6xWzqUvKZ
         B3/1mk2P5Dc/zmVZFhT8egiG4mTPUKIBpoNByJjxv/2oUOOhSDGRIL5lKDzdhUbFzo5B
         ZpHw==
X-Gm-Message-State: AFqh2kopp3CmtB/VK1WaTkuTZGJDjbyii7NfHgRJxM6NxbH0ta0o2+mH
        NyYpcY8MSQiuFEKljvaZx5aNm2k3HbEZL2k9pScKIvj0r1XtjtXa7yUEBqHNqcSfy5OgGpaZjAX
        bGfcOW1MUXmjfBpTyis3Mc+NRDsqk8up2
X-Received: by 2002:a17:906:15d4:b0:7c0:fa5f:a032 with SMTP id l20-20020a17090615d400b007c0fa5fa032mr1805365ejd.112.1674484607101;
        Mon, 23 Jan 2023 06:36:47 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtGkXxV3VbA8WAPWaj4aQnx/BD+6nTiYZiN40lGMyPKWnGiT3ZYqEqQiLlzbGTvxAcQYjWWYNyJ7YwQp7PmTjE=
X-Received: by 2002:a17:906:15d4:b0:7c0:fa5f:a032 with SMTP id
 l20-20020a17090615d400b007c0fa5fa032mr1805351ejd.112.1674484606933; Mon, 23
 Jan 2023 06:36:46 -0800 (PST)
MIME-Version: 1.0
References: <20230106113129.694750-1-miquel.raynal@bootlin.com>
 <CAK-6q+jNmvtBKKxSp1WepVXbaQ65CghZv3bS2ptjB9jyzOSGTA@mail.gmail.com>
 <20230118102058.3b1f275b@xps-13> <20230123134921.38cdfd42@xps-13> <CAK-6q+g9TxtEpELW1GXchBjPq2HD85CAv06VhDKSHjrQmXPCKA@mail.gmail.com>
In-Reply-To: <CAK-6q+g9TxtEpELW1GXchBjPq2HD85CAv06VhDKSHjrQmXPCKA@mail.gmail.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Mon, 23 Jan 2023 09:36:35 -0500
Message-ID: <CAK-6q+jf2EWASVGkTXLkD2V4gpzjEAkYTXt=rcZRXTDhO5so3w@mail.gmail.com>
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
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Jan 23, 2023 at 8:50 AM Alexander Aring <aahringo@redhat.com> wrote:
>
> Hi,
>
> On Mon, Jan 23, 2023 at 7:49 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> >
> > Hi Alexander,
> >
> > > > btw: what is about security handling... however I would declare this
> > > > feature as experimental anyway.
> > >
> > > I haven't tested the security layer at all yet, would you have a few
> > > commands to start with, which I could try using eg. hwsim?
> >
> > Using the dev_queue_xmit() doest not bypasses the whole stack anymore,
> > the beacons got rejected by the llsec layer. I did just hack into it
> > just to allow unsecure beacons for now:
> >
>
> Stupid questions: do the beacon frames need to be encrypted? Because
> we bypass llsec always with those mlme functionality.
>
> btw: there is currently an issue with the llsec hooks. You will not
> see the transmit side being encrypted via wireshark (so far I
> remember) because the capture is before encryption...

You can do with hwsim a sniffer device, just create a phy and have
from every node an edge to it, then create a monitor interface on it
and you will see all frames on air correctly encrypted and let
wireshark decrypt it. This is a workaround I had.

- Alex

