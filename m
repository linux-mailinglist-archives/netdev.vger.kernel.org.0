Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 300C31BAF37
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 22:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgD0UUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 16:20:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726233AbgD0UUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 16:20:11 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC5DBC0A3BF5
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 13:20:10 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5792915D6B9EA;
        Mon, 27 Apr 2020 13:20:10 -0700 (PDT)
Date:   Mon, 27 Apr 2020 13:20:09 -0700 (PDT)
Message-Id: <20200427.132009.1387378104495053173.davem@davemloft.net>
To:     irusskikh@marvell.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, mstarovoitov@marvell.com,
        dbogdanov@marvell.com
Subject: Re: [EXT] Re: [PATCH net-next 08/17] net: atlantic: A2
 driver-firmware interface
From:   David Miller <davem@davemloft.net>
In-Reply-To: <be1461d3-f87e-0bfa-0b37-6eef4a2519e6@marvell.com>
References: <e34bcab1-303e-a4bd-862c-125f254e93d3@marvell.com>
        <20200427120301.693525a5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <be1461d3-f87e-0bfa-0b37-6eef4a2519e6@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Apr 2020 13:20:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Igor Russkikh <irusskikh@marvell.com>
Date: Mon, 27 Apr 2020 23:04:24 +0300

> This means I have to dig each and every structure in this header and
> understand whether it may suffer from implicit alignment/holes or not.
> 
> Not mentioning the fact that these alignment rules are different on other
> compilers, or on say 32-bit archs.
> 
> I also see a lot of code through the kernel using pack(1) for the exact same
> reason - declare hw sensitive structures and eliminate any unexpected holes.

Your resistence to this feedback is becomming irritating.

Just because something is used elsewhere doesn't mean you are open to
do the same, there is a lot of code where issues like this have not
been caught through reivew and the code still ended up in the tree.

Using packed arbitrarily is being lazy and will result in suboptimal
code generation on several platforms.

Fixed sized types have well defined padding on _all_ cpus and targets,
so if you use them properly and pad up your structures, there is
absolutely _nothing_ to worry about.

When I was very active writing hardware drivers with many HW defined
structures and whatnot, I never once considered packed.  It never even
crossed my mind, because I simply defined the data structure properly
with well defined fixed sized types and padded them out as necessary.

So please stop pushing back on this feedback and get rid of the packed
attribute.

Thank you.
