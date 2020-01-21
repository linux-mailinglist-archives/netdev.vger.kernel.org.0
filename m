Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F009314361E
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 05:02:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728665AbgAUEBZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 23:01:25 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:21765 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727829AbgAUEBY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 23:01:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579579283;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0WT8Dbo3sKexQYJiDHR6PfmDQ2T2bkeXH3HUb+VfaA4=;
        b=hOIkeJgiMW6l9w8xoorqDXrUjlfTzSYUEbnRmN6ccbH/mkM31gXbCyBPB8ZAEpgHd1+Ohx
        YweAHYg+zbWD9Sa2OKnGgkRzI+tK6O94Hp3rMwis5IsFiyWNprn62iOp4XCd/B5yUBGugI
        lSoG8jEtpR0Tmlrs/XrwXLDNTlZcLmQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-138-s5fqSIo-McyvyGrkMjC0hg-1; Mon, 20 Jan 2020 23:01:20 -0500
X-MC-Unique: s5fqSIo-McyvyGrkMjC0hg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B76351034B48;
        Tue, 21 Jan 2020 04:01:17 +0000 (UTC)
Received: from [10.72.12.208] (ovpn-12-208.pek2.redhat.com [10.72.12.208])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9815919C58;
        Tue, 21 Jan 2020 04:00:58 +0000 (UTC)
Subject: Re: [PATCH 3/5] vDPA: introduce vDPA bus
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     Shahaf Shuler <shahafs@mellanox.com>,
        Rob Miller <rob.miller@broadcom.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Netdev <netdev@vger.kernel.org>,
        "Bie, Tiwei" <tiwei.bie@intel.com>,
        "maxime.coquelin@redhat.com" <maxime.coquelin@redhat.com>,
        "Liang, Cunming" <cunming.liang@intel.com>,
        "Wang, Zhihong" <zhihong.wang@intel.com>,
        "Wang, Xiao W" <xiao.w.wang@intel.com>,
        "haotian.wang@sifive.com" <haotian.wang@sifive.com>,
        "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "hch@infradead.org" <hch@infradead.org>,
        Ariel Adam <aadam@redhat.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "hanand@xilinx.com" <hanand@xilinx.com>,
        "mhabets@solarflare.com" <mhabets@solarflare.com>
References: <20200116124231.20253-1-jasowang@redhat.com>
 <20200116124231.20253-4-jasowang@redhat.com>
 <20200117070324-mutt-send-email-mst@kernel.org>
 <239b042c-2d9e-0eec-a1ef-b03b7e2c5419@redhat.com>
 <CAJPjb1+fG9L3=iKbV4Vn13VwaeDZZdcfBPvarogF_Nzhk+FnKg@mail.gmail.com>
 <AM0PR0502MB379553984D0D55FDE25426F6C3330@AM0PR0502MB3795.eurprd05.prod.outlook.com>
 <d69918ca-8af4-44b2-9652-633530d4c113@redhat.com>
 <20200120174933.GB3891@mellanox.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <2a324cec-2863-58f4-c58a-2414ee32c930@redhat.com>
Date:   Tue, 21 Jan 2020 12:00:57 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200120174933.GB3891@mellanox.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/1/21 =E4=B8=8A=E5=8D=881:49, Jason Gunthorpe wrote:
> On Mon, Jan 20, 2020 at 04:43:53PM +0800, Jason Wang wrote:
>> This is similar to the design of platform IOMMU part of vhost-vdpa. We
>> decide to send diffs to platform IOMMU there. If it's ok to do that in
>> driver, we can replace set_map with incremental API like map()/unmap()=
.
>>
>> Then driver need to maintain rbtree itself.
> I think we really need to see two modes, one where there is a fixed
> translation without dynamic vIOMMU driven changes and one that
> supports vIOMMU.


I think in this case, you meant the method proposed by Shahaf that sends=20
diffs of "fixed translation" to device?

It would be kind of tricky to deal with the following case for example:

old map [4G, 16G) new map [4G, 8G)

If we do

1) flush [4G, 16G)
2) add [4G, 8G)

There could be a window between 1) and 2).

It requires the IOMMU that can do

1) remove [8G, 16G)
2) flush [8G, 16G)
3) change [4G, 8G)

....

>
> There are different optimization goals in the drivers for these two
> configurations.
>
>>> If the first one, then I think memory hotplug is a heavy flow
>>> regardless. Do you think the extra cycles for the tree traverse
>>> will be visible in any way?
>> I think if the driver can pause the DMA during the time for setting up=
 new
>> mapping, it should be fine.
> This is very tricky for any driver if the mapping change hits the
> virtio rings. :(
>
> Even a IOMMU using driver is going to have problems with that..
>
> Jason


Or I wonder whether ATS/PRI can help here. E.g during I/O page fault,=20
driver/device can wait for the new mapping to be set and then replay the=20
DMA.

Thanks

>

