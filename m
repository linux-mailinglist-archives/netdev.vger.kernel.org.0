Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 672D4366298
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 01:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234186AbhDTXsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 19:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234444AbhDTXsw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 19:48:52 -0400
Received: from mail.monkeyblade.net (unknown [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ADBBC06174A
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 16:48:18 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id D874F4D2540BB;
        Tue, 20 Apr 2021 16:48:02 -0700 (PDT)
Date:   Tue, 20 Apr 2021 16:48:02 -0700 (PDT)
Message-Id: <20210420.164802.229687091665923532.davem@davemloft.net>
To:     m.chetan.kumar@intel.com
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        johannes@sipsolutions.net, krishna.c.sudi@intel.com,
        linuxwwan@intel.com
Subject: Re: [PATCH V2 02/16] net: iosm: irq handling
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210420161310.16189-3-m.chetan.kumar@intel.com>
References: <20210420161310.16189-1-m.chetan.kumar@intel.com>
        <20210420161310.16189-3-m.chetan.kumar@intel.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Tue, 20 Apr 2021 16:48:03 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: M Chetan Kumar <m.chetan.kumar@intel.com>
Date: Tue, 20 Apr 2021 21:42:56 +0530

> 1) Request interrupt vector, frees allocated resource.
> 2) Registers IRQ handler.
> 
> Signed-off-by: M Chetan Kumar <m.chetan.kumar@intel.com>
> ---
> v2: Streamline multiple returns using goto.
> ---
>  drivers/net/wwan/iosm/iosm_ipc_irq.c | 91 ++++++++++++++++++++++++++++
>  drivers/net/wwan/iosm/iosm_ipc_irq.h | 33 ++++++++++
>  2 files changed, 124 insertions(+)
>  create mode 100644 drivers/net/wwan/iosm/iosm_ipc_irq.c
>  create mode 100644 drivers/net/wwan/iosm/iosm_ipc_irq.h
> 
> diff --git a/drivers/net/wwan/iosm/iosm_ipc_irq.c b/drivers/net/wwan/iosm/iosm_ipc_irq.c
> new file mode 100644
> index 000000000000..a3e017604fa4
> --- /dev/null
> +++ b/drivers/net/wwan/iosm/iosm_ipc_irq.c
> @@ -0,0 +1,91 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2020-21 Intel Corporation.
> + */
> +
> +#include "iosm_ipc_pcie.h"
> +#include "iosm_ipc_protocol.h"
> +
> +static inline void write_dbell_reg(struct iosm_pcie *ipc_pcie, int irq_n,
> +				   u32 data)

Please do not use inline in foo.c files, let the compiler decide.

Thank you.
