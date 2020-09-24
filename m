Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2D62276BDF
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 10:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727293AbgIXI2k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 04:28:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60748 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726849AbgIXI2k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 04:28:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600936119;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JTY1j3OmhHbXJbAzmk77hPlarzC+ZBGY2AfyiVFzjX8=;
        b=RivIQyflKbi3hH1bgSl5S3UoDUuMD7mkTvBjYGTs+zEUFb3k60U+AeE6TJcU1Y19aF3CVu
        0aytNNOeDdxo60coQFoVryyR7zGyeT8yl/SlRba7PybDgCHN6QZC29J/YcVVh9TAbnWcVc
        GOW2s784IdCopmqQLHRNnAqz7XEyBUY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-263-vMCWz1n0OkGl2bM0e4eECw-1; Thu, 24 Sep 2020 04:28:35 -0400
X-MC-Unique: vMCWz1n0OkGl2bM0e4eECw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F3CAE800462;
        Thu, 24 Sep 2020 08:28:33 +0000 (UTC)
Received: from [10.72.13.193] (ovpn-13-193.pek2.redhat.com [10.72.13.193])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9AC0C5D993;
        Thu, 24 Sep 2020 08:28:19 +0000 (UTC)
Subject: Re: [RFC PATCH 01/24] vhost-vdpa: fix backend feature ioctls
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     lulu@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rob.miller@broadcom.com,
        lingshan.zhu@intel.com, eperezma@redhat.com, hanand@xilinx.com,
        mhabets@solarflare.com, eli@mellanox.com, amorenoz@redhat.com,
        maxime.coquelin@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, Eli Cohen <elic@nvidia.com>
References: <20200924032125.18619-1-jasowang@redhat.com>
 <20200924032125.18619-2-jasowang@redhat.com>
 <20200924034940-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <bebb65cd-732f-58b5-56f0-55ce61cde61f@redhat.com>
Date:   Thu, 24 Sep 2020 16:28:17 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200924034940-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/9/24 下午3:50, Michael S. Tsirkin wrote:
> On Thu, Sep 24, 2020 at 11:21:02AM +0800, Jason Wang wrote:
>> Commit 653055b9acd4 ("vhost-vdpa: support get/set backend features")
>> introduces two malfunction backend features ioctls:
>>
>> 1) the ioctls was blindly added to vring ioctl instead of vdpa device
>>     ioctl
>> 2) vhost_set_backend_features() was called when dev mutex has already
>>     been held which will lead a deadlock
>>
>> This patch fixes the above issues.
>>
>> Cc: Eli Cohen<elic@nvidia.com>
>> Reported-by: Zhu Lingshan<lingshan.zhu@intel.com>
>> Fixes: 653055b9acd4 ("vhost-vdpa: support get/set backend features")
>> Signed-off-by: Jason Wang<jasowang@redhat.com>
> Don't we want the fixes queued right now, as opposed to the rest of the
> RFC?


Yes, actually I've posted in before[1].

Adding the patch here is to simplify the work for the guys that want to 
do the work on top. E.g for Cindy to start the Qemu prototype.

Thanks

[1] https://www.spinics.net/lists/netdev/msg681247.html


