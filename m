Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA3E812A50A
	for <lists+netdev@lfdr.de>; Wed, 25 Dec 2019 01:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbfLYAIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 19:08:22 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57912 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726262AbfLYAIW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Dec 2019 19:08:22 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 84D37154CCC21;
        Tue, 24 Dec 2019 16:08:21 -0800 (PST)
Date:   Tue, 24 Dec 2019 16:08:21 -0800 (PST)
Message-Id: <20191224.160821.1089187984359085837.davem@davemloft.net>
To:     marcelo.leitner@gmail.com
Cc:     netdev@vger.kernel.org, nhorman@tuxdriver.com,
        linux-sctp@vger.kernel.org, lucien.xin@gmail.com,
        syzbot+9a1bc632e78a1a98488b@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH net] sctp: fix err handling of stream initialization
From:   David Miller <davem@davemloft.net>
In-Reply-To: <d41d8475f8485f571152b3f3716d7f474b5c0e79.1576864893.git.marcelo.leitner@gmail.com>
References: <d41d8475f8485f571152b3f3716d7f474b5c0e79.1576864893.git.marcelo.leitner@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 24 Dec 2019 16:08:21 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 20 Dec 2019 15:03:44 -0300

> The fix on 951c6db954a1 fixed the issued reported there but introduced
> another. When the allocation fails within sctp_stream_init() it is
> okay/necessary to free the genradix. But it is also called when adding
> new streams, from sctp_send_add_streams() and
> sctp_process_strreset_addstrm_in() and in those situations it cannot
> just free the genradix because by then it is a fully operational
> association.
> 
> The fix here then is to only free the genradix in sctp_stream_init()
> and on those other call sites  move on with what it already had and let
> the subsequent error handling to handle it.
> 
> Tested with the reproducers from this report and the previous one,
> with lksctp-tools and sctp-tests.
> 
> Reported-by: syzbot+9a1bc632e78a1a98488b@syzkaller.appspotmail.com
> Fixes: 951c6db954a1 ("sctp: fix memleak on err handling of stream initialization")
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Applied and since I backported the commit mentioned in the Fixes: tag to
-stable, I queued this up for -stable as well.

Thanks.
