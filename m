Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC5A2E75EC
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 05:02:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgL3ECH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Dec 2020 23:02:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23122 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726138AbgL3ECG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Dec 2020 23:02:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609300840;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KZ+tvVxfnnvv+eTht2YPU3/8LnIaN/7WC1RcaN3MqX4=;
        b=Ql+TaECzfZVWHvMTksPeEgURq4A4vPAeRZxzPjwHAOjlrokEF/lvw9jUKC/wPl+jH+eiLY
        3bNXADwpY6NF+rqBwju4NQtMpdbNPEHjo0vH3Yxh4ED26L1FzHPFsZXLltgGW/oEhptb4W
        lMhRrE14SfohgluXFYBDp6X3zMSp/+k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-352-usxb8T_YOo21w800PIYJBg-1; Tue, 29 Dec 2020 23:00:38 -0500
X-MC-Unique: usxb8T_YOo21w800PIYJBg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E8CD5180A096;
        Wed, 30 Dec 2020 04:00:36 +0000 (UTC)
Received: from [10.72.13.30] (ovpn-13-30.pek2.redhat.com [10.72.13.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 46A41709B3;
        Wed, 30 Dec 2020 04:00:01 +0000 (UTC)
Subject: Re: [PATCH 07/21] vdpa: multiple address spaces support
To:     Eli Cohen <elic@nvidia.com>
Cc:     mst@redhat.com, eperezma@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lulu@redhat.com, eli@mellanox.com,
        lingshan.zhu@intel.com, rob.miller@broadcom.com,
        stefanha@redhat.com, sgarzare@redhat.com
References: <20201216064818.48239-1-jasowang@redhat.com>
 <20201216064818.48239-8-jasowang@redhat.com>
 <20201229072832.GA195479@mtl-vdi-166.wap.labs.mlnx>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <bbd05848-3376-3a35-8914-16f19c74f373@redhat.com>
Date:   Wed, 30 Dec 2020 12:00:00 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201229072832.GA195479@mtl-vdi-166.wap.labs.mlnx>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/12/29 下午3:28, Eli Cohen wrote:
>> @@ -43,6 +43,8 @@ struct vdpa_vq_state {
>>    * @index: device index
>>    * @features_valid: were features initialized? for legacy guests
>>    * @nvqs: the number of virtqueues
>> + * @ngroups: the number of virtqueue groups
>> + * @nas: the number of address spaces
> I am not sure these can be categorised as part of the state of the VQ.
> It's more of a property so maybe we can have a callback to get the
> properties of the VQ?
>
> Moreover, I think they should be handled in the hardware drivers to
> return 1 for both ngroups and nas.


We can, but those are static attributes that is not expected to be 
changed by the driver.

Introduce callbacks for those static stuffs does not give us any advantage.

For group id and notification area, since we don't have a abstract of 
vdpa_virtqueue. The only choice is to introduce callbacks for them.

Maybe it's time to introduce vdpa_virtqueue.

Thanks

