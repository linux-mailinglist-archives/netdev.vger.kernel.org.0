Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48E02507F13
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 04:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343528AbiDTCuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 22:50:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242900AbiDTCuD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 22:50:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 83E1538796
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 19:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650422837;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4FdYUVfV61WLVDVI9kuj+7fCK1y/uDwzu1x8ghdoN8Y=;
        b=NKPUgoBQp8XJsQe/f5OAqs3SytegUQeA/x6KZj7azHBtuHcgdqpCOnTnbmDK57GvOqryIH
        fXjXk8OF1KOIWP8HnLhQXXmC0SKqJX+PptCBoFxvoTazQCZ12fnwyN+F8uhuomsyA4buD7
        PqycW+pwQ2V5RO060wGRZkmFuxREz0s=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-471-Ic4rC0ebNxm5ZfUX6qZxLA-1; Tue, 19 Apr 2022 22:47:16 -0400
X-MC-Unique: Ic4rC0ebNxm5ZfUX6qZxLA-1
Received: by mail-lf1-f71.google.com with SMTP id z20-20020a19e214000000b0046d1726edd8so128924lfg.13
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 19:47:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4FdYUVfV61WLVDVI9kuj+7fCK1y/uDwzu1x8ghdoN8Y=;
        b=QdBgsiv2RrwjfvWYUFRfdUGB/N7X+SPnZVdcFMIlkD5bqvDSD5kzPH8f1/rGHPRPco
         mQy0Wmsh8MQ2z+TWmz4eZHadYu6Q5gmivfBS8UkxWqWHsrqVzT2IyQuwioiiAlBvBDbF
         VQLjwxLXSRsSKVkwKcUA1LoSVjV/DRX+fciQiYmMmn5vKetfVTjG1KJvskcXvZMnZQ5i
         3IY/IxQL1JEr/RwtT+7xSBrU3+DfmH7qQsd3+ZeAdxFfpaSz3356jnzObeHLqu5r8FOq
         klV244+4RxV48C8842xVEuayVeoh0MfwBlWGNJk8cZB5jD8wWufHURG9svRvZou40OOK
         XXiQ==
X-Gm-Message-State: AOAM532nXQGCTla3n9e8OPF0FaZSUuicWT3pmUVSBL69ABgkwAvrkoyS
        FYYE4jvfz6fkdCRpOv0zXXNlBA0RDbP4XY4a7Ar7LgPmqCG2qw0TAADnJL82ulQVxEm6QxbUNdh
        29oolY/H/GtTr9cSPDjgjlw1xi2cAI43s
X-Received: by 2002:a05:6512:33d0:b0:471:a625:fdc0 with SMTP id d16-20020a05651233d000b00471a625fdc0mr4736053lfg.98.1650422834657;
        Tue, 19 Apr 2022 19:47:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxo5vRdEN2eelrx3uNE6z+vLcL5KiIhfKbTD1ONUHhWXYF2pykhV84CLmlMkE9rEGRzWsJtROrkSrpmQ8GB0Ts=
X-Received: by 2002:a05:6512:33d0:b0:471:a625:fdc0 with SMTP id
 d16-20020a05651233d000b00471a625fdc0mr4736033lfg.98.1650422834446; Tue, 19
 Apr 2022 19:47:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220418044339.127545-1-liuhangbin@gmail.com> <20220418044339.127545-2-liuhangbin@gmail.com>
 <CA+FuTScQ=tP=cr5f2S97Z7ex1HMX5R-C0W6JE2Bx5UWgiGknZA@mail.gmail.com>
 <Yl4mU0XLmPukG0WO@Laptop-X1> <CA+FuTSfBU7ck91ayf_t9=7eRGJZHuWSeXzX2SxFAQMPSitY9SA@mail.gmail.com>
 <20220419101325-mutt-send-email-mst@kernel.org> <Yl9bDrDFZhc04MiY@Laptop-X1>
In-Reply-To: <Yl9bDrDFZhc04MiY@Laptop-X1>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 20 Apr 2022 10:47:03 +0800
Message-ID: <CACGkMEvV1kOye=iVsURa8PR6mtXH8cwuYZ8hWoxcJAHs8kREew@mail.gmail.com>
Subject: Re: [PATCH net 1/2] net/af_packet: adjust network header position for
 VLAN tagged packets
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Mike Pattrick <mpattric@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Balazs Nemeth <bnemeth@redhat.com>,
        Flavio Leitner <fbl@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 20, 2022 at 9:00 AM Hangbin Liu <liuhangbin@gmail.com> wrote:
>
> On Tue, Apr 19, 2022 at 10:26:09AM -0400, Michael S. Tsirkin wrote:
> > > > There are also some duplicated codes in these *_snd functions.
> > > > I think we can move them out to one single function.
> > >
> > > Please don't refactor this code. It will complicate future backports
> > > of stable fixes.
> >
> > Hmm I don't know offhand which duplication this refers to specifically
> > so maybe it's not worth addressing specifically but generally not
> > cleaning up code just because of backports seems wrong ...
>
> Yes, packet_snd() and tpacket_snd() share same addr/msg checking logic that
> I think we can clean up.
>
> > > > > stretching the definition of the flags to include VLAN is acceptable
> > > > > (unlike outright tunnels), but even then I would suggest for net-next.
> > > >
> > > > As I asked, I'm not familiar with virtio code. Do you think if I should
> > > > add a new VIRTIO_NET_HDR_GSO_VLAN flag? It's only a L2 flag without any L3
> > > > info. If I add something like VIRTIO_NET_HDR_GSO_VLAN_TCPV4/TCPV6/UDP. That
> > > > would add more combinations. Which doesn't like a good idea.
> > >
> > > I would prefer a new flag to denote this type, so that we can be
> > > strict and only change the datapath for packets that have this flag
> > > set (and thus express the intent).
> > >
> > > But the VIRTIO_NET_HDR types are defined in the virtio spec. The
> > > maintainers should probably chime in.
> >
> > Yes, it's a UAPI extension, not to be done lightly. In this case IIUC
> > gso_type in the header is only u8 - 8 bits and 5 of these are already
> > used.  So I don't think the virtio TC will be all that happy to burn up
> > a bit unless a clear benefit can be demonstrated.
> >
> > I agree with the net-next proposal, I think it's more a feature than a
> > bugfix. In particular I think a Fixes tag can also be dropped in that
> > IIUC GSO for vlan packets didn't work even before that commit - right?

It should work, we initialize vlan_features since ("4fda830263c5
virtio-net: initialize vlan_features").

What we don't support is vlan offload.

>
> Right. virtio_net_hdr GSO with vlan doesn't work before.

It doesn't work since we don't support that feature.

> I will post this to net-next.

If you want to do that, you need a spec patch as well.

Thanks

>
> Thanks
> Hangbin
>

