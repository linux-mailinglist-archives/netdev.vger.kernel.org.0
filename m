Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 804E6E860E
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 11:49:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729493AbfJ2KtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 06:49:20 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:40196 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727260AbfJ2KtU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 06:49:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572346158;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ku5QMX1PXe0RMduAjOLbTYKTX3zeaaRJXqe/yt5ek0A=;
        b=jU0PNJ2HgW/cOYVqih2EPOVsLM7EeADYb04F4m7f4aYrMFdLUhTyBJoKlm37hfxN29nXu7
        qzCpY4QBfhG5FSZtmENIqUzw+yHkdjFOLFDsyu7HMu+XRA3FozY8aiKicHiGZK75NJP2jS
        XjhE3N+5FTABo4qt/+Vfad9X9JOMPNQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-Ojy6gkM5P2myIxO3H-nb5w-1; Tue, 29 Oct 2019 06:49:17 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 844FC476;
        Tue, 29 Oct 2019 10:49:15 +0000 (UTC)
Received: from [10.72.12.223] (ovpn-12-223.pek2.redhat.com [10.72.12.223])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1916B600F0;
        Tue, 29 Oct 2019 10:48:35 +0000 (UTC)
Subject: Re: [PATCH v2] vhost: introduce mdev based hardware backend
To:     Tiwei Bie <tiwei.bie@intel.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, alex.williamson@redhat.com,
        maxime.coquelin@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, dan.daly@intel.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        lingshan.zhu@intel.com
References: <5a7bc5da-d501-2750-90bf-545dd55f85fa@redhat.com>
 <20191024042155.GA21090@___>
 <d37529e1-5147-bbe5-cb9d-299bd6d4aa1a@redhat.com>
 <d4cc4f4e-2635-4041-2f68-cd043a97f25a@redhat.com>
 <20191024091839.GA17463@___>
 <fefc82a3-a137-bc03-e1c3-8de79b238080@redhat.com>
 <e7e239ba-2461-4f8d-7dd7-0f557ac7f4bf@redhat.com>
 <20191025080143-mutt-send-email-mst@kernel.org> <20191028015842.GA9005@___>
 <5e8a623d-9d91-607a-1f9e-7a7086ba9a68@redhat.com> <20191029095738.GA7228@___>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <146752f4-174c-c916-3682-b965b96d7872@redhat.com>
Date:   Tue, 29 Oct 2019 18:48:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191029095738.GA7228@___>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: Ojy6gkM5P2myIxO3H-nb5w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/10/29 =E4=B8=8B=E5=8D=885:57, Tiwei Bie wrote:
> On Mon, Oct 28, 2019 at 11:50:49AM +0800, Jason Wang wrote:
>> On 2019/10/28 =E4=B8=8A=E5=8D=889:58, Tiwei Bie wrote:
>>> On Fri, Oct 25, 2019 at 08:16:26AM -0400, Michael S. Tsirkin wrote:
>>>> On Fri, Oct 25, 2019 at 05:54:55PM +0800, Jason Wang wrote:
>>>>> On 2019/10/24 =E4=B8=8B=E5=8D=886:42, Jason Wang wrote:
>>>>>> Yes.
>>>>>>
>>>>>>
>>>>>>>  =C2=A0 And we should try to avoid
>>>>>>> putting ctrl vq and Rx/Tx vqs in the same DMA space to prevent
>>>>>>> guests having the chance to bypass the host (e.g. QEMU) to
>>>>>>> setup the backend accelerator directly.
>>>>>> That's really good point.=C2=A0 So when "vhost" type is created, par=
ent
>>>>>> should assume addr of ctrl_vq is hva.
>>>>>>
>>>>>> Thanks
>>>>> This works for vhost but not virtio since there's no way for virtio k=
ernel
>>>>> driver to differ ctrl_vq with the rest when doing DMA map. One possib=
le
>>>>> solution is to provide DMA domain isolation between virtqueues. Then =
ctrl vq
>>>>> can use its dedicated DMA domain for the work.
>>> It might not be a bad idea to let the parent drivers distinguish
>>> between virtio-mdev mdevs and vhost-mdev mdevs in ctrl-vq handling
>>> by mdev's class id.
>> Yes, that should work, I have something probable better, see below.
>>
>>
>>>>> Anyway, this could be done in the future. We can have a version first=
 that
>>>>> doesn't support ctrl_vq.
>>> +1, thanks
>>>
>>>>> Thanks
>>>> Well no ctrl_vq implies either no offloads, or no XDP (since XDP needs
>>>> to disable offloads dynamically).
>>>>
>>>>          if (!virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_GUEST_OFF=
LOADS)
>>>>              && (virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_TSO4)=
 ||
>>>>                  virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_TSO6)=
 ||
>>>>                  virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_ECN) =
||
>>>>                  virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_UFO) =
||
>>>>                  virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_CSUM)=
)) {
>>>>                  NL_SET_ERR_MSG_MOD(extack, "Can't set XDP while host =
is implementing LRO/CSUM, disable LRO/CSUM first");
>>>>                  return -EOPNOTSUPP;
>>>>          }
>>>>
>>>> neither is very attractive.
>>>>
>>>> So yes ok just for development but we do need to figure out how it wil=
l
>>>> work down the road in production.
>>> Totally agree.
>>>
>>>> So really this specific virtio net device does not support control vq,
>>>> instead it supports a different transport specific way to send command=
s
>>>> to device.
>>>>
>>>> Some kind of extension to the transport? Ideas?
>> So it's basically an issue of isolating DMA domains. Maybe we can start =
with
>> transport API for querying per vq DMA domain/ASID?
>>
>> - for vhost-mdev, userspace can query the DMA domain for each specific
>> virtqueue. For control vq, mdev can return id for software domain, for t=
he
>> rest mdev will return id of VFIO domain. Then userspace know that it sho=
uld
>> use different API for preparing the virtqueue, e.g for vq other than con=
trol
>> vq, it should use VFIO DMA API. The control vq it should use hva instead=
.
>>
>> - for virito-mdev, we can introduce per-vq DMA device, and route DMA map=
ping
>> request for control vq back to mdev instead of the hardware. (We can wra=
p
>> them into library or helpers to ease the development of vendor physical
>> drivers).
> Thanks for this proposal! I'm thinking about it these days.
> I think it might be too complicated. I'm wondering whether we
> can have something simpler. I will post a RFC patch to show
> my idea today.


Thanks, will check.

Btw, for virtio-mdev, the change should be very minimal, will post an
RFC as well. For vhost-mdev, it could be just a helper to return an ID
for DMA domain like ID_VFIO or ID_HVA.

Or a more straightforward way is to force queues like control vq to use PA.


>
> Thanks,
> Tiwei
>

