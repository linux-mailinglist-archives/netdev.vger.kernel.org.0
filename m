Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE5FF1C28F2
	for <lists+netdev@lfdr.de>; Sun,  3 May 2020 01:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbgEBXdw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 May 2020 19:33:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726375AbgEBXdw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 May 2020 19:33:52 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BFBDC061A0C;
        Sat,  2 May 2020 16:33:52 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5C6451515F5D8;
        Sat,  2 May 2020 16:33:51 -0700 (PDT)
Date:   Sat, 02 May 2020 16:33:50 -0700 (PDT)
Message-Id: <20200502.163350.2198213381488533981.davem@davemloft.net>
To:     mmrmaximuzz@gmail.com
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] stmmac: fix pointer check after utilization in
 stmmac_interrupt
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200502092906.GA9883@maxim-hplinux>
References: <20200502092906.GA9883@maxim-hplinux>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 02 May 2020 16:33:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Petrov <mmrmaximuzz@gmail.com>
Date: Sat, 2 May 2020 12:29:08 +0300

> The paranoidal pointer check in IRQ handler looks very strange - it
> really protects us only against bogus drivers which request IRQ line
> with null pointer dev_id. However, the code fragment is incorrect
> because the dev pointer is used before the actual check. That leads
> to undefined behavior thus compilers are free to remove the pointer
> check at all.
> 
> Signed-off-by: Maxim Petrov <mmrmaximuzz@gmail.com>

Seriously, just remove this check altogether.
