Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6F04911BC
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 23:31:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243613AbiAQWbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 17:31:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:26072 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238567AbiAQWbp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 17:31:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642458705;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FL822A+VhuSR8ouSoFdCDXJX7fbLnOA4cmggcaKq1ko=;
        b=Te5sMuXo3EoowvB26sbT9xghEb9jHXJb2wpvOWM4HhwK4lWA0/v7M45iFoL85fCO6dhe2p
        sFnO3qDLyKys4yXKU9hcqpphnVRkjaGKGOxugZ66BRpFRGx9z2/o9+6MTMPZiCMSaMioyZ
        8Pe4VRH6gCA+mSI+WqhcjXNmu3KPc4o=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-671-1S6vjQOzMkOcmfUuiwq_lQ-1; Mon, 17 Jan 2022 17:31:43 -0500
X-MC-Unique: 1S6vjQOzMkOcmfUuiwq_lQ-1
Received: by mail-ed1-f71.google.com with SMTP id r14-20020aa7da0e000000b004021fa39843so4594880eds.15
        for <netdev@vger.kernel.org>; Mon, 17 Jan 2022 14:31:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FL822A+VhuSR8ouSoFdCDXJX7fbLnOA4cmggcaKq1ko=;
        b=dWLT+Fy2/Qyb1EaHu2ntOqtEXqAxm2hECdaIjS5UjwOcRLnq1pJeV4k9M+zHjI4BC/
         dYAV/F7zgl0oW4dFMjUwKJFwpp8s3vcsc9ZpIjNe01Y38Lnvvb7HHf6O+R5PbkB13k52
         Ilvi2lm5mXmaQQQfnzbSffqEWe0vjkIIWe1qU0KjhnYsUdW3OLk5AgPsEWqFQYA9eiDi
         yZnHGxj+MlvJg+K1a3w+Ph6njsNbsJJDlydUJti67rIAHQMx19OFs1e8lmuzuKf3U0Sp
         +NtDQ4f/mKKbwgBgOyy5dcatCqWuUYdrz927rTLJgm9w5MiLSuhsJ4keWNyPDTqQTkdw
         rbPQ==
X-Gm-Message-State: AOAM533Injil1QgPhNe+fku2acSASfy7tgh2eF6f7mobK/XewFvPc3aA
        DL4ZNMt0oh6307eecFGNenhA7eh0MDCWTV1XVKfe8xRckl9C8Nz2lA10Mm9U6L5fI84V4DPCLs2
        YlbM8IZ6HverOMG9W
X-Received: by 2002:a17:907:3f94:: with SMTP id hr20mr8801513ejc.88.1642458702587;
        Mon, 17 Jan 2022 14:31:42 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzFtcIaT07HfzGtTIKKXfoD/SNDOq7+REx2KhQH3zo4ePI7rSI/H0kRcW3ViUs+z49kNyQvBw==
X-Received: by 2002:a17:907:3f94:: with SMTP id hr20mr8801484ejc.88.1642458702391;
        Mon, 17 Jan 2022 14:31:42 -0800 (PST)
Received: from redhat.com ([2.55.154.241])
        by smtp.gmail.com with ESMTPSA id a1sm6330754edu.17.2022.01.17.14.31.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jan 2022 14:31:39 -0800 (PST)
Date:   Mon, 17 Jan 2022 17:31:30 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        christophe.jaillet@wanadoo.fr, dapeng1.mi@intel.com,
        david@redhat.com, elic@nvidia.com, eperezma@redhat.com,
        flyingpenghao@gmail.com, flyingpeng@tencent.com,
        gregkh@linuxfoundation.org, guanjun@linux.alibaba.com,
        jasowang@redhat.com, jean-philippe@linaro.org,
        jiasheng@iscas.ac.cn, johan@kernel.org, keescook@chromium.org,
        labbott@kernel.org, lingshan.zhu@intel.com, lkp@intel.com,
        luolikang@nsfocus.com, lvivier@redhat.com, pasic@linux.ibm.com,
        sgarzare@redhat.com, somlo@cmu.edu, trix@redhat.com,
        wu000273@umn.edu, xianting.tian@linux.alibaba.com,
        xuanzhuo@linux.alibaba.com, yun.wang@linux.alibaba.com
Subject: Re: [GIT PULL] virtio,vdpa,qemu_fw_cfg: features, cleanups, fixes
Message-ID: <20220117172924-mutt-send-email-mst@kernel.org>
References: <20220114153515-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220114153515-mutt-send-email-mst@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 14, 2022 at 03:35:15PM -0500, Michael S. Tsirkin wrote:
> Jean-Philippe Brucker (5):
>       iommu/virtio: Add definitions for VIRTIO_IOMMU_F_BYPASS_CONFIG
>       iommu/virtio: Support bypass domains
>       iommu/virtio: Sort reserved regions
>       iommu/virtio: Pass end address to viommu_add_mapping()
>       iommu/virtio: Support identity-mapped domains

Linus, just making sure we are on the same page: Jean-Philippe
asked me to drop these patches since another version has been
accepted into another tree. So I did and sent v2 of the pull.
Hope that's clear and sorry about the noise.

-- 
MST

