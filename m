Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C47368BC32
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 13:00:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbjBFMAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 07:00:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbjBFMAd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 07:00:33 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48CFE12F28;
        Mon,  6 Feb 2023 04:00:32 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id ba1so6061706wrb.5;
        Mon, 06 Feb 2023 04:00:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OXIJO9fqX0/0Oi7czvNdityyIiS9SUbgNGdknS3wTOo=;
        b=dH217lg8N89Mqn2cQB8kM9xXVI1u1UpAmXhovfb0BxyYbQGxhsh4N6sNKN/WLviwAu
         p4lJYAxnE9VWFYwLjX2dVvPuBsf6B2KFntinHSFxEkTpjJsSlsiKVomIlGKYP6qdXG+c
         /QRiAyoy24s3ViYbiAj9TzE6f+mn7s/hua/sAwuxe85cP/qTT4+EC2EQOoWC4gU0Pmqu
         OF4+5YUObGQgVn74LGjlVdVbJBOKUFbwUPGx5BmHCs2bHuvReB4ijL6ud3t+2yC3G7yU
         T3iOG39/Qsb0tVAa6I5LGiryIK5XgMQhZmrGShJmmLXxHJMUlVIrShQEhAeHvfH1n5dZ
         mH9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OXIJO9fqX0/0Oi7czvNdityyIiS9SUbgNGdknS3wTOo=;
        b=Lxh1PF092r5BoCw6d/bBlEafofoDz71Gklb+JoppRLU4von8QaPxuuAsOLc/tecsyd
         /rOJQm2szcxRn5sL5Ei/Ae/o6ocndaTod1MIVNDytcWUNyLp86YDvObkQz7Ob5rz2Qe+
         3ohlj8hdCQXYRobDQ1/1+nNrTw8ye/dlT7xUNnXaaOXwNFEVe6uY6oxLDVcMgbSeBNnV
         PTCZn+pCoYypcaoO0+E3khTdgkhaWuYh/BC8yvioaUhFFtOkHRxJMM9xpah3Z71EvMml
         Bhm6WQ6ltDuxmgKscQLrBFX2aWwaL/+ZQVN4HA6oSt2GsjRBWH4rSLr7aBw6lzUEv8lp
         CXWA==
X-Gm-Message-State: AO0yUKU0N3+aTXAGxNpA+gMsTvE0rFfyDLr/rdFzqxpYsRXbI7bEfSAC
        8IstzmgRvz1gVWPuBWgyMsk=
X-Google-Smtp-Source: AK7set+/VGsrQ72kSq4lDohUDJph/RPl5pOdU8s1PNKR9uVVcxf9v/28mEUYpFOuF/NEZtmUetOlVQ==
X-Received: by 2002:a05:6000:3:b0:2c3:e7a7:3886 with SMTP id h3-20020a056000000300b002c3e7a73886mr3645951wrx.5.1675684830817;
        Mon, 06 Feb 2023 04:00:30 -0800 (PST)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id o2-20020a05600002c200b002bde537721dsm8912829wry.20.2023.02.06.04.00.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Feb 2023 04:00:30 -0800 (PST)
Subject: Re: [PATCH v5 net-next 1/8] sfc: add devlink support for ef100
To:     alejandro.lucero-palau@amd.com, netdev@vger.kernel.org,
        linux-net-drivers@amd.com
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, habetsm.xilinx@gmail.com,
        linux-doc@vger.kernel.org, corbet@lwn.net, jiri@nvidia.com
References: <20230202111423.56831-1-alejandro.lucero-palau@amd.com>
 <20230202111423.56831-2-alejandro.lucero-palau@amd.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <66a5d1bc-2220-4298-b166-b41f17508599@gmail.com>
Date:   Mon, 6 Feb 2023 12:00:29 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20230202111423.56831-2-alejandro.lucero-palau@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/02/2023 11:14, alejandro.lucero-palau@amd.com wrote:
> From: Alejandro Lucero <alejandro.lucero-palau@amd.com>
> 
> Basic devlink infrastructure support.
> 
> Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com>
...
> diff --git a/drivers/net/ethernet/sfc/efx_devlink.c b/drivers/net/ethernet/sfc/efx_devlink.c
> new file mode 100644
> index 000000000000..933e60876a93
> --- /dev/null
> +++ b/drivers/net/ethernet/sfc/efx_devlink.c
> @@ -0,0 +1,71 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/****************************************************************************
> + * Driver for AMD network controllers and boards
> + * Copyright (C) 2023, Advanced Micro Devices, Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published
> + * by the Free Software Foundation, incorporated herein by reference.
> + */
> +
> +#include <linux/rtc.h>
> +#include "net_driver.h"
> +#include "ef100_nic.h"
> +#include "efx_devlink.h"
> +#include "nic.h"
> +#include "mcdi.h"
> +#include "mcdi_functions.h"
> +#include "mcdi_pcol.h"
nit: as far as I can tell, most of these includes aren't used until
 the next patch (rtc, mcdi*, possibly *nic too) and should thus only
 be added there.  If you're respinning anyway, may as well fix it.
