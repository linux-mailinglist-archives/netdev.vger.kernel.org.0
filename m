Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A78E41031BB
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 03:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727472AbfKTCou (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 21:44:50 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48850 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727082AbfKTCou (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 21:44:50 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9622A146CFEC3;
        Tue, 19 Nov 2019 18:44:49 -0800 (PST)
Date:   Tue, 19 Nov 2019 18:44:46 -0800 (PST)
Message-Id: <20191119.184446.1007728375771623470.davem@davemloft.net>
To:     tbogendoerfer@suse.de
Cc:     corbet@lwn.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: ipconfig: Make device wait timeout
 configurable
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191119120647.31547-1-tbogendoerfer@suse.de>
References: <20191119120647.31547-1-tbogendoerfer@suse.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 19 Nov 2019 18:44:49 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Bogendoerfer <tbogendoerfer@suse.de>
Date: Tue, 19 Nov 2019 13:06:46 +0100

> If network device drivers are using deferred probing it's possible
> that waiting for devices to show up in ipconfig is already over,
> when the device eventually shows up. With the new netdev_max_wait
> kernel cmdline pataremter it's now possible to extend this time.
> 
> Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>

This is one of those "user's shouldn't have to figure this crap out"
situations.

To me, a knob is always a step backwards, and makes Linux harder to
use.

The irony in all of this, is that the kernel knows when this stuff is
happening.  So the ipconfig code should be taught that drivers are
still plugging themselves together and probing, instead of setting
some arbitrary timeout to wait for these things to occur.
