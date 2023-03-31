Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3577B6D18EF
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 09:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbjCaHqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 03:46:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230388AbjCaHq1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 03:46:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E3401A952
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 00:45:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680248741;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ijuijWfOviH3p+YNIe7G3DYHHIm8VDsoLsYWWShhetc=;
        b=Q1y5wMc2zk2H523GR3Q4ltmFSrX4DtQhtzHM4XQ8qeK+p4zfoM85mWujiguGG/lg6VU50J
        BMCDRO//W9+CQFWJFinnTcJAH49Ui1LhSo3dT/iq/mb5BvpYseFtdifyBRmIXzepQgHrD3
        KJUvzX93xTNn7ABlm2qneC4VTI+N6Zs=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-299-9c0Lf8R6ME6FELrZ8vi8qA-1; Fri, 31 Mar 2023 03:45:39 -0400
X-MC-Unique: 9c0Lf8R6ME6FELrZ8vi8qA-1
Received: by mail-ed1-f71.google.com with SMTP id k30-20020a50ce5e000000b00500544ebfb1so30455113edj.7
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 00:45:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680248738;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ijuijWfOviH3p+YNIe7G3DYHHIm8VDsoLsYWWShhetc=;
        b=SOGkUMRbEnyX4OzSDRrfpH7bbED+c4IWMynVnX8wxbsUiGcrHUulntpIDFFCCKoF9K
         QrCwoaSic3MqKGuUX3Yv68QY+rZN+ZoiMpPqN1ocriNXdAJAZ0plYIswz9L6v8yQCpEp
         OmHde4NwAT5ckIVE0/11xEqbJ+9LHactQ+x4Cogw7vp9f6KbDq/X16eOe8xvAUj3ArCv
         ij+ti7Wv388O+jSNx/GB3fqVc+uvBUVr0BSdRBtqDI56VUWGSS6Xsz3zJBPxNP9ja3zZ
         j1gXyweqAAWrnOTjMe3Lj+gCKsPbw35V4W9tCxqzqtNprljPK5zixsqINi8Eqts8sLAu
         bjIA==
X-Gm-Message-State: AAQBX9fpTyMxXiHCQkrlMhxMDbDQXgqfnD/PCaPwnzVJqRvKX+tgD9c1
        AA/7AyxQr0hsm2mCI644T6HWMColPKQnELOr2uOLXtnIGmFQIJKAEgL4B85hgxYTswcmlsFQIgZ
        ldRH4i42Q/jQRAYek
X-Received: by 2002:a17:906:5785:b0:93d:1c2b:bd23 with SMTP id k5-20020a170906578500b0093d1c2bbd23mr28486737ejq.39.1680248738074;
        Fri, 31 Mar 2023 00:45:38 -0700 (PDT)
X-Google-Smtp-Source: AKy350YS3/z+4R+xl2x92XT2RXYCogfvtYmw2I34NDhSWzTMLR1o5S98t+qcxg+NZzy9Jd9gHuGQoQ==
X-Received: by 2002:a17:906:5785:b0:93d:1c2b:bd23 with SMTP id k5-20020a170906578500b0093d1c2bbd23mr28486717ejq.39.1680248737742;
        Fri, 31 Mar 2023 00:45:37 -0700 (PDT)
Received: from sgarzare-redhat (host-82-57-51-130.retail.telecomitalia.it. [82.57.51.130])
        by smtp.gmail.com with ESMTPSA id dx21-20020a170906a85500b008d044ede804sm677526ejb.163.2023.03.31.00.45.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 00:45:37 -0700 (PDT)
Date:   Fri, 31 Mar 2023 09:45:33 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     virtualization@lists.linux-foundation.org,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        Jason Wang <jasowang@redhat.com>, eperezma@redhat.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, stefanha@redhat.com,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v4 5/9] vringh: support VA with iotlb
Message-ID: <3jqstd75xs6f2pn7pwjxnkphhan5bk25er3ord4rw63545htu7@vgngick7zfco>
References: <20230324153607.46836-1-sgarzare@redhat.com>
 <20230324153919.47633-1-sgarzare@redhat.com>
 <ZCWIXZbeWanvPJA3@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <ZCWIXZbeWanvPJA3@corigine.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 30, 2023 at 03:02:21PM +0200, Simon Horman wrote:
>On Fri, Mar 24, 2023 at 04:39:19PM +0100, Stefano Garzarella wrote:
>> vDPA supports the possibility to use user VA in the iotlb messages.
>> So, let's add support for user VA in vringh to use it in the vDPA
>> simulators.
>>
>> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>
>...
>
>> +/**
>> + * vringh_init_iotlb_va - initialize a vringh for a ring with IOTLB containing
>> + *                        user VA.
>> + * @vrh: the vringh to initialize.
>> + * @features: the feature bits for this ring.
>> + * @num: the number of elements.
>> + * @weak_barriers: true if we only need memory barriers, not I/O.
>> + * @desc: the userpace descriptor pointer.
>> + * @avail: the userpace avail pointer.
>> + * @used: the userpace used pointer.
>
>nit: s/userpace/userspace/

Oops, good catch!

Copy & past typos also present in the documentation of vringh_init_kern
and vringh_init_iotlb.

I will fix this patch and send a separate patch to fix the other two.

Thanks,
Stefano

