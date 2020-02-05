Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DEB7152521
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 04:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbgBEDL2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 22:11:28 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:38734 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727816AbgBEDL2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 22:11:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580872287;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=om97GEVSncDJoKUqo0m8J3j6AU1bMxcse0uk6TffhCM=;
        b=A5AkKv7GLFnT2eXTnbIR4CjiAIySxEQNACkZJ/nMdcUwj7tgBOchdNtR5PzZJ+4XmEe6jO
        6irU9cFJbtEr/eC68W0tRVqoECeb1DRENHis63dBMhRVay19rfDqQfTg706YJpWBXrUV4H
        +H5I9/JURytqbg/Cd+ndctjqecGitiM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-328-LmJy843xOnG34ARnkUMuyQ-1; Tue, 04 Feb 2020 22:11:25 -0500
X-MC-Unique: LmJy843xOnG34ARnkUMuyQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5499618AB2C0;
        Wed,  5 Feb 2020 03:11:23 +0000 (UTC)
Received: from [10.72.13.188] (ovpn-13-188.pek2.redhat.com [10.72.13.188])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5734C87B12;
        Wed,  5 Feb 2020 03:11:10 +0000 (UTC)
Subject: Re: [PATCH] vhost: introduce vDPA based backend
To:     Tiwei Bie <tiwei.bie@intel.com>
Cc:     mst@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        shahafs@mellanox.com, jgg@mellanox.com, rob.miller@broadcom.com,
        haotian.wang@sifive.com, eperezma@redhat.com, lulu@redhat.com,
        parav@mellanox.com, rdunlap@infradead.org, hch@infradead.org,
        jiri@mellanox.com, hanand@xilinx.com, mhabets@solarflare.com,
        maxime.coquelin@redhat.com, lingshan.zhu@intel.com,
        dan.daly@intel.com, cunming.liang@intel.com, zhihong.wang@intel.com
References: <20200131033651.103534-1-tiwei.bie@intel.com>
 <7aab2892-bb19-a06a-a6d3-9c28bc4c3400@redhat.com>
 <20200205020247.GA368700@___>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <ad1707a0-7884-1329-52c6-8139230a930c@redhat.com>
Date:   Wed, 5 Feb 2020 11:11:08 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200205020247.GA368700@___>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/2/5 =E4=B8=8A=E5=8D=8810:02, Tiwei Bie wrote:
>> Before trying to do this it looks to me we need the following during t=
he
>> probe
>>
>> 1) if set_map() is not supported by the vDPA device probe the IOMMU th=
at is
>> supported by the vDPA device
>> 2) allocate IOMMU domain
>>
>> And then:
>>
>> 3) pin pages through GUP and do proper accounting
>> 4) store GPA->HPA mapping in the umem
>> 5) generate diffs of memory table and using IOMMU API to setup the dma
>> mapping in this method
>>
>> For 1), I'm not sure parent is sufficient for to doing this or need to
>> introduce new API like iommu_device in mdev.
> Agree. We may also need to introduce something like
> the iommu_device.
>

Right, this is what I plan to do in next version.

Thanks

