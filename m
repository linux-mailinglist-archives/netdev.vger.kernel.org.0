Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9ECC8114848
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 21:44:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730005AbfLEUom (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 15:44:42 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47322 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729154AbfLEUom (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 15:44:42 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 89DEA1504816D;
        Thu,  5 Dec 2019 12:44:41 -0800 (PST)
Date:   Thu, 05 Dec 2019 12:44:40 -0800 (PST)
Message-Id: <20191205.124440.809438263678335744.davem@davemloft.net>
To:     ap420073@gmail.com
Cc:     jon.maloy@ericsson.com, ying.xue@windriver.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] tipc: fix ordering of tipc module init and exit
 routine
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191205163704.11800-1-ap420073@gmail.com>
References: <20191205163704.11800-1-ap420073@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 05 Dec 2019 12:44:41 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>
Date: Thu,  5 Dec 2019 16:37:04 +0000

> In order to set/get/dump, the tipc uses the generic netlink
> infrastructure. So, when tipc module is inserted, init function
> calls genl_register_family().
> After genl_register_family(), set/get/dump commands are immediately
> allowed and these callbacks internally use the net_generic.
> net_generic is allocated by register_pernet_device() but this
> is called after genl_register_family() in the __init function.
> So, these callbacks would use un-initialized net_generic.
...

Jon and other TIPC folks, please review.
