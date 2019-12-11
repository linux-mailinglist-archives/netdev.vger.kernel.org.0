Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0AD11ABEA
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 14:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729524AbfLKNUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 08:20:11 -0500
Received: from lelv0143.ext.ti.com ([198.47.23.248]:39256 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729415AbfLKNUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 08:20:11 -0500
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id xBBDK4vN099616;
        Wed, 11 Dec 2019 07:20:04 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1576070404;
        bh=GkhHaPX9UDNVUYDu93wWRNflhV/Vz2l5vZp7YzYxuYQ=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=FfJgOOluYkKqpDli4kXsWHirurmSnFSzU8sydhPy+xpmaZt/61syyf/wC8IouSpQR
         emEEdpzQmC4uNwvnPqhB6B9qU3grWeB47hzosPAHAc3uwD1yPft1CvTqKp3xKKcmbu
         sWmkbwaqS1j4gbYX0/OusjQWUgkgHseWp9H455wM=
Received: from DLEE115.ent.ti.com (dlee115.ent.ti.com [157.170.170.26])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id xBBDK4sE085099
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 11 Dec 2019 07:20:04 -0600
Received: from DLEE113.ent.ti.com (157.170.170.24) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Wed, 11
 Dec 2019 07:20:04 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Wed, 11 Dec 2019 07:20:04 -0600
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id xBBDK2lH040964;
        Wed, 11 Dec 2019 07:20:02 -0600
Subject: Re: [PATCH 2/2] net: ethernet: ti: build cpsw-common for switchdev
To:     Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>
CC:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Andrew Lunn <andrew@lunn.ch>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20191211125643.1987157-1-arnd@arndb.de>
 <20191211125643.1987157-2-arnd@arndb.de>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <e6d7c4ec-dd85-e979-bc9f-49f5b0637447@ti.com>
Date:   Wed, 11 Dec 2019 15:19:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191211125643.1987157-2-arnd@arndb.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/12/2019 14:56, Arnd Bergmann wrote:
> Without the common part of the driver, the new file fails to link:
> 
> drivers/net/ethernet/ti/cpsw_new.o: In function `cpsw_probe':
> cpsw_new.c:(.text+0x312c): undefined reference to `ti_cm_get_macid'
> 
> Use the same Makefile hack as before, and build cpsw-common.o for
> any driver that needs it.
> 
> Fixes: ed3525eda4c4 ("net: ethernet: ti: introduce cpsw switchdev based driver part 1 - dual-emac")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>   drivers/net/ethernet/ti/Makefile | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/ti/Makefile b/drivers/net/ethernet/ti/Makefile
> index d34df8e5cf94..ecf776ad8689 100644
> --- a/drivers/net/ethernet/ti/Makefile
> +++ b/drivers/net/ethernet/ti/Makefile
> @@ -5,6 +5,7 @@
>   
>   obj-$(CONFIG_TI_CPSW) += cpsw-common.o
>   obj-$(CONFIG_TI_DAVINCI_EMAC) += cpsw-common.o
> +obj-$(CONFIG_TI_CPSW_SWITCHDEV) += cpsw-common.o
>   
>   obj-$(CONFIG_TLAN) += tlan.o
>   obj-$(CONFIG_CPMAC) += cpmac.o
> 

Reviewed-by: Grygorii Strashko <grygorii.strashko@ti.com>

-- 
Best regards,
grygorii
