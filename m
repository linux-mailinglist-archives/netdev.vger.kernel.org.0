Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A30DC23B225
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 03:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728840AbgHDBPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 21:15:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726615AbgHDBPN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 21:15:13 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECED3C06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 18:15:12 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3ACDB1278A7C9;
        Mon,  3 Aug 2020 17:58:27 -0700 (PDT)
Date:   Mon, 03 Aug 2020 18:15:12 -0700 (PDT)
Message-Id: <20200803.181512.1195418774947073734.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org
Subject: Re: [PATCH net] mptcp: fix bogus sendmsg() return code under
 pressure
From:   David Miller <davem@davemloft.net>
In-Reply-To: <365d4a854cbfabbd93be7b0331e4c5d3eb1334b8.1596472748.git.pabeni@redhat.com>
References: <365d4a854cbfabbd93be7b0331e4c5d3eb1334b8.1596472748.git.pabeni@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Aug 2020 17:58:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Mon,  3 Aug 2020 18:40:39 +0200

> In case of memory pressure, mptcp_sendmsg() may call
> sk_stream_wait_memory() after succesfully xmitting some
> bytes. If the latter fails we currently return to the
> user-space the error code, ignoring the succeful xmit.
> 
> Address the issue always checking for the xmitted bytes
> before mptcp_sendmsg() completes.
> 
> Fixes: f296234c98a8 ("mptcp: Add handling of incoming MP_JOIN requests")
> Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Applied and queued up for v5.7+ -stable, thank you.
