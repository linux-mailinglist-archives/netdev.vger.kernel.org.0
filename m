Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4F975553C5
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 20:54:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377720AbiFVSx5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 14:53:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359064AbiFVSxq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 14:53:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1D3AF1705E
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 11:53:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655924024;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NUxlW/j88Epc56MqOmmJqiwjv7RfINKqkJmwCtsv0gI=;
        b=QDaZ5P8DshskWRrjqcaX4KGnJwZLhHCMb8cX+ez7ORlSs1EV8n0GyrHOviAqif6wjOvFe7
        Whr69xdEjgnFq45fe/oF0YuEzE0gPIs0crBwR8B0TNOznhPIVXESEwRq+VWIn2NFd2NCsj
        1AvooyAC46vQgUjiP1XDDEVb0fqXJbA=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-648-9V1khCgpPHO7eGUryuev3w-1; Wed, 22 Jun 2022 14:53:43 -0400
X-MC-Unique: 9V1khCgpPHO7eGUryuev3w-1
Received: by mail-qk1-f198.google.com with SMTP id k13-20020a05620a414d00b006a6e4dc1dfcso20871536qko.19
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 11:53:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NUxlW/j88Epc56MqOmmJqiwjv7RfINKqkJmwCtsv0gI=;
        b=CW7JS7KT88/hCsmgWNEujof9KJ7vlcc1NlFuMcqoykxqs1HAk+wa/kVtsCDKfSfdPl
         OhWvmhwwehcnbrOoeY61nxrqirQYuKnHP6X8cVJOi/jxqcGYN1Pjyb+QgyyWQ17bJA7n
         FBvPmH3HbFcySKD42IerpPHkxaQrY9aICNCxF0GdA6xCBVFwKMrMHZ9hASYmRBHixJ/C
         +AUlZa1HSSdkHfFX7q3J8WKo2kOQCeLZyB4QhbGJ1icR0qjd+3ovZS/ui/OZ0iZgTa/K
         mXU9yU4RZX7LZT7eXV8F9DUf4/esXC8KFKT3H37ZNXcGlyC7BsZGyM/sI6fw9EPf/elg
         sPzQ==
X-Gm-Message-State: AJIora87L/1wSmpjDaqNgkW5RPkyVTfqyr7txq1hjw+3GryufIJw7Iai
        DeAsRhTFspj/w3o/7RDO95lTDBUwL3xsiqHu3Hk+DO8q3edABx4XX7SnRWkgYxcxsPicM70CehO
        sguI+6iGIstJ8fIUyfh0y0BfJmRH8OpBX
X-Received: by 2002:ac8:598f:0:b0:305:8f8:2069 with SMTP id e15-20020ac8598f000000b0030508f82069mr4463229qte.370.1655924022280;
        Wed, 22 Jun 2022 11:53:42 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vito0RGMmoO0PY0tCMLhEJ3EtZsz9CJl1GiY/Z98Qu2Yy5UsxoSjB8deyHpN0/O8c0wv8vm/DAfiRMBO7J3Y4=
X-Received: by 2002:ac8:598f:0:b0:305:8f8:2069 with SMTP id
 e15-20020ac8598f000000b0030508f82069mr4463221qte.370.1655924022071; Wed, 22
 Jun 2022 11:53:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220622151407.51232-1-sgarzare@redhat.com>
In-Reply-To: <20220622151407.51232-1-sgarzare@redhat.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Wed, 22 Jun 2022 20:53:06 +0200
Message-ID: <CAJaqyWf6BKK1=KBwHufVY-eLt0JFz9V4-kK-pPLU0tuDc7uGgQ@mail.gmail.com>
Subject: Re: [PATCH] vhost-vdpa: call vhost_vdpa_cleanup during the release
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     virtualization <virtualization@lists.linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        Gautam Dawar <gautam.dawar@xilinx.com>,
        kvm list <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 22, 2022 at 5:14 PM Stefano Garzarella <sgarzare@redhat.com> wr=
ote:
>
> Before commit 3d5698793897 ("vhost-vdpa: introduce asid based IOTLB")
> we call vhost_vdpa_iotlb_free() during the release to clean all regions
> mapped in the iotlb.
>
> That commit removed vhost_vdpa_iotlb_free() and added vhost_vdpa_cleanup(=
)
> to do some cleanup, including deleting all mappings, but we forgot to cal=
l
> it in vhost_vdpa_release().
>
> This causes that if an application does not remove all mappings explicitl=
y
> (or it crashes), the mappings remain in the iotlb and subsequent
> applications may fail if they map the same addresses.
>

I tested this behavior even by sending SIGKILL to qemu. The failed map
is reproducible easily before applying this patch and applying it
fixes the issue properly.

> Calling vhost_vdpa_cleanup() also fixes a memory leak since we are not
> freeing `v->vdev.vqs` during the release from the same commit.
>
> Since vhost_vdpa_cleanup() calls vhost_dev_cleanup() we can remove its
> call from vhost_vdpa_release().
>

Tested-by: Eugenio P=C3=A9rez <eperezma@redhat.com>

> Fixes: 3d5698793897 ("vhost-vdpa: introduce asid based IOTLB")
> Cc: gautam.dawar@xilinx.com
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  drivers/vhost/vdpa.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 5ad2596c6e8a..23dcbfdfa13b 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -1209,7 +1209,7 @@ static int vhost_vdpa_release(struct inode *inode, =
struct file *filep)
>         vhost_dev_stop(&v->vdev);
>         vhost_vdpa_free_domain(v);
>         vhost_vdpa_config_put(v);
> -       vhost_dev_cleanup(&v->vdev);
> +       vhost_vdpa_cleanup(v);
>         mutex_unlock(&d->mutex);
>
>         atomic_dec(&v->opened);
> --
> 2.36.1
>

