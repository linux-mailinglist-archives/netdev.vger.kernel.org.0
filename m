Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BAEA1BAC56
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 20:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbgD0SU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 14:20:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726228AbgD0SU5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 14:20:57 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4524AC0610D5;
        Mon, 27 Apr 2020 11:20:57 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 14F2C15D54880;
        Mon, 27 Apr 2020 11:20:55 -0700 (PDT)
Date:   Mon, 27 Apr 2020 11:20:54 -0700 (PDT)
Message-Id: <20200427.112054.486660514927430577.davem@davemloft.net>
To:     xiyuyang19@fudan.edu.cn
Cc:     andrew.hendry@gmail.com, kuba@kernel.org, tanxin.ctf@gmail.com,
        gregkh@linuxfoundation.org, allison@lohutok.net,
        tglx@linutronix.de, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yuanxzhang@fudan.edu.cn, kjlu@umn.edu
Subject: Re: [PATCH v2] net/x25: Fix x25_neigh refcnt leak when x25
 disconnect
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1587819994-40137-1-git-send-email-xiyuyang19@fudan.edu.cn>
References: <1587819994-40137-1-git-send-email-xiyuyang19@fudan.edu.cn>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Apr 2020 11:20:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Date: Sat, 25 Apr 2020 21:06:25 +0800

> x25_connect() invokes x25_get_neigh(), which returns a reference of the
> specified x25_neigh object to "x25->neighbour" with increased refcnt.
> 
> When x25 connect success and returns, the reference still be hold by
> "x25->neighbour", so the refcount should be decreased in
> x25_disconnect() to keep refcount balanced.
> 
> The reference counting issue happens in x25_disconnect(), which forgets
> to decrease the refcnt increased by x25_get_neigh() in x25_connect(),
> causing a refcnt leak.
> 
> Fix this issue by calling x25_neigh_put() before x25_disconnect()
> returns.
> 
> Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
> Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>

Applied.
