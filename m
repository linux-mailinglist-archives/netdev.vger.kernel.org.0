Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5A029CD4C
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 02:48:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726018AbgJ1Bi0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 21:38:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:34064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1833059AbgJ0Xva (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Oct 2020 19:51:30 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B728207C4;
        Tue, 27 Oct 2020 23:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603842689;
        bh=kUt71dlSOhRY1T7LunXBypWQx5jHsE/rfiLyEj5bMDs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EndYJ641foORAQfW3AUcc9v3pCBUT7a1xNAFJ+wWtPNsz6FxoMVgUNakBFE26EBSD
         V7k47Fo8T9tGlfPmNjqKK+qETb8kO+++kc7EWTUk3O9KrM3nxuN6s4NqhBNbYhGx0f
         t7ESp5LmV34iQAq20fsgeh/XKLihijWq7QyuUedE=
Date:   Tue, 27 Oct 2020 16:51:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, secdev@chelsio.com
Subject: Re: [PATCH net] chelsio/chtls: fix deadlock issue
Message-ID: <20201027165128.45192579@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201025193538.31112-1-vinay.yadav@chelsio.com>
References: <20201025193538.31112-1-vinay.yadav@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Oct 2020 01:05:39 +0530 Vinay Kumar Yadav wrote:
> In chtls_pass_establish() we hold child socket lock using bh_lock_sock
> and we are again trying bh_lock_sock in add_to_reap_list, causing deadlock.
> Remove bh_lock_sock in add_to_reap_list() as lock is already held.
> 
> Fixes: cc35c88ae4db ("crypto : chtls - CPL handler definition")
> Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>

Applied.
