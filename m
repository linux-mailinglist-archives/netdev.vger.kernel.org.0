Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B023F6BCA7F
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 10:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbjCPJNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 05:13:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbjCPJNu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 05:13:50 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C29915C97;
        Thu, 16 Mar 2023 02:13:46 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id ip21-20020a05600ca69500b003ed56690948so594027wmb.1;
        Thu, 16 Mar 2023 02:13:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678958025;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y1wI6KS7nZ+BAxbXQwcHv8OCqNHv/ZA1CoTUOG0kaOw=;
        b=pH4DZPsV8fHwNHtlkoRtDhH+rGhAebSra2S6AS12iNP1CQphcOBdgRjZi5aQVnf2AN
         l9BRE52FccC7urQrvE81fDDpg6RHDnr5eSdedgxc9digmPGOO/m9ZSHTaUMwZ4E9qsZf
         9UJWtypK3/M0Xb/TJTq6JO777BZ0wV+dFMZbWcilV6IjWgqkDtQ5NEbVdCvDU0itsxTB
         l8PO6evxixNThrGVRpAKrZ2FTdH04fUZ2VZoK3m7m+GUDRd11NG4zDeQuhuPdFVY0Up/
         q/t/5Okm7Uj0+Wg2XOawXe3LXY6sdoNSQa632zAKMSqNANd/eW7aDO8P5fZJ8Nh8rph3
         bMlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678958025;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y1wI6KS7nZ+BAxbXQwcHv8OCqNHv/ZA1CoTUOG0kaOw=;
        b=sCayG2c/RFnLcH3+JqHcAUuguzGliCnLOpjcgj0tcEGZL5Uloniwr+d+67gAh/HYke
         JS1X6Pg8rLa4edpkjDvq2jDwBtdbln3HDIA0pwiQmhBdjHpulb6UbJPtXOxAoyxr0C10
         xLJIIvMyHdSI+Qm2PjS6z/Inf5hHw/sjjcmoWOyJ7vypMwal/06vejKq/2oKOwMPcJH1
         M4faZX/5DId7/MmLOFYSIHp8OEpjKvkE0WcZxsGkWcGvGeuLbaFOi3xuuGXxFcGfyOEI
         XP799cDQ5uFWSLttXJMa1m/Xl7C+AlKWH2OngPD1ikm11OpcZjcvlBItPivTwkiJVJ+N
         bmVg==
X-Gm-Message-State: AO0yUKVLtlVUt4a6cZqxjhNfhyt+XUxwRaOK1m6cATAFoa5RwAx+ND+7
        mWuLoTa/j21Wda5BIlJtA4SP2hn+LJ2ntA==
X-Google-Smtp-Source: AK7set/omKQgo/seetBthv72Tur5fOCcDJfwpwJcU+3LcqDf1smJKiGVEp1Nh48clT48qmi0/MIViQ==
X-Received: by 2002:a05:600c:19cf:b0:3eb:2da4:f304 with SMTP id u15-20020a05600c19cf00b003eb2da4f304mr19305219wmq.17.1678958024569;
        Thu, 16 Mar 2023 02:13:44 -0700 (PDT)
Received: from suse.localnet (host-79-35-102-94.retail.telecomitalia.it. [79.35.102.94])
        by smtp.gmail.com with ESMTPSA id i26-20020a1c541a000000b003ed246f76a2sm4609903wmb.1.2023.03.16.02.13.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 02:13:44 -0700 (PDT)
From:   "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        eperezma@redhat.com, netdev@vger.kernel.org, stefanha@redhat.com,
        linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: Re: [PATCH v2 3/8] vringh: replace kmap_atomic() with kmap_local_page()
Date:   Thu, 16 Mar 2023 10:13:39 +0100
Message-ID: <5675662.DvuYhMxLoT@suse>
In-Reply-To: <20230302113421.174582-4-sgarzare@redhat.com>
References: <20230302113421.174582-1-sgarzare@redhat.com>
 <20230302113421.174582-4-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On gioved=EC 2 marzo 2023 12:34:16 CET Stefano Garzarella wrote:
> kmap_atomic() is deprecated in favor of kmap_local_page().
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

It seems that my commit message is quite clear and complete and therefore h=
as=20
already been reused by others who have somehow given me credit.=20

I would really appreciate it being mentioned here that you are reusing a=20
"boiler plate" commit message of my own making and Cc me :-)

Thanks,

=46abio

> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>=20
> Notes:
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




