Return-Path: <netdev+bounces-5532-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AEB8712045
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 08:39:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 084261C20FB4
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 06:39:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7F9B5257;
	Fri, 26 May 2023 06:39:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D7EA2100
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 06:39:17 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB7E619C
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 23:39:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685083149;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x+bs/EeksfHI43M3AGFfTiuW/uRtRdXfogNY4shc8y0=;
	b=WLMbS94xPsz+u7Wie7Ayi82I70i2vj2Rr7bz452sX4SdjFMpS9nufnsXPcxZhrLqRlZLEJ
	ZFThEwWBZXOJS7Rmki9rZ/YeBxDsUXoGLzbLeA23YBK00NcXIaFJX0/bVTHAz1Doj5w4UZ
	cZjUta8gbKrja2bJj8tnJrOL5kcTkXY=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-484-6JSTmqiJOZWn0PVWwhVr4g-1; Fri, 26 May 2023 02:39:07 -0400
X-MC-Unique: 6JSTmqiJOZWn0PVWwhVr4g-1
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-4f4e15ce850so179285e87.2
        for <netdev@vger.kernel.org>; Thu, 25 May 2023 23:39:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685083146; x=1687675146;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x+bs/EeksfHI43M3AGFfTiuW/uRtRdXfogNY4shc8y0=;
        b=DPaxQ33DUxQ76BXNo02rWwhUmVOyqPh239SODiFhDVmunsZsKvSiKKvEJMxR3zrjt7
         Djw34MjYuvOnHokF0Yj7Efog6aN2NzH+8VPem7vAd9FErc7ItJUyp87bZhm/uvizS6s/
         bq/k0bfJmzT+ZsC8QvWwbP2D5OJwmT4pHlVrcmFmTrOqncUxuhJuLogx6T6L2TGxPqOm
         AvA/bVztddmBGjD41dUPt5oZ8C63jybnuCPm99hHwePOFXvGZvnGZGqNG6OjnGnFT6W1
         qqKsfaxqAF0FYQumsUWi/qUZHj1S3L51khvvWKwmAk+jkVMVKadztZQpPVCBrAhwStPh
         ElUQ==
X-Gm-Message-State: AC+VfDzLmC7PcyVYKyKCgQnd8vpAJQqTda16bcj/96cHYZ+QLSxxmRWa
	OVEQlSr18+ZVwBbs5ZZHS+QAZlwcYGg/DucOHXcobO1cCcFiTX0AnsGbizMAqaWf9zfNN1yg4mm
	lZtli4QhgTi6F/uygyJdR+8sQrmguEa0q
X-Received: by 2002:ac2:5584:0:b0:4f3:ba53:35f2 with SMTP id v4-20020ac25584000000b004f3ba5335f2mr348200lfg.49.1685083145940;
        Thu, 25 May 2023 23:39:05 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7ZGMBvmDOnk6A1M9x8uXTgZpQopDuFIrCe6DF0zYSEQVhyP15JnRWL7SWoXzSYalkqHdBnvbODVvBx4F4Izbo=
X-Received: by 2002:ac2:5584:0:b0:4f3:ba53:35f2 with SMTP id
 v4-20020ac25584000000b004f3ba5335f2mr348187lfg.49.1685083145623; Thu, 25 May
 2023 23:39:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230526054621.18371-1-liangchen.linux@gmail.com>
In-Reply-To: <20230526054621.18371-1-liangchen.linux@gmail.com>
From: Jason Wang <jasowang@redhat.com>
Date: Fri, 26 May 2023 14:38:54 +0800
Message-ID: <CACGkMEuUTNfHXQPg29eUZFnVBRJEmjjKN4Jmr3=Qnkgjj0B9PQ@mail.gmail.com>
Subject: Re: [PATCH net-next 1/5] virtio_net: Fix an unsafe reference to the
 page chain
To: Liang Chen <liangchen.linux@gmail.com>
Cc: mst@redhat.com, virtualization@lists.linux-foundation.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	xuanzhuo@linux.alibaba.com, kuba@kernel.org, edumazet@google.com, 
	davem@davemloft.net, pabeni@redhat.com, alexander.duyck@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 26, 2023 at 1:46=E2=80=AFPM Liang Chen <liangchen.linux@gmail.c=
om> wrote:
>
> "private" of buffer page is currently used for big mode to chain pages.
> But in mergeable mode, that offset of page could mean something else,
> e.g. when page_pool page is used instead. So excluding mergeable mode to
> avoid such a problem.

If this issue happens only in the case of page_pool, it would be
better to squash it there.

Thanks

>
> Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
> ---
>  drivers/net/virtio_net.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 5a7f7a76b920..c5dca0d92e64 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -497,7 +497,7 @@ static struct sk_buff *page_to_skb(struct virtnet_inf=
o *vi,
>                         return NULL;
>
>                 page =3D (struct page *)page->private;
> -               if (page)
> +               if (!vi->mergeable_rx_bufs && page)
>                         give_pages(rq, page);
>                 goto ok;
>         }
> --
> 2.31.1
>


