Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4CBD69D871
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 03:25:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232596AbjBUCZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 21:25:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231806AbjBUCZV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 21:25:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A7EC21948
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 18:24:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676946275;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YmnW0xbZ3rF2sCVOX2Raqo1dYUIAYEbjFfdF3vPFdKA=;
        b=E9/L8ciE/6FTk5eIWLl+SqFBBgNfFUuNT3DLPGP0DopY/S6k74YjV9iDMvtxwXfUSEEF/h
        95vdiGYNm6wHyLVJZJTTkIITDixPn4xo8n7nnLI9pYj5IGHhTJ2T0/C9Aknj4ZJ1/JqePT
        VTPCdHEnW/oswRB6itsj7v58ht6RGMw=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-209-9KgeUcnDO22K5Vk14sOpgg-1; Mon, 20 Feb 2023 21:24:33 -0500
X-MC-Unique: 9KgeUcnDO22K5Vk14sOpgg-1
Received: by mail-oi1-f199.google.com with SMTP id p6-20020acad806000000b0037890be175fso849927oig.14
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 18:24:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YmnW0xbZ3rF2sCVOX2Raqo1dYUIAYEbjFfdF3vPFdKA=;
        b=P4lSyDfxrmoh75tIq+CGUfqs5qgzR6BwCtNiPDkwyI9/tmf+QrG2mA1qnf2JznYfHQ
         L96vc0DV2svLei7on2b1NivKDIZH/aOY9yPqeY7dEu+bGCGvJxJBE7Aa9/4W1E/R4m7T
         iOFiutBRGEwlF2NpY55+YGr80Zx8xPWd9dpdKaD3sev5E3tqIfZME+H4ObiUjsrK7rat
         dNKXIsAMhRPiBRlZx1FoJqyuahs4W196tcbVGWCzdj0BglOdcp8VRaNY1M5wK8cdIPx6
         1QckOZc9+ssbQLRFxRpLaMAs3dfDL26xV71neoIOmwr97oS8di6sG6oGMMHBNL9fxjKk
         iVhw==
X-Gm-Message-State: AO0yUKX0RSqTmLWLaz5ArfLiUpDDADI2jgyY82xSJI2Jzc8yaBCX6vhz
        k300byafNj1wd+qN4lEUg71vsBCOWd96nImydBrZJhISYz1UwcIg0flKLb75P9ECOsfTa+eqo2X
        7ABbyB3upCEuKmEZFeskzIB+tO0Hgdvgg
X-Received: by 2002:a05:6808:1812:b0:37a:3ebc:d282 with SMTP id bh18-20020a056808181200b0037a3ebcd282mr1156465oib.217.1676946273117;
        Mon, 20 Feb 2023 18:24:33 -0800 (PST)
X-Google-Smtp-Source: AK7set+6NywEB1zq22G+QoHE8VrrKOnb9qGD7CaXNuTq8DRiBe+W6i7pFDEr1e9G9QtWCZKIHMIcpO0oaN2ttymqKXQ=
X-Received: by 2002:a05:6808:1812:b0:37a:3ebc:d282 with SMTP id
 bh18-20020a056808181200b0037a3ebcd282mr1156463oib.217.1676946272832; Mon, 20
 Feb 2023 18:24:32 -0800 (PST)
MIME-Version: 1.0
References: <20230217121547.3958716-1-jiri@resnulli.us> <20230217072032-mutt-send-email-mst@kernel.org>
 <Y+94418p73aUQyIn@nanopsycho> <20230217083915-mutt-send-email-mst@kernel.org>
 <Y/MwtAGru3yAY7r3@nanopsycho> <20230220074947-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230220074947-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 21 Feb 2023 10:24:21 +0800
Message-ID: <CACGkMEunrAtqRk-F56q8UBCLj61O0jsiJdKPJKt_EtuWJaMQCA@mail.gmail.com>
Subject: Re: [patch net-next] net: virtio_net: implement exact header length
 guest feature
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, virtualization@lists.linux-foundation.org,
        Vitaly Mireyno <vmireyno@marvell.com>
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

On Mon, Feb 20, 2023 at 8:55 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Mon, Feb 20, 2023 at 09:35:00AM +0100, Jiri Pirko wrote:
> > Fri, Feb 17, 2023 at 02:47:36PM CET, mst@redhat.com wrote:
> > >On Fri, Feb 17, 2023 at 01:53:55PM +0100, Jiri Pirko wrote:
> > >> Fri, Feb 17, 2023 at 01:22:01PM CET, mst@redhat.com wrote:
> > >> >On Fri, Feb 17, 2023 at 01:15:47PM +0100, Jiri Pirko wrote:
> > >> >> From: Jiri Pirko <jiri@nvidia.com>
> > >> >>
> > >> >> virtio_net_hdr_from_skb() fills up hdr_len to skb_headlen(skb).
> > >> >>
> > >> >> Virtio spec introduced a feature VIRTIO_NET_F_GUEST_HDRLEN which when
> > >> >> set implicates that the driver provides the exact size of the header.
> > >> >>
> > >> >> The driver already complies to fill the correct value. Introduce the
> > >> >> feature and advertise it.
> > >> >>
> > >> >> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> > >> >
> > >> >Could you add a bit of motivation just for the record?
> > >> >Does this improve performance for some card? By how much?
> > >> >Expected to help some future card?
> > >>
> > >> I can get that info, but isn't that rather something to be appended to
> > >> the virtio-spec patch? I mean, the feature is there, this is just
> > >> implementing it in one driver.
> > >
> > >It is more like using it in the driver.  It's not like we have to use
> > >everything - it could be useful for e.g. dpdk but not linux.
> > >Implementing it in the Linux driver has support costs - for example what
> > >if there's a bug and sometimes the length is incorrect?
> > >We'll be breaking things.
> >
> > I understand. To my understanding this feature just fixes the original
> > ambiguity in the virtio spec.
> >
> > Quoting the original virtio spec:
> > "hdr_len is a hint to the device as to how much of the header needs to
> >  be kept to copy into each packet"
> >
> > "a hint" might not be clear for the reader what does it mean, if it is
> > "maybe like that" of "exactly like that". This feature just makes it
> > crystal clear.
> >
> > If you look at the tap implementation, it uses hdr_len to alloc
> > skb linear part. No hint, it counts with the provided value.
> > So if the driver is currently not precise, it breaks tap.
>
> Well that's only for gso though right?
> And making it bigger than necessary works fine ...

