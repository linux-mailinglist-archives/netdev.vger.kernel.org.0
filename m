Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63A1F6A7CC6
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 09:34:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbjCBIeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 03:34:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbjCBIeP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 03:34:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 864CF126F9
        for <netdev@vger.kernel.org>; Thu,  2 Mar 2023 00:33:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677746009;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=J2wWYhw4IbCn2jiud1m9fHjCN/hg14p3hY5/TY/f9/s=;
        b=EJ8O7lb/BaF1WzZscLWAQvJKrUX2B9an/qXahaGczc9/e9dxJnHCtcgfZHaJrYq3yP8nO8
        0tRoxmeWNt4pINfWe099QJbabzvDYJEX+AlLSPBB3lgax1FCYzpEUZosyodJ3Dygwwn0+j
        6tVpgvIoMwSjvfk02UfuEKToTQjtDWw=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-670-XCpP2dhAN-iKRgkblAwCcw-1; Thu, 02 Mar 2023 03:33:28 -0500
X-MC-Unique: XCpP2dhAN-iKRgkblAwCcw-1
Received: by mail-qk1-f197.google.com with SMTP id m25-20020ae9e019000000b007421ddd945eso9512841qkk.6
        for <netdev@vger.kernel.org>; Thu, 02 Mar 2023 00:33:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677746008;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J2wWYhw4IbCn2jiud1m9fHjCN/hg14p3hY5/TY/f9/s=;
        b=LAGDYL868glZ8LEF7bSdYhqr3AjmM3PjxntF/k21FxfGvZjrqJRkK9dhxsZzQT663b
         iiCCdMowQr3Qx7tcjR84RYEHHbXXfkFSfA/ui9rcV3Q8s8rYl6JNKjBTL/xPg4qN/Tv6
         FQriWL3XsfY0550xLdrNlLsUrMpGXy+JA+a6aH5ZzYepznzZf/RwpMtnCme6fkEmK+P8
         YNg+zcc4+F79xIw75jiEHvHaswnJ8haoFVPQY4Gba2ZBRGU9R+WbKbTCtc9SSE6mmdPC
         Usn4RRGlV4a/xe19ABJqO+elg5Ak+snCfLCu3j0JgiDrTqaOfLp4uj18MhR9EwHaO7BF
         ZqFw==
X-Gm-Message-State: AO0yUKWW6CfBl87ndxAK5CdFeT1GRJEzYbfenJDP1G/Bws1mmyhjtbdK
        uMwdxRPdB2AZgOku+5oWTg+DDblYsxFfFz8p3PHVY9Bv3WvN2WDA1Ze3hTNqLnN6Nx52TGBiAQS
        J2rI7QgSTyf4WCVMU
X-Received: by 2002:a05:6214:19c6:b0:56e:b5a0:29eb with SMTP id j6-20020a05621419c600b0056eb5a029ebmr17272853qvc.40.1677746007954;
        Thu, 02 Mar 2023 00:33:27 -0800 (PST)
X-Google-Smtp-Source: AK7set99YYiQIT3q7u8Fs8YEPbCbxaT865af9SQwhTIhLrsPHZ5cKOxrj+xqsWWZYUHwSbbTr5OKZw==
X-Received: by 2002:a05:6214:19c6:b0:56e:b5a0:29eb with SMTP id j6-20020a05621419c600b0056eb5a029ebmr17272835qvc.40.1677746007699;
        Thu, 02 Mar 2023 00:33:27 -0800 (PST)
Received: from sgarzare-redhat ([212.43.115.213])
        by smtp.gmail.com with ESMTPSA id d187-20020ae9efc4000000b007428e743508sm9907618qkg.70.2023.03.02.00.33.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 00:33:27 -0800 (PST)
Date:   Thu, 2 Mar 2023 09:33:14 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Gautam Dawar <gautam.dawar@amd.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-net-drivers@amd.com,
        harpreet.anand@amd.com, tanuj.kamde@amd.com
Subject: Re: [PATCH] vhost-vdpa: free iommu domain after last use during
 cleanup
Message-ID: <20230302083314.xj2wlzkarvsmofd6@sgarzare-redhat>
References: <20230301163203.29883-1-gautam.dawar@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230301163203.29883-1-gautam.dawar@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 01, 2023 at 10:02:01PM +0530, Gautam Dawar wrote:
>Currently vhost_vdpa_cleanup() unmaps the DMA mappings by calling
>`iommu_unmap(v->domain, map->start, map->size);`
>from vhost_vdpa_general_unmap() when the parent vDPA driver doesn't
>provide DMA config operations.
>
>However, the IOMMU domain referred to by `v->domain` is freed in
>vhost_vdpa_free_domain() before vhost_vdpa_cleanup() in
>vhost_vdpa_release() which results in NULL pointer de-reference.
>Accordingly, moving the call to vhost_vdpa_free_domain() in
>vhost_vdpa_cleanup() would makes sense. This will also help
>detaching the dma device in error handling of vhost_vdpa_alloc_domain().

Yep, good cleanup!

>
>This issue was observed on terminating QEMU with SIGQUIT.
>
>Fixes: 037d4305569a ("vhost-vdpa: call vhost_vdpa_cleanup during the release")
>Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
>---
> drivers/vhost/vdpa.c | 3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

