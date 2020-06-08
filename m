Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22AD41F1662
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 12:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729363AbgFHKIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 06:08:05 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41647 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729345AbgFHKIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 06:08:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591610883;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J8KdBsIeUG7CqXgAwlXgq2ronkJRHUa9z02ZSl84hDE=;
        b=H3NGIDBPoAQe+Aa4VT1C4SgYx3BZfIuT/2hRfb+Ihu8kQRt7U5UODbrQsZgTI58n4TXeyX
        EhYYWpx3EQ8Q+gkYydPc/PtjFnyopvoZjbb/ePVC6r8I2pKSA00NV4/e6q6QiP3OEEI6pP
        DTP05RvkryoTUNt0nhi1VP3+g9Ycdhc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-165-RuHe18uhO4ac4yGJwcfsCw-1; Mon, 08 Jun 2020 06:07:58 -0400
X-MC-Unique: RuHe18uhO4ac4yGJwcfsCw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C584D8018AD;
        Mon,  8 Jun 2020 10:07:56 +0000 (UTC)
Received: from [10.72.13.71] (ovpn-13-71.pek2.redhat.com [10.72.13.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C69136FF1B;
        Mon,  8 Jun 2020 10:07:40 +0000 (UTC)
Subject: Re: [PATCH 5/6] vdpa: introduce virtio pci driver
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        rob.miller@broadcom.com, lingshan.zhu@intel.com,
        eperezma@redhat.com, lulu@redhat.com, shahafs@mellanox.com,
        hanand@xilinx.com, mhabets@solarflare.com, gdawar@xilinx.com,
        saugatm@xilinx.com, vmireyno@marvell.com,
        zhangweining@ruijie.com.cn, eli@mellanox.com
References: <5dbb0386-beeb-5bf4-d12e-fb5427486bb8@redhat.com>
 <6b1d1ef3-d65e-08c2-5b65-32969bb5ecbc@redhat.com>
 <20200607095012-mutt-send-email-mst@kernel.org>
 <9b1abd2b-232c-aa0f-d8bb-03e65fd47de2@redhat.com>
 <20200608021438-mutt-send-email-mst@kernel.org>
 <a1b1b7fb-b097-17b7-2e3a-0da07d2e48ae@redhat.com>
 <20200608052041-mutt-send-email-mst@kernel.org>
 <9d2571b6-0b95-53b3-6989-b4d801eeb623@redhat.com>
 <20200608054453-mutt-send-email-mst@kernel.org>
 <bc27064c-2309-acf3-ccd8-6182bfa2a4cd@redhat.com>
 <20200608055331-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <61117e6a-2568-d0f4-8713-d831af32814d@redhat.com>
Date:   Mon, 8 Jun 2020 18:07:36 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200608055331-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/6/8 下午5:54, Michael S. Tsirkin wrote:
> On Mon, Jun 08, 2020 at 05:46:52PM +0800, Jason Wang wrote:
>> On 2020/6/8 下午5:45, Michael S. Tsirkin wrote:
>>> On Mon, Jun 08, 2020 at 05:43:58PM +0800, Jason Wang wrote:
>>>>>> Looking at
>>>>>> pci_match_one_device() it checks both subvendor and subdevice there.
>>>>>>
>>>>>> Thanks
>>>>> But IIUC there is no guarantee that driver with a specific subvendor
>>>>> matches in presence of a generic one.
>>>>> So either IFC or virtio pci can win, whichever binds first.
>>>> I'm not sure I get there. But I try manually bind IFCVF to qemu's
>>>> virtio-net-pci, and it fails.
>>>>
>>>> Thanks
>>> Right but the reverse can happen: virtio-net can bind to IFCVF first.
>>
>> That's kind of expected. The PF is expected to be bound to virtio-pci to
>> create VF via sysfs.
>>
>> Thanks
>>
>>
>>
> Once VFs are created, don't we want IFCVF to bind rather than
> virtio-pci?


Yes, but for PF we need virtio-pci.

Thanks


>

