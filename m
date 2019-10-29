Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8DD6E8CE8
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 17:41:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390517AbfJ2QlV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 12:41:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:48320 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390425AbfJ2QlU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Oct 2019 12:41:20 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 84860B57D;
        Tue, 29 Oct 2019 16:41:18 +0000 (UTC)
Date:   Tue, 29 Oct 2019 17:41:16 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     Stefan Wahren <wahrenst@gmx.net>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Woojung Huh <woojung.huh@microchip.com>,
        Marc Zyngier <maz@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Jisheng Zhang <Jisheng.Zhang@synaptics.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH] net: usb: lan78xx: Disable interrupts before calling
 generic_handle_irq()
Message-ID: <20191029164116.44px7mtwrauquurz@beryllium.lan>
References: <20191025080413.22665-1-dwagner@suse.de>
 <46b35c32-4383-c630-3c52-b59bf7908c36@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46b35c32-4383-c630-3c52-b59bf7908c36@gmx.net>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stefan,

On Sun, Oct 27, 2019 at 01:14:41PM +0100, Stefan Wahren wrote:
> did you ever see this pseudo lan78xx-irqs fire? I examined
> /proc/interrupts on RPi 3B+ and always saw a 0.

# cat /proc/interrupts 
           CPU0       CPU1       CPU2       CPU3       
  2:         15         10         20         14  ARMCTRL-level   1 Edge      3f00b880.mailbox
 41:     127709     127690     127596     127783  ARMCTRL-level  41 Edge      3f980000.usb, dwc2_hsotg:usb1
 61:        219        208        183        192  ARMCTRL-level  61 Edge      ttyS1
 65:       1285       1340       2112       1483  ARMCTRL-level  88 Edge      mmc0
 71:         11         15         13         13  ARMCTRL-level  94 Edge      mmc1
147:       2823       2995       3648       3615  bcm2836-timer   1 Edge      arch_timer
148:          0          0          0          0  bcm2836-timer   3 Edge      kvm guest timer
150:          0          1          2          0  lan78xx-irqs  17 Edge      usb-001:004:01
IPI0:     11102      11331      12204      11011       Rescheduling interrupts
IPI1:        34        537        547        523       Function call interrupts
IPI2:         0          0          0          0       CPU stop interrupts
IPI3:         0          0          0          0       CPU stop (for crash dump) interrupts
IPI4:         0          0          0          0       Timer broadcast interrupts
IPI5:         0          0          0          0       IRQ work interrupts
IPI6:         0          0          0          0       CPU wake-up interrupts


Yes, this seems to work now fine with the current version. 

Thanks,
Daniel
