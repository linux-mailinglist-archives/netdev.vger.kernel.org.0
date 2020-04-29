Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 242B31BE712
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 21:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbgD2TPK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 15:15:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726519AbgD2TPK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 15:15:10 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95163C03C1AE;
        Wed, 29 Apr 2020 12:15:10 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B96F31210A3E3;
        Wed, 29 Apr 2020 12:15:09 -0700 (PDT)
Date:   Wed, 29 Apr 2020 12:15:08 -0700 (PDT)
Message-Id: <20200429.121508.82832560496943961.davem@davemloft.net>
To:     yanaijie@huawei.com
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: dsa: mv88e6xxx: remove duplicate assignment of
 struct members
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200429141001.8361-1-yanaijie@huawei.com>
References: <20200429141001.8361-1-yanaijie@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 29 Apr 2020 12:15:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Yan <yanaijie@huawei.com>
Date: Wed, 29 Apr 2020 22:10:01 +0800

> These struct members named 'phylink_validate' was assigned twice:
> 
> static const struct mv88e6xxx_ops mv88e6190_ops = {
> 	......
> 	.phylink_validate = mv88e6390_phylink_validate,
> 	......
> 	.phylink_validate = mv88e6390_phylink_validate,
> };
> 
> static const struct mv88e6xxx_ops mv88e6190x_ops = {
> 	......
> 	.phylink_validate = mv88e6390_phylink_validate,
> 	......
> 	.phylink_validate = mv88e6390x_phylink_validate,
> };
> 
> static const struct mv88e6xxx_ops mv88e6191_ops = {
> 	......
> 	.phylink_validate = mv88e6390_phylink_validate,
> 	......
> 	.phylink_validate = mv88e6390_phylink_validate,
> };
> 
> static const struct mv88e6xxx_ops mv88e6290_ops = {
> 	......
> 	.phylink_validate = mv88e6390_phylink_validate,
> 	......
> 	.phylink_validate = mv88e6390_phylink_validate,
> };
> 
> Remove all the first one and leave the second one which are been used in
> fact. Be aware that for 'mv88e6190x_ops' the assignment functions is
> different while the others are all the same. This fixes the following
> coccicheck warning:
> 
> drivers/net/dsa/mv88e6xxx/chip.c:3911:48-49: phylink_validate: first
> occurrence line 3965, second occurrence line 3967
> drivers/net/dsa/mv88e6xxx/chip.c:3970:49-50: phylink_validate: first
> occurrence line 4024, second occurrence line 4026
> drivers/net/dsa/mv88e6xxx/chip.c:4029:48-49: phylink_validate: first
> occurrence line 4082, second occurrence line 4085
> drivers/net/dsa/mv88e6xxx/chip.c:4184:48-49: phylink_validate: first
> occurrence line 4238, second occurrence line 4242
> 
> Signed-off-by: Jason Yan <yanaijie@huawei.com>

Applied, thanks.
