Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00BFC4A8BA
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 19:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730109AbfFRRoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 13:44:37 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50840 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729491AbfFRRoh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 13:44:37 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6C89515104411;
        Tue, 18 Jun 2019 10:44:36 -0700 (PDT)
Date:   Tue, 18 Jun 2019 10:44:36 -0700 (PDT)
Message-Id: <20190618.104436.269466043868578046.davem@davemloft.net>
To:     arnd@arndb.de
Cc:     aelior@marvell.com, GR-everest-linux-l2@marvell.com,
        ariel.elior@marvell.com, michal.kalderon@marvell.com,
        dan.carpenter@oracle.com, dbolotin@marvell.com,
        tomer.tayar@cavium.com, skalluru@marvell.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] qed: Fix -Wmaybe-uninitialized false positive
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190617130504.1906523-1-arnd@arndb.de>
References: <20190617130504.1906523-1-arnd@arndb.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 18 Jun 2019 10:44:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Mon, 17 Jun 2019 15:04:49 +0200

> A previous attempt to shut up the uninitialized variable use
> warning was apparently insufficient. When CONFIG_PROFILE_ANNOTATED_BRANCHES
> is set, gcc-8 still warns, because the unlikely() check in DP_NOTICE()
> causes it to no longer track the state of all variables correctly:
> 
> drivers/net/ethernet/qlogic/qed/qed_dev.c: In function 'qed_llh_set_ppfid_affinity':
> drivers/net/ethernet/qlogic/qed/qed_dev.c:798:47: error: 'abs_ppfid' may be used uninitialized in this function [-Werror=maybe-uninitialized]
>   addr = NIG_REG_PPF_TO_ENGINE_SEL + abs_ppfid * 0x4;
>                                      ~~~~~~~~~~^~~~~
> 
> This is not a nice workaround, but always initializing the output from
> qed_llh_abs_ppfid() at least shuts up the false positive reliably.
> 
> Fixes: 79284adeb99e ("qed: Add llh ppfid interface and 100g support for offload protocols")
> Fixes: 8e2ea3ea9625 ("qed: Fix static checker warning")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Applied to net-next.
