Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3C341D06C5
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 07:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729339AbgEMF5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 01:57:44 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:44446 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729171AbgEMF5e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 01:57:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589349453;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oS9s06FImqWmW3Ha3Sx3lNv173yHCer4HwNEWY7z8Lw=;
        b=A65PPSpXo6wkymPTMbSzVCOjkTAScE3Kn/2REO4bEmbMLEGQrDgTJve5g8wavyIAveswuH
        1W04B/NDyavO76cPeGkzmnJf/AWb3HyEDK78eW/z/N34fmx5W0SIcSLyXp3CFaRjtY25F/
        bQgmj3tybBafmhCypbMAxxJrzjxhQYc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304-pMwZ543xOua3WL8Aq33VRw-1; Wed, 13 May 2020 01:57:29 -0400
X-MC-Unique: pMwZ543xOua3WL8Aq33VRw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 90DC21841931;
        Wed, 13 May 2020 05:57:28 +0000 (UTC)
Received: from [10.72.13.188] (ovpn-13-188.pek2.redhat.com [10.72.13.188])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E36F05D9E8;
        Wed, 13 May 2020 05:57:20 +0000 (UTC)
Subject: Re: [PATCH V2] ifcvf: move IRQ request/free to status change handlers
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>, mst@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     lulu@redhat.com, dan.daly@intel.com, cunming.liang@intel.com
References: <1589270444-3669-1-git-send-email-lingshan.zhu@intel.com>
 <8aca85c3-3bf6-a1ec-7009-cd9a635647d7@redhat.com>
 <5bbe0c21-8638-45e4-04e8-02ad0df44b38@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <f7485579-834f-1770-1622-e6df1b2f3e81@redhat.com>
Date:   Wed, 13 May 2020 13:57:19 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <5bbe0c21-8638-45e4-04e8-02ad0df44b38@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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


Note that I tested the patch with vhost-vpda.

Thanks.

