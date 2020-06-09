Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFB4D1F33AE
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 07:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727842AbgFIFzl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 01:55:41 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:50755 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726120AbgFIFzh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 01:55:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591682136;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=08pzgeVHE6/leOw9rkcb4hjTCcujAlE6G/nlp9Vnewk=;
        b=ZjmjesdtpC0JBQ1vh94sOhi+QhAo+UiQX9Q5bhEZLpzaPJFGPQm2x+IDJynbGEsDyEhtEN
        ukpQcii3AcOR+DfxJ8jQ24TpONsh6YAcFeEgT/gwPNjlhJYtM0XN2vybYtSFIA5OFL808a
        DNPRCJzVY9cEAFSCAmGFapG/96ERIo4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-419-UVqavzv0Or2l_IiTMItEdA-1; Tue, 09 Jun 2020 01:55:32 -0400
X-MC-Unique: UVqavzv0Or2l_IiTMItEdA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 40FB81009440;
        Tue,  9 Jun 2020 05:55:30 +0000 (UTC)
Received: from [10.72.12.252] (ovpn-12-252.pek2.redhat.com [10.72.12.252])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B55F160BF3;
        Tue,  9 Jun 2020 05:55:18 +0000 (UTC)
Subject: Re: [PATCH 5/6] vdpa: introduce virtio pci driver
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        rob.miller@broadcom.com, lingshan.zhu@intel.com,
        eperezma@redhat.com, lulu@redhat.com, shahafs@mellanox.com,
        hanand@xilinx.com, mhabets@solarflare.com, gdawar@xilinx.com,
        saugatm@xilinx.com, vmireyno@marvell.com,
        zhangweining@ruijie.com.cn, eli@mellanox.com
References: <20200607095012-mutt-send-email-mst@kernel.org>
 <9b1abd2b-232c-aa0f-d8bb-03e65fd47de2@redhat.com>
 <20200608021438-mutt-send-email-mst@kernel.org>
 <a1b1b7fb-b097-17b7-2e3a-0da07d2e48ae@redhat.com>
 <20200608052041-mutt-send-email-mst@kernel.org>
 <9d2571b6-0b95-53b3-6989-b4d801eeb623@redhat.com>
 <20200608054453-mutt-send-email-mst@kernel.org>
 <bc27064c-2309-acf3-ccd8-6182bfa2a4cd@redhat.com>
 <20200608055331-mutt-send-email-mst@kernel.org>
 <61117e6a-2568-d0f4-8713-d831af32814d@redhat.com>
 <20200608092530-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <a01aced5-2357-b55c-296b-f152008ddbf2@redhat.com>
Date:   Tue, 9 Jun 2020 13:55:14 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200608092530-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/6/8 下午9:29, Michael S. Tsirkin wrote:
> On Mon, Jun 08, 2020 at 06:07:36PM +0800, Jason Wang wrote:
>> On 2020/6/8 下午5:54, Michael S. Tsirkin wrote:
>>> On Mon, Jun 08, 2020 at 05:46:52PM +0800, Jason Wang wrote:
>>>> On 2020/6/8 下午5:45, Michael S. Tsirkin wrote:
>>>>> On Mon, Jun 08, 2020 at 05:43:58PM +0800, Jason Wang wrote:
>>>>>>>> Looking at
>>>>>>>> pci_match_one_device() it checks both subvendor and subdevice there.
>>>>>>>>
>>>>>>>> Thanks
>>>>>>> But IIUC there is no guarantee that driver with a specific subvendor
>>>>>>> matches in presence of a generic one.
>>>>>>> So either IFC or virtio pci can win, whichever binds first.
>>>>>> I'm not sure I get there. But I try manually bind IFCVF to qemu's
>>>>>> virtio-net-pci, and it fails.
>>>>>>
>>>>>> Thanks
>>>>> Right but the reverse can happen: virtio-net can bind to IFCVF first.
>>>> That's kind of expected. The PF is expected to be bound to virtio-pci to
>>>> create VF via sysfs.
>>>>
>>>> Thanks
>>>>
>>>>
>>>>
>>> Once VFs are created, don't we want IFCVF to bind rather than
>>> virtio-pci?
>>
>> Yes, but for PF we need virtio-pci.
>>
>> Thanks
>>
> (Ab)using the driver_data field for this is an option.
> What do you think?


Maybe you can elaborate more on this idea?

Thanks


>

