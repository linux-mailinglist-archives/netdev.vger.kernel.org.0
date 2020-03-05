Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 337A317AF46
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 21:00:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbgCEUAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 15:00:43 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:56064 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726049AbgCEUAn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 15:00:43 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 20081126B3972;
        Thu,  5 Mar 2020 12:00:43 -0800 (PST)
Date:   Thu, 05 Mar 2020 12:00:42 -0800 (PST)
Message-Id: <20200305.120042.583751283879909582.davem@davemloft.net>
To:     ap420073@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] hsr: fix refcnt leak of hsr slave interface
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200305000254.8217-1-ap420073@gmail.com>
References: <20200305000254.8217-1-ap420073@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 05 Mar 2020 12:00:43 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>
Date: Thu,  5 Mar 2020 00:02:54 +0000

> In the commit e0a4b99773d3 ("hsr: use upper/lower device infrastructure"),
> dev_get() was removed but dev_put() in the error path wasn't removed.
> So, if creating hsr interface command is failed, the reference counter leak
> of lower interface would occur.
> 
> Test commands:
>     ip link add dummy0 type dummy
>     ip link add ipvlan0 link dummy0 type ipvlan mode l2
>     ip link add ipvlan1 link dummy0 type ipvlan mode l2
>     ip link add hsr0 type hsr slave1 ipvlan0 slave2 ipvlan1
>     ip link del ipvlan0
> 
> Result:
> [  633.271992][ T1280] unregister_netdevice: waiting for ipvlan0 to become free. Usage count = -1
> 
> Fixes: e0a4b99773d3 ("hsr: use upper/lower device infrastructure")
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

Applied.
