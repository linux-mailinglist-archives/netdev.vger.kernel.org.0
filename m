Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7AEE137756
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 20:37:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728602AbgAJThO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 14:37:14 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:40060 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728519AbgAJThO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 14:37:14 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CA2EA1577F7ED;
        Fri, 10 Jan 2020 11:37:13 -0800 (PST)
Date:   Fri, 10 Jan 2020 11:37:13 -0800 (PST)
Message-Id: <20200110.113713.476697922680090862.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     jakub.kicinski@netronome.com, netdev@vger.kernel.org,
        haegar@sdinet.de, dsahern@gmail.com
Subject: Re: [PATCH net] ipv4: Detect rollover in specific fib table dump
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200110170358.29474-1-dsahern@kernel.org>
References: <20200110170358.29474-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 10 Jan 2020 11:37:14 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Fri, 10 Jan 2020 09:03:58 -0800

> From: David Ahern <dsahern@gmail.com>
> 
> Sven-Haegar reported looping on fib dumps when 255.255.255.255 route has
> been added to a table. The looping is caused by the key rolling over from
> FFFFFFFF to 0. When dumping a specific table only, we need a means to detect
> when the table dump is done. The key and count saved to cb args are both 0
> only at the start of the table dump. If key is 0 and count > 0, then we are
> in the rollover case. Detect and return to avoid looping.
> 
> This only affects dumps of a specific table; for dumps of all tables
> (the case prior to the change in the Fixes tag) inet_dump_fib moved
> the entry counter to the next table and reset the cb args used by
> fib_table_dump and fn_trie_dump_leaf, so the rollover ffffffff back
> to 0 did not cause looping with the dumps.
> 
> Fixes: effe67926624 ("net: Enable kernel side filtering of route dumps")
> Reported-by: Sven-Haegar Koch <haegar@sdinet.de>
> Signed-off-by: David Ahern <dsahern@gmail.com>

Applied, and queued up for -stable, thanks.
