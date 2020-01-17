Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E28E11402D8
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 05:14:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729864AbgAQEOr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 23:14:47 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:39392 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729567AbgAQEOr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 23:14:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=GbWbSeaybdoD6jMMHq94tdh3eoDc9qPiy0Usy1cnMeA=; b=nYT6G65EldAx9gyrVCxRahKsW
        mDsaSrnZ+OxrGiew439TJ+Zbcd6J76dXkvaCoES5UNtweoeev2O3AIe1ktz1suXZQUNoiS1bYYeo5
        w05O2Eod2QwlI64dK8ZQeOp2IeCkBbZM5MvyJ6gI4hDMTo2kNrfzKefTbuK7vCDcT+R+cCfCzPLw1
        D1uH9TvlTltAYgaOdflUPs2yTDp1BdQCpIsrs4JxWiDR3FiCAKMf6XYGgLsHIvt7P+oxxk+kKfbSC
        YEwSP4ummhQbZ+6KWFHbB1nvH3HNyqgEFlvhoKxaTPF+YccZ+y3amei/RrlJ90+irMTS/YrSOv1ug
        tFeoVn6wg==;
Received: from [2601:1c0:6280:3f0::ed68]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1isJ1n-00074I-PU; Fri, 17 Jan 2020 04:14:35 +0000
Subject: Re: [PATCH 1/5] vhost: factor out IOTLB
To:     Jason Wang <jasowang@redhat.com>, mst@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     tiwei.bie@intel.com, jgg@mellanox.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        haotian.wang@sifive.com, lingshan.zhu@intel.com,
        eperezma@redhat.com, lulu@redhat.com, parav@mellanox.com,
        kevin.tian@intel.com, stefanha@redhat.com, hch@infradead.org,
        aadam@redhat.com, jakub.kicinski@netronome.com, jiri@mellanox.com,
        shahafs@mellanox.com, hanand@xilinx.com, mhabets@solarflare.com
References: <20200116124231.20253-1-jasowang@redhat.com>
 <20200116124231.20253-2-jasowang@redhat.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <4a577560-d42a-eed2-97a0-42d2f91495e2@infradead.org>
Date:   Thu, 16 Jan 2020 20:14:33 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200116124231.20253-2-jasowang@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/16/20 4:42 AM, Jason Wang wrote:
> diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
> index 3d03ccbd1adc..f21c45aa5e07 100644
> --- a/drivers/vhost/Kconfig
> +++ b/drivers/vhost/Kconfig
> @@ -36,6 +36,7 @@ config VHOST_VSOCK
>  
>  config VHOST
>  	tristate
> +        depends on VHOST_IOTLB
>  	---help---
>  	  This option is selected by any driver which needs to access
>  	  the core of vhost.
> @@ -54,3 +55,9 @@ config VHOST_CROSS_ENDIAN_LEGACY
>  	  adds some overhead, it is disabled by default.
>  
>  	  If unsure, say "N".
> +
> +config VHOST_IOTLB
> +	tristate
> +        default m
> +        help
> +          Generic IOTLB implementation for vhost and vringh.

Use tab + 2 spaces for Kconfig indentation.

-- 
~Randy
Reported-by: Randy Dunlap <rdunlap@infradead.org>
