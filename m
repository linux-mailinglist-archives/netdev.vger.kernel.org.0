Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74C092E3535
	for <lists+netdev@lfdr.de>; Mon, 28 Dec 2020 09:45:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbgL1IpL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 03:45:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42079 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726282AbgL1IpL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Dec 2020 03:45:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609145024;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b/mQcN8HBMjEvpA5cui1zWJDGM1GYmpavHlrRlsXqE4=;
        b=BHjOHyXqPdygAdIgXCxlEtCC4AfmlPs2v4wJqaDYdJJ/mAo0fyRDeaDFk2m5jBnHpaycWk
        L3UZtQg4BfxWTMWakupEPKpJ/LLniAhiRYMC+18wyRHCJ61MBEMf77OJnENHqBzY29EF3c
        pOpWKaHdmm1PfeeyjniWES9vXcSf/Eg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-517-fgpg1Q3MMjmXbi0k5uLn9w-1; Mon, 28 Dec 2020 03:43:40 -0500
X-MC-Unique: fgpg1Q3MMjmXbi0k5uLn9w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D532A800D53;
        Mon, 28 Dec 2020 08:43:37 +0000 (UTC)
Received: from [10.72.13.159] (ovpn-13-159.pek2.redhat.com [10.72.13.159])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AEDAC704DA;
        Mon, 28 Dec 2020 08:43:19 +0000 (UTC)
Subject: Re: [RFC v2 09/13] vduse: Add support for processing vhost iotlb
 message
To:     Yongji Xie <xieyongji@bytedance.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, sgarzare@redhat.com,
        Parav Pandit <parav@nvidia.com>, akpm@linux-foundation.org,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        axboe@kernel.dk, bcrl@kvack.org, corbet@lwn.net,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <20201222145221.711-1-xieyongji@bytedance.com>
 <20201222145221.711-10-xieyongji@bytedance.com>
 <6818a214-d587-4f0b-7de6-13c4e7e94ab6@redhat.com>
 <CACycT3vVU9vg6R6UujSnSdk8cwxWPVgeJJs0JaBH_Zg4xC-epQ@mail.gmail.com>
 <595fe7d6-7876-26e4-0b7c-1d63ca6d7a97@redhat.com>
 <CACycT3s=m=PQb5WFoMGhz8TNGme4+=rmbbBTtrugF9ZmNnWxEw@mail.gmail.com>
 <0e6faf9c-117a-e23c-8d6d-488d0ec37412@redhat.com>
 <CACycT3uwXBYvRbKDWdN3oCekv+o6_Lc=-KTrxejD=fr-zgibGw@mail.gmail.com>
 <2b24398c-e6d9-14ec-2c0d-c303d528e377@redhat.com>
 <CACycT3uDV43ecScrMh1QVpStuwDETHykJzzY=pkmZjP2Dd2kvg@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <e77c97c5-6bdc-cdd0-62c0-6ff75f6dbdff@redhat.com>
Date:   Mon, 28 Dec 2020 16:43:18 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CACycT3uDV43ecScrMh1QVpStuwDETHykJzzY=pkmZjP2Dd2kvg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/12/28 下午4:14, Yongji Xie wrote:
>> I see. So all the above two questions are because VHOST_IOTLB_INVALIDATE
>> is expected to be synchronous. This need to be solved by tweaking the
>> current VDUSE API or we can re-visit to go with descriptors relaying first.
>>
> Actually all vdpa related operations are synchronous in current
> implementation. The ops.set_map/dma_map/dma_unmap should not return
> until the VDUSE_UPDATE_IOTLB/VDUSE_INVALIDATE_IOTLB message is replied
> by userspace. Could it solve this problem?


  I was thinking whether or not we need to generate IOTLB_INVALIDATE 
message to VDUSE during dma_unmap (vduse_dev_unmap_page).

If we don't, we're probably fine.

Thanks


>
> Thanks,
> Yongji
>

