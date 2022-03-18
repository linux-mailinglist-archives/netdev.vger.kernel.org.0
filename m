Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72F5D4DD76B
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 10:54:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234699AbiCRJzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 05:55:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234689AbiCRJzt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 05:55:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 720F3FA22D
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 02:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647597269;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=B0N2tqLbrUYXG1JSQlScpTqqNArTVktmTNzG3PVVQ64=;
        b=KSNa1vkL5p7Eq2AnvtKNmWV5edLGovzXZqUAPllatqyY330F6R0rdPpuhhsE0RFJ4HuZyO
        oVB0xeuiTBwaGt959gxQra9qcUH7PNwjG0y3wnIXdZtaxoXq6Sk+YYxo5KOkLU5oZLXVlD
        y2WDomVTSQ1BNhOw3ZLco6r8Dk31YUo=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-182-sop2R-VXMaKBonxvOgPidQ-1; Fri, 18 Mar 2022 05:54:28 -0400
X-MC-Unique: sop2R-VXMaKBonxvOgPidQ-1
Received: by mail-qk1-f199.google.com with SMTP id q5-20020a05620a0d8500b004738c1b48beso5036742qkl.7
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 02:54:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=B0N2tqLbrUYXG1JSQlScpTqqNArTVktmTNzG3PVVQ64=;
        b=MdtNE9tdLKWPxh6lfWYnTXc2MBVxHAHbBJb4yjqUDK6kFAoOhW5UrQCK0e5+ZVZ7d4
         lOjHMzNBp+orVvC+7jqQ7JgkOADwZ7jxZQK6+Y1oHKlHxrriX58nnhsZQ/VlhSNBwf/Z
         KMp8auhsXbbjmHLrRNzQ3n+o1cJMIYdm6vHSjcEY0WvODLSYXx9/szd4IFtzI9lyeOcm
         /2jVjt02Oxl79jqWViCXPApEfaJ7yy5Z7KSEN0i2OkgnlQttik6vOAFVCu87B8PcLJH9
         Eu4Mhr7VpaCNytRU9sENdn87crXhLQ8BIPN8CBL3N4w7LvSXUond0cLymSqhVWHKGBcX
         brJA==
X-Gm-Message-State: AOAM530bAWyNe16IEy9Ipx2UcNaSgNK1INcH+Ecm7rd/c9OKEh2ximQs
        t1oVNOMZbEPCKUbZ8qpGf+YdpaAanDuqkQA/IyrUNL8PJqw58NHxL1+tHtihgKtz7PEM9XrYDZH
        0MYO1mVOQFC86OmO6
X-Received: by 2002:a0c:c404:0:b0:431:31c3:3d15 with SMTP id r4-20020a0cc404000000b0043131c33d15mr6517884qvi.116.1647597267947;
        Fri, 18 Mar 2022 02:54:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJww4OeEttXpHADmj/zwubxQlNCZdF6Q1KI9KtTuFS5WVsX1Yj8sug1rDI4IQP0gxF1xEeAyKQ==
X-Received: by 2002:a0c:c404:0:b0:431:31c3:3d15 with SMTP id r4-20020a0cc404000000b0043131c33d15mr6517872qvi.116.1647597267762;
        Fri, 18 Mar 2022 02:54:27 -0700 (PDT)
Received: from sgarzare-redhat (host-87-12-25-114.business.telecomitalia.it. [87.12.25.114])
        by smtp.gmail.com with ESMTPSA id de26-20020a05620a371a00b0067dc7923b14sm3642875qkb.132.2022.03.18.02.54.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 02:54:27 -0700 (PDT)
Date:   Fri, 18 Mar 2022 10:54:22 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Anirudh Rayabharam <mail@anirudhrb.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost: handle error while adding split ranges to iotlb
Message-ID: <20220318095422.a37g7vxaiwqo5wxx@sgarzare-redhat>
References: <20220312141121.4981-1-mail@anirudhrb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220312141121.4981-1-mail@anirudhrb.com>
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 12, 2022 at 07:41:21PM +0530, Anirudh Rayabharam wrote:
>vhost_iotlb_add_range_ctx() handles the range [0, ULONG_MAX] by
>splitting it into two ranges and adding them separately. The return
>value of adding the first range to the iotlb is currently ignored.
>Check the return value and bail out in case of an error.
>

We could add:

Fixes: e2ae38cf3d91 ("vhost: fix hung thread due to erroneous iotlb entries")

>Signed-off-by: Anirudh Rayabharam <mail@anirudhrb.com>
>---
> drivers/vhost/iotlb.c | 6 +++++-
> 1 file changed, 5 insertions(+), 1 deletion(-)
>
>diff --git a/drivers/vhost/iotlb.c b/drivers/vhost/iotlb.c
>index 40b098320b2a..5829cf2d0552 100644
>--- a/drivers/vhost/iotlb.c
>+++ b/drivers/vhost/iotlb.c
>@@ -62,8 +62,12 @@ int vhost_iotlb_add_range_ctx(struct vhost_iotlb *iotlb,
> 	 */
> 	if (start == 0 && last == ULONG_MAX) {
> 		u64 mid = last / 2;
>+		int err = vhost_iotlb_add_range_ctx(iotlb, start, mid, addr,
>+				perm, opaque);
>+
>+		if (err)
>+			return err;
>
>-		vhost_iotlb_add_range_ctx(iotlb, start, mid, addr, perm, opaque);
> 		addr += mid + 1;
> 		start = mid + 1;
> 	}
>-- 
>2.35.1
>

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

