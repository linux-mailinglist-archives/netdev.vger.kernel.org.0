Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1260B3F455E
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 08:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234999AbhHWG5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 02:57:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23170 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231779AbhHWG5e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 02:57:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629701811;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O6CVC1MYmQ2Yd0dGkq2W7I4r7P5G0FEqZECeGZvY4DU=;
        b=XXF/4I/38ALUpSv+8JjcB+ns36Ve9oM+NCq9KntYK7oNglIzbEBdPkbCPPVwlrvcDn34bw
        0ujSGtoKlPl8NjbhPBrBLG4afPHZV+xGhWUEO/kZdP5gAKAe54sbu4IJSKWlTmBtSKCHND
        yRoK3dxm0/NCtDEeEfEVl9t2/ht4g6M=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-509-qeVCOQf8PsqBgddt8r8XQg-1; Mon, 23 Aug 2021 02:56:48 -0400
X-MC-Unique: qeVCOQf8PsqBgddt8r8XQg-1
Received: by mail-pg1-f199.google.com with SMTP id k11-20020a6568cb0000b029023d00ca7bbcso9859824pgt.22
        for <netdev@vger.kernel.org>; Sun, 22 Aug 2021 23:56:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=O6CVC1MYmQ2Yd0dGkq2W7I4r7P5G0FEqZECeGZvY4DU=;
        b=PIjZ5nfVOb9GydmTzr5h9bPP+y7TKtOPsfusjMbKTgNRP8KElwO1XX9N06njNQ+yVj
         1kuqmvrOTbwUZDsLS6qz4A2+A06G9zYYq9q6JB9qIpHTGIVLYGUAlfVs1ibWYLWSC/oY
         x15t1DWOkM0er1M5by/iNQcbXjRyY2+C0xAPXil4+h1u2PlKttLaeglD1ntFSF4heIBY
         p/e4J7+FztpXMKhRaP4u9SpxtFtNbZAxhn27CeeSfKo3250h3xjilozGCkMqfcTfuIMQ
         7qqDDBbQIQnHbDRKcdME0xhglCYnExeg/t6ZIRve4kL/tvky2djJcAnVTUFSOyAxS9+N
         M8Bw==
X-Gm-Message-State: AOAM532jxPLecF8S4efs/3JxLIbzz40PXKlFxa999gKGZX6EjDBHzvc5
        8gJ13o2VHw4zTNvH8bQn83akUis/KBZrZIDUkQuy0+F9f3MDO+IBrzQLTJeJOxWUNjOvRqtD8O0
        HSQzoPBxJsm/dXNB9
X-Received: by 2002:aa7:9ddc:0:b0:3e1:5fc1:1d20 with SMTP id g28-20020aa79ddc000000b003e15fc11d20mr32664034pfq.48.1629701807253;
        Sun, 22 Aug 2021 23:56:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxeDlxuu1bqct4xksqs7isW8FxpMxOH+GNhpdYUwjloBQhDlJbitQ/vFhNd4D+BhyIvDS4Fgg==
X-Received: by 2002:aa7:9ddc:0:b0:3e1:5fc1:1d20 with SMTP id g28-20020aa79ddc000000b003e15fc11d20mr32664016pfq.48.1629701807013;
        Sun, 22 Aug 2021 23:56:47 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id n30sm14807096pfv.87.2021.08.22.23.56.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Aug 2021 23:56:46 -0700 (PDT)
Subject: Re: [PATCH v11 11/12] vduse: Introduce VDUSE - vDPA Device in
 Userspace
To:     Xie Yongji <xieyongji@bytedance.com>, mst@redhat.com,
        stefanha@redhat.com, sgarzare@redhat.com, parav@nvidia.com,
        hch@infradead.org, christian.brauner@canonical.com,
        rdunlap@infradead.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, axboe@kernel.dk, bcrl@kvack.org,
        corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org,
        gregkh@linuxfoundation.org, zhe.he@windriver.com,
        xiaodong.liu@intel.com, joe@perches.com, robin.murphy@arm.com
Cc:     songmuchun@bytedance.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <20210818120642.165-1-xieyongji@bytedance.com>
 <20210818120642.165-12-xieyongji@bytedance.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <cfc11f6b-764b-7a52-2c4a-6fa22e6c1585@redhat.com>
Date:   Mon, 23 Aug 2021 14:56:33 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210818120642.165-12-xieyongji@bytedance.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/8/18 ÏÂÎç8:06, Xie Yongji Ð´µÀ:
> This VDUSE driver enables implementing software-emulated vDPA
> devices in userspace. The vDPA device is created by
> ioctl(VDUSE_CREATE_DEV) on /dev/vduse/control. Then a char device
> interface (/dev/vduse/$NAME) is exported to userspace for device
> emulation.
>
> In order to make the device emulation more secure, the device's
> control path is handled in kernel. A message mechnism is introduced
> to forward some dataplane related control messages to userspace.
>
> And in the data path, the DMA buffer will be mapped into userspace
> address space through different ways depending on the vDPA bus to
> which the vDPA device is attached. In virtio-vdpa case, the MMU-based
> software IOTLB is used to achieve that. And in vhost-vdpa case, the
> DMA buffer is reside in a userspace memory region which can be shared
> to the VDUSE userspace processs via transferring the shmfd.
>
> For more details on VDUSE design and usage, please see the follow-on
> Documentation commit.
>
> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>


Acked-by: Jason Wang <jasowang@redhat.com>


