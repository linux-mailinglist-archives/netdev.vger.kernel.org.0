Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F343419AC02
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 14:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732444AbgDAMvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 08:51:06 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:27862 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726974AbgDAMvG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 08:51:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585745465;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KZrEIeJJf1z/466R4PTGZhsuBRjfB99OXepaDxzJjTA=;
        b=QGfhPHu0qbTRlC5zF+G2AnEC3HUuHihNcAiQKacmcqvmBCTXCbvA1WqbfD+rJA8g72p40X
        PgNMKssEpc6uxf0Mj2l2V70JnFOvmi3N/bi2pmJqGmW1PH0nASvNwuC3gz82wv33rPlmkk
        u8OSuUFXeP3E4HSKz2msEVV8OsHBCYA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-3-2txM6OSVP8OwClyVv-NhKQ-1; Wed, 01 Apr 2020 08:50:58 -0400
X-MC-Unique: 2txM6OSVP8OwClyVv-NhKQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8B6AE477;
        Wed,  1 Apr 2020 12:50:55 +0000 (UTC)
Received: from [10.72.12.139] (ovpn-12-139.pek2.redhat.com [10.72.12.139])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 46B9A18A85;
        Wed,  1 Apr 2020 12:50:37 +0000 (UTC)
Subject: Re: [PATCH V9 1/9] vhost: refine vhost and vringh kconfig
To:     Christian Borntraeger <borntraeger@de.ibm.com>, mst@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     jgg@mellanox.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        lingshan.zhu@intel.com, eperezma@redhat.com, lulu@redhat.com,
        parav@mellanox.com, kevin.tian@intel.com, stefanha@redhat.com,
        rdunlap@infradead.org, hch@infradead.org, aadam@redhat.com,
        jiri@mellanox.com, shahafs@mellanox.com, hanand@xilinx.com,
        mhabets@solarflare.com, gdawar@xilinx.com, saugatm@xilinx.com,
        vmireyno@marvell.com, zhangweining@ruijie.com.cn
References: <20200326140125.19794-1-jasowang@redhat.com>
 <20200326140125.19794-2-jasowang@redhat.com>
 <fde312a4-56bd-f11f-799f-8aa952008012@de.ibm.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <41ee1f6a-3124-d44b-bf34-0f26604f9514@redhat.com>
Date:   Wed, 1 Apr 2020 20:50:36 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <fde312a4-56bd-f11f-799f-8aa952008012@de.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/4/1 =E4=B8=8B=E5=8D=887:21, Christian Borntraeger wrote:
> On 26.03.20 15:01, Jason Wang wrote:
>> Currently, CONFIG_VHOST depends on CONFIG_VIRTUALIZATION. But vhost is
>> not necessarily for VM since it's a generic userspace and kernel
>> communication protocol. Such dependency may prevent archs without
>> virtualization support from using vhost.
>>
>> To solve this, a dedicated vhost menu is created under drivers so
>> CONIFG_VHOST can be decoupled out of CONFIG_VIRTUALIZATION.
> FWIW, this now results in vhost not being build with defconfig kernels =
(in todays
> linux-next).
>

Hi Christian:

Did you meet it even with this=20
commit=C2=A0https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-ne=
xt.git/commit/?id=3Da4be40cbcedba9b5b714f3c95182e8a45176e42d?

If yes, what's your build config looks like?

Thanks

