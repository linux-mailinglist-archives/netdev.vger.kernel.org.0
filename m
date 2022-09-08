Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95EA15B2789
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 22:17:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbiIHURn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 16:17:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbiIHURh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 16:17:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 205DFF1F2B
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 13:17:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662668255;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yD4cAtXIFH0/Ur9Yshsiguty68HRFw8OjjEWW83mXvs=;
        b=c15iuC4TTtbwCGxW8+p6IrLslxQbyo8PCL9So2v44LbztBjAZHuq6SaqSpPp4END0xtCst
        22pOnNOPJN6I0xt/r5p597klUmzdFTdSDE8tjXWNFnEATfwDcWlfsO4Piro51isDLB89C9
        4UHSoo+EGuvoTi2VD6XvnpDHNP7l4ps=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-623-HcMD2FUyO1uk2Nv4CvLQCQ-1; Thu, 08 Sep 2022 16:17:34 -0400
X-MC-Unique: HcMD2FUyO1uk2Nv4CvLQCQ-1
Received: by mail-il1-f200.google.com with SMTP id i27-20020a056e021d1b00b002eb5eb4d200so15820734ila.21
        for <netdev@vger.kernel.org>; Thu, 08 Sep 2022 13:17:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date;
        bh=yD4cAtXIFH0/Ur9Yshsiguty68HRFw8OjjEWW83mXvs=;
        b=nF+2zRp7Ex9kmiSyY/loQjWgessUbR3zn5qfo3TidVe1XQ/AwmdxdhE3EfeRm/YyOC
         4yMmFYBmJSMQF716ue8efakGv9q3nmgEGAAsyjz/Xsx/xssQKVjxfA9aZCkswVtaZdu8
         Rz4HVO3o2OfYlK/z4KONXNXPgHTXPAjRSKNl2wjNcoJHF9O9zznPFTI+tazlZWGyyv19
         a0ORtYKDKccxA3nOgNUfYmTXx0yL80NMZRJvtA+XGER1SH2abI4jJNMn5lHtOp4tVlWd
         PGwHZ4VD5mMeKzIENKSGNrUnhA8oFqZ8O50Po2iPR15DC9d6J5uY91rnh5Z0Hd7zZ3gj
         hw2Q==
X-Gm-Message-State: ACgBeo1hW7EaI3atl+NAj6TUMIxzeCR++NxoDLG/4dwEJ9KQiHPfMJqz
        KdoI0nf6w4ztwEIUuV6eNb6LwZdW3hmOt/+1Vnb8lgztZ4snAz/beBPFhJJ+SIfft18C7gaFnvz
        un1U/TiR14iCKzzTM
X-Received: by 2002:a02:cb5b:0:b0:341:aebb:d13 with SMTP id k27-20020a02cb5b000000b00341aebb0d13mr5713156jap.176.1662668253628;
        Thu, 08 Sep 2022 13:17:33 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4ieupTKgqP5IgfEPO8C5Uf3rGGfr8qpWDENXJlrx9i2Vl+Hapi8i0L0fyFYMYoXoG0j+v2pw==
X-Received: by 2002:a02:cb5b:0:b0:341:aebb:d13 with SMTP id k27-20020a02cb5b000000b00341aebb0d13mr5713149jap.176.1662668253409;
        Thu, 08 Sep 2022 13:17:33 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id s3-20020a056e02216300b002f1d2a4c7e9sm1180452ilv.79.2022.09.08.13.17.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 13:17:33 -0700 (PDT)
Date:   Thu, 8 Sep 2022 14:17:31 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     <jgg@nvidia.com>, <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>
Subject: Re: [PATCH V7 vfio 00/10] Add device DMA logging support for mlx5
 driver
Message-ID: <20220908141731.57bc47ab.alex.williamson@redhat.com>
In-Reply-To: <20220908183448.195262-1-yishaih@nvidia.com>
References: <20220908183448.195262-1-yishaih@nvidia.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 8 Sep 2022 21:34:38 +0300
Yishai Hadas <yishaih@nvidia.com> wrote:

> This series adds device DMA logging uAPIs and their implementation as
> part of mlx5 driver.
> 
> DMA logging allows a device to internally record what DMAs the device is
> initiating and report them back to userspace. It is part of the VFIO
> migration infrastructure that allows implementing dirty page tracking
> during the pre copy phase of live migration. Only DMA WRITEs are logged,
> and this API is not connected to VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE.
> 
> The uAPIs are based on the FEATURE ioctl as were introduced earlier by
> the below RFC [1] and follows the notes that were discussed in the
> mailing list.
> 
> It includes:
> - A PROBE option to detect if the device supports DMA logging.
> - A SET option to start device DMA logging in given IOVAs ranges.
> - A GET option to read back and clear the device DMA log.
> - A SET option to stop device DMA logging that was previously started.
> 
> Extra details exist as part of relevant patches in the series.
> 
> In addition, the series adds some infrastructure support for managing an
> IOVA bitmap done by Joao Martins.
> 
> It abstracts how an IOVA range is represented in a bitmap that is
> granulated by a given page_size. So it translates all the lifting of
> dealing with user pointers into its corresponding kernel addresses.
> This new functionality abstracts the complexity of user/kernel bitmap
> pointer usage and finally enables an API to set some bits.
> 
> This functionality will be used as part of IOMMUFD series for the system
> IOMMU tracking.
> 
> Finally, we come with mlx5 implementation based on its device
> specification for the DMA logging APIs.
> 
> The matching qemu changes can be previewed here [2].
> They come on top of the v2 migration protocol patches that were sent
> already to the mailing list.
> 
> Note:
> - As this series touched mlx5_core parts we may need to send the
>   net/mlx5 patches as a pull request format to VFIO to avoid conflicts
>   before acceptance.
> 
> [1] https://lore.kernel.org/all/20220501123301.127279-1-yishaih@nvidia.com/T/
> [2] https://github.com/avihai1122/qemu/commits/device_dirty_tracking
> 
> Changes from V6: https://lore.kernel.org/all/20220905105852.26398-11-yishaih@nvidia.com/T/
> - Use the first two patches from the PR that was sent by Leon, no code
>   change was involved.
> - Patch #5:
> * Add a documentation note near vfio_log_ops as Alex suggested.

Pulled topic branch from Leon and applied 3-10 to the vfio next branch
for v6.1.  Thanks,

Alex

