Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA151F11B7
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 05:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728908AbgFHDc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jun 2020 23:32:56 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23141 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728065AbgFHDcy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jun 2020 23:32:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591587173;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QTHYGJT484CysjTvnzyVCM1DqyJ9Sy2/Nw9/zbDo/eE=;
        b=fIwBY0ihNwvLLs3Ha9arEs/upv/M7J0ETGfbtc7rRadXVNH8aOfJB+R0UnGMhTS2S59GMv
        8HBMcbkGNDt6foVsOIX/LvrMDCcqAX15jzCeLAMpLd/gmm2iNbQVQzwSzDvuCNrfKwTUTM
        4H4yrj1yV+qWUVMWUnppl/K8dTKzxuM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-62-gw20i6ilPV-_ApCgzBqQgw-1; Sun, 07 Jun 2020 23:32:49 -0400
X-MC-Unique: gw20i6ilPV-_ApCgzBqQgw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 23B8E100CCC0;
        Mon,  8 Jun 2020 03:32:47 +0000 (UTC)
Received: from [10.72.13.71] (ovpn-13-71.pek2.redhat.com [10.72.13.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C8F111A933;
        Mon,  8 Jun 2020 03:32:37 +0000 (UTC)
Subject: Re: [PATCH 5/6] vdpa: introduce virtio pci driver
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        rob.miller@broadcom.com, lingshan.zhu@intel.com,
        eperezma@redhat.com, lulu@redhat.com, shahafs@mellanox.com,
        hanand@xilinx.com, mhabets@solarflare.com, gdawar@xilinx.com,
        saugatm@xilinx.com, vmireyno@marvell.com,
        zhangweining@ruijie.com.cn, eli@mellanox.com
References: <20200529080303.15449-1-jasowang@redhat.com>
 <20200529080303.15449-6-jasowang@redhat.com>
 <20200602010332-mutt-send-email-mst@kernel.org>
 <5dbb0386-beeb-5bf4-d12e-fb5427486bb8@redhat.com>
 <6b1d1ef3-d65e-08c2-5b65-32969bb5ecbc@redhat.com>
 <20200607095012-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <9b1abd2b-232c-aa0f-d8bb-03e65fd47de2@redhat.com>
Date:   Mon, 8 Jun 2020 11:32:31 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200607095012-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/6/7 下午9:51, Michael S. Tsirkin wrote:
> On Fri, Jun 05, 2020 at 04:54:17PM +0800, Jason Wang wrote:
>> On 2020/6/2 下午3:08, Jason Wang wrote:
>>>>> +static const struct pci_device_id vp_vdpa_id_table[] = {
>>>>> +    { PCI_DEVICE(PCI_VENDOR_ID_REDHAT_QUMRANET, PCI_ANY_ID) },
>>>>> +    { 0 }
>>>>> +};
>>>> This looks like it'll create a mess with either virtio pci
>>>> or vdpa being loaded at random. Maybe just don't specify
>>>> any IDs for now. Down the road we could get a
>>>> distinct vendor ID or a range of device IDs for this.
>>>
>>> Right, will do.
>>>
>>> Thanks
>>
>> Rethink about this. If we don't specify any ID, the binding won't work.
> We can bind manually. It's not really for production anyway, so
> not a big deal imho.


I think you mean doing it via "new_id", right.


>
>> How about using a dedicated subsystem vendor id for this?
>>
>> Thanks
> If virtio vendor id is used then standard driver is expected
> to bind, right? Maybe use a dedicated vendor id?


I meant something like:

static const struct pci_device_id vp_vdpa_id_table[] = {
     { PCI_DEVICE_SUB(PCI_VENDOR_ID_REDHAT_QUMRANET, PCI_ANY_ID, 
VP_TEST_VENDOR_ID, VP_TEST_DEVICE_ID) },
     { 0 }
};

Thanks


