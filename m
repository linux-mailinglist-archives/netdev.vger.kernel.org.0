Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53E5C6C47C6
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 11:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbjCVKhe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 06:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230310AbjCVKhc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 06:37:32 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EADF452F57;
        Wed, 22 Mar 2023 03:37:31 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id p16so11178676wmq.5;
        Wed, 22 Mar 2023 03:37:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679481450;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cXY3dtEy0DFSpO9vMF3eqheQ80y59mk1IPKmUUcnHw4=;
        b=ZvEImXvWLlZnHzB/uPkccpIeQrcbBMzUte9gqqBUQ9+aYAhQ2qUE2ce9TsDqpMKLd5
         +mQ5+bFPecNmFOmpbQdlSxktsVH6WmLN6ZDqW4PSMSLfFpKFFucTyWauuNf59gY+YFMf
         uk38VBQ9Q9jYVhPrK+iDkefM7U4YSr7woFga1RQnY/btMY8wHwaMWWzNydqI/+0Gwysh
         HiYcyUQBDx49My68w4qmEQp4kAh7wUnas5DROGDlXRs0dHgz9OQsonY8EgvlplTTCUbD
         Xv/8uCDwYciRSmjn/7OaagPTtoQN55L/NYKyLVsDYbaHp/hMn9iGmROCqGFAZM2a8EkK
         7rnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679481450;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cXY3dtEy0DFSpO9vMF3eqheQ80y59mk1IPKmUUcnHw4=;
        b=K9PFkPz16yTnCgbns/bVe1aQIdQsTiDDPE4Qhcj1ZoxihcxA4+YiVwpX3taH2YK7uS
         W0daA3gXuFnmlGpvvgsMhtbH3EElK7drCyrtDntvnmxE2UKO7rVZxmy/iQALiihnhLsn
         WFX4KeYzBHaKnjwYJ0Lg95YD9uMJPqyglE/mQl2DvSQOmp0P+J0NyzJFBJHC+Xt4kfr/
         3wTNdhys5QszkkLrS07uDPW8srHmeyFED36DvD9cuYBrrJAfYmudU7JJS56nwrxIMBhR
         tnqok1XXogxEjJM1bcQ1Q7bnYqnEQ0yCi2rwrhYZ2vuG5jEEGyeefJgty7SfJZDeqckL
         m2yA==
X-Gm-Message-State: AO0yUKUc3iAyTws0tFM1NvXNZE8fFEv1E/UVMwMAWK0j1f/xrnNg3ZG8
        Gu99h2PScTQzcthM0oU6epcTY0aDttE=
X-Google-Smtp-Source: AK7set8wjyAhRAJKpG1wItEV/9Sq5pZ1JXf92nIEtT1nfDZDVi0BjLq3WaWUnFeNRo2qaU1X0sfJgA==
X-Received: by 2002:a7b:cc95:0:b0:3ed:346d:4534 with SMTP id p21-20020a7bcc95000000b003ed346d4534mr1361845wma.0.1679481450218;
        Wed, 22 Mar 2023 03:37:30 -0700 (PDT)
Received: from suse.localnet (host-79-35-102-94.retail.telecomitalia.it. [79.35.102.94])
        by smtp.gmail.com with ESMTPSA id f9-20020a05600c154900b003ede03e4369sm10839725wmg.33.2023.03.22.03.37.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 03:37:29 -0700 (PDT)
From:   "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
To:     virtualization@lists.linux-foundation.org,
        Stefano Garzarella <sgarzare@redhat.com>
Cc:     stefanha@redhat.com, "Michael S. Tsirkin" <mst@redhat.com>,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        eperezma@redhat.com, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Stefano Garzarella <sgarzare@redhat.com>, ira.weiny@intel.com
Subject: Re: [PATCH v3 3/8] vringh: replace kmap_atomic() with kmap_local_page()
Date:   Wed, 22 Mar 2023 11:37:27 +0100
Message-ID: <4499457.LvFx2qVVIh@suse>
In-Reply-To: <20230321154228.182769-4-sgarzare@redhat.com>
References: <20230321154228.182769-1-sgarzare@redhat.com>
 <20230321154228.182769-4-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On marted=EC 21 marzo 2023 16:42:23 CET Stefano Garzarella wrote:
> kmap_atomic() is deprecated in favor of kmap_local_page() since commit
> f3ba3c710ac5 ("mm/highmem: Provide kmap_local*").
>=20
> With kmap_local_page() the mappings are per thread, CPU local, can take
> page-faults, and can be called from any context (including interrupts).
> Furthermore, the tasks can be preempted and, when they are scheduled to
> run again, the kernel virtual addresses are restored and still valid.
>=20
> kmap_atomic() is implemented like a kmap_local_page() which also disables
> page-faults and preemption (the latter only for !PREEMPT_RT kernels,
> otherwise it only disables migration).
>=20
> The code within the mappings/un-mappings in getu16_iotlb() and
> putu16_iotlb() don't depend on the above-mentioned side effects of
> kmap_atomic(), so that mere replacements of the old API with the new one
> is all that is required (i.e., there is no need to explicitly add calls
> to pagefault_disable() and/or preempt_disable()).
>=20
> This commit reuses a "boiler plate" commit message from Fabio, who has
> already did this change in several places.
>=20

=46WIW, I can confirm that the conversions here are safe...

Reviewed-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>

Thanks,

=46abio

P.S.: I had to send this message again because my former contained HTML par=
ts=20
and so it was rejected by the mailing lists. I don't yet know how HTML crep=
t=20
into my text.

> Cc: "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>=20
> Notes:
>     v3:
>     - credited Fabio for the commit message
>     - added reference to the commit that deprecated kmap_atomic() [Jason]
>     v2:
>     - added this patch since checkpatch.pl complained about deprecation
>       of kmap_atomic() touched by next patch
>=20
>  drivers/vhost/vringh.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
> index a1e27da54481..0ba3ef809e48 100644
> --- a/drivers/vhost/vringh.c
> +++ b/drivers/vhost/vringh.c
> @@ -1220,10 +1220,10 @@ static inline int getu16_iotlb(const struct vringh
> *vrh, if (ret < 0)
>  		return ret;
>=20
> -	kaddr =3D kmap_atomic(iov.bv_page);
> +	kaddr =3D kmap_local_page(iov.bv_page);
>  	from =3D kaddr + iov.bv_offset;
>  	*val =3D vringh16_to_cpu(vrh, READ_ONCE(*(__virtio16 *)from));
> -	kunmap_atomic(kaddr);
> +	kunmap_local(kaddr);
>=20
>  	return 0;
>  }
> @@ -1241,10 +1241,10 @@ static inline int putu16_iotlb(const struct vringh
> *vrh, if (ret < 0)
>  		return ret;
>=20
> -	kaddr =3D kmap_atomic(iov.bv_page);
> +	kaddr =3D kmap_local_page(iov.bv_page);
>  	to =3D kaddr + iov.bv_offset;
>  	WRITE_ONCE(*(__virtio16 *)to, cpu_to_vringh16(vrh, val));
> -	kunmap_atomic(kaddr);
> +	kunmap_local(kaddr);
>=20
>  	return 0;
>  }
> --
> 2.39.2




