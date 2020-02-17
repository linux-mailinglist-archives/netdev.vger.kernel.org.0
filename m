Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7895160911
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 04:37:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbgBQDhd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 22:37:33 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48358 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726498AbgBQDhd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 22:37:33 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AD3941579181D;
        Sun, 16 Feb 2020 19:37:32 -0800 (PST)
Date:   Sun, 16 Feb 2020 19:37:32 -0800 (PST)
Message-Id: <20200216.193732.474649064358030475.davem@davemloft.net>
To:     matthieu.baerts@tessares.net
Cc:     netdev@vger.kernel.org, mathew.j.martineau@linux.intel.com,
        pabeni@redhat.com, cpaasch@apple.com, mptcp@lists.01.org
Subject: Re: [PATCH net] mptcp: select CRYPTO
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200215144556.956173-1-matthieu.baerts@tessares.net>
References: <20200215144556.956173-1-matthieu.baerts@tessares.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Feb 2020 19:37:32 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthieu Baerts <matthieu.baerts@tessares.net>
Date: Sat, 15 Feb 2020 15:45:56 +0100

> Without this modification and if CRYPTO is not selected, we have this
> warning:
> 
>   WARNING: unmet direct dependencies detected for CRYPTO_LIB_SHA256
>     Depends on [n]: CRYPTO [=n]
>     Selected by [y]:
>     - MPTCP [=y] && NET [=y] && INET [=y]
> 
> MPTCP selects CRYPTO_LIB_SHA256 which seems to depend on CRYPTO. CRYPTO
> is now selected to avoid this issue.
> 
> Even though the config system prints that warning, it looks like
> sha256.c is compiled and linked even without CONFIG_CRYPTO. Since MPTCP
> will end up needing CONFIG_CRYPTO anyway in future commits -- currently
> in preparation for net-next -- we propose to add it now to fix the
> warning.
> 
> The dependency in the config system comes from the fact that
> CRYPTO_LIB_SHA256 is defined in "lib/crypto/Kconfig" which is sourced
> from "crypto/Kconfig" only if CRYPTO is selected.
> 
> Fixes: 65492c5a6ab5 (mptcp: move from sha1 (v0) to sha256 (v1))
> Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>

Applied.
