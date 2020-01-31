Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AFAB14E827
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 06:13:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbgAaFNS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 00:13:18 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:41240 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725263AbgAaFNS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 00:13:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:References:Cc:To:From:
        Subject:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=NVnsA3lgQnOxibe1eLWi6OoL2Yp9oede8aVfjqOqlkI=; b=RgvO7YDRDIlWCO4ilKNIMWyKB
        HXTP4o0SsAe8lqyFLX7AKBfa492GccM8ZfS7h/OPo0C4Ijhl8QomF2PI2NhL11/fyj5OzuYGwDDra
        vL6xYE1ZwmC8EudMZX0/EIMfunxANPM10WilPgnqE0wUjZUnoV9GvWImPfGYEZ0a7al5a7tnwribn
        tGJYL8wL4sWvPzr9AnjnA/0ZK6AJxJfZQtnyU0cdSOtJ725kJKLopNeLRipXOeT8pTg/URCNAOxlL
        AHnllLkOc1BOAtFbNz/MGmzr8t1B9667HWssRnzW3PNr2ZXP8kq+FHnOkG5fzaGKq0DMPw6M48HXb
        00ahJVGVg==;
Received: from [2601:1c0:6280:3f0:897c:6038:c71d:ecac]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ixOc0-0004Dv-Fr; Fri, 31 Jan 2020 05:13:00 +0000
Subject: Re: [PATCH] vhost: introduce vDPA based backend
From:   Randy Dunlap <rdunlap@infradead.org>
To:     Tiwei Bie <tiwei.bie@intel.com>, mst@redhat.com,
        jasowang@redhat.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        shahafs@mellanox.com, jgg@mellanox.com, rob.miller@broadcom.com,
        haotian.wang@sifive.com, eperezma@redhat.com, lulu@redhat.com,
        parav@mellanox.com, hch@infradead.org, jiri@mellanox.com,
        hanand@xilinx.com, mhabets@solarflare.com,
        maxime.coquelin@redhat.com, lingshan.zhu@intel.com,
        dan.daly@intel.com, cunming.liang@intel.com, zhihong.wang@intel.com
References: <20200131033651.103534-1-tiwei.bie@intel.com>
 <43aeecb4-4c08-df3d-1c1d-699ec4c494bd@infradead.org>
Message-ID: <05e21ed9-d5af-b57c-36cd-50b34915e82d@infradead.org>
Date:   Thu, 30 Jan 2020 21:12:57 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <43aeecb4-4c08-df3d-1c1d-699ec4c494bd@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/30/20 7:56 PM, Randy Dunlap wrote:
> Hi,
> 
> On 1/30/20 7:36 PM, Tiwei Bie wrote:
>> diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
>> index f21c45aa5e07..13e6a94d0243 100644
>> --- a/drivers/vhost/Kconfig
>> +++ b/drivers/vhost/Kconfig
>> @@ -34,6 +34,18 @@ config VHOST_VSOCK
>>  	To compile this driver as a module, choose M here: the module will be called
>>  	vhost_vsock.
>>  
>> +config VHOST_VDPA
>> +	tristate "Vhost driver for vDPA based backend"

oops, missed this one:
	                           vDPA-based

>> +	depends on EVENTFD && VDPA
>> +	select VHOST
>> +	default n
>> +	---help---
>> +	This kernel module can be loaded in host kernel to accelerate
>> +	guest virtio devices with the vDPA based backends.
> 
> 	                              vDPA-based
> 
>> +
>> +	To compile this driver as a module, choose M here: the module
>> +	will be called vhost_vdpa.
>> +
> 
> The preferred Kconfig style nowadays is
> (a) use "help" instead of "---help---"
> (b) indent the help text with one tab + 2 spaces
> 
> and don't use "default n" since that is already the default.
> 
>>  config VHOST
>>  	tristate
>>          depends on VHOST_IOTLB
> 
> thanks.
> 


-- 
~Randy

