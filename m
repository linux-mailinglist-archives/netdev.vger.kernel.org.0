Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A80F41EEBD
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 15:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353815AbhJANmk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 09:42:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353771AbhJANmj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 09:42:39 -0400
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5ED4C061775;
        Fri,  1 Oct 2021 06:40:54 -0700 (PDT)
Received: from localhost (cpc147930-brnt3-2-0-cust60.4-2.cable.virginm.net [86.15.196.61])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 172594D01041C;
        Fri,  1 Oct 2021 06:40:51 -0700 (PDT)
Date:   Fri, 01 Oct 2021 14:40:46 +0100 (BST)
Message-Id: <20211001.144046.309542880703739165.davem@davemloft.net>
To:     sfr@canb.auug.org.au
Cc:     netdev@vger.kernel.org, edumazet@google.com, weiwan@google.com,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the net-next tree
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20211001161849.51b6deca@canb.auug.org.au>
References: <20211001161849.51b6deca@canb.auug.org.au>
X-Mailer: Mew version 6.8 on Emacs 27.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Fri, 01 Oct 2021 06:40:53 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 1 Oct 2021 16:18:49 +1000

> Hi all,
> 
> After merging the net-next tree, today's linux-next build (sparc64
> defconfig) failed like this:
> 
> net/core/sock.c: In function 'sock_setsockopt':
> net/core/sock.c:1417:7: error: 'SO_RESERVE_MEM' undeclared (first use in this function); did you mean 'IORESOURCE_MEM'?
>   case SO_RESERVE_MEM:
>        ^~~~~~~~~~~~~~
>        IORESOURCE_MEM
> net/core/sock.c:1417:7: note: each undeclared identifier is reported only once for each function it appears in
> net/core/sock.c: In function 'sock_getsockopt':
> net/core/sock.c:1817:7: error: 'SO_RESERVE_MEM' undeclared (first use in this function); did you mean 'IORESOURCE_MEM'?
>   case SO_RESERVE_MEM:
>        ^~~~~~~~~~~~~~
>        IORESOURCE_MEM
> 
> Caused by commit
> 
>   2bb2f5fb21b0 ("net: add new socket option SO_RESERVE_MEM")
> 
> arch/sparc/include/uapi/socket.h does not include uapi/asm/socket.h and
> some other architectures do not as well.
> 
> I have added the following patch for today (I searched for SO_BUF_LOCK
> and, of these architectures, I have only compile tested sparc64 and
> sparc):

I committed the sparc part into net-next today, thanks.

