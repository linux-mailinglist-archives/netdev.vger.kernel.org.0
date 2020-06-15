Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ADC91F9D8D
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 18:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730701AbgFOQfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 12:35:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:35976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730135AbgFOQfG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jun 2020 12:35:06 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A7172078A;
        Mon, 15 Jun 2020 16:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592238906;
        bh=fgybvK2hoAkWg2kEUpThPvY4J/JYRs8GxBatSYNsifw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bkGdMaQ8WfZDzipbQYwQI1TOWsaOuGpZaslCXZHEMkvJ6OXilW718LqCNk9PZjCmU
         djZdyvkFfkqj0Y2BVarS0eoZTMLNjZxblx9L25ysYmA7bFilW+2DW4iSC8Dm6VXShB
         ojJdF51UXl0xGVGzSYQPweKdrJ4Jr96bkK++IA/A=
Date:   Mon, 15 Jun 2020 09:35:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     guodeqing <geffrey.guo@huawei.com>
Cc:     <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        <netdev@vger.kernel.org>, <dsa@cumulusnetworks.com>
Subject: Re: [PATCH] net: Fix the arp error in some cases
Message-ID: <20200615093504.37689a5c@kicinski-fedora-PC1C0HJN>
In-Reply-To: <1592030995-111190-1-git-send-email-geffrey.guo@huawei.com>
References: <1592030995-111190-1-git-send-email-geffrey.guo@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 13 Jun 2020 14:49:55 +0800 guodeqing wrote:
> ie.,
> $ ifconfig eth0 6.6.6.6 netmask 255.255.255.0
> 
> $ ip rule add from 6.6.6.6 table 6666
> 
> $ ip route add 9.9.9.9 via 6.6.6.6
> 
> $ ping -I 6.6.6.6 9.9.9.9
> PING 9.9.9.9 (9.9.9.9) from 6.6.6.6 : 56(84) bytes of data.
> 
> ^C
> --- 9.9.9.9 ping statistics ---

Please don't put --- in the commit message like this, git will cut off
the message here, since this is a footer separator.

> 3 packets transmitted, 0 received, 100% packet loss, time 2079ms
> 
> $ arp
> Address     HWtype  HWaddress           Flags Mask            Iface
> 6.6.6.6             (incomplete)                              eth0
> 
> The arp request address is error, this problem can be reproduced easily.
> 
> Fixes: 3bfd847203c6("net: Use passed in table for nexthop lookups")
> Signed-off-by: guodeqing <geffrey.guo@huawei.com>
