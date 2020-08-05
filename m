Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6F7623C35E
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 04:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbgHECUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 22:20:25 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:48535 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726799AbgHECUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 22:20:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596594024;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7DEBvkJfYvveJIW7r94EMN46Ocq9FH45hJA53lH0CMg=;
        b=Wq/GjArxvnSwNTTQ09l/pYZYdITIud8v7UldM7W99O2VSNb3GRpnV03L2S1tL0sdn29Dn9
        7uJwCfGgZoQBnsUZZ+edlqivnuQ3s/cINDsMqopvqEGqTC1aHBtegaihEWVlwkRdAGbMxP
        TMXF/E0MMkpkcdPAferRiIiwPdDh3D8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-282-A-C2bDaEN02PvsNUr52Dhw-1; Tue, 04 Aug 2020 22:20:22 -0400
X-MC-Unique: A-C2bDaEN02PvsNUr52Dhw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E78B1800469;
        Wed,  5 Aug 2020 02:20:20 +0000 (UTC)
Received: from [10.72.13.71] (ovpn-13-71.pek2.redhat.com [10.72.13.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B5FB96931B;
        Wed,  5 Aug 2020 02:20:09 +0000 (UTC)
Subject: Re: [PATCH V5 1/6] vhost: introduce vhost_vring_call
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        alex.williamson@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, eli@mellanox.com, shahafs@mellanox.com,
        parav@mellanox.com
References: <20200731065533.4144-1-lingshan.zhu@intel.com>
 <20200731065533.4144-2-lingshan.zhu@intel.com>
 <5e646141-ca8d-77a5-6f41-d30710d91e6d@redhat.com>
 <d51dd4e3-7513-c771-104c-b61f9ee70f30@intel.com>
 <156b8d71-6870-c163-fdfa-35bf4701987d@redhat.com>
 <4605de34-c426-33d4-714b-e03716d0374c@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <0bae5f7e-0f75-8fb9-37a9-68235862b5fe@redhat.com>
Date:   Wed, 5 Aug 2020 10:20:08 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <4605de34-c426-33d4-714b-e03716d0374c@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/8/4 下午5:21, Zhu, Lingshan wrote:
>>> Hi Jason,
>>>
>>> we use this lock to protect the eventfd_ctx and irq from race 
>>> conditions,
>>
>>
>> We don't support irq notification from vDPA device driver in this 
>> version, do we still have race condition?
> as we discussed before:
> (1)if vendor change IRQ after DRIVER_OK, through they should not do this, but they can.
> (2)if user space changes ctx.
>
> Thanks


Yes, but then everything happens in context of syscall (ioctl), so vq 
mutex is sufficient I guess?

Thanks

