Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1360714062A
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 10:36:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729107AbgAQJf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 04:35:27 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:47293 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729094AbgAQJf1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 04:35:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579253726;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iQlUMs2/NB7cEZJ9F2n+VZER0LwIUDsqhwlPBsX2bmw=;
        b=B9Cfde4gzTBsdtkibDNpilv8NK5/5s7ihOY+EWegKbAHdS53Ilacv+zKiCQt91+EKIBMh6
        hWrDK+WbVOXjHX3s6QPbhgKO0+jiGrM1WAdeBcn+1IMkYW6g8dmodLbPJyNCDuffCTyE1+
        6gTJTasP8vCYu6BR1IICpAHnWksUkMk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-204-OA_vQTWxNEqASHBKkg99Eg-1; Fri, 17 Jan 2020 04:35:25 -0500
X-MC-Unique: OA_vQTWxNEqASHBKkg99Eg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 52861800D48;
        Fri, 17 Jan 2020 09:35:18 +0000 (UTC)
Received: from [10.72.12.168] (ovpn-12-168.pek2.redhat.com [10.72.12.168])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DEBED10016EB;
        Fri, 17 Jan 2020 09:35:01 +0000 (UTC)
Subject: Re: [PATCH 5/5] vdpasim: vDPA device simulator
To:     Randy Dunlap <rdunlap@infradead.org>, mst@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     tiwei.bie@intel.com, jgg@mellanox.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        haotian.wang@sifive.com, lingshan.zhu@intel.com,
        eperezma@redhat.com, lulu@redhat.com, parav@mellanox.com,
        kevin.tian@intel.com, stefanha@redhat.com, hch@infradead.org,
        aadam@redhat.com, jakub.kicinski@netronome.com, jiri@mellanox.com,
        shahafs@mellanox.com, hanand@xilinx.com, mhabets@solarflare.com
References: <20200116124231.20253-1-jasowang@redhat.com>
 <20200116124231.20253-6-jasowang@redhat.com>
 <55d84df0-803a-a81f-b49f-2d6fe8f78b96@infradead.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <8d6ef81e-b42a-9a89-0857-f2732526a1af@redhat.com>
Date:   Fri, 17 Jan 2020 17:35:00 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <55d84df0-803a-a81f-b49f-2d6fe8f78b96@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/1/17 =E4=B8=8B=E5=8D=8812:12, Randy Dunlap wrote:
> On 1/16/20 4:42 AM, Jason Wang wrote:
>> diff --git a/drivers/virtio/vdpa/Kconfig b/drivers/virtio/vdpa/Kconfig
>> index 3032727b4d98..12ec25d48423 100644
>> --- a/drivers/virtio/vdpa/Kconfig
>> +++ b/drivers/virtio/vdpa/Kconfig
>> @@ -7,3 +7,20 @@ config VDPA
>>             datapath which complies with virtio specifications with
>>             vendor specific control path.
>>  =20
>> +menuconfig VDPA_MENU
>> +	bool "VDPA drivers"
>> +	default n
>> +
>> +if VDPA_MENU
>> +
>> +config VDPA_SIM
>> +	tristate "vDPA device simulator"
>> +        select VDPA
>> +        default n
>> +        help
>> +          vDPA networking device simulator which loop TX traffic back
> 	                                            loops
>
>> +          to RX. This device is used for testing, prototyping and
>> +          development of vDPA.
>> +
>> +endif # VDPA_MENU
> Most lines above use spaces for indentation, while they should use
> tab + 2 spaces.


Right, will fix.

Thanks

