Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 995B53F5CE4
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 13:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236697AbhHXLKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 07:10:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57328 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236394AbhHXLKs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 07:10:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629803403;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6MzIVYD6Rkcf1avefY9xlULEY3kI1KocMJ7+mbhVSUk=;
        b=J9zoicPacGc8JCVXDTJ1GPTrxpOvQpo1Q/257vWmOFjmtp5Agg0IF8Dg9Q/xwcx1Ik7eRK
        BWYjpB6K7Aqy5VmftBmDWsYkhPbASYgWnqYorRktJDMywF5vTY/k8HvGljgnemD44ew/Nv
        OpbAykFaiQPxE3CZdd2bEWOOJrxEAyM=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-63-c6sAH01CP5esHDmnYQINdA-1; Tue, 24 Aug 2021 07:10:02 -0400
X-MC-Unique: c6sAH01CP5esHDmnYQINdA-1
Received: by mail-ed1-f72.google.com with SMTP id bx23-20020a0564020b5700b003bf2eb11718so10320945edb.20
        for <netdev@vger.kernel.org>; Tue, 24 Aug 2021 04:10:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6MzIVYD6Rkcf1avefY9xlULEY3kI1KocMJ7+mbhVSUk=;
        b=nwh8U9TZ86Q6Kz4p54Ct97LaA/h/Tv/nX0py6CwrJ9MScNEV2aqfvkYj8wb+l14NaK
         Ywr052v4sINYY039BcWPqtesX93DiNs5ELuhNqcX/nZxWXj+RvtjVAyXlkw+EJx8HmI0
         tkJRoeDUd0AzMvdRl2TbiLxdMWjA+l7P1kVB9ikjCjVTcIVL1QdhZOOHlvEEtRGM1/YF
         pBnxhNLl+rEToTL2tDZ4OhBGuIou73Ds36HL2UDbP1xx7Lob5OzRwYIQn8/MYUhlqukm
         LHqNXRRO2KfadnM0Di2G3PCad6MR5GDlR40WM+p+vdI/NhXRC8JBwg3AIoCjUO/ZjXLE
         ghGg==
X-Gm-Message-State: AOAM532k9GVgz5bjooCSQVncdgE5IvpqHfphjhe5d1JsZawL97j7SnwQ
        UCLaPIiXfbyd2zDlX3BoT5JcdulXJnmV0CMXOesgLTsEXhSs+P3aJbexydIbXv6S6SINS/aZEG4
        UqzCZ4udBRGHSVLFD
X-Received: by 2002:a17:906:9bdc:: with SMTP id de28mr40030304ejc.154.1629803401150;
        Tue, 24 Aug 2021 04:10:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJym2zZCfOfkB6aYg6hvpM9EYCUNutnmi5ZkMGiE/H3YmE4qf/VSJ5+nHLjDGlfYfIZpl2VYMg==
X-Received: by 2002:a17:906:9bdc:: with SMTP id de28mr40030281ejc.154.1629803400969;
        Tue, 24 Aug 2021 04:10:00 -0700 (PDT)
Received: from steredhat (host-79-45-8-152.retail.telecomitalia.it. [79.45.8.152])
        by smtp.gmail.com with ESMTPSA id u2sm9003772ejc.61.2021.08.24.04.09.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 04:10:00 -0700 (PDT)
Date:   Tue, 24 Aug 2021 13:09:56 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Xie Yongji <xieyongji@bytedance.com>
Cc:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        parav@nvidia.com, hch@infradead.org,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org,
        gregkh@linuxfoundation.org, zhe.he@windriver.com,
        xiaodong.liu@intel.com, joe@perches.com, robin.murphy@arm.com,
        songmuchun@bytedance.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 03/12] vdpa: Fix some coding style issues
Message-ID: <20210824110956.gtajf34s2xpm66gx@steredhat>
References: <20210818120642.165-1-xieyongji@bytedance.com>
 <20210818120642.165-4-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210818120642.165-4-xieyongji@bytedance.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 18, 2021 at 08:06:33PM +0800, Xie Yongji wrote:
>Fix some code indent issues and following checkpatch warning:
>
>WARNING: Prefer 'unsigned int' to bare use of 'unsigned'
>371: FILE: include/linux/vdpa.h:371:
>+static inline void vdpa_get_config(struct vdpa_device *vdev, unsigned offset,
>
>Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
>---
> include/linux/vdpa.h | 34 +++++++++++++++++-----------------
> 1 file changed, 17 insertions(+), 17 deletions(-)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
>index 954b340f6c2f..8a645f8f4476 100644
>--- a/include/linux/vdpa.h
>+++ b/include/linux/vdpa.h
>@@ -43,17 +43,17 @@ struct vdpa_vq_state_split {
>  * @last_used_idx: used index
>  */
> struct vdpa_vq_state_packed {
>-        u16	last_avail_counter:1;
>-        u16	last_avail_idx:15;
>-        u16	last_used_counter:1;
>-        u16	last_used_idx:15;
>+	u16	last_avail_counter:1;
>+	u16	last_avail_idx:15;
>+	u16	last_used_counter:1;
>+	u16	last_used_idx:15;
> };
>
> struct vdpa_vq_state {
>-     union {
>-          struct vdpa_vq_state_split split;
>-          struct vdpa_vq_state_packed packed;
>-     };
>+	union {
>+		struct vdpa_vq_state_split split;
>+		struct vdpa_vq_state_packed packed;
>+	};
> };
>
> struct vdpa_mgmt_dev;
>@@ -131,7 +131,7 @@ struct vdpa_iova_range {
>  *				@vdev: vdpa device
>  *				@idx: virtqueue index
>  *				@state: pointer to returned state (last_avail_idx)
>- * @get_vq_notification: 	Get the notification area for a virtqueue
>+ * @get_vq_notification:	Get the notification area for a virtqueue
>  *				@vdev: vdpa device
>  *				@idx: virtqueue index
>  *				Returns the notifcation area
>@@ -353,25 +353,25 @@ static inline struct device *vdpa_get_dma_dev(struct vdpa_device *vdev)
>
> static inline void vdpa_reset(struct vdpa_device *vdev)
> {
>-        const struct vdpa_config_ops *ops = vdev->config;
>+	const struct vdpa_config_ops *ops = vdev->config;
>
> 	vdev->features_valid = false;
>-        ops->set_status(vdev, 0);
>+	ops->set_status(vdev, 0);
> }
>
> static inline int vdpa_set_features(struct vdpa_device *vdev, u64 features)
> {
>-        const struct vdpa_config_ops *ops = vdev->config;
>+	const struct vdpa_config_ops *ops = vdev->config;
>
> 	vdev->features_valid = true;
>-        return ops->set_features(vdev, features);
>+	return ops->set_features(vdev, features);
> }
>
>-
>-static inline void vdpa_get_config(struct vdpa_device *vdev, unsigned offset,
>-				   void *buf, unsigned int len)
>+static inline void vdpa_get_config(struct vdpa_device *vdev,
>+				   unsigned int offset, void *buf,
>+				   unsigned int len)
> {
>-        const struct vdpa_config_ops *ops = vdev->config;
>+	const struct vdpa_config_ops *ops = vdev->config;
>
> 	/*
> 	 * Config accesses aren't supposed to trigger before features are set.
>-- 
>2.11.0
>

