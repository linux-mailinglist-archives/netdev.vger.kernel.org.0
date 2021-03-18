Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 399B434013A
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 09:52:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbhCRIwN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 04:52:13 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:56192 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbhCRIvv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 04:51:51 -0400
Date:   Thu, 18 Mar 2021 09:51:48 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1616057509;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WbKRW0ALtGqtp8JBnGSzXq4UxYgK5mjnvsywKEIjCPg=;
        b=1qoC7vCLJpH/OCMdMSr8ef8YNh5zBOLuU/Gl6mpJYn3KmJyZ8Ukms9GHyeeS6wBgWavycj
        2SysWbHbADnjbDLUI1ceDxLYV/UVt917SBhd9ppRH5fsxJjNW7RFRRF2csWZbCCEbY7O/Z
        Jy0PwXq2KQVHuzwFWUBbxw7UWunIrtZ+b5gh2lRk5jTG2fWIZQU8XrYGseU46LC8jRu2Lz
        rVYAzwDXj5Ry3ybjthj43q+RXxKlIbd32nARou+D/nWGuI7ZL2NxNYt/2/BsU35FK1imXy
        44YVF97puGwZOn/Rbh2KwYjpgr8ROePmySc2G/w8JmFCf3k8cnllDLR7O49oxQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1616057509;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WbKRW0ALtGqtp8JBnGSzXq4UxYgK5mjnvsywKEIjCPg=;
        b=e8DFLvJdg1874kkgvTmumjj0rpxjLnaS1/24bK2yjCSv0035Q8A2LXFI49GziEGETbk1kO
        peVAS7gU4B1aieBw==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Johan Hovold <johan@kernel.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-serial@vger.kernel.org
Subject: Re: [patch 1/1] genirq: Disable interrupts for force threaded
 handlers
Message-ID: <20210318085148.3gnvlvzukqsmo2p2@linutronix.de>
References: <20210317143859.513307808@linutronix.de>
 <20210317144806.y4dogv6n2s62fpnw@linutronix.de>
 <YFItC/biHWUCkKt0@hovoldconsulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YFItC/biHWUCkKt0@hovoldconsulting.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-03-17 17:23:39 [+0100], Johan Hovold wrote:
> > > thread(irq_A)
> > >   irq_handler(A)
> > >     spin_lock(&foo->lock);
> > > 
> > > interrupt(irq_B)
> > >   irq_handler(B)
> > >     spin_lock(&foo->lock);
> > 
> > It will not because both threads will wake_up(thread).
> 
> Note that the above says "interrupt(irq_B)" suggesting it's a
> non-threaded interrupt unlike irq_A.

I missed that bit, thanks.

Sebastian
