Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 735AD2B7A86
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 10:42:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726929AbgKRJkD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 04:40:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:32751 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725964AbgKRJkD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 04:40:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605692402;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8YUHjCb6T+duwkVVqtutOFcmHYQOlclmLV2nizfmVHg=;
        b=HiRVW2xjpKa/i9erD3sDc184C+ca06hvsYxY3j6UIPh/URFmbJa/VRs0pnT5bAQON3B87g
        hisHCgUD/tkZzFSQmoSIVP1hBg4TeAwgodWhsImfdjGD+FHKzrPiUWmDTJoXbo+MGnfiYN
        yRZF5Mvtz75c5XIlIneqmQSm4BBg/EE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-462-eJe0u6hPPU2DjFdLdYSYRg-1; Wed, 18 Nov 2020 04:40:00 -0500
X-MC-Unique: eJe0u6hPPU2DjFdLdYSYRg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C2459100855E;
        Wed, 18 Nov 2020 09:39:58 +0000 (UTC)
Received: from [10.72.12.138] (ovpn-12-138.pek2.redhat.com [10.72.12.138])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D14E655762;
        Wed, 18 Nov 2020 09:39:52 +0000 (UTC)
Subject: Re: [PATCH net] vhost_vdpa: Return -EFUALT if copy_from_user() fails
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, kuba@kernel.org
References: <20201023120853.GI282278@mwanda>
 <20201023113326-mutt-send-email-mst@kernel.org>
 <4485cc8d-ac69-c725-8493-eda120e29c41@redhat.com>
 <e7242333-b364-c2d8-53f5-1f688fc4d0b5@redhat.com>
 <20201118035912-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <4ac146a2-a3db-abc7-73a0-98f71119de3d@redhat.com>
Date:   Wed, 18 Nov 2020 17:39:51 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201118035912-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/11/18 下午4:59, Michael S. Tsirkin wrote:
> On Wed, Nov 18, 2020 at 02:08:17PM +0800, Jason Wang wrote:
>> On 2020/10/26 上午10:59, Jason Wang wrote:
>>> On 2020/10/23 下午11:34, Michael S. Tsirkin wrote:
>>>> On Fri, Oct 23, 2020 at 03:08:53PM +0300, Dan Carpenter wrote:
>>>>> The copy_to/from_user() functions return the number of bytes which we
>>>>> weren't able to copy but the ioctl should return -EFAULT if they fail.
>>>>>
>>>>> Fixes: a127c5bbb6a8 ("vhost-vdpa: fix backend feature ioctls")
>>>>> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>>>> Acked-by: Michael S. Tsirkin <mst@redhat.com>
>>>> Needed for stable I guess.
>>>
>>> Agree.
>>>
>>> Acked-by: Jason Wang <jasowang@redhat.com>
>>
>> Hi Michael.
>>
>> I don't see this in your tree, please consider to merge.
>>
>> Thanks
>>
> I do see it there:
>
> commit 7922460e33c81f41e0d2421417228b32e6fdbe94
> Author: Dan Carpenter <dan.carpenter@oracle.com>
> Date:   Fri Oct 23 15:08:53 2020 +0300
>
>      vhost_vdpa: Return -EFAULT if copy_from_user() fails
>      
> the reason you can't find it is probably because I fixed up
> a typo in the subject.


I see that.

Thanks


>
>

