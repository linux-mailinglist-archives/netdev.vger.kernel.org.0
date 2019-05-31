Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAAB731696
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 23:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727161AbfEaV0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 17:26:16 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50768 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726719AbfEaV0Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 17:26:16 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1B10B1500FF42;
        Fri, 31 May 2019 14:26:16 -0700 (PDT)
Date:   Fri, 31 May 2019 14:26:15 -0700 (PDT)
Message-Id: <20190531.142615.403782868688096350.davem@davemloft.net>
To:     phil@nwl.cc
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [net-next PATCH] net: rtnetlink: Enslave device before
 bringing it up
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190529135120.32241-1-phil@nwl.cc>
References: <20190529135120.32241-1-phil@nwl.cc>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 31 May 2019 14:26:16 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Phil Sutter <phil@nwl.cc>
Date: Wed, 29 May 2019 15:51:20 +0200

> Unlike with bridges, one can't add an interface to a bond and set it up
> at the same time:
> 
> | # ip link set dummy0 down
> | # ip link set dummy0 master bond0 up
> | Error: Device can not be enslaved while up.
> 
> Of all drivers with ndo_add_slave callback, bond and team decline if
> IFF_UP flag is set, vrf cycles the interface (i.e., sets it down and
> immediately up again) and the others just don't care.
> 
> Support the common notion of setting the interface up after enslaving it
> by sorting the operations accordingly.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>

What about other flags like IFF_PROMISCUITY?
