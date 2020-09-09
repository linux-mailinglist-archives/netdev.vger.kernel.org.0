Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D85F3262AA1
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 10:42:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728360AbgIIImU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 04:42:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29143 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728405AbgIIImL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 04:42:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599640929;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DtMgeTKjCn17clYv2JEnI3ffDcOPCVRLd/V3CjCE3+4=;
        b=bHjGmcvqF0tE71baoI3XsazFtb7Y1uRgSepgFwfvZVBUz2TXHY8Z/uH6eebU85ovLLOVAz
        8Nqr+bGQj37LIpdfjuv1znQF6+mxZvW2ANflJEEkIPlnQsSYLPWcy89D/Y/TxGeQPqjGSH
        KjlZ03LQQkKXOnZ+4HXNy1MWu3PbLgY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-23-_Ya4rfJ9P0yaQlRETl-ZPw-1; Wed, 09 Sep 2020 04:42:06 -0400
X-MC-Unique: _Ya4rfJ9P0yaQlRETl-ZPw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D592981F02E;
        Wed,  9 Sep 2020 08:42:03 +0000 (UTC)
Received: from [10.72.12.24] (ovpn-12-24.pek2.redhat.com [10.72.12.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9D6F760C15;
        Wed,  9 Sep 2020 08:41:46 +0000 (UTC)
Subject: Re: [RFC PATCH 00/22] Enhance VHOST to enable SoC-to-SoC
 communication
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Kishon Vijay Abraham I <kishon@ti.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Jon Mason <jdmason@kudzu.us>,
        Dave Jiang <dave.jiang@intel.com>,
        Allen Hubbe <allenbh@gmail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-ntb@googlegroups.com,
        linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <20200702082143.25259-1-kishon@ti.com>
 <20200702055026-mutt-send-email-mst@kernel.org>
 <603970f5-3289-cd53-82a9-aa62b292c552@redhat.com>
 <14c6cad7-9361-7fa4-e1c6-715ccc7e5f6b@ti.com>
 <59fd6a0b-8566-44b7-3dae-bb52b468219b@redhat.com>
 <ce9eb6a5-cd3a-a390-5684-525827b30f64@ti.com>
 <da2b671c-b05d-a57f-7bdf-8b1043a41240@redhat.com>
 <fee8a0fb-f862-03bd-5ede-8f105b6af529@ti.com>
 <b2178e1d-2f5c-e8a3-72fb-70f2f8d6aa45@redhat.com>
 <45a8a97c-2061-13ee-5da8-9877a4a3b8aa@ti.com>
 <c8739d7f-e12e-f6a2-7018-9eeaf6feb054@redhat.com>
 <20200828123409.4cd2a812.cohuck@redhat.com>
 <ac8f7e4f-9f46-919a-f5c2-89b07794f0ab@ti.com>
 <9cd58cd1-0041-3d98-baf7-6e5bc2e7e317@redhat.com>
 <20200908183701.60b93441.cohuck@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <d6e4be52-78d8-546c-20a4-23bdaea68ba5@redhat.com>
Date:   Wed, 9 Sep 2020 16:41:44 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200908183701.60b93441.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/9/9 上午12:37, Cornelia Huck wrote:
>> Then you need something that is functional equivalent to virtio PCI
>> which is actually the concept of vDPA (e.g vDPA provides alternatives if
>> the queue_sel is hard in the EP implementation).
> It seems I really need to read up on vDPA more... do you have a pointer
> for diving into this alternatives aspect?


See vpda_config_ops in include/linux/vdpa.h

Especially this part:

     int (*set_vq_address)(struct vdpa_device *vdev,
                   u16 idx, u64 desc_area, u64 driver_area,
                   u64 device_area);

This means for the devices (e.g endpoint device) that is hard to 
implement virtio-pci layout, it can use any other register layout or 
vendor specific way to configure the virtqueue.


>
>>> "Virtio Over NTB" should anyways be a new transport.
>>>> Does that make any sense?
>>> yeah, in the approach I used the initial features are hard-coded in
>>> vhost-rpmsg (inherent to the rpmsg) but when we have to use adapter
>>> layer (vhost only for accessing virtio ring and use virtio drivers on
>>> both front end and backend), based on the functionality (e.g, rpmsg),
>>> the vhost should be configured with features (to be presented to the
>>> virtio) and that's why additional layer or APIs will be required.
>> A question here, if we go with vhost bus approach, does it mean the
>> virtio device can only be implemented in EP's userspace?
> Can we maybe implement an alternative bus as well that would allow us
> to support different virtio device implementations (in addition to the
> vhost bus + userspace combination)?


That should be fine, but I'm not quite sure that implementing the device 
in kerne (kthread) is the good approach.

Thanks


>

