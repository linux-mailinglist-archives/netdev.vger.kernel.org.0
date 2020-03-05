Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCDCC17AF45
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 21:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726020AbgCEUA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 15:00:29 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:56052 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbgCEUA2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 15:00:28 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 483F0126B3972;
        Thu,  5 Mar 2020 12:00:28 -0800 (PST)
Date:   Thu, 05 Mar 2020 12:00:27 -0800 (PST)
Message-Id: <20200305.120027.821059280923943275.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com
Subject: Re: [PATCH net] slip: make slhc_compress() more robust against
 malicious packets
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200304235143.214557-1-edumazet@google.com>
References: <20200304235143.214557-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 05 Mar 2020 12:00:28 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Wed,  4 Mar 2020 15:51:43 -0800

> Before accessing various fields in IPV4 network header
> and TCP header, make sure the packet :
> 
> - Has IP version 4 (ip->version == 4)
> - Has not a silly network length (ip->ihl >= 5)
> - Is big enough to hold network and transport headers
> - Has not a silly TCP header size (th->doff >= sizeof(struct tcphdr) / 4)
> 
> syzbot reported :
 ...
> Fixes: b5451d783ade ("slip: Move the SLIP drivers")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Applied and queued up for -stable, thanks.
