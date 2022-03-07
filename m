Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9E054CEFB3
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 03:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234113AbiCGCnl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 21:43:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232082AbiCGCnj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 21:43:39 -0500
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 668A9F15;
        Sun,  6 Mar 2022 18:42:44 -0800 (PST)
Received: by mail-vs1-xe29.google.com with SMTP id v62so10248006vsv.1;
        Sun, 06 Mar 2022 18:42:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ar+QRVVMuLb4bneYMxRGAr4Se2zCQinpLClua8RX+Gk=;
        b=TahNPh4NBL+WlB2jnoISG3xkqyuiWcK7SVyRcgOs7wq1BVWPqeBqq7LXs8HKlwqixb
         j/2L6fGtVz9Ex0SYBYvAvIbpUvkn2Ix1X+Ej1AJZYTVPUa5IbC5GyDMBJVyARyl2qGu3
         TqWHFniJpp9nbQQy3igJsMA/uAVkAwGRMyTYUJVAZH7qAOMBEc9vbR8zEymQaEboOBhK
         tGYwmk5AmI+ax/J+JkJNrpyqLAJj09DsQ+MlsI00l5nJ8bhC5Ljv3XZaaOq7TVK7ZXYG
         WMeCPckopbXm3siRjg4m5G8M87putCEzCppnJLgk3K5TQnlQtSFFBZKd2csTN3V/gjup
         iZkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ar+QRVVMuLb4bneYMxRGAr4Se2zCQinpLClua8RX+Gk=;
        b=wo+49Fflb6TvLf3D/v/ZzgEwBUg6kHAQqJPH3sciLg1T7qoQGKsnacWEBpPLVhzwpC
         B6iyycfrHeBLbrjpM66MlW7FiSjzH7RQ/XU63R+ANKVdDtCpKhQICAOVFn7Vy+8KWVLq
         cQc8m3F71b70NUwpMLZnvaWzrxDYQrkUeyayPLsCG5jq9Zwksvq7CNXDO2zSSeF+pyRf
         +quOoBOh8AhNrm7rFUpkcMF0VVrOV9Ktzlqmul2UgBPYDAqaJNo6kZrO9mz50O23D/EI
         I2d+wuTfgAq/g5uSQMWJO1hea7NQKdPAuKIsoc9SjPWAxCyL5VtfhOprJHcSu6h26gl2
         KWWg==
X-Gm-Message-State: AOAM532fG8M12HtmEvfHAUjFxu3fX+p/d2UDUT0Nyj0NvSF/MTNdsTd0
        9/XUqr3zlnPoQKBNMBX4wmxxJ9c9NXIXSWEei0DxADx0GyQ=
X-Google-Smtp-Source: ABdhPJx/N924O1LDHBqPdh1OkqmDTdkdK5O8CjQtWr69AEmAolB2zBPm5JgI3OsRSr3sQcJQpbisH42Lr/xox30muB8=
X-Received: by 2002:a05:6102:38c6:b0:320:797f:bd3a with SMTP id
 k6-20020a05610238c600b00320797fbd3amr3207309vst.39.1646620963431; Sun, 06 Mar
 2022 18:42:43 -0800 (PST)
MIME-Version: 1.0
References: <20220223223326.28021-1-ricardo.martinez@linux.intel.com> <20220223223326.28021-3-ricardo.martinez@linux.intel.com>
In-Reply-To: <20220223223326.28021-3-ricardo.martinez@linux.intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Mon, 7 Mar 2022 05:42:52 +0300
Message-ID: <CAHNKnsTtMG_gUgmbO9yuENO8wm=+wUbr+N9oX8_ZbkjF7iaT-g@mail.gmail.com>
Subject: Re: [PATCH net-next v5 02/13] net: wwan: t7xx: Add control DMA interface
To:     Ricardo Martinez <ricardo.martinez@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        chandrashekar.devegowda@intel.com,
        Intel Corporation <linuxwwan@intel.com>,
        chiranjeevi.rapolu@linux.intel.com,
        =?UTF-8?B?SGFpanVuIExpdSAo5YiY5rW35YabKQ==?= 
        <haijun.liu@mediatek.com>, amir.hanania@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        ilpo.johannes.jarvinen@intel.com, moises.veleta@intel.com,
        pierre-louis.bossart@intel.com, muralidharan.sethuraman@intel.com,
        Soumya.Prakash.Mishra@intel.com, sreehari.kancharla@intel.com,
        madhusmita.sahu@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 24, 2022 at 1:35 AM Ricardo Martinez
