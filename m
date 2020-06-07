Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA381F1083
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 01:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727977AbgFGXgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jun 2020 19:36:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727786AbgFGXgy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jun 2020 19:36:54 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47723C061A0E;
        Sun,  7 Jun 2020 16:36:54 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7593B127385D2;
        Sun,  7 Jun 2020 16:36:51 -0700 (PDT)
Date:   Sun, 07 Jun 2020 16:36:48 -0700 (PDT)
Message-Id: <20200607.163648.1680419872557863264.davem@davemloft.net>
To:     xianfengting221@163.com
Cc:     leon@kernel.org, saeedm@mellanox.com, kuba@kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/mlx5: Add a missing macro undefinition
From:   David Miller <davem@davemloft.net>
In-Reply-To: <c96f7991-3858-4351-9804-4482e7689cd7@163.com>
References: <20200607051241.5375-1-xianfengting221@163.com>
        <20200607063635.GD164174@unreal>
        <c96f7991-3858-4351-9804-4482e7689cd7@163.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 07 Jun 2020 16:36:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hu Haowen <xianfengting221@163.com>
Date: Sun, 7 Jun 2020 14:55:33 +0800

> 
> On 2020/6/7 2:36 PM, Leon Romanovsky wrote:
>> On Sun, Jun 07, 2020 at 01:12:40PM +0800, Hu Haowen wrote:
>>> The macro ODP_CAP_SET_MAX is only used in function
>>> handle_hca_cap_odp()
>>> in file main.c, so it should be undefined when there are no more uses
>>> of it.
>>>
>>> Signed-off-by: Hu Haowen <xianfengting221@163.com>
>>> ---
>>>   drivers/net/ethernet/mellanox/mlx5/core/main.c | 2 ++
>>>   1 file changed, 2 insertions(+)
>> "should be undefined" is s little bit over statement, but overall
>> the patch is good.
> 
> 
> Sorry for my strong tone, but my idea is that every macro which is
> defined and used just in a single function, is supposed to be
> undefined
> at the end of its final use, so that you won't get into trouble next
> time if you define a macro with the same name as this one.

The compiler would generate an error if that happened, so you would
not get into "trouble".

I fail to see the value in this change at all, sorry.

Really, what's the point?

Does it make the code harder to read?  No.

Does it cause problems if you accidently want to use that macro name
again in the same compilation unit?  No.

So I have yet to hear a valid "why" to make this kind of change and
I'd like to stop this set of cleanups before it gets out of control
and we have these ugly #undef statements all over the tree.

Thank you.
