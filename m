Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14EDD5C309
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 20:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbfGASct (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 14:32:49 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46998 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725853AbfGAScs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 14:32:48 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D144614A6DBE7;
        Mon,  1 Jul 2019 11:32:47 -0700 (PDT)
Date:   Mon, 01 Jul 2019 11:32:47 -0700 (PDT)
Message-Id: <20190701.113247.31622102771370431.davem@davemloft.net>
To:     mcroce@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org
Subject: Re: [PATCH net v2] ipv4: don't set IPv6 only flags to IPv4
 addresses
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190701170155.1967-1-mcroce@redhat.com>
References: <20190701170155.1967-1-mcroce@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 01 Jul 2019 11:32:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matteo Croce <mcroce@redhat.com>
Date: Mon,  1 Jul 2019 19:01:55 +0200

> Avoid the situation where an IPV6 only flag is applied to an IPv4 address:
> 
>     # ip addr add 192.0.2.1/24 dev dummy0 nodad home mngtmpaddr noprefixroute
>     # ip -4 addr show dev dummy0
>     2: dummy0: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN group default qlen 1000
>         inet 192.0.2.1/24 scope global noprefixroute dummy0
>            valid_lft forever preferred_lft forever
> 
> Or worse, by sending a malicious netlink command:
> 
>     # ip -4 addr show dev dummy0
>     2: dummy0: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN group default qlen 1000
>         inet 192.0.2.1/24 scope global nodad optimistic dadfailed home tentative mngtmpaddr noprefixroute stable-privacy dummy0
>            valid_lft forever preferred_lft forever
> 
> Signed-off-by: Matteo Croce <mcroce@redhat.com>

Applied and queued up for -stable, thanks Matteo.