It should work otherwise it's a bug after this commit:

commit 96f8d9ecf227638c89f98ccdcdd50b569891976c
Author: Jason Wang <jasowang@redhat.com>
Date:   Wed Nov 13 14:00:39 2013 +0800

    tuntap: limit head length of skb allocated

Thanks

>
> > I will add this to the patch description and send v2.
> >
>
> I feel this does not answer the question yet, or maybe I am being dense.
> My point was not about making hdr_len precise.  My point was that we are
> making a change here for no apparent reason. I am guessing you are not
> doing it for fun - so why? Is there a device with this feature bit
> you are aware of?
>
>
>
> >
> > >
> > >The patch was submitted by Marvell but they never bothered with
> > >using it in Linux. I guess they are using it for something else?
> > >CC Vitaly who put this in.
> > >
> > >>
> > >> >
> > >> >thanks!
> > >> >
> > >> >
> > >> >> ---
> > >> >>  drivers/net/virtio_net.c        | 6 ++++--
> > >> >>  include/uapi/linux/virtio_net.h | 1 +
> > >> >>  2 files changed, 5 insertions(+), 2 deletions(-)
> > >> >>
> > >> >> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > >> >> index fb5e68ed3ec2..e85b03988733 100644
> > >> >> --- a/drivers/net/virtio_net.c
> > >> >> +++ b/drivers/net/virtio_net.c
> > >> >> @@ -62,7 +62,8 @@ static const unsigned long guest_offloads[] = {
> > >> >>         VIRTIO_NET_F_GUEST_UFO,
> > >> >>         VIRTIO_NET_F_GUEST_CSUM,
> > >> >>         VIRTIO_NET_F_GUEST_USO4,
> > >> >> -       VIRTIO_NET_F_GUEST_USO6
> > >> >> +       VIRTIO_NET_F_GUEST_USO6,
> > >> >> +       VIRTIO_NET_F_GUEST_HDRLEN
> > >> >>  };
> > >> >>
> > >> >>  #define GUEST_OFFLOAD_GRO_HW_MASK ((1ULL << VIRTIO_NET_F_GUEST_TSO4) | \
> > >> >> @@ -4213,7 +4214,8 @@ static struct virtio_device_id id_table[] = {
> > >> >>         VIRTIO_NET_F_CTRL_MAC_ADDR, \
> > >> >>         VIRTIO_NET_F_MTU, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS, \
> > >> >>         VIRTIO_NET_F_SPEED_DUPLEX, VIRTIO_NET_F_STANDBY, \
> > >> >> -       VIRTIO_NET_F_RSS, VIRTIO_NET_F_HASH_REPORT, VIRTIO_NET_F_NOTF_COAL
> > >> >> +       VIRTIO_NET_F_RSS, VIRTIO_NET_F_HASH_REPORT, VIRTIO_NET_F_NOTF_COAL, \
> > >> >> +       VIRTIO_NET_F_GUEST_HDRLEN
> > >> >>
> > >> >>  static unsigned int features[] = {
> > >> >>         VIRTNET_FEATURES,
> > >> >> diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virtio_net.h
> > >> >> index b4062bed186a..12c1c9699935 100644
> > >> >> --- a/include/uapi/linux/virtio_net.h
> > >> >> +++ b/include/uapi/linux/virtio_net.h
> > >> >> @@ -61,6 +61,7 @@
> > >> >>  #define VIRTIO_NET_F_GUEST_USO6        55      /* Guest can handle USOv6 in. */
> > >> >>  #define VIRTIO_NET_F_HOST_USO  56      /* Host can handle USO in. */
> > >> >>  #define VIRTIO_NET_F_HASH_REPORT  57   /* Supports hash report */
> > >> >> +#define VIRTIO_NET_F_GUEST_HDRLEN  59  /* Guest provides the exact hdr_len value. */
> > >> >>  #define VIRTIO_NET_F_RSS         60    /* Supports RSS RX steering */
> > >> >>  #define VIRTIO_NET_F_RSC_EXT     61    /* extended coalescing info */
> > >> >>  #define VIRTIO_NET_F_STANDBY     62    /* Act as standby for another device
> > >> >> --
> > >> >> 2.39.0
> > >> >
> > >
>

