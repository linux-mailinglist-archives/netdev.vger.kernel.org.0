Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E15D842ADAF
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 22:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234419AbhJLUTQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 16:19:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:52146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231902AbhJLUTN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 16:19:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68C69600CC;
        Tue, 12 Oct 2021 20:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634069830;
        bh=D7EaG7LVbwEfZ5G5NS2n7FiE+vzvIG3NNkOd6RhJTeY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Rdoxraar9dYXpzP1EqxKJWv1xASLKfo5dvnJKPH/LGLWFdiE9bzpwCtYZURqaQGLZ
         tT5yFbmnUkIws4SHp04TMnHJf+KbGAp7tNEQnQiwLUlHrs/2dqFme9RmqegUN810uT
         qe7bcdMEBNYSuzK+9K2hfAOQ1DhowSP3IiSLUdf+PR0hLvV/4pF+k4ky1m9HmPlqcq
         WFoKcJX+BctuE7E9BdoA2NPXCZdHGPwLDLZLy6FNapPkazXYLOfKq/ZlytUvQwQTSS
         eSJOpQjQYSJ05iMHA0sLyJMY9YacXIaSc3diCC1Qy1mLKYUkuGhIRZu1BaG1JOHkpg
         nH2u/62vAFcKw==
Date:   Tue, 12 Oct 2021 13:17:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Biju Das <biju.das.jz@bp.renesas.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org>, Chris Paterson 
        <Chris.Paterson2@renesas.com>, Biju Das <biju.das@bp.renesas.com" 
        <linux-renesas-soc@vger.kernel.org>
Subject: Re: [PATCH net-next v3 00/14] Add functional support for Gigabit
 Ethernet driver
Message-ID: <20211012131709.0bc11e3e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <OS0PR01MB5922B6FD6195B9DC0F2C8EA986B69@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20211012163613.30030-1-biju.das.jz@bp.renesas.com>
        <20211012111920.1f3886b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <OS0PR01MB59228B47A02008629DF1782A86B69@OS0PR01MB5922.jpnprd01.prod.outlook.com>
        <20211012114125.0a9d71ae@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <OS0PR01MB5922B6FD6195B9DC0F2C8EA986B69@OS0PR01MB5922.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Oct 2021 18:53:50 +0000 Biju Das wrote:
> > > Yes, you are correct. Sergey, suggested use R-Car RX-HW checksum with
> > > RCSC/RCPT and But the TOE gives either 0x0 or 0xffff as csum output
> > > and feeding this value to skb->csum lead to kernel crash.  
> > 
> > That's quite concerning. Do you have any of the
> > 
> > /proc/sys/kernel/panic_on_io_nmi
> > /proc/sys/kernel/panic_on_oops
> > /proc/sys/kernel/panic_on_rcu_stall
> > /proc/sys/kernel/panic_on_unrecovered_nmi
> > /proc/sys/kernel/panic_on_warn
> > 
> > knobs set? I'm guessing we hit do_netdev_rx_csum_fault() when the checksum
> > is incorrect, but I'm surprised that causes a panic.
> 
> I tested this last week, if I remember correctly It was not panic,
> rather do_netdev_rx_csum_fault. I will recheck and will send you the
> stack trace next time. 

Ah, when you say crash you mean a stack trace appears. The machine does
not crash? That's fine, we don't need to see the trace.
