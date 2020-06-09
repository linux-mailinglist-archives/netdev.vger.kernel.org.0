Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5623B1F33A1
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 07:53:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbgFIFxU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 01:53:20 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:47054 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726120AbgFIFxT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 01:53:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591681998;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T/2A/WU2/svppr3uz/G5VVDxLgqlNP79/92mX4BoUzs=;
        b=LCQeUIoAF4mhb9gLr/WDJkE/X9QKY2JqWgEhpncVMWf76UMKTffu+2+zXuc0wdfRGlnnHo
        +hiwSwQsbfzprWivguyfRYcIL4taxPa1YAfhIIiJeugKj5x2vt3p+u6muctHOxbjE0SK6G
        M0e+2XaoFCazDNbo9P58dtPwIpYrWew=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-290-7lBnAItnOB6WES0WKXa7sA-1; Tue, 09 Jun 2020 01:53:16 -0400
X-MC-Unique: 7lBnAItnOB6WES0WKXa7sA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 32E871005510;
        Tue,  9 Jun 2020 05:53:15 +0000 (UTC)
Received: from [10.72.12.252] (ovpn-12-252.pek2.redhat.com [10.72.12.252])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E327510013D6;
        Tue,  9 Jun 2020 05:53:05 +0000 (UTC)
Subject: Re: [PATCH] vhost/test: fix up after API change
To:     "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc:     Zhu Lingshan <lingshan.zhu@intel.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <20200608124254.727184-1-mst@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <e747a953-3135-fef9-b098-fca11755d6e4@redhat.com>
Date:   Tue, 9 Jun 2020 13:53:03 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200608124254.727184-1-mst@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/6/8 下午8:42, Michael S. Tsirkin wrote:
> Pass a flag to request kernel thread use.
>
> Fixes: 01fcb1cbc88e ("vhost: allow device that does not depend on vhost worker")
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>   drivers/vhost/test.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
> index f55cb584b84a..12304eb8da15 100644
> --- a/drivers/vhost/test.c
> +++ b/drivers/vhost/test.c
> @@ -122,7 +122,7 @@ static int vhost_test_open(struct inode *inode, struct file *f)
>   	vqs[VHOST_TEST_VQ] = &n->vqs[VHOST_TEST_VQ];
>   	n->vqs[VHOST_TEST_VQ].handle_kick = handle_vq_kick;
>   	vhost_dev_init(dev, vqs, VHOST_TEST_VQ_MAX, UIO_MAXIOV + 64,
> -		       VHOST_TEST_PKT_WEIGHT, VHOST_TEST_WEIGHT, NULL);
> +		       VHOST_TEST_PKT_WEIGHT, VHOST_TEST_WEIGHT, true, NULL);
>   
>   	f->private_data = n;
>   


Acked-by: Jason Wang <jasowang@redhat.com>

Just to confirm, have you queued the doorbell mapping patches already? 
Or you expect I squash this into v2 of doorbell mapping series?

Thanks

