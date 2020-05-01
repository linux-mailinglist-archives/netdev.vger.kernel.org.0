Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0471C2089
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 00:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbgEAWZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 18:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbgEAWZO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 18:25:14 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ED8DC061A0C;
        Fri,  1 May 2020 15:25:14 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2D7D214F4664B;
        Fri,  1 May 2020 15:25:13 -0700 (PDT)
Date:   Fri, 01 May 2020 15:25:12 -0700 (PDT)
Message-Id: <20200501.152512.965649225646550457.davem@davemloft.net>
To:     natechancellor@gmail.com
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com, samitolvanen@google.com
Subject: Re: [PATCH v2] hv_netvsc: Fix netvsc_start_xmit's return type
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200428175455.2109973-1-natechancellor@gmail.com>
References: <20200428100828.aslw3pn5nhwtlsnt@liuwe-devbox-debian-v2.j3c5onc20sse1dnehy4noqpfcg.zx.internal.cloudapp.net>
        <20200428175455.2109973-1-natechancellor@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 01 May 2020 15:25:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>
Date: Tue, 28 Apr 2020 10:54:56 -0700

> netvsc_start_xmit is used as a callback function for the ndo_start_xmit
> function pointer. ndo_start_xmit's return type is netdev_tx_t but
> netvsc_start_xmit's return type is int.
> 
> This causes a failure with Control Flow Integrity (CFI), which requires
> function pointer prototypes and callback function definitions to match
> exactly. When CFI is in enforcing, the kernel panics. When booting a
> CFI kernel with WSL 2, the VM is immediately terminated because of this.
> 
> The splat when CONFIG_CFI_PERMISSIVE is used:
 ...
> Avoid this by using the right return type for netvsc_start_xmit.
> 
> Fixes: fceaf24a943d8 ("Staging: hv: add the Hyper-V virtual network driver")
> Link: https://github.com/ClangBuiltLinux/linux/issues/1009
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

Applied.
