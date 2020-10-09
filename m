Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 333832880F2
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 06:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731053AbgJID76 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 23:59:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35326 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727781AbgJID7y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 23:59:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602215993;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CeARdKdxXITMJyQg5RZv73lx5offC2uV5GIuBo7fxJ0=;
        b=R/JyMCpHNsJRJ3dyVsAO7ndV0bUazP5hLPlkjs71ozsilbdbaSkr1nzUHwqONFcdE6YVRq
        WRwud9876RGGiSxdfJLedGdHTvlaPYRQO+x12ws4D9NkA5vznRMgAvd9ca+qC4OkJY/GgS
        tYew4ZfS7JcLMXqE6ZttSEQDQ2Zu85k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-476-ovPi3MAeMFqZ6s7Ym02ajw-1; Thu, 08 Oct 2020 23:59:52 -0400
X-MC-Unique: ovPi3MAeMFqZ6s7Ym02ajw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 579CB425D7;
        Fri,  9 Oct 2020 03:59:50 +0000 (UTC)
Received: from [10.72.13.133] (ovpn-13-133.pek2.redhat.com [10.72.13.133])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 013996EF58;
        Fri,  9 Oct 2020 03:59:17 +0000 (UTC)
Subject: Re: [RFC PATCH 18/24] vhost-vdpa: support ASID based IOTLB API
To:     Eugenio Perez Martin <eperezma@redhat.com>
Cc:     Michael Tsirkin <mst@redhat.com>, Cindy Lu <lulu@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Miller <rob.miller@broadcom.com>,
        lingshan.zhu@intel.com, Harpreet Singh Anand <hanand@xilinx.com>,
        mhabets@solarflare.com, eli@mellanox.com,
        Adrian Moreno Zapata <amorenoz@redhat.com>,
        Maxime Coquelin <maxime.coquelin@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>
References: <20200924032125.18619-1-jasowang@redhat.com>
 <20200924032125.18619-19-jasowang@redhat.com>
 <CAJaqyWcsEfJ5n+U-8iNXEM-L4Y9buZntgmMdjPxKCtLxo2cEiw@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <e0f5e0e4-8aaf-60f0-258c-e11f8c5013fb@redhat.com>
Date:   Fri, 9 Oct 2020 11:59:10 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAJaqyWcsEfJ5n+U-8iNXEM-L4Y9buZntgmMdjPxKCtLxo2cEiw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/9/28 下午11:44, Eugenio Perez Martin wrote:
>> -                            u64 iova, u64 size)
>> +static int vhost_vdpa_unmap(struct vhost_vdpa *v,
>> +                           struct vhost_iotlb *iotlb,
>> +                           u64 iova, u64 size)
>>   {
>>          struct vdpa_device *vdpa = v->vdpa;
>>          const struct vdpa_config_ops *ops = vdpa->config;
>> +       u32 asid = (iotlb);
>> +
>> +       if (!iotlb)
>> +               return -EINVAL;
> This should be reorder to check for (!iotlb) before use at `asid =
> iotlb_to_asid()`, isn't it?
>
> Thanks!
>

Yes, will fix in the next version.

Thanks

