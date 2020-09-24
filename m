Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD0A2775BC
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 17:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728527AbgIXPrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 11:47:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728139AbgIXPrO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 11:47:14 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21F88C0613CE;
        Thu, 24 Sep 2020 08:47:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=qc5JXV13U/VUfIz1+Qfz+XAsujxBI5R8St3MEEbVRIg=; b=YC+WDN2UsHdLRUqIPkY6NU1zOq
        pTOI48Y3JjopfrDzA9z5xfIMpsqQe9fZyAAljojPJPl82x5S7OxCY/f5tcVwxF+CU7J24FgvrgIGX
        J2HLoOavodyTdMdX904oNPA+q4s0/PrkI1BLTKM87xoKtv+o1ZzAYqevLHci9oeF56jbb9GyuysNt
        Jpi1H6Oi1tdgQMSkeeKjdUaj8n/fUJWx+bl+WBl36MUEffKTdbg22WbpwFwKHy3bXWfSGWRRHa6tR
        Tuw+E1eKhss7s1AnhVCdiffZPnAwFX3k2UZ1x6bcFrnUoiFc8Q7tuTtAcrWLhimWR6WI32EQqWGeR
        tUzQDpyQ==;
Received: from [2601:1c0:6280:3f0::19c2]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kLTSg-0002U1-05; Thu, 24 Sep 2020 15:47:10 +0000
Subject: Re: [PATCH v3 -next] vdpa: mlx5: change Kconfig depends to fix build
 errors
To:     Eli Cohen <elic@nvidia.com>, "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        virtualization@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
References: <73f7e48b-8d16-6b20-07d3-41dee0e3d3bd@infradead.org>
 <20200918082245.GP869610@unreal>
 <20200924052932-mutt-send-email-mst@kernel.org>
 <20200924102413.GD170403@mtl-vdi-166.wap.labs.mlnx>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <079c831e-214d-22c1-028e-05d84e3b7f04@infradead.org>
Date:   Thu, 24 Sep 2020 08:47:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200924102413.GD170403@mtl-vdi-166.wap.labs.mlnx>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/24/20 3:24 AM, Eli Cohen wrote:
> On Thu, Sep 24, 2020 at 05:30:55AM -0400, Michael S. Tsirkin wrote:
>>>> --- linux-next-20200917.orig/drivers/vdpa/Kconfig
>>>> +++ linux-next-20200917/drivers/vdpa/Kconfig
>>>> @@ -31,7 +31,7 @@ config IFCVF
>>>>
>>>>  config MLX5_VDPA
>>>>  	bool "MLX5 VDPA support library for ConnectX devices"
>>>> -	depends on MLX5_CORE
>>>> +	depends on VHOST_IOTLB && MLX5_CORE
>>>>  	default n
>>>
>>> While we are here, can anyone who apply this patch delete the "default n" line?
>>> It is by default "n".
> 
> I can do that
> 
>>>
>>> Thanks
>>
>> Hmm other drivers select VHOST_IOTLB, why not do the same?

v1 used select, but Saeed requested use of depends instead because
select can cause problems.

> I can't see another driver doing that. Perhaps I can set dependency on
> VHOST which by itself depends on VHOST_IOTLB?
>>
>>
>>>>  	help
>>>>  	  Support library for Mellanox VDPA drivers. Provides code that is
>>>>
>>


-- 
~Randy

