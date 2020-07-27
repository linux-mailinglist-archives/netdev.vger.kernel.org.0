Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9064E22F9FC
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 22:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728958AbgG0UZ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 16:25:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728039AbgG0UZ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 16:25:59 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F6C0C061794;
        Mon, 27 Jul 2020 13:25:59 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 28E0312781F88;
        Mon, 27 Jul 2020 13:09:14 -0700 (PDT)
Date:   Mon, 27 Jul 2020 13:25:58 -0700 (PDT)
Message-Id: <20200727.132558.1865871927633102126.davem@davemloft.net>
To:     viro@zeniv.linux.org.uk
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        nbowler@draconx.ca
Subject: Re: [PATCH net] fix a braino in cmsghdr_from_user_compat_to_kern()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200727182220.GI794331@ZenIV.linux.org.uk>
References: <20200727160554.GG794331@ZenIV.linux.org.uk>
        <20200727161319.GH794331@ZenIV.linux.org.uk>
        <20200727182220.GI794331@ZenIV.linux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Jul 2020 13:09:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>
Date: Mon, 27 Jul 2020 19:22:20 +0100

> 	commit 547ce4cfb34c ("switch cmsghdr_from_user_compat_to_kern() to
> copy_from_user()") missed one of the places where ucmlen should've been
> replaced with cmsg.cmsg_len, now that we are fetching the entire struct
> rather than doing it field-by-field.
> 
> 	As the result, compat sendmsg() with several different-sized cmsg
> attached started to fail with EINVAL.  Trivial to fix, fortunately.
> 
> Reported-by: Nick Bowler <nbowler@draconx.ca>
> Tested-by: Nick Bowler <nbowler@draconx.ca>
> Fixes: 547ce4cfb34c ("switch cmsghdr_from_user_compat_to_kern() to copy_from_user()")
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Applied, thanks Al.
