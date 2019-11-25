Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE05108E58
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 14:00:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727408AbfKYNAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 08:00:00 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46201 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727300AbfKYNAA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 08:00:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574686799;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Cdk+dECH005B5t1f94C8RSsQ86cze75hgG33FXnZQFU=;
        b=E3g0mUvrxfdCSJPIJQb1MK2y16ObQw/yuvDvKFE7bUiVDKZdn3ZgrGCBrwh/SLT1au688Y
        Qyr/IH6bflYx7LukuC4nM/y9hFcQs9LrnrMp5DBE0KSaw8VBKFklF/aZ6PEigw+y2OTrJo
        cdLlmfMgnSpKlFqPjSfMTAP0xw9rvKM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-50-EC6sypjEMtSlqN8YDpjaPg-1; Mon, 25 Nov 2019 07:59:56 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5D18664A80;
        Mon, 25 Nov 2019 12:59:54 +0000 (UTC)
Received: from [10.72.12.44] (ovpn-12-44.pek2.redhat.com [10.72.12.44])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 01F665C1D4;
        Mon, 25 Nov 2019 12:59:43 +0000 (UTC)
Subject: Re: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
To:     Jason Gunthorpe <jgg@ziepe.ca>, Tiwei Bie <tiwei.bie@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        davem@davemloft.net, gregkh@linuxfoundation.org,
        Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, Kiran Patil <kiran.patil@intel.com>
References: <20191120181108.GJ22515@ziepe.ca>
 <20191120150732.2fffa141@x1.home> <20191121030357.GB16914@ziepe.ca>
 <5dcef4ab-feb5-d116-b2a9-50608784a054@redhat.com>
 <20191121141732.GB7448@ziepe.ca>
 <721e49c2-a2e1-853f-298b-9601c32fcf9e@redhat.com>
 <20191122180214.GD7448@ziepe.ca> <20191123043951.GA364267@___>
 <20191123230948.GF7448@ziepe.ca> <20191124145124.GA374942@___>
 <20191125000919.GB5634@ziepe.ca>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <1ea2fa65-650e-bb09-f9c6-361dfd9b0b77@redhat.com>
Date:   Mon, 25 Nov 2019 20:59:42 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191125000919.GB5634@ziepe.ca>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: EC6sypjEMtSlqN8YDpjaPg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/11/25 =E4=B8=8A=E5=8D=888:09, Jason Gunthorpe wrote:
> On Sun, Nov 24, 2019 at 10:51:24PM +0800, Tiwei Bie wrote:
>
>>>> You removed JasonW's other reply in above quote. He said it clearly
>>>> that we do want/need to assign parts of device BAR to the VM.
>>> Generally we don't look at patches based on stuff that isn't in them.
>> The hardware is ready, and it's something really necessary (for
>> the performance). It was planned to be added immediately after
>> current series. If you want, it certainly can be included right now.
> I don't think it makes a significant difference, there are enough
> reasons already that this does not belong in vfio. Both Greg and I
> already were very against using mdev as an alterative to the driver
> core.


Don't get us wrong, in v13 this is what Greg said [1].

"
Also, see the other conversations we are having about a "virtual" bus
and devices.  I do not want to have two different ways of doing the same
thing in the kernel at the same time please.  Please work together with
the Intel developers to solve this in a unified way, as you both
need/want the same thing here.

Neither this, nor the other proposal can be accepted until you all agree
on the design and implementation.
"

[1] https://lkml.org/lkml/2019/11/18/521


>
>>>> IIUC, your point is to suggest us invent new DMA API for userspace to
>>>> use instead of leveraging VFIO's well defined DMA API. Even if we don'=
t
>>>> use VFIO at all, I would imagine it could be very VFIO-like (e.g. caps
>>>> for BAR + container/group for DMA) eventually.
>>> None of the other user dma subsystems seem to have the problems you
>>> are imagining here. Perhaps you should try it first?
>> Actually VFIO DMA API wasn't used at the beginning of vhost-mdev. But
>> after the discussion in upstream during the RFC stage since the last
>> year, the conclusion is that leveraging VFIO's existing DMA API would
>> be the better choice and then vhost-mdev switched to that direction.
> Well, unfortunately, I think that discussion may have led you
> wrong. Do you have a link? Did you post an ICF driver that didn't use vfi=
o?


Why do you think the driver posted in [2] use vfio?

[2] https://lkml.org/lkml/2019/11/21/479

Thanks


>
> Jason
>

