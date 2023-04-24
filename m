Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF36A6EC428
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 05:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbjDXDsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 23:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjDXDsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 23:48:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4AC52136
        for <netdev@vger.kernel.org>; Sun, 23 Apr 2023 20:47:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682308048;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I584JltpIOHH0XWX0tvqPjwC5qSAM+LcHjOrkleU1aQ=;
        b=ixoG0WNpffZ3krJoIjSV+q5i+M/FuM/z97Krq9BXK+nQ1rGdvvJWotoB3woHoxRg2GW5Cm
        HnuV3iU54Y+8N2AbaQX1Z+JUhbyEypmUTk0b2JTpzudFJ9K3tU+tIdq3LfX3D91AcTSlqX
        YdNYHyBKu97IN9YTvEQ9ev2UNhu7fE4=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-475-askJX4lTOfamKmw65xrMsg-1; Sun, 23 Apr 2023 23:47:23 -0400
X-MC-Unique: askJX4lTOfamKmw65xrMsg-1
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-5452b6c69e1so2783754eaf.0
        for <netdev@vger.kernel.org>; Sun, 23 Apr 2023 20:47:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682308043; x=1684900043;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I584JltpIOHH0XWX0tvqPjwC5qSAM+LcHjOrkleU1aQ=;
        b=FX/m3Y8325WPv8vDp4H9VFCWQS2Z/gMR2i5ADg3ZCqEDFzX4WLsvzB5w30O/bkBRwH
         zt1At6j2yenz7IoWhfo1kyRaa4RWof86E5jZkh1jNnGw3TjjinNsroosG2iS8d+drB9L
         S8OwGE7zzdGunJ+jdds6++ouHWR0tJzzxqTFJdgsFCZLx+ZagwaubMEQeN81yiok041r
         ofiHhbBP/Bn7Oc43Icqi50MrZeajLTP2riPjUwiej78uDpVGT7gOIfNgfCvQVvr7iNZ0
         cK9Bpw1VlRNY9NXYNBvj6gRuIfljvqfR12C/0ctoQf7RdC6jBqWEp9YRbwORY0BzLmiX
         2FFQ==
X-Gm-Message-State: AAQBX9d+xam5EsuhwI832kComEiJ+tHzPLHlKbDPe7nxQcPGVwRJ9CNu
        VTBwb/V0EdVrUCD2+JaFj41vCeas7Tm0c8zHET7ygePNfGC8GuQyTjSK7opXIRN73sSrTIhguS2
        x3T8ZXpJaBk1e4zvTdM/Xf9yxhKbZ1bSe
X-Received: by 2002:a05:6808:24f:b0:38d:ea2e:15f with SMTP id m15-20020a056808024f00b0038dea2e015fmr6603502oie.55.1682308043145;
        Sun, 23 Apr 2023 20:47:23 -0700 (PDT)
X-Google-Smtp-Source: AKy350ab9SIDhGschCCjuuNyKJylYRhQJOud0D1ec5vKWIcImJUKSc8v87Kjk0mZxymvmmHmwGVwE71m5NCtO8VfDmc=
X-Received: by 2002:a05:6808:24f:b0:38d:ea2e:15f with SMTP id
 m15-20020a056808024f00b0038dea2e015fmr6603496oie.55.1682308042954; Sun, 23
 Apr 2023 20:47:22 -0700 (PDT)
MIME-Version: 1.0
References: <20230420151734.860168-1-lulu@redhat.com>
In-Reply-To: <20230420151734.860168-1-lulu@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 24 Apr 2023 11:47:12 +0800
Message-ID: <CACGkMEuV8a0sAJPM0aVq4o9R2uRku1Wgdy8o=YBhZM2ay7ssEg@mail.gmail.com>
Subject: Re: [PATCH v3] vhost_vdpa: fix unmap process in no-batch mode
To:     Cindy Lu <lulu@redhat.com>
Cc:     mst@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 20, 2023 at 11:17=E2=80=AFPM Cindy Lu <lulu@redhat.com> wrote:
>
> While using the vdpa device with vIOMMU enabled
> in the guest VM, when the vdpa device bind to vfio-pci and run testpmd
> then system will fail to unmap.
> The test process is
> Load guest VM --> attach to virtio driver--> bind to vfio-pci driver
> So the mapping process is
> 1)batched mode map to normal MR
> 2)batched mode unmapped the normal MR
> 3)unmapped all the memory
> 4)mapped to iommu MR
>
> This error happened in step 3). The iotlb was freed in step 2)
> and the function vhost_vdpa_process_iotlb_msg will return fail
> Which causes failure.
>
> To fix this, we will not remove the AS while the iotlb->nmaps is 0.
> This will free in the vhost_vdpa_clean
>
> Cc: stable@vger.kernel.org
> Fixes: aaca8373c4b1 ("vhost-vdpa: support ASID based IOTLB API")
> Signed-off-by: Cindy Lu <lulu@redhat.com>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

> ---
>  drivers/vhost/vdpa.c | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 7be9d9d8f01c..74c7d1f978b7 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -851,11 +851,7 @@ static void vhost_vdpa_unmap(struct vhost_vdpa *v,
>                 if (!v->in_batch)
>                         ops->set_map(vdpa, asid, iotlb);
>         }
> -       /* If we are in the middle of batch processing, delay the free
> -        * of AS until BATCH_END.
> -        */
> -       if (!v->in_batch && !iotlb->nmaps)
> -               vhost_vdpa_remove_as(v, asid);
> +
>  }
>
>  static int vhost_vdpa_va_map(struct vhost_vdpa *v,
> @@ -1112,8 +1108,6 @@ static int vhost_vdpa_process_iotlb_msg(struct vhos=
t_dev *dev, u32 asid,
>                 if (v->in_batch && ops->set_map)
>                         ops->set_map(vdpa, asid, iotlb);
>                 v->in_batch =3D false;
> -               if (!iotlb->nmaps)
> -                       vhost_vdpa_remove_as(v, asid);
>                 break;
>         default:
>                 r =3D -EINVAL;
> --
> 2.34.3
>

