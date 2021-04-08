Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E978359093
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 01:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233036AbhDHXqi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 19:46:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232488AbhDHXqg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 19:46:36 -0400
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B98B2C061760;
        Thu,  8 Apr 2021 16:46:24 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id D2E474D24927D;
        Thu,  8 Apr 2021 16:46:22 -0700 (PDT)
Date:   Thu, 08 Apr 2021 16:46:18 -0700 (PDT)
Message-Id: <20210408.164618.597563844564989065.davem@davemloft.net>
To:     decui@microsoft.com
Cc:     kuba@kernel.org, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, wei.liu@kernel.org, liuwe@microsoft.com,
        netdev@vger.kernel.org, leon@kernel.org, andrew@lunn.ch,
        bernd@petrovitsch.priv.at, rdunlap@infradead.org,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org
Subject: Re: [PATCH v3 net-next] net: mana: Add a driver for Microsoft
 Azure Network Adapter (MANA)
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210408225840.26304-1-decui@microsoft.com>
References: <20210408225840.26304-1-decui@microsoft.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Thu, 08 Apr 2021 16:46:23 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dexuan Cui <decui@microsoft.com>
Date: Thu,  8 Apr 2021 15:58:40 -0700

> +struct gdma_msg_hdr {
> +	u32 hdr_type;
> +	u32 msg_type;
> +	u16 msg_version;
> +	u16 hwc_msg_id;
> +	u32 msg_size;
> +} __packed;
> +
> +struct gdma_dev_id {
> +	union {
> +		struct {
> +			u16 type;
> +			u16 instance;
> +		};
> +
> +		u32 as_uint32;
> +	};
> +} __packed;

Please don't  use __packed unless absolutely necessary.  It generates suboptimal code (byte at a time
accesses etc.) and for many of these you don't even need it.

Thank you.
