Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 465D09C118
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 02:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728343AbfHYAAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 20:00:40 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48758 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727879AbfHYAAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Aug 2019 20:00:40 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7A0471526220B;
        Sat, 24 Aug 2019 17:00:39 -0700 (PDT)
Date:   Sat, 24 Aug 2019 17:00:38 -0700 (PDT)
Message-Id: <20190824.170038.194270186964773942.davem@davemloft.net>
To:     pmalani@chromium.org
Cc:     hayeswang@realtek.com, grundler@chromium.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] r8152: Set memory to all 0xFFs on failed reg reads
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190824083619.69139-1-pmalani@chromium.org>
References: <20190824083619.69139-1-pmalani@chromium.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 24 Aug 2019 17:00:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Prashant Malani <pmalani@chromium.org>
Date: Sat, 24 Aug 2019 01:36:19 -0700

> get_registers() blindly copies the memory written to by the
> usb_control_msg() call even if the underlying urb failed.
> 
> This could lead to junk register values being read by the driver, since
> some indirect callers of get_registers() ignore the return values. One
> example is:
>   ocp_read_dword() ignores the return value of generic_ocp_read(), which
>   calls get_registers().
> 
> So, emulate PCI "Master Abort" behavior by setting the buffer to all
> 0xFFs when usb_control_msg() fails.
> 
> This patch is copied from the r8152 driver (v2.12.0) published by
> Realtek (www.realtek.com).
> 
> Signed-off-by: Prashant Malani <pmalani@chromium.org>

Hayes, please review.
