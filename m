Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32FDB199C33
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 18:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730770AbgCaQyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 12:54:18 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52872 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730413AbgCaQyS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 12:54:18 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D4DE615D0B61A;
        Tue, 31 Mar 2020 09:54:17 -0700 (PDT)
Date:   Tue, 31 Mar 2020 09:54:06 -0700 (PDT)
Message-Id: <20200331.095406.351446411247167894.davem@davemloft.net>
To:     liuhangbin@gmail.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH net-next] neigh: support smaller retrans_time settting
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200331033356.29956-1-liuhangbin@gmail.com>
References: <20200331033356.29956-1-liuhangbin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 31 Mar 2020 09:54:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>
Date: Tue, 31 Mar 2020 11:33:56 +0800

> Currently, we limited the retrans_time to be greater than HZ/2. For
> example, if the HZ = 1000, setting retrans_time less than 500ms will
> not work. This makes the user unable to achieve a more accurate control
> for bonding arp fast failover.
> 
> But remove the sanity check would make the retransmission immediately
> if user set retrans_time to 0 by wrong config. So I hard code the sanity
> check to 10, which is 10ms if HZ is 1000 and 100ms if HZ is 100.
> This number should be enough for user to get more accurate neigh
> control.
> 
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

It only makes sense to make the safety limit be constant (time wise),
and therefore relative to HZ.
