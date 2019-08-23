Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36D3B9B854
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 23:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393230AbfHWVxd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 17:53:33 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38330 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392654AbfHWVxc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 17:53:32 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2061E1543BD1C;
        Fri, 23 Aug 2019 14:53:32 -0700 (PDT)
Date:   Fri, 23 Aug 2019 14:53:31 -0700 (PDT)
Message-Id: <20190823.145331.2056583913194843050.davem@davemloft.net>
To:     sd@queasysnail.net
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net] ipv6: propagate ipv6_add_dev's error returns out
 of ipv6_find_idev
From:   David Miller <davem@davemloft.net>
In-Reply-To: <5bc330e3f8123eb139113ae93851cc17100c22da.1566566438.git.sd@queasysnail.net>
References: <5bc330e3f8123eb139113ae93851cc17100c22da.1566566438.git.sd@queasysnail.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 23 Aug 2019 14:53:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>
Date: Fri, 23 Aug 2019 15:44:36 +0200

> Currently, ipv6_find_idev returns NULL when ipv6_add_dev fails,
> ignoring the specific error value. This results in addrconf_add_dev
> returning ENOBUFS in all cases, which is unfortunate in cases such as:
> 
>     # ip link add dummyX type dummy
>     # ip link set dummyX mtu 1200 up
>     # ip addr add 2000::/64 dev dummyX
>     RTNETLINK answers: No buffer space available
> 
> Commit a317a2f19da7 ("ipv6: fail early when creating netdev named all
> or default") introduced error returns in ipv6_add_dev. Before that,
> that function would simply return NULL for all failures.
> 
> Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>

Looks good, applied, thanks Sabrina.
