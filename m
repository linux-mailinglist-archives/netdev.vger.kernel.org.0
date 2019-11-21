Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3024210498B
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 05:07:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725842AbfKUEHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 23:07:25 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:24692 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725904AbfKUEHZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 23:07:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574309243;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4xPmtYqEvwApqpheQllbkBpuzyfIA/fCCLuuQtfXsnw=;
        b=MeWvJc0+e6+UEKMvGJ1XtmwF3H3gN1QAFH+NoSbL9LRKsrZvpdPe+eSuVSWVtlTwknOmv/
        6MwIJ9ucOi7+/MvF6ru0t9CFJ0cxnE3wM4wz4+3czUtVOPV+HGF4OgUQtBQhNlPo7gb2r+
        dtlxSjg6/yF2zp6xfSRb8BhFpBmHjtE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-345-Xu_mjR_fPQ2kgYFI6ozcxQ-1; Wed, 20 Nov 2019 23:07:20 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3C2BF107ACC5;
        Thu, 21 Nov 2019 04:07:17 +0000 (UTC)
Received: from [10.72.12.204] (ovpn-12-204.pek2.redhat.com [10.72.12.204])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DFF6960BA9;
        Thu, 21 Nov 2019 04:06:02 +0000 (UTC)
Subject: Re: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Parav Pandit <parav@mellanox.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Dave Ertman <david.m.ertman@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        Kiran Patil <kiran.patil@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Tiwei Bie <tiwei.bie@intel.com>
References: <AM0PR05MB4866CF61828A458319899664D1700@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <a40c09ee-0915-f10c-650e-7539726a887b@redhat.com>
 <AM0PR05MB4866C40A177D3D60BFC558F7D14C0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <13946106-dab2-6bbe-df79-ca6dfdeb4c51@redhat.com>
 <AM0PR05MB486685F7C839AD8A5F3EEA91D14C0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <ead356f5-db81-cb01-0d74-b9e34965a20f@redhat.com>
 <AM0PR05MB486605742430D120769F6C45D14C0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <743601510.35622214.1574219728585.JavaMail.zimbra@redhat.com>
 <AM0PR05MB48664221FB6B1C14BDF6C74AD14F0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <21106743-57b2-2ca7-258c-e37a0880c70f@redhat.com>
 <20191120134126.GD22515@ziepe.ca>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <2b5db5d9-5421-7277-acde-13862a629381@redhat.com>
Date:   Thu, 21 Nov 2019 12:06:01 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191120134126.GD22515@ziepe.ca>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: Xu_mjR_fPQ2kgYFI6ozcxQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/11/20 =E4=B8=8B=E5=8D=889:41, Jason Gunthorpe wrote:
> On Wed, Nov 20, 2019 at 12:07:59PM +0800, Jason Wang wrote:
>
>> 1) create sub fucntion and do must to have pre configuration through dev=
link
>> 2) only after sub function is created one more available instance was ad=
ded
>> and shown through sysfs
>> 3) user can choose to create and use that mdev instance as it did for ot=
her
>> type of device like vGPU
>> 4) devlink can still use to report other stuffs
> Why do we want the extra step #3? The user already indicated they want
> a mdev via #1


It's about the compatibility, but if you wish, I think we can develop=20
devlink based lifecycle for mdev for sure.


>
> I have the same question for the PF and VF cases, why doesn't a mdev
> get created automatically when the VF is probed? Why does this need
> the guid stuff?


All you said here is possible, it's a design choice for the management=20
interface.


>
> The guid stuff was intended for, essentially, multi-function devices
> that could be sliced up, I don't think it makes sense to use it for
> single-function VF devices like the ICF driver.


It doesn't harm, and indeed we have other choice, we can do it gradually=20
on top.


>
> Overall the guid thing should be optional. Drivers providing mdev
> should be able to use another scheme, like devlink, to on demand
> create their mdevs.


Yes, that's for sure. I'm not against to devlink for mdev/subdev, I just=20
say we should not make devlink the only choice for mdev/subdev.

Thanks


>
> Jason
>

