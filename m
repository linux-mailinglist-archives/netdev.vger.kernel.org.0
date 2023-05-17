Return-Path: <netdev+bounces-3206-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 28760705F60
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 07:29:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D85592815A7
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 05:29:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65F6C5255;
	Wed, 17 May 2023 05:24:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58DAD211C
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 05:24:09 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A6403C0C
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 22:24:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684301047;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t2TQmhlyr4qpfepuY+DlN4KamSzGRCNW1CGNN09KiW0=;
	b=fDLjPl7MsCd+wxd4DJS8H+ZH1mD9X/uSzBT2abX5xDFjv7P6DkoR784ITrUWeG8V1USnjH
	uYVWiRZmq3Nt6CO+cVj4exQQuoCt/lq5Pe/FMb0u1z26EJOLantdJSIjRH0Z39MAQU69bE
	+KtWQk6tYX8o4Tq/JjLJRkqVlXynmxg=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-602-lep9PprwPzim8UWAnATRUg-1; Wed, 17 May 2023 01:24:03 -0400
X-MC-Unique: lep9PprwPzim8UWAnATRUg-1
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-4f1385c2c35so257212e87.1
        for <netdev@vger.kernel.org>; Tue, 16 May 2023 22:24:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684301042; x=1686893042;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t2TQmhlyr4qpfepuY+DlN4KamSzGRCNW1CGNN09KiW0=;
        b=MzSnxYVm27WFAdZwq6K7QPYnl8Dpg+iFj704aUyLBrq+R53LQ6G7i5acLgNvjOuifu
         9PouOH4VEJMvz552CFQvVwH53MrljPQy80hJzIdWRFM0Xa4v+kCvT5wo6nVC1ScH2sou
         XwiaGb6jS7OjNxwE0zbgoIX7Nt92X2nmEhQ6SSSAzvTe2lXTGpFPrSANbW2gnzBjpOUh
         /XgTbyVRlDMPiILoM2vDImxxGins+xvnQ4vm2xNTjYrvbJb6BTYhUj2wgbpTzipexK07
         nPQu6ypR89rAQS8ijV5i4wGl35+pN/Fy7aN6Hzj4CR/EEJ5oqCMIgpSoGYHKpF5ey4Ay
         tCkQ==
X-Gm-Message-State: AC+VfDwCMv40dPgXEbyI2MwXbIyvioBSX1lz62i0iMni13PhjCJHMula
	824w/FTw1NGhhMmp29/tbMfblvTZV67Ac20HQxmcHPfe65sYPzI/ssSDV2/mYora7E45ZEqWctM
	S4SQotXZQ/e8NA6mqo+55IKZQl/CCGRlCUU4vikf6CP4=
X-Received: by 2002:ac2:598c:0:b0:4f3:83d6:f22c with SMTP id w12-20020ac2598c000000b004f383d6f22cmr2314495lfn.66.1684301042051;
        Tue, 16 May 2023 22:24:02 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4cbD5EclJjMC9h5Bmo7GCWi9NvKPqma8Oxjx6jDgJ08ur23xMjHhPMa62dMTnl0xvbjx0fqKiMEfZSJJ6fsHM=
X-Received: by 2002:ac2:598c:0:b0:4f3:83d6:f22c with SMTP id
 w12-20020ac2598c000000b004f383d6f22cmr2314490lfn.66.1684301041754; Tue, 16
 May 2023 22:24:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230516135446.16266-1-feliu@nvidia.com>
In-Reply-To: <20230516135446.16266-1-feliu@nvidia.com>
From: Jason Wang <jasowang@redhat.com>
Date: Wed, 17 May 2023 13:23:50 +0800
Message-ID: <CACGkMEtitFX1v=fFYohLNz=xo3S7CM3Cdt09=C6xXz8kb1a4Cg@mail.gmail.com>
Subject: Re: [PATCH v1] virtio_pci: Optimize virtio_pci_device structure size
To: Feng Liu <feliu@nvidia.com>
Cc: virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, "Michael S . Tsirkin" <mst@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Bodong Wang <bodong@nvidia.com>, 
	Jiri Pirko <jiri@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 16, 2023 at 9:55=E2=80=AFPM Feng Liu <feliu@nvidia.com> wrote:
>
> Improve the size of the virtio_pci_device structure, which is commonly
> used to represent a virtio PCI device. A given virtio PCI device can
> either of legacy type or modern type, with the
> struct virtio_pci_legacy_device occupying 32 bytes and the
> struct virtio_pci_modern_device occupying 88 bytes. Make them a union,
> thereby save 32 bytes of memory as shown by the pahole tool. This
> improvement is particularly beneficial when dealing with numerous
> devices, as it helps conserve memory resources.
>
> Before the modification, pahole tool reported the following:
> struct virtio_pci_device {
> [...]
>         struct virtio_pci_legacy_device ldev;            /*   824    32 *=
/
>         /* --- cacheline 13 boundary (832 bytes) was 24 bytes ago --- */
>         struct virtio_pci_modern_device mdev;            /*   856    88 *=
/
>
>         /* XXX last struct has 4 bytes of padding */
> [...]
>         /* size: 1056, cachelines: 17, members: 19 */
> [...]
> };
>
> After the modification, pahole tool reported the following:
> struct virtio_pci_device {
> [...]
>         union {
>                 struct virtio_pci_legacy_device ldev;    /*   824    32 *=
/
>                 struct virtio_pci_modern_device mdev;    /*   824    88 *=
/
>         };                                               /*   824    88 *=
/
> [...]
>         /* size: 1024, cachelines: 16, members: 18 */
> [...]
> };
>
> Signed-off-by: Feng Liu <feliu@nvidia.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

> ---
>  drivers/virtio/virtio_pci_common.h | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/virtio/virtio_pci_common.h b/drivers/virtio/virtio_p=
ci_common.h
> index 23112d84218f..4b773bd7c58c 100644
> --- a/drivers/virtio/virtio_pci_common.h
> +++ b/drivers/virtio/virtio_pci_common.h
> @@ -45,9 +45,10 @@ struct virtio_pci_vq_info {
>  struct virtio_pci_device {
>         struct virtio_device vdev;
>         struct pci_dev *pci_dev;
> -       struct virtio_pci_legacy_device ldev;
> -       struct virtio_pci_modern_device mdev;
> -
> +       union {
> +               struct virtio_pci_legacy_device ldev;
> +               struct virtio_pci_modern_device mdev;
> +       };
>         bool is_legacy;
>
>         /* Where to read and clear interrupt */
> --
> 2.37.1 (Apple Git-137.1)
>


