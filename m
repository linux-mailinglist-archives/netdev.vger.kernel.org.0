Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAD1F1EE107
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 11:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727925AbgFDJSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 05:18:13 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:27419 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726299AbgFDJSN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 05:18:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591262292;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VKRvnA2ntagIiR78RlbOmGx0PU/n/EP0BCi9aIW6b1E=;
        b=Pys6LcCCTdFHzl7/4VM19JGr738AfiScHClNzK8F18cx7LoiiyEzYRLToBdiNEseGA43SC
        W5m6mYKN2YWwbSYBNUwD/2s2Xzy7pE9ag4Iv+ARtpUhGTQDHRck8qyGc9Y7ao0AGM2lON7
        v5O7d+BT3lMjopysOvpieNknnX53Sjw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379-2rCnZHGmOECqZrGO79PghQ-1; Thu, 04 Jun 2020 05:18:10 -0400
X-MC-Unique: 2rCnZHGmOECqZrGO79PghQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 80BD9107ACF3;
        Thu,  4 Jun 2020 09:18:09 +0000 (UTC)
Received: from [10.72.13.104] (ovpn-13-104.pek2.redhat.com [10.72.13.104])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C943160CD1;
        Thu,  4 Jun 2020 09:18:01 +0000 (UTC)
Subject: Re: [PATCH RFC 07/13] vhost: format-independent API for used buffers
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org
References: <20200602130543.578420-1-mst@redhat.com>
 <20200602130543.578420-8-mst@redhat.com>
 <6d98f2cc-2084-cde0-c938-4ca01692adf9@redhat.com>
 <20200604050135-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <b39e6fb8-a59a-2b3f-a1eb-1ccea2fe1b86@redhat.com>
Date:   Thu, 4 Jun 2020 17:18:00 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200604050135-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/6/4 下午5:03, Michael S. Tsirkin wrote:
>>>    static bool vhost_notify(struct vhost_dev *dev, struct vhost_virtqueue *vq)
>>>    {
>>>    	__u16 old, new;
>>> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
>>> index a67bda9792ec..6c10e99ff334 100644
>>> --- a/drivers/vhost/vhost.h
>>> +++ b/drivers/vhost/vhost.h
>>> @@ -67,6 +67,13 @@ struct vhost_desc {
>>>    	u16 id;
>>>    };
>>> +struct vhost_buf {
>>> +	u32 out_len;
>>> +	u32 in_len;
>>> +	u16 descs;
>>> +	u16 id;
>>> +};
>> So it looks to me the struct vhost_buf can work for both split ring and
>> packed ring.
>>
>> If this is true, we'd better make struct vhost_desc work for both.
>>
>> Thanks
> Both vhost_desc and vhost_buf can work for split and packed.
>
> Do you mean we should add packed ring support based on this?
> For sure, this is one of the motivators for the patchset.
>

Somehow. But the reason I ask is that I see "split" suffix is used in 
patch 1 as:

peek_split_desc()
pop_split_desc()
push_split_desc()

But that suffix is not used for the new used ring API invented in this 
patch.

Thanks


