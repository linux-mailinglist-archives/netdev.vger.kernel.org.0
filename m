Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4100F349AE8
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 21:17:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbhCYURJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 16:17:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbhCYURC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 16:17:02 -0400
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B84C06174A
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 13:17:02 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id D2B4B4D25213B;
        Thu, 25 Mar 2021 13:17:00 -0700 (PDT)
Date:   Thu, 25 Mar 2021 13:16:57 -0700 (PDT)
Message-Id: <20210325.131657.226015113506997776.davem@davemloft.net>
To:     linux@roeck-us.net
Cc:     yangbo.lu@nxp.com, netdev@vger.kernel.org, richardcochran@gmail.com
Subject: Re: [PATCH] ptp_qoriq: fix overflow in ptp_qoriq_adjfine() u64
 calcalation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210325102307.GA163632@roeck-us.net>
References: <20210323080229.28283-1-yangbo.lu@nxp.com>
        <20210325102307.GA163632@roeck-us.net>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Thu, 25 Mar 2021 13:17:01 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>
Date: Thu, 25 Mar 2021 03:23:07 -0700

> mul_u64_u64_div_u64() is not exported. As result, every build with
> CONFIG_PTP_1588_CLOCK_QORIQ=m (ie every allmodconfig build) fails with:
> 
> ERROR: modpost: "mul_u64_u64_div_u64" [drivers/ptp/ptp-qoriq.ko] undefined!
> 
> or a similar error.

I fixed this with a follow-up commit to export the symbol.
