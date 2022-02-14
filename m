Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4A1F4B41FB
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 07:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240840AbiBNG2p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 01:28:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231207AbiBNG2o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 01:28:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B551455499
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 22:28:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644820116;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gS2aVmuoCtNo2/qNoxUIuIA2KGBRg4tAugCTlOlURtc=;
        b=eJhKbZNncRzwh2sHKB1GJUd/62547UNZQ9cyMw5kzi/6N2P0u6LEAeTK+cKh/w9ExjVjpI
        m59yxS3luxEZ6VfvMOBiMVDtclEKA0/yRmUiEIzCPgk81IofycES6HpBbgvTd0Z52b667C
        0ed0ypH7PyaRpcCQ+dZnmvecR2jBO38=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-636-6vsPrx4qPWOE6IhcHHlFUA-1; Mon, 14 Feb 2022 01:28:33 -0500
X-MC-Unique: 6vsPrx4qPWOE6IhcHHlFUA-1
Received: by mail-pf1-f199.google.com with SMTP id f24-20020aa782d8000000b004bc00caa4c0so11077115pfn.3
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 22:28:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=gS2aVmuoCtNo2/qNoxUIuIA2KGBRg4tAugCTlOlURtc=;
        b=w9FBT0AX1yq9OJMj6elk4xUyceCsqgQkwONA+lBH28wVNvVIZVkt04ek/NUam0CHRB
         rBe47AfxzegeA+wSqFZdKinIdoCoF+R+o4FQzWHfvYnacbAtg/r5v7GwiTOHNUHk7vC7
         zg88le8YSqeXuYF5Y/3clJbDEz8SCNrMwXVZrrFMz0JP9IiQuvZQWBAgz8N+ngrOPmjl
         XtOeCcEuA7nD5X1DHjqlYwgRJiEXhiUEztTUlCQWMHH7SX4hk+AMSfrfpJo9Q1CvMP9g
         3FBbNv5Gf+5UkBbHvHf7o708LiEkXDKSvX3ruGdtt8E4F95p3n+0IT+OuGErRububkbB
         QwOQ==
X-Gm-Message-State: AOAM530bg0L49pgUMFLAvYRcT4WR991Bcppcr6l8XJceFk6QZgd/rg+H
        hnAmqCvk7a7ZtocYZxp5LIutApMVq06SZs8sPJeGJJE0AQXSscDBe4zubsbKIO6xKRE9l75eSzK
        r97MnYrhoiPreJoyl
X-Received: by 2002:a65:4bc9:: with SMTP id p9mr10524813pgr.168.1644820109458;
        Sun, 13 Feb 2022 22:28:29 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyy08bsIikDcGp2bA1tyX8g5QfTM2Ih/be5IzmuVhJji489CNCEeYdKeS+uiIb0h5jrkZCyCA==
X-Received: by 2002:a65:4bc9:: with SMTP id p9mr10524806pgr.168.1644820109276;
        Sun, 13 Feb 2022 22:28:29 -0800 (PST)
Received: from [10.72.12.239] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j14sm36793051pfj.218.2022.02.13.22.28.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Feb 2022 22:28:28 -0800 (PST)
Message-ID: <850f56f6-870f-deb3-da6a-6df6e238e234@redhat.com>
Date:   Mon, 14 Feb 2022 14:28:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH V4 3/4] vhost_vdpa: don't setup irq offloading when
 irq_num < 0
Content-Language: en-US
To:     Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org
References: <20220203072735.189716-1-lingshan.zhu@intel.com>
 <20220203072735.189716-4-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220203072735.189716-4-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/2/3 下午3:27, Zhu Lingshan 写道:
> When irq number is negative(e.g., -EINVAL), the virtqueue
> may be disabled or the virtqueues are sharing a device irq.
> In such case, we should not setup irq offloading for a virtqueue.
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---
>   drivers/vhost/vdpa.c | 4 ++++
>   1 file changed, 4 insertions(+)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 851539807bc9..c4fcacb0de3a 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -96,6 +96,10 @@ static void vhost_vdpa_setup_vq_irq(struct vhost_vdpa *v, u16 qid)
>   	if (!ops->get_vq_irq)
>   		return;
>   
> +	irq = ops->get_vq_irq(vdpa, qid);
> +	if (irq < 0)
> +		return;
> +
>   	irq = ops->get_vq_irq(vdpa, qid);


So the get_vq_irq() will be called twice?


>   	irq_bypass_unregister_producer(&vq->call_ctx.producer);
>   	if (!vq->call_ctx.ctx || irq < 0)


We're already checked irq against 0 here.

Thanks


