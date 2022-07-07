Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2156056A5C6
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 16:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231985AbiGGOqW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 10:46:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbiGGOqV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 10:46:21 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B075926115;
        Thu,  7 Jul 2022 07:46:20 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D784E113E;
        Thu,  7 Jul 2022 07:46:20 -0700 (PDT)
Received: from [10.57.85.108] (unknown [10.57.85.108])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8D6E43F66F;
        Thu,  7 Jul 2022 07:46:19 -0700 (PDT)
Message-ID: <435b8da4-0db0-9111-badd-3fbdfd6045d5@arm.com>
Date:   Thu, 7 Jul 2022 15:46:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] vdpa: Use device_iommu_capable()
Content-Language: en-GB
From:   Robin Murphy <robin.murphy@arm.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
References: <548e316fa282ce513fabb991a4c4d92258062eb5.1654688822.git.robin.murphy@arm.com>
In-Reply-To: <548e316fa282ce513fabb991a4c4d92258062eb5.1654688822.git.robin.murphy@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-06-08 12:48, Robin Murphy wrote:
> Use the new interface to check the capability for our device
> specifically.

Just checking in case this got lost - vdpa is now the only remaining 
iommu_capable() user in linux-next, and I'd like to be able to remove 
the old interface next cycle.

Thanks,
Robin.

> Signed-off-by: Robin Murphy <robin.murphy@arm.com>
> ---
>   drivers/vhost/vdpa.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 935a1d0ddb97..4cfebcc24a03 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -1074,7 +1074,7 @@ static int vhost_vdpa_alloc_domain(struct vhost_vdpa *v)
>   	if (!bus)
>   		return -EFAULT;
>   
> -	if (!iommu_capable(bus, IOMMU_CAP_CACHE_COHERENCY))
> +	if (!device_iommu_capable(dma_dev, IOMMU_CAP_CACHE_COHERENCY))
>   		return -ENOTSUPP;
>   
>   	v->domain = iommu_domain_alloc(bus);
