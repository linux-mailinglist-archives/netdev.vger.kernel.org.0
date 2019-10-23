Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 027B8E171B
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 11:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391098AbfJWJ6z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 05:58:55 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:39732 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404194AbfJWJ6M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 05:58:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571824691;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JJgYQZfotgXlLYk+1TQwpLuAuYDxrmw6K+/7q0UstaI=;
        b=brWXG4kD2MwlNsF8gDS/Wr6qiqU7/QCq7vblIsFiFsBVzPCfH91JOuO7W0VQir9SxcLb0x
        UEE9QS9oFacryyr9ZOEwJSSWeDHH47DWuujShXgwRLxdWej4XtKtzVSXmdwtFsOjA4SHbV
        AKPv6+uKGhwV6aiLdBBdhzGIpyB6grU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-284-QeJcTTHPPBCURHnAdXrw0Q-1; Wed, 23 Oct 2019 05:58:08 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9756780183D;
        Wed, 23 Oct 2019 09:58:06 +0000 (UTC)
Received: from [10.72.12.79] (ovpn-12-79.pek2.redhat.com [10.72.12.79])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E145B5D6C8;
        Wed, 23 Oct 2019 09:58:01 +0000 (UTC)
Subject: Re: [RFC 2/2] vhost: IFC VF vdpa layer
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>, mst@redhat.com,
        alex.williamson@redhat.com
Cc:     linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, dan.daly@intel.com,
        cunming.liang@intel.com, tiwei.bie@intel.com, jason.zeng@intel.com,
        zhiyuan.lv@intel.com
References: <20191016013050.3918-1-lingshan.zhu@intel.com>
 <20191016013050.3918-3-lingshan.zhu@intel.com>
 <9495331d-3c65-6f49-dcd9-bfdb17054cf0@redhat.com>
 <f65358e9-6728-8260-74f7-176d7511e989@intel.com>
 <1cae60b6-938d-e2df-2dca-fbf545f06853@redhat.com>
 <ddf412c6-69e2-b3ca-d0c8-75de1db78ed9@linux.intel.com>
 <a16461af-8e78-6089-aad2-8af6d1b487af@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <3c6c0319-7961-67ae-61d3-13771162dba7@redhat.com>
Date:   Wed, 23 Oct 2019 17:58:00 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <a16461af-8e78-6089-aad2-8af6d1b487af@intel.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: QeJcTTHPPBCURHnAdXrw0Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/10/23 =E4=B8=8B=E5=8D=885:24, Zhu, Lingshan wrote:
>>>>>
>>>>>
>>>>> set_config/get_config is missing. It looks to me they are not=20
>>>>> hard, just implementing the access to dev_cfg. It's key to make=20
>>>>> kernel virtio driver to work.
>>>>>
>>>>> And in the new version of virito-mdev, features like _F_LOG_ALL=20
>>>>> should be advertised through get_mdev_features.
>>>> IMHO, currently the driver can work without set/get_config,=20
>>>> vhost_mdev doesn't call them for now.
>>>
>>>
>>> Yes, but it was required by virtio_mdev for host driver to work, and=20
>>> it looks to me it's not hard to add them. If possible please add=20
>>> them and "virtio" type then we can use the ops for both the case of=20
>>> VM and containers.
>> sure
>
> Hello Jason,
>
> Just want to double confirm the implementation of set/get_config, for=20
> now, dev_cfg only contains mac[6], status and max_virtqueue_pairs, is=20
> that enough to support virtio_mdev?
>
> THanks!


Yes, and it depends on the features that you want to advertise. If you=20
don't want to advertise MQ, there's no need to expose max_virtqueue_pairs.

Thanks

