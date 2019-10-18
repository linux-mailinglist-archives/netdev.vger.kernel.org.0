Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD89ADCC13
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 18:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502931AbfJRQ62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 12:58:28 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54864 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502699AbfJRQ61 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 12:58:27 -0400
Received: from localhost (unknown [IPv6:2603:3023:50c:85e1:5314:1b70:2a53:887e])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7817114A8C256;
        Fri, 18 Oct 2019 09:58:26 -0700 (PDT)
Date:   Fri, 18 Oct 2019 12:58:25 -0400 (EDT)
Message-Id: <20191018.125825.843031213764652652.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: avoid NPE if read_page/write_page
 callbacks are not available
From:   David Miller <davem@davemloft.net>
In-Reply-To: <41aba46c-6d75-9a15-9360-1336110dd28e@gmail.com>
References: <41aba46c-6d75-9a15-9360-1336110dd28e@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 18 Oct 2019 09:58:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Wed, 16 Oct 2019 21:53:31 +0200

> Currently there's a bug in the module subsystem [0] preventing load of
> the PHY driver module on certain systems (as one symptom).
> This results in a NPE on such systems for the following reason:
> Instead of the correct PHY driver the genphy driver is loaded that
> doesn't implement the read_page/write_page callbacks. Every call to
> phy_read_paged() et al will result in a NPE therefore.
> 
> In parallel to fixing the root cause we should make sure that this one
> and maybe similar issues in other subsystems don't result in a NPE
> in phylib. So let's check for the callbacks before using them and warn
> once if they are not available.
> 
> [0] https://marc.info/?t=157072642100001&r=1&w=2
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

I read the discussion over a few times and this looks good to me for now,
so applied.

Thanks.
