Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 626326658BD
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 11:14:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238190AbjAKKNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 05:13:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239042AbjAKKM3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 05:12:29 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74845233
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 02:10:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673431823;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ab2T4X7uK9fotwvUe5iK/l1jUo4Z6arsl3GYiaGQgIA=;
        b=M4X2l4BFMCIlF+zjV7yZ3Ma8InVsGHTSnYw50/ChVhMEj51/82gT74Fy3A/+NTgHSDvStX
        98qJnCcfSCYVrc5GeILHQdMTCFo/49wSkim2+3V6m0MlCiWyGXbhXOiL7YSoZzkeso2+dH
        IsZYt0smjq51UBFfB9BmrZH4poHYf1A=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-385-v-RWskmzPcWPcsvoc8ENmA-1; Wed, 11 Jan 2023 05:10:22 -0500
X-MC-Unique: v-RWskmzPcWPcsvoc8ENmA-1
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-4597b0ff5e9so158194297b3.10
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 02:10:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ab2T4X7uK9fotwvUe5iK/l1jUo4Z6arsl3GYiaGQgIA=;
        b=GWpaJ6FGpMlczD1VMs0sqEpJKRp3EgQ1BeuZS+j1uTM5H746dRZ/6OCZ5vkV4D9NXC
         qhQCJQf+m96ZUkU3oh0kdnX7AgrniCxgsEONHm046mJK39tfHTTzOw+5WHE+k0axjggu
         nTSHIAdLAJpZD/rEIpwemd1MAFDGINGHBMer1hPZRRp5mjza4z38Z54gP1FbP+/z7DOI
         9Z46pvO17h2H0Wf03K2ozO8dVYwzK3OhyrHkXKGuj2vsItsnCs0PEGdi1ZCaJqjhjEjt
         LJWbw6nsC1TyxHAPDfSSQBNrSAk9/eI4K9NVPF5WDLUQ5kfLtz13SRlgLZ1lLsgKaWwa
         F+/Q==
X-Gm-Message-State: AFqh2kp/hH+DdDLOe0XXYjV6LlKJvOsMMZZjwRx0FSctWjDkCNZpASS2
        YIpSjfLBULF+CSQCFFwjelk1cO6k/rM1+Y+NxcddwV7mVU9poV9DDu2ZoAV50VTc0sKgdbxqFrw
        VfIV5awmfR0oaHof/IIzjxgOCQB7N2rsP
X-Received: by 2002:a81:5292:0:b0:483:813:c70f with SMTP id g140-20020a815292000000b004830813c70fmr272930ywb.266.1673431821539;
        Wed, 11 Jan 2023 02:10:21 -0800 (PST)
X-Google-Smtp-Source: AMrXdXut4p3VM0yD8/5Y4e83a1nRa6qrlSf+k+n4EPYQisWAsKUOCyCccCCErr1GqDDIKIaj6eC/6aeEH21xladYy/s=
X-Received: by 2002:a81:5292:0:b0:483:813:c70f with SMTP id
 g140-20020a815292000000b004830813c70fmr272918ywb.266.1673431821306; Wed, 11
 Jan 2023 02:10:21 -0800 (PST)
MIME-Version: 1.0
References: <20230110024445.303-1-liming.wu@jaguarmicro.com>
In-Reply-To: <20230110024445.303-1-liming.wu@jaguarmicro.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Wed, 11 Jan 2023 11:09:45 +0100
Message-ID: <CAJaqyWeuZtx8mUB+jTPVcuiryXpjo09sbvv2QQA2C1-ASMWE1g@mail.gmail.com>
Subject: Re: [PATCH] vhost: remove unused paramete
To:     liming.wu@jaguarmicro.com
Cc:     "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, 398776277@qq.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 10, 2023 at 3:46 AM <liming.wu@jaguarmicro.com> wrote:
>
> From: Liming Wu <liming.wu@jaguarmicro.com>
>
> "enabled" is defined in vhost_init_device_iotlb,
> but it is never used. Let's remove it.
>
> Signed-off-by: Liming Wu <liming.wu@jaguarmicro.com>

Reviewed-by: Eugenio P=C3=A9rez <eperezma@redhat.com>

Thanks!

> ---
>  drivers/vhost/net.c   | 2 +-
>  drivers/vhost/vhost.c | 2 +-
>  drivers/vhost/vhost.h | 2 +-
>  drivers/vhost/vsock.c | 2 +-
>  4 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index 9af19b0cf3b7..135e23254a26 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -1642,7 +1642,7 @@ static int vhost_net_set_features(struct vhost_net =
*n, u64 features)
>                 goto out_unlock;
>
>         if ((features & (1ULL << VIRTIO_F_ACCESS_PLATFORM))) {
> -               if (vhost_init_device_iotlb(&n->dev, true))
> +               if (vhost_init_device_iotlb(&n->dev))
>                         goto out_unlock;
>         }
>
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index cbe72bfd2f1f..34458e203716 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -1729,7 +1729,7 @@ long vhost_vring_ioctl(struct vhost_dev *d, unsigne=
d int ioctl, void __user *arg
>  }
>  EXPORT_SYMBOL_GPL(vhost_vring_ioctl);
>
> -int vhost_init_device_iotlb(struct vhost_dev *d, bool enabled)
> +int vhost_init_device_iotlb(struct vhost_dev *d)
>  {
>         struct vhost_iotlb *niotlb, *oiotlb;
>         int i;
> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> index d9109107af08..4bfa10e52297 100644
> --- a/drivers/vhost/vhost.h
> +++ b/drivers/vhost/vhost.h
> @@ -221,7 +221,7 @@ ssize_t vhost_chr_read_iter(struct vhost_dev *dev, st=
ruct iov_iter *to,
>                             int noblock);
>  ssize_t vhost_chr_write_iter(struct vhost_dev *dev,
>                              struct iov_iter *from);
> -int vhost_init_device_iotlb(struct vhost_dev *d, bool enabled);
> +int vhost_init_device_iotlb(struct vhost_dev *d);
>
>  void vhost_iotlb_map_free(struct vhost_iotlb *iotlb,
>                           struct vhost_iotlb_map *map);
> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> index a2b374372363..1ffa36eb3efb 100644
> --- a/drivers/vhost/vsock.c
> +++ b/drivers/vhost/vsock.c
> @@ -829,7 +829,7 @@ static int vhost_vsock_set_features(struct vhost_vsoc=
k *vsock, u64 features)
>         }
>
>         if ((features & (1ULL << VIRTIO_F_ACCESS_PLATFORM))) {
> -               if (vhost_init_device_iotlb(&vsock->dev, true))
> +               if (vhost_init_device_iotlb(&vsock->dev))
>                         goto err;
>         }
>
> --
> 2.25.1
>

