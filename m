Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E672D506F20
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 15:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352928AbiDSN4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 09:56:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346248AbiDSN4K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 09:56:10 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68863FC8
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 06:53:25 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id x24so3778289qtq.11
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 06:53:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fgHgtJi2JyvqtaEhK4OrYC/rmPwWeLIz8PCQ10U4/yc=;
        b=C9M0V4Cy04uoUbtB//0phZ2HzQiEgo8DzIpSewKxIqZI5sxC1VDV6dQBcdbQTGIx7u
         6KLV7oteDB3Kp1K2on9MJ7tlZo1WpTIGuz0X0bNM6Ie/VCDrSU5/KVRGH1tgcBiQjT33
         XZ6NSpUBLhuKyCVNMnFf/Uwunm4IJJg/sWRdX6+7FJTWQdUAFyK45O9m2lemhP3j5lqE
         a4yB3ai+H7omOObdr3eAXOfEPGfF50jCtNY52nV2hTyv4gDcib+CPM7Xv9bHGKbmILPA
         R7+4n12a080WQ8LFg2x8GVp77dcIfmsw8YR+Vfydb/pZCbHg3oFxGy/k6UzniY1AIOaj
         FBkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fgHgtJi2JyvqtaEhK4OrYC/rmPwWeLIz8PCQ10U4/yc=;
        b=m10/HLHuktc3D+sOkEVy+SCLFHcj46sE3LY0AX/sFh3usBKRmHZ8zKkji+2tEHczOi
         5AbqRdlqZsi0+g2D5f9/S5CrKsw6WbwO6rqHv8QZVjC/u11nVghz4N9ENFqI/ophpxPd
         jdyxGVQeRU5AG0gnClY1ZSjK5qSZS+vE8DruazviNqzUfZ58W1S2ENfIFb4SVOxMEA3J
         0Vw/SU56CoBtcNzT5iKSIIWDa8fxr2MsixTHKYY4Ggq7wlothGmoQPlLg2QKE6TfCftc
         ck+QMS99mAE0LHDVNb8RfQyej0ljH/43hX1NrN4xB41EHdadl7TGBLdANcs5ReQbhUle
         y9RA==
X-Gm-Message-State: AOAM532+VSyeoT/m9Hhl+QpqXIUWkGNCrUXmKXIlxarPUh3re5KE1RtX
        qevuk+jdiyrwVS0tqHZjDCUBr0wxB9o=
X-Google-Smtp-Source: ABdhPJxpvq/qPTbAznvocQAIZ1DY8OkWy5A6hZwscTScV+1pChI1Ui0sMmmGHFp2Lr8uYhU0XesdsA==
X-Received: by 2002:ac8:5815:0:b0:2e2:2d63:ac13 with SMTP id g21-20020ac85815000000b002e22d63ac13mr10351170qtg.469.1650376404435;
        Tue, 19 Apr 2022 06:53:24 -0700 (PDT)
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com. [209.85.128.174])
        by smtp.gmail.com with ESMTPSA id g19-20020ac87f53000000b002f1c774a4cbsm57552qtk.12.2022.04.19.06.53.23
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Apr 2022 06:53:23 -0700 (PDT)
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-2ec42eae76bso172871657b3.10
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 06:53:23 -0700 (PDT)
X-Received: by 2002:a81:8304:0:b0:2ef:1922:c82 with SMTP id
 t4-20020a818304000000b002ef19220c82mr15468842ywf.348.1650376402709; Tue, 19
 Apr 2022 06:53:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220418044339.127545-1-liuhangbin@gmail.com> <20220418044339.127545-3-liuhangbin@gmail.com>
 <CA+FuTSdTbpYGJo6ec2Ti+djXCj=gBAQpv9ZVaTtaJA-QUNNgYQ@mail.gmail.com> <Yl4pG8MN7jxVybPB@Laptop-X1>
In-Reply-To: <Yl4pG8MN7jxVybPB@Laptop-X1>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 19 Apr 2022 09:52:46 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdLGUgbkP3U+zmqoFzrewnUUN3pci8q8oNfHzo11ZhRZg@mail.gmail.com>
Message-ID: <CA+FuTSdLGUgbkP3U+zmqoFzrewnUUN3pci8q8oNfHzo11ZhRZg@mail.gmail.com>
Subject: Re: [PATCH net 2/2] virtio_net: check L3 protocol for VLAN packets
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Mike Pattrick <mpattric@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        virtualization@lists.linux-foundation.org,
        Balazs Nemeth <bnemeth@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 18, 2022 at 11:14 PM Hangbin Liu <liuhangbin@gmail.com> wrote:
>
> On Mon, Apr 18, 2022 at 11:40:44AM -0400, Willem de Bruijn wrote:
> > On Mon, Apr 18, 2022 at 12:44 AM Hangbin Liu <liuhangbin@gmail.com> wrote:
> > >
> > > For gso packets, virtio_net_hdr_to_skb() will check the protocol via
> > > virtio_net_hdr_match_proto(). But a packet may come from a raw socket
> > > with a VLAN tag. Checking the VLAN protocol for virtio net_hdr makes no
> > > sense. Let's check the L3 protocol if it's a VLAN packet.
> > >
> > > Make the virtio_net_hdr_match_proto() checking for all skbs instead of
> > > only skb without protocol setting.
> > >
> > > Also update the data, protocol parameter for
> > > skb_flow_dissect_flow_keys_basic() as the skb->protocol may not IP or IPv6.
> > >
> > > Fixes: 7e5cced9ca84 ("net: accept UFOv6 packages in virtio_net_hdr_to_skb")
> > > Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> > > ---
> > >  include/linux/virtio_net.h | 26 +++++++++++++++++++-------
> > >  1 file changed, 19 insertions(+), 7 deletions(-)
> > >
> > > diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
> > > index a960de68ac69..97b4f9680786 100644
> > > --- a/include/linux/virtio_net.h
> > > +++ b/include/linux/virtio_net.h
> > > @@ -3,6 +3,7 @@
> > >  #define _LINUX_VIRTIO_NET_H
> > >
> > >  #include <linux/if_vlan.h>
> > > +#include <uapi/linux/if_arp.h>
> > >  #include <uapi/linux/tcp.h>
> > >  #include <uapi/linux/udp.h>
> > >  #include <uapi/linux/virtio_net.h>
> > > @@ -102,25 +103,36 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
> > >                  */
> > >                 if (gso_type && skb->network_header) {
> >
> > This whole branch should not be taken by well formed packets. It is
> > inside the else clause of
> >
> >        if (hdr->flags & VIRTIO_NET_HDR_F_NEEDS_CSUM) {
> >           ..
> >        } else {
> >
> > GSO packets should always request checksum offload. The fact that we
> > try to patch up some incomplete packets should not have to be expanded
> > if we expand support to include VLAN.
>
> Hi Willem,
>
> I'm not sure if I understand correctly. Do you mean we don't need to check
> L3 protocols for VLAN packet without NEEDS_CSUM flag? Which like
>
> if (hdr->flags & VIRTIO_NET_HDR_F_NEEDS_CSUM) {
>         ...
> } else if (!eth_type_vlan(skb->protocol)) {
>         ...
> }

Segmentation offload requires checksum offload. Packets that request
GSO but not NEEDS_CSUM are an aberration. We had to go out of our way
to handle them because the original implementation did not explicitly
flag and drop these. But we should not extend that to new types.
