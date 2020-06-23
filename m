Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25E88206729
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 00:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387694AbgFWW02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 18:26:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387502AbgFWW01 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 18:26:27 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87442C061573;
        Tue, 23 Jun 2020 15:26:27 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 079161294DBCA;
        Tue, 23 Jun 2020 15:26:26 -0700 (PDT)
Date:   Tue, 23 Jun 2020 15:26:26 -0700 (PDT)
Message-Id: <20200623.152626.2206118203643133195.davem@davemloft.net>
To:     likaige@loongson.cn
Cc:     benve@cisco.com, _govind@gmx.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lixuefeng@loongson.cn,
        yangtiezhu@loongson.cn
Subject: Re: [PATCH RESEND] net/cisco: Fix a sleep-in-atomic-context bug in
 enic_init_affinity_hint()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200623.143311.995885759487352025.davem@davemloft.net>
References: <1592899989-22049-1-git-send-email-likaige@loongson.cn>
        <20200623.143311.995885759487352025.davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 23 Jun 2020 15:26:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Tue, 23 Jun 2020 14:33:11 -0700 (PDT)

> Calling a NIC driver open function from a context holding a spinlock
> is very much the real problem, so many operations have to sleep and
> in face that ->ndo_open() method is defined as being allowed to sleep
> and that's why the core networking never invokes it with spinlocks
                                                      ^^^^

I mean "without" of course. :-)

> held.
