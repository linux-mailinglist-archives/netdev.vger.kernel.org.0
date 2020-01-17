Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0827141D93
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 12:31:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbgASLbP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 06:31:15 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47374 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726778AbgASLbP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 06:31:15 -0500
Received: from localhost (unknown [62.21.130.100])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8A4A114C823D6;
        Sun, 19 Jan 2020 03:31:14 -0800 (PST)
Date:   Fri, 17 Jan 2020 04:08:49 -0800 (PST)
Message-Id: <20200117.040849.2032549448991143345.davem@davemloft.net>
To:     fw@strlen.de
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] netlink: make getters tolerate NULL nla arg
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200116145522.28803-1-fw@strlen.de>
References: <20200116145522.28803-1-fw@strlen.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 19 Jan 2020 03:31:14 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>
Date: Thu, 16 Jan 2020 15:55:22 +0100

> One recurring bug pattern triggered by syzbot is NULL dereference in
> netlink code paths due to a missing "tb[NL_ARG_FOO] != NULL" test.
> 
> At least some of these missing checks would not have crashed the kernel if
> the various nla_get_XXX helpers would return 0 in case of missing arg.
> 
> Make the helpers return 0 instead of crashing when a null nla is provided.
> Even with allyesconfig the .text increase is only about 350 bytes.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Sorry, I think it's better to find out when code is trying to access
attributes without verifying that they are even supplied.
