Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C91706DCFFC
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 05:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbjDKDKq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 23:10:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbjDKDKm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 23:10:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED64C19A2
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 20:10:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681182600;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PIRYPPRzMr0WDaISNXv8JTRc994C6mm8nrgRnA2e2II=;
        b=dhCqtFIZafLnxOxO+mpkKBf+IjKZjEy5+rMcwHo0QYQthPrFULlj8cXnAyoL4T9vgiPZ+9
        OOQtZqDa1DySDSRrKskIE1ZWthRTxDVInCoqzp9CxMUvmWhBQA5SL1b++NpMfSlx5lU1c1
        8PF+cdlqLIunmekcCG8coQ6RZuxOsn8=
Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com
 [209.85.160.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-216-iM0jTS-kMyqIJMR51KNJKg-1; Mon, 10 Apr 2023 23:09:58 -0400
X-MC-Unique: iM0jTS-kMyqIJMR51KNJKg-1
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-1840d4e9758so5485411fac.11
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 20:09:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681182597; x=1683774597;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PIRYPPRzMr0WDaISNXv8JTRc994C6mm8nrgRnA2e2II=;
        b=JxbZ2ANMdSbfONG6XnMlEpdBHgu2HnDttXDk924HTEH/fkzF86v3HTvd9lRyzXN+o0
         qnLYWLuconP1FmD10cV3mAb5VhaS/+763VB/MGSLcRuyuUuKZRSwXUgdaT17j7205gdG
         JTp2Magosg4JF4mP7JbeOD6/OOgk88iu/iA2RyAhNmQ6GHZJ+UL0BYRttUg0fvlQUtuK
         fiCTc1PFotKjUE7eWRoiWRS2rygjiVs0J27XrWIqMpS02l/ms4+NtT+BvV0aipcLBCDp
         Wc+3eY7dqKzAS/ku0LEEtVii7r8q2QzqHbnFrgZPEJN2chjG2+w++dpxW5nYYi5QdmlK
         sqmg==
X-Gm-Message-State: AAQBX9fD4z6EIsDcIjKGJNxwkLZF6QqFIAvNjnAO/ymtPh3bfC+P/rdf
        No+4Vlp4SZJwNm8HlqJ48OSUsaMHNPv1eprOU1av7PMxTwXg0l3Gns2ltnHpQuQpV9bYMFXUIU/
        KQuFeitXtoLqixpxvAgvv7SDajW4zTz1x
X-Received: by 2002:a54:4108:0:b0:389:86c3:b1fb with SMTP id l8-20020a544108000000b0038986c3b1fbmr1767287oic.9.1681182597578;
        Mon, 10 Apr 2023 20:09:57 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZeucJf+EbWtNuhPzUoVMqvWrsCF6D+3DIu6eOe4RcryYcADiNhudEFaSmmkr0WQmH0aZjfEc0FYx82LleldDo=
X-Received: by 2002:a54:4108:0:b0:389:86c3:b1fb with SMTP id
 l8-20020a544108000000b0038986c3b1fbmr1767284oic.9.1681182597366; Mon, 10 Apr
 2023 20:09:57 -0700 (PDT)
MIME-Version: 1.0
References: <20230410150130.837691-1-lulu@redhat.com>
In-Reply-To: <20230410150130.837691-1-lulu@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 11 Apr 2023 11:09:46 +0800
Message-ID: <CACGkMEvTdgvqacFmMJZD4u++YJwESgSmLF6CMdAJBBqkxpZKgg@mail.gmail.com>
Subject: Re: [PATCH] vhost_vdpa: fix unmap process in no-batch mode
To:     Cindy Lu <lulu@redhat.com>
Cc:     mst@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
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

On Mon, Apr 10, 2023 at 11:01=E2=80=AFPM Cindy Lu <lulu@redhat.com> wrote:
>
> While using the no-batch mode, the process will not begin with
> VHOST_IOTLB_BATCH_BEGIN, so we need to add the
> VHOST_IOTLB_INVALIDATE to get vhost_vdpa_as, the process is the
> same as VHOST_IOTLB_UPDATE
>
> Signed-off-by: Cindy Lu <lulu@redhat.com>
> ---
>  drivers/vhost/vdpa.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 7be9d9d8f01c..32636a02a0ab 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -1074,6 +1074,7 @@ static int vhost_vdpa_process_iotlb_msg(struct vhos=
t_dev *dev, u32 asid,
>                 goto unlock;
>
>         if (msg->type =3D=3D VHOST_IOTLB_UPDATE ||
> +           msg->type =3D=3D VHOST_IOTLB_INVALIDATE ||

I'm not sure I get here, invalidation doesn't need to create a new AS.

Or maybe you can post the userspace code that can trigger this issue?

Thanks

>             msg->type =3D=3D VHOST_IOTLB_BATCH_BEGIN) {
>                 as =3D vhost_vdpa_find_alloc_as(v, asid);
>                 if (!as) {
> --
> 2.34.3
>

