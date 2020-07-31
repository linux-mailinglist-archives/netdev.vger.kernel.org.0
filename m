Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B81A233DA6
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 05:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731297AbgGaDS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 23:18:56 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32738 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731193AbgGaDSz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 23:18:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596165534;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Oeb1VKsxkfGqpmZlCJj7NjGP59zOgyrbLbbbEHSWF0Q=;
        b=bx5OKTEJ6vZtpE3vKEKJNv2yoWOgop1CdN9RVLp1vF7BK2slVOT0YZyaTKVR6C6cXEX3Ye
        kox4noBHCyaXhcY8MdqSYjen+sl8xlsS50oIXKfL8FQQDmfzXoKlyqwD3JulebIN75obaZ
        ZeoyZpoakHQC82IGY9GCvfdGoH9H3kg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-438-Ho6C2Ek9N0mJD3NRhSS_PQ-1; Thu, 30 Jul 2020 23:18:52 -0400
X-MC-Unique: Ho6C2Ek9N0mJD3NRhSS_PQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4611118839C1;
        Fri, 31 Jul 2020 03:18:51 +0000 (UTC)
Received: from [10.72.13.197] (ovpn-13-197.pek2.redhat.com [10.72.13.197])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E61355F7D8;
        Fri, 31 Jul 2020 03:18:41 +0000 (UTC)
Subject: Re: [PATCH V4 0/6] IRQ offloading for vDPA
To:     Zhu Lingshan <lingshan.zhu@intel.com>, alex.williamson@redhat.com,
        mst@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, eli@mellanox.com, shahafs@mellanox.com,
        parav@mellanox.com
References: <20200728042405.17579-1-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <d3a12faa-44b5-1c1b-2047-7b39863d82a7@redhat.com>
Date:   Fri, 31 Jul 2020 11:18:40 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200728042405.17579-1-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/7/28 下午12:23, Zhu Lingshan wrote:
> This series intends to implement IRQ offloading for
> vhost_vdpa.
>
> By the feat of irq forwarding facilities like posted
> interrupt on X86, irq bypass can  help deliver
> interrupts to vCPU directly.
>
> vDPA devices have dedicated hardware backends like VFIO
> pass-throughed devices. So it would be possible to setup
> irq offloading(irq bypass) for vDPA devices and gain
> performance improvements.
>
> In my testing, with this feature, we can save 0.1ms
> in a ping between two VFs on average.
> changes from V3:
> (1)removed vDPA irq allocate/free helpers in vDPA core.
> (2)add a new function get_vq_irq() in struct vdpa_config_ops,
> upper layer driver can use this function to: A. query the
> irq numbner of a vq. B. detect whether a vq is enabled.
> (3)implement get_vq_irq() in ifcvf driver.
> (4)in vhost_vdpa, set_status() will setup irq offloading when
> setting DRIVER_OK, and unsetup when receive !DRIVER_OK.
> (5)minor improvements.


Ok, I think you can go ahead to post a V5. It's not bad to start with 
get_vq_irq() and we can do any changes afterwards if it can work for 
some cases.

Thanks