<ricardo.martinez@linux.intel.com> wrote:
> From: Haijun Liu <haijun.liu@mediatek.com>
>
> Cross Layer DMA (CLDMA) Hardware interface (HIF) enables the control
> path of Host-Modem data transfers. CLDMA HIF layer provides a common
> interface to the Port Layer.
>
> CLDMA manages 8 independent RX/TX physical channels with data flow
> control in HW queues. CLDMA uses ring buffers of General Packet
> Descriptors (GPD) for TX/RX. GPDs can represent multiple or single
> data buffers (DB).
>
> CLDMA HIF initializes GPD rings, registers ISR handlers for CLDMA
> interrupts, and initializes CLDMA HW registers.
>
> CLDMA TX flow:
> 1. Port Layer write
> 2. Get DB address
> 3. Configure GPD
> 4. Triggering processing via HW register write
>
> CLDMA RX flow:
> 1. CLDMA HW sends a RX "done" to host
> 2. Driver starts thread to safely read GPD
> 3. DB is sent to Port layer
> 4. Create a new buffer for GPD ring
>
> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
> Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
>
> From a WWAN framework perspective:
> Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
> ---
>  drivers/net/wwan/t7xx/t7xx_cldma.c     |  281 ++++++
>  drivers/net/wwan/t7xx/t7xx_cldma.h     |  176 ++++
>  drivers/net/wwan/t7xx/t7xx_common.h    |   40 +
>  drivers/net/wwan/t7xx/t7xx_hif_cldma.c | 1204 ++++++++++++++++++++++++
>  drivers/net/wwan/t7xx/t7xx_hif_cldma.h |  141 +++
>  drivers/net/wwan/t7xx/t7xx_reg.h       |   33 +
>  6 files changed, 1875 insertions(+)
>  create mode 100644 drivers/net/wwan/t7xx/t7xx_cldma.c
>  create mode 100644 drivers/net/wwan/t7xx/t7xx_cldma.h
>  create mode 100644 drivers/net/wwan/t7xx/t7xx_common.h
>  create mode 100644 drivers/net/wwan/t7xx/t7xx_hif_cldma.c
>  create mode 100644 drivers/net/wwan/t7xx/t7xx_hif_cldma.h
>  create mode 100644 drivers/net/wwan/t7xx/t7xx_reg.h
>
> diff --git a/drivers/net/wwan/t7xx/t7xx_cldma.c b/drivers/net/wwan/t7xx/t7xx_cldma.c
> new file mode 100644
> index 000000000000..2713d9a6034b
> --- /dev/null
> +++ b/drivers/net/wwan/t7xx/t7xx_cldma.c
> @@ -0,0 +1,281 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (c) 2021, MediaTek Inc.
> + * Copyright (c) 2021-2022, Intel Corporation.
> + *
> + * Authors:
> + *  Haijun Liu <haijun.liu@mediatek.com>
> + *  Moises Veleta <moises.veleta@intel.com>
> + *  Ricardo Martinez<ricardo.martinez@linux.intel.com>

The space is missed between name and email. The same issue repeated in
every file of the series.

[skipped]

> +#ifdef NET_SKBUFF_DATA_USES_OFFSET
> +static inline unsigned int t7xx_skb_data_area_size(struct sk_buff *skb)
> +{
> +       return skb->head + skb->end - skb->data;
> +}
> +#else
> +static inline unsigned int t7xx_skb_data_area_size(struct sk_buff *skb)
> +{
> +       return skb->end - skb->data;
> +}
> +#endif

You can use skb_end_pointer() to avoid conditional compilation.

--
Sergey
