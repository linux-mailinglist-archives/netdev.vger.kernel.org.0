Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47AA9104DAD
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 09:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbfKUIRo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 03:17:44 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25355 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726170AbfKUIRo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 03:17:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574324262;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fME2CUbGpuzKSf98sUwbJKLhY6cHiaVbZgMmbu81k4g=;
        b=iejSZnoR/wJ5u7Dp4KI48TohZPv5u2kBNaIBC8X9AGePysCFfCw0k7+qc7xf0S7VT9qqEJ
        xXUynw1d7rT5Ot0b3OHWoqvehqJJclTvKM49vrjkUy0Li+6oDkedLU6d2baM4z2knhHnmF
        1CEEAMEmlcNvdLb/ykGS96CaNOfMAmY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-340-KpmBr6-hM_mP_HKXoTqyNQ-1; Thu, 21 Nov 2019 03:17:39 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 184C31800D45;
        Thu, 21 Nov 2019 08:17:38 +0000 (UTC)
Received: from [10.72.12.204] (ovpn-12-204.pek2.redhat.com [10.72.12.204])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 08A465DAB0;
        Thu, 21 Nov 2019 08:17:27 +0000 (UTC)
Subject: Re: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
To:     Parav Pandit <parav@mellanox.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Dave Ertman <david.m.ertman@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        Kiran Patil <kiran.patil@intel.com>,
        Tiwei Bie <tiwei.bie@intel.com>
References: <20191119164632.GA4991@ziepe.ca>
 <20191119134822-mutt-send-email-mst@kernel.org>
 <20191119191547.GL4991@ziepe.ca>
 <20191119163147-mutt-send-email-mst@kernel.org>
 <20191119231023.GN4991@ziepe.ca>
 <20191119191053-mutt-send-email-mst@kernel.org>
 <20191120014653.GR4991@ziepe.ca>
 <134058913.35624136.1574222360435.JavaMail.zimbra@redhat.com>
 <20191120133835.GC22515@ziepe.ca> <20191120102856.7e01e2e2@x1.home>
 <20191120181108.GJ22515@ziepe.ca> <20191120150732.2fffa141@x1.home>
 <AM0PR05MB48663ADB0A470C78694F6B8DD14F0@AM0PR05MB4866.eurprd05.prod.outlook.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <e02cf90e-1d4a-bc56-9c71-eea349dc9ff7@redhat.com>
Date:   Thu, 21 Nov 2019 16:17:26 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <AM0PR05MB48663ADB0A470C78694F6B8DD14F0@AM0PR05MB4866.eurprd05.prod.outlook.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: KpmBr6-hM_mP_HKXoTqyNQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/11/21 =E4=B8=8A=E5=8D=886:39, Parav Pandit wrote:
>> From: Alex Williamson<alex.williamson@redhat.com>
>> Sent: Wednesday, November 20, 2019 4:08 PM
>>
>> On Wed, 20 Nov 2019 14:11:08 -0400
>> Jason Gunthorpe<jgg@ziepe.ca>  wrote:
>>
>>> I feel like mdev is suffering from mission creep. I see people
>>> proposing to use mdev for many wild things, the Mellanox SF stuff in
>>> the other thread and this 'virtio subsystem' being the two that have
>>> come up publicly this month.
>> Tell me about it...;)
>>
> Initial Mellanox sub function proposal was done using dedicated non-mdev =
subdev bus in [1] because mdev looked very vfio-ish.
>
> Along the way mdev proposal was suggested at [2] by mdev maintainers to u=
se.
> The bus existed that detached two drivers (mdev and vfio_mdev), there was=
 some motivation to attach other drivers.
>
> After that we continued discussion and mdev extension using alias to have=
 persistent naming in [3].
>
> So far so good, but when we want to have actual use of mdev driver, it do=
esn't look right.:-)
>

Want to implement devlink for mdev then? I think it may help in the case.

Thanks

