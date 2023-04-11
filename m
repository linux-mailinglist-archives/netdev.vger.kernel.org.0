Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9F546DD1EA
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 07:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbjDKFl4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 01:41:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230053AbjDKFlu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 01:41:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B55622D63
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 22:40:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681191656;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5Lc8+CXiaC7kZLTFmLHcV9MWZzh4/VM+o+UitxvfuTg=;
        b=Ho9cTTiJB9dVX4TE6Oh+A6ZmlxiitUFsjwBeqI6F61VMP6I0IuHNATZMjyajiqvBj5nYnm
        sO4V0T18LOj3XNVUKh8iDHEOMoT0rpTNy73SiwnQPSUcq3slZnZlD3yHjCLALwKnmvmVQ1
        GzyoUbSwJzV2K4TWMsQReT4MkdsHM70=
Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com
 [209.85.160.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-630-7A7YfSujN0edEKQ3OJ-xLg-1; Tue, 11 Apr 2023 01:40:54 -0400
X-MC-Unique: 7A7YfSujN0edEKQ3OJ-xLg-1
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-18430ae1d46so3982503fac.18
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 22:40:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681191652; x=1683783652;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5Lc8+CXiaC7kZLTFmLHcV9MWZzh4/VM+o+UitxvfuTg=;
        b=pDyTrqWBdlc41cwl/0MAyXbzrA5E6RTzamSQkD/QK+GvnrUsQOGPYvML3Pz2FmHgN1
         VlLrCLa0ki6DbUddcWb7Rytz4V30bgAwFB0KEOchqDRFoOA05kLHI6hwWo3rGZoowvlu
         9v0aLHW0vHp1J9t7uYDCsjYqToyXLOKEVww2BzmWGi6ojo6R4Mhn+hGHwVSElzrxhW/l
         7usNdocxXqA9ZIDcIw/L7DG+Cst9zxfVKWP28MAXrjnU4+IEUj97nhY73uy9kZky91op
         W0F6aAr0lgKJ2LMZaEwX3755jrE0nBpEaa5Ww35TsYdAYYpyUxKyW+/TK1JSuY0SYYtS
         QlWQ==
X-Gm-Message-State: AAQBX9fLuvO8w/aCBAU0plCB/psY6tdvpmjQ7gNyOLOviP4v458bBeqI
        AYdyp81ExrsTvzK7/FmkRk390qJ4iZjZEc3lyNd8qJYr2NGMt+1oHQM9JECYu7AONvkqyvgEAPY
        DOrB4glA8EyF+mNgA8J+vSG15+6Dp4cH5
X-Received: by 2002:aca:2105:0:b0:37f:ab56:ff42 with SMTP id 5-20020aca2105000000b0037fab56ff42mr382973oiz.9.1681191652468;
        Mon, 10 Apr 2023 22:40:52 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZDv1ledLRdmNQyCWbksADq4zEavS68uqQs0Gsi3+bqVtEYCjFkNdzhA2mCtntAdKw7yIEaHAyObDume0j4N5E=
X-Received: by 2002:aca:2105:0:b0:37f:ab56:ff42 with SMTP id
 5-20020aca2105000000b0037fab56ff42mr382966oiz.9.1681191652266; Mon, 10 Apr
 2023 22:40:52 -0700 (PDT)
MIME-Version: 1.0
References: <20230404131326.44403-1-sgarzare@redhat.com> <20230404131326.44403-5-sgarzare@redhat.com>
In-Reply-To: <20230404131326.44403-5-sgarzare@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 11 Apr 2023 13:40:41 +0800
Message-ID: <CACGkMEvv0L7cFTHgi=4xwJ73ydhkp+Qd+tgPVcwC+b0V_U1ujQ@mail.gmail.com>
Subject: Re: [PATCH v5 4/9] vringh: define the stride used for translation
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     virtualization@lists.linux-foundation.org, eperezma@redhat.com,
        stefanha@redhat.com,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 4, 2023 at 9:14=E2=80=AFPM Stefano Garzarella <sgarzare@redhat.=
com> wrote:
>
> Define a macro to be reused in the different parts of the code.
>
> Useful for the next patches where we add more arrays to manage also
> translations with user VA.
>
> Suggested-by: Eugenio Perez Martin <eperezma@redhat.com>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

> ---
>
> Notes:
>     v4:
>     - added this patch with the changes extracted from the next patch [Eu=
genio]
>     - used _STRIDE instead of _SIZE [Eugenio]
>
>  drivers/vhost/vringh.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
> index 0ba3ef809e48..4aee230f7622 100644
> --- a/drivers/vhost/vringh.c
> +++ b/drivers/vhost/vringh.c
> @@ -1141,13 +1141,15 @@ static int iotlb_translate(const struct vringh *v=
rh,
>         return ret;
>  }
>
> +#define IOTLB_IOV_STRIDE 16
> +
>  static inline int copy_from_iotlb(const struct vringh *vrh, void *dst,
>                                   void *src, size_t len)
>  {
>         u64 total_translated =3D 0;
>
>         while (total_translated < len) {
> -               struct bio_vec iov[16];
> +               struct bio_vec iov[IOTLB_IOV_STRIDE];
>                 struct iov_iter iter;
>                 u64 translated;
>                 int ret;
> @@ -1180,7 +1182,7 @@ static inline int copy_to_iotlb(const struct vringh=
 *vrh, void *dst,
>         u64 total_translated =3D 0;
>
>         while (total_translated < len) {
> -               struct bio_vec iov[16];
> +               struct bio_vec iov[IOTLB_IOV_STRIDE];
>                 struct iov_iter iter;
>                 u64 translated;
>                 int ret;
> --
> 2.39.2
>

