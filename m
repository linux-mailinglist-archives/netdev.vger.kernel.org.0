Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 877932571C2
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 04:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbgHaCOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Aug 2020 22:14:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726579AbgHaCOW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Aug 2020 22:14:22 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5107CC061575
        for <netdev@vger.kernel.org>; Sun, 30 Aug 2020 19:14:22 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6111A13673751;
        Sun, 30 Aug 2020 18:57:27 -0700 (PDT)
Date:   Sun, 30 Aug 2020 19:14:11 -0700 (PDT)
Message-Id: <20200830.191411.329412155086247494.davem@davemloft.net>
To:     tuong.t.lien@dektech.com.au
Cc:     jmaloy@redhat.com, maloy@donjonn.com, ying.xue@windriver.com,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net
Subject: Re: [net] tipc: fix using smp_processor_id() in preemptible
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200829193755.9429-1-tuong.t.lien@dektech.com.au>
References: <20200829193755.9429-1-tuong.t.lien@dektech.com.au>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 30 Aug 2020 18:57:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tuong Lien <tuong.t.lien@dektech.com.au>
Date: Sun, 30 Aug 2020 02:37:55 +0700

> The 'this_cpu_ptr()' is used to obtain the AEAD key' TFM on the current
> CPU for encryption, however the execution can be preemptible since it's
> actually user-space context, so the 'using smp_processor_id() in
> preemptible' has been observed.
> 
> We fix the issue by using the 'get/put_cpu_ptr()' API which consists of
> a 'preempt_disable()' instead.
> 
> Fixes: fc1b6d6de220 ("tipc: introduce TIPC encryption & authentication")
> Acked-by: Jon Maloy <jmaloy@redhat.com>
> Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>

Applied and queued up for -stable.
