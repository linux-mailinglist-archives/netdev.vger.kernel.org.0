Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 186EB153D67
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 04:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727928AbgBFDMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 22:12:17 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:33531 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727856AbgBFDMN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 22:12:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580958732;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RspSNO+p1yr02wpcehjk1h3AeZBEyxIwLa/kF1BxhEY=;
        b=Tzu/fv1+x57PPEYYLKMdcqmju0mpoP7/vTvkoKseGP3HEPZfXPa6OPdgaFqvEuNWxp2i1J
        rTS2hH0KS9B/cnzajxOAcikwiBJnieqsB4Lu1Hlqlx95vWMoYKAVIApXWQTnnT8JxX+AOU
        P6L9SYGk/bzTklPNYE4Wen+Xtfd9TbU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-251-IABUdiBpNvaQmA4HuVYVBQ-1; Wed, 05 Feb 2020 22:12:10 -0500
X-MC-Unique: IABUdiBpNvaQmA4HuVYVBQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4495D8018A5;
        Thu,  6 Feb 2020 03:12:07 +0000 (UTC)
Received: from [10.72.13.85] (ovpn-13-85.pek2.redhat.com [10.72.13.85])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2AAA85C1B2;
        Thu,  6 Feb 2020 03:11:53 +0000 (UTC)
Subject: Re: [PATCH] vhost: introduce vDPA based backend
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Shahaf Shuler <shahafs@mellanox.com>,
        Tiwei Bie <tiwei.bie@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "rob.miller@broadcom.com" <rob.miller@broadcom.com>,
        "haotian.wang@sifive.com" <haotian.wang@sifive.com>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "hch@infradead.org" <hch@infradead.org>,
        Jiri Pirko <jiri@mellanox.com>,
        "hanand@xilinx.com" <hanand@xilinx.com>,
        "mhabets@solarflare.com" <mhabets@solarflare.com>,
        "maxime.coquelin@redhat.com" <maxime.coquelin@redhat.com>,
        "lingshan.zhu@intel.com" <lingshan.zhu@intel.com>,
        "dan.daly@intel.com" <dan.daly@intel.com>,
        "cunming.liang@intel.com" <cunming.liang@intel.com>,
        "zhihong.wang@intel.com" <zhihong.wang@intel.com>
References: <20200131033651.103534-1-tiwei.bie@intel.com>
 <7aab2892-bb19-a06a-a6d3-9c28bc4c3400@redhat.com>
 <20200205020247.GA368700@___>
 <AM0PR0502MB37952015716C1D5E07E390B6C3020@AM0PR0502MB3795.eurprd05.prod.outlook.com>
 <112858a4-1a01-f4d7-e41a-1afaaa1cad45@redhat.com>
 <20200205125648.GV23346@mellanox.com>
 <20200205081210-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <55b050d6-b31d-f8a2-2a15-0fc68896d47f@redhat.com>
Date:   Thu, 6 Feb 2020 11:11:52 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200205081210-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/2/5 =E4=B8=8B=E5=8D=889:14, Michael S. Tsirkin wrote:
> On Wed, Feb 05, 2020 at 08:56:48AM -0400, Jason Gunthorpe wrote:
>> On Wed, Feb 05, 2020 at 03:50:14PM +0800, Jason Wang wrote:
>>>> Would it be better for the map/umnap logic to happen inside each dev=
ice ?
>>>> Devices that needs the IOMMU will call iommu APIs from inside the dr=
iver callback.
>>> Technically, this can work. But if it can be done by vhost-vpda it wi=
ll make
>>> the vDPA driver more compact and easier to be implemented.
>> Generally speaking, in the kernel, it is normal to not hoist code of
>> out drivers into subsystems until 2-3 drivers are duplicating that
>> code. It helps ensure the right design is used
>>
>> Jason
> That's up to the sybsystem maintainer really, as there's also some
> intuition involved in guessing a specific API is widely useful.
> In-kernel APIs are flexible, if we find something isn't needed we just
> drop it.
>

If I understand correctly. At least Intel (Ling Shan) and Brodcom (Rob)=20
doesn't want to deal with DMA stuffs in their driver.

Anyway since the DMA bus operations is optional, driver may still choose=20
to do DMA by itself if they want even if it requires platform IOMMU to wo=
rk.

Thanks

