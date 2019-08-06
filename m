Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F9D683C79
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 23:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728494AbfHFVf2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 17:35:28 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50198 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728460AbfHFVf0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 17:35:26 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6B831141E37E6;
        Tue,  6 Aug 2019 14:35:26 -0700 (PDT)
Date:   Tue, 06 Aug 2019 14:35:25 -0700 (PDT)
Message-Id: <20190806.143525.1706858782072027944.davem@davemloft.net>
To:     nishkadg.linux@gmail.com
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: dsa: qca8k: Add of_node_put() in
 qca8k_setup_mdio_bus()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190804153019.2317-1-nishkadg.linux@gmail.com>
References: <20190804153019.2317-1-nishkadg.linux@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 06 Aug 2019 14:35:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nishka Dasgupta <nishkadg.linux@gmail.com>
Date: Sun,  4 Aug 2019 21:00:18 +0530

> Each iteration of for_each_available_child_of_node() puts the previous
> node, but in the case of a return from the middle of the loop, there
> is no put, thus causing a memory leak. Hence add an of_node_put() before
> the return.
> Additionally, the local variable ports in the function 
> qca8k_setup_mdio_bus() takes the return value of of_get_child_by_name(),
> which gets a node but does not put it. If the function returns without
> putting ports, it may cause a memory leak. Hence put ports before the
> mid-loop return statement, and also outside the loop after its last usage
> in this function.
> Issues found with Coccinelle.
> 
> Signed-off-by: Nishka Dasgupta <nishkadg.linux@gmail.com>

Appplied.
