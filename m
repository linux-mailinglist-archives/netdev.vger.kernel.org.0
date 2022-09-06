Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA80A5ADCB8
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 02:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232327AbiIFAzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 20:55:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231766AbiIFAzA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 20:55:00 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 552996311
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 17:54:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=RDWZrm0sW2/fNaLbT3ZIlDn7lD/i06NFjk3Y6aHpEaQ=; b=GC4zND91x3ewZppAj42nw0siG+
        jxqTb7gSNkTPKecOc/dNLsjq+dGOe0SR812zW+VpVAYFzsbGqyH1W36UX+3bg/vVDGozuooPHFCY8
        xovI42jC+t4fC6a1UmWNC53Cl+LNsawJm1iJWztUIduzwg4H4xrjcCwzbLiBQ19+AMyE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oVMrh-00FhgY-Lz; Tue, 06 Sep 2022 02:54:57 +0200
Date:   Tue, 6 Sep 2022 02:54:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mengyuan Lou <mengyuanlou@net-swift.com>
Cc:     netdev@vger.kernel.org, jiawenwu@net-swift.com
Subject: Re: [PATCH net-next 01/02] net: ngbe: Initialize sw and reset hw
Message-ID: <YxaaYdAT9QFSr0TV@lunn.ch>
References: <20220905125933.2760-1-mengyuanlou@net-swift.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220905125933.2760-1-mengyuanlou@net-swift.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_osdep.h b/drivers/net/ethernet/wangxun/ngbe/ngbe_osdep.h
> new file mode 100644
> index 000000000000..aa8a3c5211cd
> --- /dev/null
> +++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_osdep.h
> @@ -0,0 +1,31 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * WangXun Gigabit PCI Express Linux driver
> + * Copyright (c) 2019 - 2022 Beijing WangXun Technology Co., Ltd.
> + */
> +
> +#ifndef _NGBE_OSDEP_H_
> +#define _NGBE_OSDEP_H_
> +
> +#include <linux/pci.h>
> +#include <linux/delay.h>
> +#include <linux/interrupt.h>
> +#include <linux/if_ether.h>
> +#include <linux/sched.h>
> +#include <linux/types.h>
> +#include <linux/ctype.h>
> +#include <linux/delay.h>
> +#include <linux/io.h>
> +#include <linux/bitops.h>
> +#include <linux/etherdevice.h>

Same comment as i said to the txgbe driver. The .c files should
include the headers it needs, and only the headers it needs. Don't put
all the includes into one place and slow down the build for everybody.

    Andrew
