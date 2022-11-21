Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C761632EA4
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 22:18:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231483AbiKUVSr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 16:18:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231478AbiKUVS3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 16:18:29 -0500
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D462E2182C;
        Mon, 21 Nov 2022 13:18:28 -0800 (PST)
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 2ALLHg8S084328;
        Mon, 21 Nov 2022 15:17:42 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1669065462;
        bh=TbniS6q8IOVpe6hMO0iKFMkncuMMyTnXD2aCBhSgQwE=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=R4HiWvxxPiiah9vl1KnDRvCQ4Ihdn9mCvZj7yjZpYuzVpVCLXCt6XkjksVX8kvuBf
         749sg4IhS2EHH0BW31/vm4dulsIRi01yaWPPkYj+1JUgH4fVgsiBwAk3sa4/1taIhF
         jo74FxSyvYHbC2M0YCp8zy1CV9a3VoKzC9YeIa7c=
Received: from DLEE103.ent.ti.com (dlee103.ent.ti.com [157.170.170.33])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 2ALLHgmi092945
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 21 Nov 2022 15:17:42 -0600
Received: from DLEE105.ent.ti.com (157.170.170.35) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Mon, 21
 Nov 2022 15:17:41 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Mon, 21 Nov 2022 15:17:41 -0600
Received: from [10.250.38.44] (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 2ALLHdxV081189;
        Mon, 21 Nov 2022 15:17:40 -0600
Message-ID: <68ceddec-7af9-983d-c8be-7e0dc109df88@ti.com>
Date:   Mon, 21 Nov 2022 15:17:39 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 01/18] block/rnbd: fix mixed module-builtin object
Content-Language: en-US
To:     Alexander Lobakin <alobakin@pm.me>, <linux-kbuild@vger.kernel.org>
CC:     Masahiro Yamada <masahiroy@kernel.org>,
        Nicolas Schier <nicolas@fjasle.eu>,
        Jens Axboe <axboe@kernel.dk>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        "Vladimir Oltean" <vladimir.oltean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Derek Chickles <dchickles@marvell.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Daniel Scally <djrscally@gmail.com>,
        "Hans de Goede" <hdegoede@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        NXP Linux Team <linux-imx@nxp.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20221119225650.1044591-1-alobakin@pm.me>
 <20221119225650.1044591-2-alobakin@pm.me>
From:   Andrew Davis <afd@ti.com>
In-Reply-To: <20221119225650.1044591-2-alobakin@pm.me>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/19/22 5:04 PM, Alexander Lobakin wrote:
> From: Masahiro Yamada <masahiroy@kernel.org>
> 
> With CONFIG_BLK_DEV_RNBD_CLIENT=m and CONFIG_BLK_DEV_RNBD_SERVER=y
> (or vice versa), rnbd-common.o is linked to a module and also to
> vmlinux even though CFLAGS are different between builtins and modules.
> 
> This is the same situation as fixed by commit 637a642f5ca5 ("zstd:
> Fixing mixed module-builtin objects").
> 
> Turn rnbd_access_mode_str() into an inline function.
> 

Why inline? All you should need is "static" to keep these internal to
each compilation unit. Inline also bloats the object files when the
function is called from multiple places. Let the compiler decide when
to inline.

Andrew

> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> Reviewed-and-tested-by: Alexander Lobakin <alobakin@pm.me>
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>
> ---
>   drivers/block/rnbd/Makefile      |  6 ++----
>   drivers/block/rnbd/rnbd-common.c | 23 -----------------------
>   drivers/block/rnbd/rnbd-proto.h  | 14 +++++++++++++-
>   3 files changed, 15 insertions(+), 28 deletions(-)
>   delete mode 100644 drivers/block/rnbd/rnbd-common.c
> 
> diff --git a/drivers/block/rnbd/Makefile b/drivers/block/rnbd/Makefile
> index 40b31630822c..208e5f865497 100644
> --- a/drivers/block/rnbd/Makefile
> +++ b/drivers/block/rnbd/Makefile
> @@ -3,13 +3,11 @@
>   ccflags-y := -I$(srctree)/drivers/infiniband/ulp/rtrs
> 
>   rnbd-client-y := rnbd-clt.o \
> -		  rnbd-clt-sysfs.o \
> -		  rnbd-common.o
> +		  rnbd-clt-sysfs.o
> 
>   CFLAGS_rnbd-srv-trace.o = -I$(src)
> 
> -rnbd-server-y := rnbd-common.o \
> -		  rnbd-srv.o \
> +rnbd-server-y := rnbd-srv.o \
>   		  rnbd-srv-sysfs.o \
>   		  rnbd-srv-trace.o
> 
> diff --git a/drivers/block/rnbd/rnbd-common.c b/drivers/block/rnbd/rnbd-common.c
> deleted file mode 100644
> index 596c3f732403..000000000000
> --- a/drivers/block/rnbd/rnbd-common.c
> +++ /dev/null
> @@ -1,23 +0,0 @@
> -// SPDX-License-Identifier: GPL-2.0-or-later
> -/*
> - * RDMA Network Block Driver
> - *
> - * Copyright (c) 2014 - 2018 ProfitBricks GmbH. All rights reserved.
> - * Copyright (c) 2018 - 2019 1&1 IONOS Cloud GmbH. All rights reserved.
> - * Copyright (c) 2019 - 2020 1&1 IONOS SE. All rights reserved.
> - */
> -#include "rnbd-proto.h"
> -
> -const char *rnbd_access_mode_str(enum rnbd_access_mode mode)
> -{
> -	switch (mode) {
> -	case RNBD_ACCESS_RO:
> -		return "ro";
> -	case RNBD_ACCESS_RW:
> -		return "rw";
> -	case RNBD_ACCESS_MIGRATION:
> -		return "migration";
> -	default:
> -		return "unknown";
> -	}
> -}
> diff --git a/drivers/block/rnbd/rnbd-proto.h b/drivers/block/rnbd/rnbd-proto.h
> index ea7ac8bca63c..1849e7039fa1 100644
> --- a/drivers/block/rnbd/rnbd-proto.h
> +++ b/drivers/block/rnbd/rnbd-proto.h
> @@ -300,6 +300,18 @@ static inline u32 rq_to_rnbd_flags(struct request *rq)
>   	return rnbd_opf;
>   }
> 
> -const char *rnbd_access_mode_str(enum rnbd_access_mode mode);
> +static inline const char *rnbd_access_mode_str(enum rnbd_access_mode mode)
> +{
> +	switch (mode) {
> +	case RNBD_ACCESS_RO:
> +		return "ro";
> +	case RNBD_ACCESS_RW:
> +		return "rw";
> +	case RNBD_ACCESS_MIGRATION:
> +		return "migration";
> +	default:
> +		return "unknown";
> +	}
> +}
> 
>   #endif /* RNBD_PROTO_H */
> --
> 2.38.1
> 
> 
