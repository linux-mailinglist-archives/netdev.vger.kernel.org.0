Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5586415C0D1
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 15:59:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727639AbgBMO7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 09:59:08 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:50430 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727414AbgBMO7I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 09:59:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581605946;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CHiRb+twyxpf3W0EcmM5/eTdbL/em0EAL1gxZi7gnIQ=;
        b=ODyxmkzurI+RWNGd+/OIwxeJjG1L4pTuUGH1jQfymp/gttxA02ui7rXZ1+IZCxrC0tXYAj
        xRlqJHiiVY1i6mh3TkhgNrlN/bkMslrSRx+Rl6lB1CRaF9IEI/mAJd2gL8XJniUKYjeB+C
        14N2XgAPwY5LTyRp6BbIgGNNgI+ZpcQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-407-q6vGNjygM1KilbmYGgqpcw-1; Thu, 13 Feb 2020 09:59:05 -0500
X-MC-Unique: q6vGNjygM1KilbmYGgqpcw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4B6948EC825;
        Thu, 13 Feb 2020 14:59:02 +0000 (UTC)
Received: from [10.72.12.120] (ovpn-12-120.pek2.redhat.com [10.72.12.120])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 892AF9008B;
        Thu, 13 Feb 2020 14:58:46 +0000 (UTC)
Subject: Re: [PATCH V2 3/5] vDPA: introduce vDPA bus
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     mst@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        tiwei.bie@intel.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        haotian.wang@sifive.com, lingshan.zhu@intel.com,
        eperezma@redhat.com, lulu@redhat.com, parav@mellanox.com,
        kevin.tian@intel.com, stefanha@redhat.com, rdunlap@infradead.org,
        hch@infradead.org, aadam@redhat.com, jiri@mellanox.com,
        shahafs@mellanox.com, hanand@xilinx.com, mhabets@solarflare.com
References: <20200210035608.10002-1-jasowang@redhat.com>
 <20200210035608.10002-4-jasowang@redhat.com>
 <20200211134746.GI4271@mellanox.com>
 <cf7abcc9-f8ef-1fe2-248e-9b9028788ade@redhat.com>
 <20200212125108.GS4271@mellanox.com>
 <12775659-1589-39e4-e344-b7a2c792b0f3@redhat.com>
 <20200213134128.GV4271@mellanox.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <ebaea825-5432-65e2-2ab3-720a8c4030e7@redhat.com>
Date:   Thu, 13 Feb 2020 22:58:44 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200213134128.GV4271@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/2/13 =E4=B8=8B=E5=8D=889:41, Jason Gunthorpe wrote:
> On Thu, Feb 13, 2020 at 11:34:10AM +0800, Jason Wang wrote:
>
>>>    You have dev, type or
>>> class to choose from. Type is rarely used and doesn't seem to be used
>>> by vdpa, so class seems the right choice
>>>
>>> Jason
>> Yes, but my understanding is class and bus are mutually exclusive. So =
we
>> can't add a class to a device which is already attached on a bus.
> While I suppose there are variations, typically 'class' devices are
> user facing things and 'bus' devices are internal facing (ie like a
> PCI device)


Though all vDPA devices have the same programming interface, but the=20
semantic is different. So it looks to me that use bus complies what=20
class.rst said:

"

Each device class defines a set of semantics and a programming interface
that devices of that class adhere to. Device drivers are the
implementation of that programming interface for a particular device on
a particular bus.

"


>
> So why is this using a bus? VDPA is a user facing object, so the
> driver should create a class vhost_vdpa device directly, and that
> driver should live in the drivers/vhost/ directory.


This is because we want vDPA to be generic for being used by different=20
drivers which is not limited to vhost-vdpa. E.g in this series, it=20
allows vDPA to be used by kernel virtio drivers. And in the future, we=20
will probably introduce more drivers in the future.


>
> For the PCI VF case this driver would bind to a PCI device like
> everything else
>
> For our future SF/ADI cases the driver would bind to some
> SF/ADI/whatever device on a bus.


All these driver will still be bound to their own bus (PCI or other).=20
And what the driver needs is to present a vDPA device to virtual vDPA=20
bus on top.

Thanks

>
> I don't see a reason for VDPA to be creating busses..
>
> Jason
>

