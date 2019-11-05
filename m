Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47444EF3FA
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 04:19:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730367AbfKEDTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 22:19:23 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:59535 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730000AbfKEDTX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 22:19:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572923962;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j5OzLFkpAUjCP+yb4lupAMQyPwr8X3YeEPsxi0E3pqk=;
        b=idBUDc/L0fQPyhkz+QLD4dITLCRpESWGCz02q6XA28QK7ME0kIeGrhWHKmRnB2tP7c9oRV
        TSU6UdxMFB3cih1qi7RXBjeMonuEN9kTk0gM5SB1yfBl4ACqT4rXx/Qb2Kf9bRE9K6mLjh
        DqFWSoebVpZCPKvKtpb2jp4POCnQ1cQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-133-QYfxRTI1PLOj3fR3gSxtGg-1; Mon, 04 Nov 2019 22:19:18 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 01604800C73;
        Tue,  5 Nov 2019 03:19:15 +0000 (UTC)
Received: from [10.72.12.252] (ovpn-12-252.pek2.redhat.com [10.72.12.252])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2D2105D6D4;
        Tue,  5 Nov 2019 03:17:29 +0000 (UTC)
Subject: Re: [PATCH V7 3/6] mdev: introduce device specific ops
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, kwankhede@nvidia.com,
        mst@redhat.com, tiwei.bie@intel.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        cohuck@redhat.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        haotian.wang@sifive.com, zhenyuw@linux.intel.com,
        zhi.a.wang@intel.com, jani.nikula@linux.intel.com,
        joonas.lahtinen@linux.intel.com, rodrigo.vivi@intel.com,
        airlied@linux.ie, daniel@ffwll.ch, farman@linux.ibm.com,
        pasic@linux.ibm.com, sebott@linux.ibm.com, oberpar@linux.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        borntraeger@de.ibm.com, akrowiak@linux.ibm.com,
        freude@linux.ibm.com, lingshan.zhu@intel.com, idos@mellanox.com,
        eperezma@redhat.com, lulu@redhat.com, parav@mellanox.com,
        christophe.de.dinechin@gmail.com, kevin.tian@intel.com,
        stefanha@redhat.com
References: <20191104123952.17276-1-jasowang@redhat.com>
 <20191104123952.17276-4-jasowang@redhat.com>
 <20191104145008.4b6839f0@x1.home>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <47ecfe09-0954-9517-3ac5-68db8522826d@redhat.com>
Date:   Tue, 5 Nov 2019 11:17:28 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191104145008.4b6839f0@x1.home>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: QYfxRTI1PLOj3fR3gSxtGg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/11/5 =E4=B8=8A=E5=8D=885:50, Alex Williamson wrote:
>>   EXPORT_SYMBOL(mdev_set_drvdata);
>>  =20
>> +
> Extra whitespace
>
>>   /* Specify the class for the mdev device, this must be called during
>> - * create() callback.
>> - */
>> + * create() callback explicitly or implicity through the helpers
> s/implicity/implicitly/
>
>> + * provided by each class. */
>>   void mdev_set_class(struct mdev_device *mdev, u16 id)
>>   {
>>   =09WARN_ON(mdev->class_id);
>> @@ -55,6 +56,26 @@ void mdev_set_class(struct mdev_device *mdev, u16 id)
>>   }
>>   EXPORT_SYMBOL(mdev_set_class);
>>  =20
>> +/* Specify the mdev device to be a VFIO mdev device, and set VFIO
>> + * device ops for it. This must be called from the create() callback
>> + * for VFIO mdev device.
>> + */
> Comment style.  Thanks,


Will fix them all.

Thanks


>
> Alex
>

