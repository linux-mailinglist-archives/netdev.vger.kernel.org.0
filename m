Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 336BB361835
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 05:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237979AbhDPDZG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 23:25:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47689 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234973AbhDPDZG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 23:25:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618543482;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y2eoMDNZ7KhFTHyXgnjh9cYB2las6pMgIII6CMe3Tt4=;
        b=LbWoQiIYUzn7d8QIrjx/9922dSzZoAncTznxkxIqDw18UIWIZWociVrI6B6MIBzdptVEH0
        1uRqny4EdhdUYgJV0pp5mOgz1AQQDO65WjV/j3JdfvE1MIevukoa5lqNgrgMc4zN7u4dLD
        NDwcB+AKPq7lQyqXl3TPgPGqFdmu7Vc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-497-aChSZ2eYPcWkYTo_ixynCg-1; Thu, 15 Apr 2021 23:24:38 -0400
X-MC-Unique: aChSZ2eYPcWkYTo_ixynCg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B9916501FB;
        Fri, 16 Apr 2021 03:24:35 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-140.pek2.redhat.com [10.72.13.140])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2EA1518B42;
        Fri, 16 Apr 2021 03:24:20 +0000 (UTC)
Subject: Re: [PATCH v6 09/10] vduse: Introduce VDUSE - vDPA Device in
 Userspace
To:     Xie Yongji <xieyongji@bytedance.com>, mst@redhat.com,
        stefanha@redhat.com, sgarzare@redhat.com, parav@nvidia.com,
        hch@infradead.org, christian.brauner@canonical.com,
        rdunlap@infradead.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, axboe@kernel.dk, bcrl@kvack.org,
        corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20210331080519.172-1-xieyongji@bytedance.com>
 <20210331080519.172-10-xieyongji@bytedance.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <87a54b5e-626d-7e04-93f4-f59eddff9947@redhat.com>
Date:   Fri, 16 Apr 2021 11:24:19 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210331080519.172-10-xieyongji@bytedance.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/3/31 ÏÂÎç4:05, Xie Yongji Ð´µÀ:
> +	}
> +	case VDUSE_INJECT_VQ_IRQ:
> +		ret = -EINVAL;
> +		if (arg >= dev->vq_num)
> +			break;
> +
> +		ret = 0;
> +		queue_work(vduse_irq_wq, &dev->vqs[arg].inject);
> +		break;


One additional note:

Please use array_index_nospec() for all vqs[idx] access where idx is 
under the control of userspace to avoid potential spectre exploitation.

Thanks

