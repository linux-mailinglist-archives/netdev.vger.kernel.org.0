Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07BFF115811
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 20:59:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbfLFT73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 14:59:29 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:60104 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726325AbfLFT73 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 14:59:29 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DAB6F1511FD71;
        Fri,  6 Dec 2019 11:59:28 -0800 (PST)
Date:   Fri, 06 Dec 2019 11:59:28 -0800 (PST)
Message-Id: <20191206.115928.2012656428284544223.davem@davemloft.net>
To:     vladyslavt@mellanox.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] mqprio: Fix out-of-bounds access in mqprio_dump
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191206134905.2495-1-vladyslavt@mellanox.com>
References: <20191206134905.2495-1-vladyslavt@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 06 Dec 2019 11:59:28 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladyslav Tarasiuk <vladyslavt@mellanox.com>
Date: Fri, 6 Dec 2019 13:51:05 +0000

> When user runs a command like
> tc qdisc add dev eth1 root mqprio
> KASAN stack-out-of-bounds warning is emitted.
> Currently, NLA_ALIGN macro used in mqprio_dump provides too large
> buffer size as argument for nla_put and memcpy down the call stack.
> The flow looks like this:
> 1. nla_put expects exact object size as an argument;
> 2. Later it provides this size to memcpy;
> 3. To calculate correct padding for SKB, nla_put applies NLA_ALIGN
>    macro itself.
> 
> Therefore, NLA_ALIGN should not be applied to the nla_put parameter.
> Otherwise it will lead to out-of-bounds memory access in memcpy.
> 
> Fixes: 4e8b86c06269 ("mqprio: Introduce new hardware offload mode and shaper in mqprio")
> Signed-off-by: Vladyslav Tarasiuk <vladyslavt@mellanox.com>

Applied and queued up for -stable.
