Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC6501A437A
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 10:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbgDJIYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 04:24:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:41527 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725955AbgDJIYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 04:24:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586507050;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jhbDWM/COmRzn52zE0cD200v2Q1E5S+PCb8ygVpftN0=;
        b=SbPFVbLgc7HgyREdbYOlM4AxdxFZCYuJxMhftIJVC+gPzcKpYfJ7KHhGVBWkbRKSzDMxdu
        7SYakwNFWh8gl0e2UIDXs9mk/Mp7H0DLwq1KKGlAG4nn5qXI0vcDOaX8lk07p6Cbe6zici
        aEvCK7ZaTz8nN3nLAFxtaLd1v/8mFoY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-402-jQWAT0sWMkGl3PDpjBe6gA-1; Fri, 10 Apr 2020 04:24:05 -0400
X-MC-Unique: jQWAT0sWMkGl3PDpjBe6gA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B4DD6DB60;
        Fri, 10 Apr 2020 08:24:02 +0000 (UTC)
Received: from [10.72.12.205] (ovpn-12-205.pek2.redhat.com [10.72.12.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CB11760BFB;
        Fri, 10 Apr 2020 08:23:40 +0000 (UTC)
Subject: Re: [PATCH V9 8/9] vdpasim: vDPA device simulator
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        netdev <netdev@vger.kernel.org>,
        Jason Gunthorpe <jgg@mellanox.com>, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        lingshan.zhu@intel.com, eperezma@redhat.com, lulu@redhat.com,
        parav@mellanox.com, kevin.tian@intel.com, stefanha@redhat.com,
        Randy Dunlap <rdunlap@infradead.org>,
        Christoph Hellwig <hch@infradead.org>, aadam@redhat.com,
        Jiri Pirko <jiri@mellanox.com>, shahafs@mellanox.com,
        hanand@xilinx.com, Martin Habets <mhabets@solarflare.com>,
        gdawar@xilinx.com, saugatm@xilinx.com, vmireyno@marvell.com,
        zhangweining@ruijie.com.cn
References: <20200326140125.19794-1-jasowang@redhat.com>
 <20200326140125.19794-9-jasowang@redhat.com>
 <CAMuHMdUis3O_mJKOb2s=_=Zs61iHus5Aq74N3-xs7kmjN+egoQ@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <108f65dd-f1b1-54ec-ae26-49842f3686b6@redhat.com>
Date:   Fri, 10 Apr 2020 16:23:38 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CAMuHMdUis3O_mJKOb2s=_=Zs61iHus5Aq74N3-xs7kmjN+egoQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/4/10 =E4=B8=8B=E5=8D=883:45, Geert Uytterhoeven wrote:
> Hi Jason,
>
> On Thu, Mar 26, 2020 at 3:07 PM Jason Wang <jasowang@redhat.com> wrote:
>> This patch implements a software vDPA networking device. The datapath
>> is implemented through vringh and workqueue. The device has an on-chip
>> IOMMU which translates IOVA to PA. For kernel virtio drivers, vDPA
>> simulator driver provides dma_ops. For vhost driers, set_map() methods
>> of vdpa_config_ops is implemented to accept mappings from vhost.
>>
>> Currently, vDPA device simulator will loopback TX traffic to RX. So
>> the main use case for the device is vDPA feature testing, prototyping
>> and development.
>>
>> Note, there's no management API implemented, a vDPA device will be
>> registered once the module is probed. We need to handle this in the
>> future development.
>>
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
> This is now commit 2c53d0f64c06f458 ("vdpasim: vDPA device simulator").
>
>> --- a/drivers/virtio/vdpa/Kconfig
>> +++ b/drivers/virtio/vdpa/Kconfig
>> @@ -5,3 +5,22 @@ config VDPA
>>            Enable this module to support vDPA device that uses a
>>            datapath which complies with virtio specifications with
>>            vendor specific control path.
>> +
>> +menuconfig VDPA_MENU
>> +       bool "VDPA drivers"
>> +       default n
>      *
>      * VDPA drivers
>      *
>      VDPA drivers (VDPA_MENU) [N/y/?] (NEW) ?
>
>      There is no help available for this option.
>      Symbol: VDPA_MENU [=3Dn]
>      Type  : bool
>      Defined at drivers/vdpa/Kconfig:9
>       Prompt: VDPA drivers
>       Location:
>         -> Device Drivers
>
> I think this deserves a help text, so users know if they want to enable=
 this
> option or not.


Will add a help text for this.


>
> I had a quick look, but couldn't find the meaning of "vdpa" in the whol=
e kernel
> source tree.


The meaning was explained in the commit log of=20
961e9c84077f6c8579d7a628cbe94a675cb67ae4 and help text for CONFIG_VDPA.

Thanks


>
> Thanks!
>
>> +
>> +if VDPA_MENU
>> +
>> +config VDPA_SIM
>> +       tristate "vDPA device simulator"
>> +       depends on RUNTIME_TESTING_MENU
>> +       select VDPA
>> +       select VHOST_RING
>> +       default n
>> +       help
>> +         vDPA networking device simulator which loop TX traffic back
>> +         to RX. This device is used for testing, prototyping and
>> +         development of vDPA.
>> +
>> +endif # VDPA_MENU
> Gr{oetje,eeting}s,
>
>                          Geert
>

