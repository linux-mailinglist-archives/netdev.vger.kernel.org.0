Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA11C2785D5
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 13:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728322AbgIYL3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 07:29:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47017 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727838AbgIYL3f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 07:29:35 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601033373;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3NXvmRl1RoHr3cxBopNVva2P77kIGOs8tMv65YwxLi0=;
        b=h109z7aCGiczl+ZBiY0KVNFucxsfk0lcC+YWIP9YU+19Id+ETphJmGqeBNhQuPG2D9jAo5
        5P8Pc/B3/nBlYIfLr94+AX5V03f9LJp9CB5Jtj8lSAoOJI2u2Tar134jCL7qn7XEwfvHN8
        H5iBrj1LzdlpYAHmxrmbOU/5x9d6Vz0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-192-1ex2OmjHNEeCj0OvC-clLQ-1; Fri, 25 Sep 2020 07:29:29 -0400
X-MC-Unique: 1ex2OmjHNEeCj0OvC-clLQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 866C564149;
        Fri, 25 Sep 2020 11:29:28 +0000 (UTC)
Received: from [10.72.12.44] (ovpn-12-44.pek2.redhat.com [10.72.12.44])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BE17A5D9F3;
        Fri, 25 Sep 2020 11:29:25 +0000 (UTC)
Subject: Re: [PATCH v3 -next] vdpa: mlx5: change Kconfig depends to fix build
 errors
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>
Cc:     Randy Dunlap <rdunlap@infradead.org>, Eli Cohen <elic@nvidia.com>,
        virtualization@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
References: <73f7e48b-8d16-6b20-07d3-41dee0e3d3bd@infradead.org>
 <20200918082245.GP869610@unreal>
 <20200924052932-mutt-send-email-mst@kernel.org>
 <20200924102413.GD170403@mtl-vdi-166.wap.labs.mlnx>
 <079c831e-214d-22c1-028e-05d84e3b7f04@infradead.org>
 <20200924120217-mutt-send-email-mst@kernel.org>
 <20200925072005.GB2280698@unreal>
 <20200925061847-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <821c501c-53ce-3e80-8a73-f0680193df20@redhat.com>
Date:   Fri, 25 Sep 2020 19:29:24 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200925061847-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/9/25 下午6:19, Michael S. Tsirkin wrote:
> On Fri, Sep 25, 2020 at 10:20:05AM +0300, Leon Romanovsky wrote:
>> On Thu, Sep 24, 2020 at 12:02:43PM -0400, Michael S. Tsirkin wrote:
>>> On Thu, Sep 24, 2020 at 08:47:05AM -0700, Randy Dunlap wrote:
>>>> On 9/24/20 3:24 AM, Eli Cohen wrote:
>>>>> On Thu, Sep 24, 2020 at 05:30:55AM -0400, Michael S. Tsirkin wrote:
>>>>>>>> --- linux-next-20200917.orig/drivers/vdpa/Kconfig
>>>>>>>> +++ linux-next-20200917/drivers/vdpa/Kconfig
>>>>>>>> @@ -31,7 +31,7 @@ config IFCVF
>>>>>>>>
>>>>>>>>   config MLX5_VDPA
>>>>>>>>   	bool "MLX5 VDPA support library for ConnectX devices"
>>>>>>>> -	depends on MLX5_CORE
>>>>>>>> +	depends on VHOST_IOTLB && MLX5_CORE
>>>>>>>>   	default n
>>>>>>> While we are here, can anyone who apply this patch delete the "default n" line?
>>>>>>> It is by default "n".
>>>>> I can do that
>>>>>
>>>>>>> Thanks
>>>>>> Hmm other drivers select VHOST_IOTLB, why not do the same?
>>>> v1 used select, but Saeed requested use of depends instead because
>>>> select can cause problems.
>>>>
>>>>> I can't see another driver doing that. Perhaps I can set dependency on
>>>>> VHOST which by itself depends on VHOST_IOTLB?
>>>>>>
>>>>>>>>   	help
>>>>>>>>   	  Support library for Mellanox VDPA drivers. Provides code that is
>>>>>>>>
>>> Saeed what kind of problems? It's used with select in other places,
>>> isn't it?
>> IMHO, "depends" is much more explicit than "select".
>>
>> Thanks
> This is now how VHOST_IOTLB has been designed though.
> If you want to change VHOST_IOTLB to depends I think
> we should do it consistently all over.
>
>
> config VHOST_IOTLB
>          tristate
>          help
>            Generic IOTLB implementation for vhost and vringh.
>            This option is selected by any driver which needs to support
>            an IOMMU in software.


Yes, since there's no prompt for VHOST_IOTLB which means, if there's no 
other symbol that select VHOST_IOTLB, you can't enable MLX5 at all.

See kconfig-language.rst:


     In general use select only for non-visible symbols
     (no prompts anywhere) and for symbols with no dependencies.
     That will limit the usefulness but on the other hand avoid
     the illegal configurations all over.

Thanks


>
>
>>>> --
>>>> ~Randy

