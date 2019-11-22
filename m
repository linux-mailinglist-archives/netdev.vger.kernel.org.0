Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85E111076F7
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 19:08:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbfKVSIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 13:08:44 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38500 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbfKVSIn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 13:08:43 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 30AE0152828F2;
        Fri, 22 Nov 2019 10:08:43 -0800 (PST)
Date:   Fri, 22 Nov 2019 10:08:42 -0800 (PST)
Message-Id: <20191122.100842.1368735892662020130.davem@davemloft.net>
To:     hayeswang@realtek.com
Cc:     netdev@vger.kernel.org, nic_swsd@realtek.com,
        linux-kernel@vger.kernel.org, pmalani@chromium.org,
        grundler@chromium.org
Subject: Re: [PATCH net] r8152: avoid to call napi_disable twice
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1394712342-15778-337-Taiwan-albertk@realtek.com>
References: <1394712342-15778-337-Taiwan-albertk@realtek.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 22 Nov 2019 10:08:43 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Fri, 22 Nov 2019 16:21:09 +0800

> Call napi_disable() twice would cause dead lock. There are three situations
> may result in the issue.
> 
> 1. rtl8152_pre_reset() and set_carrier() are run at the same time.
> 2. Call rtl8152_set_tunable() after rtl8152_close().
> 3. Call rtl8152_set_ringparam() after rtl8152_close().
> 
> For #1, use the same solution as commit 84811412464d ("r8152: Re-order
> napi_disable in rtl8152_close"). For #2 and #3, add checking the flag
> of IFF_UP and using napi_disable/napi_enable during mutex.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

Applied and queued up for -stable, thanks.
