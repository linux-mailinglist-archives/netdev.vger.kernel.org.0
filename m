Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB54C84522
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 09:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727603AbfHGHFz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 03:05:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53926 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727436AbfHGHFz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Aug 2019 03:05:55 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7D78E81F25;
        Wed,  7 Aug 2019 07:05:55 +0000 (UTC)
Received: from [10.72.12.139] (ovpn-12-139.pek2.redhat.com [10.72.12.139])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E3D841000324;
        Wed,  7 Aug 2019 07:05:50 +0000 (UTC)
Subject: Re: [PATCH V3 01/10] vhost: disable metadata prefetch optimization
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org, jgg@ziepe.ca
References: <20190807065449.23373-1-jasowang@redhat.com>
 <20190807065449.23373-2-jasowang@redhat.com>
Message-ID: <a084127d-4acb-dceb-3bb6-617eb79734e4@redhat.com>
Date:   Wed, 7 Aug 2019 15:05:49 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190807065449.23373-2-jasowang@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Wed, 07 Aug 2019 07:05:55 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/8/7 下午2:54, Jason Wang wrote:
> From: "Michael S. Tsirkin" <mst@redhat.com>
>
> This seems to cause guest and host memory corruption.
> Disable for now until we get a better handle on that.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>   drivers/vhost/vhost.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> index 819296332913..42a8c2a13ab1 100644
> --- a/drivers/vhost/vhost.h
> +++ b/drivers/vhost/vhost.h
> @@ -96,7 +96,7 @@ struct vhost_uaddr {
>   };
>   
>   #if defined(CONFIG_MMU_NOTIFIER) && ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE == 0
> -#define VHOST_ARCH_CAN_ACCEL_UACCESS 1
> +#define VHOST_ARCH_CAN_ACCEL_UACCESS 0
>   #else
>   #define VHOST_ARCH_CAN_ACCEL_UACCESS 0
>   #endif


Oops, this is unnecessary.

Will post V4.

Thanks

