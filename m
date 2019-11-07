Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE3EEF3BFD
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 00:12:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725940AbfKGXM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 18:12:28 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:49620 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbfKGXM2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 18:12:28 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E85F4153698FD;
        Thu,  7 Nov 2019 15:12:27 -0800 (PST)
Date:   Thu, 07 Nov 2019 15:12:25 -0800 (PST)
Message-Id: <20191107.151225.1298112792540927971.davem@davemloft.net>
To:     stranche@codeaurora.org
Cc:     netdev@vger.kernel.org, subashab@codeaurora.org
Subject: Re: [PATCH net-next v2] net: Fail explicit bind to local reserved
 ports
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1572913541-28236-1-git-send-email-stranche@codeaurora.org>
References: <1572913541-28236-1-git-send-email-stranche@codeaurora.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 Nov 2019 15:12:28 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sean Tranchetti <stranche@codeaurora.org>
Date: Mon,  4 Nov 2019 17:25:41 -0700

> Reserved ports may have some special use cases which are not suitable for
> use by general userspace applications. Currently, ports specified in
> ip_local_reserved_ports will not be returned only in case of automatic port
> assignment.
> 
> In some cases, it maybe required to prevent the host from assigning the
> ports even in case of explicit binds. Consider the case of a transparent
> proxy where packets are being redirected. In case a socket matches this
> connection, packets from this application would be incorrectly sent to one
> of the endpoints.
> 
> Add a boolean sysctl flag 'reserved_port_bind'. Default value is 1 which
> preserves the existing behavior. Setting the value to 0 will prevent
> userspace applications from binding to these ports even when they are
> explicitly requested.
> 
> Signed-off-by: Sean Tranchetti <stranche@codeaurora.org>
> Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>

I think that someone with CAP_NET_BIND_SERVICE should be able to
override this.

Really, this is just extending the usual 0-->PROT_SOCK restriction.

This whole area is a mess of knobs and conditions, so I'd rather see
this implemented with some consolidation rather than layering yet
another thing on top of what we already have.

Thanks.
