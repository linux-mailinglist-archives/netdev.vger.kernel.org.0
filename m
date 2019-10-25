Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79624E44A0
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 09:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407101AbfJYHgt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 03:36:49 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:35638 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406055AbfJYHgt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 03:36:49 -0400
Received: from bigeasy by Galois.linutronix.de with local (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1iNu9K-0001MM-Tr; Fri, 25 Oct 2019 09:36:43 +0200
Date:   Fri, 25 Oct 2019 09:36:42 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     David Miller <davem@davemloft.net>
Cc:     dwagner@suse.de, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        woojung.huh@microchip.com, maz@kernel.org, andrew@lunn.ch,
        wahrenst@gmx.net, Jisheng.Zhang@synaptics.com, tglx@linutronix.de
Subject: Re: [PATCH] net: usb: lan78xx: Use phy_mac_interrupt() for interrupt
 handling
Message-ID: <20191025073642.3ov2lwo2sr4nrdzn@linutronix.de>
References: <20191018082817.111480-1-dwagner@suse.de>
 <20191024.145716.1208414850964996816.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191024.145716.1208414850964996816.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-10-24 14:57:16 [-0700], David Miller wrote:
> From: Daniel Wagner <dwagner@suse.de>
> Date: Fri, 18 Oct 2019 10:28:17 +0200
> 
> > handle_simple_irq() expect interrupts to be disabled. The USB
> > framework is using threaded interrupts, which implies that interrupts
> > are re-enabled as soon as it has run.
>  ...
> 
> Where are we with this patch?  I'm tossing it.
> 
> It seems Sebastian made a suggestion, someone else said his suggestion
> should be tried, then everything died.
> 
> Please follow up and post when something is ready.

My suggestion with the nested-handler was nonsense. The suggestion with
the local_irq_disable() before invoking generic_handle_irq() did avoid
the warning but the NFS-root was not stable (and Daniel reported a lot
of USB interrupts coming which indicates that the interrupt-handler is
not acknowledging the interrupt properly).

It works by reverting the IRQ-domain code as this patch does. "Works" as
in "no warnings" and "NFS-root looks stable".

You have two ACKs on that patch. I could ask Daniel to repost the patch
with additional informations.
My last information from Daniel was that the rpi tree works and I'm not
sure if he is looking for the missing ingredient or preferring the
removal of the non-working code.

Sebastian
