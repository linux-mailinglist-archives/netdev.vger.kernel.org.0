Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 173876A7B95
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 08:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbjCBHFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 02:05:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbjCBHFS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 02:05:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E53CD2054C
        for <netdev@vger.kernel.org>; Wed,  1 Mar 2023 23:04:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677740669;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3I7fEWBSkBRmUqs/CW5rH4YweDzHXspjsekRmlHIHT0=;
        b=CH1SHKrBw1UrwnH+XcZQqx4H2MjYKE/d0v5s4EisOt4Ocit8u6NzXcTdCQyoUsn8uRXcS0
        9xtUELqsokbK7B7Ee5/traYGx0tnkmYjQYg4NzxsqXTmKgbP8GlVmqTEzvly2mwaY7zrz/
        DK3AZfDF2YHxRASIBtEB3/6P7oZlISE=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-294-hqsmC0p4NH2pb8GZ0e737Q-1; Thu, 02 Mar 2023 02:04:27 -0500
X-MC-Unique: hqsmC0p4NH2pb8GZ0e737Q-1
Received: by mail-oo1-f72.google.com with SMTP id i2-20020a4abc02000000b0052529fc100aso3326439oop.7
        for <netdev@vger.kernel.org>; Wed, 01 Mar 2023 23:04:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3I7fEWBSkBRmUqs/CW5rH4YweDzHXspjsekRmlHIHT0=;
        b=cQXoEeHEyqL9Hpf+AKBioYLpg5K4PkKiDzgxxBZpCzgnQgvB6FWqtdOHltlyq4BW6l
         cT937IUENZ16mbQ+qYOHwIgc2gKG2GaPaOLEdbY018kYsT9ID2aPNYjMJ/eo1VEL1LNh
         23PP8qSJNgsmrnFZEuthl1eAiOsC+4UgfXj4K+x7WhBJekygLIZwVGC0h/k4hvATuhUK
         2iZbUn+0Y4N4S9xKW9UnKbgVYS6Ze3BG/wnELL6Ah1zf9YLI72J4kXtRBr8yJHEV2UG7
         HVXfkxiMova/K29aKysFN+oKI5r6h62nuv3H4CCSvuqN5KTH+BLSzVijHKrap60lhptz
         602w==
X-Gm-Message-State: AO0yUKWDOfTXOqgAAJmLeYReBueBwbegbbN6ziRFietXQt96Cu0iQEJ2
        85znUeylSko9aNoLxobriAcHXyf7NmLEano3hVjKWdpzmFBlnX9Y96AdavIbRfSm9SeXIxLWCfM
        fa3y6c1qtO+gW20KPeekZ8CUFg0ia9Qx2
X-Received: by 2002:aca:f14:0:b0:384:63a:305c with SMTP id 20-20020aca0f14000000b00384063a305cmr406850oip.2.1677740666950;
        Wed, 01 Mar 2023 23:04:26 -0800 (PST)
X-Google-Smtp-Source: AK7set/GVk7xB4Dn9iyfjHunjJpsSyZ3FpxKMSMLNZPMiyP0X8CCm77l0gsVjvHVGOmNLjOn/IuoalCbJZmuM7ep4GQ=
X-Received: by 2002:aca:f14:0:b0:384:63a:305c with SMTP id 20-20020aca0f14000000b00384063a305cmr406838oip.2.1677740666774;
 Wed, 01 Mar 2023 23:04:26 -0800 (PST)
MIME-Version: 1.0
References: <20230301163203.29883-1-gautam.dawar@amd.com>
In-Reply-To: <20230301163203.29883-1-gautam.dawar@amd.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 2 Mar 2023 15:04:15 +0800
Message-ID: <CACGkMEtSe3ho5D3Lsx2gf2xUSJq+fgWcb-zsE6Lw4jJgSuLVjA@mail.gmail.com>
Subject: Re: [PATCH] vhost-vdpa: free iommu domain after last use during cleanup
To:     Gautam Dawar <gautam.dawar@amd.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-net-drivers@amd.com,
        harpreet.anand@amd.com, tanuj.kamde@amd.com,
        "Longpeng (Mike, Cloud Infrastructure Service Product Dept.)" 
        <longpeng2@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 2, 2023 at 12:32=E2=80=AFAM Gautam Dawar <gautam.dawar@amd.com>=
 wrote:
>
> Currently vhost_vdpa_cleanup() unmaps the DMA mappings by calling
> `iommu_unmap(v->domain, map->start, map->size);`
> from vhost_vdpa_general_unmap() when the parent vDPA driver doesn't
> provide DMA config operations.
>
> However, the IOMMU domain referred to by `v->domain` is freed in
> vhost_vdpa_free_domain() before vhost_vdpa_cleanup() in
> vhost_vdpa_release() which results in NULL pointer de-reference.
> Accordingly, moving the call to vhost_vdpa_free_domain() in
> vhost_vdpa_cleanup() would makes sense. This will also help
> detaching the dma device in error handling of vhost_vdpa_alloc_domain().
>
> This issue was observed on terminating QEMU with SIGQUIT.
>
> Fixes: 037d4305569a ("vhost-vdpa: call vhost_vdpa_cleanup during the rele=
ase")
> Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

> ---
>  drivers/vhost/vdpa.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index ec32f785dfde..b7657984dd8d 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -1134,6 +1134,7 @@ static int vhost_vdpa_alloc_domain(struct vhost_vdp=
a *v)
>
>  err_attach:
>         iommu_domain_free(v->domain);
> +       v->domain =3D NULL;
>         return ret;
>  }
>
> @@ -1178,6 +1179,7 @@ static void vhost_vdpa_cleanup(struct vhost_vdpa *v=
)
>                         vhost_vdpa_remove_as(v, asid);
>         }
>
> +       vhost_vdpa_free_domain(v);
>         vhost_dev_cleanup(&v->vdev);
>         kfree(v->vdev.vqs);
>  }
> @@ -1250,7 +1252,6 @@ static int vhost_vdpa_release(struct inode *inode, =
struct file *filep)
>         vhost_vdpa_clean_irq(v);
>         vhost_vdpa_reset(v);
>         vhost_dev_stop(&v->vdev);
> -       vhost_vdpa_free_domain(v);
>         vhost_vdpa_config_put(v);
>         vhost_vdpa_cleanup(v);
>         mutex_unlock(&d->mutex);
> --
> 2.30.1
>

