Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD43ED6E2
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 02:25:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728672AbfKDBZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Nov 2019 20:25:54 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:40264 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728111AbfKDBZy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Nov 2019 20:25:54 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 44869150306AB;
        Sun,  3 Nov 2019 17:25:53 -0800 (PST)
Date:   Sun, 03 Nov 2019 17:25:52 -0800 (PST)
Message-Id: <20191103.172552.239436537129845506.davem@davemloft.net>
To:     fruggeri@arista.com
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: icmp: use input address in traceroute
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191101004414.2B2F995C102D@us180.sjc.aristanetworks.com>
References: <20191101004414.2B2F995C102D@us180.sjc.aristanetworks.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 03 Nov 2019 17:25:53 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: fruggeri@arista.com (Francesco Ruggeri)
Date: Thu, 31 Oct 2019 17:44:13 -0700

> Even with icmp_errors_use_inbound_ifaddr set, traceroute returns the
> primary address of the interface the packet was received on, even if
> the path goes through a secondary address. In the example:
> 
>                     1.0.3.1/24
>  ---- 1.0.1.3/24    1.0.1.1/24 ---- 1.0.2.1/24    1.0.2.4/24 ----
>  |H1|--------------------------|R1|--------------------------|H2|
>  ----            N1            ----            N2            ----
> 
> where 1.0.3.1/24 is R1's primary address on N1, traceroute from
> H1 to H2 returns:
> 
> traceroute to 1.0.2.4 (1.0.2.4), 30 hops max, 60 byte packets
>  1  1.0.3.1 (1.0.3.1)  0.018 ms  0.006 ms  0.006 ms
>  2  1.0.2.4 (1.0.2.4)  0.021 ms  0.007 ms  0.007 ms
> 
> After applying this patch, it returns:
> 
> traceroute to 1.0.2.4 (1.0.2.4), 30 hops max, 60 byte packets
>  1  1.0.1.1 (1.0.1.1)  0.033 ms  0.007 ms  0.006 ms
>  2  1.0.2.4 (1.0.2.4)  0.011 ms  0.007 ms  0.007 ms
> 
> Original-patch-by: Bill Fenner <fenner@arista.com>
> Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>

Applied.
