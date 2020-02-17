Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA038161D9E
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 23:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725997AbgBQWwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 17:52:38 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:56414 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725927AbgBQWwi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 17:52:38 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EB7BF15AAC283;
        Mon, 17 Feb 2020 14:52:37 -0800 (PST)
Date:   Mon, 17 Feb 2020 14:52:37 -0800 (PST)
Message-Id: <20200217.145237.25836634449905721.davem@davemloft.net>
To:     fw@strlen.de
Cc:     netdev@vger.kernel.org, dan.carpenter@oracle.com
Subject: Re: [PATCH net] mptcp: fix bogus socket flag values
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200217155438.16656-1-fw@strlen.de>
References: <20200217155438.16656-1-fw@strlen.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 17 Feb 2020 14:52:38 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>
Date: Mon, 17 Feb 2020 16:54:38 +0100

> Dan Carpenter reports static checker warnings due to bogus BIT() usage:
> 
> net/mptcp/subflow.c:571 subflow_write_space() warn: test_bit() takes a bit number
> net/mptcp/subflow.c:694 subflow_state_change() warn: test_bit() takes a bit number
> net/mptcp/protocol.c:261 ssk_check_wmem() warn: test_bit() takes a bit number
> [..]
> 
> This is harmless (we use bits 1 & 2 instead of 0 and 1), but would
> break eventually when adding BIT(5) (or 6, depends on size of 'long').
> 
> Just use 0 and 1, the values are only passed to test/set/clear_bit
> functions.
> 
> Fixes: 648ef4b88673 ("mptcp: Implement MPTCP receive path")
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>

Applied, thanks Florian.
