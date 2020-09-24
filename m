Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC6F5276AC1
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 09:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbgIXH0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 03:26:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31921 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726993AbgIXH03 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 03:26:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600932388;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K3pWzi6XBSxvJ/VWL3fyEt5ORCYjFGoEK4Nlb2X8zSM=;
        b=VLnnEKPDupyXUk1qvUQmVTa1qNw6SyhYZTfJYNcvG0uQdJ5rKul+aHMTwMorN9t8fgzHP4
        6WldMnAASIThjln4lhcYbbo7++63mvbjlNB1X4IM0TQWNaRIruZSb0AzJHdCVRTk4tLG2i
        2AWEMrO0kEiEFYZzsZaTIToeZ8bRNuE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-57-KhdlLsU5M-qlpT4HD7pE3w-1; Thu, 24 Sep 2020 03:26:26 -0400
X-MC-Unique: KhdlLsU5M-qlpT4HD7pE3w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DC2AD186DD33;
        Thu, 24 Sep 2020 07:26:24 +0000 (UTC)
Received: from [10.72.13.193] (ovpn-13-193.pek2.redhat.com [10.72.13.193])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CD64A60C15;
        Thu, 24 Sep 2020 07:26:10 +0000 (UTC)
Subject: Re: [RFC PATCH 01/24] vhost-vdpa: fix backend feature ioctls
To:     Eli Cohen <elic@nvidia.com>
Cc:     mst@redhat.com, lulu@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rob.miller@broadcom.com,
        lingshan.zhu@intel.com, eperezma@redhat.com, hanand@xilinx.com,
        mhabets@solarflare.com, eli@mellanox.com, amorenoz@redhat.com,
        maxime.coquelin@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com
References: <20200924032125.18619-1-jasowang@redhat.com>
 <20200924032125.18619-2-jasowang@redhat.com>
 <20200924071609.GA170403@mtl-vdi-166.wap.labs.mlnx>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <042dc3f9-40f0-f740-7ffc-611d315bc150@redhat.com>
Date:   Thu, 24 Sep 2020 15:26:08 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200924071609.GA170403@mtl-vdi-166.wap.labs.mlnx>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/9/24 下午3:16, Eli Cohen wrote:
> On Thu, Sep 24, 2020 at 11:21:02AM +0800, Jason Wang wrote:
>> Commit 653055b9acd4 ("vhost-vdpa: support get/set backend features")
>> introduces two malfunction backend features ioctls:
>>
>> 1) the ioctls was blindly added to vring ioctl instead of vdpa device
>>     ioctl
>> 2) vhost_set_backend_features() was called when dev mutex has already
>>     been held which will lead a deadlock
>>
> I assume this patch requires some patch in qemu as well. Do you have
> such patch?
>

It's this series: [PATCH 0/3] Vhost-vDPA: batch IOTLB updating.

You were copied.

Thanks

