Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D70B652999B
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 08:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239924AbiEQGcS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 02:32:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231146AbiEQGcR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 02:32:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A71A2D4A
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 23:32:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652769134;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tyrw7Fs5af1WocF+1NFu5sorailBB9qMhsdDA/eQUgs=;
        b=YUYNagvkuYIXft2zKJ5teBun/WeHFyeZn959jLqOiNgho0o7QZx4cFIFLCqvQlK+nh0McO
        ZfD6Xsb5snIn+u9eVXOb9upXUK9rU2AQFZGuPRuk+C4mTjADlpUrdlHPEbZoyMeBC29AMD
        f1MeFLbIJ+qyCdwk2dTs6EaalmahOZA=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-631-I7YaiLU2NmCbB8TRgqogCA-1; Tue, 17 May 2022 02:32:13 -0400
X-MC-Unique: I7YaiLU2NmCbB8TRgqogCA-1
Received: by mail-lj1-f199.google.com with SMTP id m5-20020a2e8705000000b0024f0fca4516so4042104lji.3
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 23:32:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tyrw7Fs5af1WocF+1NFu5sorailBB9qMhsdDA/eQUgs=;
        b=naC+8X9YX/JQkmYXBA98PvwYyZCytOrJV3OiAfjIJayMFQsZzHvj3xphNkK5JEReBK
         Qp/FBKDmpV99DWwe6oCQ9sLFKhPOR5KOoGe4fZuvJyhxuVo/RUUxBUvfSh1hX5iwqgdT
         AJ/MPXOCA1AxosNOQ6D68Q355h28d/+FpqSfLjmxz/1+IfUb1DFmpJRmGhGSc2TdtpY3
         e4MSgWPr7TmFPWU3MZyYTR0U6M1xtJkBwXGOl66K1mUzAW6uCRe0IUqBmpNMkj9oUqD5
         x5VmWI+rwZ7UG3Q8Q13sp65fT0fbp+3vG/vHiv3UA+xAKu3CeHgGyxWVX1HKBXC7z4rk
         uS4w==
X-Gm-Message-State: AOAM5337JqB2o1n5PcrlUjRcST/xmBtoGWB9O3SwTzaLjasVXoJndtEi
        iOGnD1V6uRKJuf/zWKlyfGt8hIU38v6iiZlpuGCdj5HfXfnsILXwjW0EQoUOTNXYaR4fedwwAyZ
        xZfAMALOWgJD/dGhUfNhBosF/KDWZZzsM
X-Received: by 2002:a05:6512:33d0:b0:473:a25e:f9fb with SMTP id d16-20020a05651233d000b00473a25ef9fbmr15703950lfg.98.1652769131490;
        Mon, 16 May 2022 23:32:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx6g8tOmupVRqttN7WDRP44n6fuYeMH5lXesAtmPnbagzn8zytd8vAd7VMUwdVlbWPpI9ns+9bblO+ugjvA7ZM=
X-Received: by 2002:a05:6512:33d0:b0:473:a25e:f9fb with SMTP id
 d16-20020a05651233d000b00473a25ef9fbmr15703935lfg.98.1652769131310; Mon, 16
 May 2022 23:32:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220512112347.18717-1-andrew@daynix.com>
In-Reply-To: <20220512112347.18717-1-andrew@daynix.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 17 May 2022 14:32:00 +0800
Message-ID: <CACGkMEvH1yE0CZYdstAK32DkEucejNO+V7PEAZD_641+rp2aKA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/5] TUN/VirtioNet USO features support.
To:     Andrew Melnychenko <andrew@daynix.com>
Cc:     davem <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, mst <mst@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Yan Vugenfirer <yan@daynix.com>,
        Yuri Benditovich <yuri.benditovich@daynix.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 12, 2022 at 7:33 PM Andrew Melnychenko <andrew@daynix.com> wrote:
>
> Added new offloads for TUN devices TUN_F_USO4 and TUN_F_USO6.
> Technically they enable NETIF_F_GSO_UDP_L4
> (and only if USO4 & USO6 are set simultaneously).
> It allows to transmission of large UDP packets.
>
> Different features USO4 and USO6 are required for qemu where Windows guests can
> enable disable USO receives for IPv4 and IPv6 separately.
> On the other side, Linux can't really differentiate USO4 and USO6, for now.
> For now, to enable USO for TUN it requires enabling USO4 and USO6 together.
> In the future, there would be a mechanism to control UDP_L4 GSO separately.
>
> Test it WIP Qemu https://github.com/daynix/qemu/tree/Dev_USOv2
>
> New types for VirtioNet already on mailing:
> https://lists.oasis-open.org/archives/virtio-comment/202110/msg00010.html
>
> Also, there is a known issue with transmitting packages between two guests.

Could you explain this more? It looks like a bug. (Or any pointer to
the discussion)

Thanks

> Without hacks with skb's GSO - packages are still segmented on the host's postrouting.
>
> Andrew (5):
>   uapi/linux/if_tun.h: Added new offload types for USO4/6.
>   driver/net/tun: Added features for USO.
>   uapi/linux/virtio_net.h: Added USO types.
>   linux/virtio_net.h: Support USO offload in vnet header.
>   drivers/net/virtio_net.c: Added USO support.
>
>  drivers/net/tap.c               | 10 ++++++++--
>  drivers/net/tun.c               |  8 +++++++-
>  drivers/net/virtio_net.c        | 19 +++++++++++++++----
>  include/linux/virtio_net.h      |  9 +++++++++
>  include/uapi/linux/if_tun.h     |  2 ++
>  include/uapi/linux/virtio_net.h |  4 ++++
>  6 files changed, 45 insertions(+), 7 deletions(-)
>
> --
> 2.35.1
>

