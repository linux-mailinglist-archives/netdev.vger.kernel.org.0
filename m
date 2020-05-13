Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 432221D09C3
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 09:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730139AbgEMHSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 03:18:33 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:49092 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726020AbgEMHSd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 03:18:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589354312;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PsFr5VgA/I8bgRAUPFXVC7Lw5/2KGXHzA0YOGHShMaY=;
        b=GrFLnPD005al6QGruQ3xrAlLXvsQduBXbFWa6l6dE7XNN6hS6fHMd/+cWLLR/mW3yZ6MX2
        CnEG6VCkSp0e+hCysfw3oV1G4s5ZWdKuRXED8ggJm4l9ho56+OyZ5zf/mfzcoPjNpXiFEw
        2QpYUg9uWRFzQ1/pDw1+urEh+XVF/lM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-8-83QqhuSGMea6fVHJPVVfYg-1; Wed, 13 May 2020 03:18:30 -0400
X-MC-Unique: 83QqhuSGMea6fVHJPVVfYg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0AEDD8014D5;
        Wed, 13 May 2020 07:18:29 +0000 (UTC)
Received: from [10.72.12.209] (ovpn-12-209.pek2.redhat.com [10.72.12.209])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C4E546E6E0;
        Wed, 13 May 2020 07:18:22 +0000 (UTC)
Subject: Re: [PATCH V2] ifcvf: move IRQ request/free to status change handlers
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>, mst@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     lulu@redhat.com, dan.daly@intel.com, cunming.liang@intel.com
References: <1589270444-3669-1-git-send-email-lingshan.zhu@intel.com>
 <8aca85c3-3bf6-a1ec-7009-cd9a635647d7@redhat.com>
 <5bbe0c21-8638-45e4-04e8-02ad0df44b38@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <572ed6af-7a04-730e-c803-a41868091e88@redhat.com>
Date:   Wed, 13 May 2020 15:18:21 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <5bbe0c21-8638-45e4-04e8-02ad0df44b38@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/5/13 下午12:42, Zhu, Lingshan wrote:
>
>
> On 5/13/2020 12:12 PM, Jason Wang wrote:
>>
>> On 2020/5/12 下午4:00, Zhu Lingshan wrote:
>>> This commit move IRQ request and free operations from probe()
>>> to VIRTIO status change handler to comply with VIRTIO spec.
>>>
>>> VIRTIO spec 1.1, section 2.1.2 Device Requirements: Device Status Field
>>> The device MUST NOT consume buffers or send any used buffer
>>> notifications to the driver before DRIVER_OK.
>>
>>
>> This comment needs to be checked as I said previously. It's only 
>> needed if we're sure ifcvf can generate interrupt before DRIVER_OK.
>>
>>
>>>
>>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>>> ---
>>> changes from V1:
>>> remove ifcvf_stop_datapath() in status == 0 handler, we don't need 
>>> to do this
>>> twice; handle status == 0 after DRIVER_OK -> !DRIVER_OK handler 
>>> (Jason Wang)
>>
>>
>> Patch looks good to me, but with this patch ping cannot work on my 
>> machine. (It works without this patch).
>>
>> Thanks
> This is strange, it works on my machines, let's have a check offline.
>
> Thanks,
> BR
> Zhu Lingshan


I give it a try with virito-vpda and a tiny userspace. Either works.

So it could be an issue of qemu codes.

Let's wait for Cindy to test if it really works.

Thanks


