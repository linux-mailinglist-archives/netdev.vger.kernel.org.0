Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFA752E7698
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 07:37:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726499AbgL3Gfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 01:35:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49254 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726350AbgL3Gfi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 01:35:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609310051;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eBNGzwi7egS/zPmLxQnZGEadManYeUMP6ZIVWQPjrak=;
        b=P5usXa+QmI3wcm6gEQ4w3yEGKaY+SLYN8O7projkTa7BCaEuQmidwT5WqsEK3Qg7qwSHMU
        9+PlhA+l9+6yU/I28WlcTtVum5ZOjyJVc4gkUmJ31ybs8C95vlhSJ8Ae4DSK/hFCJA2VeQ
        ZpOwQOFj6CNPnDTadezgVtnbMi7Br3s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-293-wWbJRowYPJ6KjjyT4C-i_Q-1; Wed, 30 Dec 2020 01:34:10 -0500
X-MC-Unique: wWbJRowYPJ6KjjyT4C-i_Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 550E11005504;
        Wed, 30 Dec 2020 06:34:08 +0000 (UTC)
Received: from [10.72.13.30] (ovpn-13-30.pek2.redhat.com [10.72.13.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 61882709B7;
        Wed, 30 Dec 2020 06:33:54 +0000 (UTC)
Subject: Re: [PATCH 11/21] vhost-vdpa: introduce asid based IOTLB
To:     Eli Cohen <elic@nvidia.com>
Cc:     mst@redhat.com, eperezma@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lulu@redhat.com, eli@mellanox.com,
        lingshan.zhu@intel.com, rob.miller@broadcom.com,
        stefanha@redhat.com, sgarzare@redhat.com
References: <20201216064818.48239-1-jasowang@redhat.com>
 <20201216064818.48239-12-jasowang@redhat.com>
 <20201229120504.GE195479@mtl-vdi-166.wap.labs.mlnx>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <bc85dfe9-7689-2be1-b124-0f0529e1d8dc@redhat.com>
Date:   Wed, 30 Dec 2020 14:33:53 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201229120504.GE195479@mtl-vdi-166.wap.labs.mlnx>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/12/29 下午8:05, Eli Cohen wrote:
>> +
>> +static int vhost_vdpa_remove_as(struct vhost_vdpa *v, u32 asid)
> The return value is never interpreted. I think it should either be made
> void or return values checked.


Right, will make it void.


>
>> +{
>> +	struct vhost_vdpa_as *as = asid_to_as(v, asid);
>> +
>> +	/* Remove default address space is not allowed */
>> +	if (asid == 0)
>> +		return -EINVAL;
> Can you explain why? I think you have a memory leak due to this as no
> one will ever free as with id 0.
>

Looks like a bug. Will remove this.

Thanks


