Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6FDB43C02A
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 04:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238561AbhJ0Cr6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 22:47:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33408 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238198AbhJ0Cr5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 22:47:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635302732;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9muq5ZSeJhvEW0ZLoiZHIrlbDuVWUKDsCoalzlqdM5A=;
        b=L5qkEK3TZLw97F41TDywZJC9bqbaFenEnHow6/BWqUIkG6HBPVzoyMh8DfArpgzN0ARPD7
        D/fg/4S1M+/GGxE3fBqmFHSlYiMNf3rswZEQmEPQb7Bl0JZj/W17Rkg7SS5UNeFGtFaBY/
        dU9z1MmoVTfzhIpSTLpU9rjG5AKdZsw=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-172-Mbn9De7vN8um_OZ5QxnZAA-1; Tue, 26 Oct 2021 22:45:31 -0400
X-MC-Unique: Mbn9De7vN8um_OZ5QxnZAA-1
Received: by mail-lf1-f71.google.com with SMTP id z7-20020a0565120c0700b003ffb3da4283so648501lfu.23
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 19:45:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9muq5ZSeJhvEW0ZLoiZHIrlbDuVWUKDsCoalzlqdM5A=;
        b=nadZ7X7QIRkVTzrUj/tr9yCpJoZE138jwSU30quhTuO4pVtw5Jhdi64zaSQPPlqMWC
         6ZekHOAKJDFZIsBbwNcaAjqgOfBnn6jLuQoCa9cjOcqtHeYn9WzL1bplRbyIjcLsWf9E
         hrqYZA0+bFsTnO57/Hv/VGyui8LHGBfsYQBZW9Ddak35PeLwzPRpOMazBs3mFD3W3Dzb
         oggXrDl84p4NkUI7KxAPaGgKt+LCGRRpanvQvwyFI/0IFgQlPKXbiLnig/PWWML4hpvF
         Fbvzahp8urMBfxzWVFsjrgiFbODdkZH50FIO7SeFQAOL7SJDGynsYVB2PXAZ4iiPHZC2
         FVcg==
X-Gm-Message-State: AOAM531V/vPOMbiMzevOTzhA53IOLj48Z3LsFZz3mSt3SinnL0+OtZyt
        tXtgq/+PDwktQ7bonWqN2zkJq1zX/4QjF1Zg5mRENexCgFxSRV6UjXa+gYcjkPo4CqreTQB05hO
        +TrYQDdc84DFH4SBxlnGie5UlN823I2nC
X-Received: by 2002:a2e:8846:: with SMTP id z6mr8569200ljj.277.1635302729837;
        Tue, 26 Oct 2021 19:45:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwitG53CURCkAynKzlzA1GM5af5iJeQG5F8KL26fH3RBWG/gNDMvl4rD5ruG1VHbCwlszT8J9sPX2R+YcJ0kb4=
X-Received: by 2002:a2e:8846:: with SMTP id z6mr8569181ljj.277.1635302729680;
 Tue, 26 Oct 2021 19:45:29 -0700 (PDT)
MIME-Version: 1.0
References: <20211026175634.3198477-1-kuba@kernel.org>
In-Reply-To: <20211026175634.3198477-1-kuba@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 27 Oct 2021 10:45:18 +0800
Message-ID: <CACGkMEu6ZnyJF2nKS-GURc2Fz8BqUY6OGFEa71fNKPfGA0Wp7g@mail.gmail.com>
Subject: Re: [PATCH net-next] net: virtio: use eth_hw_addr_set()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
        mst <mst@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 27, 2021 at 1:56 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
> of VLANs...") introduced a rbtree for faster Ethernet address look
> up. To maintain netdev->dev_addr in this tree we need to make all
> the writes to it go through appropriate helpers.

I think the title should be "net: virtio: use eth_hw_addr_set()"

>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: mst@redhat.com
> CC: jasowang@redhat.com
> CC: virtualization@lists.linux-foundation.org
> ---
>  drivers/net/virtio_net.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index c501b5974aee..b7f35aff8e82 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -3177,12 +3177,16 @@ static int virtnet_probe(struct virtio_device *vdev)
>         dev->max_mtu = MAX_MTU;
>
>         /* Configuration may specify what MAC to use.  Otherwise random. */
> -       if (virtio_has_feature(vdev, VIRTIO_NET_F_MAC))
> +       if (virtio_has_feature(vdev, VIRTIO_NET_F_MAC)) {
> +               u8 addr[MAX_ADDR_LEN];
> +
>                 virtio_cread_bytes(vdev,
>                                    offsetof(struct virtio_net_config, mac),
> -                                  dev->dev_addr, dev->addr_len);
> -       else
> +                                  addr, dev->addr_len);
> +               dev_addr_set(dev, addr);
> +       } else {
>                 eth_hw_addr_random(dev);
> +       }

Do we need to change virtnet_set_mac_address() as well?

Thanks

>
>         /* Set up our device-specific information */
>         vi = netdev_priv(dev);
> --
> 2.31.1
>

