Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7884369B78
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 22:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232802AbhDWUpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 16:45:21 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59592 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231721AbhDWUpS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 16:45:18 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 9EB294D2ADD04;
        Fri, 23 Apr 2021 13:44:40 -0700 (PDT)
Date:   Fri, 23 Apr 2021 13:44:40 -0700 (PDT)
Message-Id: <20210423.134440.604990654040210950.davem@davemloft.net>
To:     sd@queasysnail.net
Cc:     phil@philpotter.co.uk, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, edumazet@google.com, fw@strlen.de
Subject: Re: [PATCH v2] net: geneve: modify IP header check in
 geneve6_xmit_skb and geneve_xmit_skb
From:   David Miller <davem@davemloft.net>
In-Reply-To: <YILOfTt6qKNwYtV6@hog>
References: <20210422234945.1190-1-phil@philpotter.co.uk>
        <YILOfTt6qKNwYtV6@hog>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Fri, 23 Apr 2021 13:44:40 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>
Date: Fri, 23 Apr 2021 15:41:17 +0200

> 2021-04-23, 00:49:45 +0100, Phillip Potter wrote:
>> Modify the header size check in geneve6_xmit_skb and geneve_xmit_skb
>> to use pskb_inet_may_pull rather than pskb_network_may_pull. This fixes
>> two kernel selftest failures introduced by the commit introducing the
>> checks:
>> IPv4 over geneve6: PMTU exceptions
>> IPv4 over geneve6: PMTU exceptions - nexthop objects
>> 
>> It does this by correctly accounting for the fact that IPv4 packets may
>> transit over geneve IPv6 tunnels (and vice versa), and still fixes the
>> uninit-value bug fixed by the original commit.
>> 
>> Reported-by: kernel test robot <oliver.sang@intel.com>
>> Fixes: 6628ddfec758 ("net: geneve: check skb is large enough for IPv4/IPv6 header")
>> Suggested-by: Sabrina Dubroca <sd@queasysnail.net>
>> Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
>> ---
>> 
>> V2:
>> * Incorporated feedback from Sabrina Dubroca regarding pskb_inet_may_pull
>> * Added Fixes: tag as requested by Eric Dumazet
> 
> Thanks Phillip.
> 
> Acked-by: Sabrina Dubroca <sd@queasysnail.net>
> 
> Jakub/David, it would be great if this could get in 5.12, otherwise
> geneve is a bit broken:
> https://bugzilla.kernel.org/show_bug.cgi?id=212749

I don't think we will submit another pull req for networking, but thatys
ok it'll end up in stable eventually.

Thanks.
