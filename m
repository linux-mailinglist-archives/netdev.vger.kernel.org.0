Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F241274EA8
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 03:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727231AbgIWBop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 21:44:45 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:13827 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726992AbgIWBon (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Sep 2020 21:44:43 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 802CD83C44DD7ABFB3C0;
        Wed, 23 Sep 2020 09:44:40 +0800 (CST)
Received: from [10.174.179.238] (10.174.179.238) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Wed, 23 Sep 2020 09:44:39 +0800
Subject: Re: [PATCH -next v2] net: ice: Fix pointer cast warnings
From:   Bixuan Cui <cuibixuan@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <jeffrey.t.kirsher@intel.com>, <intel-wired-lan@lists.osuosl.org>,
        <netdev@vger.kernel.org>, <linux-next@vger.kernel.org>
References: <20200731105721.18511-1-cuibixuan@huawei.com>
 <5af7c5af-c45d-2174-de89-8b89eddb4f4d@huawei.com>
Message-ID: <9ba08d48-a192-bf9d-b37e-e7f3c9699970@huawei.com>
Date:   Wed, 23 Sep 2020 09:44:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <5af7c5af-c45d-2174-de89-8b89eddb4f4d@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.238]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ping~

On 2020/7/31 18:07, Bixuan Cui wrote:
> pointers should be casted to unsigned long to avoid
> -Wpointer-to-int-cast warnings:
> 
> drivers/net/ethernet/intel/ice/ice_flow.h:197:33: warning:
>     cast from pointer to integer of different size
> drivers/net/ethernet/intel/ice/ice_flow.h:198:32: warning:
>     cast to pointer from integer of different size
> 
> Signed-off-by: Bixuan Cui <cuibixuan@huawei.com>
> ---
> v2->v1: add fix:
>  ice_flow.h:198:32: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
>  #define ICE_FLOW_ENTRY_PTR(h) ((struct ice_flow_entry *)(h))
> 
>  drivers/net/ethernet/intel/ice/ice_flow.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_flow.h b/drivers/net/ethernet/intel/ice/ice_flow.h
> index 3913da2116d2..829f90b1e998 100644
> --- a/drivers/net/ethernet/intel/ice/ice_flow.h
> +++ b/drivers/net/ethernet/intel/ice/ice_flow.h
> @@ -194,8 +194,8 @@ struct ice_flow_entry {
>  	u16 entry_sz;
>  };
> 
> -#define ICE_FLOW_ENTRY_HNDL(e)	((u64)e)
> -#define ICE_FLOW_ENTRY_PTR(h)	((struct ice_flow_entry *)(h))
> +#define ICE_FLOW_ENTRY_HNDL(e)	((u64)(uintptr_t)e)
> +#define ICE_FLOW_ENTRY_PTR(h)	((struct ice_flow_entry *)(uintptr_t)(h))
> 
>  struct ice_flow_prof {
>  	struct list_head l_entry;
> --
> 2.17.1
> 
> 
> .
> 
