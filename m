Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8641267D13
	for <lists+netdev@lfdr.de>; Sun, 13 Sep 2020 03:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725935AbgIMBXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Sep 2020 21:23:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725889AbgIMBXi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Sep 2020 21:23:38 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78DA9C061574;
        Sat, 12 Sep 2020 18:23:38 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6F162128FCF29;
        Sat, 12 Sep 2020 18:06:50 -0700 (PDT)
Date:   Sat, 12 Sep 2020 18:23:36 -0700 (PDT)
Message-Id: <20200912.182336.585362420502143240.davem@davemloft.net>
To:     yepeilin.cs@gmail.com
Cc:     jmaloy@redhat.com, ying.xue@windriver.com, kuba@kernel.org,
        hdanton@sina.com, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzkaller-bugs@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: [Linux-kernel-mentees] [PATCH net] tipc: Fix memory leak in
 tipc_group_create_member()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200912102230.1529402-1-yepeilin.cs@gmail.com>
References: <000000000000879057058f193fb5@google.com>
        <20200912102230.1529402-1-yepeilin.cs@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sat, 12 Sep 2020 18:06:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peilin Ye <yepeilin.cs@gmail.com>
Date: Sat, 12 Sep 2020 06:22:30 -0400

> @@ -291,10 +291,11 @@ static void tipc_group_add_to_tree(struct tipc_group *grp,
>  		else if (key > nkey)
>  			n = &(*n)->rb_right;
>  		else
> -			return;
> +			return -1;

Use a real error code like "-EEXIST", thank you.
