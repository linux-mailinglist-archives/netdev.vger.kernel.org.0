Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15DA4323987
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 10:33:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234660AbhBXJdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 04:33:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45725 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234618AbhBXJcU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 04:32:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614159054;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7aDdkz1NoI966nz5oxyifwdANt/93ivruZ7xE/ouurI=;
        b=WT4D8b1fVU56E134D5BVfM5bw7+0bxJW7Pw85J7Za2H0IPqQaKZcZBrBjGkg8wIV15+wtu
        IqD3TC7VtxhodIQSXvJN/6ypUJYYLqxn5WSIvopHvQ4B3Qqj1ByaN5MoAywYqij6kWjMaq
        buRkNxMoLpmQKwMgtPjxyFRX1L646hg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-25-OesmgzzbMM6P57rwNLKp_A-1; Wed, 24 Feb 2021 04:30:50 -0500
X-MC-Unique: OesmgzzbMM6P57rwNLKp_A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0BFF480364D;
        Wed, 24 Feb 2021 09:30:49 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-12-28.pek2.redhat.com [10.72.12.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EADDD6064B;
        Wed, 24 Feb 2021 09:30:38 +0000 (UTC)
Subject: Re: [PATCH] vdpa/mlx5: set_features should allow reset to zero
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Si-Wei Liu <si-wei.liu@oracle.com>, elic@nvidia.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <22fe5923-635b-59f0-7643-2fd5876937c2@oracle.com>
 <fae0bae7-e4cd-a3aa-57fe-d707df99b634@redhat.com>
 <20210223082536-mutt-send-email-mst@kernel.org>
 <3ff5fd23-1db0-2f95-4cf9-711ef403fb62@oracle.com>
 <20210224000057-mutt-send-email-mst@kernel.org>
 <0559fd8c-ff44-cb7a-8a74-71976dd2ee33@redhat.com>
 <20210224014232-mutt-send-email-mst@kernel.org>
 <ce6b0380-bc4c-bcb8-db82-2605e819702c@redhat.com>
 <20210224021222-mutt-send-email-mst@kernel.org>
 <babc654d-8dcd-d8a2-c3b6-d20cc4fc554c@redhat.com>
 <20210224034240-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <d2992c03-d639-54e3-4599-c168ceeac148@redhat.com>
Date:   Wed, 24 Feb 2021 17:30:37 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210224034240-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/2/24 4:43 下午, Michael S. Tsirkin wrote:
> On Wed, Feb 24, 2021 at 04:26:43PM +0800, Jason Wang wrote:
>>      Basically on first guest access QEMU would tell kernel whether
>>      guest is using the legacy or the modern interface.
>>      E.g. virtio_pci_config_read/virtio_pci_config_write will call ioctl(ENABLE_LEGACY, 1)
>>      while virtio_pci_common_read will call ioctl(ENABLE_LEGACY, 0)
>>
>>
>> But this trick work only for PCI I think?
>>
>> Thanks
> ccw has a revision it can check. mmio does not have transitional devices
> at all.


Ok, then we can do the workaround in the qemu, isn't it?

Thanks


