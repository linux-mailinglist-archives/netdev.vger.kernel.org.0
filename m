Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9093557B154
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 09:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbiGTHCU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 03:02:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiGTHCT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 03:02:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2DF734B4B6
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 00:02:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658300538;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rU4j1J/tvqlFr93IFh6lQn/qW3Dsxbr+w/g0/ipU8B4=;
        b=IGhSbhWv+AGwZNL9l2Zg41Hpu4taIhvKKAlw4TbHy3H+fZzm5K9lMZTqQ2J7UzpNsTtqtJ
        Ecu/qPC6e5ZzX2jjLSDFAslFt+VaB1Fg4AQ2VTolHiwosONj9tIlWo3aoQOqsZuwyhnYm/
        5FKHvXWhazAKj/6j4rcWTNycCiq2mc0=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-377-VSNPK6MRPjGBCZQHOVgQMw-1; Wed, 20 Jul 2022 03:02:16 -0400
X-MC-Unique: VSNPK6MRPjGBCZQHOVgQMw-1
Received: by mail-lj1-f200.google.com with SMTP id l14-20020a2e99ce000000b0025dd695437fso115682ljj.21
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 00:02:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rU4j1J/tvqlFr93IFh6lQn/qW3Dsxbr+w/g0/ipU8B4=;
        b=I1on4GZon0I5+AdGjCl3fe6uzt/9I17AOCkZYrWwa4GA7ibftGsZT+kEij4u9Jrl2R
         xJci6qHTEIXSwQZQjrprYH07gpw2365thamcZAYK7kuuVLcr2IZxfdkTf47y8b2+H8y0
         e+yOsJn4OZdWJkv2AdJt9i9ThMjGPAHVKXrLjr9EZxe1DpAA3C8oODDOz3WHTYLxpskB
         1AC1XcxSmN6yj43uiXw5ruqdXyILakshS4PrqGfWsSpbj8lCNHg5/Awsa3pioeNB71Oh
         gXEAyw1zwXNbVYTu9OdxvhVMUeFmkryQNNYnMwj7sUnhJnAGPslbssTcvmrMRGWUDGEK
         0exA==
X-Gm-Message-State: AJIora/wpJPh4K1u37v/7TO/AHaqcFQcFkhRY/sWvOHvNn95Be4nbGBs
        /w/9UBl/hcut0xozFt0rvY3/EVx09rfG958IfKKaCw2/PUWbkrVm0XDYTKs7V/Ay2czz0vbWXT9
        L/mFV6IrrkJ4EuhpqeIesN80ebYR9z+m+
X-Received: by 2002:a05:6512:3c95:b0:48a:3d1:9df with SMTP id h21-20020a0565123c9500b0048a03d109dfmr20339633lfv.641.1658300535306;
        Wed, 20 Jul 2022 00:02:15 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1s46RTTUbHKKuDfdyLz9gCo87D0b7Ehp+yrh+gQJGtlaRjdSM8KmmGNtdnU6x8Ftym396+94smRHeuKJWdPaB8=
X-Received: by 2002:a05:6512:3c95:b0:48a:3d1:9df with SMTP id
 h21-20020a0565123c9500b0048a03d109dfmr20339623lfv.641.1658300535106; Wed, 20
 Jul 2022 00:02:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220718091102.498774-1-alvaro.karsz@solid-run.com>
 <20220719172652.0d072280@kernel.org> <20220720022901-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220720022901-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 20 Jul 2022 15:02:04 +0800
Message-ID: <CACGkMEvFdMRX-sb7hUpEq+6e04ubehefr8y5Gjnjz8R26f=qDA@mail.gmail.com>
Subject: Re: [PATCH net-next v4] net: virtio_net: notifications coalescing support
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Alvaro Karsz <alvaro.karsz@solid-run.com>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 20, 2022 at 2:45 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Tue, Jul 19, 2022 at 05:26:52PM -0700, Jakub Kicinski wrote:
> > On Mon, 18 Jul 2022 12:11:02 +0300 Alvaro Karsz wrote:
> > > New VirtIO network feature: VIRTIO_NET_F_NOTF_COAL.
> > >
> > > Control a Virtio network device notifications coalescing parameters
> > > using the control virtqueue.
> > >
> > > A device that supports this fetature can receive
> > > VIRTIO_NET_CTRL_NOTF_COAL control commands.
> > >
> > > - VIRTIO_NET_CTRL_NOTF_COAL_TX_SET:
> > >   Ask the network device to change the following parameters:
> > >   - tx_usecs: Maximum number of usecs to delay a TX notification.
> > >   - tx_max_packets: Maximum number of packets to send before a
> > >     TX notification.
> > >
> > > - VIRTIO_NET_CTRL_NOTF_COAL_RX_SET:
> > >   Ask the network device to change the following parameters:
> > >   - rx_usecs: Maximum number of usecs to delay a RX notification.
> > >   - rx_max_packets: Maximum number of packets to receive before a
> > >     RX notification.
> > >
> > > VirtIO spec. patch:
> > > https://lists.oasis-open.org/archives/virtio-comment/202206/msg00100.html
> > >
> > > Signed-off-by: Alvaro Karsz <alvaro.karsz@solid-run.com>
> >
> > Waiting a bit longer for Michael's ack, so in case other netdev
> > maintainer takes this:
> >
> > Reviewed-by: Jakub Kicinski <kuba@kernel.org>
>
> Yea was going to ack this but looking at the UAPI again we have a
> problem because we abused tax max frames values 0 and 1 to control napi
> in the past. technically does not affect legacy cards but userspace
> can't easily tell the difference, can it?

The "abuse" only works for iproute2. For uAPI we know it should follow
the spec? (anyhow NAPI is something out of the spec)

Thanks

>
> --
> MST
>

