Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E65B5B7FAA
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 05:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbiINDrQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 23:47:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbiINDrO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 23:47:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B47506EF3F
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 20:47:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663127232;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fwI4pxFaOpyghP4nKqCzlpD4iYPI4aC9XKzX8S9lXFE=;
        b=HhqvSICIzTLqGn9mreFaJS8PycNfJx6SKdh9sr8eTWnhg3EqmDHVjNPx82JLyPfrdVSush
        FF8nl6o9hYTctg9I7KiBv14Qf6Z5wZEw8kkdt0Ngnf7PjWtYmiR1v4UkJcFZwN1/O6qmuQ
        u5w33asrSWV2HcS8P212tlAV8/B4Ap0=
Received: from mail-ua1-f71.google.com (mail-ua1-f71.google.com
 [209.85.222.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-607-QUEOYPAUP4iKY-UXcsOdvQ-1; Tue, 13 Sep 2022 23:47:08 -0400
X-MC-Unique: QUEOYPAUP4iKY-UXcsOdvQ-1
Received: by mail-ua1-f71.google.com with SMTP id r33-20020a9f3624000000b0039efb8959e3so3980841uad.0
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 20:47:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=fwI4pxFaOpyghP4nKqCzlpD4iYPI4aC9XKzX8S9lXFE=;
        b=5JDMqy6lXI8h+ipsePxUpVIB4BxNbvh2ms4wooBdiNwbjA/3wWx0vfhONUjl3Shcel
         YtUpaLVHx9zmWA2GQz/G6k1D+MZkoaBjp2xWbZEhfTidXZUsQQfjjECyiqdpyLY0TQCx
         f6jmbW4DRcROu5jx/lNPNFfEOChqYi/ycVqZjGWWeA9pYbcm4eApwoR+dQzP8zef7kcy
         FzHju5yp69wvUjhFFUvdsTgurEQnolotgR3G+Q7nnqXluhKUUX1gAqQVdrUy+s8p//OY
         BDgMbUchBZy5wErqTWhCBS7JpjWrbdj0uvWIhNstLkJWcK8vULuSs6P0R2vw5AIFhOAo
         xV/Q==
X-Gm-Message-State: ACgBeo0WiP18GQoP25ITN/J32RRvZqRwJdMpxL2N9LT4H7d9Wq4mSqDP
        arYlkz1DIlhqFxCewS9k8elg5s3wH+1bqzCSCfexhE0yu3QKMn14c7Lfa/CtFGwWkU3do50k1FA
        +S9wXvsrZi/IDQsxGPGFv4Ni1Pd++RjA3
X-Received: by 2002:a05:6102:1341:b0:398:889e:7f28 with SMTP id j1-20020a056102134100b00398889e7f28mr4865563vsl.21.1663127227530;
        Tue, 13 Sep 2022 20:47:07 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5Ha3KMq4e+ZRq90AitAHpMvWzaF8YgV8fHH5lOzOSmrBmP4SuDkkqvhsU03bmmRyugK+A88DC7xMXq7SvjUso=
X-Received: by 2002:a05:6102:1341:b0:398:889e:7f28 with SMTP id
 j1-20020a056102134100b00398889e7f28mr4865558vsl.21.1663127227296; Tue, 13 Sep
 2022 20:47:07 -0700 (PDT)
MIME-Version: 1.0
References: <CADZGycYUH=j80zmJVr7dfVtoJ+BrbAEPJE8Nvf3HR5oimJR+UQ@mail.gmail.com>
In-Reply-To: <CADZGycYUH=j80zmJVr7dfVtoJ+BrbAEPJE8Nvf3HR5oimJR+UQ@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 14 Sep 2022 11:46:56 +0800
Message-ID: <CACGkMEvNMDG=9tYAWDOqdYKMy-Sk3qShQX3PWGQZBcdvZ7y3Tw@mail.gmail.com>
Subject: Re: [Q] packet truncated after enabling ip_forward for virtio-net in guest
To:     Wei Yang <richard.weiyang@gmail.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 13, 2022 at 11:43 PM Wei Yang <richard.weiyang@gmail.com> wrote:
>
> Hi, I am running a guest with vhost-net as backend. After I enable
> ip_forward, the packet received is truncated.
>
> Host runs a 5.10 kernel, while guest kernel is v5.11 which doesn't
> include this commit:
>
>   virtio-net: use NETIF_F_GRO_HW instead of NETIF_F_LRO
>
> After applying this commit, the issue is gone. I guess the reason is
> this device doesn't have NETIF_F_GRO_HW set,

Note that form device POV, it should be VIRTIO_NET_F_GUEST_TSOX.

> so
> virtnet_set_guest_offloads is not called.
>
> I am wondering why packet is truncated without this fix. I follow
> virtnet_set_guest_offloads and just see virtio_net_handle_ctrl in qemu
> handles VIRTIO_NET_CTRL_GUEST_OFFLOADS. Since we use a tap dev, then I
> follow tap_fd_set_offload to ioctl(fd, TUNSETOFFLOAD, offload).
>
> But I am lost here. tap_ioctl -> set_offload(). Since we use a normal
> tap device instead of ipvtap/macvtap, update_features is empty. So I
> don't get how the device's behavior is changed after set LRO.
>
> Do I follow the wrong path? Any suggestions on investigation?

Note that if you are using tuntap, you should refert driver/net/tun.c
instead of tap.c. Where it calls netdev_update_features() that will
change the TX offloading.

Thanks

>
> I'd appreciate it if someone could give a hint :-)
>

