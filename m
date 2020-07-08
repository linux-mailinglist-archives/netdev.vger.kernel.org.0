Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 763B0218E00
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 19:13:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730869AbgGHRNX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 13:13:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725953AbgGHRNW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 13:13:22 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5241C061A0B;
        Wed,  8 Jul 2020 10:13:22 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EED9612747A24;
        Wed,  8 Jul 2020 10:13:21 -0700 (PDT)
Date:   Wed, 08 Jul 2020 10:13:21 -0700 (PDT)
Message-Id: <20200708.101321.1049330296069021543.davem@davemloft.net>
To:     xie.he.0141@gmail.com
Cc:     kuba@kernel.org, hkallweit1@gmail.com, snelson@pensando.io,
        mhabets@solarflare.com, mst@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-x25@vger.kernel.org
Subject: Re: [PATCH] drivers/net/wan/x25_asy: Fix to make it work
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200708043754.46554-1-xie.he.0141@gmail.com>
References: <20200708043754.46554-1-xie.he.0141@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 Jul 2020 10:13:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xie He <xie.he.0141@gmail.com>
Date: Tue,  7 Jul 2020 21:37:54 -0700

> This driver is not working because of problems of its receiving code.
> This patch fixes it to make it work.
> 
> When the driver receives an LAPB frame, it should first pass the frame
> to the LAPB module to process. After processing, the LAPB module passes
> the data (the packet) back to the driver, the driver should then add a
> one-byte pseudo header and pass the data to upper layers.
> 
> The changes to the "x25_asy_bump" function and the
> "x25_asy_data_indication" function are to correctly implement this
> procedure.
> 
> Also, the "x25_asy_unesc" function ignores any frame that is shorter
> than 3 bytes. However the shortest frames are 2-byte long. So we need
> to change it to allow 2-byte frames to pass.
> 
> Signed-off-by: Xie He <xie.he.0141@gmail.com>

Something's not right, because I find it hard to believe this has been
so fundamentally broken for such a long period of time.

Maybe the drivers all handle things differently, and whilst your change
might fix some drivers, it will break others.

I'm not applying this until this situation is better understood.
