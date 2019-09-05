Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 494DAAA9C7
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 19:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732679AbfIEROV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 13:14:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:42636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729945AbfIEROV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 13:14:21 -0400
Received: from oasis.local.home (bl11-233-114.dsl.telepac.pt [85.244.233.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DB8820828;
        Thu,  5 Sep 2019 17:14:19 +0000 (UTC)
Date:   Thu, 5 Sep 2019 13:14:13 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Qian Cai <cai@lca.pw>
Cc:     Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Michal Hocko <mhocko@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/skbuff: silence warnings under memory pressure
Message-ID: <20190905131413.0aa4e4f1@oasis.local.home>
In-Reply-To: <1567699393.5576.96.camel@lca.pw>
References: <20190903185305.GA14028@dhcp22.suse.cz>
        <1567546948.5576.68.camel@lca.pw>
        <20190904061501.GB3838@dhcp22.suse.cz>
        <20190904064144.GA5487@jagdpanzerIV>
        <20190904065455.GE3838@dhcp22.suse.cz>
        <20190904071911.GB11968@jagdpanzerIV>
        <20190904074312.GA25744@jagdpanzerIV>
        <1567599263.5576.72.camel@lca.pw>
        <20190904144850.GA8296@tigerII.localdomain>
        <1567629737.5576.87.camel@lca.pw>
        <20190905113208.GA521@jagdpanzerIV>
        <1567699393.5576.96.camel@lca.pw>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 05 Sep 2019 12:03:13 -0400
Qian Cai <cai@lca.pw> wrote:

> > > and could deal with console hardware that involve irq_exit() anyway.  
> > 
> > printk->console_driver->write() does not involve irq.  
> 
> Hmm, from the article,
> 
> https://en.wikipedia.org/wiki/Universal_asynchronous_receiver-transmitter
> 
> "Since transmission of a single or multiple characters may take a long time
> relative to CPU speeds, a UART maintains a flag showing busy status so that the
> host system knows if there is at least one character in the transmit buffer or
> shift register; "ready for next character(s)" may also be signaled with an
> interrupt."

I'm pretty sure all serial consoles do a busy loop on the UART and not
use interrupts to notify when it's available. That would require an
asynchronous implementation of printk() which would be quite complex to
implement.

-- Steve
