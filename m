Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D73191983A0
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 20:45:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbgC3Spl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 14:45:41 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40934 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726385AbgC3Spk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 14:45:40 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7D40415C66ABD;
        Mon, 30 Mar 2020 11:45:40 -0700 (PDT)
Date:   Mon, 30 Mar 2020 11:45:39 -0700 (PDT)
Message-Id: <20200330.114539.1547226893911280155.davem@davemloft.net>
To:     ybason@marvell.com
Cc:     netdev@vger.kernel.org, mkalderon@marvell.com
Subject: Re: [PATCH net-next] qed: Fix use after free in qed_chain_free
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200329173249.16399-1-ybason@marvell.com>
References: <20200329173249.16399-1-ybason@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 30 Mar 2020 11:45:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yuval Basson <ybason@marvell.com>
Date: Sun, 29 Mar 2020 20:32:49 +0300

> The qed_chain data structure was modified in
> commit 1a4a69751f4d ("qed: Chain support for external PBL") to support
> receiving an external pbl (due to iWARP FW requirements).
> The pages pointed to by the pbl are allocated in qed_chain_alloc
> and their virtual address are stored in an virtual addresses array to
> enable accessing and freeing the data. The physical addresses however
> weren't stored and were accessed directly from the external-pbl
> during free.
> 
> Destroy-qp flow, leads to freeing the external pbl before the chain is
> freed, when the chain is freed it tries accessing the already freed
> external pbl, leading to a use-after-free. Therefore we need to store
> the physical addresses in additional to the virtual addresses in a
> new data structure.
> 
> Fixes: 1a4a69751f4d ("qed: Chain support for external PBL")
> Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> Signed-off-by: Yuval Bason <ybason@marvell.com>

Applied.
