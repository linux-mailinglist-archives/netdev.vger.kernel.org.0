Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84EBA2E29F5
	for <lists+netdev@lfdr.de>; Fri, 25 Dec 2020 07:17:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbgLYGQt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Dec 2020 01:16:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59252 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725779AbgLYGQt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Dec 2020 01:16:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608876923;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w7tJ3BxFC3bqQCGNgX0REDThHWaozRXz9C3kfzP9GPY=;
        b=YsvpdLsHc78idb/xT5QY6F0Cvegv2wytd1iAHAyO3zFDRwPFwWHJX6oevU4sTrYnBJhLdw
        K3k5+5GyHFbeqMK77wr0NUPCUmBcX8TkYk6GhwRqRBOzcJj9h7QcBOfmUb/tYWvUVwfnyC
        RCwUpruQPEFKEtwgF2VnaILQmfiNPpQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-258-SkLE0mm2NW-nxfCujw0HdA-1; Fri, 25 Dec 2020 01:15:21 -0500
X-MC-Unique: SkLE0mm2NW-nxfCujw0HdA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0CC4D10054FF;
        Fri, 25 Dec 2020 06:15:19 +0000 (UTC)
Received: from [10.72.12.166] (ovpn-12-166.pek2.redhat.com [10.72.12.166])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3D4BA6F816;
        Fri, 25 Dec 2020 06:15:11 +0000 (UTC)
Subject: Re: [PATCH net v4 2/2] vhost_net: fix tx queue stuck when sendmsg
 fails
To:     wangyunjian <wangyunjian@huawei.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "Lilijun (Jerry)" <jerry.lilijun@huawei.com>,
        chenchanghu <chenchanghu@huawei.com>,
        xudingke <xudingke@huawei.com>,
        "huangbin (J)" <brian.huangbin@huawei.com>
References: <1608776746-4040-1-git-send-email-wangyunjian@huawei.com>
 <c854850b-43ab-c98d-a4d8-36ad7cd6364c@redhat.com>
 <34EFBCA9F01B0748BEB6B629CE643AE60DB8ED23@DGGEMM533-MBX.china.huawei.com>
 <823a1558-70fb-386d-fd28-d0c9bdbe9dac@redhat.com>
 <34EFBCA9F01B0748BEB6B629CE643AE60DB8EE1C@DGGEMM533-MBX.china.huawei.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <c4587112-cd05-aeec-3307-8fd813060dd8@redhat.com>
Date:   Fri, 25 Dec 2020 14:15:10 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <34EFBCA9F01B0748BEB6B629CE643AE60DB8EE1C@DGGEMM533-MBX.china.huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/12/24 下午5:09, wangyunjian wrote:
>> -EAGAIN and -ENOBFS are fine. But I don't see how -ENOMEM can be returned.
> The tun_build_skb() and tun_napi_alloc_frags() return -ENOMEM when memory
> allocation fails.
>
> Thanks
>

You're right. So I think we need check them all.

In the future, we need think of a better way. I feel such check is kind 
of fragile since people may modify core sock codes without having a look 
at what vhost does.

Thanks

